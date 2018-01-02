/**
 * 对公众平台发送给公众账号的消息加解密示例代码.
 * 
 * @copyright Copyright (c) 1998-2014 Tencent Inc.
 */

// ------------------------------------------------------------------------

/**
 * 针对org.apache.commons.codec.binary.Base64，
 * 需要导入架包commons-codec-1.9（或commons-codec-1.8等其他版本）
 * 官方下载地址：http://commons.apache.org/proper/commons-codec/download_codec.cgi
 */
package com.qq.weixin.mp.aes;

import java.nio.charset.Charset;
import java.util.Arrays;
import java.util.Random;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.codec.binary.Base64;

import com.qianying.util.DateTimeUtils;
import com.qianying.util.LoggerUtils;

/**
 * 提供接收和推送给公众平台消息的加解密接口(UTF8编码的字符串).
 * <ol>
 * 	<li>第三方回复加密消息给公众平台</li>
 * 	<li>第三方收到公众平台发送的消息，验证消息的安全性，并对消息进行解密。</li>
 * </ol>
 * 说明：异常java.security.InvalidKeyException:illegal Key Size的解决方案
 * <ol>
 * 	<li>在官方网站下载JCE无限制权限策略文件（JDK7的下载地址：
 *      http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html</li>
 * 	<li>下载后解压，可以看到local_policy.jar和US_export_policy.jar以及readme.txt</li>
 * 	<li>如果安装了JRE，将两个jar文件放到%JRE_HOME%\lib\security目录下覆盖原来的文件</li>
 * 	<li>如果安装了JDK，将两个jar文件放到%JDK_HOME%\jre\lib\security目录下覆盖原来文件</li>
 * </ol>
 */
public class WXBizMsgCrypt {
	static Charset CHARSET = Charset.forName("utf-8");
	Base64 base64 = new Base64();
	byte[] aesKey;
	String token;
	String corpId;

	/**
	 * 构造函数
	 * @param token 公众平台上，开发者设置的token
	 * @param encodingAesKey 公众平台上，开发者设置的EncodingAESKey
	 * @param corpId 企业的corpid
	 * 
	 * @throws AesException 执行失败，请查看该异常的错误码和具体的错误信息
	 */
	public WXBizMsgCrypt(String token, String encodingAesKey, String corpId) throws AesException {
		if (encodingAesKey.length() != 43) {
			throw new AesException(AesException.IllegalAesKey);
		}

		this.token = token;
		this.corpId = corpId;
		aesKey = Base64.decodeBase64(encodingAesKey + "=");
	}

	// 生成4个字节的网络字节序
	byte[] getNetworkBytesOrder(int sourceNumber) {
		byte[] orderBytes = new byte[4];
		orderBytes[3] = (byte) (sourceNumber & 0xFF);
		orderBytes[2] = (byte) (sourceNumber >> 8 & 0xFF);
		orderBytes[1] = (byte) (sourceNumber >> 16 & 0xFF);
		orderBytes[0] = (byte) (sourceNumber >> 24 & 0xFF);
		return orderBytes;
	}

	// 还原4个字节的网络字节序
	int recoverNetworkBytesOrder(byte[] orderBytes) {
		int sourceNumber = 0;
		for (int i = 0; i < 4; i++) {
			sourceNumber <<= 8;
			sourceNumber |= orderBytes[i] & 0xff;
		}
		return sourceNumber;
	}
	static // 还原4个字节的网络字节序
	int recoverNetworkBytesOrder2(byte[] orderBytes) {
		int sourceNumber = 0;
		for (int i = 0; i < 4; i++) {
			sourceNumber <<= 8;
			sourceNumber |= orderBytes[i] & 0xff;
		}
		return sourceNumber;
	}

	// 随机生成16位字符串
	String getRandomStr() {
		String base = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
		Random random = new Random();
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < 16; i++) {
			int number = random.nextInt(base.length());
			sb.append(base.charAt(number));
		}
		return sb.toString();
	}

	/**
	 * 对明文进行加密.
	 * 
	 * @param text 需要加密的明文
	 * @return 加密后base64编码的字符串
	 * @throws AesException aes加密失败
	 */
	String encrypt(String randomStr, String text) throws AesException {
		ByteGroup byteCollector = new ByteGroup();
		byte[] randomStrBytes = randomStr.getBytes(CHARSET);
		byte[] textBytes = text.getBytes(CHARSET);
		byte[] networkBytesOrder = getNetworkBytesOrder(textBytes.length);
		byte[] corpidBytes = corpId.getBytes(CHARSET);

		// randomStr + networkBytesOrder + text + corpid
		byteCollector.addBytes(randomStrBytes);
		byteCollector.addBytes(networkBytesOrder);
		byteCollector.addBytes(textBytes);
		byteCollector.addBytes(corpidBytes);

		// ... + pad: 使用自定义的填充方式对明文进行补位填充
		byte[] padBytes = PKCS7Encoder.encode(byteCollector.size());
		byteCollector.addBytes(padBytes);

		// 获得最终的字节流, 未加密
		byte[] unencrypted = byteCollector.toBytes();

		try {
			// 设置加密模式为AES的CBC模式
			Cipher cipher = Cipher.getInstance("AES/CBC/NoPadding");
			SecretKeySpec keySpec = new SecretKeySpec(aesKey, "AES");
			IvParameterSpec iv = new IvParameterSpec(aesKey, 0, 16);
			cipher.init(Cipher.ENCRYPT_MODE, keySpec, iv);

			// 加密
			byte[] encrypted = cipher.doFinal(unencrypted);

			// 使用BASE64对加密后的字符串进行编码
			String base64Encrypted = base64.encodeToString(encrypted);

			return base64Encrypted;
		} catch (Exception e) {
			e.printStackTrace();
			throw new AesException(AesException.EncryptAESError);
		}
	}

	/**
	 * 对密文进行解密.
	 * 
	 * @param text 需要解密的密文
	 * @return 解密得到的明文
	 * @throws AesException aes解密失败
	 */
    String decrypt(String text) throws AesException {
		byte[] original;
		try {
			// 设置解密模式为AES的CBC模式
			Cipher cipher = Cipher.getInstance("AES/CBC/NoPadding");
			SecretKeySpec key_spec = new SecretKeySpec(aesKey, "AES");
			IvParameterSpec iv = new IvParameterSpec(Arrays.copyOfRange(aesKey, 0, 16));
			cipher.init(Cipher.DECRYPT_MODE, key_spec, iv);
			// 使用BASE64对密文进行解码
			byte[] encrypted = Base64.decodeBase64(text);
			// 解密
			original = cipher.doFinal(encrypted);
		} catch (Exception e) {
			e.printStackTrace();
			throw new AesException(AesException.DecryptAESError);
		}
		String xmlContent, from_corpid;
		try {
			// 去除补位字符
			byte[] bytes = PKCS7Encoder.decode(original);
			// 分离16位随机字符串,网络字节序和corpId
			byte[] networkOrder = Arrays.copyOfRange(bytes, 16, 20);
			int xmlLength = recoverNetworkBytesOrder(networkOrder)+20;
			if (xmlLength>bytes.length) {
				xmlLength=bytes.length-18;
			}
			xmlContent = new String(Arrays.copyOfRange(bytes, 20, xmlLength), CHARSET);
			from_corpid = new String(Arrays.copyOfRange(bytes,xmlLength, bytes.length),
					CHARSET);
		} catch (Exception e) {
//			e.printStackTrace();
			throw new AesException(AesException.IllegalBuffer);
		}
		// corpid不相同的情况
		if (!from_corpid.equals(corpId)) {
			throw new AesException(AesException.ValidateCorpidError);
		}
		return xmlContent;

	}
//public static void main(String[] args) throws Exception {
//	byte[] bytes=new byte[]{-96,22,-13,7,40,36,-117,-15,3,71,-22,-109,-88,102, -86, -49, 11, 45, -79, -101, 127, -68, -9, 68, -39, -4, -53, 62, -95, 74, 20, -127, 16,111, -51, -36, 58, -83, -20, 51, -124, 8, 102, -11, 34, -55, -91, -74, 17, -24,81, -94, -111, -95, -7, -19, 72, 98, -7, 89, -14, 71, 107, -44, 12, 120, -37, 37, -109, 57, -79, 40, -36, 35, -3, 84, -18, 4, 43, 33, -50, -64, -100, -24, 86, 68, -3, 46, 53, -17, -79, 57, 1, 106, -111, -115, -68, -118, -57, -85, -15, -9, 7, -76, -21, 4, 22, 109, 94, 119, 16, -109, -69, 20, 127, 105, 66, 110, 73, 35, -104, -109, 63, -97, -100, 13, -29, 12, 52, 27, 78, -66, -4, -18, -22, 107, -79,-89, 51, -62, 69, 71, 101, -60, 56, -118, 117, 19, 86, -76, -114, -90, 39, 26, -5, 0, -81, -26, 109, -15, -13, -34, -35, 53, 50, -64, 37, -90, -91, 106, 39, -90, 23, 36, 124, 127, 9, 86, 108, -9, 20, -106, -106, -91, 76, -105, -118, 6, -118, -2, -54, -112, 96, -100, 53, -80, 78, -18, 18, 75, 83, -34, -2, 81, -5, -128,125, 71, 69, 18, -123, 97, -87, -43, -68, -99, 76, -119, -107, -97, 50, 10, -99, -71, 6, -122, -83, 70, 5, 75, 23, 120, 69, 65, 35, -84, 41, 6, 29, 63, 112, 36, 126, 27, 37, 110, -51, -85, 52, 40, -79, 94, -33, -101, -8, 103, 16, 10, -63, -124, -115, -104, -93, -83, -87, 104, -84, -92, -2, 57, 33, -63, -88, -13, 118, -6, 17, -22, 12, 16, -39, 9, -54, -81, 114, -8, 100, 6, -111, 62, 43, 70, 51, 20, -81, -100, -4, 113, -100, -68, 9, -20, -14, -105, 70, 127, 37, -23, -22, -85, -101, -127, -3, -81, 24, 34, -19, -48, 99, 61, 40, -27, 123, -20, -22, -125, 18,-98, -34, 82, 8, -113, -3, 69, 61, -29, 118, -83, -96, -64, 5, 20, -14, -11, 122, 43, -15, -109, -48, -16, -54, -5, 26, -58, -40, 86, -27, -66, 16, 63, 21, -35,-7, 55, 64, 64, 78, 10, 68, -22, 76, -122, -34, -89, -29, 126, -22, -60, -67, -76, -26, -91, -96, 81, -39, 77, 24, 102, -17, -103, 42, 125,-24,-102,-76,118,45,-28,-84,-68,87,60,-52,-83,-40,97,-117,-91,-38,-43,-76,-37};
//	byte[] networkOrder = Arrays.copyOfRange(bytes, 16, 20);
//	int xmlLength = recoverNetworkBytesOrder2(networkOrder);
//	String xmlContent, from_corpid;
//	if (xmlLength>bytes.length) {
//		xmlLength=bytes.length;
//	}
//	xmlContent = new String(Arrays.copyOfRange(bytes, 20, xmlLength-18), CHARSET);
//	from_corpid = new String(Arrays.copyOfRange(bytes,xmlLength-18, bytes.length),CHARSET);
//	System.out.println(xmlContent);
//	System.out.println("wx582baadfc7c9859b");
//	System.out.println(Arrays.copyOfRange(bytes,xmlLength-18, bytes.length).length);
//}
	/**
	 * 将公众平台回复用户的消息加密打包.
	 * <ol>
	 * 	<li>对要发送的消息进行AES-CBC加密</li>
	 * 	<li>生成安全签名</li>
	 * 	<li>将消息密文和安全签名打包成xml格式</li>
	 * </ol>
	 * 
	 * @param replyMsg 公众平台待回复用户的消息，xml格式的字符串
	 * @param timeStamp 时间戳，可以自己生成，也可以用URL参数的timestamp
	 * @param nonce 随机串，可以自己生成，也可以用URL参数的nonce
	 * 
	 * @return 加密后的可以直接回复用户的密文，包括msg_signature, timestamp, nonce, encrypt的xml格式的字符串
	 * @throws AesException 执行失败，请查看该异常的错误码和具体的错误信息
	 */
	public String EncryptMsg(String replyMsg, String timeStamp, String nonce) throws AesException {
		// 加密
		String encrypt = encrypt(getRandomStr(), replyMsg);

		// 生成安全签名
		if (timeStamp == "") {
			timeStamp = Long.toString(System.currentTimeMillis());
		}

		String signature = SHA1.getSHA1(token, timeStamp, nonce, encrypt);

		// System.out.println("发送给平台的签名是: " + signature[1].toString());
		// 生成发送的xml
		String result = XMLParse.generate(encrypt, signature, timeStamp, nonce);
		return result;
	}

	/**
	 * 检验消息的真实性，并且获取解密后的明文.
	 * <ol>
	 * 	<li>利用收到的密文生成安全签名，进行签名验证</li>
	 * 	<li>若验证通过，则提取xml中的加密消息</li>
	 * 	<li>对消息进行解密</li>
	 * </ol>
	 * 
	 * @param msgSignature 签名串，对应URL参数的msg_signature
	 * @param timeStamp 时间戳，对应URL参数的timestamp
	 * @param nonce 随机串，对应URL参数的nonce
	 * @param postData 密文，对应POST请求的数据
	 * 
	 * @return 解密后的原文
	 * @throws AesException 执行失败，请查看该异常的错误码和具体的错误信息
	 */
	public String DecryptMsg(String msgSignature, String timeStamp, String nonce, String postData)
			throws AesException {

		// 密钥，公众账号的app secret
		// 提取密文
		LoggerUtils.info(postData);
		Object[] encrypt=null;
		try {
			encrypt = XMLParse.extract(postData);
		} catch (Exception e) {
			LoggerUtils.error("参数:"+msgSignature+"|"+timeStamp+"|"+nonce);
			LoggerUtils.error("时间:"+DateTimeUtils.dateTimeToStr());
			return "";
		}
		// 验证安全签名
		String signature = SHA1.getSHA1(token, timeStamp, nonce, encrypt[1].toString());

		// 和URL中的签名比较是否相等
		// System.out.println("第三方收到URL中的签名：" + msg_sign);
		// System.out.println("第三方校验签名：" + signature);
		if (!signature.equals(msgSignature)) {
			throw new AesException(AesException.ValidateSignatureError);
		}

		// 解密
		String result = decrypt(encrypt[1].toString());
		return result;
	}
	/**
	 * 验证URL
	 * @param msgSignature 签名串，对应URL参数的msg_signature
	 * @param timeStamp 时间戳，对应URL参数的timestamp
	 * @param nonce 随机串，对应URL参数的nonce
	 * @param echoStr 随机串，对应URL参数的echostr
	 * 
	 * @return 解密之后的echostr
	 * @throws AesException 执行失败，请查看该异常的错误码和具体的错误信息
	 */
	public String VerifyURL(String msgSignature, String timeStamp, String nonce, String echoStr)
			throws AesException {
		String signature = SHA1.getSHA1(token, timeStamp, nonce, echoStr);

		if (!signature.equals(msgSignature)) {
			throw new AesException(AesException.ValidateSignatureError);
		}

		String result = decrypt(echoStr);
		return result;
	}

}
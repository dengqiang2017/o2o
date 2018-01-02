package com.qianying.exection;

public class LogicException extends RuntimeException {
	private static final long serialVersionUID = -4001926792192603413L;
	private Integer errorCode;
	public LogicException(String msg,Integer errorCode) {
		 super(msg);
	        this.errorCode = errorCode;
	}

	public Integer getErrorCode() {
        return errorCode;
    }
 
    public void setErrorCode(Integer errorCode) {
        this.errorCode = errorCode;
    }
}

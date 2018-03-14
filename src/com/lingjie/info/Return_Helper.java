package com.lingjie.info;

/*
 * 定义一个类，用来提示返回的情况
 */
public class Return_Helper {
	//设置用来判断是否操作成功
	public boolean isSuccess;
	//设置提示消息
	public String msg;
	//此状态的编号,一般0表示成功
	public int errorCode;
	public boolean isisSuccess() {
		return isSuccess;
	}
	public void setisSuccess(boolean isSuccess) {
		this.isSuccess = isSuccess;
	}
	public String getmsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	public int geterrorCode() {
		return errorCode;
	}
	public void seterrorCode(int errorCode) {
		this.errorCode = errorCode;
	}
	//
	public Return_Helper(boolean isSuccess,String msg,int errorCode)
	{
		this.isSuccess = isSuccess;
		this.msg = msg;
		this.errorCode = errorCode;
	}
	public Return_Helper()
	{
		
	}
}

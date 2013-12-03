// ApiException.java
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

package com.depthfirstdesign.driveline.exception;

public class ApiException extends Exception{
  private int code;
  public ApiException (int code, String msg) {
    super(msg);
    this.code = code;
  }
  public int getCode(){
    return code;
  }
}

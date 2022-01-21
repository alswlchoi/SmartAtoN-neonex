package com.hankook.pg.advice;

import com.hankook.pg.exception.AuthException;
import com.hankook.pg.exception.DataNotFoundException;
import com.hankook.pg.exception.FileHandleException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** 전역 예외처리 Controller Advice */
@Slf4j
@ControllerAdvice
@ResponseBody
public class ExceptionAdvice {

//  @Value("${redirect-url}")
//  private String redirectUrl;

  /**
   * 인증 예외 처리
   *
   * @param e 인증 예외
   * @param response CORS 처리를 위한 HttpServlet 응답 객체
   * @return
   */
  @ExceptionHandler(value = {AuthException.class})
  @ResponseStatus(HttpStatus.UNAUTHORIZED)
  public Map<String, Object> handleAuthException(Exception e, HttpServletResponse response) {
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Headers", "content-type, x-auth-token, menu-id");
    return createExceptionRes(HttpStatus.UNAUTHORIZED.value(), e.getMessage());
  }

  /**
   * 데이터 조회 결과 없음 예외 처리
   *
   * @param e 데이터 조회 결과 없음 예외
   * @param response CORS 처리를 위한 HttpServlet 응답 객체
   * @return
   */
  @ExceptionHandler(value = {DataNotFoundException.class})
  @ResponseStatus(HttpStatus.NOT_FOUND)
  public Map<String, Object> handleDataNotFoundException(
      DataNotFoundException e, HttpServletResponse response) {
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Headers", "content-type, x-auth-token, menu-id");
    return createExceptionRes(HttpStatus.NOT_FOUND.value(), "not found");
  }

  @ExceptionHandler(FileHandleException.class)
  @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
  protected Map<String, Object> handleFileHandleException(
      FileHandleException e, HttpServletResponse response) {
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Headers", "content-type, x-auth-token, menu-id");
    return createExceptionRes(HttpStatus.INTERNAL_SERVER_ERROR.value(), "server error");
  }

  @ExceptionHandler(Exception.class)
  @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
  protected Map<String, Object> Exception(
          Exception e, HttpServletResponse response) {
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Headers", "content-type, x-auth-token, menu-id");

    return createExceptionRes(HttpStatus.INTERNAL_SERVER_ERROR.value(), e.getClass().getSimpleName());
  }

  /**
   * 잘못된 요청 예외 처리
   *
   * @param e 잘못된 요청 예외
   * @return
   */
  @ExceptionHandler(MethodArgumentNotValidException.class)
  @ResponseStatus(HttpStatus.BAD_REQUEST)
  protected Map<String, Object> handleMethodArgumentNotValidException(
      MethodArgumentNotValidException e) {
    final BindingResult bindingResult = e.getBindingResult();
    final List<FieldError> errors = bindingResult.getFieldErrors();

    return createExceptionRes(HttpStatus.BAD_REQUEST.value(), errors.get(0).getDefaultMessage());
  }

  /**
   * 예외 응답 메시지 생성
   *
   * @param i 에러 코드
   * @param message 에러 메시지
   * @return
   */
  private Map<String, Object> createExceptionRes(int i, String message) {
    Map<String, Object> response = new HashMap<>();
    response.put("code", i);
    response.put("message", message);
    return response;
  }

//  private Map<String, Object> createExceptionResString(String errorCode, String message) {
//    Map<String, Object> response = new HashMap<>();
//    response.put("code", errorCode);
//    response.put("message", message);
//    return response;
//  }
}

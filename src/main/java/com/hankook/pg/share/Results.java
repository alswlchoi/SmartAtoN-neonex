package com.hankook.pg.share;

import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.lang3.StringUtils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 *
 * <pre>
 *     응답형식 결과 유틸 클래스
 *
 *     - 성공 응답형식 : { result : { data : { 결과 를 가진 오브젝트 } } }
 *     - 실패 응답형식 : { error : { code : 오류코드, message : 오류메세지 } }, { error : { code : 오류코드, message :
 * 오류메세지, url : 오류 이동 주소 } }
 *     - grid 응답형식 : { page: 현재 페이지, total : 전체 페이지, records : 전체레코드 수, rows : 데이터 목록 }
 * </pre>
 *
 * @author bskim
 * @since 1.0
 */
public class Results {

  public static final String ROOT_KEY_SUCCESS = "result";
  public static final String ROOT_KEY_ERROR = "public/error";

  public static final String KEY_DATA = "data";
  public static final String KEY_LIST = "list";
  public static final String KEY_CODE = "code";
  public static final String KEY_MESSAGE = "message";
  public static final String KEY_URL = "url";
  public static final String KEY_TIMESTAMP = "timestamp";
  public static final String KEY_ERROR = "public/error";
  public static final String KEY_TRACE = "trace";

  public static final String GRID_CURRENT_PAGE = "page";
  public static final String GRID_TOTAL_PAGE = "total";
  public static final String GRID_TOTAL_RECORD = "records";
  public static final String GRID_DATA_LIST = "rows";
  public static final String GRID_MESSAGE = "msg";

  /**
   *
   *
   * <pre>
   *     성공 응답형식 결과를 반환한다.
   * </pre>
   *
   * @param data 결과
   * @return 성공 응답형식 결과
   */
  public static Map<String, Object> success(Object data) {
    return getRootResultMap(ROOT_KEY_SUCCESS, new String[] {KEY_DATA}, new Object[] {data});
  }

  /**
   *
   *
   * <pre>
   *     실패 응답형식 결과를 반환한다.
   * </pre>
   *
   * @param code 오류코드
   * @param message 오류메세지
   * @return 실패 응답형식 결과
   */
  public static Map<String, Object> error(String code, String message) {
    return error(code, message, null);
  }

  /**
   *
   *
   * <pre>
   *     실패 응답형식 결과를 반환한다.
   * </pre>
   *
   * @param code 오류코드
   * @param message 오류메세지
   * @param url 오류 이동 주소
   * @return 실패 응답형식 결과
   */
  public static Map<String, Object> error(String code, String message, String url) {
    return getRootResultMap(
        ROOT_KEY_ERROR,
        new String[] {KEY_CODE, KEY_MESSAGE, KEY_URL},
        new Object[] {code, message, url});
  }


  /**
   *
   *
   * <pre>
   *     grid 응답형식 결과를 반환한다.
   * </pre>
   *
   * @param paging 공통 페이지 VO
   * @param dataList 데이터 목록
   * @return grid 응답형식 결과
   */
  public static Map<String, Object> grid(com.hankook.pg.share.Paging paging, List<?> dataList) {
    return getResultMap(
        new String[] {GRID_CURRENT_PAGE, GRID_TOTAL_PAGE, GRID_TOTAL_RECORD, GRID_DATA_LIST},
        new Object[] {
          paging.getPageNo(), paging.getFinalPageNo(), paging.getTotalCount(), dataList
        });
  }

  /**
   *
   *
   * <pre>
   *     grid 응답형식 결과를 반환한다.
   * </pre>
   *
   * @param paging 공통 페이지 VO
   * @param dataList 데이터 목록
   * @param message 추가 메세지
   * @return grid 응답형식 결과
   */
  public static Map<String, Object> grid(com.hankook.pg.share.Paging paging, List<?> dataList, String message) {
    return getResultMap(
        new String[] {
          GRID_CURRENT_PAGE, GRID_TOTAL_PAGE, GRID_TOTAL_RECORD, GRID_DATA_LIST, GRID_MESSAGE
        },
        new Object[] {
          paging.getPageNo(), paging.getFinalPageNo(), paging.getTotalCount(), dataList, message
        });
  }

  /**
   *
   *
   * <pre>
   *     grid 응답형식 결과를 반환한다.
   * </pre>
   *
   * @param dataList 데이터 목록
   * @return grid 응답형식 결과
   */
  public static Map<String, Object> grid(List<?> dataList) {
    return getResultMap(new String[] {GRID_DATA_LIST}, new Object[] {dataList});
  }



  /**
   *
   *
   * <pre>
   *     메세지 결과를 반환한다.
   * </pre>
   *
   * @param message 메세지
   * @return 메세지 결과
   */
  public static Map<String, Object> message(String message) {
    return getResultMap(new String[] {KEY_MESSAGE}, new Object[] {message});
  }

  public static Map<String, Object> OK() {
    return getResultMap(new String[] {KEY_CODE}, new Object[] {200});
  }

  public static Map<String, Object> OK(String data) {
    return getResultMap(new String[] {KEY_CODE, KEY_DATA}, new Object[] {200, data});
  }

  public static Map<String, Object> CREATED() {
    return getResultMap(new String[] {KEY_CODE}, new Object[] {201});
  }

  public static Map<String, Object> CREATED(String data) {
    return getResultMap(new String[] {KEY_CODE, KEY_DATA}, new Object[] {201, data});
  }

  public static Map<String, Object> NOT_CREATED() {
    return getResultMap(new String[] {KEY_CODE, KEY_MESSAGE}, new Object[] {400, "NOT CREATED"});
  }

  public static Map<String, Object> NOT_FOUND() {
    return getResultMap(new String[] {KEY_CODE}, new Object[] {404});
  }

  /**
   *
   *
   * <pre>
   *     응답형식 결과맵을 가져온다.
   * </pre>
   *
   * @param rootKey 응답형식 루트키
   * @param keys 응답형식 키들
   * @param values 응답형식 값들
   * @return 응답형식 결과맵
   */
  private static Map<String, Object> getRootResultMap(
      String rootKey, String[] keys, Object[] values) {
    Map<String, Object> resultMap = getResultMap(keys, values);

    Map<String, Object> rootResultMap = new HashMap<>();

    rootResultMap.put(rootKey, resultMap.isEmpty() ? null : resultMap);

    return rootResultMap;
  }

  /**
   *
   *
   * <pre>
   *     응답형식 결과맵을 가져온다.
   * </pre>
   *
   * @param keys 응답형식 키들
   * @param values 응답형식 값들
   * @return 응답형식 결과맵
   */
  private static Map<String, Object> getResultMap(String[] keys, Object[] values) {
    Map<String, Object> resultMap = new HashMap<>();

    String key;
    Object value;

    for (int index = 0, length = keys.length; index < length; index++) {
      key = keys[index];
      value = values[index];

      if (StringUtils.isNotEmpty(key) && ObjectUtils.allNotNull(value)) {
        resultMap.put(key, value);
      }
    }

    return resultMap;
  }
}

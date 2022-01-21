package com.hankook.pg.content.user.myPageCalculate.service;

import java.util.List;

import com.hankook.pg.content.user.myPageCalculate.vo.CalToPay;
import com.hankook.pg.content.user.myPageCalculate.vo.CalVo;


public interface CalService {

	List<CalVo> searchList(CalVo calVo) throws Exception;

	int searchListCnt(CalVo calVo) throws Exception;

	List<CalVo> getOne(String[] codeArr) throws Exception;

	List<CalVo> getRfidLogList(String[] codeArr) throws Exception;

	int insertPay(String reservCode) throws Exception;

	List<CalToPay> getPayList(String[] codeArr) throws Exception;

}

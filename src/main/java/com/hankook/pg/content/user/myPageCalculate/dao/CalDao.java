package com.hankook.pg.content.user.myPageCalculate.dao;

import java.sql.SQLException;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.hankook.pg.content.admin.trReserve.dto.TrPayDto;
import com.hankook.pg.content.user.myPageCalculate.vo.CalToPay;
import com.hankook.pg.content.user.myPageCalculate.vo.CalVo;


@Repository
@Mapper
public interface CalDao {

	List<CalVo> searchList(CalVo calVo) throws SQLException;

	int searchListCnt(CalVo calVo) throws SQLException;

	List<CalVo> getOne(String[] codeArr) throws SQLException;

	List<CalVo> getRfidLogList(String[] codeArr) throws SQLException;

	List<CalToPay> getRfidLogToPay(CalToPay vo) throws SQLException;

	List<String> getTcDayList(String reservCode) throws SQLException;

	String getTrTrackType(String reservCode) throws SQLException;

	int insertPay(TrPayDto trPayDto) throws SQLException;

	List<CalToPay> getPayList(String[] codeArr) throws SQLException;

	int getGnrPrice() throws SQLException;

	TrPayDto getDayCarCnt(TrPayDto defaultPriceVo) throws SQLException;

}

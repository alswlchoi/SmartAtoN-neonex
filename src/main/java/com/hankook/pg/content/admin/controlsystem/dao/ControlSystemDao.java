package com.hankook.pg.content.admin.controlsystem.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.hankook.pg.content.admin.car.dto.CarDto;
import com.hankook.pg.content.admin.controlsystem.dto.NowGnrDto;
import com.hankook.pg.content.admin.controlsystem.dto.ResourceCurrentConditionDto;
import com.hankook.pg.content.admin.controlsystem.dto.SearchDto;
import com.hankook.pg.content.admin.controlsystem.dto.TrackDto;

@Repository
@Mapper
public interface ControlSystemDao {
	List<TrackDto> selectTrackList();
	
	Integer selectCountRfidGnr(String tcDay) throws Exception;
	
	List<ResourceCurrentConditionDto> selectRfidLogList(String tId, String tcDay) throws Exception;
	
	String selectDriver(SearchDto searchDto) throws Exception;
	
	String selectCar(SearchDto searchDto) throws Exception;
	
	NowGnrDto selectNowGnr(String tcDay) throws Exception;
	
	Integer modifyInputIntimeLastRfidGeneral(String currentTime) throws Exception;
	
	NowGnrDto selectGnrInputDriver(SearchDto searchDto) throws Exception;
	
	NowGnrDto selectSearchDriver(SearchDto searchDto) throws Exception;
	
	CarDto selectSearchCar(SearchDto searchDto) throws Exception;
	
	String[] selectKakaoPhoneList(String tcDay) throws Exception;
}

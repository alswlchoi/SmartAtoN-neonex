package com.hankook.pg.content.emergency.service;

import com.hankook.pg.content.emergency.vo.EmergencyVo;

import java.util.List;

public interface EmergencyService {

	List<EmergencyVo> getEmergencyList(EmergencyVo emergencyVo) throws Exception;

	int getEmergencyListCnt(EmergencyVo emergencyVo) throws Exception;

	String getNext()  throws Exception;

	int insertEmergency(EmergencyVo emer) throws Exception;

	int deleteEmergency(EmergencyVo emer) throws Exception;

	int updateEmergency(EmergencyVo emer) throws Exception;

}

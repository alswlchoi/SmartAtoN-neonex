package com.hankook.pg.content.emergency.dao;

import com.hankook.pg.content.emergency.vo.EmergencyVo;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.sql.SQLException;
import java.util.List;
@Repository
@Mapper
public interface EmergencyDao {

	List<EmergencyVo> getEmergencyList(EmergencyVo emergencyVo) throws SQLException;

	int getEmergencyListCnt(EmergencyVo emergencyVo) throws SQLException;

	String getNext() throws SQLException;

	int insertEmergency(EmergencyVo emer) throws SQLException;

	int deleteEmergency(EmergencyVo emer) throws SQLException;

	int updateEmergency(EmergencyVo emer) throws SQLException;


}

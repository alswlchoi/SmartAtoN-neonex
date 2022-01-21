package com.hankook.pg.content.emergency.service;

import com.hankook.pg.content.emergency.dao.EmergencyDao;
import com.hankook.pg.content.emergency.vo.EmergencyVo;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service("EmergencyService")
@Slf4j
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class EmergencyServiceImpl implements EmergencyService{
	@Autowired
	private EmergencyDao emergencyDao;
	@Override
	public List<EmergencyVo> getEmergencyList(EmergencyVo emergencyVo) throws Exception {
		return emergencyDao.getEmergencyList(emergencyVo);
	}
	@Override
	public int getEmergencyListCnt(EmergencyVo emergencyVo) throws Exception {
		return emergencyDao.getEmergencyListCnt(emergencyVo);
	}
	@Override
	public String getNext() throws Exception {
		return emergencyDao.getNext();
	}
	@Override
	public int insertEmergency(EmergencyVo emer) throws Exception {
		return emergencyDao.insertEmergency(emer);
	}
	@Override
	public int deleteEmergency(EmergencyVo emer) throws Exception {
		return emergencyDao.deleteEmergency(emer);
	}
	@Override
	public int updateEmergency(EmergencyVo emer) throws Exception {
		return emergencyDao.updateEmergency(emer);
	}

}

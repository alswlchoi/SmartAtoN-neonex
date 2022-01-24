package com.hankook.pg.content.admin.controlsystem.service;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.hankook.pg.common.util.Fn;
import com.hankook.pg.content.admin.car.dto.CarDto;
import com.hankook.pg.content.admin.controlsystem.dao.ControlSystemDao;
import com.hankook.pg.content.admin.controlsystem.dto.NowGnrDto;
import com.hankook.pg.content.admin.controlsystem.dto.ResourceCurrentConditionDto;
import com.hankook.pg.content.admin.controlsystem.dto.SearchDto;
import com.hankook.pg.content.admin.controlsystem.dto.TrackDto;
import com.hankook.pg.share.AESCrypt;

@Service
public class ControlSystemService {
	@Autowired
	private ControlSystemDao controlSystemDao;

	public List<TrackDto> selectTrackList() throws Exception {
		return controlSystemDao.selectTrackList();
	}

	public List<ResourceCurrentConditionDto> resourceCondition(String tId, String tcDay) throws Exception {
		List<ResourceCurrentConditionDto> resourceConditionList = controlSystemDao.selectRfidLogList(tId, tcDay); 
		for(int i=0; i<resourceConditionList.size(); i++) {
			ResourceCurrentConditionDto resourceCondition = resourceConditionList.get(i);
			SearchDto search = new SearchDto();
			Integer tcSeq = resourceCondition.getTcSeq();
			
			String tagId = resourceCondition.getTagId();
			String carTagId = resourceCondition.getCarTagId();
			search.setTcSeq(tcSeq);
			search.setTcDay(tcDay);
			search.setTagId(tagId);
			search.setCarTagId(carTagId);
			
			String driverInfo = controlSystemDao.selectDriver(search);
			String carInfo = controlSystemDao.selectCar(search);
			if(null!=driverInfo && driverInfo.indexOf("#div#")>-1) {
				String[] driverInfoArr = driverInfo.split("#div#");
				String dName = AESCrypt.decrypt(driverInfoArr[0]);

				driverInfo = dName+"#div#"+driverInfoArr[1];
						
			}
			resourceCondition.setDriverInfo(driverInfo);
			resourceCondition.setCarInfo(carInfo);			
		}
		return resourceConditionList;
	}
	
	public NowGnrDto selectNowGnr(String tcDay) throws Exception {
		NowGnrDto nowGnrDto = controlSystemDao.selectNowGnr(tcDay);
		
		if(null!=nowGnrDto&&null!=nowGnrDto.getDName()){
			String dName = AESCrypt.decrypt(nowGnrDto.getDName());
			nowGnrDto.setDName(dName);
		}		
		
		return nowGnrDto;
	}
	
	public Integer selectCountRfidGnr(String tcDay) throws Exception {
		return controlSystemDao.selectCountRfidGnr(tcDay);
	}
	
	public Integer modifyInputIntimeLastRfidGeneral() throws Exception {
    	/* 현재 시간 설정 */
    	Date date_now = new Date(System.currentTimeMillis());
    	String currentTime = Fn.toDateFormat(date_now, "yyyyMMddHHmmss");
    	
    	
		return controlSystemDao.modifyInputIntimeLastRfidGeneral(currentTime);
	}

	public NowGnrDto selectSearchDriver(SearchDto searchDto) throws Exception {
		
		String dName = searchDto.getdName();
		
		if(Fn.toInt(dName)>0) {	//검색어가 숫자인 경우 운전자 관리번호로 간주함
			searchDto.setdSeq(Fn.toInt(dName));
		}else {
			searchDto.setdName(AESCrypt.encrypt(dName));
		}
		
		NowGnrDto nowGnrDto = controlSystemDao.selectSearchDriver(searchDto);	//시험로 진입여부
		if(null==nowGnrDto) {	//시험로 진입전이면 GNR 진입여부 확인
			nowGnrDto = controlSystemDao.selectGnrInputDriver(searchDto);
			
			if(null!=nowGnrDto) {
				dName = AESCrypt.decrypt(nowGnrDto.getDName());
				nowGnrDto.setDName(dName);
			}
		}else {
			dName = AESCrypt.decrypt(nowGnrDto.getDName());
			nowGnrDto.setDName(dName);
			
			searchDto.setTcSeq(nowGnrDto.getTcSeq());
			searchDto.setCarTagId(nowGnrDto.getCarTagId());
			
			CarDto carInfo = controlSystemDao.selectSearchCar(searchDto);
			
			if(null!=carInfo) {
				nowGnrDto.setCVender(carInfo.getCVender());
				nowGnrDto.setCName(carInfo.getCName());
				nowGnrDto.setCNumber(carInfo.getCNumber());
				nowGnrDto.setCColor(carInfo.getCColor());
				nowGnrDto.setCType(carInfo.getCType());
			}
		}
		
		return nowGnrDto;
	}
	
	public String[] selectKakaoPhoneList() throws Exception {
    	/* 현재 시간 설정 */
    	Date date_now = new Date(System.currentTimeMillis());
    	String tcDay = Fn.toDateFormat(date_now, "yyyyMMdd");
		
		String[] phoneArr = controlSystemDao.selectKakaoPhoneList(tcDay);
		return phoneArr;
	}
}

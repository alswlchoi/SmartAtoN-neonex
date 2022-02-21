package com.hankook.pg.content.admin.trReserve.service;
 
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.hankook.pg.common.util.Fn;
import com.hankook.pg.common.util.Validity;
import com.hankook.pg.content.admin.car.dto.CarDto;
import com.hankook.pg.content.admin.company.dao.CompanyDao;
import com.hankook.pg.content.admin.company.dto.CompanyDto;
import com.hankook.pg.content.admin.company.service.CompanyService;
import com.hankook.pg.content.admin.dayoff.dto.DayoffDto;
import com.hankook.pg.content.admin.driver.dao.DriverDao;
import com.hankook.pg.content.admin.driver.dto.DriverDto;
import com.hankook.pg.content.admin.driver.dto.SearchDriverDto;
import com.hankook.pg.content.admin.trReserve.dao.TrReserveDao;
import com.hankook.pg.content.admin.trReserve.dto.ChargeDto;
import com.hankook.pg.content.admin.trReserve.dto.EaiHkDto;
import com.hankook.pg.content.admin.trReserve.dto.ResourceMappingDto;
import com.hankook.pg.content.admin.trReserve.dto.SearchTrReserveDto;
import com.hankook.pg.content.admin.trReserve.dto.TrPayDto;
import com.hankook.pg.content.admin.trReserve.dto.TrReserveDto;
import com.hankook.pg.content.admin.trReserve.dto.TrRfidDto;
import com.hankook.pg.content.admin.trReserve.dto.TrRfidGnrDto;
import com.hankook.pg.content.admin.trReserve.dto.TrackDto;
import com.hankook.pg.content.admin.weekday.dto.WeekdayDto;
import com.hankook.pg.content.member.dao.MemberDAO;
import com.hankook.pg.content.member.dto.MemberDto;
import com.hankook.pg.content.user.userShop.dao.UserShopDao;
import com.hankook.pg.content.user.userShop.service.UserShopService;
import com.hankook.pg.content.user.userShop.vo.UserShopVo;
import com.hankook.pg.mail.entity.Email;
import com.hankook.pg.mail.service.EmailService;
import com.hankook.pg.share.AESCrypt;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.Results;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@Transactional(propagation = Propagation.REQUIRED, rollbackFor = {Exception.class})
public class TrReserveService{
    //update
    @Autowired
    private TrReserveDao trReserveDao;
    
    @Autowired
    private MemberDAO memberDao;
    
    @Autowired
    private CompanyDao companyDao;
    
    @Autowired
    private DriverDao driverDao;
    
    @Autowired
    private UserShopDao shopDao;
    
    @Autowired
    private UserShopService userShopService;
    
    @Autowired
    private CompanyService companyService;
    
    @Autowired
    private EmailService emailService;
    
    public Map<String, Object> getTrReserveList(SearchTrReserveDto searchTrReserve) throws Exception {
    	String tcDay = searchTrReserve.getTcDay();
		String tcStDt = "";
		String tcEdDt = "";
    	if(null!=tcDay&&!tcDay.equals("")) {
			String days[] = searchTrReserve.getTcDay().split("~");	// ~ 구분자로 시작일과 마감일 분리, 형식 안 맞으면 insert 안 됨
			if(days.length==2) {			//기간이 정상적으로 들어오지 않으면 기간검색 무효화
		    	tcStDt = days[0].trim();	//시작일
		    	tcEdDt = days[1].trim();	//마감일
	
		    	tcStDt = Fn.toDateFormat(tcStDt, "yyyyMMdd");
		    	tcEdDt = Fn.toDateFormat(tcEdDt, "yyyyMMdd");
				
		    	searchTrReserve.setTcStDt(tcStDt);
		    	searchTrReserve.setTcEdDt(tcEdDt);
				//형식에 맞게 처리 해 줌
	    	}else if(days.length==1){
	    		tcStDt = searchTrReserve.getTcDay();
	    		
		    	searchTrReserve.setTcStDt(tcStDt);
		    	searchTrReserve.setTcEdDt(tcStDt);	
			}
    	}else {
			Date stDay = null;
			Date edDay = null;
			
			if(null!=searchTrReserve.getTcApproval() && searchTrReserve.getTcApproval().equals("3")) {
				stDay = Fn.getDateAddDay(0);
				edDay = Fn.getDateAddDay(0);
				
		    	tcStDt = Fn.toDateFormat(stDay, "yyyyMMdd");
		    	tcEdDt = Fn.toDateFormat(edDay, "yyyyMMdd");
		    	
		    	searchTrReserve.setTcStDt(tcStDt);
		    	searchTrReserve.setTcEdDt(tcEdDt);
			}
    	}

        if(null!=searchTrReserve.getOrderName1()&&searchTrReserve.getOrderName1()!="") {
        	searchTrReserve.setOrderName1("TC_DAY");
        	searchTrReserve.setOrderName2("TC_DAY2");
        	if(null==searchTrReserve.getOrderKind1()||searchTrReserve.getOrderKind1()=="") {
	        	searchTrReserve.setOrderKind1("DESC");
	        	searchTrReserve.setOrderKind2("DESC");
        	}else {
        		if(searchTrReserve.getOrderKind1().equals("DESC")) {
		        	searchTrReserve.setOrderKind1("DESC");
		        	searchTrReserve.setOrderKind2("DESC");
        		}else {
		        	searchTrReserve.setOrderKind1("ASC");
		        	searchTrReserve.setOrderKind2("ASC");
        		}
        	}
        }
        if(null!=searchTrReserve.getOrderName3()&&searchTrReserve.getOrderName3()!="") {
        	searchTrReserve.setOrderName3("TC_REG_DT");
        	if(null==searchTrReserve.getOrderKind3()||searchTrReserve.getOrderKind3()=="") {
	        	searchTrReserve.setOrderKind3("DESC");
        	}else {
        		if(searchTrReserve.getOrderKind3().equals("DESC")) {
		        	searchTrReserve.setOrderKind3("DESC");
        		}else {
		        	searchTrReserve.setOrderKind3("ASC");
        		}
        	}
        }
        if(null!=searchTrReserve.getOrderName5()&&searchTrReserve.getOrderName5()!="") {
        	searchTrReserve.setOrderName5("TR_TRACK_TYPE");
        	if(null==searchTrReserve.getOrderKind5()||searchTrReserve.getOrderKind5()=="") {
	        	searchTrReserve.setOrderKind5("DESC");
        	}else {
        		if(searchTrReserve.getOrderKind5().equals("DESC")) {
		        	searchTrReserve.setOrderKind5("DESC");
        		}else {
		        	searchTrReserve.setOrderKind5("ASC");
        		}
        	}
        }
    	
        if(null==searchTrReserve.getTcApproval()||searchTrReserve.getTcApproval().equals("")) {	//기본은 승인대기
        	searchTrReserve.setTcApproval("0");
        }
    	
    	searchTrReserve.setStartRowNum((searchTrReserve.getPageNo()-1)*searchTrReserve.getPageSize());
    	List<TrReserveDto> trReserveList = trReserveDao.getTrReserveList(searchTrReserve);
    	
    	for(TrReserveDto trReserve : trReserveList) {
    		searchTrReserve.setTcSeq(trReserve.getTcSeq());
    		searchTrReserve.setTcDay(trReserve.getTcDay());
    		searchTrReserve.setRmType("D");			//운전자 리소스 정보
    		List<ResourceMappingDto> rmlist = new ArrayList<ResourceMappingDto>();
    		if(trReserve.getCompCode().equals("THINT")) {
    			rmlist = trReserveDao.getTrHintResourceMapping(searchTrReserve);
    		}else {
    			rmlist = trReserveDao.getTrMyResourceMapping(searchTrReserve);
    		}
    		
    		for(int i=0; i<rmlist.size(); i++) {
				rmlist.get(i).setDName(AESCrypt.decrypt(rmlist.get(i).getDName()));
			}
    		
    		trReserve.setRmList(rmlist);
    		List<CarDto> carList = new ArrayList<CarDto>();

    		searchTrReserve.setRmType("C");			//시험차량 리소스 정보
    		if(trReserve.getTcReservCode().indexOf("H")>-1) {	//T-HINT 예약건이면 HINT 전용 차량 Table에서 가져옴
    			carList = trReserveDao.getTrHintCarList(searchTrReserve);
    		}else{
    			carList = trReserveDao.getTrCarList(searchTrReserve);
    		}
    		trReserve.setCarList(carList);
    	}

        Paging paging = new Paging(searchTrReserve, trReserveDao.findTrReserveCount(searchTrReserve));
        
        return Results.grid(paging, trReserveList);
    }

	public Map<String, String> selectTrCalendar(SearchTrReserveDto searchTrReserve) throws Exception {
		Map<String, String> result = new HashMap<String, String>();
		
		List<TrReserveDto> trReserveList = trReserveDao.selectTrCalendar(searchTrReserve);

		String trContent = "";
		String strCnt = trReserveDao.selectTrCalendarCount(searchTrReserve.getTcDay());
		int beforeTcSeq = 0;
		String beforePackageName = "";
		int i=0;
		for(TrReserveDto trReserve : trReserveList) {
			if(i<4) {
				String compName = trReserve.getCompName();
				String compCode = trReserve.getCompCode();
				
				if(compCode.equals("THINT")) {
					if((null!=trReserve.getTcSeq()&&beforeTcSeq!=trReserve.getTcSeq())
							||(null!=trReserve.getTrPackageName()&&!beforePackageName.equals(trReserve.getTrPackageName()))) {
						trContent += "<span class=\"event_thint\" title=\""+trReserve.getTrPackageName()+"\">[공] "+trReserve.getTrPackageName()+"</span>";
						i++;
					}
					beforeTcSeq = trReserve.getTcSeq();
					beforePackageName = trReserve.getTrPackageName();
				}else {
					trContent += "<span class=\"";
					if(trReserve.getTcApproval().equals("0")) {
						trContent += "event_approval";
					}else {
						trContent += "event_b2b";
					}
					trContent += "\" title=\""+trReserve.getTrTrackNickName() + "/" + compName+"\">";
					if(trReserve.getTrTrackType().equals("TYP01")){
						trContent += "[단] ";
					}else {
						trContent += "[공] ";
					}
					
					if(compName.length()<7) {
						trContent += trReserve.getTrTrackNickName() + "/" + compName;
					}else {
						trContent += trReserve.getTrTrackNickName() + "/" + compName.substring(0,7);
					}
					trContent += "</span>";
					i++;
				}
				result.put("trContent", trContent);
				result.put("tcApproval", trReserve.getTcApproval());
				
			}
		}
		
		result.put("cnt", Fn.toString(trReserveList.size()));
		result.put("strCnt", strCnt);
		
		return result;
	}

    public int chkSchedule(SearchTrReserveDto searchTrReserve) throws Exception {
    	int cnt = trReserveDao.chkSchedule(searchTrReserve);
    	int dayoff = trReserveDao.chkDayOff(searchTrReserve);
    	return cnt+dayoff;
    }
	
    public Integer getCompCodeduplCheck(Integer tcSeq) throws Exception {
    	return trReserveDao.getCompCodeduplCheck(tcSeq);
    }
    
    public Integer getAccountYn(String pReservCode) throws Exception {
    	return trReserveDao.getAccountYn(pReservCode);
    }
    
    public List<String> getDayoffArr(String doKind) throws Exception {

    	List<DayoffDto> dayofflist = trReserveDao.dayoffList(doKind);

    	List<String> doArr = new ArrayList<String>(); 
    	
    	for(DayoffDto dayoff : dayofflist) {
    		String stDt = dayoff.getDoStDay();
    		Integer edDt = Fn.toInt(dayoff.getDoEdDay());

        	//String stDt, int edDt
            int startYear = Integer.parseInt(stDt.substring(0,4));
            int startMonth= Integer.parseInt(stDt.substring(4,6));
            int startDate = Integer.parseInt(stDt.substring(6,8));
     
            Calendar cal = Calendar.getInstance();
             
            // Calendar의 Month는 0부터 시작하므로 -1 해준다.
            // Calendar의 기본 날짜를 stDt로 셋팅해준다.
            cal.set(startYear, startMonth -1, startDate);
             
            while(true) {
                doArr.add(getDateByString(cal.getTime()));
                 
                // Calendar의 날짜를 하루씩 증가한다.
                cal.add(Calendar.DATE, 1); // one day increment
                 
                // 현재 날짜가 종료일자보다 크면 종료 
                if(getDateByInteger(cal.getTime()) > edDt) break;
            }
    	}
        
        return doArr;
    }
    
    public static int getDateByInteger(Date date) throws Exception {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        return Integer.parseInt(sdf.format(date));
    }
     
    public static String getDateByString(Date date) throws Exception {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        return sdf.format(date);
    }

    public String getTcDayWeekday(String tcDay) throws Exception {
    	String wdKind = "b";
    	String canWeek = trReserveDao.getTcDayWeekday(wdKind, tcDay);
    	
    	return canWeek;
    }
    
    //부대시설 리스트 불러오기
    public List<ChargeDto> selectList(ChargeDto chargeDto) throws Exception{
    	return trReserveDao.getList(chargeDto);
    }
    
    //정산-부대시설-페이징
    public int selectListCnt(ChargeDto chargeDto) throws Exception{
    	return trReserveDao.getListCnt(chargeDto);
    }
    
    //정산-부대시설 디테일 리스트
    //오른쪽 매개변수를 사용해서 왼쪽 List로 뿌려준다
    public ChargeDto detailList(ChargeDto chargeDto) throws Exception{
    	ChargeDto chargedto = trReserveDao.detailList(chargeDto);
    	chargedto.setMemName(AESCrypt.decrypt(chargedto.getMemName()));
    	chargedto.setMemEmail(AESCrypt.decrypt(chargedto.getMemEmail()));
    	chargedto.setMemPhone(AESCrypt.decrypt(chargedto.getMemPhone()));
    	
    	return chargedto;
    	
    }
    
    //정산-시험로-시험정보
    public List<ChargeDto> testInfo(ChargeDto chargeDto) throws Exception{
    	return trReserveDao.testInfo(chargeDto);
    }
    
    //정산-시험로-시험정보
    public List<ChargeDto> test_Info(ChargeDto chargeDto) throws Exception{
    	List<ChargeDto> ListchargeDto = trReserveDao.test_Info(chargeDto);
    	for(int i=0; i<ListchargeDto.size(); i++){
    		ListchargeDto.get(i).setDName(AESCrypt.decrypt(ListchargeDto.get(i).getDName()));    	
    		}
    	return ListchargeDto;
    }
    
    //정산-시험로-정산
    public List<ChargeDto> chargeInfo(ChargeDto chargeDto) throws Exception{
    	return trReserveDao.chargeInfo(chargeDto);
    }
    
    //정산-부대시설-정산
    public ChargeDto shopInfo(ChargeDto chargeDto) throws Exception{
    	return trReserveDao.shopInfo(chargeDto);
    }
    
    //정산-시험로-차량정보
    public List<ChargeDto> carInfo(ChargeDto chargeDto) throws Exception{
    	return trReserveDao.carInfo(chargeDto);
    }
    
    //정산-시험로-리스트 
    public List<SearchTrReserveDto> accountList(SearchTrReserveDto searchTrReserve) throws Exception{
    	return trReserveDao.accountList(searchTrReserve);
    }
    
    //정산-시험로-페이징
    public int accountCnt(SearchTrReserveDto searchTrReserve) throws Exception{
    	return trReserveDao.accountCnt(searchTrReserve);
    }
    
    //정산-시험로-상세
    public ChargeDto accountDetaillist(String tcReservCode) throws Exception{
    	ChargeDto chargeDto = trReserveDao.accountDetaillist(tcReservCode);
    	chargeDto.setMemName(AESCrypt.decrypt(chargeDto.getMemName()));
    	chargeDto.setMemEmail(AESCrypt.decrypt(chargeDto.getMemEmail()));
    	chargeDto.setMemPhone(AESCrypt.decrypt(chargeDto.getMemPhone()));
    	return chargeDto;
    }
    
    //실제사용일		
    public String realday(ChargeDto chargeDto) {
    	return trReserveDao.realday(chargeDto);
    }
    
    //실제사용일 부대시설		
    public String realdate(ChargeDto chargeDto) {
    	return trReserveDao.realdate(chargeDto);
    }
    		
    public Integer addtrackInfoToReservedInfo(SearchTrReserveDto searchTrReserve) throws Exception {
    	TrReserveDto trReserve = trReserveDao.getTrReserveDetail(searchTrReserve);
    	Integer resultCnt = 0;
    	
    	if(!trReserve.getTcApproval().equals("0")&&!trReserve.getTcApproval().equals("3")) {
    		resultCnt = -20;
    	}else if(trReserve.getTcStep().equals("00003")) {
    			resultCnt = -30;
    	}else {
	    	Integer cnt_reserved_track = trReserveDao.getCountReserveTrack(searchTrReserve);
	    	
	    	if(cnt_reserved_track>0) {
	    		resultCnt = -10;
	    	}else {
	    		String reservedTrackCode = trReserveDao.getReserveTrackMax(searchTrReserve.getTcSeq());
	    		TrackDto track = trReserveDao.getTrackInfo(searchTrReserve.getTrTrackCode());
	    		
	    		trReserve = new TrReserveDto();
	    		trReserve.setTrTrackName(track.getTName());
	    		trReserve.setTrTrackNickName(track.getTNickName());
	    		trReserve.setTrTrackCode(track.getTId());
	    		trReserve.setTrLevel(track.getTLevel());
	    		trReserve.setTrPrice(track.getTPrice());
	    		trReserve.setTrPriceAdd(track.getTPriceAdd());
	    		trReserve.setTrPriceSolo(track.getTSolo());
	    		trReserve.setTcSeq(searchTrReserve.getTcSeq());
	    		trReserve.setTrTrackCodeCopy(reservedTrackCode);
	    		
	    		resultCnt = trReserveDao.addtrackInfoToReservedInfo(trReserve);
	    	}	
    	}
    	return resultCnt;
    }
    
    public Integer addRfidLog(TrRfidDto rfidLog) throws Exception {
    	System.out.println("rfidLog : " + rfidLog);
    	String tcDay = Fn.toDateFormat(rfidLog.getTcDay(), "yyyyMMdd");
    	rfidLog.setTcDay(tcDay);
    	rfidLog.setInsertFlug("Y");
    	rfidLog.setInTime(tcDay+rfidLog.getInTime()+"00");
    	if(null!=rfidLog.getOutTime()&&!rfidLog.getOutTime().equals("")) {
    		rfidLog.setOutTime(tcDay+rfidLog.getOutTime()+"00");
    	}
    	rfidLog.setType("WEB");
    	
    	Timestamp inTime = Fn.toTimestamp(rfidLog.getInTime());
    	Timestamp outTime = Fn.toTimestamp(rfidLog.getOutTime());
    	Integer diffTime = 0;
    	if(null!=rfidLog.getOutTime()&&!rfidLog.getOutTime().equals("")) {
    		diffTime = Fn.getSubMinutes(outTime, inTime);
    	}
    	rfidLog.setDiffTime(diffTime);
    	    	
    	SearchTrReserveDto searchTrReserve = new SearchTrReserveDto();
    	searchTrReserve.setTcSeq(rfidLog.getTcSeq());
    	searchTrReserve.setTcDay(tcDay);
    	List<TrReserveDto> trReserveList = trReserveDao.getTrTrackList(rfidLog.getTcSeq());
    	List<ResourceMappingDto> resourceMappingList = trReserveDao.getResourceMapping(searchTrReserve);

    	Integer resultCnt = 0;
    	Integer cnt_track_log = 0;
    	Integer cnt_tcday_log = 0;
    	Integer cnt_rfid_log = 0;
    	Integer cnt_carRfid_log = 0;
    	
    	for(TrReserveDto trReserve : trReserveList) {
    		if(rfidLog.getTId().equals(trReserve.getTrTrackCode())) {
    			cnt_track_log++;
    		}
    		if(tcDay.equals(trReserve.getTcDay())) {
    			cnt_tcday_log++;
    		}
    	}
    	
    	for(ResourceMappingDto resourceMapping : resourceMappingList) {
    		if(resourceMapping.getRmType().equals("D")&&rfidLog.getTagId().equals(resourceMapping.getRId())) {
    			cnt_rfid_log++;
    		}
    		if(resourceMapping.getRmType().equals("C")&&rfidLog.getCarTagId().equals(resourceMapping.getRId())) {
    			cnt_carRfid_log++;
    		}
    	}
    	
    	if(cnt_track_log==0) {		//예약된 트랙이 없는 경우 트랙먼저 추가하라는 안내메세지
    		resultCnt = -20;
    	}else if(cnt_tcday_log==0){
    		resultCnt = -30;		//예약된 시험일자만 추가 가능하다는 안내매세지
    	}else if(cnt_rfid_log==0){
    		resultCnt = -60;		//등록된 운전자 RFID 카드만 추가 가능
    	}else if(cnt_carRfid_log==0){
    		resultCnt = -40;		//등록된 차량 RFID 카드만 추가 가능
    	}else {
	    	Integer cnt_reserved_log = trReserveDao.getCountRfidLog(rfidLog);
	    	
	    	if(cnt_reserved_log>0) {
	    		resultCnt = - 10;
	    	}else {
	    		resultCnt = trReserveDao.addRfidLog(rfidLog);
	    	}	
    	}
    	return resultCnt;
    }
    
    public Integer updateRfidGnrLog(TrRfidGnrDto rfidGnrLog) throws Exception {
    	String beforeInTime = rfidGnrLog.getInTime();
    	String beforeOutTime = rfidGnrLog.getOutTime();
    	String afterInTime = "";
    	String afterOutTime = "";
    	Integer resultCnt = 0; 
    	
    	rfidGnrLog = trReserveDao.getRfidGnrLog1Row(rfidGnrLog.getPrgNo());
    	//날짜랑 시간 잘 붙는지 확인하고
    	//updateRfidGnrLog, updateRfidLog parameterType 변경한 것 잘 동작하는지 확이
    	afterInTime = rfidGnrLog.getTcDay()+beforeInTime+"00"; 

		if(null!=beforeOutTime&&!beforeOutTime.equals("")) {
    		afterOutTime = rfidGnrLog.getTcDay()+beforeOutTime+"00";	
    	}else {
    		afterOutTime = null;
    	}
    	
    	if(null!=afterOutTime&&!afterOutTime.equals("")
    		&&afterInTime.compareTo(afterOutTime)>=0) {
    		resultCnt = -20;
    	}else {
    		rfidGnrLog.setInTime(afterInTime);
    		rfidGnrLog.setOutTime(afterOutTime);
    		rfidGnrLog.setCarRfidId(rfidGnrLog.getCarRfidId());

    		resultCnt = trReserveDao.updateRfidGnrLog(rfidGnrLog);
    	}
    	return resultCnt;
    }
    
    public Integer updateRfidLog(TrRfidDto rfidLog) throws Exception {
    	String beforeInTime = rfidLog.getInTime();
    	String beforeOutTime = rfidLog.getOutTime();
    	String afterInTime = "";
    	String afterOutTime = "";
    	Integer resultCnt = 0; 
    	
    	rfidLog = trReserveDao.getRfidLog1Row(rfidLog.getRlSeq());
    	afterInTime = rfidLog.getTcDay()+beforeInTime+"00"; 
    	
    	if(null!=beforeOutTime&&!beforeOutTime.equals("")) {
    		afterOutTime = rfidLog.getTcDay()+beforeOutTime+"00";	
    	}else {
    		afterOutTime = null;
    	}
    	
    	if(null!=afterOutTime&&!afterOutTime.equals("")
    			&&afterInTime.compareTo(afterOutTime)>=0) {
    		resultCnt = -20;
    	}else {
    		rfidLog.setInTime(afterInTime);
    		rfidLog.setOutTime(afterOutTime);
    		rfidLog.setCarTagId(rfidLog.getCarTagId());
    		
    		Integer diffTime = 0;
    		
    		if(null!=afterOutTime&&!afterOutTime.equals("")) {
    			Timestamp inTime = Fn.toTimestamp(afterInTime);
    			Timestamp outTime = Fn.toTimestamp(afterOutTime);
    			
    			diffTime = Fn.getSubMinutes(outTime, inTime);
    			rfidLog.setDiffTime(diffTime);
    		}
    		
    		
    		Integer cnt_reserved_log = trReserveDao.getCountRfidLog(rfidLog);
    		
    		if(cnt_reserved_log>0) {
    			resultCnt = - 10;
    		}else {
    			resultCnt = trReserveDao.updateRfidLog(rfidLog);
    		}	
    	}
    	return resultCnt;
    }

    @Transactional(isolation = Isolation.READ_COMMITTED, rollbackFor = Exception.class)
    public int insertTrReserve(TrReserveDto trReserve) throws Exception {
    	String tcDay = Fn.toDateFormat(trReserve.getTcDay(), "yyyyMMdd");
    	String tcDay2 = Fn.toDateFormat(trReserve.getTcDay2(), "yyyyMMdd");
		String wdKind = "b";
		
    	List<String> datelist = reserveCanList(wdKind, tcDay, tcDay2, "yyyyMMdd");

    	int cnt = 0;
    	
    	try {
	    	/* 로그인 정보 가져옴 */
	    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
			MemberDto memberDto = (MemberDto)authentication.getPrincipal();
			
			SearchTrReserveDto searchTrReserve = new SearchTrReserveDto();
	
			String tcStDt = datelist.get(0);
			String tcEdDt = datelist.get(datelist.size()-1);
			
			searchTrReserve.setTcStDt(tcStDt);
			searchTrReserve.setTcEdDt(tcEdDt);
			searchTrReserve.setCompCode(memberDto.getCompCode());
			
			Integer reservedCnt = trReserveDao.getReservedCompanyInArea(searchTrReserve);
	
			if(reservedCnt>0) {
				cnt = -90;
			}else {
				String[] sTrackArr = trReserve.getSTrackArr();		//공동트랙
				String[] mTrackArr = trReserve.getMTrackArr();		//단독트랙
		    	String[] driver = trReserve.getDriver();			//운전자 정보
		    	String[] cVender = trReserve.getCVender();			//제조사
		    	String[] cName = trReserve.getCName();				//모델명
		    	String[] cNumber = trReserve.getCNumber();			//차량번호
		    	String[] cColor = trReserve.getCColor();			//차량색상
		    	String[] cType = trReserve.getCType();				//특수차량여부
		    	String memPhone = trReserve.getMemPhone();			//신청자 휴대전화 번호
		    	String compPhone = trReserve.getCompPhone();		//회사 전화번호
		    	String memEmail = trReserve.getMemEmail();			//신청자 이메일 주소
		    	String compAcctName = trReserve.getCompAcctName();	//회계담당자명
		    	String compAcctDept = trReserve.getCompAcctDept();	//회계담당부서
		    	String compAcctEmail = trReserve.getCompAcctEmail();	//회계 담당 이메일
		    	String compAcctPhone = trReserve.getCompAcctPhone();	//회계 담당 전화번호
		    	String tcPurpose = Fn.toStringHtml(trReserve.getTcPurpose());	//특수문자 처리
		    	
		    	/* 현재 시간 설정 */
		    	Date date_now = new Date(System.currentTimeMillis());
		    	String currentTime = Fn.toDateFormat(date_now, "yyyyMMddHHmmss");
		    	
		    	/* 기본값 셋팅 */
			    String compType = "B";
		    	String tcAgreement = "Y";
		    	CompanyDto company = companyDao.getCompanyDetail(memberDto.getCompCode());
		    	trReserve.setTcPurpose(tcPurpose);
		    	trReserve.setTcDay(tcStDt);
		    	trReserve.setTcDay2(tcEdDt);
		    	trReserve.setCompCode(memberDto.getCompCode());
		    	trReserve.setCompName(company.getCompName());
		     	trReserve.setTcAgreement(tcAgreement);
		    	trReserve.setTcApproval("0");		//승인대기
		     	trReserve.setTcStep("00000");			//초기값 - 시험전
		    	trReserve.setTcRegUser(memberDto.getMemId());
		    	trReserve.setTcRegDt(currentTime);
		    	
		        String minDLevel = "Z";
		        for (String dSeq : driver) {
		    		DriverDto driverDto = driverDao.getDriverDetail(Fn.toInt(dSeq));
		    		if(driverDto.getDLevel().compareTo(minDLevel)<0) {
		    			minDLevel=driverDto.getDLevel();
		    		}
		        }
		
		        String minTLevel = "Z";
		        for (String trTrackCode : mTrackArr) {
			    	TrackDto track = trReserveDao.getTrackInfo(trTrackCode);
			    	if(null==track) {		//트랙코드가 잘못되서 정보를 가져오지 못 하는 경우
			    		cnt = -10;
			    		break;
			    	}else {
				    	if(track.getTLevel().substring(0,1).compareTo(minTLevel)<0) {
			    			minTLevel=track.getTLevel();
			    		}
			    	}
		        }
		        
		        if(cnt == 0) {
			        for (String trTrackCode : sTrackArr) {
				    	TrackDto track = trReserveDao.getTrackInfo(trTrackCode);
				    	if(null==track) {
				    		cnt = -10;
				    		break;
				    	}else {
					    	if(track.getTLevel().substring(0,1).compareTo(minTLevel)<0) {
				    			minTLevel=track.getTLevel();
				    		}
				    	}
			        }
		        }
		        
		        if(cnt == 0) {
			        if(minDLevel.compareTo(minTLevel)>0) {		//트랙등급보다 높은 운전자가 없으면 예약 방지
			        	cnt = -60;
			        }else {		    	
				    	String[] carCodeArr = new String[cVender.length];
				    	String maxCarCode = trReserveDao.getMaxCarCode();		//가장 최근 차량 코드 가져옴
		            	/* 코드값 생성 시작 */
		            	String carCode = "";
		            	Integer carCodeNum = 1;
		            	if(maxCarCode.equals("")) {		//해당일 예약건이 없으면
		            		carCodeNum = 1;
		            	}else {		//C(문자) 삭제하고 넘버만 가져옴
		            		maxCarCode = maxCarCode.replace("C", "");
		            		carCodeNum = Fn.toInt(maxCarCode)+1;
		            	}
				    	
				    	for(int i=0; i<cVender.length;i++) {
			            	if(null!=cVender[i]&&null!=cName[i]&&null!=cNumber[i]&&null!=cColor[i]
		            			&&""!=cVender[i]&&""!=cName[i]&&""!=cNumber[i]&&""!=cColor[i]	) {
			            		
					            if(carCodeNum<10) {
				            		carCode = "C000"+carCodeNum; 
				            	}else if(carCodeNum>=10 && carCodeNum <100){
				            		carCode = "C00"+carCodeNum;
				            	}else if(carCodeNum>=100 && carCodeNum <1000){
				            		carCode = "C0"+carCodeNum;
				            	}else {
				            		carCode = "C"+carCode;
				            	}
				            	CarDto car = new CarDto();
				            	car.setCVender(cVender[i]);
				            	car.setCName(cName[i]);
				            	car.setCNumber(cNumber[i]);
				            	car.setCColor(cColor[i]);
				            	car.setCType(cType[i]);
				            	car.setCCode(carCode);
				            	
				            	trReserveDao.insertCar(car);
				            	carCodeArr[i] = carCode;
		
				            	carCodeNum++;
			            	}
				        }
				    	
			        	if(mTrackArr.length>0) {
				        	//단독시험로부터 입력 시작
				        	/* 예약번호 생성 (YYYYMMDD_xx)		_자리 : B2B는 B, 한국타이어는 T, 현대자동차는 H */
				        	String compareCode = "T"+Fn.toDateFormat(currentTime, "yyMMdd")+compType;
				        	String maxTrReservCode = trReserveDao.getMaxReserveCode(compareCode);		//오늘 날짜로 가장 큰 예약번호를 가져옴
				        	Integer codeNum;
				        	
				        	String tcServCode = "";
				        	if(maxTrReservCode.equals("")) {		//해당일 예약건이 없으면
				        		codeNum = 1;
				        	}else {		//해당일 예약건이 있으면 숫자추출해서 +1 해줌
				        		String[] codeArr = maxTrReservCode.split(compType);
				        		codeNum = Fn.toInt(codeArr[1])+1;
				        	}
				        	
				        	if(codeNum<10) {
				        		tcServCode = compareCode+"00"+codeNum; 
				        	}else if(codeNum>=10 && codeNum <100){
				        		tcServCode = compareCode+"0"+codeNum;
				        	}else {
				        		tcServCode = compareCode+codeNum;
				        	}
				
				        	trReserve.setTcReservCode(tcServCode);
				        	trReserve.setTcRequestNumber(tcServCode);
				        	trReserve.setTrPrice(0);
				        	trReserve.setTrReservStHour("0000");
				        	trReserve.setTrReservEdHour("2359");
				        	
					    	cnt = trReserveDao.insertTestSchedule(trReserve);
					    	
					    	int tcSeq = trReserve.getTcSeq();
					    	if(cnt>0) {
					    		trReserve.setTcSeq(tcSeq);
					    		
					    		HashSet<String> hashSet = new HashSet<>();
					            for(String item : mTrackArr){
					                hashSet.add(item);
					            }
						        for (String trTrackCode : hashSet) {		//단독트랙입력
							    	trReserve.setTrTrackCode(trTrackCode);
							    	trReserve.setTrTrackType("TYP01");
							    	
							    	TrackDto track = trReserveDao.getTrackInfo(trTrackCode);
						    					    		
							    	trReserve.setTrLevel(track.getTLevel());
							    	trReserve.setTrPrice(track.getTPrice());
							    	trReserve.setTrPriceAdd(track.getTPriceAdd());
							    	trReserve.setTrPriceSolo(track.getTSolo());
							    	trReserve.setTrTrackName(track.getTName());
							    	trReserve.setTrTrackNickName(track.getTNickName());
							    	trReserve.setTrReservStHour("0000");
							    	trReserve.setTrReservEdHour("2359");
							    	for (String date : datelist) {
							    		trReserve.setTcDay(date);
							    		cnt = trReserveDao.insertTrReserve(trReserve);
									}
						    	}
				        		trReserve.setRmRegDt(currentTime);        		
						    	
				            	/* 코드값 생성 끝 */
						    	for (String date : datelist) {
						    		trReserve.setTcDay(date);
					        		trReserve.setRmType("D");
							        for (String dSeq : driver) {
						        		DriverDto driverDto = driverDao.getDriverDetail(Fn.toInt(dSeq));
						        		
						        		trReserve.setDSeq(driverDto.getDSeq());
						        		trReserve.setDName(driverDto.getDName());
						        		trReserve.setRmLevel(driverDto.getDLevel());
						        		trReserve.setCCode(null);
						        		trReserve.setRmInOut("O");
						        		trReserve.setNDccpYn("N");
				
						        		trReserveDao.insertResourceMapping(trReserve);
									}	
							        
							        for (String carCodeVal : carCodeArr) {
						            	trReserve.setCCode(carCodeVal);
						        		trReserve.setRmType("C");
								        trReserve.setDSeq(null);
								        trReserve.setDName(null);
								        
						        		trReserveDao.insertResourceMapping(trReserve);
							        }	        
						        }
					    	}
					    	//단독시험로 입력 끝
	
							String title = "[단독] 시험로 신청이 완료되었습니다.";
							Map<String, Object> tableMap = new HashMap<>();
							tableMap = emailSetting(trReserve.getTcSeq());
							
							Email email = new Email();
							email.setTitle(title);
							email.setTableMap(tableMap);
							email.setBdt(null);
							email.setRcverEmail(AESCrypt.decrypt(company.getMemEmail()));
							email.setSenderId(null);
							email.setSenderName(null);
							email.setStatusCode(null);
							email.setStatusMsg(null);
							email.setErrDt(null);
							email.setRegDt(null);
							//emailService.GoogleSenderMail(email, "E03");
							emailService.SenderMail(email, "E03");
			        	}
				    	
			        	if(sTrackArr.length>0) {
					    	//공동시험로 입력 시작
				        	/* 예약번호 생성 (YYYYMMDD_xx)		_자리 : B2B는 B, 한국타이어는 T, 현대자동차는 H */
				        	String compareCode = "T"+Fn.toDateFormat(currentTime, "yyMMdd")+compType;
				        	String maxTrReservCode = trReserveDao.getMaxReserveCode(compareCode);		//오늘 날짜로 가장 큰 예약번호를 가져옴
				        	Integer codeNum;
				        	
				        	String tcServCode = "";
				        	if(maxTrReservCode.equals("")) {		//해당일 예약건이 없으면
				        		codeNum = 1;
				        	}else {		//해당일 예약건이 있으면 숫자추출해서 +1 해줌
				        		String[] codeArr = maxTrReservCode.split(compType);
				        		codeNum = Fn.toInt(codeArr[1])+1;
				        	}
				        	
				        	if(codeNum<10) {
				        		tcServCode = compareCode+"00"+codeNum; 
				        	}else if(codeNum>=10 && codeNum <100){
				        		tcServCode = compareCode+"0"+codeNum;
				        	}else {
				        		tcServCode = compareCode+codeNum;
				        	}
				
				        	trReserve.setTcReservCode(tcServCode);
				        	trReserve.setTcRequestNumber(tcServCode);
				        	trReserve.setTrPrice(0);
				        	trReserve.setTcDay(datelist.get(0));
				        	trReserve.setTrReservStHour("0000");
				        	trReserve.setTrReservEdHour("2359");
				        	
					    	cnt = trReserveDao.insertTestSchedule(trReserve);
					    	
					    	int tcSeq = trReserve.getTcSeq();
					    	if(cnt>0) {
					    		trReserve.setTcSeq(tcSeq);
					    		
					    		HashSet<String> hashSet = new HashSet<>();
					            for(String item : sTrackArr){
					                hashSet.add(item);
					            }
						        for (String trTrackCode : hashSet) {		//공동트랙입력
							    	trReserve.setTrTrackCode(trTrackCode);
							    	trReserve.setTrTrackType("TYP00");
							    	
							    	TrackDto track = trReserveDao.getTrackInfo(trTrackCode);
						    					    		
							    	trReserve.setTrLevel(track.getTLevel());
							    	trReserve.setTrPrice(track.getTPrice());
							    	trReserve.setTrPriceAdd(track.getTPriceAdd());
							    	trReserve.setTrPriceSolo(track.getTSolo());
							    	trReserve.setTrTrackName(track.getTName());
							    	trReserve.setTrTrackNickName(track.getTNickName());
							    	trReserve.setTrReservStHour("0000");
							    	trReserve.setTrReservEdHour("2359");
							    	for (String date : datelist) {
							    		trReserve.setTcDay(date);
							    		cnt = trReserveDao.insertTrReserve(trReserve);
									}
						    	}
				        		trReserve.setRmRegDt(currentTime);
						    	
				            	/* 코드값 생성 끝 */
						    	for (String date : datelist) {
						    		trReserve.setTcDay(date);
					        		trReserve.setRmType("D");
							        for (String dSeq : driver) {
						        		DriverDto driverDto = driverDao.getDriverDetail(Fn.toInt(dSeq));
						        		
						        		trReserve.setDSeq(driverDto.getDSeq());
						        		trReserve.setDName(driverDto.getDName());
						        		trReserve.setRmLevel(driverDto.getDLevel());
						        		trReserve.setCCode(null);
						        		trReserve.setRmInOut("O");
						        		trReserve.setNDccpYn("N");
				
						        		trReserveDao.insertResourceMapping(trReserve);
									}
							        
							        for (String carCodeVal : carCodeArr) {
						            	trReserve.setCCode(carCodeVal);
						        		trReserve.setRmType("C");
								        trReserve.setDSeq(null);
								        trReserve.setDName(null);
								        
						        		trReserveDao.insertResourceMapping(trReserve);
							        }
		
						        }
	
								String title = "[공동] 시험로 신청이 완료되었습니다.";
								Map<String, Object> tableMap = new HashMap<>();
								tableMap = emailSetting(trReserve.getTcSeq());
								
								Email email = new Email();
								email.setTitle(title);
								email.setTableMap(tableMap);
								email.setBdt(null);
								email.setRcverEmail(AESCrypt.decrypt(company.getMemEmail()));
								email.setSenderId(null);
								email.setSenderName(null);
								email.setStatusCode(null);
								email.setStatusMsg(null);
								email.setErrDt(null);
								email.setRegDt(null);
								//emailService.GoogleSenderMail(email, "E03");
								emailService.SenderMail(email, "E03");
					    	}
				    	//공동시험로 입력 끝
			        	}
				    	
				    	MemberDto member = memberDao.getMemberinfo(memberDto.getMemId());
				    	//부대시설 동시 등록 시작;
				    	
					  String shopReserve[] = trReserve.getShopReserve();
					  Integer shopReserveCnt = 0;
					  if(null!=shopReserve&&!"".equals(shopReserve)) {
						  for(String wsCode : shopReserve) {
							  if(null!=wsCode&&!"".equals(wsCode)) {
								  List<String> datelistLast = new ArrayList<String>();
								  for (String date : datelist) {
									  Integer shopReservedCnt = trReserveDao.getUserShopReserve(wsCode, date);
									  
									  if(shopReservedCnt==0) {
										  datelistLast.add(date);
									  }
								  }
	
								  String wssReservDay = "";
								  for(String date : datelistLast) {
									  if(wssReservDay.equals("")) {
										  wssReservDay += date;
									  }else {
										  wssReservDay += ","+date;
									  }
								  }
							      UserShopVo userShopVo = new UserShopVo();
								  userShopVo.setWssReservDay(wssReservDay);
							      userShopVo.setWssStDay(datelistLast.get(0));
							      userShopVo.setWssEdDay(datelistLast.get(datelistLast.size()-1));
							      userShopVo.setCompCode(trReserve.getCompCode());
							      userShopVo.setWssReservName(memberDto.getMemName());
							      userShopVo.setWssApproval("N");
							      userShopVo.setWsCode(wsCode);
							      userShopVo.setWssRegUser(trReserve.getTcRegUser());
							      userShopVo.setMemId(memberDto.getMemId());
							      userShopVo.setMemPhone(memPhone);
							      userShopVo.setMemEmail(memEmail);
							      userShopVo.setCompPhone(compPhone);
							      userShopVo.setCompAcctName(compAcctName);
							      userShopVo.setCompAcctDept(compAcctDept);
							      userShopVo.setCompAcctEmail(compAcctEmail);
							      userShopVo.setCompAcctPhone(compAcctPhone);
	
							      userShopService.insertUserShop(userShopVo);
							      shopReserveCnt++;
							  }
						  }
						  
						//부대시설 동시 등록 끝
						}
				  
						if(shopReserveCnt==0){		
					    	memPhone = AESCrypt.encrypt(memPhone);
					    	memEmail = AESCrypt.encrypt(memEmail);	    	
					    	member.setMemPhone(memPhone);
					    	member.setMemEmail(memEmail);
					    	member.setMemCompPhone(compPhone);
					    	
					    	trReserveDao.updateMember(member);
		
					    	company.setCompPhone(compPhone);
					    	company.setCompAcctName(compAcctName);
					    	company.setCompAcctDept(compAcctDept);
					    	company.setCompAcctEmail(compAcctEmail);
					    	company.setCompAcctPhone(compAcctPhone);
		
					    	companyDao.updateCompany(company);
						}					  
					}
	        	}
	        }
    	}catch (Exception e) {
    		cnt = -100;
    		log.info("에러발생으로 rollback됨");
    	}

    	return cnt;
    }
     
    public List<TrackDto> getTrackListAll() throws Exception {    	
    	//트랙 정보 가져옴
    	return trReserveDao.getTrackListAll();
    }
    
   public List<TrackDto> getTrackList(String tUseYn) throws Exception {    	
   	//트랙 정보 가져옴
   	return trReserveDao.getTrackList(tUseYn);
   }
    
   public List<DriverDto> getDriverList(SearchDriverDto searchDriver) throws Exception {
      //운전자 정보 가져옴
	   searchDriver.setDApproval("Y");		//승인된 운전자만 가져옴
	   List<DriverDto> driverList = driverDao.getDriverList(searchDriver);

	   for(DriverDto driver : driverList) {
			String dName = AESCrypt.decrypt(driver.getDName());
	   		String dBirth = AESCrypt.decrypt(driver.getDBirth());
	   		String dEmail = AESCrypt.decrypt(driver.getDEmail());
	   		String dPhone = AESCrypt.decrypt(driver.getDPhone());
	   		String dPhone2 = AESCrypt.decrypt(driver.getDPhone2());

	   		driver.setDName(dName);
	   		driver.setDBirth(dBirth);
	   		driver.setDEmail(dEmail);
	   		driver.setDPhone(dPhone);
	   		driver.setDPhone2(dPhone2);    		
		}
      return driverList; 
   }
   
   public Integer SelectEntranceFee() throws Exception {
	   return trReserveDao.SelectEntranceFee();
   }
   
    public WeekdayDto getWeekday(SearchTrReserveDto searchTrReserve) throws Exception {		//운영일, 운영시간을 가져옴
    	searchTrReserve.setCompType("B");		//B2B
    	searchTrReserve.setTcDay(Fn.toDateFormat(searchTrReserve.getTcDay(), "yyyyMMdd"));	//날짜형식 맞춰 줌
    	String compareDay = Fn.toDateFormat(searchTrReserve.getTcDay(), "yyyy-MM-dd");

 	   int weekNum = Fn.getWeek(compareDay);
 	   
 	   WeekdayDto weekday = trReserveDao.getWeekday(searchTrReserve);
 	   
 	   if(null!=weekday && weekday.getWdDay().indexOf(Fn.toString(weekNum)) == -1) {
 		   weekday = null;
 	   }
 	   
    	return weekday;
    }
    public List<WeekdayDto> getWeekdayList(SearchTrReserveDto searchTrReserve) throws Exception {
      searchTrReserve.setCompType("b");
      return trReserveDao.getWeekdayList(searchTrReserve);
    }

    public int chkSchedule (UserShopVo userShopVo){
      int shop = shopDao.chkSchedule(userShopVo);
      int dayoff = shopDao.chkDayOff(userShopVo);
      return shop+dayoff;
    }
    
    public TrReserveDto getTrReserveDetail(SearchTrReserveDto searchTrReserve) throws Exception {
    	String tcDay = Fn.toDateFormat(searchTrReserve.getTcDay(), "yyyyMMdd");
    	searchTrReserve.setTcDay(tcDay);
    	TrReserveDto trReserve = trReserveDao.getTrReserveDetail(searchTrReserve);
    	
    	searchTrReserve.setCompCode(trReserve.getCompCode());	//운전자,차량정보 가져올 경우 내부/외부 테이블 구분하기 위해서
		
    	List<TrReserveDto> trackList = new ArrayList<TrReserveDto>(); 
    	List<CarDto> carList = new ArrayList<CarDto>();

    	if(searchTrReserve.getCompCode().equals("THINT")) {
        	trackList = trReserveDao.getTrHintTrackList(trReserve.getTcSeq());
        	carList = trReserveDao.getTrHintCarList(searchTrReserve);
    	}else {
    		trackList = trReserveDao.getTrTrackList(trReserve.getTcSeq());
        	carList = trReserveDao.getTrCarList(searchTrReserve);
    	}
    	
    	if(null!=trReserve) {
        	String tcPurpose = trReserve.getTcPurpose();
	    	String tcMemo = trReserve.getTcMemo();
	    	tcMemo = Fn.scriptFilterDec(tcMemo);
        	tcPurpose = Fn.scriptFilterDec(tcPurpose);
        	trReserve.setTcPurpose(tcPurpose);
	    	trReserve.setTcMemo(tcMemo);
	    	trReserve.setTrackInfo(trackList);
	    	trReserve.setCarInfo(carList);
    	}
    	
    	return trReserve;
    }
    
    public List<TrReserveDto> getTestScheduleEqualsTcSeq(Integer tcSeq) throws Exception {
    	return trReserveDao.getTestScheduleEqualsTcSeq(tcSeq);
    }
    
    public TrReserveDto getTestScheduleEqualsTcSeq1Row(Integer tcSeq) throws Exception {   
    	TrReserveDto trReserve = trReserveDao.getTestScheduleEqualsTcSeq1Row(tcSeq);
    	
    	String tcDay = trReserve.getTcDay();
		if(tcDay.indexOf("#")>-1) {
			tcDay = tcDay.substring(0, tcDay.indexOf("#"));
		}
		
    	SearchTrReserveDto searchTrReserve = new SearchTrReserveDto();
    	searchTrReserve.setTcSeq(trReserve.getTcSeq());
    	searchTrReserve.setTcDay(tcDay);
    	searchTrReserve.setCompCode(trReserve.getCompCode());
    	
    	List<TrReserveDto> trackList = new ArrayList<TrReserveDto>(); 
    	List<CarDto> carList = new ArrayList<CarDto>();

    	if(searchTrReserve.getCompCode().equals("THINT")) {
        	trackList = trReserveDao.getTrHintTrackList(trReserve.getTcSeq());
        	carList = trReserveDao.getTrHintCarList(searchTrReserve);
    	}else {
    		trackList = trReserveDao.getTrTrackList(trReserve.getTcSeq());
        	carList = trReserveDao.getTrCarList(searchTrReserve);	
    	}

    	trReserve.setTrackInfo(trackList);
    	trReserve.setCarInfo(carList);
    	
    	return trReserve;
    }
    
    public TrReserveDto getTrReserveExpression(TrReserveDto trReserveDto) throws Exception {
    	String tcRegDt = trReserveDto.getTcRegDt();
    	String tcPurpose = trReserveDto.getTcPurpose();
    	String tcDayArr[] = trReserveDto.getTcDay().split("#");
    	
    	tcRegDt = tcRegDt.substring(0,4)+"-"+tcRegDt.substring(4,6)+"-"+tcRegDt.substring(6,8);
    	
    	tcPurpose = Fn.scriptFilterDec(tcPurpose);    	
    	trReserveDto.setTcPurpose(tcPurpose);
    	
    	String tmpTcDay = "";
    	for(int i=0; i<tcDayArr.length; i++) {
    		String tcDay = tcDayArr[i];
    		if(i>0) {
    			tmpTcDay += "<br />";
    		}
    		tmpTcDay += tcDay.substring(0, 4)+"-"+tcDay.substring(4, 6)+"-"+tcDay.substring(6, 8);
    	}

    	trReserveDto.setTcPurpose(tcPurpose);
    	trReserveDto.setTcRegDt(tcRegDt);
    	trReserveDto.setTcDay(tmpTcDay);
    	    	
    	return trReserveDto;
    }
    
    public List<ResourceMappingDto> getHintDriverInfo(SearchTrReserveDto searchTrReserve) throws Exception {
    	List<ResourceMappingDto> rmlist = trReserveDao.getTrHintResourceMapping(searchTrReserve);
    	
    	for(int i=0; i<rmlist.size(); i++) {
			rmlist.get(i).setDName(AESCrypt.decrypt(rmlist.get(i).getDName()));
		}
    	
    	return rmlist;
    }
    
    public Map<String, Object> getDriverInfo(SearchTrReserveDto searchTrReserve) throws Exception {    	
    	Map<String, Object> driverInfo = new HashMap<String, Object>();
    	List<ResourceMappingDto> rmInfos = new ArrayList<ResourceMappingDto>(); 
    	
    	if(searchTrReserve.getCompCode().equals("THINT")) {
    		rmInfos = trReserveDao.getTrHintResourceMapping(searchTrReserve);
    	}else {
    		rmInfos = trReserveDao.getTrMyResourceMapping(searchTrReserve);;
    	}
    	
    	for(int i=0; i<rmInfos.size(); i++) {
    		System.out.println("rm size : " + rmInfos.get(i).getDName());
    		rmInfos.get(i).setDName(AESCrypt.decrypt(rmInfos.get(i).getDName()));
		}
    	
    	String driverStr = "";
    	String driverOnlyNameStr = "";
    	String wiressStr = "";
    	int i = 0;
    	String[] resourceArr = new String[rmInfos.size()];
    	
    	for(ResourceMappingDto rm : rmInfos) {
    		if(i>0) {
    			driverStr += ", ";
    			driverOnlyNameStr += ", ";
    			wiressStr += ", ";
    			
    		}
    		if(!searchTrReserve.getCompCode().equals("THINT")) {
	    		driverOnlyNameStr += rm.getDName();
				resourceArr[i++] = rm.getRId()+"#"+rm.getDName();
    		}
    		driverStr += rm.getDName()+"("+rm.getRmLevel()+" / ";
    		if(rm.getDEdu().equals("Y")) {
    			driverStr += "안전교육이수";
    		}else {
    			driverStr += "<span class=\"color_red\">안전교육미이수</span>";
    		}
    		if(null!=rm.getRId()&&rm.getRId().length()>0) {
    			driverStr += " / ";
    			driverStr += "<span class=\"color_orange\">"+rm.getRId()+"</span>";
    		}
    		
    		driverStr += ")";
    		wiressStr += rm.getWId()+" ";
    	}
    	
    	driverInfo.put("driverStr", driverStr);
    	driverInfo.put("driverOnlyNameStr", driverOnlyNameStr);
    	driverInfo.put("wiressStr", wiressStr);
    	driverInfo.put("resourceArr", resourceArr);
    	
    	return driverInfo;
    }
	
    public List<TrRfidGnrDto> getTrRfidGeneralLog(String tcReservCode) throws Exception {
    	List<TrRfidGnrDto> rfidGnrLogList = trReserveDao.getTrRfidGeneralLog(tcReservCode);
    	
    	for(int i=0; i<rfidGnrLogList.size(); i++) {
    		rfidGnrLogList.get(i).setDName(AESCrypt.decrypt(rfidGnrLogList.get(i).getDName()));
    	}
    	
    	return rfidGnrLogList;
    }
    
    public List<TrRfidDto> getTrRfidLog(String tcReservCode) throws Exception {
    	List<TrRfidDto> rfidLog = trReserveDao.getTrRfidLog(tcReservCode);
    	
    	return rfidLog;
    }
    
	/* 상태 업데이트 */
	public Integer updateApproval(TrReserveDto trReserve) throws Exception {  
		//로그인 정보
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		MemberDto memberDto = (MemberDto)authentication.getPrincipal();
		
		Integer cnt = 0;
		
		if(null!=trReserve.getTcStep() && trReserve.getTcStep().equals("00002")) {
			String tcReservCode = trReserveDao.selectTcReservCode(trReserve.getTcSeq());
			Integer countRfidLogWithoutInOutTime = trReserveDao.selectCountRfidLogWithoutInOutTime(tcReservCode);
			Integer countRfidGeneralLogWithoutInOutTime = trReserveDao.selectCountRfidGeneralLogWithoutInOutTime(tcReservCode);
			
			if(countRfidLogWithoutInOutTime>0) {
				cnt = -1;
			}else if(countRfidGeneralLogWithoutInOutTime>0){
				cnt = -2;
			}
		}
		
		if(cnt==0) {
			/* 현재 시간 설정 */
	    	Date date_now = new Date(System.currentTimeMillis());
	    	String currentTime = Fn.toDateFormat(date_now, "yyyyMMddHHmmss");
	    	String tcMemo = trReserve.getTcMemo();
	
	    	trReserve.setTcMemo(Fn.toStringHtml(tcMemo));
	    	trReserve.setTcModDt(currentTime);
	    	trReserve.setTcModUser(memberDto.getMemId());
	
			cnt = trReserveDao.updateApproval(trReserve); 
			
			SearchTrReserveDto searchTrReserve = new SearchTrReserveDto();
			searchTrReserve.setTcSeq(trReserve.getTcSeq());
			
			trReserve = trReserveDao.getTrReserveDetail(searchTrReserve);
			
			String title = "시험로 승인이 완료되었습니다.";
			Map<String, Object> tableMap = new HashMap<>();
			tableMap = emailSetting(trReserve.getTcSeq());
	
			CompanyDto company = (CompanyDto)tableMap.get("company");
			Email email = new Email();
			email.setTitle(title);
			email.setTableMap(tableMap);
			email.setBdt(null);
			email.setRcverEmail(AESCrypt.decrypt(company.getMemEmail()));
			email.setSenderId(null);
			email.setSenderName(null);
			email.setStatusCode(null);
			email.setStatusMsg(null);
			email.setErrDt(null);
			email.setRegDt(null);
				
			if(!Validity.isNull(trReserve.getTcApproval())&&cnt>0&&trReserve.getTcApproval().equals("3")) {
				emailService.SenderMail(email, "E03");			
			}else if(!Validity.isNull(trReserve.getTcApproval())&&cnt>0&&trReserve.getTcApproval().equals("2")) {
				emailService.SenderMail(email, "E04");
			}
		}
		return cnt;
	}
	
	public JSONArray makeJsonApprovalEaiHk(Integer tcSeq) throws Exception {
		List<TrReserveDto> trReserveList = trReserveDao.getTestScheduleEqualsTcSeq(tcSeq);
		
		SearchTrReserveDto searchTrReserve = new SearchTrReserveDto();
		searchTrReserve.setTcSeq(tcSeq);
		TrReserveDto trReserve = trReserveDao.getTrReserveDetail(searchTrReserve);
		CompanyDto company = getCompanyDetail(trReserveList.get(0).getCompCode());
		
		String compCode = company.getCompCode();
		String compName = company.getCompName();
		String compLicense = company.getCompLicense();
		String compPhone = company.getCompPhone();
		String compAddr = company.getCompAddr();
		String compAttrDetail = company.getCompAddrDetail();
		String compPostNo = company.getCompPostNo();
		
		MemberDto member = trReserveDao.getMemberInfo(company.getMemId());

		EaiHkDto eaiHk = new EaiHkDto();
		
        JSONArray req_array = new JSONArray();
        
		for(TrReserveDto inserttrReserve : trReserveList) {
			eaiHk.setTcSeq(trReserve.getTcSeq());
			eaiHk.setTcDay(inserttrReserve.getTcDay());
			eaiHk.setCompCode(compCode);
			eaiHk.setMemName(member.getMemName());

			JSONObject data = new JSONObject();
			data.put("COMP_NAME", compName) ;
			data.put("COMP_LICENSE", compLicense) ;
			data.put("COMP_PHONE", compPhone) ;
			data.put("COMP_ADDR", compAddr) ;
			data.put("COMP_POST_NO", compPostNo) ;
			data.put("COMP_ADDR_DETAIL", compAttrDetail);
			data.put("MEM_NAME", AESCrypt.decrypt(member.getMemName()));
			data.put("MEM_BIRTH", AESCrypt.decrypt(member.getMemBirth()));
			data.put("MEM_PHONE", AESCrypt.decrypt(member.getMemPhone()));
			data.put("IN_DATE", Fn.toDateFormat(inserttrReserve.getTcDay(), "yyyy-MM-dd"));
			data.put("IF_STATUS", "N");
			
			//System.out.println("company data " + i++ + " : " + data);;
			req_array.add(data);
		}
		
		SearchTrReserveDto searchTrReserveDto = new SearchTrReserveDto();
		searchTrReserveDto.setTcSeq(trReserve.getTcSeq());
		List<DriverDto> resourceMappingList = trReserveDao.getResourceMappingOnlyDriver(searchTrReserveDto);
		
		for(DriverDto resourceMappingDto : resourceMappingList) {
			eaiHk.setTcSeq(trReserve.getTcSeq());
			eaiHk.setTcDay(resourceMappingDto.getTcDay());
			eaiHk.setCompCode(compCode);
			eaiHk.setMemName(resourceMappingDto.getDName());

			JSONObject data = new JSONObject();
			data.put("COMP_NAME", compName) ;
			data.put("COMP_LICENSE", compLicense) ;
			data.put("COMP_PHONE", compPhone) ;
			data.put("COMP_ADDR", compAddr) ;
			data.put("COMP_POST_NO", compPostNo) ;
			data.put("COMP_ADDR_DETAIL", compAttrDetail);
			data.put("MEM_NAME", AESCrypt.decrypt(resourceMappingDto.getDName()));
			data.put("MEM_BIRTH", AESCrypt.decrypt(resourceMappingDto.getDBirth()));
			data.put("MEM_PHONE", AESCrypt.decrypt(resourceMappingDto.getDPhone()));
			data.put("IN_DATE", Fn.toDateFormat(resourceMappingDto.getTcDay(), "yyyy-MM-dd"));
			data.put("IF_STATUS", "N");

			//System.out.println("resource data " + i++ + " : " + data);
			req_array.add(data);
		}
        
		return req_array;
	}
	
	public JSONArray makeJsonCancelEaiHk(Integer tcSeq) throws Exception {
		List<TrReserveDto> trReserveList = trReserveDao.getTestScheduleEqualsTcSeq(tcSeq);
		
		SearchTrReserveDto searchTrReserve = new SearchTrReserveDto();
		searchTrReserve.setTcSeq(tcSeq);
		TrReserveDto trReserve = trReserveDao.getTrReserveDetail(searchTrReserve);
		String tcApproval = trReserve.getTcApproval();
		CompanyDto company = getCompanyDetail(trReserveList.get(0).getCompCode());
		
		String compCode = company.getCompCode();
		String compName = company.getCompName();
		String compLicense = company.getCompLicense();
		String compPhone = company.getCompPhone();
		String compAddr = company.getCompAddr();
		String compAttrDetail = company.getCompAddrDetail();
		String compPostNo = company.getCompPostNo();
		
		MemberDto member = trReserveDao.getMemberInfo(company.getMemId());

		EaiHkDto eaiHk = new EaiHkDto();
		
        JSONArray req_array = new JSONArray();
        
		for(TrReserveDto inserttrReserve : trReserveList) {
			eaiHk.setTcSeq(trReserve.getTcSeq());
			eaiHk.setTcDay(inserttrReserve.getTcDay());
			eaiHk.setCompCode(compCode);
			eaiHk.setMemName(member.getMemName());
			//같은 날짜 다른 예약이 있는지 확인, 같은 예약이 있으면 데이터 지우지 않음
			Integer otherTrackReserveCnt = trReserveDao.getCountSameDayOtherTrackReserve(eaiHk);
			
			if(!tcApproval.equals("3")&&otherTrackReserveCnt==0) {
				JSONObject data = new JSONObject();
				data.put("COMP_NAME", compName) ;
				data.put("COMP_LICENSE", compLicense) ;
				data.put("COMP_PHONE", compPhone) ;
				data.put("COMP_ADDR", compAddr) ;
				data.put("COMP_POST_NO", compPostNo) ;
				data.put("COMP_ADDR_DETAIL", compAttrDetail);
				data.put("MEM_NAME", AESCrypt.decrypt(member.getMemName()));
				data.put("MEM_BIRTH", AESCrypt.decrypt(member.getMemBirth()));
				data.put("MEM_PHONE", AESCrypt.decrypt(member.getMemPhone()));
				data.put("IN_DATE", Fn.toDateFormat(inserttrReserve.getTcDay(), "yyyy-MM-dd"));
				data.put("IF_STATUS", "D");
				
				//System.out.println("company data " + i++ + " : " + data);;
				req_array.add(data);
			}
		}
		
		SearchTrReserveDto searchTrReserveDto = new SearchTrReserveDto();
		searchTrReserveDto.setTcSeq(trReserve.getTcSeq());
		List<DriverDto> resourceMappingList = trReserveDao.getResourceMappingOnlyDriver(searchTrReserveDto);
		
		for(DriverDto resourceMappingDto : resourceMappingList) {
			eaiHk.setTcSeq(trReserve.getTcSeq());
			eaiHk.setTcDay(resourceMappingDto.getTcDay());
			eaiHk.setCompCode(compCode);
			eaiHk.setMemName(resourceMappingDto.getDName());
			//같은 날짜 다른 예약이 있는지 확인, 같은 예약이 있으면 데이터 지우지 않음
			Integer otherTrackReserveCnt = trReserveDao.getCountSameDayOtherTrackReserve(eaiHk);
			
			if(!tcApproval.equals("3")&&otherTrackReserveCnt==0) {
				JSONObject data = new JSONObject();
				data.put("COMP_NAME", compName) ;
				data.put("COMP_LICENSE", compLicense) ;
				data.put("COMP_PHONE", compPhone) ;
				data.put("COMP_ADDR", compAddr) ;
				data.put("COMP_POST_NO", compPostNo) ;
				data.put("COMP_ADDR_DETAIL", compAttrDetail);
				data.put("MEM_NAME", AESCrypt.decrypt(resourceMappingDto.getDName()));
				data.put("MEM_BIRTH", AESCrypt.decrypt(resourceMappingDto.getDBirth()));
				data.put("MEM_PHONE", AESCrypt.decrypt(resourceMappingDto.getDPhone()));
				data.put("IN_DATE", Fn.toDateFormat(resourceMappingDto.getTcDay(), "yyyy-MM-dd"));
				data.put("IF_STATUS", "D");
	
				//System.out.println("resource data " + i++ + " : " + data);
				req_array.add(data);
			}
		}
        
		return req_array;
	}
	
    public Integer updateCancelInfo(TrReserveDto trReserve, HttpServletRequest request) throws Exception {
		int cnt = 0;

		SearchTrReserveDto searchTrReserve = new SearchTrReserveDto();
				
		trReserve = trReserveDao.getTrReserveDetail(searchTrReserve);
		
    	/* 로그인 정보 가져옴 */
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		MemberDto memberDto = (MemberDto)authentication.getPrincipal();
		
		if(!trReserve.getCompCode().equals(memberDto.getCompCode())) {
			cnt = -1;
		}else {
	    	/* 현재 시간 설정 */
	    	Date date_now = new Date(System.currentTimeMillis());
	    	String currentTime = Fn.toDateFormat(date_now, "yyyyMMddHHmmss");
	    	trReserve.setTcModDt(currentTime);
				
	    	List<TrReserveDto> trackReserveList = trReserveDao.getTrTrackList(trReserve.getTcSeq());
	    	
	    	String dcCount = trReserveDao.getDcCount(trReserve.getCompCode());
	    		
			if(cnt>0) {		//취소 기간 확인해서 위약금(정산) 테이블에 insert
		    	for(TrReserveDto trackReserveInfo : trackReserveList) {
					TrPayDto trPay = new TrPayDto();
				     trPay.setCompCode(trReserve.getCompCode());
				     trPay.setPType(trackReserveInfo.getTrTrackType());
				     trPay.setPReservCode(trReserve.getTcReservCode());
				     trPay.setPDay(trackReserveInfo.getTcDay());
				     trPay.setTId(trackReserveInfo.getTrTrackCode());
				     trPay.setPUseTime(0);
				     trPay.setPApplyTime(0);
				     trPay.setPDiscount(dcCount);
				     trPay.setPProductPay(0);
				     trPay.setPPay("0");
				     
				     trReserveDao.insertAccounts(trPay);
				}
	    	}
	
			trReserve.setTcApproval("2");		//사용자 취소
			cnt = trReserveDao.updateTestSchedule(trReserve);		//예약기간과 메모 수정처리
		}
    	return cnt;
    }
	
    public Integer updateTrReserve(TrReserveDto trReserve) throws Exception {
		String tcStDt = "";
		String tcEdDt = "";
		String tcMemo = trReserve.getTcMemo();
		String days[] = new String[2];
		if(null!=trReserve.getTcDay())  
			days = trReserve.getTcDay().split("~");	// 수정하고자 하는 기간. ~ 구분자로 시작일과 마감일 분리, 형식 안 맞으면 insert 안 됨
		
    	SearchTrReserveDto searchTrReserve = new SearchTrReserveDto();
    	searchTrReserve.setTcSeq(trReserve.getTcSeq());
    	trReserve = trReserveDao.getTrReserveDetail(searchTrReserve);
    	
    	String tcStep = trReserve.getTcStep();
    			
    	tcMemo = Fn.toStringHtml(tcMemo);
    	trReserve.setTcMemo(tcMemo);
    	
		searchTrReserve.setTcDay(trReserve.getTcDay());

		int cnt = 0;
		int cntTestSchdule = 0 ; 
		int cntResource = 0 ; 
		
		if(tcStep.equals("00000")&&null!=days[0]&&null!= days[1]) {			//기간이 정상적으로 들어오지 않으면 기간수정 무효화
	    	tcStDt = days[0].trim();	//시작일
	    	tcEdDt = days[1].trim();	//마감일
	    	tcStDt = Fn.toDateFormat(tcStDt, "yyyyMMdd");
	    	tcEdDt = Fn.toDateFormat(tcEdDt, "yyyyMMdd");
	      	
	    	/* 현재 시간 설정 */
	    	Date date_now = new Date(System.currentTimeMillis());
	    	String currentTime = Fn.toDateFormat(date_now, "yyyyMMddHHmmss");
	    	trReserve.setTcModDt(currentTime);
	    	
	    	if(!trReserve.getTcDay().equals(tcStDt) || !trReserve.getTcDay2().equals(tcEdDt)) {		//예약날짜가 변경되었으면 처리
	    		trReserve.setBeforeTcDay(trReserve.getTcDay());		//변경전 날짜를 저장함
	    		trReserve.setBeforeTcDay2(trReserve.getTcDay2());	//변경전 날짜를 저장함
	    		
	    		searchTrReserve.setTcStDt(tcStDt);
				searchTrReserve.setTcEdDt(tcEdDt);

				searchTrReserve.setCompCode(trReserve.getCompCode());
				
				Integer reservedCnt = trReserveDao.getReservedCompanyInArea(searchTrReserve);
				
				if(reservedCnt>0) {
					cnt = -1;
				}
				
				if(cnt==0) {
					List<String> datelist = reserveCanList("b", tcStDt, tcEdDt, "yyyyMMdd");
					
					String startDt = datelist.get(0);
					String endDt = datelist.get(datelist.size()-1);
					
					trReserve.setTcDay(startDt);
					trReserve.setTcDay2(endDt);
					
					List<TrReserveDto> TrackReservList = trReserveDao.getTrackReserv(searchTrReserve);	//예약 트랙 정보 추출(기준일 첫째날 정보들만)
					List<ResourceMappingDto> resourceMappingList = trReserveDao.getResourceMapping(searchTrReserve);	//예약 리소스 정보 추출(기준일 첫째날 정보들만)
					
					if(TrackReservList.size()>0&&resourceMappingList.size()>0) {		//정보를 잘 담았다면 수정 전 정보를 삭제한다.
						trReserveDao.deleteTrackReserv(trReserve);
						trReserveDao.deleteResourceMapping(trReserve);
						for (String date : datelist) {
							for(TrReserveDto trackReservDto : TrackReservList) {
								trackReservDto.setTcDay(date);
							}
							cntTestSchdule = trReserveDao.insertTrackReservMap(TrackReservList);
							
							for(ResourceMappingDto resourceMappingDto : resourceMappingList) {
								resourceMappingDto.setTcDay(date);
							}
							cntResource = trReserveDao.insertResourceMappingMap(resourceMappingList);
						}
					}
				}
	    	}
			
			if(cnt==0&&cntTestSchdule>=0&&cntResource>=0) {
				cnt = trReserveDao.updateTestSchedule(trReserve);		//예약기간과 메모 수정처리
			}
		}

    	return cnt;
    }
       
    public Integer deleteTrReserve(TrReserveDto trReserve) throws Exception {
    	/* 로그인 정보 가져옴 */
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		MemberDto memberDto = (MemberDto)authentication.getPrincipal();
		
		int cnt = 0;
		
		trReserve = trReserveDao.getTestScheduleEqualsTcSeq1Row(trReserve.getTcSeq());	//예약 정보를 가져옴
		if(!trReserve.getTcApproval().equals("0")) {							//승인대기 상태가 아니면 삭제할 수 없음
			cnt = -10;
		}else if(memberDto.getMemUserType().equals("user") && !memberDto.getCompCode().equals(trReserve.getCompCode())) {
			cnt = -20;
		}

		if(cnt == 0) {
			List<TrReserveDto> reserveTrackInfoList = trReserveDao.getTrTrackList(trReserve.getTcSeq());
			
			for(TrReserveDto reserveTrackInfo : reserveTrackInfoList) {
				TrPayDto trPayDto = new TrPayDto();
				trPayDto.setCompCode(memberDto.getCompCode());
				trPayDto.setPDay(reserveTrackInfo.getTcDay());
				trPayDto.setPDiscount(null);
				trPayDto.setPPay(Fn.toString(reserveTrackInfo.getTrPrice()));
				trPayDto.setPReason("취소");
				trPayDto.setPReservCode(reserveTrackInfo.getTcReservCode());
				trPayDto.setPType("Y");
				trPayDto.setPUseTime(240);
				
				trReserveDao.insertAccounts(trPayDto);
			}

	    	/* 현재 시간 설정 */
	    	Date date_now = new Date(System.currentTimeMillis());
	    	String currentTime = Fn.toDateFormat(date_now, "yyyyMMddHHmmss");
	    	
			trReserve.setTcApproval("2");			//상태값을 취소로 변경(update)
			trReserve.setTcModUser(memberDto.getMemId());
			trReserve.setTcModDt(currentTime);
			
			cnt = trReserveDao.updateSituTestSchedule(trReserve);

		}
    	return cnt;
    }
    
    public CompanyDto getCompanyDetail(String compCode) throws Exception {
    	return companyDao.getCompanyDetail(compCode);
    }
    
    public String getDcCount(String compCode) throws Exception {
    	return trReserveDao.getDcCount(compCode);
    }
    
    public String getTcDays(Integer tcSeq) throws Exception {
    	return trReserveDao.getTcDays(tcSeq);
    }
       
    public Map<String, Object> getShopReservedList(SearchTrReserveDto searchTrReserve) throws Exception {
    	Map<String, Object> shopAll = new HashMap<String, Object>();
    	List<String> dates = new ArrayList<String>();
		String tcStDt = "";
		String tcEdDt = "";

		String days[] = searchTrReserve.getTcDay().split("~");	// ~ 구분자로 시작일과 마감일 분리, 형식 안 맞으면 insert 안 됨
		if(days.length==2) {			//기간이 정상적으로 들어오지 않으면 기간검색 무효화
			tcStDt = days[0];
			tcEdDt = days[1];
	    	tcStDt = Fn.toDateFormat(tcStDt, "yyyyMMdd");
	    	tcEdDt = Fn.toDateFormat(tcEdDt, "yyyyMMdd");
			
			searchTrReserve.setTcStDt(tcStDt);
			searchTrReserve.setTcEdDt(tcEdDt);
			
			
			List<UserShopVo> shopList = getShopList();

			for(UserShopVo shop : shopList) {

				Integer dayCnt = 0;	//검색된 총 일수
				
				try {
					SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
					Date startDate = sdf.parse(tcStDt);
					Date endDate = sdf.parse(tcEdDt);
					
					Date currentDate = startDate;
					dates = new ArrayList<String>();
					
					Calendar c = Calendar.getInstance();
					while (currentDate.compareTo(endDate) <= 0) {
						String currentDate_str = Fn.toDateFormat(currentDate, "yyyyMMdd");
						String currentDate_str2 = Fn.toDateFormat(currentDate, "yyyy-MM-dd");
						System.out.println("=============================");
						/* 1차 검사 - 부대시설 전용운영일 포함여부 */
						String canWeek = trReserveDao.getTcDayWeekday(shop.getWsCode(), currentDate_str);	//부대시설 운영기간인지 확인(1차)
						if(null!=canWeek&&!canWeek.equals("")) {		//전용운영일로 등록되어 있으면
							dates.add(sdf.format(currentDate));
						}else {
							String trWeek = trReserveDao.getTcDayWeekday("b", currentDate_str);	//시험로 운영기간인지 확인(2차)
							if(trWeek.indexOf(Fn.toString(Fn.getWeek(currentDate_str2)-1))<0) {	//운영 가능한 요일이 아니라면 금지 canWeek-1,2,3,4(월,화,수,목)
								dates.add(sdf.format(currentDate));
							}else {					
								//전용운영일에 포함된 날/요일이면
								/* 2차 검사 - 공휴일 체크 */
								Integer doCnt = trReserveDao.dayoffYn(currentDate_str);
								System.out.println(currentDate_str+")" + doCnt);
								if(doCnt>0) {		//공휴일등 운영하지 않는 날이면 금지
									dates.add(sdf.format(currentDate));
								}else {
									//운영하는 날이면 다른 업체예약내역(승인대기, 승인완료)이 있는지 체크
									int shopCnt = trReserveDao.getUserShopReserve(shop.getWsCode(), currentDate_str);
									if(shopCnt>0) {		//예약내역이 있으면
										dates.add(sdf.format(currentDate));
									}
								}
							}
						}
						c.setTime(currentDate);
						c.add(Calendar.DAY_OF_MONTH, 1);
						currentDate = c.getTime();
						
						dayCnt++;
						
				    	/* 현재 시간 설정 */
				    	Date date_now = new Date(System.currentTimeMillis());
				    	String currentTime = Fn.toDateFormat(date_now, "yyyyMMdd");
				    	
				    	if(dates.indexOf(currentTime)<0) {
				    		dates.add(currentTime);
				    		dayCnt++;
				    	}
				    	
						System.out.println("=============================");
					}
				}catch (Exception e) {
					e.printStackTrace();
				}
				//System.out.println("=========");
				//System.out.println(shop.getWsCode()+ " : "+dates);
				//System.out.println("cnt"+shop.getWsCode()+" : "+dayCnt);
				//System.out.println("dates.size() : "+dates.size());
				//System.out.println("dates : "+dates);
				//System.out.println("=========");	
				
				shopAll.put(shop.getWsCode(), dates);
				shopAll.put("cnt"+shop.getWsCode(), dayCnt - dates.size());
			}			
		}

    	return shopAll;
    }
    
	 public Map<String, Object> getShopCanList(SearchTrReserveDto searchTrReserve) throws Exception {		
		
	 	Map<String, Object> shopAll = new HashMap<String, Object>();
	 	List<String> dates = new ArrayList<String>();
			String tcStDt = "";
			String tcEdDt = "";
	
			String days[] = searchTrReserve.getTcDay().split("~");	// ~ 구분자로 시작일과 마감일 분리, 형식 안 맞으면 insert 안 됨
			if(days.length==2) {			//기간이 정상적으로 들어오지 않으면 기간검색 무효화
				tcStDt = days[0];
				tcEdDt = days[1];
		    	tcStDt = Fn.toDateFormat(tcStDt, "yyyyMMdd");
		    	tcEdDt = Fn.toDateFormat(tcEdDt, "yyyyMMdd");
				
				searchTrReserve.setTcStDt(tcStDt);
				searchTrReserve.setTcEdDt(tcEdDt);

		    	/* 로그인 정보 가져옴 */
		    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
				MemberDto memberDto = (MemberDto)authentication.getPrincipal();
				
				searchTrReserve.setCompCode(memberDto.getCompCode());
				
				Integer reservedCnt = trReserveDao.getReservedCompanyInArea(searchTrReserve);
				
				if(reservedCnt>0) {
					shopAll.put("error", "cannot");
				}else {
					List<UserShopVo> shopList = getShopList();
		
					for(UserShopVo shop : shopList) {
		
						try {
							SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
							Date startDate = sdf.parse(tcStDt);
							Date endDate = sdf.parse(tcEdDt);
							
							Date currentDate = startDate;
							dates = new ArrayList<String>();
							
							Calendar c = Calendar.getInstance();
							while (currentDate.compareTo(endDate) <= 0) {
								String currentDate_str = Fn.toDateFormat(currentDate, "yyyyMMdd");
								String currentDate_str2 = Fn.toDateFormat(currentDate, "yyyy-MM-dd");
								/* 1차 검사 - 부대시설 전용운영일 포함여부 */
								String canWeek = trReserveDao.getTcDayWeekday(shop.getWsCode(), currentDate_str);	//부대시설 운영기간인지 확인(1차)
								if(null==canWeek||canWeek.equals("")) {		//전용운영일로 등록되어 있지 않으면
									String trWeek = trReserveDao.getTcDayWeekday("b", currentDate_str);	//시험로 운영기간인지 확인(2차)
									
									if(null!=trWeek&&!"".equals(trWeek) && trWeek.indexOf(Fn.toString(Fn.getWeek(currentDate_str2)-1))>=0) {	//운영 가능한 요일이라면 허용 canWeek-1,2,3,4(월,화,수,목)					
										//전용운영일에 포함된 날/요일이면
										/* 2차 검사 - 공휴일 체크 */
										Integer doCnt = trReserveDao.dayoffYn(currentDate_str);
										
										if(doCnt==0) {		//공휴일이 아니라면
											//운영하는 날이면 다른 업체예약내역(승인대기, 승인완료)이 있는지 체크
											int shopCnt = trReserveDao.getUserShopReserve(shop.getWsCode(), currentDate_str);
											if(shopCnt==0) {		//예약내역이 없으면
												dates.add(sdf.format(currentDate));
											}
										}
									}
								
								}
								c.setTime(currentDate);
								c.add(Calendar.DAY_OF_MONTH, 1);
								currentDate = c.getTime();
							}
						}catch (Exception e) {
							e.printStackTrace();
						}
						//System.out.println("=========");
						//System.out.println(shop.getWsCode()+ " : "+dates);
						//System.out.println("cnt"+shop.getWsCode()+" : "+dayCnt);
						//System.out.println("dates.size() : "+dates.size());
						//System.out.println("dates : "+dates);
						//System.out.println("=========");	
						
						shopAll.put(shop.getWsCode(), dates);
						shopAll.put("cnt"+shop.getWsCode(), dates.size());
					}
				}
			}
	
	 	return shopAll;
	 }
    
	public List<String> reserveCanList(String kind, String tcStDt, String tcEdDt, String DATE_PATTERN) throws Exception {
		List<String> dates = new ArrayList<String>();
		
		try {
			SimpleDateFormat sdf = new SimpleDateFormat(DATE_PATTERN);
			Date startDate = sdf.parse(tcStDt);
			Date endDate = sdf.parse(tcEdDt);
	
			Date currentDate = startDate;
	
			Calendar c = Calendar.getInstance();
			
			while (currentDate.compareTo(endDate) <= 0) {
				String currentDate_str = Fn.toDateFormat(currentDate, "yyyyMMdd");
				
				/* 1차 검사 - B2B가 운영하는 요일 체크 */
				//해당일이 포함된 쉼표구분으로 요일정보를 가져옴(0-일, 1-월, 2-화, 3-수, 4-목, 5-금, 6-토) ex) 2,3,4,5
				String canWeek = trReserveDao.getTcDayWeekday(kind, currentDate_str);
				int weekday = Fn.getWeek(Fn.toDateFormat(currentDate, "yyyy-MM-dd"))-1;

				//System.out.println("currentDate_str : " + currentDate_str  +"canWeek : " + canWeek +"weekday : " + weekday);
				
				if(null!=canWeek&&canWeek!="" && canWeek.indexOf(Fn.toString(weekday))>-1) {	//전용운영일에 포함된 날/요일이면
					/* 2차 검사 - 공휴일 체크 */
					Integer doCnt = trReserveDao.dayoffYn(currentDate_str);
					
					if(doCnt==0) {		//공휴일이 아니면 추가
						dates.add(sdf.format(currentDate));
					}
				
				}
				c.setTime(currentDate);
				c.add(Calendar.DAY_OF_MONTH, 1);
				currentDate = c.getTime();	
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return dates;
	}
	
	public List<String> getDateList(String inputStartDate, String inputEndDate, String DATE_PATTERN) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat(DATE_PATTERN);
		List<String> dates = new ArrayList<String>();
		
		try {
			Date startDate = sdf.parse(inputStartDate);
			Date endDate = sdf.parse(inputEndDate);
			Date currentDate = startDate;
			
			Calendar c = Calendar.getInstance();
			
			while (currentDate.compareTo(endDate) <= 0) {
				dates.add(sdf.format(currentDate));
				c.setTime(currentDate);
				c.add(Calendar.DAY_OF_MONTH, 1);
				currentDate = c.getTime();
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		return dates;
	}
	
	public List<UserShopVo> getShopList() throws Exception {
		return trReserveDao.getShopList();
	}
	
	
	public Map<String, Object>  emailSetting(Integer tcSeq) throws Exception {
		Map<String, Object> tableMap = new HashMap<>();
		SearchTrReserveDto searchTrReserve = new SearchTrReserveDto();
		
		TrReserveDto trReserve = getTestScheduleEqualsTcSeq1Row(tcSeq);
		
		String tcDay = trReserve.getTcDay();
		if(tcDay.indexOf("#")>-1) {
			tcDay = tcDay.substring(0, tcDay.indexOf("#"));
		}
		trReserve = getTrReserveExpression(trReserve);
		String tcPurpose = trReserve.getTcPurpose();
		tcPurpose = tcPurpose.replace("\n", "<br />");
		trReserve.setTcPurpose(tcPurpose);

		List<CarDto> carList = trReserve.getCarInfo();
		String carStr = "";
		for(int i=0; i<carList.size(); i++) {
			CarDto car = carList.get(i);
			if(i>0) {
				carStr += "<br />";
			}
			carStr += car.getCVender()+" "+car.getCName()+" / "+car.getCColor()+" / "+car.getCNumber();
		}
		searchTrReserve.setTcSeq(trReserve.getTcSeq());
		searchTrReserve.setTcDay(tcDay);
		searchTrReserve.setCompCode(trReserve.getCompCode());
    	
		Map<String, Object> driverInfo = getDriverInfo(searchTrReserve);

		CompanyDto company = new CompanyDto();
		company = getCompanyDetail(trReserve.getCompCode());
		//company = companyService.getCompanyDetailExpression(company);

		company.setMemName(AESCrypt.decrypt(company.getMemName()));
		company.setMemPhone(AESCrypt.decrypt(company.getMemPhone()));
		company.setMemEmail(company.getMemEmail());
		
		String driverStr = (String) driverInfo.get("driverStr");
		String driverOnlyNameStr = (String) driverInfo.get("driverOnlyNameStr");
		String wiressStr = (String) driverInfo.get("wiressStr");
		String[] resourceArr = (String[]) driverInfo.get("resourceArr");
		
		String resource = "";
		
		for(int i=0; i<resourceArr.length; i++) {
			resource += resourceArr[i];
		}

		tableMap.put("trReserve", trReserve);
		tableMap.put("driver", driverStr);
		tableMap.put("driverOnlyName", driverOnlyNameStr);
		tableMap.put("car", carStr);
		tableMap.put("wiress", wiressStr);
		tableMap.put("resource", resource);
		tableMap.put("company", company);
	
		return tableMap;
	}
	
	public Integer eaiInsert(JSONArray jsonArray) throws Exception {
		Integer cnt = 0;
		for (int i=0; i<jsonArray.size(); i++) {
			JSONObject obj = (JSONObject)jsonArray.get(i);

			EaiHkDto eaiHk = new EaiHkDto();
			eaiHk.setCompName((String)obj.get("COMP_CODE"));
			eaiHk.setCompLicense((String)obj.get("COMP_LICENSE"));
			eaiHk.setCompPhone((String)obj.get("COMP_PHONE"));
			eaiHk.setCompAddr((String)obj.get("COMP_ADDR"));
			eaiHk.setCompPostNo((String)obj.get("COMP_POST_NO"));
			eaiHk.setCompAttrDetail((String)obj.get("COMP_ADDR_DETAIL"));
			eaiHk.setMemName((String)obj.get("MEM_NAME"));
			eaiHk.setMemBirth((String)obj.get("MEM_BIRTH"));
			eaiHk.setMemPhone((String)obj.get("MEM_PHONE"));
			eaiHk.setInDate((Date)obj.get("IN_DATE"));
			
			cnt = trReserveDao.insertEaiHk(eaiHk); 
		}
		
		return cnt;
	}
}

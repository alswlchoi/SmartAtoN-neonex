package com.hankook.pg.content.admin.trReserve.dao;
 
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.hankook.pg.content.admin.car.dto.CarDto;
import com.hankook.pg.content.admin.dayoff.dto.DayoffDto;
import com.hankook.pg.content.admin.driver.dto.DriverDto;
import com.hankook.pg.content.admin.driver.dto.SearchDriverDto;
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
import com.hankook.pg.content.member.dto.MemberDto;
import com.hankook.pg.content.user.userShop.vo.UserShopVo;

@Repository
@Mapper
public interface TrReserveDao {
	/* 목록 */
    List<TrReserveDto> getTrReserveList(SearchTrReserveDto searchTrReserve) throws Exception;

	//정산-부대시설-목록 
    List<ChargeDto> getList(ChargeDto chargeDto) throws Exception;
    
    //정산-부대시설-페이징
    int getListCnt(ChargeDto chargeDto) throws Exception;
    
    //정산-부대시설-디테일
    ChargeDto detailList(ChargeDto ChargeDto) throws Exception;
    
    //정산-시험로-시험정보
    List<ChargeDto> testInfo(ChargeDto chargeDto) throws Exception;
    
    //정산-시험로-차량정보
    List<ChargeDto> carInfo(ChargeDto chargeDto) throws Exception;
    
    //정산-시험로-정산
    List<ChargeDto> chargeInfo(ChargeDto chargeDto) throws Exception;
    
    //정산 - 부대시설 -정산
    ChargeDto shopInfo(ChargeDto chargeDto) throws Exception;
    
    //정산-시험로-차량정보
    List<ChargeDto> test_Info(ChargeDto chargeDto) throws Exception;
    
    //정산-시험로 목록
    List<SearchTrReserveDto> accountList(SearchTrReserveDto searchTrReserve) throws Exception;
    
    //정산-시험로-페이징
    int accountCnt(SearchTrReserveDto searchTrReserve) throws Exception;
    
    //시험로-상세 (1)
    ChargeDto accountDetaillist(String tcReservCode) throws Exception;
    
    //실제사용일
    String realday(ChargeDto chargeDto);
    
    //실제사용일 부대시설
    String realdate(ChargeDto chargeDto);
    
    /* 달력용 */
    List<TrReserveDto> selectTrCalendar(SearchTrReserveDto searchTrReserveDto);
    
    /* 달력용 날짜별 상태 카운터 */
    String selectTrCalendarCount(String tcDay);
    
    /* 검색결과 갯수 반환(admin) */
    Integer findTrReserveCount(SearchTrReserveDto searchTrReserve) throws Exception;
        
    /* 트랙 추가할 때 기존에 예약된 트랙인지 확인 */
    Integer getCountReserveTrack(SearchTrReserveDto searchTrReserve) throws Exception;
    
    /* 로그 추가할 때 기존에 사용된 시간인지 확인(GNR용) */
    Integer getCountGnrLog(TrRfidGnrDto rfidLog) throws Exception;
    
    /* 로그 추가할 때 기존에 사용된 시간인지 확인 */
    Integer getCountRfidLog(TrRfidDto rfidLog) throws Exception;
    
    /* 로그 추가할 운전자 태그아이디 1개 추출 */
    String getMaxDriverTagIdForRfidLog(Integer tcSeq) throws Exception;
    
    /* 예약된 트랙 중 1개만 추출(임의) - 복사용 */
    String getReserveTrackMax(Integer tcSeq) throws Exception;

    /* 리소스 매핑 자료 구하기 */
    List<ResourceMappingDto> getTrMyResourceMapping(SearchTrReserveDto searchTrReserve) throws Exception;
    
    /* 리소스 매핑 자료 구하기(힌트 운전자) */
    List<ResourceMappingDto> getTrHintResourceMapping(SearchTrReserveDto searchTrReserve) throws Exception;
    
    /* GNR 시험관리 RFID 출입내역 */
    List<TrRfidGnrDto> getTrRfidGeneralLog(String tcReservCode) throws Exception;
    
    /* 시험로 시험관리 RFID 출입내역 */
    List<TrRfidDto> getTrRfidLog(String tcReservCode) throws Exception;
    
    /* 공동/단독 여부 (TYP00 : 공동, TYP01 : 단독) */
    String getKindSM(Integer tcSeq) throws Exception;
        
    /* 예약된 트랙/시간 반환 */
    List<TrReserveDto> getReservedTime(String tcDay) throws Exception;
        
    /* 고유데이터 존재유무 */
    Integer getCompCodeduplCheck(Integer trSeq) throws Exception;
    
    /* 예약된 트랙 정보 */
    List<TrReserveDto> getTrackReserv(SearchTrReserveDto searchTrReserve) throws Exception;
    
    /* 예약된 리소스 정보 */
    List<ResourceMappingDto> getResourceMapping(SearchTrReserveDto searchTrReserve) throws Exception;
    
    /* 예약된 리소스 정보(운전자정보만) */
    List<DriverDto> getResourceMappingOnlyDriver(SearchTrReserveDto searchTrReserve) throws Exception;
    
    /* 예약된 트랙 정보 입력 */
    Integer insertTrackReservMap(List<TrReserveDto> resourceMappingList) throws Exception;
    
    /* 예약코드 추출 */
    String selectTcReservCode(Integer tcSeq) throws Exception;
    
    /* RFID 로그 중 시간 없는 데이터 개수 추출 */
    Integer selectCountRfidLogWithoutInOutTime(String tcReservCode);
    
    /* RFID 로그 중 시간 없는 데이터 개수 추출 */
    Integer selectCountRfidGeneralLogWithoutInOutTime(String tcReservCode);
    
    /* 예약된 리소스 정보 입력 */
    Integer insertResourceMappingMap(List<ResourceMappingDto> resourceMappingList) throws Exception;
    
    /* 정산데이터 존재유무 */
    Integer getAccountYn(String pReservCode) throws Exception;
    
    /* 트랙별 현재 예약 개수 */
    Integer getCurrentReserveCnt(String tcDay, String trTrackCode) throws Exception;

    //예약하려는 업체의 중복기간 데이터 확인
    int getReservedCompanyInArea(SearchTrReserveDto searchTrReserve) throws Exception;
    
    /* 휴일 여부 */
    Integer dayoffYn(String tcDay) throws Exception;
    
    /* 휴일 여부 */
    List<DayoffDto> dayoffList(String doKind) throws Exception;
    
    /* 해당 요일 여부 */
    String getTcDayWeekday(String wdKind, String tcDay) throws Exception;
    
    /* 예약당 가장 비싼 트랙 요금 */
    Integer getTrMaxPrice(Integer tcDay) throws Exception;
    
    /* 가장 큰 코드의 숫자를 가져옴 */
    String getMaxReserveCode(String tcReservCode) throws Exception;
    
    /* tcDay#tcDay2 형식으로 가져옴 */
    String getTcDays(Integer tcSeq) throws Exception;
    
    /* 가장 큰 코드의 숫자를 가져옴(차량) */
    String getMaxCarCode() throws Exception;
    
    /* 트랙 예약 등록 */
    Integer insertTrReserve(TrReserveDto trReserve) throws Exception;
    
    /* 트랙 예약 복사(tcDay 같은 날 1일치 추출 후 트랙정보 변경 */
    Integer addtrackInfoToReservedInfo(TrReserveDto trReserve) throws Exception;
    
    /* 수동 시간 변경을 위해 GNR 로그 1row 가져옴 */
    TrRfidGnrDto getRfidGnrLog1Row(Integer prgNo) throws Exception;
    
    /* 수동 시간 변경을 위해 로그 1row 가져옴 */
    TrRfidDto getRfidLog1Row(Integer rlSeq) throws Exception;
    
    /* 수동으로 입력받은 입출차 내역 추가(GNR) */
    Integer addGnrLog(TrRfidGnrDto rfidLog) throws Exception;
    
    /* 수동으로 입력받은 입출차 내역 추가 */
    Integer addRfidLog(TrRfidDto rfidLog) throws Exception;
    
    /* 수동으로 입력받은 입출차 시간 변경(GNR Gate */
    Integer updateRfidGnrLog(TrRfidGnrDto rfidGnrLog) throws Exception;
    
    /* 수동으로 입력받은 입출차 시간 변경 */
    Integer updateRfidLog(TrRfidDto rfidLog) throws Exception;
    
    /* 차량 등록 */
    Integer insertCar(CarDto car) throws Exception;
    
    /* 기준일 정보 외 나무지 정보 입력(1일씩 Loop 돌면서) */
    Integer insertTrReservePart(TrReserveDto trReserve) throws Exception;

    /* 등록(mapping) */
    Integer insertTestSchedule(TrReserveDto trReserve) throws Exception;
    
    /* 등록(자원 mapping) */
    Integer insertResourceMapping(TrReserveDto trReserve) throws Exception;
    
    /* 등록(자원 mapping) */
    Integer insertResourceMappingPart(TrReserveDto trReserve) throws Exception;
    
    /* 상세보기(admin) */
    TrReserveDto getTrReserveDetail(SearchTrReserveDto searchTrReserve) throws Exception;

    /* 예약건별 트랙정보(힌트) */
    List<TrReserveDto> getTrHintTrackList(Integer tcSeq) throws Exception;
    
    /* 예약건별 트랙정보 */
    List<TrReserveDto> getTrTrackList(Integer tcSeq) throws Exception;
    
    /* 예약건별 시험차량 정보 */
    List<CarDto> getTrCarList(SearchTrReserveDto searchTrReserve) throws Exception;
    
    /* 예약당 차량 정보 구하기(T-HINT) */
    List<CarDto> getTrHintCarList(SearchTrReserveDto searchTrReserve) throws Exception;
    
    /* 상세보기(user) */
    List<TrReserveDto> getTestScheduleEqualsTcSeq(Integer tcSeq) throws Exception;
    
    /* 상세보기(user) */
    TrReserveDto getTestScheduleEqualsTcSeq1Row(Integer tcSeq) throws Exception;
        
    /* 수정 */
    Integer updateTestSchedule(TrReserveDto trReserve) throws Exception;
    
    
    /* 기준일 정보 외 나무지 정보 삭제 */
    Integer deleteTrMappingInfoPart(TrReserveDto trReserve) throws Exception;
        
    /* 수정(예약된 트랙 정보) */
    Integer updateTrackReserv(TrReserveDto trReserve) throws Exception;

    /* 기준일 정보 외 나무지 정보 삭제 */
    Integer deleteTrReservePart(TrReserveDto trReserve) throws Exception;
    
    /* 수정(예약된 자원 정보) */
    Integer updateResourceMapping(TrReserveDto trReserve) throws Exception;
    
    /* 승인 또는 반려/취소 처리 */
    Integer updateApproval(TrReserveDto trReserve) throws Exception;

    /* 같이 공동/단독 예약여부 확인 */
    Integer getCountSameDayOtherTrackReserve(EaiHkDto eaiHk) throws Exception;
    
    /* 정산데이터 입력 */
    Integer insertAccounts(TrPayDto trPay) throws Exception;
    
    /* 예약트랙정보삭제 (tcSeq로 삭제) */
    Integer deleteTrackReserv(TrReserveDto trReserve) throws Exception;
    
    /* 예약트랙정보삭제 (tcSeq와 tcDay(tempDay)로 삭제) */
    Integer deleteTrReserve2(TrReserveDto trReserve) throws Exception;

    /* 삭제(mapping) (tcSeq로 삭제) */
    Integer deleteResourceMapping(TrReserveDto trReserve) throws Exception;
    
    /* 삭제(mapping) (tcSeq와 tcDay(tempDay)로 삭제) */
    Integer deleteTrMappingInfo2(TrReserveDto trReserve) throws Exception;
    
    /* 타이어관리정보삭제 */
    Integer deleteTireManagement(TrReserveDto trReserve) throws Exception;
    
    /* 예약정보삭제 */
    Integer deleteTestSchedule(TrReserveDto trReserve) throws Exception;
    
    /* 예약정보 상태를 변경 */
    Integer updateSituTestSchedule(TrReserveDto trReserve) throws Exception;
    
    /* 회원정보 수정 */
    Integer updateMember(MemberDto member) throws Exception;
    
    //삭제 대상(아래로)

    //트랙(all) 정보 가져옴
    List<TrackDto> getTrackListAll() throws Exception;

	/* 입장료 추출 */
	Integer SelectEntranceFee() throws Exception;
    
    //트랙(Y or N) 정보 가져옴
    List<TrackDto> getTrackList(String tUseYn) throws Exception;
    
    //트랙(1개만) 정보 가져옴
    TrackDto getTrackInfo(String trTrackCode) throws Exception;
    
    //회사 소속 운전자 정보 가져옴
    List<DriverDto> getDriverList(SearchDriverDto searchDriver) throws Exception;
    
    //운영일 조회
    WeekdayDto getWeekday(SearchTrReserveDto searchTrReserve) throws Exception;
    
    //운영일 조회(목록)
    List<WeekdayDto> getWeekdayList(SearchTrReserveDto searchTrReserve) throws Exception;

    Integer chkSchedule(SearchTrReserveDto searchTrReserve) throws Exception;
    
    Integer chkDayOff(SearchTrReserveDto searchTrReserve) throws Exception;

    //업체별 할인율
    String getDcCount(String compCode) throws Exception;
    
    //워크샵동 예약 내역
    List<UserShopVo> getShopReservedList(SearchTrReserveDto searchTrReserve) throws Exception;
    
    //워크샵동 예약 내역(작업 완료 후 확인하고 삭제 여부 확인-기능 부족한 듯)
    Integer getUserShopReserve(String wsCode, String tcDay) throws Exception;
    
    //회원정보를 수정하기 위해 정보를 가져옴
    MemberDto getMemberInfo(String memId) throws Exception;
    
    /* 부대시설 사용중인 전체목록  */
    List<UserShopVo> getShopList() throws Exception;
    
    /* 방문자데이터 입력 */
    Integer insertEaiHk(EaiHkDto eaiHk) throws Exception;
    
    void addTrackCapa(String trackId) throws Exception;
    
    void minusTrackCapa(String trackId) throws Exception;
}
package com.hankook.pg.content.user.myPageCalculate.service;

import com.hankook.pg.content.admin.trReserve.dto.TrPayDto;
import com.hankook.pg.content.user.myPageCalculate.dao.CalDao;
import com.hankook.pg.content.user.myPageCalculate.vo.CalToPay;
import com.hankook.pg.content.user.myPageCalculate.vo.CalVo;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service("CalService")
@Slf4j
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class CalServiceImpl implements CalService{
	@Autowired
	private CalDao calDao;

	@Override
	public List<CalVo> searchList(CalVo calVo) throws Exception {
		return calDao.searchList(calVo);
	}

	@Override
	public int searchListCnt(CalVo calVo) throws Exception {
		return calDao.searchListCnt(calVo);
	}

	@Override
	public List<CalVo> getOne(String[] codeArr) throws Exception {
		return calDao.getOne(codeArr);
	}

	@Override
	public List<CalVo> getRfidLogList(String[] codeArr) throws Exception {
		return calDao.getRfidLogList(codeArr);
	}

	/**
	 * insertPay
	 * RFID_LOG 읽어서 PG_PAY에 INSERT
	 * */
	@Override
	public int insertPay(String reservCode) throws Exception {
		int defaultTime = 240;//기준 시간 240분

		CalToPay vo = new CalToPay();//조회할 vo
		vo.setTcReservCode(reservCode);

		//기본요금
		int defaultPrice = calDao.getGnrPrice();
		//중간중간에 담아둘 map
		Map<String,List<TrPayDto>> map = new LinkedHashMap<String,List<TrPayDto>>();


		System.out.println("예약번호 : "+reservCode);

		//해당 예약번호가 단독인지 공동인지 조회
		String trTrackType = calDao.getTrTrackType(reservCode);
		System.out.println("공동구분 : "+trTrackType);
		//일자 조회
		List<String> tcDayList = calDao.getTcDayList(reservCode);

		//해당 일자만큼 공동 단독 구분하여 리스트 생성
		for(int i=0;i<tcDayList.size();i++) {
			System.out.println("일자 : "+tcDayList.get(i).toString());
			if(trTrackType.equals("TYP00")) {//공동이면
				//기본4시간 리스트 담을 것 생성
				map.put("1_"+tcDayList.get(i)+"_DEFAULT", new ArrayList<TrPayDto>());
				//초과시간 리스트 담을 것 생성
				map.put("2_"+tcDayList.get(i)+"_ADD", new ArrayList<TrPayDto>());
			}else {//단독
				//단독 리스트 담을 것 생성
				map.put("1_"+tcDayList.get(i)+"_SOLO", new ArrayList<TrPayDto>());
			}
			//기본요금 추가 (2021-12-24) 일자 * 제네럴 출입 차량 대수 * 기본 요금
			map.put("1_"+tcDayList.get(i)+"_GNR", new ArrayList<TrPayDto>());

			vo.setTcDay(tcDayList.get(i));
			//rfid로그 테이블 기준으로 가져온 정보(해당일자 기준)
			List<CalToPay> rfidLog = calDao.getRfidLogToPay(vo);
			int sum = 0;
			int beforesum = 0;
			int maxPay = 0;//가격이 가장 높은 트랙의 가격
			String maxTrack = null;
			if(rfidLog!=null) {
				for(int j =0;j<rfidLog.size();j++) {
					System.out.println("-----rfid------"+j);
					System.out.println(rfidLog.get(j));
					TrPayDto pay = new TrPayDto();

					if(trTrackType.equals("TYP00")) {//공동
						if(sum<=defaultTime) {//기본시간이내
							//sum에 차이시간 누적
							beforesum = sum;
							sum += rfidLog.get(j).getDiffTime();
							//누적 했을 때 기본시간 넘는지 여부
							if(sum<=defaultTime) {//넘지 않을때
								//같은트랙이 있는지 찾기
								boolean exist=false;
								int existNum = 0;
								for(int k=0; k<map.get("1_"+tcDayList.get(i)+"_DEFAULT").size();k++) {
									if(rfidLog.get(j).getTId().equals(map.get("1_"+tcDayList.get(i)+"_DEFAULT").get(k).getTId())) {
										exist = true;
										existNum = k;
									}
								}
								if(exist) {//존재 할 때
									map.get("1_"+tcDayList.get(i)+"_DEFAULT").get(existNum).setPUseTime(map.get("1_"+tcDayList.get(i)+"_DEFAULT").get(existNum).getPUseTime()+rfidLog.get(j).getDiffTime());
								}else {//아닐 때
									pay.setCompCode(rfidLog.get(j).getCompCode());//회사코드
									pay.setPType(rfidLog.get(j).getTrTrackType());//유형 TYP00공동 else 단독
									pay.setPReservCode(rfidLog.get(j).getTcReservCode());//예약코드
									pay.setPDay(rfidLog.get(j).getTcDay());//사용일
									pay.setPReason(null);
									pay.setTId(rfidLog.get(j).getTId());//트랙아이디
									pay.setPUseTime(rfidLog.get(j).getDiffTime());//실제사용시간
									pay.setPDiscount(rfidLog.get(j).getDcCount());//할인율
									pay.setPProductPay(rfidLog.get(j).getTrPrice());//공급가
									//처음 넣는거는 적용시간 0에 합계0으로 넣고 밑에서 가장 비싼 트랙에만 수치 적용
									pay.setPApplyTime(0);//적용시간
									pay.setPPay("0");//합계 = 공급가 *적용시간(100-할인율)/100
									pay.setPPayType("DEFAULT");
									if(rfidLog.get(j).getTrPrice()>maxPay) {
										maxPay=rfidLog.get(j).getTrPrice();
										maxTrack = rfidLog.get(j).getTId();
									}
									map.get("1_"+tcDayList.get(i)+"_DEFAULT").add(pay);
								}
							}else {//넘을때
								//넘으면 넘는만큼 잘라서 default와 add에 각각 추가
								//같은트랙이 있는지 찾기
								System.out.println("넘을때");
								System.out.println("before = "+beforesum);
								System.out.println("sum = "+sum);
								TrPayDto pay2 = new TrPayDto();
								boolean exist=false;
								int existNum = 0;
								for(int k=0; k<map.get("1_"+tcDayList.get(i)+"_DEFAULT").size();k++) {
									if(rfidLog.get(j).getTId().equals(map.get("1_"+tcDayList.get(i)+"_DEFAULT").get(k).getTId())) {
										exist = true;
										existNum = k;
									}
								}
								if(exist) {//존재 할 때
									map.get("1_"+tcDayList.get(i)+"_DEFAULT").get(existNum).setPUseTime(map.get("1_"+tcDayList.get(i)+"_DEFAULT").get(existNum).getPUseTime()+(defaultTime-beforesum));
								}else {//아닐 때
									if((defaultTime-beforesum)>0) {
										System.out.println("de-before = "+(defaultTime-beforesum));
										pay2.setCompCode(rfidLog.get(j).getCompCode());//회사코드
										pay2.setPType(rfidLog.get(j).getTrTrackType());//유형 TYP00공동 else 단독
										pay2.setPReservCode(rfidLog.get(j).getTcReservCode());//예약코드
										pay2.setPDay(rfidLog.get(j).getTcDay());//사용일
										pay2.setPReason(null);
										pay2.setTId(rfidLog.get(j).getTId());//트랙아이디
										pay2.setPUseTime(defaultTime-beforesum);//실제사용시간
										pay2.setPDiscount(rfidLog.get(j).getDcCount());//할인율
										pay2.setPProductPay(rfidLog.get(j).getTrPrice());//공급가
										//처음 넣는거는 적용시간 0에 합계0으로 넣고 밑에서 가장 비싼 트랙에만 수치 적용
										pay2.setPApplyTime(0);//적용시간
										pay2.setPPay("0");//합계 = 공급가 *적용시간(100-할인율)/100
										pay2.setPPayType("DEFAULT");
										if(rfidLog.get(j).getTrPrice()>maxPay) {
											maxPay=rfidLog.get(j).getTrPrice();
											maxTrack = rfidLog.get(j).getTId();
										}
										map.get("1_"+tcDayList.get(i)+"_DEFAULT").add(pay2);
									}
								}
								///////////////////////////////////////
								System.out.println("de-before = "+(sum-defaultTime));
								pay.setCompCode(rfidLog.get(j).getCompCode());//회사코드
								pay.setPType(rfidLog.get(j).getTrTrackType());//유형 TYP00공동 else 단독
								pay.setPReservCode(rfidLog.get(j).getTcReservCode());//예약코드
								pay.setPDay(rfidLog.get(j).getTcDay());//사용일
								pay.setPReason(null);
								pay.setTId(rfidLog.get(j).getTId());//트랙아이디
								pay.setPUseTime(sum-defaultTime);//실제사용시간
								pay.setPDiscount(rfidLog.get(j).getDcCount());//할인율
								pay.setPProductPay(rfidLog.get(j).getTrPriceAdd());//공급가
								int apply = 0;
								if((sum-defaultTime)%60>0) {
									apply = ((sum-defaultTime)/60+1)*60;
								}else {
									apply = ((sum-defaultTime)/60)*60;
								}
								pay.setPApplyTime(apply);//적용시간
								pay.setPPayType("ADD");
								double paySum= apply/60 * rfidLog.get(j).getTrPriceAdd()
										* ((100-Integer.parseInt(rfidLog.get(j).getDcCount()))
										/100.0);
								pay.setPPay(Double.toString(paySum));//합계 = 공급가 *적용시간(100-할인율)/100
								map.get("2_"+tcDayList.get(i)+"_ADD").add(pay);
							}

						}else {//기본시간 초과
							//초과리스트에 같은 트랙 있는지 검사
							boolean exist=false;
							int existNum = 0;
							for(int k=0; k<map.get("2_"+tcDayList.get(i)+"_ADD").size();k++) {
								if(rfidLog.get(j).getTId().equals(map.get("2_"+tcDayList.get(i)+"_ADD").get(k).getTId())) {
									exist = true;
									existNum = k;
								}
							}
							if(exist) {
								//있으면 해당 로우에 누적
								//실 사용시간
								map.get("2_"+tcDayList.get(i)+"_ADD").get(existNum).setPUseTime(map.get("2_"+tcDayList.get(i)+"_ADD").get(existNum).getPUseTime()+rfidLog.get(j).getDiffTime());
								//적용시간
								int use = map.get("2_"+tcDayList.get(i)+"_ADD").get(existNum).getPUseTime();
								int apply = 0;
								if(use%60>0) {
									apply = (use/60+1)*60;
								}else {
									apply = (use/60)*60;
								}
								map.get("2_"+tcDayList.get(i)+"_ADD").get(existNum).setPApplyTime(apply);//적용시간
								double paySum= (apply/60 * rfidLog.get(j).getTrPriceAdd())
										* ((100-Integer.parseInt(rfidLog.get(j).getDcCount()))
												/100.0);
								map.get("2_"+tcDayList.get(i)+"_ADD").get(existNum).setPPay(Double.toString(paySum));//합계 = 공급가 *적용시간(100-할인율)/100
							}else {
								//없으면 새 로우 생성
								pay.setCompCode(rfidLog.get(j).getCompCode());//회사코드
								pay.setPType(rfidLog.get(j).getTrTrackType());//유형 TYP00공동 else 단독
								pay.setPReservCode(rfidLog.get(j).getTcReservCode());//예약코드
								pay.setPDay(rfidLog.get(j).getTcDay());//사용일
								pay.setPReason(null);
								pay.setTId(rfidLog.get(j).getTId());//트랙아이디
								pay.setPUseTime(rfidLog.get(j).getDiffTime());//실제사용시간
								pay.setPDiscount(rfidLog.get(j).getDcCount());//할인율
								pay.setPProductPay(rfidLog.get(j).getTrPriceAdd());//공급가
								pay.setPPayType("ADD");
								int apply = 0;
								if(rfidLog.get(j).getDiffTime()%60>0) {
									apply = (rfidLog.get(j).getDiffTime()/60+1)*60;
								}else {
									apply = (rfidLog.get(j).getDiffTime()/60)*60;
								}
								pay.setPApplyTime(apply);//적용시간
								double paySum= (apply/60 * rfidLog.get(j).getTrPriceAdd())
										* ((100-Integer.parseInt(rfidLog.get(j).getDcCount()))
												/100.0);
								pay.setPPay(Double.toString(paySum));//합계 = 공급가 *적용시간(100-할인율)/100

								map.get("2_"+tcDayList.get(i)+"_ADD").add(pay);
							}

						}
					}else {//단독일때
						//같은트랙이 있는지 찾기
						boolean exist=false;
						int existNum = 0;
						for(int k=0; k<map.get("1_"+tcDayList.get(i)+"_SOLO").size();k++) {
							if(rfidLog.get(j).getTId().equals(map.get("1_"+tcDayList.get(i)+"_SOLO").get(k).getTId())) {
								exist = true;
								existNum = k;
							}
						}
						if(exist) {//존재 할 때
							//실 사용시간
							map.get("1_"+tcDayList.get(i)+"_SOLO").get(existNum).setPUseTime(map.get("1_"+tcDayList.get(i)+"_SOLO").get(existNum).getPUseTime()+rfidLog.get(j).getDiffTime());
							//적용시간
							int use = map.get("1_"+tcDayList.get(i)+"_SOLO").get(existNum).getPUseTime();
							int apply = 0;
							if(use%60>0) {
								apply = (use/60+1)*60;
							}else {
								apply = (use/60)*60;
							}
							map.get("1_"+tcDayList.get(i)+"_SOLO").get(existNum).setPApplyTime(apply);//적용시간
							double paySum= (apply/60 * rfidLog.get(j).getTrPriceSolo())
									* ((100-Integer.parseInt(rfidLog.get(j).getDcCount()))
											/100.0);
							map.get("1_"+tcDayList.get(i)+"_SOLO").get(existNum).setPPay(Double.toString(paySum));//합계 = 공급가 *적용시간(100-할인율)/100
						}else {//아닐 때
							pay.setCompCode(rfidLog.get(j).getCompCode());//회사코드
							pay.setPType(rfidLog.get(j).getTrTrackType());//유형 TYP00공동 else 단독
							pay.setPReservCode(rfidLog.get(j).getTcReservCode());//예약코드
							pay.setPDay(rfidLog.get(j).getTcDay());//사용일
							pay.setPReason(null);
							pay.setTId(rfidLog.get(j).getTId());//트랙아이디
							pay.setPUseTime(rfidLog.get(j).getDiffTime());//실제사용시간
							pay.setPDiscount(rfidLog.get(j).getDcCount());//할인율
							pay.setPProductPay(rfidLog.get(j).getTrPriceSolo());//공급가
							pay.setPPayType("SOLO");
							int apply = 0;
							if(rfidLog.get(j).getDiffTime()%60>0) {
								apply = (rfidLog.get(j).getDiffTime()/60+1)*60;
							}else {
								apply = (rfidLog.get(j).getDiffTime()/60)*60;
							}
							pay.setPApplyTime(apply);//적용시간
							double paySum= (apply/60 * rfidLog.get(j).getTrPriceSolo())
									* ((100-Integer.parseInt(rfidLog.get(j).getDcCount()))
											/100.0);
							pay.setPPay(Double.toString(paySum));//합계 = 공급가 *적용시간(100-할인율)/100
							map.get("1_"+tcDayList.get(i)+"_SOLO").add(pay);
						}

					}


				}
				//가장 비싼것 구분 / 적용시간 변경,공급가 기본료로 변경, 합계 계산해서 넣어주기
				if(map.get("1_"+tcDayList.get(i)+"_DEFAULT")!=null) {
					for(int di=0; di< map.get("1_"+tcDayList.get(i)+"_DEFAULT").size();di++) {
						if(maxTrack.equals(map.get("1_"+tcDayList.get(i)+"_DEFAULT").get(di).getTId())) {
							map.get("1_"+tcDayList.get(i)+"_DEFAULT").get(di).setPApplyTime(240);
							double paySum= map.get("1_"+tcDayList.get(i)+"_DEFAULT").get(di).getPProductPay()
									* ((100-Integer.parseInt(map.get("1_"+tcDayList.get(i)+"_DEFAULT").get(di).getPDiscount()))
											/100.0);
							map.get("1_"+tcDayList.get(i)+"_DEFAULT").get(di).setPPay(Double.toString(paySum));//합계 = 공급가 *적용시간(100-할인율)/100
						}
					}
				}


			}
//			else {//입출차 기록이 없을 때
//			}
			//기본요금 추가 로직
			TrPayDto defaultPriceVo = new TrPayDto();
			defaultPriceVo.setPReservCode(reservCode);
			defaultPriceVo.setPDay(tcDayList.get(i));
			//차량대수
			TrPayDto gnrVo = calDao.getDayCarCnt(defaultPriceVo);
			System.out.println("gnrVognrVognrVognrVo"+gnrVo.toString());
			if(gnrVo != null && gnrVo.getCarCnt()>0) {
				int carCnt = gnrVo.getCarCnt();
				String cCode = gnrVo.getCompCode();
				//pay에 추가
				TrPayDto defaultPay = new TrPayDto();
				defaultPay.setCompCode(cCode);//회사코드
				defaultPay.setPType("TYP02");//유형 TYP00공동 else 단독 + TYP02기본료
				defaultPay.setPReservCode(reservCode);//예약코드
				defaultPay.setPDay(tcDayList.get(i));//사용일
				defaultPay.setPReason(null);
				defaultPay.setTId("T000");//트랙아이디
				defaultPay.setPUseTime(carCnt);//실제사용시간
				defaultPay.setPApplyTime(0);//실제사용시간

				double defaultPaySum = (carCnt * gnrVo.getPProductPay())* ((100-Integer.parseInt(gnrVo.getPDiscount()))/100.0);
				defaultPay.setPDiscount(gnrVo.getPDiscount());//할인율
				defaultPay.setPProductPay(gnrVo.getPProductPay());//공급가
				defaultPay.setPPay(Double.toString(defaultPaySum));
				defaultPay.setPPayType("GNR");

				map.get("1_"+tcDayList.get(i)+"_GNR").add(defaultPay);
			}
		}//일자 반복문 end

		//인서트 할 리스트 인서트
		Iterator<String> keys = map.keySet().iterator();
		System.out.println("============insert List===========");
		System.out.println(map.toString());
		int resultCnt = 0;
		while (keys.hasNext()) {
			String key = keys.next();
			System.out.println("key = " + key);
			for (int i = 0; i < map.get(key).size(); i++) {
				System.out.println(map.get(key).get(i).toString());
				resultCnt += calDao.insertPay(map.get(key).get(i));
			}
		}
		System.out.println("==================================");
		return resultCnt;
	}

	@Override
	public List<CalToPay> getPayList(String[] codeArr) throws Exception {
		return calDao.getPayList(codeArr);
	}

}

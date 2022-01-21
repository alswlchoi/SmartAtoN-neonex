package com.hankook.pg.content.admin.car.controller;

import com.hankook.pg.content.admin.car.dto.CarDto;
import com.hankook.pg.content.admin.car.dto.SearchCarDto;
import com.hankook.pg.content.admin.car.service.CarService;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.ResultCode;
import com.hankook.pg.share.Search;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/admin/car")
public class CarController {
 
    @Autowired
    CarService carService;

    @GetMapping("")
    public ModelAndView getCars(ModelAndView mav ,SearchCarDto searchCar) {

        searchCar.setPageNo(1);
        searchCar.setPageSize(10);

        Map<String, Object> carList = carService.getCarList(searchCar);
        
        //페이징 처리
        Search search = new Search();
        search.setPageNo(1);
        search.setPageSize(10);
        Paging paging = new Paging(search, (Integer)carList.get("records"));

        //변수 설정
        mav.addObject("paging", paging);
        mav.addObject("carList",carList);
        mav.addObject("totalCnt", carList.get("records").toString());
        
        mav.setViewName("/admin/car/car");
                
        return mav;
    }

    @GetMapping("/search-car")
    public Map<String, Object> getSearch(SearchCarDto searchCar) {
    	String[] order = {"COMP_CODE DESC"};
    	searchCar.setArrOrderColumn(order);
    	//업체 조회

    	Map<String, Object> carList = carService.getCarList(searchCar);
        //페이징 처리
        Search search = new Search();
        search.setPageNo(searchCar.getPageNo());
        search.setPageSize(searchCar.getPageSize());
        Paging paging = new Paging(search, (Integer)carList.get("records"));
        
        carList.put("totalCnt", carList.get("records").toString());
        carList.put("paging",paging);
        
        return carList;
    }
    
    @RequestMapping("/insert-car")
    public ResultCode insertCar(CarDto car,HttpServletRequest request) {
    	
    	boolean result = false;

		try {
			// 사용자 등록
	    	result = carService.insertCar(car, request);
		} catch (Exception e) {
			return ResultCode.builder()
                    .code(500)
                    .message("등록에 실패하였습니다.")
                    .build();
		}
		
		int code = result ? 200 : 400;
		String message = result ? "등록에 성공하였습니다." : "등록에 실패하였습니다.";
		
		return ResultCode.builder()
                .code(code)
                .message(message)
                .build();
    }
    
    @GetMapping("/detail-car")
    public Map<String, Object> getCarDetail(CarDto car) {
        car = carService.getCarDetail(car.getCCode());
        
        Map<String, Object> result = new HashMap<String, Object>();  
        result.put("car", car);
        return result;
    	
    }
    
    //수정 처리
    @RequestMapping("/update-car")
    public ResultCode getCarModify(CarDto car,HttpServletRequest request) {
		int cnt = carService.getCompCodeduplCheck(car.getCCode());
		
		if (cnt == 0) return ResultCode.builder()
                .code(400)
                .message("정보가 존재하지 않습니다.")
                .build();	
  
     	boolean result = true;
    	
     	try {
     		//사용자 업데이트
     		result = carService.updateCar(car);
 		} catch (Exception e) {
 			return ResultCode.builder()
 	                .code(400)
 	                .message("수정에 실패했습니다.")
 	                .build();	
 		}
		
     	int code = result ? 200 : 400;
		String message = result ? "수정에 성공하였습니다." : "수정에 실패하였습니다.";
		
		return ResultCode.builder()
                .code(code)
                .message(message)
                .build();
    }
    
    //삭제 처리
    @RequestMapping("/delete-car")
    public ResultCode getCarDelete(CarDto car,HttpServletRequest request) {

    	boolean result = true;
    	
     	try {
     		//사용자 업데이트
     		result = carService.deleteCar(car.getCCode());
 		} catch (Exception e) {
 			return ResultCode.builder()
 	                .code(400)
 	                .message("삭제에 실패했습니다.")
 	                .build();	
 		}
		
     	int code = result ? 200 : 400;
		String message = result ? "삭제에 성공하였습니다." : "삭제에 실패하였습니다.";
		
		return ResultCode.builder()
                .code(code)
                .message(message)
                .build();
    	
    }
}
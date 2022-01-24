package com.hankook.pg.content.admin.car.service;
 
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.hankook.pg.content.admin.car.dao.CarDao;
import com.hankook.pg.content.admin.car.dto.CarDto;
import com.hankook.pg.content.admin.car.dto.SearchCarDto;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.Results;

@Service
public class CarService{
    
    @Autowired
    private CarDao carDao;
    
    public Map<String, Object> getCarList(SearchCarDto searchCar) {
    	searchCar.setStartRowNum((searchCar.getPageNo()-1)*10);
    	List<CarDto> carList = carDao.getCarList(searchCar);
    	
        Paging paging = new Paging(searchCar, carDao.findCarCount(searchCar));
        
        return Results.grid(paging, carList);
    }
    
    public Integer getCompCodeduplCheck(String cCode){
    	return carDao.getCompCodeduplCheck(cCode);
    }
    
    public boolean insertCar(CarDto car, HttpServletRequest request) {
    	
    	Integer cnt = carDao.insertCar(car);

		return cnt > 0;
    }
     
    public CarDto getCarDetail(String cCode) {
    	return carDao.getCarDetail(cCode);
    }
     
    public boolean updateCar(CarDto car) {
    	int cnt = carDao.updateCar(car); 
    	return cnt > 0;
    }
       
    public boolean deleteCar(String cCode) {
    	int cnt = carDao.deleteCar(cCode); 
    	return cnt > 0;
    }
}


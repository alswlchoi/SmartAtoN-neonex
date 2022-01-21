package com.hankook.pg.content.admin.car.dao;
 
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.hankook.pg.content.admin.car.dto.CarDto;
import com.hankook.pg.content.admin.car.dto.SearchCarDto;

@Repository
@Mapper
public interface CarDao {
	/* 목록*/
    List<CarDto> getCarList(SearchCarDto search);

    /* 검색결과 갯수 반환 */
    int findCarCount(SearchCarDto search);
        
    /* 존재유무 */
    int getCompCodeduplCheck(String cCode);
    
    /* 가장 큰 코드의 숫자를 가져옴 */
    String getMaxCompCode();
    /* 등록*/
    int insertCar(CarDto car);
    
    /* 상세보기 */
    CarDto getCarDetail(String cCode);
        
    /* 수정*/
    int updateCar(CarDto car);
    
    /* 삭제*/
    int deleteCar(String cCode);
}
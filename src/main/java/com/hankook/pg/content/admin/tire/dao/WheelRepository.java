package com.hankook.pg.content.admin.tire.dao;

import com.hankook.pg.content.admin.tire.domain.Wheel;
import com.hankook.pg.content.admin.tire.dto.WheelPagingAndSearchRequestDto;
import org.springframework.stereotype.Repository;

import java.sql.SQLException;
import java.util.List;

@Repository
public interface WheelRepository {

    List<Wheel> findAll(WheelPagingAndSearchRequestDto request) throws SQLException;

    int findAllCount(WheelPagingAndSearchRequestDto request) throws SQLException;

    List<Wheel> findWheelAttr(WheelPagingAndSearchRequestDto request) throws SQLException;

    int findWheelAttrCount(WheelPagingAndSearchRequestDto request) throws SQLException;
}

package com.hankook.pg.content.admin.tire.dao;

import com.hankook.pg.content.admin.tire.domain.TireManagement;
import com.hankook.pg.content.admin.tire.dto.InsertTireDataDto;
import com.hankook.pg.content.admin.tire.dto.InsertWheelDataDto;
import com.hankook.pg.content.admin.tire.dto.PagingAndSearchRequestDto;
import org.springframework.stereotype.Repository;

import java.sql.SQLException;
import java.util.List;

@Repository
public interface TireDao {

    List<TireManagement> findAllToday(PagingAndSearchRequestDto request) throws SQLException;

    int findAllTodayCount(PagingAndSearchRequestDto request) throws SQLException;

    int insertTirePush(InsertTireDataDto insertTireDataDto) throws SQLException;

    int insertTireLift(InsertTireDataDto request) throws SQLException;

    int insertAssembly(InsertTireDataDto request) throws SQLException;

    int insertDisAssembly(InsertTireDataDto request) throws SQLException;

    List<TireManagement> findTireAttr(PagingAndSearchRequestDto request) throws SQLException;

    int findTireAttrCount(PagingAndSearchRequestDto request) throws SQLException;

    int insertWheelLocation(InsertWheelDataDto request) throws SQLException;

    int insertTireLocation(InsertTireDataDto request) throws SQLException;
}

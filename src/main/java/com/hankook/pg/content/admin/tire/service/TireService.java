package com.hankook.pg.content.admin.tire.service;

import com.hankook.pg.content.admin.tire.dao.TireDao;
import com.hankook.pg.content.admin.tire.domain.Wheel;
import com.hankook.pg.content.admin.tire.dto.InsertWheelDataDto;
import com.hankook.pg.content.admin.tire.dto.WheelPagingAndSearchRequestDto;
import com.hankook.pg.content.admin.tire.dao.WheelRepository;
import com.hankook.pg.content.admin.tire.domain.TireManagement;
import com.hankook.pg.content.admin.tire.dto.InsertTireDataDto;
import com.hankook.pg.content.admin.tire.dto.PagingAndSearchRequestDto;
import com.hankook.pg.content.member.dto.MemberDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class TireService {

    private static final String COMPLETE = "Y";

    private final TireDao tireRepository;
    private final WheelRepository wheelRepository;

    @Transactional
    public List<TireManagement>findAllToday(PagingAndSearchRequestDto request) throws SQLException {
        return tireRepository.findAllToday(request);
    }

    @Transactional
    public int findAllTodayCount(PagingAndSearchRequestDto request) throws SQLException {
        return tireRepository.findAllTodayCount(request);
    }

    @Transactional
    public int insertTirePush(InsertTireDataDto request) throws SQLException {
        request.setComplete(COMPLETE);
        return tireRepository.insertTirePush(request);
    }

    @Transactional
    public int insertTireLift(InsertTireDataDto request) throws SQLException {
        return tireRepository.insertTireLift(request);
    }

    @Transactional
    public int insertAssembly(InsertTireDataDto request) throws SQLException {
        String saveTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy.MM.dd HH:mm:ss"));
        MemberDto member = (MemberDto) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        request.setSaveTime(saveTime);
        request.setEngineer(member.getMemName());
        return tireRepository.insertAssembly(request);
    }

    @Transactional
    public int insertDisAssembly(InsertTireDataDto request) throws SQLException {
        String saveTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy.MM.dd HH:mm:ss"));
        request.setSaveTime(saveTime);
        return tireRepository.insertDisAssembly(request);
    }

    @Transactional
    public int insertTireLocation(InsertTireDataDto request) throws SQLException {
        return tireRepository.insertTireLocation(request);
    }


    @Transactional
    public List<TireManagement> findTireAttr(PagingAndSearchRequestDto request) throws SQLException {
        return tireRepository.findTireAttr(request);
    }

    public int findTireAttrCount(PagingAndSearchRequestDto request) throws SQLException {
        return tireRepository.findTireAttrCount(request);
    }

    @Transactional
    public List<Wheel> wheelFindAll(WheelPagingAndSearchRequestDto request) throws SQLException {
        return wheelRepository.findAll(request);
    }

    @Transactional
    public int wheelFindAllCount(WheelPagingAndSearchRequestDto request) throws SQLException {
        return wheelRepository.findAllCount(request);
    }

    @Transactional
    public int insertWheelLocation(InsertWheelDataDto request) throws SQLException {
        return tireRepository.insertWheelLocation(request);
    }

    @Transactional
    public List<Wheel> findWheelAttr(WheelPagingAndSearchRequestDto request) throws SQLException {
        return wheelRepository.findWheelAttr(request);
    }

    @Transactional
    public int findWheelAttrCount(WheelPagingAndSearchRequestDto request) throws SQLException {
        return wheelRepository.findWheelAttrCount(request);
    }
}

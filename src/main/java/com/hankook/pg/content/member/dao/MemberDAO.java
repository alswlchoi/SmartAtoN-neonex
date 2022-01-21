package com.hankook.pg.content.member.dao;
 
import java.sql.SQLException;
import java.util.List;

import com.hankook.pg.content.member.dto.MemberDto;
import org.springframework.stereotype.Repository;

@Repository
public interface MemberDAO {
    List<MemberDto> getMmemberlist() throws Exception;
    MemberDto getMemberinfo(String memId) throws SQLException;
    int insertMember(MemberDto memberDto) throws SQLException;
}
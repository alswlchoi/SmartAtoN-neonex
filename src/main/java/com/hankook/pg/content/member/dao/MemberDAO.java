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
    int createCompany(MemberDto build) throws SQLException;
	int chkMemId(MemberDto memberDto) throws SQLException;
	int chkCompLicense(String b_no) throws SQLException;
	MemberDto searchId(MemberDto memberDto) throws SQLException;
	int modiPwd(MemberDto memberDto) throws SQLException;
	String chkApproval(MemberDto memberDto) throws SQLException;
	int dueChkPwd(MemberDto memberDto) throws SQLException;
	int updateCompany(MemberDto memberDto) throws SQLException;
	int updateMember(MemberDto build) throws SQLException;
	int chkMemEmail(MemberDto memberDto) throws SQLException;
	int getAdminListCnt(MemberDto memberDto) throws SQLException;
	List<MemberDto> getAdminList(MemberDto memberDto) throws SQLException;
	int chkMemIdName(MemberDto memberDto) throws SQLException;
	int updateAdmin(MemberDto build) throws SQLException;
}
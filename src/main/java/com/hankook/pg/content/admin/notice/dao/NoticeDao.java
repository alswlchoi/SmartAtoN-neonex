package com.hankook.pg.content.admin.notice.dao;
 
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.hankook.pg.content.admin.notice.dto.NoticeDto;
import com.hankook.pg.content.admin.notice.dto.SearchNoticeDto;
import com.hankook.pg.content.admin.notice.dto.UpfilesDto;

@Repository
@Mapper
public interface NoticeDao {
	/* 공지사항에서 가장 큰 값 가져오기 */
	NoticeDto getMaxNoticeOrder() throws Exception;
	/* 게시판 목록*/
    List<NoticeDto> getNoticeList(SearchNoticeDto searchNotice) throws Exception;
    /* 검색결과 갯수 반환 */
    int findNoticeCount(SearchNoticeDto search) throws Exception;

    /* 게시판 등록*/
    int insertNotice(NoticeDto notice) throws Exception;
    
    /* 게시판 상세보기 */
    NoticeDto getNoticeDetail(Integer nSeq) throws Exception;

    /* 파일정보(게시글 다수) */
    List<UpfilesDto> getFileinfo(NoticeDto notice) throws Exception;
    
    /* 파일정보 (한개) */
    UpfilesDto getFileinfoOnly(Integer fSeq) throws Exception;
    
    /* 조회수 증가 */
    void updateHits(Integer nSeq) throws Exception;
    
    /* 게시판 수정 */
    int updateNotice(NoticeDto notice) throws Exception;
    
    /* 게시판 삭제 */
    int deleteNotice(Integer nSeq) throws Exception;
    
    /* 게시판 파일 삭제 */
    int deleteFile(Integer fSeq) throws Exception;
    
    /* 게시판 파일 등록 */
    int insertNoticeFile(UpfilesDto upfiles) throws Exception;

    /* 공지사항 메인 노출 */
    List<NoticeDto> mainNotice(String nType) throws Exception;
}
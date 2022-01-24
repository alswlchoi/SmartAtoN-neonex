package com.hankook.pg.share;

import lombok.Data;
import org.apache.ibatis.type.Alias;

/**
 * Paging
 *
 * @author koyoungho
 * @since 20200602
 */
@Data
@Alias("Paging")
public class Paging {

    private int pageSize = 10; // 한 페이지에 보일 게시글 수
    private int pageNo = 1; // 페이지 번호
    private int finalPageNo; // 마지막 페이지 번호
    private int totalCount; // 게시글 전체 수
    private int startRowNum; // 게시글 조회 쿼리에 들어갈 row 시작점
    private int endRowNum; // 게시글 조회 쿼리에 들어갈 row 끝점
    //아래는 추가 사항
    private int rangeSize=10; //한 블럭당 페이지 수 
    private int curRange=1; //현재 블럭 
    private int startPage;//블럭 시작 페이지
    private int endPage;//블럭 끝 페이지
    private int prevPage;//이전페이지
    private int nextPage;//다음페이지
    
    public Paging() {

    }

    public Paging(Search search, int totalCount) {
        this.pageSize = search.getPageSize();
        this.totalCount = totalCount;
        this.pageNo = search.getPageNo();
        int extraPage = 0;
        if (totalCount % search.getPageSize() > 0) {
            extraPage = 1;
        }
        this.finalPageNo = this.totalCount / this.pageSize + extraPage;
        this.curRange = (search.getPageNo()-1)/rangeSize + 1;
        this.startPage = (curRange -1)*rangeSize+1;
        this.endPage = startPage +rangeSize -1;
        if(endPage > finalPageNo) {
        	this.endPage = finalPageNo;
        }
        if(pageNo == 1) {
        	this.prevPage = 0;
        }else {
        	this.prevPage = pageNo - 1;
        }
        if(pageNo == finalPageNo) {
        	this.nextPage = 0;
        }else {
        	this.nextPage = pageNo + 1;
        }
    }

}

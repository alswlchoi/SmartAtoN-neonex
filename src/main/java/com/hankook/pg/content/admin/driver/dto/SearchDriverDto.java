package com.hankook.pg.content.admin.driver.dto;

import com.hankook.pg.share.Search;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
@Data
public class SearchDriverDto extends Search {

    private String compCode;	//회사코드
    private String stDt;		//검색 시작일
    private String edDt;		//검색 마감일
    private String dName;		//운전자명
    private String keyword;		//검색어
    private String enckeyword;	//암호화한 검색어
    private String dApproval;	//승인
    
    @ApiModelProperty(value = "페이지번호")
    private Integer pageNo = 1;
    
    @ApiModelProperty(value = "한페이지 사이즈")
    private Integer pageSize = 10;

    @ApiModelProperty(value = "시작페이지")
    private Integer startPage = 1;
    
    @ApiModelProperty(value = "끝페이지")
    private Integer endPage = 10;
    
    @ApiModelProperty(value = "시작 Limit 번호")
    private Integer startRowNum = 0;
}



package com.hankook.pg.content.admin.company.dto;

import com.hankook.pg.share.Search;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
@Data
public class SearchCompanyDto extends Search {

    private String compCode;		//회사코드
    private String compName;		//회사명
    private String MemName;			//담당자명
    private String compRegStDt;		//검색시작일
    private String compRegEdDt;		//검색마감일
    private String memApproval;		//상태(승인대기 검색용)
    private String compCond;		//업종형태
    private String blackList;		//블랙리스트
    
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



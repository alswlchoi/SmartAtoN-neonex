package com.hankook.pg.content.admin.dayoff.dto;

import com.hankook.pg.share.Search;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
public class SearchDayoffDto extends Search {

    private String searchYear;
    
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

    private String doKind;
}



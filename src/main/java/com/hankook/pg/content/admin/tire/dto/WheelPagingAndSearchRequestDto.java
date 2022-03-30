package com.hankook.pg.content.admin.tire.dto;

import com.hankook.pg.share.Search;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class WheelPagingAndSearchRequestDto extends Search {
    private String wheelSize;
    private String maker;
    private String project;
    private String searchSizeT;
    private String searchMakerT;
    private String searchProjectT;
}

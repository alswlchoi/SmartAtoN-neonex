package com.hankook.pg.content.admin.tire.dto;

import com.hankook.pg.share.Search;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class PagingAndSearchRequestDto extends Search {
    private String today;
    private String date;
    private String endDate;
    private String attr;

    public void setToday(String today) {
        this.today = today;
    }
}

package com.hankook.pg.content.account.dto;

import com.hankook.pg.share.Search;
import lombok.Data;
import lombok.EqualsAndHashCode;


@EqualsAndHashCode(callSuper = true)
@Data
public class SearchAccountDto extends Search {

    private String id;
    private String name;
    private String role;
    private String orgName;

}

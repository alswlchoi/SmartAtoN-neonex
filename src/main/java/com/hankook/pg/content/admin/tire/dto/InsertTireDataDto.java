package com.hankook.pg.content.admin.tire.dto;


import lombok.*;

import javax.validation.constraints.NotNull;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class InsertTireDataDto {
    @NotNull
    private int tmSeq;
    @NotNull
    private String colType;
    private String engineer;
    private int lift;

    private String complete;
    private String saveTime;
    private String tmTrwhYn;
}

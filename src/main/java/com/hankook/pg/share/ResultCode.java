package com.hankook.pg.share;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ResultCode {
    private int code;

    private String message;

    @Builder
    public ResultCode(int code, String message) {
        this.code = code;
        this.message = message;
    }
}

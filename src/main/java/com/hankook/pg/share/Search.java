package com.hankook.pg.share;

import com.google.common.base.CaseFormat;
import lombok.Data;
import org.apache.ibatis.type.Alias;

/**
 * Search
 *
 * @author Kyeongjin.Kim
 * @since 2019-06-19
 */
@Data
@Alias("Search")
public class Search {

    private Integer pageSize = 10;

//    @ApiParam(value = "현재 페이지 번호", defaultValue = "1", required = true)
    private Integer pageNo = 1;

//    @ApiParam(value = "정렬컬럼 (ex = usrNm desc, authGrpNm asc)", defaultValue = "")
    private String[] arrOrderColumn;

//    @ApiModelProperty(value = "요청자 아이디", hidden = true)
    private String requesterId;

//    @ApiModelProperty(value = "요청자 권한", hidden = true)
    private String requesterRole;

    public String[] getArrOrderColumn(){
        return convertUnderscore(this.arrOrderColumn);
    }

    private String[] convertUnderscore(String[] arrOrderColumn){
        if (arrOrderColumn != null && arrOrderColumn.length > 0) {
            String[] convertUnderscore = new String[arrOrderColumn.length];
            for (int x=0;x<arrOrderColumn.length;x++) {
                convertUnderscore[x] = CaseFormat.UPPER_CAMEL.to(CaseFormat.LOWER_UNDERSCORE, arrOrderColumn[x]).toUpperCase();
            }
            return convertUnderscore;
        }else{
            return new String[0];
        }
    }

}

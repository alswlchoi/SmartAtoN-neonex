package com.hankook.pg.common.code.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.hankook.pg.common.code.dto.CodeDto;

@Repository("codeDao")
public class CodeDao {
	private static Map<String,CodeDto> codeDataMap = new HashMap<String,CodeDto>();
	private static List<CodeDto> codeDataList = new ArrayList<CodeDto>();	

	/**
	 * @param codeDto
	 * @return
	 * Description 코드 전체 목록
	 */
	public List<CodeDto> selectCodeALLList(CodeDto codeDto) {
		List<CodeDto> codeList = new ArrayList<CodeDto>();
		for(CodeDto codeDataVo : codeDataList){			
			// CODE_PATH ||'||'||CODE=#code_path# OR CODE_PATH||'||'||CODE LIKE #code_path#||'||%'
			boolean isCheck = (codeDataVo.getCode_path() + "||" + codeDataVo.getCode()).equals(codeDto.getCode_path()) 
					||  (codeDataVo.getCode_path() + "||" + codeDataVo.getCode()).indexOf(codeDto.getCode_path()+"||")>-1 ;
			if(isCheck && ((null!=codeDto.getUse_yn())||codeDto.getUse_yn().length()>0)){		
				// USE_YN = #use_yn#
				isCheck = codeDataVo.getUse_yn().equals(codeDto.getUse_yn()); 	
			}
			if(isCheck){
				// START WITH CODE_PATH2=#code_path#
				isCheck = (codeDataVo.getCode_path() + "||" + codeDataVo.getCode()).indexOf(codeDto.getCode_path())==0;
			}					
			if(isCheck){
				codeList.add(codeDataVo);
			}
		}
		
		return codeList;
	}
	
	/**
	 * @param codeDto
	 * @return
	 * Description 코드 목록
	 */
	public List<CodeDto> selectCodeList(CodeDto codeDto) {
		List<CodeDto> codeList = new ArrayList<CodeDto>();
		for(CodeDto codeDataVo : codeDataList){			
			// CODE_PATH=#code_path#
			boolean isCheck = codeDataVo.getCode_path().equals(codeDto.getCode_path());

			if(isCheck && !(null!=codeDto.getUse_yn()||codeDto.getUse_yn().length()>0)){		
				// USE_YN = #use_yn#
				isCheck = codeDataVo.getUse_yn().equals(codeDto.getUse_yn()); 	
			}
			if(isCheck){
				codeList.add(codeDataVo);
			}
		}
		
		return codeList;
	} 
	
	/**
	 * @param code_path
	 * @return
	 */
	public List<CodeDto> selectCodeList(String code_path) {
		CodeDto codeDto = new CodeDto();
		codeDto.setCode_path(code_path);
		return selectCodeList(codeDto);
	} 


	/**
	 * @param codeDto
	 * @return
	 * Description 하위 코드 포함 목록
	 */
	public List<CodeDto> selectCodeChildIncludeList(CodeDto codeDto) {
		List<CodeDto> codeList = new ArrayList<CodeDto>();
		for(CodeDto codeDataVo : codeDataList){			
			// CODE_PATH LIKE #code_path#||'||%' OR CODE_PATH=#code_path#
			boolean isCheck = codeDataVo.getCode_path().indexOf(codeDto.getCode_path()+"||")>-1 
					|| codeDataVo.getCode_path().equals(codeDto.getCode_path())
				;
			
			if(isCheck){
				// CODE_LV<=#code_lv#
				isCheck = codeDataVo.getCode_lv() <= codeDto.getCode_lv(); 
			}
			if(isCheck){		
				// USE_YN = #use_yn#
				isCheck = codeDto.getUse_yn().equals(codeDataVo.getUse_yn()); 	
			}
			if(isCheck){
				codeList.add(codeDataVo);
			}
		}

		return codeList;
	} 
	
	
	
	/**
	 * @param codeDto
	 * @return
	 * Description 코드 정보
	 */
	public CodeDto selectCode(CodeDto codeDto) {
		CodeDto codeDataVo = null;
		if((null!=codeDto.getCode()||codeDto.getCode().length()>0)){
			//CODE_PATH=#code_path# AND CODE=#code#
			codeDataVo = codeDataMap.get(codeDto.getCode_path() + "||" + codeDto.getCode());
		}else{
			//CODE_PATH2=#code_path#
			codeDataVo = codeDataMap.get(codeDto.getCode_path());
		}
		if(codeDataVo==null){
			codeDataVo = new CodeDto();
		}
		return codeDataVo;
	}
	
	public CodeDto selectCode(String code_path, String code) {
		CodeDto codeDto = new CodeDto();
		codeDto.setCode_path(code_path);
		codeDto.setCode(code);
		return selectCode(codeDto);
	} 
	
	
	/**
	 * @param code_path
	 * @return
	 * Description 코드 수
	 */
	public int selectCodeChildCount(String code_path) {
		int code_cnt = 0;
		for(CodeDto codeDataVo : codeDataList){			
			// CODE_PATH LIKE #code_path#||'||%' OR CODE_PATH=#code_path#
			boolean isCheck = codeDataVo.getCode_path().indexOf(code_path+"||")>-1 
					|| codeDataVo.getCode_path().equals(code_path)
				;

			if(isCheck){
				code_cnt++;
			}
		}
		
		return code_cnt;
	}
	
	
	/**
	 * @param code_path
	 * @return
	 * Description 코드 Max 레벨
	 */
	public int selectCodeMaxLv(String code_path) {
		int maxlv = 0;
		for(CodeDto codeDataVo : codeDataList){			
			// CODE_PATH=#code_path#
			boolean isCheck = codeDataVo.getCode_path().equals(code_path) ;

			if(isCheck && codeDataVo.getCode_lv() >  maxlv){
				maxlv = codeDataVo.getCode_lv();
			}
		}

		return maxlv;
	}
	
	
	/**
	 * @param code_path
	 * @return
	 * Description 코드 Max 레벨 like
	 */
	public int selectCodeMaxLvLike(String code_path) {
		int maxlv = 0;
		for(CodeDto codeDataVo : codeDataList){			
			// CODE_PATH LIKE #code_path#||'||%' OR CODE_PATH=#code_path#
			boolean isCheck = codeDataVo.getCode_path().indexOf(code_path+"||")>-1 
					|| codeDataVo.getCode_path().equals(code_path)
				;

			if(isCheck && codeDataVo.getCode_lv() >  maxlv){
				maxlv = codeDataVo.getCode_lv();
			}
		}

		return maxlv;
	}
}

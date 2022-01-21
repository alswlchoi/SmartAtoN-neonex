package com.hankook.pg.common.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.hankook.pg.common.code.dao.CodeDao;
import com.hankook.pg.common.code.dto.CodeDto;

@Component
public class CodeUtil {	
	private static CodeDao codeDao;

	@Autowired
    private void setCodeDao(CodeDao codeDao) {
    	CodeUtil.codeDao = codeDao;
    }
	
	/**
	 * @param codePath
	 * @return
	 * @throws Exception
	 */
	public static List<CodeDto> selectCodeList(String codePath) throws Exception {
		CodeDto codeDto = new CodeDto();
		codeDto.setCode_path("root||" + codePath);
		codeDto.setUse_yn("y");
		return codeDao.selectCodeList(codeDto);
	}
	
	/**
	 * @param codePath
	 * @return
	 * @throws Exception
	 */
	public static List<Map<String,Object>> selectCodeMapList(String codePath) throws Exception {
		CodeDto codeDto = new CodeDto();
		codeDto.setCode_path("root||" + codePath);
		codeDto.setUse_yn("y");
		
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		List<CodeDto> codeList = selectCodeList(codePath);
		for(CodeDto vo : codeList){
			Map<String,Object> map = new HashMap<String,Object>();			
			map.put("code", vo.getCode());						//코드
			map.put("pcode", vo.getPcode()); 					//부모코드
			map.put("code_nm1", vo.getCode_nm1()); 				//코드이름1
			map.put("code_nm2", vo.getCode_nm2()); 				//코드이름2
			map.put("code_nm3", vo.getCode_nm3()); 				//코드이름3
			map.put("code_nm4", vo.getCode_nm4()); 				//코드이름4
			map.put("code_nm5", vo.getCode_nm5()); 				//코드이름5
			map.put("code_lv", vo.getCode_lv());				//코드 레벨
			map.put("ord", vo.getOrd());						//코드 순서
			map.put("code_path", vo.getCode_path());			//코드 경로
			map.put("code_path_nm1", vo.getCode_path_nm1());	//코드 이름1 경로
			map.put("code_path_nm2", vo.getCode_path_nm2());	//코드 이름2 경로
			map.put("code_path_nm3", vo.getCode_path_nm3());	//코드 이름3 경로
			map.put("code_path_nm4", vo.getCode_path_nm4());	//코드 이름4 경로
			map.put("code_path_nm5", vo.getCode_path_nm5());	//코드 이름5 경로
			map.put("code_no", vo.getCode_no());				//코드번호
			map.put("code_no_path", vo.getCode_no_path());		//코드번호 경로
			list.add(map);
		}		
		return list;
	}
	
	/*************************************************************************
	 *@제목		: select box 1EA 생성
	 *@참조키 	: codePath, select_nm, select_id, select_tag, option_nm, current_value
	 *@적성일	: 2009. 3. 16
	 *@RETURN 	: String 
	 *************************************************************************/	
	public static String selectOne(String codePath, String select_nm, String select_tag, String option_nm, String current_value) throws Exception {
		return selectOne(codePath, select_nm, select_nm, select_tag, option_nm, current_value);
	}
	public static String selectOne(String codePath, String select_nm, String select_tag, String option_nm, int code_nm_no, String current_value) throws Exception {
		return selectOne(codePath, select_nm, select_nm, select_tag, option_nm, code_nm_no, current_value);
	}
	//
	public static String selectOne(String codePath, String select_nm, String select_id, String select_tag, String option_nm, String current_value) throws Exception {
		return  selectOne(codePath, select_nm, select_id, select_tag, option_nm, "", current_value);
	}
	public static String selectOne(String codePath, String select_nm, String select_id, String select_tag, String option_nm, int code_nm_no, String current_value) throws Exception {
		return  selectOne(codePath, select_nm, select_id, select_tag, option_nm, "", code_nm_no, current_value);
	}
	//	
	public static String selectOne(String codePath, String select_nm, String select_id, String select_tag, String option_nm, String optgroup_nm, String current_value) throws Exception {
		return selectOne(codePath, select_nm, select_id, select_tag, "", option_nm, optgroup_nm, current_value);
	}
	public static String selectOne(String codePath, String select_nm, String select_id, String select_tag, String option_nm, String optgroup_nm, int code_nm_no, String current_value) throws Exception {
		return selectOne(codePath, select_nm, select_id, select_tag, "", option_nm, optgroup_nm, code_nm_no, current_value);
	}
	//
	public static String selectOne(String codePath, String select_nm, String select_id, String select_tag, String title, String option_nm, String optgroup_nm, String current_value) throws Exception {
		return selectOne(codePath, select_nm, select_id, select_tag, title, option_nm, optgroup_nm, 1, current_value);
	}
	public static String selectOne(String codePath, String select_nm, String select_id, String select_tag, String title, String option_nm, String optgroup_nm, int code_nm_no, String current_value) throws Exception {
		CodeDto codeDto = new CodeDto();
		codeDto.setCode_path("root||" + codePath);
		codeDto.setUse_yn("y");
		List<CodeDto> codeList = codeDao.selectCodeList(codeDto);
		
		StringBuffer selectOne = new StringBuffer();
		if(title!=null && title.length()>0){
			selectOne.append("<select name=\"" + select_nm + "\" id=\"" + select_id + "\" " + select_tag + " title=\"" + title + "\" >\n");
		}else{
			selectOne.append("<select name=\"" + select_nm + "\" id=\"" + select_id + "\" " + select_tag + " >\n");
		}
		
		if(option_nm!=null && !option_nm.equals("")){
			if(!"".equals(current_value)){
				selectOne.append("<option value=\"\" >" + option_nm + "</option>\n");
			}else{
				selectOne.append("<option value=\"\" selected=\"selected\">" + option_nm + "</option>\n");
			}
		}
		if(optgroup_nm!=null && optgroup_nm.length()>0){
			//selectOne.append("<optgroup label=\"" + optgroup_nm + "\">\n");
		}
		
		if(code_nm_no<1 || code_nm_no>5){
			code_nm_no = 1;
		}
		for(int i=0; i<codeList.size(); i++){
			CodeDto codeBean = codeList.get(i);
			String selected = codeBean.getCode().equals(current_value) || option_nm.equals("")&&i==0&&(current_value==null || current_value.length()==0) ?"selected=\"selected\"": "";
			selectOne.append("<option value=\"" + codeBean.getCode() + "\" " + selected + " >");
			selectOne.append(codeBean.getCode_nms()[code_nm_no-1]);
			selectOne.append("</option>\n");
		}
		if(optgroup_nm!=null && optgroup_nm.length()>0){
			//selectOne.append("</optgroup>\n");
		}
		selectOne.append("</select>");
		
		return selectOne.toString();
	}
	
	/*************************************************************************
	 *@제목		: select box 1EA 생성 (특정 범위 지정)
	 *@참조키 	: codePath, select_nm, select_id, select_tag, option_nm, current_value
	 *@적성일	: 2010. 1. 18
	 *@RETURN 	: String 
	 *************************************************************************/	
	public static String selectOneBetween(String codePath, String select_nm, String select_id, String select_tag, String title, String option_nm, String optgroup_nm, String between_str, String current_value) throws Exception {
		return selectOneBetween(codePath, select_nm, select_id, select_tag, title, option_nm, optgroup_nm, between_str, 1, current_value);
	}
	
	public static String selectOneBetween(String codePath, String select_nm, String select_id, String select_tag, String title, String option_nm, String optgroup_nm, String between_str, int code_nm_no, String current_value) throws Exception {
		CodeDto codeDto = new CodeDto();
		codeDto.setCode_path("root||" + codePath);
		codeDto.setUse_yn("y");
		List<CodeDto> codeList = codeDao.selectCodeList(codeDto);
		
		StringBuffer selectOne = new StringBuffer();
		
		HashMap<String,String> betweenCodeHash = new HashMap<String,String>();
		String[] between_code_array = null;
		
		if(between_str!=null && between_str.length()>0){
			between_code_array = toStr_array(between_str, ","); 
			for(String code : between_code_array){
				betweenCodeHash.put(code, "true");
			}
		}
		
		if(title!=null && title.length()>0){
			selectOne.append("<select name=\"" + select_nm + "\" id=\"" + select_id + "\" " + select_tag + " title=\""+title+"\" >\n");
		}else{
			selectOne.append("<select name=\"" + select_nm + "\" id=\"" + select_id + "\" " + select_tag + " >\n");
		}
		
		if(option_nm!=null && option_nm.length()>0){
			if(current_value!=null && current_value.length()>0){	
				selectOne.append("<option value=\"\" >" + option_nm + "</option>\n");
			}else{
				selectOne.append("<option value=\"\" selected=\"selected\">" + option_nm + "</option>\n");
			}
		}
		
		if(optgroup_nm!=null && optgroup_nm.length()>0){
			//selectOne.append("<optgroup label=\"" + optgroup_nm + "\">\n");
		}
		
		if(code_nm_no<1 || code_nm_no>5){
			code_nm_no = 1;
		}
		
		if(between_str!=null && between_str.length()>0){
			
			for(int i=0; i<codeList.size(); i++){
				CodeDto codeBean = codeList.get(i);
				if(betweenCodeHash.get(codeBean.getCode())!=null){
					String selected = codeBean.getCode().equals(current_value) || option_nm.equals("")&&i==0 ?"selected=\"selected\"": "";
					selectOne.append("<option value=\"" + codeBean.getCode() + "\" " + selected + " >");
					selectOne.append(codeBean.getCode_nms()[code_nm_no-1]);			
					selectOne.append("</option>\n");
				}
			}
		}else{
			for(int i=0; i<codeList.size(); i++){
				CodeDto codeBean = codeList.get(i);
				String selected = codeBean.getCode().equals(current_value) || option_nm.equals("")&&i==0 ?"selected=\"selected\"": "";
				selectOne.append("<option value=\"" + codeBean.getCode() + "\" " + selected + " >");
				selectOne.append(codeBean.getCode_nms()[code_nm_no-1]);		
				selectOne.append("</option>\n");
			}
		}
		
		if(optgroup_nm!=null && optgroup_nm.length()>0){
			//selectOne.append("</optgroup>\n");
		}
		selectOne.append("</select>");
		
		return selectOne.toString();
	}
	//
	public static String selectCodePathOne(String codePath, String select_nm, String select_id, String select_tag, String option_nm, String current_value) throws Exception {
		return selectCodePathOne(codePath, select_nm, select_id, select_tag, option_nm, 1, current_value);
	}	
	
	public static String selectCodePathOne(String codePath, String select_nm, String select_id, String select_tag, String option_nm, int code_nm_no, String current_value) throws Exception {
		CodeDto codeDto = new CodeDto();
		codeDto.setCode_path("root||" + codePath);
		codeDto.setUse_yn("y");
		List<CodeDto> codeList = codeDao.selectCodeList(codeDto);
		
		if(code_nm_no<1 || code_nm_no>5){
			code_nm_no = 1;
		}
		
		StringBuffer selectOne = new StringBuffer();

		
		String title = (replaceAll(replaceAll(replaceAll(option_nm,"-",""),"분류",""),"선택","").trim());
		if(!option_nm.equals("")){
			
			selectOne.append("<select name=\"" + select_nm + "\" id=\"" + select_id + "\" " + select_tag + " title=\"" + title + "\" >\n");
			//selectOne.append("<optgroup label=\"" + title + "\" >\n");
			if(!"".equals(current_value)){
				selectOne.append("<option value=\"\" >" + option_nm + "</option>\n");
			}else{
				selectOne.append("<option value=\"\" selected=\"selected\">" + option_nm + "</option>\n");
			}
		}else{
			selectOne.append("<select name=\"" + select_nm + "\" id=\"" + select_id + "\" " + select_tag + " >\n");
		}
		
		for(int i=0; i<codeList.size(); i++){
			CodeDto codeBean = codeList.get(i);
			String selected = codeBean.getCode().equals(current_value) || option_nm.equals("")&&i==0 ?"selected=\"selected\"": "";

			selectOne.append("<option value=\"" + codeBean.getCode_path()+"||" + codeBean.getCode() + "\" " + selected + " >");
			selectOne.append(codeBean.getCode_nms()[code_nm_no-1]);		
			selectOne.append("</option>\n");

		}
		if(!option_nm.equals("")){
			//selectOne.append("</optgroup>");
		}
		selectOne.append("</select>");
		
		return selectOne.toString();
	}
	
	/*************************************************************
	 *@제목		: multi select box 생성
	 *@참조키 	: codePath, select_nm, select_tag, option_nm, current_value
     *@parameter (code : 리스트 코드), (number : 콤보박스 수), (span_nm : span name) 
	 *@적성일	: 2009. 3. 16
	 *@RETURN 	: String 
     *************************************************************/
	public static String selectMulti(String codePath, String select_nm, String option_nm, String span_nm) throws Exception {
		 String [] current_value ={};
		 return  selectMulti(codePath, select_nm, option_nm, 1, current_value, span_nm);
	}
	public static String selectMulti(String codePath, String select_nm, String option_nm, int code_nm_no, String span_nm) throws Exception {
		 String [] current_value ={};
		 return  selectMulti(codePath, select_nm, option_nm, code_nm_no, current_value, span_nm);
	}
	//
	public static String selectMulti(String codePath, String select_nm, String option_nm, String span_nm, boolean isreplace) throws Exception {
		 String [] current_value ={};
		 return  selectMulti(codePath, select_nm, option_nm, 1, current_value, span_nm, isreplace);
	}
	public static String selectMulti(String codePath, String select_nm, String option_nm, int code_nm_no, String span_nm, boolean isreplace) throws Exception {
		 String [] current_value ={};
		 return  selectMulti(codePath, select_nm, option_nm, code_nm_no, current_value, span_nm, isreplace);
	}
	//
	public static String selectMulti2(String codePath, String select_nm, String option_nm, String span_nm, boolean isreplace) throws Exception {
		 String [] current_value ={};
		 return  selectMulti2(codePath, select_nm, option_nm, 1, current_value, span_nm, isreplace);
	}
	public static String selectMulti2(String codePath, String select_nm, String option_nm, int code_nm_no, String span_nm, boolean isreplace) throws Exception {
		 String [] current_value ={};
		 return  selectMulti2(codePath, select_nm, option_nm, code_nm_no, current_value, span_nm, isreplace);
	}
	
    // 전체형
    public static String selectMulti(String codePath, String select_nm, String option_nm, String[] current_value, String span_nm) throws Exception {
        return selectMulti(codePath, select_nm, option_nm, 1, current_value, span_nm);
    }
    public static String selectMulti(String codePath, String select_nm, String option_nm, int code_nm_no, String[] current_value, String span_nm) throws Exception {
    	int number = codeDao.selectCodeMaxLvLike("root||" + codePath) - codeDao.selectCodeMaxLv("root||" + codePath) + 1;

    	CodeDto codeDto = new CodeDto();
    	codeDto.setCode_path("root||" + codePath);
    	codeDto.setUse_yn("y");
    	codeDto.setCode_lv(toStr_array("root||" + codePath, "||").length+number-1);
     	List<CodeDto> codeList = codeDao.selectCodeChildIncludeList(codeDto);

    	int size = codeList.size();
    	
    	if(code_nm_no<1 || code_nm_no>5){
			code_nm_no = 1;
		}
    	
    	StringBuffer combo = new StringBuffer();
    	
    	// innerHtml 부분 및 기본 형식
    	for(int i=0; i<number; i++){
    		if(i==0){
    			combo.append(" <span id=\"" + span_nm + "0\"> \n");
    			combo.append(selectCodePathOne(codePath, select_nm+"0", select_nm+"0", "onchange=\"cb_" + span_nm + "(this, 1)\"", (option_nm.length()>0?"- " + option_nm+(i+1) + " -":""), ""));
            	combo.append(" </span>\n");
    		}else{
    			combo.append(" <span id=\"" + span_nm + i + "\"> \n");
	        	combo.append(" <select name=\"" + select_nm + i + "\" id=\"" + select_nm + i + "\" > \n");
	        	
	        	//combo.append(" 	<option value=\"\"> - 선택 하세요 - </option> \n");
	        	
	        	if(option_nm!=null && option_nm.length()>0){
	        		combo.append(" 	<option value=\"\"> - "+option_nm+(i+1)+" - </option> \n");
	        	}else{
	        		combo.append(" 	<option value=\"\"> - 선택 하세요 - </option> \n");
	        	}
	        	
	        	combo.append(" </select>");
	        	combo.append(" </span>\n");
    		}
    	}

    	// java script
    	combo.append(" <script> \n");
    	combo.append(" //<![CDATA[\n");
    	
    	// 스크립트 전역 변수 선언
    	combo.append(" var cd" + select_nm + " = new Array(); 		\n");	// 자바스크립트 코드 배열 선언
    	combo.append(" cd" + select_nm + "[0]= new Array();			\n");	// cd + codePath[0] 배열 선언  (코드)
    	combo.append(" cd" + select_nm + "[1]= new Array(); 		\n");	// cd + codePath[1] 배열 선언   (코드설명)
    	combo.append(" cd" + select_nm + "[2]= new Array(); 		\n");	// cd + codePath[2] 배열 선언   (코드경로[부모코드])
    	combo.append(" var snm" + select_nm + " = '" + span_nm + "';\n");	// span 이름

    	for(int i=0; i<size; i++){
    		CodeDto codebean = codeList.get(i);
    		combo.append(" cd" + select_nm+ "[0][" + i + "]=\"" + codebean.getCode_path() + "||" + codebean.getCode() + "\"; ");		// code
    		combo.append(" cd" + select_nm+ "[1][" + i + "]=\"" + codebean.getCode_nms()[code_nm_no-1] + "\"; ");	// code name
    		combo.append(" cd" + select_nm+ "[2][" + i + "]=\"" + codebean.getCode_path() + "\"; ");// code path
    	}
    	combo.append(" \n");
	
    	// 스크립트 함수 선언
    	combo.append(" function cb_" + span_nm + "(obj, no){ \n");
    	combo.append(" 	var search_cd = obj.options[obj.selectedIndex].value; \n");
    	combo.append(" 	var current_no = eval(no); \n");
    	combo.append(" 	var next_no = current_no+1; \n");
    	combo.append(" 	var max_no = " + number +"; \n");
    	combo.append(" 	if(search_cd==''){ \n");
    	combo.append(" 		for(i=current_no; i<max_no; i++){ \n");
    	combo.append(" 			var select = document.getElementById(snm" + select_nm + "+i); \n");
    	combo.append(" 			var html = ''; \n");
    	combo.append(" 			html += '<select name=\"" + select_nm + "' + no + '\" id=\"" + select_nm + "' + no + '\" >'; \n");
    	
    	//combo.append(" 			html += '<option value=\"\"> - 선택 하세요 - </option>'; \n");
    	
    	
    	if(option_nm!=null && option_nm.length()>0){
    		combo.append(" 		html += '<option value=\"\"> - "+option_nm+"'+(no+1)+' - </option>'; \n");
    	}else{
    		combo.append(" 		html += '<option value=\"\"> - 선택 하세요 - </option>'; \n");
    	}
        	
     	
    	combo.append(" 			html += '</select>'; \n");
    	combo.append(" 			select.innerHTML = html; \n");
    	combo.append(" 		} \n");
    	combo.append(" 	}else{ \n");
    	combo.append(" 		for(j=current_no; j<max_no; j++){ \n");
    	combo.append(" 			var select = document.getElementById(snm" + select_nm + "+j); \n");
    	combo.append(" 			var html = ''; \n");
    	combo.append(" 			if(j==current_no){ \n");
    	combo.append("   			html += '<select name=\"" + select_nm + "' + j +  '\" id=\"" + select_nm + "' + j + '\" '; \n");
    	combo.append(" 				if(max_no>next_no){ \n");
    	combo.append(" 					html += 'onchange=\"cb_" + span_nm + "(this, ' + next_no + ')\">'; \n");
    	combo.append(" 				} \n");
    	combo.append(" 				html += '>'; \n");
    	combo.append(" 				var size =  cd" + select_nm + "[0].length; \n");
    	combo.append(" 				for(i=0; i<size; i++){ \n");
    	combo.append(" 					if(cd" + select_nm + "[0][i] == search_cd){ \n");
    	combo.append(" 						html += '<option value=\"\"> - ' + cd" + select_nm + "[1][i] + ' 선택 - </option>'; \n");
    	combo.append(" 						break; \n");
    	combo.append(" 					} \n");
    	combo.append(" 				} \n");
    	combo.append(" 				for(i=0; i<size; i++){	\n");
    	combo.append(" 					if(cd" + select_nm + "[2][i] == search_cd  ){ \n");
    	combo.append(" 						html += '<option value=\"' + cd" + select_nm + "[0][i] + '\">' + cd" + select_nm + "[1][i] + '</option>'; \n");
    	combo.append(" 					} \n");
    	combo.append(" 				} \n");
      	combo.append(" 				html += '</select>'; \n");
      	combo.append(" 			}else{ \n");
    	combo.append(" 				html += '<select name=\"" + select_nm + "' + j + '\" id=\"" + select_nm + "' + j + '\" >'; \n");
    	
    	//combo.append(" 			html += '<option value=\"\"> - 선택 하세요 - </option>'; \n");
    	

    	if(option_nm!=null && option_nm.length()>0){
    		combo.append(" 			html += '<option value=\"\"> - "+option_nm+"' + (no+1) + ' - </option>'; \n");
    	}else{
    		combo.append(" 			html += '<option value=\"\"> - 선택 하세요 - </option>'; \n");
    	}
    	
    	combo.append(" 				html += '</select>'; \n");     	
      	combo.append(" 			} \n");
      	combo.append(" 			select.innerHTML = html; \n");
      	combo.append(" 		} \n");
    	combo.append(" 	} \n");
    	combo.append(" } \n");

    	if(current_value!=null){
	    	for(int i=0; i<(number>current_value.length?current_value.length:number); i++){
	    		combo.append(" for(i=0; i<document.getElementById(\""+ (select_nm +i) +"\").length; i++){ \n");
	    		combo.append(" 	if(document.getElementById(\""+ (select_nm +i) +"\")[i].value==\""+current_value[i]+"\"){ \n");
	    		combo.append("		document.getElementById(\""+ (select_nm +i) +"\")[i].selected=true; \n");
				combo.append("		break; \n");
				combo.append("	} \n");
				combo.append(" } \n");
				if(i<current_value.length && current_value[i]!=null && !"".equals(current_value[i]) ){
					combo.append(" cb_" + span_nm + "(document.getElementById(\""+ (select_nm +i) +"\"), "+(i+1)+"); \n");
				}
			}
    	}

    	if(option_nm==null || option_nm.length()==0){
    		combo.append(" cb_" + span_nm + "(document.getElementById('"+select_nm+"0'), 1);\n");
    	}
    	
    	combo.append(" //]]> \n");
    	combo.append(" </script> \n");
    	combo.append(" <noscript><p>카테고리 선택 스크립트가 동작 하지 않습니다.</p></noscript> \n");
        return combo.toString();
    }
    
    
    
    
	
	// 단축형
    public static String selectMulti2(String codePath, String select_nm, String option_nm, String[] current_value, String span_nm) throws Exception {
        return selectMulti2(codePath, select_nm, option_nm, 1, current_value, span_nm);  
    }
    public static String selectMulti2(String codePath, String select_nm, String option_nm, int code_nm_no, String[] current_value, String span_nm) throws Exception {

    	int number = codeDao.selectCodeMaxLvLike("root||" + codePath) - codeDao.selectCodeMaxLv("root||" + codePath) + 1;

    	CodeDto codeDto = new CodeDto();
    	codeDto.setCode_path("root||" + codePath);
    	codeDto.setUse_yn("y");
    	codeDto.setCode_lv(toStr_array("root||" + codePath, "||").length+number-2);

    	List<CodeDto> codeList = codeDao.selectCodeChildIncludeList(codeDto);

    	int size = codeList.size();
    	
    	if(code_nm_no<1 || code_nm_no>5){
			code_nm_no = 1;
		}
    	
    	StringBuffer combo = new StringBuffer();
    	
    	// innerHtml 부분 및 기본 형식
    	for(int i=0; i<number; i++){
    		if(i==0){
    			combo.append(" <span id=\"" + span_nm + "0\"> \n");
    			combo.append(selectCodePathOne(codePath, select_nm+"0", select_nm+"0", "onchange=\"cb_" + span_nm + "(this, 1)\"", (option_nm.length()>0?"- " + option_nm + " -":""), ""));
            	combo.append(" </span>\n");
    		}else{
    			combo.append(" <span id=\"" + span_nm + i + "\"></span> \n");
    		}
    	}

    	// java script
    	combo.append(" <script> \n");
    	combo.append(" //<![CDATA[\n");
    	
    	// 스크립트 전역 변수 선언
    	combo.append(" var cd" + select_nm + " = new Array(); 		\n");	// 자바스크립트 코드 배열 선언
    	combo.append(" cd" + select_nm + "[0]= new Array();			\n");	// cd + codePath[0] 배열 선언  (코드)
    	combo.append(" cd" + select_nm + "[1]= new Array(); 		\n");	// cd + codePath[1] 배열 선언   (코드설명)
    	combo.append(" cd" + select_nm + "[2]= new Array(); 		\n");	// cd + codePath[2] 배열 선언   (코드경로[부모코드])
    	combo.append(" var snm" + select_nm + " = '" + span_nm + "';\n");	// span 이름

    	for(int i=0; i<size; i++){
    		CodeDto codebean = codeList.get(i);
    		combo.append(" cd" + select_nm+ "[0][" + i + "]=\"" + codebean.getCode_path() + "||" + codebean.getCode() + "\"; ");		// code
    
    		//combo.append(" cd" + select_nm+ "[1][" + i + "]=\"" + codebean.getCode_nm() + "\"; ");	// code name
      		combo.append(" cd" + select_nm+ "[1][" + i + "]=\"");	// code name    			
    		combo.append(codebean.getCode_nms()[code_nm_no-1]);    		
    		combo.append("\"; ");	// code name    		
    		
    		combo.append(" cd" + select_nm+ "[2][" + i + "]=\"" + codebean.getCode_path() + "\"; ");// code path
    	}
    	combo.append(" \n");
	
    	// 스크립트 함수 선언
    	combo.append(" function cb_" + span_nm + "(obj, no){ \n");
    	combo.append(" 	var search_cd = obj.options[obj.selectedIndex].value; \n");
    	combo.append(" 	var current_no = eval(no); \n");
    	combo.append(" 	var next_no = current_no+1; \n");
    	combo.append(" 	var max_no = " + number +"; \n");
    	combo.append(" 	if(search_cd==''){ \n");
    	combo.append(" 		for(i=current_no; i<max_no; i++){ \n");
    	combo.append(" 			document.getElementById(snm" + select_nm + "+i).innerHTML = ''; \n");
    	combo.append(" 		} \n");
    	combo.append(" 	}else{ \n");
    	combo.append(" 		for(j=current_no; j<max_no; j++){ \n");
    	combo.append(" 			var select = document.getElementById(snm" + select_nm + "+j); \n");
    	combo.append(" 			var html = ''; \n");
    	combo.append(" 			if(j==current_no){ \n");
    	combo.append("   			html += '<select name=\"" + select_nm + "' + j +  '\" id=\"" + select_nm + "' + j + '\" '; \n");
    	combo.append(" 				var cd_select_nm =  \"\"; \n");
    	combo.append(" 				var size =  cd" + select_nm + "[0].length; \n");
    	combo.append(" 				for(i=0; i<size; i++){ \n");
    	combo.append(" 					if(cd" + select_nm + "[0][i] == search_cd){ \n");
    	combo.append(" 						cd_select_nm = cd" + select_nm + "[1][i] \n");
    	combo.append(" 						break; \n");
    	combo.append(" 					} \n");
    	combo.append(" 				} \n");
    	combo.append(" 				if(max_no>next_no){ \n");
    	combo.append(" 					html += 'onchange=\"cb_" + span_nm + "(this, ' + next_no + ')\" title=\"' + cd_select_nm + '\" >'; \n");
    	combo.append(" 				} \n");
    	combo.append(" 				html += 'title=\"' + cd_select_nm + '\" >'; \n");
    	//combo.append("				html += '<optgroup label=\"' + cd_select_nm + '\" >'; \n");
    	combo.append(" 				html += '<option value=\"\"> - ' + cd_select_nm + ' 선택 - </option>'; \n");
    	combo.append(" 				var isOption = false; \n");
    	combo.append(" 				for(i=0; i<size; i++){	\n");
    	combo.append(" 					if(cd" + select_nm + "[2][i] == search_cd  ){ \n");
    	combo.append(" 						isOption = true; \n");
    	combo.append(" 						html += '<option value=\"' + cd" + select_nm + "[0][i] + '\">' + cd" + select_nm + "[1][i] + '</option>'; \n");
    	combo.append(" 					} \n");
    	combo.append(" 				} \n");
    	//combo.append(" 				html += '</optgroup>'; \n");
      	combo.append(" 				html += '</select>'; \n");
      	combo.append(" 				if(!isOption){ \n");
      	combo.append(" 					html = ''; \n");
      	combo.append(" 				} \n");
      	combo.append(" 			}else{ \n");
    	combo.append(" 				html = ''; \n");
      	combo.append(" 			} \n");
      	combo.append(" 			select.innerHTML = html; \n");
      	combo.append(" 		} \n");
    	combo.append(" 	} \n");
    	combo.append(" } \n");

    	if(current_value!=null){
	    	for(int i=0; i<(number>current_value.length?current_value.length:number); i++){
	    		combo.append(" if(document.getElementById(\""+ (select_nm +i) +"\")){\n");
	    		combo.append(" 	for(i=0; i<document.getElementById(\""+ (select_nm +i) +"\").length; i++){ \n");
	    		combo.append(" 		if(document.getElementById(\""+ (select_nm +i) +"\")[i].value==\""+current_value[i]+"\"){ \n");
	    		combo.append("			document.getElementById(\""+ (select_nm +i) +"\")[i].selected=true; \n");
				combo.append("			break; \n");
				combo.append("		} \n");
				combo.append(" 	} \n");
				if(i<current_value.length && current_value[i]!=null && !"".equals(current_value[i]) ){
					combo.append(" 	cb_" + span_nm + "(document.getElementById(\""+ (select_nm +i) +"\"), "+(i+1)+"); \n");
				}
				combo.append(" }\n");
				
			}
    	}

    	if(option_nm==null || option_nm.length()==0){
    		combo.append(" cb_" + span_nm + "(document.getElementById('"+select_nm+"0'), 1);\n");
    	}
    	
    	combo.append(" //]]> \n");
    	combo.append(" </script> \n");
    	combo.append(" <noscript><p>카테고리 선택 스크립트가 동작 하지 않습니다.</p></noscript> \n");
        return combo.toString();
  
    }
    
    //
    public static String selectMulti(String codePath, String select_nm, String option_nm, String[] current_value, String span_nm, boolean isreplace) throws Exception {
    	if(isreplace){
    		return replaceAll(replaceAll(selectMulti(codePath, select_nm, option_nm, 1, current_value, span_nm), "root||"+ codePath + "||", ""), "root||"+ codePath, "");
    	}else{
    		return selectMulti(codePath, select_nm, option_nm, 1, current_value, span_nm);
    	}
    }
    
    public static String selectMulti(String codePath, String select_nm, String option_nm, int code_nm_no, String[] current_value, String span_nm, boolean isreplace) throws Exception {
    	if(isreplace){
    		return replaceAll(replaceAll(selectMulti(codePath, select_nm, option_nm, code_nm_no, current_value, span_nm), "root||"+ codePath + "||", ""), "root||"+ codePath, "");
    	}else{
    		return selectMulti(codePath, select_nm, option_nm, code_nm_no, current_value, span_nm);
    	}
    }
    //
    public static String selectMulti2(String codePath, String select_nm, String option_nm, String[] current_value, String span_nm, boolean isreplace) throws Exception {
    	if(isreplace){
    		return replaceAll(replaceAll(selectMulti2(codePath, select_nm, option_nm, 1, current_value, span_nm), "root||"+ codePath + "||", ""), "root||"+ codePath, "");
    	}else{
    		return selectMulti2(codePath, select_nm, option_nm, 1, current_value, span_nm);
    	}
    }
    public static String selectMulti2(String codePath, String select_nm, String option_nm, int code_nm_no, String[] current_value, String span_nm, boolean isreplace) throws Exception {
    	if(isreplace){
    		return replaceAll(replaceAll(selectMulti2(codePath, select_nm, option_nm, code_nm_no, current_value, span_nm), "root||"+ codePath + "||", ""), "root||"+ codePath, "");
    	}else{
    		return selectMulti2(codePath, select_nm, option_nm, code_nm_no, current_value, span_nm);
    	}
    }
	
	/*************************************************************************
	 *@제목		: checkBox 생성
	 *@참조키 	: codePath, checkbox_nm, checkbox_tag, current_value, split_symbol
	 *@적성일	: 2009. 3. 16
	 *@RETURN 	: String 
	 *************************************************************************/	
	public static String checkBox(String codePath, String checkbox_nm, String checkbox_tag, String current_value, String split_symbol) throws Exception {
		return checkBox(codePath, checkbox_nm, "", checkbox_tag, "", 1, current_value, split_symbol );
	}
	public static String checkBox(String codePath, String checkbox_nm, String checkbox_tag, int code_nm_no, String current_value, String split_symbol) throws Exception {
		return checkBox(codePath, checkbox_nm, "", checkbox_tag, "", code_nm_no, current_value, split_symbol );
	}
	//
	public static String checkBox(String codePath, String checkbox_nm, String div_tag, String checkbox_tag, String label_tag, String current_value, String split_symbol ) throws Exception {
		return checkBox(codePath,checkbox_nm, div_tag, checkbox_tag, label_tag, 1, current_value, split_symbol );
	}	
	public static String checkBox(String codePath, String checkbox_nm, String div_tag, String checkbox_tag, String label_tag, int code_nm_no, String current_value, String split_symbol ) throws Exception {
		return checkBox(codePath, checkbox_nm, checkbox_nm, div_tag, checkbox_tag, label_tag, code_nm_no, current_value, split_symbol );
	}	
	public static String checkBox(String codePath, String checkbox_nm, String checkbox_id, String div_tag, String checkbox_tag, String label_tag, int code_nm_no, String current_value, String split_symbol ) throws Exception {
		CodeDto codeDto = new CodeDto();
		codeDto.setCode_path("root||" + codePath);
		codeDto.setUse_yn("y");
		List<CodeDto> codeList = codeDao.selectCodeList(codeDto);

		if(code_nm_no<1 || code_nm_no>5){
			code_nm_no = 1;
		}
		
		StringBuffer checkbox = new StringBuffer();
		
		String values[] = toStr_array(current_value, split_symbol);
		
		
		HashMap<String,String> valueHash = new HashMap<String,String>();
		for(int i=0; i<values.length; i++){
			if(null!=values[i] && !"".equals(values[i])){
				valueHash.put(values[i], "checked=\"checked\"");
			}
		}
		for(int i=0; i<codeList.size(); i++){
			CodeDto codeBean = codeList.get(i);
			String code_nm = codeBean.getCode_nms()[code_nm_no-1];
			
			String checked = valueHash.get(codeBean.getCode())==null?"":valueHash.get(codeBean.getCode())+"";
			if(div_tag.length()>0){
				checkbox.append("<div "+div_tag+"><input type=\"checkbox\" name=\"" + checkbox_nm + "\" id=\"" + checkbox_id + i + "\" value=\"" + codeBean.getCode() + "\" title=\"" + code_nm + "\" " + checkbox_tag + " " + checked + " /><label for=\""+checkbox_id+i+"\" "+label_tag+">" + code_nm + "</label></div>");
			}else{
				checkbox.append("<input type=\"checkbox\" name=\"" + checkbox_nm + "\" id=\"" + checkbox_id + i + "\" value=\"" + codeBean.getCode() + "\" title=\"" + code_nm + "\" " + checkbox_tag + " " + checked + " /><label for=\""+checkbox_id+i+"\" "+label_tag+">" + code_nm + "</label>\n");
			}
		}			
		return checkbox.toString();
	}
	//
	public static String checkBoxBetween(String codePath, String checkbox_nm, String checkbox_tag, String between_str, String current_value, String split_symbol) throws Exception {
		return checkBoxBetween(codePath, checkbox_nm, "", checkbox_tag, "", 1, between_str, current_value, split_symbol );
	}
	public static String checkBoxBetween(String codePath, String checkbox_nm, String checkbox_tag, int code_nm_no, String between_str, String current_value, String split_symbol) throws Exception {
		return checkBoxBetween(codePath, checkbox_nm, "", checkbox_tag, "", code_nm_no, between_str, current_value, split_symbol );
	}
	//
	public static String checkBoxBetween(String codePath, String checkbox_nm, String div_tag, String checkbox_tag, String label_tag, String between_str, String current_value, String split_symbol ) throws Exception {
		return checkBoxBetween(codePath, checkbox_nm, div_tag, checkbox_tag, label_tag, 1, between_str, current_value, split_symbol);
	}
	public static String checkBoxBetween(String codePath, String checkbox_nm, String div_tag, String checkbox_tag, String label_tag, int code_nm_no, String between_str, String current_value, String split_symbol ) throws Exception {
		CodeDto codeDto = new CodeDto();
		codeDto.setCode_path("root||" + codePath);
		codeDto.setUse_yn("y");
		List<CodeDto> codeList = codeDao.selectCodeList(codeDto);
		
		HashMap<String,String> betweenCodeHash = new HashMap<String,String>();
		String[] between_code_array = null;
		
		if(between_str!=null && between_str.length()>0){
			between_code_array = toStr_array(between_str, ",");
			for(String code : between_code_array){
				betweenCodeHash.put(code, "true");
			}
		}
		
		if(code_nm_no<1 || code_nm_no>5){
			code_nm_no = 1;
		}

		StringBuffer checkbox = new StringBuffer();

		String values[] = toStr_array(current_value, split_symbol);
		HashMap<String,String> valueHash = new HashMap<String,String>();
		for(int i=0; i<values.length; i++){
			if(null!=values[i] && !"".equals(values[i])){
				valueHash.put(values[i], "checked=\"checked\"");
			}
		}
		for(int i=0; i<codeList.size(); i++){
			CodeDto codeBean = (CodeDto)codeList.get(i);
			String code_nm = codeBean.getCode_nms()[code_nm_no-1];
			if(betweenCodeHash.get(codeBean.getCode())!=null){			
				String checked = valueHash.get(codeBean.getCode())==null?"":valueHash.get(codeBean.getCode())+"";
				if(div_tag.length()>0){
					checkbox.append("<div "+div_tag+"><input type=\"checkbox\" name=\"" + checkbox_nm + "\" id=\"" + checkbox_nm + i + "\" value=\"" + codeBean.getCode() + "\" title=\"" + code_nm + "\" " + checkbox_tag + " " + checked + " /><label for=\""+checkbox_nm+i+"\" "+label_tag+">" + code_nm + "</label></div>");
				}else{
					checkbox.append("<input type=\"checkbox\" name=\"" + checkbox_nm + "\" id=\"" + checkbox_nm + i + "\" value=\"" + codeBean.getCode() + "\" title=\"" + code_nm + "\" " + checkbox_tag + " " + checked + " /><label for=\""+checkbox_nm+i+"\" "+label_tag+">" + code_nm + "</label>\n");
				}
			}
		}			
		return checkbox.toString();
	}
	/*************************************************************************
	 *@제목		: radio 생성
	 *@참조키 	: codePath, radio_nm, radio_tag, current_value, etc_tag
	 *@적성일	: 2009. 3. 16
	 *@RETURN 	: String 
	 *************************************************************************/	
	public static String radio(String codePath, String radio_nm, String radio_tag, String current_value, String etc_tag) throws Exception {
		return radio(codePath, radio_nm, radio_tag, 1, current_value, etc_tag);
	}
	public static String radio(String codePath, String radio_nm, String radio_tag, int code_nm_no, String current_value, String etc_tag) throws Exception {
		CodeDto codeDto = new CodeDto();
		codeDto.setCode_path("root||" + codePath);
		codeDto.setUse_yn("y");
		List<CodeDto> codeList = codeDao.selectCodeList(codeDto);
		
		if(code_nm_no<1 || code_nm_no>5){
			code_nm_no = 1;
		}
		
		StringBuffer radio = new StringBuffer();
		for(int i=0; i<codeList.size(); i++){
			CodeDto codeBean = codeList.get(i);
			
			String code_nm = codeBean.getCode_nms()[code_nm_no-1];
			
			String checked = codeBean.getCode().equals(current_value)?"checked=\"checked\"":"";
			radio.append("<input type=\"radio\" name=\"" + radio_nm + "\" id=\"" + radio_nm + i + "\" value=\"" + codeBean.getCode() + "\" " + radio_tag + " " + checked + " /> <label for=\""+ radio_nm + i +"\">" + code_nm +  etc_tag + "</label>\n");
		}
		return radio.toString().trim();
	}
	//
	public static String radioAddAll(String codePath, String radio_nm, String radio_tag, String current_value, String all_label, String etc_tag) throws Exception {
		return radioAddAll(codePath, radio_nm, radio_tag, 1, current_value, all_label, etc_tag);
	}	
	public static String radioAddAll(String codePath, String radio_nm, String radio_tag, int code_nm_no, String current_value, String all_label, String etc_tag) throws Exception {
		CodeDto codeDto = new CodeDto();
		codeDto.setCode_path("root||" + codePath);
		codeDto.setUse_yn("y");
		List<CodeDto> codeList = codeDao.selectCodeList(codeDto);
		
		if(code_nm_no<1 || code_nm_no>5){
			code_nm_no = 1;
		}
		
		StringBuffer radio = new StringBuffer();
		
		radio.append("<input type=\"radio\" name=\"" + radio_nm + "\" id=\"" + radio_nm +  "0\" value=\"\" " + radio_tag + " " + (current_value==null || current_value.equals("")? "checked=\"checked\"" : "") + " /> <label for=\""+ radio_nm +"0\"> "+(all_label==null || all_label.length()>0 ? all_label :"전체")+  etc_tag + "</label>\n");
		
		for(int i=0; i<codeList.size(); i++){
			CodeDto codeBean = codeList.get(i);
			
			String code_nm = codeBean.getCode_nms()[code_nm_no-1];
			
			String checked = codeBean.getCode().equals(current_value)?"checked=\"checked\"":"";
			radio.append("<input type=\"radio\" name=\"" + radio_nm + "\" id=\"" + radio_nm + (i+1) + "\" value=\"" + codeBean.getCode() + "\" " + radio_tag + " " + checked + " /> <label for=\""+ radio_nm + (i+1) +"\">" + code_nm +  etc_tag + "</label>\n");
		}
		return radio.toString().trim();
	}	
	
	/*************************************************************************
	 *@제목		: HashMap 코드/코드명
	 *@참조키 	: codePath
	 *@적성일	: 2009. 3. 25
	 *@RETURN 	: String 
	 *************************************************************************/	
	public static HashMap<String,String> selectHash(String codePath) throws Exception {
		return selectHash(codePath,1);
	}
	public static HashMap<String,String> selectHash(String codePath,int code_nm_no) throws Exception {
		CodeDto codeDto = new CodeDto();
		codeDto.setCode_path("root||" + codePath);
		codeDto.setUse_yn("y");
		//List<CodeDto> codeList = codeDao.selectCodeList(codeDto);
		
		List<CodeDto> codeList = codeDao.selectCodeList(codeDto);

		
		if(code_nm_no<1 || code_nm_no>5){
			code_nm_no = 1;
		}
		
		HashMap<String,String> codeHash = new HashMap<String,String>();
		for(int i=0; i<codeList.size(); i++){
			CodeDto codeBean = codeList.get(i);			
			String code_nm = codeBean.getCode_nms()[code_nm_no-1];			
			codeHash.put(codeBean.getCode(), (String)code_nm);
		}
		return codeHash;
	}
	
	/*************************************************************************
	 *@제목		: HashMap 코드path /코드 path name
	 *@참조키 	: codePath, isreplace
	 *@적성일	: 2009. 3. 25
	 *@RETURN 	: String 
	 *************************************************************************/	
	public static HashMap<String,String> selectHashAll(String codePath, boolean isreplace) throws Exception {
		return selectHashAll(codePath, isreplace,1);
	}
	
	public static HashMap<String,String> selectHashAll(String codePath, boolean isreplace,int code_nm_no) throws Exception {
		return selectHashAll(codePath,  "||", isreplace, 1);
	}
	/*************************************************************************
	 *@제목		: HashMap 코드path /코드 path name
	 *@참조키 	: codePath, symbol, isreplace
	 *@적성일	: 2009. 4. 9
	 *@RETURN 	: String 
	 *************************************************************************/	
	public static HashMap<String,String> selectHashAll(String codePath, String symbol, boolean isreplace) throws Exception {
		return selectHashAll(codePath, symbol, isreplace, 1);
	}
	public static HashMap<String,String> selectHashAll(String codePath, String symbol, boolean isreplace, int code_nm_no) throws Exception {
		CodeDto codeDto = new CodeDto();
		codeDto.setCode_path("root||" + codePath);
		codeDto.setUse_yn("y");
		List<CodeDto> codeList = codeDao.selectCodeALLList(codeDto);
		
		if(code_nm_no<1 || code_nm_no>5){
			code_nm_no = 1;
		}
		
		CodeDto pcodeDto = codeDao.selectCode(codeDto);
		String root_codepath_nm = replaceAll(pcodeDto.getCode_path_nms()[code_nm_no-1], "||", symbol)+symbol;

		HashMap<String,String> codeHash = new HashMap<String,String>();
		for(int i=0; i<codeList.size(); i++){
			CodeDto codeBean = codeList.get(i);
			String key = codeBean.getCode_path()+"||"+codeBean.getCode();
			String value = replaceAll(codeBean.getCode_path_nm1(), "||", symbol);
			if(isreplace){
				key = replaceAll(key, "root||" + codePath + "||","");
				value = replaceAll(value,root_codepath_nm,"");
			}
			codeHash.put(key , value);
		}
		return codeHash;
	}
	
	
	/*************************************************************************
	 *@제목		: 코드이름 
	 *@참조키 	: codePath, code
	 *@적성일	: 2009. 3. 16
	 *@RETURN 	: String 
	 *************************************************************************/	
	public static String selectCodeNm(String codePath, String code) throws Exception {
		return selectCodeNm(codePath, code, 1);
	}
	public static String selectCodeNm(String codePath, String code, int code_nm_no) throws Exception {
		String code_nm = "";
		if(code==null || code.length()==0 || codePath==null || codePath.length()==0 ){
			code_nm = "";
		}else{
			CodeDto codeDto = new CodeDto();
			codeDto.setCode_path("root||" + codePath);
			codeDto.setUse_yn("y");
			codeDto.setCode(code);
			
			CodeDto codeBean = codeDao.selectCode(codeDto);
			
			if(code_nm_no<1 || code_nm_no>5){
				code_nm_no = 1;
			}
			
			code_nm = codeBean.getCode_nms()[code_nm_no-1];
		}
		return code_nm;
	}
	/*************************************************************************
	 *@제목		: 코드이름 열거 예) sun,tues,wed -> 일,화,수
	 *@참조키 	: codePath, symbol, code_str, return_symbol
	 *@적성일	: 2010. 1. 2
	 *@RETURN 	: String 
	 *************************************************************************/	
	public static String selectCodeNmStr(String codePath, String symbol, String code_str, String return_symbol) throws Exception {
		return selectCodeNmStr(codePath, symbol, code_str, return_symbol, 1);
	}
	public static String selectCodeNmStr(String codePath, String symbol, String code_str, String return_symbol, int code_nm_no) throws Exception {
		String code_array[] = toStr_array(code_str, symbol); 
		HashMap<String,String> codeHash = selectHash(codePath, code_nm_no);
		StringBuffer code_nm_str = new StringBuffer(); 
		for(int i=0; i<code_array.length; i++){
			String code_value = codeHash.get(code_array[i]);
			if(code_value!=null){
				code_nm_str.append(code_value);
			}
			if(i < code_array.length-1){
				code_nm_str.append(return_symbol);
			}
		}
		return code_nm_str.toString();
	}
	
	/*************************************************************************
	 *@제목		: 코드 Path 이름 
	 *@참조키 	: root_code_path(코드 이름만), code_path (/type/3/2)
	 *@적성일	: 2009. 3. 16
	 *@RETURN 	: String 
	 *************************************************************************/	
	public static String selectCodePathNm(String code_path, String code) throws Exception {
		return selectCodePathNm(code_path, code, 1);
	}
	public static String selectCodePathNm(String code_path, String code, int code_nm_no) throws Exception {
		CodeDto codeDto = new CodeDto();
		codeDto.setCode_path("root||" + code_path);
		codeDto.setUse_yn("y");
		codeDto.setCode(code);
		CodeDto codeBean= codeDao.selectCode(codeDto);
		
		if(code_nm_no<1 || code_nm_no>5){
			code_nm_no = 1;
		}

		return codeBean.getCode_path_nms()[code_nm_no];
	}
	
	private static String toString(String value){
		return (value==null || value.trim().equals("") || value.equals("null"))? "" : value;
	}
	
	private static String replaceAll( String str, String s1, String s2 ){
		str = toString(str);
		if(s1!=null && s2!=null){
			StringBuffer result = new StringBuffer();
			if(s1.length()>0){				
				String s = str;
				int index1 = 0;
				int index2 = s.indexOf(s1);
		
				while(index2 >= 0) {
					result.append( str.substring(index1, index2) );
					result.append( s2 );
					index1 = index2 + s1.length();
					index2 = s.indexOf(s1, index1);
				}
				result.append( str.substring( index1 ) );
			}else{
				result.append(str);
			}
			return result.toString();
		}else{
			return str;
		}		
	}
	
	private static String[] toStr_array(String value, String split_symbol){
		return replaceAll(value, split_symbol, "##d##i##v##").split("##d##i##v##");
	}
	
}
package com.hankook.pg.content.admin.notice.controller;
import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.hankook.pg.common.util.Fn;
import com.hankook.pg.content.admin.notice.dto.FileUploadVo;

@Controller
@RequestMapping("/ckeditor")
public class CKEditorController{
	
	@Value("${file.upload.location}")
	private String location;
	
	@PostMapping("/fileupload")
    public ModelAndView fileUpload(@ModelAttribute("fileUploadVo") FileUploadVo fileUploadVo , HttpServletRequest request , ModelAndView mav){

		String uploadFilePath = location+"/";
		
        MultipartFile upload = fileUploadVo.getUpload();
        String filename = "";
        String CKEditorFuncNum = "";
        
        if(upload != null){
        	String prefix = upload.getOriginalFilename().substring(upload.getOriginalFilename().lastIndexOf(".")+1, upload.getOriginalFilename().length());
        	filename = UUID.randomUUID().toString() + "." + prefix;
            fileUploadVo.setFilename(filename);
            CKEditorFuncNum = fileUploadVo.getCKEditorFuncNum();
        	/* 현재 시간 설정 */
        	Date date_now = new Date(System.currentTimeMillis());
        	String currentym = Fn.toDateFormat(date_now, "yyyyMM");
        	
            try{
            	
            	File dir = new File(uploadFilePath+"editor/"+currentym);
            	
            	if(!dir.exists()){
	        		try {
	        			// 생성
	        			boolean result = dir.mkdir();
	        			
	        			if(result) {
	        				System.out.println("Directory is created.");
	        			}else {
	        				System.out.println("Failed to create directory.");		        				
	        			}
	        		}catch(Exception e) {
	        			System.out.println("Exception occurred.");
	        			e.getStackTrace();
	        		}
	        	}
                File file = new File(uploadFilePath+"editor/"+currentym+"/"+filename);
                upload.transferTo(file);
            }catch(IOException e){
                e.printStackTrace();
            }  
            mav.setViewName("/admin/notice/fileUploadComplete");
            mav.addObject("filePath",uploadFilePath+"editor/"+currentym+"/"+filename);          //결과값을
            mav.addObject("CKEditorFuncNum",CKEditorFuncNum);//jsp ckeditor 콜백함수로 보내줘야함
        }
        
        return mav;
    }
}
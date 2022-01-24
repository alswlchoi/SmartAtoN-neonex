package com.hankook.pg.content.user.notice.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/upfiles")
public class ImageController {
	
	@Value("${file.upload.location}")
	private String location;

    @GetMapping(value="/editor")
    public ResponseEntity<Resource> display(@Param("filename") String filename) {
    	String folder = "editor";
    	String fullPath = location + "/" + folder + "/" + filename;
    	
    	Resource resource = (Resource)new FileSystemResource(fullPath);
    	
    	if(!resource.exists())
    		return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
    	
    	HttpHeaders header = new HttpHeaders();
    	Path filePath = null;
    	
    	try {
    		filePath = Paths.get(fullPath);	//file의 경로를 구한다.
    		//파일의 확장자명에 따라 달라지는 Content-type, IMAGE/JPEG or IMAGE/PNG
    		header.add("Content-Type", Files.probeContentType(filePath));
    	}catch (IOException e) {
    		e.printStackTrace();
    	}
    	
    	return new ResponseEntity<Resource>(resource, header, HttpStatus.OK);
    }
}
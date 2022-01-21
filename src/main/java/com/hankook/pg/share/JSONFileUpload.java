package com.hankook.pg.share;

import lombok.Data;

@Data
public class JSONFileUpload {
	private String path;
	
	public JSONFileUpload() {
		super();
	}
	
	public JSONFileUpload(String path) {
		super();
		this.path = path;
	}
}

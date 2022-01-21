package com.hankook.pg.content.admin.trackPackage.dto;

import com.hankook.pg.share.Search;

import lombok.*;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class TrackPackageDto extends Search{
	private int num;
	private String tpId;
	private String tId;
	private String tpName;
	private String tName;
	private String searchInput;
	private int mapSeq;
	private String tLevel;
	private int tPrice;
}

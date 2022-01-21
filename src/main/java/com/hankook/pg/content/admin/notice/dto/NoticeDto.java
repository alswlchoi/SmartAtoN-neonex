package com.hankook.pg.content.admin.notice.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NoticeDto {

	private Integer nSeq; 			//일련번호
	private String nType; 		//게시판코드 (n:공지사항, s:자료실)
	private String nTitle;		//제목
	private String nContent;	//내용
	private String nTop;		//긴급여부
	private int nOrder; 		//우선순위
	private int nLevel; 		//댓글step
	private int nParent; 		//부모글 일련번호
	private String nRegDt;		//등록일
	private String nModDt;		//수정일
	private String nRegUser;	//등록아이디
	private String nModUser;	//수정아이디
	private int nTopOrder;	//긴급우선순위
	private String fName;	//파일이름
	private String fUrl;	//파읽경로

	private String type;
}
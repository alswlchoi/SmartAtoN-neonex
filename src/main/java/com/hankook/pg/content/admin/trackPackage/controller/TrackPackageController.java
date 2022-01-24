package com.hankook.pg.content.admin.trackPackage.controller;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.hankook.pg.content.admin.trackPackage.dto.TrackPackageDto;
import com.hankook.pg.content.admin.trackPackage.service.TrackPackageService;
import com.hankook.pg.content.auth.vo.AuthVO;
import com.hankook.pg.share.Paging;
import com.hankook.pg.share.Search;

import lombok.extern.slf4j.Slf4j;
@Slf4j
@RestController
@RequestMapping("/admin/trackPackage")
public class TrackPackageController {
	
	@Autowired
	private  TrackPackageService trackPackageService;
	
	@RequestMapping(value="",method= RequestMethod.GET)
	public ModelAndView getTrack() throws Exception {
		log.info("트랙");
		ModelAndView mv = new ModelAndView("/admin/trackPackage/trackPackage");
		return mv;
	}
	
	@PostMapping("/search")
    public Map<String, Object> searchPk(@RequestBody TrackPackageDto trackPackageDto) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		System.out.println("트랙패키지 페이지 조회"+trackPackageDto+"/page="+trackPackageDto.getPageNo());
		String[] arrOrderCoulmn = {"num"};
		trackPackageDto.setArrOrderColumn(arrOrderCoulmn);
		//리스트 10개 조회
		List<TrackPackageDto> list = trackPackageService.getTrackPackageList(trackPackageDto);
		//토탈 카운트
		int cnt = trackPackageService.getTrackCnt(trackPackageDto);
		//페이징 처리
		Search search = new Search();
		search.setPageNo(trackPackageDto.getPageNo());
		Paging paging = new Paging(search,cnt);
		result.put("list", list);
		result.put("paging", paging);
		result.put("totalCnt", cnt);
		return result;
	}
	
	@RequestMapping(value = "/detail-trackPackage")
    public Map<String, Object> getTrackPackageDetail(@RequestBody TrackPackageDto trackPackageDto) throws Exception {
		log.info("track list");
		Map<String, Object> result = new HashMap<String, Object>();
		List<TrackPackageDto> trackpackage = trackPackageService.getTrackPackageDetail(trackPackageDto.getTpId());
		//System.out.println("trackpackage" + trackpackage);
		List<TrackPackageDto> trackname = trackPackageService.getTrackName();
		//System.out.println("trackname" + trackname);
		
		result.put("trackPackage", trackpackage);
		result.put("trackName", trackname);
		return result;
    }
	
	@PostMapping("/delete")
	public int deleteTrack(@RequestBody TrackPackageDto trackPackageDto) throws Exception {
		log.info("delete deleteTrack");
		int cnt = trackPackageService.deleteTrackPackage(trackPackageDto);
		return cnt;
	}

	@PostMapping(value = "/insert")
	public int insertTrackNm(@RequestBody TrackPackageDto trackPackageDto) throws Exception {
		log.info("insert trackname");
		int data = trackPackageService.getEqTrackCnt(trackPackageDto);	
		System.out.println("data" + data);
		int cnt = 0;
		if(data > 0) {
			cnt = 999;
		}else {
			cnt = trackPackageService.insertTrackNm(trackPackageDto);
		}
		return cnt;
	}
}

package com.web.ddentist.ddit.pcheckup.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.web.ddentist.ddit.pcheckup.service.PcheckupService;
import com.web.ddentist.patient.service.PatientDetails;
import com.web.ddentist.vo.CheckupVO;

import lombok.extern.slf4j.Slf4j;


@Slf4j
@PreAuthorize("hasRole('ROLE_PT')")
@Controller
@RequestMapping("/ddit/checkup")
public class PcheckupController {
	
	@Autowired
	PcheckupService pcheckupService;
	
	@GetMapping("")
	public String home(Model model) {
		//환자 정보 
		PatientDetails ptInfo = (PatientDetails)SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String ptNum = ptInfo.getPtVO().getPtNum();
		 	
		Map<String, String> map = new HashMap<>();
		map.put("ptNum", ptNum);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar c = Calendar.getInstance();
		c.add(c.DATE, +1);
		String today = sdf.format(c.getTime());
		c.add(c.DATE, -7);
		String stDate = sdf.format(c.getTime());
		
		map.put("eDate", today);
		map.put("sDate", stDate);
		List<CheckupVO> checkupList = this.pcheckupService.pCheckupList(map);
		
		model.addAttribute("checkupList", checkupList);
		
		return "ddit/checkupList";
	}
	
	@GetMapping("/detail")
	public String detail(Model model,
			@ModelAttribute CheckupVO checkupVO) {
		log.info("asdfasdfvo : " + checkupVO);
		
		checkupVO = this.pcheckupService.detailCheckup(checkupVO);
		
		model.addAttribute("checkupVO", checkupVO);
//		
		return "ddit/checkupDetail";
	}
	
	// 날짜 검색
	@ResponseBody
	@GetMapping("/searchCheckup")
	public List<CheckupVO> searchCheckup(@RequestParam Map<String, String> map){
		PatientDetails ptInfo = (PatientDetails)SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String ptNum = ptInfo.getPtVO().getPtNum();
		
		map.put("ptNum", ptNum);	
		
		List<CheckupVO> checkupList = this.pcheckupService.pCheckupList(map);
		
		log.info("asdfasdf : " + checkupList);
		
		return checkupList;
	}
	
	
}

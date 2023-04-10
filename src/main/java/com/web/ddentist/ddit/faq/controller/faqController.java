package com.web.ddentist.ddit.faq.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.web.ddentist.ddit.faq.service.IPFaqService;
import com.web.ddentist.vo.FaqVO;
import com.web.ddentist.vo.PageVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/ddit/faq")
@Controller
public class faqController {
	
	@Autowired
	IPFaqService iPFaqService;
	
	//요청URL : localhost/ddit/faq
	@GetMapping("")
	public String faq(Model model,
			@RequestParam(value="currentPage", required=false, defaultValue="1") int currentPage
			,@RequestParam(value="faqType", required=false, defaultValue="") String faqType
			,@RequestParam(value="keyword", required=false, defaultValue="") String keyword
			) {
		
		//전체 리스트 받아서 담기
//		List<FaqVO> faqList = this.iPFaqService.getFaqList();
		
		//페이지 시작
		log.info("currentPage :" + currentPage);
		log.info("faqType :"+ faqType);
		log.info("keyword :"+ keyword);
		
		FaqVO faqVO = new FaqVO();
		//1) total
		faqVO.setFaqType(faqType);
		faqVO.setKeyword(keyword);
		log.info("setFaqTypeFaqVO :"+ faqVO);
		int total = this.iPFaqService.faqGetTotal(faqVO);
		log.info("total :"+ total);
		//2) size
		int size = 5;
		//3) content
		faqVO.setCurrentPage(currentPage);
		faqVO.setSize(size);
		log.info("faqVO.getCurrentPage() :"+ faqVO.getCurrentPage());
		List<FaqVO> content = this.iPFaqService.faqPageGetList(faqVO);
		log.info("content :"+ content);
		//4) blockSize
		int blockSize = 5;
		
		
		PageVO<FaqVO> pageVO = new PageVO<FaqVO>(total, currentPage, size, content, blockSize);
		log.info("pageVO :::::"+ pageVO);
		
//		model.addAttribute("faqList"+ faqList);
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("keyword", keyword);
		
		
		return "ddit/pfaq";
	}
	
}


































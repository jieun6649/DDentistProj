package com.web.ddentist.ddit.notice.service;

import java.util.List;
import java.util.Map;

import com.web.ddentist.vo.NoticeVO;

public interface IPNoticeService {

//	<!-- 전체 행의 수(total) -->
	public int getTotal();

	//파라미터로 받은 정보로 페이징처리하기
	public List<NoticeVO> beforePaginglist(Map<String, String> map);

	//상세 정보 조회
	public NoticeVO noticeDetail(NoticeVO noticeVO);

}

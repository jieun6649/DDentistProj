<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<style>
/* 삭제,수정, 목록으로 버튼 */
.listBtn {
	border-radius: 20px;
	border: none;
	background-color: #904aff;
	color: white;
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 500;
}
.violetBtn:hover{
	background-color:#7c3dde !important;
}

.redBtn:hover{
	background-color:#e13636 !important;
}
</style>
<!-- Head Image 시작 -->
<div class="boardHeadImage">
	<div class="wrapper">
		<div class="slide">
			<img src="/resources/images/layout/ddit/noticeHeadImg.png" />
		</div>
	</div>
</div>
<!-- Head Image 끝 -->
<!-- main section 시작 -->
<section class="container">
	<!-- 문의게시판 nav 시작 -->
	<div class="row" style="margin-left: 7%; margin-top: 50px; width: 85%; height: 100px; border-bottom: 1px solid gray;">
		<div class="col-12">
			<h4 style="margin-left: 50px; margin-top: 20px; font-family: 'Noto Sans KR', sans-serif; font-weight: 700;">${noticeVO.noTitle}</h4>
		</div>
		<div class="col-6">
			<div class="row">
				<h6 class="col-6" style="margin-left: 50px; font-family: 'Noto Sans KR', sans-serif; font-size: 14px;">작성일자 : <fmt:formatDate value="${noticeVO.noDt}" pattern="yyyy-MM-dd hh:mm:ss"/></h6>
				<h6 class="col-4" style="font-family: 'Noto Sans KR', sans-serif; font-size: 14px; display: inline-block;">작성자 : ${noticeVO.noWrtrNm}</h6>
			</div>
		</div>
	</div>
	<!-- 문의게시판 nav 끝 -->
	<div style="margin-left: 7%; margin-top: 50px; margin-bottom: 100px; width: 85%; height: auto;">
		<h5 style="margin-left: 50px; margin-right: 50px; font-family: 'Noto Sans KR', sans-serif;">${noticeVO.noContent}</h5>
	</div>
	<hr style="margin-left: 7%; width: 85%;" />

	<div style="margin-left: 7%; margin-right: 7%; text-align: right;">
		<input type="button" class="btn btn-primary violetBtn listBtn" value="목록으로" style="margin-right: 5%;"
		onclick="javascript:location.href='/ddit/notice?currentPage=${currentPage}';" />
	</div>
</section>
<!-- footer 시작 -->
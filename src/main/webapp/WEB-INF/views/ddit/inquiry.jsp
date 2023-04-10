<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<style>
.btn-group {
	display: flex;
	justify-content: center;
	align-items: center;
	width: 50%;
	margin: auto;
	margin-top: 50px;
	margin-bottom: 50px;
}

.categoryBtn {
	width: 200px;
	height: 60px;
	background-color: white;
	color: gray;
	border: 1px solid gray;
	font-family: 'Noto Sans KR', sans-serif;
	padding-top: 14px;
}

.categoryBtn:hover {
	background-color: #ccadff;
	border: 1px solid #ccadff;
}

.paginationBtn {
	display: flex;
	justify-content: center;
	align-items: center;
	margin: auto;
}

.insertBtn {
	background-color: #904aff;
	border: none;
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 500;
	margin-right: 35px;
	float: right;
}

span {
	font-family: 'Noto Sans KR', sans-serif;
}

th {
	font-family: 'Noto Sans KR', sans-serif;
	text-align: center;
}

td {
	font-family: 'Gothic A1', sans-serif;
	text-align: center;
}

tbody tr{
	cursor:pointer;
}

li{
	cursor:pointer;
}
.violetBtn{
	background-color:#904aff;
	border:none;
	font-family: 'Noto Sans KR', sans-serif;
	font-weight:500;
	color:white;
}

.violetBtn:hover{
	background-color:#7c3dde !important;
}
</style>
<script>
	$(function(){
		$(".detailBtn").on("click",function(){
			var inqNum = $(this).children().eq(0).text();	// 클릭한 tr의 inqNum
			var intInqNum = Number(inqNum);	// int로 형변환
			var content = $(this).children().eq(2).text();	// 클릭한 tr의 제목 데이터
			var ptNum = $(".ptNum").val();	// 현재접속한 사용자의 ptNum
			var writerPtNum = $(this).children().eq(4).text();	// 클릭한 tr의 작성자의 ptNum
			var inqPw = $(this).children().eq(5).text();	// 클릭한 tr의 비밀번호 데이터

			console.log("ptNum : " + ptNum);
			console.log("writerPtNum : " + writerPtNum);
			console.log("content : " + content);

			if(content == "비밀글 입니다."){
				// 현재접속한 사용자의 차트번호와 게시물작성자의 차트번호가 다르면 비밀번호 입력해야함
				if(ptNum != writerPtNum){
					var inqNum = $(this).children().eq(0).text();	// 게시물 번호(식별)
					var password = prompt("비밀글은 작성자만 확인가능합니다.");	// 사용자가 입력한 비밀번호
					var data = {"inqPw":password,
								"inqNum":inqNum}
					if(password == null){
						return false;
					}

					console.log("data : " + JSON.stringify(data));
					// 사용자가 입력한 비밀번호가 일치하면 true, 아니면 false
					$.ajax({
						url: "/ddit/inquiry/secret",
						contentType:"application/json;charset=utf-8" ,
						data: JSON.stringify(data),
						dataType:"json",
						type: "POST",
						beforeSend : function(xhr) { // 데이터 전송 전 헤더에 csrf값 설정
							xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
						},
						success:function(result){
							console.log(result);
							if(result){
								location.href = "/ddit/inquiry/detail?inqNum=" + inqNum;
							}else{
								alert("비밀번호를 다시 확인해주세요");
							}
						}
					});

				}else{
					location.href = "/ddit/inquiry/detail?inqNum=" + inqNum;
				}
			}else{
				location.href = "/ddit/inquiry/detail?inqNum=" + inqNum;
			}
		});
	});


	function inquiryWrite(){
		window.location.href = "/ddit/inquiry/write";
	}

	// 페이징된 리스트를 가져온다.
	$(function(){
	var searchForm = $("#searchForm");
	var pagingArea = $("#pagingArea");

	pagingArea.on("click", "a", function(event){
		event.preventDefault();
		// a태그의 data-page속성을 이용하면
		var pageNo = $(this).data("page");
		searchForm.find("#page").val(pageNo);
		searchForm.submit();
	});

	// 리스트의 사이즈를 바꾸면 목록을 다시 불러온다.
	$(".selectSize").on("change", function(){
		var size = $(this).val();

		searchForm.submit();
	});

	// li의 커서모양을 수정한다

});
</script>
<!-- Head Image 시작 -->
<div class="boardHeadImage">
	<div class="wrapper">
		<div class="slide">
			<img src="/resources/images/layout/ddit/inquiryHeadImage.png" />
		</div>
	</div>
</div>
<!-- Head Image 끝 -->
<!-- button group 공지사항,문의게시판,이용안내 -->
<div class="btn-group" role="group" aria-label="Basic example">
	<a type="button" id="categoryBtn1" class="btn btn-primary btn-lg categoryBtn" href="/ddit/notice">공지사항</a>
	<a type="button" id="categoryBtn2" class="btn btn-primary btn-lg categoryBtn" href="/ddit/faq">자주 묻는 질문</a>
	<a type="button" id="categoryBtn2" class="btn btn-primary btn-lg categoryBtn" href="/ddit/inquiry" style="background-color: #904aff; color: white;">문의게시판</a>
	<a type="button" id="categoryBtn3" class="btn btn-primary btn-lg categoryBtn" href="/ddit/community">커뮤니티</a>
</div>
<!-- main section 시작 -->
<section class="container">
	<!-- 문의게시판 nav 시작 -->
	<div class="row" style="margin-left: 7%; width: 85%; height: 100px; border-top: 1px solid gray; border-bottom: 1px solid gray;">
		<div class="col-12">
			<h4 style="margin-left: 50px; margin-top: 20px; font-family: 'Noto Sans KR', sans-serif; font-weight: 700;">문의게시판</h4>
		</div>
		<div class="col-6">
			<h6 style="margin-left: 50px; font-family: 'Noto Sans KR', sans-serif; opacity: 0.5; font-size: 14px;">home > 고객의 소리 > 문의게시판</h6>
		</div>
	</div>
	<!-- 문의게시판 nav 끝 -->
	<div class="table-responsive">
		<div class="table-wrapper" style="margin-left: 7%; width: 85%;">

		<form action="" method="get" id="searchForm">
			<input type="hidden" name="page" id="page" />
			<div class="row" style="margin: 20px;">
				<div class="col-sm-6">
					<span style="width: 10px;">Show</span>
					<select class="form-select selectSize" aria-label="Default select example" style="width: 18%; display: inline-block;" name="size">
						<option value="10" <c:if test="${size == 10}">selected</c:if>>10</option>
						<option value="20" <c:if test="${size == 20}">selected</c:if>>20</option>
						<option value="30" <c:if test="${size == 30}">selected</c:if>>30</option>
						<option value="50" <c:if test="${size == 50}">selected</c:if>>50</option>
					</select>
					<span style="width: 10px;">Entries</span>
				</div>
				<div class="col-sm-6" style="text-align:right;">
					<input type="text" class="col-sm-6 form-control" id="search" name="searchWord" placeholder="검색어를 입력해주세요" value="${searchWord}" style="font-family: 'Noto Sans KR', sans-serif; display:inline-block; width: 50%; opacity: 0.8;" />
					<input type="submit" class="col-sm-3 btn btn-primary violetBtn" id="searchBtn" value="검색" style="font-family: 'Noto Sans KR', sans-serif; background-color: #904aff; border: none; margin: auto; margin-bottom:5px;" />
				</div>
			</div>
		</form>
			<!-- 현재 로그인한 사용자 정보-->
			<input type="hidden" value="${ptVO.ptNum}" class="ptNum" id="ptNum" name="ptNum"/>
			<!-- -------------------- -->
			<table class="table table-hover">
				<thead style="border-top: 1px solid #c2c2c2;">
					<tr>
						<th class="p-3">번호</th>
						<th class="p-3">작성일시</th>
						<th class="p-3">제목</th>
						<th class="p-3">작성자</th>
						<th class="p-3">답변여부</th>
					</tr>
				</thead>
				<tbody>
				<c:set value="${inqPageVO.dataList}" var="list"></c:set>
					<c:choose>
						<c:when test="${empty list }">
							<tr>
								<td colspan="4">조회하신 게시글이 존재하지 않습니다.</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="inqVO" items="${list}" varStatus="stat">
								<fmt:formatDate var="sysdate" value="${inqVO.inqDt}" pattern="yyyy-MM-dd" />
								<tr class="detailBtn">
									<th class="p-3">${inqVO.inqNum }</th>
									<td class="p-3">${sysdate}</td>
								<c:choose>
									<c:when test="${inqVO.inqPw == null}">
										<td class="p-3 content">${inqVO.inqTitle}</td>
									</c:when>
									<c:otherwise>
										<td class="p-3 content"><i class="fa-solid fa-lock" style="margin-right: 10px;"></i>비밀글 입니다.</td>
									</c:otherwise>
								</c:choose>
									<td class="p-3">${inqVO.inqWrtrNm}</td>
									<!-- 각각의 게시물이 가지는 ptNum의 값을 가져온다. -->
									<td style="display:none;">${inqVO.ptNum}</td>
									<!-- ------------------------------------- -->
								<c:choose>
									<c:when test="${inqVO.ansVO.empNum == null}">
										<td class="p-3 text-danger">답변대기</td>
									</c:when>
									<c:otherwise>
										<td class="p-3 text-success">답변완료</td>
									</c:otherwise>
								</c:choose>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
			<input type="button" class="btn btn-primary violetBtn insertBtn" value="글쓰기" id="insertBtn" onclick="inquiryWrite()" />
			<nav class="paginationBtn" aria-label="Page navigation example" id="pagingArea" style="margin-left:13%;">
				${inqPageVO.pagingHTML}
			</nav>
		</div>
	</div>
</section>
<!-- main section 끝 -->

<script src="/resources/js/alertModule.js"></script>
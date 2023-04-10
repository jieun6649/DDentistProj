<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<style>

.m-0{
	 font-family: "Noto Sans KR", sans-serif;
	 font-weight:700;
	 font-size: 1rem;
	 line-height: 26px;
}
.text-sm{
	overflow: hidden;
	white-space: nowrap;
	text-overflow: ellipsis;
	width:200px;
	margin:0px;
	display:inherit;
	font-family: "Noto Sans KR", sans-serif;
	font-weight: 300;
}
/* Button css */
.newChatBtn{
	border:none;
	border-radius:50px;
	background-color:#4e7eac;;
	font-family: "Noto Sans KR", sans-serif;
	font-weight: 700;
	width:70px;
	height:35px;
}

.createChatBtn{
	border:none;
	border-radius:30px;
	background-color:#b94aff;
	font-family: "Noto Sans KR", sans-serif;
	font-weight: 500;
}

.closeBtn{
	border:none;
	border-radius:30px;
	font-family: "Noto Sans KR", sans-serif;
	font-weight: 500;
}

.sendBtn{
	border:none;
	border-radius:70px;
	width:35px;
	height:35px;
	background-color:green;
	padding:0px;
	margin-left:10px;
}
/* Modal css */
.modal-title{
	font-family: "Noto Sans KR", sans-serif;
	font-weight: 700;
}
#chatList::-webkit-scrollbar,
#chatgrpList::-webkit-scrollbar{
	width: 8px;
	height: 8px;
}
#chatList::-webkit-scrollbar-thumb,
#chatgrpList::-webkit-scrollbar-thumb{
    background-color: #4e7eac;
    border-radius: 5px;
}
#chatList::-webkit-scrollbar-track,
#chatgrpList::-webkit-scrollbar-track{
    background-color: rgba(0,0,0,0);
}

.chatListScroll::-webkit-scrollbar{
	width: 8px;
	height: 8px;
}
.chatListScroll::-webkit-scrollbar-thumb{
	background-color: #dca2e1;
    border-radius: 5px;
}
.chatListScroll::-webkit-scrollbar-track{
	background-color: rgba(0,0,0,0);
}


.chatHeader {
    -webkit-line-clamp: 5;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    overflow: hidden;
}
</style>
<script>
	// icon을 누르면 event주기
	$(function() {
		$(".sideLink").on("click", function() {
			$(".sideLink").removeClass("active");
			$(this).addClass("nav-link sideLink active");
		});

		// sidebar icon 사이간격 조정
		$(".sidebaricon").children().css("margin-bottom", "1.2rem");

		// 템플릿 카드의 상단 버튼들 위에 마우스가 올라가면 어떤 기능을 하는 버튼인지 설명이 나온다.

	}); // function 끝..


		// 템플릿 카드의 상단 버튼들 위에 마우스가 올라가면 어떤 기능을 하는 버튼인지 설명이 나온다.
		$(document).popover({
			trigger: 'hover',
			selector: '.chatHeader button'
		});

</script>

<sec:authentication var="empInfo" property="principal.empVO" />
<input type="hidden" id="_empNum" value="${empInfo.empNum}" />
<input type="hidden" id="_empNm" value="${empInfo.empNm}" />
<!-- top navbar 시작 -->
<nav class="main-header navbar navbar-expand navbar-white navbar-light" style="background-color: #2f3338; border: none;">

	<ul class="navbar-nav">
		<li class="nav-item">
			<a class="nav-link" data-widget="pushmenu" href="#" role="button">
				<img src="/resources/images/layout/hospital/TWO_CLICK.png" style="height: 120%; width: 120%;" />
			</a>
		</li>
	</ul>

	<ul class="navbar-nav ml-auto">
		<li class="nav-item dropdown">
			<a class="nav-link" data-toggle="dropdown" id="chatButton" href="#">
				<i class="far fa-comments" style="color: aliceblue"></i>
				<span id="totalChatCount" class="badge badge-danger navbar-badge"></span>
			</a>
			<div class="dropdown-menu dropdown-menu-right border-0" style="background-color:#4e7eac;">
				<div class="container">
					<div class="d-flex justify-content-center align-items-center">
						<div class="card border-0 p-0 shadow-none" style="width: 100%;">
							<div class="p-2 elevation-2">
								<div class="card-body p-0" style="width: 300px; height: 400px;">
									<div id="chatMainWindow">
										<div style="text-align:right;">
											<button type="button" class="btn btn-primary btn-sm newChatBtn" data-toggle="modal" onclick="newChatModal();">새 채팅</button>
										</div>
										<div class="dropdown-divider"></div>
										<div class="chatListScroll overflow-auto" id="chatgrpList" style="height: 300px;">
										</div>
									</div>
									<div class="overflow-auto" id="chatRoom" style="height: 100%; display: none;">
										<div class="d-flex justify-content-between mb-2">
											<!-- 뒤로가기 버튼 -->
											<button type="button" id="backToChatMainWindow" class="btn btn-secondary btn-sm" style="border:none; background-color:white;">
												<i class="fa-solid fa-chevron-left" style="color:black; font-size:14px;"></i>
											</button>
											<div class="chatHeader">
												<button type="button" class="btn btn-primary btn-sm" data-content="멤버목록" onclick="chatgrpMemListModal();" style="background-color:white; border:none;">
													<i class="fa-solid fa-list-ul" style="font-size: 18px; color: #404b57;"></i>
												</button>
												<!--  초대하기 버튼  -->
												<button type="button" class="btn btn-primary btn-sm" data-toggle="modal" data-content="초대하기" onclick="inviteMemModal();" style="background-color:white; border:none;">
													<i class="fa-solid fa-user-plus" style="font-size: 18px; color: #404b57;"></i>
<!-- 													<i class="fa-solid fa-user" style="font-size:18px; color:black;"></i> -->
												</button>
												<!-- 나가기버튼 -->
												<button type="button" id="exitChatgrp" class="btn btn-danger btn-sm" data-content="나가기" style="background-color:white; border:none;">
<!-- 													<i class="fa-solid fa-xmark" style="font-size:20px; color:red" ></i> -->
													<i class="fa-solid fa-arrow-right-from-bracket" style="font-size: 20px; color: red"></i>
												</button>
											</div>
										</div>
										<div id="chatList" class="overflow-auto px-2" style="height: 80%;"></div>
										<div class="input-group">
											<input type="text" id="chatMsg" class="form-control" style="border-radius:30px;"/>
											<!-- message보내기 -->
											<button type="button" id="btn" class="btn btn-primary sendBtn" onclick="sendMessage();">
												<i class="fa-sharp fa-solid fa-paper-plane" style="color:white;"></i>
											</button>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</li>
		<li class="nav-item">
			<a class="nav-link" href="javascript:void(0);" onclick="logout();">
				<i class="nav-icon fa-solid fa-right-from-bracket" style="color: whitesmoke;"></i>
			</a>
			<form name="logoutForm" action="/hospital/logout" method="post">
				<sec:csrfInput />
			</form>
		</li>
	</ul>
	<div class="user-panel d-flex">
		<div class="image d-flex justify-content-center align-items-center">
			<div class="overflow-hidden" style="width: 32px; height: 32px;">
				<c:set var="empImg" value="${empInfo.empImg}" />
				<c:if test="${empImg eq null or empImg eq ''}">
					<c:set var="empImg" value="/doc_def_image.png" />
				</c:if>
				<img src="/resources/images/employee${empImg}" alt="직원 이미지" class="w-100" style="clip-path: circle(16px at center 16px);" />
			</div>
		</div>
		<div class="info">
			<a href="javascript:void(0);" class="d-block" style="color: aliceblue; font-family: 'Noto Sans KR', sans-serif;">${empInfo.empNm}님 환영합니다.</a>
		</div>
	</div>
</nav>
<!-- top navbar 끝 -->

<!-- 새 채팅그룹 생성 모달 -->
<div class="modal fade" id="newChatModal" tabindex="-1" role="dialog">
	<div class="modal-dialog" role="document">
		<div class="modal-content" style="border-radius:20px; border: 5px solid #dca2e1;">
			<div class="modal-header" style="border:none;">
				<h5 class="modal-title" id="newChatModalLabel">새 채팅</h5>
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
			  <div class="media-body elevation-2" style="border-radius:20px; padding:20px;">
				<form name="newChatForm" onsubmit="return false;">
					<div class="row align-items-center form-group">
						<label class="col-3" for="chatgrpNm" style="margin:0px;">채팅 이름</label>
						<input type="text" class="col-8 form-control" id="chatgrpNm" name="chatgrpNm" />
					</div>
					<div class="form-group mt-2">
						<label>채팅 멤버</label>
						<div class="chatListScroll overflow-auto p-0" style="max-height: 300px;">
							<table class="table text-center" style="border-collapse: separate; border-spacing: 0;">
								<thead>
									<tr>
										<th>번호</th>
										<th>이름</th>
										<th>선택</th>
									</tr>
								</thead>
								<tbody id="chatMemSelectList"></tbody>
							</table>
						</div>
					</div>
				</form>
			  </div>
			</div>
			<div class="modal-footer" style="border:none;">
				<button type="button" class="btn btn-primary createChatBtn" onclick="createNewChat();">생성</button>
				<button type="button" class="btn btn-secondary closeBtn" data-dismiss="modal">닫기</button>
			</div>
		</div>
	</div>
</div>
<!-- 채팅 초대 모달 -->
<div class="modal fade" id="inviteMemModal" tabindex="-1" role="dialog">
	<div class="modal-dialog" role="document">
		<div class="modal-content" style="border-radius: 20px; border: 5px solid #dca2e1;">
			<div class="modal-header" style="border: none;">
				<h5 class="modal-title" id="inviteMemModalLabel">채팅 초대</h5>
				<button type="button" class="close" data-dismiss="modal">
					<span>&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<div class="media-body elevation-2" style="padding: 20px; border-radius: 20px;">
					<form name="inviteMemForm" onsubmit="return false;">
						<div class="p-0">
							<p class="m-0 py-3">채팅 멤버</p>
						</div>
						<div class="chatListScroll overflow-auto p-0" style="max-height: 300px;">
							<table class="table text-center" style="border-collapse: separate; border-spacing: 0;">
								<thead>
									<tr>
										<th>번호</th>
										<th>이름</th>
										<th>선택</th>
									</tr>
								</thead>
								<tbody id="inviteMemSelectList">
								</tbody>
							</table>
						</div>
					</form>
				</div>
			</div>
			<div class="modal-footer" style="border: none;">
				<button type="button" class="btn btn-primary" onclick="inviteNewMem();">초대</button>
				<button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
			</div>
		</div>
	</div>
</div>
<!-- 현재 채팅그룹 멤버 목록 모달 -->
<div class="modal fade" id="chatgrpMemListModal" tabindex="-1" role="dialog">
	<div class="modal-dialog" role="document">
		<div class="modal-content" style="border-radius: 20px; border: 5px solid #dca2e1;">
			<div class="modal-header" style="border: none;">
				<h5 class="modal-title" id="chatgrpMemListModalLabel">멤버 목록</h5>
				<button type="button" class="close" data-dismiss="modal">
					<span>&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<div class="media-body elevation-2" style="padding: 20px; border-radius: 20px;">
					<div class="p-0">
						<p class="m-0 py-3">참여중인 채팅 멤버</p>
					</div>
					<div class="chatListScroll overflow-auto p-0" style="max-height: 300px;">
						<table class="table table-hover text-center" style="border-collapse: separate; border-spacing: 0;">
							<thead class="sticky-top bg-white">
								<tr>
									<th>사번</th>
									<th>이름</th>
									<th>직급</th>
									<th>부서</th>
								</tr>
							</thead>
							<tbody id="chatgrpMemListBody">
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="modal-footer" style="border: none;">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
			</div>
		</div>
	</div>
</div>
<script>
async function logout(){

	const result = await Swal.fire({
		title: '로그아웃 하시겠습니까?',
		showDenyButton: true,
		confirmButtonText: '로그아웃',
		denyButtonText: '취소',
	});

	if(result.isConfirmed){
		document.logoutForm.submit();
	}

}
</script>
<input type="hidden" id="_csrfParameterName" value="${_csrf.parameterName}" />
<input type="hidden" id="_csrfHeaderName" value="${_csrf.headerName}" />
<input type="hidden" id="_csrfToken" value="${_csrf.token}" />
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="/resources/js/chatModule.js"></script>
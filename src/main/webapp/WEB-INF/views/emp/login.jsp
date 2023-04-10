<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!-- bootstrap 5 CDN -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- jquery 3.6.0 -->
<script src="https://code.jquery.com/jquery-3.6.4.js"></script>
<!-- icon setting = font awesome -->
<script src="https://kit.fontawesome.com/5f4aa574e8.js"></script>
<!-- google font + 500/700 -->
<!-- 사용시 font-weight : 500 or 700으로 줄것 -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@500;700&display=swap" rel="stylesheet">
<!-- Swiper Demo Css, JS setting -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@9/swiper-bundle.min.css" />
<script src="https://cdn.jsdelivr.net/npm/swiper@9/swiper-bundle.min.js"></script>
<!-- favicon -->
<link rel="icon" type="image/png" sizes="16x16" href="/resources/images/layout/ddit/logo/favicon-16x16.png">
<title>병원관계자 로그인</title>
<style>
/* body */
body {
	background-color: #404b57;
}

/* Button css */
.loginBtn, .homeBtn{
	border-radius: 50px;
	margin-left: 30px;
	margin-bottom: 10px;
	width: 85%;
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 700;
	height: 50px;
}

/* 글씨체 css */
label {
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 700;
}

textarea, input, select {
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 500;
}

h4 {
	margin: 30px;
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 700;
}

a {
	margin-left: 35%;
	text-decoration: none;
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 500;
	color: gray;
}

a:hover {
	color: #404b57;
}
</style>
<!-- main section 시작 -->
<section class="container">
	<div class="row justify-content-center">
		<div class="col-xl-10 col-lg-12 col-md-9" style="padding-top: 100px;">
			<div class="card border-0 shadow-lg my-5" style="border-radius: 30px; box-shadow: 0 1rem 3rem rgba(0, 0, 0, 0.4) !important;">
				<div class="card-body p-0">
					<!-- Nested Row within Card Body -->
					<div class="row" style="padding-right: 2%; margin-top: -1px;">
						<div class="col-lg-6">
							<img src="/resources/images/layout/hospital/empLoginImage.png" style="border-top-left-radius: 30px; border-bottom-left-radius: 30px;" />
						</div>
						<div class="col-lg-6">
							<div class="p-3">
								<div class="text-center">
									<h4>병원관계자 로그인</h4>
								</div>
								<form class="employee" action="/hospital/login" method="post">
									<sec:csrfInput/>
									<div style="border: 2px solid #dddddd; border-radius: 30px; padding: 30px;">
										<div class="row pb-3">
											<label for="id" class="col-sm-3 col-form-label">아이디</label>
											<div class="col-sm-9">
												<input type="text" class="form-control" id="empId" name="empId" value="${requestScope.rememberId}" placeholder="아이디를 입력해주세요" required>
											</div>
										</div>
										<div class="row pb-3">
											<label for="password" class="col-sm-3 col-form-label">비밀번호</label>
											<div class="col-sm-9">
												<input type="password" class="form-control" id="empPw" name="empPw" placeholder="비밀번호를 입력해주세요" required>
											</div>
										</div>
										<div class="form-check pb-2">
											<input class="form-check-input" type="checkbox" id="rememberId" name="rememberId" value="Y" <c:if test="${requestScope.rememberId != null}">checked</c:if> />
											<label class="form-check-label" for="rememberId"> 아이디 저장 </label>
										</div>
										<c:if test="${requestScope.errMsg != null and requestScope.errMsg != ''}">
											<label class="text-danger">${requestScope.errMsg}</label>
										</c:if>
									</div>
									<button type="submit" class="btn btn-primary loginBtn mt-4 d-block">로그인</button>
									<button type="button" class="btn btn-danger homeBtn mb-4 d-block" onclick="javascript:location.href='/ddit';">홈으로</button>
									<a href="/ddit/login">혹시 고객/환자신가요?</a>
								</form>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>
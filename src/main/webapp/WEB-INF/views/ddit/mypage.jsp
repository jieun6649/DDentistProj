<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<style>
/* Button css */
.modifyBtn {
	background-color: #904aff;
	border: none;
	display: flex;
	justify-content: center;
	align-items: center;
/* 	margin: auto; */
/* 	margin-top: 50px; */
/* 	margin-bottom: 50px; */
	width: 150px;
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 700;
}

/* body */
body {
	overflow-x: hidden;
}

.cardbody {
	width: 700px;
	height: 800px;
	margin: auto;
	border: 1px solid #B3B3B3;
	box-shadow: 5px 5px 8px rgba(113, 113, 113, 0.25);
	padding: 45px;
	border-radius: 20px;
	background-color: white;
}
h5 {
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 500;
}
h6 {
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 500;
	font-size: 14px;
	margin-left: 50px;
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
	border:none;
	color:white;
}

.redBtn{
	background-color:#FF5252;
	border:none;
	font-family: 'Noto Sans KR', sans-serif;
	font-weight:500;
	color:white;
}

.redBtn:hover{
	background-color:#e13636 !important;
	border:none;
	color:white;
}
</style>
<!-- Head Image 시작 -->
<div class="boardHeadImage">
	<div class="wrapper">
		<div class="slide">
			<img src="/resources/images/layout/ddit/myPageHeadImg.png" />
		</div>
	</div>
</div>
<!-- Head Image 끝 -->
<sec:authentication var="ptInfo" property='principal.ptVO' />
<!-- main section 시작 -->
<section class="container">
	<!-- 마이페이지 nav 시작 -->
	<div class="row" style="margin-left: 7%; margin-top: 50px; width: 85%; height: 100px; border-top: 1px solid gray; border-bottom: 1px solid gray;">
		<div class="col-12">
			<h4 style="margin-left: 50px; margin-top: 20px; font-family: 'Noto Sans KR', sans-serif; font-weight: 700;">마이페이지</h4>
		</div>
		<div class="col-6">
			<h6 style="opacity: 0.5;">home&nbsp;&nbsp; > &nbsp;&nbsp;마이페이지</h6>
		</div>
	</div>
	<!-- 마이페이지 nav 끝 -->
	<div style="margin-left: 7%; margin-top: 50px; width: 85%; margin-bottom: 100px;">
		<div class="cardbody">
			<h4 style="font-family: 'Noto Sans KR', sans-serif; font-weight: 700;">내 정보</h4>
			<hr style="width: 100%; height:2px; background:#FF5252; opacity:1; margin-bottom: 50px;" />
			<form style="padding-left: 7%;" name="mypageForm" method="post" action="/ddit/mypage/updatePtInfo" onsubmit="return validation();">
				<input type="hidden" name="ptId" value="${ptInfo.ptId}" />
				<div class="row mb-3" style="padding-bottom: 30px;">
					<label for="ptNm" class="col-sm-2 col-form-label">이름</label>
					<div class="col-sm-1"></div>
					<div class="col-sm-6">
						<input type="text" class="form-control" id="ptNm" name="ptNm" value="${ptInfo.ptNm}" readonly>
					</div>
				</div>
				<div class="row mb-3" style="padding-bottom: 30px;">
					<label for="ptRrno1" class="col-sm-4 col-form-label" style="width: 115px;">주민등록번호</label>
					<div class="col-sm-1"></div>
					<div class="col-sm-3" style="padding: 0px;">
						<input type="text" class="form-control" id="ptRrno1" name="ptRrno1" value="${fn:substring(ptInfo.ptRrno, 0, 6)}" disabled>
					</div>
					<span style="width: 10px; text-align: center;">-</span>
					<div class="col-sm-3" style="padding: 0px;">
						<input type="password" class="form-control" id="ptRrno2" name="ptRrno2" value="*******" disabled>
					</div>
				</div>

				<div class="row mb-3" style="padding-bottom: 30px;">
					<label for="ptPhone1" class="col-sm-1 col-form-label" style="width: 115px;"> 연락처</label>
					<div class="col-sm-1"></div>
					<div class="col-sm-2" style="padding: 0px;">
						<input type="text" class="form-control" id="ptPhone1" name="ptPhone1" value="${fn:substring(ptInfo.ptPhone, 0, 3)}" />
					</div>
					<span style="width: 3px; text-align: center;">-</span>
					<div class="col-sm-2" style="padding: 0px;">
						<input type="text" class="form-control" id="ptPhone2" name="ptPhone2" value="${fn:substring(ptInfo.ptPhone, 3, 7)}" />
					</div>
					<span style="width: 3px; text-align: center;">-</span>
					<div class="col-sm-2" style="padding: 0px;">
						<input type="text" class="form-control" id="ptPhone3" name="ptPhone3" value="${fn:substring(ptInfo.ptPhone, 7, 11)}" />
					</div>
				</div>

				<div class="row mb-3" style="padding-bottom: 30px;">
					<label for="ptZip" class="col-sm-2 col-form-label">주소</label>
					<div class="col-sm-1"></div>
					<div class="col-sm-4" style="padding-bottom: 10px;">
						<input type="text" class="form-control" id="ptZip" name="ptZip" value="${ptInfo.ptZip}" />
					</div>
					<div class="col-sm-5" style="padding-bottom: 10px;">
						<input class="btn btn-primary violetBtn" type="button" value="우편번호 검색" id="searchZip" style="border-radius: 20px; background-color: #904aff; border: 0px;" onclick="openHomeSearch();" />
					</div>
					<div class="col-sm-3"></div>
					<div class="col-sm-9" style="padding-bottom: 10px;">
						<input type="text" class="form-control" id="ptAddr" name="ptAddr" value="${ptInfo.ptAddr}" />
					</div>
					<div class="col-sm-3"></div>
					<div class="col-sm-9">
						<input type="text" class="form-control" id="ptAddrDet" name="ptAddrDet" value="${ptInfo.ptAddrDet}" />
					</div>
				</div>

				<div class="row mb-3" style="padding-bottom: 30px;">
					<label for="ptPw" class="col-sm-2 col-form-label">비밀번호</label>
					<div class="col-sm-1"></div>
					<div class="col-sm-6">
						<input type="password" class="form-control" id="ptPw" name="ptPw">
					</div>
				</div>
<!-- 				<div class="row mb-3" style="padding-bottom: 30px;"> -->
<!-- 					<label for="passwordChk" class="col-sm-3 col-form-label">비밀번호 확인</label> -->
<!-- 					<div class="col-sm-6"> -->
<!-- 						<input type="text" class="form-control" id="passwordChk" name="ptPwChk"> -->
<!-- 					</div> -->
<!-- 				</div> -->
				<sec:csrfInput/>
				<div class="d-flex justify-content-center">
					<div class="row gap-2">
						<button type="button" class="btn btn-primary btn-lg modifyBtn" style="background-color: #dc3545; border-color: #dc3545;" onclick="openPwChangeModal();">비밀번호 변경</button>
						<button type="submit" class="btn btn-primary violetBtn btn-lg modifyBtn">수정하기</button>
					</div>
				</div>
			</form>
		</div>
	</div>
</section>
<!-- main section 끝 -->

<!-- 비밀번호 변경 모달 시작 -->
<!-- Modal -->
<div class="modal fade" id="pwChangeModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content" style="border-radius:30px;">
			<form name="pwChangeForm" action="/ddit/mypage/updatePtPw" method="post" onsubmit="return pwValidation();">
				<div class="modal-header" style="width: 90%;margin-left: 5%;border-bottom: 2px solid #FF5252;">
					<h5 class="modal-title" id="pwChangeModalLabel">비밀번호 변경</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>
				<div class="modal-body" style="padding:20px 20px;">
					<div class="row my-4">
						<div class="col-sm-4 align-middle">
							<label for="ptPw" style="border-left: 3px solid #FF5252;padding-left: 10px;">현재 비밀번호</label>
						</div>
						<div class="col-sm-8">
							<input type="password" class="form-control" name="ptPw" />
						</div>
					</div>
					<hr />
					<div class="row my-4">
						<div class="col-sm-4">
							<label for="newPtPw" style="border-left: 3px solid #FF5252;padding-left: 10px;">새 비밀번호</label>
						</div>
						<div class="col-sm-8">
							<input type="password" class="form-control" name="newPtPw" />
						</div>
					</div>
					<div class="row my-4">
						<div class="col-sm-4">
							<label for="newPtPw" style="border-left: 3px solid #FF5252;padding-left: 10px;">새 비밀번호 확인</label>
						</div>
						<div class="col-sm-8">
							<input type="password" class="form-control" name="newPtPwChk" />
						</div>
					</div>
				</div>
				<div class="modal-footer" style="border-top:0px; padding-right:25%;">
					<button type="submit" class="btn btn-danger redBtn" style="width:100px; border:none;">변경</button>
					<button type="button" class="btn btn-outline-secondary" style="border:none; width:100px;" data-bs-dismiss="modal" onclick="resetPwChangeForm();">닫기</button>
				</div>
				<sec:csrfInput />
			</form>
		</div>
	</div>
</div>
<!-- 비밀번호 변경 모달 끝 -->
<script>
//다음 주소찾기 API
function openHomeSearch() {
	new daum.Postcode({
		// 선택 완료 시 데이터를 폼에 담아준다.
		oncomplete : function(data) {
			document.mypageForm.ptZip.value = data.zonecode; // 우편번호
			document.mypageForm.ptAddr.value = data.address; // 주소
			document.mypageForm.ptAddrDet.value = data.buildingName; // 건물주소
		}
	}).open();
}

//폼 유효성 검사
function validation() {

	const mypageForm = document.mypageForm;

	const ptPw = mypageForm.ptPw.value;
	if (ptPw == '') {
		alert('비밀번호를 입력해주세요.');
		return false;
	}

	const ptNm = mypageForm.ptNm.value;
	if (!ptNm.match(/^[가-힣]{2,5}$/g)) {
		alert('이름을 다시 한번 확인해주세요.');
		return false;
	}
	const ptRrno = mypageForm.ptRrno1.value;
	if (!ptRrno.match(/^[\d]{6}$/g)) {
		alert('주민등록번호를 다시 한번 확인해주세요.');
		return false;
	}

	const ptPhone = mypageForm.ptPhone1.value + mypageForm.ptPhone2.value
			+ mypageForm.ptPhone3.value;
	if (!ptPhone.match(/^[\d]{9,11}$/g)) {
		alert('연락처를 다시 한번 확인해주세요.');
		return false;
	}

	const ptZip = mypageForm.ptZip.value;
	if (!ptZip.match(/^[\d]{5}$/g)) {
		alert('우편번호를 다시한번 확인해주세요.');
		return false;
	}

	const ptAddr = mypageForm.ptAddr.value;
	if (!ptAddr.match(/^[a-zA-Z0-9가-힣\s]{1,33}$/g)) {
		alert('주소를 다시 한번 확인해주세요.');
		return false;
	}

	const ptAddrDet = mypageForm.ptAddrDet.value;
	if (!ptAddrDet.match(/^[a-zA-Z0-9가-힣\s]{0,46}$/g)) {
		alert('상세주소를 다시 한번 확인해주세요.');
		return false;
	}

	return true;
}

// 비밀번호 변경 모달 열기
function openPwChangeModal(){
	$('#pwChangeModal').modal('show');
}

// 비밀번호 변경 모달 닫기
function resetPwChangeForm(){
	document.pwChangeForm.reset();
}

// 비밀번호 변경 폼 유효성 검사
function pwValidation(){

	const pwChangeForm = document.pwChangeForm;

	const ptPw = pwChangeForm.ptPw.value;
	if(ptPw == ''){
		alert('비밀번호를 입력해주세요.');
		return false;
	}

	const newPtPw = pwChangeForm.newPtPw.value;
	if(newPtPw == ''){
		alert('새 비밀번호를 입력해주세요.');
		return false;
	}

	const newPtPwChk = pwChangeForm.newPtPwChk.value;
	if((newPtPw != newPtPwChk) || (newPtPwChk == '')){
		alert('새 비밀번호가 서로 일치하지 않습니다.');
		return false;
	}

	if(!newPtPw.match(/^[A-Za-z\d!@#$%^&*?]+$/)){
		alert('비밀번호에 사용할 수 없는 문자가 포함되어 있습니다.');
		return false;
	}

	if(!newPtPw.match(/^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*?]).{8,33}$/)){
		alert('비밀번호는 문자, 숫자, 특수문자를 조합해 8~33자 이내로 입력해주세요.');
		return false;
	}

	return true;
}
</script>
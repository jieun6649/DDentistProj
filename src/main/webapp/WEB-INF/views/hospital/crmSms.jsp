<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<style>
/* chatCss */
#chatButton{
	padding-right:1.25rem;
}
.navbar-badge{
	top:5px;
}
/* **************************** */
.overflow-auto::-webkit-scrollbar{
	width: 8px;
	height: 8px;
}
.overflow-auto::-webkit-scrollbar-thumb{
    background-color: #404b57;
    border-radius: 5px;
}
.overflow-auto::-webkit-scrollbar-track{
    background-color: rgba(0,0,0,0);
}
.crmMenu .nav-link{
	font-family: 'Noto Sans KR', sans-serif;
}
.text-truncate{
	max-width: 200px;
	border-top: none !important;
}
.smsHistRow{
	cursor: pointer;
}
.smsTemplateType{
	height: 100%;
	padding: 0px;
	display: flex;
	justify-content: center;
	align-items: center;
}
.sms-template-card {
	width: 140px;
	height: 140px;
	margin: 0px;
	margin-left: 0.5rem;
	margin-right: 0.5rem;
	padding: 0.25rem;
	padding-top: 0;
}
.sms-template-header{
	padding: 0.25rem;
	padding-top: 0.5rem;
	padding-bottom: 0.5rem;
	display: flex;
	justify-content: start;
	align-items: center;
}
.sms-template-header button{
	padding: 0px;
	margin-right: 5px;
	width: 15px !important;
	height: 15px !important;
	border-radius: 50%;
}
.sms-template-text {
    -webkit-line-clamp: 4;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    overflow: hidden;
}
/* Modal Css */
.labelCss{
	border-left: 3px solid #ff3e3e;
	padding-left: 10px;
}
.saveBtnCss{
	width: 120px;
	background: #ff3e3e;
	border: none;
	font-family: 'Noto Sans KR', sans-serif;
	font-weight:500;
}
.closeBtnCss{
	width: 120px;
	border: none;
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 500;
}
#smsSendBtn{
	background-color: #904aff;
	border: #904aff;
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 500;
	width:100px;
}
.cancelBtn{
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 500;
	border:none;
	width:100px;
}
.navbar-light .navbar-nav .nav-link {
	color: #f8f9fa;
	margin-left: 0.5rem;
	height: 38px;
	padding: 0.25rem;
	display: flex;
	align-items: center;
}

.btn-outline-light:hover {
    color: #1f2d3d !important;
    background-color: #f8f9fa;
    border-color: #f8f9fa;
}

/* 폰트 */
span, td, textarea {
	font-family: 'Noto Sans KR', sans-serif;
}
</style>
<div class="content-wrapper" style="background-color: #657D96;">
	<!-- main 검색창을 포함한 navbar 시작-->
	<nav class="navbar navbar-expand navbar-white navbar-light" style="background-color: #404b57;">
		<div class="input-group" style="width: 400px;">
			<input type="text" class="form-control" id="ptSearch" placeholder="환자 검색" autocomplete="off" />
			<div class="input-group-append">
				<button type="button" id="ptSearchBtn" class="btn btn-outline-light" onclick="searchPtOnCrmList();">검색</button>
			</div>
		</div>
<!-- 		<img src="/resources/images/layout/memo_icon.png" alt="메모" id="memo" class="brand-image elevation-1" style="margin-left: 15px;"> -->
		<ul class="navbar-nav ml-auto"></ul>
		<div class="crmMenu">
			<ul class="navbar-nav mb-0">
				<li class="nav-item">
					<a href="javascript:void(0);" class="nav-link btn btn-outline-light active" onclick="changeMenu('crmNeedList');">CRM 내역</a>
				</li>
				<li class="nav-item">
					<a href="javascript:void(0);" class="nav-link btn btn-outline-light" onclick="changeMenu('crmTargetList');">CRM 대상 검색</a>
				</li>
				<li class="nav-item">
					<a href="javascript:void(0);" class="nav-link btn btn-outline-light" onclick="changeMenu('smsHistList');">SMS 발송 내역</a>
				</li>
				<li class="nav-item">
					<a href="/hospital/board" class="nav-link btn btn-outline-light">게시판 관리</a>
				</li>
			</ul>
		</div>
	</nav>

	<section class="content" style="margin-top: 1%;">
		<div class="row" style="height: 900px;">
			<div class="col-md-8" style="height: 100%;">
				<!-- CRM 내역 시작 -->
				<div id="crmNeedList" class="card card-info menuDiv" style="height: 68%;">
					<div class="navbar navbar-expand card-header" style="background-color: #404b57;">
						<div class="card-title">
							<h4 class="m-0">CRM 내역</h4>
						</div>
						<ul class="navbar-nav ml-auto"></ul>
						<div>
							<ul class="navbar-nav mb-0">
								<li class="nav-item">
									<a href="javascript:void(0);" class="nav-link py-0 mr-2 btn btn-outline-light" onclick="addToSendListFromCrmList();">목록에 추가</a>
								</li>
								<li class="nav-item">
									<a href="javascript:void(0);" class="nav-link py-0 mr-2 btn btn-outline-light" onclick="completeCrm();">처리완료</a>
								</li>
								<li class="nav-item">
									<a href="javascript:void(0);" class="nav-link py-0 mr-2 btn btn-outline-light" onclick="uncompleteCrm();">처리완료 취소</a>
								</li>
								<li class="nav-item">
									<a href="javascript:void(0);" class="nav-link py-0 btn btn-outline-light" onclick="deleteCrm();">삭제</a>
								</li>
							</ul>
						</div>
					</div>
					<div class="card-body py-2 text-right" style="min-height: 45px; max-height: 45px; border-bottom:1px solid #e1e1e1;">
						<input type="date" id="crmSDate" /> ~ <input type="date" id="crmEDate" />
					</div>
					<div class="card-body overflow-auto p-0">
						<table class="table table-hover text-center">
							<thead class="sticky-top bg-white">
								<tr>
									<th><input type="checkbox" id="crmNeedListBodyCheckBox" onchange="selectAllCheckBox(this, 'crmNeedListBody');"/></th>
									<th>환자명(차트번호)</th>
									<th>처리상태</th>
									<th>CRM사유</th>
									<th>다음예약일시</th>
									<th>CRM예정일</th>
									<th>CRM처리일</th>
								</tr>
							</thead>
							<tbody id="crmNeedListBody"></tbody>
						</table>
					</div>
				</div>
				<!-- CRM 내역 끝 -->
				<!-- CRM 대상 검색 시작 -->
				<div id="crmTargetList" class="card card-info menuDiv d-none" style="height: 68%;">
					<div class="navbar navbar-expand card-header" style="background-color: #404b57;">
						<div class="card-title">
							<h4 class="m-0">CRM 대상 검색</h4>
						</div>
						<ul class="navbar-nav ml-auto"></ul>
						<div>
							<ul class="navbar-nav mb-0">
								<li class="nav-item">
									<a href="javascript:void(0);" class="nav-link py-0 mr-2 btn btn-outline-light" onclick="addToSendListFromTargetList();">목록에 추가</a>
								</li>
								<li class="nav-item">
									<a href="javascript:void(0);" class="nav-link py-0 btn btn-outline-light" onclick="resetCrmTargetListBody();">초기화</a>
								</li>
							</ul>
						</div>
					</div>
					<div class="card-body overflow-auto p-0">
						<table class="table table-hover text-center">
							<thead class="sticky-top bg-white">
								<tr>
									<th><input type="checkbox" id="crmTargetListBodyCheckBox" onchange="selectAllCheckBox(this, 'crmTargetListBody');"/></th>
									<th>환자명</th>
									<th>차트번호</th>
									<th>최근진료일자</th>
									<th>다음예약일시</th>
									<th>연락처</th>
								</tr>
							</thead>
							<tbody id="crmTargetListBody">
								<tr>
									<td colspan="6">환자를 검색해주세요.</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!-- CRM 대상 검색 끝 -->
				<!-- SMS 발송 내역 시작 -->
				<div id="smsHistList" class="card card-info menuDiv d-none" style="height: 97.67%;">
					<div class="navbar card-header" style="background-color: #404b57;">
						<div class="card-title">
							<h4 class="m-0">SMS 발송 내역</h4>
						</div>
					</div>
					<div class="card-body py-2 text-right" style="max-height: 45px; border-bottom:1px solid #e1e1e1;">
						<input type="date" id="smsHistSDate" /> ~ <input type="date" id="smsHistEDate" />
					</div>
					<div class="card-body overflow-auto p-0">
						<table class="table table-hover text-center">
							<thead class="sticky-top bg-white">
								<tr>
									<th style="width: 15%;">환자명</th>
									<th style="width: 15%;">차트번호</th>
									<th style="width: 20%;">연락처</th>
									<th style="width: 30%;">내용</th>
									<th style="width: 20%;">발송일자</th>
								</tr>
							</thead>
							<tbody id="smsHistListBody"></tbody>
						</table>
					</div>
				</div>
				<!-- SMS 발송 내역 끝 -->
				<div id="smsTemplateCard" class="card card-info menuDiv" style="height: 28%;">
					<div class="card-header" style="background-color: #404b57;">
						<div class="card-title">
							<h4 class="m-0">SMS 템플릿</h4>
						</div>
					</div>
					<div class="card-body p-0">
						<div class="row h-100">
							<div class="col-md-2 h-100">
								<table class="table text-center p-0 m-0" style="height: 100%;">
									<tr>
										<td class="p-0">
											<a href="javascript:void(0);"
											   class="smsTemplateType dropdown-item"
											   onclick="listSmsTemplate('');">전체</a>
										</td>
									</tr>
									<tr class="border-right">
										<td class="p-0">
											<a href="javascript:void(0);"
											   class="smsTemplateType dropdown-item"
											   onclick="listSmsTemplate('SMS_RESV');">예약</a>
										</td>
									</tr>
									<tr class="border-right">
										<td class="p-0">
											<a href="javascript:void(0);"
											   class="smsTemplateType dropdown-item"
											   onclick="listSmsTemplate('SMS_NOTICE');">안내</a>
										</td>
									</tr>
									<tr class="border-right">
										<td class="p-0">
											<a href="javascript:void(0);"
											   class="smsTemplateType dropdown-item"
											   onclick="listSmsTemplate('SMS_REGARD');">인사</a>
										</td>
									</tr>
									<tr class="border-right">
										<td class="p-0">
											<a href="javascript:void(0);"
											   class="smsTemplateType dropdown-item rounded-left-bottom"
											   onclick="listSmsTemplate('SMS_OTHER');">기타</a>
										</td>
									</tr>
								</table>
							</div>
							<div class="col-md-10 p-3">
								<div id="smsTemplateList" class="w-100 h-100 border overflow-auto d-flex justify-content-start align-items-center">
								</div>
								<div class="p-3 position-absolute" style="z-index: 20; bottom: 8px; right: 8px;">
									<button type="button" class="btn btn-secondary rounded-pill" style="opacity: 70%;"
											onclick="openSmsTemplateSaveModal();">+</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 문자메시지 작성폼 시작 -->
			<div class="col-md-4" style="height: 100%;">
				<div class="card" style="height: 97.67%;">
					<div class="card-body">
						<div style="height: 60%;">
							<div class="border p-4 h-100 w-100">
								<div class="h-100 w-100 py-4 mx-auto bg-black" style="border: 5px solid black; border-radius: 2rem; max-width: 270px;">
									<div class="position-relative" style="width: 25%; top: -10px; left: 37.5%; border: 3px solid grey; border-radius: 1rem;"></div>
									<div class="h-100 w-100 bg-white d-flex justify-content-center align-items-center" style="border: 5px solid black; border-radius: 2rem;">
										<textarea id="smsContentTextarea" style="width: 70%; height: 80%;"></textarea>
									</div>
								</div>
							</div>
						</div>
						<div class="overflow-auto my-4 p-0" style="height: 30%;">
							<table class="table table-bordered text-center w-100">
								<thead class="sticky-top bg-white" style="top: -1px;">
									<tr>
										<th style="width: 35%;">이름</th>
										<th style="width: 50%;">번호</th>
										<th style="width: 15%;"></th>
									</tr>
								</thead>
								<tbody id="smsTargetListBody"></tbody>
							</table>
						</div>
						<div class="text-right">
							<button type="button" id="smsSendBtn" class="btn btn-primary" onclick="sendSmsOnCrm();">전송</button>
							<button type="button" class="btn btn-secondary cancelBtn" onclick="resetSmsForm();">취소</button>
						</div>
					</div>
				</div>
			</div>
			<!-- 문자메시지 작성폼 끝 -->
		</div>
	</section>
</div>
<div class="modal fade" id="smsTemplateSaveModal" data-backdrop="static" data-keyboard="false" tabindex="-1">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content" style="border-radius: 30px; width: 80%;">
			<div class="modal-header" style="width: 80%;margin-left: 11%;border-bottom: 2px solid #ff3e3e;">
				<h5 class="modal-title" id="smsTemplateSaveModalLabel"></h5>
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body" style="padding: 40px 40px;">
				<form name="smsTemplateSaveForm" action="/hospital/sms/InsertSmsTemplate">
					<input type="hidden" name="tplNum" />
					<div class="form-group">
						<label class="labelCss" style="border-left: 3px solid #ff3e3e; padding-left: 10px;">카테고리</label>
						<select name="tplType" class="form-control">
							<option value="SMS_RESV">예약</option>
							<option value="SMS_NOTICE">안내</option>
							<option value="SMS_REGARD">인사</option>
							<option value="SMS_OTHER">기타</option>
						</select>
					</div>
					<div class="form-group">
						<label class="labelCss">템플릿 내용</label>
						<textarea class="form-control" name="tplSmsContent" cols="5"></textarea>
					</div>
					<div class="form-group">
						<input type="checkbox" name="tplRepYn" value="Y" />
						<label>대표 템플릿</label>
					</div>
				</form>
			</div>
			<div class="modal-footer" style="margin: auto; border-top:none;">
				<button type="button" class="btn btn-danger saveBtnCss" onclick="saveSmsTemplate();">저장</button>
				<button type="button" class="btn btn-outline-secondary closeBtnCss" data-dismiss="modal" >닫기</button>
			</div>
		</div>
	</div>
</div>
<script>

// 상단 메뉴 클릭 시 활성화
$('.crmMenu .nav-link').on('click', function(){
	$('.crmMenu .nav-link').removeClass('active');
	$(this).addClass('active');
});

// CRM 내역의 초기 날짜는 일주일전부터 오늘까지이다.
let today = new Date().toISOString().split('T')[0];
let beforeSevenDays = new Date(today);
beforeSevenDays.setDate(beforeSevenDays.getDate() - 7);
beforeSevenDays = beforeSevenDays.toISOString().split('T')[0];

document.querySelector('#crmEDate').value = today;
document.querySelector('#crmSDate').value = beforeSevenDays;
document.querySelector('#crmEDate').min = beforeSevenDays;


// SMS 발송 내역의 초기 날짜는 일주일전부터 오늘까지이다.
document.querySelector('#smsHistEDate').value = today;
document.querySelector('#smsHistSDate').value = beforeSevenDays;
document.querySelector('#smsHistEDate').min = beforeSevenDays;

// CRM 목록의 전체선택 체크박스
crmNeedListBodyCheckBox = document.querySelector('#crmNeedListBodyCheckBox');

// 문자열 바이트 크기 구하는 함수
const byteSize = str => new Blob([str]).size;

// SMS 템플릿 목록 조회
listSmsTemplate('');

//CRM 내역 조회
searchPtOnCrmList();

// SMS 발송 내역 조회
searchSmsHist();


// SMS 템플릿 카드의 초록색 버튼 클릭 시 문구가 휴대폰 화면에 복사된다.
$(document).on('click', '.sms-template-select', function(e){
	const targetTemplateCard = $(this).parents('.sms-template-card');
	const templateText = targetTemplateCard.text().trim();
	$('#smsContentTextarea').val(templateText);
});

// SMS 템플릿 카드의 노란색 버튼 클릭 시 수정 모달이 출력된다.
$(document).on('click', '.sms-template-update', function(e){

	const tplNum = $(this).parent().data('tplnum');
	const tplType = $(this).parent().data('tpltype');
	const tplSmsContent = $(this).parents('.sms-template-card').find('.sms-template-text').text().trim();
	const tplRepYn = $(this).parent().data('tplrepyn');

	document.querySelector('#smsTemplateSaveModalLabel').textContent = '템플릿 수정';

	document.smsTemplateSaveForm.action = '/hospital/sms/updateSmsTemplate';
	document.smsTemplateSaveForm.tplNum.value = tplNum;
	document.smsTemplateSaveForm.tplType.value = tplType;
	document.smsTemplateSaveForm.tplSmsContent.value = tplSmsContent;
	if(tplRepYn == 'Y'){
		document.smsTemplateSaveForm.tplRepYn.checked = true;
		document.smsTemplateSaveForm.tplRepYn.disabled = true;
	} else {
		document.smsTemplateSaveForm.tplRepYn.checked = false;
		document.smsTemplateSaveForm.tplRepYn.disabled = false;
	}


	$('#smsTemplateSaveModal').modal('show');
});

// SMS 템플릿 카드의 빨간색 버튼 클릭 시 템플릿을 삭제한다.
$(document).on('click', '.sms-template-delete', function(e){
	const tplNum = $(this).parent().data('tplnum');
	deleteSmsTemplate(tplNum);
});

// SMS 템플릿 목록 선택 시 우측 Border가 지워진다.
$('.smsTemplateType').on('click', function(e){
	$('.smsTemplateType').parents('tr').addClass('border-right');
	$(this).parents('tr').removeClass('border-right');
});

// CRM 내역에서 시작날짜 변경 시 종료날짜가 자동으로 변경된다.
$('#crmSDate').on('change', function(){
	const crmSDate = $('#crmSDate');
	const crmEDate = $('#crmEDate');

	if(crmSDate.val() > crmEDate.val()){
		crmEDate.val(crmSDate.val());
	}
	crmEDate.attr('min', crmSDate.val());

	// CRM 내역에서 시작날짜 변경 시 바로 검색
	$('#ptSearchBtn').click();
});

// CRM 내역에서 종료날짜 변경 시 바로 검색
$('#crmEDate').on('change', function(){
	$('#ptSearchBtn').click();
});

// SMS 발송 내역에서 시작날짜 변경 시 종료날짜가 자동으로 변경된다.
$('#smsHistSDate').on('change', function(){
	const smsHistSDate = $('#smsHistSDate');
	const smsHistEDate = $('#smsHistEDate');

	if(smsHistSDate.val() > smsHistEDate.val()){
		smsHistEDate.val(smsHistSDate.val());
	}
	smsHistEDate.attr('min', smsHistSDate.val());

	// SMS 발송 내역에서 시작날짜 변경 시 바로 검색
	$('#ptSearchBtn').click();
});


// SMS 발송 내역에서 종료날짜 변경 시 바로 검색
$('#smsHistEDate').on('change', function(){
	$('#ptSearchBtn').click();
});


// 수신자 목록의 x 버튼을 클릭하면 목록에서 삭제
$(document).on('click', '.SmsRowDeleteBtn', function(e){
	$(this).parents('tr').remove();
});


// CRM 내역에서 목록에 추가 버튼을 클릭하면 체크박스를 선택한 환자가 수신자 목록에 추가됨
function addToSendListFromCrmList(){

	const ptCrmRow = $('.ptCrmRow');

	let code = '';
	ptCrmRow.each(function(idx, ptCrm){

		let crmCheckBox = ptCrm.querySelector('.crmCheckBox');
		if(crmCheckBox.checked){

			const crmCrmNum = ptCrm.dataset.crmnum;

			const ptNm = ptCrm.childNodes[1].textContent;
			const crmPtNm = ptNm.substring(0, ptNm.indexOf('('));

			const crmPtPhone = ptCrm.dataset.ptphone;

			code += '<tr>';
			code += '<td class="crmCrmNum" data-crmnum="' + crmCrmNum + '">' + crmPtNm + '</td>';
			code += '<td>' + crmPtPhone + '</td>';
			code += '<td><button type="button" class="btn btn-light p-0 btn-block SmsRowDeleteBtn">&times;</button></td>';
			code += '</tr>';

			crmCheckBox.checked = false;
		}
	});

	document.querySelector('#crmNeedListBodyCheckBox').checked = false;
	document.querySelector('#smsTargetListBody').insertAdjacentHTML('beforeEnd', code);
}

// CRM 대상 검색에서 목록에 추가 버튼을 클릭하면 체크박스를 선택한 환자가 수신자 목록에 추가됨
function addToSendListFromTargetList(){

	const ptTargetRow = $('.ptTargetRow');

	let code = '';
	ptTargetRow.each(function(idx, ptTarget){

		let targetCheckBox = ptTarget.querySelector('.targetCheckBox')
		if(targetCheckBox.checked){

			const targetPtNum = ptTarget.dataset.ptnum;
			const targetPtNm = ptTarget.childNodes[1].textContent;
			const targetPtPhone = ptTarget.childNodes[5].textContent;

			code += '<tr>';
			code += '<td class="targetPtNum" data-ptnum="' + targetPtNum + '">' + targetPtNm + '</td>';
			code += '<td>' + targetPtPhone + '</td>';
			code += '<td><button type="button" class="btn btn-light p-0 btn-block SmsRowDeleteBtn">&times;</button></td>';
			code += '</tr>';

			targetCheckBox.checked = false;
		}
	});

	document.querySelector('#crmTargetListBodyCheckBox').checked = false;
	document.querySelector('#smsTargetListBody').insertAdjacentHTML('beforeEnd', code);

}

// 네비게이션바의 메뉴를 클릭하면 메뉴 변경
function changeMenu(menuName){

	document.querySelectorAll('.menuDiv').forEach(function(div){
		div.classList.add('d-none');
	});

	document.querySelector('#' + menuName).classList.remove('d-none');
	const ptSearchBtn = document.querySelector('#ptSearchBtn');
	const smsSendBtn = document.querySelector('#smsSendBtn');

	switch(menuName){
	case 'crmNeedList':
		document.querySelector('#smsTemplateCard').classList.remove('d-none');
		ptSearchBtn.onclick = searchPtOnCrmList;
		smsSendBtn.onclick = sendSmsOnCrm;
		break;
	case 'crmTargetList':
		document.querySelector('#smsTemplateCard').classList.remove('d-none');
		ptSearchBtn.onclick = searchPtOnTargetList;
		smsSendBtn.onclick = sendSmsOnTarget;
		break;
	case 'smsHistList':
		ptSearchBtn.onclick = searchSmsHist;
		break;
	}
}

// 환자 검색창에서 엔터 클릭 시 검색 실행
$('#ptSearch').on('keydown', function(e){
	if(e.keyCode == 13){
		document.querySelector('#ptSearchBtn').click();
	}
})

// 환자를 검색해 CRM 내역 목록에 출력한다.
function searchPtOnCrmList(){

	let keyword = document.querySelector('#ptSearch').value;
	keyword = keyword.trim();

	let crmSDate = document.querySelector('#crmSDate').value;
	let crmEDate = document.querySelector('#crmEDate').value;

	let parameterData = {
		keyword : keyword,
		crmSDate : crmSDate,
		crmEDate : crmEDate
	};
	const parameterString = Object.entries(parameterData).map(e => e.join('=')).join('&');

	fetch('/hospital/sms/searchPtOnCrmList?' + parameterString)
	.then(res => res.json())
	.then(crmList => {

		let code = '';
		crmList.forEach(function(crm){
			code += '<tr class="ptCrmRow" data-crmnum="' + crm.crmNum + '" data-ptphone="' + crm.ptPhone + '">';
			code += '<td><input type="checkbox" class="crmCheckBox" /></td>';
			code += '<td>' + (crm.ptNm + '(' + crm.ptNum + ')') + '</td>';
			code += '<td>' + crm.crmPrcsStatus + '</td>';
			code += '<td>' + crm.crmReason + '</td>';
			code += '<td>' + (crm.crmNxResvDtStr == null ? '-' : crm.crmNxResvDtStr) + '</td>';
			code += '<td>' + crm.crmEthStr + '</td>';
			code += '<td>' + (crm.crmPrcsCmptnDtStr == null ? '-' : crm.crmPrcsCmptnDtStr ) + '</td>';
			code += '</tr>';

		});

		if(code == ''){
			code += '<tr><td colspan="7">내역이 존재하지 않습니다.</td></tr>';
		}

		crmNeedListBodyCheckBox.checked = false;
		document.querySelector('#crmNeedListBody').innerHTML = code;
	});

}

// 환자를 검색해 CRM 대상 검색 목록에 출력한다.
function searchPtOnTargetList(){

	let keyword = document.querySelector('#ptSearch').value;
	keyword = keyword.trim();

	if(keyword == '') return false;

	fetch('/hospital/sms/searchPtOnTargetList?keyword=' + keyword)
		.then(res => res.json())
		.then(ptList => {

			let code = '';
			ptList.forEach(function(pt){
				code += '<tr class="ptTargetRow" data-ptnum="' + pt.ptNum + '">'
				code += '<td><input type="checkbox" class="targetCheckBox" /></td>';
				code += '<td>' + pt.ptNm + '</td>'
				code += '<td>' + pt.ptNum + '</td>'
				code += '<td>' + (pt.recentCheckupDt == null ? '-' : pt.recentCheckupDt) + '</td>'
				code += '<td>' + (pt.crmNxResvDtStr == null ? '-' : pt.crmNxResvDtStr) + '</td>'
				code += '<td>' + pt.ptPhone + '</td>'
				code += '</tr>'
			})

			if(code == ''){
				code += '<tr><td colspan="6">일치하는 환자가 존재하지 않습니다.</td></tr>';
			}

			document.querySelector('#crmTargetListBody').innerHTML = code;
		});

}

// CRM 내역에서 SMS 전송
function sendSmsOnCrm(){

	if(isSmsFormEmpty()) return false;

	Swal.fire({
		title: '메시지를 전송하시겠습니까?',
		showDenyButton: true,
		confirmButtonText: '확인',
		denyButtonText: '취소',
	}).then(result => {
		if(result.isConfirmed){

			const smsContent = document.querySelector('#smsContentTextarea').value;
			const tdList = document.querySelectorAll('#smsTargetListBody .crmCrmNum');

			let crmNumList = [];
			tdList.forEach(function(td){
				const crmNum = td.dataset.crmnum;
				crmNumList.push(crmNum);
			});

			const csrfToken = $('#_csrfToken').val();
			fetch('/hospital/sms/sendSmsOnCrm', {
				method: 'post',
				headers: {
					'X-CSRF-TOKEN' : csrfToken,
					'Content-Type' : 'application/json;charset=utf-8'
				},
				body: JSON.stringify({
					'smsContent' : smsContent,
					'crmNumList' : crmNumList
				})
			})
				.then(res => res.text())
				.then(sendCount => {

					if(sendCount == 0){
						simpleJustErrorAlert();
						return false;
					}
					simpleSuccessAlert(sendCount + '건의 메시지가 발송되었습니다.');
					searchPtOnCrmList();
					resetSmsForm();

				});
		}
	});

}

// CRM 대상 검색에서 SMS 전송
function sendSmsOnTarget(){

	if(isSmsFormEmpty()) return false;

	Swal.fire({
		title: '메시지를 전송하시겠습니까?',
		showDenyButton: true,
		confirmButtonText: '확인',
		denyButtonText: '취소',
	}).then(result => {
		if(result.isConfirmed){

			const smsContent = document.querySelector('#smsContentTextarea').value;
			const tdList = document.querySelectorAll('#smsTargetListBody .targetPtNum');

			let ptNumList = [];
			tdList.forEach(function(td){
				const ptNum = td.dataset.ptnum;
				ptNumList.push(ptNum);
			});

			const csrfToken = $('#_csrfToken').val();
			fetch('/hospital/sms/sendSmsOnTarget', {
				method: 'post',
				headers: {
					'X-CSRF-TOKEN' : csrfToken,
					'Content-Type' : 'application/json;charset=utf-8'
				},
				body: JSON.stringify({
					'smsContent' : smsContent,
					'ptNumList' : ptNumList
				})
			})
				.then(res => res.text())
				.then(sendCount => {

					if(sendCount == 0){
						simpleJustErrorAlert();
						return false;
					}
					simpleSuccessAlert(sendCount + '건의 메시지가 발송되었습니다.');
					searchPtOnTargetList();
					resetSmsForm();

				});
		}
	});

}

// 메시지 내용과 메시지 수신자 목록이 비어있는지 확인
function isSmsFormEmpty(){

	const smsContent = document.querySelector('#smsContentTextarea').value;
	if(smsContent == ''){
		simpleErrorAlert('메시지 내용을 입력해주세요.');
		return true;
	}

	const smsTargetList = document.querySelector('#smsTargetListBody').innerHTML.trim();
	if(smsTargetList == ''){
		simpleErrorAlert('환자를 선택해주세요.');
		return true;
	}

	return false;
}

// SMS 전송 폼을 초기화
function resetSmsForm(){
	document.querySelector('#smsContentTextarea').value = '';
	document.querySelector('#smsTargetListBody').innerHTML = '';
}

// 선택된 CRM이 있는지 확인
function isCrmSelected(){

	const crmCheckBox = $('.crmCheckBox');
	let crmNumList = [];

	crmCheckBox.each(function(idx, checkBox){
		if(checkBox.checked){
			crmNumList.push($(checkBox).parents('tr').data('crmnum'));
		}
	});

	if(crmNumList.length == 0) {
		simpleErrorAlert('CRM을 선택해주세요.');
		return false;
	}

	return true;
}

// 선택된 CRM 목록에서 CRM 번호를 꺼내어 배열로 반환
function setCrmNumList(){

	const crmCheckBox = $('.crmCheckBox');
	let crmNumList = [];

	crmCheckBox.each(function(idx, checkBox){
		if(checkBox.checked){
			crmNumList.push($(checkBox).parents('tr').data('crmnum'));
		}
	});

	return crmNumList;
}

// 처리완료 상태의 CRM을 미완료 상태로 변경
function uncompleteCrm(){

	if(!isCrmSelected()) return false;

	Swal.fire({
		title: 'CRM을 미완료처리하시겠습니까?',
		showDenyButton: true,
		confirmButtonText: '확인',
		denyButtonText: '취소',
	}).then(result => {
		if(result.isConfirmed){

			let crmNumList = setCrmNumList();
			if(!isCrmAlreadyCompleted(crmNumList)){
				simpleErrorAlert('처리완료되지 않은 CRM은 변경할 수 없습니다.');
				return false;
			}

			const csrfToken = $('#_csrfToken').val();
			fetch('/hospital/sms/uncompleteCrm', {
				method: 'post',
				headers: {
					'X-CSRF-TOKEN' : csrfToken,
					'Content-Type' : 'application/json;charset=utf-8'
				},
				body : JSON.stringify(crmNumList)
			})
				.then(res => res.text())
				.then(uncompleteCount => {

					if(uncompleteCount == 0){
						simpleJustErrorAlert();
						return false;
					}

					simpleSuccessAlert(uncompleteCount + '건의 CRM이 미완료처리되었습니다.');
					searchPtOnCrmList();

				});

		}
	});

}

// 선택된 CRM 목록 중 처리완료된 CRM이 존재하는지 확인
function isCrmAlreadyCompleted(crmNumList){

	for(crmNum of crmNumList){
		const crmStatus = document.querySelector('tr[data-crmnum="' + crmNum + '"]').childNodes[2].textContent;
		if(crmStatus === '처리완료'){
			return true;
		}
	}

	return false;
}

// 미완료 상태의 CRM을 처리완료로 변경
function completeCrm(){

	if(!isCrmSelected()) return false;

	Swal.fire({
		title: 'CRM을 완료처리하시겠습니까?',
		showDenyButton: true,
		confirmButtonText: '확인',
		denyButtonText: '취소',
	}).then(result => {
		if(result.isConfirmed){

			let crmNumList = setCrmNumList();
			if(isCrmAlreadyCompleted(crmNumList)){
				simpleErrorAlert('이미 처리완료된 CRM입니다.');
				return false;
			}

			const csrfToken = $('#_csrfToken').val();
			fetch('/hospital/sms/completeCrm', {
				method: 'post',
				headers: {
					'X-CSRF-TOKEN' : csrfToken,
					'Content-Type' : 'application/json;charset=utf-8'
				},
				body : JSON.stringify(crmNumList)
			})
				.then(res => res.text())
				.then(completeCount => {

					if(completeCount == 0){
						simpleJustErrorAlert();
						return false;
					}

					simpleSuccessAlert(completeCount + '건의 CRM이 완료처리되었습니다.');
					searchPtOnCrmList();

				});

		}
	});
}

// CRM 삭제
function deleteCrm(){

	if(!isCrmSelected()) return false;

	Swal.fire({
		title: 'CRM을 삭제하시겠습니까?',
		text: '삭제된 내용은 복구할 수 없습니다.',
		showDenyButton: true,
		confirmButtonText: '확인',
		denyButtonText: '취소',
	}).then(result => {
		if(result.isConfirmed){

			let crmNumList = setCrmNumList();

			const csrfToken = $('#_csrfToken').val();
			fetch('/hospital/sms/deleteCrm', {
				method: 'post',
				headers: {
					'X-CSRF-TOKEN' : csrfToken,
					'Content-Type' : 'application/json;charset=utf-8'
				},
				body: JSON.stringify(crmNumList)
			})
				.then(res => res.text())
				.then(deleteCount => {

					if(deleteCount == 0){
						simpleJustErrorAlert();
						return false;
					}

					simpleSuccessAlert(deleteCount + '건의 CRM이 삭제되었습니다.');
					searchPtOnCrmList();
				});
		}
	});

}

// SMS 발송 이력 목록을 클릭하면 발송 내용을 휴대폰 화면에 출력
$(document).on('click', '.smsHistRow', function(e){
	document.querySelector('#smsContentTextarea').value = $('.text-truncate', this).text();
});

// SMS 발송 이력 조회
function searchSmsHist(){

	let keyword = document.querySelector('#ptSearch').value;
	keyword = keyword.trim();

	let smsHistSDate = document.querySelector('#smsHistSDate').value;
	let smsHistEDate = document.querySelector('#smsHistEDate').value;

	let parameterData = {
		keyword : keyword,
		smsHistSDate : smsHistSDate,
		smsHistEDate : smsHistEDate
	};
	const parameterString = Object.entries(parameterData).map(e => e.join('=')).join('&');

	fetch('/hospital/sms/searchSmsHist?' + parameterString)
		.then(res => res.json())
		.then(smsHistList => {

			let code = '';
			smsHistList.forEach(function(smsHist){

				code += '<tr class="smsHistRow">';
				code += '<td>' + smsHist.ptNm + '</td>'
				code += '<td>' + smsHist.ptNum + '</td>'
				code += '<td>' + smsHist.ptPhone + '</td>'
				code += '<td><span class="d-inline-block text-truncate">' + smsHist.smsContent + '</span></td>'
				code += '<td>' + smsHist.smsDtStr + '</td>'
				code += '</tr>';

			});

			document.querySelector('#smsHistListBody').innerHTML = code;

		});

}

// 템플릿 카드의 상단 버튼들 위에 마우스가 올라가면 어떤 기능을 하는 버튼인지 설명이 나온다.
$(document).popover({
	trigger: 'hover',
	selector: '.sms-template-header button'
	});

// SMS 템플릿 목록 조회
function listSmsTemplate(tplType){

	$('.smsTemplateType').blur();

	fetch('/hospital/sms/listSmsTemplate?tplType=' + tplType)
		.then(res => res.json())
		.then(tplList => {

			let code = '';
			tplList.forEach(function(tpl){
				code += '<div class="card sms-template-card" style="min-width: 140px;">';
				code += '<div class="card-header sms-template-header" data-tplnum="' + tpl.tplNum + '" data-tpltype="' + tpl.tplType + '" data-tplrepyn="' + tpl.tplRepYn + '">';
				code += '<button type="button" class="btn btn-danger sms-template-delete" data-content="삭제"></button>';
				code += '<button type="button" class="btn btn-warning sms-template-update" data-content="수정"></button>';
				code += '<button type="button" class="btn btn-success sms-template-select" data-content="선택"></button>';
				code += '</div>';
				code += '<span class="sms-template-text">';
				code += tpl.tplSmsContent;
				code += '</span>';
				code += '</div>';
			});

			document.querySelector('#smsTemplateList').innerHTML = code;
			document.querySelector('#smsTemplateList').dataset.type = tplType;

		});

}

// SMS 템플릿 저장 모달 오픈
function openSmsTemplateSaveModal(){

	document.querySelector('#smsTemplateSaveModalLabel').textContent = '템플릿 추가';
	document.smsTemplateSaveForm.action = '/hospital/sms/insertSmsTemplate';
	document.smsTemplateSaveForm.tplNum.value = '0';
	document.smsTemplateSaveForm.tplType.value = document.querySelector('#smsTemplateList').dataset.type;
	document.smsTemplateSaveForm.tplSmsContent.value = '';
	document.smsTemplateSaveForm.tplRepYn.checked = false;
	document.smsTemplateSaveForm.tplRepYn.disabled = false;

	$('#smsTemplateSaveModal').modal('show');

}

// SMS 템플릿 추가, 수정
function saveSmsTemplate(){

	const formData = new FormData(document.smsTemplateSaveForm);
	const tplSmsContent = formData.get('tplSmsContent').trim();
	if(tplSmsContent == ''){
		simpleErrorAlert('내용을 입력해주세요.');
		return false;
	}

	if(formData.get('tplType') == null){
		simpleErrorAlert('카테고리를 선택해주세요.');
		return false;
	}

	if(byteSize(tplSmsContent) > 80){
		simpleErrorAlert('최대 80바이트까지 입력 가능합니다.');
		return false;
	}

	const actionPath = document.smsTemplateSaveForm.action;

	const csrfToken = $('#_csrfToken').val();
	fetch(actionPath + '?_csrf=' + csrfToken, {
		method: 'post',
		body : formData
	})
		.then(res => res.text())
		.then(text => {

			if(text == 'FAILED'){
				simpleJustErrorAlert();
				return false;
			}

			if(text == 'INSERT'){
				simpleSuccessAlert('템플릿이 추가되었습니다.');
			} else if(text == 'UPDATE'){
				simpleSuccessAlert('템플릿이 수정되었습니다.');
			}

			$('#smsTemplateSaveModal').modal('hide');

			const tplType = document.querySelector('#smsTemplateList').dataset.type;
			listSmsTemplate(tplType);

		});

}

// SMS 템플릿 삭제
function deleteSmsTemplate(tplNum){

	Swal.fire({
		title: '템플릿을 삭제하시겠습니까?',
		showDenyButton: true,
		confirmButtonText: '삭제',
		denyButtonText: '취소',
	}).then(result => {
		if(result.isConfirmed){

			const csrfToken = $('#_csrfToken').val();
			fetch('/hospital/sms/deleteSmsTemplate', {
				method: 'post',
				headers: {
					'X-CSRF-TOKEN' : csrfToken,
					'Content-Type' : 'application/json;charset=utf-8'
				},
				body: JSON.stringify({
					'tplNum' : tplNum
				})
			})
				.then(res => {
					if(!res.ok) throw new Error();
					return res.text();
				})
				.then(text => {

					if(text == 'REP'){
						simpleErrorAlert('대표 템플릿은 삭제할 수 없습니다.');
						return false;
					}

					if(text == 'FAILED') throw new Error();

					simpleSuccessAlert('템플릿이 삭제되었습니다.');

					const tplType = document.querySelector('#smsTemplateList').dataset.type;
					listSmsTemplate(tplType);

				})
				.catch(() => {
					simpleJustErrorAlert();
				})

		}
	});

}

// 테이블 상단의 전체 선택 체크박스 선택 시 모든 행이 선택된다.
function selectAllCheckBox(target, targetId){

	const targetCheckBox = document.querySelector('#' + targetId).querySelectorAll('input[type="checkbox"]');

	let checkBoxValue;
	if(target.checked){
		checkBoxValue = true;
	} else {
		checkBoxValue = false;
	}

	targetCheckBox.forEach(function(target){
		target.checked = checkBoxValue;
	});

}

// CRM 대상 검색의 초기화 버튼 클릭 시 목록을 초기화
function resetCrmTargetListBody(){

	document.querySelector('#crmTargetListBody').innerHTML = '<tr><td colspan="6">환자를 검색해주세요.</td></tr>';
	document.querySelector('#crmTargetListBodyCheckBox').checked = false;
	document.querySelectorAll('.targetCheckBox').forEach(function(checkBox){
		checkBox.checked = false;
	});


}

</script>
<script src="/resources/js/alertModule.js"></script>
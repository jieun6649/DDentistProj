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
/* ***************************** */
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
.rcvmtMenu .nav-link{
	font-family: 'Noto Sans KR', sans-serif;
}
.waitingRcvmtRow, .completedRcvmtRow,
.rcvmtHistRow, .rctHistRow{
	cursor: pointer;
}
#receiptForm label{
	margin: 0px;
	display: flex;
	justify-content: center;
	align-items: center;
}
#receiptForm input{
	text-align: right;
}
/* 글씨체 통일 css */
table,h3{
	font-family: 'Noto Sans KR', sans-serif;
	font-weight:500;
}
.violetBtn:hover{
	background-color:#7c3dde !important;
}
.navbar-light .navbar-nav .nav-link {
	color: #f8f9fa;
	margin-left: 0.5rem;
	height: 38px;
	padding: 0.25rem;
	display: flex;
	align-items: center;
}
</style>
<div class="content-wrapper" style="background-color: #657D96;">
	<!-- main 검색창을 포함한 navbar 시작-->
	<nav class="navbar navbar-expand navbar-white navbar-light" style="background-color: #404b57;">
		<div id="ptSearchDiv" class="input-group d-none" style="width: 400px;">
			<input type="search" class="form-control" id="ptSearch" placeholder="환자 검색">
			<div class="input-group-append">
				<button type="button" id="ptSearchBtn" class="btn btn-outline-light" onclick="searchRcvmtHistList();">검색</button>
			</div>
		</div>
		<ul class="navbar-nav ml-auto"></ul>
		<div class="rcvmtMenu">
			<ul class="navbar-nav mb-0">
				<li class="nav-item">
					<a href="#" class="nav-link btn btn-outline-light active" onclick="changeMenu('rcvmtMain');">수납</a>
				</li>
				<li class="nav-item">
					<a href="#" class="nav-link btn btn-outline-light" onclick="changeMenu('rcvmtHistList');">수납 내역</a>
				</li>
				<li class="nav-item">
					<a href="#" class="nav-link btn btn-outline-light" onclick="changeMenu('rctHistList');">결제 내역</a>
				</li>
			</ul>
		</div>
	</nav>

	<section class="content" style="margin-top: 1%;">
		<!-- 수납 메인화면 시작 -->
		<div id="rcvmtMain" class="menuDiv" style="height: 900px;">
			<!-- 수납대기/완료 목록 시작 -->
			<div class="row mb-3" style="height: 40%;">
				<!-- 수납대기 시작 -->
				<div class="col-md-6">
					<div class="card card-info" style="height: 100%;">
						<div class="card-header" style="background-color: #404b57;">
							<div class="card-title">
								<h5 class="m-0">수납대기</h5>
							</div>
						</div>
						<div class="card-body p-0">
							<table class="table table-hover text-center">
								<thead class="sticky-top bg-white">
									<tr>
										<th>차트번호</th>
										<th>이름</th>
										<th>진료의사</th>
										<th>진료비</th>
									</tr>
								</thead>
								<tbody id="watingRcvmtListBody">
								</tbody>
							</table>
						</div>
					</div>
				</div>
				<!-- 수납대기 끝  -->
				<!-- 수납완료 시작  -->
				<div class="col-md-6">
					<div class="card card-info" style="height: 100%;">
						<div class="card-header" style="background-color: #404b57;">
							<div class="card-title">
								<h5 class="m-0">수납완료</h5>
							</div>
						</div>
						<div class="card-body p-0">
							<table class="table table-hover text-center">
								<thead class="sticky-top bg-white">
									<tr>
										<th>차트번호</th>
										<th>이름</th>
										<th>결제금액</th>
									</tr>
								</thead>
								<tbody id="completedRcvmtListBody">
								</tbody>
							</table>
						</div>
					</div>
				</div>
				<!-- 수납완료 끝  -->
			</div>
			<!-- 수납대기/완료 목록 끝 -->

			<!-- 환자정보 시작 -->
			<div class="card card-info" style="height: 28%;">
				<div class="card-header" style="background-color: #404b57;">
					<div class="card-title">
						<h5 class="m-0">환자정보 : <span id="ptHistListPtNm"></span></h5>
					</div>
				</div>
				<div class="card-body p-0">
					<div class="row h-100">
						<div class="col-md-2 h-100">
							<table class="table text-center p-0 m-0" style="height: 100%;">
								<tr>
									<td class="p-0">
										<a href="#"
										   class="ptHistType dropdown-item"
										   onclick="changePtHistType(this, 'ptRcvmtHistList');">수납</a>
									</td>
								</tr>
								<tr class="border-right">
									<td class="p-0">
										<a href="#"
										   class="ptHistType dropdown-item"
										   onclick="changePtHistType(this, 'ptChkupHistList');">진료</a>
									</td>
								</tr>
								<tr class="border" style="height: 100%;"></tr>
							</table>
						</div>
						<div class="col-md-10" style="height: 100%;">
							<div id="ptRcvmtHistList" class="overflow-auto ptHistList" style="height: 100%;">
								<table class="table text-center">
									<thead class="sticky-top bg-white">
										<tr>
											<th style="width: 20%;">번호</th>
											<th style="width: 20%;">수납구분</th>
											<th style="width: 20%;">총금액</th>
											<th style="width: 20%;">잔여금액</th>
											<th style="width: 20%;">수납일시</th>
										</tr>
									</thead>
									<tbody id="ptRcvmtHistListBody"></tbody>
								</table>
							</div>
							<div id="ptChkupHistList" class="overflow-auto ptHistList d-none" style="height: 100%;">
								<table class="table text-center">
									<thead class="sticky-top bg-white">
										<tr>
											<th style="width: 20%;">진료번호</th>
											<th style="width: 20%;">진료일</th>
											<th style="width: 45%;">처치내용</th>
											<th style="width: 15%;">담당의사</th>
										</tr>
									</thead>
									<tbody id="ptChkupHistListBody"></tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 환자정보 끝 -->

			<!-- 결제정보 시작 -->
			<div class="card card-info" style="height: 22%;">
				<div class="navbar card-header" style="background-color: #404b57;">
					<div class="card-title">
						<h5 class="m-0">결제정보</h5>
					</div>
					<ul class="navbar-nav ml-auto"></ul>
					<div class="text-right">
						<button type="button" class="btn btn-primary btnCss violetBtn" onclick="payInCard();" style="background-color: #904aff; border: #904aff;">카드 결제</button>
						<button type="button" class="btn btn-success btnCss" onclick="payInCash();" style="border:none;">현금 결제</button>
					</div>
				</div>
				<div class="card-body py-3">
					<form id="receiptForm" name="receiptForm">
						<div class="row">
							<div class="col-sm-3">
								<div class="form-group row my-2">
									<label class="col-sm-5">수납번호</label>
									<input type="text" class="col-sm-7 form-control-plaintext" name="rcvmtNum" readonly />
								</div>
								<div class="form-group row my-2">
									<label class="col-sm-5">상태</label>
									<input type="text" class="col-sm-7 form-control-plaintext" name="rcvmtStatus" readonly />
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group row my-2">
									<label class="col-sm-5">진료비</label>
									<input type="text" id="rcvmtAmt" class="col-sm-5 form-control-plaintext" name="rcvmtAmt" readonly />
									<h3 class="col-sm-2 text-right">원</h3>
								</div>
								<div class="form-group row my-2">
									<label class="col-sm-5">할인</label>
									<input type="text" id="rcvmtDscntAmt" class="col-sm-5 form-control" name="rcvmtDscntAmt" />
									<h3 class="col-sm-2 text-right">원</h3>
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group row my-2">
									<label class="col-sm-5">부가가치세<small>(포함)</small></label>
									<input type="text" id="rcvmtTax" class="col-sm-5 form-control-plaintext" name="rcvmtTax" readonly />
									<h3 class="col-sm-2 text-right">원</h3>
								</div>
								<div class="form-group row my-2">
									<label class="col-sm-5">결제금액</label>
									<input type="text" id="rctAmt" class="col-sm-5 form-control" name="rctAmt" />
									<h3 class="col-sm-2 text-right">원</h3>
								</div>
							</div>
							<div class="col-sm-3">
								<div class="form-group row my-2">
									<label class="col-sm-5">합계</label>
									<input type="text" id="rcvmtGramt" class="col-sm-5 form-control-plaintext" name="rcvmtGramt" readonly />
									<h3 class="col-sm-2 text-right">원</h3>
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
			<!-- 결제정보 끝 -->
		</div>
		<!-- 수납 메인화면 끝 -->

		<!-- 수납내역 시작 -->
		<div id="rcvmtHistList" class="menuDiv d-none" style="height: 900px;">
			<div class="row" style="height: 100%;">
				<div class="col-md-9" style="height: 100%;">
					<div class="card card-info" style="height: 100%;">
						<div class="card-header" style="background-color: #404b57;">
							<div class="card-title">
								<h5 class="m-0">수납내역</h5>
							</div>
						</div>
						<div class="card-body py-2 text-right" style="height: 46px; min-height: 46px; max-height: 46px; border-bottom:1px solid #e1e1e1;">
							<input type="date" id="rcvmtSDate" /> ~ <input type="date" id="rcvmtEDate" />
						</div>
						<div class="card-body p-0 overflow-auto">
							<table class="table table-hover text-center">
								<thead class="sticky-top bg-white">
									<tr>
										<th style="width: 22%;">차트번호</th>
										<th style="width: 15%;">환자명</th>
										<th style="width: 21%;">수납일</th>
										<th style="width: 21%;">미수금</th>
										<th style="width: 21%;">총액</th>
									</tr>
								</thead>
								<tbody id="rcvmtHistListBody"></tbody>
							</table>
						</div>
					</div>
				</div>
				<div class="col-md-3">
					<div class="card card-info" style="height: 80%;">
						<div class="card-header" style="background-color: #404b57;">
							<div class="card-title">
								<h5 class="m-0">결제</h5>
							</div>
						</div>
						<div class="card-body">
							<form name="rcvmtHistReceiptForm">
								<div class="form-group my-3">
									<label>차트번호</label>
									<input type="text" class="form-control-plaintext" name="ptNum" readonly />
								</div>
								<div class="form-group my-3">
									<label>환자명</label>
									<input type="text" class="form-control-plaintext" name="ptNm" readonly />
								</div>
								<div class="form-group my-3">
									<label>수납번호</label>
									<input type="text" class="form-control-plaintext" name="rcvmtNum" readonly />
								</div>
								<div class="form-group my-3">
									<label>구분</label>
									<input type="text" class="form-control-plaintext" name="rcvmtType" readonly />
								</div>
								<div class="form-group my-3">
									<label>미수금</label>
									<div class="row">
										<input type="text" id="rcvmtBalance" class="form-control-plaintext col-sm-9 text-right" name="rcvmtBalance" readonly />
										<h3 class="text-right col-sm-3">원</h3>
									</div>
								</div>
								<div class="form-group my-3">
									<label>결제금액</label>
									<div class="row">
										<input type="text" id="rctAmt" class="form-control col-sm-9 text-right" name="rctAmt" />
										<h3 class="text-right col-sm-3">원</h3>
									</div>
								</div>
								<div class="text-right my-3">
									<button type="button" class="btn btn-primary btnCss violetBtn" onclick="payInCardOnRcvmtHist();" style="background-color: #904aff; border: #904aff;">카드 결제</button>
									<button type="button" class="btn btn-success btnCss" onclick="payInCashOnRcvmtHist();" style="border:none;">현금 결제</button>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- 수납내역 끝 -->

		<!-- 결제내역 시작 -->
		<div id="rctHistList" class="menuDiv d-none" style="height: 900px;">
			<div class="row" style="height: 100%;">
				<div class="col-md-9" style="height: 100%;">
					<div class="card card-info" style="height: 100%;">
						<div class="card-header" style="background-color: #404b57;">
							<div class="card-title">
								<h5 class="m-0">결제내역</h5>
							</div>
						</div>
						<div class="card-body py-2 text-right" style="height: 46px; min-height: 46px; max-height: 46px; border-bottom:1px solid #e1e1e1;">
							<input type="date" id="rctSDate" /> ~ <input type="date" id="rctEDate" />
						</div>
						<div class="card-body p-0 overflow-auto">
							<table class="table table-hover text-center">
								<thead class="sticky-top bg-white">
									<tr>
										<th style="width: 22%;">차트번호</th>
										<th style="width: 20%;">환자명</th>
										<th style="width: 16%;">결제방식</th>
										<th style="width: 20%;">결제금액</th>
										<th style="width: 22%;">결제일</th>
									</tr>
								</thead>
								<tbody id="rctHistListBody"></tbody>
							</table>
						</div>
					</div>
				</div>
				<div class="col-md-3">
					<div class="card card-info" style="height: 100%;">
						<div class="card-header" style="background-color: #404b57;">
							<div class="card-title">
								<h5 class="m-0">영수증</h5>
							</div>
						</div>
						<div class="card-body">
							<form name="rctHistForm">
								<input type="hidden" name="rctNum" />
								<div class="form-group my-3">
									<label>차트번호</label>
									<input type="text" class="form-control-plaintext" name="ptNum" readonly />
								</div>
								<div class="form-group my-3">
									<label>환자명</label>
									<input type="text" class="form-control-plaintext" name="ptNm" readonly />
								</div>
								<div class="form-group my-3">
									<label>수납번호</label>
									<input type="text" class="form-control-plaintext" name="rcvmtNum" readonly />
								</div>
									<div class="form-group col-sm-6">
										<label>결제순번</label>
										<div class="row">
											<input type="text" id="rcvmtRctSn" class="form-control-plaintext col-sm-6 text-right" name="rcvmtRctSn" readonly />
											<h3 class="text-center col-sm-6">회</h3>
										</div>
									</div>
								<div class="form-group my-3">
									<label>결제방식</label>
									<input type="text" class="form-control-plaintext" name="rctPayOpt" readonly />
								</div>
								<div class="row my-3">
									<div class="form-group col-sm-4">
										<label>카드사</label>
										<input type="text" class="form-control-plaintext" name="rctCardComp" readonly />
									</div>
									<div class="form-group col-sm-8">
										<label>카드번호</label>
										<input type="text" class="form-control-plaintext" name="rctCardNum" readonly />
									</div>
								</div>
								<div class="form-group my-3">
									<label>결제승인번호</label>
									<input type="text" class="form-control-plaintext" name="rctAcceptNum" readonly />
								</div>
								<div class="form-group my-3">
									<label>결제금액</label>
									<input type="text" class="form-control-plaintext" name="rctAmt" readonly />
								</div>
								<div class="text-right my-3">
									<button type="button" class="btn btn-primary btnCss violetBtn" onclick="receiptWindow();" style="background-color: #904aff; border: #904aff;">영수증 확인</button>
									<button type="button" class="btn btn-danger btnCss" onclick="refundRct();" style="border:none;">환불</button>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- 결제내역 끝 -->
	</section>
</div>
<script>

// 클릭 시 영수증 정보
function receiptWindow() {
	const rctHistFormData = new FormData(document.rctHistForm);
	if(rctHistFormData.get('rcvmtNum') == ''){
		simpleErrorAlert('결제 건을 선택해주세요.');
		return false;
	}
	var histRctNum = rctHistFormData.get("rctNum");

	let receiptWin = window.open(
			url = "/hospital/rcvmt/rcvmtWindow?rctNum=" + histRctNum,
			 'rcvmt', 'top=200, left=300, width=1000, height=800, toolbar=no, menubar=no, location=no, status=no, scrollbars=no, resizable=no');
};

// 상단 메뉴 버튼 클릭 시 활성화
$('.rcvmtMenu .nav-link').on('click', function(){
	$('.rcvmtMenu .nav-link').removeClass('active');
	$(this).addClass('active');
});

// 수납 대기 목록 초기화
listWaitingRcvmt();
//수납 완료 목록 초기화
listCompletedRcvmt();

//CRM 내역의 초기 날짜는 일주일전부터 오늘까지이다.
let today = new Date().toISOString().split('T')[0];
let beforeSevenDays = new Date(today);
beforeSevenDays.setDate(beforeSevenDays.getDate() - 7);
beforeSevenDays = beforeSevenDays.toISOString().split('T')[0];

document.querySelector('#rcvmtEDate').value = today;
document.querySelector('#rcvmtSDate').value = beforeSevenDays;
document.querySelector('#rcvmtSDate').max = today;
document.querySelector('#rcvmtEDate').max = today;
document.querySelector('#rcvmtEDate').min = beforeSevenDays;

document.querySelector('#rctEDate').value = today;
document.querySelector('#rctSDate').value = beforeSevenDays;
document.querySelector('#rctSDate').max = today;
document.querySelector('#rctEDate').max = today;
document.querySelector('#rctEDate').min = beforeSevenDays;

// CRM 내역에서 시작날짜 변경 시 종료날짜가 자동으로 변경된다.
$('#rcvmtSDate').on('change', function(){
	const rcvmtSDate = $('#rcvmtSDate');
	const rcvmtEDate = $('#rcvmtEDate');

	if(rcvmtSDate.val() > rcvmtEDate.val()){
		rcvmtEDate.val(rcvmtSDate.val());
	}
	rcvmtEDate.attr('min', rcvmtSDate.val());
});

// CRM 내역에서 시작날짜, 종료날짜 변경 시 날짜 검색
$('#rcvmtSDate, #rcvmtEDate').on('change', function(){
	searchRcvmtHistList();
});

// 결제 내역에서 시작날짜 변경 시 종료날짜가 자동으로 변경된다.
$('#rctSDate').on('change', function(){
	const rctSDate = $('#rctSDate');
	const rctEDate = $('#rctEDate');

	if(rctSDate.val() > rctEDate.val()){
		rctEDate.val(rctSDate.val());
	}
	rctEDate.attr('min', rctSDate.val());
});

// 결제 내역에서 시작날짜, 종료날짜 변경 시 날짜 검색
$('#rctSDate, #rctEDate').on('change', function(){
	searchRctHistList();
});

// 수납대기 행을 클릭하면 해당 환자의 이력정보와 수납에 필요한 정보를 가져옴
$(document).on('click', '.waitingRcvmtRow', function(){

	const ptNum = $(this).find('.waitingRcvmtPtNum').text().trim();
	const ptNm = $(this).children()[1].textContent.trim();

	$('#ptHistListPtNm').text(ptNm + '(' + ptNum + ')');

	const rcvmtNum = $(this).data('rcvmtnum');

	listPtRcvmtHist(ptNum);
	listPtChkupHist(ptNum);
	selectRcvmt(rcvmtNum);

});

// 수납완료 행을 클릭하면 해당 환자의 이력정보를 가져옴
$(document).on('click', '.completedRcvmtRow', function(){

	const ptNum = $(this).find('.completedRcvmtPtNum').text().trim();
	const ptNm = $(this).children()[1].textContent.trim();

	$('#ptHistListPtNm').text(ptNm + '(' + ptNum + ')');

	listPtRcvmtHist(ptNum);
	listPtChkupHist(ptNum);

});

// 할인 칸에서 커서가 떠나면 할인가를 계산한 총액이 구해짐
$('#rcvmtDscntAmt').on('blur', function(){

	let rcvmtDscntAmt = $(this).val();
	let rcvmtAmt = $('#rcvmtAmt').val()
	if(rcvmtAmt == '') return false;

	rcvmtAmt = rcvmtAmt.replace(/\,/g, '');

	let newRcvmtGramt = rcvmtAmt - rcvmtDscntAmt;

	$('#rcvmtGramt').val(newRcvmtGramt.toLocaleString());

});

// 검색칸에서 엔터키를 누르면 검색 실행
$('#ptSearch').on('keydown', function(e){
	if(e.keyCode == 13){
		document.querySelector('#ptSearchBtn').click();
	}
})

// 네비게이션바의 메뉴를 클릭하면 메뉴 변경
function changeMenu(menuName){

	$('#ptSearch').val('');
	$('.menuDiv').addClass('d-none');
	$('#' + menuName).removeClass('d-none');

	const ptSearchDiv = $('#ptSearchDiv');
	const ptSearchBtn = document.querySelector('#ptSearchBtn');

	switch(menuName){
	case 'rcvmtMain':
		ptSearchDiv.addClass('d-none');
		ptSearchBtn.onclick = '';
		listWaitingRcvmt();
		listCompletedRcvmt();
		break;
	case 'rcvmtHistList':
		ptSearchDiv.removeClass('d-none');
		ptSearchBtn.onclick = searchRcvmtHistList;
		searchRcvmtHistList();
		break;
	case 'rctHistList':
		ptSearchDiv.removeClass('d-none');
		ptSearchBtn.onclick = searchRctHistList;
		searchRctHistList();
		break;
	}

}

// 수납대기 목록 조회
function listWaitingRcvmt(){

	fetch('/hospital/rcvmt/listWaitingRcvmt')
	.then(res => res.json())
	.then(watingRcvmtList => {

		let code = '';
		watingRcvmtList.forEach(function(rcvmt){

			code += '<tr class="waitingRcvmtRow" data-rcvmtnum="' + rcvmt.rcvmtNum + '">';
			code += '<td class="waitingRcvmtPtNum">' + rcvmt.ptNum + '</td>';
			code += '<td>' + rcvmt.ptNm + '</td>';
			code += '<td>' + rcvmt.empNm + '</td>';
			code += '<td>' + rcvmt.rcvmtAmt.toLocaleString() + '</td>';
			code += '</tr>';

		});

		document.querySelector('#watingRcvmtListBody').innerHTML = code;
	});

}

//수납완료 목록 조회
function listCompletedRcvmt(){

	fetch('/hospital/rcvmt/listCompletedRcvmt')
	.then(res => res.json())
	.then(completedRcvmtList => {

		let code = '';
		completedRcvmtList.forEach(function(rcvmt){

			code += '<tr class="completedRcvmtRow" data-rcvmtnum="' + rcvmt.rcvmtNum + '">';
			code += '<td class="completedRcvmtPtNum">' + rcvmt.ptNum + '</td>';
			code += '<td>' + rcvmt.ptNm + '</td>';
			code += '<td>' + rcvmt.rctAmt.toLocaleString() + '</td>';
			code += '</tr>';

		});

		document.querySelector('#completedRcvmtListBody').innerHTML = code;
	});

}

// 수납정보 조회
function selectRcvmt(rcvmtNum){

	fetch('/hospital/rcvmt/selectRcvmt?rcvmtNum=' + rcvmtNum)
		.then(res => res.json())
		.then(rcvmt => {

			let receiptForm = document.receiptForm;
			receiptForm.rcvmtNum.value = rcvmt.rcvmtNum;
			receiptForm.rcvmtAmt.value = rcvmt.rcvmtAmt.toLocaleString();
			receiptForm.rcvmtStatus.value = rcvmt.rcvmtStatus;
			receiptForm.rcvmtDscntAmt.value = rcvmt.rcvmtDscntAmt;
			receiptForm.rcvmtGramt.value = rcvmt.rcvmtGramt.toLocaleString();
			receiptForm.rcvmtTax.value = (rcvmt.rcvmtAmt/10).toLocaleString();

		});
}

// 환자정보 메뉴 변경
function changePtHistType(element, type){

	document.querySelectorAll('.ptHistType').forEach(function(type){
		type.blur();
		type.parentNode.parentNode.classList.add('border-right');
	});

	element.parentNode.parentNode.classList.remove('border-right');

	document.querySelectorAll('.ptHistList').forEach(function(list){
		list.classList.add('d-none');
	});

	document.querySelector('#' + type).classList.remove('d-none');

}

// 환자 수납이력 조회
function listPtRcvmtHist(ptNum){

	fetch('/hospital/rcvmt/listPtRcvmtHist?ptNum=' + ptNum)
		.then(res => res.json())
		.then(rcvmtList => {

			let code = '';
			rcvmtList.forEach(function(rcvmt){
				code += '<tr>';
				code += '<td>' + rcvmt.rcvmtNum + '</td>';
				code += '<td>' + rcvmt.rcvmtType + '</td>';
				code += '<td>' + rcvmt.rcvmtGramt.toLocaleString() + '</td>';
				code += '<td>' + rcvmt.rcvmtBalance.toLocaleString() + '</td>';
				code += '<td>' + rcvmt.rcvmtDtStr + '</td>';
				code += '</tr>';
			});

			document.querySelector('#ptRcvmtHistListBody').innerHTML = code;

		});

}

// 환자 진료이력 조회
function listPtChkupHist(ptNum){

	fetch('/hospital/rcvmt/listPtChkupHist?ptNum=' + ptNum)
	.then(res => res.json())
	.then(chkupList => {

		let code = '';
		chkupList.forEach(function(chkup){
			code += '<tr>';
			code += '<td>' + chkup.chkNum + '</td>';
			code += '<td>' + chkup.chkDtStr + '</td>';
			let txContent = '';
			for(let i = 0; i < chkup.txList.length; i++){
				if(i > 0) txContent += ', ';
				txContent += chkup.txList[i].txcCd;
			}
			code += '<td>' + txContent + '</td>';
			code += '<td>' + chkup.empNm + '</td>';
			code += '</tr>';
		});

		document.querySelector('#ptChkupHistListBody').innerHTML = code;
	});

}

// 카드 결제
function payInCard(){

	const rctAmt = document.receiptForm.rctAmt.value.trim().replace(/\,/g, '');
	if(rctAmt == '') {
		simpleErrorAlert('결제금액을 확인해주세요.');
		return false;
	}

	const rcvmtNum = document.receiptForm.rcvmtNum.value;
	const rcvmtDscntAmt = document.receiptForm.rcvmtDscntAmt.value;
	const ptHistListPtNm = document.getElementById("ptHistListPtNm").textContent.split("(")[0];

	payAPI(rcvmtNum, rctAmt, rcvmtDscntAmt, ptHistListPtNm);
}

// 카드결제 api
// 수납 번호, 수납금액 , 할인 금액, 환자 이름
function payAPI(rcvmtNum, rctAmt, rcvmtDscntAmt, ptHistListPtNm){

	var amount = rctAmt - rcvmtDscntAmt; // 결제 금액
	var ptNm = ptHistListPtNm; // 결제자 이름(환자 이름)

	var IMP = window.IMP;
	//가맹점 식별코드
	IMP.init("imp88644884");//박승배 식별코드입니다~

	// 결제창 호출
	IMP.request_pay({
	    pg : 'html5_inicis', // 여러 가맹점 지정시 html5_inicis
	    pay_method : 'card',
	    merchant_uid : 'hospital_' + new Date().getTime(),
	    name : "수납결제",
	    buyer_email : ' ',
	    amount : 500, //결제 금액 : amount
	    buyer_name : ptNm,
	}, function(rsp) {
	    if ( rsp.success ) {
	        var msg = '결제가 완료되었습니다.';
	        msg += '고유ID : ' + rsp.imp_uid;
	        msg += '상점 거래ID : ' + rsp.merchant_uid;
	        msg += '결제 금액 : ' + amount//rsp.paid_amount;
	        msg += '카드 승인번호 : ' + rsp.apply_num;
	        console.log(msg);

	        var rctCardComp = rsp.card_name;
	        if(rctCardComp == null){
	        	rctCardComp = "카카오페이";
	        }
	        var rctCardNum = rsp.card_number;
	        var rctAcceptNum = rsp.apply_num;
	        // 결제 진행 후 데이터 입력
	        var data = {
				'rcvmtNum' : rcvmtNum,
				'rcvmtDscntAmt' : rcvmtDscntAmt,
				'rctAmt' : rctAmt,
				'rctPayOpt' : 'CARD',
				'rctCardComp' : rctCardComp,
				'rctCardNum' : rctCardNum,
				'rctAcceptNum' : rctAcceptNum
			}
	        payCardInfo(data);
	    } else {
	        var msg = '결제에 실패하였습니다.\n';
	        msg += '에러내용 : ' + rsp.error_msg;
	        simpleErrorAlert(msg);
	    }
	    console.log(rsp);
	});
};

//결제 카드 정보(수납 번호, 수납 할인 금액, 수납 총 금액, 카드사, 카드번호, 승인번호)
function payCardInfo(data){
	const csrfToken = $('#_csrfToken').val();
	fetch('/hospital/rcvmt/payInCard', {
		method: 'post',
		headers: {
			'X-CSRF-TOKEN' : csrfToken,
			'Content-Type' : 'application/json;charset=utf-8'
		},
		body: JSON.stringify(data)
	})
	.then(res => res.text())
	.then(text => {

		if(text == 'FAILED'){
			simpleJustErrorAlert();
			return false;
		}

		listWaitingRcvmt();
		listCompletedRcvmt();
		document.querySelector('#ptHistListPtNm').textContent = '';
		document.querySelector('#ptRcvmtHistListBody').innerHTML = '';
		document.querySelector('#ptChkupHistListBody').innerHTML = '';
		document.receiptForm.reset();

		simpleSuccessAlert('결제가 완료되었습니다.');

		rctWindow(text);

	});
}

// 현금 결제
function payInCash(){

	const rcvmtNum = document.receiptForm.rcvmtNum.value.trim();
	if(rcvmtNum == ''){
		simpleErrorAlert('처리할 수납 건을 선택해주세요.');
		return false;
	}

	const rcvmtDscntAmt = document.receiptForm.rcvmtDscntAmt.value;
	const rctAmt = document.receiptForm.rctAmt.value.trim().replace(/\,/g, '');
	if(rctAmt == '') {
		simpleErrorAlert('결제금액을 확인해주세요.');
		return false;
	}

	if(!(/^[0-9]+$/).test(rctAmt) || !(/^[0-9]+$/).test(rcvmtDscntAmt)){
		simpleErrorAlert('숫자만 입력해주세요.');
		return false;
	}

	Swal.fire({
		title: '결제 방식 확인',
		text: '현금 결제 후 수납완료 처리하시겠습니까?',
		showDenyButton: true,
		confirmButtonText: '확인',
		denyButtonText: '취소',
	}).then(result => {
		if(result.isConfirmed){

			const csrfToken = $('#_csrfToken').val();
			fetch('/hospital/rcvmt/payInCash', {
				method: 'post',
				headers: {
					'X-CSRF-TOKEN' : csrfToken,
					'Content-Type' : 'application/json;charset=utf-8'
				},
				body: JSON.stringify({
					'rcvmtNum' : rcvmtNum,
					'rcvmtDscntAmt' : rcvmtDscntAmt,
					'rctAmt' : rctAmt,
					'rctPayOpt' : 'CASH'
				})
			})
				.then(res => res.text())
				.then(text => {

					if(text == 'FAILED'){
						simpleJustErrorAlert();
						return false;
					}

					listWaitingRcvmt();
					listCompletedRcvmt();
					document.querySelector('#ptHistListPtNm').textContent = '';
					document.querySelector('#ptRcvmtHistListBody').innerHTML = '';
					document.querySelector('#ptChkupHistListBody').innerHTML = '';
					document.receiptForm.reset();

					simpleSuccessAlert('결제가 완료되었습니다.');

					rctWindow(text);
				});
		}
	});

}

// 수납 내역 목록을 선택하면 우측 폼에 상세 정보가 출력된다.
$(document).on('click', '.rcvmtHistRow', function(){

	const ptNum = $(this).children()[0].textContent;
	const ptNm = $(this).children()[1].textContent;
	const rcvmtNum = $(this).data('rcvmtnum');
	const rcvmtType = $(this).data('rcvmttype')
	const rcvmtBalance = $(this).children()[3].textContent;

	const receiptForm = document.rcvmtHistReceiptForm;
	receiptForm.ptNum.value = ptNum;
	receiptForm.ptNm.value = ptNm;
	receiptForm.rcvmtNum.value = rcvmtNum;
	receiptForm.rcvmtType.value = rcvmtType;
	receiptForm.rcvmtBalance.value = rcvmtBalance.toLocaleString();
});

// 수납내역 검색 조회
function searchRcvmtHistList(){

	const keyword = document.querySelector('#ptSearch').value;
	const rcvmtSDate = document.querySelector('#rcvmtSDate').value;
	const rcvmtEDate = document.querySelector('#rcvmtEDate').value;

	let parameterData = {
			keyword : keyword,
			rcvmtSDate : rcvmtSDate,
			rcvmtEDate : rcvmtEDate
		};

	const parameterString = Object.entries(parameterData).map(e => e.join('=')).join('&');

	fetch('/hospital/rcvmt/searchRcvmtHistList?' + parameterString)
		.then(res => res.json())
		.then(rcvmtList => {

			let code = '';
			if(rcvmtList.length == 0){
				code += '<tr>';
				code += '<td colspan="5">검색 결과가 없습니다.</td>';
				code += '</tr>';
			} else {
				rcvmtList.forEach(function(rcvmt){
					code += '<tr class="rcvmtHistRow" data-rcvmtnum="' + rcvmt.rcvmtNum + '" data-rcvmttype="' + rcvmt.rcvmtType + '">';
					code += '<td>' + rcvmt.ptNum + '</td>';
					code += '<td>' + rcvmt.ptNm + '</td>';
					code += '<td>' + rcvmt.rcvmtDtStr + '</td>';
					code += '<td>' + rcvmt.rcvmtBalance.toLocaleString() + '</td>';
					code += '<td>' + rcvmt.rcvmtGramt.toLocaleString() + '</td>';
					code += '</tr>';
				});
			}

			document.querySelector('#rcvmtHistListBody').innerHTML = code;
		});
};

//카드결제 api
//수납 번호, 수납금액 , 할인 금액, 환자 이름
function payAPIHist(rcvmtNum, rctAmt, ptNm){

	var amount = rctAmt; // 결제 금액
	var Nm = ptNm; // 결제자 이름(환자 이름)

	var IMP = window.IMP;
	//가맹점 식별코드
	IMP.init("imp88644884");//박승배 식별코드입니다~

	// 결제창 호출
	IMP.request_pay({
	    pg : 'html5_inicis', // 여러 가맹점 지정시 html5_inicis
	    pay_method : 'card',
	    merchant_uid : 'hospital_' + new Date().getTime(),
	    name : "수납결제",
	    buyer_email : ' ',
	    amount : 500, //결제 금액 : amount
	    buyer_name : Nm,
	}, function(rsp) {
	    if ( rsp.success ) {
	        var msg = '결제가 완료되었습니다.';
	        msg += '고유ID : ' + rsp.imp_uid;
	        msg += '상점 거래ID : ' + rsp.merchant_uid;
	        msg += '결제 금액 : ' + amount//rsp.paid_amount;
	        msg += '카드 승인번호 : ' + rsp.apply_num;
	        console.log(msg);
	        // 결제 예상 금액과 실결제 금액이 미일 치시 결제 취소 후 다시 결제 요청 -- 아직 안함.. 해야할까?
	        var rctCardComp = rsp.card_name;
	        if(rctCardComp == null){
	        	rctCardComp = "카카오페이";
	        }
	        var rctCardNum = rsp.card_number;
	        var rctAcceptNum = rsp.apply_num;
	        // 결제 진행 후 데이터 입력
	        var data = {
				'rcvmtNum' : rcvmtNum,
				'rctAmt' : rctAmt,
				'rctPayOpt' : 'CARD',
				'rctCardComp' : rctCardComp,
				'rctCardNum' : rctCardNum,
				'rctAcceptNum' : rctAcceptNum
			}
	        payCardInfoHist(data);
	    } else {
	        var msg = '결제에 실패하였습니다.\n';
	        msg += '에러내용 : ' + rsp.error_msg;
	        simpleErrorAlert(msg);
	    }
	    console.log(rsp);
	});
};

function payCardInfoHist(data){
	const csrfToken = $('#_csrfToken').val();
	fetch('/hospital/rcvmt/payInCardOnRcvmtHist', {
		method: 'post',
		headers: {
			'X-CSRF-TOKEN' : csrfToken,
			'Content-Type' : 'application/json;charset=utf-8'
		},
		body: JSON.stringify(data)
	})
	.then(res => res.text())
	.then(text => {

		if(text == 'FAILED'){
			simpleJustErrorAlert();
			return false;
		}

		document.rcvmtHistReceiptForm.reset();
		searchRcvmtHistList();

		simpleSuccessAlert('결제가 완료되었습니다.');

		rctWindow(text);

	});
}


// 수납 내역에서 카드결제
function payInCardOnRcvmtHist(){

	const receiptForm = document.rcvmtHistReceiptForm;

	const rcvmtNum = receiptForm.rcvmtNum.value.trim();
	const rcvmtBalance = receiptForm.rcvmtBalance.value.trim();
	const rctAmt = receiptForm.rctAmt.value.trim().replace(/\,/g, '');
	const ptNm = receiptForm.ptNm.value.trim();
	console.log(ptNm);

	if(rcvmtNum == ''){
		simpleErrorAlert('처리할 수납 건을 선택해주세요.');
		return false;
	}

	if(rcvmtBalance == '0'){
		simpleErrorAlert('완납된 수납 건입니다.');
		return false;
	}

	if(rctAmt == '') {
		simpleErrorAlert('결제금액을 확인해주세요.');
		return false;
	}

	if(!(/^[0-9]+$/).test(rctAmt)){
		simpleErrorAlert('숫자만 입력해주세요.');
		return false;
	}

	// 카드결제 api
	// 수납 번호, 수납금액 , 할인 금액, 환자 이름
	payAPIHist(rcvmtNum, rctAmt, ptNm);

}

function payInCashOnRcvmtHist(){

	const receiptForm = document.rcvmtHistReceiptForm;

	const rcvmtNum = receiptForm.rcvmtNum.value.trim();
	const rcvmtBalance = receiptForm.rcvmtBalance.value.trim();
	const rctAmt = receiptForm.rctAmt.value.trim().replace(/\,/g, '');

	if(rcvmtNum == ''){
		simpleErrorAlert('처리할 수납 건을 선택해주세요.');
		return false;
	}

	if(rcvmtBalance == '0'){
		simpleErrorAlert('완납된 접수 건입니다.');
		return false;
	}

	if(rctAmt == '') {
		simpleErrorAlert('결제금액을 확인해주세요.');
		return false;
	}

	if(!(/^[0-9]+$/).test(rctAmt)){
		simpleErrorAlert('숫자만 입력해주세요.');
		return false;
	}



	Swal.fire({
		title: '결제 방식 확인',
		text: '현금 결제 후 수납완료 처리하시겠습니까?',
		showDenyButton: true,
		confirmButtonText: '확인',
		denyButtonText: '취소',
	}).then(result => {
		if(result.isConfirmed){

			const csrfToken = $('#_csrfToken').val();
			fetch('/hospital/rcvmt/payInCashOnRcvmtHist', {
				method: 'post',
				headers: {
					'X-CSRF-TOKEN' : csrfToken,
					'Content-Type' : 'application/json;charset=utf-8'
				},
				body: JSON.stringify({
					'rcvmtNum' : rcvmtNum,
					'rctAmt' : rctAmt,
					'rctPayOpt' : 'CASH'
				})
			})
				.then(res => res.text())
				.then(text => {

					if(text == 'FAILED'){
						simpleJustErrorAlert();
						return false;
					}

					receiptForm.reset();
					searchRcvmtHistList();
					simpleSuccessAlert('결제가 완료되었습니다.');

					rctWindow(text);

				});
		}
	});

}

// 결제내역 조회
function searchRctHistList(){

	const keyword = document.querySelector('#ptSearch').value;
	const rctSDate = document.querySelector('#rctSDate').value;
	const rctEDate = document.querySelector('#rctEDate').value;

	let parameterData = {
			keyword : keyword,
			rctSDate : rctSDate,
			rctEDate : rctEDate
		};

	const parameterString = Object.entries(parameterData).map(e => e.join('=')).join('&');

	fetch('/hospital/rcvmt/searchRctHistList?' + parameterString)
		.then(res => res.json())
		.then(rctList => {

			let code = '';
			if(rctList.length == 0){
				code += '<tr>';
				code += '<td colspan="5">검색 결과가 없습니다.</td>';
				code += '</tr>';
			} else {

				rctList.forEach(function(rct){
					code += '<tr class="rctHistRow" data-rctnum="' + rct.rctNum + '">';
					code += '<td>' + rct.ptNum + '</td>';
					code += '<td>' + rct.ptNm + '</td>';
// 					code += '<td></td>';
					code += '<td>' + (rct.rctPayOpt == null ? '-' : rct.rctPayOpt) + '</td>';
					code += '<td>' + rct.rctAmt.toLocaleString() + '</td>';
					code += '<td>' + rct.rctIssueDtStr + '</td>';
					code += '</tr>';
				});
			}

			document.querySelector('#rctHistListBody').innerHTML = code;
		});

}

$(document).on('click', '.rctHistRow', function(){

	const rctNum = $(this).data('rctnum');
	selectRctHist(rctNum);

});

// 선택된 결제 건에 대한 정보 조회
function selectRctHist(rctNum){

	fetch('/hospital/rcvmt/selectRctHist?rctNum=' + rctNum)
		.then(res => res.json())
		.then(rct => {

			const rctHistForm = document.rctHistForm;
			rctHistForm.ptNum.value = rct.ptNum;
			rctHistForm.ptNm.value = rct.ptNm;
			rctHistForm.rctNum.value = rct.rctNum;
			rctHistForm.rcvmtNum.value = rct.rcvmtNum;
// 			rctHistForm.rctType.value = '';
			rctHistForm.rcvmtRctSn.value = rct.rcvmtRctSn;
			rctHistForm.rctPayOpt.value = rct.rctPayOpt;
			rctHistForm.rctCardComp.value = rct.rctCardComp;
			rctHistForm.rctCardNum.value = rct.rctCardNum == '0' ? '' : rct.rctCardNum;
			rctHistForm.rctAcceptNum.value = rct.rctAcceptNum == '0' ? '' : rct.rctAcceptNum;
			rctHistForm.rctAmt.value = rct.rctAmt;

		})

}

// 환불처리
function refundRct(){

	const rctHistFormData = new FormData(document.rctHistForm);
	if(rctHistFormData.get('rcvmtNum') == ''){
		simpleErrorAlert('결제 건을 선택해주세요.');
		return false;
	}

	const rctPayOpt = rctHistFormData.get('rctPayOpt');
	if(rctPayOpt == '환불' || rctPayOpt == '취소'){
		simpleErrorAlert('이미 취소된 결제 건입니다.');
		return false;
	}


	Swal.fire({
		title: '결제 건을 환불하시겠습니까?',
		showDenyButton: true,
		confirmButtonText: '확인',
		denyButtonText: '취소',
	}).then(result => {
		if(result.isConfirmed){

			if(rctHistFormData.get('rctAcceptNum') == '') rctHistFormData.set('rctAcceptNum', '0');
			if(rctHistFormData.get('rctCardNum') == '') rctHistFormData.set('rctCardNum', '0');

			const csrfToken = $('#_csrfToken').val();
			fetch('/hospital/rcvmt/refundRct', {
				method: 'post',
				headers: {
					'X-CSRF-TOKEN' : csrfToken
				},
				body: rctHistFormData
			})
				.then(res => res.text())
				.then(text => {
					if(text == 'FAILED'){
						simpleJustErrorAlert();
						return false;
					}

					searchRctHistList();
					document.rctHistForm.reset();
					simpleSuccessAlert('환불 처리되었습니다.');
				})

		}
	});

}

</script>
<script src="/resources/js/alertModule.js"></script>
<script src="/resources/js/receiptIssue.js"></script>
<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
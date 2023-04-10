<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
.docBtn:hover {
	background-color: #23232B !important;
}

.searchBtn{
	background-color:#904aff;
	border:none;
	width:130px;
	height:70px;
	color:white;
	float:right;
	border-radius:50px;
	font-size:1.2rem;
	margin-top:8px;
}

.listScroll::-webkit-scrollbar{
	 display: none;
}

.overflow-auto::-webkit-scrollbar{
	display: none;
}

.dropdown-item{
	cursor: pointer;
}
.doclist{
	cursor: pointer;
}

.docMenu a {
    font-family: 'Noto Sans KR', sans-serif;
    color: white;
}

/* 검색 초기화 버튼 */
@keyframes vibrate-1 {
  0% {
    -webkit-transform: translate(0);
            transform: translate(0);
  }
  20% {
    -webkit-transform: translate(-2px, 2px);
            transform: translate(-2px, 2px);
  }
  40% {
    -webkit-transform: translate(-2px, -2px);
            transform: translate(-2px, -2px);
  }
  60% {
    -webkit-transform: translate(2px, 2px);
            transform: translate(2px, 2px);
  }
  80% {
    -webkit-transform: translate(2px, -2px);
            transform: translate(2px, -2px);
  }
  100% {
    -webkit-transform: translate(0);
            transform: translate(0);
  }
}

.crossBtn {
    border-radius: 30px;
    border: 2px solid white;
    width: 35px;
    height: 35px;
    text-align: center;
    background: #404b57;
    color: white;
    padding: 7px;
    margin-left: 10px;
    cursor:pointer;
}

.crossBtn:hover {
    border: 2px solid #FF5252;
    color: #FF5252 !important;
    animation: vibrate-1 0.3s linear infinite both;
}
/***************************************************** */
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

.btn-success, .btn-secondary, .btn-outline-secondary{
	font-family: 'Noto Sans KR', sans-serif;
	font-weight:500;
}
thead{
	font-family: 'Noto Sans KR', sans-serif;
	font-weight:700;
	border-top:1px solid #e1e1e1;
}
</style>

<script>

// 환자의 미수납 기록 가져오기
function ptRvmList(ptNum){
	$.ajax({
		url: '/hospital/document/ptRvmList?ptNum=' + ptNum ,
		type: "get" ,
		dataType:'json',
		success: function(res){
			//console.log(JSON.stringify(res));
			var ptRvmListTable = "";
			$.each(res, function(i, v){
				ptRvmListTable += '<tr>';
				ptRvmListTable += '	<td>' + v.rcvmtNum + '</td>';
				ptRvmListTable += '	<td>' + v.rcvmtAmt.toLocaleString() + '원</td>';
				ptRvmListTable += '	<td>' + v.rcvmtBalance.toLocaleString() + '원</td>';
				ptRvmListTable += '	<td>' + v.rcvmtGramt.toLocaleString() + '원</td>';
				ptRvmListTable += '	<td>' + formatDate(v.rcvmtDt) + '</td>';
				ptRvmListTable += "	<td>";
				ptRvmListTable += "		<input type='radio' name='wait' class='btn chooseRcvmt'/>";
				ptRvmListTable += "	</td>";
				ptRvmListTable += "</tr>";
			});
			$("#ptRcvmtInfo").html(ptRvmListTable);

		},
		error: function(err){
			console.log(err.status);
			simpleJustErrorAlert();
		}
	});
};
// 선택한 서류 정보
function choiceDocInfo(){
	var choiceDocInfoHtml = '';
	var docTotal = 0;
	$("#documentPrNm").find("tr").each(function(i, v){
		var tdInfo = $(this).find('td');
		var docNum = $(this).attr('id');
		var docNm = tdInfo.eq(0).text();
		var docCnt = tdInfo.find('input[type="number"]').val();
		var docPrice = tdInfo.eq(1).text();

		choiceDocInfoHtml += "<tr id=" + docNum + ">";
		choiceDocInfoHtml += "<td>" + docNum + "</td>";
		choiceDocInfoHtml += "<td>" + docNm + "</td>";
		choiceDocInfoHtml += "<td>" + docPrice + "</td>";
		choiceDocInfoHtml += "<td>" + docCnt + "</td>";

		var docPriceNumber = docPrice.replaceAll(",", "").split("원")[0] * docCnt;
		choiceDocInfoHtml += "<td>" + docPriceNumber.toLocaleString() + "원</td>";
		choiceDocInfoHtml += "<td>";
		choiceDocInfoHtml += "		<button type='button' class='close removeDoc'>";
		choiceDocInfoHtml += "			<span aria-hidden='true'>&times;</span>";
		choiceDocInfoHtml += "		</button>";
		choiceDocInfoHtml += "</td>";
		choiceDocInfoHtml += "</tr>";
		docTotal += parseInt(docPriceNumber);
	});

	$("#documentInfo").html(choiceDocInfoHtml);
};

function docAndCheckPrice(){
	var balance = $('input[name="wait"]:checked').parent().prev().prev().prev().text().replaceAll(",","");
	var total = 0;
	$("#documentInfo").find('tr').each(function(){
		total += parseInt($(this).find('td').eq(4).text().replaceAll(",",""));
	});
	if($('input[name="wait"]').is(':checked')){
		$("#totalPrice").text((parseInt(balance) + total).toLocaleString());
		docPayPriceChange();
	} else {
		$("#totalPrice").text((total).toLocaleString());
		docPayPriceChange();
	}
};

function docPayPriceChange(){
	$("#docPayPrice").val($("#totalPrice").text().replaceAll(",",""));
}

//미수납 내역 선택 시  css class;
$(document).on('click', '#ptRcvmtInfo tr', function(){
	if($(this).hasClass('ptRcvmtInfoSelected')){ // 이미 선택된 항목
		$(this).removeClass('ptRcvmtInfoSelected');
		$(this).css('background-color','');
		$(this).find('input[name="wait"]').prop("checked", false);
	} else { // 새로 선택된 항목
		// 이전 선택 제거
		$(".ptRcvmtInfoSelected").css('background-color','');
		$(".ptRcvmtInfoSelected").removeClass('ptRcvmtInfoSelected');

		$(this).addClass('ptRcvmtInfoSelected');
		$(this).css('background-color','#E2E2E2');
		$(this).find('input[name="wait"]').prop("checked", true);
	}
	docAndCheckPrice();
});

// 서류 결제 클릭 시 모달 창
function docPayment(){
// 	var ptNm = document.querySelector("#docPtInfo").value;
	var total = $("#totalDocPrice").text();
// 	var ptNum = ptNm.split("(")[1].split(")")[0];
	var ptNum = document.querySelector("#docPtInfo").value;

	if(ptNum == ''){
		simpleErrorAlert("환자를 검색해주세요")
		return false;
	}

	ptRvmList(ptNum);
	choiceDocInfo();

	if(total <= 0){
		simpleErrorAlert("서류를 선택해주세요");
		return false;
	}

	$("#totalPrice").text(total);

	$('#documentPayModal').modal('show');
};

// 모달 창에서 결제 항목 제거시 이벤트
$(document).on('click', '.removeDoc', function(){
	var DocInfo = $(this).parent().parent();
	var removeDocInfo = DocInfo.attr('id');
	$("#" + removeDocInfo).detach();

	var total = $("#totalPrice").text().replaceAll(",","");
	var removePrice = DocInfo.find('td').eq(4).text().replaceAll(",","");
	console.log(removePrice);
	$("#totalPrice").text((parseInt(total) - parseInt(removePrice)).toLocaleString());
	docPayPriceChange();
});

// 모달 창 내부 새 결제 목록 추가
function addDocument(){
	var docSelected = document.querySelector("#documentChoice");
	var docNum = docSelected.value;
	var docNm = docSelected.options[docSelected.selectedIndex].text;
	var docPrice = docSelected.options[docSelected.selectedIndex].dataset.price;
	var docBuy = document.querySelector("#docCunt");
	var docCnt = docBuy.value
	var sumPrice = docPrice * docCnt;

	var docInfoNum = 1;
	var lastInfoNum = $("#documentInfo").find('tr:last').find('td').eq(0).text();
	if(lastInfoNum != ''){
		docInfoNum += parseInt(lastInfoNum);
	}

	if(docSelected.value == ''){
		docSelected.style.border = '2px solid red';
		return false;
	}else {
		docSelected.style.border = '';
	}

	if(docCnt == ''){
		docBuy.style.border = '1px solid red';
		return false;
	} else {
		docBuy.style.border = '';
	}

	var appendDoc = "";
	appendDoc += "<tr id=" + docInfoNum + ">";
	appendDoc += "	<td id='" + docNum + "'>" + docInfoNum + "</td>";
	appendDoc += "	<td>" + docNm + "</td>";
	appendDoc += "	<td>" + docPrice + "</td>";
	appendDoc += "	<td>" + docCnt + "</td>";
	appendDoc += "	<td>" + sumPrice + "</td>";
	appendDoc += "	<td>";
	// appendDoc += "		<button type='button' class='btn-close removeDoc'></button>";
	appendDoc += "		<button type='button' class='close removeDoc'>";
	appendDoc += "			<span aria-hidden='true'>&times;</span>";
	appendDoc += "		</button>";
	appendDoc += "	</td>";
	appendDoc += "</tr>";

	Swal.fire({
		title: '서류 추가',
		text: docNm + '을(를) ' + docCnt + "매 추가하시겠습니까?",
		showDenyButton: true,
		confirmButtonText: '확인',
		denyButtonText: '취소',
	}).then(result => {
		if(result.isConfirmed){
			$("#documentInfo").append(appendDoc);
			// 합계 추가
			var total = $("#totalPrice").text();
			if(total == ''){
				$("#totalPrice").text(sumPrice);
				docPayPriceChange();
			}
			else {
				$("#totalPrice").text(parseInt(total) + sumPrice);
				docPayPriceChange();
			};

			docSelected.value = '';
			docBuy.value = '';
		} else if(result.isDenied){
			return false;
		}
	});

}

function checkUpDocRcvmt(docData, listUnpaid){
	var data = {
		'docData' : docData,
		'unpaid' : listUnpaid
	}
	console.log(JSON.stringify(data));
	$.ajax({
		url: '/hospital/document/checkUpDocRcvmt',
		type: "post",
		data: JSON.stringify(data),
		dataType: "text",
		beforeSend : function(xhr) {
			xhr.setRequestHeader('Content-Type', 'application/json;charset=utf-8');
	           xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
		},
		success: function(res){
			console.log(res);
			if(res == 'false'){
				simpleErrorAlert('결제 실패..');
				return false;
			}

			simpleSuccessAlert('결제가 완료되었습니다');
			$("#payClose").click();

			rctWindow(res);

		},
		error: function(err){
			console.log(err.status);
			simpleJustErrorAlert();
		}
	});
};

// 카드결제 api
function docPay(e){
	// 결제 총 금액
	var amount = $("#docPayPrice").val();
	if(amount == '' || amount == 0 || amount == null){
		simpleErrorAlert("결제 금액을 확인해주세요");
		return false;
	}

	// 환자 명
	var ptInfo = document.querySelector("#ptSearch").value.split("(");
	var ptNm = ptInfo[0];
	var ptNum = ptInfo[1].split(")")[0];

	var docData = new Array();
	var onlyDocPrice = 0;
	// 서류 발급 정보 데이터
    $("#documentInfo").find('tr').each(function(i, v){
     	var docInfo = $(this).find('td');
     	var docNum = docInfo.eq(0).text();
     	var docNm = docInfo.eq(1).text();
     	var docPrice = docInfo.eq(2).text().split("원")[0].replaceAll(",","");
     	var docCnt = docInfo.eq(3).text();
     	var docTotal = docInfo.eq(4).text().split("원")[0].replaceAll(",","");
     	var docInfoArr = {
	   		'docNum': docNum,
	   		'docNm': docNm,
	   		'docPrice': docPrice,
	   		'docCnt': docCnt,
	   		'docTotal': docTotal
     	}
     	onlyDocPrice += parseInt(docTotal);
     	docData[i] = docInfoArr;
    });

	var unpaid = '';
	// 선택 된 미수납 내역 정보
	if($('input[name="wait"]').is(':checked')){
		var waitChkInfo = $(".ptRcvmtInfoSelected").find('td');
		var rcvmtNum = waitChkInfo.eq(0).text();
		var rcvmtDscntAmt = waitChkInfo.eq(1).text().split("원")[0].replaceAll(",","");
		var rcvmtBalance = waitChkInfo.eq(2).text().split("원")[0].replaceAll(",","");
		var rcvmtGramt = waitChkInfo.eq(3).text().split("원")[0].replaceAll(",","");
		unpaid = {
			'checkPay': amount - onlyDocPrice, // 수납만!  결제 금액
			'docPay': onlyDocPrice, // 서류만! 결제 금액
			'ptNum': ptNum,
			'rcvmtNumOrign': rcvmtNum,
	   		'rcvmtDscntAmt': parseInt(rcvmtDscntAmt) + onlyDocPrice,	// 수납 금액
	   		'rcvmtBalance': rcvmtBalance, // 잔액
	   		'rcvmtGramt': parseInt(rcvmtGramt) + onlyDocPrice // 총 금액
		}
	} else {
		unpaid = {
			'total': amount,
			'ptNum': ptNum,
			'rcvmtNumOrign': '',
	   		'rcvmtDscntAmt': '',
	   		'rcvmtBalance': '',
	   		'rcvmtGramt': ''
		}
	}

	if(e.value == 'CASH'){
		Swal.fire({
			title: "현금 결제",
			text: "현금결제를 진행하시겠습니까?",
			showDenyButton: true,
			confirmButtonText: '확인',
			denyButtonText: '취소',
		}).then(result => {
			if(result.isConfirmed){
				var cardPaydata = {
					'rctPayOpt' : 'CASH',
					'rctAmt' : amount
				}
		        var listUnpaid = new Array();
			   	listUnpaid[0] = unpaid;
			   	listUnpaid[1] = cardPaydata;

			    // 수납 테이블(수납 update or 수납 insert)
				checkUpDocRcvmt(docData, listUnpaid);
			}
		});
	} else {
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
		    amount : 100, //결제 금액 : amount
		    buyer_name : ptNm,
		}, function(rsp) {
		    if ( rsp.success ) {
		        var msg = '결제가 완료되었습니다.';
		        msg += '고유ID : ' + rsp.imp_uid;
		        msg += '상점 거래ID : ' + rsp.merchant_uid;
		        msg += '결제 금액 : ' + rsp.paid_amount;
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

		        var cardPaydata = {
					'rctPayOpt' : 'CARD',
					'rctCardComp' : rctCardComp,
					'rctCardNum' : rctCardNum,
					'rctAcceptNum' : rctAcceptNum,
					'rctAmt' : amount
				}
		        var listUnpaid = new Array();
		    	listUnpaid[0] = unpaid;
		    	listUnpaid[1] = cardPaydata;

		        // 수납 테이블(수납 update or 수납 insert)
				checkUpDocRcvmt(docData, listUnpaid);
		    } else {
		        var msg = '결제에 실패하였습니다.\n';
		        msg += '에러내용 : ' + rsp.error_msg;
		        simpleErrorAlert(msg);
		    }
		    console.log(rsp);
		});
	}
}

// 모달 창 열릴 때 해당 환자의 미수납 내역 가져옴
$(document).on('show.bs.modal','#documentPayModal', function (e) {
	docAndCheckPrice();
});

// 모달 창 닫힐 때 이벤트(내부를 비움)
$(document).on('hidden.bs.modal','#documentPayModal', function (e) {
	document.querySelector("#documentChoice").value = '';
	document.querySelector("#docCunt").value = '';
	$('input[name="wait"]:checked').prop("checked", false);
	$('input[name="wait"]').prop("checked", false);

	console.log($('input[name="wait"]:checked'));
	console.log($('input[name="wait"]').is(":checked"));

	var checked = $('input[name="wait"]:checked').val();
	console.log(checked);

	$('input[name="wait"]').is(":checked")
	$("#documentInfo").html('');
	$("#totalPrice").text('');
	docPayPriceChange();
});

// 추가 이벤트
// 서류 리스트 목록 클릭 시 이벤트
$(document).on('click', '#issuedDocList tr', function(){
	var docNum = $(this).find('td').eq(0).text();
	if($(this).hasClass('docSelect')){ // 이미 선택된 항목
		$(this).removeClass('docSelect');
		$(this).css('background-color','');

		$("#documentPrNm").find('tr').each(function(){
			var removeDocNum = $(this).attr('id');
			if(removeDocNum == docNum){
				$("#" + removeDocNum).detach();
			}
		});
		totalPriceSum();
	} else { // 새로 선택된 항목
		$(this).addClass('docSelect');
		$(this).css('background-color','#E2E2E2');

		docNum = $(this).find('td').eq(0).text();
		var docPrice = $(this).find('td').eq(0).data('price');
		var docNm = $(this).find('td').eq(0).data('name');
		var docPrNm = '';
		docPrNm += '<tr id="' + docNum + '">';
		docPrNm += '	<td>' + docNm + '</td>';
		docPrNm += '	<td>' + docPrice.toLocaleString() + '원</td>';
		docPrNm += '	<td><input class="form docPrCnt" type="number" min="1" value="1" style="width:50px;"/></td>';
		docPrNm += '</tr>';

		$("#documentPrNm").append(docPrNm);
	}
});

// 모달창 총 합계 계산
function totalPriceSum(){
	var totalPrice = 0;
	$('.docPrCnt').each(function(){
		var cnt = $(this).val();
		var price = $(this).parent().prev().text().replaceAll(",","");
		totalPrice += parseInt(cnt) * parseInt(price);
	});
	$("#totalDocPrice").text(totalPrice.toLocaleString());
};

$(document).on('change', '.docPrCnt', function(){
	totalPriceSum();
});
$(document).on('click', '#docSearchlist', function(){
	totalPriceSum();
});

function docAlert(title, content){
	Swal.fire({
		title: '제목',
		text: '내용',
		showDenyButton: true,
		confirmButtonText: '확인',
		denyButtonText: '취소',
	}).then(result => {
		if(result.isConfirmed){

		} else if(result.isDenied){

		}
	});
};
// 날짜 포멧
function formatDate(date) {
    var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2)
        month = '0' + month;
    if (day.length < 2)
        day = '0' + day;

    return [year, month, day].join('-');
}


// 진단서 시연용 데이터 입력
function inputTestDiagnosisData(){

	$('#therapycon').val('레진 온레이 및 치주판막술');
	$('#occur').val('2023-04-13');
	$('#diagnosisDate').val('2023-04-13');
	$('#purpose').val('직장 제출');

}

// 원외처방전 시연용 데이터 입력
function inputTestOutsideData(){

	$('#year6').val('2023-04-13');
	$('#purpose6').val('직장 제출');

}

</script>

<sec:authentication var="empInfo" property='principal.empVO' />
<div class="content-wrapper" style="background-color: rgb(101, 125, 150); min-height: 1033px;">

<nav class="navbar navbar-expand navbar-white navbar-light" style="background-color: #404b57;">

		<div class="dropdown">
			<input type="text" class="form-control" id="ptSearch" name="ptSearch" placeholder="환자 검색" onkeyup="searchPatient(this);" style="width: 400px; display:inline-block;" autocomplete="off" />
			<ul id="ptSearchDropdown" class="dropdown-menu">
			</ul>
			<i class="fa-solid fa-xmark crossBtn" onclick="reset();"></i>
		</div>
		<ul class="navbar-nav ml-auto"></ul>
<!-- 		<div class="docMenu d-flex justify-content-around" style="width: 10%; min-width: 100px;"> -->
<!-- 			<a href="#" onclick="docPayment();" >서류 결제</a> -->
<!-- 		</div> -->
	</nav>

<!-- Modal -->
<div class="modal fade" id="documentPayModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content" style="border-radius: 30px;" >
      <div class="modal-header" style="border-bottom: 3px solid #FF5252;width: 90%;margin-left: 5%;">
        <h5 class="modal-title fs-5" id="staticBackdropLabel">서류 결제</h5>
<!--         <button type="button" data-dismiss="modal" aria-label="Close">&times;</button> -->
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
		          <span aria-hidden="true">&times;</span>
		</button>
      </div>
      <div class="modal-body" style="padding: 40px 40px;">
        <div class="card" >
        	<div class="card-body">
        		<div style="display:none;">
	        		<div class="d-flex justify-content-between align-items-center" >
	        			<div class="d-flex justify-content-center align-items-center">
				        	<select class="form-control" id="documentChoice">
				        		<option value="" selected>서류를 선택해주세요</option>
				        		<option value="1" data-price="10000">진단서</option>
				        		<option value="2" data-price="10000">소견서</option>
				        		<option value="3" data-price="3000">치료확인서</option>
				        		<option value="4" data-price="50000">향후 치료비 추정서</option>
				        		<option value="5" data-price="500">CT판독소견서</option>
				        		<option value="6" data-price="10000">원외처방전</option>
				        	</select>
				        	<input class="form-control ml-2 text-right" type="number" id="docCunt" min="0" placeholder="매수를 선택해주세요" />
				        	<input type="hidden" id="docPtInfo" />
	        			</div>
			        	<button type="button" class="btn btn-info" onclick="addDocument();">서류 추가</button>
	        		</div>
        		</div>
	        	<div class="d-flex justify-content-center align-items-center">
	        		<label style="font-size:1.25rem;border-bottom: 2px solid #FF5252;">미수납 목록</label>
	        	</div>
				<table class="table table-hover text-center">
					<thead>
						<tr>
							<th style="width:25%">수납 번호</th>
							<th style="width:15%">수납 금액</th>
							<th style="width:15%">잔액</th>
							<th style="width:15%">총액</th>
							<th style="width:25%">수납 일시</th>
							<th style="width:8%"></th>
						</tr>
					</thead>
					<tbody id="ptRcvmtInfo">
					</tbody>
				</table>
				<hr />
				<div class="d-flex justify-content-center align-items-center">
					<label style="font-size:1.25rem;border-bottom: 2px solid #FF5252;">발급 희망 서류 내역</label>
				</div>
				<table class="table table-hover text-center">
					<thead>
						<tr>
							<th style="width:25%">발급번호</th>
							<th style="width:25%">서류명</th>
							<th style="width:15%">서류 가격</th>
							<th style="width:10%">매수</th>
							<th style="width:15%">합계</th>
							<th style="width:8%"></th>
						</tr>
					</thead>
					<tbody id="documentInfo">
					</tbody>
				</table>
	        	<hr />
	        	<div class="d-flex justify-content-between align-items-center">
		        	<h3>
		        		<label>총 금액:</label><span id="totalPrice">0</span>원
		        	</h3>
		        	<h3>
		        		<label>결제금액:</label><input type="number" id="docPayPrice" style="width:200px;"/>
		        	</h3>
	        	</div>
        	</div>
        </div>
      </div>
      <div class="modal-footer" style="border-top: none; font-family: 'Noto Sans KR', sans-serif; font-weight: 500; margin: auto;">
        <button type="button" class="btn btn-success" style="width: 100px; border: none;" value="CASH" onclick="docPay(this);">현금결제</button>
        <button type="button" class="btn btn-danger redBtn" style="width: 100px; border: none;" value="CARD" onclick="docPay(this);">카드결제</button>
        <button type="button" class="btn btn-outline-secondary" style="width: 100px; border: none;" data-dismiss="modal" id="payClose">닫기</button>
      </div>
    </div>
  </div>
</div>
<!-- /Modal -->


<section class="content" style="margin-top: 1%;">
<!-- sidebar 시작 -->
<div class="row">
<div class="col-2" style="font-family: 'Noto Sans KR', sans-serif; font-weight:700;">
<button type="button" class="btn btn-block btn-secondary btn-lg docBtn" id="docSearch" name="docSearch" style="height: 80px; background-color:white; border:none; color:rgb(64, 75, 87);">서류 검색</button>
<button type="button" class="btn btn-block btn-secondary btn-lg docBtn" id="diagnosis" name="diagnosis" style="height: 80px; background-color:#404b57; border:none;">진단서</button>
<button type="button" class="btn btn-block btn-secondary btn-lg docBtn" id="opinion" name="opinion" style="height: 80px; background-color:#404b57; border:none;">소견서</button>
<button type="button" class="btn btn-block btn-secondary btn-lg docBtn" id="confirm" name="confirm" style="height: 80px; background-color:#404b57; border:none;">치료확인서</button>
<button type="button" class="btn btn-block btn-secondary btn-lg docBtn" id="treatment" name="treatment" style="height: 80px; background-color:#404b57; border:none;">향후 치료비 추정서</button>
<button type="button" class="btn btn-block btn-secondary btn-lg docBtn" id="CT" name="CT" style="height: 80px; background-color:#404b57; border:none;">CT판독소견서</button>
<button type="button" class="btn btn-block btn-secondary btn-lg docBtn" id="outside" name="outside" style="height: 80px; background-color:#404b57; border:none;">원외처방전</button>
</div>
<!-- sidebar 끝-->

<!-- 서류 검색 탭 시작 -->
<div class="col-sm-7" id="Searchlist">
	<div class="card">
		<div class="card-header" style="background-color:#404b57;">
			<h3 class="card-title" style="color:white;">서류 검색</h3>
		</div>
		<div class="card-body" style="font-family: 'Noto Sans KR', sans-serif; font-weight:700;">
			<div class="row">
				<div class="col-sm-4">
			    	<label for="docStartDt" style="font-size:1.2rem;">날짜</label>
			    	<br />
			    	<input type="date" id="docStartDt" pattern="yyyy-MM-dd">~<input type="date" id="docFinalDt">
			    	<!-- date타입은 String타입으로 넘어간다. 따라서 VO에 String 타입으로 받아줘야함 -->
		    	</div>
		    	<div class="col-sm-6">
					<label for="docNum1" style="font-size:1.2rem;">서류 종류</label>
					<br />

					<label><input type="checkbox" id="docNum1" name="docNum" value="1"> 진단서</label>
				    <label><input type="checkbox" id="docNum2" name="docNum" value="2"> 소견서</label>
				    <label><input type="checkbox" id="docNum3" name="docNum" value="3"> 치료확인서</label><br>
				    <label><input type="checkbox" id="docNum4" name="docNum" value="4"> 향후 치료비 추정서</label>
				    <label><input type="checkbox" id="docNum5" name="docNum" value="5"> CT판독소견서</label>
				    <label><input type="checkbox" id="docNum6" name="docNum" value="6"> 원외처방전</label>
				</div>
				<div class="col-sm-2">
					<button type="button" id="detailSearch" name="detailSearch" class="btn btn-primary searchBtn violetBtn">상세 검색</button>
				</div>
			</div>
		</div>
	</div>

	<div id="docSearchform">
        <form action="/hospital/document/document" method="post" id="frm" name="frm">
         	<div class="card">
	           	<div class="card-header" style="background-color:#404b57;">
	              <h3 class="card-title" style="color:white;">리스트 목록</h3>
				</div>
				<div class="card-body" >
					<table class="table table-bordered">
						<colgroup>
							<col width="15%">
<%-- 							<col width="15%"> --%>
							<col width="8%">
							<col width="15%">
							<col width="10%">
							<col width="15%">
						</colgroup>
						<thead style="text-align:center; font-family: 'Noto Sans KR', sans-serif; font-weight:700;">
							<tr>
								<th class="p-3" style="width: 20%;">발급번호</th>
<!-- 								<th class="p-3">차트번호</th> -->
								<th class="p-3" style="width: 18%;">서류명</th>
								<th class="p-3" style="width: 16%;">발급사유</th>
								<th class="p-3" style="width: 20%;">발급일시</th>
								<th class="p-3" style="width: 18%;">진료번호</th>
								<th class="p-3" style="width: 8%;">보기</th>
							</tr>
						</thead>
					</table>
					<div style="overflow: scroll;overflow-x: hidden; height: 600px;" class="listScroll">
					<table class="table table-bordered table-hover text-center" id="issuedDocList">
							<col width="20%">
<%-- 							<col width="15%"> --%>
							<col width="18%">
							<col width="16%">
							<col width="20%">
							<col width="18%">
							<col width="8%">
						<tbody id="docSearchlist" style= "font-family: 'Noto Sans KR', sans-serif; font-weight:500;">
							<!-- 리스트  -->
						</tbody>
					</table>
					</div>
				</div>
			</div>
		</form>
	</div>
</div>
<!-- 서류 검색 탭 끝 -->
<!-- 서류 결제 탭 시작 -->
<div class="col-sm-3" id="docPayDiv">
	<div class="card">
		<div class="card-header" style="background-color:#404b57;">
			<h3 class="card-title" style="color:white;">서류 결제</h3>
		</div>
		<div class="card-body" style="font-family: 'Noto Sans KR', sans-serif; font-weight:700; height:901px;">
			<div class="dataTables_wrapper dt-bootstrap4">
				<div class="mb-3 d-flex justify-content-between align-items-center">
					<div>총 금액 :
						<span id="totalDocPrice">0</span>원
					</div>
					<button type="button" class="btn btn-primary violetBtn"
						style="background-color: #904aff; border: none; width:100px; height: 100%;"
						onclick="docPayment();">서류 결제</button>
				</div>
				<table class="table table-hover text-center">
					<thead>
						<tr>
							<th style="width:100px;">서류명</th>
							<th style="width:100px">서류 가격</th>
							<th style="width:98px;">매수</th>
						</tr>
					</thead>
					<tbody id="documentPrNm">
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>
<!-- 서류 결제 탭 끝 -->


        <!-- 진단서 탭시작 -->
        <div class="col-sm-6" id="diagform" style="display: none;">
        <form action="/hospital/document/diagnosis" method="post" id="frm" name="frm">
          <div class="card">
            <div class="card-header" style="background-color:#404b57;">
              <h3 class="card-title" style="color:white;">진단서</h3>
            </div>
			<div class="card-body">
				<div class="form-group">
					<label>질병명</label>
 					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" id="disease" name="disease" readonly>
						<!-- modal 버튼 -->
						<button type="button" id="disButton" class="btn btn-secondary" data-toggle="modal" data-target="#modal-default">
						검색
						</button>
						<!-- modal -->
						<div class="modal fade" id="modal-default">
						<div class="modal-dialog modal-dialog-scrollable">
						<div class="modal-content" style="border-radius: 30px;">
						<div class="modal-header"  style="border-bottom: 2px solid #FF5252;margin-left: 5%;width: 90%;">
						<h5 class="modal-title">상병코드 및 병명</h5>
						</div>
						<div class="modal-body">

						<div class="dropdown">
							<input type="search" class="form-control" id="diskeyword" name="diskeyword" placeholder="상병코드 및 병명 입력" style="width: 300px;float:left;margin-bottom: 20px;">
						</div>
						<button type="button" class="btn btn-md btn-default" id="disListButton" name="disListButton" ><i class="fas fa-fw fa-search"></i></button>

							<div class="form-group">
								<table class="table table-bordered" style="margin-bottom:0px;">
								<colgroup>
									<col width="40%">
									<col width="60%">
								</colgroup>
									<thead style="text-align:center; font-family: 'Noto Sans KR', sans-serif; font-weight:700;">
										<tr>
											<th class="p-3">코드</th>
											<th class="p-3">병명</th>
										</tr>
									</thead>
								</table>
								<div style="overflow: scroll;overflow-x: hidden; height: 600px;" class="listScroll">
									<table class="table table-bordered table-hover">
										<colgroup>
											<col width="40%">
											<col width="60%">
										</colgroup>
										<tbody id="disList" style="font-family: 'Noto Sans KR', sans-serif; font-weight:500; text-align:center;">
										<!-- 리스트  -->
										</tbody>
									</table>
								</div>
							</div>
						</div>
						<!-- modal footer -->
						<div class="modal-footer justify-content-between" style="border-top:0px; margin:auto;">
						<button type="button" class="btn btn-outline-secondary" style="width:100px; border:none;" data-dismiss="modal">닫기</button>
						</div>
						<!-- modal footer 끝 -->
						</div>
						</div>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label>치료 내용</label>
					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" id="therapycon" name="therapycon">
					</div>
				</div>
				<div class="form-group">
					<label>발병연월일</label>
					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="date" class="form-control" id="occur" name="occur">
					</div>
				</div>
				<div class="form-group">
					<label>진단연월일</label>
					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="date" class="form-control" id="diagnosisDate" name="diagnosisDate">
					</div>
				</div>
				<div class="form-group">
					<label>용도</label>
 					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" id="purpose" name="purpose">
					</div>
				</div>
				<div class="form-group">
					<label>의사 면허번호</label>
					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" id="licenseNum" name="licenseNum" value="${empInfo.doctLn}" readonly>
					</div>
				</div>
				<div class="form-group">
					<label>의사 이름</label>
 					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" id="doctorName" name="doctorName" value="${empInfo.empNm}" readonly>
					</div>
				</div>
				<button type="button" class="btn btn-success" onclick="inputTestDiagnosisData();">시연용</button>
				<button type="button" class="btn btn-default violetBtn" id="diagformsend" name="diagformsend">발급</button>
				<input type='reset' class="btn btn-default redBtn" value='초기화'/>
				<button type="button" class="btn btn-success" id="disPreview" name="disPreview" style="float: right;" onclick="openPdfViewer(this);" data-data="" disabled>미리보기</button>
			</div>
            <div class="card-body table-responsive p-0" id="tabCard">
              <div id="example2_wrapper" class="dataTables_wrapper dt-bootstrap4">
                <div class="row">
                  <div class="col-sm-12">
                  </div>
                </div>
              </div>
            </div>
          </div>
          </form>
        </div>
        <!-- 진단서 작성 끝 -->

    <!-- 소견서 시작 -->
	<div class="col-sm-6" id="opinionform" style="display: none;">
        <form action="/hospital/document" method="post" id="frm" name="frm">
          <div class="card">
            <div class="card-header" style="background-color:#404b57;">
              <h3 class="card-title" style="color:white;">소견서</h3>
            </div>
			<div class="card-body">
				<div class="form-group">
					<label>진료소견</label>
					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" name="Clinicopinion5" id="Clinicopinion5">
					</div>
				</div>
				<div class="form-group">
					<label>용도</label>
					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" name="purpose5" id="purpose5">
					</div>
				</div>
				<div class="form-group">
					<label>발행일</label>
					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="date" class="form-control" name="publishDate5" id="publishDate5">
					</div>
				</div>
				<div class="form-group">
					<label>면허번호</label>
					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" name="licenseNum5" id="licenseNum5" value="${empInfo.doctLn}" readonly>
					</div>
				</div>
				<div class="form-group">
					<label>의사 이름</label>
 					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" name="doctorName5" id="doctorName5" value="${empInfo.empNm}" readonly>
					</div>
				</div>
				<button type="button" class="btn btn-default violetBtn" id="opinionsend" name="opinionsend">발급</button>
				<input type='reset' class="btn btn-default redBtn" value='초기화' />
				<button type="button" class="btn btn-success" id="opinionPreview" name="opinionPreview" style="float: right;" onclick="openPdfViewer(this);" data-data="" disabled>미리보기</button>
			</div>
            <div class="card-body table-responsive p-0" id="tabCard">
              <div id="example2_wrapper" class="dataTables_wrapper dt-bootstrap4">
                <div class="row">
                  <div class="col-sm-12">
                  </div>
                </div>
              </div>
            </div>
          </div>
	</form>
	</div>
   	<!-- 소견서 작성 끝 -->

   	 <!-- 향후 치료비 추정서 시작 -->
	<div class="col-sm-6" id="treatform" style="display: none;">
        <form action="/hospital/document" method="post" id="frm" name="frm">
          <div class="card">
            <div class="card-header" style="background-color:#404b57;">
              <h3 class="card-title" style="color:white;">향후 치료비 추정서</h3>
            </div>
			<div class="card-body">
				<div class="form-group">
					<label>질병명</label>
 					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" id="DiagnosisNum2" name="DiagnosisNum2" readonly>

						<!-- modal 버튼 -->
						<button type="button" id="disButton2" class="btn btn-secondary" data-toggle="modal" data-target="#modal-default2"> <!-- 여기 data-target이랑 같아야 함 -->
						검색
						</button>
						<!-- modal -->
						<div class="modal fade" id="modal-default2"> <!-- 여기 id값이랑 -->
						<div class="modal-dialog modal-dialog-scrollable">
						<div class="modal-content" style="border-radius: 30px;">
						<div class="modal-header"  style="border-bottom: 2px solid #FF5252;margin-left: 5%;width: 90%;">
						<h5 class="modal-title">상병코드 및 병명</h5>
						</div>
						<div class="modal-body">

						<div class="dropdown">
							<input type="search" class="form-control" id="diskeyword2" name="diskeyword2" placeholder="상병코드 및 병명 입력" style="width: 300px;float:left;margin-bottom: 20px;">
						</div>
						<button type="button" class="btn btn-md btn-default" id="disListButton2" name="disListButton2" ><i class="fas fa-fw fa-search"></i></button>

							<div class="form-group">
								<table class="table table-bordered" style="margin-bottom:0px;">
								<colgroup>
									<col width="40%">
									<col width="60%">
								</colgroup>
									<thead style="text-align:center; font-family: 'Noto Sans KR', sans-serif; font-weight:700;">
										<tr>
											<th class="p-3">코드</th>
											<th class="p-3">병명</th>
										</tr>
									</thead>
								</table>
								<div style="overflow: scroll;overflow-x: hidden; height: 600px;" class="listScroll">
									<table class="table table-bordered table-hover">
									<colgroup>
										<col width="40%">
										<col width="60%">
									</colgroup>
										<tbody id="disList2" style="font-family: 'Noto Sans KR', sans-serif; font-weight:500; text-align:center;">
										<!-- 리스트  -->
										</tbody>
									</table>
								</div>
							</div>
						</div>
						<!-- modal footer -->
						<div class="modal-footer justify-content-between" style="border-top:0px; margin:auto;">
						<button type="button" class="btn btn-outline-secondary" style="width:100px; border:none;" data-dismiss="modal">닫기</button>
						</div>
						</div>
						</div>
						</div>

					</div>
				</div>
				<div class="form-group">
					<label>치료내용</label>
					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" name="therapycon2" id="therapycon2">
					</div>
				</div>
				<div class="form-group">
					<label>치료기간</label>
					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="number" class="form-control"  name="therapyDate2" id="therapyDate2">
					</div>
				</div>
				<div class="form-group">
					<label>발행일</label>
					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="date" class="form-control" name="publishDate2" id="publishDate2">
					</div>
				</div>
				<div class="form-group">
					<label>용도</label>
 					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" id="purpose2" name="purpose2">
					</div>
				</div>
				<div class="form-group">
					<label>면허번호</label>
	 				<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" name="licenseNum2" id="licenseNum2" value="${empInfo.doctLn}" readonly>
					</div>
				</div>
				<div class="form-group">
					<label>의사 이름</label>
 					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" name="doctorName2" id="doctorName2" value="${empInfo.empNm}" readonly>
					</div>
				</div>
				<button type="button" class="btn btn-default violetBtn" id="treatformmsend" name="treatformmsend">발급</button>
				<input type='reset' class="btn btn-default redBtn" value='초기화' />
				<button type="button" class="btn btn-success" id="treatPreview" name="treatPreview" onclick="openPdfViewer(this);" style="float: right;" data-data="" disabled>미리보기</button>
			</div>
            <div class="card-body table-responsive p-0" id="tabCard">
              <div id="example2_wrapper" class="dataTables_wrapper dt-bootstrap4">
                <div class="row">
                  <div class="col-sm-12">
                  </div>
                </div>
              </div>
            </div>
          </div>
	</form>
	</div>
   	<!-- 향후 치료비 추정서 작성 끝 -->

   	 <!-- CT판독소견서 시작 -->
	<div class="col-sm-6" id="CTform" style="display: none;">
        <form action="/hospital/document" method="post" id="frm" name="frm">
          <div class="card">
            <div class="card-header" style="background-color:#404b57;">
              <h3 class="card-title" style="color:white;">CT판독소견서</h3>
            </div>
			<div class="card-body">
				<div class="form-group">
					<label>검사일자</label>
 					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="date" class="form-control" name="Exdate4" id="Exdate4">
					</div>
				</div>
				<div class="form-group">
					<label>용도</label>
 					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" id="purpose4" name="purpose4">
					</div>
				</div>
				<div class="form-group">
					<label>의사 이름</label>
					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" name="doctorname4" id="doctorname4" value="${empInfo.empNm}" readonly>
					</div>
				</div>
				<div class="form-group">
					<label>면허번호</label>
					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" name="licenseNum4" id="licenseNum4" value="${empInfo.doctLn}" readonly>
					</div>
				</div>
				<div class="form-group">
					<label>판독소견</label>
					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" name="Readingfind4" id="Readingfind4">
					</div>
				</div>
				<div class="form-group">
					<label>결론</label>
 					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" name="conclusion4" id="conclusion4">
					</div>
				</div>
				<div class="form-group">
					<label>판독일자</label>
 					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="date" class="form-control" name="readingdate4" id="readingdate4">
				</div>
				</div>
				<button type="button" class="btn btn-default violetBtn" id="CTsend" name="CTsend">발급</button>
				<input type='reset' class="btn btn-default redBtn" value='초기화' />
				<button type="button" class="btn btn-success" id="CTPreview" name="CTPreview" onclick="openPdfViewer(this);" style="float: right;" data-data="" disabled>미리보기</button>
			</div>
            <div class="card-body table-responsive p-0" id="tabCard">
              <div id="example2_wrapper" class="dataTables_wrapper dt-bootstrap4">
                <div class="row">
                  <div class="col-sm-12">
                  </div>
                </div>
              </div>
            </div>
          </div>
	</form>
	</div>
   	<!-- CT판독소견서 작성 끝 -->

   	<!-- 치료확인서 시작 -->
	<div class="col-sm-6" id="confirmform" style="display: none;">
        <form action="/hospital/document" method="post" id="frm" name="frm">
          <div class="card">
            <div class="card-header" style="background-color:#404b57;">
              <h3 class="card-title" style="color:white;">치료확인서</h3>
            </div>
			<div class="card-body">
				<div class="form-group">
					<label>질병명</label>
					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" id="disease3" name="disease3" readonly>

						<!-- modal 버튼 -->
						<button type="button" id="disButton3" class="btn btn-secondary" data-toggle="modal" data-target="#modal-default3"> <!-- 여기 data-target이랑 같아야 함 -->
						검색
						</button>
						<!-- modal -->
						<div class="modal fade" id="modal-default3"> <!-- 여기 id값이랑 -->
						<div class="modal-dialog modal-dialog-scrollable">
						<div class="modal-content" style="border-radius: 30px;">
						<div class="modal-header"  style="border-bottom: 2px solid #FF5252;margin-left: 5%;width: 90%;">
						<h4 class="modal-title">상병코드 및 병명</h4>
						</div>
						<div class="modal-body">

						<div class="dropdown">
							<input type="search" class="form-control" id="diskeyword3" name="diskeyword3" placeholder="상병코드 및 병명 입력" style="width: 300px;float:left;margin-bottom: 20px;">
						</div>
						<button type="button" class="btn btn-md btn-default" id="disListButton3" name="disListButton3" ><i class="fas fa-fw fa-search"></i></button>

							<div class="form-group">
								<table class="table table-bordered" style="margin-bottom:0px;">
								<colgroup>
									<col width="40%">
									<col width="60%">
								</colgroup>
									<thead style="text-align:center; font-family: 'Noto Sans KR', sans-serif; font-weight:700;">
										<tr>
											<th class="p-3">코드</th>
											<th class="p-3">병명</th>
										</tr>
									</thead>
								</table>
								<div style="overflow: scroll;overflow-x: hidden; height: 600px;" class="listScroll">
									<table class="table table-bordered table-hover">
									<colgroup>
										<col width="40%">
										<col width="60%">
									</colgroup>
									<tbody id="disList3" style="font-family: 'Noto Sans KR', sans-serif; font-weight:500; text-align:center;">
									<!-- 리스트  -->
								</tbody>
								</table>
								</div>
							</div>
						</div>
						<!-- modal footer -->
						<div class="modal-footer justify-content-between" style="border-top:0px; margin:auto;">
						<button type="button" class="btn btn-outline-secondary" style="width:100px; border:none;" data-dismiss="modal">닫기</button>
						</div>
						</div>
						</div>
						</div>
						<!-- modal footer 끝 -->

					</div>
				</div>
				<div class="form-group">
					<label>치료내용</label>
					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" id="therapycon3" name="therapycon3">
					</div>
				</div>
				<div class="form-group">
					<label>치료기간</label>
					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="number" class="form-control" id="therapyDate3" name="therapyDate3">
					</div>
				</div>
				<div class="form-group">
					<label>발행일</label>
 					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="date" class="form-control" name="publishDate3" id="publishDate3">
					</div>
				</div>
				<div class="form-group">
					<label>용도</label>
 					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" id="purpose3" name="purpose3">
					</div>
				</div>
				<div class="form-group">
					<label>면허번호</label>
	 				<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" name="licenseNum3" id="licenseNum3" value="${empInfo.doctLn}" readonly>
					</div>
				</div>
				<div class="form-group">
					<label>의사 이름</label>
	 				<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" name="doctorName3" id="doctorName3" value="${empInfo.empNm}" readonly>
					</div>
				</div>
				<button type="button" class="btn btn-default violetBtn" id="confirmformsend" name="confirmformsend">발급</button>
				<input type='reset' class="btn btn-default redBtn" value='초기화' />
				<button type="button" class="btn btn-success" id="confirmPreview" name="confirmPreview" onclick="openPdfViewer(this);" style="float: right;" data-data="" disabled>미리보기</button>
			</div>
            <div class="card-body table-responsive p-0" id="tabCard">
              <div id="example2_wrapper" class="dataTables_wrapper dt-bootstrap4">
                <div class="row">
                  <div class="col-sm-12">
                  </div>
                </div>
              </div>
            </div>
          </div>
	</form>
	</div>
   	<!-- 치료확인서 작성 끝 -->

   	<!-- 원외처방전 시작 -->
			<div class="col-sm-6" id="outsideform" style="display: none;">
				<form action="/hospital/document" method="post" id="frm" name="frm">
					<div class="card">
						<div class="card-header" style="background-color: #404b57;">
							<h3 class="card-title" style="color: white;">원외처방전</h3>
						</div>
						<div class="card-body">
							<div class="form-group">
								<label>교부연월일</label>
								<div class="input-group">
									<div class="input-group-prepend"></div>
									<input type="date" class="form-control" name="year6" id="year6" />
								</div>
							</div>
							<div class="form-group">
								<label>질병명</label>
								<div class="input-group">
									<div class="input-group-prepend"></div>
									<input type="text" class="form-control" name="disease6" id="disease6" readonly />

									<!-- modal 버튼 -->
									<button type="button" id="disButton4" class="btn btn-secondary" data-toggle="modal" data-target="#modal-default4">
										<!-- 여기 data-target이랑 같아야 함 -->
										검색
									</button>
									<!-- modal -->
									<div class="modal fade" id="modal-default4">
										<!-- 여기 id값이랑 -->
										<div class="modal-dialog modal-dialog-scrollable">
											<div class="modal-content" style="border-radius: 30px;">
												<div class="modal-header"  style="border-bottom: 2px solid #FF5252;margin-left: 5%;width: 90%;">
													<h4 class="modal-title">상병코드 및 병명</h4>
												</div>
												<div class="modal-body listScroll">

													<div class="dropdown">
														<input type="search" class="form-control" id="diskeyword4" name="diskeyword4" placeholder="상병코드 및 병명 입력" style="width: 300px; float: left; margin-bottom: 20px;">
													</div>
													<button type="button" class="btn btn-md btn-default" id="disListButton4" name="disListButton4">
														<i class="fas fa-fw fa-search"></i>
													</button>
													<div class="form-group">
														<table class="table table-bordered table-hover" style="margin-bottom: 0px;">
															<colgroup>
																<col width="40%">
																<col width="60%">
															</colgroup>
															<thead style="text-align: center; font-family: 'Noto Sans KR', sans-serif; font-weight: 700;">
																<tr>
																	<th class="p-3">코드</th>
																	<th class="p-3">병명</th>
																</tr>
															</thead>
																<tbody id="disList4" style="font-family: 'Noto Sans KR', sans-serif; font-weight: 500; text-align: center;">
																</tbody>
														</table>
													</div>
												</div>
												<!-- modal footer -->
												<div class="modal-footer justify-content-between" style="border-top:0px; margin:auto;">
													<button type="button" class="btn btn-outline-secondary" style="width:100px; border:none;" data-dismiss="modal">닫기</button>
												</div>
											</div>
										</div>
									</div>
									<!-- modal footer 끝 -->

								</div>
							</div>
							<div class="form-group">
								<label>용도</label>
								<div class="input-group">
									<div class="input-group-prepend"></div>
									<input type="text" class="form-control" id="purpose6" name="purpose6" />
								</div>
							</div>
							<div class="form-group">
								<label>면허번호</label>
								<div class="input-group">
									<div class="input-group-prepend"></div>
									<input type="text" class="form-control" name="licenseNum6" id="licenseNum6" value="${empInfo.doctLn}" readonly />
								</div>
							</div>
							<div class="form-group">
								<label>의사 이름</label>
								<div class="input-group">
									<div class="input-group-prepend"></div>
									<input type="text" class="form-control" name="doctorName6" id="doctorName6" value="${empInfo.empNm}" readonly />
								</div>
							</div>
							<!-- modal -->
							<div class="modal fade" id="modal-default5">
								<div class="modal-dialog modal-lg modal-dialog-scrollable">
									<div class="modal-content" style="border-radius: 30px;">
											<div class="modal-header"  style="border-bottom: 2px solid #FF5252;margin-left: 5%;width: 90%;">
											<h4 class="modal-title">약품코드 및 약품명</h4>
										</div>
										<div class="modal-body listScroll" style="padding:40px 40px;">
											<p style="color: red;">약품 선택 후 등록버튼을 누르셔야 합니다</p>

											<div class="dropdown">
												<input type="search" class="form-control" id="mediSearch" name="mediSearch" placeholder="처방 의약품 검색" style="width: 300px; float: left; margin-bottom: 20px;">
											</div>
											<button type="button" class="btn btn-md btn-default" id="mediSearchBtn" name="mediSearchBtn">
												<i class="fas fa-fw fa-search"></i>
											</button>

											<div class="form-group">
												<table class="table table-bordered table-hover" style="margin-bottom: 0px;">
													<colgroup>
														<col width="40%">
														<col width="60%">
													</colgroup>
													<thead style="text-align: center; font-family: 'Noto Sans KR', sans-serif; font-weight: 700;">
														<tr>
															<th class="p-3">코드</th>
															<th class="p-3">약품명</th>
														</tr>
													</thead>
													<tbody id="drugList" style="font-family: 'Noto Sans KR', sans-serif; font-weight: 500; text-align: center; table-layout: fixed;">
												</table>
												<div style="overflow: scroll; overflow-x: hidden;" class="listScroll">
													<table class="table table-bordered">
														<colgroup>
															<col width="40%">
															<col width="60%">
														</colgroup>
															<!-- 리스트  -->
														</tbody>
													</table>
												</div>
											</div>
										</div>
										<!-- modal footer -->
										<div class="modal-footer justify-content-between" style="border-top:0px; margin:auto;">
											<button type="button" class="btn btn-outline-secondary" style="width:100px; border:none;" data-dismiss="modal">닫기</button>
										</div>
									</div>
								</div>
							</div>
						<!-- modal footer 끝 -->

						<table class="table table-bordered" style="overflow-x: scroll;">
							<thead style="text-align: center; font-family: 'Noto Sans KR', sans-serif; font-weight: 700;">
								<tr>
									<th class="p-1" style="width: 40%; margin-bottom: 5%">처방의약품</th>
									<th class="p-1" style="width: 20%;">1회<br />투여량
									</th>
									<th class="p-1" style="width: 20%;">1회<br />투여횟수
									</th>
									<th class="p-1" style="width: 20%;">1회<br />투약일수
									</th>
								</tr>
							</thead>
							<tbody style="font-family: 'Noto Sans KR', sans-serif; font-weight: 500; text-align: center;" id="medi">
							</tbody>
						</table>

						<br />
						<!-- modal 버튼 -->
						<button type="button" id="mediBtn" class="btn btn-primary btnCss violetBtn" data-toggle="modal" data-target="#modal-default5">
							<!-- 여기 data-target이랑 같아야 함 -->
							약품 검색
						</button>
						<button type="button" class="btn btn-md btn-danger btnCss redBtn" id="drugClick" name="drugClick">등록</button>
						<p style="font-family: 'Noto Sans KR', sans-serif; font-weight: 500; color: red;">등록버튼을 누를 시 약품 선택 및 수정이 불가합니다</p>

						<div class="form-group">
							<div class="input-group">
								<div class="input-group-prepend">
									<p style="font-family: 'Noto Sans KR', sans-serif; margin-top: 10px;"><input type="number" class="form-control" name="date6" id="date6" style="width:100px;float:left;"/>&nbsp;일간</p>
								</div>
							</div>
						</div>
						<button type="button" class="btn btn-success" onclick="inputTestOutsideData();">시연용</button>
						<button type="button" class="btn btn-default violetBtn" id="outsidesend" name="outsidesend" disabled>발급</button>
						<input type='reset' class="btn btn-default redBtn" value='초기화' id="reset" />
						<button type="button" class="btn btn-success" id="outSidePreview" name="outSidePreview" onclick="openPdfViewer(this);" style="float: right;" data-data="" disabled>미리보기</button>
					</div>
					<div class="card-body table-responsive p-0" id="tabCard">
						<div id="example2_wrapper" class="dataTables_wrapper dt-bootstrap4"></div>
					</div>
				</div>
			</form>
		</div>
		<!-- 원외처방전 작성 끝 -->

        <!-- 환자 정보 시작 -->
        <div class="col-sm-4" id="patientInfo" style="display: none;">
          <div class="card">
            <div class="card-header" style="background-color:#404b57;">
             <h3 class="card-title" style="color:white;">환자 정보</h3>
            </div>
            <div class="card-body">
          		<div class="form-group">
					<label>환자 이름</label>
					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" id="name7" name="name7" readonly>
					</div>
				</div>
				<div class="form-group">
					<label>성별</label>
					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" id="ptGen" name="ptGen" readonly>
					</div>
				</div>
          		<div class="form-group">
					<label>차트번호</label>
					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" id="chartNum7" name="chartNum7" readonly>
					</div>
				</div>
          		<div class="form-group">
					<label>주민등록번호</label>
					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" id="citizenNum7" name="citizenNum7" readonly>
					</div>
				</div>
          		<div class="form-group">
					<label>생년월일</label>
					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" id="birth7" name="birth7" readonly>
					</div>
				</div>
          		<div class="form-group">
					<label>나이</label>
					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="number" class="form-control" id="age7" name="age7" readonly>
					</div>
				</div>
          		<div class="form-group">
					<label>주소</label>
					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" id="addr7" name="addr7" readonly>
					</div>
				</div>
          		<div class="form-group">
					<label>전화번호</label>
					<div class="input-group">
						<div class="input-group-prepend"></div>
						<input type="text" class="form-control" id="tel7" name="tel7" readonly>
					</div>
				</div>
          		<div class="form-group">
					<label>진료 번호</label>
					<div class="input-group">
						<div class="input-group-prepend"></div>
						<select id="ptChkSelect" name="ptChkSelect" class="form-control" onchange="getSelect()">
						</select>
					</div>
				</div>
				</div>
				</div>
				<!-- 환자 정보 끝 -->
				<!-- 병원 정보 시작 -->
				<div class="card">
            		<div class="card-header" style="background-color:#404b57;">
            		<h3 class="card-title" style="color:white;">병.의원 정보</h3>
           		 	</div>
          			<div class="card-body">
          			<div class="form-group">
						<label>사업자 등록번호</label>
							<div class="input-group">
								<div class="input-group-prepend"></div>
								<input type="text" class="form-control" id="num8" name="num8" readonly>
							</div>
					</div>
					<div class="form-group">
						<label>병.의원명</label>
							<div class="input-group">
								<div class="input-group-prepend"></div>
								<input type="text" class="form-control" id="name8" name="name8" readonly>
							</div>
					</div>
					<div class="form-group">
						<label>주소</label>
						<div class="input-group">
							<div class="input-group-prepend"></div>
							<input type="text" class="form-control" id="addr8" name="addr8" readonly>
						</div>
					</div>
					<div class="form-group">
						<label>전화번호</label>
						<div class="input-group">
							<div class="input-group-prepend"></div>
							<input type="text" class="form-control" id="tel8" name="tel8" readonly>
						</div>
					</div>
					<div class="form-group">
						<label>이메일</label>
						<div class="input-group">
							<div class="input-group-prepend"></div>
							<input type="text" class="form-control" id="email8" name="email8" readonly>
						</div>
					</div>
					</div>
	            </div>
         </div>
        </div>
        <!-- 병원 정보 끝 -->

</section>
</div>

<script>
//검색창옆 crossBtn을 누르면 창이 초기화된다.
function reset(){
	var ptSearch = document.querySelector("#ptSearch");

	ptSearch.value = null;
}
</script>

<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
<script src="/resources/js/document.js"></script>
<script src="/resources/js/searchModule.js"></script>
<script src="/resources/js/alertModule.js"></script>
<script src="/resources/js/receiptIssue.js"></script>
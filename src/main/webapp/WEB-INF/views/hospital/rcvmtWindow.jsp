<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<html>
<head>

<!-- jquery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Bootstrap 4 -->
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js"></script>

<!-- AdminLTE 3 -->
<script src="https://cdn.jsdelivr.net/npm/admin-lte@3.1/dist/js/adminlte.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.1/dist/css/adminlte.min.css" />

<!-- icon setting - font awesome -->
<script src="https://kit.fontawesome.com/5f4aa574e8.js"></script>

<!-- font setting google font -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@500;700&display=swap" />

<!-- sweetalert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<title>결제 영수증</title>
<style type="text/css">

/* body { */
/*     width: 100%; */
/*     height: 100%; */
/*     margin: 0; */
/*     padding: 0; */
/*     background-color: #ddd; */
/* } */

/* * { */
/*     box-sizing: border-box; */
/*     -moz-box-sizing: border-box; */
/* } */

.paper {
    width: 210mm;
    min-height: 297mm;
    padding: 20mm; /* set contents area */
    margin: 10mm auto;
    border-radius: 5px;
    background: #fff;
    box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
}

.content {
    padding: 0;
    border: 1px #888 dotted;
    width: 210mm;
    height: 257mm;
}

 

@page {
    size: A4;
    margin: 0;
}

@media print {
     html, body {
         width: 210mm; 		
         height: 297mm;
         background: #fff;
     }
    .paper {
        margin: 0;
        border: initial;
        border-radius: initial;		
        width: initial;	
        min-height: initial;
        box-shadow: initial;
        background: initial;
        page-break-after: always;
    }
    
    #btn-rcvmt{
    	display : none;
    }
}
</style>

</head>
<body>
	<div class="container" style="padding:30px;">  
		<div class="col-sm-5 border p-4"> 
			<h4 class="text-end">
				<fmt:formatDate var="shortDate" pattern="yyyy-MM-dd" value="${ rctVO.rctIssueDt }" />  
				'<span id="ptNm">${ rctVO.ptNm }</span>'님의 <span id="rctIssueDtShort"><c:out value="${ shortDate }" /></span>일자
				<br> <span id="rctType"></span>영수증 입니다.
			</h4>
			<table cellpadding="0px" cellspacing="0" width="100%" border="0" style="margin-top: 20px; font-size: 17px; line-height: 22px; table-layout: auto; width: 100%; border: none;"> 
				<tbody>
					<tr>
						<td style="font-weight: normal; text-align: left; white-space: nowrap; padding: 18px 16px 18px 0; vertical-align: top; border-bottom: 1px solid rgba(0, 27, 55, 0.1)">구분</td>
						<td style="text-align: center; padding: 18px 0; border-bottom: 1px solid rgba(0, 27, 55, 0.1)">
							<strong><span id="rcvmtType">${ rctVO.rcvmtType }</span></strong>
						</td>
						<td style="font-weight: normal; text-align: left; white-space: nowrap; padding: 18px 32px 18px 0; vertical-align: top; border-bottom: 1px solid rgba(0, 27, 55, 0.1)">결제회차</td>
						<td style="text-align: center; padding: 18px 0; border-bottom: 1px solid rgba(0, 27, 55, 0.1)">
							<strong><span id="rcvmtRctSn">${ rctVO.rcvmtRctSn }</span></strong> 회차
						</td>
					</tr>
					<tr></tr>
					<tr>
						<td colspan="2" style="font-weight: normal; text-align: left; white-space: nowrap; padding: 18px 32px 18px 0; vertical-align: top; border-bottom: 1px solid rgba(0, 27, 55, 0.1)">결제금액</td>
						<td colspan="2" style="text-align: right; padding: 18px 0; border-bottom: 1px solid rgba(0, 27, 55, 0.1)">
								<strong><span id="rctAmt"><fmt:formatNumber value="${ rctVO.rctAmt }" pattern="#,###"></fmt:formatNumber></span>원</strong>
						</td>
					</tr>
					<tr></tr>
					<tr>
						<td colspan="2" style="font-weight: normal; text-align: left; white-space: nowrap; padding: 18px 32px 18px 0; vertical-align: top; border-bottom: 1px solid rgba(0, 27, 55, 0.1)">결제방식</td>
						<td colspan="2" style="text-align: right; padding: 18px 0; border-bottom: 1px solid rgba(0, 27, 55, 0.1)">
							<strong><span id="rctPayOpt">${ rctVO.rctPayOpt }</span></strong>
						</td>
					</tr>
					<tr></tr>
					<tr>
						<td colspan="2" style="font-weight: normal; text-align: left; white-space: nowrap; padding: 18px 32px 18px 0; vertical-align: top; border-bottom: 1px solid rgba(0, 27, 55, 0.1)">결제일시</td>
						<td colspan="2" style="text-align: right; padding: 18px 0; border-bottom: 1px solid rgba(0, 27, 55, 0.1)">
							<strong><span id="rctIssueDtStr">${ rctVO.rctIssueDtStr }</span></strong>
						</td>
					</tr>
					<tr></tr>
					<tr>
						<td colspan="2" style="font-weight: normal; text-align: left; white-space: nowrap; padding: 18px 32px 18px 0; vertical-align: top; border-bottom: 1px solid rgba(0, 27, 55, 0.1)">승인번호</td>
						<td colspan="2" style="text-align: right; padding: 18px 0; border-bottom: 1px solid rgba(0, 27, 55, 0.1)">
							<strong><span id="rctAcceptNum">${ rctVO.rctAcceptNum }</span></strong> 
						</td>
					</tr>
					<tr></tr>
					<tr>
						<td colspan="2" style="font-weight: normal; text-align: left; white-space: nowrap; padding: 18px 32px 18px 0; vertical-align: top; border-bottom: 1px solid rgba(0, 27, 55, 0.1)">카드사</td>
						<td colspan="2" style="text-align: right; padding: 18px 0; border-bottom: 1px solid rgba(0, 27, 55, 0.1)">
							<strong><span id="rctCardComp">${ rctVO.rctCardComp }</span></strong>
						</td>
					</tr>
					<tr></tr>
				</tbody>
			</table>
			<div class="mt-3 d-flex justify-content-end align-items-center">
				<h3 class="m-0"><span id="hiNm">${ rctVO.hiNm }</span></h3>
				<img src="/resources/images/stamp/stamp.png" alt="병원 직인" class="ms-3" style="max-width: 50px; max-height: 50px;">
			</div>
			<button class="btn btn-primary receiptPrintBtn mt-2" type="button" onclick="rcvmtPrint();" id="btn-rcvmt">영수증 출력</button>
		</div>
	</div>
	
	<div style="display:none;">
		<input type="text" value="" id="rctNum" />
	</div>
</body>
</html>

<script type="text/javascript">
// 결제 내역 조회에서 값을 가져와 넣는다.
// const rctHistFormData = new FormData(opener.document.rctHistForm);
// document.getElementById("rctNum").value = rctHistFormData.get('rctNum');

// console.log(rctNum);
// $(document).ready(function(){
	
	
// 	const rctNum = $("#rctNum").val();
// 	console.log("rctNumrctNum : " + rctNum);
	
// 	if(rctNum != ''){
// 		fetch('/hospital/rcvmt/selectRctHist?rctNum=' + rctNum)
// 		.then(res => res.json())
// 		.then(rcvmt => {
// 			//console.log(rcvmt);
// 			document.getElementById("ptNm").innerText = rcvmt.ptNm;	// 환자이름
// 			document.getElementById("rctIssueDtShort").innerText = rcvmt.rctIssueDtStr.split(" ")[0]; // 날짜 짧게
// 			document.getElementById("rcvmtType").innerText = rcvmt.rcvmtType;	// 날짜 구분
// 			document.getElementById("rcvmtRctSn").innerText = rcvmt.rcvmtRctSn;	// 순번
// 			document.getElementById("rctAmt").innerText = parseInt(rcvmt.rctAmt).toLocaleString();// 결제 금액
// 			document.getElementById("rctPayOpt").innerText = rcvmt.rctPayOpt	// 결제 구분
// 			document.getElementById("rctIssueDtStr").innerText = rcvmt.rctIssueDtStr// 날짜 길게 
// 			document.getElementById("rctCardComp").innerText = rcvmt.rctCardComp;	// 카드사
// 			document.getElementById("rctAcceptNum").innerText = rcvmt.rctAcceptNum;// 승인번호
// 			document.getElementById("hiNm").innerText = rcvmt.hiNm;	// 승인번호
// 		});
// 	}
// });

function rcvmtPrint(){
	window.print();
}
</script>




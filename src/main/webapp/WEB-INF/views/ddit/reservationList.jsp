<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<style>
/* 태그자체 css */
thead {
	position: sticky;
	top: 0px;
	background-color: whitesmoke;
	border-top: none !important;
	box-shadow: inset 0 -1.5px 0 #000000;
}

th {
	font-family: 'Noto Sans KR', sans-serif;
	text-align: center;
}

tbody {
	border-top: none !important;
}

td {
	font-family: 'Gothic A1', sans-serif;
	text-align: center;
}

/* 글씨체 css */
h4 {
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 700;
}

h5 {
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 700;
	line-height: 32px;
}

h6 {
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 500;
	font-size: 14px;
	margin-left: 50px;
}
/* scroll css */
.resvList::-webkit-scrollbar {
	display: none;
}

/* button css */
.resvBtn {
	background-color: #904aff;
	border: none;
	border-radius: 30px;
	display: flex;
	justify-content: center;
	align-items: center;
	margin: auto;
	width: 200px;
	height: 50px;
	font-family: 'Noto Sans KR', sans-serif;
	font-weight: 700;
}

.resvRow{
	cursor: pointer;
}
</style>
<!-- Head Image 시작 -->
<div class="boardHeadImage">
	<div class="wrapper">
		<div class="slide">
			<img src="/resources/images/layout/ddit/resvChkHeadImage.png" />
		</div>
	</div>
</div>
<!-- Head Image 끝 -->
<!-- main section 시작 -->
<section class="container">
	<!-- 내 예약조회 nav 시작 -->
	<div class="row" style="margin-left: 7%; margin-top: 50px; width: 85%; height: 100px; border-top: 1px solid gray; border-bottom: 1px solid gray;">
		<div class="col-12">
			<h4 style="margin-left: 50px; margin-top: 20px; font-family: 'Noto Sans KR', sans-serif; font-weight: 700;">내 예약조회</h4>
		</div>
		<div class="col-6">
			<h6 style="opacity: 0.5;">home > 예약 / 조회 > 내 예약조회</h6>
		</div>
	</div>
	<!-- 내 예약조회 nav 끝 -->
	<div class="row" style="margin-top: 30px; margin-bottom: 30px;">
		<!-- 예약목록 확인, 왼쪽 칸 시작 -->
		<div class="row mb-4">
			<div class="offset-xl-1 col-xl-5 px-3">
				<h4 class="m-0">'${requestScope.ptNm}'님의 예약내역입니다.</h4>
			</div>
		</div>
		<div class="row g-0">
			<div class="offset-xl-1 col-xl-5 p-3">
				<div class="p-0 resvList" style="border: 1px solid rgb(211, 211, 211); box-shadow: 5px 5px 12px 0px rgba(130, 130, 130, 0.72); border-radius: 20px; height: 600px; overflow-y: scroll;">
					<table class="table table-hover">
						<thead>
							<tr class="stickyTr">
								<th class="p-2 py-3" width="23%">예약일자</th>
								<th class="p-2 py-3" width="20%">예약시간</th>
								<th class="p-2 py-3" width="27%;">호소증상</th>
								<th class="p-2 py-3" width="22%">예약상태</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="presv" items="${requestScope.presvList}" varStatus="idx">
								<tr class="resvRow" data-resvnum="${presv.resvNum}">
									<td class="p-2 py-3">${fn:split(presv.resvSdt, ' ')[0]}</td>
									<td class="p-2 py-3">${fn:split(presv.resvSdt, ' ')[1]}</td>
									<td class="p-2 py-3">${presv.resvCc}</td>
									<td class="p-2 py-3 text-danger">${presv.resvStatus}</td>
								</tr>
							</c:forEach>
<!-- 							<tr class="selectTr"> -->
<!-- 								<td class="p-3">1</td> -->
<!-- 								<td class="p-3">2023-03-10</td> -->
<!-- 								<td class="p-3">17:30</td> -->
<!-- 								<td class="p-3">사랑니발치 후 피가 안멈춰요</td> -->
<!-- 								<td class="p-3 text-danger">예약중</td> -->
<!-- 							</tr> -->
						</tbody>
					</table>
				</div>
			</div>
			<!-- 예약목록 확인, 왼쪽 칸 끝 -->
			<div class="col-xl-5 p-3">
				<!-- 비어있는 오른쪽 칸 시작 -->
				<div id="emptyResvInfoCard" class="resvDetailCard d-flex justify-content-center align-items-center" style="border: 1px solid rgb(211, 211, 211); height: 600px; text-align: center; padding: 30px; border-radius: 30px; box-shadow: 5px 5px 12px 0px rgba(130, 130, 130, 0.72);">
					<h5 class="m-0">조회하실 예약을 선택해주세요.</h5>
				</div>
				<!-- 비어있는 오른쪽 칸 끝 -->
				<!-- 예약내용 확인, 오른쪽 칸 시작 -->
				<div id="resvInfoCard" class="resvDetailCard d-none" style="border: 1px solid rgb(211, 211, 211); height: 600px; text-align: center; padding: 30px; border-radius: 30px; box-shadow: 5px 5px 12px 0px rgba(130, 130, 130, 0.72);">
					<h5>
						'${requestScope.ptNm}'님의 예약은 <br />
						'<span id="resvSdt" style="color: #ff786e"></span>'입니다.
					</h5>
					<!-- 혹시 이미지 사이즈 안맞으면 style값줘서 width, height 맞춰주세요~ -->
					<img id="empImg" src="/resources/images/layout/ddit/dentist3.png" alt="의사이미지"
						 onerror="javascript:src='/resources/images/employee/doc_def_image.png';"
						 style="width: 180px; height: 240px;" />
					<h5 style="margin-top: 15px;">
						<span id="deptNm"></span>의 '<span style="color: #ff786e"><span id="empNm"></span> 선생님</span>'이<br /> 진료하실 예정입니다.
					</h5>

					<button class="btn btn-primary resvBtn" type="button" style="margin-top: 15px;" onclick="javascript:location.href='/ddit/info';">오시는 길 확인하기</button>
					<button id="resvCancelBtn" class="btn btn-danger resvBtn" type="button" style="margin-top: 5px; background-color: #dc3545; border: none;" onclick="cancelResvAlert();">예약 취소</button>
				</div>
				<!-- 예약내용 확인, 오른쪽 칸 끝 -->
			</div>
		</div>
	</div>

</section>

<!-- main section 끝 -->

<script>
// 예약 목록 선택 시 상세 예약 정보를 가져와 오른쪽 카드에 작성한다.
$(".resvRow").on("click",function(){
	//tr 클릭시 색변경
    $(".resvRow").css("background-color","white");
    $(this).css("background-color","#B4DFFF");

    const resvNum = $(this).data('resvnum');
    fetch('/ddit/resv/selectPresv?resvNum=' + resvNum)
    	.then(res => {
    		if(!res.ok) throw new Error();
    		return res.json();
    	})
    	.then(presv => {

    		$('#emptyResvInfoCard').addClass('d-none');
    		$('#resvInfoCard').removeClass('d-none');

    		$('#resvInfoCard').attr('data-resvnum', presv.resvNum);
    		$('#empImg').attr('src', '/resources/images/employee' + presv.empImg);
    		$('#deptNm').text(presv.deptNm);
    		$('#empNm').text(presv.empNm);
    		$('#resvSdt').text(presv.resvSdt);


    		if(presv.resvStatus != '예약중'){
    			$('#resvCancelBtn').prop('disabled', true);
    		} else {
	   			$('#resvCancelBtn').prop('disabled', false);
    		}

    	})
    	.catch(() => {
    		alert('잠시 후 다시 시도해주세요.');
    	});

});

// 예약 취소
function cancelResvAlert(){

	if(confirm('예약을 취소하시겠습니까?')){

		const resvNum = $('#resvInfoCard').data('resvnum');
		const csrfToken = $('#_csrfToken').val();
		fetch('/ddit/resv/cancelResv', {
			method: 'post',
			headers: {
				'X-CSRF-TOKEN' : csrfToken,
				'Content-Type' : 'application/json;charset=utf-8'
			},
			body: JSON.stringify({
				resvNum : resvNum
			})
		})
			.then(res => {
				if(!res.ok) throw new Error();
				return res.text();
			})
			.then(text => {
				if(text == 'FAILED') throw new Error();
				alert('예약이 취소되었습니다.');
				location.reload();
			})
			.catch(() => {
				alert('잠시 후 다시 시도해주세요.');
			});
	}

}

</script>
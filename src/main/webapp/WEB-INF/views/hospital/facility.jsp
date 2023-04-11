<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
/* chatCss */
#chatButton{
	padding-right:1.25rem;
}
.navbar-badge{
	top:5px;
}
/* **************************** */
.row .hospitalRow {
	margin: 20px;
}

.row .zip {
	margin-top: 10px;
	margin-left: 20px;
	margin-right: 20px;
}

body, input[type="button"] {
	font-family: bookman old style;
	font-size: 12pt;
}

table {
	border-collapse: collapse;
	margin: auto;
}

th, td {
	border: 1px solid indianred;
	padding: 6px;
}

input[type="text"] {
	border: 1px solid blue;
}

input[type="button"] {
	border: 2px solid indianred;
	background: antiquewhite;
	cursor: pointer;
	margin-top: 20px;
}

input[type="button"]:hover {
	background: indianred;
	color: antiquewhite;
}

.card-footer{
	background-color: white;
}
</style>



<script type="text/javascript">

// 체어관리- 체어 추가
function addRow() {

	  // 템플릿 가져오기
	  const template = document.querySelector('#rowTemplate');

	  // 추가할 테이블 가져오기
	  const tbl = document.querySelector('#myTable');

	  // 왼쪽 숫자 표시 설정
	  const td_slNo = template.content.querySelectorAll("td")[1];
	  const tr_count = tbl.rows.length;
	  td_slNo.textContent = tr_count;

	  // 템플릿의 content 속성과 그의 자식 모든 요소를 복사
	  const clone = template.content.cloneNode(true);

	  // 기존 테이블에 복사한 템플릿을 추가
	  tbl.appendChild(clone);


	  // 수정버튼 클릭 -> 저장모드 전환
	  // 	//spn1 : 가려짐 / spn2 : 보임
	 $("#spn1").hide();
	 $("#spn2").show();

}


// 체어관리- 체어 등록
function createRow(){

	  // 체크된 체크박스 값을 가져온다.
	  var checkbox = $("input[name=user_CheckBox]:checked");
	  console.log(checkbox);
	  var checkYn = $("#checkYn");
	  if(!checkYn.is(":checked")){
	    alert("추가할 항목에 체크하여주십시오.");
	  }

	  let tr = checkbox.parent().parent();
	  let td = tr.children();

	  // 배열 생성
	  var arr = [];

	  checkbox.each(function(i){
		  var a = {};

			var tr = checkbox.parent().parent().eq(i); // tr
			console.log("tr: " , tr);
			var td = tr.children(); // tr의 자식요소들

			// td.eq(0)은 체크박스 이므로 td.eq(1)의 값부터 가져온다.
			a.chairSn = td.eq(1).text();
			a.chairNm = td.eq(2).children().val();
			a.deptCd = td.eq(3).find("#chairSn").val();

			console.log("a : " + JSON.stringify(a));

			arr.push(a);
		});

			console.log("arr : ", arr);

			$.ajax({
				url : '/hospital/manage/hosInfo/createChair',
				type : 'post',
				data : JSON.stringify(arr),
				contentType: 'application/json;charset=utf-8',
				beforeSend: function(xhr){
					xhr.setRequestHeader('X-CSRF-TOKEN', '${_csrf.token}');
				},
				success : function(res){
					console.log("res : " + res);

					location.href= "/hospital/manage/hosInfo/";
				}
			});
}

//체어관리- 체어 삭제
function deleteRow(){

	  // 체크된 체크박스 값을 가져온다.
	  var checkbox = $("input[name=user_CheckBox]:checked");
	  console.log("checkbox : " ,checkbox);

	  let tr = checkbox.parent().parent();
	  let td = tr.children();

	  // 배열 생성
	  var arr = [];

	  checkbox.each(function(i){
		  var a = {};

			var tr = checkbox.parent().parent().eq(i); // tr
			console.log("tr: " , tr);
			var td = tr.children(); // tr의 자식요소들

			// td.eq(0)은 체크박스 이므로 td.eq(1)의 값부터 가져온다.
			a.chairSn = td.eq(1).text();
			a.chairNm = td.eq(2).children().val();
			a.deptCd = td.eq(3).find("#chairSn").val();

			console.log("a : " + JSON.stringify(a));

			arr.push(a);
		});

			console.log("arr : ", arr);

			$.ajax({
				url : '/hospital/manage/hosInfo/deleteChair',
				type : 'post',
				data : JSON.stringify(arr),
				contentType: 'application/json;charset=utf-8',
				beforeSend: function(xhr){
					xhr.setRequestHeader('X-CSRF-TOKEN', '${_csrf.token}');
				},
				success : function(res){
					console.log("res : " + res);
					location.href= "/hospital/manage/hosInfo/";
				}
			});
}


// 체어관리- 체어 수정
function updateRow(){

// 	var total_cnt=0;
// 	var tdArr = new Array();
	var checkbox = $("input[name=user_CheckBox]:checked");
	var arr = [];

	//체크된 체크박스 값을 가져온다.
	checkbox.each(function(i){

		var a = {};

		var tr = checkbox.parent().parent().eq(i); // tr
		var td = tr.children(); // tr의 자식요소들

		//체크된 row의 모든 값을 배열에 담는다.

		//td.eq(0)은 체크박스 이므로 td.eq(1)의 값부터 가져온다.
		a.chairSn = td.eq(1).text();
		a.chairNm = td.eq(2).find(".updateInput").val();
		a.deptCd = td.eq(3).find("#chairSn").val();

		console.log(a);
		arr.push(a); //객체를 배열안에 넣는다.

	});


		console.log("arr : ", arr);

		$.ajax({
			url : '/hospital/manage/hosInfo/updateChair',
			type : 'post',
			data : JSON.stringify(arr),
			contentType: 'application/json;charset=utf-8',
			beforeSend: function(xhr){
				xhr.setRequestHeader('X-CSRF-TOKEN', '${_csrf.token}');
			},
			success : function(res){
				console.log("res : " + res);

				checkbox.click();
			}
		});
}
</script>

<div class="content-wrapper" style="background-color: rgb(101, 125, 150); min-height: 1001px;">

	<!-- main 검색창을 포함한 navbar 시작-->
	<nav class="navbar navbar-expand navbar-white navbar-light"
		 style="background-color: #404b57;">
		<div class="dropdown">
			<input type="text" class="form-control" id="ptSearch"
				   placeholder="직원 검색" onkeyup="searchPatient(this);"
				   style="width: 400px;">
			<ul id="ptSearchDropdown" class="dropdown-menu">
		</div>
		<img src="/resources/images/memo_icon.png" alt="병원 로고" id="memo"
			 class="brand-image elevation-1" style="margin-left: 15px;">

		<div class="collapse navbar-collapse" id="navbarTogglerDemo03"
			 style="margin-left: 47%;">
			<ul class="navbar-nav me-auto mb-2 mb-lg-0">
				<li class="nav-item"><a class="nav-link active"
					aria-current="page" href="/hospital/manage/empInfo/" data-toggle="tab"
					style="color: white;">직원관리</a></li>
				<li class="nav-item"><a class="nav-link" href="/hospital/drug"
					style="color: white;">약품관리</a></li>
				<li class="nav-item"><a class="nav-link"
					href="/hospital/txCode" style="color: white;">처치 관리</a></li>
				<li class="nav-item"><a class="nav-link" href="/hospital/manage/hosInfo"
					style="color: white;">병원 기초정보관리</a></li>
				<li class="nav-item"><a class="nav-link" href="#"
					style="color: white;">병원 시설관리</a></li>
			</ul>
		</div>
	</nav>
	<!-- main 검색창을 포함한 navbar 끝 -->

	<div class="SaveRow">
		<input type="button" id="save"
			   style="float: right; margin-right: 15px;" value="병원정보 저장" />
		<input type="button" id="update"
			   style="float: right; margin-right: 15px;" value="병원정보 수정" />
	</div>

				<!-- 우측 하단 -->
				<div class="card card-info">

					<div class="card-header"
						style="background-color: #404b57; border: none;">
						<div class="d-flex justify-content-between align-items-center">
							<h4 class="card-title">체어 관리</h4>
						</div>
					</div>
					<!-- 					https://inpa.tistory.com/1093#datalist_%ED%83%9C%EA%B7%B8 -->
					<div class="card-body" style="height: 450px;">

						<form name="myTable" action="" method="post">
							<div class="card-body"
								style="max-height: 317px; overflow-y: auto;">
								<table class="table table-bordered chairTable" id="myTable">
									<thead>
										<tr>
											<th style="width: 10px">🛠</th>
											<th>No.</th>
											<!-- 자동생성 -->
											<th>체어명</th>
											<!-- 직접 입력 -->
											<th>부서</th>
											<!-- 직접 입력 -->
										</tr>
									</thead>
									<tbody>
										<c:forEach var="chair" items="${requestScope.chairList}"
											varStatus="stat">
											<tr class="trClassDelete">
												<td id="td1">
													<input type="checkbox" class="tdSelected"
														   name="user_CheckBox" id="checkYn" required /></td>
												<td id="td2">${chair.chairSn}</td>
												<td id="td3">
													<input type="text"
													data-chair="${chair.chairNm}" class="updateInput"
													value="${chair.chairNm}" style="border: none;" readonly /></td>
												<td id="td4">
													<select id="chairSn" name="chairSn"
													data-dept="${chair.deptCd}" disabled>
														<option value="">진료실 선택</option>
														<c:forEach var="dept" items="${requestScope.deptList}">
															<option value="${dept.deptCd}"
																<c:if test='${dept.deptCd == chair.deptCd}'>selected</c:if>>${dept.deptNm}</option>
														</c:forEach>
												</select></td>
											</tr>
										</c:forEach>
									</tbody>
								</table>




								<!-- 테이블에 추가할 테이블 내부 템플릿 -->
								<template id="rowTemplate">
									<tr class="trClassAdd">
										<td id="td1"><input type="checkbox" name="user_CheckBox" id="checkYn" required></td>
										<td id="td2"></td>
										<td id="td3"><input type="text" /></td>
										<td id="td4"><select id="chairSn" class="updateInput" name="chairSn">
												<option value="">진료실 선택</option>
												<c:forEach var="dept" items="${requestScope.deptList}">
													<option value="${dept.deptCd}"
														<c:if test='${deptCd == dept.deptCd}'>selected</c:if>>${dept.deptNm}</option>
												</c:forEach>
										</select></td>
									</tr>
								</template>

							</div>
						</form>
						<div class="card-footer">
						<!-- 일반모드 시작 -->

							<!-- 버튼 클릭하면 자바스크립트 실행 -->
							<input type="button" id="v" value="추가" onclick="addRow()" />
								<span id="spn1">
									<!-- 저장 클릭하면 자바스크립트 실행 -->
									<input type="button" id="updateChair" value="저장" onclick="updateRow()" />
								    <input type="button" id="deleteChair" value="삭제" onclick="deleteRow()" />
						        </span>
								<!-- 일반모드 끝 -->

								<!-- 수정모드 시작 -->
								<span id="spn2" style="display: none;">
									<input type="button" id="createChair" value="저장" onclick="createRow()">
									<input type="button" value="취소" id="cancelBtn" />
								</span>
								<!-- 수정모드 끝 -->
					</div>
					</div>
				</div>

</div>

<script type="text/javascript">
$(document).ready(function(){
	// 취소버튼 클릭시 일반모드로 전환
	$("#cancelBtn").on("click",function(){
		$("#spn1").show();
		$("#spn2").hide();

		$(".trClassAdd").remove();
	});	// 취소버튼 클릭이벤트 끝..

	$(document).on("change", ".tdSelected", function(){

		// 체크박스 활성화했을 시
		if($(this).is(":checked")){
			//alert("체크");

			//parents(해당 요소의 위에있는 부모들 중 <tr>요소를 찾고 찾은 <tr>요소의 자식 중 .updateInput 클래스이름을 가진 요소의 style을 변경 )
			//parent(해당 요소의 바로 위에있는 부모를 찾아 <tr>요소를 찾고 찾은 <tr>요소의 자식 중 .updateInput 클래스이름을 가진 요소의 style을 변경 )
			//children(해당 요소의 아래에 있는 자식들 중 <tr>요소를 찾고 찾은 <tr>요소의 자식 중 .updateInput 클래스이름을 가진 요소의 style을 변경)
			//child(해당 요소의 바로 아래에 있는 자식을 찾아 <tr>요소를 찾고 찾은 <tr>요소의 자식 중 .updateInput 클래스이름을 가진 요소의 style을 변경)

			$(this).parent().next().next().find(".updateInput").prop("readonly", false); //체어명
			$(this).parent().next().next().find(".updateInput").css("border", "1px solid blue"); //체어명 작성란 테두리
			$(this).parent().parent().find("#chairSn").prop("disabled", false); //부서 선택란 작성가능 처리



		}else{
			//alert("체크해제");
// 			$("#chairSn").prop("disabled", true);
// 			$(".updateInput").attr("readonly", true);
			$(this).parent().next().next().find(".updateInput").prop("readonly", true);
			$(this).parent().next().next().find(".updateInput").css("border", "none");
			$(this).parent().parent().find("#chairSn").prop("disabled", true);
		}
	})
});
</script>

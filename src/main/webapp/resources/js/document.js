
$('input[type="date"]').attr('max', '9999-12-31');

//원외처방전 reset 버튼 table tr 초기화
$("#reset").on("click",function(){
	$("#medi > tr").remove();

	if($("#mediBtn").attr("disabled")){
		$("#mediBtn").attr("disabled",false);
		$("#outsidesend").attr("disabled",true);
		$("#preview").attr("disabled",true);
		$("#drugClick").attr("disabled",false);
	}
});

//전역변수로 처리
let drugVOList = [];
let drugNmList = [];

//원외처방전 처방 의약품 리스트에서 등록 버튼을 누르면 배열로 되는거
$("#drugClick").on("click",function(){

	drugVOList = [];

	let tr = "";	//tr
	let td = "";		//tr안에 있는 td가 4개가 있음
	let drugNm = "";	//<input type="text"..
	let dosage = "";
	let doses = "";
	let dosesdate = "";

		//하나의 tbody안에는 현재 3개의 tr이 존재. 3회 반복
	$("#medi tr").each(function(index){
		tr = $(this);	//tr --> this는 "#medi tr"를 말하는 것, 전역변수를 선언하면 this가 #drugClick을 말하는 것이 되니까 아예 값이 안 나옴-->위에 선언만 해줘야 함
		td = tr.children();		//tr안에 있는 td가 4개가 있음
		drugNm = td.eq(0).children().val();	//<input type="text"..
		dosage = td.eq(1).children().val();
		doses = td.eq(2).children().val();
		dosesdate = td.eq(3).children().val();

		const drugNum = tr.data('drugnum');

		let jsonData = {"drugNum":drugNum, "drugNm":drugNm,"dosage":dosage,"doses":doses,"dosesdate":dosesdate};

		drugVOList.push(jsonData);

	});


	if($(".drugNm").length<1){
		simpleErrorAlert("약품을 추가해주세요");
		return false;
	}


	if(dosage == "" || doses == "" || dosesdate == ""){
		simpleErrorAlert("모든 정보를 입력해주셔야 합니다");
		return false;
	}

	if(dosage<=0 || doses<=0||dosesdate<=0) {
		simpleErrorAlert("0 또는 음수는 등록할 수 없습니다");
		return false;
	}

	$("#drugClick").attr("disabled",true);

	$("#outsidesend").attr("disabled",false);
	$("#mediBtn").attr("disabled",true);
	$(".dosage").attr("readonly",true);
	$(".doses").attr("readonly",true);
	$(".dosesdate").attr("readonly",true);

});

//원외처방전 약품 모달창에서 검색하면 리스트 뜸
$("#mediSearchBtn").on("click", function(event){ //모달창안의 버튼은 document 필수

	let keyword = $("#mediSearch").val();

	var url = 'http://apis.data.go.kr/1471000/DrugPrdtPrmsnInfoService03' + '/getDrugPrdtPrmsnInq03'; /*URL*/
    var queryParams = '?' + encodeURIComponent('serviceKey') + '=' + '9TscTEWwoFUI2OzuPJWp%2Bk1FmhozUx8gk32WztJ7sxLUQrGgyzqRMHQ2rpqRjXB8l2mugEiOBXovV%2FSs9nBv9g%3D%3D'; /*Service Key*/
    queryParams += '&' + encodeURIComponent('type') + '=' + encodeURIComponent('json');
    queryParams += '&' + encodeURIComponent('item_name') + '=' + encodeURIComponent(keyword)

    fetch(url + queryParams)
        .then((res) => res.json())
        .then((jsonData) => {

        	let str = '';
            jsonData.body.items.forEach(function(item){
                let itemName = item.ITEM_NAME;
                if(itemName.indexOf('(수출명', 2) != -1){
                    itemName = itemName.substring(0, itemName.indexOf('(수출명', 2));
                }

                str += "<tr class='showNumNm'>";
				str += "<td class='showNum' data-dismiss='modal' style='cursor:pointer;'>" + item.PRDLST_STDR_CODE + "</td>";
				str += "<td class='showNm' data-dismiss='modal' style='cursor:pointer;'>" + itemName + "</td>";
				str += "</tr>";

            });

            $("#drugList").html(str);
        })
        .catch(() => {
        	simpleErrorAlert("조건에 해당하는 약품이 없습니다");
        })

});

//원외처방전에서 클릭하면 append로 뜨게 하기
$(document).on("click", ".showNumNm", function(){

	if($("#medi > tr").length>7){
		simpleErrorAlert("더 이상 추가할 수 없습니다");
		return false;
	}

	// 선택한 약품의 번호를 가져옴
	let ipt = $(this).children().eq(0).text().trim();

	for(tr of [...$("#medi").children()]){
		const drugNum = $(tr).data('drugnum'); //뽑은 값을 변수로 선언
		if(drugNum == ipt){
			simpleErrorAlert("중복된 약품은 추가할 수 없습니다.");
			return false;
		}
	}

	//this : class="showCdNm"이 여러개이고, 이 중에서 하나를 클릭한 바로 그 요소
	let drugNum = $('.showNum', this).text().trim();
	let drugNm = $('.showNm', this).text().trim();

	let code = "<tr data-drugnum='" + drugNum + "'>";
	code += "<td class='p-0'>";
	code += "<input type='text' value='" + drugNm + "' class='drugNm' name='drugNm' style='border:none;width: 300px;text-align:center;' readonly>";
	code += "</td>";
	code += "<td class='p-0'>";
	code += "<input type='number' style='width:100%;border:none;' class='dosage'>";
	code += "</td>";
	code += "<td class='p-0'>";
	code += "<input type='number' style='width:100%;border:none;' class='doses'>";
	code += "</td>";
	code += "<td class='p-0'>";
	code += "<input type='number' style='width:100%;border:none;' class='dosesdate'>";
	code += "</td>";
	code += "</tr>";

	$("#medi").append(code);

});

//클릭했을때 색이 바뀜
$(".docBtn").on("click",function(){
	$(".docBtn").css("background-color","#404b57");
	$(".docBtn").css("color","white");
	$(this).css("background-color","white");
	$(this).css("color"," #404b57");
});

//원외처방전 모달창 버튼 누르면 병명 리스트 뜨기
$("#disButton4").on("click",function(){
	let disCd = "";
	let disKorNm = "";

	let data = {
			"disCd":disCd,
			"disKorNm":disKorNm
	};

	const csrfToken = $('#_csrfToken').val();
	$.ajax({
		url: '/hospital/document/disList',
		contentType:"application/json;charset:utf-8",
		data:JSON.stringify(data),
		type: 'post',
		dataType: 'json',
		beforeSend : function(xhr) { // 데이터 전송 전 헤더에 csrf값 설정
			xhr.setRequestHeader("X-CSRF-TOKEN", csrfToken);
		},
		success: function(result){

			let str="";
			//data-dismiss='modal' style='cursor:pointer;'=값 입력하면 사라지는 창
			$.each(result,function(index,disVO) {
				str += "<tr class='showCdNm4'>";
				str+="<td class='showCd4' data-dismiss='modal' style='cursor:pointer;'>" + disVO.disCd + "</td><br>";
				str+="<td class='showNm4' data-dismiss='modal' style='cursor:pointer;'>" + disVO.disKorNm + "</td><br>";
				str += "</tr>";
			});

            $("#disList4").html(str);
	},
	error:function(xhr){
		alert("xhr:"+xhr.status);
		}
	});
});

//원외처방전 모달창에서 검색하면 리스트 뜸
$(document).on("click", "#disListButton4", function(event){ //모달창안의 버튼은 document 필수

	let keyword=$("#diskeyword4").val();

	const csrfToken = $('#_csrfToken').val();
	$.ajax({
		url: "/hospital/document/disModalSelect?keyword="+keyword,
		contentType:"application/json;charset=utf-8",
		type:"get",
		dataType:"json",
		beforeSend : function(xhr) { // 데이터 전송 전 헤더에 csrf값 설정
			xhr.setRequestHeader("X-CSRF-TOKEN", csrfToken);
		},
		success:function(result){

			let str="";

			$.each(result,function(index,disVO) {
				str += "<tr class='showCdNm4'>";
				str+="<td class='showCd4' data-dismiss='modal' style='cursor:pointer;'>"+disVO.disCd+"</td><br>";
				str+="<td class='showNm4' data-dismiss='modal' style='cursor:pointer;'>"+disVO.disKorNm+"</td><br>";
				str += "</tr>";
			});

            $("#disList4").html(str);
		},
		error: function(){
			simpleJustErrorAlert();
		}
	});
});

//원외처방전 모달창에서 질병명을 입력하고 버튼을 누르면 진단서 폼에 출력됨
$(document).on("click", ".showCdNm4", function(){
	//this : class="showCdNm"이 여러개이고, 이 중에서 하나를 클릭한 바로 그 요소
	let disCd = $('.showCd4', this).text().trim();
	let disKorNm = $('.showNm4', this).text().trim();

	let data = {"disCd":disCd, "disKorNm":disKorNm};

	const csrfToken = $('#_csrfToken').val();
	$.ajax({
		url:"/hospital/document/showCdNm",
		contentType:"application/json;charset:utf-8",
		data:JSON.stringify(data),
		type:"post",
		dataType:"json",
		beforeSend : function(xhr) {   // 데이터 전송 전  헤더에 csrf값 설정
	        xhr.setRequestHeader("X-CSRF-TOKEN", csrfToken);
		},
		success:function(result){
			$("#disease6").val(result.disKorNm);
		},
		error: function(){
			simpleJustErrorAlert();
		}
	});

});

//치료확인서 모달창 버튼 누르면 병명 리스트 뜨기
$("#disButton3").on("click",function(){

	let disCd = "";
	let disKorNm = "";

	let data = {
			"disCd":disCd,
			"disKorNm":disKorNm
	};

	const csrfToken = $('#_csrfToken').val();
	$.ajax({
		url: '/hospital/document/disList',
		contentType:"application/json;charset:utf-8",
		data:JSON.stringify(data),
		type: 'post',
		dataType: 'json',
		beforeSend : function(xhr) { // 데이터 전송 전 헤더에 csrf값 설정
			xhr.setRequestHeader("X-CSRF-TOKEN", csrfToken);
		},
		success: function(result){

			let str="";
			//data-dismiss='modal' style='cursor:pointer;'=값 입력하면 사라지는 창
			$.each(result,function(index,disVO) {
				str += "<tr class='showCdNm2'>";
				str+="<td class='showCd2' data-dismiss='modal' style='cursor:pointer;'>" + disVO.disCd + "</td><br>";
				str+="<td class='showNm2' data-dismiss='modal' style='cursor:pointer;'>" + disVO.disKorNm + "</td><br>";
				str += "</tr>";
			});
            $("#disList3").html(str);

		},
		error:function(){
			simpleJustErrorAlert();
		}
	});
});

//치료확인서 모달창에서 검색하면 리스트 뜸
$(document).on("click", "#disListButton3", function(event){ //모달창안의 버튼은 document 필수

	let keyword=$("#diskeyword3").val();

	const csrfToken = $('#_csrfToken').val();
	$.ajax({
		url: "/hospital/document/disModalSelect?keyword="+keyword,
		contentType:"application/json;charset=utf-8",
		type:"get",
		dataType:"json",
		beforeSend : function(xhr) { // 데이터 전송 전 헤더에 csrf값 설정
			xhr.setRequestHeader("X-CSRF-TOKEN", csrfToken);
		},
		success:function(result){

			let str="";

			$.each(result,function(index,disVO) {
				str += "<tr class='showCdNm2'>";
				str+="<td class='showCd2' data-dismiss='modal' style='cursor:pointer;'>"+disVO.disCd+"</td><br>";
				str+="<td class='showNm2' data-dismiss='modal' style='cursor:pointer;'>"+disVO.disKorNm+"</td><br>";
				str += "</tr>";
			});

            $("#disList3").html(str);
		},
		error: function(){
			simpleJustErrorAlert();
		}
	});
});

//치료확인서 모달창에서 질병명을 입력하고 버튼을 누르면 진단서 폼에 출력됨
$(document).on("click", ".showCdNm2", function(){
	//this : class="showCdNm"이 여러개이고, 이 중에서 하나를 클릭한 바로 그 요소
	let disCd = $('.showCd2', this).text().trim();
	let disKorNm = $('.showNm2', this).text().trim();

	let data = {"disCd":disCd, "disKorNm":disKorNm};

	const csrfToken = $('#_csrfToken').val();
	$.ajax({
		url:"/hospital/document/showCdNm",
		contentType:"application/json;charset:utf-8",
		data:JSON.stringify(data),
		type:"post",
		dataType:"json",
		beforeSend : function(xhr) {   // 데이터 전송 전  헤더에 csrf값 설정
	        xhr.setRequestHeader("X-CSRF-TOKEN", csrfToken);
		},
		success:function(result){
			$("#disease3").val(result.disKorNm);
		},
		error: function(){
			simpleJustErrorAlert();
		}
	});

});

//향후 치료비 추정서 모달창 버튼 누르면 병명 리스트 뜨기
$("#disButton2").on("click",function(){

	let disCd="";
	let disKorNm="";

	let data={
			"disCd":disCd,
			"disKorNm":disKorNm
	}

	const csrfToken = $('#_csrfToken').val();
	$.ajax({
		url: '/hospital/document/disList',
		contentType:"application/json;charset:utf-8",
		data:JSON.stringify(data),
		type: 'post',
		dataType: 'json',
		beforeSend : function(xhr) { // 데이터 전송 전 헤더에 csrf값 설정
			xhr.setRequestHeader("X-CSRF-TOKEN", csrfToken);
		},
		success: function(result){

			let str="";
			//data-dismiss='modal' style='cursor:pointer;'=값 입력하면 사라지는 창
			$.each(result,function(index,disVO) {
				str += "<tr class='showCdNm3'>";
				str+="<td class='showCd3' data-dismiss='modal' style='cursor:pointer;'>"+disVO.disCd+"</td><br>";
				str+="<td class='showNm3' data-dismiss='modal' style='cursor:pointer;'>"+disVO.disKorNm+"</td><br>";
				str += "</tr>";
			});
            $("#disList2").html(str);

		},
		error:function(){
			simpleJustErrorAlert();
		}
	});
});



//향후 치료비 추정서에서 검색창에 질병명이나 코드 치면 질병명 나옴
$(document).on("click", "#disListButton2", function(event){ //모달창안의 버튼은 document 필수

	let keyword=$("#diskeyword2").val();

	const csrfToken = $('#_csrfToken').val();
	$.ajax({
		url: "/hospital/document/disModalSelect?keyword="+keyword,
		contentType:"application/json;charset=utf-8",
		type:"get",
		dataType:"json",
		beforeSend : function(xhr) { // 데이터 전송 전 헤더에 csrf값 설정
			xhr.setRequestHeader("X-CSRF-TOKEN", csrfToken);
		},
		success:function(result){

			let str="";

			$.each(result,function(index,disVO) {
				str += "<tr class='showCdNm3'>";
				str+="<td class='showCd3' data-dismiss='modal' style='cursor:pointer;'>"+disVO.disCd+"</td><br>";
				str+="<td class='showNm3' data-dismiss='modal' style='cursor:pointer;'>"+disVO.disKorNm+"</td><br>";
				str += "</tr>";
			});

            $("#disList2").html(str);
		},
		error: function(){
			simpleJustErrorAlert();
		}
	});
});

//향후 치료비 추정서 모달창에서 질병명을 입력하고 버튼을 누르면 진단서 폼에 출력됨
$(document).on("click", ".showCdNm3", function(){
	//this : class="showCdNm"이 여러개이고, 이 중에서 하나를 클릭한 바로 그 요소
	let disCd = $('.showCd3', this).text().trim();
	let disKorNm = $('.showNm3', this).text().trim();

	let data = {"disCd":disCd, "disKorNm":disKorNm};

	const csrfToken = $('#_csrfToken').val();
	$.ajax({
		url:"/hospital/document/showCdNm",
		contentType:"application/json;charset:utf-8",
		data:JSON.stringify(data),
		type:"post",
		dataType:"json",
		beforeSend : function(xhr) {   // 데이터 전송 전  헤더에 csrf값 설정
	        xhr.setRequestHeader("X-CSRF-TOKEN", csrfToken);
		},
		success:function(result){
			$("#DiagnosisNum2").val(result.disKorNm);
		},
		error: function(){
			simpleJustErrorAlert();
		}
	});

});

//진단서 모달창 버튼 누르면 병명 리스트 뜨기
$("#disButton").on("click",function(){

	let disCd="";
	let disKorNm="";

	let data={
			"disCd":disCd,
			"disKorNm":disKorNm
	}

	const csrfToken = $('#_csrfToken').val();
	$.ajax({
		url: '/hospital/document/disList',
		contentType:"application/json;charset:utf-8",
		data:JSON.stringify(data),
		type: 'post',
		dataType: 'json',
		beforeSend : function(xhr) { // 데이터 전송 전 헤더에 csrf값 설정
			xhr.setRequestHeader("X-CSRF-TOKEN", csrfToken);
		},
		success: function(result){

			let str="";
			//data-dismiss='modal' style='cursor:pointer;'=값 입력하면 사라지는 창
			$.each(result,function(index,disVO) {
				str += "<tr class='showCdNm'>";
				str+="<td class='showCd' data-dismiss='modal' style='cursor:pointer;'>"+disVO.disCd+"</td><br>";
				str+="<td class='showNm' data-dismiss='modal' style='cursor:pointer;'>"+disVO.disKorNm+"</td><br>";
				str += "</tr>";
			});
            $("#disList").html(str);

		},
		error:function(xhr){
			alert("xhr:"+xhr.status);
		}
	});
});

//진단서에서 검색창에 질병명이나 코드 치면 질병명 나옴
$(document).on("click", "#disListButton", function(event){ //모달창안의 버튼은 document 필수

	let keyword=$("#diskeyword").val();

	const csrfToken = $('#_csrfToken').val();
	$.ajax({
		url: "/hospital/document/disModalSelect?keyword="+keyword,
		contentType:"application/json;charset=utf-8",
		type:"get",
		dataType:"json",
		beforeSend : function(xhr) { // 데이터 전송 전 헤더에 csrf값 설정
			xhr.setRequestHeader("X-CSRF-TOKEN", csrfToken);
		},
		success:function(result){

			let str="";

			$.each(result,function(index,disVO) {
				str += "<tr class='showCdNm'>";
				str+="<td class='showCd' data-dismiss='modal' style='cursor:pointer;'>"+disVO.disCd+"</td><br>";
				str+="<td class='showNm' data-dismiss='modal' style='cursor:pointer;'>"+disVO.disKorNm+"</td><br>";
				str += "</tr>";
			});

            $("#disList").html(str);
		},
		error: function(){
			simpleJustErrorAlert();
		}
	});
});

//진단서 모달창에서 질병명을 입력하고 버튼을 누르면 진단서 폼에 출력됨
$(document).on("click", ".showCdNm", function(){
	//this : class="showCdNm"이 여러개이고, 이 중에서 하나를 클릭한 바로 그 요소
	let disCd = $('.showCd', this).text().trim();
	let disKorNm = $('.showNm', this).text().trim();

	let data = {"disCd":disCd, "disKorNm":disKorNm};

	const csrfToken = $('#_csrfToken').val();
	$.ajax({
		url:"/hospital/document/showCdNm",
		contentType:"application/json;charset:utf-8",
		data:JSON.stringify(data),
		type:"post",
		dataType:"json",
		beforeSend : function(xhr) {   // 데이터 전송 전  헤더에 csrf값 설정
	        xhr.setRequestHeader("X-CSRF-TOKEN", csrfToken);
		},
		success:function(result){
			$("#disease").val(result.disKorNm);
		},
		error: function(){
			simpleJustErrorAlert();
		}
	});

});

$("#detailSearch").on("click",function(){
	//진단서별로 체크박스값 및 달력 값 가져오기
	$("#CTform").hide();
	$("#patientInfo").hide();
	$("#confirmform").hide();
	$("#diagform").hide();
	$("#treatform").hide();
	$("#opinionform").hide();
	$("#outsideform").hide();
	$("#docSearchform").show();
	$("#Searchlist").show();


	let ptNum = $("#chartNum7").val();
	if(ptNum == null || ptNum.trim() == ""){
		simpleErrorAlert("먼저 환자를 검색해주세요");
		return false;
	}

	let docStartDt = $("#docStartDt").val();
	let docFinalDt = $("#docFinalDt").val();
	let docNumList = [];
	$("input:checkbox[name='docNum']:checked").each(function(index,data){
		docNumList.push(data.value);
	});

	//파라미터 용도 : json데이터
	let data={
			"ptNum" : ptNum,
			"docNumList" : docNumList,
			"docStartDt" : docStartDt,
			"docFinalDt" : docFinalDt
			};

	const csrfToken = $('#_csrfToken').val();
	$.ajax({
		url: '/hospital/document/checkbox',
		contentType:"application/json;charset=utf-8",
		data:JSON.stringify(data),
		type: 'post',
		dataType: 'json',
		beforeSend : function(xhr) { // 데이터 전송 전 헤더에 csrf값 설정
			xhr.setRequestHeader("X-CSRF-TOKEN", csrfToken);
		},
		success: function(result){

			let str="";

			$.each(result,function(index,docVO) {
				if(docVO.chkNum==null){
					docVO.chkNum="";
				}

				let docSavePath = docVO.docSavePath;
				docSavePath = docSavePath.substring(docSavePath.indexOf('\\resources'));
				docSavePath = docSavePath.replace(/\\/g, '/');

				str += "<tr class='doclist'>";
				str+="<td data-price='" + docVO.docIssuePrice + "' data-name='" + docVO.docName + "'>"+docVO.docIssueNum+"</td><br>";
				//str+="<td>"+docVO.ptNum+"</td><br>";
				//str+="<td>"+docVO.docNum+"</td><br>";
				str+="<td>" + docVO.docName + "</td><br>";
				str+="<td>" + docVO.docIssueReason + "</td><br>";
				str+="<td>" + dateFormat(new Date(docVO.docIssueDt)) + "</td><br>";
				str+="<td>" + docVO.chkNum + "</td><br>";
				str+="<td class='align-middle'>";
				str+="<button type='button' class='docShowButton btn btn-success m-0 mx-auto d-flex justify-content-center align-items-center' data-path='" + docSavePath + "' style='width: 28px; height: 28px;'>";
				str+="<i class='fa-solid fa-magnifying-glass'></i>";
				str+="</button>";
				str+="</td>"
				str+="</tr>";
			});
            $("#docSearchlist").html(str);
			$('#documentPrNm').empty(); // 서류 결제 목록에 선택되어있는 서류 비움
		},
		error:function(){
			simpleJustErrorAlert();
		}
	});
});


//진단서
$("#diagformsend").on("click",function(){

	let ptSearch=$("#ptSearch").val();

	if(ptSearch==null || ptSearch==""){
		simpleErrorAlert("환자를 검색해주세요");
		return false;
	}

	let ptNm=$("#name7").val();
	let ptRrno=$("#citizenNum7").val();
	let ptAddr=$("#addr7").val();
	let disease=$("#disease").val();
	let occur=$("#occur").val();
	let diagnosisDate=$("#diagnosisDate").val();
	let therapycon=$("#therapycon").val();
	let docIssueReason=$("#purpose").val();
	let licenseNum=$("#licenseNum").val();
	let doctorName=$("#doctorName").val();
	let ptNum=$("#chartNum7").val();
	let hiBrno=$("#num8").val();
	let hiNm=$("#name8").val();
	let hiAddr=$("#addr8").val();
	let hiPhone=$("#tel8").val();
	let hiEml=$("#email8").val();
	let chkNum= $("#ptChkSelect").val();

	if(disease==null || disease=="" || occur==null || occur=="" || diagnosisDate==null || diagnosisDate=="" || therapycon==null || therapycon=="" || purpose==null || purpose=="" || licenseNum==null || licenseNum=="" || doctorName==null) {
		simpleErrorAlert("양식을 모두 작성해주셔야 합니다.");
		return false;
	}

	$("#disPreview").attr("disabled",false);

	let data={"ptNm":ptNm, "ptRrno":ptRrno,
			"ptAddr":ptAddr,"disease":disease,
			"occur":occur,"diagnosisDate":diagnosisDate,
			"therapycon":therapycon,"docIssueReason":docIssueReason,
			"licenseNum":licenseNum,"doctorName":doctorName,
			"ptNum":ptNum, "hiBrno":hiBrno, "hiNm":hiNm,
			"hiAddr":hiAddr, "hiPhone":hiPhone, "hiEml":hiEml , "chkNum":chkNum
	};

	const csrfToken = $('#_csrfToken').val();
	$.ajax({
		url: "/hospital/document/diagnosis",
		contentType: "application/json; charset=utf-8",
		type: "POST",
		dataType:"text",
		data: JSON.stringify(data),
		beforeSend : function(xhr) { // 데이터 전송 전 헤더에 csrf값 설정
			xhr.setRequestHeader("X-CSRF-TOKEN", csrfToken);
			},	success: function(res){
				simpleSuccessAlert("발급 완료");
				const url = '/resources/document/pdfjs/web/viewer.html?file=' + res;
				$("#disPreview").attr('data-path',url);
		},
		error:function(){
			simpleJustErrorAlert();
		}
	});
});

//향후 치료비 추정서
$("#treatformmsend").on("click",function(){

	let ptSearch=$("#ptSearch").val();

	if(ptSearch==null || ptSearch==""){
		simpleErrorAlert("환자를 검색해주세요");
		return false;
	}

	let ptNm=$("#name7").val();
	let ptRrno=$("#citizenNum7").val();
	let ptAddr=$("#addr7").val();
	let DiagnosisNum=$("#DiagnosisNum2").val();
	let therapycon=$("#therapycon2").val();
	let therapyDate=$("#therapyDate2").val();
	let publishDate=$("#publishDate2").val();
	let licenseNum=$("#licenseNum2").val();
	let doctorName=$("#doctorName2").val();
	let docIssueReason=$("#purpose2").val();
	let ptNum=$("#chartNum7").val();
	let hiBrno=$("#num8").val();
	let hiNm=$("#name8").val();
	let hiAddr=$("#addr8").val();
	let hiPhone=$("#tel8").val();
	let hiEml=$("#email8").val();
	let chkNum= $("#ptChkSelect").val();

	if(ptNm==null || ptNm=="" || ptRrno==null || ptRrno=="" || ptAddr==null || ptAddr=="" || DiagnosisNum==null || DiagnosisNum=="" || therapycon==null || therapycon=="" ||
			therapyDate==null || therapyDate=="" || doctorName==null) {
		simpleErrorAlert("양식을 모두 작성해주셔야 합니다.");
		return false;
	}

	$("#treatPreview").attr("disabled",false);

	let data={"ptAddr":ptAddr, "ptNm":ptNm,
			"ptRrno":ptRrno,"DiagnosisNum":DiagnosisNum,
			"therapycon":therapycon,"therapyDate":therapyDate,
			"publishDate":publishDate, "licenseNum":licenseNum,
			"doctorName":doctorName, "docIssueReason":docIssueReason,
			"ptNum":ptNum,
			"hiBrno":hiBrno, "hiNm":hiNm, "hiAddr":hiAddr, "hiPhone":hiPhone, "hiEml":hiEml,
			"chkNum":chkNum
	};

	const csrfToken = $('#_csrfToken').val();
	$.ajax({
		url: "/hospital/document/treatmentPlan",
		contentType: "application/json;charset=utf-8",
		type: "POST",
		dataType:"text",
		data: JSON.stringify(data),
		beforeSend : function(xhr) { // 데이터 전송 전 헤더에 csrf값 설정
			xhr.setRequestHeader("X-CSRF-TOKEN", csrfToken);
		},	success: function(res){
				simpleSuccessAlert("발급 완료");
				const url = '/resources/document/pdfjs/web/viewer.html?file=' + res;
				$("#treatPreview").attr('data-path',url);
		},
		error:function(){
			simpleJustErrorAlert();
		}
	});
});

//치료확인서
$("#confirmformsend").on("click",function(){

	let ptSearch=$("#ptSearch").val();

	if(ptSearch==null || ptSearch==""){
		simpleErrorAlert("환자를 검색해주세요");
		return false;
	}

	let ptNm=$("#name7").val();
	let ptRrno=$("#citizenNum7").val();
	let ptAddr=$("#addr7").val();
	let ptGen=$("#ptGen").val();
	let disease=$("#disease3").val();
	let therapycon=$("#therapycon3").val();
	let therapyDate=$("#therapyDate3").val();
	let publishDate=$("#publishDate3").val();
	let licenseNum=$("#licenseNum3").val();
	let doctorName=$("#doctorName3").val();
	let docIssueReason=$("#purpose3").val();
	let ptNum=$("#chartNum7").val();
	let ptPhone=$("#tel7").val();
	let hiBrno=$("#num8").val();
	let hiNm=$("#name8").val();
	let hiAddr=$("#addr8").val();
	let hiPhone=$("#tel8").val();
	let hiEml=$("#email8").val();
	let chkNum= $("#ptChkSelect").val();

	if(ptNm==null || ptNm=="" || ptRrno==null || ptRrno=="" || ptAddr==null || ptAddr=="" || therapycon==null || therapycon=="" || disease==null || disease=="" ||
			publishDate==null) {
		simpleErrorAlert("양식을 모두 작성해주셔야 합니다.");
		return false;
	}

	$("#confirmPreview").attr("disabled",false);

	let data={"ptNm":ptNm, "ptGen":ptGen, "ptAddr":ptAddr,
			"ptRrno":ptRrno,"ptPhone":ptPhone,
			"disease":disease,"therapycon":therapycon,
			"therapyDate":therapyDate,"publishDate":publishDate,
			"licenseNum":licenseNum,
			"doctorName":doctorName,"docIssueReason":docIssueReason,"ptNum":ptNum,
			"hiBrno":hiBrno, "hiNm":hiNm, "hiAddr":hiAddr, "hiPhone":hiPhone, "hiEml":hiEml,
			"chkNum":chkNum
	};

	const csrfToken = $('#_csrfToken').val();
	$.ajax({
		url: "/hospital/document/treatconfirm",
		contentType: "application/json;charset=utf-8",
		type: "POST",
		dataType:"text",
		data: JSON.stringify(data),
		beforeSend : function(xhr) { // 데이터 전송 전 헤더에 csrf값 설정
			xhr.setRequestHeader("X-CSRF-TOKEN", csrfToken);
		}, success: function(res){
			simpleSuccessAlert("발급 완료");

			const url = '/resources/document/pdfjs/web/viewer.html?file=' + res;
			$("#confirmPreview").attr('data-path',url);
		},
		error:function(){
			simpleJustErrorAlert();
		}
	});
});

//CT판독
$("#CTsend").on("click",function(){

	let ptSearch=$("#ptSearch").val();

	if(ptSearch==null || ptSearch==""){
		simpleErrorAlert("환자를 검색해주세요");
		return false;
	}

	let ptNm=$("#name7").val();
	let ptRrno=$("#citizenNum7").val();
	let ptAddr=$("#addr7").val();
	let ptGen=$("#ptGen").val();
	let Exdate=$("#Exdate4").val();
	let doctorname=$("#doctorname4").val();
	let licenseNum=$("#licenseNum4").val();
	let Readingfind=$("#Readingfind4").val();
	let conclusion=$("#conclusion4").val();
	let readingdate=$("#readingdate4").val();
	let docIssueReason=$("#purpose4").val();
	let ptNum=$("#chartNum7").val();
	let hiBrno=$("#num8").val();
	let hiNm=$("#name8").val();
	let hiAddr=$("#addr8").val();
	let hiPhone=$("#tel8").val();
	let hiEml=$("#email8").val();
	let chkNum= $("#ptChkSelect").val();

	if(ptNm==null || ptNm=="" || ptRrno==null || ptRrno=="" || ptAddr==null || ptAddr=="" || Readingfind==null || Readingfind=="" ||
			conclusion==null || conclusion=="" || doctorName==null) {
		simpleErrorAlert("양식을 모두 작성해주셔야 합니다.");
		return false;
	}

	$("#CTPreview").attr("disabled",false);

	let data={"ptNm":ptNm, "ptGen":ptGen, "Exdate":Exdate,
			"doctorname":doctorname, "ptRrno":ptRrno,"ptAddr":ptAddr,
			"licenseNum":licenseNum,"Readingfind":Readingfind,
			"conclusion":conclusion,"readingdate":readingdate,
			"docIssueReason":docIssueReason,"ptNum":ptNum,
			"hiBrno":hiBrno, "hiNm":hiNm, "hiAddr":hiAddr, "hiPhone":hiPhone, "hiEml":hiEml,
			"chkNum":chkNum
	};

	const csrfToken = $('#_csrfToken').val();
	$.ajax({
		url: "/hospital/document/CT",
		contentType: "application/json;charset=utf-8",
		type: "POST",
		dataType:"text",
		data: JSON.stringify(data),
		beforeSend : function(xhr) { // 데이터 전송 전 헤더에 csrf값 설정
			xhr.setRequestHeader("X-CSRF-TOKEN", csrfToken);
			},
		success: function(res){
			simpleSuccessAlert("발급 완료");
			const url = '/resources/document/pdfjs/web/viewer.html?file=' + res;
			$("#CTPreview").attr('data-path',url);
		},
		error:function(){
			simpleJustErrorAlert();
		}
	});
});

//소견서
$("#opinionsend").on("click",function(){

	let ptSearch=$("#ptSearch").val();

	if(ptSearch==null || ptSearch==""){
		simpleErrorAlert("환자를 검색해주세요");
		return false;
	}

	let ptNm=$("#name7").val();
	let ptRrno=$("#citizenNum7").val();
	let ptAddr=$("#addr7").val();
	let ptGen=$("#ptGen").val();
	let Clinicopinion=$("#Clinicopinion5").val();
	let docIssueReason=$("#purpose5").val();
	let publishDate=$("#publishDate5").val();
	let licenseNum=$("#licenseNum5").val();
	let doctorName=$("#doctorName5").val();
	let ptNum=$("#chartNum7").val();
	let hiBrno=$("#num8").val();
	let hiNm=$("#name8").val();
	let hiAddr=$("#addr8").val();
	let hiPhone=$("#tel8").val();
	let hiEml=$("#email8").val();
	let chkNum= $("#ptChkSelect").val();

	if(Clinicopinion==null || Clinicopinion=="" || docIssueReason==null || docIssueReason=="" ||
			publishDate==null || publishDate=="") {
		simpleErrorAlert("양식을 모두 작성해주셔야 합니다.");
		return false;
	}

	$("#opinionPreview").attr("disabled",false);

	let data={"ptNm":ptNm, "ptGen":ptGen, "ptRrno":ptRrno,
			"ptAddr":ptAddr,"Clinicopinion":Clinicopinion,
			"docIssueReason":docIssueReason,"publishDate":publishDate,
			"licenseNum":licenseNum,"doctorName":doctorName,"ptNum":ptNum,
			"hiBrno":hiBrno, "hiNm":hiNm, "hiAddr":hiAddr, "hiPhone":hiPhone, "hiEml":hiEml
			,"chkNum":chkNum
	};

	const csrfToken = $('#_csrfToken').val();
	$.ajax({
		url: "/hospital/document/opinion",
		contentType: "application/json;charset=utf-8",
		type: "POST",
		dataType:"text", //controller에서 반환 타입이 String이라면 dataType을 text로 바꿔줘야 함. json타입은 반환타입이 map이나 vo일 때만 가능
		data: JSON.stringify(data),
		beforeSend : function(xhr) { // 데이터 전송 전 헤더에 csrf값 설정
			xhr.setRequestHeader("X-CSRF-TOKEN", csrfToken);
			},
		success: function(res){
			simpleSuccessAlert("발급 완료");

			const url='/resources/document/pdfjs/web/viewer.html?file=' + res;
			$("#opinionPreview").attr('data-path',url);
		},
		error:function(){
			simpleJustErrorAlert();
		}
	});
});

//발급 버튼 클릭. 원외처방전
$("#outsidesend").on("click",function(){


	let ptSearch = $("#ptSearch").val();

	if(ptSearch==null || ptSearch==""){
		simpleErrorAlert("환자를 검색해주세요");
		return false;
	}

	let ptNm=$("#name7").val();
	let ptRrno=$("#citizenNum7").val();
	let ptAddr=$("#addr7").val();
	let year=$("#year6").val();
	let disease=$("#disease6").val();
	let doctorName=$("#doctorName6").val();
	let licenseNum=$("#licenseNum6").val();
	let docIssueReason=$("#purpose6").val();
	let ptNum=$("#chartNum7").val();

	let date=$("#date6").val();

	let hiBrno=$("#num8").val();
	let hiNm=$("#name8").val();
	let hiAddr=$("#addr8").val();
	let hiPhone=$("#tel8").val();
	let hiEml=$("#email8").val();
	let chkNum= $("#ptChkSelect").val();

	if(year==null || year=="" || ptNm==null || ptNm=="" || ptRrno==null || ptRrno=="" || ptAddr==null || ptAddr=="" || docIssueReason==null || docIssueReason==""|| doctorName==null) {
		simpleErrorAlert("양식을 모두 작성해주셔야 합니다.");
		return false;
	}

	$("#outSidePreview").attr("disabled",false);

	let data={"year":year,
			"ptNm":ptNm,"ptRrno":ptRrno,"ptAddr":ptAddr,
			"disease":disease,"doctorName":doctorName,
			"licenseNum":licenseNum,
			"date":date, "docIssueReason":docIssueReason,"ptNum":ptNum,
			"hiBrno":hiBrno, "hiNm":hiNm, "hiAddr":hiAddr, "hiPhone":hiPhone, "hiEml":hiEml
			,"chkNum":chkNum
			,"drugVOList":JSON.stringify(drugVOList)

	};

	const csrfToken = $('#_csrfToken').val();
	$.ajax({
		url: "/hospital/document/outside",
		contentType: "application/json;charset=utf-8",
		type: "POST",
		dataType:"text",
		data: JSON.stringify(data),
		beforeSend : function(xhr) { // 데이터 전송 전 헤더에 csrf값 설정
			xhr.setRequestHeader("X-CSRF-TOKEN", csrfToken);
		},
		success: function(res){
			simpleSuccessAlert("발급 완료");
			const url = '/resources/document/pdfjs/web/viewer.html?file=' + res;
			$("#outSidePreview").attr('data-path',url);
		},
		error:function(){
			simpleJustErrorAlert();
		}
	});
});

//진단서
$("#diagnosis").on("click",function(){
	$("#diagform").show();
	$("#patientInfo").show();
	$("#treatform").hide();
	$("#confirmform").hide();
	$("#CTform").hide();
	$("#opinionform").hide();
	$("#outsideform").hide();
	$("#docSearchform").hide();
	$("#Searchlist").hide();
	$("#docPayDiv").hide();
});
//향후 치료비 추정서
$("#treatment").on("click",function(){
	$("#treatform").show();
	$("#patientInfo").show();
	$("#diagform").hide();
	$("#confirmform").hide();
	$("#CTform").hide();
	$("#opinionform").hide();
	$("#outsideform").hide();
	$("#docSearchform").hide();
	$("#Searchlist").hide();
	$("#docPayDiv").hide();
});
//치료확인서
$("#confirm").on("click",function(){
	$("#confirmform").show();
	$("#patientInfo").show();
	$("#diagform").hide();
	$("#treatform").hide();
	$("#CTform").hide();
	$("#opinionform").hide();
	$("#outsideform").hide();
	$("#docSearchform").hide();
	$("#Searchlist").hide();
	$("#docPayDiv").hide();
});
//ct판독확인서
$("#CT").on("click",function(){
	$("#CTform").show();
	$("#patientInfo").show();
	$("#confirmform").hide();
	$("#diagform").hide();
	$("#treatform").hide();
	$("#opinionform").hide();
	$("#outsideform").hide();
	$("#docSearchform").hide();
	$("#Searchlist").hide();
	$("#docPayDiv").hide();
});
//소견서
$("#opinion").on("click",function(){
	$("#opinionform").show();
	$("#patientInfo").show();
	$("#CTform").hide();
	$("#confirmform").hide();
	$("#diagform").hide();
	$("#treatform").hide();
	$("#outsideform").hide();
	$("#docSearchform").hide();
	$("#Searchlist").hide();
	$("#docPayDiv").hide();
});
//원외처방전
$("#outside").on("click",function(){
	$("#outsideform").show();
	$("#patientInfo").show();
	$("#Searchlist").hide();
	$("#docSearchform").hide();
	$("#opinionform").hide();
	$("#CTform").hide();
	$("#confirmform").hide();
	$("#diagform").hide();
	$("#treatform").hide();
	$("#docPayDiv").hide();
});
//서류검색
$("#docSearch").on("click",function(){
	$("#docSearchform").show();
	$("#Searchlist").show();
	$(".doclist").show();
	$("#docPayDiv").show();
	$("#outsideform").hide();
	$("#opinionform").hide();
	$("#CTform").hide();
	$("#confirmform").hide();
	$("#diagform").hide();
	$("#treatform").hide();
	$("#patientInfo").hide();

	// 서류 검색 버튼을 눌렀을 때 서류 목록을 다시 불러온다.
	let ptNum = $("#chartNum7").val();
	if(ptNum != null && ptNum.trim() != ""){
		$("#detailSearch").click();
	}

});


//searchModule.js에서 onmousedown="selectPt(this)를 선언했기 때문에 아래 메소드에 target이 따로 붙지 않아서 따로 써야함
function selectPt(target){
	$("#documentPrNm").html('');
	const ptInfo = target.textContent;
	$('#ptSearch').val(ptInfo);
	const ptNum = target.dataset.ptnum;
//	$("#docPtInfo").val(ptInfo);

	$.ajax({
		url: '/hospital/document/patientInfo?ptNum=' + ptNum,
		type: 'get',
		dataType: 'json',
		success: function(result){

			$("#docPtInfo").val(result.ptNum); // 서류 결제 모달에 환자 번호 지정

			$("#name7").val(result.ptNm);
			$("#chartNum7").val(result.ptNum);
			$("#citizenNum7").val(result.ptRrno);
			$("#ptGen").val(result.ptGen);

			const ptBrdt = result.ptBrdt;
			$("#birth7").val(ptBrdt);

			let bornYear = ptBrdt.substring(0,4);
			let today = new Date();
			let age = today.getYear() + 1900 - parseInt(bornYear);

			$("#age7").val(age);
			$("#addr7").val(result.ptAddr+", "+result.ptAddrDet);
			$("#tel7").val(result.ptPhone);

			let chkOptions = '';
			result.chkList.forEach(function(chk){
				chkOptions += '<option value="' + chk.chkNum + '">' + chk.chkNum + '</option>';
			});

			$('#ptChkSelect').html(chkOptions);

			//환자 진료번호 입력하기
			getSelect();
			//병원 정보 함수 호출
			getHos();
			//환자 서류 리스트 함수 호출
			getDoclist(target);
		},
		error: function(){
			simpleJustErrorAlert();
		}
	});

}

function getSelect(){
	let select = $("#ptChkSelect").val();
}

function getHos(){//병원 정보
	$.ajax({
		url: '/hospital/document/hospitalInfo',
		type:'get',
		dataType:'json',
		success:function(result){
			$("#name8").val(result.hiNm);
			$("#addr8").val(result.hiAddr+", "+result.hiDaddr);
			$("#tel8").val(result.hiPhone);
			$("#email8").val(result.hiEml);
			$("#num8").val(result.hiBrno);
		},
		error: function(){
			simpleJustErrorAlert();
		}
	});
}

function getDoclist(target){ //환자 서류 리스트

	const ptNum = target.dataset.ptnum;
	$.ajax({
		url: "/hospital/document/doclist?ptNum=" + ptNum,
		contentType:"application/json;charset=utf-8",
		type:"get",
		dataType:"json",
		success:function(result){

			let str="";

			$.each(result,function(index,docVO) {
				if(docVO.chkNum==null){
					docVO.chkNum="";
				}
				let docSavePath = docVO.docSavePath;
				docSavePath = docSavePath.substring(docSavePath.indexOf('\\resources'));
				docSavePath = docSavePath.replace(/\\/g, '/');

				str += "<tr class='doclist'>";
				str+="<td data-price='" + docVO.docIssuePrice + "' data-name='" + docVO.docName + "'>"+docVO.docIssueNum+"</td><br>";
				//str+="<td>"+docVO.ptNum+"</td><br>";
				//str+="<td>"+docVO.docNum+"</td><br>";
				str+="<td>"+docVO.docName+"</td><br>";
				str+="<td>"+docVO.docIssueReason+"</td><br>";
				str+="<td>"+dateFormat(new Date(docVO.docIssueDt))+"</td><br>";
				str+="<td>"+docVO.chkNum+"</td><br>";
				str+="<td class='align-middle'>";
				str+="<button type='button' class='docShowButton btn btn-success m-0 mx-auto d-flex justify-content-center align-items-center' data-path='" + docSavePath + "' style='width: 28px; height: 28px;'>";
				str+="<i class='fa-solid fa-magnifying-glass'></i>";
				str+="</button>";
				str+="</td>"
				str += "</tr>";
			});
            $("#docSearchlist").html(str);
		},
		error: function(){
			simpleJustErrorAlert();
		}
	});
}

//위에 new Date 함수
function dateFormat(mydate){
	   let month = (mydate.getMonth()+1);
	   month = month < 10 ? "0" + month : month;
	   let day = mydate.getDate();
	   day = day < 10 ? "0" + day : day;

	   return mydate.getFullYear() + "-" + month + "-" + day;
}

//pdf 열도록 하는 함수
function openPdfViewer(target){
	const targetUrl = $(target).data('path');
	window.open(targetUrl,'pdf','width=700px','height=800px','scrollbars=yes');
}

// 서류 검색에서 서류 보기 버튼
$(document).on('click', '.docShowButton', function(e){
	e.stopPropagation();
	const path = $(this).data('path');
	window.open('/resources/document/pdfjs/web/viewer.html?file=' + path,'pdf','width=700px,height=800px,scrollbars=yes');
});
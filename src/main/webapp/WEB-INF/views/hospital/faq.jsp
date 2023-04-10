<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<script
	src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.js"></script>
<link
	href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.css"
	rel="stylesheet">
<script src="/resources/summernote/lang/summernote-ko-KR.js"></script>


<style>
/* chatCss */
#chatButton {
	padding-right: 1.25rem;
}

.navbar-badge {
	top: 5px;
}
/* **************************** */
.tableHead {
	position: sticky;
	top: -0.1px;
	background-color: whitesmoke;
}

#tabCardSelected::-webkit-scrollbar-thumb {
	background-color: #404b57;
	border-radius: 5px;
}

#tabCardSelected::-webkit-scrollbar-track {
	background-color: rgba(0, 0, 0, 0);
}

#tabCardSelected::-webkit-scrollbar {
	width: 10px;
	height: 10px;
}

#faqList {
	cursor: pointer;
}

.table {
	font-size: 12pt;
}

.cancel {
	cursor: pointer;
	font-weight: bold;
	color: blue;
}

td {
	vertical-align: middle !important;
}

.navbar-light .navbar-nav .nav-link {
	color: #f8f9fa;
	margin-left: 0.5rem;
	height: 38px;
	padding: 0.25rem;
	display: flex;
	align-items: center;
}

.selectCss, thead {
	font-family: 'Noto Sans KR', sans-serif !important;
	font-weight: 700;
}

.violetBtn {
	background-color: #904aff;
	border: none;
	font-family: 'Noto Sans KR', sans-serif !important;
	font-weight: 500;
	color: white;
}

.violetBtn:hover {
	background-color: #7c3dde !important;
	border: none;
	color: white;
}

.redBtn {
	background-color: #FF5252;
	border: none;
	font-family: 'Noto Sans KR', sans-serif !important;
	font-weight: 500;
	color: white;
}

.redBtn:hover {
	background-color: #e13636 !important;
	border: none;
	color: white;
}
</style>


<script type="text/javascript">
$(function(){

	//최초실행 시작///////////////////////////////////////////////////////
	console.log("최초실행 나와따.");

	let keyword = $("input[name='keyword']").val();
	let faqTypeKeyword= $("#faqTypeKeyword").val();
//		let faqTypeKeyword= $("#faqTypeKeyword").children("option:seleted").text();

	console.log("keyword :", keyword, ", faqTypeKeyword :",faqTypeKeyword);

	let data = {"keyword":keyword, "faqType":faqTypeKeyword};

	console.log("data",data);

	$.ajax({
		url:"/hospital/site/faqInfo/getSearchList",
		contentType : "application/json;charset=utf-8",
		data : JSON.stringify(data),
		type : "post",
		beforeSend : function(xhr) {
	           xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
		},
		success:function(result){

			//성공시 검색 창과 분류에 선택한 값 넣기
			console.log("result.faqTitle :",result.faqTitle,", result.faqType :",result.faqType);
			$("#keyword").val(keyword);
			$("#faqTypeKeyword").val(result.faqType);

			//result.content : List<FaqVO>
			console.log("result.content : " + JSON.stringify(result.content));
			console.log("result.currentPage : " + JSON.stringify(result.currnetPage));

			let str = "";
			let pagingStr = "";

			//리스트 반복문으로 만들기
			$.each(result.content,function(index,faqVO){
				str += "<tr class='faqListTr' data-faq-num='"+faqVO.faqNum+"' id='"+faqVO.faqNum+
					"' data-faq-content='"+faqVO.faqContent+"'><td class='faqNumTd'>"+faqVO.faqNum+
					"</td><td class='faqTypeTd'>"+faqVO.faqType+"</td><td class='faqTitleTd'>"+faqVO.faqTitle+
					"</td><td class='faqDtTd'>"+faqVO.faqDt+"</td></tr>";
			});

			$("#faqList").html(str);


			//"total":124,"currentPage":1,"totalPages":13,"startPage":1,"endPage":5,"blockSize":5,"content"
//				console.log("result : " + JSON.stringify(result));
//				console.log("result.startPage : " + JSON.stringify(result.startPage));

			//페이징 처리 시작
			pagingStr += "<ul class='pagination'>";
			pagingStr += "<li class='page-item";
			if(result.startPage <= 1){
				pagingStr += " disabled";
			}
			pagingStr += "'><a style='border-radius:20px; margin:0px 5px;' class='page-link' href='#' onclick='pageClick("+(result.startPage - 1)+",\""+keyword+"\",\""+faqTypeKeyword+"\")'>";
			pagingStr += "<<</a></li>";


//				console.log("result.endPage : " + JSON.stringify(result.endPage));
//				console.log("result.currentPage : " + JSON.stringify(result.currentPage));
//				//반복문 시작
			for(let i=result.startPage; i<=result.endPage; i++){
//					console.log("i :",i);
				pagingStr +="<li class='page-item";
				if(result.currentPage == i){
					pagingStr +=" active";
				}
				pagingStr +="' data-page='"+i+"'>";
				console.log("keyword:",keyword,",faqTypeKeyword :",faqTypeKeyword);
				pagingStr +="<a style='border-radius:50%; margin:0px 5px;' class='page-link' href='#' onclick='pageClick("+i+",\""+$("#keyword").val()+"\",\""+$("#faqTypeKeyword").val()+"\")'";
				pagingStr +=">"+i+"</a></li>";

			}

//				//반복문 끝

			pagingStr += "<li class='page-item";
			if(result.totalPages <= result.endPage){
			pagingStr += " disabled";

			}

			pagingStr += "'><a style='border-radius:20px; margin:0px 5px;' class='page-link' href='#' onclick='pageClick("+(result.startPage + 5)+",\""+keyword+"\",\""+faqTypeKeyword+"\")'>";
			pagingStr += ">></a></li>";
			pagingStr += "</ul>";
			//페이징 처리 끝

			$("#paging").html(pagingStr);
			if(result.total ==0){
				str += "<tr'><td colspan=4>관련 게시글은 없습니다.</td></tr>";
				$("#faqList").html(str);
				$("#paging").html("");
			}
		}

	});
	//최초실행 끝///////////////////////////////////////////////////////

	//검색 클릭 시 관련 키워드, 분류 타입 선택가져와 페이징하기
	$("#faqSearchBtn").on("click", function(){
		console.log("나와따.");
		//상세조회는 초기화===================================================================
		$("#faqTitle").val("");
		$("#faqType").val("제증명");
		$("#faqContent").val("");

		$("#faqTitle").prop("readonly",false);
		$("#faqType").prop("disabled",false);
		$("#faqContent").summernote('reset');
		$("#faqContent").summernote('enable');


		let keyword = $("input[name='keyword']").val();
		let faqTypeKeyword= $("#faqTypeKeyword").val();
// 		let faqTypeKeyword= $("#faqTypeKeyword").children("option:seleted").text();

		console.log("keyword :", keyword, ", faqTypeKeyword :",faqTypeKeyword);

		let data = {"keyword":keyword, "faqType":faqTypeKeyword};

		console.log("data",data);

		$.ajax({
			url:"/hospital/site/faqInfo/getSearchList",
			contentType : "application/json;charset=utf-8",
			data : JSON.stringify(data),
			type : "post",
			beforeSend : function(xhr) {
		           xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
			},
			success:function(result){

				//성공시 검색 창과 분류에 선택한 값 넣기
				console.log("result :",result);

				let str = "";

				console.log("result.faqTitle :",result.faqTitle,", result.faqType :",result.faqType);
				$("#keyword").val(keyword);
				$("#faqTypeKeyword").val(result.faqType);

/*
{"faqNum":124,"faqType":"외래","faqTitle":"sdfs","faqContent":"<p>sdfsdfsd</p>"
	,"faqDt":"2023-03-25 17:08:54.0","keyword":null,"currentPage":0,"size":0},
{"faqNum":123,"faqType":"제증명","faqTitle":"sdfs","faqContent":"<p>sdfsdfs</p>"
		,"faqDt":"2023-03-25 17:02:31.0","keyword":null,"currentPage":0,"size":0},
{"faqNum":122,"faqType":"외래","faqTitle":"sdfsdfs","faqContent":"<p>dsdfsdfsdfs</p>"
			,"faqDt":"2023-03-25 17:02:05.0","keyword":null,"currentPage":0,"size":0}
*/
				//result.content : List<FaqVO>
				console.log("result.content : " + JSON.stringify(result.content));
				console.log("result.currentPage : " + JSON.stringify(result.currnetPage));

				let pagingStr = "";

				//리스트 반복문으로 만들기
				$.each(result.content,function(index,faqVO){
					str += "<tr class='faqListTr' data-faq-num='"+faqVO.faqNum+"' id='"+faqVO.faqNum+
						"' data-faq-content='"+faqVO.faqContent+"'><td class='faqNumTd'>"+faqVO.faqNum+
						"</td><td class='faqTypeTd'>"+faqVO.faqType+"</td><td class='faqTitleTd'>"+faqVO.faqTitle+
						"</td><td class='faqDtTd'>"+faqVO.faqDt+"</td></tr>";
				});

				$("#faqList").html(str);


				//"total":124,"currentPage":1,"totalPages":13,"startPage":1,"endPage":5,"blockSize":5,"content"
// 				console.log("result : " + JSON.stringify(result));
// 				console.log("result.startPage : " + JSON.stringify(result.startPage));

				//페이징 처리 시작
				pagingStr += "<ul class='pagination'>";
				pagingStr += "<li class='page-item";
				if(result.startPage <= 1){
					pagingStr += " disabled";
				}
				pagingStr += "'><a style='border-radius:20px; margin:0px 5px;' class='page-link' href='#' onclick='pageClick("+(result.startPage - 1)+",\""+keyword+"\",\""+faqTypeKeyword+"\")'>";
				pagingStr += "Prev</a></li>";


// 				console.log("result.endPage : " + JSON.stringify(result.endPage));
// 				console.log("result.currentPage : " + JSON.stringify(result.currentPage));
// 				//반복문 시작
				for(let i=result.startPage; i<=result.endPage; i++){
// 					console.log("i :",i);
					pagingStr +="<li class='page-item";
					if(result.currentPage == i){
						pagingStr +=" active";
					}
					pagingStr +="' data-page='"+i+"'>";
					console.log("keyword:",keyword,",faqTypeKeyword :",faqTypeKeyword);
					pagingStr +="<a style='border-radius:50%; margin:0px 5px;' class='page-link' href='#' onclick='pageClick("+i+",\""+$("#keyword").val()+"\",\""+$("#faqTypeKeyword").val()+"\")'";
					pagingStr +=">"+i+"</a></li>";

				}

// 				//반복문 끝

				pagingStr += "<li class='page-item";
				if(result.totalPages <= result.endPage){
				pagingStr += " disabled";

				}

				pagingStr += "'><a style='border-radius:20px; margin:0px 5px;' class='page-link' href='#' onclick='pageClick("+(result.startPage + 5)+",\""+keyword+"\",\""+faqTypeKeyword+"\")'>";
				pagingStr += "Next</a></li>";
				pagingStr += "</ul>";
				//페이징 처리 끝

				$("#paging").html(pagingStr);
				if(result.total ==0){
					str += "<tr'><td colspan=4>관련 게시글은 없습니다.</td></tr>";
					$("#faqList").html(str);
					$("#paging").html("");
				}
			}

		});
	});


	//tr 클릭시 상세 조회 읽기 전용으로
	$(document).on("click",".faqListTr",function(){

		//클릭하는 순간 faq-num 제목 data에 담기
		let faqNum = $(this).data("faq-num");
		console.log("faqNum : " + faqNum);
// 		$("#faqType").data("faq-num",faqNum);
// 		console.log('$("#faqType").data("faq-num") : ' + $("#faqType").data("faq-num"));
		$('.faqListTr').children('td').css({'background-color' : '', 'color' : ''});
		$(this).children('td').css({'background-color' : 'rgb(101, 125, 150)', 'color' : 'white'});
		let data = {"faqNum":faqNum};

		//클릭시 선택된 녀석의 1건의 데이터를 가지고 와서 우측 화면에 주입하기..
		$.ajax({
			url:"/hospital/site/faqInfo/getInfo",
			contentType : "application/json;charset=utf-8",
			data : JSON.stringify(data),
			type : "post",
			beforeSend : function(xhr) {
		           xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
			},
			success:function(result){
				console.log("result : ", result);
				console.log("result.faqTitle : ", result.faqTitle);
				console.log("result.faqType : ", result.faqType);





				//#faqBoard
				str = '';
				str += '<div class="form-group">';
				str += '	<label for="faqTitle">제목</label>';
				str += '	<input type="text" data-faq-num="'+result.faqNum+'" class="form-control" id="faqTitle" name="faqTitle" placeholder="제목을 입력해주세요." value="'+result.faqTitle+'" />';
				str += '</div>';
				str += '<div class="form-group">';
				str += '	<label>분류</label>';
				str += '	<div class="row">';
				str += '		<div class="col-sm-3">';
				str += '			<select id="faqType" name="faqType" class="custom-select rounded-10">';

				str += '				<option value="제증명" ' +  ("제증명" == result.faqType ? 'selected="selected"' : "") + '>제증명</option>';
				str += '				<option value="외래" ' +  ("외래" ==  result.faqType ? 'selected="selected"' : "") + '>외래</option>';
				str += '				<option value="기타"' +  ("기타" ==  result.faqType ? 'selected="selected"' : "") + '>기타</option>';

				str += '			</select>';
				str += '		</div>';
				str += '	</div>';
				str += '</div>';
				str += '<div class="form-group">';
				str += '	<label for="faqContent">내용</label><span id="numAndDate"></span>';
				str += '	<textarea class="form-control" id="faqContent" name="faqContent" style="display: none;"></textarea>';
				str += '</div>';


				$("#faqBoard").html(str);

				$('#faqContent').summernote({
				    width: 870,
					height: 355,                 // 에디터 높이
				      minHeight: 355,             // 최소 높이
				      maxHeight: 500,             // 최대 높이
				      focus: false,                  // 에디터 로딩후 포커스를 맞출지 여부
				      lang: "ko-KR",					// 한글 설정
				});

				$("#faqContent").summernote( 'code', result.faqContent );

				//모드 선택
	 			$("#insertMode").css("display","none");
	 			$("#updateBtnMode").css("display","block");
	 			$("#deleteBtnMode").css("display","block");
	 			$("#updatetMode").css("display","none");
	 			$("#cleanMode").css("display","block");
	 			//읽기 전용
	 			$("#faqContent").summernote('disable');
				$("#faqType").prop("disabled",true);
				$("#faqTitle").prop("readonly",true);
			}
		});


	});


	//수정하기 버튼 클릭 시
	$("#updateFaq").on("click",function(){
		$("#faqTitle").prop("readonly",false);
		$("#faqType").prop("disabled",false);
		$("#faqContent").summernote('enable');

		//모드 선택
		$("#insertMode").css("display","none");
		$("#updateBtnMode").css("display","none");
		$("#deleteBtnMode").css("display","none");
		$("#updatetMode").css("display","block");
		$("#cleanMode").css("display","none");

	});

	//등록하기 클릭 시 등록하기 / /hospital/site/faqInfo/insertFaq
	$("#insertFaq").on("click",function(){

		let faqTitle = $("#faqTitle").val();
		let faqType = $("#faqType").val();
		let faqContent = $("#faqContent").val();
		let faqNum = $("#faqTitle").data("faq-num");

		if(faqTitle==""||faqTitle==null){
			setTimeout(() => simpleErrorAlert('제목을 입력해주세요.'), 100);
			$("#faqTitle").focus();
			return;
		};
		if(faqType==""||faqType==null){
			setTimeout(() => simpleErrorAlert('분류를 선택해주세요.'), 100);
			$("#faqType").focus();
			return;
		};
		if(faqContent==""||faqContent==null){
			setTimeout(() => simpleErrorAlert('내용을 입력해주세요.'), 100);
			$("#faqContent").focus();
			return;
		};




// 		console.log("faqNum : " + faqNum);

		let data = {
					"faqType":faqType,
					"faqTitle":faqTitle,
					"faqContent":faqContent
		}
		console.log(JSON.stringify(data));

		$.ajax({
			url:"/hospital/site/faqInfo/insertFaq",
			contentType : "application/json;charset=utf-8",
			data : JSON.stringify(data),
			type : "post",
			beforeSend : function(xhr) {
		           xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
			},
			success:function(result){
				console.log("result : ",result);

				$('#faqSearchBtn').click();


				$("#faqTitle").prop("readonly",false);
				$("#faqType").prop("disabled",false);
				$("#faqContent").summernote('enable');

				//모드 선택
				$("#insertMode").css("display","block");
				$("#updateBtnMode").css("display","none");
				$("#deleteBtnMode").css("display","none");
				$("#updatetMode").css("display","none");
				$("#cleanMode").css("display","none"); // 비우기 버튼도 숨김

				simpleSuccessAlert('성공적으로 등록되었습니다.');



			}
		});
	});

	//확인 버튼 클릭 시
	$("#checkFaq").on("click",function(){
// 		const frm = $("form[name=faqForm]");
// 		frm.attr("action","/hospital/site/faqInfo/updateFaq?${_csrf.parameterName}=${_csrf.token}");


		let faqTitle = $("#faqTitle").val();
		let faqType = $("#faqType").val();
		let faqContent = $("#faqContent").val();
		let faqNum = $("#faqTitle").data("faq-num");

		console.log("faqNum : " + faqNum);

		let data = {
					"faqNum":faqNum,
					"faqType":faqType,
					"faqTitle":faqTitle,
					"faqContent":faqContent
		}

		console.log("data : " + JSON.stringify(data));

		$.ajax({
			url:"/hospital/site/faqInfo/updateFaq",
			contentType : "application/json;charset=utf-8",
			data : JSON.stringify(data),
			type : "post",
			beforeSend : function(xhr) {
		           xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
			},
			success:function(result){
				console.log("type", result.faqType);
				console.log(result);
				var ddddd = "제증명" == result.faqType ? 'selected="selected"' : "";

				//faqNumTd faqTypeTd faqTitleTd faqDtTd
// 				let dataFaqNumTr = $(".faqListTr").data("faq-num");
				let dataFaqNum = $("#faqTitle").data("faq-num");
				let dataFaqNumTr = $("#"+dataFaqNum);
				console.log("dataFaqNumTr :",dataFaqNumTr);
				console.log("dataFaqNum :",dataFaqNum);

				dataFaqNumTr.children().eq(1).html(result.faqType);
				dataFaqNumTr.children().eq(2).html(result.faqTitle);


				$("#faqNumTd").html(result.faqNum);
				$("#faqTypeTd").html(result.faqType);
				$("#faqTitleTd").html(result.faqTitle);
				$("#faqDtTd").html(result.faqDt);

				//상세조회 리스트에 넣기 / #faqBoard
				str = '';
				str += '<div class="form-group">';
				str += '	<label for="faqTitle">제목</label>';
				str += '	<input type="text" data-faq-num="'+result.faqNum+'" class="form-control" id="faqTitle" name="faqTitle" placeholder="제목을 입력해주세요." value="'+result.faqTitle+'" />';
				str += '</div>';
				str += '<div class="form-group">';
				str += '	<label>분류</label>';
				str += '	<div class="row">';
				str += '		<div class="col-sm-3">';
				str += '			<select id="faqType" name="faqType" class="custom-select rounded-10">';

				str += '				<option value="제증명" ' +  ("제증명" == result.faqType ? 'selected="selected"' : "") + '>제증명</option>';
				str += '				<option value="외래" ' +  ("외래" ==  result.faqType ? 'selected="selected"' : "") + '>외래</option>';
				str += '				<option value="기타"' +  ("기타" ==  result.faqType ? 'selected="selected"' : "") + '>기타</option>';

				str += '			</select>';
				str += '		</div>';
				str += '	</div>';
				str += '</div>';
				str += '<div class="form-group">';
				str += '	<label for="faqContent">내용</label><span id="numAndDate"></span>';
				str += '	<textarea class="form-control" id="faqContent" name="faqContent" style="display: none;"></textarea>';
				str += '</div>';


				$("#faqBoard").html(str);

				$('#faqContent').summernote({
				    width: 950,
					height: 355,                 // 에디터 높이
				      minHeight: 355,             // 최소 높이
				      maxHeight: 500,             // 최대 높이
				      focus: false,                  // 에디터 로딩후 포커스를 맞출지 여부
				      lang: "ko-KR",					// 한글 설정
				});

				$("#faqContent").summernote( 'code', result.faqContent );

				//읽기전용
				$("#faqTitle").prop("readonly",true);
				$("#faqType").prop("disabled",true);
				$("#faqContent").summernote('disable');


				//모드 선택
				$("#insertMode").css("display","none");
				$("#updateBtnMode").css("display","block");
				$("#deleteBtnMode").css("display","block");
				$("#updatetMode").css("display","none");
				$("#cleanMode").css("display","block");

				simpleSuccessAlert('성공적으로 수정되었습니다.');
				$('#faqSearchBtn').click();

			}
		});


		//읽기전용
		$("#faqTitle").prop("readonly",true);
		$("#faqType").prop("disabled",true);
		$("#faqContent").summernote('disable');


		//모드 선택
		$("#insertMode").css("display","none");
		$("#updateBtnMode").css("display","block");
		$("#deleteBtnMode").css("display","block");
		$("#updatetMode").css("display","none");
	});

	//취소 클릭 시
	$("#cancelFaq").on("click",function(){
		//읽기전용
		$("#faqTitle").prop("readonly",true);
		$("#faqType").prop("disabled",true);
		$("#faqContent").summernote('disable');


		//모드 선택
		$("#insertMode").css("display","none");
		$("#updateBtnMode").css("display","block");
		$("#deleteBtnMode").css("display","block");
		$("#updatetMode").css("display","none");
	});


	//비우기 클릭 시
	$("#cleanFaq").on("click",function(){

		$('.faqListTr').children('td').css({'background-color' : '', 'color' : ''});

		//내용 비우기
		$("#faqContent").summernote('reset');
		$("#faqTitle").val("");
		$("#faqType").val("제증명");

		//모드 선택
		$("#insertMode").css("display","block");
		$("#updateBtnMode").css("display","none");
		$("#deleteBtnMode").css("display","none");
		$("#updatetMode").css("display","none");
		$("#cleanMode").css("display","none"); // 비우기 버튼도 숨김

		//쓰기전용
		$("#faqTitle").prop("readonly",false);
		$("#faqType").prop("disabled",false);
		$("#faqContent").summernote('enable');
	});

	//삭제하기 클릭 시
	$("#deleteFaq").on("click",function(){
		let faqNum = $("#faqTitle").data("faq-num");
		console.log("faqNum : " ,faqNum);

		let data = {"faqNum":faqNum};
		$.ajax({
			url:"/hospital/site/faqInfo/deleteFaq",
			contentType : "application/json;charset=utf-8",
			data : JSON.stringify(data),
			type : "post",
			beforeSend : function(xhr) {
		           xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
			},
			success:function(result){
				console.log("result : ",result);



				//내용 비우기
				$('#faqContent').summernote({
				    width: 950,
					height: 355,                 // 에디터 높이
				      minHeight: 355,             // 최소 높이
				      maxHeight: 500,             // 최대 높이
				      focus: false,                  // 에디터 로딩후 포커스를 맞출지 여부
				      lang: "ko-KR",					// 한글 설정
				      placeholder: '내용을 입력해주세요.'	//placeholder 설정

				});

				$("#faqContent").summernote('reset');
				$("#faqTitle").val("");
				$("#faqType").val("제증명");

				//쓰기전용
				$("#faqTitle").prop("readonly",false);
				$("#faqType").prop("disabled",false);
				$("#faqContent").summernote('enable');

				$("[data-faq-num='"+faqNum+"']").empty();
				simpleSuccessAlert('성공적으로 삭제되었습니다.');
				//모드 변경
				$("#insertMode").css("display","block");
				$("#updateBtnMode").css("display","none");
				$("#deleteBtnMode").css("display","none");
				$("#updatetMode").css("display","none");
				$("#cleanMode").css("display","none"); // 비우기 버튼도 숨김

				$('#faqSearchBtn').click();
			}
		});
	});
});

//keyword, type 가져와서
function pageClick(currentPage, keyword, faqType){
	//1) currentPage : 2 , keyword :  , faqType :
	//2) currentPage : 3 , keyword :  , faqType : [object HTMLSelectElement]
	console.log("currentPage :",currentPage,", keyword :",keyword,", faqType :", faqType);
	console.log("찍었다.");

	$("input[name='keyword']").val(keyword);
	$("#faqTypeKeyword").val(faqType);

	let data = {"currentPage":currentPage, "keyword":keyword, "faqType":faqType};

	console.log("data",JSON.stringify(data));

	$.ajax({
		url:"/hospital/site/faqInfo/getSearchList",
		contentType : "application/json;charset=utf-8",
		data : JSON.stringify(data),
		type : "post",
		beforeSend : function(xhr) {
	           xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
		},
		success:function(result){


/*
{"faqNum":124,"faqType":"외래","faqTitle":"sdfs","faqContent":"<p>sdfsdfsd</p>"
,"faqDt":"2023-03-25 17:08:54.0","keyword":null,"currentPage":0,"size":0},
{"faqNum":123,"faqType":"제증명","faqTitle":"sdfs","faqContent":"<p>sdfsdfs</p>"
	,"faqDt":"2023-03-25 17:02:31.0","keyword":null,"currentPage":0,"size":0},
{"faqNum":122,"faqType":"외래","faqTitle":"sdfsdfs","faqContent":"<p>dsdfsdfsdfs</p>"
		,"faqDt":"2023-03-25 17:02:05.0","keyword":null,"currentPage":0,"size":0}
*/
			//result.content : List<FaqVO>
			console.log("result.content : " + JSON.stringify(result.content));
			console.log("result.currentPage : " + JSON.stringify(result.currnetPage));

			let str = "";
			let pagingStr = "";

			//리스트 반복문으로 만들기
			$.each(result.content,function(index,faqVO){
				str += "<tr class='faqListTr' data-faq-num='"+faqVO.faqNum+"' id='"+faqVO.faqNum+
					"' data-faq-content='"+faqVO.faqContent+"'><td class='faqNumTd'>"+faqVO.faqNum+
					"</td><td class='faqTypeTd'>"+faqVO.faqType+"</td><td class='faqTitleTd'>"+faqVO.faqTitle+
					"</td><td class='faqDtTd'>"+faqVO.faqDt+"</td></tr>";
			});

			$("#faqList").html(str);


			//"total":124,"currentPage":1,"totalPages":13,"startPage":1,"endPage":5,"blockSize":5,"content"
			console.log("result : " + JSON.stringify(result));
			console.log("result.startPage : " + JSON.stringify(result.startPage));

			//페이징 처리 시작
			pagingStr += "<ul class='pagination'>";
			pagingStr += "<li class='page-item";
			if(result.startPage <= 1){
				pagingStr += " disabled";
			}
			pagingStr += "'><a style='border-radius:20px; margin:0px 5px;' class='page-link' href='#' onclick='pageClick("+(result.startPage - 1)+",\""+keyword+"\",\""+faqTypeKeyword+"\")'>";
			pagingStr += "<<</a></li>";


			console.log("result.endPage : " + JSON.stringify(result.endPage));
			console.log("result.currentPage : " + JSON.stringify(result.currentPage));
//				//반복문 시작
			for(let i=result.startPage; i<=result.endPage; i++){
//					console.log("i :",i);
				pagingStr +="<li class='page-item";
				if(result.currentPage == i){
					pagingStr +=" active";
				}
				pagingStr +="' data-page='"+i+"'>";
// 				console.log("keyword:",$("#keyword").val(),",faqTypeKeyword(개똥이) :",$("#faqTypeKeyword").val());
				pagingStr +="<a style='border-radius:50%; margin:0px 5px;' class='page-link' href='#' onclick='pageClick("+i+",\""+$("#keyword").val()+"\",\""+$("#faqTypeKeyword").val()+"\")'";
				pagingStr +=">"+i+"</a></li>";

			}

//				//반복문 끝

			pagingStr += "<li class='page-item ";
			if(result.totalPages <= result.endPage){
			pagingStr += " disabled";

			}

			pagingStr += "'><a style='border-radius:20px; margin:0px 5px;' class='page-link' href='#' onclick='pageClick("+(result.startPage + 5)+",\""+keyword+"\",\""+faqTypeKeyword+"\")'>";
			pagingStr += ">></a></li>";
			pagingStr += "</ul>";
			//페이징 처리 끝

			$("#paging").html(pagingStr);
			if(result.total ==0){
				str += "<tr'><td colspan=4>관련 게시글은 없습니다.</td></tr>";
				$("#faqList").html(str);
				$("#paging").html("");
			}
		}

	});

};

</script>

<!-- main 검색창을 포함한 navbar 시작-->
<div class="content-wrapper"
	style="background-color: rgb(101, 125, 150); min-height: 873px;">
	<nav class="navbar navbar-expand navbar-white navbar-light"
		style="background-color: #404b57;">

		<div class="input-group" style="width: 68%;">
			<div class="dropdown">
				<!-------------------- 검색대 -------------------->
				<input type="text" class="form-control" id="keyword" name="keyword"
					placeholder="찾으시는 게시글을 입력하세요." style="width: 400px;">
				<ul id="ptSearchDropdown" class="dropdown-menu">
				</ul>
				<!-------------------- 검색대 -------------------->
			</div>
			<div class="input-group-append">
				<button type="button" class="btn btn-outline-light"
					id="faqSearchBtn" name="faqSearchBtn">검색</button>
				<!-- 				<button type="button" class="btn btn-outline-light" id="list" name="list">검색</button> -->
				<!-- 		<button type="button" class="btn btn-md btn-default" id="faqSearchBtn" name="faqSearchBtn"><i class="fas fa-fw fa-search" aria-hidden="true"></i></button> -->
			</div>
		</div>
		<ul class="navbar-nav ml-auto"></ul>
		<div class="menu">
			<ul class="navbar-nav mb-0">
				<li class="nav-item"><a class="nav-link btn btn-outline-light"
					href="/hospital/site/communityInfo">커뮤니티 관리</a></li>
				<li class="nav-item"><a class="nav-link btn btn-outline-light"
					href="/hospital/site/bannerInfo">배너 관리</a></li>
				<li class="nav-item"><a class="nav-link btn btn-outline-light"
					href="/hospital/site/doctorIntro">의사 소개 관리</a></li>
				<li class="nav-item"><a
					class="nav-link btn btn-outline-light active"
					href="/hospital/site/faqInfo">자주 묻는 질문 관리</a></li>
			</ul>
		</div>
	</nav>



	<!-- main 검색창을 포함한 navbar 끝 -->
	<section class="content" style="margin-top: 1%;">
		<!-- 자주 묻는 질문 시작 -->
		<div class="row">
			<div class="col-lg-6">
				<div class="card card-info menuDiv" style="height: 98%;">
					<div class="card-header" style="background-color: #404b57;">
						<div class="row">
							<div class="col-sm-3">
								<h3 class="card-title" style="color: white; padding-top: 9px;">자주
									묻는 질문 List</h3>
							</div>
							<div class="col-sm-6"></div>
							<div class="col-sm-3" style="float: right;">
								<select id="faqTypeKeyword" name="faqTypeKeyword"
									class="custom-select rounded-10 selectCss">
									<option value="">전체</option>
									<option value="제증명">제증명</option>
									<option value="외래">외래</option>
									<option value="기타">기타</option>
								</select>
							</div>
						</div>
					</div>

					<!-- 자주 묻는 질문 테이블 시작 -->
					<div class="card-body table-responsive p-0"
						style="height: 600px; border-bottom: 20px; overflow-x: hidden;"
						id="tabCardSelected">
						<div id="example2_wrapper"
							class="dataTables_wrapper dt-bootstrap4">
							<!-- ajax를 통해서 매너 이미지를 로딩 시 바로 보임 -->
							<div class="row" id="menu_wrap" style="padding: 15px;">
								<div id="example2_wrapper"
									class="dataTables_wrapper dt-bootstrap4">
									<div class="row">
										<div class="col-sm-12">
											<table id="table table-hover text-nowrap"
												class="table table-bordered table-hover dataTable dtr-inline text-center"
												aria-describedby="example2_info"
												style="table-layout: fixed;">
												<thead class="tableHead text-center">
													<tr>
														<th style="width: 9%;">번호</th>
														<th style="width: 9%;">분류</th>
														<th style="width: 15%;">제목</th>
														<th style="width: 10%;">작성 일</th>
													</tr>
												</thead>
												<tbody id="faqList">
													<c:forEach var="faqVO" items="${faqList}" varStatus="stat">
														<c:if test="${faqNum==faqVO.faqNum}">
															<tr class="faqListTr insertActive"
																data-faq-num="${faqVO.faqNum}" id="${faqVO.faqNum}"
																data-faq-content="${faqVO.faqContent}">
														</c:if>
														<c:if test="${faqNum!=faqVO.faqNum}">
															<tr class="faqListTr" data-faq-num="${faqVO.faqNum}"
																id="${faqVO.faqNum}"
																data-faq-content="${faqVO.faqContent}">
														</c:if>

														<td style="">${faqVO.faqNum}</td>
														<td style="">${faqVO.faqType}</td>
														<td style="">${faqVO.faqTitle}</td>
														<td style=""><fmt:formatDate value="${faqVO.faqDt}"
																pattern="yyyy-MM-dd" /></td>
														</tr>
													</c:forEach>

												</tbody>
											</table>
										</div>
									</div>
								</div>
								<!-- 자주 묻는 질문 테이블 끝 -->

								<!-- footer에 페이징 -->

							</div>
						</div>
					</div>

					<!-- footer 시작 -->
					<div class="card-footer justify-content-between align-items-center"
						style="text-align: center; background-color: white; margin: 0 auto;">
						<nav
							class="paginationBtn justify-content-between align-items-center"
							style="text-align: center; background-color: white;"
							aria-label="Page navigation example" id="paging">
							<!-- /////////////// 페이징 시작/////////////////// -->
							<ul class="pagination">
								<li class="page-item disabled "><a class="page-link"
									href="/ddit/notice?currentPage=0">Prev</a></li>
								<li class="page-item  active "><a class="page-link"
									href="/ddit/notice?currentPage=1">1</a></li>
								<li class="page-item"><a class="page-link"
									href="/ddit/notice?currentPage=2">2</a></li>
								<li class="page-item"><a class="page-link"
									href="/ddit/notice?currentPage=3">3</a></li>
								<li class="page-item "><a class="page-link"
									href="/ddit/notice?currentPage=4">4</a></li>
								<li class="page-item "><a class="page-link"
									href="/ddit/notice?currentPage=5">5</a></li>
								<li class="page-item"><a class="page-link"
									href="/ddit/notice?currentPage=6">Next</a></li>
							</ul>
						</nav>
						<!-- /////////////// 페이징 끝/////////////////// -->
					</div>

					<!-- footer  끝 -->


				</div>
			</div>
			<!-- 문의글 상세조회 -->
			<div class="col-lg-6" style="min-height: 100%;">
				<div class="card card-info" style="min-height: 400px;">
					<div class="card-header" style="background-color: #404b57;">
						<div class="card-title">
							<h4 id="selectedBoardName" class="m-0">자주 묻는 질문 상세</h4>
						</div>
					</div>
					<!-- 자주 묻는 질문 게시글 상세 시작 -->
					<div id="faqBoard" class="card-body boardDiv">
						<div class="form-group">
							<label for="faqTitle">제목</label> <input type="text"
								data-faq-num="" class="form-control" id="faqTitle"
								name="faqTitle" placeholder="제목을 입력해주세요." value="" />
						</div>
						<div class="form-group">
							<label>분류</label>
							<div class="row">
								<div class="col-sm-3">
									<select id="faqType" name="faqType"
										class="custom-select rounded-10">
										<option>제증명</option>
										<option>외래</option>
										<option>기타</option>
									</select>
								</div>
							</div>
						</div>
						<div class="form-group">
							<label for="faqContent">내용</label><span id="numAndDate"></span>
							<textarea class="form-control" id="faqContent" name="faqContent"
								style="display: none;"></textarea>
						</div>
					</div>

					<div class="d-flex align-items-center card-footer boardDiv">

						<!-- 등록하기 모드 시작 -->
						<span id="insertMode">
							<button type="button" class="btn btn-primary btnCss violetBtn"
								style="margin-right: 10px;" id="insertFaq">등록하기</button>
							<button type="button" class="btn btn-success"
								style="	border: none; font-family: 'Noto Sans KR', sans-serif !important; font-weight: 500;"
								onclick="inputTestFaqData();">시연용</button>
						</span>
						<!-- 등록하기 모드 끝 -->
						<!-- 수정버튼 모드 시작 -->
						<span id="updateBtnMode" style="display: none">
							<button type="button" class="btn btn-success btnCss violetBtn"
								style="margin-right: 10px;" id="updateFaq">수정하기</button>
						</span>
						<!-- 수정버튼 모드 끝 -->
						<!-- 삭제하기 모드 시작 -->
						<span id="deleteBtnMode" style="display: none">
							<button type="button" class="btn btn-danger btnCss redBtn"
								style="margin-right: 10px;" id="deleteFaq">삭제하기</button>
						</span>
						<!-- 삭제하기 모드 끝 -->
						<!-- 수정하기 모드 시작 -->
						<span id="updatetMode" style="display: none;">
							<button type="button" class="btn btn-primary btnCss violetBtn"
								style="margin-right: 10px;" id="checkFaq">확인</button>
							<button type="button" class="btn btn-primary btnCss redBtn"
								style="margin-right: 10px;" id="cancelFaq">취소</button>
						</span>
						<!-- 수정하기 모드 끝 -->
						<!-- 비우기 모드 시작 -->
						<span id="cleanMode" style="display: none;">
							<button type="button" class="btn btn-info btnCss redBtn"
								id="cleanFaq">비우기</button>
						</span>
						<!-- 비우기 모드 끝 -->
					</div>
					<!-- 자주 묻는 질문 게시글 상세 끝 -->
				</div>
			</div>
		</div>
		<!-- 자주 묻는 질문 끝 -->


	</section>
</div>

<script src="/resources/js/alertModule.js"></script>
<script>
//서머노트 초기화
$(function(){

	$('#faqContent').summernote({
		height: 355,                 // 에디터 높이
	      minHeight: 355,             // 최소 높이
	      maxHeight: 500,             // 최대 높이
	      focus: false,                  // 에디터 로딩후 포커스를 맞출지 여부
	      lang: "ko-KR",					// 한글 설정
	      placeholder: '내용을 입력해주세요.'	//placeholder 설정

		});

});

// 시연용 데이터 삽입
function inputTestFaqData(){

	$('#faqTitle').val('시연용 질문입니다.');
	$('#faqContent').summernote('code', '<p>405호 프로젝트 시연중입니다.</p>');

}

</script>
<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
#selectBannerImg {
 cursor : pointer;
}

.navbar-light .navbar-nav .nav-link {
	color: #f8f9fa;
	margin-left: 0.5rem;
	height: 38px;
	padding: 0.25rem;
	display: flex;
	align-items: center;
}

.violetBtn:hover{
	background-color:#7c3dde !important;
}

.redBtn:hover{
	background-color:#e13636 !important;
}
</style>


<script type="text/javascript">
$(function(){

	var lineNum = "";

	//미리 이미지 보여주기
	$.ajax({
		url:"/hospital/site/bannerInfo/getImgs",
		type:"get",
		dataType:"json",
		success:function(result){
// 			console.log("result : " , result);
			//result : [
// 			{"bannerNum":1,"bannerNm":"/2023/03/21/084a6176-0dd3-4831-8d54-bbce9b607bb9_a002.jpg"
// 				,"bannerSize":18099,"bannerPath":"/2023/03/21/084a6176-0dd3-4831-8d54-bbce9b607bb9_a002.jpg"
// 				,"bannerThumbnail":"/2023/03/21/s_084a6176-0dd3-4831-8d54-bbce9b607bb9_a002.jpg"}
// 			,{"bannerNum":2,"bannerNm":"/2023/03/21/96c1afc5-fefe-4872-95e2-263aa6155f37_a003.jpg"
// 				,"bannerSize":9451,"bannerPath":"/2023/03/21/96c1afc5-fefe-4872-95e2-263aa6155f37_a003.jpg"
// 				,"bannerThumbnail":"/2023/03/21/s_96c1afc5-fefe-4872-95e2-263aa6155f37_a003.jpg"}
// 			,{"bannerNum":3,"bannerNm":"/2023/03/21/e1867c11-734d-4b72-8d83-74550be60836_a004.jpg"
// 				,"bannerSize":7686,"bannerPath":"/2023/03/21/e1867c11-734d-4b72-8d83-74550be60836_a004.jpg"
// 				,"bannerThumbnail":"/2023/03/21/s_e1867c11-734d-4b72-8d83-74550be60836_a004.jpg"}
// 			console.log("result : " + JSON.stringify(result));


			let str = "";
			let frmNum = "";

			//result : List<BannerVO>
			//data : BannerVO=======================================================
			$.each(result,function(index,data){
				str += "<div class='filtr-item col-sm-2' id='bannerImageDiv'><a data-toggle='lightbox'><img src='"+data.bannerPath+"' id='selectBannerImg'";
				if(data.bannerStatus==1){
					console.log("status가 1인거 : " + data.bannerNum);
// 					str += "style='width:150px;height:150px; border:solid 3px red' class='img-fluid mb-2 click'";
					str += "style='width:200px;height:150px; border:solid 3px red' class='img-fluid mb-2 line'";
					if(frmNum==""){
						frmNum += data.bannerNum;
					}else{
						frmNum += "," + data.bannerNum;
					}
					if(lineNum==""){
						lineNum += data.bannerNum;
					}else{
						lineNum += "," + data.bannerNum;
					}
				}
				if(data.bannerStatus==0){
					str += "style='width:200px;height:150px;' class='img-fluid mb-2'";
				}
				str += "data-no='"+data.bannerNum+"' ></a></div>";


			});
// 			console.log(str);
			console.log(frmNum);
			console.log("lineNum : ", lineNum);


			$("#menu_wrap").html(str);
// 			$("#decisionBannerNum").val(frmNum);
		}
	});


	//미리보기 공간에 넣을 이미지 담을 배열 선언
	let self_file = [];
	$("#input_imgs").on("change",handleImgFileSelect);

	function handleImgFileSelect(e){
// 		console.log("아무거나")
		$(".imgs_wrap").html("");
		//타겟 안의 파일들 가져옴
		let files = e.target.files;
		//파일이 여러 개일 시 분리해서 배열에 넣기
		let fileArr = Array.prototype.slice.call(files);
		//하나씩 이미지인지 확인하고 이미지라면 파일 띄우기(반복문)
		fileArr.forEach(function(f){
			//이미지 파일이 아니라면 미리보기 못함(image/jpeg)
			if(!f.type.match("image.*")){
				simpleErrorAlert("이미지 확장자만 가능합니다.");
				$("#input_imgs").val("");
				return;
			}

			//이미지인 것들을 배열에 넣기
			self_file.push(f);


			//reader 선언
			let reader = new FileReader();
			//이미지 객체 읽어오기
			//e : reader객체가 이미지 객체를 읽는 이벤트
			reader.onload = function(e){

				//e.target.result : 읽은 결과물
// 				let img_html = "<img style='width:150px; height:150px; margin-right:10px;' src='"+e.target.result+"'/>";
				let img_html = "<div class='filtr-item col-sm-2'><a href='#' data-toggle='lightbox'><a href='#' data-toggle='lightbox'><img src='"+e.target.result+"' style='width:200px;height:150px;' class='img-fluid mb-2' ></a></div>";

				//새로고침으로 넣기
				$(".imgs_wrap").append(img_html);
			}

			//다음 이미지 파일을 읽기 위해 reader를 초기화해주기
			reader.readAsDataURL(f);

		});

		console.log("self_file : " , self_file);
		self_file = [];
	}

	//추가하기 클릭 시 이미지가 추가된다.
	var formData = null;
	const sendButton = document.querySelector("#addBtn");
	sendButton.addEventListener("click",function(e){
		var imageUploadFlag = true;	// 이미지 업로드가 가능합니다라는 on 스위치 역할
		// form태그가 현재 id가 fileForm이다.
		// 이때, FormData()를 이용하여 form 엘리멘트를 얻어와 FormData에 바인딩한다.
		// 여기서 일어나는 과정은 form태그 안에 들어있는 input 요소들 중, name이 존재하는 엘리멘트를 이용하여
		// formData.append("key", "value")의 형태로 만들어준다. (자동으로 해줌)
		formData = new FormData($("#fileForm")[0]);
		console.log(formData.getAll("uploadFile"));
		var reg = /(.*?)\.(jpg|jpeg|png|gif|bmp)$/;
		var file = formData.getAll("uploadFile");
		file.map(function(value, idx){
		  	if(!value.name.match(reg)) {
				simpleErrorAlert("이미지를 선택해주세요.");
				imageUploadFlag = false;
				return false;
			}
		});

		if(file == null){
			simpleErrorAlert("이미지 파일을 선택해주세요!");
			imageUploadFlag = false;
			return false;
		}


		if(imageUploadFlag){
			$.ajax({
				url: '/hospital/site/bannerInfo/uploadFormMultiAction',
				type: "post",
				data: formData,
				dataType: "json",
				processData:false,
				contentType:false,
				beforeSend : function(xhr) {
			           xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
				},
				success: function(res){
					console.log("res : " + res);
					res.map(function(value, idx){
						console.log(value + " ::: " + idx);
	// 					$("#menu_wrap").append("<img style='width:150px; height:150px; margin-right:10px;' src='"+value+"'/>");
						$(".imgs_wrap").empty();
						$("#menu_wrap").append("<div class='filtr-item col-sm-2'><a href='#' data-toggle='lightbox'><img src='"+value.bannerPath+"' id='selectBannerImg' style='width:150px;height:150px;' class='img-fluid mb-2' data-no='"+value.bannerNum+"'></a></div>");
					});
					formData.delete("uploadFile");
					console.log(formData.getAll("uploadFile"));
					$("#input_imgs").val("");
				},
				error: function(err){
					console.log(err.status);
					simpleJustErrorAlert();

				}
	 		});
		}

	});

	//메뉴에서 선택한 이미지 input태그에 넣어주기
	var numBox = "";
// 	var flag = true;
	$("#menu_wrap").on("click", "img", function(){
// 		console.log($(this).attr("class"));
// 		console.log($(this).attr("class") == "click");
		var bannerNum = $(this).data("no");
		console.log("bannerNum : ", bannerNum);
		console.log("$(this) : ", $(this));
		var imgParent = $(this).parent().parent();
		console.log("imgParent ", imgParent);

		//bannerClear bannerDecision imgDelete 버튼 활성화하기
		$("#bannerClear").prop("disabled",false);
		$("#bannerDecision").prop("disabled",false);
		$("#imgDelete").prop("disabled",false);


		//기존에 선택된게 있다면...
// 		numBox = $("#decisionBannerNum").val();
// 		console.log("numBox : " + numBox);

		//만약에 기존에 선택된거라면...
		//1) 그대로 #selectImg에 넣어주기(border형태 유지)
// 		if($(this).attr("class") == "img-fluid mb-2 click"){
		if($(this).attr("class") == "img-fluid mb-2 line"){
			$(this).addClass("click");
			console.log("numBox : " + numBox);
			console.log("bannerNum : " + bannerNum);
			if(numBox==""){
				numBox += bannerNum;
				console.log("numBox가 공백일 때 들어간 bannerNum : " + bannerNum);
				console.log("numBox가 공백일 때 numBox : " + numBox);
			}else{
				numBox += "," + bannerNum;
			}
			//========================================================================line이 있는 이미지 input에 들어갈 때 line class 지워주기
			$(this).removeClass("line");
			$("#decisionBannerNum").val(numBox);
			$("#selectImg").append(imgParent);

		}
		//만약 선택되지 않았던거라면
// 		$(this).css("border", "solid 2px red");
// 		if($(this).attr("class") != "img-fluid mb-2 click"){
		if($(this).attr("class") == "img-fluid mb-2"){
			$(this).addClass("click");
			if(numBox==""){
				numBox += bannerNum;
			}else{
				numBox += "," + bannerNum;
			}

			$("#decisionBannerNum").val(numBox);
			$("#selectImg").append(imgParent);

			console.log("numBox : " + numBox);
	// 		console.log($(this).data("no"));
		}

		console.log("decisionBannerNum에 있는 번호 : " + $("#decisionBannerNum").val());
	});

	//선택했던 이미지 다시 메뉴에 넣기
	//click 클래스가 있는 경우
	//1) 이미지 #menu_wrap에 다시 넣기
	//2) click 클래스 제거하기
	//3) input hidden의 value에서 빼기
	$("#selectImg").on("click", "img", function(){
// 		console.log($(this).attr("class"));
// 		console.log($(this).attr("class") == "click");
		var bannerNum = $(this).data("no");
		console.log("$(this) : ", $(this));
		var imgParent = $(this).parent().parent();
		console.log("imgParent ", imgParent);

		//line, click이 있는 이미지라면...
		if($(this).attr("class") == "img-fluid mb-2 line click"){
// 			console.log("클릭한거야");
 			// 1)이미지 #menu_wrap에 다시 넣기
 			$("#menu_wrap").append(imgParent);

 			//선택했던 사진 클릭 시 전체 가져옴
 			let decisionBannerNum = $("#decisionBannerNum").val();
 			console.log("기존에 선택했던 사진 번호",decisionBannerNum);
 			//배열로 넣음
 			let arr = decisionBannerNum.split(",");
 			console.log("처음 배열 : ",arr);
 			numBox = "";
 			//index 줄일 순서를 위해 스위치 만들기
 			for(let index=arr.length-1; index>=0; index--){
 				let data = arr[index];

 				if(bannerNum==data){
 					arr.splice(index, 1);
 					console.log("index : " + index);

 				}else{
 					if(numBox==""){
 						numBox += data;
 					}else{
 						numBox += "," + data;
 					}
 				}
 			}
 			console.log("반복문을 돌고 나서 배열 :", arr);
 			console.log("반복문 돌고 나서 numBox : " + numBox);
 			$("#decisionBannerNum").val(numBox);

 			//class 속성 바꾸기
 			$(this).removeClass("click");


 		}

		//클래스에 클릭만 있는 경우
		if($(this).attr("class") == "img-fluid mb-2 click"){

			let no = $(this).data("no");
// 			let thisClass = $(this).attr("class");

			//class 속성 바꾸기
 			$(this).removeClass("click");
 			console.log("lineNum : ", lineNum);
 			let lineArr = lineNum.split(",");
 			console.log("lineArr : ", lineArr);
 			//========================================전역에 있던 line 번호와 맞다면  클래스 명을 line으로 부여하기
 			let className = "";
 			$.each(lineArr,function(index,data){
 				console.log("data : ", data);
 				console.log("no : " + no);
 				if(no==data){
 					className += "img-fluid mb-2 line";
 				}
 			})
 			$(this).attr("class",className);


// 			console.log("클릭한거야");
 			// 1)이미지 #menu_wrap에 다시 넣기
 			$("#menu_wrap").append(imgParent);

 			//둘레 지우기
// 			$(this).css("border", "");
 			//form 태그 안의 no 지우기
 			//선택했던 사진 클릭 시 전체 가져옴
 			let decisionBannerNum = $("#decisionBannerNum").val();
 			console.log("기존에 선택했던 사진 번호",decisionBannerNum);
 			//배열로 넣음
 			let arr = decisionBannerNum.split(",");
 			console.log("처음 배열 : ",arr);
 			numBox = "";
 			for(let index=arr.length-1; index>=0; index--){
 				let data = arr[index];

 				if(bannerNum==data){
 					arr.splice(index, 1);
 					console.log("index : " + index);

 				}else{
 					if(numBox==""){
 						numBox += data;
 					}else{
 						numBox += "," + data;
 					}
 				}
 			}

 			console.log("반복문을 돌고 나서 배열 :", arr);
 			console.log("반복문 돌고 나서 numBox : " + numBox);
 			$("#decisionBannerNum").val(numBox);

//  			//class 속성 바꾸기
//  			$(this).removeClass("click");
//  			console.log("lineNum : ", lineNum);
//  			let lineArr = lineNum.split(",");
//  			console.log("lineArr : ", lineArr);
//  			$.each(lineArr,function(index,data){
//  				console.log("data : ", data);
//  				console.log("no : " + no);
//  				if(no==data){
// //  					thisClass.addClass("line");
//  				}
//  			})


 		}

		//decisionBannerNum의 val이 없다면 버튼 비활성화시키기
		if($("#decisionBannerNum").val()==""){
			//bannerClear bannerDecision imgDelete 버튼 비활성화하기
			$("#bannerClear").prop("disabled",true);
			$("#bannerDecision").prop("disabled",true);
			$("#imgDelete").prop("disabled",true);
		}

	});

	//삭제 버튼 클릭 시 선택한 이미지 삭제하기
	$("#imgDelete").on("click",function(){
		$("#decisionForm").attr("action","/hospital/site/bannerInfo/imgDelete?${_csrf.parameterName}=${_csrf.token}");
		console.log("numBox : " + numBox);

		let line = $(".line");
		console.log(line);
		if(line.length < 1){
			simpleErrorAlert("배너는 1개 이상 있어야합니다.");
			return;
		}

		$("#decisionForm").submit();
	});

	//bannerClear 해제하기 버튼 클릭시 상태값 변경해주기
	$("#bannerClear").on("click",function(){
		$("#decisionForm").attr("action","/hospital/site/bannerInfo/bannerClear?${_csrf.parameterName}=${_csrf.token}");
		console.log("numBox : " + numBox);

		let line = $(".line");
		console.log(line);
		if(line.length < 1){
			simpleErrorAlert("배너는 1개 이상 있어야합니다.");
			return;
		}

		$("#decisionForm").submit();
	});

});
</script>

		<!-- main 검색창을 포함한 navbar 시작-->
		<div class="content-wrapper"
	style="background-color: rgb(101, 125, 150); min-height: 873px;">
	<nav class="navbar navbar-expand navbar-white navbar-light"
		 style="background-color: #404b57;">
		<div style="width:65%;"></div>
		<div class="dropdown">
			<!-------------------- 검색대 -------------------->
<!-- 			<input type="text" class="form-control" id="keyword" name="keyword" -->
<!-- 				placeholder="" style="width: 400px;" disabled> -->
<!-- 			<ul id="ptSearchDropdown" class="dropdown-menu"> -->
<!-- 			</ul> -->
			<!-------------------- 검색대 -------------------->
		</div>
<!-- 		<img src="/resources/images/layout/hospital/memo_icon.png" alt="메모" id="memo" class="brand-image elevation-1" style="margin-left: 15px;"> -->
		<ul class="navbar-nav ml-auto"></ul>
		<div class="menu">
			<ul class="navbar-nav mb-0">
				<li class="nav-item"><a class="nav-link btn btn-outline-light" href="/hospital/site/communityInfo" >커뮤니티 관리</a></li>
				<li class="nav-item"><a class="nav-link btn btn-outline-light active" href="/hospital/site/bannerInfo">배너 관리</a></li>
				<li class="nav-item"><a class="nav-link btn btn-outline-light" href="/hospital/site/doctorIntro" >의사 소개 관리</a></li>
				<li class="nav-item"><a class="nav-link btn btn-outline-light" href="/hospital/site/faqInfo" >자주 묻는 질문 관리</a></li>
			</ul>
		</div>
	</nav>


		<!-- main 검색창을 포함한 navbar 끝 -->
		<section class="content" style="margin-top: 1%;">

			<!-- 파일 업로드 선택 시작 -->
			<form action="/hospital/site/bannerInfo/uploadFormMultiAction?${_csrf.parameterName}=${_csrf.token}" method="post"
				enctype="multipart/form-data" id="fileForm">
				<div class="row">
					<div class="col-lg-2">
					</div>
					<div class="col-lg-8">
						<div class="form-group">
							<label for="exampleInputFile" style="color:white;">이미지 추가하기</label>
							<div class="input-group">
								<div class="custom-file">
									<input type="file" class="custom-file-input" id="input_imgs" name="uploadFile" multiple />
									<label class="custom-file-label" for="exampleInputFile">추가할 이미지를 선택해주세요.</label>
								</div>
							</div>
						</div>
					</div>
				</div>

				<div class="row">
					<div class="col-lg-2">
					</div>
					<div class="col-lg-8">
					<div class="card card-info menuDiv">
						<div class="card-header" style="background-color: #404b57;">
							<h3 class="card-title" style="color: white;">추가할 이미지 미리 보기</h3>
						</div>

						<div class="card-body table-responsive p-0" style="height: 200px; border-bottom: 20px; overflow-x: hidden;"
							id="tabCardImgs">
							<div id="example2_wrapper" class="dataTables_wrapper dt-bootstrap4">
								<!--미리	보기 시작 -->
								<div class="row imgs_wrap" style="padding:15px;">

								</div>
								<!--미리보기 끝 -->
							</div>
						</div>
						<div class="card-footer">
							<div class="d-flex justify-content-between align-items-center">
								<!-- 추가하기 버튼 -->
								<button type="button" class="btn btn-info btnCss" id="addBtn"
									style="background-color: #904aff; border: #904aff; float:right; margin-left:90%;">추가하기</button>
								<!-- 추가하기 버튼 -->
							</div>
						</div>
					</div>
					</div>
				</div>
				<sec:csrfInput/>
			</form>
			<!-- 파일 업로드 선택 끝 -->

			<div class="row">
				<div class="col-lg-2">
				</div>
				<div class="col-lg-8">
				<!-- 배너 메뉴 -->
				<div class="card card-info menuDiv">
					<div class="card-header" style="background-color: #404b57;">
						<h3 class="card-title" style="color: white;">배너 이미지 메뉴
						<span style="font-size: 12px;">(테두리가 있는 이미지는 현재 배너로 사용되고 있는 이미지입니다.)</span></h3>
					</div>

					<div class="card-body table-responsive p-0" style="height: 400px; border-bottom: 20px; overflow-x: hidden;" id="tabCardSelected">
						<div id="example2_wrapper" class="dataTables_wrapper dt-bootstrap4">
							<!-- ajax를 통해서 매너 이미지를 로딩 시 바로 보임 -->
							<div class="row" id="menu_wrap" style="padding:15px;" >
							</div>
						</div>
					</div>


				</div>
				<!-- 배너 메뉴 -->
				</div>
			</div>

			<div class="row">
				<div class="col-lg-2">
				</div>
			<div class="col-lg-8">
				<!-- 선택한 메뉴 -->
				<div class="card card-info menuDiv">
					<div class="card-header" style="background-color: #404b57;">
						<h3 class="card-title" style="color: white;">이미지 설정하기</h3>
					</div>

					<div class="card-body table-responsive p-0"
						style="height: 300px; border-bottom: 20px; overflow-x: hidden;"
						id="tabCardSelected">
						<div id="example2_wrapper"
							class="dataTables_wrapper dt-bootstrap4">
							<!-- 메뉴에서 클릭한 이미지가 들어온다. -->
							<div class="row" id="selectImg" style="padding: 15px;"></div>
						</div>
					</div>

					<div class="card-footer">
						<div class="d-flex justify-content-between align-items-center" style="float:right;">
							<form method="post"
								action="/hospital/site/bannerInfo/decision?${_csrf.parameterName}=${_csrf.token}"
								id="decisionForm">
								<input type="hidden" name="bannerNum" value=""
									id="decisionBannerNum" />
								<div>
									<input type="button" class="btn btn-warning ml-1 btnCss"
										style="color: white; border: none; background-color: #ff3e3e; float:right;"
										id="imgDelete" value="삭제" disabled />
									<input type="submit" class="btn btn-success btnCss"
										id="bannerDecision" value="배너로 결정하기" disabled />
									<input type="button" class="btn btn-info btnCss"
										style="background-color: #904aff; border: #904aff;"
										id="bannerClear" value="배너 해제하기" disabled />
								</div>
							</form>
						</div>
					</div>

				</div>
				<!-- 선택한 메뉴 -->
			</div>
		</div>

		</section>
	</div>

<script src="/resources/js/alertModule.js"></script>












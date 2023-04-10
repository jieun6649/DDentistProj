
// 성공 토스트
function simpleSuccessAlert(msg){
	Swal.mixin({
		toast: true,
		position: 'top',
		showConfirmButton: false,
		timer: 3000
	}).fire({
		icon: 'success',
		title: msg
	});
}

// 메시지 있는에러 알림창 출력
function simpleErrorAlert(msg){
	Swal.fire({
		icon: 'error',
		title: msg,
		confirmButtonText: '확인'
	});
}

// 에러 알림창 출력
function simpleJustErrorAlert(){
	Swal.fire({
		icon: 'error',
		title: '에러가 발생했습니다.',
		text: '잠시 후 다시 시도해주세요.',
		confirmButtonText: '확인'
	});
}


// 확인-취소 알림창은 복사해서 사용할 것
/*
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
*/
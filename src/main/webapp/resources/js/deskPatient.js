
// 환자 선택 필요 알림창 출력
function simplePatientSelectNeedAlert(){
	Swal.fire({
		icon: 'error',
		title: '환자를 선택해주세요.',
		confirmButtonText: '확인'
	});
}

// 주민등록번호를 모두 입력하면 생년월일과 성별이 자동으로 설정된다.
$('input[name=ptRrno1], input[name=ptRrno2]').on('blur', function(e){

	if(document.patientForm.ptRrno1.value == '' || document.patientForm.ptRrno2.value == ''){
		return;
	}

	setFromRrno();
});

// 주민등록번호를 통해 생년월일과 성별을 설정한다.
function setFromRrno(){

	const rrno = document.patientForm.ptRrno1.value + document.patientForm.ptRrno2.value;
	let birNum = rrno.substring(0, 6);
	const genNum = rrno.substring(6, 7);

	let gen = '';
	switch(genNum){
	case '1':
		birNum = '19' + birNum;
		gen = 'M';
		break;
	case '2':
		birNum = '19' + birNum;
		gen = 'W';
		break;
	case '3':
		birNum = '20' + birNum;
		gen = 'M';
		break;
	case '4':
		birNum = '20' + birNum;
		gen = 'W';
		break;
	}

	document.patientForm.ptBrdt.value = birNum;
	document.patientForm.ptGen.value = gen;
}



//환자 검색란에서 환자를 찾아 선택 시 환자 데이터가 폼에 입력된다.
function selectPt(target){

	resetForm();
	const ptNum = target.dataset.ptnum;
	document.querySelector('#ptSearch').value = target.textContent;

	fetch('/hospital/desk/selectPatient?ptNum=' + ptNum)
		.then(res => res.json())
		.then(ptInfo => {

			document.querySelector('#regCc').value = '';

			document.patientForm.ptNum.value = ptInfo.ptNum;
			document.patientForm.ptNm.value = ptInfo.ptNm;
			document.patientForm.ptBrdt.value = ptInfo.ptBrdt;
			document.patientForm.ptRrno1.value = ptInfo.ptRrno.substring(0, 6);
			document.patientForm.ptRrno2.value = ptInfo.ptRrno.substring(6);
			document.patientForm.ptGen.value = ptInfo.ptGen;

			const ptPhone = ptInfo.ptPhone;
			document.patientForm.ptPhone1.value = ptPhone.substring(0, 3);
			if(ptPhone.length == 7){
				document.patientForm.ptPhone2.value = ptPhone.substring(3, 6);
				document.patientForm.ptPhone3.value = ptPhone.substring(6);
			} else {
				document.patientForm.ptPhone2.value = ptPhone.substring(3, 7);
				document.patientForm.ptPhone3.value = ptPhone.substring(7);
			}

			document.patientForm.ptZip.value = ptInfo.ptZip;
			document.patientForm.ptAddr.value = ptInfo.ptAddr;
			document.patientForm.ptAddrDet.value = ptInfo.ptAddrDet;
			document.querySelector('#ptMemo').value = ptInfo.ptMemo;

			if(ptInfo.prvcPvsnAgreYn == 'Y'){
				document.patientForm.prvcPvsnAgreYn.checked = true;
			}
			if(ptInfo.smsRcptnAgreYn == 'Y'){
				document.patientForm.smsRcptnAgreYn.checked = true;
			}
			if(ptInfo.ptPregYn == 'Y'){
				document.patientForm.ptPregYn.checked = true;
			}

			document.questionnaireForm.ptNum.value = ptInfo.ptNum;
			document.patientForm.action = '/hospital/desk/updatePatient';

			document.querySelector('#openQuesBtn').disabled = false;
			document.questionnaireForm.action = '/hospital/desk/updateQue';

			setMedicalAlert(ptInfo.queInfo.uconList);
			selectDetail();
		});
}

//Medical Alert 설정
function setMedicalAlert(uconList){

	if(uconList[0].conNum == '') {
		$('.medicalAlertFlow').text('');
		return false;
	}

	let mAlert = '';
	uconList.forEach(function(ucon, i){
		if(i > 0) mAlert += ', ';
			mAlert += ucon.conNm;

		if(ucon.conDet != null && ucon.conDet != ''){
			mAlert += '(' + ucon.conDet + ')';
		}
	});

	$('.medicalAlertFlow').text(mAlert);
}

// 입력란 유효성 검사
function checkPatientFormValid(){

	let alertContent = '';

	if(document.patientForm.ptNm.value.trim() == ''){
		alertContent = '환자 이름을 입력해주세요.';
	} else if(document.patientForm.ptRrno1.value.trim() == '' ||
			   document.patientForm.ptRrno2.value.trim() == ''){
		alertContent = '주민등록번호를 입력해주세요.';
	} else if(document.patientForm.ptPhone1.value.trim() == '' ||
			  document.patientForm.ptPhone2.value.trim() == '' ||
			  document.patientForm.ptPhone3.value.trim() == ''){
		alertContent = '환자 연락처를 입력해주세요.';
	} else if(document.patientForm.ptZip.value.trim() == '' ||
			   document.patientForm.ptAddr.value.trim() == ''){
		alertContent = '환자 주소를 입력해주세요.';
	} else if(!document.patientForm.prvcPvsnAgreYn.checked){
		alertContent = '환자 등록을 위해서는 개인정보 제공에 동의해야 합니다.';
	}

	if (alertContent != ''){
		Swal.fire({
			icon: 'error',
			title: alertContent,
			confirmButtonText: '확인'
		});

		return false;
	}

	return true;
}

// 새 환자를 등록한다.
function insertPatient(){

	if(!checkPatientFormValid()) return false;

	const csrfToken = $('#_csrfToken').val();
	const actionPath = document.patientForm.action;
	const patientFormData = new FormData(document.patientForm);
	patientFormData.append('ptRrno', document.patientForm.ptRrno1.value + document.patientForm.ptRrno2.value);
	patientFormData.append('ptPhone', document.patientForm.ptPhone1.value + document.patientForm.ptPhone2.value + document.patientForm.ptPhone3.value);
	patientFormData.append('ptMemo', document.querySelector('#ptMemo').value);

	if(!validation(patientFormData)) return false;

	fetch(actionPath + '?_csrf=' + csrfToken, {
		method: 'post',
		body : patientFormData
	})
		.then(res => {
			if(!res.ok) throw new Error();
			return res.text();
		})
		.then(text => {

			if(text == 'FAILED'){
				simpleJustErrorAlert();
				return;
			}

			if(text == 'UPDATE'){
				simpleSuccessAlert('환자 정보가 수정되었습니다.');
				document.querySelector('#ptSearch').value = document.patientForm.ptNm.value + '(' + document.patientForm.ptNum.value + ')';
				document.querySelector('#ptSearchDropdown').innerHTML = '';
				return;
			}

			// 서버로부터 반환받은 값이 환자 번호일 경우
			document.patientForm.ptNum.value = text;
			document.querySelector('#ptSearch').value = document.patientForm.ptNm.value + '(' + text + ')';
			document.patientForm.action = '/hospital/desk/updatePatient';

			document.questionnaireForm.ptNum.value = document.patientForm.ptNum.value;
			document.querySelector('#openQuesBtn').disabled = false;

			alertQue('환자 등록이 완료되었습니다.');
		})
		.catch(() => {
			simpleJustErrorAlert();
		});
}

// 환자 폼 유효성 검사
function validation(ptForm){

	const ptNm = ptForm.get('ptNm');
	if(!ptNm.match(/^[가-힣]{2,5}$/g)){
		simpleErrorAlert('이름을 확인해주세요.');
		return false;
	}

	const ptRrno = ptForm.get('ptRrno');
	if(!ptRrno.match(/^[\d]{13}$/g)){
		simpleErrorAlert('주민등록번호를 확인해주세요.');
		return false;
	}

	const ptPhone = ptForm.get('ptPhone');
	if(!ptPhone.match(/^[\d]{9,11}$/g)){
		simpleErrorAlert('연락처를 확인해주세요.');
		return false;
	}

	const ptZip = ptForm.get('ptZip');
	if(!ptZip.match(/^[\d]{5}$/g)){
		simpleErrorAlert('우편번호를 확인해주세요.');
		return false;
	}

	const ptAddr = ptForm.get('ptAddr');
	if(!ptAddr.match(/^[가-힣a-zA-Z\d\s-]{1,33}$/g)){
		simpleErrorAlert('주소를 확인해주세요.');
		return false;
	}

	return true;

}

// 문진표 경고창 출력
function alertQue(title){

	Swal.fire({
		title: title,
		text: '문진표를 작성하시겠습니까?',
		showDenyButton: true,
		confirmButtonText: '작성',
		denyButtonText: '닫기',
	}).then((result) => {
		if (result.isConfirmed) {
			selectQue();
		} else if (result.isDenied){
			Swal.fire({
				icon: 'info',
				title: '문진표 작성 필요',
				html: '정상적인 진료를 위해<br>반드시 문진표를 작성해주시길 바랍니다.',
				confirmButtonText: '확인'
			});
		}
	});

}

// 환자 삭제 알림창
function deletePatientAlert(){

	Swal.fire({
		title: '환자 정보를 삭제하시겠습니까?',
		text: '삭제 후 복구가 불가능합니다.',
		showDenyButton: true,
		confirmButtonText: '삭제',
		denyButtonText: '닫기',
	}).then((result) => {
		if (result.isConfirmed) {
			deletePatient();
		}
	});

}

// 환자를 삭제한다.
function deletePatient(){

	const csrfToken = $('#_csrfToken').val();
	const ptNum = document.patientForm.ptNum.value;

	fetch('/hospital/desk/deletePatient', {
		method: 'post',
		headers: {
			'X-CSRF-TOKEN' : csrfToken
		},
		body: ptNum
	})
		.then(res => res.text())
		.then(text => {

			if(text == 'SUCCESS'){
				Swal.fire({
					icon: 'success',
					title: '환자 정보가 삭제되었습니다.',
					confirmButtonText: '확인'
				});
				resetForm();
			} else if(text == 'DENIED'){
				Swal.fire({
					icon: 'error',
					title: '진료 내역이 있는 환자는 삭제할 수 없습니다.',
					confirmButtonText: '확인'
				});
			} else if(text == 'FAILED'){
				simpleJustErrorAlert();
			}

		});
}

//전체 폼을 초기화한다.
function resetForm(){
	$('.medicalAlertFlow').text('');
	document.querySelector('#ptSearch').value = '';
	document.querySelector('#ptSearchDropdown').innerHTML = '';
	document.querySelector('#regCc').value = '';
	document.querySelector('#ptMemo').value = '';
	document.patientForm.reset();
	document.patientForm.action = '/hospital/desk/insertPatient';

	document.querySelector('#openQuesBtn').disabled = true;
	document.questionnaireForm.action = '/hospital/desk/insertQue';

	document.querySelector('#familyListBody').innerHTML = '';
	document.querySelector('#checkupListBody').innerHTML = '';
	document.querySelector('#rcvmtListBody').innerHTML = '';
}

// 체크박스 체크 시 disabled 설정/해제
$('input:checkbox', questionnaireForm).on('change', function(){
	if($(this).is(':checked')){
		$(this).next().attr('disabled', false);
	} else {
		$(this).next().attr('disabled', true);
	}
});

// 문진표와 기저질환 등록
function insertQue(){

	const csrfToken = $('#_csrfToken').val();
	const actionPath = document.questionnaireForm.action;
	const queFormData = new FormData(document.questionnaireForm);

	fetch(actionPath + '?_csrf=' + csrfToken, {
		method: 'post',
		body: queFormData
	})
		.then(res => res.text())
		.then(text => {

			if (text == 'FAILED') {
				simpleJustErrorAlert();
				return;
			}

			let titleContent = '';
			if(text == 'INSERT'){
				titleContent = '문진표가 저장되었습니다.';
			} else if (text == 'UPDATE') {
				titleContent = '문진표가 수정되었습니다.';
			}

			const Toast = Swal.mixin({
				toast: true,
				position: 'top',
				showConfirmButton: false,
				timer: 3000
			}).fire({
				icon: 'success',
				title: titleContent
			});

			setUpdatedMedicalAlerts(queFormData);

			$('#queModal').modal('hide');
			document.questionnaireForm.reset();
			$('.uConditionType').attr('disabled', true);
		});
}

// 수정된 문진표를 Medical Alerts에 업데이트
function setUpdatedMedicalAlerts(queFormData){

	let index = 0;
	let medicalAlerts = '';
	for(const key of queFormData.keys()){
		if(key.startsWith('uConList')){
			const uConData = queFormData.get(key);
			if(uConData == '') continue;
			if(key.endsWith('conNm')){
				if(index++ > 0) medicalAlerts += ', ';
				medicalAlerts += uConData;
			} else {
				medicalAlerts += '(' + (uConData == null ? '' : uConData) + ')';
			}
		}
	}

	$('.medicalAlertFlow').text(medicalAlerts);
}

// 환자의 문진표를 가져오고 모달 출력
function selectQue(){

    document.questionnaireForm.reset();
    $('.uConditionType').attr('disabled', true);
	const ptNum = document.patientForm.ptNum.value;

	fetch('/hospital/desk/selectQue?ptNum=' + ptNum)
		.then(async res => {
			let text = await res.text();
            if (text == '') return null;
			else return JSON.parse(text);
		})
		.then(queInfo => {
			if(queInfo != null) {
				document.questionnaireForm.queReason.value = queInfo.queReason;
				document.questionnaireForm.queWant.value = queInfo.queWant;
				document.questionnaireForm.quePharm.value = queInfo.quePharm;

				queInfo.uconList.forEach(function(ucon){
					$('input:checkbox[value="' + ucon.conNm + '"]').prop('checked', true);
					$('input:checkbox[value="' + ucon.conNm + '"]').next().attr('disabled', false);
					$('input:checkbox[value="' + ucon.conNm + '"]').next().val(ucon.conDet);
				});
			}
		})

	$('#queModal').modal('show');
}

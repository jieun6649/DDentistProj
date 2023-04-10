/*
// 차트 드롭다운 메뉴 출력
$(document).on('click', '.chartRow', function(e){

	$('#chartDropdownMenu')
		.attr('data-type', $(this).children()[1].textContent)
		.attr('data-chknum', $(this).data('chknum'))
		.attr('data-sn', $(this).data('sn'))
		.removeClass('d-none')
		.css({
			left: e.pageX,
			top: e.pageY
		});
});

//다른 곳을 클릭할 경우 차트 목록 드롭다운 메뉴 숨김
$(document).on('click', function(e){

	// 차트 드롭다운 메뉴 초기화
	if(!e.target.parentNode.classList.contains('chartRow')){
		$('#chartDropdownMenu')
			.addClass('d-none')
	}
});
*/

// 진료비 항목의 체크박스 해제 시 취소줄이 쳐진다.
$(document).on('change', '.rcvmtCheck', function(){

	const textTd = $(this).parents('tr').children();

	if($(this).is(':checked')){
		textTd[1].style.textDecorationLine = '';
		textTd[2].style.textDecorationLine = '';
	} else {
		textTd[1].style.textDecorationLine = 'line-through';
		textTd[2].style.textDecorationLine = 'line-through';
	}

	calcCheckupCost();
});

// 총진료비 계산
function calcCheckupCost(){

	const rcvmtList = document.querySelectorAll('.rcvmtCheck');

	let totalCost = 0;
	rcvmtList.forEach(function(rcvmt){
		if(rcvmt.checked == true){
			totalCost += parseInt(rcvmt.dataset.cost);
		}
	});

	document.querySelector('#totalCheckupCost').textContent = totalCost.toLocaleString();
}

// 수납 목록
function listCheckupCost(chkNum){

	fetch('/hospital/chart/listCheckupCost?chkNum=' + chkNum)
		.then(res => res.json())
		.then(checkupCostList => {

			let code = '';
			checkupCostList.forEach(function(chk){

				code += '<tr>';
				code += '<td><input type="checkbox" class="rcvmtCheck" data-cost="' + chk.txCost + '" checked /></td>';
				code += '<td>' + chk.txcNm + '(' + chk.txcCd + ')' + '</td>';
				let teethCount = chk.txToothNum.split(', ').length;
				code += '<td>' + teethCount + '</td>';
				code += '<td>' + chk.txCost.toLocaleString() + '</td>';
				code += '</tr>';

			});

			document.querySelector('#rcvmtListBody').innerHTML = code;
			calcCheckupCost();
		});

}

// 진료차트 조회
function listChart(ptNum){


	if(ptNum == null){
		ptNum = chartListPtNum.value;
//		ptNum = document.querySelector('#chartListBody').dataset.ptnum;
	}

	fetch('/hospital/checkup/listChart?ptNum=' + ptNum)
		.then(res => res.json())
		.then(chartList => {

			let code = '';
			const chartListBody = document.querySelector('#chartListBody');

			if(chartList.length == 0){
				code += '<tr>';
				code += '<td colspan="4">진료기록이 존재하지 않습니다.</td>';
				code += '</tr>';
			} else {

				chartList.forEach(function(chart){

					// 다음 치료 계획 출력
					chart.txnList.forEach(function(txn){

						if(txn.txnSn == 0) return false;

						code += '<tr class="chartRow" data-chknum="' + txn.chkNum + '" data-sn="' + txn.txnSn + '">';
						code += '<td>';
						code += '<a href="javascript:void(0);" class="position-relative text-danger" style="left:-10px;" onclick="deleteChartContentAlert(this)">&times;</a>';
						code += txn.chkDtStr + '</td>';
						code += '<td>TX NEXT</td>';
						code += '<td class="text-left">';
						code += txn.txnToothNum.split(', ').map(num => '#<u class="teethNum">' + num + '</u>').join(', ');
						code += '<br />- ' + txn.txcNm;
						if(txn.txnContent != null){
							code += '<hr class="mx-0 my-2" />';
							code += txn.txnContent;
						}
						code += '</td>';
						code += '<td>' + txn.empNm + '</td>';
						code += '</tr>';
					});

					// 처치 출력
					chart.txList.forEach(function(tx){

						if(tx.txSn == 0) return false;

						code += '<tr class="chartRow" data-chknum="' + tx.chkNum + '" data-sn="' + tx.txSn + '">';
						code += '<td>';
						code += '<a href="javascript:void(0);" class="position-relative text-danger" style="left:-10px;" onclick="deleteChartContentAlert(this)">&times;</a>';
						code += tx.chkDtStr + '</td>';
						code += '<td>TX</td>';
						code += '<td class="text-left">';
						code += tx.txToothNum.split(', ').map(num => '#<u class="teethNum">' + num + '</u>').join(', ');
						code += '<br />- ' + tx.txcNm;
						if(tx.txContent != null){
							code += '<hr class="mx-0 my-2" />';
							code += tx.txContent;
						}
						code += '</td>';
						code += '<td>' + tx.empNm + '</td>';
						code += '</tr>';
					});

					// 치료 계획 출력
					chart.txpList.forEach(function(txp){

						if(txp.txpSn == 0) return false;

						code += '<tr class="chartRow" data-chknum="' + txp.chkNum + '" data-sn="' + txp.txpSn + '">';
						code += '<td>';
						code += '<a href="javascript:void(0);" class="position-relative text-danger" style="left:-10px;" onclick="deleteChartContentAlert(this)">&times;</a>';
						code += txp.chkDtStr + '</td>';
						code += '<td>TX PLAN</td>';
						code += '<td class="text-left">';
						code += txp.txpToothNum.split(', ').map(num => '#<u class="teethNum">' + num + '</u>').join(', ');
						code += '<br />- ' + txp.txcNm;
						if(txp.txpContent != null){
							code += '<hr class="mx-0 my-2" />';
							code += txp.txpContent;
						}
						code += '</td>';
						code += '<td>' + txp.empNm + '</td>';
						code += '</tr>';
					});

					// 증상 출력
					chart.piList.forEach(function(pi){

						if(pi.piSn == 0) return false;

						code += '<tr class="chartRow" data-chknum="' + pi.chkNum + '" data-sn="' + pi.piSn + '">';
						code += '<td>';
						code += '<a href="javascript:void(0);" class="position-relative text-danger" style="left:-10px;" onclick="deleteChartContentAlert(this)">&times;</a>';
						code += pi.chkDtStr + '</td>';
						code += '<td>PI</td>';
						code += '<td class="text-left">';
						code += pi.piToothNum.split(', ').map(num => '#<u class="teethNum">' + num + '</u>').join(', ');
						code += '<br />- ' + pi.disKorNm;
						if(pi.piContent != null){
							code += '<hr class="mx-0 my-2" />';
							code += pi.piContent;
						}
						code += '</td>';
						code += '<td>' + pi.empNm + '</td>';
						code += '</tr>';
					});

				});

			}

			chartListBody.innerHTML = code;

			listMedicalAlerts(ptNum);
			
			const chkNum = chartListChkNum.value;
//			const chkNum = document.querySelector('#chartListBody').dataset.chknum;
			if(chkNum != ''){
				listCheckupCost(chkNum);
			}
		});

}

// 환자 문진표 및 기저질환 조회
function listMedicalAlerts(ptNum){

	fetch('/hospital/chart/listMedicalAlerts?ptNum=' + ptNum)
		.then(res => {
			if(!res.ok) throw new Error();
			return res.json();
		})
		.then(medInfo => {

			let med = '';

			let quePharm = medInfo.quePharm;
			if(quePharm != null && quePharm != ''){
				med += '복용약 : ' + medInfo.quePharm;
			}

			let uconList = medInfo.uconList;
			if(uconList != null && uconList.length > 0){
				if(med != '') med += ' // ';
				med += uconList.map(ucon => {
						let uconText = ucon.conNm;
						if(ucon.conDet != null && ucon.conDet != ''){
							uconText += ' : ' + ucon.conDet;
						}

						return uconText;
					})
					.join(' / ');
			}

			$('.medicalAlertFlow').text(med);

		})
		.catch(() => {
			simpleJustErrorAlert();
		})


}

//차트 내용 삭제 알림창
function deleteChartContentAlert(target){

	Swal.fire({
		title: '차트 내용을 삭제하시겠습니까?',
		showDenyButton: true,
		confirmButtonText: '삭제',
		denyButtonText: '취소',
	}).then(result => {
		if(result.isConfirmed){
			deleteChartContent(target);
		}
	});
}

// 차트 내용 삭제
function deleteChartContent(target){

	const chartRow = target.closest('.chartRow');
	const type = chartRow.childNodes[1].textContent;

	let actionPath = '';
	let snNm = '';

	switch(type){
	case 'PI':
		actionPath = '/deletePi';
		snNm = 'piSn';
		break;
	case 'TX PLAN':
		actionPath = '/deleteTxPlan';
		snNm = 'txpSn';
		break;
	case 'TX':
		actionPath = '/deleteTx';
		snNm = 'txSn';
		break;
	case 'TX NEXT':
		actionPath = '/deleteTxNext';
		snNm = 'txnSn';
		break;
	}

	const csrfToken = $('#_csrfToken').val();

	let data = {};
	data['chkNum'] = chartRow.dataset.chknum;
	data[snNm] = chartRow.dataset.sn;

	fetch('/hospital/chart' + actionPath, {
		method: 'post',
		headers: {
			'X-CSRF-TOKEN' : csrfToken,
			'Content-Type' : 'application/json;charset=utf-8'
		},
		body: JSON.stringify(data)
	})
		.then(res => res.text())
		.then(text => {
			if(text == "FAILED"){
				simpleJustErrorAlert();
				return false;
			}

			if(text == "DENIED"){
				simpleErrorAlert('일주일 이내에 작성된 차트 내용만 삭제할 수 있습니다.');
				return false;
			}

			simpleSuccessAlert('차트 내용이 삭제되었습니다.');
			listChart();
		});

}

//진료 취소
function stopCheckup(){

	Swal.fire({
		title: '진료를 중단하시겠습니까?',
		showDenyButton: true,
		confirmButtonText: '확인',
		denyButtonText: '취소',
	}).then(result => {
		if(result.isConfirmed){

//			const chartListBody = document.querySelector('#chartListBody');
//			const chkNum = chartListBody.dataset.chknum;
			const chkNum = chartListChkNum.value;

			const csrfToken = $('#_csrfToken').val();

			fetch('/hospital/chart/stopCheckup', {
				method: 'post',
				headers: {
					'X-CSRF-TOKEN' : csrfToken,
					'Content-Type' : 'application/json;chartset=utf-8'
				},
				body: JSON.stringify({
					'chkNum' : chkNum
				})
			})
				.then(res => res.text())
				.then(text => {
					if(text == "FAILED"){
						simpleJustErrorAlert();
						return false;
					}

					simpleSuccessAlert('진료가 중지되었습니다.');
					resetChartData();
					listRegist();
				});
		}
	});

}

// 진료 완료 후 수납으로 진행
function completeCheckup(){

	if(!isOnCheckup()) return false;

	Swal.fire({
		title: '진료를 끝내고 수납 처리를 하시겠습니까?',
		showDenyButton: true,
		confirmButtonText: '확인',
		denyButtonText: '취소',
	}).then(result => {

		if(result.isConfirmed){
//			const chartListBody = document.querySelector('#chartListBody');
//			const chkNum = chartListBody.dataset.chknum;
			const chkNum = chartListChkNum.value;

			let totalCheckupCost = document.querySelector('#totalCheckupCost').textContent;
			totalCheckupCost = totalCheckupCost.replace(/\,/g, '');

			const csrfToken = $('#_csrfToken').val();
			fetch('/hospital/chart/completeCheckup', {
				method: 'post',
				headers: {
					'X-CSRF-TOKEN' : csrfToken,
					'Content-Type' : 'application/json;charset=utf-8'
				},
				body: JSON.stringify({
					'chkNum' : chkNum,
					'totalCheckupCost' : totalCheckupCost
				})
			})
				.then(res => res.text())
				.then(text => {

					simpleSuccessAlert('진료가 완료되었습니다.');
					resetChartData();
					listRegist();

				});
		}

	});

}

//진료차트의 차트 내용, 선택된 환자 번호, 진료 번호를 초기화
function resetChartData(){

	const chartListBody = document.querySelector('#chartListBody');
	chartListBody.innerHTML = '';
	chartListPtNum.value = '';
	chartListChkNum.value = '';
//	chartListBody.dataset.ptnum = '';
//	chartListBody.dataset.chknum = '';
	document.querySelector('#selectedPtNm').textContent = '';

	document.querySelector('#rcvmtListBody').innerHTML = '';
	document.querySelector('#totalCheckupCost').textContent = '';

}

//환자 검색창에서 환자 선택 시 차트 조회
function selectPt(target){
	const ptInfo = target.textContent;
	document.querySelector('#ptSearch').value = ptInfo;

	const ptNum = target.dataset.ptnum;
	const ptNm = target.dataset.ptnm;

	chartListPtNum.value = ptNum;
	chartListChkNum.value = '';
//	document.querySelector('#chartListBody').dataset.ptnum = ptNum;
//	document.querySelector('#chartListBody').dataset.chknum = '';
	document.querySelector('#selectedPtNm').textContent = ptNm;
	listChart(ptNum);
}

// 증상/처치 카드의 탭을 누를 때 저장 버튼의 핸들러 함수가 바뀐다.
function changeCheckupType(target){

	resetPiBadges();
	const event = target.dataset.event;
	const saveBtn = document.querySelector('#checkupSaveBtn');

	switch(event){
	case 'insertPi':
		saveBtn.onclick = insertPi;
		break;
	case 'insertTxPlan':
		saveBtn.onclick = insertTxPlan;
		break;
	case 'insertTx':
		saveBtn.onclick = insertTx;
		break;
	case 'insertTxNext':
		saveBtn.onclick = insertTxNext;
		break;
	}

}

// 현재 진료중인지 확인
// 진료중인 환자가 아니면 증상이나 처치를 추가할 수 없다.
function isOnCheckup(){

	const chkNum = chartListChkNum.value;
//	const chkNum = document.querySelector('#chartListBody').dataset.chknum;
	if(chkNum == '') {
		simpleErrorAlert('진료중이 아닙니다.');
		return false;
	}
	return true;
}

// PI를 DB에 추가
function insertPi(){

	if(!isOnCheckup()) return false;

	let formData = new FormData();
	formData.append('chkNum', chartListChkNum.value);
//	formData.append('chkNum', document.querySelector('#chartListBody').dataset.chknum);

	const selectedPiTx = getSelectedPiTx();
	if(selectedPiTx == ''){
		simpleErrorAlert('증상 또는 처치를 선택해주세요.');
		return false;
	}
	formData.append('disCd', selectedPiTx);

	const selectedTeeth = getSelectedTeeth();
	if(selectedTeeth == ''){
		simpleErrorAlert('치아를 선택해주세요.');
		return false;
	}
	formData.append('piToothNum', selectedTeeth);

	formData.append('piContent', document.querySelector('#checkupMemo').value);

	const csrfToken = $('#_csrfToken').val();
	fetch('/hospital/chart/insertPi?_csrf=' + csrfToken, {
		method: 'post',
		body: formData
	})
		.then(res => res.text())
		.then(text => {
			if(text == 'FAILED'){
				simpleJustErrorAlert();
				return false;
			}

			simpleSuccessAlert('PI가 추가되었습니다.');
			listChart();
			resetAll();
		});
}

// TX PLAN을 DB에 추가
function insertTxPlan(){

	if(!isOnCheckup()) return false;

	let formData = new FormData();
	formData.append('chkNum', chartListChkNum.value);
//	formData.append('chkNum', document.querySelector('#chartListBody').dataset.chknum);

	const selectedPiTx = getSelectedPiTx();
	if(selectedPiTx == ''){
		simpleErrorAlert('증상 또는 처치를 선택해주세요.');
		return false;
	}
	formData.append('txcCd', selectedPiTx);

	const selectedTeeth = getSelectedTeeth();
	if(selectedTeeth == ''){
		simpleErrorAlert('치아를 선택해주세요.');
		return false;
	}
	formData.append('txpToothNum', selectedTeeth);
	formData.append('txpContent', document.querySelector('#checkupMemo').value);

	const csrfToken = $('#_csrfToken').val();
	fetch('/hospital/chart/insertTxPlan?_csrf=' + csrfToken, {
		method: 'post',
		body: formData
	})
		.then(res => res.text())
		.then(text => {
			if(text == 'FAILED'){
				simpleJustErrorAlert();
				return false;
			}

			simpleSuccessAlert('TX.PLAN이 추가되었습니다.');
			listChart();
			resetAll();
		});

}

// TX를 DB에 추가
function insertTx(){

	if(!isOnCheckup()) return false;

	let formData = new FormData();
	formData.append('chkNum', chartListChkNum.value);
//	formData.append('chkNum', document.querySelector('#chartListBody').dataset.chknum);

	const selectedPiTx = getSelectedPiTx();
	if(selectedPiTx == ''){
		simpleErrorAlert('증상 또는 처치를 선택해주세요.');
		return false;
	}
	formData.append('txcCd', selectedPiTx);

	const selectedTeeth = getSelectedTeeth();
	if(selectedTeeth == ''){
		simpleErrorAlert('치아를 선택해주세요.');
		return false;
	}
	formData.append('txToothNum', selectedTeeth);
	formData.append('txContent', document.querySelector('#checkupMemo').value);

	const csrfToken = $('#_csrfToken').val();
	fetch('/hospital/chart/insertTx?_csrf=' + csrfToken, {
		method: 'post',
		body: formData
	})
		.then(res => res.text())
		.then(text => {
			if(text == 'FAILED'){
				simpleJustErrorAlert();
				return false;
			}

			simpleSuccessAlert('TX가 추가되었습니다.');
			listChart();
			resetAll();
		});

}

// TXNext를 DB에 추가
function insertTxNext(){

	if(!isOnCheckup()) return false;

	let formData = new FormData();
	formData.append('chkNum', chartListChkNum.value);
//	formData.append('chkNum', document.querySelector('#chartListBody').dataset.chknum);

	const selectedPiTx = getSelectedPiTx();
	if(selectedPiTx == ''){
		simpleErrorAlert('증상 또는 처치를 선택해주세요.');
		return false;
	}
	formData.append('txcCd', selectedPiTx);

	const selectedTeeth = getSelectedTeeth();
	if(selectedTeeth == ''){
		simpleErrorAlert('치아를 선택해주세요.');
		return false;
	}
	formData.append('txnToothNum', selectedTeeth);
	formData.append('txnContent', document.querySelector('#checkupMemo').value);

	const csrfToken = $('#_csrfToken').val();
	fetch('/hospital/chart/insertTxNext?_csrf=' + csrfToken, {
		method: 'post',
		body: formData
	})
		.then(res => res.text())
		.then(text => {
			if(text == 'FAILED'){
				simpleJustErrorAlert();
				return false;
			}

			simpleSuccessAlert('TX.NEXT가 추가되었습니다.');
			listChart();
			resetAll();
		});

}


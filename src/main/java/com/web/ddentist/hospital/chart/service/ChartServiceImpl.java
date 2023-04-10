package com.web.ddentist.hospital.chart.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.web.ddentist.mapper.ChartMapper;
import com.web.ddentist.vo.CheckupVO;
import com.web.ddentist.vo.DiseaseVO;
import com.web.ddentist.vo.PiVO;
import com.web.ddentist.vo.QuestionnaireVO;
import com.web.ddentist.vo.RegistVO;
import com.web.ddentist.vo.ReservationVO;
import com.web.ddentist.vo.TxCodeVO;
import com.web.ddentist.vo.TxNextVO;
import com.web.ddentist.vo.TxPlanVO;
import com.web.ddentist.vo.TxVO;

@Service
public class ChartServiceImpl implements IChartService {

	@Autowired
	private ChartMapper chartMapper;

	@Override
	public Map<String, Object> initChartData() {

		Map<String, Object> dataMap = new HashMap<>();

		List<DiseaseVO> disList = chartMapper.listDis();
		if(disList != null) {
			for(DiseaseVO disVO : disList) {
				String color = setBadgeColor(disVO.getDisCd());
				disVO.setColor(color);
			}
		}
		dataMap.put("disList", disList);

		List<TxCodeVO> txcList = chartMapper.listTxCode();
		if(txcList != null) {
			for(TxCodeVO txcVO : txcList) {
				String color = setBadgeColor(txcVO.getTxcCd());
				txcVO.setColor(color);
			}
		}
		dataMap.put("txcList", txcList);

		return dataMap;
	}

	// 전자차트에서 증상, 처치 뱃지의 색상을 지정하는 메서드
	private String setBadgeColor(String code) {

		if(code == null || code.equals("")) return "#757575";
		String headChar = code.substring(0, 1).toLowerCase();

		switch (headChar){
		case "a":
			return "#FF5252";
		case "b":
			return "#E040FB";
		case "c":
			return "#7C4DFF";
		case "d":
			return "#536DFE";
		case "e":
			return "#448AFF";
		case "f":
			return "#0091EA";
		case "g":
			return "#00897B";
		case "h":
			return "#388E3C";
		case "i":
			return "#689F38";
		case "j":
			return "#EF6C00";
		default:
			return "#757575";
		}

	}

	@Override
	public List<RegistVO> listRegist() {
		return chartMapper.listRegist();
	}

	@Override
	public List<ReservationVO> listResv() {
		return chartMapper.listResv();
	}

	@Transactional
	@Override
	public String insertCheckup(CheckupVO chkVO) {
		int result = chartMapper.insertCheckup(chkVO);
		if(result == 0) return "FAILED";

		String regNum = chkVO.getRegNum();
		result = chartMapper.updateRegStatusInTreat(regNum);
		if(result == 0) return "FAILED";

		return "SUCCESS";
	}

	@Override
	public String stopCheckup(CheckupVO chkVO) {
		int result = chartMapper.stopCheckup(chkVO);
		if(result == 0) return "FAILED";
		return "SUCCESS";
	}

	@Transactional
	@Override
	public String completeCheckup(CheckupVO chkVO) {
		int result = chartMapper.insertRcvmt(chkVO);
		if(result == 0) return "FAILED";

		result = chartMapper.completeCheckup(chkVO);
		if(result == 0) return "FAILED";
		return "SUCCESS";
	}

	@Override
	public String insertPi(PiVO piVO) {
		int result = chartMapper.insertPi(piVO);
		if(result == 0) return "FAILED";
		return "SUCCESS";
	}

	@Override
	public String insertTxPlan(TxPlanVO txpVO) {
		int result = chartMapper.insertTxPlan(txpVO);
		if(result == 0) return "FAILED";
		return "SUCCESS";
	}

	@Override
	public String insertTx(TxVO txVO) {
		int result = chartMapper.insertTx(txVO);
		if(result == 0) return "FAILED";
		return "SUCCESS";
	}

	@Override
	public String insertTxNext(TxNextVO txnVO) {
		int result = chartMapper.insertTxNext(txnVO);
		if(result == 0) return "FAILED";
		return "SUCCESS";
	}

	/*
	@Transactional
	@Override
	public Map<String, Object> listChart(String ptNum) {

		Map<String, Object> chartMap = new HashMap<>();
		chartMap.put("piList", chartMapper.listPtPi(ptNum));
		chartMap.put("txpList", chartMapper.listPtTxPlan(ptNum));
		chartMap.put("txList", chartMapper.listPtTx(ptNum));
		chartMap.put("txnList", chartMapper.listPtTxNext(ptNum));

		return chartMap;
	}
	*/

	@Override
	public List<CheckupVO> listChart(String ptNum) {
		return chartMapper.listChart(ptNum);
	}

	@Override
	public QuestionnaireVO listMedicalAlerts(String ptNum) {
		return chartMapper.listMedicalAlerts(ptNum);
	}

	@Override
	public String deletePi(PiVO piVO) {
		String chkNum = piVO.getChkNum();
		int result = chartMapper.checkPiTxDt(chkNum);
		if(result == 0) return "DENIED";

		result = chartMapper.deletePi(piVO);
		if(result == 0) return "FAILED";
		return "SUCCESS";
	}

	@Override
	public String deleteTxPlan(TxPlanVO txpVO) {
		String chkNum = txpVO.getChkNum();
		int result = chartMapper.checkPiTxDt(chkNum);
		if(result == 0) return "DENIED";

		result = chartMapper.deleteTxPlan(txpVO);
		if(result == 0) return "FAILED";
		return "SUCCESS";
	}

	@Override
	public String deleteTx(TxVO txVO) {
		String chkNum = txVO.getChkNum();
		int result = chartMapper.checkPiTxDt(chkNum);
		if(result == 0) return "DENIED";

		result = chartMapper.deleteTx(txVO);
		if(result == 0) return "FAILED";
		return "SUCCESS";
	}

	@Override
	public String deleteTxNext(TxNextVO txnVO) {
		String chkNum = txnVO.getChkNum();
		int result = chartMapper.checkPiTxDt(chkNum);
		if(result == 0) return "DENIED";

		result = chartMapper.deleteTxNext(txnVO);
		if(result == 0) return "FAILED";
		return "SUCCESS";
	}

	@Override
	public List<TxVO> listCheckupCost(String chkNum) {
		return chartMapper.listCheckupCost(chkNum);
	}

	@Override
	public List<TxVO> selectToothHist(Map<String, String> searchMap) {
		return chartMapper.selectToothHist(searchMap);
	}

}
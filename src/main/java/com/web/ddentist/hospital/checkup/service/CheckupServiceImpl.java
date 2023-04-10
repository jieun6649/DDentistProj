package com.web.ddentist.hospital.checkup.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.web.ddentist.mapper.CheckupMapper;
import com.web.ddentist.vo.CheckupVO;
import com.web.ddentist.vo.MediaVO;
import com.web.ddentist.vo.PatientVO;

@Service
public class CheckupServiceImpl implements ICheckupService {
	
	@Autowired
	private CheckupMapper checkupMapper;
	
	@Override
	public List<PatientVO> searchPt(String keyword) {
		return checkupMapper.searchPt(keyword);
	}
	
	@Override
	public List<CheckupVO> listChart(Map<String, String> searchMap) {
		return checkupMapper.listChart(searchMap);
	}
	
//	@Transactional
//	@Override
//	public Map<String, Object> listChart(Map<String, String> searchMap) {
//		
//		Map<String, Object> chartMap = new HashMap<>();
//		chartMap.put("piList", checkupMapper.listPtPi(searchMap));
//		chartMap.put("txpList", checkupMapper.listPtTxPlan(searchMap));
//		chartMap.put("txList", checkupMapper.listPtTx(searchMap));
//		chartMap.put("txnList", checkupMapper.listPtTxNext(searchMap));
//		
//		return chartMap;
//	}
	
	@Override
	public MediaVO selectMedia(String medNum) {
		return checkupMapper.selectMedia(medNum);
	}
	
}

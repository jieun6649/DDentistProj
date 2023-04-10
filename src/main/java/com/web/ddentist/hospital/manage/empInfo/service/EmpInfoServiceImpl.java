package com.web.ddentist.hospital.manage.empInfo.service;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.web.ddentist.mapper.EmpInfoMapper;
import com.web.ddentist.vo.CommonCodeVO;
import com.web.ddentist.vo.DepartmentVO;
import com.web.ddentist.vo.EmployeeVO;
import com.web.ddentist.vo.JbgdVO;

import lombok.extern.slf4j.Slf4j;
@Slf4j
@Service
public class EmpInfoServiceImpl implements IEmpInfoService {

	@Autowired
	private EmpInfoMapper empInfoMapper;
	@Autowired
	private BCryptPasswordEncoder passwordEncoder;

	// 직원 등록
	@Override
	public int createEmp(EmployeeVO employeeVO) {
		log.info("서비스 employeeVO : " + employeeVO);

		String empBrdt = employeeVO.getEmpBrdt();
		empBrdt = empBrdt.replace("-", "");
		employeeVO.setEmpBrdt(empBrdt);
		log.info("1서비스 employeeVO : " + employeeVO);

		String empJncmpYmd = employeeVO.getEmpJncmpYmd();
		empJncmpYmd = empJncmpYmd.replace("-", "");
		employeeVO.setEmpJncmpYmd(empJncmpYmd);
		log.info("2서비스 employeeVO : " + employeeVO);


		String empRtrmYmd = employeeVO.getEmpRtrmYmd();
		log.info("서비스 empRtrmYmd : " + empRtrmYmd);
		if(empRtrmYmd != null && !empRtrmYmd.equals("")) {
			empRtrmYmd = empRtrmYmd.replace("-", "");
			employeeVO.setEmpRtrmYmd(empRtrmYmd);
		}
		log.info(" after employeeVO : " + employeeVO);

		// 비밀번호 암호화
		String empPw = passwordEncoder.encode(employeeVO.getEmpPw());
		employeeVO.setEmpPw(empPw);

		int result = this.empInfoMapper.createEmp(employeeVO);
		log.info("삽입 result : " + result);
		return result;
	}

	// 사번 자동생성
	public String getEmpNum() {

		String empNum = this.empInfoMapper.getEmpNum();
		log.info("사번 자동생성 getEmpNum() {} : " + empNum);

		return empNum;
	}

	// 직원 정보 조회
	@Override
	public EmployeeVO getEmpInfo(EmployeeVO empVO) {
		EmployeeVO vo = this.empInfoMapper.getEmpInfo(empVO);

		log.info("직원 vo : " + vo);

		return vo;
	}

	// 직원 정보 수정
	@Override
	public int updateEmp(EmployeeVO employeeVO) {

		String empBrdt = employeeVO.getEmpBrdt();
		empBrdt = empBrdt.replace("-", "");
		employeeVO.setEmpBrdt(empBrdt);

		String empJncmpYmd = employeeVO.getEmpJncmpYmd();
		empJncmpYmd = empJncmpYmd.replace("-", "");
		employeeVO.setEmpJncmpYmd(empJncmpYmd);

		String empRtrmYmd = employeeVO.getEmpRtrmYmd();
		if(empRtrmYmd != null && !empRtrmYmd.equals("")) {
			empRtrmYmd = empRtrmYmd.replace("-", "");
			employeeVO.setEmpRtrmYmd(empRtrmYmd);
		}

		return this.empInfoMapper.updateEmp(employeeVO);
	}

	// 직원 정보 삭제
	@Override
	public int deleteEmp(EmployeeVO employeeVO) {
		return this.empInfoMapper.deleteEmp(employeeVO);
	}

	// 직급 리스트
	public List<JbgdVO> getJbgd(){
		return this.empInfoMapper.getJbgd();
	}

	// 부서 리스트
	public List<DepartmentVO> getDept(){
		return this.empInfoMapper.getDept();
	}

	// 부서 추가
	@Override
	public int createDept(DepartmentVO departmentVO) {
		return this.empInfoMapper.createDept(departmentVO);
	}

	// 부서 삭제
	@Override
	public int deleteDept(DepartmentVO departmentVO) {
		return this.empInfoMapper.deleteDept(departmentVO);
	}

	// 부서 수정
	@Override
	public int updateDept(DepartmentVO departmentVO) {
		return this.empInfoMapper.updateDept(departmentVO);
	}


	// 직급 추가
	@Override
	public int createJbgd(JbgdVO jbgdVO) {
		return this.empInfoMapper.createJbgd(jbgdVO);
	}

	// 직급 수정
	@Override
	public int updateJbgd(JbgdVO jbgdVO) {
		return this.empInfoMapper.updateJbgd(jbgdVO);
	}

	// 직급 삭제
	@Override
	public int deleteJbgd(JbgdVO jbgdVO) {
		return this.empInfoMapper.deleteJbgd(jbgdVO);
	}

	// 공통 코드
	@Override
	public List<CommonCodeVO> getCommon(String commGrCd) {
		List<CommonCodeVO> hdpfYnList =  this.empInfoMapper.getCommon(commGrCd);
		log.info("hdpfYnList 직원 재직여부 : {} " + hdpfYnList);
		return hdpfYnList;
	}

	// 검색키워드와 페이징처리 결과 직원목록 가져오기
	@Override
	public List<EmployeeVO> getList(Map<String, String> param) {
		return this.empInfoMapper.getList(param);
	}

	// 직원 사진 삭제
	@Override
	public int deleteFile(EmployeeVO employeeVO) {
		String empImg = this.empInfoMapper.getEmpImg(employeeVO);
		if(empImg == null) return 0;

		Path imgFilePath = Paths.get(System.getProperty("user.dir").replace("\\eclipse", "")
				+ "\\workspace\\DDentistProj\\src\\main\\webapp\\resources\\images\\employee", empImg.replace("/", "\\\\"));
		Path thumbFilePath = Paths.get(System.getProperty("user.dir").replace("\\eclipse", "")
				+ "\\workspace\\DDentistProj\\src\\main\\webapp\\resources\\images\\employee", empImg.replace("/s_", "/").replace("/", "\\\\"));

		try {
			Files.deleteIfExists(imgFilePath);
			Files.deleteIfExists(thumbFilePath);
		} catch (Exception e) {
			return 0;
		}

		return this.empInfoMapper.deleteFile(employeeVO);
	}

	// 검색값에 따른 전체 행의 수
	@Override
	public int getTotal(Map<String, String> param) {

		return this.empInfoMapper.getTotal(param);
	}

	// 비밀번호 변경
	@Override
	public int changePassword(EmployeeVO vo) {
		// 비밀번호 암호화
		String empPw = passwordEncoder.encode(vo.getEmpPw());
		vo.setEmpPw(empPw);
		return this.empInfoMapper.changePassword(vo);
	}

	@Override
	public String checkId(EmployeeVO employeeVo) {
		int result = this.empInfoMapper.checkId(employeeVo);
		if(result == 0) return "SUCCESS"; // 중복되는 아이디 없음
		return "FAILED";
	}

}

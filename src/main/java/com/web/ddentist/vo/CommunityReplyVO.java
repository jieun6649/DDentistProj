package com.web.ddentist.vo;

import lombok.Data;

@Data
public class CommunityReplyVO {
	private int replyNum;
	private int comNum;
	private String ptNum;
	private String replyContent;
	private String replyDt;
	private int targetReplyNum;
	private int lvl;
	
	
	private String replyDtStr;
	private String ptId;
	private String ptNm;
	private String empNum;
	private String empNm;
	private String empId;
	
	//COMMUNITY_REPLY(B) : PATIENT(P2) = 1 : 1
	private PatientVO patientVO;
	
	//COMMUNITY_REPLY(B) : EMPLOYEE(E) = 1 : 1
	private EmployeeVO employeeVO;
}

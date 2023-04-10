package com.web.ddentist.chat.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.web.ddentist.chat.service.IChatService;
import com.web.ddentist.vo.ChatMemberVO;
import com.web.ddentist.vo.EmployeeVO;

public class ChatHandler extends TextWebSocketHandler {

	@Autowired
	private IChatService chatService;

	private static Map<String, WebSocketSession> connectedSessions = new HashMap<>();
	private static Map<Integer, List<WebSocketSession>> chatGroup = new HashMap<>();

	private static final String CHATDATA_SEPERATOR = "$//##";
	private static final String CHATCONTENT_SEPERATOR = "$/:/##";

	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {

		String empId = session.getPrincipal().getName();

		// 직원 정보 조회
		EmployeeVO empInfo = chatService.empInfo(empId);
		session.getAttributes().put("empInfo", empInfo);

		String empNum = empInfo.getEmpNum();
		connectedSessions.put(empNum, session);

		// 접속한 직원이 속한 채팅 그룹 번호를 가져옴
		List<Integer> chatgroupNum = chatService.chatgrpNum(empNum);

		for(int num : chatgroupNum) {
			// 채팅 그룹에 직원을 포함시킴
			// 채팅 그룹이 새로 생성된 경우 새로운 채팅 그룹을 ChatHandler에 추가
			chatGroup.computeIfAbsent(num, v -> new ArrayList<>()).add(session);
		}
	}

	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {

		String[] messageContent = message.getPayload().split("\\" + CHATDATA_SEPERATOR);
		int chatgrpNum = Integer.parseInt(messageContent[0]);
		String chatContent = messageContent[1];

		// 채팅 내용을 DB에 저장
		chatService.chat(session, chatgrpNum, chatContent);

		EmployeeVO empInfo = (EmployeeVO) session.getAttributes().get("empInfo");

		TextMessage msgContent = new TextMessage(chatgrpNum + CHATDATA_SEPERATOR + empInfo.getEmpNm() + CHATCONTENT_SEPERATOR
												+ chatContent + CHATDATA_SEPERATOR + empInfo.getEmpNum() + CHATDATA_SEPERATOR + empInfo.getEmpImg());
		// 채팅을 현재 접속 중인 직원들에게 전송
		for(WebSocketSession receiver : chatGroup.get(chatgrpNum)) {
			receiver.sendMessage(msgContent);
		}
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		chatGroup.keySet().forEach(chatgrpNum -> chatGroup.get(chatgrpNum).remove(session));
	}

	// 새 채팅방 생성
	public void newChatgrpCreated(int chatgrpNum, List<ChatMemberVO> chatMemList) {

		List<WebSocketSession> newChatGroup = new ArrayList<>();
		for(ChatMemberVO chatMem : chatMemList) {
			WebSocketSession session = connectedSessions.get(chatMem.getEmpNum());
			if(session == null) continue;
			newChatGroup.add(session);
		}
		chatGroup.put(chatgrpNum, newChatGroup);
	}

	// 기존 채팅방에 새 멤버 초대
	public void newMemInvited(int chatgrpNum, List<ChatMemberVO> invitedMemList) throws IOException {

		List<WebSocketSession> chatMemList = chatGroup.get(chatgrpNum);
		for(ChatMemberVO chatMem : invitedMemList) {
			WebSocketSession session = connectedSessions.get(chatMem.getEmpNum());
			if(session == null) continue;
			chatMemList.add(session);
		}

		StringBuilder sb = new StringBuilder();
		for(int i = 0; i < invitedMemList.size(); i++) {
			if(i > 0) sb.append(", ");
			sb.append(invitedMemList.get(i).getEmpNm());
		}
		sb.append("(이)가 채팅에 참여했습니다.");

		sendSystemMessage(chatgrpNum, sb.toString());
	}

	// 채팅방에서 나감
	public void memExitedChatgrp(ChatMemberVO chatMemVO) throws IOException {

		int chatgrpNum = chatMemVO.getChatgrpNum();
		String systemMessage = chatMemVO.getEmpNm() + "님이 퇴장했습니다.";

		sendSystemMessage(chatgrpNum, systemMessage);
	}

	// 초대, 퇴장 시스템 메시지 전송
	private void sendSystemMessage(int chatgrpNum, String systemMessage) throws IOException {
		chatService.systemChat(chatgrpNum, systemMessage);
		TextMessage msgContent = new TextMessage(chatgrpNum + CHATDATA_SEPERATOR + "시스템" + CHATCONTENT_SEPERATOR + systemMessage
												+ CHATDATA_SEPERATOR + "SYSTEM" + CHATDATA_SEPERATOR + "null");
		for(WebSocketSession receiver : chatGroup.get(chatgrpNum)) {
			receiver.sendMessage(msgContent);
		}
	}

}

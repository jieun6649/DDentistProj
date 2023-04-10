package com.web.ddentist.mapper;

import java.util.List;

import com.web.ddentist.vo.BannerVO;

public interface BannerMapper {
	
//	<!-- 배너 등록하기 -->
//	<insert id="uploadFormAction" parameterType="bannerVO">
	public int uploadFormAction(BannerVO bannerVO);
	
//	<!-- 등록된 배너 가져오기 -->
//	<select id="getImgs" resultType="bannerVO">
	public List<BannerVO> getImgs();
	
//	<!-- 배너 선택하기로 상태 바꾸기 -->
//	<update id="updateStatus" parameterType="int">
	public int updateStatus(int intBannerNum);
	
//	<!-- 선택한 배너 사진 삭제하기 -->
//	<delete id="deleteBanner" parameterType="int">
	public int deleteBanner(int intBannerNum);
	
//	<!-- 배너 취소로 상태 바꾸기 -->
//	<update id="updateStatusCancel" parameterType="int">
	public int updateStatusCancel(int intBannerNum);

}

package com.web.ddentist.hospital.site.bannerInfo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.web.ddentist.mapper.BannerMapper;
import com.web.ddentist.vo.BannerVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class BannerServiceImpl implements BannerService {
	
	@Autowired
	BannerMapper bannerMapper;
	
//	<!-- 배너 등록하기 -->
//	<insert id="uploadFormAction" parameterType="bannerVO">
	@Override
	public int uploadFormAction(BannerVO bannerVO) {
		return this.bannerMapper.uploadFormAction(bannerVO);
	};
	
//	<!-- 등록된 배너 가져오기 -->
//	<select id="getImgs" resultType="bannerVO">
	@Override
	public List<BannerVO> getImgs(){
		List<BannerVO> list = this.bannerMapper.getImgs();
		log.info("list : " + list);
		return list;
	};
	
//	<!-- 배너 선택하기로 상태 바꾸기 -->
//	<update id="updateStatus" parameterType="int">
	@Override
	public int updateStatus(String bannerNum) {
		String[] arr = null;
		int result = 0;
		arr = bannerNum.split(",");
		log.info("arr : " + arr);
		for(int i=0;i<arr.length;i++) {
			int intBannerNum = Integer.parseInt(arr[i]);
			result = result + this.bannerMapper.updateStatus(intBannerNum);
		}
		return result;
	};
	
//	<!-- 선택한 배너 사진 삭제하기 -->
//	<delete id="deleteBanner" parameterType="int">
	@Override
	public int deleteBanner(String bannerNum) {
		log.info("bannerNum : " + bannerNum);
		String[] arr = null;
		int result = 0;
		arr = bannerNum.split(",");
		log.info("arr : " + arr);
		for(int i=0;i<arr.length;i++) {
			int intBannerNum = Integer.parseInt(arr[i]);
			result = result + this.bannerMapper.deleteBanner(intBannerNum);
		}
		log.info("result : " + result);
		return result;
	};
	
//	<!-- 배너 취소로 상태 바꾸기 -->
//	<update id="updateStatusCancel" parameterType="int">
	@Override
	public int updateStatusCancel(String bannerNum) {
		String[] arr = null;
		int result = 0;
		arr = bannerNum.split(",");
		log.info("arr : " + arr);
		for(int i=0;i<arr.length;i++) {
			int intBannerNum = Integer.parseInt(arr[i]);
			result = result + this.bannerMapper.updateStatusCancel(intBannerNum);
		}
		return result;
	};
}

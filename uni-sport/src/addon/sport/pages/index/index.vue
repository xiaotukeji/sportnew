<template>
  <view class="sport-index">
    <!-- 页面头部 -->
    <view class="header">
      <view class="title">运动会助手</view>
      <view class="subtitle">专业的比赛管理平台</view>
    </view>

    <!-- 主要内容区域 -->
    <view class="main-content">
      <!-- 创建比赛按钮 -->
      <view class="create-button-wrapper">
        <u-button 
          type="primary" 
          size="large"
          shape="round"
          :custom-style="buttonStyle"
          @click="handleCreateEvent"
        >
          <u-icon name="plus-circle" size="20" margin-right="8"></u-icon>
          创建比赛
        </u-button>
      </view>

      <!-- 功能介绍 -->
      <view class="features">
        <view class="feature-item">
          <u-icon name="trophy" size="24" color="#409eff"></u-icon>
          <text class="feature-text">专业比赛管理</text>
        </view>
        <view class="feature-item">
          <u-icon name="account" size="24" color="#67c23a"></u-icon>
          <text class="feature-text">参赛人员管理</text>
        </view>
        <view class="feature-item">
          <u-icon name="data" size="24" color="#e6a23c"></u-icon>
          <text class="feature-text">成绩统计分析</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useLoginCheck } from '@/addon/sport/hooks/useLoginCheck'

// 登录检查工具
const { requireLogin } = useLoginCheck()

// 按钮样式
const buttonStyle = computed(() => ({
  width: '280rpx',
  height: '88rpx',
  fontSize: '32rpx',  
  fontWeight: 'bold',
  background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
  border: 'none',
  boxShadow: '0 8rpx 16rpx rgba(102, 126, 234, 0.3)'
}))

/**
 * 创建比赛按钮点击事件
 */
const handleCreateEvent = () => {
  requireLogin(() => {
    uni.navigateTo({
      url: '/addon/sport/pages/event/create_simple?clearCache=1'
    })
  }, '/addon/sport/pages/index/index')
}
</script>

<style lang="scss" scoped>
.sport-index {
  min-height: 100vh;
  background: linear-gradient(180deg, #f8faff 0%, #ffffff 100%);
  padding: 0 32rpx;
}

.header {
  text-align: center;
  padding: 80rpx 0 60rpx;
  
  .title {
    font-size: 48rpx;
    font-weight: bold;
    color: #2c3e50;
    margin-bottom: 16rpx;
  }
  
  .subtitle {
    font-size: 28rpx;
    color: #7f8c8d;
  }
}

.main-content {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.create-button-wrapper {
  margin-bottom: 120rpx;
}

.features {
  width: 100%;
  display: flex;
  justify-content: space-around;
  padding: 0 40rpx;
  
  .feature-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    
    .feature-text {
      font-size: 24rpx;
      color: #606266;
      margin-top: 16rpx;
    }
  }
}
</style> 
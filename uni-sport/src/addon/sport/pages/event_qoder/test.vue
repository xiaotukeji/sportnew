<template>
  <view class="test-container">
    <view class="header">
      <text class="title">赛事助手功能测试</text>
    </view>
    
    <view class="content">
      <view class="test-section">
        <text class="section-title">页面测试</text>
        <view class="test-item">
          <text class="item-label">一站式创建赛事页面</text>
          <button class="test-btn" @tap="navigateToCreate">测试</button>
        </view>
        <view class="test-item">
          <text class="item-label">赛事详情页面</text>
          <button class="test-btn" @tap="navigateToDetail">测试</button>
        </view>
      </view>
      
      <view class="test-section">
        <text class="section-title">API测试</text>
        <view class="test-item">
          <text class="item-label">创建赛事接口</text>
          <button class="test-btn" @tap="testCreateEvent">测试</button>
        </view>
        <view class="test-item">
          <text class="item-label">初始化数据接口</text>
          <button class="test-btn" @tap="testInitData">测试</button>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref } from 'vue'
import { useLoginCheck } from '@/addon/sport/hooks/useLoginCheck'
import { addEventQoder, getEventQoderInit } from '@/addon/sport/api/eventQoder'

// 登录检查
const { requireLogin } = useLoginCheck()

// 方法
const navigateToCreate = () => {
  uni.navigateTo({
    url: '/addon/sport/pages/event_qoder/create-all-in-one'
  })
}

const navigateToDetail = () => {
  // 这里需要一个实际的赛事ID进行测试
  uni.showToast({
    title: '请先创建赛事再测试详情页面',
    icon: 'none'
  })
}

const testCreateEvent = async () => {
  try {
    uni.showLoading({
      title: '测试中...'
    })
    
    // 测试数据
    const testData = {
      name: '测试赛事',
      location: '测试地点',
      address_detail: '详细地址',
      start_date: '2023-10-01',
      start_time: '09:00',
      end_date: '2023-10-01',
      end_time: '17:00',
      organizer_id: 1,
      event_type: 1,
      base_item_ids: [1, 2]
    }
    
    const result = await addEventQoder(testData)
    
    uni.hideLoading()
    
    if (result.code === 1) {
      uni.showToast({
        title: '接口调用成功',
        icon: 'success'
      })
    } else {
      uni.showToast({
        title: result.msg || '接口调用失败',
        icon: 'none'
      })
    }
  } catch (error) {
    uni.hideLoading()
    uni.showToast({
      title: '接口调用异常',
      icon: 'none'
    })
    console.error('测试创建赛事接口失败:', error)
  }
}

const testInitData = async () => {
  try {
    uni.showLoading({
      title: '测试中...'
    })
    
    const result = await getEventQoderInit()
    
    uni.hideLoading()
    
    if (result.code === 1) {
      uni.showToast({
        title: '接口调用成功',
        icon: 'success'
      })
      console.log('初始化数据:', result.data)
    } else {
      uni.showToast({
        title: result.msg || '接口调用失败',
        icon: 'none'
      })
    }
  } catch (error) {
    uni.hideLoading()
    uni.showToast({
      title: '接口调用异常',
      icon: 'none'
    })
    console.error('测试初始化数据接口失败:', error)
  }
}
</script>

<style lang="scss" scoped>
.test-container {
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20rpx;
}

.header {
  text-align: center;
  padding: 40rpx 0;
  
  .title {
    font-size: 48rpx;
    font-weight: bold;
    color: #fff;
  }
}

.content {
  .test-section {
    background: rgba(255, 255, 255, 0.95);
    border-radius: 20rpx;
    padding: 30rpx;
    margin-bottom: 30rpx;
    
    .section-title {
      display: block;
      font-size: 36rpx;
      font-weight: bold;
      color: #333;
      margin-bottom: 30rpx;
      text-align: center;
    }
    
    .test-item {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 20rpx 0;
      border-bottom: 1rpx solid #f0f0f0;
      
      &:last-child {
        border-bottom: none;
      }
      
      .item-label {
        font-size: 28rpx;
        color: #333;
      }
      
      .test-btn {
        padding: 15rpx 30rpx;
        background: #667eea;
        color: #fff;
        border-radius: 30rpx;
        border: none;
        font-size: 24rpx;
      }
    }
  }
}
</style>

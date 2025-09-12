<template>
  <view class="signup-success-page">
    <!-- 成功状态 -->
    <view class="success-status">
      <view class="success-icon">
        <text class="icon">✓</text>
      </view>
      <text class="success-title">报名成功</text>
      <text class="success-desc">您的报名信息已提交，请等待审核</text>
    </view>

    <!-- 报名信息卡片 -->
    <view class="registration-info-card">
      <view class="card-header">
        <text class="card-title">报名信息</text>
        <text class="registration-no">报名号：{{ registrationNo }}</text>
      </view>
      <view class="card-content">
        <view class="info-item">
          <text class="info-label">赛事名称</text>
          <text class="info-value">{{ eventInfo.name }}</text>
        </view>
        <view class="info-item">
          <text class="info-label">比赛时间</text>
          <text class="info-value">{{ eventInfo.start_time_text }}</text>
        </view>
        <view class="info-item">
          <text class="info-label">比赛地点</text>
          <text class="info-value">{{ eventInfo.location }}</text>
        </view>
        <view class="info-item">
          <text class="info-label">参赛项目</text>
          <text class="info-value">{{ selectedProjectsText }}</text>
        </view>
        <view class="info-item">
          <text class="info-label">参赛人数</text>
          <text class="info-value">{{ participants.length }}人</text>
        </view>
        <view class="info-item">
          <text class="info-label">报名费用</text>
          <text class="info-value fee">￥{{ totalFee }}</text>
        </view>
      </view>
    </view>

    <!-- 参赛人员信息 -->
    <view class="participants-card">
      <view class="card-header">
        <text class="card-title">参赛人员</text>
      </view>
      <view class="card-content">
        <view 
          v-for="(participant, index) in participants" 
          :key="index"
          class="participant-item"
        >
          <view class="participant-header">
            <text class="participant-name">{{ participant.name }}</text>
            <text class="participant-mobile">{{ participant.mobile }}</text>
          </view>
          <view class="participant-details">
            <text class="detail-item">身份证：{{ participant.id_card }}</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 费用明细 -->
    <view class="fee-details-card">
      <view class="card-header">
        <text class="card-title">费用明细</text>
      </view>
      <view class="card-content">
        <view 
          v-for="(fee, index) in feeDetails" 
          :key="index"
          class="fee-item"
        >
          <text class="fee-name">{{ fee.name }}</text>
          <text class="fee-amount">￥{{ fee.amount }}</text>
        </view>
        <view class="fee-total">
          <text class="total-label">总计</text>
          <text class="total-amount">￥{{ totalFee }}</text>
        </view>
      </view>
    </view>

    <!-- 重要提醒 -->
    <view class="notice-card">
      <view class="card-header">
        <text class="card-title">重要提醒</text>
      </view>
      <view class="card-content">
        <view class="notice-list">
          <view class="notice-item">
            <text class="notice-icon">📋</text>
            <text class="notice-text">请保存好报名号，用于后续查询和确认</text>
          </view>
          <view class="notice-item">
            <text class="notice-icon">📱</text>
            <text class="notice-text">请保持手机畅通，我们会及时通知您相关信息</text>
          </view>
          <view class="notice-item">
            <text class="notice-icon">⏰</text>
            <text class="notice-text">请按时参加比赛，逾期视为自动放弃</text>
          </view>
          <view class="notice-item">
            <text class="notice-icon">📞</text>
            <text class="notice-text">如有疑问请联系主办方：{{ eventInfo.contact_phone }}</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 操作按钮 -->
    <view class="action-buttons">
      <button class="action-btn secondary" @click="viewRegistration">
        查看报名详情
      </button>
      <button class="action-btn primary" @click="shareRegistration">
        分享给朋友
      </button>
    </view>

    <!-- 底部安全区域 -->
    <view class="safe-area-bottom"></view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { getEventDetailInfo } from '@/addon/sport/api/event'

// 页面参数
const eventId = ref<number>(0)

// 数据状态
const eventInfo = ref<any>({})
const registrationNo = ref<string>('')
const selectedProjects = ref<any[]>([])
const participants = ref<any[]>([])
const feeDetails = ref<any[]>([])
const totalFee = ref<number>(0)

// 页面初始化
onMounted(() => {
  const pages = getCurrentPages()
  const currentPage = pages[pages.length - 1]
  eventId.value = parseInt(currentPage.options?.event_id || '0')
  
  if (eventId.value) {
    loadPageData()
  }
})

// 加载页面数据
const loadPageData = async () => {
  try {
    // 加载赛事信息
    await loadEventInfo()
    
    // 模拟从本地存储或接口获取报名信息
    loadRegistrationData()
  } catch (error) {
    console.error('加载页面数据失败:', error)
    uni.showToast({
      title: '加载失败',
      icon: 'error'
    })
  }
}

// 加载赛事信息
const loadEventInfo = async () => {
  try {
    const response = await getEventDetailInfo(eventId.value)
    if (response.code === 1) {
      eventInfo.value = response.data
    }
  } catch (error) {
    console.error('加载赛事信息失败:', error)
  }
}

// 加载报名数据（模拟）
const loadRegistrationData = () => {
  // 这里应该从接口获取实际的报名数据
  // 现在使用模拟数据
  registrationNo.value = 'SP' + Date.now()
  
  selectedProjects.value = [
    { id: 1, name: '100米短跑', fee: 50 },
    { id: 2, name: '200米短跑', fee: 50 }
  ]
  
  participants.value = [
    {
      name: '张三',
      mobile: '13800138000',
      id_card: '110101199001011234'
    },
    {
      name: '李四',
      mobile: '13800138001',
      id_card: '110101199001011235'
    }
  ]
  
  feeDetails.value = [
    { name: '100米短跑', amount: 50 },
    { name: '200米短跑', amount: 50 }
  ]
  
  totalFee.value = 100
}

// 计算属性
const selectedProjectsText = computed(() => {
  return selectedProjects.value.map(project => project.name).join('、')
})

// 方法
const viewRegistration = () => {
  // 跳转到报名详情页面
  uni.navigateTo({
    url: `/addon/sport/pages/event/registration_detail?registration_no=${registrationNo.value}`
  })
}

const shareRegistration = () => {
  uni.share({
    provider: 'weixin',
    scene: 'WXSceneSession',
    type: 0,
    href: `/addon/sport/pages/event/signup_show?event_id=${eventId.value}`,
    title: `我报名了${eventInfo.value.name}，一起来参加吧！`,
    summary: `比赛时间：${eventInfo.value.start_time_text}\n比赛地点：${eventInfo.value.location}`,
    imageUrl: ''
  })
}
</script>

<style lang="scss" scoped>
.signup-success-page {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding: 40rpx 30rpx;
}

.success-status {
  text-align: center;
  margin-bottom: 60rpx;

  .success-icon {
    width: 120rpx;
    height: 120rpx;
    background: #67c23a;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 30rpx;

    .icon {
      font-size: 60rpx;
      color: #fff;
      font-weight: bold;
    }
  }

  .success-title {
    display: block;
    font-size: 36rpx;
    font-weight: 500;
    color: #333;
    margin-bottom: 16rpx;
  }

  .success-desc {
    font-size: 26rpx;
    color: #666;
  }
}

.registration-info-card,
.participants-card,
.fee-details-card,
.notice-card {
  background: #fff;
  border-radius: 16rpx;
  margin-bottom: 30rpx;
  overflow: hidden;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.1);

  .card-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 30rpx;
    border-bottom: 1rpx solid #eee;
    background: #f8f9fa;

    .card-title {
      font-size: 32rpx;
      font-weight: 500;
      color: #333;
    }

    .registration-no {
      font-size: 24rpx;
      color: #409EFF;
      background: #e3f2fd;
      padding: 8rpx 16rpx;
      border-radius: 12rpx;
    }
  }

  .card-content {
    padding: 30rpx;
  }
}

.registration-info-card {
  .info-item {
    display: flex;
    margin-bottom: 20rpx;

    &:last-child {
      margin-bottom: 0;
    }

    .info-label {
      width: 120rpx;
      font-size: 28rpx;
      color: #666;
      flex-shrink: 0;
    }

    .info-value {
      flex: 1;
      font-size: 28rpx;
      color: #333;

      &.fee {
        color: #f56c6c;
        font-weight: 500;
      }
    }
  }
}

.participants-card {
  .participant-item {
    padding: 24rpx 0;
    border-bottom: 1rpx solid #eee;

    &:last-child {
      border-bottom: none;
    }

    .participant-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 12rpx;

      .participant-name {
        font-size: 30rpx;
        font-weight: 500;
        color: #333;
      }

      .participant-mobile {
        font-size: 26rpx;
        color: #666;
      }
    }

    .participant-details {
      .detail-item {
        font-size: 24rpx;
        color: #999;
      }
    }
  }
}

.fee-details-card {
  .fee-item {
    display: flex;
    justify-content: space-between;
    padding: 16rpx 0;
    border-bottom: 1rpx solid #eee;

    .fee-name {
      font-size: 28rpx;
      color: #333;
    }

    .fee-amount {
      font-size: 28rpx;
      color: #f56c6c;
      font-weight: 500;
    }
  }

  .fee-total {
    display: flex;
    justify-content: space-between;
    padding: 20rpx 0 0;
    margin-top: 16rpx;
    border-top: 2rpx solid #eee;

    .total-label {
      font-size: 30rpx;
      font-weight: 500;
      color: #333;
    }

    .total-amount {
      font-size: 32rpx;
      font-weight: 500;
      color: #f56c6c;
    }
  }
}

.notice-card {
  .notice-list {
    .notice-item {
      display: flex;
      align-items: flex-start;
      margin-bottom: 20rpx;

      &:last-child {
        margin-bottom: 0;
      }

      .notice-icon {
        font-size: 32rpx;
        margin-right: 16rpx;
        margin-top: 4rpx;
      }

      .notice-text {
        flex: 1;
        font-size: 26rpx;
        color: #666;
        line-height: 1.5;
      }
    }
  }
}

.action-buttons {
  display: flex;
  gap: 20rpx;
  margin-top: 40rpx;

  .action-btn {
    flex: 1;
    height: 88rpx;
    border: none;
    border-radius: 12rpx;
    font-size: 28rpx;
    font-weight: 500;

    &.primary {
      background: #409EFF;
      color: #fff;
    }

    &.secondary {
      background: #f0f0f0;
      color: #666;
    }
  }
}

.safe-area-bottom {
  height: env(safe-area-inset-bottom);
}
</style>

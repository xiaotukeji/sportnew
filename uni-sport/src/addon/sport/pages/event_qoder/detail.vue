<template>
  <view class="event-detail-container">
    <!-- 顶部导航栏 -->
    <view class="nav-bar">
      <view class="nav-back" @tap="goBack">
        <text class="iconfont icon-arrow-left"></text>
      </view>
      <view class="nav-title">赛事详情</view>
      <view class="nav-actions">
        <text class="iconfont icon-share" @tap="shareEvent"></text>
      </view>
    </view>

    <!-- 赛事封面 -->
    <view class="event-banner">
      <image 
        class="banner-image" 
        :src="eventInfo.banner || defaultBanner" 
        mode="aspectFill"
      ></image>
      <view class="banner-overlay">
        <text class="event-status" :class="statusClass">{{ eventInfo.status_text }}</text>
      </view>
    </view>

    <!-- 赛事基本信息 -->
    <view class="event-info-section">
      <view class="event-header">
        <text class="event-title">{{ eventInfo.name }}</text>
        <view class="event-meta">
          <view class="meta-item">
            <text class="iconfont icon-calendar"></text>
            <text class="meta-text">{{ formatDate(eventInfo.start_time) }} - {{ formatDate(eventInfo.end_time) }}</text>
          </view>
          <view class="meta-item">
            <text class="iconfont icon-location"></text>
            <text class="meta-text">{{ eventInfo.location }}</text>
          </view>
        </view>
      </view>

      <view class="organizer-info">
        <view class="organizer-header">
          <text class="section-title">主办方</text>
        </view>
        <view class="organizer-content">
          <image 
            class="organizer-avatar" 
            :src="eventInfo.organizer_logo || defaultAvatar" 
            mode="aspectFill"
          ></image>
          <view class="organizer-details">
            <text class="organizer-name">{{ eventInfo.organizer_name }}</text>
            <text class="organizer-contact" v-if="eventInfo.contact_name || eventInfo.contact_phone">
              联系人：{{ eventInfo.contact_name }} {{ eventInfo.contact_phone }}
            </text>
          </view>
        </view>
      </view>
    </view>

    <!-- 比赛项目 -->
    <view class="event-section">
      <view class="section-header">
        <text class="section-title">比赛项目</text>
        <text class="section-count">{{ eventItems.length }}个项目</text>
      </view>
      <scroll-view class="items-scroll" scroll-x>
        <view class="items-container">
          <view 
            class="item-card" 
            v-for="item in eventItems" 
            :key="item.id"
          >
            <view class="item-icon" :class="getItemIconClass(item.category_name)">
              <text class="iconfont" :class="getItemIcon(item.category_name)"></text>
            </view>
            <text class="item-name">{{ item.name }}</text>
            <text class="item-desc" v-if="item.description">{{ item.description }}</text>
          </view>
        </view>
      </scroll-view>
    </view>

    <!-- 赛事场地 -->
    <view class="event-section" v-if="eventVenues.length > 0">
      <view class="section-header">
        <text class="section-title">比赛场地</text>
        <text class="section-count">{{ eventVenues.length }}个场地</text>
      </view>
      <view class="venues-container">
        <view 
          class="venue-item" 
          v-for="venue in eventVenues" 
          :key="venue.id"
        >
          <view class="venue-header">
            <text class="venue-name">{{ venue.name }}</text>
            <text class="venue-type">{{ getVenueTypeText(venue.venue_type) }}</text>
          </view>
          <text class="venue-location">{{ venue.location }}</text>
        </view>
      </view>
    </view>

    <!-- 赛事介绍 -->
    <view class="event-section" v-if="eventInfo.description">
      <view class="section-header">
        <text class="section-title">赛事介绍</text>
      </view>
      <view class="description-content">
        <text class="description-text">{{ eventInfo.description }}</text>
      </view>
    </view>

    <!-- 底部操作栏 -->
    <view class="bottom-actions">
      <button class="action-btn secondary" @tap="showQrCode">
        <text class="iconfont icon-qrcode"></text>
        <text class="btn-text">二维码</text>
      </button>
      <button class="action-btn primary" @tap="registerEvent">
        <text class="iconfont icon-edit"></text>
        <text class="btn-text">立即报名</text>
      </button>
    </view>

    <!-- 二维码弹窗 -->
    <uni-popup ref="qrCodePopup" type="center">
      <view class="qr-popup">
        <view class="qr-header">
          <text class="qr-title">赛事二维码</text>
          <text class="iconfont icon-close" @tap="closeQrCode"></text>
        </view>
        <view class="qr-content">
          <image 
            class="qr-image" 
            :src="qrCodeUrl" 
            mode="aspectFit"
          ></image>
          <text class="qr-desc">扫码报名参赛</text>
        </view>
      </view>
    </uni-popup>
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useLoginCheck } from '@/addon/sport/hooks/useLoginCheck'
import { getEventDetail } from '@/addon/sport/api/event'

// 登录检查
const { requireLogin } = useLoginCheck()

// 数据
const eventInfo = ref({
  id: 0,
  name: '',
  banner: '',
  status: 0,
  status_text: '',
  start_time: 0,
  end_time: 0,
  location: '',
  description: '',
  organizer_name: '',
  organizer_logo: '',
  contact_name: '',
  contact_phone: ''
})

const eventItems = ref([])
const eventVenues = ref([])
const qrCodeUrl = ref('')

// 默认图片
const defaultBanner = '/static/images/default_banner.png'
const defaultAvatar = '/static/images/default_avatar.png'

// 弹窗引用
const qrCodePopup = ref(null)

// 计算属性
const statusClass = computed(() => {
  const statusMap = {
    0: 'draft',      // 草稿
    1: 'published',  // 已发布
    2: 'ongoing',    // 进行中
    3: 'finished',   // 已结束
    4: 'cancelled'   // 已取消
  }
  return statusMap[eventInfo.value.status] || 'draft'
})

// 方法
const goBack = () => {
  uni.navigateBack()
}

const shareEvent = () => {
  // #ifdef MP-WEIXIN
  uni.showShareMenu({
    withShareTicket: true,
    menus: ['shareAppMessage', 'shareTimeline']
  })
  // #endif
  
  // #ifndef MP-WEIXIN
  uni.showToast({
    title: '分享功能开发中',
    icon: 'none'
  })
  // #endif
}

const formatDate = (timestamp) => {
  if (!timestamp) return ''
  const date = new Date(timestamp * 1000)
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
}

const getItemIconClass = (categoryName) => {
  const categoryMap = {
    '田径': 'track',
    '游泳': 'swim',
    '篮球': 'basketball',
    '足球': 'football',
    '羽毛球': 'badminton',
    '乒乓球': 'pingpong'
  }
  return categoryMap[categoryName] || 'default'
}

const getItemIcon = (categoryName) => {
  const iconMap = {
    '田径': 'icon-run',
    '游泳': 'icon-swim',
    '篮球': 'icon-basketball',
    '足球': 'icon-football',
    '羽毛球': 'icon-badminton',
    '乒乓球': 'icon-pingpong'
  }
  return iconMap[categoryName] || 'icon-sport'
}

const getVenueTypeText = (venueType) => {
  const typeMap = {
    'track': '田径场',
    'swimming_pool': '游泳池',
    'basketball_court': '篮球场',
    'football_field': '足球场',
    'badminton_court': '羽毛球场',
    'pingpong_table': '乒乓球台'
  }
  return typeMap[venueType] || '其他'
}

const showQrCode = () => {
  // 生成二维码URL（示例）
  qrCodeUrl.value = `https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${encodeURIComponent(window.location.href)}`
  qrCodePopup.value.open()
}

const closeQrCode = () => {
  qrCodePopup.value.close()
}

const registerEvent = () => {
  uni.showToast({
    title: '报名功能开发中',
    icon: 'none'
  })
}

// 加载赛事详情
const loadEventDetail = async (id) => {
  try {
    uni.showLoading({
      title: '加载中...'
    })
    
    const result = await getEventDetail(id)
    
    if (result.code === 1) {
      eventInfo.value = result.data.event || {}
      eventItems.value = result.data.items || []
      eventVenues.value = result.data.venues || []
    } else {
      uni.showToast({
        title: result.msg || '加载失败',
        icon: 'none'
      })
    }
  } catch (error) {
    console.error('加载赛事详情失败:', error)
    uni.showToast({
      title: '加载失败，请重试',
      icon: 'none'
    })
  } finally {
    uni.hideLoading()
  }
}

// 页面初始化
onMounted(() => {
  requireLogin(() => {
    // 获取赛事ID
    const pages = getCurrentPages()
    const currentPage = pages[pages.length - 1]
    const options = currentPage.options || {}
    const eventId = options.id
    
    if (eventId) {
      loadEventDetail(eventId)
    } else {
      uni.showToast({
        title: '参数错误',
        icon: 'none'
      })
      setTimeout(() => {
        uni.navigateBack()
      }, 1500)
    }
  })
})
</script>

<style lang="scss" scoped>
.event-detail-container {
  min-height: 100vh;
  background: #f5f7fa;
  padding-bottom: 120rpx;
}

.nav-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20rpx 30rpx;
  background: #fff;
  position: sticky;
  top: 0;
  z-index: 999;
  box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.05);
  
  .nav-back {
    width: 60rpx;
    height: 60rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    
    .iconfont {
      color: #333;
      font-size: 40rpx;
    }
  }
  
  .nav-title {
    font-size: 36rpx;
    font-weight: bold;
    color: #333;
  }
  
  .nav-actions {
    .iconfont {
      color: #333;
      font-size: 40rpx;
      margin-left: 30rpx;
    }
  }
}

.event-banner {
  position: relative;
  height: 400rpx;
  
  .banner-image {
    width: 100%;
    height: 100%;
  }
  
  .banner-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(to bottom, rgba(0, 0, 0, 0.3), transparent 30%, transparent 70%, rgba(0, 0, 0, 0.5));
    display: flex;
    align-items: flex-end;
    padding: 30rpx;
    
    .event-status {
      padding: 10rpx 20rpx;
      border-radius: 30rpx;
      font-size: 24rpx;
      font-weight: bold;
      
      &.draft {
        background: #ffd700;
        color: #333;
      }
      
      &.published {
        background: #1aad19;
        color: #fff;
      }
      
      &.ongoing {
        background: #ff6b35;
        color: #fff;
      }
      
      &.finished {
        background: #888;
        color: #fff;
      }
      
      &.cancelled {
        background: #e54d42;
        color: #fff;
      }
    }
  }
}

.event-info-section {
  background: #fff;
  margin: -60rpx 30rpx 30rpx;
  border-radius: 20rpx;
  padding: 30rpx;
  box-shadow: 0 10rpx 30rpx rgba(0, 0, 0, 0.08);
  
  .event-header {
    margin-bottom: 30rpx;
    
    .event-title {
      display: block;
      font-size: 40rpx;
      font-weight: bold;
      color: #333;
      margin-bottom: 20rpx;
      line-height: 1.4;
    }
    
    .event-meta {
      .meta-item {
        display: flex;
        align-items: center;
        margin-bottom: 15rpx;
        
        &:last-child {
          margin-bottom: 0;
        }
        
        .iconfont {
          font-size: 32rpx;
          color: #667eea;
          margin-right: 15rpx;
        }
        
        .meta-text {
          font-size: 28rpx;
          color: #666;
        }
      }
    }
  }
  
  .organizer-info {
    .organizer-header {
      margin-bottom: 20rpx;
      
      .section-title {
        font-size: 32rpx;
        font-weight: bold;
        color: #333;
      }
    }
    
    .organizer-content {
      display: flex;
      align-items: center;
      
      .organizer-avatar {
        width: 100rpx;
        height: 100rpx;
        border-radius: 50%;
        margin-right: 20rpx;
        border: 2rpx solid #eee;
      }
      
      .organizer-details {
        flex: 1;
        
        .organizer-name {
          display: block;
          font-size: 30rpx;
          font-weight: bold;
          color: #333;
          margin-bottom: 10rpx;
        }
        
        .organizer-contact {
          display: block;
          font-size: 26rpx;
          color: #666;
        }
      }
    }
  }
}

.event-section {
  background: #fff;
  margin: 0 30rpx 30rpx;
  border-radius: 20rpx;
  padding: 30rpx;
  box-shadow: 0 10rpx 30rpx rgba(0, 0, 0, 0.08);
  
  .section-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 30rpx;
    
    .section-title {
      font-size: 32rpx;
      font-weight: bold;
      color: #333;
    }
    
    .section-count {
      font-size: 24rpx;
      color: #999;
    }
  }
  
  .items-scroll {
    .items-container {
      display: flex;
      gap: 20rpx;
      padding: 10rpx 0;
      
      .item-card {
        flex-shrink: 0;
        width: 200rpx;
        background: #f8f9fa;
        border-radius: 15rpx;
        padding: 20rpx;
        text-align: center;
        
        .item-icon {
          width: 80rpx;
          height: 80rpx;
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          margin: 0 auto 15rpx;
          
          &.track {
            background: linear-gradient(135deg, #667eea, #764ba2);
          }
          
          &.swim {
            background: linear-gradient(135deg, #4facfe, #00f2fe);
          }
          
          &.basketball {
            background: linear-gradient(135deg, #fa709a, #fee140);
          }
          
          &.football {
            background: linear-gradient(135deg, #a8edea, #fed6e3);
          }
          
          &.badminton {
            background: linear-gradient(135deg, #ffecd2, #fcb69f);
          }
          
          &.pingpong {
            background: linear-gradient(135deg, #a8c8ec, #d4a8ec);
          }
          
          &.default {
            background: linear-gradient(135deg, #d299c2, #fef9d7);
          }
          
          .iconfont {
            color: #fff;
            font-size: 40rpx;
          }
        }
        
        .item-name {
          display: block;
          font-size: 26rpx;
          font-weight: bold;
          color: #333;
          margin-bottom: 10rpx;
          line-height: 1.3;
        }
        
        .item-desc {
          display: block;
          font-size: 22rpx;
          color: #999;
          line-height: 1.4;
        }
      }
    }
  }
  
  .venues-container {
    .venue-item {
      padding: 20rpx 0;
      border-bottom: 1rpx solid #f0f0f0;
      
      &:last-child {
        border-bottom: none;
      }
      
      .venue-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 10rpx;
        
        .venue-name {
          font-size: 28rpx;
          font-weight: bold;
          color: #333;
        }
        
        .venue-type {
          font-size: 22rpx;
          color: #667eea;
          background: rgba(102, 126, 234, 0.1);
          padding: 4rpx 12rpx;
          border-radius: 10rpx;
        }
      }
      
      .venue-location {
        font-size: 24rpx;
        color: #999;
      }
    }
  }
  
  .description-content {
    .description-text {
      font-size: 28rpx;
      color: #666;
      line-height: 1.6;
    }
  }
}

.bottom-actions {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  padding: 20rpx 30rpx 40rpx;
  background: #fff;
  box-shadow: 0 -2rpx 10rpx rgba(0, 0, 0, 0.05);
  
  .action-btn {
    flex: 1;
    height: 90rpx;
    border-radius: 45rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10rpx;
    border: none;
    font-size: 30rpx;
    font-weight: bold;
    
    &.secondary {
      background: #f8f9fa;
      color: #666;
      margin-right: 20rpx;
    }
    
    &.primary {
      background: linear-gradient(135deg, #667eea, #764ba2);
      color: #fff;
    }
    
    .iconfont {
      font-size: 32rpx;
    }
    
    .btn-text {
      font-size: 30rpx;
    }
  }
}

.qr-popup {
  width: 500rpx;
  background: #fff;
  border-radius: 20rpx;
  overflow: hidden;
  
  .qr-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 30rpx;
    border-bottom: 1rpx solid #f0f0f0;
    
    .qr-title {
      font-size: 36rpx;
      font-weight: bold;
      color: #333;
    }
    
    .iconfont {
      font-size: 36rpx;
      color: #999;
    }
  }
  
  .qr-content {
    padding: 40rpx 30rpx;
    text-align: center;
    
    .qr-image {
      width: 300rpx;
      height: 300rpx;
      margin: 0 auto 20rpx;
    }
    
    .qr-desc {
      font-size: 28rpx;
      color: #666;
    }
  }
}
</style>

<template>
  <view class="signup-show-page">
    <!-- 页面头部 -->
    <view class="page-header">
      <view class="header-left" @click="goBack">
        <text class="nc-iconfont nc-icon-zuoV6xx"></text>
        <text class="header-title">赛事报名</text>
      </view>
      <view class="header-right">
        <text class="nc-iconfont nc-icon-fenxiangV6xx" @click="shareEvent"></text>
      </view>
    </view>

    <!-- 主要内容区域 -->
    <view class="main-content">
      <!-- Banner轮播区域 -->
      <view v-if="diyConfig?.modules?.banner?.enabled" class="banner-section">
        <u-swiper 
          v-if="bannerList.length > 0"
          :list="bannerList" 
          :height="bannerHeight + 'rpx'"
          :autoplay="bannerAutoplay"
          :indicator="bannerIndicator"
          :interval="bannerInterval"
          @click="onBannerClick"
        />
        <view v-else class="empty-banner">
          <text class="empty-text">暂无Banner图片</text>
        </view>
      </view>

      <!-- 基本信息模块 -->
      <view v-if="diyConfig?.modules?.basicInfo?.enabled" class="basic-info-section">
        <view class="section-card">
          <view class="card-header">
            <text class="card-title">赛事信息</text>
          </view>
          <view class="card-content">
            <!-- 赛事名称 -->
            <view v-if="basicInfoSettings.showEventName" class="info-item">
              <text class="info-label">赛事名称</text>
              <text class="info-value">{{ eventInfo.name }}</text>
            </view>
            
            <!-- 时间地点 -->
            <view v-if="basicInfoSettings.showTimeLocation" class="info-item">
              <text class="info-label">比赛时间</text>
              <text class="info-value">{{ eventInfo.start_time_text }} - {{ eventInfo.end_time_text }}</text>
            </view>
            
            <view v-if="basicInfoSettings.showTimeLocation && eventInfo.location" class="info-item">
              <text class="info-label">比赛地点</text>
              <text class="info-value">{{ eventInfo.location }}</text>
            </view>
            
            <!-- 主办方信息 -->
            <view v-if="basicInfoSettings.showOrganizer" class="info-item">
              <text class="info-label">主办方</text>
              <text class="info-value">{{ eventInfo.organizer_name }}</text>
            </view>
            
            <!-- 协办方信息 -->
            <view v-if="basicInfoSettings.showCoOrganizer && coOrganizers.length > 0" class="info-item">
              <text class="info-label">协办方</text>
              <view class="co-organizer-list">
                <view 
                  v-for="coOrg in coOrganizers" 
                  :key="coOrg.id"
                  class="co-organizer-item"
                >
                  <text class="co-org-name">{{ coOrg.name }}</text>
                  <text class="co-org-type">{{ getCoOrganizerTypeText(coOrg.type) }}</text>
                </view>
              </view>
            </view>
            
            <!-- 系列赛信息 -->
            <view v-if="basicInfoSettings.showSeries && eventInfo.series_name" class="info-item">
              <text class="info-label">系列赛</text>
              <text class="info-value">{{ eventInfo.series_name }}</text>
            </view>
            
            <!-- 项目分类 -->
            <view v-if="basicInfoSettings.showCategory && eventInfo.category_name" class="info-item">
              <text class="info-label">项目分类</text>
              <text class="info-value">{{ eventInfo.category_name }}</text>
            </view>
            
            <!-- 年龄分组 -->
            <view v-if="basicInfoSettings.showAgeGroups && eventInfo.age_groups?.length > 0" class="info-item">
              <text class="info-label">年龄分组</text>
              <view class="age-groups">
                <text 
                  v-for="ageGroup in eventInfo.age_groups" 
                  :key="ageGroup"
                  class="age-group-tag"
                >
                  {{ ageGroup }}
                </text>
              </view>
            </view>
            
            <!-- 自定义分组 -->
            <view v-if="basicInfoSettings.showCustomGroups && eventInfo.custom_groups?.length > 0" class="info-item">
              <text class="info-label">自定义分组</text>
              <view class="custom-groups">
                <text 
                  v-for="group in eventInfo.custom_groups" 
                  :key="group.id"
                  class="custom-group-tag"
                >
                  {{ group.group_name }}
                </text>
              </view>
            </view>
            
            <!-- 联系方式 -->
            <view v-if="basicInfoSettings.showContactInfo" class="info-item">
              <text class="info-label">联系方式</text>
              <view class="contact-info">
                <view v-if="eventInfo.contact_name" class="contact-item">
                  <text class="contact-label">联系人：</text>
                  <text class="contact-value">{{ eventInfo.contact_name }}</text>
                </view>
                <view v-if="eventInfo.contact_phone" class="contact-item">
                  <text class="contact-label">电话：</text>
                  <text class="contact-value" @click="makePhoneCall(eventInfo.contact_phone)">
                    {{ eventInfo.contact_phone }}
                  </text>
                </view>
                <view v-if="eventInfo.contact_email" class="contact-item">
                  <text class="contact-label">邮箱：</text>
                  <text class="contact-value">{{ eventInfo.contact_email }}</text>
                </view>
                <view v-if="eventInfo.contact_wechat" class="contact-item">
                  <text class="contact-label">微信：</text>
                  <text class="contact-value">{{ eventInfo.contact_wechat }}</text>
                </view>
              </view>
            </view>
          </view>
        </view>
      </view>

      <!-- 比赛项目模块 -->
      <view v-if="diyConfig?.modules?.projects?.enabled" class="projects-section">
        <view class="section-card">
          <view class="card-header">
            <text class="card-title">比赛项目</text>
          </view>
          <view class="card-content">
            <view v-if="eventItems.length > 0" class="projects-list">
              <view 
                v-for="item in eventItems" 
                :key="item.id"
                class="project-item"
              >
                <view class="project-header">
                  <text class="project-name">{{ item.base_item_name }}</text>
                  <text v-if="projectsSettings.showRegistrationFee" class="project-fee">
                    ￥{{ item.registration_fee || '0' }}
                  </text>
                </view>
                
                <view class="project-details">
                  <view v-if="projectsSettings.showAgeGroup && item.age_group" class="project-detail">
                    <text class="detail-label">年龄组：</text>
                    <text class="detail-value">{{ item.age_group }}</text>
                  </view>
                  
                  <view v-if="projectsSettings.showGenderLimit && item.gender_limit" class="project-detail">
                    <text class="detail-label">性别限制：</text>
                    <text class="detail-value">{{ getGenderLimitText(item.gender_limit) }}</text>
                  </view>
                  
                  <view v-if="projectsSettings.showParticipantCount" class="project-detail">
                    <text class="detail-label">参赛人数：</text>
                    <text class="detail-value">{{ item.current_participants || 0 }}/{{ item.max_participants || '不限' }}</text>
                  </view>
                  
                  <view v-if="projectsSettings.showVenue && item.venues?.length > 0" class="project-detail">
                    <text class="detail-label">比赛场地：</text>
                    <text class="detail-value">{{ item.venues.map(v => v.venue_name).join('、') }}</text>
                  </view>
                </view>
              </view>
            </view>
            <view v-else class="empty-projects">
              <text class="empty-text">暂无比赛项目</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 详情内容模块 -->
      <view v-if="diyConfig?.modules?.detailContent?.enabled" class="detail-content-section">
        <view class="section-card">
          <view class="card-header">
            <text class="card-title">赛事详情</text>
          </view>
          <view class="card-content">
            <view v-if="detailContent" class="content-display">
              <rich-text :nodes="detailContent.content_data"></rich-text>
            </view>
            <view v-else class="empty-content">
              <text class="empty-text">暂无详情内容</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 报名操作模块 -->
      <view v-if="diyConfig?.modules?.signupAction?.enabled" class="signup-action-section">
        <view class="section-card">
          <view class="card-header">
            <text class="card-title">报名信息</text>
          </view>
          <view class="card-content">
            <!-- 报名状态 -->
            <view v-if="signupSettings.showRegistrationStatus" class="signup-status">
              <text class="status-label">报名状态：</text>
              <text class="status-value" :class="getRegistrationStatusClass()">
                {{ getRegistrationStatusText() }}
              </text>
            </view>
            
            <!-- 报名时间 -->
            <view v-if="signupSettings.showRegistrationTime" class="signup-time">
              <text class="time-label">报名时间：</text>
              <text class="time-value">
                {{ eventInfo.registration_start_time }} - {{ eventInfo.registration_end_time }}
              </text>
            </view>
            
            <!-- 参赛人数统计 -->
            <view v-if="signupSettings.showParticipantCount" class="participant-count">
              <text class="count-label">已报名人数：</text>
              <text class="count-value">{{ totalParticipants }}人</text>
            </view>
            
            <!-- 报名按钮 -->
            <view class="signup-button-area">
              <button 
                class="signup-btn"
                :class="signupButtonClass"
                :disabled="!canRegister"
                @click="handleSignup"
              >
                {{ signupButtonText }}
              </button>
            </view>
          </view>
        </view>
      </view>
    </view>

    <!-- 底部安全区域 -->
    <view class="safe-area-bottom"></view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { diyConfigApi, bannerApi, contentApi, type DIYConfig } from '@/addon/sport/api/diy'
import { getEventDetailInfo, getEventItems } from '@/addon/sport/api/event'
import { getCoOrganizerList } from '@/addon/sport/api/co_organizer'

// 页面参数
const eventId = ref<number>(0)
const isPreview = ref(false)

// 数据状态
const loading = ref(true)
const eventInfo = ref<any>({})
const diyConfig = ref<DIYConfig | null>(null)
const bannerList = ref<any[]>([])
const coOrganizers = ref<any[]>([])
const eventItems = ref<any[]>([])
const detailContent = ref<any>(null)

// 页面初始化
onMounted(() => {
  const pages = getCurrentPages()
  const currentPage = pages[pages.length - 1]
  eventId.value = parseInt(currentPage.options?.event_id || '0')
  isPreview.value = currentPage.options?.preview === '1'
  
  if (eventId.value) {
    loadPageData()
  }
})

// 加载页面数据
const loadPageData = async () => {
  try {
    loading.value = true
    
    // 并行加载所有数据
    await Promise.all([
      loadEventInfo(),
      loadDiyConfig(),
      loadBannerImages(),
      loadCoOrganizers(),
      loadEventItems(),
      loadDetailContent()
    ])
  } catch (error) {
    console.error('加载页面数据失败:', error)
    uni.showToast({
      title: '加载失败',
      icon: 'error'
    })
  } finally {
    loading.value = false
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

// 加载DIY配置
const loadDiyConfig = async () => {
  try {
    const response = await diyConfigApi.getEventDiyConfig(eventId.value)
    if (response.code === 1) {
      diyConfig.value = response.data.config
    }
  } catch (error) {
    console.error('加载DIY配置失败:', error)
  }
}

// 加载Banner图片
const loadBannerImages = async () => {
  try {
    const response = await bannerApi.getEventBanners(eventId.value)
    if (response.code === 1) {
      bannerList.value = response.data.banners.map((banner: any) => ({
        image: banner.image_url,
        title: banner.image_title,
        link: banner.image_link
      }))
    }
  } catch (error) {
    console.error('加载Banner图片失败:', error)
  }
}

// 加载协办方信息
const loadCoOrganizers = async () => {
  try {
    const response = await getCoOrganizerList(eventId.value)
    if (response.code === 1) {
      coOrganizers.value = response.data
    }
  } catch (error) {
    console.error('加载协办方信息失败:', error)
  }
}

// 加载比赛项目
const loadEventItems = async () => {
  try {
    const response = await getEventItems(eventId.value)
    if (response.code === 1) {
      eventItems.value = response.data
    }
  } catch (error) {
    console.error('加载比赛项目失败:', error)
  }
}

// 加载详情内容
const loadDetailContent = async () => {
  try {
    const response = await contentApi.getEventDetailContent(eventId.value)
    if (response.code === 1) {
      detailContent.value = response.data
    }
  } catch (error) {
    console.error('加载详情内容失败:', error)
  }
}

// 计算属性
const basicInfoSettings = computed(() => {
  return diyConfig.value?.modules?.basicInfo?.properties || {}
})

const projectsSettings = computed(() => {
  return diyConfig.value?.modules?.projects?.properties || {}
})

const signupSettings = computed(() => {
  return diyConfig.value?.modules?.signupAction?.properties || {}
})

const bannerHeight = computed(() => {
  return diyConfig.value?.modules?.banner?.properties?.height || 400
})

const bannerAutoplay = computed(() => {
  return diyConfig.value?.modules?.banner?.properties?.autoplay || true
})

const bannerIndicator = computed(() => {
  return diyConfig.value?.modules?.banner?.properties?.indicator || true
})

const bannerInterval = computed(() => {
  return diyConfig.value?.modules?.banner?.properties?.interval || 3000
})

const signupButtonText = computed(() => {
  return signupSettings.value.buttonText || '立即报名'
})

const signupButtonClass = computed(() => {
  const style = signupSettings.value.buttonStyle || 'primary'
  return `signup-btn-${style}`
})

const totalParticipants = computed(() => {
  return eventItems.value.reduce((total, item) => {
    return total + (item.current_participants || 0)
  }, 0)
})

const canRegister = computed(() => {
  const now = new Date()
  const startTime = new Date(eventInfo.value.registration_start_time)
  const endTime = new Date(eventInfo.value.registration_end_time)
  
  return now >= startTime && now <= endTime
})

// 方法
const getCoOrganizerTypeText = (type: number) => {
  const typeMap: Record<number, string> = {
    1: '协办单位',
    2: '赞助商',
    3: '合作伙伴',
    11: '协办单位', // 兼容旧数据
    12: '赞助商',
    13: '合作伙伴'
  }
  return typeMap[type] || '协办单位'
}

const getGenderLimitText = (limit: number) => {
  const limitMap: Record<number, string> = {
    1: '仅限男性',
    2: '仅限女性',
    3: '不限性别'
  }
  return limitMap[limit] || '不限性别'
}

const getRegistrationStatusText = () => {
  if (!canRegister.value) {
    const now = new Date()
    const startTime = new Date(eventInfo.value.registration_start_time)
    const endTime = new Date(eventInfo.value.registration_end_time)
    
    if (now < startTime) {
      return '报名未开始'
    } else if (now > endTime) {
      return '报名已结束'
    }
  }
  return '报名进行中'
}

const getRegistrationStatusClass = () => {
  const status = getRegistrationStatusText()
  if (status === '报名进行中') {
    return 'status-active'
  } else if (status === '报名已结束') {
    return 'status-ended'
  } else {
    return 'status-pending'
  }
}

const onBannerClick = (index: number) => {
  const banner = bannerList.value[index]
  if (banner.link) {
    // 处理Banner链接跳转
    console.log('Banner链接:', banner.link)
  }
}

const makePhoneCall = (phone: string) => {
  uni.makePhoneCall({
    phoneNumber: phone
  })
}

const handleSignup = () => {
  if (!canRegister.value) {
    uni.showToast({
      title: '当前不在报名时间内',
      icon: 'none'
    })
    return
  }
  
  // 跳转到报名表单页面
  uni.navigateTo({
    url: `/addon/sport/pages/event/signup_form?event_id=${eventId.value}`
  })
}

const shareEvent = () => {
  uni.share({
    provider: 'weixin',
    scene: 'WXSceneSession',
    type: 0,
    href: `/addon/sport/pages/event/signup_show?event_id=${eventId.value}`,
    title: eventInfo.value.name,
    summary: eventInfo.value.remark || '精彩赛事，等你来参加！',
    imageUrl: bannerList.value[0]?.image || ''
  })
}

const goBack = () => {
  uni.navigateBack()
}
</script>

<style lang="scss" scoped>
.signup-show-page {
  min-height: 100vh;
  background-color: #f5f5f5;
}

.page-header {
  height: 88rpx;
  background: #fff;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 30rpx;
  border-bottom: 1rpx solid #eee;
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 100;

  .header-left {
    display: flex;
    align-items: center;
    
    .nc-iconfont {
      font-size: 36rpx;
      color: #333;
      margin-right: 20rpx;
    }
    
    .header-title {
      font-size: 32rpx;
      font-weight: 500;
      color: #333;
    }
  }

  .header-right {
    .nc-iconfont {
      font-size: 36rpx;
      color: #333;
    }
  }
}

.main-content {
  margin-top: 88rpx;
  padding-bottom: 120rpx;
}

.banner-section {
  .empty-banner {
    height: 400rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #f8f9fa;
    
    .empty-text {
      font-size: 28rpx;
      color: #999;
    }
  }
}

.section-card {
  background: #fff;
  margin: 20rpx 30rpx;
  border-radius: 16rpx;
  overflow: hidden;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.1);

  .card-header {
    padding: 30rpx;
    border-bottom: 1rpx solid #eee;
    
    .card-title {
      font-size: 32rpx;
      font-weight: 500;
      color: #333;
    }
  }

  .card-content {
    padding: 30rpx;
  }
}

.basic-info-section {
  .info-item {
    display: flex;
    margin-bottom: 24rpx;
    
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
      line-height: 1.5;
    }
  }

  .co-organizer-list {
    .co-organizer-item {
      display: flex;
      align-items: center;
      margin-bottom: 12rpx;
      
      .co-org-name {
        font-size: 28rpx;
        color: #333;
        margin-right: 16rpx;
      }
      
      .co-org-type {
        padding: 4rpx 12rpx;
        background: #e3f2fd;
        color: #1976d2;
        border-radius: 12rpx;
        font-size: 22rpx;
      }
    }
  }

  .age-groups, .custom-groups {
    display: flex;
    flex-wrap: wrap;
    gap: 12rpx;
    
    .age-group-tag, .custom-group-tag {
      padding: 8rpx 16rpx;
      background: #f0f9ff;
      color: #0369a1;
      border-radius: 16rpx;
      font-size: 24rpx;
    }
  }

  .contact-info {
    .contact-item {
      display: flex;
      margin-bottom: 12rpx;
      
      .contact-label {
        font-size: 26rpx;
        color: #666;
        width: 100rpx;
      }
      
      .contact-value {
        font-size: 26rpx;
        color: #409EFF;
      }
    }
  }
}

.projects-section {
  .projects-list {
    .project-item {
      padding: 24rpx 0;
      border-bottom: 1rpx solid #eee;
      
      &:last-child {
        border-bottom: none;
      }

      .project-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 16rpx;

        .project-name {
          font-size: 30rpx;
          font-weight: 500;
          color: #333;
        }

        .project-fee {
          font-size: 28rpx;
          color: #f56c6c;
          font-weight: 500;
        }
      }

      .project-details {
        .project-detail {
          display: flex;
          margin-bottom: 8rpx;
          
          &:last-child {
            margin-bottom: 0;
          }

          .detail-label {
            font-size: 24rpx;
            color: #999;
            width: 120rpx;
          }

          .detail-value {
            font-size: 24rpx;
            color: #666;
          }
        }
      }
    }
  }

  .empty-projects {
    text-align: center;
    padding: 60rpx 0;
    
    .empty-text {
      font-size: 28rpx;
      color: #999;
    }
  }
}

.detail-content-section {
  .content-display {
    font-size: 28rpx;
    line-height: 1.6;
    color: #333;
  }

  .empty-content {
    text-align: center;
    padding: 60rpx 0;
    
    .empty-text {
      font-size: 28rpx;
      color: #999;
    }
  }
}

.signup-action-section {
  .signup-status, .signup-time, .participant-count {
    display: flex;
    margin-bottom: 20rpx;
    
    .status-label, .time-label, .count-label {
      font-size: 28rpx;
      color: #666;
      width: 120rpx;
    }
    
    .status-value {
      font-size: 28rpx;
      font-weight: 500;
      
      &.status-active {
        color: #67c23a;
      }
      
      &.status-ended {
        color: #f56c6c;
      }
      
      &.status-pending {
        color: #e6a23c;
      }
    }
    
    .time-value, .count-value {
      font-size: 28rpx;
      color: #333;
    }
  }

  .signup-button-area {
    margin-top: 40rpx;
    
    .signup-btn {
      width: 100%;
      height: 88rpx;
      border: none;
      border-radius: 12rpx;
      font-size: 32rpx;
      font-weight: 500;
      
      &.signup-btn-primary {
        background: #409EFF;
        color: #fff;
      }
      
      &.signup-btn-secondary {
        background: #909399;
        color: #fff;
      }
      
      &.signup-btn-success {
        background: #67c23a;
        color: #fff;
      }
      
      &.signup-btn-warning {
        background: #e6a23c;
        color: #fff;
      }
      
      &:disabled {
        background: #c0c4cc;
        color: #fff;
      }
    }
  }
}

.safe-area-bottom {
  height: env(safe-area-inset-bottom);
}
</style>

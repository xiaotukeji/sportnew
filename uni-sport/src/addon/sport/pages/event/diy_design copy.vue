<template>
  <view class="diy-design-page">
    <!-- 页面头部 -->
    <view class="page-header">
      <view class="header-left" @click="goBack">
        <text class="nc-iconfont nc-icon-zuoV6xx"></text>
        <text class="header-title">DIY设计</text>
      </view>
      <view class="header-right">
        <button class="preview-btn" @click="previewPage">预览</button>
        <button class="save-btn" @click="saveConfig" :disabled="isSaving">
          {{ isSaving ? '保存中...' : '保存' }}
        </button>
      </view>
    </view>

    <!-- 主要内容区域 - 直接显示所有元素 -->
    <view class="main-content">
      <view class="diy-preview-container">
        <!-- Banner轮播图模块 -->
        <view class="diy-module banner-module" :class="{ 'module-disabled': !enabledModules.includes('banner') }">
          <view class="module-controls" v-if="selectedModule === 'banner'">
            <button class="control-btn add-btn" @click="addBanner">+ 添加图片</button>
            <button class="control-btn delete-btn" @click="deleteBanner">删除</button>
            <button class="control-btn edit-btn" @click="editBanner">编辑</button>
          </view>
          <view class="module-content" @click="selectModule('banner')">
            <view v-if="bannerList.length > 0" class="banner-carousel">
              <swiper class="banner-swiper" :indicator-dots="true" :autoplay="true">
                <swiper-item v-for="(banner, index) in bannerList" :key="index">
                  <image :src="banner.image_url" class="banner-image" mode="aspectFill" />
                </swiper-item>
              </swiper>
            </view>
            <view v-else class="banner-placeholder">
              <text class="placeholder-text">点击添加Banner图片</text>
            </view>
          </view>
          <view class="module-toggle" @click="toggleModule('banner')">
            <switch :checked="enabledModules.includes('banner')" />
          </view>
        </view>

        <!-- 赛事基本信息模块 -->
        <view class="diy-module basic-info-module" :class="{ 'module-disabled': !enabledModules.includes('basic_info') }">
          <view class="module-controls" v-if="selectedModule === 'basic_info'">
            <button class="control-btn edit-btn" @click="editBasicInfo">编辑信息</button>
          </view>
          <view class="module-content" @click="selectModule('basic_info')">
            <view class="event-basic-info">
              <text class="event-name">{{ eventInfo.name || '赛事名称' }}</text>
              <view class="info-row">
                <text class="info-label">时间：</text>
                <text class="info-value">{{ eventInfo.start_time || '开始时间' }} - {{ eventInfo.end_time || '结束时间' }}</text>
              </view>
              <view class="info-row">
                <text class="info-label">地点：</text>
                <text class="info-value">{{ eventInfo.location || '举办地点' }}</text>
              </view>
              <view class="info-row" v-if="eventInfo.address_detail">
                <text class="info-label">详细地址：</text>
                <text class="info-value">{{ eventInfo.address_detail }}</text>
              </view>
              <view class="info-row">
                <text class="info-label">主办方：</text>
                <text class="info-value">{{ eventInfo.organizer_name || '主办单位' }}</text>
              </view>
              <view class="info-row" v-if="eventInfo.co_organizer && eventInfo.co_organizer.length > 0">
                <text class="info-label">协办方：</text>
                <text class="info-value">{{ eventInfo.co_organizer.map(item => item.name).join('、') }}</text>
              </view>
              <view class="info-row" v-if="eventInfo.series">
                <text class="info-label">系列赛：</text>
                <text class="info-value">{{ eventInfo.series }}</text>
              </view>
              <view class="info-row" v-if="eventInfo.category">
                <text class="info-label">项目分类：</text>
                <text class="info-value">{{ eventInfo.category }}</text>
              </view>
              <view class="info-row" v-if="eventInfo.contact_phone">
                <text class="info-label">联系电话：</text>
                <text class="info-value">{{ eventInfo.contact_phone }}</text>
              </view>
              <view class="info-row" v-if="eventInfo.contact_email">
                <text class="info-label">联系邮箱：</text>
                <text class="info-value">{{ eventInfo.contact_email }}</text>
              </view>
              <view class="info-row" v-if="eventInfo.signup_fields && eventInfo.signup_fields.length > 0">
                <text class="info-label">报名字段：</text>
                <text class="info-value">{{ eventInfo.signup_fields.map(field => field.name).join('、') }}</text>
              </view>
              <view class="info-row" v-if="eventInfo.custom_groups && eventInfo.custom_groups.length > 0">
                <text class="info-label">自定义分组：</text>
                <text class="info-value">{{ eventInfo.custom_groups.map(group => group.name).join('、') }}</text>
              </view>
              <view class="info-row" v-if="eventInfo.age_groups && eventInfo.age_groups.length > 0">
                <text class="info-label">年龄分组：</text>
                <text class="info-value">{{ eventInfo.age_groups.map(group => group.name).join('、') }}</text>
              </view>
            </view>
          </view>
          <view class="module-toggle" @click="toggleModule('basic_info')">
            <switch :checked="enabledModules.includes('basic_info')" />
          </view>
        </view>

        <!-- 比赛项目模块 -->
        <view class="diy-module event-items-module" :class="{ 'module-disabled': !enabledModules.includes('event_items') }">
          <view class="module-controls" v-if="selectedModule === 'event_items'">
            <button class="control-btn edit-btn" @click="editEventItems">管理项目</button>
          </view>
          <view class="module-content" @click="selectModule('event_items')">
            <view class="event-items-list">
              <text class="section-title">比赛项目</text>
              <view v-for="(item, index) in eventItems.slice(0, 3)" :key="index" class="item-row">
                <view class="item-info">
                  <text class="item-name">{{ item.name }}</text>
                  <text class="item-category">{{ item.category_name }}</text>
                </view>
                <view class="item-details" v-if="item.registration_fee">
                  <text class="item-fee">报名费：¥{{ item.registration_fee }}</text>
                </view>
                <view class="item-details" v-if="item.age_group">
                  <text class="item-age">年龄组：{{ item.age_group }}</text>
                </view>
                <view class="item-details" v-if="item.gender_limit">
                  <text class="item-gender">性别限制：{{ item.gender_limit }}</text>
                </view>
              </view>
              <text v-if="eventItems.length > 3" class="more-items">还有 {{ eventItems.length - 3 }} 个项目...</text>
            </view>
          </view>
          <view class="module-toggle" @click="toggleModule('event_items')">
            <switch :checked="enabledModules.includes('event_items')" />
          </view>
        </view>

        <!-- 详情内容模块 -->
        <view class="diy-module detail-content-module" :class="{ 'module-disabled': !enabledModules.includes('detail_content') }">
          <view class="module-controls" v-if="selectedModule === 'detail_content'">
            <button class="control-btn add-btn" @click="addContent">+ 添加内容</button>
            <button class="control-btn edit-btn" @click="editDetailContent">编辑</button>
          </view>
          <view class="module-content" @click="selectModule('detail_content')">
            <view class="detail-content">
              <text class="section-title">赛事详情</text>
              <view v-for="(content, index) in detailContentList" :key="index" class="content-item">
                <text class="content-title">{{ content.title }}</text>
                <text class="content-text">{{ content.content }}</text>
              </view>
              <text v-if="detailContentList.length === 0" class="placeholder-text">点击添加详情内容</text>
            </view>
          </view>
          <view class="module-toggle" @click="toggleModule('detail_content')">
            <switch :checked="enabledModules.includes('detail_content')" />
          </view>
        </view>

        <!-- 报名操作模块 -->
        <view class="diy-module signup-action-module" :class="{ 'module-disabled': !enabledModules.includes('signup_action') }">
          <view class="module-controls" v-if="selectedModule === 'signup_action'">
            <button class="control-btn edit-btn" @click="editSignupAction">编辑按钮</button>
          </view>
          <view class="module-content" @click="selectModule('signup_action')">
            <view class="signup-action">
              <view class="signup-info" v-if="eventInfo.registration_start_time && eventInfo.registration_end_time">
                <text class="signup-time">报名时间：{{ eventInfo.registration_start_time }} 至 {{ eventInfo.registration_end_time }}</text>
              </view>
              <view class="signup-status">
                <text class="status-text">报名状态：{{ getRegistrationStatus() }}</text>
              </view>
              <view class="participant-count" v-if="eventItems.length > 0">
                <text class="count-text">参赛人数：{{ getTotalParticipants() }} 人</text>
              </view>
              <button class="signup-btn" :class="signupButtonStyle">
                {{ signupButtonText }}
              </button>
              <text class="signup-tips">点击上方按钮进行报名</text>
            </view>
          </view>
          <view class="module-toggle" @click="toggleModule('signup_action')">
            <switch :checked="enabledModules.includes('signup_action')" />
          </view>
        </view>
      </view>
    </view>

    <!-- Banner编辑弹窗 -->
    <u-popup :show="bannerEditShow" @close="bannerEditShow = false" mode="bottom" height="80%">
      <view class="popup-content">
        <view class="popup-header">
          <text class="popup-title">Banner设置</text>
          <text class="close-btn" @click="bannerEditShow = false">×</text>
        </view>
        <view class="popup-body">
          <view class="form-group">
            <text class="form-label">轮播图片</text>
            <view class="image-list">
              <view v-for="(banner, index) in bannerList" :key="index" class="image-item">
                <image :src="banner.image_url" class="preview-image" mode="aspectFill" />
                <button class="delete-image-btn" @click="removeBannerImage(index)">×</button>
              </view>
              <view class="add-image-btn" @click="chooseBannerImage">
                <text class="add-icon">+</text>
                <text class="add-text">添加图片</text>
              </view>
            </view>
          </view>
        </view>
      </view>
    </u-popup>

    <!-- 基本信息编辑弹窗 -->
    <u-popup :show="basicInfoEditShow" @close="basicInfoEditShow = false" mode="bottom" height="60%">
      <view class="popup-content">
        <view class="popup-header">
          <text class="popup-title">基本信息设置</text>
          <text class="close-btn" @click="basicInfoEditShow = false">×</text>
        </view>
        <view class="popup-body">
          <view class="form-group">
            <text class="form-label">赛事名称</text>
            <input class="form-input" v-model="eventInfo.name" placeholder="请输入赛事名称" />
          </view>
          <view class="form-group">
            <text class="form-label">开始时间</text>
            <input class="form-input" v-model="eventInfo.start_time" placeholder="请输入开始时间" />
          </view>
          <view class="form-group">
            <text class="form-label">结束时间</text>
            <input class="form-input" v-model="eventInfo.end_time" placeholder="请输入结束时间" />
          </view>
          <view class="form-group">
            <text class="form-label">举办地点</text>
            <input class="form-input" v-model="eventInfo.location" placeholder="请输入举办地点" />
          </view>
        </view>
      </view>
    </u-popup>

    <!-- 报名按钮编辑弹窗 -->
    <u-popup :show="signupEditShow" @close="signupEditShow = false" mode="bottom" height="50%">
      <view class="popup-content">
        <view class="popup-header">
          <text class="popup-title">报名按钮设置</text>
          <text class="close-btn" @click="signupEditShow = false">×</text>
        </view>
        <view class="popup-body">
          <view class="form-group">
            <text class="form-label">按钮文字</text>
            <input class="form-input" v-model="signupButtonText" placeholder="请输入按钮文字" />
          </view>
          <view class="form-group">
            <text class="form-label">按钮样式</text>
            <view class="style-options">
              <view 
                v-for="(style, index) in buttonStyles" 
                :key="index"
                class="style-option"
                :class="{ active: signupButtonStyleIndex === index }"
                @click="signupButtonStyleIndex = index"
              >
                <button class="style-btn" :class="style">{{ signupButtonText }}</button>
              </view>
            </view>
          </view>
        </view>
      </view>
    </u-popup>
  </view>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { diyConfigApi, bannerApi, contentApi, type DIYConfig, type DIYModule } from '@/addon/sport/api/diy'
import { getEventDetailInfo, getEventItems } from '@/addon/sport/api/event'
import useMemberStore from '@/stores/member'
import { useLogin } from '@/hooks/useLogin'

// 页面参数
const eventId = ref<number>(0)

// 登录状态管理
const memberStore = useMemberStore()
const login = useLogin()
const userInfo = computed(() => memberStore.info)

// 状态管理
const isSaving = ref(false)
const selectedModule = ref<string>('')

// 弹窗状态
const bannerEditShow = ref(false)
const basicInfoEditShow = ref(false)
const signupEditShow = ref(false)

// 可用模块列表
const availableModules = ref<DIYModule[]>([
  { key: 'banner', name: 'Banner轮播图', icon: '🖼️', enabled: true },
  { key: 'basic_info', name: '基本信息', icon: '📋', enabled: true },
  { key: 'event_items', name: '比赛项目', icon: '🏆', enabled: true },
  { key: 'detail_content', name: '详情内容', icon: '📄', enabled: true },
  { key: 'signup_action', name: '报名操作', icon: '✍️', enabled: true }
])

// 启用的模块
const enabledModules = computed(() => {
  return availableModules.value.filter(module => module.enabled).map(module => module.key)
})

// 赛事信息
const eventInfo = ref({
  name: '',
  start_time: '',
  end_time: '',
  location: '',
  address_detail: '',
  organizer_name: '',
  co_organizer: [],
  series: '',
  category: '',
  contact_phone: '',
  contact_email: '',
  signup_fields: [],
  custom_groups: [],
  age_groups: [],
  registration_start_time: '',
  registration_end_time: ''
})

// Banner数据
const bannerList = ref<any[]>([])

// 比赛项目数据
const eventItems = ref<any[]>([])

// 详情内容数据
const detailContentList = ref<any[]>([])

// 报名按钮设置
const signupButtonText = ref('立即报名')
const signupButtonStyle = ref('primary')
const signupButtonStyleIndex = ref(0)
const buttonStyles = ['primary', 'secondary', 'success', 'warning']

// 页面初始化
onMounted(() => {
  // 检查登录状态
  if (!userInfo.value) {
    login.setLoginBack({ url: `/addon/sport/pages/event/diy_design?event_id=${eventId.value}` })
    return
  }
  
  const pages = getCurrentPages()
  const currentPage = pages[pages.length - 1]
  eventId.value = currentPage.options?.event_id || 0
  
  if (eventId.value) {
    loadDiyConfig()
    loadBannerImages()
    loadEventInfo()
    loadEventItems()
    loadDetailContent()
  }
})

// 加载DIY配置
const loadDiyConfig = async () => {
  try {
    const response = await diyConfigApi.getEventDiyConfig(eventId.value)
    if (response.data) {
      const config = response.data
      // 更新模块启用状态
      availableModules.value.forEach(module => {
        module.enabled = config.enabled_modules?.includes(module.key) ?? true
      })
      // 更新报名按钮设置
      if (config.signup_button) {
        signupButtonText.value = config.signup_button.text || '立即报名'
        signupButtonStyle.value = config.signup_button.style || 'primary'
      }
    }
  } catch (error) {
    console.error('加载DIY配置失败:', error)
  }
}

// 加载Banner图片
const loadBannerImages = async () => {
  try {
    const response = await bannerApi.getEventBanners(eventId.value)
    if (response.data) {
      // 确保 response.data 是数组格式
      bannerList.value = Array.isArray(response.data) ? response.data : []
    } else {
      bannerList.value = []
    }
  } catch (error) {
    console.error('加载Banner图片失败:', error)
    bannerList.value = []
  }
}

// 加载赛事信息
const loadEventInfo = async () => {
  try {
    const response = await getEventDetailInfo(eventId.value)
    if (response.data) {
      const eventData = response.data
      eventInfo.value = {
        name: eventData.name || '',
        start_time: eventData.start_time || '',
        end_time: eventData.end_time || '',
        location: eventData.location || '',
        address_detail: eventData.address_detail || '',
        organizer_name: eventData.organizer?.name || '',
        co_organizer: eventData.co_organizer || [],
        series: eventData.series?.name || '',
        category: eventData.category?.name || '',
        contact_phone: eventData.contact_phone || '',
        contact_email: eventData.contact_email || '',
        signup_fields: eventData.signup_fields || [],
        custom_groups: eventData.custom_groups || [],
        age_groups: eventData.age_groups || [],
        registration_start_time: eventData.registration_start_time || '',
        registration_end_time: eventData.registration_end_time || ''
      }
    }
  } catch (error) {
    console.error('加载赛事信息失败:', error)
    // 使用默认数据
    eventInfo.value = {
      name: '赛事名称',
      start_time: '',
      end_time: '',
      location: '',
      address_detail: '',
      organizer_name: '',
      co_organizer: [],
      series: '',
      category: '',
      contact_phone: '',
      contact_email: '',
      signup_fields: [],
      custom_groups: [],
      age_groups: [],
      registration_start_time: '',
      registration_end_time: ''
    }
  }
}

// 加载比赛项目
const loadEventItems = async () => {
  try {
    const response = await getEventItems(eventId.value)
    if (response.data) {
      eventItems.value = response.data
    } else {
      eventItems.value = []
    }
  } catch (error) {
    console.error('加载比赛项目失败:', error)
    eventItems.value = []
  }
}

// 加载详情内容
const loadDetailContent = async () => {
  try {
    const response = await contentApi.getEventDetailContent(eventId.value)
    if (response.data) {
      detailContentList.value = [
        { 
          title: '赛事详情', 
          content: response.data.content_data || '暂无详细说明' 
        }
      ]
    } else {
      detailContentList.value = [
        { title: '赛事详情', content: '暂无详细说明' }
      ]
    }
  } catch (error) {
    console.error('加载详情内容失败:', error)
    detailContentList.value = [
      { title: '赛事详情', content: '暂无详细说明' }
    ]
  }
}

// 选择模块
const selectModule = (moduleKey: string) => {
  selectedModule.value = selectedModule.value === moduleKey ? '' : moduleKey
}

// 获取报名状态
const getRegistrationStatus = () => {
  if (!eventInfo.value.registration_start_time || !eventInfo.value.registration_end_time) {
    return '未设置报名时间'
  }
  
  const now = new Date()
  const startTime = new Date(eventInfo.value.registration_start_time)
  const endTime = new Date(eventInfo.value.registration_end_time)
  
  if (now < startTime) {
    return '报名未开始'
  } else if (now > endTime) {
    return '报名已结束'
  } else {
    return '报名进行中'
  }
}

// 获取总参赛人数
const getTotalParticipants = () => {
  return eventItems.value.reduce((total, item) => {
    return total + (item.participant_count || 0)
  }, 0)
}

// 切换模块显示状态
const toggleModule = (moduleKey: string) => {
  const module = availableModules.value.find(m => m.key === moduleKey)
  if (module) {
    module.enabled = !module.enabled
  }
}

// 编辑Banner
const editBanner = () => {
  bannerEditShow.value = true
}

// 添加Banner
const addBanner = () => {
  chooseBannerImage()
}

// 删除Banner
const deleteBanner = () => {
  bannerList.value = []
}

// 选择Banner图片
const chooseBannerImage = () => {
  uni.chooseImage({
    count: 9,
    sizeType: ['compressed'],
    sourceType: ['album', 'camera'],
    success: (res) => {
      // 确保 bannerList.value 是数组
      if (!Array.isArray(bannerList.value)) {
        bannerList.value = []
      }
      
      // 这里应该上传图片到服务器
      res.tempFilePaths.forEach(path => {
        bannerList.value.push({
          image_url: path,
          sort: bannerList.value.length
        })
      })
    }
  })
}

// 移除Banner图片
const removeBannerImage = (index: number) => {
  if (Array.isArray(bannerList.value) && index >= 0 && index < bannerList.value.length) {
    bannerList.value.splice(index, 1)
  }
}

// 编辑基本信息
const editBasicInfo = () => {
  basicInfoEditShow.value = true
}

// 编辑比赛项目
const editEventItems = () => {
  uni.navigateTo({
    url: `/addon/sport/pages/event/items?event_id=${eventId.value}`
  })
}

// 编辑详情内容
const editDetailContent = () => {
  uni.navigateTo({
    url: `/addon/sport/pages/event/content?event_id=${eventId.value}`
  })
}

// 添加内容
const addContent = () => {
  detailContentList.value.push({
    title: '新内容',
    content: '请输入内容'
  })
}

// 编辑报名操作
const editSignupAction = () => {
  signupEditShow.value = true
}

// 保存配置
const saveConfig = async () => {
  if (isSaving.value) return
  
  isSaving.value = true
  try {
    const configData = {
      event_id: eventId.value,
      enabled_modules: enabledModules.value,
      signup_button: {
        text: signupButtonText.value,
        style: signupButtonStyle.value
      }
    }
    
    await diyConfigApi.saveEventDiyConfig(configData)
    uni.showToast({ title: '保存成功', icon: 'success' })
  } catch (error) {
    console.error('保存配置失败:', error)
    uni.showToast({ title: '保存失败', icon: 'error' })
  } finally {
    isSaving.value = false
  }
}

// 预览页面
const previewPage = () => {
  uni.navigateTo({
    url: `/addon/sport/pages/event/signup_show?event_id=${eventId.value}`
  })
}

// 返回上一页
const goBack = () => {
  uni.navigateBack()
}

// 监听按钮样式变化
watch(signupButtonStyleIndex, (newIndex) => {
  signupButtonStyle.value = buttonStyles[newIndex]
})
</script>

<style lang="scss" scoped>
.diy-design-page {
  min-height: 100vh;
  background-color: #f5f5f5;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20rpx 30rpx;
  background: white;
  border-bottom: 1rpx solid #eee;
  
  .header-left {
    display: flex;
    align-items: center;
    
    .nc-iconfont {
      font-size: 36rpx;
      margin-right: 10rpx;
    }
    
    .header-title {
      font-size: 32rpx;
      font-weight: bold;
    }
  }
  
  .header-right {
    display: flex;
    gap: 20rpx;
    
    .preview-btn, .save-btn {
      padding: 12rpx 24rpx;
      border-radius: 8rpx;
      font-size: 28rpx;
      border: none;
    }
    
    .preview-btn {
      background: #f0f0f0;
      color: #666;
    }
    
    .save-btn {
      background: #007aff;
      color: white;
      
      &:disabled {
        background: #ccc;
      }
    }
  }
}

.main-content {
  padding: 20rpx;
}

.diy-preview-container {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
}

.diy-module {
  background: white;
  border-radius: 16rpx;
  padding: 20rpx;
  position: relative;
  
  &.module-disabled {
    opacity: 0.5;
  }
  
  .module-controls {
    position: absolute;
    top: -10rpx;
    right: 20rpx;
    display: flex;
    gap: 10rpx;
    background: white;
    padding: 10rpx;
    border-radius: 8rpx;
    box-shadow: 0 2rpx 8rpx rgba(0,0,0,0.1);
    z-index: 10;
    
    .control-btn {
      padding: 8rpx 16rpx;
      border-radius: 6rpx;
      font-size: 24rpx;
      border: none;
      
      &.add-btn {
        background: #4cd964;
        color: white;
      }
      
      &.delete-btn {
        background: #ff3b30;
        color: white;
      }
      
      &.edit-btn {
        background: #007aff;
        color: white;
      }
    }
  }
  
  .module-content {
    position: relative;
    
    &.selected {
      border: 2rpx dashed #007aff;
    }
  }
  
  .module-toggle {
    position: absolute;
    top: 20rpx;
    right: 20rpx;
    z-index: 5;
  }
}

// Banner模块样式
.banner-module {
  .banner-carousel {
    .banner-swiper {
      height: 300rpx;
      border-radius: 12rpx;
      overflow: hidden;
      
      .banner-image {
        width: 100%;
        height: 100%;
      }
    }
  }
  
  .banner-placeholder {
    height: 300rpx;
    background: #f8f8f8;
    border: 2rpx dashed #ddd;
    border-radius: 12rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    
    .placeholder-text {
      color: #999;
      font-size: 28rpx;
    }
  }
}

// 基本信息模块样式
.basic-info-module {
  .event-basic-info {
    .event-name {
      font-size: 36rpx;
      font-weight: bold;
      color: #333;
      margin-bottom: 20rpx;
      display: block;
    }
    
    .info-row {
      display: flex;
      margin-bottom: 12rpx;
      
      .info-label {
        color: #666;
        font-size: 28rpx;
        width: 120rpx;
      }
      
      .info-value {
        color: #333;
        font-size: 28rpx;
        flex: 1;
      }
    }
  }
}

// 比赛项目模块样式
.event-items-module {
  .event-items-list {
    .section-title {
      font-size: 32rpx;
      font-weight: bold;
      color: #333;
      margin-bottom: 20rpx;
      display: block;
    }
    
    .item-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 16rpx 0;
      border-bottom: 1rpx solid #f0f0f0;
      
      .item-name {
        font-size: 28rpx;
        color: #333;
      }
      
      .item-category {
        font-size: 24rpx;
        color: #999;
      }
    }
    
    .more-items {
      font-size: 24rpx;
      color: #999;
      text-align: center;
      margin-top: 16rpx;
      display: block;
    }
  }
}

// 详情内容模块样式
.detail-content-module {
  .detail-content {
    .section-title {
      font-size: 32rpx;
      font-weight: bold;
      color: #333;
      margin-bottom: 20rpx;
      display: block;
    }
    
    .content-item {
      margin-bottom: 20rpx;
      
      .content-title {
        font-size: 28rpx;
        font-weight: bold;
        color: #333;
        margin-bottom: 8rpx;
        display: block;
      }
      
      .content-text {
        font-size: 26rpx;
        color: #666;
        line-height: 1.6;
      }
    }
    
    .placeholder-text {
      color: #999;
      font-size: 28rpx;
      text-align: center;
      padding: 40rpx 0;
      display: block;
    }
  }
}

// 报名操作模块样式
.signup-action-module {
  .signup-action {
    text-align: center;
    
    .signup-btn {
      width: 100%;
      height: 80rpx;
      border-radius: 40rpx;
      font-size: 32rpx;
      font-weight: bold;
      border: none;
      margin-bottom: 16rpx;
      
      &.primary {
        background: linear-gradient(135deg, #007aff 0%, #0051d5 100%);
        color: white;
      }
      
      &.secondary {
        background: linear-gradient(135deg, #8e8e93 0%, #636366 100%);
        color: white;
      }
      
      &.success {
        background: linear-gradient(135deg, #4cd964 0%, #34c759 100%);
        color: white;
      }
      
      &.warning {
        background: linear-gradient(135deg, #ff9500 0%, #ff6b35 100%);
        color: white;
      }
    }
    
    .signup-tips {
      font-size: 24rpx;
      color: #999;
    }
  }
}

// 弹窗样式
.popup-content {
  background: white;
  border-radius: 20rpx 20rpx 0 0;
  height: 100%;
  display: flex;
  flex-direction: column;
  
  .popup-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 30rpx;
    border-bottom: 1rpx solid #eee;
    
    .popup-title {
      font-size: 32rpx;
      font-weight: bold;
    }
    
    .close-btn {
      font-size: 40rpx;
      color: #999;
    }
  }
  
  .popup-body {
    flex: 1;
    padding: 30rpx;
    overflow-y: auto;
  }
}

.form-group {
  margin-bottom: 30rpx;
  
  .form-label {
    font-size: 28rpx;
    color: #333;
    margin-bottom: 16rpx;
    display: block;
  }
  
  .form-input {
    width: 100%;
    height: 80rpx;
    border: 1rpx solid #ddd;
    border-radius: 8rpx;
    padding: 0 20rpx;
    font-size: 28rpx;
  }
}

.image-list {
  display: flex;
  flex-wrap: wrap;
  gap: 20rpx;
  
  .image-item {
    position: relative;
    width: 200rpx;
    height: 200rpx;
    
    .preview-image {
      width: 100%;
      height: 100%;
      border-radius: 8rpx;
    }
    
    .delete-image-btn {
      position: absolute;
      top: -10rpx;
      right: -10rpx;
      width: 40rpx;
      height: 40rpx;
      border-radius: 50%;
      background: #ff3b30;
      color: white;
      border: none;
      font-size: 24rpx;
    }
  }
  
  .add-image-btn {
    width: 200rpx;
    height: 200rpx;
    border: 2rpx dashed #ddd;
    border-radius: 8rpx;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    
    .add-icon {
      font-size: 48rpx;
      color: #999;
      margin-bottom: 10rpx;
    }
    
    .add-text {
      font-size: 24rpx;
      color: #999;
    }
  }
}

.style-options {
  display: flex;
  flex-wrap: wrap;
  gap: 20rpx;
  
  .style-option {
    &.active {
      border: 2rpx solid #007aff;
      border-radius: 8rpx;
      padding: 4rpx;
    }
    
    .style-btn {
      width: 200rpx;
      height: 60rpx;
      border-radius: 30rpx;
      border: none;
      font-size: 28rpx;
      
      &.primary {
        background: linear-gradient(135deg, #007aff 0%, #0051d5 100%);
        color: white;
      }
      
      &.secondary {
        background: linear-gradient(135deg, #8e8e93 0%, #636366 100%);
        color: white;
      }
      
      &.success {
        background: linear-gradient(135deg, #4cd964 0%, #34c759 100%);
        color: white;
      }
      
      &.warning {
        background: linear-gradient(135deg, #ff9500 0%, #ff6b35 100%);
        color: white;
      }
    }
  }
}
</style>
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

    <!-- 主要内容区域 -->
    <view class="main-content">
      <!-- 左侧：模块面板 -->
      <view class="modules-panel">
        <view class="panel-title">页面模块</view>
        <view class="modules-list" id="modules-list">
          <view 
            v-for="module in availableModules" 
            :key="module.key"
            class="module-item"
            :class="{ disabled: !module.enabled }"
            @click="toggleModule(module.key)"
          >
            <view class="module-icon">{{ module.icon }}</view>
            <text class="module-name">{{ module.name }}</text>
            <view class="module-switch">
              <switch :checked="module.enabled" @change="toggleModule(module.key)" />
            </view>
          </view>
        </view>
      </view>

      <!-- 中间：预览区域 -->
      <view class="preview-area">
        <view class="preview-container">
          <view class="preview-title">实时预览</view>
          
          <!-- Banner模块预览 -->
          <view v-if="enabledModules.includes('banner')" class="preview-module">
            <view class="module-header">
              <text class="module-title">Banner轮播图</text>
              <button class="edit-btn" @click="editBanner">编辑</button>
            </view>
            <view class="banner-preview">
              <view v-if="bannerImages.length === 0" class="empty-banner" @click="editBanner">
                <text class="empty-text">点击添加Banner图片</text>
                <text class="add-icon">+</text>
              </view>
              <u-swiper 
                v-else 
                :list="bannerImages" 
                :height="bannerHeight + 'rpx'"
                :autoplay="bannerAutoplay"
                :indicator="bannerIndicator"
                :interval="bannerInterval"
              />
            </view>
          </view>

          <!-- 基本信息模块预览 -->
          <view v-if="enabledModules.includes('basicInfo')" class="preview-module">
            <view class="module-header">
              <text class="module-title">基本信息</text>
              <button class="edit-btn" @click="editBasicInfo">编辑</button>
            </view>
            <view class="basic-info-preview">
              <view class="info-item" v-if="basicInfoSettings.showEventName">
                <text class="info-label">赛事名称</text>
                <text class="info-value">示例赛事名称</text>
              </view>
              <view class="info-item" v-if="basicInfoSettings.showTimeLocation">
                <text class="info-label">时间地点</text>
                <text class="info-value">2025年1月1日 北京</text>
              </view>
              <view class="info-item" v-if="basicInfoSettings.showOrganizer">
                <text class="info-label">主办方</text>
                <text class="info-value">示例主办方</text>
              </view>
            </view>
          </view>

          <!-- 项目信息模块预览 -->
          <view v-if="enabledModules.includes('projects')" class="preview-module">
            <view class="module-header">
              <text class="module-title">比赛项目</text>
              <button class="edit-btn" @click="editProjects">编辑</button>
            </view>
            <view class="projects-preview">
              <view class="project-item">
                <text class="project-name">100米短跑</text>
                <text class="project-fee">报名费：￥50</text>
              </view>
              <view class="project-item">
                <text class="project-name">200米短跑</text>
                <text class="project-fee">报名费：￥50</text>
              </view>
            </view>
          </view>

          <!-- 详情内容模块预览 -->
          <view v-if="enabledModules.includes('detailContent')" class="preview-module">
            <view class="module-header">
              <text class="module-title">详情内容</text>
              <button class="edit-btn" @click="editDetailContent">编辑</button>
            </view>
            <view class="detail-content-preview">
              <text class="content-text">这里是赛事详情内容...</text>
            </view>
          </view>

          <!-- 报名操作模块预览 -->
          <view v-if="enabledModules.includes('signupAction')" class="preview-module">
            <view class="module-header">
              <text class="module-title">报名操作</text>
              <button class="edit-btn" @click="editSignupAction">编辑</button>
            </view>
            <view class="signup-action-preview">
              <view class="signup-status">
                <text class="status-text">报名进行中</text>
                <text class="time-text">2025年1月1日 - 2025年1月31日</text>
              </view>
              <button class="signup-btn" :class="signupButtonStyle">
                {{ signupButtonText }}
              </button>
            </view>
          </view>
        </view>
      </view>

      <!-- 右侧：属性设置面板 -->
      <view class="properties-panel">
        <view class="panel-title">属性设置</view>
        <view class="properties-content">
          <view v-if="selectedModule" class="module-properties">
            <text class="properties-title">{{ selectedModule.name }}设置</text>
            
            <!-- Banner属性设置 -->
            <view v-if="selectedModule.key === 'banner'" class="property-group">
              <view class="property-item">
                <text class="property-label">轮播高度</text>
                <slider 
                  :value="bannerHeight" 
                  @change="updateBannerHeight"
                  min="200" 
                  max="600" 
                  step="50"
                />
                <text class="property-value">{{ bannerHeight }}rpx</text>
              </view>
              <view class="property-item">
                <text class="property-label">自动播放</text>
                <switch :checked="bannerAutoplay" @change="updateBannerAutoplay" />
              </view>
              <view class="property-item">
                <text class="property-label">显示指示器</text>
                <switch :checked="bannerIndicator" @change="updateBannerIndicator" />
              </view>
            </view>

            <!-- 基本信息属性设置 -->
            <view v-if="selectedModule.key === 'basicInfo'" class="property-group">
              <view class="property-item" v-for="(value, key) in basicInfoSettings" :key="key">
                <text class="property-label">{{ getBasicInfoLabel(key) }}</text>
                <switch :checked="value" @change="updateBasicInfoSetting(key, $event)" />
              </view>
            </view>

            <!-- 报名操作属性设置 -->
            <view v-if="selectedModule.key === 'signupAction'" class="property-group">
              <view class="property-item">
                <text class="property-label">按钮文字</text>
                <input 
                  v-model="signupButtonText" 
                  class="property-input"
                  placeholder="请输入按钮文字"
                />
              </view>
              <view class="property-item">
                <text class="property-label">按钮样式</text>
                <picker 
                  :value="signupButtonStyleIndex" 
                  :range="buttonStyles"
                  @change="updateSignupButtonStyle"
                >
                  <view class="picker-text">{{ buttonStyles[signupButtonStyleIndex] }}</view>
                </picker>
              </view>
            </view>
          </view>
          
          <view v-else class="no-selection">
            <text class="no-selection-text">请选择要编辑的模块</text>
          </view>
        </view>
      </view>
    </view>

    <!-- Banner编辑弹窗 -->
    <u-popup :show="bannerEditShow" @close="bannerEditShow = false">
      <view class="banner-edit-popup">
        <view class="popup-header">
          <text class="popup-title">编辑Banner</text>
          <text class="close-btn" @click="bannerEditShow = false">×</text>
        </view>
        
        <view class="popup-content">
          <!-- 图片上传区域 -->
          <view class="upload-area">
            <view 
              v-for="(image, index) in bannerImages" 
              :key="index"
              class="image-item"
            >
              <image :src="image" class="uploaded-image" />
              <view class="image-actions">
                <button class="action-btn" @click="previewImage(image)">预览</button>
                <button class="action-btn delete" @click="removeImage(index)">删除</button>
              </view>
            </view>
            
            <view v-if="bannerImages.length < 5" class="upload-btn" @click="uploadImage">
              <text class="upload-icon">+</text>
              <text class="upload-text">添加图片</text>
            </view>
          </view>
        </view>
        
        <view class="popup-footer">
          <button class="cancel-btn" @click="bannerEditShow = false">取消</button>
          <button class="confirm-btn" @click="saveBannerSettings">确定</button>
        </view>
      </view>
    </u-popup>

    <!-- 基本信息编辑弹窗 -->
    <u-popup :show="basicInfoEditShow" @close="basicInfoEditShow = false">
      <view class="basic-info-edit-popup">
        <view class="popup-header">
          <text class="popup-title">编辑基本信息</text>
          <text class="close-btn" @click="basicInfoEditShow = false">×</text>
        </view>
        
        <view class="popup-content">
          <view class="settings-section">
            <view class="setting-item" v-for="(value, key) in basicInfoSettings" :key="key">
              <text class="setting-label">{{ getBasicInfoLabel(key) }}</text>
              <switch :checked="value" @change="updateBasicInfoSetting(key, $event)" />
            </view>
          </view>
        </view>
        
        <view class="popup-footer">
          <button class="cancel-btn" @click="basicInfoEditShow = false">取消</button>
          <button class="confirm-btn" @click="saveBasicInfoSettings">确定</button>
        </view>
      </view>
    </u-popup>
  </view>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { diyConfigApi, bannerApi, type DIYConfig, type DIYModule } from '@/addon/sport/api/diy'
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
const selectedModule = ref<DIYModule | null>(null)

// 弹窗状态
const bannerEditShow = ref(false)
const basicInfoEditShow = ref(false)

// 可用模块列表
const availableModules = ref<DIYModule[]>([
  {
    key: 'banner',
    name: 'Banner轮播图',
    icon: '🖼️',
    description: '展示赛事宣传图片，支持多图轮播',
    enabled: true,
    order: 1,
    properties: {}
  },
  {
    key: 'basicInfo',
    name: '基本信息',
    icon: '📋',
    description: '展示赛事基本信息和组织方信息',
    enabled: true,
    order: 2,
    properties: {}
  },
  {
    key: 'projects',
    name: '比赛项目',
    icon: '🏆',
    description: '展示赛事项目和报名信息',
    enabled: true,
    order: 3,
    properties: {}
  },
  {
    key: 'detailContent',
    name: '详情内容',
    icon: '📄',
    description: '展示赛事详细说明和规则',
    enabled: true,
    order: 4,
    properties: {}
  },
  {
    key: 'signupAction',
    name: '报名操作',
    icon: '📝',
    description: '报名状态和操作按钮',
    enabled: true,
    order: 5,
    properties: {}
  }
])

// 启用的模块
const enabledModules = computed(() => {
  return availableModules.value
    .filter(module => module.enabled)
    .sort((a, b) => a.order - b.order)
    .map(module => module.key)
})

// Banner相关数据
const bannerImages = ref<string[]>([])
const bannerHeight = ref(400)
const bannerAutoplay = ref(true)
const bannerIndicator = ref(true)
const bannerInterval = ref(3000)

// 基本信息设置
const basicInfoSettings = ref({
  showEventName: true,
  showTimeLocation: true,
  showOrganizer: true,
  showCoOrganizer: true,
  showSeries: true,
  showCategory: true,
  showAgeGroups: true,
  showCustomGroups: true,
  showContactInfo: true
})

// 报名操作设置
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
  }
})

// 加载DIY配置
const loadDiyConfig = async () => {
  try {
    const response = await diyConfigApi.getEventDiyConfig(eventId.value)
    if (response.code === 1) {
      const config = response.data.config
      if (config) {
        // 应用配置到界面
        applyConfigToUI(config)
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
    if (response.code === 1) {
      bannerImages.value = response.data.banners.map((banner: any) => banner.image_url)
    }
  } catch (error) {
    console.error('加载Banner图片失败:', error)
  }
}

// 应用配置到界面
const applyConfigToUI = (config: DIYConfig) => {
  // 应用模块配置
  Object.keys(config.modules).forEach(moduleKey => {
    const module = availableModules.value.find(m => m.key === moduleKey)
    if (module) {
      module.enabled = config.modules[moduleKey].enabled
      module.order = config.modules[moduleKey].order
      module.properties = config.modules[moduleKey].properties
    }
  })

  // 应用Banner配置
  if (config.modules.banner) {
    const bannerProps = config.modules.banner.properties
    bannerHeight.value = bannerProps.height
    bannerAutoplay.value = bannerProps.autoplay
    bannerIndicator.value = bannerProps.indicator
    bannerInterval.value = bannerProps.interval
  }

  // 应用基本信息配置
  if (config.modules.basicInfo) {
    basicInfoSettings.value = { ...basicInfoSettings.value, ...config.modules.basicInfo.properties }
  }

  // 应用报名操作配置
  if (config.modules.signupAction) {
    const signupProps = config.modules.signupAction.properties
    signupButtonText.value = signupProps.buttonText
    signupButtonStyle.value = signupProps.buttonStyle
    signupButtonStyleIndex.value = buttonStyles.indexOf(signupProps.buttonStyle)
  }
}

// 切换模块启用状态
const toggleModule = (moduleKey: string) => {
  const module = availableModules.value.find(m => m.key === moduleKey)
  if (module) {
    module.enabled = !module.enabled
    if (module.enabled) {
      selectedModule.value = module
    } else if (selectedModule.value?.key === moduleKey) {
      selectedModule.value = null
    }
  }
}

// 编辑Banner
const editBanner = () => {
  selectedModule.value = availableModules.value.find(m => m.key === 'banner') || null
  bannerEditShow.value = true
}

// 编辑基本信息
const editBasicInfo = () => {
  selectedModule.value = availableModules.value.find(m => m.key === 'basicInfo') || null
  basicInfoEditShow.value = true
}

// 编辑项目信息
const editProjects = () => {
  selectedModule.value = availableModules.value.find(m => m.key === 'projects') || null
}

// 编辑详情内容
const editDetailContent = () => {
  selectedModule.value = availableModules.value.find(m => m.key === 'detailContent') || null
}

// 编辑报名操作
const editSignupAction = () => {
  selectedModule.value = availableModules.value.find(m => m.key === 'signupAction') || null
}

// 上传图片
const uploadImage = () => {
  uni.chooseImage({
    count: 1,
    sizeType: ['compressed'],
    sourceType: ['album', 'camera'],
    success: async (res) => {
      try {
        const filePath = res.tempFilePaths[0]
        // 这里应该调用上传接口
        // const response = await bannerApi.uploadBanner({
        //   event_id: eventId.value,
        //   image: filePath
        // })
        // 临时添加到列表
        bannerImages.value.push(filePath)
      } catch (error) {
        uni.showToast({
          title: '上传失败',
          icon: 'error'
        })
      }
    }
  })
}

// 删除图片
const removeImage = (index: number) => {
  bannerImages.value.splice(index, 1)
}

// 预览图片
const previewImage = (imageUrl: string) => {
  uni.previewImage({
    urls: [imageUrl]
  })
}

// 更新Banner高度
const updateBannerHeight = (e: any) => {
  bannerHeight.value = e.detail.value
}

// 更新Banner自动播放
const updateBannerAutoplay = (e: any) => {
  bannerAutoplay.value = e.detail.value
}

// 更新Banner指示器
const updateBannerIndicator = (e: any) => {
  bannerIndicator.value = e.detail.value
}

// 更新基本信息设置
const updateBasicInfoSetting = (key: string, e: any) => {
  basicInfoSettings.value[key] = e.detail.value
}

// 更新报名按钮样式
const updateSignupButtonStyle = (e: any) => {
  signupButtonStyleIndex.value = e.detail.value
  signupButtonStyle.value = buttonStyles[e.detail.value]
}

// 获取基本信息标签
const getBasicInfoLabel = (key: string) => {
  const labels: Record<string, string> = {
    showEventName: '显示赛事名称',
    showTimeLocation: '显示时间地点',
    showOrganizer: '显示主办方',
    showCoOrganizer: '显示协办方',
    showSeries: '显示系列赛',
    showCategory: '显示项目分类',
    showAgeGroups: '显示年龄分组',
    showCustomGroups: '显示自定义分组',
    showContactInfo: '显示联系方式'
  }
  return labels[key] || key
}

// 保存Banner设置
const saveBannerSettings = () => {
  bannerEditShow.value = false
}

// 保存基本信息设置
const saveBasicInfoSettings = () => {
  basicInfoEditShow.value = false
}

// 保存配置
const saveConfig = async () => {
  if (isSaving.value) return
  
  isSaving.value = true
  try {
    const config: DIYConfig = {
      modules: {
        banner: {
          enabled: availableModules.value.find(m => m.key === 'banner')?.enabled || false,
          order: 1,
          properties: {
            images: bannerImages.value,
            height: bannerHeight.value,
            autoplay: bannerAutoplay.value,
            indicator: bannerIndicator.value,
            interval: bannerInterval.value
          }
        },
        basicInfo: {
          enabled: availableModules.value.find(m => m.key === 'basicInfo')?.enabled || false,
          order: 2,
          properties: basicInfoSettings.value
        },
        projects: {
          enabled: availableModules.value.find(m => m.key === 'projects')?.enabled || false,
          order: 3,
          properties: {}
        },
        detailContent: {
          enabled: availableModules.value.find(m => m.key === 'detailContent')?.enabled || false,
          order: 4,
          properties: {
            content: '',
            showRichText: true,
            showImages: true,
            maxHeight: 500,
            showExpand: true
          }
        },
        signupAction: {
          enabled: availableModules.value.find(m => m.key === 'signupAction')?.enabled || false,
          order: 5,
          properties: {
            showRegistrationStatus: true,
            showRegistrationTime: true,
            showParticipantCount: true,
            buttonText: signupButtonText.value,
            buttonStyle: signupButtonStyle.value,
            buttonSize: 'large',
            showProgress: true
          }
        }
      },
      global: {
        theme: 'light',
        primaryColor: '#409EFF',
        backgroundColor: '#FFFFFF',
        borderRadius: 8,
        spacing: 16
      }
    }

    const response = await diyConfigApi.saveEventDiyConfig({
      event_id: eventId.value,
      config_data: config
    })

    if (response.code === 1) {
      uni.showToast({
        title: '保存成功',
        icon: 'success'
      })
    } else {
      throw new Error(response.msg)
    }
  } catch (error) {
    uni.showToast({
      title: '保存失败',
      icon: 'error'
    })
  } finally {
    isSaving.value = false
  }
}

// 预览页面
const previewPage = () => {
  uni.navigateTo({
    url: `/addon/sport/pages/event/signup_show?event_id=${eventId.value}&preview=1`
  })
}

// 返回上一页
const goBack = () => {
  uni.navigateBack()
}
</script>

<style lang="scss" scoped>
.diy-design-page {
  height: 100vh;
  display: flex;
  flex-direction: column;
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
      background: #409EFF;
      color: #fff;
      
      &:disabled {
        background: #ccc;
      }
    }
  }
}

.main-content {
  flex: 1;
  display: flex;
  margin-top: 88rpx;
  height: calc(100vh - 88rpx);
}

.modules-panel {
  width: 300rpx;
  background: #fff;
  border-right: 1rpx solid #eee;
  overflow-y: auto;

  .panel-title {
    height: 80rpx;
    line-height: 80rpx;
    padding: 0 30rpx;
    font-size: 28rpx;
    font-weight: 500;
    color: #333;
    border-bottom: 1rpx solid #eee;
  }

  .modules-list {
    padding: 20rpx 0;
  }

  .module-item {
    display: flex;
    align-items: center;
    padding: 20rpx 30rpx;
    cursor: pointer;
    transition: background-color 0.2s;

    &:hover {
      background: #f8f9fa;
    }

    &.disabled {
      opacity: 0.5;
    }

    .module-icon {
      font-size: 32rpx;
      margin-right: 20rpx;
    }

    .module-name {
      flex: 1;
      font-size: 28rpx;
      color: #333;
    }

    .module-switch {
      margin-left: 20rpx;
    }
  }
}

.preview-area {
  flex: 1;
  background: #f8f9fa;
  overflow-y: auto;

  .preview-container {
    padding: 30rpx;
  }

  .preview-title {
    font-size: 32rpx;
    font-weight: 500;
    color: #333;
    margin-bottom: 30rpx;
  }

  .preview-module {
    background: #fff;
    border-radius: 16rpx;
    margin-bottom: 30rpx;
    overflow: hidden;

    .module-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 30rpx;
      border-bottom: 1rpx solid #eee;

      .module-title {
        font-size: 28rpx;
        font-weight: 500;
        color: #333;
      }

      .edit-btn {
        padding: 8rpx 16rpx;
        background: #409EFF;
        color: #fff;
        border: none;
        border-radius: 6rpx;
        font-size: 24rpx;
      }
    }
  }

  .banner-preview {
    .empty-banner {
      height: 200rpx;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      background: #f8f9fa;
      color: #999;
      cursor: pointer;

      .empty-text {
        font-size: 28rpx;
        margin-bottom: 10rpx;
      }

      .add-icon {
        font-size: 48rpx;
        color: #409EFF;
      }
    }
  }

  .basic-info-preview {
    padding: 30rpx;

    .info-item {
      display: flex;
      margin-bottom: 20rpx;

      .info-label {
        width: 120rpx;
        font-size: 26rpx;
        color: #666;
      }

      .info-value {
        flex: 1;
        font-size: 26rpx;
        color: #333;
      }
    }
  }

  .projects-preview {
    padding: 30rpx;

    .project-item {
      display: flex;
      justify-content: space-between;
      padding: 20rpx 0;
      border-bottom: 1rpx solid #eee;

      .project-name {
        font-size: 28rpx;
        color: #333;
      }

      .project-fee {
        font-size: 26rpx;
        color: #f56c6c;
      }
    }
  }

  .detail-content-preview {
    padding: 30rpx;

    .content-text {
      font-size: 28rpx;
      color: #666;
      line-height: 1.6;
    }
  }

  .signup-action-preview {
    padding: 30rpx;

    .signup-status {
      margin-bottom: 30rpx;

      .status-text {
        display: block;
        font-size: 28rpx;
        color: #67c23a;
        margin-bottom: 10rpx;
      }

      .time-text {
        font-size: 24rpx;
        color: #999;
      }
    }

    .signup-btn {
      width: 100%;
      height: 80rpx;
      background: #409EFF;
      color: #fff;
      border: none;
      border-radius: 8rpx;
      font-size: 28rpx;
    }
  }
}

.properties-panel {
  width: 400rpx;
  background: #fff;
  border-left: 1rpx solid #eee;
  overflow-y: auto;

  .panel-title {
    height: 80rpx;
    line-height: 80rpx;
    padding: 0 30rpx;
    font-size: 28rpx;
    font-weight: 500;
    color: #333;
    border-bottom: 1rpx solid #eee;
  }

  .properties-content {
    padding: 30rpx;
  }

  .module-properties {
    .properties-title {
      font-size: 28rpx;
      font-weight: 500;
      color: #333;
      margin-bottom: 30rpx;
    }

    .property-group {
      .property-item {
        display: flex;
        align-items: center;
        margin-bottom: 30rpx;

        .property-label {
          width: 120rpx;
          font-size: 26rpx;
          color: #666;
        }

        .property-value {
          margin-left: 20rpx;
          font-size: 24rpx;
          color: #999;
        }

        .property-input {
          flex: 1;
          height: 60rpx;
          padding: 0 20rpx;
          border: 1rpx solid #ddd;
          border-radius: 6rpx;
          font-size: 26rpx;
        }

        .picker-text {
          flex: 1;
          height: 60rpx;
          line-height: 60rpx;
          padding: 0 20rpx;
          border: 1rpx solid #ddd;
          border-radius: 6rpx;
          font-size: 26rpx;
          color: #333;
        }
      }
    }
  }

  .no-selection {
    text-align: center;
    padding: 100rpx 0;

    .no-selection-text {
      font-size: 26rpx;
      color: #999;
    }
  }
}

// 弹窗样式
.banner-edit-popup, .basic-info-edit-popup {
  width: 600rpx;
  max-height: 80vh;
  background: #fff;
  border-radius: 16rpx;
  overflow: hidden;

  .popup-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 30rpx;
    border-bottom: 1rpx solid #eee;

    .popup-title {
      font-size: 32rpx;
      font-weight: 500;
      color: #333;
    }

    .close-btn {
      font-size: 48rpx;
      color: #999;
      cursor: pointer;
    }
  }

  .popup-content {
    padding: 30rpx;
    max-height: 60vh;
    overflow-y: auto;
  }

  .popup-footer {
    display: flex;
    gap: 20rpx;
    padding: 30rpx;
    border-top: 1rpx solid #eee;

    .cancel-btn, .confirm-btn {
      flex: 1;
      height: 80rpx;
      border: none;
      border-radius: 8rpx;
      font-size: 28rpx;
    }

    .cancel-btn {
      background: #f0f0f0;
      color: #666;
    }

    .confirm-btn {
      background: #409EFF;
      color: #fff;
    }
  }
}

.upload-area {
  .image-item {
    position: relative;
    margin-bottom: 20rpx;

    .uploaded-image {
      width: 100%;
      height: 200rpx;
      border-radius: 8rpx;
    }

    .image-actions {
      position: absolute;
      top: 10rpx;
      right: 10rpx;
      display: flex;
      gap: 10rpx;

      .action-btn {
        padding: 8rpx 16rpx;
        background: rgba(0, 0, 0, 0.6);
        color: #fff;
        border: none;
        border-radius: 4rpx;
        font-size: 24rpx;

        &.delete {
          background: #f56c6c;
        }
      }
    }
  }

  .upload-btn {
    height: 200rpx;
    border: 2rpx dashed #ddd;
    border-radius: 8rpx;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    cursor: pointer;

    .upload-icon {
      font-size: 48rpx;
      color: #409EFF;
      margin-bottom: 10rpx;
    }

    .upload-text {
      font-size: 26rpx;
      color: #999;
    }
  }
}

.settings-section {
  .setting-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 20rpx 0;
    border-bottom: 1rpx solid #eee;

    .setting-label {
      font-size: 28rpx;
      color: #333;
    }
  }
}
</style>

<template>
  <view class="create-event-container">
    <!-- 顶部导航栏 -->
    <view class="nav-bar">
      <view class="nav-back" @tap="goBack">
        <text class="iconfont icon-arrow-left"></text>
      </view>
      <view class="nav-title">创建赛事</view>
      <view class="nav-placeholder"></view>
    </view>

    <!-- 页面标题 -->
    <view class="page-header">
      <text class="header-title">一站式赛事创建</text>
      <text class="header-subtitle">快速发布您的体育赛事</text>
    </view>

    <!-- 创建表单 -->
    <scroll-view class="form-container" scroll-y>
      <!-- 赛事基本信息 -->
      <view class="form-section">
        <view class="section-header">
          <text class="section-title">赛事信息</text>
          <text class="section-desc">填写赛事的基本信息</text>
        </view>
        
        <view class="form-item">
          <text class="item-label required">赛事名称</text>
          <input 
            class="form-input" 
            v-model="formData.name" 
            placeholder="请输入赛事名称"
            maxlength="50"
          />
        </view>
        
        <view class="form-item">
          <text class="item-label required">主办方</text>
          <view class="select-container" @tap="showOrganizerPicker">
            <text class="select-text" :class="{ placeholder: !selectedOrganizerName }">
              {{ selectedOrganizerName || '请选择主办方' }}
            </text>
            <text class="iconfont icon-arrow-right"></text>
          </view>
        </view>
        
        <view class="form-item">
          <text class="item-label required">赛事类型</text>
          <view class="radio-group">
            <view 
              class="radio-item" 
              v-for="type in eventTypeOptions" 
              :key="type.value"
              @tap="selectEventType(type.value)"
            >
              <view class="radio-icon" :class="{ checked: formData.event_type === type.value }">
                <text class="iconfont icon-check" v-if="formData.event_type === type.value"></text>
              </view>
              <text class="radio-label">{{ type.label }}</text>
            </view>
          </view>
        </view>
        
        <view class="form-item" v-if="formData.event_type === 2">
          <text class="item-label required">系列赛</text>
          <view class="select-container" @tap="showSeriesPicker">
            <text class="select-text" :class="{ placeholder: !selectedSeriesName }">
              {{ selectedSeriesName || '请选择系列赛' }}
            </text>
            <text class="iconfont icon-arrow-right"></text>
          </view>
        </view>
      </view>
      
      <!-- 时间地点信息 -->
      <view class="form-section">
        <view class="section-header">
          <text class="section-title">时间地点</text>
          <text class="section-desc">设置赛事的时间和地点</text>
        </view>
        
        <view class="form-item">
          <text class="item-label required">举办地点</text>
          <view class="location-container" @tap="chooseLocation">
            <text class="location-text" :class="{ placeholder: !formData.location }">
              {{ formData.location || '点击选择地图位置' }}
            </text>
            <text class="iconfont icon-location"></text>
          </view>
        </view>
        
        <view class="form-item">
          <text class="item-label required">详细地址</text>
          <input 
            class="form-input" 
            v-model="formData.address_detail" 
            placeholder="请输入详细地址"
            maxlength="100"
          />
        </view>
        
        <view class="form-item">
          <text class="item-label required">开始时间</text>
          <view class="datetime-container">
            <picker mode="date" :value="startDate" @change="onStartDateChange">
              <view class="date-picker">
                <text class="date-text">{{ startDate || '选择日期' }}</text>
              </view>
            </picker>
            <picker mode="time" :value="startTime" @change="onStartTimeChange">
              <view class="time-picker">
                <text class="time-text">{{ startTime || '选择时间' }}</text>
              </view>
            </picker>
          </view>
        </view>
        
        <view class="form-item">
          <text class="item-label required">结束时间</text>
          <view class="datetime-container">
            <picker mode="date" :value="endDate" @change="onEndDateChange">
              <view class="date-picker">
                <text class="date-text">{{ endDate || '选择日期' }}</text>
              </view>
            </picker>
            <picker mode="time" :value="endTime" @change="onEndTimeChange">
              <view class="time-picker">
                <text class="time-text">{{ endTime || '选择时间' }}</text>
              </view>
            </picker>
          </view>
        </view>
      </view>
      
      <!-- 比赛项目 -->
      <view class="form-section">
        <view class="section-header">
          <text class="section-title">比赛项目</text>
          <text class="section-desc">选择本次赛事包含的比赛项目</text>
        </view>
        
        <view class="items-container">
          <view class="items-selected" v-if="selectedItems.length > 0">
            <view class="selected-tag" v-for="item in selectedItems" :key="item.id">
              <text class="tag-text">{{ item.name }}</text>
              <text class="iconfont icon-close" @tap="removeItem(item.id)"></text>
            </view>
          </view>
          
          <view class="items-selector" @tap="showItemSelector">
            <text class="selector-text">选择比赛项目</text>
            <text class="iconfont icon-arrow-right"></text>
          </view>
          
          <view class="items-summary">
            已选择 {{ selectedItems.length }} 个项目
          </view>
        </view>
      </view>
    </scroll-view>
    
    <!-- 底部操作栏 -->
    <view class="bottom-actions">
      <button class="submit-btn" :class="{ disabled: !isFormValid }" @tap="submitForm">
        <text class="btn-text">创建赛事</text>
      </button>
    </view>
    
    <!-- 主办方选择弹窗 -->
    <uni-popup ref="organizerPopup" type="bottom">
      <view class="popup-container">
        <view class="popup-header">
          <text class="header-title">选择主办方</text>
          <text class="iconfont icon-close" @tap="closeOrganizerPopup"></text>
        </view>
        <scroll-view class="popup-content" scroll-y>
          <view 
            class="organizer-item" 
            v-for="organizer in organizerList" 
            :key="organizer.id"
            @tap="selectOrganizer(organizer)"
          >
            <text class="organizer-name">{{ organizer.organizer_name }}</text>
            <text class="iconfont icon-check" v-if="formData.organizer_id === organizer.id"></text>
          </view>
        </scroll-view>
        <view class="popup-footer">
          <button class="add-btn" @tap="showAddOrganizer">
            <text class="iconfont icon-plus"></text>
            <text class="btn-text">添加主办方</text>
          </button>
        </view>
      </view>
    </uni-popup>
    
    <!-- 系列赛选择弹窗 -->
    <uni-popup ref="seriesPopup" type="bottom">
      <view class="popup-container">
        <view class="popup-header">
          <text class="header-title">选择系列赛</text>
          <text class="iconfont icon-close" @tap="closeSeriesPopup"></text>
        </view>
        <scroll-view class="popup-content" scroll-y>
          <view 
            class="series-item" 
            v-for="series in seriesList" 
            :key="series.id"
            @tap="selectSeries(series)"
          >
            <text class="series-name">{{ series.name }}</text>
            <text class="iconfont icon-check" v-if="formData.series_id === series.id"></text>
          </view>
        </scroll-view>
        <view class="popup-footer">
          <button class="add-btn" @tap="showAddSeries">
            <text class="iconfont icon-plus"></text>
            <text class="btn-text">添加系列赛</text>
          </button>
        </view>
      </view>
    </uni-popup>
    
    <!-- 项目选择弹窗 -->
    <uni-popup ref="itemPopup" type="bottom" class="item-popup">
      <view class="popup-container full-height">
        <view class="popup-header">
          <text class="header-title">选择比赛项目</text>
          <text class="iconfont icon-close" @tap="closeItemPopup"></text>
        </view>
        <view class="search-container">
          <input 
            class="search-input" 
            v-model="searchKeyword" 
            placeholder="搜索项目名称"
          />
          <text class="iconfont icon-search"></text>
        </view>
        <scroll-view class="popup-content" scroll-y>
          <view class="category-list">
            <view 
              class="category-item" 
              v-for="category in filteredCategories" 
              :key="category.id"
            >
              <view class="category-header">
                <text class="category-name">{{ category.name }}</text>
                <text class="category-count">{{ category.items.length }}个项目</text>
              </view>
              <view class="items-list">
                <view 
                  class="item-row" 
                  v-for="item in category.items" 
                  :key="item.id"
                  @tap="toggleItem(item)"
                >
                  <text class="item-name">{{ item.name }}</text>
                  <view class="checkbox" :class="{ checked: isItemSelected(item.id) }">
                    <text class="iconfont icon-check"></text>
                  </view>
                </view>
              </view>
            </view>
          </view>
        </scroll-view>
        <view class="popup-footer">
          <button class="confirm-btn" @tap="confirmItems">
            <text class="btn-text">确定 ({{ selectedItems.length }})</text>
          </button>
        </view>
      </view>
    </uni-popup>
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useLoginCheck } from '@/addon/sport/hooks/useLoginCheck'
import { addEventQoder } from '@/addon/sport/api/eventQoder'
import { getOrganizerList, addOrganizer } from '@/addon/sport/api/organizer'
import { getEventSeriesList, addEventSeries } from '@/addon/sport/api/eventSeries'
import { getCategoryList } from '@/addon/sport/api/category'

// 登录检查
const { requireLogin } = useLoginCheck()

// 表单数据
const formData = ref({
  name: '',
  location: '',
  address_detail: '',
  start_date: '',
  start_time: '',
  end_date: '',
  end_time: '',
  organizer_id: 0,
  event_type: 1,
  series_id: 0,
  base_item_ids: []
})

// 日期时间
const startDate = ref('')
const startTime = ref('')
const endDate = ref('')
const endTime = ref('')

// 数据列表
const organizerList = ref([])
const seriesList = ref([])
const categoryList = ref([])

// 搜索关键词
const searchKeyword = ref('')

// 弹窗引用
const organizerPopup = ref(null)
const seriesPopup = ref(null)
const itemPopup = ref(null)

// 临时选择的项目
const tempSelectedItems = ref([])

// 计算属性
const selectedItems = computed(() => {
  return tempSelectedItems.value
})

const selectedOrganizerName = computed(() => {
  const organizer = organizerList.value.find(item => item.id === formData.value.organizer_id)
  return organizer ? organizer.organizer_name : ''
})

const selectedSeriesName = computed(() => {
  const series = seriesList.value.find(item => item.id === formData.value.series_id)
  return series ? series.name : ''
})

const isFormValid = computed(() => {
  return formData.value.name && 
         formData.value.organizer_id && 
         formData.value.location && 
         formData.value.address_detail && 
         formData.value.start_date && 
         formData.value.start_time && 
         formData.value.end_date && 
         formData.value.end_time &&
         (formData.value.event_type === 1 || (formData.value.event_type === 2 && formData.value.series_id)) &&
         selectedItems.value.length > 0
})

const eventTypeOptions = [
  { label: '独立赛事', value: 1 },
  { label: '系列赛事', value: 2 }
]

const filteredCategories = computed(() => {
  if (!searchKeyword.value) {
    return categoryList.value
  }
  
  const keyword = searchKeyword.value.toLowerCase()
  return categoryList.value.map(category => {
    const filteredItems = category.items.filter(item => 
      item.name.toLowerCase().includes(keyword)
    )
    return {
      ...category,
      items: filteredItems
    }
  }).filter(category => category.items.length > 0)
})

// 方法
const goBack = () => {
  uni.navigateBack()
}

const showOrganizerPicker = () => {
  organizerPopup.value.open()
}

const closeOrganizerPopup = () => {
  organizerPopup.value.close()
}

const selectOrganizer = (organizer) => {
  formData.value.organizer_id = organizer.id
  closeOrganizerPopup()
}

const showAddOrganizer = () => {
  uni.showToast({
    title: '添加主办方功能开发中',
    icon: 'none'
  })
}

const showSeriesPicker = () => {
  seriesPopup.value.open()
}

const closeSeriesPopup = () => {
  seriesPopup.value.close()
}

const selectSeries = (series) => {
  formData.value.series_id = series.id
  closeSeriesPopup()
}

const showAddSeries = () => {
  uni.showToast({
    title: '添加系列赛功能开发中',
    icon: 'none'
  })
}

const selectEventType = (type) => {
  formData.value.event_type = type
  if (type === 1) {
    formData.value.series_id = 0
  }
}

const chooseLocation = () => {
  // #ifdef MP-WEIXIN
  uni.chooseLocation({
    success: (res) => {
      formData.value.location = res.name || res.address
      formData.value.address_detail = res.address
    },
    fail: (err) => {
      console.error('选择位置失败:', err)
      uni.showToast({
        title: '选择位置失败',
        icon: 'none'
      })
    }
  })
  // #endif
  
  // #ifndef MP-WEIXIN
  uni.showToast({
    title: '当前环境不支持选择位置',
    icon: 'none'
  })
  // #endif
}

const onStartDateChange = (e) => {
  startDate.value = e.detail.value
  formData.value.start_date = e.detail.value
}

const onStartTimeChange = (e) => {
  startTime.value = e.detail.value
  formData.value.start_time = e.detail.value
}

const onEndDateChange = (e) => {
  endDate.value = e.detail.value
  formData.value.end_date = e.detail.value
}

const onEndTimeChange = (e) => {
  endTime.value = e.detail.value
  formData.value.end_time = e.detail.value
}

const showItemSelector = () => {
  // 初始化临时选择
  tempSelectedItems.value = [...selectedItems.value]
  itemPopup.value.open()
}

const closeItemPopup = () => {
  itemPopup.value.close()
}

const isItemSelected = (itemId) => {
  return tempSelectedItems.value.some(item => item.id === itemId)
}

const toggleItem = (item) => {
  const index = tempSelectedItems.value.findIndex(i => i.id === item.id)
  if (index > -1) {
    tempSelectedItems.value.splice(index, 1)
  } else {
    tempSelectedItems.value.push(item)
  }
}

const confirmItems = () => {
  // 确认选择，关闭弹窗
  closeItemPopup()
}

const removeItem = (itemId) => {
  const index = selectedItems.value.findIndex(item => item.id === itemId)
  if (index > -1) {
    selectedItems.value.splice(index, 1)
  }
}

const submitForm = async () => {
  if (!isFormValid.value) {
    uni.showToast({
      title: '请完善赛事信息',
      icon: 'none'
    })
    return
  }

  try {
    uni.showLoading({
      title: '创建中...'
    })

    // 准备提交数据
    const submitData = {
      name: formData.value.name,
      location: formData.value.location,
      address_detail: formData.value.address_detail,
      start_date: formData.value.start_date,
      start_time: formData.value.start_time,
      end_date: formData.value.end_date,
      end_time: formData.value.end_time,
      organizer_id: formData.value.organizer_id,
      event_type: formData.value.event_type,
      series_id: formData.value.series_id,
      base_item_ids: selectedItems.value.map(item => item.id)
    }

    // 调用接口创建赛事
    const result = await addEventQoder(submitData)
    
    uni.hideLoading()
    
    if (result.code === 1) {
      uni.showToast({
        title: '赛事创建成功',
        icon: 'success'
      })
      
      // 跳转到赛事详情页
      setTimeout(() => {
        uni.redirectTo({
          url: `/addon/sport/pages/event/detail?id=${result.data.id}`
        })
      }, 1500)
    } else {
      uni.showToast({
        title: result.msg || '创建失败',
        icon: 'none'
      })
    }
  } catch (error) {
    uni.hideLoading()
    uni.showToast({
      title: '创建失败，请重试',
      icon: 'none'
    })
    console.error('创建赛事失败:', error)
  }
}

// 加载数据
const loadOrganizers = async () => {
  try {
    const result = await getOrganizerList()
    if (result.code === 1) {
      organizerList.value = result.data
    }
  } catch (error) {
    console.error('加载主办方列表失败:', error)
  }
}

const loadSeries = async () => {
  try {
    const result = await getEventSeriesList()
    if (result.code === 1) {
      seriesList.value = result.data
    }
  } catch (error) {
    console.error('加载系列赛列表失败:', error)
  }
}

const loadCategories = async () => {
  try {
    const result = await getCategoryList()
    if (result.code === 1) {
      // 转换数据结构以适应前端展示
      categoryList.value = result.data.map(category => ({
        id: category.id,
        name: category.name,
        items: category.base_items || []
      }))
    }
  } catch (error) {
    console.error('加载项目分类失败:', error)
  }
}

// 页面初始化
onMounted(() => {
  requireLogin(() => {
    // 初始化日期为今天
    const today = new Date().toISOString().split('T')[0]
    startDate.value = today
    endDate.value = today
    formData.value.start_date = today
    formData.value.end_date = today
    
    // 初始化时间为当前时间
    const now = new Date()
    const hours = String(now.getHours()).padStart(2, '0')
    const minutes = String(now.getMinutes()).padStart(2, '0')
    startTime.value = `${hours}:${minutes}`
    endTime.value = `${hours}:${minutes}`
    formData.value.start_time = `${hours}:${minutes}`
    formData.value.end_time = `${hours}:${minutes}`
    
    // 加载数据
    loadOrganizers()
    loadSeries()
    loadCategories()
  })
})
</script>

<style lang="scss" scoped>
.create-event-container {
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding-bottom: 120rpx;
}

.nav-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20rpx 30rpx;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  
  .nav-back {
    width: 60rpx;
    height: 60rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    
    .iconfont {
      color: #fff;
      font-size: 40rpx;
    }
  }
  
  .nav-title {
    font-size: 36rpx;
    font-weight: bold;
    color: #fff;
  }
  
  .nav-placeholder {
    width: 60rpx;
  }
}

.page-header {
  padding: 40rpx 30rpx 20rpx;
  text-align: center;
  
  .header-title {
    display: block;
    font-size: 48rpx;
    font-weight: bold;
    color: #fff;
    margin-bottom: 10rpx;
  }
  
  .header-subtitle {
    display: block;
    font-size: 28rpx;
    color: rgba(255, 255, 255, 0.9);
  }
}

.form-container {
  padding: 20rpx 30rpx;
  height: calc(100vh - 300rpx);
}

.form-section {
  background: rgba(255, 255, 255, 0.95);
  border-radius: 20rpx;
  padding: 30rpx;
  margin-bottom: 30rpx;
  box-shadow: 0 10rpx 30rpx rgba(0, 0, 0, 0.1);
  
  .section-header {
    margin-bottom: 30rpx;
    
    .section-title {
      display: block;
      font-size: 36rpx;
      font-weight: bold;
      color: #333;
      margin-bottom: 10rpx;
    }
    
    .section-desc {
      display: block;
      font-size: 24rpx;
      color: #999;
    }
  }
  
  .form-item {
    margin-bottom: 30rpx;
    
    &:last-child {
      margin-bottom: 0;
    }
    
    .item-label {
      display: block;
      font-size: 28rpx;
      color: #333;
      margin-bottom: 15rpx;
      
      &.required::after {
        content: '*';
        color: #ff4757;
        margin-left: 10rpx;
      }
    }
    
    .form-input {
      width: 100%;
      height: 80rpx;
      background: #f8f9fa;
      border-radius: 15rpx;
      padding: 0 20rpx;
      font-size: 28rpx;
      color: #333;
      border: 2rpx solid #e9ecef;
      
      &::placeholder {
        color: #999;
      }
      
      &:focus {
        border-color: #667eea;
      }
    }
    
    .select-container {
      display: flex;
      align-items: center;
      justify-content: space-between;
      height: 80rpx;
      background: #f8f9fa;
      border-radius: 15rpx;
      padding: 0 20rpx;
      border: 2rpx solid #e9ecef;
      
      .select-text {
        font-size: 28rpx;
        color: #333;
        
        &.placeholder {
          color: #999;
        }
      }
      
      .iconfont {
        color: #999;
        font-size: 28rpx;
      }
    }
    
    .radio-group {
      display: flex;
      flex-direction: column;
      gap: 20rpx;
      
      .radio-item {
        display: flex;
        align-items: center;
        gap: 20rpx;
        
        .radio-icon {
          width: 40rpx;
          height: 40rpx;
          border-radius: 50%;
          border: 2rpx solid #ddd;
          display: flex;
          align-items: center;
          justify-content: center;
          
          &.checked {
            background: #667eea;
            border-color: #667eea;
            
            .iconfont {
              color: #fff;
              font-size: 24rpx;
            }
          }
        }
        
        .radio-label {
          font-size: 28rpx;
          color: #333;
        }
      }
    }
    
    .location-container {
      display: flex;
      align-items: center;
      justify-content: space-between;
      height: 80rpx;
      background: #f8f9fa;
      border-radius: 15rpx;
      padding: 0 20rpx;
      border: 2rpx solid #e9ecef;
      
      .location-text {
        font-size: 28rpx;
        color: #333;
        
        &.placeholder {
          color: #999;
        }
      }
      
      .iconfont {
        color: #667eea;
        font-size: 32rpx;
      }
    }
    
    .datetime-container {
      display: flex;
      gap: 20rpx;
      
      .date-picker, .time-picker {
        flex: 1;
        height: 80rpx;
        background: #f8f9fa;
        border-radius: 15rpx;
        display: flex;
        align-items: center;
        justify-content: center;
        border: 2rpx solid #e9ecef;
        
        .date-text, .time-text {
          font-size: 28rpx;
          color: #333;
        }
      }
    }
  }
  
  .items-container {
    .items-selected {
      display: flex;
      flex-wrap: wrap;
      gap: 15rpx;
      margin-bottom: 30rpx;
      
      .selected-tag {
        display: flex;
        align-items: center;
        gap: 10rpx;
        background: #667eea;
        color: #fff;
        padding: 10rpx 20rpx;
        border-radius: 30rpx;
        font-size: 24rpx;
        
        .iconfont {
          font-size: 20rpx;
        }
      }
    }
    
    .items-selector {
      display: flex;
      align-items: center;
      justify-content: space-between;
      height: 80rpx;
      background: #f8f9fa;
      border-radius: 15rpx;
      padding: 0 20rpx;
      border: 2rpx dashed #667eea;
      
      .selector-text {
        font-size: 28rpx;
        color: #667eea;
      }
      
      .iconfont {
        color: #667eea;
        font-size: 28rpx;
      }
    }
    
    .items-summary {
      text-align: center;
      margin-top: 20rpx;
      font-size: 24rpx;
      color: #999;
    }
  }
}

.bottom-actions {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 20rpx 30rpx 40rpx;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  
  .submit-btn {
    width: 100%;
    height: 90rpx;
    background: #fff;
    border-radius: 45rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    border: none;
    
    &.disabled {
      opacity: 0.6;
    }
    
    .btn-text {
      font-size: 32rpx;
      font-weight: bold;
      color: #667eea;
    }
  }
}

.popup-container {
  background: #fff;
  border-radius: 20rpx 20rpx 0 0;
  max-height: 80vh;
  
  &.full-height {
    height: 80vh;
  }
  
  .popup-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 30rpx;
    border-bottom: 1rpx solid #eee;
    
    .header-title {
      font-size: 36rpx;
      font-weight: bold;
      color: #333;
    }
    
    .iconfont {
      font-size: 36rpx;
      color: #999;
    }
  }
  
  .search-container {
    position: relative;
    padding: 20rpx 30rpx;
    
    .search-input {
      width: 100%;
      height: 70rpx;
      background: #f8f9fa;
      border-radius: 35rpx;
      padding: 0 30rpx 0 70rpx;
      font-size: 28rpx;
      border: none;
    }
    
    .iconfont {
      position: absolute;
      left: 50rpx;
      top: 50%;
      transform: translateY(-50%);
      font-size: 32rpx;
      color: #999;
    }
  }
  
  .popup-content {
    max-height: 60vh;
    padding: 20rpx 30rpx;
    
    .organizer-item, .series-item {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 30rpx 0;
      border-bottom: 1rpx solid #f0f0f0;
      
      &:last-child {
        border-bottom: none;
      }
      
      .organizer-name, .series-name {
        font-size: 28rpx;
        color: #333;
      }
      
      .iconfont {
        color: #667eea;
        font-size: 32rpx;
      }
    }
    
    .category-list {
      .category-item {
        margin-bottom: 30rpx;
        
        .category-header {
          display: flex;
          align-items: center;
          justify-content: space-between;
          padding: 20rpx;
          background: #f8f9fa;
          border-radius: 15rpx;
          margin-bottom: 20rpx;
          
          .category-name {
            font-size: 30rpx;
            font-weight: bold;
            color: #333;
          }
          
          .category-count {
            font-size: 24rpx;
            color: #999;
          }
        }
        
        .items-list {
          .item-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 20rpx 0;
            border-bottom: 1rpx solid #f0f0f0;
            
            &:last-child {
              border-bottom: none;
            }
            
            .item-name {
              font-size: 28rpx;
              color: #333;
            }
            
            .checkbox {
              width: 36rpx;
              height: 36rpx;
              border-radius: 50%;
              border: 2rpx solid #ddd;
              display: flex;
              align-items: center;
              justify-content: center;
              
              &.checked {
                background: #667eea;
                border-color: #667eea;
                
                .iconfont {
                  color: #fff;
                  font-size: 24rpx;
                }
              }
            }
          }
        }
      }
    }
  }
  
  .popup-footer {
    padding: 20rpx 30rpx 40rpx;
    
    .add-btn {
      width: 100%;
      height: 80rpx;
      background: #f8f9fa;
      border-radius: 15rpx;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 10rpx;
      border: none;
      
      .iconfont {
        font-size: 32rpx;
        color: #667eea;
      }
      
      .btn-text {
        font-size: 28rpx;
        color: #667eea;
      }
    }
    
    .confirm-btn {
      width: 100%;
      height: 80rpx;
      background: #667eea;
      border-radius: 15rpx;
      display: flex;
      align-items: center;
      justify-content: center;
      border: none;
      
      .btn-text {
        font-size: 28rpx;
        color: #fff;
        font-weight: bold;
      }
    }
  }
}
</style>

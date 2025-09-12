<template>
  <view class="signup-form-page">
    <!-- 页面头部 -->
    <view class="page-header">
      <view class="header-left" @click="goBack">
        <text class="nc-iconfont nc-icon-zuoV6xx"></text>
        <text class="header-title">赛事报名</text>
      </view>
    </view>

    <!-- 主要内容区域 -->
    <view class="main-content">
      <!-- 赛事信息卡片 -->
      <view class="event-info-card">
        <view class="card-header">
          <text class="event-name">{{ eventInfo.name }}</text>
          <text class="event-time">{{ eventInfo.start_time_text }}</text>
        </view>
        <view class="card-content">
          <text class="event-location">{{ eventInfo.location }}</text>
        </view>
      </view>

      <!-- 项目选择 -->
      <view class="section-card">
        <view class="card-header">
          <text class="card-title">选择参赛项目</text>
        </view>
        <view class="card-content">
          <view v-if="eventItems.length > 0" class="project-selection">
            <view 
              v-for="item in eventItems" 
              :key="item.id"
              class="project-option"
              :class="{ selected: selectedProjects.includes(item.id) }"
              @click="toggleProject(item.id)"
            >
              <view class="project-info">
                <text class="project-name">{{ item.base_item_name }}</text>
                <text class="project-details">
                  {{ item.age_group || '不限年龄' }} · 
                  {{ getGenderLimitText(item.gender_limit) }} · 
                  ￥{{ item.registration_fee || '0' }}
                </text>
              </view>
              <view class="project-checkbox">
                <text v-if="selectedProjects.includes(item.id)" class="check-icon">✓</text>
              </view>
            </view>
          </view>
          <view v-else class="empty-projects">
            <text class="empty-text">暂无可选项目</text>
          </view>
        </view>
      </view>

      <!-- 参赛人员信息 -->
      <view class="section-card">
        <view class="card-header">
          <text class="card-title">参赛人员信息</text>
          <view class="participant-count">
            <text class="count-text">{{ participants.length }}人</text>
          </view>
        </view>
        <view class="card-content">
          <view class="participants-list">
            <view 
              v-for="(participant, index) in participants" 
              :key="index"
              class="participant-item"
            >
              <view class="participant-header">
                <text class="participant-title">参赛人员 {{ index + 1 }}</text>
                <button 
                  v-if="participants.length > 1"
                  class="remove-btn"
                  @click="removeParticipant(index)"
                >
                  删除
                </button>
              </view>
              
              <view class="participant-form">
                <!-- 动态表单字段 -->
                <view 
                  v-for="field in signupFields" 
                  :key="field.key"
                  class="form-item"
                >
                  <text class="form-label">
                    {{ field.label }}
                    <text v-if="field.required" class="required">*</text>
                  </text>
                  
                  <!-- 文本输入 -->
                  <input 
                    v-if="field.type === 'text' || field.type === 'mobile' || field.type === 'id_card'"
                    v-model="participant[field.key]"
                    class="form-input"
                    :placeholder="`请输入${field.label}`"
                    :type="getInputType(field.type)"
                  />
                  
                  <!-- 选择器 -->
                  <picker 
                    v-else-if="field.type === 'select'"
                    :value="getSelectIndex(field, participant[field.key])"
                    :range="field.options"
                    @change="updateSelectValue(field, participant, $event)"
                  >
                    <view class="form-picker">
                      {{ participant[field.key] || `请选择${field.label}` }}
                    </view>
                  </picker>
                  
                  <!-- 日期选择 -->
                  <picker 
                    v-else-if="field.type === 'date'"
                    mode="date"
                    :value="participant[field.key]"
                    @change="updateDateValue(field, participant, $event)"
                  >
                    <view class="form-picker">
                      {{ participant[field.key] || `请选择${field.label}` }}
                    </view>
                  </picker>
                  
                  <!-- 多行文本 -->
                  <textarea 
                    v-else-if="field.type === 'textarea'"
                    v-model="participant[field.key]"
                    class="form-textarea"
                    :placeholder="`请输入${field.label}`"
                  />
                </view>
              </view>
            </view>
          </view>
          
          <view class="add-participant">
            <button class="add-btn" @click="addParticipant">
              <text class="add-icon">+</text>
              <text class="add-text">添加参赛人员</text>
            </button>
          </view>
        </view>
      </view>

      <!-- 费用明细 -->
      <view class="section-card">
        <view class="card-header">
          <text class="card-title">费用明细</text>
        </view>
        <view class="card-content">
          <view class="fee-details">
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
      </view>

      <!-- 报名须知 -->
      <view class="section-card">
        <view class="card-header">
          <text class="card-title">报名须知</text>
        </view>
        <view class="card-content">
          <view class="notice-content">
            <text class="notice-text">
              1. 请确保填写信息真实有效，虚假信息将影响参赛资格\n
              2. 报名费用一经缴纳，除赛事取消外不予退还\n
              3. 请按时参加比赛，逾期视为自动放弃\n
              4. 如有疑问请联系主办方
            </text>
          </view>
          <view class="agreement">
            <checkbox 
              :checked="agreedToTerms"
              @change="toggleAgreement"
              class="agreement-checkbox"
            />
            <text class="agreement-text">我已阅读并同意报名须知</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 底部提交区域 -->
    <view class="submit-area">
      <view class="fee-summary">
        <text class="summary-label">报名费用：</text>
        <text class="summary-amount">￥{{ totalFee }}</text>
      </view>
      <button 
        class="submit-btn"
        :disabled="!canSubmit"
        @click="submitRegistration"
      >
        {{ isSubmitting ? '提交中...' : '确认报名' }}
      </button>
    </view>

    <!-- 底部安全区域 -->
    <view class="safe-area-bottom"></view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { getEventDetailInfo, getEventItems } from '@/addon/sport/api/event'

// 页面参数
const eventId = ref<number>(0)

// 数据状态
const loading = ref(true)
const isSubmitting = ref(false)
const eventInfo = ref<any>({})
const eventItems = ref<any[]>([])
const signupFields = ref<any[]>([])
const selectedProjects = ref<number[]>([])
const participants = ref<any[]>([{}])
const agreedToTerms = ref(false)

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
    loading.value = true
    
    // 并行加载数据
    await Promise.all([
      loadEventInfo(),
      loadEventItems()
    ])
    
    // 初始化报名字段
    initSignupFields()
    
    // 添加第一个参赛人员
    addParticipant()
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

// 初始化报名字段
const initSignupFields = () => {
  // 默认字段
  const defaultFields = [
    { key: 'name', label: '姓名', type: 'text', required: true },
    { key: 'mobile', label: '手机号', type: 'mobile', required: true },
    { key: 'id_card', label: '身份证号', type: 'id_card', required: true }
  ]
  
  // 从赛事配置中获取自定义字段
  const customFields = eventInfo.value.signup_fields || []
  
  signupFields.value = [...defaultFields, ...customFields]
}

// 计算属性
const feeDetails = computed(() => {
  const details: any[] = []
  
  selectedProjects.value.forEach(projectId => {
    const project = eventItems.value.find(item => item.id === projectId)
    if (project && project.registration_fee > 0) {
      details.push({
        name: project.base_item_name,
        amount: project.registration_fee
      })
    }
  })
  
  return details
})

const totalFee = computed(() => {
  return feeDetails.value.reduce((total, fee) => total + fee.amount, 0)
})

const canSubmit = computed(() => {
  return selectedProjects.value.length > 0 && 
         participants.value.length > 0 && 
         agreedToTerms.value &&
         isFormValid.value
})

const isFormValid = computed(() => {
  return participants.value.every(participant => {
    return signupFields.value.every(field => {
      if (field.required) {
        return participant[field.key] && participant[field.key].trim() !== ''
      }
      return true
    })
  })
})

// 方法
const toggleProject = (projectId: number) => {
  const index = selectedProjects.value.indexOf(projectId)
  if (index > -1) {
    selectedProjects.value.splice(index, 1)
  } else {
    selectedProjects.value.push(projectId)
  }
}

const addParticipant = () => {
  participants.value.push({})
}

const removeParticipant = (index: number) => {
  if (participants.value.length > 1) {
    participants.value.splice(index, 1)
  }
}

const getInputType = (fieldType: string) => {
  const typeMap: Record<string, string> = {
    mobile: 'number',
    id_card: 'text'
  }
  return typeMap[fieldType] || 'text'
}

const getSelectIndex = (field: any, value: string) => {
  return field.options?.indexOf(value) || 0
}

const updateSelectValue = (field: any, participant: any, event: any) => {
  participant[field.key] = field.options[event.detail.value]
}

const updateDateValue = (field: any, participant: any, event: any) => {
  participant[field.key] = event.detail.value
}

const getGenderLimitText = (limit: number) => {
  const limitMap: Record<number, string> = {
    1: '仅限男性',
    2: '仅限女性',
    3: '不限性别'
  }
  return limitMap[limit] || '不限性别'
}

const toggleAgreement = (event: any) => {
  agreedToTerms.value = event.detail.value
}

const submitRegistration = async () => {
  if (!canSubmit.value) {
    uni.showToast({
      title: '请完善报名信息',
      icon: 'none'
    })
    return
  }
  
  try {
    isSubmitting.value = true
    
    // 构建提交数据
    const submitData = {
      event_id: eventId.value,
      project_ids: selectedProjects.value,
      participants: participants.value,
      total_fee: totalFee.value,
      fee_details: feeDetails.value
    }
    
    // 这里应该调用报名提交接口
    // const response = await registrationApi.submitRegistration(submitData)
    
    // 模拟提交成功
    await new Promise(resolve => setTimeout(resolve, 2000))
    
    uni.showToast({
      title: '报名成功',
      icon: 'success'
    })
    
    // 跳转到报名成功页面
    setTimeout(() => {
      uni.redirectTo({
        url: `/addon/sport/pages/event/signup_success?event_id=${eventId.value}`
      })
    }, 1500)
    
  } catch (error) {
    console.error('提交报名失败:', error)
    uni.showToast({
      title: '提交失败，请重试',
      icon: 'error'
    })
  } finally {
    isSubmitting.value = false
  }
}

const goBack = () => {
  uni.navigateBack()
}
</script>

<style lang="scss" scoped>
.signup-form-page {
  min-height: 100vh;
  background-color: #f5f5f5;
}

.page-header {
  height: 88rpx;
  background: #fff;
  display: flex;
  align-items: center;
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
}

.main-content {
  margin-top: 88rpx;
  padding-bottom: 200rpx;
}

.event-info-card {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  margin: 20rpx 30rpx;
  border-radius: 16rpx;
  padding: 30rpx;
  color: #fff;

  .card-header {
    margin-bottom: 16rpx;

    .event-name {
      display: block;
      font-size: 32rpx;
      font-weight: 500;
      margin-bottom: 8rpx;
    }

    .event-time {
      font-size: 26rpx;
      opacity: 0.9;
    }
  }

  .card-content {
    .event-location {
      font-size: 24rpx;
      opacity: 0.8;
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
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 30rpx;
    border-bottom: 1rpx solid #eee;
    
    .card-title {
      font-size: 32rpx;
      font-weight: 500;
      color: #333;
    }

    .participant-count {
      .count-text {
        font-size: 26rpx;
        color: #409EFF;
        background: #e3f2fd;
        padding: 8rpx 16rpx;
        border-radius: 12rpx;
      }
    }
  }

  .card-content {
    padding: 30rpx;
  }
}

.project-selection {
  .project-option {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 24rpx;
    border: 2rpx solid #eee;
    border-radius: 12rpx;
    margin-bottom: 16rpx;
    transition: all 0.2s;

    &.selected {
      border-color: #409EFF;
      background: #f0f9ff;
    }

    .project-info {
      flex: 1;

      .project-name {
        display: block;
        font-size: 30rpx;
        font-weight: 500;
        color: #333;
        margin-bottom: 8rpx;
      }

      .project-details {
        font-size: 24rpx;
        color: #666;
      }
    }

    .project-checkbox {
      width: 40rpx;
      height: 40rpx;
      border: 2rpx solid #ddd;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-left: 20rpx;

      .check-icon {
        font-size: 24rpx;
        color: #409EFF;
        font-weight: bold;
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

.participants-list {
  .participant-item {
    border: 1rpx solid #eee;
    border-radius: 12rpx;
    margin-bottom: 24rpx;
    overflow: hidden;

    .participant-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 20rpx 24rpx;
      background: #f8f9fa;
      border-bottom: 1rpx solid #eee;

      .participant-title {
        font-size: 28rpx;
        font-weight: 500;
        color: #333;
      }

      .remove-btn {
        padding: 8rpx 16rpx;
        background: #f56c6c;
        color: #fff;
        border: none;
        border-radius: 6rpx;
        font-size: 24rpx;
      }
    }

    .participant-form {
      padding: 24rpx;

      .form-item {
        margin-bottom: 24rpx;

        &:last-child {
          margin-bottom: 0;
        }

        .form-label {
          display: block;
          font-size: 28rpx;
          color: #333;
          margin-bottom: 12rpx;

          .required {
            color: #f56c6c;
            margin-left: 4rpx;
          }
        }

        .form-input {
          width: 100%;
          height: 80rpx;
          padding: 0 20rpx;
          border: 1rpx solid #ddd;
          border-radius: 8rpx;
          font-size: 28rpx;
          color: #333;
          box-sizing: border-box;
        }

        .form-picker {
          height: 80rpx;
          line-height: 80rpx;
          padding: 0 20rpx;
          border: 1rpx solid #ddd;
          border-radius: 8rpx;
          font-size: 28rpx;
          color: #333;
          background: #fff;
        }

        .form-textarea {
          width: 100%;
          min-height: 120rpx;
          padding: 20rpx;
          border: 1rpx solid #ddd;
          border-radius: 8rpx;
          font-size: 28rpx;
          color: #333;
          box-sizing: border-box;
        }
      }
    }
  }
}

.add-participant {
  .add-btn {
    width: 100%;
    height: 80rpx;
    border: 2rpx dashed #409EFF;
    border-radius: 8rpx;
    background: transparent;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #409EFF;

    .add-icon {
      font-size: 32rpx;
      margin-right: 12rpx;
    }

    .add-text {
      font-size: 28rpx;
    }
  }
}

.fee-details {
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

.notice-content {
  .notice-text {
    font-size: 26rpx;
    color: #666;
    line-height: 1.6;
  }
}

.agreement {
  display: flex;
  align-items: center;
  margin-top: 30rpx;

  .agreement-checkbox {
    margin-right: 16rpx;
  }

  .agreement-text {
    font-size: 26rpx;
    color: #333;
  }
}

.submit-area {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  background: #fff;
  padding: 20rpx 30rpx;
  border-top: 1rpx solid #eee;
  display: flex;
  align-items: center;
  gap: 20rpx;

  .fee-summary {
    flex: 1;

    .summary-label {
      font-size: 28rpx;
      color: #666;
    }

    .summary-amount {
      font-size: 32rpx;
      font-weight: 500;
      color: #f56c6c;
    }
  }

  .submit-btn {
    width: 200rpx;
    height: 80rpx;
    background: #409EFF;
    color: #fff;
    border: none;
    border-radius: 8rpx;
    font-size: 28rpx;
    font-weight: 500;

    &:disabled {
      background: #c0c4cc;
    }
  }
}

.safe-area-bottom {
  height: env(safe-area-inset-bottom);
}
</style>

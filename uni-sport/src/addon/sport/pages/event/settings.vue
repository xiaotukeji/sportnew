<template>
    <view class="container">
        <!-- 页面标题 -->
        <view class="page-header">
            <text class="page-title">赛事设置</text>
            <text class="page-subtitle">{{ eventInfo?.name || '赛事配置' }}</text>
        </view>
        
        <!-- 设置表单 -->
        <view class="settings-form">
            <!-- 基本信息设置 -->
            <view class="form-section">
                <view class="section-title">
                    <text class="title-text">基本信息</text>
                </view>
                
                <view class="form-item">
                    <text class="item-label">赛事状态</text>
                    <picker 
                        :value="formData.status" 
                        :range="statusOptions" 
                        range-key="label"
                        @change="onStatusChange"
                    >
                        <view class="picker-value">
                            {{ getStatusText(formData.status) }}
                            <text class="picker-arrow">></text>
                        </view>
                    </picker>
                </view>
                
                <view class="form-item">
                    <text class="item-label">排序权重</text>
                    <input 
                        class="item-input" 
                        type="number" 
                        v-model="formData.sort"
                        placeholder="数字越大排序越靠前"
                    />
                </view>
            </view>
            
            <!-- 报名设置 -->
            <view class="form-section">
                <view class="section-title">
                    <text class="title-text">报名设置</text>
                </view>
                
                <view class="form-item">
                    <text class="item-label">报名开始时间</text>
                    <picker 
                        mode="date" 
                        :value="formData.registration_start_time" 
                        @change="onRegistrationStartChange"
                    >
                        <view class="picker-value">
                            {{ formData.registration_start_time || '请选择' }}
                            <text class="picker-arrow">></text>
                        </view>
                    </picker>
                </view>
                
                <view class="form-item">
                    <text class="item-label">报名结束时间</text>
                    <picker 
                        mode="date" 
                        :value="formData.registration_end_time" 
                        @change="onRegistrationEndChange"
                    >
                        <view class="picker-value">
                            {{ formData.registration_end_time || '请选择' }}
                            <text class="picker-arrow">></text>
                        </view>
                    </picker>
                </view>
                
                <view class="form-item">
                    <text class="item-label">报名费（元）</text>
                    <input 
                        class="item-input" 
                        type="digit" 
                        v-model="formData.registration_fee"
                        placeholder="0表示免费"
                    />
                </view>
                
                <view class="form-item">
                    <text class="item-label">总报名人数限制</text>
                    <input 
                        class="item-input" 
                        type="number" 
                        v-model="formData.max_participants"
                        placeholder="0表示不限制"
                    />
                </view>
            </view>
            
            <!-- 比赛设置 -->
            <view class="form-section">
                <view class="section-title">
                    <text class="title-text">比赛设置</text>
                </view>
                
                <view class="form-item">
                    <text class="item-label">每组人数</text>
                    <input 
                        class="item-input" 
                        type="number" 
                        v-model="formData.group_size"
                        placeholder="每组参赛人数"
                    />
                </view>
                
                <view class="form-item">
                    <text class="item-label">比赛轮次</text>
                    <input 
                        class="item-input" 
                        type="number" 
                        v-model="formData.rounds"
                        placeholder="比赛轮次数量"
                    />
                </view>
                
                <view class="form-item">
                    <text class="item-label">是否允许重复报名</text>
                    <switch 
                        :checked="formData.allow_duplicate_registration" 
                        @change="onDuplicateRegistrationChange"
                    />
                </view>
            </view>
            
            <!-- 显示设置 -->
            <view class="form-section">
                <view class="section-title">
                    <text class="title-text">显示设置</text>
                </view>
                
                <view class="form-item">
                    <text class="item-label">显示年龄组</text>
                    <switch 
                        :checked="formData.age_group_display" 
                        @change="onAgeGroupDisplayChange"
                    />
                </view>
                
                <view class="form-item">
                    <text class="item-label">显示报名人数</text>
                    <switch 
                        :checked="formData.show_participant_count" 
                        @change="onShowParticipantCountChange"
                    />
                </view>
                
                <view class="form-item">
                    <text class="item-label">显示比赛进度</text>
                    <switch 
                        :checked="formData.show_progress" 
                        @change="onShowProgressChange"
                    />
                </view>
            </view>
            
            <!-- 备注说明 -->
            <view class="form-section">
                <view class="section-title">
                    <text class="title-text">备注说明</text>
                </view>
                
                <view class="form-item">
                    <textarea 
                        class="item-textarea" 
                        v-model="formData.remark"
                        placeholder="请输入赛事备注说明..."
                        maxlength="500"
                    />
                    <text class="textarea-count">{{ formData.remark.length }}/500</text>
                </view>
            </view>
        </view>
        
        <!-- 底部按钮 -->
        <view class="bottom-actions">
            <button class="action-btn cancel-btn" @tap="goBack">
                <text class="btn-text">取消</text>
            </button>
            <button class="action-btn save-btn" @tap="saveSettings" :loading="saving">
                <text class="btn-text">{{ saving ? '保存中...' : '保存设置' }}</text>
            </button>
        </view>
    </view>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useLoginCheck } from '@/addon/sport/hooks/useLoginCheck'
import { getEventInfo, updateEventSettings } from '@/addon/sport/api/event'

// 使用登录检查
const { requireLogin } = useLoginCheck()

// 响应式数据
const eventInfo = ref<any>(null)
const eventId = ref(0)
const saving = ref(false)

// 表单数据
const formData = ref({
    status: 0,
    sort: 0,
    registration_start_time: '',
    registration_end_time: '',
    registration_fee: 0,
    max_participants: 0,
    group_size: 0,
    rounds: 0,
    allow_duplicate_registration: false,
    age_group_display: false,
    show_participant_count: true,
    show_progress: true,
    remark: ''
})

// 状态选项
const statusOptions = [
    { value: 0, label: '待发布' },
    { value: 1, label: '进行中' },
    { value: 2, label: '已结束' },
    { value: 3, label: '已作废' }
]

/**
 * 获取状态文本
 */
const getStatusText = (status: number) => {
    const option = statusOptions.find(item => item.value === status)
    return option ? option.label : '未知状态'
}

/**
 * 状态选择事件
 */
const onStatusChange = (e: any) => {
    formData.value.status = statusOptions[e.detail.value].value
}

/**
 * 报名开始时间选择
 */
const onRegistrationStartChange = (e: any) => {
    formData.value.registration_start_time = e.detail.value
}

/**
 * 报名结束时间选择
 */
const onRegistrationEndChange = (e: any) => {
    formData.value.registration_end_time = e.detail.value
}

/**
 * 重复报名开关
 */
const onDuplicateRegistrationChange = (e: any) => {
    formData.value.allow_duplicate_registration = e.detail.value
}

/**
 * 年龄组显示开关
 */
const onAgeGroupDisplayChange = (e: any) => {
    formData.value.age_group_display = e.detail.value
}

/**
 * 显示报名人数开关
 */
const onShowParticipantCountChange = (e: any) => {
    formData.value.show_participant_count = e.detail.value
}

/**
 * 显示进度开关
 */
const onShowProgressChange = (e: any) => {
    formData.value.show_progress = e.detail.value
}

/**
 * 加载赛事信息
 */
const loadEventInfo = async () => {
    if (!eventId.value) return
    
    try {
        const response: any = await getEventInfo(eventId.value)
        eventInfo.value = response.data
        
        // 填充表单数据
        formData.value = {
            status: eventInfo.value.status || 0,
            sort: eventInfo.value.sort || 0,
            registration_start_time: eventInfo.value.registration_start_time || '',
            registration_end_time: eventInfo.value.registration_end_time || '',
            registration_fee: eventInfo.value.registration_fee || 0,
            max_participants: eventInfo.value.max_participants || 0,
            group_size: eventInfo.value.group_size || 0,
            rounds: eventInfo.value.rounds || 0,
            allow_duplicate_registration: eventInfo.value.allow_duplicate_registration || false,
            age_group_display: eventInfo.value.age_group_display || false,
            show_participant_count: eventInfo.value.show_participant_count !== false,
            show_progress: eventInfo.value.show_progress !== false,
            remark: eventInfo.value.remark || ''
        }
        
        console.log('赛事信息:', eventInfo.value)
    } catch (error) {
        console.error('加载赛事信息失败:', error)
        uni.showToast({
            title: '加载失败',
            icon: 'none'
        })
    }
}

/**
 * 保存设置
 */
const saveSettings = async () => {
    requireLogin(async () => {
        try {
            saving.value = true
            
            const response: any = await updateEventSettings({
                event_id: eventId.value,
                ...formData.value
            })
            
            uni.showToast({
                title: '保存成功',
                icon: 'success'
            })
            
            // 延迟返回上一页
            setTimeout(() => {
                uni.navigateBack()
            }, 1500)
            
        } catch (error) {
            console.error('保存设置失败:', error)
            uni.showToast({
                title: '保存失败',
                icon: 'none'
            })
        } finally {
            saving.value = false
        }
    })
}

/**
 * 返回上一页
 */
const goBack = () => {
    uni.navigateBack()
}

/**
 * 页面加载
 */
onMounted(() => {
    // 获取页面参数
    const pages = getCurrentPages()
    const currentPage = pages[pages.length - 1] as any
    const options = currentPage.options || {}
    
    if (options.event_id) {
        eventId.value = parseInt(options.event_id)
        loadEventInfo()
    } else {
        uni.showToast({
            title: '缺少赛事ID参数',
            icon: 'none'
        })
    }
})
</script>

<style lang="scss" scoped>
.container {
    min-height: 100vh;
    background-color: #f5f5f5;
    padding-bottom: 120rpx;
}

.page-header {
    background-color: white;
    padding: 40rpx 32rpx;
    margin-bottom: 20rpx;
    
    .page-title {
        display: block;
        font-size: 36rpx;
        font-weight: bold;
        color: #333;
        margin-bottom: 8rpx;
    }
    
    .page-subtitle {
        display: block;
        font-size: 28rpx;
        color: #666;
    }
}

.settings-form {
    .form-section {
        background-color: white;
        margin: 0 32rpx 20rpx;
        border-radius: 16rpx;
        padding: 32rpx;
        
        .section-title {
            margin-bottom: 32rpx;
            padding-bottom: 20rpx;
            border-bottom: 1rpx solid #f0f0f0;
            
            .title-text {
                font-size: 32rpx;
                font-weight: bold;
                color: #333;
            }
        }
        
        .form-item {
            display: flex;
            align-items: center;
            margin-bottom: 32rpx;
            
            &:last-child {
                margin-bottom: 0;
            }
            
            .item-label {
                width: 200rpx;
                font-size: 28rpx;
                color: #333;
                flex-shrink: 0;
            }
            
            .item-input {
                flex: 1;
                height: 80rpx;
                padding: 0 24rpx;
                border: 1rpx solid #e0e0e0;
                border-radius: 8rpx;
                font-size: 28rpx;
                color: #333;
                background-color: #fafafa;
                
                &:focus {
                    border-color: #007aff;
                    background-color: white;
                }
            }
            
            .picker-value {
                flex: 1;
                height: 80rpx;
                padding: 0 24rpx;
                border: 1rpx solid #e0e0e0;
                border-radius: 8rpx;
                background-color: #fafafa;
                display: flex;
                align-items: center;
                justify-content: space-between;
                font-size: 28rpx;
                color: #333;
                
                .picker-arrow {
                    color: #999;
                    font-size: 24rpx;
                }
            }
            
            .item-textarea {
                flex: 1;
                min-height: 160rpx;
                padding: 24rpx;
                border: 1rpx solid #e0e0e0;
                border-radius: 8rpx;
                font-size: 28rpx;
                color: #333;
                background-color: #fafafa;
                line-height: 1.5;
                
                &:focus {
                    border-color: #007aff;
                    background-color: white;
                }
            }
            
            .textarea-count {
                position: absolute;
                right: 24rpx;
                bottom: 24rpx;
                font-size: 24rpx;
                color: #999;
            }
        }
    }
}

.bottom-actions {
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    background-color: white;
    padding: 32rpx;
    border-top: 1rpx solid #f0f0f0;
    display: flex;
    gap: 24rpx;
    
    .action-btn {
        flex: 1;
        height: 88rpx;
        border-radius: 12rpx;
        border: none;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 32rpx;
        
        .btn-text {
            font-size: 32rpx;
        }
        
        &.cancel-btn {
            background-color: #f8f9fa;
            border: 1rpx solid #dee2e6;
            
            .btn-text {
                color: #333;
            }
        }
        
        &.save-btn {
            background-color: #007aff;
            
            .btn-text {
                color: white;
            }
        }
        
        &:active {
            opacity: 0.8;
        }
    }
}
</style> 
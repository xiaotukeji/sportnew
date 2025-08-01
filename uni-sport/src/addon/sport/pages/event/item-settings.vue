<template>
    <view class="container">
        <!-- 页面标题 -->
        <view class="page-header">
            <text class="page-title">项目设置</text>
            <text class="page-subtitle">{{ eventInfo?.name || '为每个比赛项目设置详细参数' }}</text>
        </view>
        
        <!-- 赛事基本信息 -->
        <view class="event-info-card">
            <view class="event-name">{{ eventInfo?.name }}</view>
            <view class="event-time">{{ formatDateTime(eventInfo?.start_time) }} - {{ formatDateTime(eventInfo?.end_time) }}</view>
        </view>
        
        <!-- 项目列表设置 -->
        <view class="items-settings">
            <view class="section-title">
                <text class="title-text">比赛项目设置</text>
                <text class="title-count">({{ eventItems.length }}个项目)</text>
            </view>
            
            <view v-if="eventItems.length > 0" class="items-list">
                <view 
                    v-for="(item, index) in eventItems" 
                    :key="item.id" 
                    class="item-card"
                >
                    <view class="item-header">
                        <view class="item-info">
                            <text class="item-name">{{ item.name }}</text>
                            <text class="item-category">{{ item.category_name }}</text>
                        </view>
                        <view class="item-status" :class="'status-' + (item.is_configured ? 'configured' : 'pending')">
                            {{ item.is_configured ? '已配置' : '待配置' }}
                        </view>
                    </view>
                    
                    <view class="item-settings">
                        <!-- 报名费设置 -->
                        <view class="setting-item">
                            <text class="setting-label">报名费（元）</text>
                            <input 
                                class="setting-input" 
                                type="digit" 
                                v-model="item.registration_fee"
                                placeholder="0表示免费"
                                @input="onItemSettingChange(index, 'registration_fee', $event)"
                            />
                        </view>
                        
                        <!-- 人数限制设置 -->
                        <view class="setting-item">
                            <text class="setting-label">人数限制</text>
                            <input 
                                class="setting-input" 
                                type="number" 
                                v-model="item.max_participants"
                                placeholder="0表示不限制"
                                @input="onItemSettingChange(index, 'max_participants', $event)"
                            />
                        </view>
                        
                        <!-- 比赛轮次设置 -->
                        <view class="setting-item">
                            <text class="setting-label">比赛轮次</text>
                            <input 
                                class="setting-input" 
                                type="number" 
                                v-model="item.rounds"
                                placeholder="比赛轮次数量"
                                @input="onItemSettingChange(index, 'rounds', $event)"
                            />
                        </view>
                        
                        <!-- 是否允许重复报名 -->
                        <view class="setting-item">
                            <text class="setting-label">允许重复报名</text>
                            <switch 
                                :checked="item.allow_duplicate_registration" 
                                @change="onItemSwitchChange(index, 'allow_duplicate_registration', $event)"
                            />
                        </view>
                        
                        <!-- 项目说明 -->
                        <view class="setting-item">
                            <text class="setting-label">项目说明</text>
                            <textarea 
                                class="setting-textarea" 
                                v-model="item.remark"
                                placeholder="请输入项目说明..."
                                maxlength="200"
                                @input="onItemSettingChange(index, 'remark', $event)"
                            />
                            <text class="textarea-count">{{ item.remark.length }}/200</text>
                        </view>
                    </view>
                </view>
            </view>
            
            <view v-else class="empty-items">
                <text class="empty-text">暂无比赛项目</text>
                <text class="empty-tip">请先添加比赛项目</text>
            </view>
        </view>
        
        <!-- 赛事级别设置 -->
        <view class="event-settings">
            <view class="section-title">
                <text class="title-text">赛事设置</text>
            </view>
            
            <view class="settings-form">
                <!-- 报名时间设置 -->
                <view class="form-item">
                    <text class="item-label">报名开始时间</text>
                    <picker 
                        mode="date" 
                        :value="eventSettings.registration_start_time" 
                        @change="onRegistrationStartChange"
                    >
                        <view class="picker-value">
                            {{ eventSettings.registration_start_time || '请选择' }}
                            <text class="picker-arrow">></text>
                        </view>
                    </picker>
                </view>
                
                <view class="form-item">
                    <text class="item-label">报名结束时间</text>
                    <picker 
                        mode="date" 
                        :value="eventSettings.registration_end_time" 
                        @change="onRegistrationEndChange"
                    >
                        <view class="picker-value">
                            {{ eventSettings.registration_end_time || '请选择' }}
                            <text class="picker-arrow">></text>
                        </view>
                    </picker>
                </view>
                
                <!-- 显示设置 -->
                <view class="form-item">
                    <text class="item-label">显示年龄组</text>
                    <switch 
                        :checked="eventSettings.age_group_display" 
                        @change="onAgeGroupDisplayChange"
                    />
                </view>
                
                <view class="form-item">
                    <text class="item-label">显示报名人数</text>
                    <switch 
                        :checked="eventSettings.show_participant_count" 
                        @change="onShowParticipantCountChange"
                    />
                </view>
                
                <view class="form-item">
                    <text class="item-label">显示比赛进度</text>
                    <switch 
                        :checked="eventSettings.show_progress" 
                        @change="onShowProgressChange"
                    />
                </view>
            </view>
        </view>
        
        <!-- 底部按钮 -->
        <view class="bottom-actions">
            <button class="action-btn cancel-btn" @tap="goBack">
                <text class="btn-text">取消</text>
            </button>
            <button class="action-btn save-btn" @tap="saveAllSettings" :loading="saving">
                <text class="btn-text">{{ saving ? '保存中...' : '保存设置' }}</text>
            </button>
        </view>
    </view>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useLoginCheck } from '@/addon/sport/hooks/useLoginCheck'
import { getEventInfo, getEventItems, updateEventSettings, updateItemSettings } from '@/addon/sport/api/event'

// 使用登录检查
const { requireLogin } = useLoginCheck()

// 响应式数据
const eventInfo = ref<any>(null)
const eventItems = ref<any[]>([])
const eventId = ref(0)
const saving = ref(false)

// 赛事级别设置
const eventSettings = ref({
    registration_start_time: '',
    registration_end_time: '',
    age_group_display: false,
    show_participant_count: true,
    show_progress: true
})

/**
 * 格式化日期时间
 */
const formatDateTime = (timestamp: number | string) => {
    if (!timestamp) return '--'
    const date = new Date(Number(timestamp) * 1000)
    const year = date.getFullYear()
    const month = String(date.getMonth() + 1).padStart(2, '0')
    const day = String(date.getDate()).padStart(2, '0')
    return `${year}-${month}-${day}`
}

/**
 * 项目设置变更
 */
const onItemSettingChange = (index: number, field: string, event: any) => {
    const value = event.detail?.value || event.target?.value || event
    eventItems.value[index][field] = value
    eventItems.value[index].is_configured = true
}

/**
 * 项目开关变更
 */
const onItemSwitchChange = (index: number, field: string, event: any) => {
    eventItems.value[index][field] = event.detail.value
    eventItems.value[index].is_configured = true
}

/**
 * 报名开始时间选择
 */
const onRegistrationStartChange = (e: any) => {
    eventSettings.value.registration_start_time = e.detail.value
}

/**
 * 报名结束时间选择
 */
const onRegistrationEndChange = (e: any) => {
    eventSettings.value.registration_end_time = e.detail.value
}

/**
 * 年龄组显示开关
 */
const onAgeGroupDisplayChange = (e: any) => {
    eventSettings.value.age_group_display = e.detail.value
}

/**
 * 显示报名人数开关
 */
const onShowParticipantCountChange = (e: any) => {
    eventSettings.value.show_participant_count = e.detail.value
}

/**
 * 显示进度开关
 */
const onShowProgressChange = (e: any) => {
    eventSettings.value.show_progress = e.detail.value
}

/**
 * 加载赛事信息
 */
const loadEventInfo = async () => {
    if (!eventId.value) return
    
    try {
        const response: any = await getEventInfo(eventId.value)
        eventInfo.value = response.data
        
        // 填充赛事设置
        eventSettings.value = {
            registration_start_time: eventInfo.value.registration_start_time || '',
            registration_end_time: eventInfo.value.registration_end_time || '',
            age_group_display: eventInfo.value.age_group_display || false,
            show_participant_count: eventInfo.value.show_participant_count !== false,
            show_progress: eventInfo.value.show_progress !== false
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
 * 加载赛事项目列表
 */
const loadEventItems = async () => {
    if (!eventId.value) return
    
    try {
        const response: any = await getEventItems(eventId.value)
        const items = response.data || []
        
        // 为每个项目添加默认设置
        eventItems.value = items.map((item: any) => ({
            ...item,
            registration_fee: item.registration_fee || 0,
            max_participants: item.max_participants || 0,
            rounds: item.rounds || 0,
            allow_duplicate_registration: item.allow_duplicate_registration || false,
            remark: item.remark || '',
            is_configured: !!(item.registration_fee || item.max_participants || item.rounds || item.remark)
        }))
        
        console.log('赛事项目列表:', eventItems.value)
    } catch (error) {
        console.error('加载赛事项目失败:', error)
        eventItems.value = []
    }
}

/**
 * 保存所有设置
 */
const saveAllSettings = async () => {
    requireLogin(async () => {
        try {
            saving.value = true
            
            // 保存赛事级别设置
            await updateEventSettings({
                event_id: eventId.value,
                ...eventSettings.value
            })
            
            // 保存项目级别设置
            for (const item of eventItems.value) {
                await updateItemSettings({
                    item_id: item.id,
                    registration_fee: item.registration_fee,
                    max_participants: item.max_participants,
                    rounds: item.rounds,
                    allow_duplicate_registration: item.allow_duplicate_registration,
                    remark: item.remark
                })
            }
            
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
        loadEventItems()
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

.event-info-card {
    background-color: white;
    margin: 0 32rpx 20rpx;
    border-radius: 16rpx;
    padding: 32rpx;
    
    .event-name {
        font-size: 32rpx;
        font-weight: bold;
        color: #333;
        margin-bottom: 12rpx;
    }
    
    .event-time {
        font-size: 28rpx;
        color: #666;
    }
}

.items-settings {
    background-color: white;
    margin: 0 32rpx 20rpx;
    border-radius: 16rpx;
    padding: 32rpx;
    
    .section-title {
        margin-bottom: 32rpx;
        padding-bottom: 20rpx;
        border-bottom: 1rpx solid #f0f0f0;
        display: flex;
        align-items: center;
        
        .title-text {
            font-size: 32rpx;
            font-weight: bold;
            color: #333;
        }
        
        .title-count {
            font-size: 24rpx;
            color: #999;
            margin-left: 16rpx;
            font-weight: normal;
        }
    }
    
    .items-list {
        .item-card {
            background-color: #f8f9fa;
            border-radius: 12rpx;
            padding: 24rpx;
            margin-bottom: 20rpx;
            border: 1rpx solid #e9ecef;
            
            &:last-child {
                margin-bottom: 0;
            }
            
            .item-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 24rpx;
                
                .item-info {
                    flex: 1;
                    
                    .item-name {
                        display: block;
                        font-size: 30rpx;
                        font-weight: bold;
                        color: #333;
                        margin-bottom: 8rpx;
                    }
                    
                    .item-category {
                        font-size: 24rpx;
                        color: #007aff;
                        background-color: #e3f2fd;
                        padding: 4rpx 12rpx;
                        border-radius: 12rpx;
                    }
                }
                
                .item-status {
                    font-size: 24rpx;
                    padding: 8rpx 16rpx;
                    border-radius: 20rpx;
                    
                    &.status-configured {
                        background-color: #e7f5e7;
                        color: #52c41a;
                    }
                    
                    &.status-pending {
                        background-color: #fff1f0;
                        color: #ff4d4f;
                    }
                }
            }
            
            .item-settings {
                .setting-item {
                    display: flex;
                    align-items: center;
                    margin-bottom: 24rpx;
                    
                    &:last-child {
                        margin-bottom: 0;
                    }
                    
                    .setting-label {
                        width: 160rpx;
                        font-size: 28rpx;
                        color: #333;
                        flex-shrink: 0;
                    }
                    
                    .setting-input {
                        flex: 1;
                        height: 80rpx;
                        padding: 0 24rpx;
                        border: 1rpx solid #e0e0e0;
                        border-radius: 8rpx;
                        font-size: 28rpx;
                        color: #333;
                        background-color: white;
                        
                        &:focus {
                            border-color: #007aff;
                        }
                    }
                    
                    .setting-textarea {
                        flex: 1;
                        min-height: 120rpx;
                        padding: 20rpx;
                        border: 1rpx solid #e0e0e0;
                        border-radius: 8rpx;
                        font-size: 28rpx;
                        color: #333;
                        background-color: white;
                        line-height: 1.5;
                        position: relative;
                        
                        &:focus {
                            border-color: #007aff;
                        }
                    }
                    
                    .textarea-count {
                        position: absolute;
                        right: 20rpx;
                        bottom: 20rpx;
                        font-size: 24rpx;
                        color: #999;
                    }
                }
            }
        }
    }
    
    .empty-items {
        text-align: center;
        padding: 60rpx 0;
        
        .empty-text {
            display: block;
            font-size: 28rpx;
            color: #999;
            margin-bottom: 16rpx;
        }
        
        .empty-tip {
            display: block;
            font-size: 24rpx;
            color: #ccc;
        }
    }
}

.event-settings {
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
    
    .settings-form {
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
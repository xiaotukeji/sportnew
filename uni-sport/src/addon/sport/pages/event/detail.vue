<template>
    <view class="container">
        <!-- 加载状态 -->
        <view v-if="loading" class="loading-container">
            <text>加载中...</text>
        </view>
        
        <!-- 赛事详情 -->
        <view v-else-if="eventInfo" class="event-detail">
            <!-- 页面标题 -->
            <view class="page-header">
                <text class="page-title">赛事详情</text>
            </view>
            
            <!-- 赛事基本信息 -->
            <view class="detail-card">
                <view class="card-title">
                    <text class="title-text">基本信息</text>
                </view>
                
                <view class="detail-item">
                    <text class="label">赛事名称</text>
                    <text class="value">{{ eventInfo.name }}</text>
                </view>
                
                <view class="detail-item">
                    <text class="label">赛事类型</text>
                    <text class="value">{{ eventInfo.event_type === 1 ? '独立赛事' : '系列赛事' }}</text>
                </view>
                
                <view v-if="eventInfo.event_type === 2 && eventInfo.series_name" class="detail-item">
                    <text class="label">系列赛</text>
                    <text class="value">{{ eventInfo.series_name }}</text>
                </view>
                
                <view class="detail-item">
                    <text class="label">举办年份</text>
                    <text class="value">{{ eventInfo.year }}年</text>
                </view>
                
                <view v-if="eventInfo.season" class="detail-item">
                    <text class="label">赛季</text>
                    <text class="value">{{ eventInfo.season }}</text>
                </view>
            </view>
            
            <!-- 时间地点信息 -->
            <view class="detail-card">
                <view class="card-title">
                    <text class="title-text">时间地点</text>
                </view>
                
                <view class="detail-item">
                    <text class="label">开始时间</text>
                    <text class="value">{{ formatDateTime(eventInfo.start_time) }}</text>
                </view>
                
                <view class="detail-item">
                    <text class="label">结束时间</text>
                    <text class="value">{{ formatDateTime(eventInfo.end_time) }}</text>
                </view>
                
                <view class="detail-item">
                    <text class="label">举办地点</text>
                    <text class="value">{{ eventInfo.location || eventInfo.full_address }}</text>
                </view>
                
                <view v-if="eventInfo.address_detail" class="detail-item">
                    <text class="label">详细地址</text>
                    <text class="value">{{ eventInfo.address_detail }}</text>
                </view>
            </view>
            
            <!-- 主办方信息 -->
            <view class="detail-card">
                <view class="card-title">
                    <text class="title-text">主办方信息</text>
                </view>
                
                <view class="detail-item">
                    <text class="label">主办方</text>
                    <text class="value">{{ eventInfo.organizer_name }}</text>
                </view>
                
                <view v-if="eventInfo.contact_name" class="detail-item">
                    <text class="label">联系人</text>
                    <text class="value">{{ eventInfo.contact_name }}</text>
                </view>
                
                <view v-if="eventInfo.contact_phone" class="detail-item">
                    <text class="label">联系电话</text>
                    <text class="value">{{ eventInfo.contact_phone }}</text>
                </view>
            </view>
            
            <!-- 其他信息 -->
            <view v-if="eventInfo.remark" class="detail-card">
                <view class="card-title">
                    <text class="title-text">备注说明</text>
                </view>
                
                <view class="detail-item">
                    <text class="remark-text">{{ eventInfo.remark }}</text>
                </view>
            </view>
            
            <!-- 比赛项目 -->
            <view class="detail-card">
                <view class="card-title">
                    <text class="title-text">比赛项目</text>
                    <text class="item-count">({{ eventItems.length }}个)</text>
                </view>
                
                <view v-if="eventItems.length > 0" class="items-container">
                    <view 
                        v-for="(item, index) in eventItems" 
                        :key="item.id" 
                        class="item-card"
                    >
                        <view class="item-header">
                            <text class="item-name">{{ item.name }}</text>
                            <text class="item-category">{{ item.category_name }}</text>
                        </view>
                        
                        <view class="item-details">
                            <view class="item-detail-row">
                                <text class="detail-label">比赛类型：</text>
                                <text class="detail-value">{{ getCompetitionTypeText(item.competition_type) }}</text>
                            </view>
                            
                            <view class="item-detail-row">
                                <text class="detail-label">性别要求：</text>
                                <text class="detail-value">{{ getGenderTypeText(item.gender_type) }}</text>
                            </view>
                            
                            <view v-if="item.remark" class="item-detail-row">
                                <text class="detail-label">项目说明：</text>
                                <text class="detail-value">{{ item.remark }}</text>
                            </view>
                        </view>
                    </view>
                </view>
                
                <view v-else class="empty-items">
                    <text class="empty-text">暂无比赛项目</text>
                    <text class="empty-tip">请点击"下一步"添加比赛项目</text>
                </view>
            </view>
            
            <!-- 赛事状态 -->
            <view class="detail-card">
                <view class="card-title">
                    <text class="title-text">赛事状态</text>
                </view>
                
                <view class="detail-item">
                    <text class="label">当前状态</text>
                    <text class="value status" :class="'status-' + eventInfo.status">
                        {{ eventInfo.status === 1 ? '启用' : '禁用' }}
                    </text>
                </view>
                
                <view class="detail-item">
                    <text class="label">创建时间</text>
                    <text class="value">{{ formatDateTime(eventInfo.create_time) }}</text>
                </view>
            </view>
        </view>
        
        <!-- 错误状态 -->
        <view v-else class="error-container">
            <text class="error-text">加载失败，请重试</text>
            <button class="retry-btn" @tap="loadEventDetail">重新加载</button>
        </view>
        
        <!-- 底部按钮 -->
        <view class="bottom-actions">
            <button class="action-btn edit-btn" @tap="editEvent">
                <text class="btn-text">编辑比赛</text>
            </button>
            <button class="action-btn next-btn" @tap="nextStep">
                <text class="btn-text">下一步</text>
            </button>
        </view>
    </view>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useLoginCheck } from '@/addon/sport/hooks/useLoginCheck'
import { getEventInfo, getEventItems } from '@/addon/sport/api/event'

// 使用登录检查
const { requireLogin } = useLoginCheck()

// 响应式数据
const loading = ref(true)
const eventInfo = ref<any>(null)
const eventItems = ref<any[]>([])
const eventId = ref(0)

/**
 * 格式化日期时间
 */
const formatDateTime = (timestamp: number | string) => {
    if (!timestamp) return '--'
    const date = new Date(Number(timestamp) * 1000)
    const year = date.getFullYear()
    const month = String(date.getMonth() + 1).padStart(2, '0')
    const day = String(date.getDate()).padStart(2, '0')
    const hours = String(date.getHours()).padStart(2, '0')
    const minutes = String(date.getMinutes()).padStart(2, '0')
    return `${year}-${month}-${day} ${hours}:${minutes}`
}

/**
 * 获取比赛类型文本
 */
const getCompetitionTypeText = (type: number) => {
    const typeMap: Record<number, string> = {
        1: '个人项目',
        2: '团体项目'
    }
    return typeMap[type] || '未知'
}

/**
 * 获取性别要求文本
 */
const getGenderTypeText = (type: number) => {
    const typeMap: Record<number, string> = {
        1: '男子项目',
        2: '女子项目',
        3: '混合/不限'
    }
    return typeMap[type] || '未知'
}

/**
 * 加载赛事项目列表
 */
const loadEventItems = async () => {
    if (!eventId.value) return
    
    try {
        const response: any = await getEventItems(eventId.value)
        eventItems.value = response.data || []
        console.log('赛事项目列表:', eventItems.value)
    } catch (error) {
        console.error('加载赛事项目失败:', error)
        eventItems.value = []
    }
}

/**
 * 加载赛事详情
 */
const loadEventDetail = async () => {
    if (!eventId.value) {
        uni.showToast({
            title: '参数错误',
            icon: 'none'
        })
        return
    }
    
    try {
        loading.value = true
        const response: any = await getEventInfo(eventId.value)
        eventInfo.value = response.data
        console.log('赛事详情:', eventInfo.value)
        
        // 加载赛事项目列表
        await loadEventItems()
    } catch (error) {
        console.error('加载赛事详情失败:', error)
        uni.showToast({
            title: '加载失败',
            icon: 'none'
        })
    } finally {
        loading.value = false
    }
}

/**
 * 编辑比赛
 */
const editEvent = () => {
    requireLogin(() => {
        uni.navigateTo({
            url: `/addon/sport/pages/event/create?id=${eventId.value}&mode=edit`
        })
    })
}

/**
 * 下一步 - 进入比赛项目选择
 */
const nextStep = () => {
    requireLogin(() => {
        uni.navigateTo({
            url: `/addon/sport/pages/event/items?event_id=${eventId.value}`
        })
    })
}

/**
 * 页面加载
 */
onMounted(() => {
    // 获取页面参数
    const pages = getCurrentPages()
    const currentPage = pages[pages.length - 1] as any
    const options = currentPage.options || {}
    
    if (options.id) {
        eventId.value = parseInt(options.id)
        loadEventDetail()
    } else {
        loading.value = false
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

.loading-container,
.error-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 60vh;
    
    .error-text {
        font-size: 28rpx;
        color: #999;
        margin-bottom: 40rpx;
    }
    
    .retry-btn {
        padding: 20rpx 40rpx;
        background-color: #007aff;
        color: white;
        border-radius: 10rpx;
        border: none;
        font-size: 28rpx;
    }
}

.page-header {
    background-color: white;
    padding: 40rpx 32rpx;
    margin-bottom: 20rpx;
    
    .page-title {
        font-size: 36rpx;
        font-weight: bold;
        color: #333;
    }
}

.detail-card {
    background-color: white;
    margin: 0 32rpx 20rpx;
    border-radius: 16rpx;
    padding: 32rpx;
    
    .card-title {
        margin-bottom: 32rpx;
        padding-bottom: 20rpx;
        border-bottom: 1rpx solid #f0f0f0;
        
        .title-text {
            font-size: 32rpx;
            font-weight: bold;
            color: #333;
        }
    }
    
    .detail-item {
        display: flex;
        margin-bottom: 24rpx;
        align-items: flex-start;
        
        &:last-child {
            margin-bottom: 0;
        }
        
        .label {
            width: 160rpx;
            font-size: 28rpx;
            color: #666;
            flex-shrink: 0;
        }
        
        .value {
            flex: 1;
            font-size: 28rpx;
            color: #333;
            word-break: break-all;
            
            &.status {
                display: inline-block;
                padding: 8rpx 16rpx;
                border-radius: 8rpx;
                font-size: 24rpx;
                
                &.status-1 {
                    background-color: #e7f5e7;
                    color: #52c41a;
                }
                
                &.status-0 {
                    background-color: #fff1f0;
                    color: #ff4d4f;
                }
            }
        }
        
        .remark-text {
            font-size: 28rpx;
            color: #333;
            line-height: 1.6;
            word-break: break-all;
        }
    }
    
    .item-count {
        font-size: 24rpx;
        color: #999;
        margin-left: 16rpx;
        font-weight: normal;
    }
    
    .items-container {
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
                margin-bottom: 16rpx;
                
                .item-name {
                    font-size: 30rpx;
                    font-weight: bold;
                    color: #333;
                    flex: 1;
                }
                
                .item-category {
                    font-size: 24rpx;
                    color: #007aff;
                    background-color: #e3f2fd;
                    padding: 8rpx 16rpx;
                    border-radius: 20rpx;
                }
            }
            
            .item-details {
                .item-detail-row {
                    display: flex;
                    margin-bottom: 12rpx;
                    
                    &:last-child {
                        margin-bottom: 0;
                    }
                    
                    .detail-label {
                        width: 140rpx;
                        font-size: 26rpx;
                        color: #666;
                        flex-shrink: 0;
                    }
                    
                    .detail-value {
                        flex: 1;
                        font-size: 26rpx;
                        color: #333;
                        word-break: break-all;
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
        
        &.edit-btn {
            background-color: #f8f9fa;
            border: 1rpx solid #dee2e6;
            
            .btn-text {
                color: #333;
            }
        }
        
        &.next-btn {
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
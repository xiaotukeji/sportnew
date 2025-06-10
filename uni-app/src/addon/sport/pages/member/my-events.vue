<template>
    <view class="my-events-page">
        <!-- 状态筛选标签 -->
        <view class="status-tabs">
            <view 
                v-for="tab in statusTabs" 
                :key="tab.value"
                class="tab-item"
                :class="{ 'active': currentStatus === tab.value }"
                @tap="switchStatus(tab.value)"
            >
                <text class="tab-text">{{ tab.label }}</text>
                <!-- 暂时隐藏统计数字 -->
                <!-- <view v-if="tab.count !== undefined" class="tab-badge">{{ tab.count }}</view> -->
            </view>
        </view>
        
        <!-- 加载状态 -->
        <view v-if="loading" class="loading-container">
            <text class="loading-text">加载中...</text>
        </view>
        
        <!-- 赛事列表 -->
        <view v-else-if="eventList.length > 0" class="event-list">
            <view 
                v-for="event in eventList" 
                :key="event.id"
                class="event-item"
                @tap="viewEventDetail(event.id)"
            >
                <!-- 赛事状态标签 -->
                <view class="event-status">
                    <text class="status-badge" :class="'status-' + event.status">
                        {{ getStatusText(event.status) }}
                    </text>
                </view>
                
                <!-- 赛事信息 -->
                <view class="event-info">
                    <view class="event-name">{{ event.name }}</view>
                    <view class="event-meta">
                        <view class="meta-item">
                            <text class="meta-icon">📅</text>
                            <text class="meta-text">{{ formatDateTime(event.start_time) }}</text>
                        </view>
                        <view class="meta-item">
                            <text class="meta-icon">📍</text>
                            <text class="meta-text">{{ event.location || '暂未设定' }}</text>
                        </view>
                        <view class="meta-item">
                            <text class="meta-icon">🏢</text>
                            <text class="meta-text">{{ event.organizer_name }}</text>
                        </view>
                    </view>
                    
                    <!-- 赛事类型 -->
                    <view class="event-type">
                        <text class="type-tag">{{ event.event_type === 1 ? '独立赛事' : '系列赛事' }}</text>
                        <view v-if="event.series_name" class="series-name">
                            <text>{{ event.series_name }}</text>
                        </view>
                    </view>
                </view>
                
                <!-- 操作按钮 -->
                <view class="event-actions">
                    <view class="action-btn detail-btn" @tap.stop="viewEventDetail(event.id)">
                        <text class="btn-text">查看详情</text>
                    </view>
                    <view v-if="event.status === 0" class="action-btn edit-btn" @tap.stop="editEvent(event.id)">
                        <text class="btn-text">编辑</text>
                    </view>
                    <view v-if="event.status === 0" class="action-btn publish-btn" @tap.stop="publishEvent(event.id)">
                        <text class="btn-text">发布</text>
                    </view>
                    <view v-if="event.status !== 3" class="action-btn cancel-btn" @tap.stop="cancelEvent(event.id)">
                        <text class="btn-text">作废</text>
                    </view>
                </view>
            </view>
        </view>
        
        <!-- 空状态 -->
        <view v-else class="empty-container">
            <text class="empty-icon">🏆</text>
            <text class="empty-text">{{ getEmptyText() }}</text>
            <view class="empty-action" @tap="goCreateEvent">
                <text class="action-text">创建赛事</text>
            </view>
        </view>
        
        <!-- 底部加载更多 -->
        <view v-if="hasMore && eventList.length > 0" class="load-more" @tap="loadMoreEvents">
            <text class="load-more-text">加载更多</text>
        </view>
        <view v-else-if="eventList.length > 0" class="no-more">
            <text class="no-more-text">没有更多数据了</text>
        </view>
    </view>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, nextTick } from 'vue'
import { useLoginCheck } from '@/addon/sport/hooks/useLoginCheck'
import { getEventList, updateEventStatus } from '@/addon/sport/api/event'

// 使用登录检查
const { requireLogin } = useLoginCheck()

// 响应式数据
const loading = ref(true)
const eventList = ref<any[]>([])
const currentStatus = ref('all')
const page = ref(1)
const hasMore = ref(true)

// 状态标签定义
const statusTabs = ref([
    { label: '全部赛事', value: 'all', count: undefined },
    { label: '待发布', value: '0', count: undefined },
    { label: '进行中', value: '1', count: undefined },
    { label: '已结束', value: '2', count: undefined },
    { label: '已作废', value: '3', count: undefined }
])

/**
 * 获取状态文本
 */
const getStatusText = (status: number) => {
    const statusMap: Record<number, string> = {
        0: '待发布',
        1: '进行中', 
        2: '已结束',
        3: '已作废'
    }
    return statusMap[status] || '未知状态'
}

/**
 * 获取空状态文本
 */
const getEmptyText = () => {
    const statusMap: Record<string, string> = {
        'all': '暂无赛事记录',
        '0': '暂无待发布赛事',
        '1': '暂无进行中赛事', 
        '2': '暂无已结束赛事',
        '3': '暂无已作废赛事'
    }
    return statusMap[currentStatus.value] || '暂无赛事记录'
}

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
 * 切换状态筛选
 */
const switchStatus = (status: string) => {
    if (currentStatus.value === status) return
    
    currentStatus.value = status
    page.value = 1
    hasMore.value = true
    eventList.value = []
    
    loadEventList()
}

/**
 * 加载赛事列表
 */
const loadEventList = async (isLoadMore = false) => {
    try {
        if (!isLoadMore) {
            loading.value = true
        }
        
        const params = {
            page: page.value,
            limit: 10,
            status: currentStatus.value === 'all' ? '' : currentStatus.value
        }
        
        const response: any = await getEventList(params)
        console.log('原始API响应:', response)
        
        // 适配后端分页数据结构
        const newList = response.data?.data || []
        
        // 调试：检查每个事件的状态值
        newList.forEach((event: any, index: number) => {
            console.log(`事件${index + 1} 状态信息:`, {
                name: event.name,
                status: event.status,
                status_type: typeof event.status,
                status_text: getStatusText(event.status)
            })
        })
        const total = response.data?.total || 0
        const currentPage = response.data?.current_page || 1
        const lastPage = response.data?.last_page || 1
        
        if (isLoadMore) {
            eventList.value = [...eventList.value, ...newList]
        } else {
            eventList.value = newList
        }
        
        // 更新状态统计
        if (response.data?.status_count) {
            updateStatusCount(response.data.status_count)
        }
        
        // 根据分页信息判断是否还有更多数据
        hasMore.value = currentPage < lastPage
        
        console.log('加载赛事列表成功:', {
            status: currentStatus.value,
            page: page.value,
            count: newList.length,
            total: eventList.value.length
        })
        
    } catch (error) {
        console.error('加载赛事列表失败:', error)
        uni.showToast({
            title: '加载失败',
            icon: 'none'
        })
    } finally {
        loading.value = false
    }
}

/**
 * 加载更多赛事
 */
const loadMoreEvents = () => {
    if (!hasMore.value) return
    
    page.value++
    loadEventList(true)
}

/**
 * 更新状态统计
 */
const updateStatusCount = (statusCount: any) => {
    statusTabs.value.forEach(tab => {
        if (tab.value === 'all') {
            tab.count = statusCount.total || 0
        } else {
            tab.count = statusCount[tab.value] || 0
        }
    })
}

/**
 * 查看赛事详情
 */
const viewEventDetail = (eventId: number) => {
    uni.navigateTo({
        url: `/addon/sport/pages/event/detail?id=${eventId}`
    })
}

/**
 * 编辑赛事
 */
const editEvent = (eventId: number) => {
    uni.navigateTo({
        url: `/addon/sport/pages/event/create?id=${eventId}&mode=edit`
    })
}

/**
 * 发布赛事
 */
const publishEvent = (eventId: number) => {
    uni.showModal({
        title: '确认发布',
        content: '确定要发布这个赛事吗？发布后将开始接受报名。',
        success: async (res) => {
            if (res.confirm) {
                try {
                    await updateEventStatus(eventId, 1)
                    uni.showToast({
                        title: '发布成功',
                        icon: 'success'
                    })
                    // 重新加载列表
                    page.value = 1
                    loadEventList()
                } catch (error) {
                    console.error('发布赛事失败:', error)
                    uni.showToast({
                        title: '发布失败',
                        icon: 'none'
                    })
                }
            }
        }
    })
}

/**
 * 作废赛事
 */
const cancelEvent = (eventId: number) => {
    uni.showModal({
        title: '确认作废',
        content: '确定要作废这个赛事吗？此操作不可撤销。',
        success: async (res) => {
            if (res.confirm) {
                try {
                    await updateEventStatus(eventId, 3)
                    uni.showToast({
                        title: '作废成功',
                        icon: 'success'
                    })
                    // 重新加载列表
                    page.value = 1
                    loadEventList()
                } catch (error) {
                    console.error('作废赛事失败:', error)
                    uni.showToast({
                        title: '作废失败',
                        icon: 'none'
                    })
                }
            }
        }
    })
}

/**
 * 跳转创建赛事
 */
const goCreateEvent = () => {
    uni.navigateTo({
        url: '/addon/sport/pages/event/create'
    })
}

/**
 * 页面初始化
 */
onMounted(() => {
    requireLogin(() => {
        loadEventList()
    }, '/addon/sport/pages/member/my-events')
})
</script>

<style lang="scss" scoped>
.my-events-page {
    min-height: 100vh;
    background-color: #f5f5f5;
}

.status-tabs {
    background-color: white;
    padding: 16rpx 32rpx;
    display: flex;
    box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.1);
    
    .tab-item {
        flex: 1;
        display: flex;
        flex-direction: column;
        align-items: center;
        padding: 16rpx 8rpx;
        position: relative;
        
        &.active {
            .tab-text {
                color: #007aff;
                font-weight: bold;
            }
            
            &::after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 50%;
                transform: translateX(-50%);
                width: 60rpx;
                height: 4rpx;
                background-color: #007aff;
                border-radius: 2rpx;
            }
        }
        
        .tab-text {
            font-size: 28rpx;
            color: #666;
            margin-bottom: 8rpx;
        }
        
        .tab-badge {
            background-color: #ff4757;
            color: white;
            font-size: 20rpx;
            padding: 4rpx 8rpx;
            border-radius: 12rpx;
            min-width: 32rpx;
            text-align: center;
            line-height: 1;
        }
    }
}

.loading-container {
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 120rpx 0;
    
    .loading-text {
        font-size: 28rpx;
        color: #999;
    }
}

.event-list {
    padding: 32rpx;
    
    .event-item {
        background-color: white;
        border-radius: 16rpx;
        padding: 32rpx;
        margin-bottom: 24rpx;
        box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.1);
        position: relative;
        
        &:active {
            opacity: 0.8;
        }
        
        .event-status {
            position: absolute;
            top: 24rpx;
            right: 24rpx;
            
            .status-badge {
                padding: 8rpx 16rpx;
                border-radius: 8rpx;
                font-size: 20rpx;
                color: white;
                
                &.status-0 {
                    background-color: #ffa726;
                }
                
                &.status-1 {
                    background-color: #66bb6a;
                }
                
                &.status-2 {
                    background-color: #42a5f5;
                }
                
                &.status-3 {
                    background-color: #ef5350;
                }
            }
        }
        
        .event-info {
            padding-right: 120rpx;
            
            .event-name {
                font-size: 32rpx;
                font-weight: bold;
                color: #333;
                margin-bottom: 16rpx;
                line-height: 1.4;
            }
            
            .event-meta {
                margin-bottom: 16rpx;
                
                .meta-item {
                    display: flex;
                    align-items: center;
                    margin-bottom: 8rpx;
                    
                    &:last-child {
                        margin-bottom: 0;
                    }
                    
                    .meta-icon {
                        font-size: 20rpx;
                        margin-right: 12rpx;
                        width: 32rpx;
                    }
                    
                    .meta-text {
                        font-size: 24rpx;
                        color: #666;
                        flex: 1;
                    }
                }
            }
            
            .event-type {
                display: flex;
                align-items: center;
                gap: 16rpx;
                
                .type-tag {
                    background-color: #e3f2fd;
                    color: #1976d2;
                    font-size: 20rpx;
                    padding: 6rpx 12rpx;
                    border-radius: 6rpx;
                }
                
                .series-name {
                    background-color: #f3e5f5;
                    color: #7b1fa2;
                    font-size: 20rpx;
                    padding: 6rpx 12rpx;
                    border-radius: 6rpx;
                }
            }
        }
        
        .event-actions {
            margin-top: 24rpx;
            display: flex;
            gap: 16rpx;
            
            .action-btn {
                padding: 12rpx 24rpx;
                border-radius: 8rpx;
                border: 1rpx solid #ddd;
                
                .btn-text {
                    font-size: 24rpx;
                }
                
                &.detail-btn {
                    background-color: #007aff;
                    border-color: #007aff;
                    
                    .btn-text {
                        color: white;
                    }
                }
                
                &.edit-btn {
                    background-color: #f8f9fa;
                    border-color: #dee2e6;
                    
                    .btn-text {
                        color: #495057;
                    }
                }
                
                &.publish-btn {
                    background-color: #28a745;
                    border-color: #28a745;
                    
                    .btn-text {
                        color: white;
                    }
                }
                
                &.cancel-btn {
                    background-color: #dc3545;
                    border-color: #dc3545;
                    
                    .btn-text {
                        color: white;
                    }
                }
                
                &:active {
                    opacity: 0.8;
                }
            }
        }
    }
}

.empty-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 120rpx 32rpx;
    
    .empty-icon {
        font-size: 120rpx;
        margin-bottom: 32rpx;
        opacity: 0.5;
    }
    
    .empty-text {
        font-size: 28rpx;
        color: #999;
        margin-bottom: 48rpx;
    }
    
    .empty-action {
        background-color: #007aff;
        padding: 24rpx 48rpx;
        border-radius: 12rpx;
        
        .action-text {
            color: white;
            font-size: 28rpx;
        }
        
        &:active {
            opacity: 0.8;
        }
    }
}

.load-more {
    padding: 32rpx;
    text-align: center;
    
    .load-more-text {
        font-size: 28rpx;
        color: #007aff;
    }
    
    &:active {
        opacity: 0.6;
    }
}

.no-more {
    padding: 32rpx;
    text-align: center;
    
    .no-more-text {
        font-size: 24rpx;
        color: #999;
    }
}
</style> 
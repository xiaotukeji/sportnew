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
                <text class="title-count">({{ groupedEventItems.length }}大类 {{ eventItems.length }}项)</text>
            </view>
            
            <view v-if="eventItems.length > 0" class="items-container">
                <view 
                    v-for="(group, groupIndex) in groupedEventItems" 
                    :key="group.categoryName" 
                    class="category-group"
                >
                    <!-- 大类标题 -->
                    <view class="category-header" :style="{ background: getCategoryColor(group.categoryName) }">
                        <view class="category-info">
                            <text class="category-name">{{ group.categoryName }}</text>
                            <text class="category-count">({{ group.items.length }}项)</text>
                        </view>
                        <view class="category-batch" v-if="group.items.length > 1">
                    <text class="batch-label">批量设置</text>
                    <switch 
                                :checked="getCategoryBatchMode(group.categoryName)" 
                                @change="onCategoryBatchModeChange(group.categoryName, $event)"
                    />
                </view>
            </view>
            
            <!-- 批量设置提示 -->
                    <view v-if="getCategoryBatchMode(group.categoryName) && group.items.length > 1" class="batch-tip">
                        <text class="tip-text">💡 已开启批量设置：修改第一个项目的设置将自动应用到该分类下的其他项目</text>
            </view>
            
                    <!-- 该大类下的项目列表 -->
                    <view class="group-items">
                <view 
                            v-for="(item, index) in group.items" 
                    :key="item.id" 
                    class="item-card"
                            :class="{ 'batch-item': getCategoryBatchMode(group.categoryName) && index > 0 }"
                            :style="{ borderLeftColor: getCategoryBorderColor(group.categoryName) }"
                >
                    <view class="item-header">
                        <view class="item-info">
                            <text class="item-name">{{ item.name }}</text>
                            <text class="item-category">{{ item.category_name }}</text>
                        </view>
                        <view class="item-status" :class="'status-' + (item.is_configured ? 'configured' : 'pending')">
                            {{ item.is_configured ? '已配置' : '待配置' }}
                                    <text v-if="getCategoryBatchMode(group.categoryName) && index > 0" class="batch-tag">批量</text>
                        </view>
                    </view>
                    
                    <view class="item-settings">
                        <!-- 报名费设置 -->
                        <view class="setting-item">
                            <text class="setting-label">报名费（元）</text>
                            <input 
                                class="setting-input" 
                                type="digit" 
                                :value="getRegistrationFeeDisplayValue(item.registration_fee)"
                                placeholder="0表示免费"
                                        @input="onRegistrationFeeChange(getItemGlobalIndex(groupIndex, index), $event)"
                                        @focus="onRegistrationFeeFocus(getItemGlobalIndex(groupIndex, index), $event)"
                                        @blur="onRegistrationFeeBlur(getItemGlobalIndex(groupIndex, index), $event)"
                            />
                        </view>
                        
                        <!-- 人数限制设置 -->
                        <view class="setting-item">
                            <text class="setting-label">人数限制</text>
                            <input 
                                class="setting-input" 
                                type="number" 
                                :value="getMaxParticipantsDisplayValue(item.max_participants)"
                                placeholder="0表示不限制"
                                        @input="onMaxParticipantsChange(getItemGlobalIndex(groupIndex, index), $event)"
                                        @blur="onMaxParticipantsBlur(getItemGlobalIndex(groupIndex, index), $event)"
                            />
                        </view>
                        
                        <!-- 是否允许重复报名 -->
                        <view class="setting-item">
                            <text class="setting-label">允许重复\n报名</text>
                            <switch 
                                :checked="item.allow_duplicate_registration" 
                                        @change="onItemSwitchChange(getItemGlobalIndex(groupIndex, index), 'allow_duplicate_registration', $event)"
                            />
                        </view>
                        
                        <!-- 项目说明 -->
                        <view class="setting-item">
                            <text class="setting-label">项目说明</text>
                            <view class="textarea-container">
                                <textarea 
                                    class="setting-textarea" 
                                    v-model="item.remark"
                                    placeholder="请输入项目说明..."
                                    maxlength="200"
                                            @input="onRemarkChange(getItemGlobalIndex(groupIndex, index), $event)"
                                />
                                <text class="textarea-count">{{ item.remark.length }}/200</text>
                                    </view>
                                </view>
                            </view>
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
import { ref, onMounted, computed } from 'vue'
import { useLoginCheck } from '@/addon/sport/hooks/useLoginCheck'
import { getEventInfo, getEventItems, updateEventSettings, updateItemSettings } from '@/addon/sport/api/event'

// 使用登录检查
const { requireLogin } = useLoginCheck()

// 响应式数据
const eventInfo = ref<any>(null)
const eventItems = ref<any[]>([])
const eventId = ref(0)
const saving = ref(false)

// 批量设置状态，存储每个分类的批量模式
const categoryBatchModes = ref<Record<string, boolean>>({})

// 赛事级别设置
const eventSettings = ref({
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
    
    // 如果是批量模式且修改的是第一个项目，则同步到其他项目
    if (getCategoryBatchMode(eventItems.value[index].category_name || '其他') && index === 0) {
        const batchFields = ['registration_fee', 'max_participants', 'allow_duplicate_registration', 'remark']
        if (batchFields.includes(field)) {
            for (let i = 1; i < eventItems.value.length; i++) {
                eventItems.value[i][field] = value
                eventItems.value[i].is_configured = true
            }
        }
    }
}

/**
 * 报名费输入处理
 */
const onRegistrationFeeChange = (index: number, event: any) => {
    let value = event.detail?.value || event.target?.value || event
    
    // 只允许非负数
    if (value < 0) {
        value = 0
    }
    
    // 转换为数字
    const numValue = parseFloat(value) || 0
    eventItems.value[index].registration_fee = numValue
    eventItems.value[index].is_configured = true
    
    // 批量模式同步 - 只在同一分类内同步，且只同步第一个项目
    const currentItem = eventItems.value[index]
    const categoryName = currentItem.category_name || '其他'
    const group = groupedEventItems.value.find(g => g.categoryName === categoryName)
    
    if (getCategoryBatchMode(categoryName) && group && group.items.length > 1) {
        // 检查是否是该分类下的第一个项目
        const isFirstItem = group.items[0].id === currentItem.id
        if (isFirstItem) {
            // 找到同一分类下的其他项目并同步设置
            for (let i = 1; i < group.items.length; i++) {
                const otherItem = group.items[i]
                const otherIndex = eventItems.value.findIndex(item => item.id === otherItem.id)
                if (otherIndex !== -1) {
                    eventItems.value[otherIndex].registration_fee = numValue
                    eventItems.value[otherIndex].is_configured = true
                }
            }
        }
    }
}

/**
 * 获取报名费显示值
 */
const getRegistrationFeeDisplayValue = (value: number) => {
    return value === 0 ? '' : value.toString()
}

/**
 * 获取人数限制显示值
 */
const getMaxParticipantsDisplayValue = (value: number) => {
    return value === 0 ? '' : value.toString()
}

/**
 * 报名费获得焦点
 */
const onRegistrationFeeFocus = (index: number, event: any) => {
    // 焦点事件不需要修改数据，只是触发重新渲染
    // 通过 :value 绑定来控制显示
}

/**
 * 报名费失去焦点
 */
const onRegistrationFeeBlur = (index: number, event: any) => {
    const value = event.detail?.value || event.target?.value || event
    
    // 如果为空或无效值，设置为0
    if (!value || value === '' || isNaN(parseFloat(value))) {
        eventItems.value[index].registration_fee = 0
    }
}

/**
 * 人数限制输入处理
 */
const onMaxParticipantsChange = (index: number, event: any) => {
    let value = event.detail?.value || event.target?.value || event
    
    // 只允许非负整数
    if (value < 0) {
        value = 0
    }
    
    // 转换为整数
    const intValue = parseInt(value) || 0
    eventItems.value[index].max_participants = intValue
    eventItems.value[index].is_configured = true
    
    // 批量模式同步 - 只在同一分类内同步，且只同步第一个项目
    const currentItem = eventItems.value[index]
    const categoryName = currentItem.category_name || '其他'
    const group = groupedEventItems.value.find(g => g.categoryName === categoryName)
    
    if (getCategoryBatchMode(categoryName) && group && group.items.length > 1) {
        // 检查是否是该分类下的第一个项目
        const isFirstItem = group.items[0].id === currentItem.id
        if (isFirstItem) {
            // 找到同一分类下的其他项目并同步设置
            for (let i = 1; i < group.items.length; i++) {
                const otherItem = group.items[i]
                const otherIndex = eventItems.value.findIndex(item => item.id === otherItem.id)
                if (otherIndex !== -1) {
                    eventItems.value[otherIndex].max_participants = intValue
                    eventItems.value[otherIndex].is_configured = true
                }
            }
        }
    }
}

/**
 * 人数限制失去焦点
 */
const onMaxParticipantsBlur = (index: number, event: any) => {
    const value = event.detail?.value || event.target?.value || event
    
    // 如果为空或无效值，设置为0
    if (!value || value === '' || isNaN(parseInt(value))) {
        eventItems.value[index].max_participants = 0
    }
}

/**
 * 项目说明变更
 */
const onRemarkChange = (index: number, event: any) => {
    const value = event.detail?.value || event.target?.value || event
    eventItems.value[index].remark = value
    eventItems.value[index].is_configured = true
    
    // 批量模式同步 - 只在同一分类内同步，且只同步第一个项目
    const currentItem = eventItems.value[index]
    const categoryName = currentItem.category_name || '其他'
    const group = groupedEventItems.value.find(g => g.categoryName === categoryName)
    
    if (getCategoryBatchMode(categoryName) && group && group.items.length > 1) {
        // 检查是否是该分类下的第一个项目
        const isFirstItem = group.items[0].id === currentItem.id
        if (isFirstItem) {
            // 找到同一分类下的其他项目并同步设置
            for (let i = 1; i < group.items.length; i++) {
                const otherItem = group.items[i]
                const otherIndex = eventItems.value.findIndex(item => item.id === otherItem.id)
                if (otherIndex !== -1) {
                    eventItems.value[otherIndex].remark = value
                    eventItems.value[otherIndex].is_configured = true
                }
            }
        }
    }
}

/**
 * 项目开关变更
 */
const onItemSwitchChange = (index: number, field: string, event: any) => {
    eventItems.value[index][field] = event.detail.value
    eventItems.value[index].is_configured = true
    
    // 批量模式同步 - 只在同一分类内同步，且只同步第一个项目
    const currentItem = eventItems.value[index]
    const categoryName = currentItem.category_name || '其他'
    const group = groupedEventItems.value.find(g => g.categoryName === categoryName)
    
    if (getCategoryBatchMode(categoryName) && group && group.items.length > 1) {
        // 检查是否是该分类下的第一个项目
        const isFirstItem = group.items[0].id === currentItem.id
        if (isFirstItem) {
            // 找到同一分类下的其他项目并同步设置
            for (let i = 1; i < group.items.length; i++) {
                const otherItem = group.items[i]
                const otherIndex = eventItems.value.findIndex(item => item.id === otherItem.id)
                if (otherIndex !== -1) {
                    eventItems.value[otherIndex][field] = event.detail.value
                    eventItems.value[otherIndex].is_configured = true
                }
            }
        }
    }
}

/**
 * 应用分类批量设置
 */
const applyCategoryBatchSettings = (categoryName: string) => {
    const group = groupedEventItems.value.find(g => g.categoryName === categoryName)
    if (!group || group.items.length <= 1) return
    
    const firstItem = group.items[0]
    const batchFields = ['registration_fee', 'max_participants', 'allow_duplicate_registration', 'remark']
    
    // 将第一个项目的设置应用到该分类下的其他项目
    for (let i = 1; i < group.items.length; i++) {
        const currentItem = group.items[i]
        // 找到该item在eventItems中的索引
        const itemIndex = eventItems.value.findIndex(item => item.id === currentItem.id)
        if (itemIndex !== -1) {
            batchFields.forEach(field => {
                eventItems.value[itemIndex][field] = firstItem[field]
            })
            eventItems.value[itemIndex].is_configured = true
        }
    }
}

/**
 * 获取项目在eventItems中的全局索引
 */
const getItemGlobalIndex = (groupIndex: number, itemIndex: number) => {
    let globalIndex = 0
    for (let i = 0; i < groupIndex; i++) {
        globalIndex += groupedEventItems.value[i].items.length
    }
    globalIndex += itemIndex
    return globalIndex
}

/**
 * 获取分类颜色
 */
const getCategoryColor = (categoryName: string) => {
    const colorMap: Record<string, string> = {
        '乒乓球': 'linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%)',
        '羽毛球': 'linear-gradient(135deg, #4834d4 0%, #686de0 100%)',
        '篮球': 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)',
        '足球': 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)',
        '网球': 'linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)',
        '排球': 'linear-gradient(135deg, #fa709a 0%, #fee140 100%)',
        '田径': 'linear-gradient(135deg, #a8edea 0%, #fed6e3 100%)',
        '游泳': 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
        '其他': 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)'
    }
    
    return colorMap[categoryName] || colorMap['其他']
}

/**
 * 获取分类边框颜色
 */
const getCategoryBorderColor = (categoryName: string) => {
    const colorMap: Record<string, string> = {
        '乒乓球': '#ff6b6b',
        '羽毛球': '#4834d4',
        '篮球': '#f093fb',
        '足球': '#4facfe',
        '网球': '#43e97b',
        '排球': '#fa709a',
        '田径': '#a8edea',
        '游泳': '#667eea',
        '其他': '#667eea'
    }
    
    return colorMap[categoryName] || colorMap['其他']
}

/**
 * 获取分组后的项目列表
 */
const groupedEventItems = computed(() => {
    const groups: Record<string, any[]> = {}
    
    eventItems.value.forEach((item: any) => {
        // 使用大类名称作为分组键
        const categoryName = item.category_name || '其他'
        if (!groups[categoryName]) {
            groups[categoryName] = []
        }
        groups[categoryName].push(item)
    })
    
    // 转换为数组格式，便于模板渲染，并按大类名称排序
    return Object.keys(groups)
        .sort()
        .map(categoryName => ({
            categoryName,
            items: groups[categoryName].sort((a: any, b: any) => a.name.localeCompare(b.name)) // 项目名称也排序
        }))
})

/**
 * 获取分类的批量设置状态
 */
const getCategoryBatchMode = (categoryName: string) => {
    return categoryBatchModes.value[categoryName] || false
}

/**
 * 分类批量模式切换
 */
const onCategoryBatchModeChange = (categoryName: string, e: any) => {
    categoryBatchModes.value[categoryName] = e.detail.value
    
    if (e.detail.value) {
        // 开启批量模式时，将该分类下第一个项目的设置应用到该分类下的其他项目
        applyCategoryBatchSettings(categoryName)
        uni.showToast({
            title: `${categoryName}批量设置已开启`,
            icon: 'success'
        })
    } else {
        uni.showToast({
            title: `${categoryName}批量设置已关闭`,
            icon: 'none'
        })
    }
}

/**
 * 加载赛事项目列表并分组
 */
const loadEventItems = async () => {
    if (!eventId.value) return
    
    try {
        const response: any = await getEventItems(eventId.value)
        const items = response.data || []
        
        // 为每个项目添加默认设置
        eventItems.value = items.map((item: any) => ({
            ...item,
            registration_fee: item.registration_fee ?? 0, // 使用 ?? 确保 0 值不被覆盖
            max_participants: item.max_participants ?? 0, // 使用 ?? 确保 0 值不被覆盖
            rounds: item.rounds ?? 0,
            allow_duplicate_registration: item.allow_duplicate_registration ?? false,
            remark: item.remark ?? '',
            is_configured: !!(item.registration_fee || item.max_participants || item.rounds || item.remark)
        }))
        
        console.log('赛事项目列表:', eventItems.value)
    } catch (error) {
        console.error('加载赛事项目失败:', error)
        eventItems.value = []
    }
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
 * 保存所有设置
 */
const saveAllSettings = async () => {
    requireLogin(async () => {
        try {
            saving.value = true
            
            // 保存赛事级别设置
            await updateEventSettings({
                event_id: eventId.value,
                age_group_display: eventSettings.value.age_group_display,
                show_participant_count: eventSettings.value.show_participant_count,
                show_progress: eventSettings.value.show_progress
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
    
    .items-container {
        .category-group {
            margin-bottom: 32rpx;
            background-color: white;
            border-radius: 16rpx;
            padding: 20rpx;
            box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.08);
            
            &:last-child {
                margin-bottom: 0;
            }
            
            .category-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 20rpx;
                padding: 20rpx 24rpx;
                border-radius: 12rpx;
                box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.15);
                
                .category-info {
                    display: flex;
                    align-items: center;
                    flex: 1;
                    
                    .category-name {
                        font-size: 34rpx;
                        font-weight: bold;
                        color: white;
                        text-shadow: 0 1rpx 2rpx rgba(0, 0, 0, 0.3);
                    }
                    
                    .category-count {
                        font-size: 24rpx;
                        color: rgba(255, 255, 255, 0.9);
                        background-color: rgba(255, 255, 255, 0.25);
                        padding: 8rpx 16rpx;
                        border-radius: 20rpx;
                        font-weight: 500;
                        backdrop-filter: blur(10rpx);
                        margin-left: 16rpx;
                    }
                }
                
                .category-batch {
            display: flex;
            align-items: center;
            
            .batch-label {
                        font-size: 24rpx;
                        color: rgba(255, 255, 255, 0.9);
                margin-right: 16rpx;
                        font-weight: 500;
                    }
            }
        }
        
        .batch-tip {
                margin: 16rpx 0;
            padding: 16rpx 20rpx;
                background-color: rgba(255, 255, 255, 0.9);
                border: 1rpx solid rgba(255, 255, 255, 0.3);
            border-radius: 8rpx;
                backdrop-filter: blur(10rpx);
            
            .tip-text {
                    font-size: 24rpx;
                    color: #333;
                line-height: 1.4;
        }
    }
    
            .group-items {
        .item-card {
            background-color: #f8f9fa;
            border-radius: 12rpx;
                    padding: 20rpx;
                    margin-bottom: 16rpx;
            border: 1rpx solid #e9ecef;
                    border-left: 4rpx solid;
                    transition: all 0.3s ease;
                    
                    &:hover {
                        transform: translateY(-2rpx);
                        box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.12);
                    }
            
            &:last-child {
                margin-bottom: 0;
            }
            
            &.batch-item {
                border-left: 4rpx solid #007aff;
                background-color: #f0f8ff;
                        position: relative;
                        
                        &::before {
                            content: '';
                            position: absolute;
                            top: 0;
                            left: 0;
                            right: 0;
                            height: 2rpx;
                            background: linear-gradient(90deg, #007aff, #00d4ff);
                        }
                
                .item-header {
                    .item-status {
                        color: #007aff;
                    }
                }
            }
            
            .item-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                        margin-bottom: 20rpx;
                
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
                    display: flex;
                    align-items: center;
                    
                    &.status-configured {
                        background-color: #e7f5e7;
                        color: #52c41a;
                    }
                    
                    &.status-pending {
                        background-color: #fff1f0;
                        color: #ff4d4f;
                    }
                    
                    .batch-tag {
                        margin-left: 8rpx;
                        font-size: 20rpx;
                        padding: 2rpx 6rpx;
                        background-color: #007aff;
                        color: white;
                        border-radius: 8rpx;
                    }
                }
            }
            
            .item-settings {
                .setting-item {
                    display: flex;
                    align-items: center;
                            margin-bottom: 20rpx;
                    
                    &:last-child {
                        margin-bottom: 0;
                    }
                    
                    .setting-label {
                        width: 160rpx;
                        font-size: 28rpx;
                        color: #333;
                        flex-shrink: 0;
                        white-space: pre-line; /* 支持换行 */
                        line-height: 1.4;
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
                        z-index: 1; /* 设置较低的z-index */
                        
                        &:focus {
                            border-color: #007aff;
                            z-index: 10; /* 聚焦时稍微提升，但不超过按钮 */
                        }
                    }
                    
                    .textarea-container {
                        flex: 1;
                        position: relative;
                    }
                    
                    .setting-textarea {
                        width: 100%;
                        min-height: 120rpx;
                        padding: 20rpx;
                        padding-bottom: 60rpx; /* 为字数统计留出空间 */
                        border: 1rpx solid #e0e0e0;
                        border-radius: 8rpx;
                        font-size: 28rpx;
                        color: #333;
                        background-color: white;
                        line-height: 1.5;
                        box-sizing: border-box;
                        z-index: 1; /* 设置较低的z-index */
                        
                        &:focus {
                            border-color: #007aff;
                            z-index: 10; /* 聚焦时稍微提升，但不超过按钮 */
                        }
                    }
                    
                    .textarea-count {
                        position: absolute;
                        right: 20rpx;
                        bottom: 20rpx;
                        font-size: 24rpx;
                        color: #999;
                        pointer-events: none; /* 防止点击字数统计影响textarea */
                            }
                        }
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
                z-index: 1; /* 设置较低的z-index */
                
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
    z-index: 1000; /* 确保按钮在最上层 */
    
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
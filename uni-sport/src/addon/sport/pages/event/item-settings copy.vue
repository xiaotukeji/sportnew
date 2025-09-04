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
                        <view class="category-sync" v-if="group.items.length > 1">
                            <button class="sync-btn" @tap="onSyncSettings(group.categoryName)">
                                <text class="sync-text">同步设置</text>
                            </button>
                        </view>
            </view>
            

            
                    <!-- 该大类下的项目列表 -->
                    <view class="group-items">
                <view 
                            v-for="(item, index) in group.items" 
                    :key="item.id" 
                    class="item-card"
                            :style="{ borderLeftColor: getCategoryBorderColor(group.categoryName) }"
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
                                :value="getRegistrationFeeDisplayValue(item.registration_fee)"
                                placeholder="0表示免费"
                                        :data-index="getItemGlobalIndex(groupIndex, index)"
                                        @input="onRegistrationFeeInput"
                                        @focus="onRegistrationFeeFocusEvt"
                                        @blur="onRegistrationFeeBlurEvt"
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
                                        :data-index="getItemGlobalIndex(groupIndex, index)"
                                        @input="onMaxParticipantsInput"
                                        @blur="onMaxParticipantsBlurEvt"
                            />
                        </view>
                        
                        <!-- 是否允许重复报名 -->
                        <view class="setting-item">
                            <text class="setting-label">允许重复\n报名</text>
                            <switch 
                                :checked="item.allow_duplicate_registration" 
                                :data-id="item.id"
                                data-field="allow_duplicate_registration"
                                @change="onItemSwitchChangeEvt"
                            />
                        </view>

                        <!-- 是否循环赛（小组） -->
                        <view class="setting-item">
                            <text class="setting-label">循环赛\n(小组)</text>
                            <switch
                                :checked="item.is_round_robin"
                                :data-id="item.id"
                                data-field="is_round_robin"
                                @change="onItemSwitchChangeEvt"
                            />
                        </view>

                        <!-- 每组人数（0表示不分组） -->
                        <view class="setting-item">
                            <text class="setting-label">每组人数</text>
                            <input 
                                class="setting-input" 
                                type="number" 
                                v-model.number="item.group_size"
                                placeholder="0表示不分组"
                                @blur="item.group_size = Math.max(0, parseInt(item.group_size || 0) || 0)"
                            />
                            <text class="input-tip">0 表示不分组</text>
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
                                ></textarea>
                                <text class="textarea-count">{{ item.remark.length }}/200</text>
                                    </view>
                                </view>
                            
                            <!-- 场地设备管理 -->
                            <view class="venue-management">
                                <view class="venue-header">
                                    <text class="venue-title">场地设备管理</text>
                                    <button class="add-venue-btn" @tap="showVenueModal(item.id, group.categoryName)">
                                        <text class="btn-text">{{ hasVenues ? '管理场地' : '添加场地' }}</text>
                                    </button>
                                </view>
                                
                                
                                <!-- 场地选择（直接展示可用场地，支持多选与全选） -->
                                <view class="venue-selection">
                                    <text class="selection-label">选择场地：</text>
                                    <view class="venue-selector-list">
                                        <view class="select-all" v-if="getAvailableVenuesForItem(item.id).length > 0">
                                            <view class="select-row" :class="{ selected: isAllVenuesSelected(item.id) }" @tap.stop="toggleSelectAllVenues(item.id)">
                                                <text class="select-text">{{ isAllVenuesSelected(item.id) ? '取消全选' : '全选' }}</text>
                                                <!-- 全选状态显示勾选标记 -->
                                                <view v-if="isAllVenuesSelected(item.id)" class="selected-mark">
                                                    <text class="mark-text">✓</text>
                                                </view>
                                            </view>
                                        </view>
                                        <view class="venue-options">
                                            <view
                                                v-for="venue in getAvailableVenuesForItem(item.id)"
                                                :key="venue.id"
                                                class="venue-option"
                                                :class="{ selected: isVenueSelectedForItem(item.id, venue.id) }"
                                                @tap="toggleVenueSelection(item.id, venue.id)"
                                            >
                                                <text class="option-text">{{ venue.name }}</text>
                                                <text class="venue-code">({{ venue.venue_code }})</text>
                                                <!-- 已选中的场地显示勾选标记 -->
                                                <view v-if="isVenueSelectedForItem(item.id, venue.id)" class="selected-mark">
                                                    <text class="mark-text">✓</text>
                                                </view>
                                            </view>
                                        </view>
                                        <view v-if="getAvailableVenuesForItem(item.id).length === 0" class="empty-venues">
                                            <text class="empty-text">暂无可用场地</text>
                                        </view>
                                    </view>
                                </view>
                                
                                <!-- 快速分配按钮（已移除，改为直接勾选） -->
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
                <text class="btn-text">返回</text>
            </button>
            <button class="action-btn save-btn" @tap="saveAllSettings" :loading="saving">
                <text class="btn-text">{{ saving ? '保存中...' : '保存设置' }}</text>
            </button>
        </view>
        
        <!-- 场地管理弹窗（底部全宽抽屉样式） -->
        <view v-if="showVenueDialog" class="venue-dialog-overlay" @tap="closeVenueDialog">
            <view class="venue-dialog bottom-full" @tap.stop>
                <view class="dialog-header">
                    <text class="dialog-title">场地管理</text>
                    <button class="close-btn" @tap="closeVenueDialog">
                        <text class="close-text">×</text>
                    </button>
                </view>
                
                <view class="dialog-content">
                    <!-- 添加新场地 -->
                    <view class="add-venue-section">
                        <text class="section-title">添加新场地</text>
                        
                        <view class="form-item">
                            <text class="form-label">场地类型：</text>
                            <picker 
                                :value="newVenueTypeIndex" 
                                :range="venueTypeOptions" 
                                range-key="label"
                                @change="onNewVenueTypeChange"
                            >
                                <view class="picker-value">
                                    <text>{{ getVenueTypeLabel(newVenue.venue_type) || '请选择场地类型' }}</text>
                                    <text class="picker-arrow">></text>
                                </view>
                            </picker>
                        </view>
                        
                        <!-- 添加模式切换 -->
                <view class="form-item">
                    <text class="form-label">添加模式：</text>
                    <view class="mode-switch buttons row">
                        <view class="mode-btn left" :class="{ active: !batchMode }" @tap="batchMode = false">单个添加</view>
                        <view class="mode-btn right" :class="{ active: batchMode }" @tap="batchMode = true">批量添加</view>
                    </view>
                </view>
                        
                        <!-- 单个添加模式 -->
                        <view v-if="!batchMode">
                            <view class="form-item">
                                <text class="form-label">场地名称：</text>
                                <input 
                                    class="form-input" 
                                    v-model="newVenue.name"
                                    placeholder="如：乒乓球台1、羽毛球场地A"
                                />
                            </view>
                        </view>
                        
                        <!-- 批量添加模式 -->
                        <view v-if="batchMode">
                            <view class="form-item">
                                <text class="form-label">名称前缀：</text>
                                <input 
                                    class="form-input" 
                                    v-model="batchVenue.namePrefix"
                                    placeholder="如：乒乓球台"
                                />
                            </view>
                            
                            <!-- 编码前缀：已自动根据类型生成，不再手动输入 -->
                            
                            <view class="form-item">
                                <text class="form-label">起始编号：</text>
                                <input 
                                    class="form-input" 
                                    type="number" 
                                    v-model="batchVenue.startNumber"
                                    placeholder="1"
                                />
                            </view>
                            
                            <view class="form-item">
                                <text class="form-label">结束编号：</text>
                                <input 
                                    class="form-input" 
                                    type="number" 
                                    v-model="batchVenue.endNumber"
                                    placeholder="10"
                                />
                            </view>
                        </view>
                        
                        <view class="form-item">
                            <text class="form-label">场地位置：</text>
                            <input 
                                class="form-input" 
                                v-model="newVenue.location"
                                placeholder="如：体育馆一楼"
                            />
                        </view>
                        
                        <button class="add-btn" @tap="addNewVenue">
                            <text class="add-text">{{ batchMode ? '批量添加场地' : '添加场地' }}</text>
                        </button>
                    </view>
                    
                    <!-- 现有场地列表 -->
                    <view class="existing-venues-section">
                        <text class="section-title">现有场地</text>
                        <view v-if="Array.isArray(venues) && venues.length > 0" class="venue-list">
                            <view 
                                v-for="venue in venues" 
                                :key="venue.id" 
                                class="venue-item"
                            >
                                <view class="venue-info">
                                    <text class="venue-name">{{ venue.name }}</text>
                                    <text class="venue-code">({{ venue.venue_code }})</text>
                                    <text class="venue-location">{{ venue.location }}</text>
                                </view>
                                <view class="venue-actions">
                                    <button class="action-btn edit-btn" @tap="editVenue(venue)">
                                        <text class="action-text">编辑</text>
                                    </button>
                                    <button class="action-btn delete-btn" @tap="deleteVenue(venue.id)">
                                        <text class="action-text">删除</text>
                                    </button>
                                </view>
                            </view>
                        </view>
                        <view v-else class="empty-venues">
                            <text class="empty-text">暂无场地，请先添加</text>
                        </view>
                    </view>
                </view>
                <!-- 底部关闭按钮 -->
                <view style="padding: 16rpx">
                    <button class="add-btn" @tap="closeVenueDialog"><text class="add-text">关闭</text></button>
                </view>
            </view>
        </view>
    </view>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useLoginCheck } from '@/addon/sport/hooks/useLoginCheck'
import { getEventInfo, getEventItems, updateEventSettings, updateItemSettings } from '@/addon/sport/api/event'
import { getEventVenues, addEventVenue, editEventVenue, deleteEventVenue, batchAddVenues as apiBatchAddVenues, getItemVenues as apiGetItemVenues, assignVenueToItem, removeVenueFromItem as apiRemoveVenueFromItem, batchAssignVenuesToItem, getAvailableVenuesForItem as apiGetAvailableVenuesForItem } from '@/addon/sport/api/venue'

// 使用登录检查
const { requireLogin } = useLoginCheck()

// 响应式数据
const eventInfo = ref<any>(null)
const eventItems = ref<any[]>([])
const eventId = ref(0)
const saving = ref(false)



// 赛事级别设置
const eventSettings = ref({
    age_group_display: false,
    show_participant_count: true,
    show_progress: true
})

// 场馆设备管理相关数据
const venues = ref<any[]>([])
const itemVenueAssignments = ref<Record<number, any[]>>({})

// 场地类型选项
const venueTypeOptions = ref([
    { value: 'pingpong_table', label: '乒乓球台' },
    { value: 'badminton_court', label: '羽毛球场地' },
    { value: 'basketball_court', label: '篮球场' },
    { value: 'football_field', label: '足球场' },
    { value: 'tennis_court', label: '网球场' },
    { value: 'volleyball_court', label: '排球场' },
    { value: 'track', label: '田径跑道' },
    { value: 'swimming_pool', label: '游泳池' },
    { value: 'other', label: '其他' }
])

// 场地管理弹窗相关数据
const showVenueDialog = ref(false)
const batchMode = ref(false)
const currentItemId = ref<number | null>(null)
const newVenue = ref({
    venue_type: '',
    name: '',
    venue_code: '',
    location: ''
})
const batchVenue = ref({
    namePrefix: '',
    startNumber: 1,
    endNumber: 10
})

// 计算属性
const newVenueTypeIndex = computed(() => {
    return getVenueTypeIndex(newVenue.value.venue_type)
})

// 判断是否有可用场馆
const hasVenues = computed(() => {
    return Array.isArray(venues.value) && venues.value.length > 0
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
     * 获取每组人数显示值
     */
    const getGroupSizeDisplayValue = (value: number) => {
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
 * 同步分类设置（包括场地选择）
 */
const onSyncSettings = async (categoryName: string) => {
    const group = groupedEventItems.value.find(g => g.categoryName === categoryName)
    if (!group || group.items.length <= 1) return
    
    const firstItem = group.items[0]
    const syncFields = ['registration_fee', 'max_participants', 'allow_duplicate_registration', 'is_round_robin', 'group_size', 'remark']
    
    // 同步基本设置
    for (let i = 1; i < group.items.length; i++) {
        const currentItem = group.items[i]
        const itemIndex = eventItems.value.findIndex(item => item.id === currentItem.id)
        if (itemIndex !== -1) {
            syncFields.forEach(field => {
                eventItems.value[itemIndex][field] = firstItem[field]
            })
            eventItems.value[itemIndex].is_configured = true
        }
    }
    
    // 同步场地选择
    const firstItemVenues = itemVenueAssignments.value[firstItem.id] || []
    for (let i = 1; i < group.items.length; i++) {
        const currentItem = group.items[i]
        const currentItemId = currentItem.id
        
        // 先清除当前项目的场地分配
        if (itemVenueAssignments.value[currentItemId]) {
            for (const venue of itemVenueAssignments.value[currentItemId]) {
                await apiRemoveVenueFromItem(currentItemId, venue.venue_id)
            }
        }
        
        // 复制第一个项目的场地分配
        for (const venue of firstItemVenues) {
            await assignVenueToItem(currentItemId, { venue_id: venue.venue_id, assignment_type: 1 })
        }
        
        // 重新加载场地分配
        const venues = await getItemVenues(currentItemId)
        itemVenueAssignments.value[currentItemId] = venues
    }
    
    uni.showToast({
        title: `${categoryName}设置同步完成`,
        icon: 'success'
    })
}

/**
 * 报名费 事件版本
 */
const onRegistrationFeeInput = (e: any) => {
    const idx = e?.currentTarget?.dataset?.index
    if (idx === undefined || idx === null) return
    onRegistrationFeeChange(Number(idx), e)
}
const onRegistrationFeeFocusEvt = (e: any) => {
    const idx = e?.currentTarget?.dataset?.index
    if (idx === undefined || idx === null) return
    onRegistrationFeeFocus(Number(idx), e)
}
const onRegistrationFeeBlurEvt = (e: any) => {
    const idx = e?.currentTarget?.dataset?.index
    if (idx === undefined || idx === null) return
    onRegistrationFeeBlur(Number(idx), e)
}

/**
 * 人数输入 事件版本
 */
const onMaxParticipantsInput = (e: any) => {
    const idx = e?.currentTarget?.dataset?.index
    if (idx === undefined || idx === null) return
    onMaxParticipantsChange(Number(idx), e)
}
const onMaxParticipantsBlurEvt = (e: any) => {
    const idx = e?.currentTarget?.dataset?.index
    if (idx === undefined || idx === null) return
    onMaxParticipantsBlur(Number(idx), e)
}

/**
 * 项目开关事件版本（允许重复/循环赛）
 */
const onItemSwitchChangeEvt = (e: any) => {
    const idAttr = e?.currentTarget?.dataset?.id || e?.target?.dataset?.id
    const field = e?.currentTarget?.dataset?.field || e?.target?.dataset?.field
    const itemId = typeof idAttr === 'string' ? parseInt(idAttr) : idAttr
    if (!itemId || !field) return
    onItemSwitchChange(itemId, String(field), e)
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

    /**
     * 每组人数变更（0 表示不分组）
     */
    const onGroupSizeInput = (index: number, event: any) => {
        let value = event.detail?.value || event.target?.value || event
        if (value < 0) value = 0
        const intValue = parseInt(value) || 0
        eventItems.value[index].group_size = intValue
        eventItems.value[index].is_configured = true


    }
    
    // 转换为整数
    const intValue = parseInt(value) || 0
    eventItems.value[index].max_participants = intValue
    eventItems.value[index].is_configured = true
    

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
    

}

// 备注直接使用 v-model 双向绑定，无需事件函数

/**
 * 项目开关变更
 */
const onItemSwitchChange = (itemId: number, field: string, event: any) => {
    const index = eventItems.value.findIndex(i => i.id === itemId)
    if (index === -1) return
    eventItems.value[index][field] = event.detail.value
    eventItems.value[index].is_configured = true
    

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
 * 加载赛事项目列表并分组
 */
const loadEventItems = async () => {
    if (!eventId.value) return
    
    try {
        const response: any = await getEventItems(eventId.value)
        const items = response.data || []
        
        // 为每个项目添加默认设置（并将后端返回的数字字符串规范为正确类型）
        eventItems.value = items.map((item: any) => ({
            ...item,
            registration_fee: item.registration_fee ?? 0,
            max_participants: item.max_participants ?? 0,
            rounds: item.rounds ?? 0,
            allow_duplicate_registration: (item.allow_duplicate_registration === 1 || item.allow_duplicate_registration === '1' || item.allow_duplicate_registration === true),
            is_round_robin: (item.is_round_robin === 1 || item.is_round_robin === '1' || item.is_round_robin === true),
            group_size: (Number.parseInt(item.group_size, 10) || 0),
            venue_count: (Number.parseInt(item.venue_count, 10) || 0),
            venue_type: item.venue_type ?? '',
            remark: item.remark ?? '',
            is_configured: !!(item.registration_fee || item.max_participants || item.rounds || item.remark)
        }))
        
        // 加载每个项目的已分配场地
        for (const item of eventItems.value) {
            try {
                const venues = await getItemVenues(item.id)
                itemVenueAssignments.value[item.id] = venues
            } catch (error) {
                console.error(`加载项目${item.id}的场地失败:`, error)
                itemVenueAssignments.value[item.id] = []
            }
        }
        
        console.log('赛事项目列表:', eventItems.value)
        console.log('项目场地分配:', itemVenueAssignments.value)
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
                    is_round_robin: item.is_round_robin ? 1 : 0,
                    group_size: item.group_size,
                    venue_count: item.venue_count,
                    venue_type: item.venue_type,
                    remark: item.remark
                })
            }
            
            uni.showToast({
                title: '保存成功',
                icon: 'success'
            })
            
            // 不再重新加载数据，避免覆盖已删除的场地分配
            // await loadEventItems()
            
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
        loadVenues()
        
        // 调试信息
        console.log('页面初始化完成')
        console.log('eventId:', eventId.value)
        console.log('venues初始值:', venues.value)
    } else {
        uni.showToast({
            title: '缺少赛事ID参数',
            icon: 'none'
        })
    }
})

// ==================== 场馆设备管理相关函数 ====================

/**
 * 加载赛事场地列表
 */
const loadVenues = async () => {
    if (!eventId.value) return
    
    try {
        const response: any = await getEventVenues(eventId.value)
        console.log('场地API响应:', response)
        
        // 确保返回的数据是数组
        if (response && response.data) {
            if (Array.isArray(response.data)) {
                venues.value = response.data
            } else if (response.data.list && Array.isArray(response.data.list)) {
                venues.value = response.data.list
            } else if (response.data.data && Array.isArray(response.data.data)) {
                venues.value = response.data.data
            } else {
                console.warn('场地数据格式不正确:', response.data)
                venues.value = []
            }
        } else {
            venues.value = []
        }
        
        console.log('场地列表:', venues.value)
    } catch (error) {
        console.error('加载场地列表失败:', error)
        venues.value = []
    }
}

/**
 * 获取场地类型索引
 */
const getVenueTypeIndex = (venueType: string) => {
    return venueTypeOptions.value.findIndex(option => option.value === venueType)
}

/**
 * 获取场地类型标签
 */
const getVenueTypeLabel = (venueType: string) => {
    const option = venueTypeOptions.value.find(option => option.value === venueType)
    return option ? option.label : ''
}

/**
 * 场地类型变更
 */
const onVenueTypeChange = (index: number, event: any) => {
    const venueType = venueTypeOptions.value[event.detail.value].value
    eventItems.value[index].venue_type = venueType
    eventItems.value[index].is_configured = true
    

}

/**
 * 场地数量变更
 */
const onVenueCountChange = (index: number, event: any) => {
    let value = parseInt(event.detail?.value || event.target?.value || event) || 0
    if (value < 0) value = 0
    
    eventItems.value[index].venue_count = value
    eventItems.value[index].is_configured = true
    

}

/**
 * 增加场地数量
 */
const increaseVenueCount = (index: number) => {
    const currentCount = eventItems.value[index].venue_count || 0
    onVenueCountChange(index, { detail: { value: currentCount + 1 } })
}

/**
 * 减少场地数量
 */
const decreaseVenueCount = (index: number) => {
    const currentCount = eventItems.value[index].venue_count || 0
    if (currentCount > 0) {
        onVenueCountChange(index, { detail: { value: currentCount - 1 } })
    }
}

/**
 * 获取项目已分配的场地
 */
const getItemVenues = async (itemId: number) => {
    try {
        const response: any = await apiGetItemVenues(itemId)
        return response.data || []
    } catch (error) {
        console.error('获取项目场地失败:', error)
        return []
    }
}

// 这个函数已经在下面重新定义了，这里删除重复定义

/**
 * 从项目中移除场地
 */
const removeVenueFromItem = async (itemId: number, venueId: number) => {
    try {
        console.log('删除场地分配 - 请求参数:', { itemId, venueId })
        
        const response = await apiRemoveVenueFromItem(itemId, venueId)
        console.log('删除场地分配 - 接口响应:', response)
        
        // 删除后立即从后端获取最新数据验证
        const updatedList = await getItemVenues(itemId)
        console.log('删除后重新获取的场地列表:', updatedList)
        itemVenueAssignments.value[itemId] = updatedList
        
        uni.showToast({
            title: '移除成功',
            icon: 'success'
        })
    } catch (error: any) {
        console.error('移除场地失败:', error)
        const errorMsg = error?.message || error?.msg || '删除失败'
        uni.showToast({
            title: errorMsg,
            icon: 'none'
        })
    }
}

/**
 * 批量添加场地
 */
const batchAddVenues = async (index: number) => {
    const item = eventItems.value[index]
    if (!item.venue_type || !item.venue_count) {
        uni.showToast({
            title: '请先设置场地类型和数量',
            icon: 'none'
        })
        return
    }
    
    try {
        const venueTypeLabel = getVenueTypeLabel(item.venue_type)
        const data = {
            venue_type: item.venue_type,
            venue_category: venueTypeLabel,
            count: item.venue_count,
            name_prefix: venueTypeLabel,
            code_prefix: item.venue_type.replace('_', ''),
            location: eventInfo.value?.location || '',
            capacity: 0
        }
        
        const response: any = await apiBatchAddVenues(eventId.value, data)
        
        // 重新加载场地列表
        await loadVenues()
        
        uni.showToast({
            title: `成功添加${item.venue_count}个${venueTypeLabel}`,
            icon: 'success'
        })
    } catch (error) {
        console.error('批量添加场地失败:', error)
        uni.showToast({
            title: '批量添加失败',
            icon: 'none'
        })
    }
}

// ==================== 场地管理弹窗相关函数 ====================

/**
 * 显示场地管理弹窗
 */
const showVenueModal = (itemOrIndex: number, categoryName?: string) => {
    showVenueDialog.value = true

    // 允许传入 itemId 或全局索引，两者兼容
    let item = eventItems.value.find((it: any) => it.id === itemOrIndex)
    if (!item) item = eventItems.value[itemOrIndex]
    currentItemId.value = item?.id || null

    console.log('打开弹窗的项目:', item)
    console.log('传入的categoryName参数:', categoryName)
    console.log('item.category_name:', item?.category_name)
    console.log('item.name:', item?.name)
    console.log('item.venue_type:', item?.venue_type)

    // 1) 优先使用“传入的分类 → 类型”映射（绑定分组分类，避免串类）
    let defaultType = mapCategoryToVenueType(String(categoryName || '').trim())
    console.log('由参数categoryName映射得到的类型:', defaultType)

    // 2) 若没有显式传入分类，则使用 item.category_name 映射
    if (!defaultType) {
        defaultType = mapCategoryToVenueType(String(item?.category_name || '').trim())
        console.log('由item.category_name映射得到的类型:', defaultType)
    }

    // 3) 仍无结果时，基于名称关键字兜底
    if (!defaultType) {
        const text = `${item?.category_name || ''}${item?.name || ''}`
        console.log('关键字判定text:', text)
        if (/乒乓/.test(text)) defaultType = 'pingpong_table'
        else if (/羽毛/.test(text)) defaultType = 'badminton_court'
        else if (/篮球/.test(text)) defaultType = 'basketball_court'
        else if (/足球/.test(text)) defaultType = 'football_field'
        else if (/网球/.test(text)) defaultType = 'tennis_court'
        else if (/排球/.test(text)) defaultType = 'volleyball_court'
        else if (/田径|跑/.test(text)) defaultType = 'track'
        else if (/泳/.test(text)) defaultType = 'swimming_pool'
    }

    // 4) 最后回退到 item 自身的 venue_type
    if (!defaultType) defaultType = (item?.venue_type || '')
    console.log('最终defaultType:', defaultType)

    newVenue.value = {
        venue_type: defaultType || '',
        name: '',
        venue_code: '',
        location: ''
    }
    batchVenue.value.namePrefix = getVenueTypeLabel(defaultType || '') || ''
}

/**
 * 关闭场地管理弹窗
 */
const closeVenueDialog = () => {
    showVenueDialog.value = false
}

/**
 * 新场地类型变更
 */
const onNewVenueTypeChange = (event: any) => {
    const venueType = venueTypeOptions.value[event.detail.value].value
    newVenue.value.venue_type = venueType
    
    // 自动生成场地编码
    if (!newVenue.value.venue_code) {
        const prefix = getVenueCodePrefixByType(venueType)
        newVenue.value.venue_code = `${prefix}_1`
    }
}

/**
 * 添加新场地
 */
const getVenueCodePrefixByType = (venueType: string) => {
    const typeMap: Record<string, string> = {
        'pingpong_table': 'table',
        'badminton_court': 'court',
        'basketball_court': 'court',
        'football_field': 'field',
        'tennis_court': 'court',
        'volleyball_court': 'court',
        'track': 'track',
        'swimming_pool': 'pool',
        'other': 'venue'
    }
    return typeMap[venueType] || 'venue'
}

const addNewVenue = async () => {
    if (!newVenue.value.venue_type) {
        uni.showToast({
            title: '请选择场地类型',
            icon: 'none'
        })
        return
    }
    
    try {
        if (batchMode.value) {
            // 批量添加模式
            if (!batchVenue.value.namePrefix || 
                !batchVenue.value.startNumber || !batchVenue.value.endNumber) {
                uni.showToast({
                    title: '请填写完整的批量添加信息',
                    icon: 'none'
                })
                return
            }
            
            const count = batchVenue.value.endNumber - batchVenue.value.startNumber + 1
            if (count <= 0 || count > 50) {
                uni.showToast({
                    title: '批量添加数量应在1-50之间',
                    icon: 'none'
                })
                return
            }
            
            const data = {
                venue_type: newVenue.value.venue_type,
                venue_category: getVenueTypeLabel(newVenue.value.venue_type),
                count: count,
                name_prefix: batchVenue.value.namePrefix,
                code_prefix: getVenueCodePrefixByType(newVenue.value.venue_type),
                location: newVenue.value.location,
                capacity: 0
            }
            
            await apiBatchAddVenues(eventId.value, data)
            
            uni.showToast({
                title: `成功添加${count}个场地`,
                icon: 'success'
            })
        } else {
            // 单个添加模式
            if (!newVenue.value.name || !newVenue.value.venue_code) {
                uni.showToast({
                    title: '请填写完整的场地信息',
                    icon: 'none'
                })
                return
            }
            
            // 若未填写编码，自动生成不重复编码（基于类型前缀与已有数量）
            if (!newVenue.value.venue_code) {
                const prefix = getVenueCodePrefixByType(newVenue.value.venue_type)
                let suffix = 1
                const existingCodes = (venues.value || []).map((v: any) => v.venue_code)
                let candidate = `${prefix}_${suffix}`
                while (existingCodes.includes(candidate)) {
                    suffix += 1
                    candidate = `${prefix}_${suffix}`
                }
                newVenue.value.venue_code = candidate
            }

            const data = {
                venue_type: newVenue.value.venue_type,
                venue_category: getVenueTypeLabel(newVenue.value.venue_type),
                name: newVenue.value.name,
                venue_code: newVenue.value.venue_code,
                location: newVenue.value.location,
                capacity: 0,
                is_available: 1,
                remark: ''
            }
            
            await addEventVenue(eventId.value, data)
            
            uni.showToast({
                title: '场地添加成功',
                icon: 'success'
            })
        }
        
        // 重新加载场地列表
        await loadVenues()
        
        // 重置表单
        newVenue.value = {
            venue_type: '',
            name: '',
            venue_code: '',
            location: ''
        }
        batchVenue.value = {
            namePrefix: '',
            startNumber: 1,
            endNumber: 10
        }
    } catch (error) {
        console.error('添加场地失败:', error)
        uni.showToast({
            title: '添加失败',
            icon: 'none'
        })
    }
}

/**
 * 编辑场地
 */
const editVenue = (venue: any) => {
    // TODO: 实现编辑场地功能
    uni.showToast({
        title: '编辑功能开发中',
        icon: 'none'
    })
}

/**
 * 删除场地
 */
const deleteVenue = async (venueId: number) => {
    uni.showModal({
        title: '确认删除',
        content: '确定要删除这个场地吗？',
        success: async (res) => {
            if (res.confirm) {
                try {
                    await deleteEventVenue(eventId.value, venueId)
                    
                    // 重新加载场地列表
                    await loadVenues()
                    
                    uni.showToast({
                        title: '删除成功',
                        icon: 'success'
                    })
                } catch (error) {
                    console.error('删除场地失败:', error)
                    uni.showToast({
                        title: '删除失败',
                        icon: 'none'
                    })
                }
            }
        }
    })
}

/**
 * 获取项目可用的场地列表（按类型自动过滤）
 */
const getAvailableVenuesForItem = (itemId: number) => {
    // 确保venues.value是数组
    if (!Array.isArray(venues.value)) {
        console.warn('venues.value is not an array:', venues.value)
        return []
    }

    // 确定当前项目及其目标场地类型
    const currentItem = eventItems.value.find((it: any) => it.id === itemId)
    const targetVenueType = currentItem ? (currentItem.venue_type || mapCategoryToVenueType(currentItem.category_name)) : ''

    // 共享模式：所有场地都可以选择，不再排他
    return venues.value.filter(venue => {
        if (!venue || !venue.id) return false
        // 类型匹配：若设置了目标类型，则要求 venue.venue_type === 目标类型
        if (targetVenueType && venue.venue_type && venue.venue_type !== targetVenueType) return false
        return true // 所有匹配类型的场地都可以选择
    })
}

/**
 * 根据项目大类名称映射到场地类型
 */
const mapCategoryToVenueType = (categoryName: string): string => {
    const map: Record<string, string> = {
        '乒乓球': 'pingpong_table',
        '羽毛球': 'badminton_court',
        '篮球': 'basketball_court',
        '足球': 'football_field',
        '网球': 'tennis_court',
        '排球': 'volleyball_court',
        '田径': 'track',
        '游泳': 'swimming_pool'
    }
    // 严格匹配分类名称，避免误判
    if (map[categoryName]) return map[categoryName]
    return ''
}

/**
 * 是否已选中某场地
 */
const isVenueSelectedForItem = (itemId: number, venueId: number) => {
    const selected = itemVenueAssignments.value[itemId] || []
    return selected.some(a => a.venue_id === venueId)
}

/**
 * 是否全选
 */
const isAllVenuesSelected = (itemId: number) => {
    const available = getAvailableVenuesForItem(itemId)
    if (available.length === 0) return false
    const selectedIds = new Set((itemVenueAssignments.value[itemId] || []).map(a => a.venue_id))
    return available.every(v => selectedIds.has(v.id))
}

/**
 * 切换全选/取消全选
 */
const toggleSelectAllVenues = async (itemId: number) => {
    // 对可用场地ID去重
    const available = getAvailableVenuesForItem(itemId)
    const uniqueAvailableIds = Array.from(new Set<number>(available.map(v => v.id)))
    const selectedIds = new Set<number>((itemVenueAssignments.value[itemId] || []).map(a => a.venue_id))
    try {
        if (isAllVenuesSelected(itemId)) {
            // 取消全选：移除全部已选
            for (const vid of Array.from(selectedIds)) {
                await apiRemoveVenueFromItem(itemId, vid)
            }
        } else {
            // 全选：添加未选中的
            for (const vid of uniqueAvailableIds) {
                if (!selectedIds.has(vid)) {
                    await assignVenueToItem(itemId, { venue_id: vid, assignment_type: 1 })
                    // 立即加入已选集合，防止重复提交导致唯一键冲突
                    selectedIds.add(vid)
                }
            }
        }
        const list = await getItemVenues(itemId)
        itemVenueAssignments.value[itemId] = list
    } catch (err) {
        console.error('切换全选失败:', err)
        uni.showToast({ title: '操作失败', icon: 'none' })
    }
}

/**
 * 复选框组选中变化
 */
const onVenueCheckboxGroupChange = async (itemId: number, event: any) => {
    // 对新选择的值去重并转为数字集合
    const newIds = new Set<number>((event.detail?.value || []).map((v: string) => parseInt(v)))
    const currentAssignments = itemVenueAssignments.value[itemId] || []
    const currentIds = new Set<number>(currentAssignments.map(a => a.venue_id))
    try {
        // 需要移除的
        for (const cid of Array.from(currentIds)) {
            if (!newIds.has(cid)) {
                await apiRemoveVenueFromItem(itemId, cid)
            }
        }
        // 需要新增的
        for (const nid of Array.from(newIds)) {
            if (!currentIds.has(nid)) {
                await assignVenueToItem(itemId, { venue_id: nid, assignment_type: 1 })
                currentIds.add(nid)
            }
        }
        const list = await getItemVenues(itemId)
        itemVenueAssignments.value[itemId] = list
        uni.showToast({ title: '已更新场地选择', icon: 'success' })
    } catch (error) {
        console.error('更新场地选择失败:', error)
        uni.showToast({ title: '更新失败', icon: 'none' })
    }
}

/**
 * 单个场地点击切换选中状态
 */
const toggleVenueSelection = async (itemId: number, venueId: number) => {
    const selected = itemVenueAssignments.value[itemId] || []
    const isSelected = selected.some(a => a.venue_id === venueId)
    try {
        if (isSelected) {
            await apiRemoveVenueFromItem(itemId, venueId)
        } else {
            await assignVenueToItem(itemId, { venue_id: venueId, assignment_type: 1 })
        }
        const list = await getItemVenues(itemId)
        itemVenueAssignments.value[itemId] = list
    } catch (error) {
        console.error('切换场地选中失败:', error)
        uni.showToast({ title: '操作失败', icon: 'none' })
    }
}

/**
 * 获取选中的场地索引
 */
const getSelectedVenueIndexes = (itemId: number) => {
    const availableVenues = getAvailableVenuesForItem(itemId)
    const selectedVenues = itemVenueAssignments.value[itemId] || []
    
    return selectedVenues.map(assignment => {
        const index = availableVenues.findIndex(venue => venue.id === assignment.venue_id)
        return index >= 0 ? index : 0
    })
}

/**
 * 获取选中场地的文本显示
 */
const getSelectedVenuesText = (itemId: number) => {
    const selectedVenues = itemVenueAssignments.value[itemId] || []
    if (selectedVenues.length === 0) return ''
    
    // 确保venues.value是数组
    if (!Array.isArray(venues.value)) {
        return ''
    }
    
    const venueNames = selectedVenues.map(assignment => {
        const venue = venues.value.find(v => v && v.id === assignment.venue_id)
        return venue ? venue.name : ''
    }).filter(name => name)
    
    return venueNames.join('、')
}

/**
 * 场地选择变更
 */
const onVenueSelectionChange = async (itemId: number, event: any) => {
    const availableVenues = getAvailableVenuesForItem(itemId)
    const selectedIndexes = event.detail.value
    
    try {
        // 先移除所有当前分配
        const currentAssignments = itemVenueAssignments.value[itemId] || []
        for (const assignment of currentAssignments) {
            await apiRemoveVenueFromItem(itemId, assignment.venue_id)
        }
        
        // 添加新选择的场地
        for (const index of selectedIndexes) {
            if (index >= 0 && index < availableVenues.length) {
                const venue = availableVenues[index]
                await assignVenueToItem(itemId, {
                    venue_id: venue.id,
                    assignment_type: 1
                })
            }
        }
        
        // 重新加载项目场地分配
        const venues = await getItemVenues(itemId)
        itemVenueAssignments.value[itemId] = venues
        
        uni.showToast({
            title: '场地分配成功',
            icon: 'success'
        })
    } catch (error) {
        console.error('场地分配失败:', error)
        uni.showToast({
            title: '场地分配失败',
            icon: 'none'
        })
    }
}

/**
 * 快速分配可用场地
 */
const quickAssignVenues = async (itemId: number) => {
    const availableVenues = getAvailableVenuesForItem(itemId)
    const unassignedVenues = availableVenues.filter(venue => {
        return !itemVenueAssignments.value[itemId]?.some(a => a.venue_id === venue.id)
    })
    
    if (unassignedVenues.length === 0) {
        uni.showToast({
            title: '没有可分配的场地',
            icon: 'none'
        })
        return
    }
    
    try {
        // 分配所有可用场地
        for (const venue of unassignedVenues) {
            await assignVenueToItem(itemId, {
                venue_id: venue.id,
                assignment_type: 1
            })
        }
        
        // 重新加载项目场地分配
        const venues = await getItemVenues(itemId)
        itemVenueAssignments.value[itemId] = venues
        
        uni.showToast({
            title: `成功分配${unassignedVenues.length}个场地`,
            icon: 'success'
        })
    } catch (error) {
        console.error('快速分配失败:', error)
        uni.showToast({
            title: '分配失败',
            icon: 'none'
        })
    }
}


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
                
                .category-sync {
                    display: flex;
                    align-items: center;
                    
                    .sync-btn {
                        height: 48rpx;
                        padding: 0 20rpx;
                        background: linear-gradient(135deg, #007aff, #00d4ff);
                        color: white;
                        border-radius: 8rpx;
                        border: none;
                        font-size: 24rpx;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        box-shadow: 0 2rpx 8rpx rgba(0, 122, 255, 0.3);
                        transition: all 0.2s ease;
                        position: relative;
                        
                        &:active {
                            transform: scale(0.95);
                            box-shadow: 0 1rpx 4rpx rgba(0, 122, 255, 0.5);
                        }
                        
                        &:hover {
                            box-shadow: 0 4rpx 16rpx rgba(0, 122, 255, 0.4);
                        }
                        
                        // 添加同步图标提示
                        &::before {
                            content: '🔄';
                            margin-right: 8rpx;
                            font-size: 20rpx;
                        }
                        
                        .sync-text {
                            font-size: 24rpx;
                            font-weight: bold;
                        }
                    }
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

                    .input-tip {
                        margin-left: 12rpx;
                        font-size: 24rpx;
                        color: #999;
                        flex-shrink: 0;
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
    
    .venue-management {
        margin-top: 32rpx;
        padding: 24rpx;
        background-color: #f8f9fa;
        border-radius: 12rpx;
        border: 1rpx solid #e9ecef;
        
        .venue-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24rpx;
            
            .venue-title {
                font-size: 28rpx;
                font-weight: bold;
                color: #333;
            }
            
            .add-venue-btn {
                height: 48rpx; /* 比文字略高，整体更紧凑 */
                padding: 0 20rpx; /* 去除上下内边距，改为定高 */
                background-color: #007aff;
                color: white;
                border-radius: 8rpx;
                border: none;
                font-size: 24rpx;
                display: flex;
                align-items: center; /* 垂直居中文本 */
                justify-content: center; /* 水平居中 */
                line-height: 1; /* 防止基线导致上下不居中 */
                
                .btn-text {
                    font-size: 24rpx;
                    line-height: 1;
                }
            }
        }
        
        .venue-type-selector {
            display: flex;
            align-items: center;
            margin-bottom: 20rpx;
            
            .selector-label {
                width: 140rpx;
                font-size: 26rpx;
                color: #333;
                flex-shrink: 0;
            }
            
            .picker-value {
                flex: 1;
                height: 60rpx;
                padding: 0 20rpx;
                border: 1rpx solid #e0e0e0;
                border-radius: 8rpx;
                background-color: white;
                display: flex;
                align-items: center;
                justify-content: space-between;
                font-size: 26rpx;
                color: #333;
                
                .picker-arrow {
                    color: #999;
                    font-size: 24rpx;
                }
            }
        }
        
        .venue-count-setting {
            display: flex;
            align-items: center;
            margin-bottom: 20rpx;
            
            .count-label {
                width: 140rpx;
                font-size: 26rpx;
                color: #333;
                flex-shrink: 0;
            }
            
            .count-controls {
                display: flex;
                align-items: center;
                flex: 1;
                
                .count-btn {
                    width: 60rpx;
                    height: 60rpx;
                    background-color: #f8f9fa;
                    border: 1rpx solid #e0e0e0;
                    border-radius: 8rpx;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 32rpx;
                    color: #333;
                    font-weight: bold;
                }
                
                .count-input {
                    width: 120rpx;
                    height: 60rpx;
                    margin: 0 16rpx;
                    padding: 0 20rpx;
                    border: 1rpx solid #e0e0e0;
                    border-radius: 8rpx;
                    background-color: white;
                    text-align: center;
                    font-size: 26rpx;
                    color: #333;
                }
            }
        }
        

        
        .batch-add-venue {
            .batch-btn {
                width: 100%;
                height: 60rpx;
                background-color: #28a745;
                color: white;
                border-radius: 8rpx;
                border: none;
                font-size: 26rpx;
                
                .batch-text {
                    font-size: 26rpx;
                }
            }
        }
        
        .venue-selection {
            display: flex;
            align-items: flex-start;
            margin-bottom: 20rpx;
            gap: 16rpx;

            .selection-label {
                width: 140rpx;
                font-size: 26rpx;
                color: #333;
                flex-shrink: 0;
                line-height: 48rpx;
            }

            .venue-selector-list {
                flex: 1;
                background-color: #fafafa;
                border: 1rpx solid #e0e0e0;
                border-radius: 8rpx;
                padding: 16rpx;

                .select-all {
                    margin-bottom: 8rpx;
                    .select-row {
                        display: flex;
                        align-items: center;
                        padding: 12rpx 8rpx;
                        border-radius: 6rpx;
                        background-color: #f5f7fa;
                        cursor: pointer;
                        transition: all 0.2s ease;
                        border: 1rpx solid transparent;
                        position: relative;
                        
                        &:hover {
                            background-color: #e6f3ff;
                            border-color: #007aff;
                        }
                        
                        &.selected {
                            background: linear-gradient(135deg, #e6f3ff, #f0f8ff);
                            border-color: #007aff;
                            color: #007aff;
                            font-weight: bold;
                            box-shadow: 0 2rpx 8rpx rgba(0, 122, 255, 0.15);
                        }
                        .select-text {
                            font-size: 26rpx;
                            flex: 1;
                        }
                    }
                }

                .venue-options {
                    display: flex;
                    flex-direction: column;
                    gap: 8rpx;
                }

                .venue-option {
                    display: flex;
                    align-items: center;
                    padding: 12rpx 8rpx;
                    border-radius: 6rpx;
                    transition: all 0.2s ease;
                    border: 1rpx solid transparent;
                    position: relative;
                    
                    &:hover {
                        background-color: #f5f7fa;
                        border-color: #e0e0e0;
                    }
                    
                    &.selected {
                        background: linear-gradient(135deg, #e6f3ff, #f0f8ff);
                        border-color: #007aff;
                        box-shadow: 0 2rpx 8rpx rgba(0, 122, 255, 0.15);
                        
                        .option-text { 
                            color: #007aff; 
                            font-weight: bold;
                        }
                        .venue-code { 
                            color: #007aff; 
                        }
                    }

                    .option-text {
                        font-size: 26rpx;
                        color: #333;
                        flex: 1;
                    }

                    .venue-code {
                        font-size: 22rpx;
                        color: #999;
                        margin-left: 8rpx;
                    }
                    
                    .selected-mark {
                        width: 32rpx;
                        height: 32rpx;
                        background-color: #007aff;
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        margin-left: 8rpx;
                        box-shadow: 0 2rpx 4rpx rgba(0, 122, 255, 0.3);
                        
                        .mark-text {
                            color: white;
                            font-size: 20rpx;
                            font-weight: bold;
                        }
                    }
                }

                .empty-venues {
                    text-align: center;
                    padding: 16rpx 0;

                    .empty-text {
                        color: #999;
                        font-size: 24rpx;
                    }
                }
            }
        }
        
        .quick-assign {
            margin-bottom: 20rpx;
            
            .quick-btn {
                width: 100%;
                height: 80rpx;
                border: 1rpx solid #007aff;
                border-radius: 8rpx;
                background-color: #f0f8ff;
                display: flex;
                align-items: center;
                justify-content: center;
                
                .quick-text {
                    font-size: 28rpx;
                    color: #007aff;
                }
                
                &:active {
                    background-color: #e6f3ff;
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
            
            .mode-switch.buttons {
                flex: 1;
                display: flex;
                flex-direction: row;
                align-items: center;
                flex-wrap: nowrap;
                width: 100%;
            }

            .mode-btn {
                flex: 1 1 50%;
                height: 80rpx;
                border: 1rpx solid #e0e0e0;
                border-radius: 8rpx;
                background-color: #f8f9fa;
                color: #666;
                font-size: 28rpx;
                display: flex;
                align-items: center;
                justify-content: center;
                min-width: 0;
                white-space: nowrap;
                text-align: center;
                &:not(:first-child) { margin-left: 16rpx; }
                &.active {
                    background-color: #007aff;
                    color: #fff;
                    border-color: #007aff;
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

// ==================== 场地管理弹窗样式 ====================

.venue-dialog-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 10000;
}

.venue-dialog {
    width: 100%;
    max-height: 85%;
    background-color: white;
    border-radius: 16rpx;
    overflow: hidden;
    position: fixed;
    left: 0;
    right: 0;
    bottom: 0;
    border-bottom-left-radius: 0;
    border-bottom-right-radius: 0;
    
    .dialog-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 32rpx;
        border-bottom: 1rpx solid #f0f0f0;
        
        .dialog-title {
            font-size: 32rpx;
            font-weight: bold;
            color: #333;
        }
        
        .close-btn {
            width: 60rpx;
            height: 60rpx;
            background-color: #f8f9fa;
            border-radius: 50%;
            border: none;
            display: flex;
            align-items: center;
            justify-content: center;
            
            .close-text {
                font-size: 32rpx;
                color: #666;
                font-weight: bold;
            }
        }
    }
    
    .dialog-content {
        padding: 32rpx;
        max-height: 60vh;
        overflow-y: auto;
        

        
        .add-venue-section {
            margin-bottom: 40rpx;
            padding-bottom: 32rpx;
            border-bottom: 1rpx solid #f0f0f0;
            
            .section-title {
                display: block;
                font-size: 28rpx;
                font-weight: bold;
                color: #333;
                margin-bottom: 24rpx;
            }
            
            .form-item {
                display: flex;
                align-items: center;
                margin-bottom: 20rpx;
                
                .form-label {
                    width: 140rpx;
                    font-size: 26rpx;
                    color: #333;
                    flex-shrink: 0;
                }
                
                .form-input {
                    flex: 1;
                    height: 60rpx;
                    padding: 0 20rpx;
                    border: 1rpx solid #e0e0e0;
                    border-radius: 8rpx;
                    background-color: white;
                    font-size: 26rpx;
                    color: #333;
                }
                
                .picker-value {
                    flex: 1;
                    height: 60rpx;
                    padding: 0 20rpx;
                    border: 1rpx solid #e0e0e0;
                    border-radius: 8rpx;
                    background-color: white;
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    font-size: 26rpx;
                    color: #333;
                    
                    .picker-arrow {
                        color: #999;
                        font-size: 24rpx;
                    }
                }
            }
            
            .add-btn {
                width: 100%;
                height: 64rpx; /* 与上面的模式按钮同高 */
                padding: 0; /* 去掉默认内边距，避免文字下沉 */
                background-color: #007aff;
                color: white;
                border-radius: 8rpx;
                border: none;
                font-size: 26rpx;
                margin-top: 20rpx;
                display: flex;
                align-items: center; /* 垂直居中文本 */
                justify-content: center; /* 水平居中 */
                line-height: 1; /* 防止基线导致偏移 */
                
                .add-text {
                    font-size: 26rpx;
                    line-height: 1;
                }
            }
            /* 添加模式：弹窗专属样式，强制一行显示为两个按钮 */
            .form-item {
                .mode-switch.buttons {
                    flex: 1;
                    display: flex;
                    flex-wrap: nowrap;
                }
                .mode-switch.buttons .mode-btn {
                    flex: 1 1 0;
                    height: 64rpx; /* 矮一点，与添加按钮一致 */
                    border: 1rpx solid #e0e0e0;
                    border-radius: 8rpx;
                    background-color: #f8f9fa;
                    color: #333;
                    font-size: 28rpx;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    white-space: nowrap;
                    user-select: none;
                }
                .mode-switch.buttons .mode-btn + .mode-btn { margin-left: 16rpx; }
                .mode-switch.buttons .mode-btn.active {
                    background-color: #007aff;
                    color: #fff;
                    border-color: #007aff;
                }
            }
        }
        
        .existing-venues-section {
            .section-title {
                display: block;
                font-size: 28rpx;
                font-weight: bold;
                color: #333;
                margin-bottom: 24rpx;
            }
            
            .venue-list {
                .venue-item {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 20rpx;
                    background-color: #f8f9fa;
                    border-radius: 8rpx;
                    margin-bottom: 16rpx;
                    border: 1rpx solid #e9ecef;
                    
                    .venue-info {
                        flex: 1;
                        
                        .venue-name {
                            display: block;
                            font-size: 26rpx;
                            font-weight: bold;
                            color: #333;
                            margin-bottom: 8rpx;
                        }
                        
                        .venue-code {
                            font-size: 24rpx;
                            color: #666;
                            margin-right: 16rpx;
                        }
                        
                        .venue-location {
                            font-size: 24rpx;
                            color: #999;
                        }
                    }
                    
                    .venue-actions {
                        display: flex;
                        gap: 12rpx;
                        
                        .action-btn {
                            padding: 8rpx 16rpx;
                            border-radius: 6rpx;
                            border: none;
                            font-size: 22rpx;
                            
                            &.edit-btn {
                                background-color: #007aff;
                                color: white;
                            }
                            
                            &.delete-btn {
                                background-color: #ff4757;
                                color: white;
                            }
                            
                            .action-text {
                                font-size: 22rpx;
                            }
                        }
                    }
                }
            }
            
            .empty-venues {
                text-align: center;
                padding: 60rpx 0;
                
                .empty-text {
                    font-size: 26rpx;
                    color: #999;
                }
            }
        }
    }
}
</style> 
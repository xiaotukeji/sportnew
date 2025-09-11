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
                
                <view v-if="eventInfo.season" class="detail-item">
                    <text class="label">赛季</text>
                    <text class="value">{{ eventInfo.season }}</text>
                </view>
                
                <view v-if="eventInfo.age_groups && eventInfo.age_groups.length > 0" class="detail-item">
                    <text class="label">年龄组设置</text>
                    <view class="age-groups-container">
                        <view 
                            v-for="(group, index) in eventInfo.age_groups" 
                            :key="index" 
                            class="age-group-tag"
                        >
                            <text class="age-group-text">{{ group }}</text>
                        </view>
                    </view>
                </view>
            </view>
            
            <!-- 时间地点信息 -->
            <view class="detail-card">
                <view class="card-title">
                    <text class="title-text">时间地点</text>
                </view>
                
                <view class="detail-item">
                    <text class="label">开始比赛</text>
                    <text class="value">{{ formatDateTime(eventInfo.start_time) }}</text>
                </view>
                
                <view class="detail-item">
                    <text class="label">结束比赛</text>
                    <text class="value">{{ formatDateTime(eventInfo.end_time) }}</text>
                </view>
                
                <view v-if="eventInfo.registration_start_time" class="detail-item">
                    <text class="label">开始报名</text>
                    <text class="value">{{ formatRegistrationTime(eventInfo.registration_start_time) }}</text>
                </view>
                
                <view v-if="eventInfo.registration_end_time" class="detail-item">
                    <text class="label">截至报名</text>
                    <text class="value">{{ formatRegistrationTime(eventInfo.registration_end_time) }}</text>
                </view>
                
                <view class="detail-item">
                    <text class="label">举办地点</text>
                    <text class="value">{{ eventInfo.location }}</text>
                </view>
                
                <view v-if="getAddressDetail(eventInfo)" class="detail-item">
                    <text class="label">详细地址</text>
                    <text class="value">{{ getAddressDetail(eventInfo) }}</text>
                </view>
                
                <!-- 联系方式信息 -->
                <view v-if="eventInfo.contact_name || eventInfo.contact_phone || eventInfo.contact_wechat || eventInfo.contact_email" class="detail-item">
                    <text class="label">联系方式</text>
                    <view class="contact-info-container">
                        <view v-if="eventInfo.contact_name" class="contact-item">
                            <text class="contact-label">联系人：</text>
                            <text class="contact-value">{{ eventInfo.contact_name }}</text>
                        </view>
                        <view v-if="eventInfo.contact_phone" class="contact-item">
                            <text class="contact-label">电话：</text>
                            <text class="contact-value">{{ eventInfo.contact_phone }}</text>
                        </view>
                        <view v-if="eventInfo.contact_wechat" class="contact-item">
                            <text class="contact-label">微信：</text>
                            <text class="contact-value">{{ eventInfo.contact_wechat }}</text>
                        </view>
                        <view v-if="eventInfo.contact_email" class="contact-item">
                            <text class="contact-label">邮箱：</text>
                            <text class="contact-value">{{ eventInfo.contact_email }}</text>
                        </view>
                    </view>
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
                
                <view v-if="eventInfo.organizer_contact_name" class="detail-item">
                    <text class="label">联系人</text>
                    <text class="value">{{ eventInfo.organizer_contact_name }}</text>
                </view>
                
                <view v-if="eventInfo.organizer_contact_phone" class="detail-item">
                    <text class="label">联系电话</text>
                    <text class="value">{{ eventInfo.organizer_contact_phone }}</text>
                </view>
            </view>
            
            <!-- 协办方信息 -->
            <view v-if="eventInfo.co_organizers && eventInfo.co_organizers.length > 0" class="detail-card">
                <view class="card-title">
                    <text class="title-text">协办方信息</text>
                    <text class="item-count">({{ eventInfo.co_organizers.length }}个)</text>
                </view>
                
                <view class="co-organizers-container">
                    <view 
                        v-for="(coOrg, index) in eventInfo.co_organizers" 
                        :key="index" 
                        class="co-organizer-item"
                    >
                        <view class="co-org-header">
                            <text class="co-org-name">{{ coOrg.organizer_name }}</text>
                            <view class="co-org-type-badge" :class="'type-' + coOrg.organizer_type">
                                <text class="type-text">{{ getCoOrganizerTypeText(coOrg.organizer_type) }}</text>
                            </view>
                        </view>
                        <view v-if="coOrg.contact_name" class="co-org-detail">
                            <text class="co-org-label">联系人：</text>
                            <text class="co-org-value">{{ coOrg.contact_name }}</text>
                        </view>
                        <view v-if="coOrg.contact_phone" class="co-org-detail">
                            <text class="co-org-label">联系电话：</text>
                            <text class="co-org-value">{{ coOrg.contact_phone }}</text>
                        </view>
                    </view>
                </view>
            </view>
            
            <!-- 报名参数字段 -->
            <view class="detail-card">
                <view class="card-title">
                    <text class="title-text">报名参数字段</text>
                    <text v-if="eventInfo.signup_fields && eventInfo.signup_fields.length > 0" class="item-count">
                        ({{ eventInfo.signup_fields.length }}项，必填{{ requiredFieldsCount }}项)
                    </text>
                </view>
                
                <view v-if="eventInfo.signup_fields && eventInfo.signup_fields.length > 0" class="signup-fields-container">
                    <view 
                        v-for="(field, index) in eventInfo.signup_fields" 
                        :key="field.key" 
                        class="signup-field-item"
                    >
                        <view class="field-header">
                            <view class="field-info">
                                <text class="field-index">{{ index + 1 }}</text>
                                <text class="field-name">{{ field.label }}</text>
                            </view>
                            <view :class="field.required ? 'required-badge' : 'optional-badge'">
                                <text :class="field.required ? 'required-text' : 'optional-text'">
                                    {{ field.required ? '必填' : '选填' }}
                                </text>
                            </view>
                        </view>
                        <view class="field-key">
                            <text class="key-label">字段标识：</text>
                            <text class="key-value">{{ field.key }}</text>
                        </view>
                    </view>
                </view>
                
                <view v-else class="empty-signup-fields">
                    <text class="empty-text">暂未设置报名参数字段</text>
                    <text class="empty-tip">可在编辑赛事时设置报名所需的字段</text>
                </view>
            </view>
            
            <!-- 自定义分组信息 -->
            <view v-if="eventInfo.custom_groups && eventInfo.custom_groups.length > 0" class="detail-card">
                <view class="card-title">
                    <text class="title-text">自定义分组</text>
                    <text class="item-count">({{ eventInfo.custom_groups.length }}个)</text>
                </view>
                
                <view class="custom-groups-container">
                    <view 
                        v-for="(group, index) in eventInfo.custom_groups" 
                        :key="group.id" 
                        class="custom-group-item"
                    >
                        <view class="group-header">
                            <view class="group-info">
                                <text class="group-index">{{ index + 1 }}</text>
                                <text class="group-name">{{ group.group_name }}</text>
                            </view>
                            <view class="group-status-badge" :class="'status-' + group.status">
                                <text class="status-text">{{ group.status === 1 ? '启用' : '禁用' }}</text>
                            </view>
                        </view>
                        
                        <view v-if="group.description" class="group-description">
                            <text class="description-text">{{ group.description }}</text>
                        </view>
                    </view>
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
            
            <!-- 比赛项目设置 -->
            <view class="detail-card">
                <view class="card-title">
                    <text class="title-text">比赛项目设置</text>
                    <text class="item-count">({{ groupedEventItems.length }}大类 {{ eventItems.length }}项)</text>
                </view>
                
                <view v-if="eventItems.length > 0" class="items-container">
                    <view 
                        v-for="(group, groupIndex) in groupedEventItems" 
                        :key="group.categoryName" 
                        class="category-group"
                    >
                        <!-- 大类标题 -->
                        <view class="category-header" :style="{ background: getCategoryColor(group.categoryName) }">
                            <text class="category-name">{{ group.categoryName }}</text>
                            <text class="category-count">({{ group.items.length }}项)</text>
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
                                    <text class="item-name">{{ item.name }}</text>
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
                                    
                                    <!-- 项目设置信息 -->
                                    <view v-if="item.registration_fee > 0" class="item-detail-row">
                                        <text class="detail-label">报名费用：</text>
                                        <text class="detail-value fee">¥{{ item.registration_fee }}</text>
                                    </view>
                                    
                                    <view v-if="item.max_participants > 0" class="item-detail-row">
                                        <text class="detail-label">最大参赛人数：</text>
                                        <text class="detail-value">{{ item.max_participants }}人</text>
                                    </view>
                                    
                                    <view v-if="item.rounds > 0" class="item-detail-row">
                                        <text class="detail-label">比赛轮次：</text>
                                        <text class="detail-value">{{ item.rounds }}轮</text>
                                    </view>
                                    
                                    <view v-if="item.group_size > 0" class="item-detail-row">
                                        <text class="detail-label">分组大小：</text>
                                        <text class="detail-value">{{ item.group_size }}人/组</text>
                                    </view>
                                    
                                    <view class="item-detail-row">
                                        <text class="detail-label">允许重复报名：</text>
                                        <text class="detail-value">{{ item.allow_duplicate_registration ? '是' : '否' }}</text>
                                    </view>
                                    
                                    <view class="item-detail-row">
                                        <text class="detail-label">循环赛制：</text>
                                        <text class="detail-value">{{ item.is_round_robin ? '是' : '否' }}</text>
                                    </view>
                                    
                                    <view v-if="item.venue_type" class="item-detail-row">
                                        <text class="detail-label">场地类型：</text>
                                        <text class="detail-value">{{ getVenueTypeLabel(item.venue_type) }}</text>
                                    </view>
                                    
                                    <view v-if="item.venue_count > 0" class="item-detail-row">
                                        <text class="detail-label">场地数量：</text>
                                        <text class="detail-value">{{ item.venue_count }}个</text>
                                    </view>
                                    
                                    <!-- 场地分配信息 -->
                                    <view v-if="item.venues && item.venues.length > 0" class="item-detail-row">
                                        <text class="detail-label">分配场地：</text>
                                        <view class="venues-container">
                                            <view 
                                                v-for="venue in item.venues" 
                                                :key="venue.id" 
                                                class="venue-tag"
                                            >
                                                <text class="venue-text">{{ venue.name }}({{ venue.venue_code }})</text>
                                            </view>
                                        </view>
                                    </view>
                                    
                                    <view v-if="item.remark" class="item-detail-row">
                                        <text class="detail-label">项目说明：</text>
                                        <text class="detail-value">{{ item.remark }}</text>
                                    </view>
                                </view>
                            </view>
                        </view>
                    </view>
                </view>
                
                <view v-else class="empty-items">
                    <text class="empty-text">暂无比赛项目</text>
                    <text class="empty-tip">请点击"下一步"添加比赛项目</text>
                </view>
            </view>
            
            <!-- 比赛场地安排 -->
            <view v-if="hasVenueArrangements" class="detail-card">
                <view class="card-title">
                    <text class="title-text">比赛场地安排</text>
                </view>
                
                <view class="venue-arrangements-container">
                    <view 
                        v-for="(group, groupIndex) in groupedEventItems" 
                        :key="group.categoryName" 
                        class="venue-category-group"
                    >
                        <view class="venue-category-header">
                            <text class="venue-category-name">{{ group.categoryName }}</text>
                            <text class="venue-category-count">({{ getCategoryVenueCount(group.items) }}个场地)</text>
                        </view>
                        
                        <view class="venue-items-list">
                            <view 
                                v-for="item in group.items.filter(i => i.venues && i.venues.length > 0)" 
                                :key="item.id" 
                                class="venue-item-card"
                            >
                                <view class="venue-item-header">
                                    <text class="venue-item-name">{{ item.name }}</text>
                                    <text class="venue-item-type">{{ getVenueTypeLabel(item.venue_type) }}</text>
                                </view>
                                
                                <view class="venue-assignments">
                                    <view 
                                        v-for="venue in item.venues" 
                                        :key="venue.id" 
                                        class="venue-assignment"
                                    >
                                        <view class="venue-info">
                                            <text class="venue-name">{{ venue.name }}</text>
                                            <text class="venue-code">({{ venue.venue_code }})</text>
                                        </view>
                                        <view v-if="venue.location" class="venue-location">
                                            <text class="location-text">{{ venue.location }}</text>
                                        </view>
                                    </view>
                                </view>
                            </view>
                        </view>
                    </view>
                </view>
            </view>
            
            <!-- 显示设置 -->
            <view class="detail-card">
                <view class="card-title">
                    <text class="title-text">显示设置</text>
                </view>
                
                <view class="detail-item">
                    <text class="label">显示报名人数</text>
                    <text class="value">{{ eventInfo.show_participant_count ? '是' : '否' }}</text>
                </view>
                
                <view class="detail-item">
                    <text class="label">显示比赛进度</text>
                    <text class="value">{{ eventInfo.show_progress ? '是' : '否' }}</text>
                </view>
                
                <view class="detail-item">
                    <text class="label">显示年龄组</text>
                    <text class="value">{{ eventInfo.age_group_display ? '是' : '否' }}</text>
                </view>
            </view>
            
            <!-- 号码牌设置 -->
            <view v-if="eventInfo.number_plate_settings" class="detail-card">
                <view class="card-title">
                    <text class="title-text">号码牌设置</text>
                </view>
                
                <view class="detail-item">
                    <text class="label">编号模式</text>
                    <text class="value">{{ eventInfo.number_plate_settings.numbering_mode === 1 ? '系统分配' : '用户自选' }}</text>
                </view>
                
                <view class="detail-item">
                    <text class="label">自动编号</text>
                    <text class="value">{{ getAutoAssignText(eventInfo.number_plate_settings.auto_assign_after_registration, eventInfo.number_plate_settings.numbering_mode) }}</text>
                </view>
                
                <view v-if="eventInfo.number_plate_settings.prefix" class="detail-item">
                    <text class="label">号码前缀</text>
                    <text class="value">{{ eventInfo.number_plate_settings.prefix }}</text>
                </view>
                
                <view class="detail-item">
                    <text class="label">数字位数</text>
                    <text class="value">{{ eventInfo.number_plate_settings.number_length }}位</text>
                </view>
                
                <view class="detail-item">
                    <text class="label">起始号码</text>
                    <text class="value">{{ eventInfo.number_plate_settings.start_number }}</text>
                </view>
                
                <view class="detail-item">
                    <text class="label">结束号码</text>
                    <text class="value">{{ eventInfo.number_plate_settings.end_number }}</text>
                </view>
                
                <view class="detail-item">
                    <text class="label">是否禁用4</text>
                    <text class="value">{{ eventInfo.number_plate_settings.disable_number_4 ? '是' : '否' }}</text>
                </view>
                
                <view v-if="eventInfo.number_plate_settings.numbering_mode === 2" class="detail-item">
                    <text class="label">自选时间窗口</text>
                    <text class="value">{{ eventInfo.number_plate_settings.choice_time_window }}天</text>
                </view>
                
                <view v-if="eventInfo.number_plate_settings.reserved_numbers && eventInfo.number_plate_settings.reserved_numbers.length > 0" class="detail-item">
                    <text class="label">保留号码</text>
                    <view class="numbers-container">
                        <view 
                            v-for="number in eventInfo.number_plate_settings.reserved_numbers" 
                            :key="number" 
                            class="number-tag reserved"
                        >
                            <text class="number-text">{{ number }}</text>
                        </view>
                    </view>
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
                        {{ getStatusText(eventInfo.status) }}
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
                <text class="btn-text">项目设置</text>
            </button>
        </view>
    </view>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useLoginCheck } from '@/addon/sport/hooks/useLoginCheck'
import { getEventInfo, getEventItems, getEventDetailInfo } from '@/addon/sport/api/event'

// 使用登录检查
const { requireLogin } = useLoginCheck()

// 响应式数据
const loading = ref(true)
const eventInfo = ref<any>(null)
const eventItems = ref<any[]>([])
const eventId = ref(0)

// 按大类分组的比赛项目
const groupedEventItems = computed(() => {
    const groups: Record<string, any[]> = {}
    
    eventItems.value.forEach(item => {
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
            items: groups[categoryName].sort((a, b) => a.name.localeCompare(b.name)) // 项目名称也排序
        }))
})

// 必填字段数量
const requiredFieldsCount = computed(() => {
    if (!eventInfo.value?.signup_fields) return 0
    return eventInfo.value.signup_fields.filter((field: any) => field.required).length
})

// 获取大类颜色
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

// 获取大类边框颜色
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

// 获取状态文本
const getStatusText = (status: number) => {
    const statusMap: Record<number, string> = {
        0: '待发布',
        1: '进行中', 
        2: '已结束',
        3: '已作废'
    }
    return statusMap[status] || '未知状态'
}

// 获取详细地址
const getAddressDetail = (eventInfo: any) => {
    if (!eventInfo) {
        return ''
    }
    
    // 优先使用address_detail字段
    if (eventInfo.address_detail) {
        return eventInfo.address_detail
    }
    
    // 如果没有address_detail字段，尝试从location_detail中分离
    if (eventInfo.location_detail) {
        const locationDetail = eventInfo.location_detail
        const location = eventInfo.location || ''
        
        // 如果location_detail包含location，则分离出详细地址
        if (location && locationDetail.startsWith(location)) {
            return locationDetail.substring(location.length).trim()
        } else {
            // 如果location_detail不包含location，则整个作为详细地址
            return locationDetail
        }
    }
    
    return ''
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
 * 格式化报名时间
 */
const formatRegistrationTime = (timeString: string) => {
    if (!timeString) return '--'
    // 报名时间格式为 YYYY-MM-DD HH:mm
    return timeString
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
 * 获取协办方类型文本
 */
const getCoOrganizerTypeText = (type: number) => {
    const typeMap: Record<number, string> = {
        1: '协办单位',
        2: '赞助商',
        3: '支持单位',
        11: '赞助商',  // 兼容旧数据
        12: '赞助商',  // 兼容旧数据
        13: '赞助商'   // 兼容旧数据
    }
    return typeMap[type] || '未知'
}



/**
 * 检查是否有场地安排
 */
const hasVenueArrangements = computed(() => {
    if (!eventItems.value || eventItems.value.length === 0) return false
    return eventItems.value.some(item => item.venues && item.venues.length > 0)
})

/**
 * 获取分类下的场地数量
 */
const getCategoryVenueCount = (items: any[]) => {
    let totalCount = 0
    items.forEach(item => {
        if (item.venues && item.venues.length > 0) {
            totalCount += item.venues.length
        }
    })
    return totalCount
}

/**
 * 获取场地类型标签
 */
const getVenueTypeLabel = (venueType: string) => {
    const typeMap: Record<string, string> = {
        'PP': '乒乓球台',
        'BD': '羽毛球场地',
        'BB': '篮球场地',
        'FB': '足球场地',
        'TN': '网球场地',
        'VB': '排球场地',
        'SW': '游泳场地',
        'AT': '田径场地',
        'GYM': '健身房',
        'OTHER': '其他'
    }
    return typeMap[venueType] || venueType
}

/**
 * 获取自动编号显示文本
 */
const getAutoAssignText = (autoAssign: number, numberingMode: number) => {
    if (numberingMode === 1) {
        // 系统分配模式
        return autoAssign ? '是（系统统一编号）' : '否（手动分配）'
    } else {
        // 用户自选模式
        return autoAssign ? '是（报名后自动分配）' : '否（用户自选号码）'
    }
}

/**
 * 加载赛事项目列表（从详情接口获取，包含场地分配信息）
 */
const loadEventItems = async () => {
    if (!eventId.value) return
    
    try {
        // 使用详情接口获取项目列表，包含场地分配信息
        const response: any = await getEventDetailInfo(eventId.value)
        eventItems.value = response.data?.event_items || []
        console.log('赛事项目列表（含场地）:', eventItems.value)
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
        // 使用新的详情页API，包含协办方和号码牌设置
        const response: any = await getEventDetailInfo(eventId.value)
        eventInfo.value = response.data
        console.log('赛事详情（完整）:', eventInfo.value)
        
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
            url: `/addon/sport/pages/event/create_simple?id=${eventId.value}&mode=edit`
        })
    })
}

/**
 * 下一步 - 进入项目详细设置
 */
const nextStep = () => {
    requireLogin(() => {
        uni.navigateTo({
            url: `/addon/sport/pages/event/item-settings?event_id=${eventId.value}`
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
        }
        
        // 联系方式信息样式
        .contact-info-container {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 12rpx;
        }
        
        .contact-item {
            display: flex;
            align-items: center;
            font-size: 28rpx;
            
            .contact-label {
                color: #666;
                margin-right: 8rpx;
                min-width: 80rpx;
            }
            
            .contact-value {
                color: #333;
                font-weight: 500;
            }
            
            &.status {
                display: inline-block;
                padding: 8rpx 16rpx;
                border-radius: 8rpx;
                font-size: 24rpx;
                
                &.status-0 {
                    background-color: #fff7e6;
                    color: #fa8c16;
                }
                
                &.status-1 {
                    background-color: #e7f5e7;
                    color: #52c41a;
                }
                
                &.status-2 {
                    background-color: #f6ffed;
                    color: #389e0d;
                }
                
                &.status-3 {
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
    
    .age-groups-container {
        display: flex;
        flex-wrap: wrap;
        gap: 8rpx;
        margin-top: 8rpx;
    }
    
    .age-group-tag {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        padding: 6rpx 12rpx;
        border-radius: 16rpx;
        
        .age-group-text {
            font-size: 22rpx;
            color: white;
            font-weight: 500;
        }
    }
    
    .co-organizers-container {
        display: flex;
        flex-direction: column;
        gap: 16rpx;
    }
    
    .co-organizer-item {
        background-color: #f8f9fa;
        border-radius: 12rpx;
        padding: 20rpx;
        border: 1rpx solid #e9ecef;
        
        .co-org-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 12rpx;
            
            .co-org-name {
                font-size: 28rpx;
                font-weight: bold;
                color: #333;
                flex: 1;
            }
            
            .co-org-type-badge {
                padding: 6rpx 12rpx;
                border-radius: 20rpx;
                margin-left: 16rpx;
                
                &.type-1 {
                    background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
                }
                
                &.type-2 {
                    background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
                }
                
                &.type-3 {
                    background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
                }
                
                // 兼容旧数据的赞助商类型
                &.type-11,
                &.type-12,
                &.type-13 {
                    background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
                }
                
                .type-text {
                    font-size: 20rpx;
                    color: white;
                    font-weight: bold;
                }
            }
        }
        
        .co-org-type-desc {
            margin-bottom: 12rpx;
            
            .type-desc-text {
                font-size: 22rpx;
                color: #888;
                font-style: italic;
            }
        }
        
        .co-org-detail {
            display: flex;
            align-items: center;
            margin-bottom: 8rpx;
            
            &:last-child {
                margin-bottom: 0;
            }
            
            .co-org-label {
                font-size: 24rpx;
                color: #666;
                margin-right: 8rpx;
                width: 120rpx;
                flex-shrink: 0;
            }
            
            .co-org-value {
                font-size: 24rpx;
                color: #333;
                flex: 1;
            }
        }
    }
    
    .venues-container {
        display: flex;
        flex-wrap: wrap;
        gap: 8rpx;
        margin-top: 8rpx;
    }
    
    .venue-tag {
        background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
        padding: 6rpx 12rpx;
        border-radius: 16rpx;
        
        .venue-text {
            font-size: 22rpx;
            color: #333;
            font-weight: 500;
        }
    }
    
    .numbers-container {
        display: flex;
        flex-wrap: wrap;
        gap: 8rpx;
        margin-top: 8rpx;
    }
    
    .number-tag {
        padding: 6rpx 12rpx;
        border-radius: 16rpx;
        
        &.reserved {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
        }
        
        &.disabled {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
        }
        
        .number-text {
            font-size: 22rpx;
            color: white;
            font-weight: 500;
        }
    }
    
    .fee {
        color: #ff6b35;
        font-weight: bold;
    }
    
    .venue-arrangements-container {
        .venue-category-group {
            margin-bottom: 24rpx;
            background-color: #f8f9fa;
            border-radius: 12rpx;
            padding: 20rpx;
            border: 1rpx solid #e9ecef;
            
            &:last-child {
                margin-bottom: 0;
            }
            
            .venue-category-header {
                display: flex;
                align-items: center;
                margin-bottom: 16rpx;
                padding-bottom: 12rpx;
                border-bottom: 1rpx solid #dee2e6;
                
                .venue-category-name {
                    font-size: 28rpx;
                    font-weight: bold;
                    color: #333;
                    flex: 1;
                }
                
                .venue-category-count {
                    font-size: 22rpx;
                    color: #666;
                    background-color: #e9ecef;
                    padding: 4rpx 8rpx;
                    border-radius: 12rpx;
                }
            }
            
            .venue-items-list {
                display: flex;
                flex-direction: column;
                gap: 16rpx;
                
                .venue-item-card {
                    background-color: white;
                    border-radius: 8rpx;
                    padding: 16rpx;
                    border: 1rpx solid #e9ecef;
                    
                    .venue-item-header {
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        margin-bottom: 12rpx;
                        
                        .venue-item-name {
                            font-size: 26rpx;
                            font-weight: bold;
                            color: #333;
                            flex: 1;
                        }
                        
                        .venue-item-type {
                            font-size: 22rpx;
                            color: #666;
                            background-color: #f0f0f0;
                            padding: 4rpx 8rpx;
                            border-radius: 8rpx;
                        }
                    }
                    
                    .venue-assignments {
                        display: flex;
                        flex-direction: column;
                        gap: 8rpx;
                        
                        .venue-assignment {
                            display: flex;
                            align-items: center;
                            justify-content: space-between;
                            padding: 8rpx 12rpx;
                            background-color: #f8f9fa;
                            border-radius: 6rpx;
                            border: 1rpx solid #e9ecef;
                            
                            .venue-info {
                                display: flex;
                                align-items: center;
                                flex: 1;
                                
                                .venue-name {
                                    font-size: 24rpx;
                                    color: #333;
                                    font-weight: 500;
                                }
                                
                                .venue-code {
                                    font-size: 22rpx;
                                    color: #666;
                                    margin-left: 8rpx;
                                }
                            }
                            
                            .venue-location {
                                .location-text {
                                    font-size: 22rpx;
                                    color: #888;
                                }
                            }
                        }
                    }
                }
            }
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
                margin-bottom: 20rpx;
                padding: 20rpx 24rpx;
                border-radius: 12rpx;
                box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.15);
                
                .category-name {
                    font-size: 34rpx;
                    font-weight: bold;
                    color: white;
                    flex: 1;
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
                        margin-bottom: 12rpx;
                        
                        .item-name {
                            font-size: 30rpx;
                            font-weight: bold;
                            color: #333;
                            padding: 8rpx 0;
                        }
                    }
                    
                    .item-details {
                                                    .item-detail-row {
                                display: flex;
                                margin-bottom: 10rpx;
                                padding: 6rpx 0;
                                
                                &:last-child {
                                    margin-bottom: 0;
                                }
                                
                                .detail-label {
                                    width: 140rpx;
                                    font-size: 24rpx;
                                    color: #666;
                                    flex-shrink: 0;
                                    font-weight: 500;
                                }
                                
                                .detail-value {
                                    flex: 1;
                                    font-size: 24rpx;
                                    color: #333;
                                    word-break: break-all;
                                    font-weight: 400;
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
    
    .empty-signup-fields {
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
    
    .signup-fields-container {
        .signup-field-item {
            background-color: #f8f9fa;
            border-radius: 12rpx;
            padding: 20rpx;
            margin-bottom: 16rpx;
            border: 1rpx solid #e9ecef;
            transition: all 0.3s ease;
            
            &:hover {
                transform: translateY(-2rpx);
                box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.12);
            }
            
            &:last-child {
                margin-bottom: 0;
            }
            
            .field-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 12rpx;
                
                .field-info {
                    display: flex;
                    align-items: center;
                    flex: 1;
                    
                    .field-index {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        font-size: 20rpx;
                        font-weight: bold;
                        width: 32rpx;
                        height: 32rpx;
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        margin-right: 16rpx;
                        flex-shrink: 0;
                    }
                    
                    .field-name {
                        font-size: 30rpx;
                        font-weight: bold;
                        color: #333;
                        flex: 1;
                    }
                }
                
                .required-badge {
                    background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
                    padding: 6rpx 12rpx;
                    border-radius: 20rpx;
                    margin-left: 16rpx;
                    
                    .required-text {
                        font-size: 20rpx;
                        color: white;
                        font-weight: bold;
                    }
                }
                
                .optional-badge {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    padding: 6rpx 12rpx;
                    border-radius: 20rpx;
                    margin-left: 16rpx;
                    
                    .optional-text {
                        font-size: 20rpx;
                        color: white;
                        font-weight: bold;
                    }
                }
            }
            
            .field-key {
                display: flex;
                align-items: center;
                
                .key-label {
                    font-size: 24rpx;
                    color: #666;
                    margin-right: 8rpx;
                }
                
                .key-value {
                    font-size: 24rpx;
                    color: #999;
                    background-color: #e9ecef;
                    padding: 4rpx 8rpx;
                    border-radius: 6rpx;
                    font-family: 'Courier New', monospace;
                }
            }
        }
    }
    
    .custom-groups-container {
        display: flex;
        flex-direction: column;
        gap: 16rpx;
        
        .custom-group-item {
            background-color: #f8f9fa;
            border-radius: 12rpx;
            padding: 20rpx;
            border: 1rpx solid #e9ecef;
            transition: all 0.3s ease;
            
            &:hover {
                transform: translateY(-2rpx);
                box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.12);
            }
            
            .group-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 12rpx;
                
                .group-info {
                    display: flex;
                    align-items: center;
                    flex: 1;
                    
                    .group-index {
                        background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
                        color: white;
                        font-size: 20rpx;
                        font-weight: bold;
                        width: 32rpx;
                        height: 32rpx;
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        margin-right: 16rpx;
                        flex-shrink: 0;
                    }
                    
                    .group-name {
                        font-size: 30rpx;
                        font-weight: bold;
                        color: #333;
                        flex: 1;
                    }
                }
                
                .group-status-badge {
                    padding: 6rpx 12rpx;
                    border-radius: 20rpx;
                    margin-left: 16rpx;
                    
                    &.status-1 {
                        background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
                    }
                    
                    &.status-0 {
                        background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
                    }
                    
                    .status-text {
                        font-size: 20rpx;
                        color: white;
                        font-weight: bold;
                    }
                }
            }
            
            .group-description {
                margin-bottom: 0;
                
                .description-text {
                    font-size: 26rpx;
                    color: #666;
                    line-height: 1.5;
                    font-style: italic;
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
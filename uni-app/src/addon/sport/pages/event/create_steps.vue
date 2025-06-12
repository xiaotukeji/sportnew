<template>
    <view class="create-steps-page">
        <!-- 步骤导航 -->
        <view class="steps-header">
            <view class="steps-nav">
                <view 
                    v-for="(step, index) in steps" 
                    :key="index"
                    class="step-item"
                    :class="{ 
                        'active': currentStep === index + 1,
                        'completed': currentStep > index + 1 
                    }"
                >
                    <view class="step-number">{{ index + 1 }}</view>
                    <text class="step-title">{{ step.title }}</text>
                </view>
            </view>
        </view>

        <!-- 步骤内容 -->
        <view class="steps-content">
            <!-- 第1步：基本信息 -->
            <view v-if="currentStep === 1" class="step-content">
                <view class="form-section">
                    <!-- 是否系列赛 -->
                    <view class="form-item">
                        <view class="form-label">赛事类型</view>
                        <view class="radio-group">
                            <view 
                                v-for="item in eventTypeOptions" 
                                :key="item.value" 
                                class="radio-item"
                                @tap="handleEventTypeChange(item.value)"
                            >
                                <view class="radio-circle" :class="{ 'active': formData.event_type === item.value }">
                                    <view class="radio-dot" v-if="formData.event_type === item.value"></view>
                                </view>
                                <text class="radio-label">{{ item.label }}</text>
                            </view>
                        </view>
                    </view>
                    
                    <!-- 系列赛选择 -->
                    <view v-if="formData.event_type === 2" class="form-item">
                        <view class="form-label required">系列赛</view>
                        <input 
                            class="form-input readonly" 
                            :value="selectedSeriesName" 
                            placeholder="请选择系列赛"
                            disabled
                            @tap="openSeriesPicker"
                        />
                        <view class="form-tip">
                            <text class="tip-text" v-if="!seriesList.length">暂无系列赛，</text>
                            <text class="tip-link" @tap="showSeriesModal = true">
                                {{ seriesList.length ? '添加新系列赛' : '点击添加' }}
                            </text>
                        </view>
                    </view>
                    
                    <!-- 比赛名称 -->
                    <view class="form-item">
                        <view class="form-label required">比赛名称</view>
                        <input 
                            class="form-input" 
                            v-model="formData.name" 
                            placeholder="请输入比赛名称"
                            maxlength="100"
                        />
                    </view>
                    
                    <!-- 举办地点 - 地图选择 -->
                    <view class="form-item">
                        <view class="form-label required">选择地点</view>
                        <view class="location-container">
                            <input 
                                class="form-input readonly" 
                                :value="formData.location || ''" 
                                placeholder="点击地图选择地点"
                                disabled
                                @tap="chooseLocation"
                            />
                            <view class="location-action" @tap="chooseLocation">
                                <text class="location-icon">📍</text>
                                <text class="location-text">地图选择</text>
                            </view>
                        </view>
                    </view>
                    
                    <!-- 举办地点 - 手动输入 -->
                    <view class="form-item">
                        <view class="form-label required">详细地址</view>
                        <input 
                            class="form-input" 
                            v-model="formData.address_detail" 
                            placeholder="请输入详细地址（如：xx楼xx室）"
                            maxlength="200"
                        />
                        <view class="form-tip">
                            <text class="tip-text">先选择地图位置，再补充详细地址信息</text>
                        </view>
                    </view>
                </view>
            </view>

            <!-- 第2步：时间和分组 -->
            <view v-if="currentStep === 2" class="step-content">
                <view class="form-section">
                    <!-- 主办方 -->
                    <view class="form-item">
                        <view class="form-label required">主办方</view>
                        <input 
                            class="form-input readonly" 
                            :value="selectedOrganizerName" 
                            placeholder="请选择主办方"
                            disabled
                            @tap="openOrganizerPicker"
                        />
                        <view class="form-tip">
                            <text class="tip-text" v-if="!organizerList.length">暂无主办方，</text>
                            <text class="tip-link" @tap="showOrganizerModal = true">
                                {{ organizerList.length ? '添加新主办方' : '点击添加' }}
                            </text>
                        </view>
                    </view>
                    
                    <!-- 开始时间 -->
                    <view class="form-item">
                        <view class="form-label required">开始时间</view>
                        <view class="time-picker-container">
                            <picker
                                mode="date"
                                :value="startDateValue"
                                @change="onStartDateChange"
                            >
                                <view class="time-picker-item">
                                    <input 
                                        class="form-input readonly" 
                                        :value="startDateDisplay" 
                                        placeholder="选择日期"
                                        disabled
                                    />
                                    <text class="picker-arrow">📅</text>
                                </view>
                            </picker>
                            <picker
                                mode="time"
                                :value="startTimeValue"
                                @change="onStartTimeChange"
                            >
                                <view class="time-picker-item">
                                    <input 
                                        class="form-input readonly" 
                                        :value="startTimeDisplay" 
                                        placeholder="选择时间"
                                        disabled
                                    />
                                    <text class="picker-arrow">🕐</text>
                                </view>
                            </picker>
                        </view>
                    </view>
                    
                    <!-- 结束时间 -->
                    <view class="form-item">
                        <view class="form-label required">结束时间</view>
                        <view class="time-picker-container">
                            <picker
                                mode="date"
                                :value="endDateValue"
                                @change="onEndDateChange"
                            >
                                <view class="time-picker-item">
                                    <input 
                                        class="form-input readonly" 
                                        :value="endDateDisplay" 
                                        placeholder="选择日期"
                                        disabled
                                    />
                                    <text class="picker-arrow">📅</text>
                                </view>
                            </picker>
                            <picker
                                mode="time"
                                :value="endTimeValue"
                                @change="onEndTimeChange"
                            >
                                <view class="time-picker-item">
                                    <input 
                                        class="form-input readonly" 
                                        :value="endTimeDisplay" 
                                        placeholder="选择时间"
                                        disabled
                                    />
                                    <text class="picker-arrow">🕐</text>
                                </view>
                            </picker>
                        </view>
                    </view>
                    
                    <!-- 自定义分组 -->
                    <view class="form-item">
                        <view class="form-label">参赛分组</view>
                        <view class="groups-container">
                            <view 
                                v-for="(group, index) in formData.custom_groups" 
                                :key="index"
                                class="group-item"
                            >
                                <input 
                                    class="group-input" 
                                    v-model="group.group_name" 
                                    :placeholder="`分组${index + 1}名称`"
                                    maxlength="50"
                                />
                                <view class="group-actions">
                                    <text class="action-btn remove" @tap="removeGroup(index)">删除</text>
                                </view>
                            </view>
                            <view class="add-group-btn" @tap="addGroup">
                                <text class="add-icon">+</text>
                                <text class="add-text">添加分组</text>
                            </view>
                        </view>
                        <view class="form-tip">
                            <text class="tip-text">如：12年级组、A组、青年组等，可根据实际需要自定义分组</text>
                        </view>
                    </view>
                </view>
            </view>

            <!-- 第3步：选择项目 -->
            <view v-if="currentStep === 3" class="step-content">
                <view class="items-selection">
                    <!-- 分类标签切换 -->
                    <view class="category-tabs">
                        <scroll-view class="tabs-scroll" scroll-x show-scrollbar="false">
                            <view class="tabs-content">
                                <view 
                                    class="tab-item" 
                                    :class="{ active: activeTab === 'all' }"
                                    @tap="switchTab('all')"
                                >
                                    <text class="tab-text">全部</text>
                                </view>
                                <view 
                                    v-for="category in categories" 
                                    :key="category.id"
                                    class="tab-item" 
                                    :class="{ active: activeTab === category.id }"
                                    @tap="switchTab(category.id)"
                                >
                                    <text class="tab-text">{{ category.name.replace('运动', '') }}</text>
                                </view>
                            </view>
                        </scroll-view>
                    </view>
                    
                    <!-- 分类列表 -->
                    <view class="categories-list">
                        <view 
                            v-for="category in filteredCategories" 
                            :key="category.id"
                            class="category-section"
                        >
                            <!-- 分类标题 -->
                            <view class="category-header" @tap="toggleCategory(category.id)">
                                <view class="category-info">
                                    <text class="category-name">{{ category.name }}</text>
                                    <text class="category-count">({{ category.base_items?.length || 0 }}项)</text>
                                </view>
                                <view class="category-arrow" :class="{ expanded: expandedCategories.includes(category.id) }">
                                    <text class="arrow-icon">›</text>
                                </view>
                            </view>
                            
                            <!-- 基础项目列表 -->
                            <view 
                                v-if="expandedCategories.includes(category.id)"
                                class="base-items-grid"
                            >
                                <view 
                                    v-for="item in category.base_items" 
                                    :key="item.id"
                                    class="base-item" 
                                    :class="{ selected: selectedItems.includes(item.id) }"
                                    @tap="toggleItem(item.id)"
                                >
                                    <view class="item-content">
                                        <text class="item-name">{{ item.name }}</text>
                                        <view v-if="selectedItems.includes(item.id)" class="selected-icon">
                                            <text class="icon-check">✓</text>
                                        </view>
                                    </view>
                                </view>
                            </view>
                        </view>
                    </view>
                    
                    <!-- 已选项目统计 -->
                    <view class="selected-summary">
                        <text class="summary-text">已选择 {{ selectedItems.length }} 个项目</text>
                    </view>
                </view>
            </view>
        </view>

        <!-- 底部操作栏 -->
        <view class="bottom-actions">
            <view class="action-buttons">
                <button 
                    v-if="currentStep > 1"
                    class="btn-secondary" 
                    @tap="prevStep"
                >
                    上一步
                </button>
                <button 
                    v-if="currentStep < 3"
                    class="btn-primary" 
                    @tap="nextStep"
                    :disabled="!canProceedToNext"
                >
                    下一步
                </button>
                <button 
                    v-if="currentStep === 3"
                    class="btn-primary" 
                    @tap="handleSubmit"
                    :disabled="submitLoading || selectedItems.length === 0"
                >
                    {{ submitLoading ? '创建中...' : '创建比赛' }}
                </button>
            </view>
        </view>

        <!-- 各种弹窗和选择器 -->
        <!-- 主办方选择器 -->
        <view v-if="showOrganizerPicker" class="picker-mask" @tap="showOrganizerPicker = false">
            <view class="picker-container" @tap.stop>
                <view class="picker-header">
                    <text class="picker-cancel" @tap="showOrganizerPicker = false">取消</text>
                    <text class="picker-title">选择主办方</text>
                    <text class="picker-confirm" @tap="confirmOrganizerSelection">确定</text>
                </view>
                <picker-view class="picker-view" :value="[selectedOrganizerIndex]" @change="onOrganizerPickerChange">
                    <picker-view-column>
                        <view v-for="(item, index) in organizerPickerList" :key="index" class="picker-item">
                            {{ item.organizer_name }}
                        </view>
                    </picker-view-column>
                </picker-view>
            </view>
        </view>

        <!-- 系列赛选择器 -->
        <view v-if="showSeriesPicker" class="picker-mask" @tap="showSeriesPicker = false">
            <view class="picker-container" @tap.stop>
                <view class="picker-header">
                    <text class="picker-cancel" @tap="showSeriesPicker = false">取消</text>
                    <text class="picker-title">选择系列赛</text>
                    <text class="picker-confirm" @tap="confirmSeriesSelection">确定</text>
                </view>
                <picker-view class="picker-view" :value="[selectedSeriesIndex]" @change="onSeriesPickerChange">
                    <picker-view-column>
                        <view v-for="(item, index) in seriesPickerList" :key="index" class="picker-item">
                            {{ item.name }}
                        </view>
                    </picker-view-column>
                </picker-view>
            </view>
        </view>

        <!-- 主办方添加弹窗 -->
        <!-- 系列赛添加弹窗 -->
        <!-- 这里可以复用原来的弹窗组件 -->
    </view>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useLoginCheck } from '@/addon/sport/hooks/useLoginCheck'
import { 
    getOrganizerList, 
    getEventSeriesList,
    getEventCategories,
    addEvent
} from '@/addon/sport/api/event'

// 使用登录检查
const { requireLogin } = useLoginCheck()

// 步骤配置
const steps = [
    { title: '基本信息', key: 'basic' },
    { title: '时间分组', key: 'schedule' },
    { title: '选择项目', key: 'items' }
]

// 当前步骤
const currentStep = ref(1)

// 表单数据
const formData = ref({
    name: '',                   // 比赛名称
    location: '',              // 举办地点（地图选择的地址名称）
    lng: '',                   // 经度
    lat: '',                   // 纬度
    full_address: '',          // 完整地址
    address_detail: '',        // 地址补充
    start_time: 0,             // 开始时间
    end_time: 0,               // 结束时间
    organizer_id: 0,           // 主办方ID
    event_type: 1,             // 赛事类型：1独立赛事 2系列赛事
    series_id: 0,              // 系列赛ID
    year: new Date().getFullYear(), // 举办年份
    custom_groups: [] as any[], // 自定义分组
    items: [] as any[]         // 比赛项目
})

// 选项数据
const eventTypeOptions = [
    { label: '独立赛事', value: 1 },
    { label: '系列赛事', value: 2 }
]

// 时间相关
const startDateValue = ref('')
const startTimeValue = ref('')
const endDateValue = ref('')
const endTimeValue = ref('')

// 显示用的计算属性
const startDateDisplay = computed(() => startDateValue.value || '')
const startTimeDisplay = computed(() => startTimeValue.value || '')
const endDateDisplay = computed(() => endDateValue.value || '')
const endTimeDisplay = computed(() => endTimeValue.value || '')

// 选择器相关
const showOrganizerPicker = ref(false)
const showSeriesPicker = ref(false)
const showOrganizerModal = ref(false)
const showSeriesModal = ref(false)

// 数据列表
const organizerList = ref<any[]>([])
const seriesList = ref<any[]>([])

// 选择器数据
const organizerPickerList = computed(() => organizerList.value)
const seriesPickerList = computed(() => seriesList.value)

// 选择器临时索引
const tempOrganizerIndex = ref(0)
const tempSeriesIndex = ref(0)

// 选中的索引
const selectedOrganizerIndex = computed(() => {
    const index = organizerList.value.findIndex((item: any) => item.id === formData.value.organizer_id)
    return index >= 0 ? index : 0
})

const selectedSeriesIndex = computed(() => {
    const index = seriesList.value.findIndex((item: any) => item.id === formData.value.series_id)
    return index >= 0 ? index : 0
})

// 选中的显示名称
const selectedOrganizerName = computed(() => {
    const organizer = organizerList.value.find((item: any) => item.id === formData.value.organizer_id)
    return organizer ? organizer.organizer_name : ''
})

const selectedSeriesName = computed(() => {
    const series = seriesList.value.find((item: any) => item.id === formData.value.series_id)
    return series ? series.name : ''
})

// 项目选择相关
const categories = ref<any[]>([])
const activeTab = ref<string | number>('all')
const expandedCategories = ref<number[]>([])
const selectedItems = ref<number[]>([])

// 计算属性
const filteredCategories = computed(() => {
    if (activeTab.value === 'all') {
        return categories.value
    }
    return categories.value.filter(cat => cat.id === activeTab.value)
})

// 是否可以进入下一步
const canProceedToNext = computed(() => {
    switch (currentStep.value) {
        case 1:
            return formData.value.name && 
                   formData.value.location && 
                   formData.value.address_detail &&
                   (formData.value.event_type === 1 || formData.value.series_id > 0)
        case 2:
            return formData.value.organizer_id > 0 && 
                   formData.value.start_time > 0 && 
                   formData.value.end_time > 0
        case 3:
            return selectedItems.value.length > 0
        default:
            return false
    }
})

// 提交状态
const submitLoading = ref(false)

/**
 * 步骤控制
 */
const nextStep = () => {
    if (canProceedToNext.value && currentStep.value < 3) {
        // 保存当前步骤数据到缓存
        saveStepData()
        currentStep.value++
        
        // 如果进入第3步，加载项目数据
        if (currentStep.value === 3) {
            loadCategories()
        }
    }
}

const prevStep = () => {
    if (currentStep.value > 1) {
        currentStep.value--
    }
}

/**
 * 保存步骤数据到缓存
 */
const saveStepData = () => {
    const cacheData = {
        formData: formData.value,
        startDateValue: startDateValue.value,
        startTimeValue: startTimeValue.value,
        endDateValue: endDateValue.value,
        endTimeValue: endTimeValue.value,
        selectedItems: selectedItems.value
    }
    uni.setStorageSync('sport_event_create_cache', cacheData)
}

/**
 * 从缓存恢复数据
 */
const restoreFromCache = () => {
    try {
        const cacheData = uni.getStorageSync('sport_event_create_cache')
        if (cacheData) {
            formData.value = { ...formData.value, ...cacheData.formData }
            startDateValue.value = cacheData.startDateValue || ''
            startTimeValue.value = cacheData.startTimeValue || ''
            endDateValue.value = cacheData.endDateValue || ''
            endTimeValue.value = cacheData.endTimeValue || ''
            selectedItems.value = cacheData.selectedItems || []
        }
    } catch (error) {
        console.error('恢复缓存数据失败:', error)
    }
}

/**
 * 清除缓存
 */
const clearCache = () => {
    uni.removeStorageSync('sport_event_create_cache')
}

/**
 * 赛事类型变化
 */
const handleEventTypeChange = (value: number) => {
    formData.value.event_type = value
    if (value === 1) {
        formData.value.series_id = 0
    }
}

/**
 * 地址选择
 */
const chooseLocation = () => {
    // #ifdef MP-WEIXIN
    console.log('当前环境: 微信小程序')
    
    // 检查是否支持隐私协议
    if ((uni as any).requirePrivacyAuthorize) {
        (uni as any).requirePrivacyAuthorize({
            success: () => {
                console.log('隐私协议授权成功')
                performChooseLocation()
            },
            fail: () => {
                console.log('隐私协议授权失败')
                uni.showToast({
                    title: '需要授权地理位置权限',
                    icon: 'none'
                })
            }
        })
    } else {
        performChooseLocation()
    }
    // #endif
    
    // #ifdef H5
    uni.showToast({
        title: 'H5环境暂不支持地图选择，请手动输入地址',
        icon: 'none'
    })
    // #endif
    
    // #ifdef APP-PLUS
    uni.showToast({
        title: 'APP环境暂不支持地图选择，请手动输入地址',
        icon: 'none'
    })
    // #endif
}

const performChooseLocation = () => {
    uni.chooseLocation({
        success: (res) => {
            console.log('选择地址成功:', res)
            
            if (res.latitude && res.longitude) {
                formData.value.lat = res.latitude.toString()
                formData.value.lng = res.longitude.toString()
            }
            
            let locationName = ''
            if (res.address) {
                locationName = res.address
            }
            if (res.name && res.name !== res.address) {
                locationName += (locationName ? ' ' : '') + res.name
            }
            
            formData.value.location = locationName || res.name || '已选择位置'
            formData.value.full_address = locationName
            
            uni.showToast({
                title: '地址选择成功',
                icon: 'success'
            })
        },
        fail: (res) => {
            console.error('选择地址失败:', res)
            if (res.errMsg && res.errMsg.includes('cancel')) {
                return
            }
            
            let message = '选择地址失败'
            if (res.errMsg) {
                if (res.errMsg.includes('auth deny') || res.errMsg.includes('unauthorized')) {
                    message = '请授权地理位置权限'
                } else if (res.errMsg.includes('system permission denied')) {
                    message = '系统权限被拒绝，请在系统设置中开启定位权限'
                }
            }
            
            uni.showToast({
                title: message,
                icon: 'none',
                duration: 3000
            })
        }
    })
}

/**
 * 时间选择处理
 */
const onStartDateChange = (e: any) => {
    startDateValue.value = e.detail.value
    updateStartDateTime()
}

const onStartTimeChange = (e: any) => {
    startTimeValue.value = e.detail.value
    updateStartDateTime()
}

const onEndDateChange = (e: any) => {
    endDateValue.value = e.detail.value
    updateEndDateTime()
}

const onEndTimeChange = (e: any) => {
    endTimeValue.value = e.detail.value
    updateEndDateTime()
}

const updateStartDateTime = () => {
    if (startDateValue.value && startTimeValue.value) {
        const dateTimeString = `${startDateValue.value} ${startTimeValue.value}`
        const timestamp = new Date(dateTimeString).getTime()
        formData.value.start_time = Math.floor(timestamp / 1000)
        formData.value.year = new Date(timestamp).getFullYear()
    }
}

const updateEndDateTime = () => {
    if (endDateValue.value && endTimeValue.value) {
        const dateTimeString = `${endDateValue.value} ${endTimeValue.value}`
        const timestamp = new Date(dateTimeString).getTime()
        formData.value.end_time = Math.floor(timestamp / 1000)
    }
}

/**
 * 选择器处理
 */
const openOrganizerPicker = () => {
    if (!organizerList.value.length) {
        uni.showToast({
            title: '暂无主办方数据',
            icon: 'none'
        })
        return
    }
    tempOrganizerIndex.value = selectedOrganizerIndex.value
    showOrganizerPicker.value = true
}

const openSeriesPicker = () => {
    if (!seriesList.value.length) {
        uni.showToast({
            title: '暂无系列赛数据',
            icon: 'none'
        })
        return
    }
    tempSeriesIndex.value = selectedSeriesIndex.value
    showSeriesPicker.value = true
}

const onOrganizerPickerChange = (e: any) => {
    tempOrganizerIndex.value = e.detail.value[0]
}

const onSeriesPickerChange = (e: any) => {
    tempSeriesIndex.value = e.detail.value[0]
}

const confirmOrganizerSelection = () => {
    if (organizerPickerList.value[tempOrganizerIndex.value]) {
        const selected = organizerPickerList.value[tempOrganizerIndex.value]
        formData.value.organizer_id = selected.id
    }
    showOrganizerPicker.value = false
}

const confirmSeriesSelection = () => {
    if (seriesPickerList.value[tempSeriesIndex.value]) {
        const selected = seriesPickerList.value[tempSeriesIndex.value]
        formData.value.series_id = selected.id
    }
    showSeriesPicker.value = false
}

/**
 * 自定义分组处理
 */
const addGroup = () => {
    formData.value.custom_groups.push({
        group_name: '',
        group_type: 'custom',
        description: '',
        sort: formData.value.custom_groups.length
    })
}

const removeGroup = (index: number) => {
    formData.value.custom_groups.splice(index, 1)
}

/**
 * 项目选择处理
 */
const switchTab = (tabId: string | number) => {
    activeTab.value = tabId
}

const toggleCategory = (categoryId: number) => {
    const index = expandedCategories.value.indexOf(categoryId)
    if (index > -1) {
        expandedCategories.value.splice(index, 1)
    } else {
        expandedCategories.value.push(categoryId)
    }
}

const toggleItem = (itemId: number) => {
    const index = selectedItems.value.indexOf(itemId)
    if (index > -1) {
        selectedItems.value.splice(index, 1)
    } else {
        selectedItems.value.push(itemId)
    }
}

/**
 * 加载数据
 */
const loadOrganizerList = async () => {
    try {
        const response: any = await getOrganizerList()
        organizerList.value = response.data || []
    } catch (error) {
        console.error('加载主办方列表失败:', error)
    }
}

const loadSeriesList = async () => {
    try {
        const response: any = await getEventSeriesList()
        seriesList.value = response.data || []
    } catch (error) {
        console.error('加载系列赛列表失败:', error)
    }
}

const loadCategories = async () => {
    try {
        const response: any = await getEventCategories()
        categories.value = response.data?.categories || []
        
        // 设置默认展开的分类
        categories.value.forEach(category => {
            if (category.default_expand) {
                expandedCategories.value.push(category.id)
            }
        })
    } catch (error) {
        console.error('加载分类失败:', error)
    }
}

/**
 * 提交表单
 */
const handleSubmit = async () => {
    if (selectedItems.value.length === 0) {
        uni.showToast({
            title: '请选择至少一个比赛项目',
            icon: 'none'
        })
        return
    }
    
    try {
        submitLoading.value = true
        
        // 准备提交数据
        const submitData = {
            ...formData.value,
            base_item_ids: selectedItems.value,
            custom_groups: formData.value.custom_groups.filter(group => group.group_name.trim())
        }
        
        console.log('提交数据:', submitData)
        
        const response: any = await addEvent(submitData)
        
        if (response.code === 1) {
            uni.showToast({
                title: '创建成功',
                icon: 'success'
            })
            
            // 清除缓存
            clearCache()
            
            // 返回列表页
            setTimeout(() => {
                uni.navigateBack()
            }, 1500)
        } else {
            throw new Error(response.msg || '创建失败')
        }
    } catch (error: any) {
        console.error('创建赛事失败:', error)
        uni.showToast({
            title: error.message || '创建失败',
            icon: 'none'
        })
    } finally {
        submitLoading.value = false
    }
}

/**
 * 页面初始化
 */
onMounted(() => {
    requireLogin(() => {
        // 恢复缓存数据
        restoreFromCache()
        
        // 加载基础数据
        loadOrganizerList()
        loadSeriesList()
        
        // 初始化时间选择器的值
        if (!startDateValue.value) {
            const now = new Date()
            const today = now.toISOString().slice(0, 10)
            const currentTime = now.toTimeString().slice(0, 5)
            
            startDateValue.value = today
            startTimeValue.value = currentTime
            endDateValue.value = today
            endTimeValue.value = currentTime
        }
    }, '/addon/sport/pages/event/create_steps')
})

// 页面卸载时保存数据
onUnmounted(() => {
    saveStepData()
})
</script>

<style lang="scss" scoped>
.create-steps-page {
    min-height: 100vh;
    background-color: #f8faff;
    padding-bottom: 120rpx;
}

.steps-header {
    background-color: white;
    padding: 40rpx 32rpx;
    border-bottom: 1rpx solid #f0f0f0;
    
    .steps-nav {
        display: flex;
        justify-content: space-between;
        align-items: center;
        
        .step-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            flex: 1;
            position: relative;
            
            &:not(:last-child)::after {
                content: '';
                position: absolute;
                top: 20rpx;
                right: -50%;
                width: 100%;
                height: 2rpx;
                background-color: #e0e0e0;
                z-index: 1;
            }
            
            &.completed::after {
                background-color: #007aff;
            }
            
            .step-number {
                width: 40rpx;
                height: 40rpx;
                border-radius: 50%;
                background-color: #e0e0e0;
                color: #999;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 24rpx;
                font-weight: bold;
                margin-bottom: 16rpx;
                position: relative;
                z-index: 2;
            }
            
            &.active .step-number {
                background-color: #007aff;
                color: white;
            }
            
            &.completed .step-number {
                background-color: #007aff;
                color: white;
            }
            
            .step-title {
                font-size: 24rpx;
                color: #999;
            }
            
            &.active .step-title {
                color: #007aff;
                font-weight: bold;
            }
            
            &.completed .step-title {
                color: #007aff;
            }
        }
    }
}

.steps-content {
    padding: 32rpx;
    
    .step-content {
        .form-section {
            background: white;
            border-radius: 16rpx;
            padding: 32rpx;
            
            .form-item {
                margin-bottom: 32rpx;
                
                &:last-child {
                    margin-bottom: 0;
                }
                
                .form-label {
                    font-size: 28rpx;
                    color: #333;
                    margin-bottom: 16rpx;
                    
                    &.required::after {
                        content: '*';
                        color: #ff4757;
                        margin-left: 8rpx;
                    }
                }
                
                .form-input {
                    width: 100%;
                    height: 88rpx;
                    padding: 0 24rpx;
                    border: 2rpx solid #e0e0e0;
                    border-radius: 12rpx;
                    font-size: 28rpx;
                    color: #333;
                    
                    &.readonly {
                        background-color: #f8f9fa;
                        color: #666;
                    }
                    
                    &:focus {
                        border-color: #007aff;
                    }
                }
                
                .form-tip {
                    margin-top: 12rpx;
                    
                    .tip-text {
                        font-size: 24rpx;
                        color: #999;
                    }
                    
                    .tip-link {
                        font-size: 24rpx;
                        color: #007aff;
                    }
                }
            }
        }
    }
}

// 自定义分组样式
.groups-container {
    .group-item {
        display: flex;
        align-items: center;
        margin-bottom: 16rpx;
        
        .group-input {
            flex: 1;
            height: 80rpx;
            padding: 0 20rpx;
            border: 2rpx solid #e0e0e0;
            border-radius: 8rpx;
            font-size: 28rpx;
            margin-right: 16rpx;
        }
        
        .group-actions {
            .action-btn {
                padding: 12rpx 20rpx;
                border-radius: 6rpx;
                font-size: 24rpx;
                
                &.remove {
                    background-color: #ff4757;
                    color: white;
                }
            }
        }
    }
    
    .add-group-btn {
        display: flex;
        align-items: center;
        justify-content: center;
        height: 80rpx;
        border: 2rpx dashed #007aff;
        border-radius: 8rpx;
        color: #007aff;
        
        .add-icon {
            font-size: 32rpx;
            margin-right: 8rpx;
        }
        
        .add-text {
            font-size: 28rpx;
        }
    }
}

// 项目选择样式
.items-selection {
    .category-tabs {
        background-color: white;
        border-radius: 16rpx;
        margin-bottom: 20rpx;
        padding: 20rpx 0;
        
        .tabs-scroll {
            .tabs-content {
                display: flex;
                padding: 0 32rpx;
                
                .tab-item {
                    flex-shrink: 0;
                    padding: 16rpx 24rpx;
                    margin-right: 16rpx;
                    border-radius: 20rpx;
                    background-color: #f8f9fa;
                    
                    &.active {
                        background-color: #007aff;
                        
                        .tab-text {
                            color: white;
                        }
                    }
                    
                    .tab-text {
                        font-size: 26rpx;
                        color: #666;
                    }
                }
            }
        }
    }
    
    .categories-list {
        .category-section {
            background-color: white;
            border-radius: 16rpx;
            margin-bottom: 20rpx;
            overflow: hidden;
            
            .category-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 32rpx;
                border-bottom: 1rpx solid #f0f0f0;
                
                .category-info {
                    display: flex;
                    align-items: center;
                    
                    .category-name {
                        font-size: 30rpx;
                        font-weight: bold;
                        color: #333;
                        margin-right: 16rpx;
                    }
                    
                    .category-count {
                        font-size: 24rpx;
                        color: #999;
                    }
                }
                
                .category-arrow {
                    transition: transform 0.3s ease;
                    
                    &.expanded {
                        transform: rotate(90deg);
                    }
                    
                    .arrow-icon {
                        font-size: 32rpx;
                        color: #999;
                    }
                }
            }
            
            .base-items-grid {
                padding: 32rpx;
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 16rpx;
                
                .base-item {
                    background-color: #f8f9fa;
                    border: 2rpx solid transparent;
                    border-radius: 12rpx;
                    padding: 24rpx 20rpx;
                    transition: all 0.3s ease;
                    position: relative;
                    
                    &.selected {
                        background-color: #e7f3ff;
                        border-color: #007aff;
                        
                        .item-name {
                            color: #007aff;
                            font-weight: bold;
                        }
                    }
                    
                    .item-content {
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        min-height: 80rpx;
                        position: relative;
                        
                        .item-name {
                            font-size: 28rpx;
                            color: #333;
                            text-align: center;
                            line-height: 1.4;
                            word-break: break-all;
                            flex: 1;
                        }
                        
                        .selected-icon {
                            position: absolute;
                            top: -8rpx;
                            right: -8rpx;
                            width: 32rpx;
                            height: 32rpx;
                            background-color: #007aff;
                            border-radius: 50%;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            
                            .icon-check {
                                font-size: 20rpx;
                                color: white;
                                font-weight: bold;
                            }
                        }
                    }
                }
            }
        }
    }
    
    .selected-summary {
        background-color: white;
        border-radius: 16rpx;
        padding: 24rpx 32rpx;
        text-align: center;
        
        .summary-text {
            font-size: 28rpx;
            color: #007aff;
            font-weight: bold;
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
    
    .action-buttons {
        display: flex;
        gap: 24rpx;
        
        .btn-secondary,
        .btn-primary {
            flex: 1;
            height: 88rpx;
            border-radius: 12rpx;
            border: none;
            font-size: 32rpx;
            font-weight: bold;
            
            &.btn-secondary {
                background-color: #f8f9fa;
                color: #666;
                border: 2rpx solid #dee2e6;
            }
            
            &.btn-primary {
                background-color: #007aff;
                color: white;
                
                &:disabled {
                    background-color: #ccc;
                    color: #999;
                }
            }
        }
    }
}

// 选择器样式
.picker-mask {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.5);
    z-index: 1000;
    display: flex;
    align-items: flex-end;
    
    .picker-container {
        background-color: white;
        border-radius: 24rpx 24rpx 0 0;
        width: 100%;
        max-height: 60vh;
        
        .picker-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 32rpx;
            border-bottom: 1rpx solid #f0f0f0;
            
            .picker-cancel,
            .picker-confirm {
                font-size: 32rpx;
                color: #007aff;
            }
            
            .picker-title {
                font-size: 32rpx;
                font-weight: bold;
                color: #333;
            }
        }
        
        .picker-view {
            height: 400rpx;
            
            .picker-item {
                display: flex;
                align-items: center;
                justify-content: center;
                height: 80rpx;
                font-size: 28rpx;
                color: #333;
            }
        }
    }
}
</style> 
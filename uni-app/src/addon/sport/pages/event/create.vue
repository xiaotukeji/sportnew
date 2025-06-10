<template>
    <view class="create-event-page">
        <!-- 表单内容 -->
        <view class="form-container">
            <view class="form-wrapper">
                <!-- 基本信息 -->
                <view class="form-section">
                    <view class="section-title">基本信息</view>
                    
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
                </view>
                
                <!-- 组织信息 -->
                <view class="form-section">
                    <view class="section-title">组织信息</view>
                    
                    <!-- 举办者类型 -->
                    <view class="form-item">
                        <view class="form-label required">举办者类型</view>
                        <view class="radio-group">
                            <view 
                                v-for="item in organizerTypeOptions" 
                                :key="item.value" 
                                class="radio-item"
                                @tap="handleOrganizerTypeChange(item.value)"
                            >
                                <view class="radio-circle" :class="{ 'active': formData.organizer_type === item.value }">
                                    <view class="radio-dot" v-if="formData.organizer_type === item.value"></view>
                                </view>
                                <text class="radio-label">{{ item.label }}</text>
                            </view>
                        </view>
                    </view>
                    
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
                </view>
                
                <!-- 系列赛设置 -->
                <view class="form-section">
                    <view class="section-title">系列赛设置</view>
                    
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
                    <view 
                        v-if="formData.event_type === 2" 
                        class="form-item"
                    >
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
                </view>
            </view>
            
            <!-- 提交按钮 -->
            <view class="submit-section">
                <button 
                    class="submit-btn" 
                    :class="{ 'loading': submitLoading }"
                    :disabled="submitLoading"
                    @tap="handleSubmit"
                >
                    {{ submitLoading ? '创建中...' : '创建比赛' }}
                </button>
            </view>
        </view>
        

        
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
        
        <!-- 添加主办方模态框 -->
        <view v-if="showOrganizerModal" class="modal-mask" @tap="cancelOrganizerModal">
            <view class="modal-container" @tap.stop>
                <view class="modal-header">
                    <text class="modal-title">添加主办方</text>
                    <text class="modal-close" @tap="cancelOrganizerModal">×</text>
                </view>
                <view class="modal-content">
                    <view class="form-item">
                        <view class="form-label required">名称</view>
                        <input 
                            class="form-input" 
                            v-model="organizerForm.organizer_name" 
                            placeholder="请输入主办方名称"
                            maxlength="100"
                        />
                    </view>
                    <view class="form-item">
                        <view class="form-label">联系人</view>
                        <input 
                            class="form-input" 
                            v-model="organizerForm.contact_name" 
                            placeholder="请输入联系人"
                            maxlength="50"
                        />
                    </view>
                    <view class="form-item">
                        <view class="form-label">联系电话</view>
                        <input 
                            class="form-input" 
                            v-model="organizerForm.contact_phone" 
                            placeholder="请输入联系电话"
                            maxlength="20"
                        />
                    </view>
                </view>
                <view class="modal-footer">
                    <button class="modal-btn cancel" @tap="cancelOrganizerModal">取消</button>
                    <button class="modal-btn confirm" @tap="addOrganizerConfirm">确定</button>
                </view>
            </view>
        </view>
        
        <!-- 添加系列赛模态框 -->
        <view v-if="showSeriesModal" class="modal-mask" @tap="cancelSeriesModal">
            <view class="modal-container" @tap.stop>
                <view class="modal-header">
                    <text class="modal-title">添加系列赛</text>
                    <text class="modal-close" @tap="cancelSeriesModal">×</text>
                </view>
                <view class="modal-content">
                    <view class="form-item">
                        <view class="form-label required">系列赛名称</view>
                        <input 
                            class="form-input" 
                            v-model="seriesForm.name" 
                            placeholder="请输入系列赛名称"
                            maxlength="100"
                        />
                    </view>
                    <view class="form-item">
                        <view class="form-label required">开始年份</view>
                        <input 
                            class="form-input" 
                            v-model="seriesForm.start_year" 
                            placeholder="请输入开始年份"
                            type="number"
                        />
                    </view>
                    <view class="form-item">
                        <view class="form-label">描述</view>
                        <textarea 
                            class="form-textarea" 
                            v-model="seriesForm.description" 
                            placeholder="请输入系列赛描述"
                            maxlength="200"
                        />
                    </view>
                </view>
                <view class="modal-footer">
                    <button class="modal-btn cancel" @tap="cancelSeriesModal">取消</button>
                    <button class="modal-btn confirm" @tap="addSeriesConfirm">确定</button>
                </view>
            </view>
        </view>
    </view>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useLoginCheck } from '@/addon/sport/hooks/useLoginCheck'
import { 
    addEvent, 
    getOrganizerList, 
    addOrganizer, 
    getEventSeriesList, 
    addEventSeries
} from '@/addon/sport/api/event'

// 登录检查
const { requireLogin } = useLoginCheck()

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
    organizer_type: 1,         // 举办者类型：1个人 2单位
    organizer_id: 0,           // 主办方ID
    event_type: 1,             // 赛事类型：1独立赛事 2系列赛事
    series_id: 0,              // 系列赛ID
    year: new Date().getFullYear() // 举办年份
})

// 主办方表单
const organizerForm = ref({
    organizer_name: '',
    contact_name: '',
    contact_phone: '',
    organizer_type: 1
})

// 系列赛表单
const seriesForm = ref({
    name: '',
    start_year: new Date().getFullYear(),
    description: ''
})

// 选项数据
const organizerTypeOptions = [
    { label: '个人', value: 1 },
    { label: '单位', value: 2 }
]

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
const startDateDisplay = computed(() => {
    return startDateValue.value || ''
})

const startTimeDisplay = computed(() => {
    return startTimeValue.value || ''
})

const endDateDisplay = computed(() => {
    return endDateValue.value || ''
})

const endTimeDisplay = computed(() => {
    return endTimeValue.value || ''
})

// 选择器相关
const showOrganizerPicker = ref(false)
const showSeriesPicker = ref(false)
const showOrganizerModal = ref(false)
const showSeriesModal = ref(false)

// 数据列表
const organizerList = ref<any[]>([])
const seriesList = ref<any[]>([])

// 选择器数据
const organizerPickerList = computed(() => {
    return organizerList.value
})

const seriesPickerList = computed(() => {
    return seriesList.value
})

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

// 提交状态
const submitLoading = ref(false)

/**
 * 日期时间选择
 */
const onStartDateChange = (e: any) => {
    console.log('开始日期选择:', e.detail.value)
    startDateValue.value = e.detail.value
    updateStartDateTime()
}

const onStartTimeChange = (e: any) => {
    console.log('开始时间选择:', e.detail.value)
    startTimeValue.value = e.detail.value
    updateStartDateTime()
}

const onEndDateChange = (e: any) => {
    console.log('结束日期选择:', e.detail.value)
    endDateValue.value = e.detail.value
    updateEndDateTime()
}

const onEndTimeChange = (e: any) => {
    console.log('结束时间选择:', e.detail.value)
    endTimeValue.value = e.detail.value
    updateEndDateTime()
}

/**
 * 更新开始时间戳
 */
const updateStartDateTime = () => {
    if (startDateValue.value && startTimeValue.value) {
        const dateTimeString = `${startDateValue.value} ${startTimeValue.value}`
        const timestamp = new Date(dateTimeString).getTime()
        formData.value.start_time = Math.floor(timestamp / 1000)
        formData.value.year = new Date(timestamp).getFullYear()
        
        console.log('开始时间更新:', {
            date: startDateValue.value,
            time: startTimeValue.value,
            timestamp: formData.value.start_time,
            year: formData.value.year
        })
    }
}

/**
 * 更新结束时间戳
 */
const updateEndDateTime = () => {
    if (endDateValue.value && endTimeValue.value) {
        const dateTimeString = `${endDateValue.value} ${endTimeValue.value}`
        const timestamp = new Date(dateTimeString).getTime()
        formData.value.end_time = Math.floor(timestamp / 1000)
        
        console.log('结束时间更新:', {
            date: endDateValue.value,
            time: endTimeValue.value,
            timestamp: formData.value.end_time
        })
    }
}

/**
 * 选择地址
 */
const chooseLocation = () => {
    console.log('开始选择地址')
    
    // #ifdef MP-WEIXIN
    uni.chooseLocation({
        success: (res) => {
            console.log('选择地址成功:', res)
            
            // 保存经纬度
            if (res.latitude && res.longitude) {
                formData.value.lat = res.latitude.toString()
                formData.value.lng = res.longitude.toString()
                console.log('经纬度保存:', { lat: formData.value.lat, lng: formData.value.lng })
            }
            
            // 保存地址信息
            let locationName = ''
            if (res.address) {
                locationName = res.address
            }
            if (res.name && res.name !== res.address) {
                locationName += (locationName ? ' ' : '') + res.name
            }
            
            formData.value.location = locationName || res.name || '已选择位置'
            
            // 组合完整地址用于提交
            formData.value.full_address = locationName
            
            console.log('地址信息保存:', {
                location: formData.value.location,
                full_address: formData.value.full_address
            })
            
            uni.showToast({
                title: '地址选择成功',
                icon: 'success'
            })
        },
        fail: (res) => {
            console.error('选择地址失败:', res)
            if (res.errMsg && res.errMsg.includes('cancel')) {
                console.log('用户取消选择地址')
                return
            }
            
            let message = '选择地址失败'
            if (res.errMsg) {
                console.log('错误信息:', res.errMsg)
                if (res.errMsg.includes('auth deny') || res.errMsg.includes('unauthorized')) {
                    message = '请授权地理位置权限'
                } else if (res.errMsg.includes('system permission denied')) {
                    message = '系统权限被拒绝，请在系统设置中开启定位权限'
                }
            }
            
            uni.showToast({
                title: message,
                icon: 'none'
            })
        }
    })
    // #endif
    
    // #ifdef H5
    console.log('当前环境: H5')
    uni.showToast({
        title: 'H5环境暂不支持地图选择，请手动输入地址',
        icon: 'none'
    })
    // #endif
    
    // #ifdef APP-PLUS
    console.log('当前环境: APP')
    uni.showToast({
        title: 'APP环境暂不支持地图选择，请手动输入地址',
        icon: 'none'
    })
    // #endif
}

/**
 * 举办者类型变化
 */
const handleOrganizerTypeChange = (value: number) => {
    formData.value.organizer_type = value
    formData.value.organizer_id = 0
    organizerForm.value.organizer_type = value
    loadOrganizerList()
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
 * 打开选择器
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

/**
 * 选择器变化
 */
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
 * 加载主办方列表
 */
const loadOrganizerList = async () => {
    try {
        const response: any = await getOrganizerList(formData.value.organizer_type)
        organizerList.value = response.data || []
    } catch (error) {
        console.error('加载主办方列表失败:', error)
        organizerList.value = []
    }
}

/**
 * 加载系列赛列表
 */
const loadSeriesList = async () => {
    try {
        const response: any = await getEventSeriesList()
        seriesList.value = response.data || []
    } catch (error) {
        console.error('加载系列赛列表失败:', error)
        seriesList.value = []
    }
}

/**
 * 添加主办方
 */
const addOrganizerConfirm = async () => {
    if (!organizerForm.value.organizer_name.trim()) {
        uni.showToast({
            title: '请输入主办方名称',
            icon: 'none'
        })
        return
    }
    
    try {
        const params = {
            ...organizerForm.value,
            organizer_type: formData.value.organizer_type
        }
        const result: any = await addOrganizer(params)
        
        // 重新加载主办方列表
        await loadOrganizerList()
        
        // 自动选中新添加的主办方
        if (result && result.data && result.data.id) {
            formData.value.organizer_id = result.data.id
            console.log('自动选中新添加的主办方:', result.data.id)
        }
        
        // 关闭模态框并重置表单
        showOrganizerModal.value = false
        organizerForm.value = {
            organizer_name: '',
            contact_name: '',
            contact_phone: '',
            organizer_type: 1
        }
        
        uni.showToast({
            title: '添加主办方成功',
            icon: 'success'
        })
    } catch (error) {
        console.error('添加主办方失败:', error)
    }
}

const cancelOrganizerModal = () => {
    showOrganizerModal.value = false
    organizerForm.value = {
        organizer_name: '',
        contact_name: '',
        contact_phone: '',
        organizer_type: 1
    }
}

/**
 * 添加系列赛
 */
const addSeriesConfirm = async () => {
    if (!seriesForm.value.name.trim()) {
        uni.showToast({
            title: '请输入系列赛名称',
            icon: 'none'
        })
        return
    }
    
    if (!seriesForm.value.start_year) {
        uni.showToast({
            title: '请输入开始年份',
            icon: 'none'
        })
        return
    }
    
    try {
        const result: any = await addEventSeries(seriesForm.value)
        
        // 重新加载系列赛列表
        await loadSeriesList()
        
        // 自动选中新添加的系列赛
        if (result && result.data && result.data.id) {
            formData.value.series_id = result.data.id
            console.log('自动选中新添加的系列赛:', result.data.id)
        }
        
        // 关闭模态框并重置表单
        showSeriesModal.value = false
        seriesForm.value = {
            name: '',
            start_year: new Date().getFullYear(),
            description: ''
        }
        
        uni.showToast({
            title: '添加系列赛成功',
            icon: 'success'
        })
    } catch (error) {
        console.error('添加系列赛失败:', error)
    }
}

const cancelSeriesModal = () => {
    showSeriesModal.value = false
    seriesForm.value = {
        name: '',
        start_year: new Date().getFullYear(),
        description: ''
    }
}

/**
 * 表单验证
 */
const validateForm = () => {
    if (!formData.value.name.trim()) {
        uni.showToast({
            title: '请输入比赛名称',
            icon: 'none'
        })
        return false
    }
    
    if (!formData.value.location.trim()) {
        uni.showToast({
            title: '请先选择地图位置',
            icon: 'none'
        })
        return false
    }
    
    if (!formData.value.address_detail.trim()) {
        uni.showToast({
            title: '请输入详细地址',
            icon: 'none'
        })
        return false
    }
    
    if (!formData.value.start_time) {
        uni.showToast({
            title: '请选择开始时间',
            icon: 'none'
        })
        return false
    }
    
    if (!formData.value.end_time) {
        uni.showToast({
            title: '请选择结束时间',
            icon: 'none'
        })
        return false
    }
    
    if (formData.value.start_time >= formData.value.end_time) {
        uni.showToast({
            title: '结束时间必须晚于开始时间',
            icon: 'none'
        })
        return false
    }
    
    if (!formData.value.organizer_id) {
        uni.showToast({
            title: '请选择主办方',
            icon: 'none'
        })
        return false
    }
    
    if (formData.value.event_type === 2 && !formData.value.series_id) {
        uni.showToast({
            title: '请选择系列赛',
            icon: 'none'
        })
        return false
    }
    
    return true
}

/**
 * 表单提交
 */
const handleSubmit = async () => {
    // 验证表单
    if (!validateForm()) {
        return
    }
    
    try {
        submitLoading.value = true
        
        // 组合完整地址信息
        let finalFullAddress = formData.value.full_address
        if (formData.value.address_detail) {
            finalFullAddress += (finalFullAddress ? ' ' : '') + formData.value.address_detail
        }
        
        // 提交数据
        const submitData = {
            ...formData.value,
            full_address: finalFullAddress
        }
        
        await addEvent(submitData)
        
        uni.showToast({
            title: '创建比赛成功',
            icon: 'success'
        })
        
        // 延迟跳转
        setTimeout(() => {
            uni.navigateBack()
        }, 1500)
        
    } catch (error) {
        console.error('创建比赛失败:', error)
    } finally {
        submitLoading.value = false
    }
}

/**
 * 页面初始化
 */
onMounted(() => {
    // 检查登录状态
    requireLogin(() => {
        // 已登录，初始化数据
        loadOrganizerList()
        loadSeriesList()
        
        // 初始化时间选择器的值（设置为当前时间）
        const now = new Date()
        const today = now.toISOString().slice(0, 10) // YYYY-MM-DD
        const currentTime = now.toTimeString().slice(0, 5) // HH:MM
        
        startDateValue.value = today
        startTimeValue.value = currentTime
        endDateValue.value = today
        endTimeValue.value = currentTime
        
        console.log('初始化时间选择器:', {
            date: today,
            time: currentTime
        })
    }, '/addon/sport/pages/event/create')
})
</script>

<style lang="scss" scoped>
.create-event-page {
    min-height: 100vh;
    background-color: #f8faff;
}

.form-container {
    padding: 32rpx;
}

.form-wrapper {
    margin-bottom: 120rpx;
}

.form-section {
    background: white;
    border-radius: 16rpx;
    margin-bottom: 32rpx;
    overflow: hidden;
    
    .section-title {
        padding: 32rpx 32rpx 16rpx;
        font-size: 32rpx;
        font-weight: bold;
        color: #333;
        border-bottom: 1px solid #f0f0f0;
    }
}

.form-item {
    padding: 24rpx 32rpx;
    border-bottom: 1px solid #f8f8f8;
    
    &:last-child {
        border-bottom: none;
    }
    
    .form-label {
        font-size: 28rpx;
        color: #333;
        margin-bottom: 16rpx;
        
        &.required::after {
            content: '*';
            color: #ff4757;
            margin-left: 4rpx;
        }
    }
    
    .form-input {
        width: 100%;
        padding: 20rpx 0;
        font-size: 28rpx;
        color: #333;
        border: none;
        outline: none;
        background: transparent;
        
        &.readonly {
            color: #666;
        }
        
        &::placeholder {
            color: #999;
        }
    }
    
    .form-textarea {
        width: 100%;
        min-height: 120rpx;
        padding: 20rpx 0;
        font-size: 28rpx;
        color: #333;
        border: none;
        outline: none;
        background: transparent;
        resize: none;
        
        &::placeholder {
            color: #999;
        }
    }
}

.location-container {
    display: flex;
    align-items: center;
    gap: 16rpx;
    
    .form-input {
        flex: 1;
    }
    
    .location-action {
        display: flex;
        align-items: center;
        gap: 8rpx;
        padding: 16rpx 24rpx;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-radius: 12rpx;
        
        .location-icon {
            font-size: 24rpx;
        }
        
        .location-text {
            font-size: 24rpx;
            color: white;
        }
    }
}

.time-picker-container {
    display: flex;
    gap: 16rpx;
    
    .time-picker-item {
        flex: 1;
        position: relative;
        display: flex;
        align-items: center;
        
        .form-input {
            flex: 1;
            padding-right: 40rpx;
        }
        
        .picker-arrow {
            position: absolute;
            right: 12rpx;
            font-size: 24rpx;
            color: #999;
        }
    }
}



.radio-group {
    display: flex;
    flex-direction: row;
    gap: 32rpx;
}

.radio-item {
    display: flex;
    align-items: center;
    cursor: pointer;
    
    .radio-circle {
        width: 32rpx;
        height: 32rpx;
        border: 2rpx solid #ddd;
        border-radius: 50%;
        margin-right: 16rpx;
        display: flex;
        align-items: center;
        justify-content: center;
        
        &.active {
            border-color: #007aff;
        }
        
        .radio-dot {
            width: 16rpx;
            height: 16rpx;
            background-color: #007aff;
            border-radius: 50%;
        }
    }
    
    .radio-label {
        font-size: 28rpx;
        color: #333;
    }
}

.form-tip {
    margin-top: 16rpx;
    font-size: 24rpx;
    color: #999;
    
    .tip-text {
        color: #999;
    }
    
    .tip-link {
        color: #007aff;
        text-decoration: underline;
    }
}

.submit-section {
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    padding: 32rpx;
    background: white;
    border-top: 1px solid #f0f0f0;
    
    .submit-btn {
        width: 100%;
        height: 88rpx;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        border-radius: 44rpx;
        font-size: 32rpx;
        font-weight: bold;
        display: flex;
        align-items: center;
        justify-content: center;
        
        &.loading {
            opacity: 0.7;
        }
        
        &:disabled {
            opacity: 0.5;
        }
    }
}

.modal-mask {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    z-index: 9999;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 64rpx;
}

.modal-container {
    background: white;
    border-radius: 16rpx;
    width: 100%;
    max-width: 600rpx;
    max-height: 80vh;
    overflow: hidden;
}

.modal-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 32rpx;
    border-bottom: 1px solid #f0f0f0;
    
    .modal-title {
        font-size: 32rpx;
        font-weight: bold;
        color: #333;
    }
    
    .modal-close {
        font-size: 48rpx;
        color: #999;
        cursor: pointer;
    }
}

.modal-content {
    padding: 32rpx;
    max-height: 50vh;
    overflow-y: auto;
}

.modal-footer {
    display: flex;
    border-top: 1px solid #f0f0f0;
    
    .modal-btn {
        flex: 1;
        height: 88rpx;
        border: none;
        font-size: 28rpx;
        cursor: pointer;
        
        &.cancel {
            background: #f8f8f8;
            color: #666;
        }
        
        &.confirm {
            background: #007aff;
            color: white;
        }
    }
}

.picker-mask {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    z-index: 9999;
    display: flex;
    align-items: flex-end;
    justify-content: center;
}

.picker-container {
    background: white;
    width: 100%;
    border-radius: 24rpx 24rpx 0 0;
}

.picker-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 32rpx;
    border-bottom: 1px solid #f0f0f0;
    
    .picker-cancel,
    .picker-confirm {
        font-size: 28rpx;
        color: #007aff;
        cursor: pointer;
    }
    
    .picker-title {
        font-size: 32rpx;
        font-weight: bold;
        color: #333;
    }
}

.picker-view {
    height: 500rpx;
}

.picker-item {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 100rpx;
    font-size: 28rpx;
    color: #333;
}
</style> 
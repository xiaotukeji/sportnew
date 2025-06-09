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
                    
                    <!-- 举办地点 -->
                    <view class="form-item">
                        <view class="form-label required">举办地点</view>
                        <input 
                            class="form-input" 
                            v-model="formData.location" 
                            placeholder="请输入举办地点"
                            maxlength="200"
                        />
                    </view>
                    
                    <!-- 开始时间 -->
                    <view class="form-item">
                        <view class="form-label required">开始时间</view>
                        <input 
                            class="form-input readonly" 
                            :value="startTimeDisplay" 
                            placeholder="请选择开始时间"
                            disabled
                            @tap="showStartTimePicker = true"
                        />
                    </view>
                    
                    <!-- 结束时间 -->
                    <view class="form-item">
                        <view class="form-label required">结束时间</view>
                        <input 
                            class="form-input readonly" 
                            :value="endTimeDisplay" 
                            placeholder="请选择结束时间"
                            disabled
                            @tap="showEndTimePicker = true"
                        />
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
                            @tap="showOrganizerPicker = true"
                        />
                        <view class="form-tip" v-if="!organizerList.length">
                            <text class="tip-text">暂无主办方，</text>
                            <text class="tip-link" @tap="showOrganizerModal = true">点击添加</text>
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
                            @tap="showSeriesPicker = true"
                        />
                        <view class="form-tip" v-if="!seriesList.length">
                            <text class="tip-text">暂无系列赛，</text>
                            <text class="tip-link" @tap="showSeriesModal = true">点击添加</text>
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
        
        <!-- 时间选择器 -->
        <picker
            v-if="showStartTimePicker"
            mode="datetime"
            :value="startTimeValue"
            @change="onStartTimeChange"
            @cancel="showStartTimePicker = false"
        >
            <view></view>
        </picker>
        
        <picker
            v-if="showEndTimePicker"
            mode="datetime"
            :value="endTimeValue"
            @change="onEndTimeChange"
            @cancel="showEndTimePicker = false"
        >
            <view></view>
        </picker>
        
        <!-- 主办方选择器 -->
        <picker
            v-if="showOrganizerPicker"
            :range="organizerPickerList"
            range-key="organizer_name"
            @change="onOrganizerChange"
            @cancel="showOrganizerPicker = false"
        >
            <view></view>
        </picker>
        
        <!-- 系列赛选择器 -->
        <picker
            v-if="showSeriesPicker"
            :range="seriesPickerList"
            range-key="name"
            @change="onSeriesChange"
            @cancel="showSeriesPicker = false"
        >
            <view></view>
        </picker>
        
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
    location: '',              // 举办地点
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
const showStartTimePicker = ref(false)
const showEndTimePicker = ref(false)
const startTimeValue = ref('')
const endTimeValue = ref('')

const startTimeDisplay = computed(() => {
    return formData.value.start_time ? 
        new Date(formData.value.start_time * 1000).toLocaleString() : ''
})

const endTimeDisplay = computed(() => {
    return formData.value.end_time ? 
        new Date(formData.value.end_time * 1000).toLocaleString() : ''
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
 * 时间选择
 */
const onStartTimeChange = (e: any) => {
    const timeString = e.detail.value
    const timestamp = new Date(timeString).getTime()
    formData.value.start_time = Math.floor(timestamp / 1000)
    formData.value.year = new Date(timestamp).getFullYear()
    showStartTimePicker.value = false
}

const onEndTimeChange = (e: any) => {
    const timeString = e.detail.value
    const timestamp = new Date(timeString).getTime()
    formData.value.end_time = Math.floor(timestamp / 1000)
    showEndTimePicker.value = false
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
 * 选择器变化
 */
const onOrganizerChange = (e: any) => {
    const index = e.detail.value
    const selected = organizerPickerList.value[index]
    formData.value.organizer_id = selected.id
    showOrganizerPicker.value = false
}

const onSeriesChange = (e: any) => {
    const index = e.detail.value
    const selected = seriesPickerList.value[index]
    formData.value.series_id = selected.id
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
        await addOrganizer(params)
        
        // 重新加载主办方列表
        await loadOrganizerList()
        
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
        await addEventSeries(seriesForm.value)
        
        // 重新加载系列赛列表
        await loadSeriesList()
        
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
            title: '请输入举办地点',
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
        
        // 提交数据
        await addEvent(formData.value)
        
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
        
        // 初始化时间选择器的值
        const now = new Date()
        startTimeValue.value = now.toISOString().slice(0, 16)
        endTimeValue.value = now.toISOString().slice(0, 16)
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
</style> 
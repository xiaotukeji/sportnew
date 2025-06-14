<template>
    <view class="create-event-page">
        <!-- 步骤导航 -->
        <view class="steps-header">
            <view class="steps-nav">
                <view 
                    v-for="(step, index) in steps" 
                    :key="index"
                    class="step-item"
                    :class="{ 
                        'active': currentStep === index + 1,
                        'completed': currentStep > index + 1,
                        'clickable': index + 1 <= maxReachedStep
                    }"
                    @tap="goToStep(index + 1)"
                >
                    <view class="step-circle">
                        <view class="step-number" v-if="currentStep <= index + 1">{{ index + 1 }}</view>
                        <text class="step-check" v-else>✓</text>
                    </view>
                    <text class="step-title">{{ step.title }}</text>
                    <view v-if="index < steps.length - 1" class="step-line"></view>
                </view>
            </view>
        </view>

        <!-- 步骤内容 -->
        <view class="form-container">
            <!-- 第1步：基本信息 -->
            <view v-if="currentStep === 1" class="form-wrapper">
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
                
                <view class="form-section">
                    <view class="section-title">赛事信息</view>
                    
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
            </view>

            <!-- 第2步：地点信息 -->
            <view v-if="currentStep === 2" class="form-wrapper">
                <view class="form-section">
                    <view class="section-title">地点信息</view>
                    
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

            <!-- 第3步：时间安排 -->
            <view v-if="currentStep === 3" class="form-wrapper">
                <view class="form-section">
                    <view class="section-title">时间安排</view>
                    
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
                
                <!-- 自定义分组 -->
                <view class="form-section">
                    <view class="section-title">自定义分组</view>
                    <view class="form-tip" style="margin: 0 32rpx 16rpx;">
                        <text class="tip-text">可以创建如"12年级组"、"A组/B组"等自定义分组</text>
                    </view>
                    
                    <view class="form-item">
                        <view class="group-default">
                            <text class="group-default-text">默认不分组</text>
                            <text class="add-link" @tap="addGroup">添加分组</text>
                        </view>
                    </view>
                    
                    <view v-if="formData.custom_groups.length > 0">
                        <view 
                            v-for="(group, index) in formData.custom_groups" 
                            :key="index"
                            class="form-item"
                        >
                            <view class="group-item">
                                <input 
                                    class="form-input group-input" 
                                    v-model="group.group_name" 
                                    :placeholder="`分组${index + 1}名称`"
                                    maxlength="50"
                                />
                                <view class="group-actions">
                                    <text class="action-btn delete" @tap="removeGroup(index)">删除</text>
                                </view>
                            </view>
                        </view>
                        
                        <view class="form-item">
                            <view class="add-group-btn" @tap="addGroup">
                                <text class="add-text">+ 添加分组</text>
                            </view>
                        </view>
                    </view>
                </view>
            </view>

            <!-- 第4步：选择项目 -->
            <view v-if="currentStep === 4" class="form-wrapper">
                <view class="form-section">
                    <view class="section-title">比赛项目</view>
                    
                    <view class="form-item">
                        <view class="form-label required">选择项目</view>
                        <view class="items-selection" @tap="openItemSelect">
                            <view class="selection-display">
                                <text class="selection-text" v-if="selectedItems.length === 0">请选择比赛项目</text>
                                <text class="selection-text selected" v-else>已选择 {{ selectedItems.length }} 个项目</text>
                                <text class="selection-arrow">></text>
                            </view>
                        </view>
                        
                        <!-- 已选项目预览 -->
                        <view v-if="selectedItems.length > 0" class="selected-preview">
                            <view class="preview-title">已选项目：</view>
                            <view class="preview-items">
                                <text 
                                    v-for="(item, index) in selectedItems.slice(0, 3)" 
                                    :key="index"
                                    class="preview-item"
                                >
                                    {{ item.name }}
                                </text>
                                <text v-if="selectedItems.length > 3" class="preview-more">
                                    等{{ selectedItems.length }}项
                                </text>
                            </view>
                        </view>
                    </view>
                </view>
            </view>
        </view>

        <!-- 底部操作栏 -->
        <view class="bottom-actions">
            <button 
                v-if="currentStep > 1" 
                class="action-btn prev-btn" 
                @tap="prevStep"
            >
                上一步
            </button>
            <button 
                v-if="currentStep < 4" 
                class="action-btn next-btn" 
                :class="{ 'disabled': !canProceedToNext }"
                :disabled="!canProceedToNext"
                @tap="nextStep"
            >
                下一步
            </button>
            <button 
                v-if="currentStep === 4" 
                class="action-btn submit-btn" 
                :class="{ 'loading': submitLoading }"
                :disabled="submitLoading || !canProceedToNext"
                @tap="handleSubmit"
            >
                {{ submitLoading ? '创建中...' : '创建比赛' }}
            </button>
        </view>

        <!-- 项目选择弹窗 -->
        <view v-if="showItemSelect" class="popup-mask" @tap="showItemSelect = false">
            <view class="popup-container" @tap.stop>
                <view class="popup-header">
                    <text class="popup-title">选择比赛项目</text>
                    <text class="popup-close" @tap="showItemSelect = false">×</text>
                </view>
                <view class="popup-content">
                    <view class="items-list">
                        <label 
                            v-for="item in mockItems" 
                            :key="item.id" 
                            class="item-checkbox"
                        >
                            <checkbox 
                                :value="item.id.toString()" 
                                :checked="isMockItemSelected(item)"
                                @tap="toggleMockItem(item)"
                            />
                            <view class="item-info">
                                <text class="item-name">{{ item.name }}</text>
                            </view>
                        </label>
                    </view>
                </view>
                <view class="popup-footer">
                    <button class="popup-btn cancel" @tap="showItemSelect = false">取消</button>
                    <button class="popup-btn confirm" @tap="confirmItemSelection">
                        确认选择 ({{ tempSelectedItems.length }})
                    </button>
                </view>
            </view>
        </view>
        
        <!-- 主办方和系列赛相关弹窗（复制自create.vue） -->
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
                        <view class="form-label required">类型</view>
                        <radio-group @change="onOrganizerTypeChange" @tap.stop>
                            <view class="radio-group">
                                <label class="radio-item" v-for="option in organizerTypeOptions" :key="option.value" @tap.stop>
                                    <radio 
                                        :value="option.value" 
                                        :checked="organizerForm.organizer_type === option.value"
                                    />
                                    <text class="radio-text">{{ option.label }}</text>
                                </label>
                            </view>
                        </radio-group>
                    </view>
                    <view class="form-item">
                        <view class="form-label required">名称</view>
                        <input 
                            class="form-input" 
                            v-model="organizerForm.organizer_name" 
                            :placeholder="organizerForm.organizer_type === 1 ? '请输入姓名（个人）' : '请输入机构名称（单位）'"
                            maxlength="100"
                        />
                    </view>
                    
                    <!-- 机构证件上传（仅机构显示） -->
                    <view v-if="organizerForm.organizer_type === 2" class="form-item">
                        <view class="form-label">机构证件</view>
                        <view class="upload-container">
                            <!-- 已上传的图片预览 -->
                            <view v-if="organizerForm.organizer_license_img" class="image-preview">
                                <image 
                                    :src="img(organizerForm.organizer_license_img)" 
                                    class="preview-image"
                                    @click="previewOrganizerImage"
                                    mode="aspectFill"
                                />
                                <view class="delete-btn" @click="deleteOrganizerImage">
                                    <text class="nc-iconfont nc-icon-guanbiV6xx"></text>
                                </view>
                            </view>
                            
                            <!-- 上传按钮 -->
                            <view v-else class="upload-btn" @click="chooseOrganizerImage">
                                <text class="nc-iconfont nc-icon-xiangjiV6xx"></text>
                                <text class="upload-text">上传机构证件（可选）</text>
                            </view>
                        </view>
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
        
        <!-- 添加协办方模态框 -->
        <view v-if="showCoOrganizerModal" class="modal-mask" @tap="cancelCoOrganizer">
            <view class="modal-container" @tap.stop>
                <view class="modal-header">
                    <text class="modal-title">{{ editingCoOrganizerIndex >= 0 ? '编辑协办方' : '添加协办方' }}</text>
                    <text class="modal-close" @tap="cancelCoOrganizer">×</text>
                </view>
                <view class="modal-content">
                    <view class="form-item">
                        <view class="form-label required">协办方名称</view>
                        <input 
                            class="form-input" 
                            v-model="coOrganizerForm.organizer_name" 
                            placeholder="请输入协办方名称"
                            maxlength="100"
                        />
                    </view>
                    <view class="form-item">
                        <view class="form-label required">协办方类型</view>
                        <radio-group @change="onCoOrganizerTypeChange">
                            <view class="radio-group">
                                <label class="radio-item" v-for="option in coOrganizerTypeOptions" :key="option.value">
                                    <radio 
                                        :value="option.value" 
                                        :checked="coOrganizerForm.organizer_type === option.value"
                                    />
                                    <text class="radio-text">{{ option.label }}</text>
                                </label>
                            </view>
                        </radio-group>
                    </view>
                    <view class="form-item">
                        <view class="form-label">联系人</view>
                        <input 
                            class="form-input" 
                            v-model="coOrganizerForm.contact_name" 
                            placeholder="请输入联系人"
                            maxlength="50"
                        />
                    </view>
                    <view class="form-item">
                        <view class="form-label">联系电话</view>
                        <input 
                            class="form-input" 
                            v-model="coOrganizerForm.contact_phone" 
                            placeholder="请输入联系电话"
                            maxlength="20"
                        />
                    </view>
                </view>
                <view class="modal-footer">
                    <button class="modal-btn cancel" @tap="cancelCoOrganizer">取消</button>
                    <button class="modal-btn confirm" @tap="confirmCoOrganizer">确定</button>
                </view>
            </view>
        </view>
    </view>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useLoginCheck } from '@/addon/sport/hooks/useLoginCheck'
import { uploadImage } from '@/app/api/system'
import { img } from '@/utils/common'
import { 
    addEvent, 
    getOrganizerList, 
    addOrganizer, 
    getEventSeriesList, 
    addEventSeries
} from '@/addon/sport/api/event'

// 登录检查
const { requireLogin } = useLoginCheck()

// 步骤配置
const steps = [
    { title: '基本信息' },
    { title: '地点信息' },
    { title: '时间安排' },
    { title: '选择项目' }
]

// 当前步骤和最大到达步骤
const currentStep = ref(1)
const maxReachedStep = ref(1)

// 类型定义
interface FormData {
    name: string
    location: string
    lng: string
    lat: string
    full_address: string
    address_detail: string
    start_time: number
    end_time: number
    organizer_id: number
    event_type: number
    series_id: number
    year: number
    age_groups: string[]
    items: Item[]
    custom_groups: CustomGroup[]
    co_organizers: CoOrganizer[]
}

interface Organizer {
    id: number
    organizer_name: string
    organizer_type: number
    contact_name: string
    contact_phone: string
    logo: string
}

interface Series {
    id: number
    name: string
    sort: number
}

interface Item {
    id: number
    name: string
}

interface CustomGroup {
    id?: number
    group_name: string
    sort: number
}

interface CoOrganizer {
    id?: number
    organizer_name: string
    organizer_type: number
    contact_name: string
    contact_phone: string
    logo: string
}

// 表单数据
const formData = ref<FormData>({
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
    age_groups: ['不限年龄'],    // 年龄组设置，默认不限年龄
    items: [],                 // 比赛项目
    custom_groups: [],         // 自定义分组
    co_organizers: []          // 协办方
})

// 添加自定义分组
const handleAddCustomGroup = () => {
    const newGroup: CustomGroup = {
        group_name: '',
        sort: formData.value.custom_groups.length + 1
    }
    formData.value.custom_groups.push(newGroup)
}

// 添加协办方
const handleAddCoOrganizer = () => {
    const newOrganizer: CoOrganizer = {
        organizer_name: '',
        organizer_type: 1,
        contact_name: '',
        contact_phone: '',
        logo: ''
    }
    formData.value.co_organizers.push(newOrganizer)
}

// 删除自定义分组
const handleDeleteCustomGroup = (index: number) => {
    formData.value.custom_groups.splice(index, 1)
    // 重新排序
    formData.value.custom_groups.forEach((group, idx) => {
        group.sort = idx + 1
    })
}

// 删除协办方
const handleDeleteCoOrganizer = (index: number) => {
    formData.value.co_organizers.splice(index, 1)
}

// 更新自定义分组名称
const handleUpdateCustomGroupName = (index: number, value: string) => {
    formData.value.custom_groups[index].group_name = value
}

// 更新协办方信息
const handleUpdateCoOrganizer = (index: number, field: keyof CoOrganizer, value: any) => {
    (formData.value.co_organizers[index] as any)[field] = value
}

// 主办方表单
const organizerForm = ref({
    organizer_name: '',
    contact_name: '',
    contact_phone: '',
    organizer_type: 1,
    organizer_license_img: ''
})

// 系列赛表单
const seriesForm = ref({
    name: '',
    start_year: new Date().getFullYear(),
    description: ''
})

// 协办方表单
const coOrganizerForm = ref({
    organizer_name: '',
    organizer_type: 1, // 1协办单位 2赞助商 3支持单位
    contact_name: '',
    contact_phone: '',
    logo: ''
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

// 协办方类型选项
const coOrganizerTypeOptions = [
    { label: '协办单位', value: 1 },
    { label: '赞助商', value: 2 },
    { label: '支持单位', value: 3 }
]

// 时间相关
const startDateValue = ref('')
const startTimeValue = ref('')
const endDateValue = ref('')
const endTimeValue = ref('')
const startDateDisplay = ref('')
const startTimeDisplay = ref('')
const endDateDisplay = ref('')
const endTimeDisplay = ref('')

// 格式化日期显示
const formatDate = (dateStr: string) => {
    const date = new Date(dateStr)
    return `${date.getFullYear()}年${date.getMonth() + 1}月${date.getDate()}日`
}

// 初始化表单数据
const initFormData = () => {
    // 获取当前日期
    const now = new Date()
    const today = now.toISOString().split('T')[0]
    
    // 从缓存中恢复数据
    const cachedData = uni.getStorageSync('sport_event_form_data')
    if (cachedData) {
        try {
            const parsedData = JSON.parse(cachedData)
            formData.value = {
                ...formData.value,
                ...parsedData
            }
            
            // 恢复时间显示
            if (parsedData.start_time) {
                const startDate = new Date(parsedData.start_time * 1000)
                startDateValue.value = startDate.toISOString().split('T')[0]
                startTimeValue.value = `${String(startDate.getHours()).padStart(2, '0')}:${String(startDate.getMinutes()).padStart(2, '0')}`
                startDateDisplay.value = formatDate(startDateValue.value)
                startTimeDisplay.value = startTimeValue.value
            }
            
            if (parsedData.end_time) {
                const endDate = new Date(parsedData.end_time * 1000)
                endDateValue.value = endDate.toISOString().split('T')[0]
                endTimeValue.value = `${String(endDate.getHours()).padStart(2, '0')}:${String(endDate.getMinutes()).padStart(2, '0')}`
                endDateDisplay.value = formatDate(endDateValue.value)
                endTimeDisplay.value = endTimeValue.value
            }
            
            return
        } catch (e) {
            console.error('解析缓存数据失败:', e)
        }
    }
    
    // 如果没有缓存数据，设置默认值
    formData.value = {
        name: '',
        organizer_id: 0,
        location: '',
        lng: '',
        lat: '',
        full_address: '',
        address_detail: '',
        start_time: 0,
        end_time: 0,
        custom_groups: [],
        event_type: 1,
        series_id: 0,
        year: now.getFullYear(),
        age_groups: ['不限年龄'],
        items: [],
        co_organizers: []
    }
    
    // 设置默认时间
    startDateValue.value = today
    startTimeValue.value = '00:00'
    endDateValue.value = today
    endTimeValue.value = '23:59'
    
    // 更新显示值
    startDateDisplay.value = formatDate(today)
    startTimeDisplay.value = '00:00'
    endDateDisplay.value = formatDate(today)
    endTimeDisplay.value = '23:59'
    
    // 更新时间戳
    updateStartTimestamp()
    updateEndTimestamp()
}

// 保存表单数据到缓存
const saveFormDataToCache = () => {
    try {
        uni.setStorageSync('sport_event_form_data', JSON.stringify(formData.value))
    } catch (e) {
        console.error('保存表单数据到缓存失败:', e)
    }
}

// 监听表单数据变化，自动保存到缓存
watch(formData, () => {
    saveFormDataToCache()
}, { deep: true })

// 表单提交
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
        const submitData: any = {
            name: formData.value.name,
            location: formData.value.location,
            location_detail: finalFullAddress,
            latitude: formData.value.lat ? parseFloat(formData.value.lat) : null,
            longitude: formData.value.lng ? parseFloat(formData.value.lng) : null,
            start_time: formData.value.start_time,
            end_time: formData.value.end_time,
            organizer_id: formData.value.organizer_id,
            event_type: formData.value.event_type,
            series_id: formData.value.series_id,
            year: formData.value.year,
            age_groups: JSON.stringify(formData.value.age_groups),
            age_group_display: formData.value.age_groups.length > 1 && !formData.value.age_groups.includes('不限年龄') ? 1 : 0
        }
        
        const result: any = await addEvent(submitData)
        
        // 提交成功后清除缓存
        uni.removeStorageSync('sport_event_form_data')
        
        uni.showToast({
            title: '创建比赛成功',
            icon: 'success'
        })
        
        // 延迟跳转到赛事详情页面
        setTimeout(() => {
            uni.redirectTo({
                url: `/addon/sport/pages/event/detail?id=${result.data.id}`
            })
        }, 1500)
        
    } catch (error) {
        console.error('创建比赛失败:', error)
    } finally {
        submitLoading.value = false
    }
}

// 验证时间是否有效
const validateTime = () => {
    if (formData.value.start_time >= formData.value.end_time) {
        uni.showToast({
            title: '结束时间必须大于开始时间',
            icon: 'none'
        })
        return false
    }
    return true
}

// 是否可以进入下一步
const canProceedToNext = computed(() => {
    switch (currentStep.value) {
        case 1:
            // 第1步：要求比赛名称和主办方（必填）
            return formData.value.name.trim() !== '' && formData.value.organizer_id > 0
        case 2:
            // 第2步：要求地点信息
            return formData.value.location && formData.value.address_detail
        case 3:
            // 第3步：要求时间信息，且结束时间必须大于开始时间
            return formData.value.start_time > 0 && formData.value.end_time > 0 && validateTime()
        case 4:
            // 第4步：要求选择项目
            return selectedItems.value.length > 0
        default:
            return false
    }
})

// 步骤控制
const goToStep = (step: number) => {
    if (step <= maxReachedStep.value) {
        currentStep.value = step
    }
}

const nextStep = () => {
    if (canProceedToNext.value && currentStep.value < 4) {
        currentStep.value++
        if (currentStep.value > maxReachedStep.value) {
            maxReachedStep.value = currentStep.value
        }
    }
}

const prevStep = () => {
    if (currentStep.value > 1) {
        currentStep.value--
    }
}

/**
 * 日期时间选择
 */
const onStartDateChange = (e: any) => {
    startDateValue.value = e.detail.value
    startDateDisplay.value = formatDate(e.detail.value)
    updateStartTimestamp()
    // 如果结束时间小于开始时间，自动调整结束时间
    if (formData.value.start_time >= formData.value.end_time) {
        const startDate = new Date(startDateValue.value)
        endDateValue.value = startDateValue.value
        endTimeValue.value = '23:59'
        endDateDisplay.value = formatDate(startDateValue.value)
        endTimeDisplay.value = '23:59'
        updateEndTimestamp()
    }
}

const onStartTimeChange = (e: any) => {
    startTimeValue.value = e.detail.value
    startTimeDisplay.value = e.detail.value
    updateStartTimestamp()
    // 如果结束时间小于开始时间，自动调整结束时间
    if (formData.value.start_time >= formData.value.end_time) {
        const [hours, minutes] = startTimeValue.value.split(':')
        const newEndTime = `${parseInt(hours) + 1}:${minutes}`
        endTimeValue.value = newEndTime
        endTimeDisplay.value = newEndTime
        updateEndTimestamp()
    }
}

const onEndDateChange = (e: any) => {
    endDateValue.value = e.detail.value
    endDateDisplay.value = formatDate(e.detail.value)
    updateEndTimestamp()
    // 验证时间
    validateTime()
}

const onEndTimeChange = (e: any) => {
    endTimeValue.value = e.detail.value
    endTimeDisplay.value = e.detail.value
    updateEndTimestamp()
    // 验证时间
    validateTime()
}

/**
 * 更新开始时间戳
 */
const updateStartTimestamp = () => {
    if (startDateValue.value && startTimeValue.value) {
        const [hours, minutes] = startTimeValue.value.split(':')
        const date = new Date(startDateValue.value)
        date.setHours(parseInt(hours), parseInt(minutes))
        formData.value.start_time = Math.floor(date.getTime() / 1000)
    }
}

/**
 * 更新结束时间戳
 */
const updateEndTimestamp = () => {
    if (endDateValue.value && endTimeValue.value) {
        const [hours, minutes] = endTimeValue.value.split(':')
        const date = new Date(endDateValue.value)
        date.setHours(parseInt(hours), parseInt(minutes))
        formData.value.end_time = Math.floor(date.getTime() / 1000)
    }
}

/**
 * 选择地址
 */
const chooseLocation = () => {
    console.log('开始选择地址')
    
    // #ifdef MP-WEIXIN
    // 检查是否支持隐私协议API
    if (typeof (global as any).wx !== 'undefined' && (global as any).wx.requirePrivacyAuthorize) {
        (global as any).wx.requirePrivacyAuthorize({
            success: () => {
                console.log('隐私协议已同意，可以选择地址')
                performChooseLocation()
            },
            fail: () => {
                console.log('用户拒绝了隐私协议')
                uni.showToast({
                    title: '需要同意隐私协议才能选择地址',
                    icon: 'none'
                })
            }
        })
    } else {
        // 旧版本或不支持隐私协议的情况下直接调用
        performChooseLocation()
    }
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
 * 执行地址选择
 */
const performChooseLocation = () => {
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
                } else if (res.errMsg.includes('privacy agreement')) {
                    message = '请在小程序管理后台配置隐私协议'
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
 * 赛事类型变化
 */
const handleEventTypeChange = (value: number) => {
    console.log('赛事类型变化:', value, '当前系列赛列表长度:', seriesList.value.length)
    formData.value.event_type = value
    if (value === 1) {
        formData.value.series_id = 0
        console.log('选择独立赛事，清空系列赛ID')
    }
    // 如果选择系列赛事且还没有系列赛数据，加载系列赛列表
    if (value === 2) {
        console.log('选择系列赛事')
        if (!seriesList.value.length) {
            console.log('系列赛列表为空，开始加载...')
            loadSeriesList()
        } else {
            console.log('系列赛列表已存在，无需重新加载')
        }
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
    console.log('打开系列赛选择器, 系列赛列表:', seriesList.value)
    if (!seriesList.value.length) {
        uni.showToast({
            title: '暂无系列赛数据',
            icon: 'none'
        })
        return
    }
    tempSeriesIndex.value = selectedSeriesIndex.value
    showSeriesPicker.value = true
    console.log('显示系列赛选择器')
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
        const response: any = await getOrganizerList()
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
        console.log('开始加载系列赛列表...')
        const response: any = await getEventSeriesList()
        console.log('系列赛列表响应:', response)
        seriesList.value = response.data || []
        console.log('系列赛列表加载完成:', seriesList.value.length, '条记录')
    } catch (error) {
        console.error('加载系列赛列表失败:', error)
        seriesList.value = []
    }
}

/**
 * 主办方类型变更
 */
const onOrganizerTypeChange = (e: any) => {
    const newType = parseInt(e.detail.value)
    
    // 只有当类型真正改变时才清空证件图片
    if (organizerForm.value.organizer_type !== newType) {
        organizerForm.value.organizer_license_img = ''
    }
    
    organizerForm.value.organizer_type = newType
    console.log('主办方类型已更新为:', newType)
}

/**
 * 选择主办方证件图片
 */
const chooseOrganizerImage = () => {
    // #ifdef MP-WEIXIN
    // 检查是否支持隐私协议API
    if (typeof (global as any).wx !== 'undefined' && (global as any).wx.requirePrivacyAuthorize) {
        (global as any).wx.requirePrivacyAuthorize({
            success: () => {
                console.log('隐私协议已同意，可以选择图片')
                performChooseImage()
            },
            fail: () => {
                console.log('用户拒绝了隐私协议')
                uni.showToast({
                    title: '需要同意隐私协议才能选择图片',
                    icon: 'none'
                })
            }
        })
    } else {
        // 旧版本或不支持隐私协议的情况下直接调用
        performChooseImage()
    }
    // #endif
    
    // #ifndef MP-WEIXIN
    performChooseImage()
    // #endif
}

/**
 * 执行图片选择
 */
const performChooseImage = () => {
    uni.chooseImage({
        count: 1,
        sizeType: ['original', 'compressed'],
        sourceType: ['camera', 'album'],
        success: (res) => {
            uploadOrganizerImageFile(res.tempFilePaths[0])
        },
        fail: (err) => {
            console.error('选择图片失败:', err)
            let message = '选择图片失败'
            if (err.errMsg && err.errMsg.includes('privacy agreement')) {
                message = '请在小程序管理后台配置隐私协议'
            }
            uni.showToast({
                title: message,
                icon: 'none'
            })
        }
    })
}

/**
 * 上传主办方证件图片
 */
const uploadOrganizerImageFile = (filePath: string) => {
    uni.showLoading({ title: '上传中...' })
    
    uploadImage({
        filePath: filePath,
        name: 'file'
    }).then((res: any) => {
        uni.hideLoading()
        organizerForm.value.organizer_license_img = res.data.url
        uni.showToast({ title: '上传成功', icon: 'success' })
    }).catch(err => {
        uni.hideLoading()
        uni.showToast({ title: '上传失败', icon: 'none' })
        console.error('上传失败:', err)
    })
}

/**
 * 预览主办方证件图片
 */
const previewOrganizerImage = () => {
    uni.previewImage({
        urls: [img(organizerForm.value.organizer_license_img)],
        current: 0
    })
}

/**
 * 删除主办方证件图片
 */
const deleteOrganizerImage = () => {
    uni.showModal({
        title: '提示',
        content: '确定要删除这张图片吗？',
        success: (res) => {
            if (res.confirm) {
                organizerForm.value.organizer_license_img = ''
            }
        }
    })
}

/**
 * 添加主办方
 */
const addOrganizerConfirm = async () => {
    // 移除不必要的验证提示，因为输入框已经有placeholder提示了
    if (!organizerForm.value.organizer_name.trim()) {
        return // 直接返回，不显示toast
    }
    
    try {
        const params = {
            ...organizerForm.value
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
            organizer_type: 1,
            organizer_license_img: ''
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
        organizer_type: 1,
        organizer_license_img: ''
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

// 添加分组
const addGroup = () => {
    formData.value.custom_groups.push({
        group_name: '',
        sort: formData.value.custom_groups.length + 1
    })
}

// 删除分组
const removeGroup = (index: number) => {
    formData.value.custom_groups.splice(index, 1)
    // 重新排序
    formData.value.custom_groups.forEach((group, idx) => {
        group.sort = idx + 1
    })
}

// 协办方处理
const getCoOrganizerTypeText = (type: number) => {
    const option = coOrganizerTypeOptions.find(item => item.value === type)
    return option ? option.label : '未知类型'
}

const addCoOrganizer = () => {
    editingCoOrganizerIndex.value = -1
    coOrganizerForm.value = {
        organizer_name: '',
        organizer_type: 1,
        contact_name: '',
        contact_phone: '',
        logo: ''
    }
    showCoOrganizerModal.value = true
}

const editCoOrganizer = (index: number) => {
    editingCoOrganizerIndex.value = index
    const coOrganizer = formData.value.co_organizers[index]
    coOrganizerForm.value = { ...coOrganizer }
    showCoOrganizerModal.value = true
}

const deleteCoOrganizer = (index: number) => {
    uni.showModal({
        title: '确认删除',
        content: '确定要删除这个协办方吗？',
        success: (res) => {
            if (res.confirm) {
                formData.value.co_organizers.splice(index, 1)
            }
        }
    })
}

const confirmCoOrganizer = () => {
    if (!coOrganizerForm.value.organizer_name.trim()) {
        uni.showToast({
            title: '请输入协办方名称',
            icon: 'none'
        })
        return
    }
    
    if (editingCoOrganizerIndex.value >= 0) {
        // 编辑模式
        formData.value.co_organizers[editingCoOrganizerIndex.value] = { ...coOrganizerForm.value }
    } else {
        // 新增模式
        formData.value.co_organizers.push({ ...coOrganizerForm.value })
    }
    
    showCoOrganizerModal.value = false
}

const cancelCoOrganizer = () => {
    showCoOrganizerModal.value = false
    editingCoOrganizerIndex.value = -1
}

// 协办方类型变更
const onCoOrganizerTypeChange = (e: any) => {
    coOrganizerForm.value.organizer_type = parseInt(e.detail.value)
}

// 项目选择
const openItemSelect = () => {
    // 初始化临时选择数据
    tempSelectedItems.value = [...selectedItems.value]
    showItemSelect.value = true
}

const isMockItemSelected = (item: any) => {
    return tempSelectedItems.value.some(selected => selected.id === item.id)
}

const toggleMockItem = (item: any) => {
    const index = tempSelectedItems.value.findIndex(selected => selected.id === item.id)
    if (index > -1) {
        tempSelectedItems.value.splice(index, 1)
    } else {
        tempSelectedItems.value.push(item)
    }
}

const confirmItemSelection = () => {
    selectedItems.value = [...tempSelectedItems.value]
    showItemSelect.value = false
}

/**
 * 最终提交验证
 */
const validateSubmitForm = () => {
    if (!formData.value.name.trim()) {
        uni.showToast({
            title: '请输入比赛名称',
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
    
    if (!formData.value.location) {
        uni.showToast({
            title: '请选择地点',
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
    
    if (selectedItems.value.length === 0) {
        uni.showToast({
            title: '请选择比赛项目',
            icon: 'none'
        })
        return false
    }
    
    return true
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
    }, '/addon/sport/pages/event/create_simple')

    // 初始化项目选择
    tempSelectedItems.value = [...selectedItems.value]
})

// 表单数据
const selectedItems = ref<Item[]>([])
const showItemSelect = ref(false)
const tempSelectedItems = ref<Item[]>([])

// 模拟项目数据
const mockItems = [
    { id: 1, name: '100米短跑' },
    { id: 2, name: '200米短跑' },
    { id: 3, name: '跳高' },
    { id: 4, name: '跳远' },
    { id: 5, name: '铅球' },
    { id: 6, name: '4x100米接力' }
]

// 提交状态
const submitLoading = ref(false)

// 编辑中的协办方索引
const editingCoOrganizerIndex = ref(-1)

// 选择器相关
const showOrganizerPicker = ref(false)
const showSeriesPicker = ref(false)
const showOrganizerModal = ref(false)
const showSeriesModal = ref(false)
const showCoOrganizerModal = ref(false)

// 数据列表
const organizerList = ref<Organizer[]>([])
const seriesList = ref<Series[]>([])

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

// 验证表单
const validateForm = () => {
    if (!formData.value.name) {
        uni.showToast({
            title: '请输入比赛名称',
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
    
    if (!formData.value.location) {
        uni.showToast({
            title: '请选择比赛地点',
            icon: 'none'
        })
        return false
    }
    
    if (!formData.value.start_time || !formData.value.end_time) {
        uni.showToast({
            title: '请选择比赛时间',
            icon: 'none'
        })
        return false
    }
    
    if (formData.value.start_time >= formData.value.end_time) {
        uni.showToast({
            title: '结束时间必须大于开始时间',
            icon: 'none'
        })
        return false
    }
    
    return true
}
</script>

<style lang="scss" scoped>
.create-event-page {
    min-height: 100vh;
    background-color: #f8faff;
}

.steps-header {
    background: white;
    padding: 40rpx 32rpx;
    border-bottom: 1px solid #f0f0f0;
    
    .steps-nav {
        display: flex;
        align-items: center;
        justify-content: space-between;
        position: relative;
        
        .step-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            flex: 1;
            position: relative;
            cursor: pointer;
            
            &.clickable {
                .step-circle {
                    cursor: pointer;
                }
            }
            
            .step-circle {
                width: 60rpx;
                height: 60rpx;
                border-radius: 50%;
                background-color: #e0e0e0;
                color: #999;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 24rpx;
                margin-bottom: 16rpx;
                transition: all 0.3s ease;
                position: relative;
                z-index: 2;
                
                .step-number {
                    font-weight: bold;
                }
                
                .step-check {
                    font-size: 28rpx;
                    color: white;
                }
            }
            
            &.active .step-circle {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                box-shadow: 0 4rpx 12rpx rgba(102, 126, 234, 0.3);
            }
            
            &.completed .step-circle {
                background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
                color: white;
            }
            
            .step-title {
                font-size: 24rpx;
                color: #999;
                text-align: center;
                transition: all 0.3s ease;
            }
            
            &.active .step-title {
                color: #667eea;
                font-weight: bold;
            }
            
            &.completed .step-title {
                color: #4CAF50;
            }
            
            .step-line {
                position: absolute;
                top: 30rpx;
                left: 50%;
                width: 100%;
                height: 2rpx;
                background-color: #e0e0e0;
                z-index: 1;
                transition: all 0.3s ease;
            }
            
            &.completed .step-line {
                background-color: #4CAF50;
            }
        }
    }
}

.form-container {
    padding: 32rpx;
    margin-bottom: 120rpx;
}

.form-wrapper {
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

.radio-group {
    display: flex;
    flex-direction: row;
    gap: 32rpx;
    
    .radio-item {
        display: flex;
        align-items: center;
        cursor: pointer;
        
        radio {
            margin-right: 16rpx;
        }
        
        .radio-text {
            font-size: 28rpx;
            color: #333;
        }
        
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
}

.groups-container {
    .group-item {
        display: flex;
        align-items: center;
        margin-bottom: 16rpx;
        gap: 16rpx;
        
        .group-input {
            flex: 1;
        }
        
        .remove-btn {
            padding: 12rpx 20rpx;
            background-color: #ff4757;
            color: white;
            border-radius: 8rpx;
            font-size: 24rpx;
            
            .remove-text {
                color: white;
            }
        }
    }
    
    .add-group-btn {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8rpx;
        padding: 20rpx;
        border: 2rpx dashed #007aff;
        border-radius: 12rpx;
        color: #007aff;
        background-color: #f8faff;
        
        .add-icon {
            font-size: 28rpx;
            font-weight: bold;
        }
        
        .add-text {
            font-size: 28rpx;
        }
    }
}

.items-selection {
    padding: 24rpx 0;
    
    .selection-display {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 20rpx 0;
        border-bottom: 1px solid #f0f0f0;
        
        .selection-text {
            font-size: 28rpx;
            color: #999;
            
            &.selected {
                color: #007aff;
            }
        }
        
        .selection-arrow {
            font-size: 28rpx;
            color: #999;
        }
    }
}

.selected-preview {
    margin-top: 20rpx;
    
    .preview-title {
        font-size: 26rpx;
        color: #666;
        margin-bottom: 12rpx;
    }
    
    .preview-items {
        display: flex;
        flex-wrap: wrap;
        gap: 12rpx;
        
        .preview-item {
            padding: 8rpx 16rpx;
            background-color: #e3f2fd;
            border: 1rpx solid #bbdefb;
            border-radius: 20rpx;
            font-size: 24rpx;
            color: #1976d2;
        }
    }
}

.bottom-actions {
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    background: white;
    padding: 32rpx;
    border-top: 1px solid #f0f0f0;
    display: flex;
    gap: 24rpx;
    
    .action-btn {
        flex: 1;
        height: 88rpx;
        border: none;
        border-radius: 44rpx;
        font-size: 32rpx;
        font-weight: bold;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.3s ease;
        
        &.prev-btn {
            background-color: #f8f8f8;
            color: #666;
        }
        
        &.next-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            
            &.disabled {
                background: #ccc;
                color: #999;
            }
        }
        
        &.submit-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            
            &.loading {
                opacity: 0.7;
            }
            
            &:disabled {
                background: #ccc;
                color: #999;
            }
        }
    }
}

.popup-mask {
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

.popup-container {
    background: white;
    border-radius: 16rpx;
    width: 100%;
    max-width: 600rpx;
    max-height: 80vh;
    overflow: hidden;
}

.popup-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 32rpx;
    border-bottom: 1px solid #f0f0f0;
    
    .popup-title {
        font-size: 32rpx;
        font-weight: bold;
        color: #333;
    }
    
    .popup-close {
        font-size: 48rpx;
        color: #999;
        cursor: pointer;
    }
}

.popup-content {
    padding: 32rpx;
    max-height: 50vh;
    overflow-y: auto;
}

.items-list {
    .item-checkbox {
        display: flex;
        align-items: center;
        padding: 16rpx 0;
        border-bottom: 1px solid #f0f0f0;
        
        &:last-child {
            border-bottom: none;
        }
        
        checkbox {
            margin-right: 16rpx;
        }
        
        .item-info {
            flex: 1;
            
            .item-name {
                font-size: 28rpx;
                color: #333;
            }
        }
    }
}

.popup-footer {
    display: flex;
    border-top: 1px solid #f0f0f0;
    
    .popup-btn {
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

/* 图片上传相关样式 */
.upload-container {
    margin-top: 20rpx;
    
    .image-preview {
        position: relative;
        width: 200rpx;
        height: 200rpx;
        border-radius: 10rpx;
        overflow: hidden;
        
        .preview-image {
            width: 100%;
            height: 100%;
        }
        
        .delete-btn {
            position: absolute;
            top: 0;
            right: 0;
            width: 40rpx;
            height: 40rpx;
            background-color: rgba(0, 0, 0, 0.6);
            border-radius: 0 10rpx 0 20rpx;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24rpx;
        }
    }
    
    .upload-btn {
        width: 200rpx;
        height: 200rpx;
        border: 2rpx dashed #ddd;
        border-radius: 10rpx;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        color: #999;
        
        .nc-iconfont {
            font-size: 60rpx;
            margin-bottom: 20rpx;
        }
        
        .upload-text {
            font-size: 24rpx;
            text-align: center;
        }
    }
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

/* 协办方相关样式 */
.co-organizer-container {
    .co-organizer-empty {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 24rpx 0;
        
        .empty-text {
            color: #999;
            font-size: 28rpx;
        }
        
        .add-link {
            color: #007aff;
            font-size: 28rpx;
        }
    }
    
    .co-organizer-list {
        .co-organizer-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 24rpx 0;
            border-bottom: 1px solid #f0f0f0;
            
            &:last-child {
                border-bottom: none;
            }
            
            .co-organizer-info {
                flex: 1;
                
                .co-organizer-name {
                    display: block;
                    font-size: 28rpx;
                    color: #333;
                    margin-bottom: 8rpx;
                }
                
                .co-organizer-type {
                    display: block;
                    font-size: 24rpx;
                    color: #666;
                }
            }
            
            .co-organizer-actions {
                display: flex;
                gap: 16rpx;
                
                .action-btn {
                    padding: 8rpx 16rpx;
                    border-radius: 8rpx;
                    font-size: 24rpx;
                    
                    &.edit {
                        background-color: #e3f2fd;
                        color: #2196f3;
                    }
                    
                    &.delete {
                        background-color: #ffebee;
                        color: #f44336;
                    }
                }
            }
        }
        
        .add-co-organizer {
            padding: 24rpx 0;
            text-align: center;
            
            .add-text {
                color: #007aff;
                font-size: 28rpx;
            }
        }
    }
}

/* 分组相关样式 */
.empty-groups {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 24rpx 0;
    
    .empty-text {
        color: #999;
        font-size: 28rpx;
    }
    
    .add-link {
        color: #007aff;
        font-size: 28rpx;
    }
}

.group-item {
    display: flex;
    align-items: center;
    gap: 16rpx;
    
    .group-input {
        flex: 1;
    }
    
    .group-actions {
        .action-btn {
            padding: 8rpx 16rpx;
            border-radius: 8rpx;
            font-size: 24rpx;
            background-color: #ffebee;
            color: #f44336;
        }
    }
}

.add-group-btn {
    padding: 24rpx 0;
    text-align: center;
    border: 2rpx dashed #e0e0e0;
    border-radius: 12rpx;
    margin-top: 16rpx;
    
    .add-text {
        color: #007aff;
        font-size: 28rpx;
    }
}

.group-default {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 24rpx 0;
    
    .group-default-text {
        color: #999;
        font-size: 28rpx;
    }
    
    .add-link {
        color: #007aff;
        font-size: 28rpx;
    }
}
</style> 
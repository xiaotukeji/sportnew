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
                
                <!-- 年龄组设置 -->
                <view class="form-section">
                    <view class="section-title">年龄组设置</view>
                    
                    <!-- 比赛项目选择 -->
                    <u-cell-group :border="false" customStyle="margin-top: 15px;">
                        <u-cell title="比赛项目" :isLink="true" @click="showItemSelect = true" :border="false">
                            <template #value>
                                <text class="text-muted" v-if="!formData.items || formData.items.length === 0">请选择比赛项目</text>
                                <text class="text-primary" v-else>已选择{{ formData.items.length }}项</text>
                            </template>
                        </u-cell>
                    </u-cell-group>
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
        
        <!-- 项目选择弹窗（灵活多级结构） -->
        <u-popup v-model="showItemSelect" mode="bottom" height="70%" closeable title="选择比赛项目">
            <view class="popup-content">
                <!-- 年龄组选择 -->
                <view class="age-group-section">
                    <text class="section-title">年龄组设置</text>
                    <view class="age-group-tips">选择年龄组后，将自动为项目名称添加相应前缀</view>
                    <view class="age-group-list">
                        <label class="checkbox-item" v-for="group in ageGroups" :key="group.code">
                            <checkbox 
                                :value="group.code" 
                                :checked="formData.age_groups.includes(group.code)"
                                @tap="toggleAgeGroup(group.code)"
                            />
                            <text>{{ group.name }}</text>
                        </label>
                    </view>
                    
                    <!-- 年龄组预览 -->
                    <view v-if="formData.age_groups.length > 0" class="age-preview">
                        <text class="preview-title">项目名称预览：</text>
                        <text class="preview-text">
                            {{ generateAgeGroupPrefix() }}男子100米自由泳
                        </text>
                    </view>
                </view>

                <!-- 智能分类选择 -->
                <view class="category-section">
                    <text class="section-title">项目分类</text>
                    
                    <!-- 分类树形结构 -->
                    <scroll-view scroll-y class="category-scroll">
                        <view class="category-tree">
                            <view v-for="category in categoryTree" :key="category.id" class="category-level-1">
                                <!-- 一级分类 -->
                                <view 
                                    class="category-item level-1" 
                                    :class="{ 'expanded': expandedCategories.includes(category.id) }"
                                    @tap="handleCategoryTap(category)"
                                >
                                    <u-icon 
                                        v-if="category.structure_type !== 'level_2'"
                                        :name="expandedCategories.includes(category.id) ? 'arrow-down' : 'arrow-right'" 
                                        size="16"
                                    />
                                    <text>{{ category.name }}</text>
                                    <text class="category-info">({{ getStructureInfo(category.structure_type) }})</text>
                                </view>

                                <!-- 二级分类 -->
                                <view 
                                    v-if="expandedCategories.includes(category.id) && category.children" 
                                    class="category-level-2"
                                >
                                    <view 
                                        v-for="subCategory in category.children" 
                                        :key="subCategory.id" 
                                        class="category-level-2-wrapper"
                                    >
                                        <view 
                                            class="category-item level-2"
                                            :class="{ 'expanded': expandedCategories.includes(subCategory.id) }"
                                            @tap="handleCategoryTap(subCategory)"
                                        >
                                            <u-icon 
                                                v-if="!subCategory.is_final_level"
                                                :name="expandedCategories.includes(subCategory.id) ? 'arrow-down' : 'arrow-right'" 
                                                size="14"
                                            />
                                            <text>{{ subCategory.name }}</text>
                                            <text v-if="subCategory.is_final_level" class="final-level-tag">可选项目</text>
                                        </view>

                                        <!-- 三级分类 -->
                                        <view 
                                            v-if="expandedCategories.includes(subCategory.id) && subCategory.children" 
                                            class="category-level-3"
                                        >
                                            <view 
                                                v-for="thirdCategory in subCategory.children" 
                                                :key="thirdCategory.id"
                                                class="category-item level-3"
                                                :class="{ 'final-level': thirdCategory.is_final_level }"
                                                @tap="handleCategoryTap(thirdCategory)"
                                            >
                                                <text>{{ thirdCategory.name }}</text>
                                                <text v-if="thirdCategory.is_final_level" class="final-level-tag">可选项目</text>
                                            </view>
                                        </view>
                                    </view>
                                </view>
                            </view>
                        </view>
                    </scroll-view>
                </view>

                <!-- 项目选择列表 -->
                <view v-if="currentCategoryItems.length > 0" class="items-section">
                    <text class="section-title">
                        可选项目 ({{ currentCategoryName }})
                        <text class="item-count">{{ currentCategoryItems.length }}个</text>
                    </text>
                    
                    <scroll-view scroll-y class="items-scroll">
                        <view class="items-list">
                            <label 
                                v-for="item in currentCategoryItems" 
                                :key="item.id" 
                                class="item-checkbox"
                            >
                                <checkbox 
                                    :value="item.id.toString()" 
                                    :checked="isItemSelected(item.id)"
                                    @tap="toggleItem(item)"
                                />
                                <view class="item-info">
                                    <text class="item-name">{{ item.name }}</text>
                                    <text class="item-desc">{{ item.description }}</text>
                                </view>
                            </label>
                        </view>
                    </scroll-view>
                </view>

                <!-- 已选项目预览 -->
                <view v-if="selectedItems.length > 0" class="selected-items-section">
                    <text class="section-title">已选项目 ({{ selectedItems.length }}项)</text>
                    <scroll-view scroll-x class="selected-items-scroll">
                        <view class="selected-items">
                            <view 
                                v-for="item in selectedItems" 
                                :key="item.id" 
                                class="selected-item-tag"
                                @tap="removeItem(item.id)"
                            >
                                <text>{{ item.display_name || item.name }}</text>
                                <u-icon name="close" size="12" color="#fff"></u-icon>
                            </view>
                        </view>
                    </scroll-view>
                </view>

                <!-- 底部按钮 -->
                <view class="popup-footer">
                    <u-button 
                        type="default" 
                        size="large" 
                        @click="showItemSelect = false"
                        customStyle="margin-right: 10px; flex: 1;"
                    >
                        取消
                    </u-button>
                    <u-button 
                        type="primary" 
                        size="large" 
                        @click="confirmItemSelection"
                        customStyle="flex: 2;"
                    >
                        确认选择 ({{ selectedItems.length }})
                    </u-button>
                </view>
            </view>
        </u-popup>
        
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
                        <radio-group @change="onOrganizerTypeChange">
                            <view class="radio-group">
                                <label class="radio-item" v-for="option in organizerTypeOptions" :key="option.value">
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
                    <!-- 调试信息：organizerForm.organizer_type = {{ organizerForm.organizer_type }} -->
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
    </view>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useLoginCheck } from '@/addon/sport/hooks/useLoginCheck'
import { uploadImage } from '@/app/api/system'
import { img } from '@/utils/common'
import { 
    addEvent, 
    getOrganizerList, 
    addOrganizer, 
    getEventSeriesList, 
    addEventSeries,
    getCategoryList,
    getBaseItems
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
    organizer_id: 0,           // 主办方ID
    event_type: 1,             // 赛事类型：1独立赛事 2系列赛事
    series_id: 0,              // 系列赛ID
    year: new Date().getFullYear(), // 举办年份
    age_groups: ['不限年龄'],    // 年龄组设置，默认不限年龄
    items: [] as any[]         // 比赛项目
})

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

// 选项数据
const organizerTypeOptions = [
    { label: '个人', value: 1 },
    { label: '单位', value: 2 }
]

const eventTypeOptions = [
    { label: '独立赛事', value: 1 },
    { label: '系列赛事', value: 2 }
]

// 年龄组选项
const ageGroupOptions = [
    { label: '不限年龄', value: '不限年龄' },
    { label: '青少年', value: '青少年' },
    { label: '成年', value: '成年' },
    { label: '老年', value: '老年' }
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

// 年龄组相关计算属性
const selectedAgeGroups = computed(() => {
    return formData.value.age_groups.filter(group => group !== '不限年龄')
})

// 提交状态
const submitLoading = ref(false)

// 项目选择弹窗
const showItemSelect = ref(false)

// 智能分类相关
const categoryTree = ref<any[]>([]) // 分类树结构
const expandedCategories = ref<number[]>([]) // 展开的分类ID
const currentCategoryItems = ref<any[]>([]) // 当前分类的项目
const currentCategoryName = ref<string>('') // 当前分类名称
const selectedItems = ref<any[]>([]) // 已选择的项目

// 年龄组数据
const ageGroups = [
    { name: '青少年', code: 'youth' },
    { name: '成年', code: 'adult' },
    { name: '老年', code: 'elder' }
]

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

/**
 * 年龄组处理
 */
const handleAgeGroupChange = (value: string) => {
    const currentGroups = [...formData.value.age_groups]
    
    if (value === '不限年龄') {
        // 选择不限年龄时，清空其他选项
        formData.value.age_groups = ['不限年龄']
    } else {
        // 选择其他年龄组时，移除不限年龄
        const index = currentGroups.indexOf(value)
        if (index > -1) {
            // 已选中，移除
            currentGroups.splice(index, 1)
        } else {
            // 未选中，添加
            currentGroups.push(value)
        }
        
        // 移除不限年龄选项
        const noLimitIndex = currentGroups.indexOf('不限年龄')
        if (noLimitIndex > -1) {
            currentGroups.splice(noLimitIndex, 1)
        }
        
        // 如果没有选择任何年龄组，默认为不限年龄
        if (currentGroups.length === 0) {
            formData.value.age_groups = ['不限年龄']
        } else {
            formData.value.age_groups = currentGroups
        }
    }
    
    console.log('年龄组变更:', formData.value.age_groups)
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
        const response: any = await getEventSeriesList()
        seriesList.value = response.data || []
    } catch (error) {
        console.error('加载系列赛列表失败:', error)
        seriesList.value = []
    }
}

/**
 * 主办方类型变更
 */
const onOrganizerTypeChange = (e: any) => {
    console.log('主办方类型变更:', e.detail.value, typeof e.detail.value)
    organizerForm.value.organizer_type = parseInt(e.detail.value)
    console.log('设置后的类型:', organizerForm.value.organizer_type, typeof organizerForm.value.organizer_type)
    // 切换类型时清空证件图片
    organizerForm.value.organizer_license_img = ''
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
    if (!organizerForm.value.organizer_name.trim()) {
        uni.showToast({
            title: '请输入主办方名称',
            icon: 'none'
        })
        return
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
        
        // 提交数据 - 映射字段名
        const submitData: any = {
            name: formData.value.name,
            location: formData.value.location,
            location_detail: finalFullAddress, // 详细地址
            latitude: formData.value.lat ? parseFloat(formData.value.lat) : null,   // 纬度
            longitude: formData.value.lng ? parseFloat(formData.value.lng) : null,  // 经度
            start_time: formData.value.start_time,
            end_time: formData.value.end_time,
            organizer_id: formData.value.organizer_id,
            event_type: formData.value.event_type,
            series_id: formData.value.series_id,
            year: formData.value.year,
            age_groups: JSON.stringify(formData.value.age_groups), // 年龄组数据
            age_group_display: formData.value.age_groups.length > 1 && !formData.value.age_groups.includes('不限年龄') ? 1 : 0
        }
        
        console.log('提交数据:', submitData)
        
        const result: any = await addEvent(submitData)
        
        uni.showToast({
            title: '创建比赛成功',
            icon: 'success'
        })
        
        console.log('创建比赛成功，比赛ID:', result.data.id)
        
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

/**
 * 智能分类相关方法
 */

// 获取结构信息描述
const getStructureInfo = (structureType: string) => {
    const typeMap: Record<string, string> = {
        'level_2': '直接选择',
        'level_3': '三级结构', 
        'level_4': '四级结构'
    }
    return typeMap[structureType] || '未知结构'
}

// 年龄组切换
const toggleAgeGroup = (code: string) => {
    const index = formData.value.age_groups.indexOf(code)
    if (index > -1) {
        formData.value.age_groups.splice(index, 1)
    } else {
        formData.value.age_groups.push(code)
    }
}

// 生成年龄组前缀
const generateAgeGroupPrefix = () => {
    if (formData.value.age_groups.length === 0 || formData.value.age_groups.includes('不限年龄')) {
        return ''
    }
    if (formData.value.age_groups.length === 1) {
        const groupMap: Record<string, string> = {
            'youth': '青少年',
            'adult': '成年',
            'elder': '老年'
        }
        return groupMap[formData.value.age_groups[0]] || ''
    }
    return '多年龄组'
}

// 处理分类点击
const handleCategoryTap = async (category: any) => {
    console.log('点击分类:', category.name, '结构类型:', category.structure_type, '是否最终级别:', category.is_final_level)
    
    // 如果是最终级别或者直接有项目的分类，加载项目
    if (category.is_final_level || category.has_items) {
        await loadCategoryItems(category.id, category.name)
        return
    }
    
    // 如果是中间级别，展开/折叠子分类
    const index = expandedCategories.value.indexOf(category.id)
    if (index > -1) {
        expandedCategories.value.splice(index, 1)
    } else {
        expandedCategories.value.push(category.id)
    }
}

// 加载分类项目
const loadCategoryItems = async (categoryId: number, categoryName: string) => {
    try {
        uni.showLoading({ title: '加载项目...' })
        
        const response = await getBaseItems({ category_id: categoryId })
        if (response.code === 1) {
            currentCategoryItems.value = response.data || []
            currentCategoryName.value = categoryName
            
            console.log(`加载 ${categoryName} 项目:`, currentCategoryItems.value.length, '个')
            
            if (currentCategoryItems.value.length === 0) {
                uni.showToast({ title: '该分类暂无可选项目', icon: 'none' })
            }
        } else {
            console.error('加载项目失败:', response.msg)
            uni.showToast({ title: response.msg || '加载项目失败', icon: 'none' })
        }
    } catch (error) {
        console.error('加载项目异常:', error)
        uni.showToast({ title: '加载项目失败', icon: 'none' })
    } finally {
        uni.hideLoading()
    }
}

// 加载分类树
const loadCategoryTree = async () => {
    try {
        const response = await getCategoryList()
        if (response.code === 1) {
            categoryTree.value = response.data || []
            
            // 自动展开有默认展开需求的分类
            categoryTree.value.forEach(category => {
                if (category.structure_type === 'level_3' || category.structure_type === 'level_4') {
                    // 可以根据需要设置默认展开的分类
                    if (['球类', '体操类'].includes(category.name)) {
                        expandedCategories.value.push(category.id)
                    }
                }
            })
            
            console.log('分类树加载完成:', categoryTree.value.length, '个一级分类')
        } else {
            console.error('加载分类失败:', response.msg)
            uni.showToast({ title: '加载分类失败', icon: 'none' })
        }
    } catch (error) {
        console.error('加载分类异常:', error)
        uni.showToast({ title: '加载分类失败', icon: 'none' })
    }
}

// 判断项目是否已选择
const isItemSelected = (itemId: number) => {
    return selectedItems.value.some(item => item.id === itemId)
}

// 切换项目选择
const toggleItem = (item: any) => {
    const index = selectedItems.value.findIndex(selected => selected.id === item.id)
    if (index > -1) {
        selectedItems.value.splice(index, 1)
    } else {
        // 生成带年龄组前缀的显示名称
        const displayName = generateItemDisplayName(item.name)
        selectedItems.value.push({
            ...item,
            display_name: displayName
        })
    }
}

// 移除已选项目
const removeItem = (itemId: number) => {
    const index = selectedItems.value.findIndex(item => item.id === itemId)
    if (index > -1) {
        selectedItems.value.splice(index, 1)
    }
}

// 生成项目显示名称（包含年龄组前缀）
const generateItemDisplayName = (originalName: string) => {
    const prefix = generateAgeGroupPrefix()
    return prefix + originalName
}

// 确认项目选择
const confirmItemSelection = () => {
    // 生成最终的项目数据，包含年龄组信息
    const finalItems = selectedItems.value.map(item => ({
        base_item_id: item.id,
        name: item.display_name || item.name,
        original_name: item.name,
        category_id: item.category_id,
        description: item.description,
        rules: item.rules,
        equipment: item.equipment,
        venue_requirements: item.venue_requirements
    }))
    
    formData.value.items = finalItems
    showItemSelect.value = false
    
    console.log('确认选择项目:', finalItems.length, '个')
    uni.showToast({ 
        title: `已选择 ${finalItems.length} 个比赛项目`, 
        icon: 'success' 
    })
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

    // 初始化时加载分类树
    loadCategoryTree()
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

// 年龄组相关样式
.checkbox-group {
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    gap: 32rpx;
    
    .checkbox-item {
        display: flex;
        align-items: center;
        cursor: pointer;
        
        .checkbox-circle {
            width: 32rpx;
            height: 32rpx;
            border: 2rpx solid #ddd;
            border-radius: 8rpx;
            margin-right: 16rpx;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            
            &.active {
                border-color: #007aff;
                background-color: #007aff;
            }
            
            .checkbox-icon {
                font-size: 20rpx;
                color: white;
                font-weight: bold;
            }
        }
        
        .checkbox-label {
            font-size: 28rpx;
            color: #333;
        }
    }
}

.age-group-preview {
    margin-top: 20rpx;
    padding: 24rpx;
    background-color: #f8f9fa;
    border-radius: 12rpx;
    border: 1rpx solid #e9ecef;
    
    .preview-text {
        font-size: 26rpx;
        color: #666;
        margin-bottom: 12rpx;
    }
    
    .preview-list {
        display: flex;
        flex-wrap: wrap;
        gap: 8rpx;
        
        .preview-item {
            font-size: 24rpx;
            color: #007aff;
            background-color: #e3f2fd;
            padding: 8rpx 16rpx;
            border-radius: 20rpx;
            border: 1rpx solid #bbdefb;
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

/* 智能分类树样式 */
.category-section {
    margin-bottom: 20px;
}

.category-scroll {
    max-height: 300px;
    border: 1px solid #e4e7ed;
    border-radius: 8px;
}

.category-tree {
    padding: 10px;
}

.category-item {
    display: flex;
    align-items: center;
    padding: 8px 12px;
    border-radius: 6px;
    margin: 2px 0;
    
    &.level-1 {
        background: #f8f9fa;
        font-weight: 600;
        border-left: 3px solid #409eff;
    }
    
    &.level-2 {
        background: #f0f9ff;
        margin-left: 20px;
        border-left: 2px solid #67c23a;
    }
    
    &.level-3 {
        background: #fafcff;
        margin-left: 40px;
        border-left: 1px solid #909399;
        
        &.final-level {
            background: #f0f9ff;
            border-left: 2px solid #e6a23c;
        }
    }
    
    &.expanded {
        background: #e3f2fd;
    }
    
    text {
        margin-left: 8px;
        flex: 1;
    }
}

.category-info {
    font-size: 12px;
    color: #909399;
    margin-left: 8px !important;
}

.final-level-tag {
    font-size: 10px;
    color: #67c23a;
    background: #f0f9ff;
    padding: 2px 6px;
    border-radius: 10px;
    margin-left: 8px !important;
}

/* 项目列表样式 */
.items-section {
    margin-bottom: 20px;
}

.items-scroll {
    max-height: 200px;
    border: 1px solid #e4e7ed;
    border-radius: 8px;
}

.items-list {
    padding: 10px;
}

.item-checkbox {
    display: flex;
    align-items: center;
    padding: 10px;
    border-bottom: 1px solid #f0f0f0;
    
    &:last-child {
        border-bottom: none;
    }
}

.item-info {
    margin-left: 12px;
    flex: 1;
}

.item-name {
    font-size: 14px;
    color: #303133;
    display: block;
}

.item-desc {
    font-size: 12px;
    color: #909399;
    margin-top: 4px;
    display: block;
}

.item-count {
    font-size: 12px;
    color: #909399;
    margin-left: 8px;
}

/* 已选项目样式 */
.selected-items-section {
    margin-bottom: 20px;
}

.selected-items-scroll {
    white-space: nowrap;
}

.selected-items {
    display: flex;
    padding: 10px 0;
}

.selected-item-tag {
    display: flex;
    align-items: center;
    background: #409eff;
    color: white;
    padding: 6px 12px;
    border-radius: 16px;
    margin-right: 8px;
    font-size: 12px;
    white-space: nowrap;
    
    text {
        margin-right: 6px;
    }
}
</style> 
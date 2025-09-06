<template>
    <view class="co-organizer-manager">
        <!-- 弹窗遮罩 -->
        <view v-if="visible" class="popup-mask" @tap="handleClose">
            <view class="popup-container" @tap.stop>
                <!-- 弹窗头部 -->
                <view class="popup-header">
                    <view class="popup-title">协办单位管理</view>
                    <view class="popup-close" @tap="handleClose">×</view>
                </view>
                
                <!-- 弹窗内容 -->
                <view class="popup-content">
                    <!-- 添加按钮 -->
                    <view class="add-section">
                        <button class="add-btn" @tap="handleAdd">
                            <text class="add-icon">+</text>
                            <text class="add-text">添加协办单位</text>
                        </button>
                    </view>
                    
                    <!-- 协办单位列表 -->
                    <view class="list-section">
                        <view v-if="coOrganizerList.length === 0" class="empty-state">
                            <text class="empty-text">暂无协办单位</text>
                        </view>
                        
                        <view v-else class="co-organizer-list">
                            <view 
                                v-for="(item, index) in coOrganizerList" 
                                :key="item.id || index"
                                class="co-organizer-item"
                            >
                                <view class="item-content">
                                    <view class="item-header">
                                        <view class="item-name">{{ item.organizer_name }}</view>
                                        <view class="item-type">{{ getTypeText(item.organizer_type) }}</view>
                                    </view>
                                    
                                    <view v-if="item.contact_name || item.contact_phone" class="item-contact">
                                        <text v-if="item.contact_name" class="contact-name">{{ item.contact_name }}</text>
                                        <text v-if="item.contact_phone" class="contact-phone">{{ item.contact_phone }}</text>
                                    </view>
                                    
                                    <view v-if="item.remark" class="item-remark">
                                        <text class="remark-text">{{ item.remark }}</text>
                                    </view>
                                </view>
                                
                                <view class="item-actions">
                                    <button class="edit-btn" @tap="handleEdit(item)">编辑</button>
                                    <button class="delete-btn" @tap="handleDelete(item)">删除</button>
                                </view>
                            </view>
                        </view>
                    </view>
                </view>
            </view>
        </view>
        
        <!-- 添加/编辑弹窗 -->
        <view v-if="showForm" class="form-mask" @tap="handleFormClose">
            <view class="form-container" @tap.stop>
                <view class="form-header">
                    <view class="form-title">{{ isEdit ? '编辑协办单位' : '添加协办单位' }}</view>
                    <view class="form-close" @tap="handleFormClose">×</view>
                </view>
                
                <view class="form-content">
                    <view class="form-item">
                        <text class="form-label">单位名称：</text>
                        <input 
                            v-model="formData.organizer_name" 
                            class="form-input" 
                            placeholder="请输入单位名称"
                            maxlength="100"
                        />
                    </view>
                    
                    <view class="form-item">
                        <text class="form-label">单位类型：</text>
                        <picker 
                            :value="typeIndex" 
                            :range="typeOptions" 
                            @change="onTypeChange"
                            class="form-picker"
                        >
                            <view class="picker-display">{{ typeOptions[typeIndex] }}</view>
                        </picker>
                    </view>
                    
                    <view class="form-item">
                        <text class="form-label">联系人：</text>
                        <input 
                            v-model="formData.contact_name" 
                            class="form-input" 
                            placeholder="请输入联系人姓名"
                            maxlength="50"
                        />
                    </view>
                    
                    <view class="form-item">
                        <text class="form-label">联系电话：</text>
                        <input 
                            v-model="formData.contact_phone" 
                            class="form-input" 
                            placeholder="请输入联系电话"
                            maxlength="20"
                        />
                    </view>
                    
                    <view class="form-item">
                        <text class="form-label">备注：</text>
                        <textarea 
                            v-model="formData.remark" 
                            class="form-textarea" 
                            placeholder="请输入备注信息"
                            maxlength="255"
                        />
                    </view>
                </view>
                
                <view class="form-actions">
                    <button class="cancel-btn" @tap="handleFormClose">取消</button>
                    <button class="confirm-btn" @tap="handleSubmit" :disabled="!canSubmit">
                        {{ isEdit ? '保存' : '添加' }}
                    </button>
                </view>
            </view>
        </view>
    </view>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { 
    getCoOrganizerList, 
    addCoOrganizer, 
    editCoOrganizer, 
    deleteCoOrganizer,
    CO_ORGANIZER_TYPES,
    CO_ORGANIZER_TYPE_TEXTS,
    type CoOrganizerItem 
} from '@/addon/sport/api/co_organizer'

// Props
interface Props {
    visible: boolean
    eventId: number
}

const props = withDefaults(defineProps<Props>(), {
    visible: false,
    eventId: 0
})

// Emits
const emit = defineEmits<{
    close: []
    refresh: []
}>()

// 响应式数据
const coOrganizerList = ref<CoOrganizerItem[]>([])
const loading = ref(false)
const showForm = ref(false)
const isEdit = ref(false)
const editingItem = ref<CoOrganizerItem | null>(null)

// 表单数据
const formData = ref<Partial<CoOrganizerItem>>({
    organizer_name: '',
    organizer_type: CO_ORGANIZER_TYPES.CO_ORGANIZER,
    contact_name: '',
    contact_phone: '',
    remark: ''
})

// 类型选择器
const typeOptions = ['协办单位', '赞助商', '支持单位']
const typeIndex = ref(0)

// 计算属性
const canSubmit = computed(() => {
    return formData.value.organizer_name?.trim()
})

// 监听弹窗显示状态
watch(() => props.visible, (newVal) => {
    if (newVal && props.eventId) {
        loadCoOrganizerList()
    }
})

// 监听类型索引变化
watch(typeIndex, (newIndex) => {
    formData.value.organizer_type = newIndex + 1
})

// 方法
const loadCoOrganizerList = async () => {
    if (!props.eventId) return
    
    try {
        loading.value = true
        const response: any = await getCoOrganizerList(props.eventId)
        coOrganizerList.value = response.data || []
    } catch (error) {
        console.error('加载协办单位列表失败:', error)
    } finally {
        loading.value = false
    }
}

const getTypeText = (type: number) => {
    return CO_ORGANIZER_TYPE_TEXTS[type as keyof typeof CO_ORGANIZER_TYPE_TEXTS] || '未知'
}

const handleClose = () => {
    emit('close')
}

const handleAdd = () => {
    isEdit.value = false
    editingItem.value = null
    resetForm()
    showForm.value = true
}

const handleEdit = (item: CoOrganizerItem) => {
    isEdit.value = true
    editingItem.value = item
    formData.value = { ...item }
    typeIndex.value = (item.organizer_type || 1) - 1
    showForm.value = true
}

const handleDelete = async (item: CoOrganizerItem) => {
    if (!item.id) return
    
    try {
        await uni.showModal({
            title: '确认删除',
            content: `确定要删除协办单位"${item.organizer_name}"吗？`,
            confirmText: '删除',
            confirmColor: '#ff4757'
        })
        
        await deleteCoOrganizer(item.id)
        await loadCoOrganizerList()
        emit('refresh')
    } catch (error) {
        console.error('删除协办单位失败:', error)
    }
}

const handleFormClose = () => {
    showForm.value = false
    resetForm()
}

const resetForm = () => {
    formData.value = {
        organizer_name: '',
        organizer_type: CO_ORGANIZER_TYPES.CO_ORGANIZER,
        contact_name: '',
        contact_phone: '',
        remark: ''
    }
    typeIndex.value = 0
}

const onTypeChange = (e: any) => {
    typeIndex.value = e.detail.value
}

const handleSubmit = async () => {
    if (!canSubmit.value) return
    
    try {
        const submitData = {
            ...formData.value,
            event_id: props.eventId
        }
        
        if (isEdit.value && editingItem.value?.id) {
            await editCoOrganizer(editingItem.value.id, submitData)
        } else {
            await addCoOrganizer(submitData as CoOrganizerItem)
        }
        
        await loadCoOrganizerList()
        handleFormClose()
        emit('refresh')
    } catch (error) {
        console.error('保存协办单位失败:', error)
    }
}
</script>

<style lang="scss" scoped>
.co-organizer-manager {
    .popup-mask, .form-mask {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0, 0, 0, 0.5);
        z-index: 1000;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    
    .popup-container, .form-container {
        width: 90%;
        max-width: 600rpx;
        max-height: 80vh;
        background: white;
        border-radius: 16rpx;
        overflow: hidden;
    }
    
    .popup-header, .form-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 24rpx 32rpx;
        background: linear-gradient(135deg, #ff6b35, #f7931e);
        color: white;
    }
    
    .popup-title, .form-title {
        font-size: 32rpx;
        font-weight: 600;
    }
    
    .popup-close, .form-close {
        width: 48rpx;
        height: 48rpx;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 36rpx;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.2);
    }
    
    .popup-content, .form-content {
        padding: 32rpx;
        max-height: 60vh;
        overflow-y: auto;
    }
    
    .add-section {
        margin-bottom: 32rpx;
    }
    
    .add-btn {
        width: 100%;
        height: 80rpx;
        background: linear-gradient(135deg, #ff6b35, #f7931e);
        color: white;
        border: none;
        border-radius: 12rpx;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 28rpx;
        font-weight: 600;
    }
    
    .add-icon {
        margin-right: 12rpx;
        font-size: 32rpx;
    }
    
    .empty-state {
        text-align: center;
        padding: 80rpx 0;
    }
    
    .empty-text {
        color: #999;
        font-size: 28rpx;
    }
    
    .co-organizer-list {
        .co-organizer-item {
            display: flex;
            align-items: center;
            padding: 24rpx;
            margin-bottom: 16rpx;
            background: #f8f9fa;
            border-radius: 12rpx;
            border-left: 4rpx solid #ff6b35;
        }
        
        .item-content {
            flex: 1;
        }
        
        .item-header {
            display: flex;
            align-items: center;
            margin-bottom: 8rpx;
        }
        
        .item-name {
            font-size: 30rpx;
            font-weight: 600;
            color: #333;
            margin-right: 16rpx;
        }
        
        .item-type {
            padding: 4rpx 12rpx;
            background: #ff6b35;
            color: white;
            border-radius: 8rpx;
            font-size: 22rpx;
        }
        
        .item-contact {
            display: flex;
            align-items: center;
            margin-bottom: 8rpx;
        }
        
        .contact-name, .contact-phone {
            font-size: 26rpx;
            color: #666;
            margin-right: 16rpx;
        }
        
        .item-remark {
            .remark-text {
                font-size: 24rpx;
                color: #999;
                line-height: 1.4;
            }
        }
        
        .item-actions {
            display: flex;
            flex-direction: column;
            gap: 8rpx;
        }
        
        .edit-btn, .delete-btn {
            width: 80rpx;
            height: 48rpx;
            border: none;
            border-radius: 8rpx;
            font-size: 24rpx;
        }
        
        .edit-btn {
            background: #3498db;
            color: white;
        }
        
        .delete-btn {
            background: #e74c3c;
            color: white;
        }
    }
    
    .form-item {
        display: flex;
        align-items: center;
        margin-bottom: 24rpx;
    }
    
    .form-label {
        width: 160rpx;
        font-size: 28rpx;
        color: #333;
        flex-shrink: 0;
    }
    
    .form-input, .form-picker {
        flex: 1;
        height: 72rpx;
        padding: 0 16rpx;
        border: 2rpx solid #e0e0e0;
        border-radius: 8rpx;
        font-size: 28rpx;
    }
    
    .form-textarea {
        flex: 1;
        min-height: 120rpx;
        padding: 16rpx;
        border: 2rpx solid #e0e0e0;
        border-radius: 8rpx;
        font-size: 28rpx;
    }
    
    .picker-display {
        height: 72rpx;
        line-height: 72rpx;
        color: #333;
    }
    
    .form-actions {
        display: flex;
        gap: 16rpx;
        padding: 24rpx 0;
    }
    
    .cancel-btn, .confirm-btn {
        flex: 1;
        height: 80rpx;
        border: none;
        border-radius: 12rpx;
        font-size: 28rpx;
        font-weight: 600;
    }
    
    .cancel-btn {
        background: #f8f9fa;
        color: #666;
    }
    
    .confirm-btn {
        background: linear-gradient(135deg, #ff6b35, #f7931e);
        color: white;
        
        &:disabled {
            background: #ccc;
            color: #999;
        }
    }
}
</style>

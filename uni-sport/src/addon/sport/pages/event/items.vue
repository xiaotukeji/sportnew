<template>
    <view class="container">
        <!-- 页面标题 -->
        <view class="page-header">
            <text class="page-title">选择比赛项目</text>
            <text class="page-desc">已选择 {{ selectedCount }} 个项目</text>
        </view>
        
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
        
        <!-- 加载状态 -->
        <view v-if="loading" class="loading-container">
            <text>加载中...</text>
        </view>
        
        <!-- 分类列表 -->
        <view v-else class="categories-list">
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
        
        <!-- 错误状态 -->
        <view v-if="error" class="error-container">
            <text class="error-text">{{ error }}</text>
            <button class="retry-btn" @tap="loadCategories">重新加载</button>
        </view>
        
        <!-- 底部操作栏 -->
        <view class="bottom-actions">
            <view class="selected-info">
                <text class="selected-text">已选 {{ selectedCount }} 项</text>
            </view>
            <view class="action-buttons">
                <button class="btn-secondary" @tap="clearAll">清空</button>
                <button class="btn-primary" @tap="saveItems" :disabled="selectedCount === 0">
                    保存选择
                </button>
            </view>
        </view>
    </view>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useLoginCheck } from '@/addon/sport/hooks/useLoginCheck'
import { getEventCategories, saveEventItems } from '@/addon/sport/api/event'

// 使用登录检查
const { requireLogin } = useLoginCheck()

// 响应式数据
const loading = ref(true)
const error = ref('')
const eventId = ref(0)
const categories = ref<any[]>([])
const selectedItems = ref<number[]>([])
const expandedCategories = ref<number[]>([])
const activeTab = ref<string | number>('all')

// 计算属性
const selectedCount = computed(() => selectedItems.value.length)

const filteredCategories = computed(() => {
    if (activeTab.value === 'all') {
        return categories.value
    }
    return categories.value.filter(cat => cat.id === activeTab.value)
})

/**
 * 加载分类和基础项目数据
 */
const loadCategories = async () => {
    try {
        loading.value = true
        error.value = ''
        
        const response: any = await getEventCategories({ event_id: eventId.value })
        console.log('分类数据:', response.data)
        
        categories.value = response.data.categories || []
        
        // 设置默认展开的分类
        const defaultExpandCategories: number[] = []
        categories.value.forEach(category => {
            if (category.default_expand) {
                defaultExpandCategories.push(category.id)
            }
            
            // 收集已选中的项目
            if (category.base_items) {
                category.base_items.forEach((item: any) => {
                    if (item.selected) {
                        selectedItems.value.push(item.id)
                    }
                })
            }
        })
        
        expandedCategories.value = defaultExpandCategories
        
    } catch (err: any) {
        console.error('加载分类失败:', err)
        error.value = err.message || '加载失败'
    } finally {
        loading.value = false
    }
}

/**
 * 切换标签
 */
const switchTab = (tabId: string | number) => {
    activeTab.value = tabId
}

/**
 * 切换分类展开/收起
 */
const toggleCategory = (categoryId: number) => {
    const index = expandedCategories.value.indexOf(categoryId)
    if (index > -1) {
        expandedCategories.value.splice(index, 1)
    } else {
        expandedCategories.value.push(categoryId)
    }
}

/**
 * 切换项目选择状态
 */
const toggleItem = (itemId: number) => {
    const index = selectedItems.value.indexOf(itemId)
    if (index > -1) {
        selectedItems.value.splice(index, 1)
    } else {
        selectedItems.value.push(itemId)
    }
}

/**
 * 清空所有选择
 */
const clearAll = () => {
    uni.showModal({
        title: '确认清空',
        content: '确定要清空所有已选择的项目吗？',
        success: (res) => {
            if (res.confirm) {
                selectedItems.value = []
            }
        }
    })
}

/**
 * 保存项目选择
 */
const saveItems = async () => {
    if (selectedItems.value.length === 0) {
        uni.showToast({
            title: '请选择至少一个项目',
            icon: 'none'
        })
        return
    }
    
    try {
        uni.showLoading({ title: '保存中...' })
        
        await saveEventItems({
            event_id: eventId.value,
            base_item_ids: selectedItems.value
        })
        
        uni.hideLoading()
        
        // 返回上一页
        uni.navigateBack()
        
    } catch (err: any) {
        uni.hideLoading()
        console.error('保存失败:', err)
        uni.showToast({
            title: err.message || '保存失败',
            icon: 'none'
        })
    }
}

/**
 * 页面加载
 */
onMounted(() => {
    requireLogin(() => {
        // 获取页面参数
        const pages = getCurrentPages()
        const currentPage = pages[pages.length - 1] as any
        const options = currentPage.options || {}
        
        if (options.event_id) {
            eventId.value = parseInt(options.event_id)
            loadCategories()
        } else {
            loading.value = false
            error.value = '缺少赛事ID参数'
        }
    })
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
    border-bottom: 1rpx solid #f0f0f0;
    
    .page-title {
        font-size: 36rpx;
        font-weight: bold;
        color: #333;
        display: block;
        margin-bottom: 8rpx;
    }
    
    .page-desc {
        font-size: 28rpx;
        color: #666;
    }
}

.category-tabs {
    background-color: white;
    border-bottom: 1rpx solid #f0f0f0;
    
    .tabs-scroll {
        white-space: nowrap;
        
        .tabs-content {
            display: flex;
            padding: 0 32rpx;
            
            .tab-item {
                flex-shrink: 0;
                padding: 24rpx 32rpx;
                margin-right: 16rpx;
                border-radius: 24rpx;
                background-color: #f8f9fa;
                transition: all 0.3s ease;
                
                &.active {
                    background-color: #007aff;
                    
                    .tab-text {
                        color: white;
                    }
                }
                
                .tab-text {
                    font-size: 28rpx;
                    color: #666;
                }
            }
        }
    }
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

.categories-list {
    .category-section {
        background-color: white;
        margin: 20rpx 32rpx;
        border-radius: 16rpx;
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
                    font-size: 32rpx;
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
                
                &:active {
                    transform: scale(0.98);
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
    align-items: center;
    justify-content: space-between;
    
    .selected-info {
        .selected-text {
            font-size: 28rpx;
            color: #333;
        }
    }
    
    .action-buttons {
        display: flex;
        gap: 24rpx;
        
        .btn-secondary,
        .btn-primary {
            padding: 16rpx 32rpx;
            border-radius: 8rpx;
            border: none;
            font-size: 28rpx;
            
            &.btn-secondary {
                background-color: #f8f9fa;
                color: #666;
                border: 1rpx solid #dee2e6;
            }
            
            &.btn-primary {
                background-color: #007aff;
                color: white;
                
                &:disabled {
                    background-color: #ccc;
                    color: #999;
                }
            }
            
            &:active:not(:disabled) {
                opacity: 0.8;
            }
        }
    }
}
</style> 
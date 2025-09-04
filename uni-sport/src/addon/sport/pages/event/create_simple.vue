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
                    <view class="step-title-container">
                        <text class="step-title-line1">{{ getStepTitleLine1(step.title) }}</text>
                        <text class="step-title-line2">{{ getStepTitleLine2(step.title) }}</text>
                    </view>
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
                    <view class="section-title">比赛时间</view>
                    
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
                
                <!-- 报名时间设置 -->
                <view class="form-section">
                    <view class="section-title">报名时间</view>
                    <view class="form-tip" style="margin: 0 32rpx 16rpx;">
                        <text class="tip-text">设置报名开始和结束时间，默认与比赛时间相同</text>
                    </view>
                    
                    <!-- 报名开始时间 -->
                    <view class="form-item">
                        <view class="form-label">报名开始时间</view>
                        <view class="time-picker-container">
                            <picker
                                mode="date"
                                :value="registrationStartDateValue"
                                @change="onRegistrationStartDateChange"
                            >
                                <view class="time-picker-item">
                                    <input 
                                        class="form-input readonly" 
                                        :value="registrationStartDateDisplay" 
                                        placeholder="选择日期"
                                        disabled
                                    />
                                    <text class="picker-arrow">📅</text>
                                </view>
                            </picker>
                            <picker
                                mode="time"
                                :value="registrationStartTimeValue"
                                @change="onRegistrationStartTimeChange"
                            >
                                <view class="time-picker-item">
                                    <input 
                                        class="form-input readonly" 
                                        :value="registrationStartTimeDisplay" 
                                        placeholder="选择时间"
                                        disabled
                                    />
                                    <text class="picker-arrow">🕐</text>
                                </view>
                            </picker>
                        </view>
                    </view>
                    
                    <!-- 报名结束时间 -->
                    <view class="form-item">
                        <view class="form-label">报名结束时间</view>
                        <view class="time-picker-container">
                            <picker
                                mode="date"
                                :value="registrationEndDateValue"
                                @change="onRegistrationEndDateChange"
                            >
                                <view class="time-picker-item">
                                    <input 
                                        class="form-input readonly" 
                                        :value="registrationEndDateDisplay" 
                                        placeholder="选择日期"
                                        disabled
                                    />
                                    <text class="picker-arrow">📅</text>
                                </view>
                            </picker>
                            <picker
                                mode="time"
                                :value="registrationEndTimeValue"
                                @change="onRegistrationEndTimeChange"
                            >
                                <view class="time-picker-item">
                                    <input 
                                        class="form-input readonly" 
                                        :value="registrationEndTimeDisplay" 
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

            <!-- 第4步：报名参数 -->
            <view v-if="currentStep === 4" class="form-wrapper">
                <view class="form-section">
                    <view class="section-title">报名参数</view>
                    <view class="form-item">
                        <view class="form-label flex-between">
                            <text>选择需要收集的报名字段</text>
                            <text class="selected-count" v-if="formData.signup_fields.length">已选 {{ formData.signup_fields.length }} 项</text>
                        </view>
                        <view class="signup-groups">
                            <view class="signup-group" v-for="group in signupFieldGroups" :key="group.key">
                                <view class="signup-group-title">{{ group.title }}</view>
                                <view class="signup-chip-grid">
                                    <view 
                                        class="signup-chip" 
                                        v-for="field in group.options" 
                                        :key="field.key"
                                        :class="{ active: isSignupFieldChecked(field.key) }"
                                        @tap="toggleSignupField(field.key)"
                                    >
                                        <text class="chip-label">{{ field.label }}</text>
                                    </view>
                                </view>
                            </view>
                        </view>
                    </view>

                    <view v-if="formData.signup_fields.length" class="form-item">
                        <view class="form-label flex-between">
                            <text>必填设置</text>
                            <text class="required-tip">请设置必填字段</text>
                        </view>
                        <view class="signup-selected-list">
                            <view class="signup-selected-item" v-for="sf in formData.signup_fields" :key="sf.key">
                                <text class="field-name">{{ sf.label }}</text>
                                <view class="required-toggle">
                                    <text class="toggle-text">必填</text>
                                    <switch :checked="sf.required" @change="(e:any)=>setSignupFieldRequired(sf.key,e.detail.value)" />
                                </view>
                            </view>
                        </view>
                    </view>

                    <view class="form-item">
                        <view class="form-label flex-between">
                            <text>自定义字段</text>
                        </view>
                        <view class="custom-field-row">
                            <input class="form-input" v-model="customFieldName" placeholder="请输入自定义字段名称，如：工号/队服号码" />
                            <button class="btn-secondary" @tap="addCustomField">添加</button>
                        </view>
                                        <view v-if="customFields.length" class="signup-chip-grid" style="margin-top: 8rpx;">
                    <view class="signup-chip active" v-for="cf in customFields" :key="cf.key">
                        <text class="chip-label">{{ cf.label }}</text>
                        <text class="chip-delete" @tap.stop="removeCustomField(cf.key)">×</text>
                    </view>
                </view>
                    </view>
                </view>
            </view>
            
            <!-- 第5步：选择项目 -->
            <view v-if="currentStep === 5" class="form-wrapper">
                <view class="form-section">
                    <view class="section-title">比赛项目</view>
                    
                    <!-- 加载状态 -->
                    <view v-if="categoriesLoading" class="loading-container">
                        <text>加载中...</text>
                    </view>
                    
                    <!-- 错误状态 -->
                    <view v-else-if="categoriesError" class="error-container">
                        <text class="error-text">{{ categoriesError }}</text>
                        <button class="retry-btn" @tap="loadCategories">重新加载</button>
                    </view>
                    
                    <!-- 正常内容 -->
                    <view v-else>

                        
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
                                        <text class="category-count">(总{{ getTotalItemCount(category) }}项，已选{{ getSelectedItemCount(category) }}项)</text>
                                        <view v-if="getSelectedItemCount(category) > 0" class="selected-badge">
                                            <text class="badge-text">{{ getSelectedItemCount(category) }}</text>
                                        </view>
                                    </view>
                                    <view 
                                        v-if="category.has_children || category.base_items?.length > 0"
                                        class="category-arrow" 
                                        :class="{ expanded: expandedCategories.includes(category.id) }"
                                    >
                                        <text class="arrow-icon">›</text>
                                    </view>
                                </view>
                                
                                <!-- 展开内容 -->
                                <view v-if="expandedCategories.includes(category.id)" class="category-content">
                                    <!-- 子分类 -->
                                    <view 
                                        v-if="category.children && category.children.length > 0"
                                        class="sub-categories"
                                    >
                                        <view 
                                            v-for="subCategory in category.children" 
                                            :key="subCategory.id"
                                            class="sub-category-section"
                                        >
                                            <!-- 子分类标题 -->
                                            <view class="sub-category-header" @tap="toggleCategory(subCategory.id)">
                                                <view class="sub-category-info">
                                                    <text class="sub-category-name">{{ subCategory.name }}</text>
                                                    <text class="sub-category-count">(总{{ getTotalItemCount(subCategory) }}项，已选{{ getSelectedItemCount(subCategory) }}项)</text>
                                                    <view v-if="getSelectedItemCount(subCategory) > 0" class="selected-badge sub-badge">
                                                        <text class="badge-text">{{ getSelectedItemCount(subCategory) }}</text>
                                                    </view>
                                                </view>
                                                <view 
                                                    v-if="subCategory.has_children || subCategory.base_items?.length > 0"
                                                    class="sub-category-arrow" 
                                                    :class="{ expanded: expandedCategories.includes(subCategory.id) }"
                                                >
                                                    <text class="arrow-icon">›</text>
                                                </view>
                                            </view>
                                            
                                            <!-- 子分类展开内容 -->
                                            <view v-if="expandedCategories.includes(subCategory.id)" class="sub-category-content">
                                                <!-- 三级分类 -->
                                                <view 
                                                    v-if="subCategory.children && subCategory.children.length > 0"
                                                    class="third-categories"
                                                >
                                                    <view 
                                                        v-for="thirdCategory in subCategory.children" 
                                                        :key="thirdCategory.id"
                                                        class="third-category-section"
                                                    >
                                                        <!-- 三级分类标题 -->
                                                        <view class="third-category-header" @tap="toggleCategory(thirdCategory.id)">
                                                            <view class="third-category-info">
                                                                <text class="third-category-name">{{ thirdCategory.name }}</text>
                                                                <text class="third-category-count">(总{{ thirdCategory.base_items?.length || 0 }}项，已选{{ getSelectedItemCount(thirdCategory) }}项)</text>
                                                                <view v-if="getSelectedItemCount(thirdCategory) > 0" class="selected-badge third-badge">
                                                                    <text class="badge-text">{{ getSelectedItemCount(thirdCategory) }}</text>
                                                                </view>
                                                            </view>
                                                            <view 
                                                                v-if="thirdCategory.base_items?.length > 0"
                                                                class="third-category-arrow" 
                                                                :class="{ expanded: expandedCategories.includes(thirdCategory.id) }"
                                                            >
                                                                <text class="arrow-icon">›</text>
                                                            </view>
                                                        </view>
                                                        
                                                        <!-- 三级分类的基础项目 -->
                                                        <view 
                                                            v-if="expandedCategories.includes(thirdCategory.id) && thirdCategory.base_items?.length > 0"
                                                            class="base-items-grid"
                                                        >
                                                            <view 
                                                                v-for="item in thirdCategory.base_items" 
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
                                                
                                                <!-- 二级分类的基础项目 -->
                                                <view 
                                                    v-if="subCategory.base_items?.length > 0"
                                                    class="base-items-grid"
                                                >
                                                    <view 
                                                        v-for="item in subCategory.base_items" 
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
                                    </view>
                                    
                                    <!-- 一级分类的基础项目 -->
                                    <view 
                                        v-if="category.base_items?.length > 0"
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
                        </view>
                        
                        <!-- 已选项目预览（仅显示已选条目，不再显示标题） -->
                        <view v-if="selectedItems.length > 0" class="selected-preview">
                            <view class="preview-items">
                                <view 
                                    v-for="itemId in selectedItems"
                                    :key="itemId"
                                    class="preview-item"
                                >
                                    {{ getItemNameById(itemId) || ('#' + itemId) }}
                                </view>
                            </view>
                        </view>
                        
                        <!-- 项目选择内的操作栏 -->
                        <view class="items-actions">
                            <view class="selected-info">
                                <text class="selected-text">已选 {{ selectedItems.length }} 项</text>
                            </view>
                            <view class="action-buttons">
                                <button class="btn-secondary" @tap="clearAllItems">清空</button>
                            </view>
                        </view>
                        <view style="height: 16rpx;"></view>
                    </view>
                </view>
            </view>
            
            <!-- 第6步：项目设置 -->
            <view v-if="currentStep === 6" class="form-wrapper">
                <view class="form-section">
                    <view class="section-title">
                        <text class="title-text">项目设置</text>
                        <button class="save-settings-btn" @tap="saveItemSettings">
                            <text class="btn-text">保存设置</text>
                        </button>
                    </view>
                    <!-- <view class="section-subtitle">为每个比赛项目设置详细参数</view> -->
                    
                    <!-- 项目列表设置 -->
                    <view class="items-settings">
                        <view class="section-title">
                            <text class="title-text">比赛项目设置</text>
                            <text class="title-count">({{ groupedEventItems?.length || 0 }}大类 {{ eventItems?.length || 0 }}项)</text>
                        </view>
                        
                        <view v-if="eventItems && eventItems.length > 0" class="items-container">
                                                            <view 
                                    v-for="(group, groupIndex) in (groupedEventItems || [])" 
                                    :key="group?.categoryName || groupIndex" 
                                    class="category-group"
                                    :style="{ background: getCategoryColor(group?.categoryName || '其他') }"
                                >
                                <!-- 大类标题 -->
                                <view class="category-header" :style="{ background: getCategoryColor(group?.categoryName || '其他') }">
                                    <view class="category-info">
                                        <text class="category-name">{{ group?.categoryName || '其他' }}</text>
                                        <text class="category-count">({{ group?.items?.length || 0 }}项)</text>
                                    </view>
                                    <view class="category-sync" v-if="group?.items && group.items.length > 1">
                                        <button class="sync-btn" @tap="onSyncSettings(group?.categoryName || '其他')">
                                            <text class="sync-text">同步设置</text>
                                        </button>
                                    </view>
                                </view>
                                
                                <!-- 该大类下的项目列表 -->
                                <view class="group-items">
                                    <view 
                                        v-for="(item, index) in (group?.items || [])" 
                                        :key="item?.id || index" 
                                        class="item-card"
                                        :style="{ borderLeftColor: getCategoryBorderColor(group?.categoryName || '其他') }"
                                    >
                                        <view class="item-header">
                                            <view class="item-info">
                                                <text class="item-name">{{ item?.name || '未知项目' }}</text>
                                                <text class="item-category">{{ item?.category_name || '其他' }}</text>
                                                <text class="item-id-info">ID: {{ item?.id }} (base: {{ item?.base_item_id }})</text>
                                            </view>
                                            <view class="item-status" :class="'status-' + (item?.is_configured ? 'configured' : 'pending')">
                                                {{ item?.is_configured ? '已配置' : '待配置' }}
                                            </view>
                                        </view>
                                        
                                        <view class="item-settings">
                                            <!-- 报名费设置 -->
                                            <view class="setting-item">
                                                <text class="setting-label">报名费（元）</text>
                                                <input 
                                                    class="setting-input" 
                                                    type="digit" 
                                                    :value="getRegistrationFeeDisplayValue(item?.registration_fee)"
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
                                                    :value="getMaxParticipantsDisplayValue(item?.max_participants)"
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
                                                    :checked="item?.allow_duplicate_registration" 
                                                    :data-id="item?.id"
                                                    data-field="allow_duplicate_registration"
                                                    @change="onItemSwitchChangeEvt"
                                                />
                                            </view>

                                            <!-- 是否循环赛（小组） -->
                                            <view class="setting-item">
                                                <text class="setting-label">循环赛\n(小组)</text>
                                                <switch
                                                    :checked="item?.is_round_robin"
                                                    :data-id="item?.id"
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
                                                    <text class="textarea-count">{{ (item?.remark || '').length }}/200</text>
                                                </view>
                                            </view>
                                            
                                            <!-- 场地设备管理 -->
                                            <view class="venue-management">
                                                <view class="venue-header">
                                                    <text class="venue-title">场地设备管理</text>
                                                    <button class="add-venue-btn" @tap="showVenueModal(item?.id, group?.categoryName)">
                                                        <text class="btn-text">{{ hasVenues ? '管理场地' : '添加场地' }}</text>
                                                    </button>
                                                </view>
                                                
                                                <!-- 场地选择（直接展示可用场地，支持多选与全选） -->
                                                <view class="venue-selection">
                                                    <view class="selection-header">
                                                        <text class="selection-label">选择场地：</text>
                                                        <text class="venue-type-tip">{{ getVenueTypeLabel(getItemVenueType(item)) }}类型</text>
                                                    </view>
                                                    <view class="venue-selector-list">
                                                        <view class="select-all" v-if="getAvailableVenuesForItem(item?.id)?.length > 0">
                                                            <view class="select-row" :class="{ selected: isAllVenuesSelected(item?.id) }" @tap.stop="toggleSelectAllVenues(item?.id)">
                                                                <text class="select-text">{{ isAllVenuesSelected(item?.id) ? '取消全选' : '全选' }}</text>
                                                                <!-- 全选状态显示勾选标记 -->
                                                                <view v-if="isAllVenuesSelected(item?.id)" class="selected-mark">
                                                                    <text class="mark-text">✓</text>
                                                                </view>
                                                            </view>
                                                        </view>
                                                        <view class="venue-options">
                                                            <view
                                                                v-for="venue in (getAvailableVenuesForItem(item?.id) || [])"
                                                                :key="venue?.id"
                                                                class="venue-option"
                                                                :class="{ selected: isVenueSelectedForItem(item?.id, venue?.id) }"
                                                                @tap="toggleVenueSelection(item?.id, venue?.id)"
                                                            >
                                                                <text class="option-text">{{ venue?.name || '未知场地' }}</text>
                                                                <text class="venue-code">({{ venue?.venue_code || 'N/A' }})</text>
                                                                <!-- 已选中的场地显示勾选标记 -->
                                                                <view v-if="isVenueSelectedForItem(item?.id, venue?.id)" class="selected-mark">
                                                                    <text class="mark-text">✓</text>
                                                                </view>
                                                            </view>
                                                        </view>
                                                        <view v-if="!getAvailableVenuesForItem(item?.id) || getAvailableVenuesForItem(item?.id).length === 0" class="empty-venues">
                                                            <text class="empty-text">暂无可用场地</text>
                                                        </view>
                                                    </view>
                                                </view>
                                            </view>
                                        </view>
                                    </view>
                                </view>
                            </view>
                        </view>
                        
                        <view v-else-if="!eventItems || eventItems.length === 0" class="empty-items">
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
                                </view>
            </view>
        </view>
        
        <!-- 第7步：更多设置 -->
        <view v-if="currentStep === 7" class="form-wrapper">
            <view class="form-section">
                <view class="section-title">更多设置</view>
                <view class="section-subtitle">配置赛事的显示和功能选项</view>
                
                <!-- 赛事级别设置 -->
                <view class="event-settings">
                    <view class="settings-form">
                        <!-- 显示年龄组 -->
                        <view class="form-item">
                            <text class="item-label">显示年龄组</text>
                            <switch 
                                :checked="eventSettings.age_group_display" 
                                @change="onAgeGroupDisplayChange"
                            />
                        </view>
                        
                        <!-- 显示报名人数 -->
                        <view class="form-item">
                            <text class="item-label">显示报名人数</text>
                            <switch 
                                :checked="eventSettings.show_participant_count" 
                                @change="onShowParticipantCountChange"
                            />
                        </view>
                        
                        <!-- 显示比赛进度 -->
                        <view class="form-item">
                            <text class="item-label">显示比赛进度</text>
                            <switch 
                                :checked="eventSettings.show_progress" 
                                @change="onShowProgressChange"
                            />
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
                v-if="currentStep < 6" 
                class="action-btn next-btn" 
                :class="{ 'disabled': !canProceedToNext }"
                :disabled="!canProceedToNext"
                @tap="nextStep"
            >
                下一步
            </button>
            <button 
                v-if="currentStep === 6" 
                class="action-btn next-btn" 
                :class="{ 'disabled': !canProceedToNext }"
                :disabled="!canProceedToNext"
                @tap="nextStep"
            >
                下一步
            </button>
            <button 
                v-if="currentStep === 7" 
                class="action-btn submit-btn" 
                :class="{ 'loading': submitLoading }"
                :disabled="submitLoading || !canProceedToNext"
                @tap="handleSubmit"
            >
                {{ submitLoading ? (isEditMode ? '保存中...' : '创建比赛') : (isEditMode ? '保存修改' : '创建比赛') }}
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
                        <text class="section-title">现有场地 ({{ getCurrentProjectVenueTypeLabel() }}类型)</text>
                        <view v-if="getCurrentProjectVenues().length > 0" class="venue-list">
                            <view 
                                v-for="venue in getCurrentProjectVenues()" 
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
                            <text class="empty-text">暂无{{ getCurrentProjectVenueTypeLabel() }}类型场地，请先添加</text>
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
import { ref, computed, onMounted, watch } from 'vue'
import { useLoginCheck } from '@/addon/sport/hooks/useLoginCheck'
import { uploadImage } from '@/app/api/system'
import { img } from '@/utils/common'
import { getEventVenues, addEventVenue, editEventVenue, deleteEventVenue, batchAddVenues as apiBatchAddVenues, getItemVenues as apiGetItemVenues, assignVenueToItem, removeVenueFromItem as apiRemoveVenueFromItem, batchAssignVenuesToItem, getAvailableVenuesForItem as apiGetAvailableVenuesForItem } from '@/addon/sport/api/venue'
import { 
    addEvent, 
    editEvent,
    getEventInfo,
    getEventItems,
    getOrganizerList, 
    addOrganizer, 
    getEventSeriesList, 
    addEventSeries,
    getEventCategories,
    saveEventItems,
    updateItemSettings
} from '@/addon/sport/api/event'

// 登录检查
const { requireLogin } = useLoginCheck()

// 步骤配置
const steps = [
    { title: '基本信息' },
    { title: '地点信息' },
    { title: '时间安排' },
    { title: '报名参数' },
    { title: '选择项目' },
    { title: '项目设置' },
    { title: '更多设置' }
]

// 页面标题
const pageTitle = computed(() => {
    return isEditMode.value ? '编辑比赛' : '创建比赛'
})

// 当前步骤和最大到达步骤
const currentStep = ref(1)
const maxReachedStep = ref(1)

// 编辑模式相关
const isEditMode = ref(false) // 是否为编辑模式
const eventId = ref(0) // 编辑时的赛事ID

/**
 * 获取步骤标题第一行
 */
const getStepTitleLine1 = (title: string) => {
    const titleMap: Record<string, string> = {
        '基本信息': '基本',
        '地点信息': '地点',
        '时间安排': '时间',
        '报名参数': '报名',
        '选择项目': '选择',
        '项目设置': '项目',
        '更多设置': '更多'
    }
    return titleMap[title] || title
}

/**
 * 获取步骤标题第二行
 */
const getStepTitleLine2 = (title: string) => {
    const titleMap: Record<string, string> = {
        '基本信息': '信息',
        '地点信息': '信息',
        '时间安排': '安排',
        '报名参数': '参数',
        '选择项目': '项目',
        '项目设置': '设置',
        '更多设置': '设置'
    }
    return titleMap[title] || ''
}

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
    registration_start_time: string
    registration_end_time: string
    organizer_id: number
    event_type: number
    series_id: number
    year: number
    age_groups: string[]
    items: Item[]
    custom_groups: CustomGroup[]
    co_organizers: CoOrganizer[]
    signup_fields: SignupField[]
}

interface SignupField {
    key: string
    label: string
    required: boolean
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
    registration_start_time: '', // 报名开始时间
    registration_end_time: '',   // 报名结束时间
    organizer_id: 0,           // 主办方ID
    event_type: 1,             // 赛事类型：1独立赛事 2系列赛事
    series_id: 0,              // 系列赛ID
    year: new Date().getFullYear(), // 举办年份
    age_groups: ['不限年龄'],    // 年龄组设置，默认不限年龄
    items: [],                 // 比赛项目
    custom_groups: [],         // 自定义分组
    co_organizers: [],          // 协办方
    signup_fields: []
})

// 项目选择相关数据
const selectedItems = ref<number[]>([])

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

// 赛事项目数据
const eventItems = ref<any[]>([])

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

// 报名时间相关
const registrationStartDateValue = ref('')
const registrationStartTimeValue = ref('')
const registrationEndDateValue = ref('')
const registrationEndTimeValue = ref('')
const registrationStartDateDisplay = ref('')
const registrationStartTimeDisplay = ref('')
const registrationEndDateDisplay = ref('')
const registrationEndTimeDisplay = ref('')

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
            
            // 恢复报名时间显示
            if (parsedData.registration_start_time) {
                const [date, time] = parsedData.registration_start_time.split(' ')
                registrationStartDateValue.value = date
                registrationStartTimeValue.value = time || '00:00'
                registrationStartDateDisplay.value = formatDate(date)
                registrationStartTimeDisplay.value = time || '00:00'
            } else if (parsedData.registrationStartDateValue) {
                registrationStartDateValue.value = parsedData.registrationStartDateValue
                registrationStartTimeValue.value = parsedData.registrationStartTimeValue || '00:00'
                registrationStartDateDisplay.value = formatDate(parsedData.registrationStartDateValue)
                registrationStartTimeDisplay.value = parsedData.registrationStartTimeValue || '00:00'
            }
            
            if (parsedData.registration_end_time) {
                const [date, time] = parsedData.registration_end_time.split(' ')
                registrationEndDateValue.value = date
                registrationEndTimeValue.value = time || '23:59'
                registrationEndDateDisplay.value = formatDate(date)
                registrationEndTimeDisplay.value = time || '23:59'
            } else if (parsedData.registrationEndDateValue) {
                registrationEndDateValue.value = parsedData.registrationEndDateValue
                registrationEndTimeValue.value = parsedData.registrationEndTimeValue || '23:59'
                registrationEndDateDisplay.value = formatDate(parsedData.registrationEndDateValue)
                registrationEndTimeDisplay.value = parsedData.registrationEndTimeValue || '23:59'
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
        registration_start_time: '',
        registration_end_time: '',
        custom_groups: [],
        event_type: 1,
        series_id: 0,
        year: now.getFullYear(),
        age_groups: ['不限年龄'],
        items: [],
        co_organizers: [],
        signup_fields: []
    }
    
    // 设置默认时间
    startDateValue.value = today
    startTimeValue.value = '00:00'
    endDateValue.value = today
    endTimeValue.value = '23:59'
    
    // 设置默认报名时间（与比赛时间相同）
    registrationStartDateValue.value = today
    registrationStartTimeValue.value = '00:00'
    registrationEndDateValue.value = today
    registrationEndTimeValue.value = '23:59'
    formData.value.registration_start_time = `${today} 00:00`
    formData.value.registration_end_time = `${today} 23:59`
    
    // 更新显示值
    startDateDisplay.value = formatDate(today)
    startTimeDisplay.value = '00:00'
    endDateDisplay.value = formatDate(today)
    endTimeDisplay.value = '23:59'
    registrationStartDateDisplay.value = formatDate(today)
    registrationStartTimeDisplay.value = '00:00'
    registrationEndDateDisplay.value = formatDate(today)
    registrationEndTimeDisplay.value = '23:59'
    
    // 更新时间戳
    updateStartTimestamp()
    updateEndTimestamp()
}

// 保存表单数据到缓存
const saveFormDataToCache = () => {
    // 只有创建模式才保存缓存
    if (isEditMode.value) {
        return
    }
    
    try {
        const cacheData = {
            formData: formData.value,
            selectedItems: selectedItems.value,
            startDateValue: startDateValue.value,
            startTimeValue: startTimeValue.value,
            endDateValue: endDateValue.value,
            endTimeValue: endTimeValue.value,
            registrationStartDateValue: registrationStartDateValue.value,
            registrationStartTimeValue: registrationStartTimeValue.value,
            registrationEndDateValue: registrationEndDateValue.value,
            registrationEndTimeValue: registrationEndTimeValue.value
        }
        uni.setStorageSync('sport_event_form_data', JSON.stringify(cacheData))
    } catch (e) {
        console.error('保存表单数据到缓存失败:', e)
    }
}

// 监听表单数据变化，自动保存到缓存
watch(formData, () => {
    saveFormDataToCache()
}, { deep: true })

// 监听选择项目变化，自动保存到缓存
watch(selectedItems, () => {
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
        let finalLocationDetail = formData.value.location
        if (formData.value.address_detail) {
            finalLocationDetail += (finalLocationDetail ? ' ' : '') + formData.value.address_detail
        }
        
        // 提交数据
        const submitData: any = {
            name: formData.value.name,
            location: formData.value.location,
            location_detail: finalLocationDetail,
            address_detail: formData.value.address_detail || '',
            latitude: formData.value.lat ? parseFloat(formData.value.lat) : null,
            longitude: formData.value.lng ? parseFloat(formData.value.lng) : null,
            start_time: formData.value.start_time,
            end_time: formData.value.end_time,
            registration_start_time: formData.value.registration_start_time || '',
            registration_end_time: formData.value.registration_end_time || '',
            organizer_id: formData.value.organizer_id,
            event_type: formData.value.event_type,
            series_id: formData.value.series_id,
            year: formData.value.year,
            age_groups: JSON.stringify(formData.value.age_groups),
            age_group_display: formData.value.age_groups.length > 1 && !formData.value.age_groups.includes('不限年龄') ? 1 : 0,
            signup_fields: formData.value.signup_fields
        }
        
        let result: any
        
        if (isEditMode.value) {
            // 编辑模式：更新赛事
            result = await editEvent(eventId.value, submitData)
            
            // 更新比赛项目
            if (selectedItems.value.length > 0) {
                try {
                    await saveEventItems({
                        event_id: eventId.value,
                        base_item_ids: selectedItems.value
                    })
                    console.log('比赛项目更新成功:', selectedItems.value)
                } catch (error) {
                    console.error('更新比赛项目失败:', error)
                    uni.showToast({
                        title: '赛事更新成功，但项目更新失败',
                        icon: 'none'
                    })
                }
            }
            
            // 第6步时，保存项目设置
            if (currentStep.value === 6 && eventItems.value && eventItems.value.length > 0) {
                try {
                    console.log('=== 第6步：开始保存项目设置 ===')
                    const settingsResult = await saveItemSettings()
                    if (settingsResult) {
                        console.log('项目设置保存成功')
                    } else {
                        console.error('项目设置保存失败')
                        uni.showToast({
                            title: '赛事更新成功，但项目设置保存失败',
                            icon: 'none'
                        })
                    }
                } catch (error) {
                    console.error('保存项目设置时出错:', error)
                    uni.showToast({
                        title: '赛事更新成功，但项目设置保存失败',
                        icon: 'none'
                    })
                }
            }
            
            uni.showToast({
                title: '保存修改成功',
                icon: 'success'
            })
            
            // 延迟跳转到赛事详情页面
            setTimeout(() => {
                uni.redirectTo({
                    url: `/addon/sport/pages/event/detail?id=${eventId.value}`
                })
            }, 1500)
            
        } else {
            // 创建模式：新增赛事
            result = await addEvent(submitData)
            
            // 保存选择的比赛项目
            if (selectedItems.value.length > 0) {
                try {
                    await saveEventItems({
                        event_id: result.data.id,
                        base_item_ids: selectedItems.value
                    })
                    console.log('比赛项目保存成功:', selectedItems.value)
                } catch (error) {
                    console.error('保存比赛项目失败:', error)
                    uni.showToast({
                        title: '比赛创建成功，但项目保存失败',
                        icon: 'none'
                    })
                }
            }
            
            // 第6步时，保存项目设置
            if (currentStep.value === 6 && eventItems.value && eventItems.value.length > 0) {
                try {
                    console.log('=== 第6步：开始保存项目设置 ===')
                    const settingsResult = await saveItemSettings()
                    if (settingsResult) {
                        console.log('项目设置保存成功')
                    } else {
                        console.error('项目设置保存失败')
                        uni.showToast({
                            title: '比赛创建成功，但项目设置保存失败',
                            icon: 'none'
                    })
                    }
                } catch (error) {
                    console.error('保存项目设置时出错:', error)
                    uni.showToast({
                        title: '比赛创建成功，但项目设置保存失败',
                        icon: 'none'
                    })
                }
            }
            
            // 创建成功后清除缓存
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
        }
        
    } catch (error) {
        console.error(isEditMode.value ? '保存修改失败:' : '创建比赛失败:', error)
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
            return formData.value.start_time > 0 && formData.value.end_time > 0 && formData.value.start_time < formData.value.end_time
        case 4:
            // 第4步：报名参数，必须至少选择了一个字段，且必填字段数量合理
            if (formData.value.signup_fields.length === 0) {
                return false
            }
            const requiredFields = formData.value.signup_fields.filter(f => f.required)
            // 如果总字段数少于3个，则所有字段都必须是必填的
            // 如果总字段数大于等于3个，则必填字段数不能为0
            if (formData.value.signup_fields.length < 3) {
                return requiredFields.length === formData.value.signup_fields.length
            } else {
                return requiredFields.length > 0
            }
        case 5:
            // 第5步：要求选择项目
            return selectedItems.value.length > 0
        case 6:
            // 第6步：项目设置，检查是否所有项目都已配置
            if (!eventItems.value || eventItems.value.length === 0) {
                return false
            }
            // 检查是否所有项目都有基本配置
            return eventItems.value.every(item => {
                return item && 
                       item.registration_fee !== undefined && 
                       item.max_participants !== undefined && 
                       item.allow_duplicate_registration !== undefined &&
                       item.is_round_robin !== undefined &&
                       item.group_size !== undefined
            })
        default:
            return false
    }
})

// 步骤控制
const goToStep = (step: number) => {
    // 允许跳转到当前步骤或已完成的步骤，以及下一步（如果满足条件）
    if (step <= maxReachedStep.value || (step === currentStep.value + 1 && canProceedToNext.value)) {
        currentStep.value = step
        
        // 如果跳转到第5步，确保加载分类数据
        if (step === 5) {
            // 如果是编辑模式且还没有加载赛事数据，先加载赛事数据
            if (isEditMode.value && eventId.value && selectedItems.value.length === 0) {
                loadEventData().then(() => {
                    // 赛事数据加载完成后，再加载分类数据
                    if (categories.value.length === 0) {
                        loadCategories()
                    }
                })
            } else if (categories.value.length === 0) {
                loadCategories()
            }
        }
        
        // 如果跳转到第6步，确保初始化项目数据
        if (step === 6) {
            // 确保有选中的项目
            if (selectedItems.value.length > 0) {
                initEventItems()
            }
        }
        
        // 更新最大到达步骤
        if (step > maxReachedStep.value) {
            maxReachedStep.value = step
        }
    }
}

const nextStep = async () => {
    if (currentStep.value === 3) {
        // 第3步特殊处理：检查时间有效性
        if (!formData.value.start_time || !formData.value.end_time) {
            uni.showToast({
                title: '请选择开始时间和结束时间',
                icon: 'none'
            })
            return
        }
        if (formData.value.start_time >= formData.value.end_time) {
            uni.showToast({
                title: '结束时间必须大于开始时间',
                icon: 'none'
            })
            return
        }
    }
    
    if (currentStep.value === 6) {
        // 第6步特殊处理：保存项目设置并进入第7步
        try {
            console.log('=== 第6步：点击下一步，开始保存项目设置 ===')
            
            // 检查是否有项目设置需要保存
            if (eventItems.value && eventItems.value.length > 0) {
                const settingsResult = await saveItemSettings()
                if (settingsResult) {
                    console.log('项目设置保存成功，进入第7步')
                    
                    // 保存成功后进入第7步
                    currentStep.value = 7
                    if (currentStep.value > maxReachedStep.value) {
                        maxReachedStep.value = currentStep.value
                    }
                    
                    uni.showToast({
                        title: '项目设置已保存',
                        icon: 'success',
                        duration: 1500
                    })
                } else {
                    console.error('项目设置保存失败')
                    uni.showToast({
                        title: '项目设置保存失败，请重试',
                        icon: 'none',
                        duration: 3000
                    })
                    return
                }
            } else {
                console.log('没有项目设置需要保存，直接进入第7步')
                currentStep.value = 7
                if (currentStep.value > maxReachedStep.value) {
                    maxReachedStep.value = currentStep.value
                }
            }
        } catch (error) {
            console.error('第6步保存项目设置时出错:', error)
            uni.showToast({
                title: '保存失败，请重试',
                icon: 'none',
                duration: 3000
            })
            return
        }
    } else if (canProceedToNext.value && currentStep.value < 6) {
        // 其他步骤的正常处理
        // 第4步特殊验证：检查必填字段数量
        if (currentStep.value === 4) {
            if (formData.value.signup_fields.length === 0) {
                uni.showToast({
                    title: '请至少选择一个报名字段',
                    icon: 'none'
                })
                return
            }
            const requiredFields = formData.value.signup_fields.filter(f => f.required)
            if (formData.value.signup_fields.length < 3 && requiredFields.length !== formData.value.signup_fields.length) {
                uni.showToast({
                    title: '请将所有选择的字段设为必填',
                    icon: 'none'
                })
                return
            } else if (formData.value.signup_fields.length >= 3 && requiredFields.length === 0) {
                uni.showToast({
                    title: '请至少设置一个必填字段',
                    icon: 'none'
                })
                return
            }
        }
        
        currentStep.value++
        if (currentStep.value > maxReachedStep.value) {
            maxReachedStep.value = currentStep.value
        }
        
        // 进入第5步时加载分类数据
        if (currentStep.value === 5) {
            loadCategories()
        }
        
        // 进入第6步时初始化项目数据
        if (currentStep.value === 6) {
            initEventItems()
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
    // 验证报名时间
    validateRegistrationTime()
}

const onEndTimeChange = (e: any) => {
    endTimeValue.value = e.detail.value
    endTimeDisplay.value = e.detail.value
    updateEndTimestamp()
    // 验证时间
    validateTime()
}

/**
 * 报名时间选择
 */
const onRegistrationStartDateChange = (e: any) => {
    registrationStartDateValue.value = e.detail.value
    registrationStartDateDisplay.value = formatDate(e.detail.value)
    formData.value.registration_start_time = e.detail.value
    
    // 验证报名时间
    validateRegistrationTime()
}

const onRegistrationEndDateChange = (e: any) => {
    registrationEndDateValue.value = e.detail.value
    registrationEndDateDisplay.value = formatDate(e.detail.value)
    formData.value.registration_end_time = e.detail.value
    
    // 验证报名时间
    validateRegistrationTime()
}

/**
 * 报名时间选择
 */
const onRegistrationStartTimeChange = (e: any) => {
    registrationStartTimeValue.value = e.detail.value
    registrationStartTimeDisplay.value = e.detail.value
    formData.value.registration_start_time = `${registrationStartDateValue.value} ${e.detail.value}`
    
    // 验证报名时间
    validateRegistrationTime()
}

const onRegistrationEndTimeChange = (e: any) => {
    registrationEndTimeValue.value = e.detail.value
    registrationEndTimeDisplay.value = e.detail.value
    formData.value.registration_end_time = `${registrationEndDateValue.value} ${e.detail.value}`
    
    // 验证报名时间
    validateRegistrationTime()
}

/**
 * 验证报名时间
 */
const validateRegistrationTime = () => {
    // 如果报名结束时间大于比赛结束时间，自动调整为比赛结束时间
    if (registrationEndDateValue.value && endDateValue.value) {
        const registrationEndDate = new Date(registrationEndDateValue.value)
        const eventEndDate = new Date(endDateValue.value)
        
        if (registrationEndDate > eventEndDate) {
            registrationEndDateValue.value = endDateValue.value
            registrationEndDateDisplay.value = formatDate(endDateValue.value)
            formData.value.registration_end_time = endDateValue.value
            
            uni.showToast({
                title: '报名结束时间已调整为比赛结束时间',
                icon: 'none'
            })
        }
    }
    
    // 如果报名开始时间大于报名结束时间，自动调整
    if (registrationStartDateValue.value && registrationEndDateValue.value) {
        const registrationStartDate = new Date(registrationStartDateValue.value)
        const registrationEndDate = new Date(registrationEndDateValue.value)
        
        if (registrationStartDate > registrationEndDate) {
            registrationEndDateValue.value = registrationStartDateValue.value
            registrationEndDateDisplay.value = formatDate(registrationStartDateValue.value)
            formData.value.registration_end_time = registrationStartDateValue.value
            
            uni.showToast({
                title: '报名结束时间已调整为报名开始时间',
                icon: 'none'
            })
        }
    }
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
    return tempSelectedItems.value.includes(item.id)
}

const toggleMockItem = (item: any) => {
    const index = tempSelectedItems.value.indexOf(item.id)
    if (index > -1) {
        tempSelectedItems.value.splice(index, 1)
    } else {
        tempSelectedItems.value.push(item.id)
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
 * 初始化默认时间值
 */
const initDefaultTimeValues = () => {
    const now = new Date()
    const today = now.toISOString().slice(0, 10) // YYYY-MM-DD
    startDateValue.value = today
    startTimeValue.value = '00:00'
    endDateValue.value = today
    endTimeValue.value = '23:59'
    startDateDisplay.value = formatDate(today)
    startTimeDisplay.value = '00:00'
    endDateDisplay.value = formatDate(today)
    endTimeDisplay.value = '23:59'
    
    // 更新时间戳
    updateStartTimestamp()
    updateEndTimestamp()
}

/**
 * 加载现有赛事数据（编辑模式）
 */
const loadEventData = async () => {
    if (!eventId.value) return
    
    try {
        // 显示加载提示
        uni.showLoading({
            title: '加载中...'
        })
        // 加载赛事基本信息
        const eventResponse: any = await getEventInfo(eventId.value)
        const eventData = eventResponse.data
        
        // 处理地址字段
        let fullAddress = eventData.location || ''
        let addressDetail = eventData.address_detail || ''
        
        // 如果没有address_detail字段，尝试从location_detail中分离
        if (!addressDetail && eventData.location_detail) {
            const locationDetail = eventData.location_detail
            // 如果location_detail包含location，则分离出详细地址
            if (locationDetail.startsWith(fullAddress)) {
                addressDetail = locationDetail.substring(fullAddress.length).trim()
            } else {
                // 如果location_detail不包含location，则整个作为详细地址
                addressDetail = locationDetail
            }
        }
        
        // 填充表单数据
        formData.value = {
            name: eventData.name || '',
            location: eventData.location || '',
            lng: eventData.longitude || eventData.lng || '',
            lat: eventData.latitude || eventData.lat || '',
            full_address: fullAddress,
            address_detail: addressDetail,
            start_time: eventData.start_time || 0,
            end_time: eventData.end_time || 0,
            registration_start_time: eventData.registration_start_time || '',
            registration_end_time: eventData.registration_end_time || '',
            organizer_id: eventData.organizer_id || 0,
            event_type: eventData.event_type || 1,
            series_id: eventData.series_id || 0,
            year: eventData.year || new Date().getFullYear(),
            age_groups: eventData.age_groups ? (typeof eventData.age_groups === 'string' ? JSON.parse(eventData.age_groups) : eventData.age_groups) : ['不限年龄'],
            items: [],
            custom_groups: [],
            co_organizers: [],
            signup_fields: eventData.signup_fields || []
        }
        
        // 设置时间选择器的值
        if (eventData.start_time) {
            const startDate = new Date(eventData.start_time * 1000)
            startDateValue.value = startDate.toISOString().slice(0, 10)
            startTimeValue.value = startDate.toTimeString().slice(0, 5)
            startDateDisplay.value = formatDate(startDateValue.value)
            startTimeDisplay.value = startTimeValue.value
        }
        
        if (eventData.end_time) {
            const endDate = new Date(eventData.end_time * 1000)
            endDateValue.value = endDate.toISOString().slice(0, 10)
            endTimeValue.value = endDate.toTimeString().slice(0, 5)
            endDateDisplay.value = formatDate(endDateValue.value)
            endTimeDisplay.value = endTimeValue.value
        }
        
        // 设置报名时间选择器的值
        if (eventData.registration_start_time) {
            const [date, time] = eventData.registration_start_time.split(' ')
            registrationStartDateValue.value = date
            registrationStartTimeValue.value = time || '00:00'
            registrationStartDateDisplay.value = formatDate(date)
            registrationStartTimeDisplay.value = time || '00:00'
        } else {
            // 如果报名时间为空，默认与比赛时间相同
            registrationStartDateValue.value = startDateValue.value
            registrationStartTimeValue.value = startTimeValue.value
            registrationStartDateDisplay.value = startDateDisplay.value
            registrationStartTimeDisplay.value = startTimeDisplay.value
            formData.value.registration_start_time = `${startDateValue.value} ${startTimeValue.value}`
        }
        
        if (eventData.registration_end_time) {
            const [date, time] = eventData.registration_end_time.split(' ')
            registrationEndDateValue.value = date
            registrationEndTimeValue.value = time || '23:59'
            registrationEndDateDisplay.value = formatDate(date)
            registrationEndTimeDisplay.value = time || '23:59'
        } else {
            // 如果报名时间为空，默认与比赛时间相同
            registrationEndDateValue.value = endDateValue.value
            registrationEndTimeValue.value = endTimeValue.value
            registrationEndDateDisplay.value = endDateDisplay.value
            registrationEndTimeDisplay.value = endTimeDisplay.value
            formData.value.registration_end_time = `${endDateValue.value} ${endTimeValue.value}`
        }
        
        // 加载赛事项目
        const itemsResponse: any = await getEventItems(eventId.value)
        const items = itemsResponse.data || []
        selectedItems.value = items.map((item: any) => item.base_item_id || item.id)
        tempSelectedItems.value = [...selectedItems.value]
        
        // 更新步骤状态 - 编辑模式下允许访问所有步骤
        maxReachedStep.value = 5
        
        // 等待主办方和系列赛列表加载完成后再设置显示名称
        setTimeout(() => {
            // 触发计算属性重新计算
            console.log('主办方列表:', organizerList.value)
            console.log('系列赛列表:', seriesList.value)
            console.log('选中的主办方ID:', formData.value.organizer_id)
            console.log('选中的系列赛ID:', formData.value.series_id)
            
            // 检查主办方和系列赛是否在列表中
            const organizerExists = organizerList.value.some((org: any) => org.id === formData.value.organizer_id)
            const seriesExists = seriesList.value.some((series: any) => series.id === formData.value.series_id)
            
            if (!organizerExists) {
                console.warn('主办方不在列表中，可能需要重新选择')
            }
            if (!seriesExists && formData.value.event_type === 2) {
                console.warn('系列赛不在列表中，可能需要重新选择')
            }
        }, 100)
        
        console.log('编辑模式：加载赛事数据成功', eventData)
        
    } catch (error) {
        console.error('加载赛事数据失败:', error)
        uni.showToast({
            title: '加载赛事数据失败',
            icon: 'none'
        })
        // 加载失败时返回上一页
        setTimeout(() => {
            uni.navigateBack()
        }, 1500)
    } finally {
        // 隐藏加载提示
        uni.hideLoading()
    }
}

/**
 * 页面初始化
 */
onMounted(() => {
    requireLogin(() => {
        // 获取页面参数
        const pages = getCurrentPages()
        const currentPage = pages[pages.length - 1] as any
        const options = currentPage.options || {}
        
        // 加载基础数据
        loadOrganizerList()
        loadSeriesList()
        
        // 检查是否为编辑模式
        if (options.id && options.mode === 'edit') {
            // 编辑模式：清空所有数据，加载现有赛事数据
            isEditMode.value = true
            eventId.value = parseInt(options.id)
            
            // 清空表单数据
            formData.value = {
                name: '',
                location: '',
                lng: '',
                lat: '',
                full_address: '',
                address_detail: '',
                start_time: 0,
                end_time: 0,
                registration_start_time: '',
                registration_end_time: '',
                organizer_id: 0,
                event_type: 1,
                series_id: 0,
                year: new Date().getFullYear(),
                age_groups: ['不限年龄'],
                items: [],
                custom_groups: [],
                co_organizers: [],
                signup_fields: []
            }
            
            // 清空选择的数据
            selectedItems.value = []
            tempSelectedItems.value = []
            
            // 清空时间选择器（使用默认时间）
            const now = new Date()
            const today = now.toISOString().slice(0, 10)
            startDateValue.value = today
            startTimeValue.value = '00:00'
            endDateValue.value = today
            endTimeValue.value = '23:59'
            startDateDisplay.value = formatDate(today)
            startTimeDisplay.value = '00:00'
            endDateDisplay.value = formatDate(today)
            endTimeDisplay.value = '23:59'
            
            // 更新时间戳
            updateStartTimestamp()
            updateEndTimestamp()
            
            // 等待基础数据加载完成后再加载赛事数据
            setTimeout(() => {
                loadEventData()
            }, 500)
            
        } else {
            // 创建模式：先清空数据，然后读取缓存（如果有）
            isEditMode.value = false
            eventId.value = 0
            
            // 清空表单数据
            formData.value = {
                name: '',
                location: '',
                lng: '',
                lat: '',
                full_address: '',
                address_detail: '',
                start_time: 0,
                end_time: 0,
                registration_start_time: '',
                registration_end_time: '',
                organizer_id: 0,
                event_type: 1,
                series_id: 0,
                year: new Date().getFullYear(),
                age_groups: ['不限年龄'],
                items: [],
                custom_groups: [],
                co_organizers: [],
                signup_fields: []
            }
            
            // 清空选择的数据
            selectedItems.value = []
            tempSelectedItems.value = []
            
            // 读取缓存数据（如果有）
            const cachedData = uni.getStorageSync('sport_event_form_data')
            if (cachedData) {
                try {
                    const parsedData = JSON.parse(cachedData)
                    // 恢复表单数据
                    formData.value = { ...formData.value, ...parsedData.formData }
                    selectedItems.value = parsedData.selectedItems || []
                    tempSelectedItems.value = [...selectedItems.value]
                    
                    // 恢复时间选择器
                    if (parsedData.startDateValue) {
                        startDateValue.value = parsedData.startDateValue
                        startTimeValue.value = parsedData.startTimeValue
                        endDateValue.value = parsedData.endDateValue
                        endTimeValue.value = parsedData.endTimeValue
                        startDateDisplay.value = formatDate(parsedData.startDateValue)
                        startTimeDisplay.value = parsedData.startTimeValue
                        endDateDisplay.value = formatDate(parsedData.endDateValue)
                        endTimeDisplay.value = parsedData.endTimeValue
                        
                        // 更新时间戳
                        updateStartTimestamp()
                        updateEndTimestamp()
                    }
                    
                    console.log('创建模式：从缓存恢复数据成功')
                } catch (error) {
                    console.error('缓存数据解析失败:', error)
                    // 缓存数据损坏，使用默认值
                    initDefaultTimeValues()
                }
            } else {
                // 没有缓存，使用默认值
                initDefaultTimeValues()
            }
        }
        
        // 设置页面标题
        uni.setNavigationBarTitle({
            title: pageTitle.value
        })
    }, '/addon/sport/pages/event/create_simple')

    // 初始化项目选择等其他逻辑
    tempSelectedItems.value = [...selectedItems.value]

    // 首次创建默认选择：姓名、手机、身份证号（三个必填）
    if (!isEditMode.value && (!formData.value.signup_fields || formData.value.signup_fields.length === 0)) {
        const defaults = ['name','mobile','id_card']
        formData.value.signup_fields = defaults.map(k => {
            const opt = allSignupFieldOptions.find(o => o.key === k)!
            return { key: k, label: opt.label, required: true }
        })
    }
})

// 表单数据
const showItemSelect = ref(false)
const tempSelectedItems = ref<number[]>([])

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

// 项目选择相关数据
const categories = ref<any[]>([])
const expandedCategories = ref<number[]>([])
const categoriesLoading = ref(false)
const categoriesError = ref('')

const filteredCategories = computed(() => {
    return categories.value
})

// 获取项目名称
const getItemNameById = (id: number) => {
    const findItemInCategory = (category: any): any => {
        // 检查当前分类的基础项目
        if (category.base_items) {
            const item = category.base_items.find((i: any) => i.id === id)
            if (item) return item
        }
        
        // 递归检查子分类
        if (category.children) {
            for (const child of category.children) {
                const item = findItemInCategory(child)
                if (item) return item
            }
        }
        
        return null
    }
    
    for (const cat of categories.value) {
        const item = findItemInCategory(cat)
        if (item) return item.name
    }
    return ''
}

// 获取分类总项目数
const getTotalItemCount = (category: any) => {
    return category.total_item_count || category.base_items?.length || 0
}

// 获取分类已选项目数
const getSelectedItemCount = (category: any) => {
    let count = 0
    
    // 检查当前分类的基础项目
    if (category.base_items) {
        count += category.base_items.filter((item: any) => selectedItems.value.includes(item.id)).length
    }
    
    // 递归检查子分类
    if (category.children) {
        for (const child of category.children) {
            count += getSelectedItemCount(child)
        }
    }
    
    return count
}



// 切换分类展开/收起
const toggleCategory = (categoryId: number) => {
    const index = expandedCategories.value.indexOf(categoryId)
    if (index > -1) {
        expandedCategories.value.splice(index, 1)
    } else {
        expandedCategories.value.push(categoryId)
    }
}

// 切换项目选择状态
const toggleItem = (itemId: number) => {
    const index = selectedItems.value.indexOf(itemId)
    if (index > -1) {
        selectedItems.value.splice(index, 1)
    } else {
        selectedItems.value.push(itemId)
    }
}

// 清空所有选择
const clearAllItems = () => {
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

// 分类数据加载
const loadCategories = async () => {
    try {
        categoriesLoading.value = true
        categoriesError.value = ''
        
        const response: any = await getEventCategories()
        console.log('分类数据:', response.data)
        
        categories.value = response.data.categories || []
        
        // 设置默认展开的分类
        const defaultExpandCategories: number[] = []
        categories.value.forEach(category => {
            if (category.default_expand) {
                defaultExpandCategories.push(category.id)
            }
        })
        
        // 如果是编辑模式且有选中的项目，展开包含这些项目的分类
        if (isEditMode.value && selectedItems.value.length > 0) {
            const categoriesWithSelectedItems = findCategoriesWithSelectedItems(categories.value)
            defaultExpandCategories.push(...categoriesWithSelectedItems)
        }
        
        expandedCategories.value = [...new Set(defaultExpandCategories)] // 去重
        
    } catch (err: any) {
        console.error('加载分类失败:', err)
        categoriesError.value = err.message || '加载失败'
    } finally {
        categoriesLoading.value = false
    }
}

// 查找包含选中项目的分类
const findCategoriesWithSelectedItems = (categories: any[]): number[] => {
    const result: number[] = []
    
    const checkCategory = (category: any) => {
        // 检查当前分类是否有选中的项目
        if (category.base_items) {
            const hasSelectedItems = category.base_items.some((item: any) => 
                selectedItems.value.includes(item.id)
            )
            if (hasSelectedItems) {
                result.push(category.id)
            }
        }
        
        // 递归检查子分类
        if (category.children) {
            category.children.forEach((child: any) => {
                checkCategory(child)
            })
        }
    }
    
    categories.forEach(checkCategory)
    return result
}

// 实时同步到formData.items
watch(selectedItems, (val) => {
    formData.value.items = val.map(id => ({ id, name: getItemNameById(id) }))
})

// 按分类分组的赛事项目
const groupedEventItems = computed(() => {
    if (!eventItems.value || !eventItems.value.length) return []
    
    const groups: Record<string, any[]> = {}
    
    eventItems.value.forEach(item => {
        if (item) {
            const categoryName = item.category_name || '其他'
            if (!groups[categoryName]) {
                groups[categoryName] = []
            }
            groups[categoryName].push(item)
        }
    })
    
    return Object.entries(groups).map(([categoryName, items]) => ({
        categoryName,
        items
    }))
})

// 报名参数选项
const allSignupFieldOptions = [
    // 基础身份信息
    { key: 'name', label: '姓名' },
    { key: 'gender', label: '性别' },
    { key: 'birthday', label: '生日' },
    { key: 'id_card', label: '身份证号' },
    // 联系方式
    { key: 'mobile', label: '手机' },
    { key: 'wechat', label: '微信号' },
    { key: 'qq', label: 'QQ号' },
    { key: 'email', label: '邮箱' },
    // 地址/单位
    { key: 'org', label: '单位' },
    { key: 'title', label: '职称' },
    { key: 'address', label: '地址' },
    // 学校类（青少年）
    { key: 'school', label: '学校' },
    { key: 'grade', label: '年级' },
    { key: 'class', label: '班级' },
    { key: 'student_no', label: '学号' },
    // 紧急联系人/监护人
    { key: 'guardian_name', label: '监护人姓名' },
    { key: 'guardian_mobile', label: '监护人手机' },
    { key: 'emergency_contact', label: '紧急联系人' },
    { key: 'emergency_mobile', label: '紧急联系电话' },
    // 健康/装备
    { key: 'blood_type', label: '血型' },
    { key: 'allergy', label: '过敏史' },
    { key: 'medical_history', label: '既往病史' },
    { key: 'tshirt_size', label: 'T恤尺码' },
    // 其他
    { key: 'number', label: '编号' }
]

const isSignupFieldChecked = (key: string) => {
    return formData.value.signup_fields.some(f => f.key === key)
}

const toggleSignupField = (key: string) => {
    const idx = formData.value.signup_fields.findIndex(f => f.key === key)
    if (idx > -1) {
        formData.value.signup_fields.splice(idx, 1)
    } else {
        const option = allSignupFieldOptions.find(o => o.key === key)
        if (option) formData.value.signup_fields.push({ key, label: option.label, required: false })
    }
}

const setSignupFieldRequired = (key: string, required: boolean) => {
    const target = formData.value.signup_fields.find(f => f.key === key)
    if (target) target.required = required
}

// 分组数据
const signupFieldGroups = [
    {
        key: 'basic',
        title: '基础信息',
        options: [
            { key: 'name', label: '姓名' },
            { key: 'gender', label: '性别' },
            { key: 'birthday', label: '生日' },
            { key: 'id_card', label: '身份证号' }
        ]
    },
    {
        key: 'contact',
        title: '联系方式',
        options: [
            { key: 'mobile', label: '手机' },
            { key: 'wechat', label: '微信号' },
            { key: 'qq', label: 'QQ号' },
            { key: 'email', label: '邮箱' },
            { key: 'address', label: '地址' }
        ]
    },
    {
        key: 'org',
        title: '单位/学校',
        options: [
            { key: 'org', label: '单位' },
            { key: 'title', label: '职称' },
            { key: 'school', label: '学校' },
            { key: 'grade', label: '年级' },
            { key: 'class', label: '班级' },
            { key: 'student_no', label: '学号' }
        ]
    },
    {
        key: 'guardian',
        title: '监护与紧急',
        options: [
            { key: 'guardian_name', label: '监护人姓名' },
            { key: 'guardian_mobile', label: '监护人手机' },
            { key: 'emergency_contact', label: '紧急联系人' },
            { key: 'emergency_mobile', label: '紧急联系电话' }
        ]
    },
    {
        key: 'health',
        title: '健康与装备',
        options: [
            { key: 'blood_type', label: '血型' },
            { key: 'allergy', label: '过敏史' },
            { key: 'medical_history', label: '既往病史' },
            { key: 'tshirt_size', label: 'T恤尺码' }
        ]
    },
    {
        key: 'other',
        title: '其他',
        options: [
            { key: 'number', label: '编号' },
            { key: 'leader', label: '领队' },
            { key: 'team_name', label: '团队名称' }
        ]
    }
]

// 自定义字段
const customFields = ref<SignupField[]>([])
const customFieldName = ref('')
const addCustomField = () => {
    const name = customFieldName.value.trim()
    if (!name) return
    // 生成唯一key
    const key = `custom_${Date.now()}`
    const field: SignupField = { key, label: name, required: false }
    customFields.value.push(field)
    // 自动加入选中集合
    formData.value.signup_fields.push(field)
    customFieldName.value = ''
}

const removeCustomField = (key: string) => {
    // 从自定义字段列表移除
    const customIndex = customFields.value.findIndex(f => f.key === key)
    if (customIndex > -1) {
        customFields.value.splice(customIndex, 1)
    }
    // 从已选字段列表移除
    const selectedIndex = formData.value.signup_fields.findIndex(f => f.key === key)
    if (selectedIndex > -1) {
        formData.value.signup_fields.splice(selectedIndex, 1)
    }
}

// 项目设置相关函数
const getCategoryColor = (categoryName: string) => {
    const colors = [
        'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
        'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)',
        'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)',
        'linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)',
        'linear-gradient(135deg, #fa709a 0%, #fee140 100%)'
    ]
    const index = categoryName.charCodeAt(0) % colors.length
    return colors[index]
}

const getCategoryBorderColor = (categoryName: string) => {
    const colors = ['#667eea', '#f093fb', '#4facfe', '#43e97b', '#fa709a']
    const index = categoryName.charCodeAt(0) % colors.length
    return colors[index]
}

const onSyncSettings = async (categoryName: string) => {
    const group = groupedEventItems.value.find(g => g.categoryName === categoryName)
    if (!group || group.items.length <= 1) return
    
    const firstItem = group.items[0]
    const syncFields = ['registration_fee', 'max_participants', 'allow_duplicate_registration', 'is_round_robin', 'group_size', 'remark']
    
    // 同步基本设置
    for (let i = 1; i < group.items.length; i++) {
        const currentItem = group.items[i]
        syncFields.forEach(field => {
            if (firstItem[field] !== undefined) {
                currentItem[field] = firstItem[field]
            }
        })
        currentItem.is_configured = true
    }
    
    // 同步场地选择
    const firstItemVenues = itemVenueAssignments.value[firstItem.id] || []
    for (let i = 1; i < group.items.length; i++) {
        const currentItem = group.items[i]
        itemVenueAssignments.value[currentItem.id] = [...firstItemVenues]
    }
    
    uni.showToast({
        title: `${categoryName}设置同步完成`,
        icon: 'success'
    })
}

const getItemGlobalIndex = (groupIndex: number, itemIndex: number) => {
    let globalIndex = 0
    for (let i = 0; i < groupIndex; i++) {
        globalIndex += groupedEventItems.value[i]?.items.length || 0
    }
    return globalIndex + itemIndex
}

const getRegistrationFeeDisplayValue = (value: any) => {
    if (value === undefined || value === null || value === '') return ''
    return value.toString()
}

const getMaxParticipantsDisplayValue = (value: any) => {
    if (value === undefined || value === null || value === '') return ''
    return value.toString()
}

const onRegistrationFeeInput = (e: any) => {
    const index = parseInt(e.target.dataset.index)
    const value = e.detail.value
    const item = eventItems.value[index]
    if (item) {
        item.registration_fee = value === '' ? 0 : parseFloat(value) || 0
        item.is_configured = true
    }
}

const onRegistrationFeeFocusEvt = (e: any) => {
    // 聚焦时的处理
}

const onRegistrationFeeBlurEvt = (e: any) => {
    const index = parseInt(e.target.dataset.index)
    const value = e.detail.value
    const item = eventItems.value[index]
    if (item) {
        item.registration_fee = value === '' ? 0 : parseFloat(value) || 0
        item.is_configured = true
    }
}

const onMaxParticipantsInput = (e: any) => {
    const index = parseInt(e.target.dataset.index)
    const value = e.detail.value
    const item = eventItems.value[index]
    if (item) {
        item.max_participants = value === '' ? 0 : parseInt(value) || 0
        item.is_configured = true
    }
}

const onMaxParticipantsBlurEvt = (e: any) => {
    const index = parseInt(e.target.dataset.index)
    const value = e.detail.value
    const item = eventItems.value[index]
    if (item) {
        item.max_participants = value === '' ? 0 : parseInt(value) || 0
        item.is_configured = true
    }
}

const onItemSwitchChangeEvt = (e: any) => {
    const itemId = parseInt(e.target.dataset.id)
    const field = e.target.dataset.field
    const value = e.detail.value
    
    const item = eventItems.value.find(item => item.id === itemId)
    if (item) {
        item[field] = value
        item.is_configured = true
    }
}

// 场地管理相关函数
const showVenueModal = (itemId: number, categoryName: string) => {
    currentItemId.value = itemId
    showVenueDialog.value = true
    
    // 根据项目类型自动设置默认场馆类型
    let defaultType = mapCategoryToVenueType(String(categoryName || '').trim())
    
    // 如果没有通过参数获取到类型，尝试从项目数据中获取
    if (!defaultType && itemId) {
        const item = eventItems.value.find((it: any) => it.id === itemId)
        if (item) {
            defaultType = mapCategoryToVenueType(String(item.category_name || '').trim())
        }
    }
    
    // 如果还是没有，基于名称关键字兜底
    if (!defaultType) {
        const text = `${categoryName || ''}`
        if (/乒乓/.test(text)) defaultType = 'pingpong_table'
        else if (/羽毛/.test(text)) defaultType = 'badminton_court'
        else if (/篮球/.test(text)) defaultType = 'basketball_court'
        else if (/足球/.test(text)) defaultType = 'football_field'
        else if (/网球/.test(text)) defaultType = 'tennis_court'
        else if (/排球/.test(text)) defaultType = 'volleyball_court'
        else if (/田径|跑/.test(text)) defaultType = 'track'
        else if (/泳/.test(text)) defaultType = 'swimming_pool'
    }
    
    // 设置默认场馆类型
    newVenue.value = {
        venue_type: defaultType || '',
        name: '',
        venue_code: '',
        location: ''
    }
    
    // 设置批量添加的默认名称前缀
    batchVenue.value.namePrefix = getVenueTypeLabel(defaultType || '') || ''
}

/**
 * 获取项目的场地类型
 */
const getItemVenueType = (item: any): string => {
    if (!item) return ''
    
    // 优先使用项目自身的venue_type
    if (item.venue_type) {
        return item.venue_type
    }
    
    // 根据category_name自动推断
    return mapCategoryToVenueType(String(item.category_name || '').trim())
}

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
 * 获取当前项目类型的场地列表（用于管理弹窗显示）
 */
const getCurrentProjectVenues = () => {
    if (!currentItemId.value || !venues.value || !Array.isArray(venues.value)) {
        return []
    }
    
    const currentItem = eventItems.value.find(item => item.id === currentItemId.value)
    if (!currentItem) {
        return []
    }
    
    // 获取项目的目标场地类型
    let targetVenueType = currentItem.venue_type
    if (!targetVenueType) {
        targetVenueType = mapCategoryToVenueType(String(currentItem.category_name || '').trim())
    }
    
    // 如果还是没有类型信息，返回空数组
    if (!targetVenueType) {
        return []
    }
    
    // 只返回与当前项目类型匹配的场地
    return venues.value.filter(venue => {
        if (!venue || !venue.id) return false
        return venue.venue_type === targetVenueType
    })
}

/**
 * 获取当前项目类型的场地类型标签
 */
const getCurrentProjectVenueTypeLabel = () => {
    if (!currentItemId.value) {
        return '未知'
    }
    
    const currentItem = eventItems.value.find(item => item.id === currentItemId.value)
    if (!currentItem) {
        return '未知'
    }
    
    // 获取项目的目标场地类型
    let targetVenueType = currentItem.venue_type
    if (!targetVenueType) {
        targetVenueType = mapCategoryToVenueType(String(currentItem.category_name || '').trim())
    }
    
    // 返回场地类型的标签
    return getVenueTypeLabel(targetVenueType) || '未知'
}



/**
 * 保存项目设置到数据库
 */
const saveItemSettings = async () => {
    if (!eventId.value || !eventItems.value || eventItems.value.length === 0) {
        console.warn('无法保存项目设置：缺少赛事ID或项目数据')
        console.warn('eventId:', eventId.value)
        console.warn('eventItems:', eventItems.value)
        return false
    }
    
    try {
        console.log('=== 开始保存项目设置 ===')
        console.log('赛事ID:', eventId.value)
        console.log('项目数量:', eventItems.value.length)
        console.log('项目列表:', eventItems.value)
        
        // 打印每个项目的详细信息，包括sport_item.id
        eventItems.value.forEach((item, index) => {
            console.log(`=== 项目${index + 1}详细信息 ===`)
            console.log('项目名称:', item.name)
            console.log('项目分类:', item.category_name)
            console.log('base_item_id (基础项目ID):', item.base_item_id)
            console.log('sport_item.id (数据库记录ID):', item.id)
            console.log('sport_item_id (映射后的ID):', item.sport_item_id)
            console.log('项目完整数据:', item)
            console.log('---')
        })
        
        // 保存每个项目的设置
        for (const item of eventItems.value) {
            console.log('--- 保存项目 ---')
            console.log('项目ID:', item.id)
            console.log('项目名称:', item.name)
            console.log('项目分类:', item.category_name)
            console.log('项目ID:', item.id)
            console.log('项目完整数据:', item)
            
            // 准备保存的数据 - 使用正确的sport_item.id
            const saveData = {
                item_id: item.sport_item_id || item.id, // 优先使用sport_item_id，兼容旧版本
                registration_fee: item.registration_fee || 0,
                max_participants: item.max_participants || 0,
                rounds: item.rounds || 0,
                allow_duplicate_registration: item.allow_duplicate_registration || false,
                is_round_robin: item.is_round_robin || false,
                group_size: item.group_size || 0,
                venue_count: item.venue_count || 0,
                venue_type: item.venue_type || '',
                remark: item.remark || ''
            }
            
            console.log('保存数据:', saveData)
            
            // 调用接口保存
            const response = await updateItemSettings(saveData)
            console.log('接口响应:', response)
            
            // 检查响应状态
            if (response && (response.code === 200 || response.code === 1)) {
                console.log(`项目 ${item.name} 保存成功`)
            } else {
                console.error(`项目 ${item.name} 保存失败:`, response)
                throw new Error(`项目 ${item.name} 保存失败: ${response?.msg || '未知错误'}`)
            }
        }
        
        console.log('=== 所有项目设置保存成功 ===')
        uni.showToast({
            title: '项目设置已保存',
            icon: 'success',
            duration: 1500
        })
        
        return true
    } catch (error) {
        console.error('=== 保存项目设置失败 ===')
        console.error('错误详情:', error)
        console.error('错误类型:', typeof error)
        console.error('错误消息:', error?.message || error?.msg || error)
        
        let errorMessage = '保存项目设置失败'
        if (error && error.msg) {
            errorMessage = error.msg
        } else if (error && error.message) {
            errorMessage = error.message
        }
        
        uni.showToast({
            title: errorMessage,
            icon: 'none',
            duration: 3000
        })
        
        return false
    }
}

const getAvailableVenuesForItem = (itemId: number) => {
    // 确保venues.value是数组
    if (!Array.isArray(venues.value)) {
        console.warn('venues.value is not an array:', venues.value)
        return []
    }

    // 确定当前项目及其目标场地类型
    const currentItem = eventItems.value.find((it: any) => it.id === itemId)
    const targetVenueType = currentItem ? (currentItem.venue_type || mapCategoryToVenueType(currentItem.category_name)) : ''

    // 共享模式：所有场地都可以选择，不再排他（与item-settings.vue保持一致）
    return venues.value.filter(venue => {
        if (!venue || !venue.id) return false
        // 类型匹配：若设置了目标类型，则要求 venue.venue_type === 目标类型
        if (targetVenueType && venue.venue_type && venue.venue_type !== targetVenueType) return false
        return true // 所有匹配类型的场地都可以选择
    })
}

const isVenueSelectedForItem = (itemId: number, venueId: number) => {
    const assignments = itemVenueAssignments.value[itemId] || []
    return assignments.some(assignment => assignment.id === venueId)
}

const toggleVenueSelection = (itemId: number, venueId: number) => {
    if (!itemVenueAssignments.value[itemId]) {
        itemVenueAssignments.value[itemId] = []
    }
    
    const assignments = itemVenueAssignments.value[itemId]
    const existingIndex = assignments.findIndex(assignment => assignment.id === venueId)
    
    if (existingIndex > -1) {
        assignments.splice(existingIndex, 1)
    } else {
        const venue = venues.value.find(v => v.id === venueId)
        if (venue) {
            assignments.push(venue)
        }
    }
}

const isAllVenuesSelected = (itemId: number) => {
    const availableVenues = getAvailableVenuesForItem(itemId)
    const selectedVenues = itemVenueAssignments.value[itemId] || []
    return availableVenues.length > 0 && selectedVenues.length === availableVenues.length
}

const toggleSelectAllVenues = (itemId: number) => {
    const availableVenues = getAvailableVenuesForItem(itemId)
    const selectedVenues = itemVenueAssignments.value[itemId] || []
    
    if (selectedVenues.length === availableVenues.length) {
        // 取消全选
        itemVenueAssignments.value[itemId] = []
    } else {
        // 全选
        itemVenueAssignments.value[itemId] = [...availableVenues]
    }
}

// 赛事设置相关函数
const onAgeGroupDisplayChange = (e: any) => {
    eventSettings.value.age_group_display = e.detail.value
}

const onShowParticipantCountChange = (e: any) => {
    eventSettings.value.show_participant_count = e.detail.value
}

const onShowProgressChange = (e: any) => {
    eventSettings.value.show_progress = e.detail.value
}

// 计算属性
const hasVenues = computed(() => {
    return venues.value && venues.value.length > 0
})

// 场馆管理相关计算属性
const newVenueTypeIndex = computed(() => {
    return getVenueTypeIndex(newVenue.value.venue_type)
})

// 初始化赛事项目数据
const initEventItems = () => {
    if (selectedItems.value.length === 0) {
        eventItems.value = []
        return
    }
    
    // 从选中的项目创建eventItems
    eventItems.value = selectedItems.value.map((itemId, index) => {
        const itemName = getItemNameById(itemId)
        const categoryName = getItemCategoryName(itemId)
        
        return {
            id: itemId,
            name: itemName,
            category_name: categoryName,
            registration_fee: 0,
            max_participants: 0,
            allow_duplicate_registration: false,
            is_round_robin: false,
            group_size: 0,
            remark: '',
            venue_type: mapCategoryToVenueType(categoryName), // 根据分类自动设置场地类型
            venue_count: 0,
            is_configured: false
        }
    })
    
    // 初始化场地分配
    eventItems.value.forEach(item => {
        if (!itemVenueAssignments.value[item.id]) {
            itemVenueAssignments.value[item.id] = []
        }
    })
    
    // 确保场地数据已加载
    if (venues.value.length === 0) {
        loadVenues()
    }
    
    console.log('初始化的赛事项目:', eventItems.value)
}

// 获取项目分类名称
const getItemCategoryName = (itemId: number) => {
    const findItemInCategory = (category: any): string | null => {
        // 检查当前分类的基础项目
        if (category.base_items) {
            const item = category.base_items.find((i: any) => i.id === itemId)
            if (item) return category.name
        }
        
        // 递归检查子分类
        if (category.children) {
            for (const child of category.children) {
                const result = findItemInCategory(child)
                if (result) return result
            }
        }
        
        return null
    }
    
    for (const cat of categories.value) {
        const result = findItemInCategory(cat)
        if (result) return result
    }
    return '其他'
}

// 场馆管理相关函数
const getVenueTypeIndex = (venueType: string) => {
    return venueTypeOptions.value.findIndex(option => option.value === venueType)
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

const getVenueTypeLabel = (venueType: string) => {
    const option = venueTypeOptions.value.find(option => option.value === venueType)
    return option ? option.label : ''
}

const closeVenueDialog = () => {
    showVenueDialog.value = false
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
}

const onNewVenueTypeChange = (e: any) => {
    const index = e.detail.value
    const selectedType = venueTypeOptions.value[index]
    if (selectedType) {
        newVenue.value.venue_type = selectedType.value
        // 自动生成场地编码前缀
        newVenue.value.venue_code = generateVenueCodePrefix(selectedType.value)
    }
}

const generateVenueCodePrefix = (venueType: string) => {
    const codeMap: Record<string, string> = {
        'pingpong_table': 'PP',
        'badminton_court': 'BD',
        'basketball_court': 'BK',
        'football_field': 'FB',
        'tennis_court': 'TN',
        'volleyball_court': 'VB',
        'track': 'TR',
        'swimming_pool': 'SW',
        'other': 'OT'
    }
    return codeMap[venueType] || 'OT'
}

const addNewVenue = async () => {
    if (!newVenue.value.venue_type) {
        uni.showToast({
            title: '请选择场地类型',
            icon: 'none'
        })
        return
    }
    
    if (!newVenue.value.name && !batchMode.value) {
        uni.showToast({
            title: '请输入场地名称',
            icon: 'none'
        })
        return
    }
    
    if (batchMode.value && !batchVenue.value.namePrefix) {
        uni.showToast({
            title: '请输入名称前缀',
            icon: 'none'
        })
        return
    }
    
    try {
        if (batchMode.value) {
            // 批量添加模式
            if (!batchVenue.value.namePrefix) {
                uni.showToast({
                    title: '请输入名称前缀',
                    icon: 'none'
                })
                return
            }
            
            const startNum = parseInt(batchVenue.value.startNumber) || 1
            const endNum = parseInt(batchVenue.value.endNumber) || 10
            
            if (startNum > endNum) {
                uni.showToast({
                    title: '起始编号不能大于结束编号',
                    icon: 'none'
                })
                return
            }
            
            const count = endNum - startNum + 1
            if (count <= 0 || count > 50) {
                uni.showToast({
                    title: '批量添加数量应在1-50之间',
                    icon: 'none'
                })
                return
            }
            
            // 生成不冲突的编码前缀
            const basePrefix = generateVenueCodePrefix(newVenue.value.venue_type)
            const existingCodes = (venues.value || []).map((v: any) => v.venue_code)
            let codePrefix = basePrefix
            let suffix = 1
            
            // 查找可用的编码前缀
            while (existingCodes.some(code => code.startsWith(codePrefix))) {
                codePrefix = `${basePrefix}_${suffix}`
                suffix += 1
            }
            
            const data = {
                venue_type: newVenue.value.venue_type,
                venue_category: getVenueTypeLabel(newVenue.value.venue_type),
                count: count,
                name_prefix: batchVenue.value.namePrefix,
                code_prefix: codePrefix,
                location: newVenue.value.location,
                capacity: 0
            }
            
            // 调用批量添加API
            await apiBatchAddVenues(eventId.value, data)
            
            uni.showToast({
                title: `成功添加${count}个场地`,
                icon: 'success'
            })
        } else {
            // 单个添加模式
            if (!newVenue.value.name) {
                uni.showToast({
                    title: '请输入场地名称',
                    icon: 'none'
                })
                return
            }
            
            // 自动生成场地编码（如果用户没有填写）
            if (!newVenue.value.venue_code) {
                const prefix = generateVenueCodePrefix(newVenue.value.venue_type)
                let suffix = 1
                const existingCodes = (venues.value || []).map((v: any) => v.venue_code)
                let candidate = `${prefix}_${suffix}`
                
                // 查找可用的编号
                while (existingCodes.includes(candidate)) {
                    suffix += 1
                    candidate = `${prefix}_${suffix}`
                }
                
                // 如果编号超过100，使用时间戳避免冲突
                if (suffix > 100) {
                    candidate = `${prefix}_${Date.now()}`
                }
                
                newVenue.value.venue_code = candidate
                console.log('自动生成的场地编码:', candidate)
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
            
            // 调用添加API
            await addEventVenue(eventId.value, data)
            
            uni.showToast({
                title: '场地添加成功',
                icon: 'success'
            })
        }
        
        // 重新加载场地列表
        await loadVenues()
        
        // 不自动关闭弹窗，支持连续添加
        // closeVenueDialog()
        
        // 重置表单，准备下一次添加
        newVenue.value = {
            venue_type: newVenue.value.venue_type, // 保持当前选择的类型
            name: '',
            venue_code: '',
            location: ''
        }
        
        // 重置批量添加表单
        batchVenue.value = {
            namePrefix: batchVenue.value.namePrefix, // 保持当前名称前缀
            startNumber: 1,
            endNumber: 10
        }
        
    } catch (error) {
        console.error('添加场地失败:', error)
        
        // 处理具体的错误信息
        let errorMessage = '添加失败'
        if (error && error.msg) {
            errorMessage = error.msg
        } else if (error && error.message) {
            errorMessage = error.message
        }
        
        uni.showToast({
            title: errorMessage,
            icon: 'none',
            duration: 3000
        })
    }
}

const editVenue = (venue: any) => {
    // 编辑场地功能
    newVenue.value = { ...venue }
    // 这里可以添加编辑逻辑
    uni.showToast({
        title: '编辑功能开发中',
        icon: 'none'
    })
}

const deleteVenue = async (venueId: number | string) => {
    uni.showModal({
        title: '确认删除',
        content: '确定要删除这个场地吗？',
        success: async (res) => {
            if (res.confirm) {
                try {
                    // 这里应该调用删除API
                    // await deleteVenue(venueId)
                    
                    // 从本地数据中移除
                    const index = venues.value.findIndex(v => v.id === venueId)
                    if (index > -1) {
                        venues.value.splice(index, 1)
                    }
                    
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

</script>

<style lang="scss" scoped>
.flex-between { display: flex; align-items: center; justify-content: space-between; }
.selected-count { color:#667eea; font-size:24rpx; }
.required-tip { color:#ff4757; font-size:22rpx; font-weight:bold; }
.required-tip::before { content:'* '; }

.signup-chip-grid {
    display: flex;
    flex-wrap: wrap;
    gap: 16rpx;
    padding: 8rpx 0;
}
.signup-chip {
    padding: 12rpx 20rpx;
    border: 2rpx solid #e6e8f0;
    border-radius: 24rpx;
    color: #666;
    background-color: #f6f8ff;
}
.signup-chip.active {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: #fff;
    border-color: transparent;
}
.chip-label { font-size: 26rpx; }
.chip-delete {
    margin-left: 8rpx;
    font-size: 24rpx;
    color: rgba(255, 255, 255, 0.8);
    cursor: pointer;
}

.signup-selected-list { display: flex; flex-direction: column; gap: 12rpx; }
.signup-selected-item { display:flex; align-items:center; justify-content: space-between; padding: 16rpx 20rpx; background:#f8f9fb; border-radius:12rpx; }
.field-name { color:#333; font-size: 26rpx; }
.required-toggle { display:flex; align-items:center; gap: 12rpx; }
.toggle-text { color:#666; font-size:24rpx; }

.signup-groups { display:flex; flex-direction: column; gap: 16rpx; margin-top: 8rpx; }
.signup-group { background:#fff; border-radius:12rpx; }
.signup-group-title { font-size: 26rpx; color:#666; padding: 8rpx 0; }

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
            
            .step-title-container {
                text-align: center;
                transition: all 0.3s ease;
                margin-top: 8rpx;
                
                .step-title-line1 {
                    display: block;
                    font-size: 22rpx;
                    color: #999;
                    line-height: 1.2;
                    margin-bottom: 2rpx;
                }
                
                .step-title-line2 {
                    display: block;
                    font-size: 22rpx;
                    color: #999;
                    line-height: 1.2;
                }
            }
            
            &.active .step-title-container {
                .step-title-line1,
                .step-title-line2 {
                    color: #667eea;
                    font-weight: bold;
                }
            }
            
            &.completed .step-title-container {
                .step-title-line1,
                .step-title-line2 {
                    color: #4CAF50;
                }
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
    /* 预留底部固定按钮高度，避免内容被遮挡 */
    padding-bottom: 220rpx;
    padding-bottom: calc(220rpx + constant(safe-area-inset-bottom));
    padding-bottom: calc(220rpx + env(safe-area-inset-bottom));
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
            display: flex;
            align-items: center;
            justify-content: space-between;
            
            .title-text {
                font-size: 32rpx;
                font-weight: bold;
                color: #333;
            }
            
            .save-settings-btn {
                height: 56rpx;
                padding: 0 24rpx;
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
                
                &:active {
                    transform: scale(0.95);
                    box-shadow: 0 1rpx 4rpx rgba(0, 122, 255, 0.5);
                }
                
                .btn-text {
                    font-size: 24rpx;
                    font-weight: bold;
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
    height: 400rpx;
    
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
            display: flex;
            flex-wrap: wrap;
            padding: 32rpx;
            gap: 16rpx;
            
            .base-item {
                flex: 0 0 calc(50% - 8rpx);
                background-color: #f8f9fa;
                border-radius: 12rpx;
                padding: 24rpx;
                transition: all 0.3s ease;
                
                &.selected {
                    background-color: #e3f2fd;
                    border: 2rpx solid #2196f3;
                }
                
                .item-content {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    
                    .item-name {
                        font-size: 28rpx;
                        color: #333;
                        flex: 1;
                    }
                    
                    .selected-icon {
                        margin-left: 16rpx;
                        
                        .icon-check {
                            font-size: 24rpx;
                            color: #2196f3;
                        }
                    }
                }
            }
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
    position: relative;
    z-index: 1;
    
    .time-picker-item {
        flex: 1;
        position: relative;
        display: flex;
        align-items: center;
        z-index: 1;
        
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

// 确保picker组件的z-index不会过高
picker {
    z-index: 10 !important;
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
    background-color: white;
    margin: 20rpx 32rpx 8rpx;
    border-radius: 16rpx;
    padding: 24rpx 32rpx 8rpx;
    
    .preview-items {
        display: flex;
        flex-wrap: wrap;
        gap: 12rpx 16rpx;
        
        .preview-item {
            background-color: #e6f2ff;
            color: #1677ff;
            padding: 10rpx 14rpx;
            border-radius: 18rpx;
            font-size: 22rpx;
            line-height: 1.2;
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
    padding-bottom: calc(32rpx + constant(safe-area-inset-bottom));
    padding-bottom: calc(32rpx + env(safe-area-inset-bottom));
    border-top: 1px solid #f0f0f0;
    display: flex;
    gap: 24rpx;
    z-index: 1000;
    
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

.category-tabs {
    display: flex;
    justify-content: space-between;
    margin-bottom: 20rpx;
}

.tabs-scroll {
    flex: 1;
    overflow-x: auto;
    white-space: nowrap;
}

.tabs-content {
    display: inline-block;
}

.tab-item {
    display: inline-block;
    padding: 12rpx 24rpx;
    margin-right: 16rpx;
    border: 2rpx solid #e0e0e0;
    border-radius: 12rpx;
    cursor: pointer;
    
    &.active {
        border-color: #007aff;
        background-color: #007aff;
        color: white;
    }
}

.category-section {
    margin-bottom: 20rpx;
}

.category-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 16rpx 24rpx;
    border: 2rpx solid #e0e0e0;
    border-radius: 12rpx;
    cursor: pointer;
    
    &.expanded {
        border-color: #007aff;
    }
}

.category-info {
    display: flex;
    align-items: center;
}

.category-name {
    font-size: 28rpx;
    color: #333;
    margin-right: 16rpx;
}

.category-count {
    font-size: 24rpx;
    color: #999;
}

.selected-badge {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-width: 32rpx;
    height: 32rpx;
    padding: 0 8rpx;
    background-color: #007aff;
    border-radius: 16rpx;
    margin-left: 12rpx;
    
    &.sub-badge {
        background-color: #ff6b35;
    }
    
    &.third-badge {
        background-color: #4caf50;
    }
}

.badge-text {
    font-size: 20rpx;
    color: white;
    font-weight: 500;
}

.category-arrow {
    font-size: 24rpx;
    color: #999;
    
    &.expanded {
        transform: rotate(90deg);
    }
}

.base-items-grid {
    display: flex;
    flex-wrap: wrap;
    gap: 16rpx;
    padding: 16rpx 24rpx;
}

.base-item {
    display: flex;
    align-items: center;
    padding: 12rpx 24rpx;
    border: 2rpx solid #e0e0e0;
    border-radius: 12rpx;
    cursor: pointer;
    
    &.selected {
        border-color: #007aff;
        background-color: #e3f2fd;
    }
}

.item-content {
    display: flex;
    align-items: center;
}

.item-name {
    font-size: 28rpx;
    color: #333;
    margin-right: 16rpx;
}

.selected-icon {
    font-size: 24rpx;
    color: #007aff;
}

.selected-info {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 20rpx;
}

.selected-text {
    font-size: 28rpx;
    color: #333;
}

.items-actions {
    position: static;
    background: #fff;
    padding: 16rpx 32rpx;
    border-top: 1px solid #f0f0f0;
    margin-top: 12rpx;
}

.action-buttons {
    display: flex;
    gap: 16rpx;
}

.btn-secondary {
    padding: 12rpx 24rpx;
    border: 2rpx solid #e0e0e0;
    border-radius: 12rpx;
    font-size: 28rpx;
    color: #333;
    background-color: #f8f8f8;
    cursor: pointer;
}

.sub-categories {
    .sub-category-section {
        margin-left: 32rpx;
        border-left: 2rpx solid #e0e0e0;
        
        .sub-category-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 24rpx 32rpx;
            background-color: #f8f9fa;
            
            .sub-category-info {
                display: flex;
                align-items: center;
                
                .sub-category-name {
                    font-size: 28rpx;
                    font-weight: 500;
                    color: #555;
                    margin-right: 16rpx;
                }
                
                .sub-category-count {
                    font-size: 22rpx;
                    color: #999;
                }
            }
            
            .sub-category-arrow {
                transition: transform 0.3s ease;
                
                &.expanded {
                    transform: rotate(90deg);
                }
                
                .arrow-icon {
                    font-size: 28rpx;
                    color: #999;
                }
            }
        }
        
        .sub-category-content {
            background-color: #fafafa;
        }
    }
}

.third-categories {
    .third-category-section {
        margin-left: 32rpx;
        border-left: 2rpx solid #e0e0e0;
        
        .third-category-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 20rpx 32rpx;
            background-color: #f0f0f0;
            
            .third-category-info {
                display: flex;
                align-items: center;
                
                .third-category-name {
                    font-size: 26rpx;
                    color: #666;
                    margin-right: 16rpx;
                }
                
                .third-category-count {
                    font-size: 20rpx;
                    color: #999;
                }
            }
            
            .third-category-arrow {
                transition: transform 0.3s ease;
                
                &.expanded {
                    transform: rotate(90deg);
                }
                
                .arrow-icon {
                    font-size: 24rpx;
                    color: #999;
                }
            }
        }
    }
}

.custom-field-row {
    display: flex;
    align-items: center;
    gap: 16rpx;
    margin-top: 16rpx;
}

.custom-field-row .form-input {
    flex: 1;
    background-color: #f8f9fa;
    border: 1px solid #e9ecef;
    border-radius: 8rpx;
    padding: 16rpx 20rpx;
    height: 88rpx;
    box-sizing: border-box;
}

.custom-field-row .btn-secondary {
    flex-shrink: 0;
    padding: 16rpx 24rpx;
    background-color: #667eea;
    color: white;
    border: none;
    border-radius: 8rpx;
    font-size: 26rpx;
    white-space: nowrap;
    height: 88rpx;
    line-height: 56rpx;
    box-sizing: border-box;
}

// 项目设置样式
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
        
        .section-subtitle {
            font-size: 26rpx;
            color: #666;
            margin-bottom: 24rpx;
            line-height: 1.4;
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
                            
                            .item-id-info {
                                font-size: 20rpx;
                                color: #999;
                                margin-top: 4rpx;
                                font-family: monospace;
                                background-color: #f5f5f5;
                                padding: 2rpx 8rpx;
                                border-radius: 8rpx;
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
            
            .venue-selection {
                margin-bottom: 20rpx;

                .selection-header {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    margin-bottom: 16rpx;
                }

                .selection-label {
                    font-size: 26rpx;
                    color: #333;
                }
                
                .venue-type-tip {
                    font-size: 22rpx;
                    color: #007aff;
                    background: rgba(0, 122, 255, 0.1);
                    padding: 6rpx 12rpx;
                    border-radius: 16rpx;
                    border: 1rpx solid rgba(0, 122, 255, 0.2);
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
        }
    }
}

/* 场馆管理弹窗样式 */
.venue-dialog-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    z-index: 1000;
    display: flex;
    align-items: flex-end;
}

.venue-dialog.bottom-full {
    width: 100%;
    background: #fff;
    border-radius: 24rpx 24rpx 0 0;
    max-height: 80vh;
    overflow-y: auto;
}

.dialog-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 32rpx;
    border-bottom: 1rpx solid #eee;
}

.dialog-title {
    font-size: 36rpx;
    font-weight: 600;
    color: #333;
}

.close-btn {
    width: 60rpx;
    height: 60rpx;
    border-radius: 50%;
    background: #f5f5f5;
    display: flex;
    align-items: center;
    justify-content: center;
    border: none;
}

.close-text {
    font-size: 32rpx;
    color: #666;
}

.dialog-content {
    padding: 32rpx;
}

.add-venue-section {
    margin-bottom: 40rpx;
}

.section-title {
    font-size: 32rpx;
    font-weight: 600;
    color: #333;
    margin-bottom: 24rpx;
}

.form-item {
    margin-bottom: 24rpx;
}

.form-label {
    display: block;
    font-size: 28rpx;
    color: #333;
    margin-bottom: 12rpx;
}

.form-input {
    width: 100%;
    height: 80rpx;
    border: 1rpx solid #ddd;
    border-radius: 8rpx;
    padding: 0 20rpx;
    font-size: 28rpx;
    background: #fff;
}

.picker-value {
    width: 100%;
    height: 80rpx;
    border: 1rpx solid #ddd;
    border-radius: 8rpx;
    padding: 0 20rpx;
    font-size: 28rpx;
    background: #fff;
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.picker-arrow {
    color: #999;
    font-size: 24rpx;
}

.mode-switch {
    display: flex;
    border: 1rpx solid #ddd;
    border-radius: 8rpx;
    overflow: hidden;
}

.mode-btn {
    flex: 1;
    height: 80rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 28rpx;
    background: #f5f5f5;
    color: #666;
    border: none;
}

.mode-btn.active {
    background: #007aff;
    color: #fff;
}

.add-btn {
    width: 100%;
    height: 80rpx;
    background: #007aff;
    color: #fff;
    border: none;
    border-radius: 8rpx;
    font-size: 28rpx;
    margin-top: 20rpx;
}

.add-text {
    color: #fff;
}

.existing-venues-section {
    margin-top: 40rpx;
}

.venue-list {
    margin-top: 20rpx;
}

.venue-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 24rpx;
    border: 1rpx solid #eee;
    border-radius: 8rpx;
    margin-bottom: 16rpx;
}

.venue-info {
    flex: 1;
}

.venue-name {
    display: block;
    font-size: 28rpx;
    font-weight: 600;
    color: #333;
    margin-bottom: 8rpx;
}

.venue-code {
    display: block;
    font-size: 24rpx;
    color: #666;
    margin-bottom: 4rpx;
}

.venue-location {
    display: block;
    font-size: 24rpx;
    color: #999;
}

.venue-actions {
    display: flex;
    gap: 16rpx;
}

.action-btn {
    padding: 12rpx 24rpx;
    border-radius: 6rpx;
    font-size: 24rpx;
    border: none;
}

.edit-btn {
    background: #f0f0f0;
    color: #333;
}

.delete-btn {
    background: #ff4757;
    color: #fff;
}

.action-text {
    color: inherit;
}

.empty-venues {
    text-align: center;
    padding: 60rpx 0;
}

.empty-text {
    font-size: 28rpx;
    color: #999;
}
</style> 
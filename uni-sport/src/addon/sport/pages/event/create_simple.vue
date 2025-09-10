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
                            class="form-input basic-input" 
                            v-model="formData.name" 
                            placeholder="请输入比赛名称"
                            maxlength="100"
                        />
                    </view>
                    
                    <!-- 主办方 -->
                    <view class="form-item">
                        <view class="form-label required">主办方</view>
                        <input 
                            class="form-input basic-input readonly" 
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
                            <view class="location-display" @tap="chooseLocation">
                                <text class="location-text-display" v-if="formData.location">{{ formData.location }}</text>
                                <text class="location-placeholder" v-else>点击地图选择地点</text>
                            </view>
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
                            class="form-input basic-input" 
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
                            class="form-item group-form-item"
                        >
                            <view class="group-item">
                                <input 
                                    class="form-input group-input modal-input" 
                                    v-model="group.group_name" 
                                    :placeholder="`分组${index + 1}名称`"
                                    maxlength="50"
                                />
                                <view class="group-actions">
                                    <text class="action-btn delete" @tap="removeGroup(index)">删除</text>
                                </view>
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
                        <view class="title-left">
                        <text class="title-text">项目设置</text>
                            <text class="title-count">({{ groupedEventItems?.length || 0 }}大类 {{ eventItems?.length || 0 }}项)</text>
                        </view>
        </view>
                    
                    <!-- 项目列表设置 -->
                    <view class="items-settings">
                        
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
                                            </view>
                                            <view class="item-status" :class="'status-' + (item?.is_configured ? 'configured' : 'pending')">
                                                {{ item?.is_configured ? '已配置' : '待配置' }}
                                            </view>
                                        </view>
                                        
                                        <view class="item-settings">
                                            <!-- 第一组：基础设置 -->
                                            <view class="settings-group">
                                                <view class="group-content">
                                            <!-- 报名费设置 -->
                                            <view class="setting-item">
                                                        <view class="setting-header">
                                                            <text class="setting-label">报名费：</text>
                                                            <switch 
                                                                :checked="item?.registration_fee_enabled" 
                                                                :data-id="item?.id"
                                                                data-field="registration_fee_enabled"
                                                                @change="onItemSwitchChangeEvt"
                                                            />
                                                        </view>
                                                        <text v-if="!item?.registration_fee_enabled" class="setting-tip">默认免费</text>
                                                        <view v-if="item?.registration_fee_enabled" class="setting-input-container">
                                                <input 
                                                    class="setting-input" 
                                                    type="digit" 
                                                    :value="getRegistrationFeeDisplayValue(item?.registration_fee)"
                                                                placeholder="请输入报名费"
                                                    :data-index="getItemGlobalIndex(groupIndex, index)"
                                                    @input="onRegistrationFeeInput"
                                                    @focus="onRegistrationFeeFocusEvt"
                                                    @blur="onRegistrationFeeBlurEvt"
                                                />
                                                            <text class="input-unit">元</text>
                                                        </view>
                                            </view>
                                            
                                            <!-- 人数限制设置 -->
                                            <view class="setting-item">
                                                        <view class="setting-header">
                                                <text class="setting-label">人数限制：</text>
                                                            <switch 
                                                                :checked="item?.max_participants_enabled" 
                                                                :data-id="item?.id"
                                                                data-field="max_participants_enabled"
                                                                @change="onItemSwitchChangeEvt"
                                                            />
                                                        </view>
                                                        <text v-if="!item?.max_participants_enabled" class="setting-tip">默认不限制</text>
                                                        <view v-if="item?.max_participants_enabled" class="setting-input-container">
                                                <input 
                                                    class="setting-input" 
                                                    type="number" 
                                                    :value="getMaxParticipantsDisplayValue(item?.max_participants)"
                                                                placeholder="请输入人数限制"
                                                    :data-index="getItemGlobalIndex(groupIndex, index)"
                                                    @input="onMaxParticipantsInput"
                                                    @blur="onMaxParticipantsBlurEvt"
                                                />
                                                            <text class="input-unit">人</text>
                                                        </view>
                                            </view>
                                            
                                                    <!-- 每组人数设置 -->
                                                    <view class="setting-item">
                                                        <view class="setting-header">
                                                            <text class="setting-label">每组人数：</text>
                                                            <switch 
                                                                :checked="item?.group_size_enabled" 
                                                                :data-id="item?.id"
                                                                data-field="group_size_enabled"
                                                                @change="onItemSwitchChangeEvt"
                                                            />
                                                        </view>
                                                        <text v-if="!item?.group_size_enabled" class="setting-tip">默认不分组</text>
                                                        <view v-if="item?.group_size_enabled" class="setting-input-container">
                                                            <input 
                                                                class="setting-input" 
                                                                type="number" 
                                                                v-model.number="item.group_size"
                                                                placeholder="请输入每组人数"
                                                                @blur="item.group_size = Math.max(0, parseInt(item.group_size || 0) || 0)"
                                                            />
                                                            <text class="input-unit">人</text>
                                                        </view>
                                                    </view>
                                                </view>
                                            </view>
                                            
                                            <!-- 第二组：比赛设置 -->
                                            <view class="settings-group">
                                                <view class="group-content">
                                            <!-- 是否允许重复报名 -->
                                            <view class="setting-item">
                                                        <view class="setting-header">
                                                            <text class="setting-label">允许重复报名：</text>
                                                <switch 
                                                    :checked="item?.allow_duplicate_registration" 
                                                    :data-id="item?.id"
                                                    data-field="allow_duplicate_registration"
                                                    @change="onItemSwitchChangeEvt"
                                                />
                                                        </view>
                                                        <text class="setting-tip">一人可报名多次</text>
                                            </view>

                                            <!-- 是否循环赛（小组） -->
                                            <view class="setting-item">
                                                        <view class="setting-header">
                                                            <text class="setting-label">循环赛（小组）：</text>
                                                <switch
                                                    :checked="item?.is_round_robin"
                                                    :data-id="item?.id"
                                                    data-field="is_round_robin"
                                                    @change="onItemSwitchChangeEvt"
                                                />
                                                        </view>
                                                        <text class="setting-tip">小组循环赛</text>
                                            </view>

                                                    <!-- 比赛说明 -->
                                            <view class="setting-item remark-setting">
                                                        <view class="remark-header">
                                                            <text class="setting-label">比赛说明：</text>
                                                            <switch 
                                                                :checked="item?.remark_enabled" 
                                                                :data-id="item?.id"
                                                                data-field="remark_enabled"
                                                                @change="onItemSwitchChangeEvt"
                                                            />
                                                        </view>
                                                        <view v-if="item?.remark_enabled" class="remark-textarea-container">
                                                    <textarea 
                                                        class="setting-textarea" 
                                                        v-model="item.remark"
                                                                placeholder="请输入比赛说明..."
                                                        maxlength="200"
                                                    ></textarea>
                                                    <text class="textarea-count">{{ (item?.remark || '').length }}/200</text>
                                                        </view>
                                                    </view>
                                                </view>
                                            </view>
                                            
                                            <!-- 场地设备管理 -->
                                            <view class="venue-management">
                                                <view class="venue-header">
                                                    <text class="venue-title">场地设备管理</text>
                                                    <view class="venue-actions">
                                                        <button class="add-venue-btn" @tap="showVenueModal(item?.id, group?.categoryName)">
                                                            <text class="btn-text">{{ hasVenues ? '管理场地' : '添加场地' }}</text>
                                                        </button>
                                                    </view>
                                                </view>
                                                
                                                <!-- 场地选择（直接展示可用场地，支持多选与全选） -->
                                                <view class="venue-selection">
                                                    <view class="selection-header">
                                                        <text class="selection-label">选择场地：</text>
                                                        <view class="header-right">
                                                            <text class="venue-type-tip">{{ getVenueTypeLabel(getItemVenueType(item)) }}类型</text>
                                                            <!-- 全选功能移到右边，添加复选框 -->
                                                            <view class="select-all-right" v-if="getAvailableVenuesForItem(item?.id)?.length > 0" @tap.stop="toggleSelectAllVenues(item?.id)">
                                                                <text class="select-text">{{ isAllVenuesSelected(item?.id) ? '取消全选' : '全选' }}</text>
                                                                <view class="checkbox" :class="{ checked: isAllVenuesSelected(item?.id) }">
                                                                    <text v-if="isAllVenuesSelected(item?.id)" class="checkmark">✓</text>
                                                                </view>
                                                            </view>
                                                        </view>
                                                    </view>
                                                    <view class="venue-selector-list">
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
                </view>
            </view>


        <!-- 第7步：更多设置 -->
        <view v-if="currentStep === 7" class="form-wrapper">
            <!-- 显示设置 -->
            <view class="settings-card">
                <view class="card-header">
                    <view class="card-title">显示设置</view>
                </view>
                <view class="card-content">
                    <!-- 显示年龄组 -->
                    <!-- <view class="setting-item">
                        <view class="setting-info">
                            <text class="setting-label">显示年龄组</text>
                            <text class="setting-desc">在赛事页面显示参赛者的年龄组信息</text>
                        </view>
                        <switch 
                            :checked="eventSettings.age_group_display" 
                            @change="onAgeGroupDisplayChange"
                            class="setting-switch"
                        />
                    </view> -->
                    
                    <!-- 显示报名人数 -->
                    <view class="setting-item">
                        <view class="setting-info">
                            <text class="setting-label">显示报名人数</text>
                            <text class="setting-desc">实时显示各项目的报名人数统计</text>
                        </view>
                        <switch 
                            :checked="eventSettings.show_participant_count" 
                            @change="onShowParticipantCountChange"
                            class="setting-switch"
                        />
                    </view>
                    
                    <!-- 显示比赛进度 -->
                    <view class="setting-item">
                        <view class="setting-info">
                            <text class="setting-label">显示比赛进度</text>
                            <text class="setting-desc">显示比赛进行状态和完成进度</text>
                        </view>
                        <switch 
                            :checked="eventSettings.show_progress" 
                            @change="onShowProgressChange"
                            class="setting-switch"
                        />
                    </view>
                </view>
            </view>
            
            <!-- 协办单位管理 -->
            <view class="settings-card">
                <view class="card-header">
                    <view class="card-title">协办单位管理</view>
                </view>
                <view class="card-content">
                    <view class="co-organizer-section">
                        <!-- 协办单位列表 -->
                        <view v-if="coOrganizerList.length > 0" class="co-organizer-list">
                            <view 
                                v-for="(item, index) in coOrganizerList" 
                                :key="item.id || index"
                                class="co-organizer-item"
                            >
                                <view class="item-content">
                                    <view class="item-header">
                                        <view class="item-name">{{ item.organizer_name }}</view>
                                        <view class="item-type">{{ item.organizer_type_text || getCoOrganizerTypeText(item.organizer_type) }}</view>
                                    </view>
                                </view>
                            </view>
                        </view>
                        
                        <!-- 空状态 -->
                        <view v-else class="empty-state">
                            <text class="empty-text">暂无协办单位</text>
                        </view>
                        
                        <button class="manage-btn" @tap="handleShowCoOrganizerManager">
                            
                            <text class="manage-text">管理协办单位</text>
                        </button>
                    </view>
                </view>
            </view>
            
            <!-- 号码牌设置 -->
            <view class="settings-card">
                <view class="card-header">
                    <view class="card-title">号码牌设置</view>
                    <view class="card-subtitle">配置参赛号码分配规则</view>
                </view>
                <view class="card-content">
                    <!-- 编号模式选择 -->
                    <view class="setting-item">
                        <view class="setting-info">
                            <text class="setting-label">编号模式</text>
                    </view>
                        <radio-group @change="onNumberingModeChange" class="radio-group">
                            <label class="radio-item">
                                <radio value="1" :checked="numberPlateSettings.numbering_mode === 1" />
                                <text class="radio-text">系统分配</text>
                            </label>
                            <label class="radio-item">
                                <radio value="2" :checked="numberPlateSettings.numbering_mode === 2" />
                                <text class="radio-text">用户自选</text>
                            </label>
                        </radio-group>
                </view>

                    <!-- 号码格式设置 -->
                    <view class="setting-section">
                        <view class="section-title">号码格式</view>
                        
                        <!-- 前缀设置 -->
                        <view class="form-item">
                            <view class="form-label">号码前缀</view>
                            <input 
                                v-model="numberPlateSettings.prefix"
                                placeholder="如：A、B（可为空）"
                                class="form-input with-bg"
                                maxlength="10"
                                @input="onPrefixChange"
                            />
            </view>
            
                        <!-- 数字位数 -->
                        <view class="form-item">
                            <view class="form-label">数字位数</view>
                            <picker 
                                :value="numberLengthIndex" 
                                :range="numberLengthOptions"
                                @change="onNumberLengthChange"
                                class="form-picker with-bg"
                            >
                                <view class="picker-display">
                                    {{ numberLengthOptions[numberLengthIndex] }}
                </view>
                            </picker>
                    </view>

                        <!-- 号码范围和步长 -->
                        <view class="form-row three-columns">
                            <view class="form-item third">
                                <view class="form-label">起始号码</view>
                                <input 
                                    v-model.number="numberPlateSettings.start_number"
                                    type="number"
                                    placeholder="1"
                                    class="form-input with-bg"
                                    @input="onNumberRangeChange"
                                />
                </view>
                            <view class="form-item third">
                                <view class="form-label">结束号码</view>
                                <input 
                                    v-model.number="numberPlateSettings.end_number"
                                    type="number"
                                    placeholder="999"
                                    class="form-input with-bg"
                                    @input="onNumberRangeChange"
                                />
                            </view>
                            <view class="form-item third">
                                <view class="form-label">编号步长</view>
                                <input 
                                    v-model.number="numberPlateSettings.step"
                                    type="number"
                                    placeholder="1"
                                    class="form-input with-bg"
                                    @input="onStepChange"
                                />
                            </view>
                        </view>

                        <!-- 禁用4设置 -->
                        <view class="form-item">
                            <view class="form-label">是否禁用4</view>
                            <view class="switch-container">
                                <switch 
                                    :checked="numberPlateSettings.disable_number_4"
                                    @change="onDisableNumber4Change"
                                    color="#007AFF"
                                />
                                <text class="switch-text">禁用包含数字4的号码</text>
                            </view>
                            <text class="form-hint">开启后，所有生成的号码都不会包含数字4</text>
                        </view>

                        <!-- 号码预览 -->
                        <view class="form-item">
                            <view class="form-label">号码预览</view>
                            <view class="number-preview">
                                <text class="preview-label">示例：</text>
                                <text class="preview-number">{{ numberPreview }}</text>
                            </view>
                        </view>
                    </view>

                    <!-- 特殊号码设置 -->
                    <view class="setting-section">
                        <view class="section-title">特殊号码</view>
                        
                        <!-- 保留号码 -->
                        <view class="form-item">
                            <view class="number-tags">
                                <view 
                                    v-for="(number, index) in reservedNumbers" 
                                    :key="index"
                                    class="number-tag"
                                >
                                    <text class="tag-text">{{ number }}</text>
                                    <text class="tag-remove" @tap="removeReservedNumber(index)">×</text>
                                </view>
                            </view>
                            <view class="number-input-section">
                                <input 
                                    v-model="tempReservedNumber"
                                    placeholder="请输入保留号码，如：666、888"
                                    class="form-input full-width"
                                    @confirm="addReservedNumber"
                                />
                                <button class="add-btn full-width" @tap="addReservedNumber">添加保留号码</button>
                            </view>
        </view>
        
                        <!-- 禁用号码 -->
                        <view class="form-item">
                            <view class="number-tags">
                                <view 
                                    v-for="(number, index) in disabledNumbers" 
                                    :key="index"
                                    class="number-tag disabled"
                                >
                                    <text class="tag-text">{{ number }}</text>
                                    <text class="tag-remove" @tap="removeDisabledNumber(index)">×</text>
                                </view>
                            </view>
                            <view class="number-input-section">
                                <input 
                                    v-model="tempDisabledNumber"
                                    placeholder="请输入禁用号码，如：4、44、444"
                                    class="form-input full-width"
                                    @confirm="addDisabledNumber"
                                />
                                <button class="add-btn full-width" @tap="addDisabledNumber">添加禁用号码</button>
                            </view>
                        </view>
                    </view>

                    <!-- 用户自选设置 -->
                    <view v-if="numberPlateSettings.numbering_mode === 2" class="setting-section">
                        <view class="section-title">自选设置</view>
                        
                        <!-- 自选时间窗口 -->
                        <view class="form-item">
                            <view class="form-label">自选时间窗口</view>
                            <view class="time-window-row">
                                <input 
                                    v-model.number="numberPlateSettings.choice_time_window"
                                    type="number"
                                    placeholder="7"
                                    class="form-input"
                                />
                                <text class="time-unit">天</text>
                            </view>
                            <text class="form-desc">报名后允许用户自选号码的天数</text>
                        </view>

                        <!-- 自选规则 -->
                        <view class="form-item">
                            <view class="form-label">自选规则</view>
                            <picker 
                                :value="choiceRuleIndex" 
                                :range="choiceRuleOptions"
                                @change="onChoiceRuleChange"
                                class="form-picker"
                            >
                                <view class="picker-display">
                                    {{ choiceRuleOptions[choiceRuleIndex] }}
                                </view>
                            </picker>
                        </view>
                    </view>

                    <!-- 自动分配设置 -->
                    <view v-if="numberPlateSettings.numbering_mode === 1" class="setting-section">
                        <view class="section-title">自动分配</view>
                        
                        <view class="setting-item">
                            <view class="setting-info">
                                <text class="setting-label">报名后自动分配</text>
                                <text class="setting-desc">用户报名成功后自动分配号码</text>
                            </view>
                            <switch 
                                :checked="numberPlateSettings.auto_assign_after_registration" 
                                @change="onAutoAssignChange"
                                class="setting-switch"
                            />
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
                v-if="currentStep < 7" 
                class="action-btn next-btn" 
                :class="{ 'disabled': !canProceedToNext }"
                :disabled="!canProceedToNext"
                @tap="nextStep"
            >
                下一步（保存）
            </button>
            <button 
                v-if="currentStep === 7" 
                class="action-btn submit-btn" 
                :class="{ 'loading': submitLoading }"
                :disabled="submitLoading || !canProceedToNext"
                @tap="handleSubmit"
            >
                {{ submitLoading ? (isEditMode ? '保存中...' : '创建比赛') : (isEditMode ? '保存赛事' : '创建比赛') }}
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
                            class="form-input modal-input" 
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
                            class="form-input modal-input" 
                            v-model="organizerForm.contact_name" 
                            placeholder="请输入联系人"
                            maxlength="50"
                        />
                    </view>
                    <view class="form-item">
                        <view class="form-label">联系电话</view>
                        <input 
                            class="form-input modal-input" 
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
                                <view class="picker-value venue-picker">
                                    <text>{{ getVenueTypeLabel(newVenue.venue_type) || '请选择场地类型' }}</text>
                                    <text class="picker-arrow">></text>
                                </view>
                            </picker>
                        </view>
                        
                        <!-- 添加模式切换 -->
                        <view class="form-item">
                            <text class="form-label">添加模式：</text>
                            <radio-group @change="onModeChange" class="mode-radio-group">
                                <label class="mode-radio-item">
                                    <radio value="single" :checked="!batchMode" color="#ff6b35" />
                                    <text class="radio-text">单个添加</text>
                                </label>
                                <label class="mode-radio-item">
                                    <radio value="batch" :checked="batchMode" color="#ff6b35" />
                                    <text class="radio-text">批量添加</text>
                                </label>
                            </radio-group>
                        </view>
                        
                        <!-- 单个添加模式 -->
                        <view v-if="!batchMode">
                            <view class="form-item">
                                <text class="form-label">场地名称：</text>
                                <input 
                                    class="form-input venue-input" 
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
                                    class="form-input venue-input" 
                                    v-model="batchVenue.namePrefix"
                                    placeholder="如：乒乓球台"
                                />
                            </view>
                            
                            <view class="form-item">
                                <text class="form-label">起始编号：</text>
                                <input 
                                    class="form-input venue-input" 
                                    type="number" 
                                    v-model="batchVenue.startNumber"
                                    placeholder="1"
                                />
                            </view>
                            
                            <view class="form-item">
                                <text class="form-label">结束编号：</text>
                                <input 
                                    class="form-input venue-input" 
                                    type="number" 
                                    v-model="batchVenue.endNumber"
                                    placeholder="10"
                                />
                            </view>
                        </view>
                        
                        <view class="form-item">
                            <text class="form-label">场地位置：</text>
                            <input 
                                class="form-input venue-input" 
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
                    <button class="close-bottom-btn" @tap="closeVenueDialog"><text class="close-bottom-text">关闭</text></button>
                </view>
            </view>
        </view>
    </view>
    
    <!-- 协办单位管理弹窗 -->
    <CoOrganizerManager 
        :visible="showCoOrganizerManager"
        :event-id="eventId"
        @close="onCoOrganizerManagerClose"
        @refresh="onCoOrganizerManagerRefresh"
    />
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
    getEventDetailInfo,
    getEventItems,
    getOrganizerList, 
    addOrganizer, 
    getEventSeriesList, 
    addEventSeries,
    getEventCategories,
    saveEventItems,
    updateItemSettings
} from '@/addon/sport/api/event'
import { getCoOrganizerList, CO_ORGANIZER_TYPE_TEXTS } from '@/addon/sport/api/co_organizer'
import CoOrganizerManager from '@/addon/sport/components/CoOrganizerManager.vue'

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

// 号码牌设置
const numberPlateSettings = ref({
    numbering_mode: 1, // 1=系统分配 2=用户自选
    prefix: '', // 号码前缀
    number_length: 3, // 数字位数
    start_number: 1, // 起始号码
    end_number: 999, // 结束号码
    step: 1, // 编号步长
    reserved_numbers: [] as string[], // 保留号码列表
    disabled_numbers: [] as string[], // 禁用号码列表
    allow_athlete_choice: false, // 是否允许运动员自选
    choice_time_window: 7, // 自选时间窗口（天）
    choice_rules: 'first_come_first_served', // 自选规则
    auto_assign_after_registration: true, // 报名后是否自动分配
    disable_number_4: false // 是否禁用包含4的号码
})

// 号码牌设置相关数据
const numberLengthOptions = ['1位', '2位', '3位', '4位', '5位', '6位']
const numberLengthIndex = ref(2) // 默认3位

const choiceRuleOptions = ['先到先得', '随机分配', '按报名顺序']
const choiceRuleIndex = ref(0) // 默认先到先得

// 临时输入数据
const tempReservedNumber = ref('')
const tempDisabledNumber = ref('')

// 计算属性
const reservedNumbers = computed(() => numberPlateSettings.value.reserved_numbers)
const disabledNumbers = computed(() => numberPlateSettings.value.disabled_numbers)

// 号码预览
const numberPreview = computed(() => {
    const prefix = numberPlateSettings.value.prefix || ''
    const length = numberPlateSettings.value.number_length
    const start = numberPlateSettings.value.start_number
    const step = numberPlateSettings.value.step
    
    // 生成示例号码
    const exampleNumber = start + step
    const paddedNumber = exampleNumber.toString().padStart(length, '0')
    
    return prefix + paddedNumber
})

// 协办单位管理
const showCoOrganizerManager = ref(false)
const coOrganizerList = ref<any[]>([])

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
            // 解析缓存数据失败
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
        // 保存表单数据到缓存失败
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
        
        // 如果是第7步，添加显示设置和号码牌设置
        if (currentStep.value === 7) {
            // 从选中的主办方获取organizer_type
            const selectedOrganizer = organizerList.value.find((item: any) => item.id === formData.value.organizer_id)
            submitData.organizer_type = selectedOrganizer?.organizer_type || 1
            
            // 显示设置
            submitData.age_group_display = eventSettings.value.age_group_display ? 1 : 0
            submitData.show_participant_count = eventSettings.value.show_participant_count ? 1 : 0
            submitData.show_progress = eventSettings.value.show_progress ? 1 : 0
            
            // 号码牌设置
            submitData.number_plate_settings = {
                numbering_mode: numberPlateSettings.value.numbering_mode,
                prefix: numberPlateSettings.value.prefix,
                number_length: numberPlateSettings.value.number_length,
                start_number: numberPlateSettings.value.start_number,
                end_number: numberPlateSettings.value.end_number,
                step: numberPlateSettings.value.step,
                reserved_numbers: JSON.stringify(numberPlateSettings.value.reserved_numbers),
                disabled_numbers: JSON.stringify(numberPlateSettings.value.disabled_numbers),
                allow_athlete_choice: numberPlateSettings.value.allow_athlete_choice ? 1 : 0,
                choice_time_window: numberPlateSettings.value.choice_time_window,
                choice_rules: numberPlateSettings.value.choice_rules,
                auto_assign_after_registration: numberPlateSettings.value.auto_assign_after_registration ? 1 : 0
            }
        }
        
        let result: any
        
        if (isEditMode.value) {
            // 编辑模式：第7步只保存最终设置
            if (currentStep.value === 7) {
                // 第7步：保存赛事最终设置（显示设置和号码牌设置）
                // 从选中的主办方获取organizer_type
                const selectedOrganizer = organizerList.value.find((item: any) => item.id === formData.value.organizer_id)
                const finalSettingsData = {
                    step: 7, // 第7步：最终设置
                    // 主办方类型
                    organizer_type: selectedOrganizer?.organizer_type || 1,
                    // 显示设置
                    age_group_display: eventSettings.value.age_group_display ? 1 : 0,
                    show_participant_count: eventSettings.value.show_participant_count ? 1 : 0,
                    show_progress: eventSettings.value.show_progress ? 1 : 0,
                    // 号码牌设置
                    number_plate_settings: {
                        numbering_mode: numberPlateSettings.value.numbering_mode,
                        prefix: numberPlateSettings.value.prefix,
                        number_length: numberPlateSettings.value.number_length,
                        start_number: numberPlateSettings.value.start_number,
                        end_number: numberPlateSettings.value.end_number,
                        step: numberPlateSettings.value.step,
                        reserved_numbers: JSON.stringify(numberPlateSettings.value.reserved_numbers),
                        disabled_numbers: JSON.stringify(numberPlateSettings.value.disabled_numbers),
                        allow_athlete_choice: numberPlateSettings.value.allow_athlete_choice ? 1 : 0,
                        choice_time_window: numberPlateSettings.value.choice_time_window,
                        choice_rules: numberPlateSettings.value.choice_rules,
                        auto_assign_after_registration: numberPlateSettings.value.auto_assign_after_registration ? 1 : 0
                    },
                    update_time: Date.now() / 1000 // 添加更新时间
                }
                
                // 第7步：保存最终设置
                result = await editEvent(eventId.value, finalSettingsData)
            } else {
                // 其他步骤：保存完整数据（创建模式或编辑模式的其他步骤）
            result = await editEvent(eventId.value, submitData)
            
            // 更新比赛项目
            if (selectedItems.value.length > 0) {
                try {
                    await saveEventItems({
                        event_id: eventId.value,
                        base_item_ids: selectedItems.value
                    })
                    // 比赛项目更新成功
                } catch (error) {
                    // 更新比赛项目失败
                    uni.showToast({
                        title: '赛事更新成功，但项目更新失败',
                        icon: 'none'
                    })
                    }
                }
                
                // 第6步时，保存项目设置
                if (currentStep.value === 6 && eventItems.value && eventItems.value.length > 0) {
                    try {
                        // 第6步：开始保存项目设置
                        const settingsResult = await saveItemSettings()
                        if (settingsResult) {
                            // 项目设置保存成功
                        } else {
                            // 项目设置保存失败
                            uni.showToast({
                                title: '赛事更新成功，但项目设置保存失败',
                                icon: 'none'
                            })
                        }
                    } catch (error) {
                        // 保存项目设置时出错
                        uni.showToast({
                            title: '赛事更新成功，但项目设置保存失败',
                            icon: 'none'
                        })
                    }
                }
            }
            
            // 保存修改成功，无需提示
            
            // 延迟跳转到赛事详情页面
            setTimeout(() => {
                uni.redirectTo({
                    url: `/addon/sport/pages/event/detail?id=${eventId.value}`
                })
            }, 1500)
            
        } else {
            // 这种情况不应该发生，因为第1步已经创建了赛事并切换到编辑模式
            // 如果还是创建模式，说明第1步创建失败，需要重新创建
            console.warn('第7步仍为创建模式，重新创建赛事')
            result = await addEvent(submitData)
            
            if (result && result.data && result.data.id) {
                // 保存赛事ID，切换到编辑模式
                eventId.value = result.data.id
                isEditMode.value = true
            
            // 保存选择的比赛项目
            if (selectedItems.value.length > 0) {
                try {
                    await saveEventItems({
                        event_id: result.data.id,
                        base_item_ids: selectedItems.value
                    })
                    // 比赛项目保存成功
                } catch (error) {
                    // 保存比赛项目失败
                    uni.showToast({
                        title: '比赛创建成功，但项目保存失败',
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
            } else {
                uni.showToast({
                    title: '赛事创建失败，请重试',
                    icon: 'none'
                })
                return
            }
        }
        
    } catch (error) {
        // 保存修改失败或创建比赛失败
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
    // 第1步需要验证，因为这是基础信息
    if (currentStep.value === 1) {
            return formData.value.name.trim() !== '' && formData.value.organizer_id > 0
    }
    
    // 其他步骤在进入页面时不验证，只在点击下一步时验证
    // 这样用户刚进入页面时按钮是可用的，不会因为数据为空而禁用
            return true
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
    // 简单逻辑：每次点击下一步只跳转一步
    console.log('=== nextStep 函数开始执行 ===')
    console.log('点击下一步，当前步骤:', currentStep.value)
    console.log('canProceedToNext.value:', canProceedToNext.value)
    console.log('eventItems.value:', eventItems.value)
    console.log('eventItems数量:', eventItems.value?.length || 0)
    
    // 验证当前步骤数据
    if (!canProceedToNext.value) {
        console.log('当前步骤数据不完整，不能跳转')
        return
    }
    
    // 保存当前步骤数据（如果需要）
    if (currentStep.value === 1) {
        // 第1步：验证并保存基础信息
        if (!formData.value.name.trim()) {
            uni.showToast({ title: '请输入赛事名称', icon: 'none' })
            return
        }
        if (!formData.value.organizer_id) {
            uni.showToast({ title: '请选择主办方', icon: 'none' })
            return
        }
        
        try {
            const basicEventData: any = {
                step: 1,
                name: formData.value.name.trim(),
                organizer_id: formData.value.organizer_id
            }
            
            if (formData.value.event_type === 2 && formData.value.series_id && formData.value.series_id > 0) {
                basicEventData.event_type = formData.value.event_type
                basicEventData.series_id = formData.value.series_id
            } else if (formData.value.event_type === 1) {
                basicEventData.event_type = formData.value.event_type
            }
            
            console.log('第1步保存数据:', basicEventData)
            
            if (isEditMode.value) {
                const result: any = await editEvent(eventId.value, basicEventData)
                if (result) {
                    // 基础信息已保存，无需提示
                }
            } else {
                const result: any = await addEvent(basicEventData)
                if (result && result.data && result.data.id) {
                    eventId.value = result.data.id
                    isEditMode.value = true
                    // 赛事已创建，无需提示
                }
            }
        } catch (error) {
            console.error('第1步保存失败:', error)
            uni.showToast({ title: '保存失败，请重试', icon: 'none' })
            return
        }
    } else if (currentStep.value === 2) {
        // 第2步：验证并保存地址信息
        if (!formData.value.location || !formData.value.address_detail) {
            uni.showToast({ title: '请完善地点信息', icon: 'none' })
            return
        }
        
        try {
            const locationData: any = {
                step: 2,
                location: formData.value.location,
                address_detail: formData.value.address_detail
            }
            
            if (formData.value.lat) locationData.latitude = parseFloat(formData.value.lat)
            if (formData.value.lng) locationData.longitude = parseFloat(formData.value.lng)
            
            console.log('第2步保存数据:', locationData)
            
            const result = await editEvent(eventId.value, locationData)
            if (result) {
                // 地点信息已保存，无需提示
            }
        } catch (error) {
            console.error('第2步保存失败:', error)
            uni.showToast({ title: '保存失败，请重试', icon: 'none' })
            return
        }
    } else if (currentStep.value === 3) {
        // 第3步：验证并保存时间信息
        if (!formData.value.start_time || !formData.value.end_time) {
            uni.showToast({ title: '请完善时间信息', icon: 'none' })
            return
        }
        if (formData.value.start_time >= formData.value.end_time) {
            uni.showToast({ title: '结束时间必须大于开始时间', icon: 'none' })
            return
        }
        
        // 验证分组信息
        if (formData.value.custom_groups.length > 0) {
            for (let i = 0; i < formData.value.custom_groups.length; i++) {
                const group = formData.value.custom_groups[i]
                if (!group.group_name || group.group_name.trim() === '') {
                    uni.showToast({ 
                        title: `请填写分组${i + 1}的名称或删除该分组`, 
                        icon: 'none' 
                    })
                    return
                }
            }
        }
        
        try {
            const timeData: any = {
                step: 3,
                start_time: formData.value.start_time,
                end_time: formData.value.end_time
            }
            
            if (formData.value.registration_start_time) {
                timeData.registration_start_time = formData.value.registration_start_time
            }
            if (formData.value.registration_end_time) {
                timeData.registration_end_time = formData.value.registration_end_time
            }
            
            console.log('第3步保存数据:', timeData)
            
            const result = await editEvent(eventId.value, timeData)
            if (result) {
                // 时间信息已保存，无需提示
            }
        } catch (error) {
            console.error('第3步保存失败:', error)
            uni.showToast({ title: '保存失败，请重试', icon: 'none' })
            return
        }
    } else if (currentStep.value === 4) {
        // 第4步：验证并保存报名设置
        if (formData.value.signup_fields.length === 0) {
            uni.showToast({ title: '请至少选择一个报名字段', icon: 'none' })
            return
        }
        
        const requiredFields = formData.value.signup_fields.filter(f => f.required)
        if (formData.value.signup_fields.length < 3 && requiredFields.length !== formData.value.signup_fields.length) {
            uni.showToast({ title: '请将所有选择的字段设为必填', icon: 'none' })
            return
        } else if (formData.value.signup_fields.length >= 3 && requiredFields.length === 0) {
            uni.showToast({ title: '请至少设置一个必填字段', icon: 'none' })
            return
        }
        
        try {
            const signupData: any = {
                step: 4,
                signup_fields: formData.value.signup_fields
            }
            
            console.log('第4步保存数据:', signupData)
            
            const result = await editEvent(eventId.value, signupData)
            if (result) {
                // 报名设置已保存，无需提示
            }
        } catch (error) {
            console.error('第4步保存失败:', error)
            uni.showToast({ title: '保存失败，请重试', icon: 'none' })
            return
        }
    } else if (currentStep.value === 6) {
        // 第6步特殊处理：保存项目设置并进入第7步
        console.log('=== 第6步：开始保存项目设置 ===')
        console.log('eventItems.value:', eventItems.value)
        console.log('eventItems数量:', eventItems.value?.length || 0)
        
        try {
            // 检查是否有项目设置需要保存
            if (eventItems.value && eventItems.value.length > 0) {
                console.log('开始调用saveItemSettings函数...')
                const settingsResult = await saveItemSettings()
                console.log('saveItemSettings返回结果:', settingsResult)
                
                if (settingsResult) {
                    console.log('项目设置保存成功，进入第7步')
                    // 项目设置保存成功，进入第7步
                    currentStep.value = 7
                    if (currentStep.value > maxReachedStep.value) {
                        maxReachedStep.value = currentStep.value
                    }
                    return
                } else {
                    console.error('项目设置保存失败')
                    // 项目设置保存失败
                    uni.showToast({
                        title: '项目设置保存失败，请重试',
                        icon: 'none',
                        duration: 3000
                    })
                    return
                }
            } else {
                console.log('没有项目设置需要保存，直接进入第7步')
                // 没有项目设置需要保存，直接进入第7步
                currentStep.value = 7
                if (currentStep.value > maxReachedStep.value) {
                    maxReachedStep.value = currentStep.value
                }
                return
            }
        } catch (error) {
            console.error('第6步保存项目设置时出错:', error)
            // 第6步保存项目设置时出错
            uni.showToast({
                title: '保存失败，请重试',
                icon: 'none',
                duration: 3000
            })
            return
        }
    }
    
    // 跳转到下一步
    currentStep.value++
    console.log('跳转到步骤:', currentStep.value)
    
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

const nextStepOld = async () => {
    if (currentStep.value === 1) {
        // 第1步特殊处理：创建或更新赛事基础信息
        try {
            // 验证第1步必填字段
            if (!formData.value.name.trim()) {
                uni.showToast({
                    title: '请输入赛事名称',
                    icon: 'none'
                })
                return
            }
            if (!formData.value.organizer_id) {
                uni.showToast({
                    title: '请选择主办方',
                    icon: 'none'
                })
                return
            }
            
            // 第1步：只提交基础信息相关字段
            const basicEventData: any = {
                step: 1, // 第1步标识
                name: formData.value.name.trim(),
                organizer_id: formData.value.organizer_id
            }
            
            // 只在是系列赛且有选择系列赛时才添加相关字段
            if (formData.value.event_type === 2 && formData.value.series_id && formData.value.series_id > 0) {
                basicEventData.event_type = formData.value.event_type
                basicEventData.series_id = formData.value.series_id
            } else if (formData.value.event_type === 1) {
                // 独立赛事
                basicEventData.event_type = formData.value.event_type
            }
            
            // 详细调试信息
            console.log('=== 第1步跳转到第2步 ===')
            console.log('第1步提交的数据:', basicEventData)
            console.log('比赛名称:', formData.value.name)
            console.log('主办方ID:', formData.value.organizer_id)
            console.log('赛事类型:', formData.value.event_type)
            console.log('系列赛ID:', formData.value.series_id)
            console.log('==================')
            
            if (isEditMode.value) {
                // 编辑模式：更新现有赛事的基础信息
                // 注意：编辑模式下只更新传入的字段，不覆盖其他字段
                try {
                    const result: any = await editEvent(eventId.value, basicEventData)
                    console.log('第1步保存结果:', result)
                    if (result && result.debug) {
                        console.log('后端调试信息:', result.debug)
                    }
                    if (result) {
                        // 基础信息已保存，无需提示
                    }
                } catch (error) {
                    console.error('第1步保存失败:', error)
                    uni.showToast({
                        title: '保存失败，请重试',
                        icon: 'none'
                    })
                    return
                }
            } else {
                // 新建模式：创建新赛事
                const result: any = await addEvent(basicEventData)
                if (result && result.data && result.data.id) {
                    // 保存赛事ID，切换到编辑模式
                    eventId.value = result.data.id
                    isEditMode.value = true
                    
                    // 赛事已创建，无需提示
                } else {
                    uni.showToast({
                        title: '创建赛事失败，请重试',
                        icon: 'none'
                    })
                    return
                }
            }
            
            // 进入第2步
            currentStep.value = 2
            if (currentStep.value > maxReachedStep.value) {
                maxReachedStep.value = currentStep.value
            }
            
        } catch (error) {
            console.error('第1步保存失败:', error)
            uni.showToast({
                title: '保存失败，请重试',
                icon: 'none'
            })
            return
        }
    } else if (currentStep.value === 3) {
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
        
        // 验证分组信息
        if (formData.value.custom_groups.length > 0) {
            for (let i = 0; i < formData.value.custom_groups.length; i++) {
                const group = formData.value.custom_groups[i]
                if (!group.group_name || group.group_name.trim() === '') {
                    uni.showToast({
                        title: `请填写分组${i + 1}的名称或删除该分组`,
                        icon: 'none'
                    })
                    return
                }
            }
        }
    }
    
    if (currentStep.value === 6) {
        // 第6步特殊处理：保存项目设置并进入第7步
        try {
            console.log('=== 第6步：开始保存项目设置 ===')
            console.log('eventItems.value:', eventItems.value)
            console.log('eventItems数量:', eventItems.value?.length || 0)
            
            // 检查是否有项目设置需要保存
            if (eventItems.value && eventItems.value.length > 0) {
                console.log('开始调用saveItemSettings函数...')
                const settingsResult = await saveItemSettings()
                console.log('saveItemSettings返回结果:', settingsResult)
                
                if (settingsResult) {
                    console.log('项目设置保存成功，进入第7步')
                    // 项目设置保存成功，进入第7步
                    
                    // 保存成功后进入第7步
                    currentStep.value = 7
                    if (currentStep.value > maxReachedStep.value) {
                        maxReachedStep.value = currentStep.value
                    }
                    
                    // 项目设置已保存，无需提示
                } else {
                    console.error('项目设置保存失败')
                    // 项目设置保存失败
                    uni.showToast({
                        title: '项目设置保存失败，请重试',
                        icon: 'none',
                        duration: 3000
                    })
                    return
                }
            } else {
                console.log('没有项目设置需要保存，直接进入第7步')
                // 没有项目设置需要保存，直接进入第7步
                currentStep.value = 7
                if (currentStep.value > maxReachedStep.value) {
                    maxReachedStep.value = currentStep.value
                }
            }
        } catch (error) {
            console.error('第6步保存项目设置时出错:', error)
            // 第6步保存项目设置时出错
            uni.showToast({
                title: '保存失败，请重试',
                icon: 'none',
                duration: 3000
            })
            return
        }
    } else if (canProceedToNext.value && currentStep.value < 6) {
        // 其他步骤的正常处理
        // 第2步特殊处理：保存地点信息
        if (currentStep.value === 2) {
            try {
                // 验证地点信息
                if (!formData.value.location || !formData.value.address_detail) {
                    uni.showToast({
                        title: '请完善地点信息',
                        icon: 'none'
                    })
                    return
                }
                
                // 组合完整地址信息
                let finalLocationDetail = formData.value.location
                if (formData.value.address_detail) {
                    finalLocationDetail += (finalLocationDetail ? ' ' : '') + formData.value.address_detail
                }
                
                // 第2步：只提交地址相关字段
                const locationData: any = {
                    step: 2, // 第2步标识
                    location: formData.value.location,
                    address_detail: formData.value.address_detail
                }
                
                // 只在有值时添加完整地址和经纬度
                if (finalLocationDetail) {
                    locationData.location_detail = finalLocationDetail
                }
                if (formData.value.lat) {
                    locationData.latitude = parseFloat(formData.value.lat)
                }
                if (formData.value.lng) {
                    locationData.longitude = parseFloat(formData.value.lng)
                }
                
                // 详细调试信息
                console.log('=== 第2步跳转到第3步 ===')
                console.log('第2步提交的数据:', locationData)
                console.log('地点:', formData.value.location)
                console.log('详细地址:', formData.value.address_detail)
                console.log('经纬度:', formData.value.lat, formData.value.lng)
                console.log('==================')
                const result = await editEvent(eventId.value, locationData)
                console.log('第2步保存结果:', result)
                if (result) {
                    // 地点信息已保存，无需提示
                }
            } catch (error) {
                console.error('第2步保存失败:', error)
                uni.showToast({
                    title: '保存失败，请重试',
                    icon: 'none'
                })
                return
            }
        }
        
        // 第3步特殊处理：保存时间信息
        if (currentStep.value === 3) {
            try {
                // 验证时间信息
                if (!formData.value.start_time || !formData.value.end_time) {
                    uni.showToast({
                        title: '请完善时间信息',
                        icon: 'none'
                    })
                    return
                }
                
                // 验证分组信息
                if (formData.value.custom_groups.length > 0) {
                    for (let i = 0; i < formData.value.custom_groups.length; i++) {
                        const group = formData.value.custom_groups[i]
                        if (!group.group_name || group.group_name.trim() === '') {
                            uni.showToast({
                                title: `请填写分组${i + 1}的名称或删除该分组`,
                                icon: 'none'
                            })
                            return
                        }
                    }
                }
                
                // 第3步：只提交时间相关字段
                const timeData: any = {
                    step: 3, // 第3步标识
                    start_time: formData.value.start_time,
                    end_time: formData.value.end_time
                }
                
                // 只在有值时添加报名时间
                if (formData.value.registration_start_time) {
                    timeData.registration_start_time = formData.value.registration_start_time
                }
                if (formData.value.registration_end_time) {
                    timeData.registration_end_time = formData.value.registration_end_time
                }
                
                // 详细调试信息
                console.log('=== 第3步跳转到第4步 ===')
                console.log('第3步提交的数据:', timeData)
                console.log('开始时间:', formData.value.start_time)
                console.log('结束时间:', formData.value.end_time)
                console.log('报名开始时间:', formData.value.registration_start_time)
                console.log('报名结束时间:', formData.value.registration_end_time)
                console.log('==================')
                const result = await editEvent(eventId.value, timeData)
                console.log('第3步保存结果:', result)
                if (result) {
                    // 时间信息已保存，无需提示
                }
            } catch (error) {
                console.error('第3步保存失败:', error)
                uni.showToast({
                    title: '保存失败，请重试',
                    icon: 'none'
                })
                return
            }
        }
        
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
            
            try {
                // 第4步：只提交报名相关字段
                const signupData: any = {
                    step: 4, // 第4步标识
                    signup_fields: formData.value.signup_fields
                }
                
                // 详细调试信息
                console.log('=== 第4步跳转到第5步 ===')
                console.log('第4步提交的数据:', signupData)
                console.log('报名字段:', formData.value.signup_fields)
                console.log('==================')
                const result = await editEvent(eventId.value, signupData)
                console.log('第4步保存结果:', result)
                if (result) {
                    // 报名设置已保存，无需提示
                }
            } catch (error) {
                console.error('第4步保存失败:', error)
                uni.showToast({
                    title: '保存失败，请重试',
                    icon: 'none'
                })
                return
            }
        }
        
        // 保存成功后跳转到下一步
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
    // #ifdef MP-WEIXIN
    // 检查是否支持隐私协议API
    if (typeof (global as any).wx !== 'undefined' && (global as any).wx.requirePrivacyAuthorize) {
        (global as any).wx.requirePrivacyAuthorize({
            success: () => {
                performChooseLocation()
            },
            fail: () => {
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

/**
 * 执行地址选择
 */
const performChooseLocation = () => {
    uni.chooseLocation({
        success: (res) => {
            // 保存经纬度
            if (res.latitude && res.longitude) {
                formData.value.lat = res.latitude.toString()
                formData.value.lng = res.longitude.toString()
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
            
            // 地址选择成功，无需提示
        },
        fail: (res) => {
            if (res.errMsg && res.errMsg.includes('cancel')) {
                return
            }
            
            let message = '选择地址失败'
            if (res.errMsg) {
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
    // 如果选择系列赛事且还没有系列赛数据，加载系列赛列表
    if (value === 2) {
        if (!seriesList.value.length) {
            loadSeriesList()
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
        const response: any = await getOrganizerList()
        organizerList.value = response.data || []
    } catch (error) {
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
                performChooseImage()
            },
            fail: () => {
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
        // 上传成功，无需提示
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
        
        // 添加主办方成功，无需提示
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
        }
        
        // 关闭模态框并重置表单
        showSeriesModal.value = false
        seriesForm.value = {
            name: '',
            start_year: new Date().getFullYear(),
            description: ''
        }
        
        // 添加系列赛成功，无需提示
    } catch (error) {
        // 添加系列赛失败
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
        
        // 加载协办单位列表
        try {
            await loadCoOrganizerList()
        } catch (error) {
            console.error('加载协办单位列表失败:', error)
            // 协办单位加载失败不影响整体流程
        }
        
        // 加载显示设置
        if (eventData.age_group_display !== undefined) {
            eventSettings.value.age_group_display = eventData.age_group_display === 1
        }
        if (eventData.show_participant_count !== undefined) {
            eventSettings.value.show_participant_count = eventData.show_participant_count === 1
        }
        if (eventData.show_progress !== undefined) {
            eventSettings.value.show_progress = eventData.show_progress === 1
        }
        
        // 加载号码牌设置
        if (eventData.number_plate_settings) {
            const settings = eventData.number_plate_settings
            numberPlateSettings.value = {
                numbering_mode: settings.numbering_mode || 1,
                prefix: settings.prefix || '',
                number_length: settings.number_length || 3,
                start_number: settings.start_number || 1,
                end_number: settings.end_number || 999,
                step: settings.step || 1,
                reserved_numbers: Array.isArray(settings.reserved_numbers) ? settings.reserved_numbers : (settings.reserved_numbers ? JSON.parse(settings.reserved_numbers) : []),
                disabled_numbers: Array.isArray(settings.disabled_numbers) ? settings.disabled_numbers : (settings.disabled_numbers ? JSON.parse(settings.disabled_numbers) : []),
                allow_athlete_choice: settings.allow_athlete_choice === 1,
                choice_time_window: settings.choice_time_window || 7,
                choice_rules: settings.choice_rules || 'first_come_first_served',
                auto_assign_after_registration: settings.auto_assign_after_registration === 1,
                disable_number_4: settings.disable_number_4 === 1
            }
            
            // 设置数字位数选择器的索引
            numberLengthIndex.value = Math.max(0, (settings.number_length || 3) - 1)
            
            // 设置自选规则选择器的索引
            const rules = ['first_come_first_served', 'random', 'by_registration_order']
            const ruleIndex = rules.indexOf(settings.choice_rules || 'first_come_first_served')
            choiceRuleIndex.value = ruleIndex >= 0 ? ruleIndex : 0
        }
        
        // 更新步骤状态 - 编辑模式下允许访问所有步骤
        maxReachedStep.value = 7
        
    } catch (error) {
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
        
        // 检查是否为编辑模式
        if (options.id && options.mode === 'edit') {
            // 编辑模式：先加载基础数据，再加载赛事数据
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
            
            // 先加载基础数据，再加载赛事数据
            Promise.all([
                loadOrganizerList(),
                loadSeriesList()
            ]).then(() => {
                // 基础数据加载完成后，再加载赛事数据
                loadEventData()
            }).catch((error) => {
                console.error('加载基础数据失败:', error)
                // 即使基础数据加载失败，也尝试加载赛事数据
                loadEventData()
            })
            
        } else {
            // 创建模式：先清空数据，然后读取缓存（如果有）
            isEditMode.value = false
            eventId.value = 0
            
            // 加载基础数据
            loadOrganizerList()
            loadSeriesList()
            
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

    // 创建模式默认选择：姓名、手机、身份证号（三个必填）
    // 编辑模式保持原有设置，不设置默认值
    if (!isEditMode.value && (!formData.value.signup_fields || formData.value.signup_fields.length === 0)) {
        const defaults = ['name','mobile','id_card']
        formData.value.signup_fields = defaults.map(k => {
            const opt = allSignupFieldOptions.find(o => o.key === k)!
            return { key: k, label: opt.label, required: true }
        })
        console.log('创建模式设置默认报名字段:', formData.value.signup_fields)
    }

    // 注意：uni-app不支持直接操作DOM，文本对齐通过CSS处理
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
    
    // 验证分组信息
    if (formData.value.custom_groups.length > 0) {
        for (let i = 0; i < formData.value.custom_groups.length; i++) {
            const group = formData.value.custom_groups[i]
            if (!group.group_name || group.group_name.trim() === '') {
                uni.showToast({
                    title: `请填写分组${i + 1}的名称或删除该分组`,
                    icon: 'none'
                })
                return false
            }
        }
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
        'linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%)',
        'linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%)',
        'linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%)',
        'linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%)',
        'linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%)'
    ]
    const index = categoryName.charCodeAt(0) % colors.length
    return colors[index]
}

const getCategoryBorderColor = (categoryName: string) => {
    const colors = ['#dee2e6', '#dee2e6', '#dee2e6', '#dee2e6', '#dee2e6']
    const index = categoryName.charCodeAt(0) % colors.length
    return colors[index]
}

const onSyncSettings = async (categoryName: string) => {
    const group = groupedEventItems.value.find(g => g.categoryName === categoryName)
    if (!group || group.items.length <= 1) return
    
    const firstItem = group.items[0]
    const syncFields = ['registration_fee', 'max_participants', 'allow_duplicate_registration', 'is_round_robin', 'group_size', 'remark', 'registration_fee_enabled', 'max_participants_enabled', 'group_size_enabled', 'remark_enabled']
    
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
    
    console.log(`开关变更: itemId=${itemId}, field=${field}, value=${value}`)
    
    const item = eventItems.value.find(item => item.id === itemId)
    if (item) {
        console.log(`找到项目: ${item.name}, 更新前: ${item[field]}`)
        item[field] = value
        item.is_configured = true
        console.log(`更新后: ${item[field]}`)
    } else {
        console.error(`未找到项目: itemId=${itemId}`)
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
    console.log('=== saveItemSettings 函数开始执行 ===')
    console.log('eventId.value:', eventId.value)
    console.log('eventItems.value:', eventItems.value)
    console.log('eventItems数量:', eventItems.value?.length || 0)
    
    if (!eventId.value || !eventItems.value || eventItems.value.length === 0) {
        console.log('条件检查失败，返回false')
        return false
    }
    
    try {
        console.log(`开始保存 ${eventItems.value.length} 个项目的设置`)
        
        // 保存每个项目的设置
        for (let i = 0; i < eventItems.value.length; i++) {
            const item = eventItems.value[i]
            console.log(`\n--- 处理第 ${i + 1} 个项目: ${item.name} ---`)
            console.log('项目完整数据:', item)
            
            // 准备保存的数据 - 修复ID字段问题
            const itemId = item.id // 直接使用id字段，因为后端接口返回的id就是sport_item_id
            const saveData = {
                item_id: itemId,
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
            
            console.log(`准备保存项目: ${item.name} (ID: ${itemId})`)
            console.log('保存数据:', saveData)
            
            // 调用接口保存
            console.log('调用updateItemSettings API...')
            const response: any = await updateItemSettings(saveData)
            console.log('API响应:', response)
            
            // 检查响应状态
            if (response && (response.code === 200 || response.code === 1)) {
                console.log(`项目 ${item.name} 保存成功`)
                
                // 保存场地分配
                const selectedVenues = itemVenueAssignments.value[item.id] || []
                console.log(`项目 ${item.name} 的场地分配:`, selectedVenues)
                
                if (selectedVenues.length > 0) {
                    try {
                        const venueIds = selectedVenues.map(venue => venue.venue_id || venue.id)
                        console.log(`为项目 ${item.name} 分配场地:`, venueIds)
                        
                        await batchAssignVenuesToItem(itemId, {
                            venue_ids: venueIds,
                            assignment_type: 2 // 共享模式
                        })
                        console.log(`项目 ${item.name} 场地分配成功`)
                    } catch (error) {
                        console.error(`项目 ${item.name} 场地分配失败:`, error)
                        // 场地分配失败不影响整体保存
                    }
                } else {
                    console.log(`项目 ${item.name} 没有场地分配`)
                }
            } else {
                console.error(`项目 ${item.name} 保存失败:`, response)
                throw new Error(`项目 ${item.name} 保存失败: ${response?.msg || '未知错误'}`)
            }
        }
        
        console.log('=== 所有项目设置保存完成 ===')
        return true
    } catch (error: any) {
        console.error('=== saveItemSettings 执行失败 ===', error)
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
        return true
    })
}

const isVenueSelectedForItem = (itemId: number, venueId: number) => {
    const assignments = itemVenueAssignments.value[itemId] || []
    // 后端返回的数据结构中，场地ID是 venue_id 字段
    return assignments.some(assignment => assignment.venue_id === venueId)
}

const toggleVenueSelection = async (itemId: number, venueId: number) => {
    if (!itemVenueAssignments.value[itemId]) {
        itemVenueAssignments.value[itemId] = []
    }
    
    const assignments = itemVenueAssignments.value[itemId]
    // 修复：使用 venue_id 字段进行比较
    const existingIndex = assignments.findIndex(assignment => assignment.venue_id === venueId)
    
    if (existingIndex > -1) {
        // 取消选择：从已分配列表中移除，并调用后端API
        assignments.splice(existingIndex, 1)
        
        try {
            // 调用后端API取消场地分配
            await apiRemoveVenueFromItem(itemId, venueId)
        } catch (error) {
            console.error('取消场地分配失败:', error)
            // 如果API调用失败，恢复本地状态
            const venue = venues.value.find(v => v.id === venueId)
            if (venue) {
                const assignmentData = {
                    venue_id: venue.id,
                    name: venue.name,
                    venue_code: venue.venue_code,
                    venue_type: venue.venue_type,
                    assignment_type: 2 // 共享模式
                }
                assignments.push(assignmentData)
            }
        }
    } else {
        // 选择场地：添加到已分配列表
        const venue = venues.value.find(v => v.id === venueId)
        if (venue) {
            // 构造与后端返回格式一致的数据结构
            const assignmentData = {
                venue_id: venue.id,
                name: venue.name,
                venue_code: venue.venue_code,
                venue_type: venue.venue_type,
                assignment_type: 2 // 共享模式
            }
            assignments.push(assignmentData)
        }
    }
}

const isAllVenuesSelected = (itemId: number) => {
    const availableVenues = getAvailableVenuesForItem(itemId)
    const selectedVenues = itemVenueAssignments.value[itemId] || []
    
    if (availableVenues.length === 0) {
        return false
    }
    
    // 检查每个可用场地是否都被选中
    return availableVenues.every(venue => 
        selectedVenues.some(assignment => assignment.venue_id === venue.id)
    )
}

const toggleSelectAllVenues = (itemId: number) => {
    const availableVenues = getAvailableVenuesForItem(itemId)
    const selectedVenues = itemVenueAssignments.value[itemId] || []
    
    if (isAllVenuesSelected(itemId)) {
        // 取消全选
        itemVenueAssignments.value[itemId] = []
        console.log(`取消全选场地，项目 ${itemId}`)
    } else {
        // 全选：构造与后端返回格式一致的数据结构
        const allAssignments = availableVenues.map(venue => ({
            venue_id: venue.id,
            name: venue.name,
            venue_code: venue.venue_code,
            venue_type: venue.venue_type,
            assignment_type: 2 // 共享模式
        }))
        itemVenueAssignments.value[itemId] = allAssignments
        console.log(`全选场地，项目 ${itemId}:`, allAssignments)
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

// 号码牌设置相关函数
const onNumberingModeChange = (e: any) => {
    numberPlateSettings.value.numbering_mode = parseInt(e.detail.value)
}

const onPrefixChange = () => {
    // 前缀变化时触发预览更新
}

const onNumberLengthChange = (e: any) => {
    numberLengthIndex.value = e.detail.value
    numberPlateSettings.value.number_length = parseInt(e.detail.value) + 1
}

const onNumberRangeChange = () => {
    // 验证号码范围
    if (numberPlateSettings.value.start_number >= numberPlateSettings.value.end_number) {
        uni.showToast({
            title: '起始号码应小于结束号码',
            icon: 'none'
        })
    }
}

const onStepChange = () => {
    // 验证步长
    if (numberPlateSettings.value.step < 1) {
        numberPlateSettings.value.step = 1
    }
}

/**
 * 禁用4开关变化处理
 */
const onDisableNumber4Change = (e: any) => {
    numberPlateSettings.value.disable_number_4 = e.detail.value
    console.log('禁用4设置变更:', numberPlateSettings.value.disable_number_4)
}

const onChoiceRuleChange = (e: any) => {
    choiceRuleIndex.value = e.detail.value
    const rules = ['first_come_first_served', 'random', 'by_registration_order']
    numberPlateSettings.value.choice_rules = rules[e.detail.value]
}

const onAutoAssignChange = (e: any) => {
    numberPlateSettings.value.auto_assign_after_registration = e.detail.value
}

// 特殊号码管理函数
const addReservedNumber = () => {
    const number = tempReservedNumber.value.trim()
    if (!number) {
        uni.showToast({
            title: '请输入保留号码',
            icon: 'none'
        })
        return
    }
    
    if (numberPlateSettings.value.reserved_numbers.includes(number)) {
        uni.showToast({
            title: '该号码已存在',
            icon: 'none'
        })
        return
    }
    
    numberPlateSettings.value.reserved_numbers.push(number)
    tempReservedNumber.value = ''
}

const removeReservedNumber = (index: number) => {
    numberPlateSettings.value.reserved_numbers.splice(index, 1)
}

const addDisabledNumber = () => {
    const number = tempDisabledNumber.value.trim()
    if (!number) {
        uni.showToast({
            title: '请输入禁用号码',
            icon: 'none'
        })
        return
    }
    
    if (numberPlateSettings.value.disabled_numbers.includes(number)) {
        uni.showToast({
            title: '该号码已存在',
            icon: 'none'
        })
        return
    }
    
    numberPlateSettings.value.disabled_numbers.push(number)
    tempDisabledNumber.value = ''
}

const removeDisabledNumber = (index: number) => {
    numberPlateSettings.value.disabled_numbers.splice(index, 1)
}

// 协办单位管理相关方法
const handleShowCoOrganizerManager = () => {
    if (!eventId.value) {
        uni.showToast({
            title: '请先保存赛事基本信息',
            icon: 'none'
        })
        return
    }
    showCoOrganizerManager.value = true
}

const onCoOrganizerManagerClose = () => {
    showCoOrganizerManager.value = false
}

const onCoOrganizerManagerRefresh = () => {
    // 协办单位数据刷新后的回调
    loadCoOrganizerList()
}

// 获取协办单位类型文本
const getCoOrganizerTypeText = (type: number) => {
    return CO_ORGANIZER_TYPE_TEXTS[type as keyof typeof CO_ORGANIZER_TYPE_TEXTS] || '未知'
}

// 加载协办单位列表
const loadCoOrganizerList = async () => {
    if (!eventId.value) return
    
    try {
        const response: any = await getCoOrganizerList(eventId.value)
        coOrganizerList.value = response.data || []
        console.log('协办单位列表数据:', coOrganizerList.value)
        console.log('CO_ORGANIZER_TYPE_TEXTS:', CO_ORGANIZER_TYPE_TEXTS)
        if (coOrganizerList.value.length > 0) {
            console.log('第一个协办单位的类型:', coOrganizerList.value[0].organizer_type, typeof coOrganizerList.value[0].organizer_type)
        }
    } catch (error) {
        console.error('加载协办单位列表失败:', error)
        coOrganizerList.value = []
    }
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
const initEventItems = async () => {
    if (selectedItems.value.length === 0) {
        eventItems.value = []
        return
    }
    
    // 如果是编辑模式，从getEventItems接口获取真实的项目数据
    if (isEditMode.value && eventId.value) {
        try {
            console.log('=== 编辑模式：从getEventItems接口获取项目数据 ===')
            const response: any = await getEventItems(eventId.value)
            console.log('getEventItems接口返回:', response)
            
            if (response && response.data && Array.isArray(response.data)) {
                // 使用接口返回的真实数据
                eventItems.value = response.data.map((item: any) => {
                    const processedItem = {
                        ...item,
                        is_configured: true // 编辑模式下默认为已配置
                    }
                    
                    // 如果比赛说明不为空，自动开启比赛说明开关
                    if (item.remark && item.remark.trim() !== '') {
                        processedItem.remark_enabled = true
                    }
                    
                    // 如果报名费不为0，自动开启报名费开关
                    if (item.registration_fee && parseFloat(item.registration_fee) > 0) {
                        processedItem.registration_fee_enabled = true
                    }
                    
                    // 如果人数限制不为0，自动开启人数限制开关
                    if (item.max_participants && parseInt(item.max_participants) > 0) {
                        processedItem.max_participants_enabled = true
                    }
                    
                    // 如果每组人数不为0，自动开启每组人数开关
                    if (item.group_size && parseInt(item.group_size) > 0) {
                        processedItem.group_size_enabled = true
                    }
                    
                    return processedItem
                })
                
                console.log('从接口获取的eventItems:', eventItems.value)
                
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
                
                // 加载每个项目的已分配场地
                await loadItemVenueAssignments()
                
                return
            }
        } catch (error) {
            console.error('获取项目数据失败:', error)
        }
    }
    
    // 创建模式或接口失败时的兜底逻辑
    console.log('=== 使用兜底逻辑创建eventItems ===')
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
            is_configured: false,
            // 新增的开关字段，默认都是关闭状态
            registration_fee_enabled: false,
            max_participants_enabled: false,
            group_size_enabled: false,
            remark_enabled: false
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
    
    console.log('兜底逻辑创建的赛事项目:', eventItems.value)
}

/**
 * 加载每个项目的已分配场地
 */
const loadItemVenueAssignments = async () => {
    if (!eventItems.value || eventItems.value.length === 0) {
        return
    }
    
    for (const item of eventItems.value) {
        const itemId = item.sport_item_id || item.id
        
        try {
            const response: any = await apiGetItemVenues(itemId)
            
            if (response && response.data && Array.isArray(response.data)) {
                // 将已分配的场地存储到 itemVenueAssignments 中
                itemVenueAssignments.value[item.id] = response.data
            } else {
                itemVenueAssignments.value[item.id] = []
            }
        } catch (error) {
            itemVenueAssignments.value[item.id] = []
        }
    }
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

// 处理添加模式切换
const onModeChange = (e: any) => {
    const value = e.detail.value
    batchMode.value = value === 'batch'
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
            
            const startNum = parseInt(String(batchVenue.value.startNumber)) || 1
            const endNum = parseInt(String(batchVenue.value.endNumber)) || 10
            
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
            const basePrefix = generateVenueCodePrefix(String(newVenue.value.venue_type))
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
            
            // 成功添加场地，无需提示
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
                const prefix = generateVenueCodePrefix(String(newVenue.value.venue_type))
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
            
            // 场地添加成功，无需提示
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
        
    } catch (error: any) {
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
                    // 调用删除API
                    if (eventId.value) {
                        await deleteEventVenue(eventId.value, Number(venueId))
                    } else {
                        throw new Error('赛事ID不存在')
                    }
                    
                    // 从本地数据中移除
                    const index = venues.value.findIndex(v => v.id === venueId)
                    if (index > -1) {
                        venues.value.splice(index, 1)
                    }
                    
                    // 删除成功，无需提示
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
.selected-count { color:#4caf50; font-size:24rpx; }
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
    background: linear-gradient(135deg, #ff6b35 0%, #f7931e 100%);
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
                background: linear-gradient(135deg, #ff6b35 0%, #f7931e 100%);
                color: white;
                box-shadow: 0 4rpx 12rpx rgba(255, 107, 53, 0.3);
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
                color: #ff6b35;
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
        background: linear-gradient(135deg, #ff6b35, #f7931e);
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
                    background: linear-gradient(135deg, #ff6b35, #f7931e);
                    
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
                    background-color: #f1f8e9;
                    border: 2rpx solid #4caf50;
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
                            color: #4caf50;
                        }
                    }
                }
            }
        }
    }
}



.form-item {
    padding: 20rpx 0;
    border-bottom: 1px solid #f8f8f8;
    
    &:last-child {
        border-bottom: none;
    }
    
    .form-label {
        font-size: 28rpx;
        color: #333;
        margin-bottom: 12rpx;
        
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
    flex-direction: column;
    gap: 16rpx;
    
    .location-display {
        width: 100%;
        min-height: 88rpx;
        padding: 20rpx;
        background-color: #f8f9fa;
        border: 1px solid #e9ecef;
        border-radius: 8rpx;
        box-sizing: border-box;
        display: flex;
        align-items: flex-start;
        justify-content: flex-start;
        
        .location-text-display {
            font-size: 28rpx;
            color: #333;
            line-height: 1.4;
            word-wrap: break-word;
            word-break: break-all;
        }
        
        .location-placeholder {
            font-size: 28rpx;
            color: #999;
            line-height: 1.4;
        }
    }
    
    .location-action {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8rpx;
        padding: 16rpx 24rpx;
        background: linear-gradient(135deg, #ff6b35 0%, #f7931e 100%);
        border-radius: 12rpx;
        width: 100%;
        box-sizing: border-box;
        
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
            background-color: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8rpx;
            padding: 0 20rpx;
            height: 80rpx;
            line-height: 80rpx;
            box-sizing: border-box;
            text-align: left;
            
            &::placeholder {
                color: #999;
                text-align: left;
                position: static;
                transform: none;
                opacity: 1;
            }
        }
        
        .picker-arrow {
            position: absolute;
            right: 20rpx;
            font-size: 24rpx;
            color: #999;
            top: 50%;
            transform: translateY(-50%);
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
        color: #ff6b35;
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
                border-color: #ff6b35;
            }
            
            .radio-dot {
                width: 16rpx;
                height: 16rpx;
                background: linear-gradient(135deg, #ff6b35, #f7931e);
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
        border: 2rpx dashed #ff6b35;
        border-radius: 12rpx;
        color: #ff6b35;
        background-color: #fff5f0;
        
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
                color: #ff6b35;
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
        border-radius: 12rpx;
        font-size: 32rpx;
        font-weight: bold;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.3s ease;
        box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.15);
        
        &.prev-btn {
            background: linear-gradient(135deg, #f5f5f5 0%, #e0e0e0 100%);
            color: #666;
            border: 2rpx solid #d0d0d0;
            
            &:active {
                transform: translateY(2rpx);
                box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.1);
            }
        }
        
        &.next-btn {
            background: linear-gradient(135deg, #ff6b35 0%, #f7931e 100%);
            color: white;
            border: 2rpx solid #e55a2b;
            
            &:active {
                transform: translateY(2rpx);
                box-shadow: 0 2rpx 8rpx rgba(255, 107, 53, 0.3);
            }
            
            &.disabled {
                background: linear-gradient(135deg, #ccc 0%, #aaa 100%);
                color: #999;
                border: 2rpx solid #bbb;
                box-shadow: none;
                
                &:active {
                    transform: none;
                }
            }
        }
        
        &.submit-btn {
            background: linear-gradient(135deg, #ff6b35 0%, #f7931e 100%);
            color: white;
            border: 2rpx solid #e55a2b;
            
            &:active {
                transform: translateY(2rpx);
                box-shadow: 0 2rpx 8rpx rgba(255, 107, 53, 0.3);
            }
            
            &.loading {
                opacity: 0.8;
                transform: none;
            }
            
            &:disabled {
                background: linear-gradient(135deg, #ccc 0%, #aaa 100%);
                color: #999;
                border: 2rpx solid #bbb;
                box-shadow: none;
                
                &:active {
                    transform: none;
                }
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
        color: #ff6b35;
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
    padding: 40rpx;
}

.modal-container {
    background: white;
    border-radius: 16rpx;
    width: 100%;
    max-width: 600rpx;
    max-height: 85vh;
    overflow: hidden;
}

.modal-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 24rpx 32rpx;
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
    padding: 24rpx 32rpx;
    max-height: 60vh;
    overflow-y: auto;
}

/* 图片上传相关样式 */
.upload-container {
    margin-top: 12rpx;
    
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

/* 弹窗内输入框样式 */
.form-input.modal-input {
    width: 100%;
    height: 80rpx;
    background-color: #f8f9fa;
    border: 1px solid #e9ecef;
    border-radius: 8rpx;
    padding: 0 20rpx;
    font-size: 28rpx;
    color: #333;
    box-sizing: border-box;
    line-height: 80rpx;
    text-align: left;
    
    &:focus {
        border-color: #ff6b35;
        background-color: #fff;
    }
    
    &::placeholder {
        color: #999;
        text-align: left;
        position: static;
        transform: none;
        opacity: 1;
    }
    
    &:focus::placeholder {
        opacity: 0.6;
    }
}

.modal-footer {
    display: flex;
    border-top: 1px solid #f0f0f0;
    
    .modal-btn {
        flex: 1;
        height: 80rpx;
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
            color: #ff6b35;
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
                    border: none;
                    font-weight: 500;
                    transition: all 0.2s ease;
                    
                    &.edit {
                        background: linear-gradient(135deg, #fff5f0 0%, #ffe0d6 100%);
                        color: #ff6b35;
                        border: 1rpx solid #ffb366;
                        
                        &:active {
                            transform: translateY(1rpx);
                        }
                    }
                    
                    &.delete {
                        background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
                        color: #d32f2f;
                        border: 1rpx solid #ef9a9a;
                        
                        &:active {
                            transform: translateY(1rpx);
                        }
                    }
                }
            }
        }
        
        .add-co-organizer {
            padding: 24rpx 0;
            text-align: center;
            
            .add-text {
                color: #ff6b35;
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
        color: #ff6b35;
        font-size: 28rpx;
    }
}

.group-item {
    display: flex;
    align-items: center;
    gap: 12rpx;
    
    .group-input {
        flex: 1;
    }
    
    .group-actions {
        .action-btn {
            padding: 8rpx 16rpx;
            border-radius: 8rpx;
            font-size: 24rpx;
            background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
            color: #d32f2f;
            border: 1rpx solid #ef9a9a;
            font-weight: 500;
            transition: all 0.2s ease;
            
            &:active {
                transform: translateY(1rpx);
            }
        }
    }
}


/* 分组表单项样式 */
.form-item.group-form-item {
    padding: 12rpx 0;
    border-bottom: 1px solid #f8f8f8;
    
    &:last-child {
        border-bottom: none;
    }
}

.group-default {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 16rpx 0;
    
    .group-default-text {
        color: #999;
        font-size: 28rpx;
    }
    
    .add-link {
        color: #ff6b35;
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
        border-color: #ff6b35;
        background: linear-gradient(135deg, #ff6b35, #f7931e);
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
        border-color: #ff6b35;
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
        border-color: #4caf50;
        background-color: #f1f8e9;
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
    color: #4caf50;
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
    padding: 0 20rpx;
    height: 88rpx;
    box-sizing: border-box;
    line-height: 88rpx;
    text-align: center;
}

.custom-field-row .form-input:focus {
    text-align: left;
}

.custom-field-row .btn-secondary {
    flex-shrink: 0;
    padding: 16rpx 24rpx;
    background: linear-gradient(135deg, #ff6b35 0%, #f7931e 100%);
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
.section-title {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 32rpx;
}

.items-settings {
    background-color: white;
    margin: 0 0 16rpx 0;
    border-radius: 12rpx;
    padding: 20rpx;
    
    .title-left {
        display: flex;
        align-items: center;
        
        .title-text {
            font-size: 36rpx;
            font-weight: bold;
            color: #333;
        }
        
        .title-count {
            font-size: 28rpx;
            color: #666;
            margin-left: 16rpx;
        }
    }
    
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
            margin-bottom: 16rpx;
            background: #f8f9fa;
            border-radius: 8rpx;
            padding: 8rpx;
            border: 1rpx solid rgba(200, 200, 200, 0.3);
            box-shadow: 0 1rpx 4rpx rgba(0, 0, 0, 0.05);
            
            &:last-child {
                margin-bottom: 0;
            }
            
            .category-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 8rpx;
                padding: 16rpx 20rpx;
                border-radius: 12rpx;
                background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
                box-shadow: 0 2rpx 8rpx rgba(52, 152, 219, 0.2);
                
                .category-info {
                    display: flex;
                    align-items: center;
                    flex: 1;
                    
                    .category-name {
                        font-size: 32rpx !important;
                        font-weight: 600 !important;
                        color: #333 !important;
                    }
                    
                    .category-count {
                        font-size: 26rpx !important;
                        color: #333 !important;
                        background: rgba(255, 255, 255, 0.8) !important;
                        padding: 6rpx 14rpx;
                        border-radius: 16rpx;
                        font-weight: 500;
                        margin-left: 16rpx;
                    }
                }
                
                .category-sync {
                    display: flex;
                    align-items: center;
                    
                    .sync-btn {
                        height: 48rpx;
                        padding: 0 20rpx;
                        background: linear-gradient(135deg, #ff6b35 0%, #f7931e 100%);
                        color: white;
                        border-radius: 8rpx;
                        border: none;
                        font-size: 24rpx;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        box-shadow: 0 2rpx 6rpx rgba(255, 107, 53, 0.3);
                        transition: all 0.3s ease;
                        
                        &:active {
                            transform: translateY(1rpx);
                            box-shadow: 0 1rpx 3rpx rgba(255, 107, 53, 0.4);
                        }
                        
                        &:hover {
                            box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.15);
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
                    background-color: white;
                    border-radius: 6rpx;
                    padding: 12rpx;
                    margin-bottom: 8rpx;
                    border: 1rpx solid rgba(200, 200, 200, 0.2);
                    border-left: 2rpx solid;
                    transition: all 0.3s ease;
                    box-shadow: 0 1rpx 2rpx rgba(0, 0, 0, 0.04);
                    
                    &:hover {
                        transform: translateY(-1rpx);
                        box-shadow: 0 2rpx 4rpx rgba(0, 0, 0, 0.08);
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
                                color: #4caf50;
                                background-color: #f1f8e9;
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
                        padding: 0;
                        margin: 0 0 16rpx 0;
                        background-color: transparent;
                    }
                    
                    .settings-group {
                        margin-bottom: 16rpx;
                        background: #f8f9fa;
                        border-radius: 12rpx;
                        border: 1rpx solid rgba(200, 200, 200, 0.3);
                        box-shadow: 0 1rpx 4rpx rgba(0, 0, 0, 0.05);
                        overflow: hidden;
                        
                        &:last-child {
                            margin-bottom: 0;
                        }
                    }
                    
                    .group-header {
                        background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
                        padding: 16rpx 20rpx;
                        border-bottom: 1rpx solid rgba(255, 255, 255, 0.1);
                    }
                    
                    .group-title {
                        font-size: 28rpx;
                        font-weight: 600;
                        color: white;
                    }
                    
                    .group-content {
                        padding: 16rpx;
                    }
                    
                         .setting-item {
                        margin-bottom: 16rpx;
                            
                            &:last-child {
                                margin-bottom: 0;
                        }
                    }
                    
                    .setting-header {
                        display: flex;
                        align-items: center;
                        margin-bottom: 8rpx;
                        flex-wrap: wrap;
                            }
                            
                             .setting-label {
                        font-size: 26rpx;
                                color: #333;
                        font-weight: 500;
                        text-align: right;
                        width: 200rpx;
                        margin-right: 16rpx;
                        flex-shrink: 0;
                    }
                    
                    .setting-input-container {
                        display: flex;
                        align-items: center;
                        gap: 8rpx;
                        margin-left: 16rpx;
                            }
                            
                            .setting-input {
                                width: 120rpx;
                        height: 48rpx;
                        padding: 0 12rpx;
                                border: 1rpx solid #e0e0e0;
                                border-radius: 8rpx;
                        font-size: 26rpx;
                                background-color: white;
                                
                                &:focus {
                            border-color: #4caf50;
                            outline: none;
                                }
                            }

                    .input-unit {
                                font-size: 24rpx;
                        color: #666;
                        min-width: 32rpx;
                            }
                            
                    .setting-textarea-container {
                        margin-top: 8rpx;
                        width: 100%;
                        display: block;
                        clear: both;
                        margin-left: 0;
                        margin-right: 0;
                        flex-basis: 100%;
                            }
                    
                    .remark-setting {
                        display: block !important;
                    }
                    
                    .remark-header {
                        display: flex;
                        align-items: center;
                        margin-bottom: 8rpx;
                    }
                    
                    .remark-textarea-container {
                        display: block !important;
                        width: calc(100% - 32rpx) !important;
                        margin: 16rpx 16rpx 0 0 !important;
                        clear: both !important;
                    }
                    
                    .setting-tip {
                        font-size: 24rpx;
                        color: #999;
                        margin-left: 16rpx;
                        margin-top: 4rpx;
                        display: block;
                    }
                            
                            .setting-textarea {
                                width: 100%;
                        min-height: 80rpx;
                        padding: 12rpx 16rpx;
                                border: 1rpx solid #e0e0e0;
                                border-radius: 8rpx;
                        font-size: 26rpx;
                                background-color: white;
                        resize: none;
                                
                                &:focus {
                            border-color: #4caf50;
                            outline: none;
                                }
                            }
                            
                            .textarea-count {
                        display: block;
                        text-align: right;
                        font-size: 22rpx;
                                color: #999;
                        margin-top: 4rpx;
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
                
                .venue-actions {
                    display: flex;
                    align-items: center;
                }
                
                .add-venue-btn {
                    height: 48rpx; /* 比文字略高，整体更紧凑 */
                    padding: 0 20rpx; /* 去除上下内边距，改为定高 */
                    background: linear-gradient(135deg, #ff6b35, #f7931e);
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

                .header-right {
                    display: flex;
                    align-items: center;
                    gap: 16rpx;
                }
                
                .venue-type-tip {
                    font-size: 22rpx;
                    color: #ff6b35;
                    background: rgba(255, 107, 53, 0.1);
                    padding: 6rpx 12rpx;
                    border-radius: 16rpx;
                    border: 1rpx solid rgba(255, 107, 53, 0.2);
                }

                .select-all-right {
                    display: flex;
                    align-items: center;
                    gap: 8rpx;
                    padding: 6rpx 12rpx;
                    border-radius: 6rpx;
                    background-color: #f8f9fa;
                    border: 1rpx solid #e9ecef;
                    cursor: pointer;
                    transition: all 0.2s ease;

                    &:hover {
                        background-color: #e9ecef;
                        border-color: #dee2e6;
                    }

                    &:active {
                        background-color: #dee2e6;
                    }

                    .select-text {
                        font-size: 24rpx;
                        color: #495057;
                        white-space: nowrap;
                        order: 1;
                    }

                    .checkbox {
                        width: 32rpx;
                        height: 32rpx;
                        border: 2rpx solid #ced4da;
                        border-radius: 4rpx;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        background-color: #fff;
                        transition: all 0.2s ease;
                        order: 2;

                        &.checked {
                            background-color: #007bff;
                            border-color: #007bff;
                        }

                        .checkmark {
                            color: #fff;
                            font-size: 20rpx;
                            font-weight: bold;
                        }
                    }
                }

                .venue-selector-list {
                    flex: 1;
                    background-color: #fafafa;
                    border: 1rpx solid #e0e0e0;
                    border-radius: 8rpx;
                    padding: 16rpx;


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
                            background: linear-gradient(135deg, #f1f8e9, #e8f5e8);
                            border-color: #4caf50;
                            box-shadow: 0 2rpx 8rpx rgba(76, 175, 80, 0.15);
                            
                            .option-text { 
                                color: #4caf50; 
                                font-weight: bold;
                            }
                            .venue-code { 
                                color: #4caf50; 
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
                            background: linear-gradient(135deg, #4caf50, #66bb6a);
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
    padding: 24rpx 32rpx;
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
    background: #f8f9fa;
    display: flex;
    align-items: center;
    justify-content: center;
    border: 1px solid #e9ecef;
    &:active {
        background: #e9ecef;
    }
}

.close-text {
    font-size: 32rpx;
    color: #666;
}

.dialog-content {
    padding: 24rpx 32rpx;
}

.add-venue-section {
    margin-bottom: 32rpx;
}

.section-title {
    font-size: 30rpx;
    font-weight: 600;
    color: #333;
    margin-bottom: 20rpx;
}

.form-item {
    margin-bottom: 20rpx;
}

.form-label {
    display: block;
    font-size: 28rpx;
    color: #333;
    margin-bottom: 12rpx;
}

.form-input {
    width: 100%;
    height: 88rpx;
    border: 1px solid #e9ecef;
    border-radius: 8rpx;
    padding: 0 20rpx;
    font-size: 28rpx;
    background: #fff;
    box-sizing: border-box;
    line-height: 88rpx;
    text-align: center;
}

.form-input:focus {
    text-align: left;
}

.form-input::placeholder {
    text-align: center;
    color: #999;
    position: absolute;
    left: 0;
    right: 0;
    top: 50%;
    transform: translateY(-50%);
    transition: opacity 0.3s;
    opacity: 1;
}

.form-input:focus::placeholder {
    opacity: 1;
    color: #aaa;
}

.form-input:not(:placeholder-shown)::placeholder {
    opacity: 0;
}

.form-input.with-bg {
    background-color: #f8f9fa;
    padding: 0 20rpx;
    line-height: 88rpx;
    text-align: center;
}

.form-input.with-bg:focus {
    text-align: left;
}

.form-input.with-bg::placeholder {
    text-align: center;
    color: #999;
    position: absolute;
    left: 0;
    right: 0;
    top: 50%;
    transform: translateY(-50%);
    transition: opacity 0.3s;
    opacity: 1;
}

.form-input.with-bg:focus::placeholder {
    opacity: 1;
    color: #aaa;
}

.form-input.with-bg:not(:placeholder-shown)::placeholder {
    opacity: 0;
}

// 基础信息输入框样式（比赛名称、主办方）
.form-input.basic-input {
    background-color: #f8f9fa;
    border: 1px solid #e9ecef;
    border-radius: 8rpx;
    padding: 0 20rpx;
    height: 88rpx;
    line-height: 88rpx;
    text-align: left;
    box-sizing: border-box;
}

.form-input.basic-input:focus {
    text-align: left;
    border-color: #ff6b35;
}

.form-input.basic-input::placeholder {
    text-align: left;
    color: #999;
    position: absolute;
    left: 20rpx;
    right: 20rpx;
    top: 50%;
    transform: translateY(-50%);
    transition: opacity 0.3s;
    opacity: 1;
}

.form-input.basic-input:focus::placeholder {
    opacity: 1;
    color: #aaa;
}

.form-input.basic-input:not(:placeholder-shown)::placeholder {
    opacity: 0;
}

.picker-value {
    width: 100%;
    height: 88rpx;
    border: 1px solid #e9ecef;
    border-radius: 8rpx;
    padding: 0 20rpx;
    font-size: 28rpx;
    background: #fff;
    display: flex;
    align-items: center;
    justify-content: space-between;
    box-sizing: border-box;
    line-height: 88rpx;
}

.picker-arrow {
    color: #999;
    font-size: 24rpx;
}

/* 单选按钮组样式 */
.mode-radio-group {
    display: flex;
    gap: 32rpx;
    margin-top: 8rpx;
}

.mode-radio-item {
    display: flex;
    align-items: center;
    gap: 12rpx;
}

.radio-text {
    font-size: 28rpx;
    color: #333;
}

/* 场地输入框样式 */
.form-input.venue-input {
    width: 100%;
    height: 80rpx;
    background-color: #f8f9fa;
    border: 1px solid #e9ecef;
    border-radius: 8rpx;
    padding: 0 20rpx;
    font-size: 28rpx;
    color: #333;
    box-sizing: border-box;
    line-height: 80rpx;
    text-align: left;
    &:focus {
        border-color: #ff6b35;
        background-color: #fff;
    }
    &::placeholder {
        color: #999;
        text-align: left;
    }
}

/* 场地选择器样式 */
.picker-value.venue-picker {
    width: 100%;
    height: 80rpx;
    background-color: #f8f9fa;
    border: 1px solid #e9ecef;
    border-radius: 8rpx;
    padding: 0 20rpx;
    font-size: 28rpx;
    color: #333;
    box-sizing: border-box;
    line-height: 80rpx;
    text-align: left;
    display: flex;
    align-items: center;
    justify-content: space-between;
    &:active {
        border-color: #ff6b35;
        background-color: #fff;
    }
}

.add-btn {
    width: 100%;
    height: 80rpx;
    background: linear-gradient(135deg, #ff6b35 0%, #f7931e 100%);
    color: #fff;
    border: 2rpx solid #e55a2b;
    border-radius: 8rpx;
    font-size: 28rpx;
    margin-top: 20rpx;
    box-shadow: 0 4rpx 12rpx rgba(255, 107, 53, 0.3);
    &:active {
        transform: translateY(2rpx);
        box-shadow: 0 2rpx 8rpx rgba(255, 107, 53, 0.3);
    }
}

.add-text {
    color: #fff;
}

/* 底部关闭按钮样式 */
.close-bottom-btn {
    width: 100%;
    height: 80rpx;
    background: #f8f9fa;
    color: #666;
    border: 1px solid #e9ecef;
    border-radius: 8rpx;
    font-size: 28rpx;
    &:active {
        background: #e9ecef;
    }
}

.close-bottom-text {
    color: #666;
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
    border-radius: 8rpx;
    font-size: 24rpx;
    border: none;
    font-weight: 500;
    transition: all 0.2s ease;
}

.edit-btn {
    background: linear-gradient(135deg, #f5f5f5 0%, #e0e0e0 100%);
    color: #333;
    border: 1rpx solid #d0d0d0;
    
    &:active {
        transform: translateY(1rpx);
    }
}

.delete-btn {
    background: linear-gradient(135deg, #ff4757 0%, #ff3742 100%);
    color: #fff;
    border: 1rpx solid #e63946;
    
    &:active {
        transform: translateY(1rpx);
    }
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

/* 第7步卡片样式 */
.settings-card {
    background: #fff;
    margin: 0 32rpx 24rpx 32rpx;
    border-radius: 20rpx;
    box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.08);
    overflow: hidden;
    border: 1rpx solid #f0f0f0;
}


.card-header {
    background: #f8f9fa;
    padding: 32rpx;
    color: #333;
    border-bottom: 1rpx solid #e0e0e0;
}



.card-title {
    font-size: 30rpx;
    font-weight: 600;
    margin-bottom: 0;
    color: #333;
}

.card-content {
    padding: 32rpx;
}


.setting-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 24rpx 0;
    border-bottom: 1rpx solid #f5f5f5;
}

.setting-item:last-child {
    border-bottom: none;
}


.setting-info {
    flex: 1;
    margin-right: 24rpx;
}

.setting-label {
    display: block;
    font-size: 30rpx;
    font-weight: 500;
    color: #333;
    margin-bottom: 8rpx;
}

.setting-desc {
    display: block;
    font-size: 24rpx;
    color: #666;
    line-height: 1.4;
}

.setting-switch {
    transform: scale(1.1);
}

.coming-soon {
    text-align: center;
    padding: 60rpx 0;
}

.coming-soon-text {
    font-size: 28rpx;
    color: #999;
    background: #f8f9fa;
    padding: 16rpx 32rpx;
    border-radius: 20rpx;
    display: inline-block;
}

/* 协办单位管理样式 */
.co-organizer-section {
    display: flex;
    flex-direction: column;
    gap: 24rpx;
}

.section-info {
    .info-text {
        font-size: 26rpx;
        color: #666;
        line-height: 1.5;
    }
}

.manage-btn {
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
    box-shadow: 0 4rpx 12rpx rgba(255, 107, 53, 0.3);
    
    &:active {
        transform: translateY(2rpx);
        box-shadow: 0 2rpx 8rpx rgba(255, 107, 53, 0.3);
    }
}

.manage-icon {
    margin-right: 12rpx;
    font-size: 32rpx;
}

.manage-text {
    font-size: 28rpx;
}

/* 协办单位列表样式 */
.co-organizer-list {
    margin-bottom: 24rpx;
}

.co-organizer-item {
    background: #f8f9fa;
    border-radius: 12rpx;
    padding: 20rpx;
    margin-bottom: 16rpx;
    border-left: 4rpx solid #ff6b35;
}

.item-content {
    .item-header {
        display: flex;
        align-items: center;
        margin-bottom: 8rpx;
    }
    
    .item-name {
        font-size: 28rpx;
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
        font-size: 24rpx;
        color: #666;
        margin-right: 16rpx;
    }
    
    .item-remark {
        .remark-text {
            font-size: 22rpx;
            color: #999;
            line-height: 1.4;
        }
    }
}

.empty-state {
    text-align: center;
    padding: 40rpx 0;
    margin-bottom: 24rpx;
}

.empty-text {
    color: #999;
    font-size: 26rpx;
}

/* 号码牌设置样式 */
.card-subtitle {
    font-size: 24rpx;
    color: #999;
    margin-top: 8rpx;
}

.setting-section {
    margin-top: 32rpx;
    padding-top: 32rpx;
    border-top: 1rpx solid #f5f5f5;
}

.section-title {
    font-size: 30rpx;
    font-weight: 600;
    color: #333;
    margin-bottom: 24rpx;
    padding-left: 8rpx;
    border-left: 4rpx solid #007aff;
}

.radio-group {
    display: flex;
    gap: 32rpx;
}

.radio-item {
    display: flex;
    align-items: center;
    gap: 12rpx;
}

.radio-text {
    font-size: 28rpx;
    color: #333;
}

.form-row {
    display: flex;
    gap: 24rpx;
}

.form-item.half {
    flex: 1;
}

.form-row.three-columns {
    display: flex;
    gap: 16rpx;
}

.form-item.third {
    flex: 1;
}

.form-picker {
    width: 100%;
}

.form-picker.with-bg .picker-display {
    background-color: #f8f9fa;
}

.picker-display {
    width: 100%;
    height: 88rpx;
    border: 1px solid #e9ecef;
    border-radius: 8rpx;
    padding: 0 20rpx;
    font-size: 28rpx;
    background: #fff;
    display: flex;
    align-items: center;
    justify-content: space-between;
    box-sizing: border-box;
    line-height: 88rpx;
}

.number-preview {
    display: flex;
    align-items: center;
    gap: 16rpx;
    padding: 20rpx;
    background: #f8f9fa;
    border-radius: 12rpx;
    border: 1rpx solid #e9ecef;
}

.preview-label {
    font-size: 26rpx;
    color: #666;
}

.preview-number {
    font-size: 32rpx;
    font-weight: 600;
    color: #007aff;
    background: #fff;
    padding: 8rpx 16rpx;
    border-radius: 8rpx;
    border: 1rpx solid #007aff;
}

.number-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 12rpx;
    margin-bottom: 16rpx;
    min-height: 40rpx;
}

.number-tag {
    display: flex;
    align-items: center;
    gap: 8rpx;
    background: #e3f2fd;
    color: #1976d2;
    padding: 8rpx 12rpx;
    border-radius: 20rpx;
    font-size: 24rpx;
    border: 1rpx solid #bbdefb;
}

.number-tag.disabled {
    background: #ffebee;
    color: #d32f2f;
    border-color: #ffcdd2;
}

.tag-text {
    font-size: 24rpx;
}

.tag-remove {
    font-size: 28rpx;
    font-weight: bold;
    cursor: pointer;
    color: #999;
    
    &:hover {
        color: #f44336;
    }
}

.number-input-row {
    display: flex;
    gap: 16rpx;
    align-items: center;
}

.number-input-section {
    margin-top: 16rpx;
}

.number-input-section .form-input {
    width: 100%;
    background-color: #f8f9fa;
    border: 1px solid #e9ecef;
    border-radius: 8rpx;
    padding: 0 20rpx;
    height: 88rpx;
    box-sizing: border-box;
    margin-bottom: 16rpx;
    line-height: 88rpx;
    text-align: center;
}

.number-input-section .form-input:focus {
    text-align: left;
}

.number-input-section .form-input::placeholder {
    color: #999;
    font-size: 26rpx;
    text-align: center;
    position: absolute;
    left: 0;
    right: 0;
    top: 50%;
    transform: translateY(-50%);
    transition: opacity 0.3s;
    opacity: 1;
}

.number-input-section .form-input:focus::placeholder {
    opacity: 1;
    color: #aaa;
}

.number-input-section .form-input:not(:placeholder-shown)::placeholder {
    opacity: 0;
}

.number-input-section .add-btn {
    width: 100%;
    padding: 16rpx 24rpx;
    background: linear-gradient(135deg, #ff6b35 0%, #f7931e 100%);
    color: white;
    border: none;
    border-radius: 8rpx;
    font-size: 26rpx;
    white-space: nowrap;
    height: 88rpx;
    line-height: 56rpx;
    box-sizing: border-box;
}

.time-window-row {
    display: flex;
    align-items: center;
    gap: 16rpx;
}

.time-unit {
    font-size: 28rpx;
    color: #666;
    white-space: nowrap;
}

.form-desc {
    font-size: 24rpx;
    color: #999;
    margin-top: 8rpx;
    line-height: 1.4;
}

/* 开关容器样式 */
.switch-container {
    display: flex;
    align-items: center;
    gap: 16rpx;
}

.switch-text {
    font-size: 28rpx;
    color: #333;
    font-weight: 500;
}

.form-hint {
    font-size: 24rpx;
    color: #999;
    margin-top: 8rpx;
    line-height: 1.4;
}
</style> 
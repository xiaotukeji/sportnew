<template>
    <view class="container">
        <!-- 页面头部 -->
        <view class="page-header">
            <view class="header-left" @click="goBack">
                <text class="nc-iconfont nc-icon-zuoV6xx"></text>
                <text class="header-title">DIY设计</text>
            </view>
            <view class="header-right">
                <button class="preview-btn" @click="previewPage">预览</button>
                <button class="save-btn" @click="saveConfig" :disabled="isSaving">
                    {{ isSaving ? '保存中...' : '保存' }}
                </button>
            </view>
        </view>

        <!-- 加载状态 -->
        <view v-if="loading" class="loading-container">
            <text>加载中...</text>
        </view>
        
        <!-- 赛事详情 -->
        <view v-else-if="eventInfo" class="event-detail">
            <!-- Banner轮播图模块 -->
            <view class="detail-card diy-module" :class="{ 'module-disabled': !moduleSettings.banner.enabled }">
                <view class="card-title">
                    <text class="title-text">Banner轮播图</text>
                    <view class="module-toggle" @click="toggleModule('banner')">
                        <switch :checked="moduleSettings.banner.enabled" />
                    </view>
                </view>
                <view v-if="moduleSettings.banner.enabled" class="banner-content">
                    <view v-if="bannerList.length > 0" class="banner-carousel">
                        <swiper class="banner-swiper" :indicator-dots="true" :autoplay="true">
                            <swiper-item v-for="(banner, index) in bannerList" :key="index">
                                <image :src="banner.image_url" class="banner-image" mode="aspectFill" />
                            </swiper-item>
                        </swiper>
                    </view>
                    <view v-else class="banner-placeholder" @click="addBanner">
                        <text class="placeholder-text">点击添加Banner图片</text>
                    </view>
                </view>
            </view>

            <!-- 赛事基本信息 -->
            <view class="detail-card diy-module" :class="{ 'module-disabled': !moduleSettings.basicInfo.enabled }">
                <view class="card-title">
                    <text class="title-text">基本信息</text>
                    <view class="module-toggle" @click="toggleModule('basicInfo')">
                        <switch :checked="moduleSettings.basicInfo.enabled" />
                    </view>
                </view>
                
                <view v-if="moduleSettings.basicInfo.enabled">
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
            </view>
            
            <!-- 时间信息 -->
            <view class="detail-card diy-module" :class="{ 'module-disabled': !moduleSettings.timeInfo.enabled }">
                <view class="card-title">
                    <text class="title-text">时间信息</text>
                    <view class="module-toggle" @click="toggleModule('timeInfo')">
                        <switch :checked="moduleSettings.timeInfo.enabled" />
                    </view>
                </view>
                
                <view v-if="moduleSettings.timeInfo.enabled">
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
                </view>
            </view>
            
            <!-- 地址信息 -->
            <view class="detail-card diy-module" :class="{ 'module-disabled': !moduleSettings.locationInfo.enabled }">
                <view class="card-title">
                    <text class="title-text">地址信息</text>
                    <view class="module-toggle" @click="toggleModule('locationInfo')">
                        <switch :checked="moduleSettings.locationInfo.enabled" />
                    </view>
                </view>
                
                <view v-if="moduleSettings.locationInfo.enabled">
                    <view class="detail-item">
                        <text class="label">举办地点</text>
                        <text class="value">{{ eventInfo.location }}</text>
                    </view>
                    
                    <view v-if="getAddressDetail(eventInfo)" class="detail-item">
                        <text class="label">详细地址</text>
                        <text class="value">{{ getAddressDetail(eventInfo) }}</text>
                    </view>
                </view>
            </view>
            
            <!-- 联系方式信息 -->
            <view v-if="eventInfo.contact_name || eventInfo.contact_phone || eventInfo.contact_wechat || eventInfo.contact_email" class="detail-card diy-module" :class="{ 'module-disabled': !moduleSettings.contactInfo.enabled }">
                <view class="card-title">
                    <text class="title-text">联系方式</text>
                    <view class="module-toggle" @click="toggleModule('contactInfo')">
                        <switch :checked="moduleSettings.contactInfo.enabled" />
                    </view>
                </view>
                
                <view v-if="moduleSettings.contactInfo.enabled">
                    <view class="detail-item">
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
            </view>
            
            <!-- 主办方信息 -->
            <view class="detail-card diy-module" :class="{ 'module-disabled': !moduleSettings.organizerInfo.enabled }">
                <view class="card-title">
                    <text class="title-text">主办方信息</text>
                    <view class="module-toggle" @click="toggleModule('organizerInfo')">
                        <switch :checked="moduleSettings.organizerInfo.enabled" />
                    </view>
                </view>
                
                <view v-if="moduleSettings.organizerInfo.enabled">
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
            </view>
            
            <!-- 协办方信息 -->
            <view v-if="eventInfo.co_organizers && eventInfo.co_organizers.length > 0" class="detail-card diy-module" :class="{ 'module-disabled': !moduleSettings.coOrganizerInfo.enabled }">
                <view class="card-title">
                    <text class="title-text">协办方信息</text>
                    <text class="item-count">({{ eventInfo.co_organizers.length }}个)</text>
                    <view class="module-toggle" @click="toggleModule('coOrganizerInfo')">
                        <switch :checked="moduleSettings.coOrganizerInfo.enabled" />
                    </view>
                </view>
                
                <view v-if="moduleSettings.coOrganizerInfo.enabled">
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
            </view>
            
            <!-- 报名参数字段 -->
            <view class="detail-card diy-module" :class="{ 'module-disabled': !moduleSettings.signupFields.enabled }">
                <view class="card-title">
                    <text class="title-text">报名参数字段</text>
                    <text v-if="eventInfo.signup_fields && eventInfo.signup_fields.length > 0" class="item-count">
                        ({{ eventInfo.signup_fields.length }}项，必填{{ requiredFieldsCount }}项)
                    </text>
                    <view class="module-toggle" @click="toggleModule('signupFields')">
                        <switch :checked="moduleSettings.signupFields.enabled" />
                    </view>
                </view>
                
                <view v-if="moduleSettings.signupFields.enabled">
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
            </view>
            
            <!-- 自定义分组信息 -->
            <view v-if="eventInfo.custom_groups && eventInfo.custom_groups.length > 0" class="detail-card diy-module" :class="{ 'module-disabled': !moduleSettings.customGroups.enabled }">
                <view class="card-title">
                    <text class="title-text">自定义分组</text>
                    <text class="item-count">({{ eventInfo.custom_groups.length }}个)</text>
                    <view class="module-toggle" @click="toggleModule('customGroups')">
                        <switch :checked="moduleSettings.customGroups.enabled" />
                    </view>
                </view>
                
                <view v-if="moduleSettings.customGroups.enabled">
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
            </view>
            
            <!-- 比赛项目设置 -->
            <view class="detail-card diy-module" :class="{ 'module-disabled': !moduleSettings.eventItems.enabled }">
                <view class="card-title">
                    <text class="title-text">比赛项目设置</text>
                    <text class="item-count">({{ groupedEventItems.length }}大类 {{ eventItems.length }}项)</text>
                    <view class="module-toggle" @click="toggleModule('eventItems')">
                        <switch :checked="moduleSettings.eventItems.enabled" />
                    </view>
                </view>
                
                <view v-if="moduleSettings.eventItems.enabled">
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
            </view>
            
            <!-- 比赛场地安排 -->
            <view v-if="hasVenueArrangements" class="detail-card diy-module" :class="{ 'module-disabled': !moduleSettings.venueArrangements.enabled }">
                <view class="card-title">
                    <text class="title-text">比赛场地安排</text>
                    <view class="module-toggle" @click="toggleModule('venueArrangements')">
                        <switch :checked="moduleSettings.venueArrangements.enabled" />
                    </view>
                </view>
                
                <view v-if="moduleSettings.venueArrangements.enabled">
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
            </view>
            
            <!-- 显示设置 -->
            <view class="detail-card diy-module" :class="{ 'module-disabled': !moduleSettings.displaySettings.enabled }">
                <view class="card-title">
                    <text class="title-text">显示设置</text>
                    <view class="module-toggle" @click="toggleModule('displaySettings')">
                        <switch :checked="moduleSettings.displaySettings.enabled" />
                    </view>
                </view>
                
                <view v-if="moduleSettings.displaySettings.enabled">
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
            </view>
            
            <!-- 号码牌设置 -->
            <view v-if="eventInfo.number_plate_settings" class="detail-card diy-module" :class="{ 'module-disabled': !moduleSettings.numberPlate.enabled }">
                <view class="card-title">
                    <text class="title-text">号码牌设置</text>
                    <view class="module-toggle" @click="toggleModule('numberPlate')">
                        <switch :checked="moduleSettings.numberPlate.enabled" />
                    </view>
                </view>
                
                <view v-if="moduleSettings.numberPlate.enabled">
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
            </view>
            
            <!-- 赛事状态 -->
            <view class="detail-card diy-module" :class="{ 'module-disabled': !moduleSettings.eventStatus.enabled }">
                <view class="card-title">
                    <text class="title-text">赛事状态</text>
                    <view class="module-toggle" @click="toggleModule('eventStatus')">
                        <switch :checked="moduleSettings.eventStatus.enabled" />
                    </view>
                </view>
                
                <view v-if="moduleSettings.eventStatus.enabled">
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
            
            <!-- 备注说明 -->
            <view v-if="eventInfo.remark" class="detail-card diy-module" :class="{ 'module-disabled': !moduleSettings.remarkInfo.enabled }">
                <view class="card-title">
                    <text class="title-text">备注说明</text>
                    <view class="module-toggle" @click="toggleModule('remarkInfo')">
                        <switch :checked="moduleSettings.remarkInfo.enabled" />
                    </view>
                </view>
                
                <view v-if="moduleSettings.remarkInfo.enabled">
                    <view class="detail-item">
                        <text class="remark-text">{{ eventInfo.remark }}</text>
                    </view>
                </view>
            </view>
        </view>

    <!-- Banner编辑弹窗 -->
    <u-popup :show="bannerEditShow" @close="bannerEditShow = false" mode="bottom" height="80%">
      <view class="popup-content">
        <view class="popup-header">
          <text class="popup-title">Banner设置</text>
          <text class="close-btn" @click="bannerEditShow = false">×</text>
        </view>
        <view class="popup-body">
          <view class="form-group">
            <text class="form-label">轮播图片</text>
            <view class="image-list">
              <view v-for="(banner, index) in bannerList" :key="index" class="image-item">
                <image :src="banner.image_url" class="preview-image" mode="aspectFill" />
                <button class="delete-image-btn" @click="removeBannerImage(index)">×</button>
              </view>
              <view class="add-image-btn" @click="chooseBannerImage">
                <text class="add-icon">+</text>
                <text class="add-text">添加图片</text>
              </view>
            </view>
          </view>
        </view>
      </view>
    </u-popup>

    <!-- 基本信息编辑弹窗 -->
    <u-popup :show="basicInfoEditShow" @close="basicInfoEditShow = false" mode="bottom" height="60%">
      <view class="popup-content">
        <view class="popup-header">
          <text class="popup-title">基本信息设置</text>
          <text class="close-btn" @click="basicInfoEditShow = false">×</text>
        </view>
        <view class="popup-body">
          <view class="form-group">
            <text class="form-label">赛事名称</text>
            <input class="form-input" v-model="eventInfo.name" placeholder="请输入赛事名称" />
          </view>
          <view class="form-group">
            <text class="form-label">开始时间</text>
            <input class="form-input" v-model="eventInfo.start_time" placeholder="请输入开始时间" />
          </view>
          <view class="form-group">
            <text class="form-label">结束时间</text>
            <input class="form-input" v-model="eventInfo.end_time" placeholder="请输入结束时间" />
          </view>
          <view class="form-group">
            <text class="form-label">举办地点</text>
            <input class="form-input" v-model="eventInfo.location" placeholder="请输入举办地点" />
          </view>
        </view>
      </view>
    </u-popup>

    <!-- 报名按钮编辑弹窗 -->
    <u-popup :show="signupEditShow" @close="signupEditShow = false" mode="bottom" height="50%">
      <view class="popup-content">
        <view class="popup-header">
          <text class="popup-title">报名按钮设置</text>
          <text class="close-btn" @click="signupEditShow = false">×</text>
        </view>
        <view class="popup-body">
          <view class="form-group">
            <text class="form-label">按钮文字</text>
            <input class="form-input" v-model="signupButtonText" placeholder="请输入按钮文字" />
          </view>
          <view class="form-group">
            <text class="form-label">按钮样式</text>
            <view class="style-options">
              <view 
                v-for="(style, index) in buttonStyles" 
                :key="index"
                class="style-option"
                :class="{ active: signupButtonStyleIndex === index }"
                @click="signupButtonStyleIndex = index"
              >
                <button class="style-btn" :class="style">{{ signupButtonText }}</button>
              </view>
            </view>
          </view>
        </view>
      </view>
    </u-popup>
  </view>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { diyConfigApi, bannerApi, contentApi, type DIYConfig, type DIYModule } from '@/addon/sport/api/diy'
import { getEventDetailInfo, getEventItems } from '@/addon/sport/api/event'
import useMemberStore from '@/stores/member'
import { useLogin } from '@/hooks/useLogin'

// 页面参数
const eventId = ref<number>(0)

// 登录状态管理
const memberStore = useMemberStore()
const login = useLogin()
const userInfo = computed(() => memberStore.info)

// 状态管理
const loading = ref(true)
const isSaving = ref(false)
const selectedModule = ref<string>('')

// 弹窗状态
const bannerEditShow = ref(false)
const basicInfoEditShow = ref(false)
const signupEditShow = ref(false)

// 模块设置
const moduleSettings = ref({
  banner: { enabled: true },
  basicInfo: { enabled: true },
  timeInfo: { enabled: true },
  locationInfo: { enabled: true },
  contactInfo: { enabled: true },
  organizerInfo: { enabled: true },
  coOrganizerInfo: { enabled: true },
  signupFields: { enabled: true },
  customGroups: { enabled: true },
  eventItems: { enabled: true },
  venueArrangements: { enabled: true },
  displaySettings: { enabled: true },
  numberPlate: { enabled: true },
  eventStatus: { enabled: true },
  remarkInfo: { enabled: true }
})

// 赛事信息
const eventInfo = ref<any>({
  name: '',
  start_time: '',
  end_time: '',
  location: '',
  address_detail: '',
  organizer_name: '',
  co_organizer: [],
  series: '',
  category: '',
  contact_phone: '',
  contact_email: '',
  contact_name: '',
  contact_wechat: '',
  signup_fields: [],
  custom_groups: [],
  age_groups: [],
  registration_start_time: '',
  registration_end_time: '',
  event_type: 1,
  series_name: '',
  season: ''
})

// Banner数据
const bannerList = ref<any[]>([])

// 比赛项目数据
const eventItems = ref<any[]>([])

// 详情内容数据
const detailContentList = ref<any[]>([])

// 报名按钮设置
const signupButtonText = ref('立即报名')
const signupButtonStyle = ref('primary')
const signupButtonStyleIndex = ref(0)
const buttonStyles = ['primary', 'secondary', 'success', 'warning']

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

// 检查是否有场地安排
const hasVenueArrangements = computed(() => {
    if (!eventItems.value || eventItems.value.length === 0) return false
    return eventItems.value.some(item => item.venues && item.venues.length > 0)
})

// 页面初始化
onMounted(() => {
  // 检查登录状态
  if (!userInfo.value) {
    login.setLoginBack({ url: `/addon/sport/pages/event/diy_design?event_id=${eventId.value}` })
    return
  }
  
  const pages = getCurrentPages()
  const currentPage = pages[pages.length - 1] as any
  eventId.value = currentPage.options?.event_id || 0
  
  if (eventId.value) {
    loadDiyConfig()
    loadBannerImages()
    loadEventInfo()
    loadEventItems()
    loadDetailContent()
  }
})

// 加载DIY配置
const loadDiyConfig = async () => {
  try {
    console.log('开始加载DIY配置，eventId:', eventId.value)
    const response: any = await diyConfigApi.getEventDiyConfig(eventId.value)
    console.log('DIY配置响应:', response)
    
    if (response.data) {
      const config = response.data
      console.log('配置数据:', config)
      
      // 更新模块设置
      if (config.module_settings) {
        Object.keys(config.module_settings).forEach(key => {
          if (moduleSettings.value[key as keyof typeof moduleSettings.value]) {
            moduleSettings.value[key as keyof typeof moduleSettings.value] = config.module_settings[key]
          }
        })
      }
      
      // 更新报名按钮设置
      if (config.signup_button) {
        signupButtonText.value = config.signup_button.text || '立即报名'
        signupButtonStyle.value = config.signup_button.style || 'primary'
      }
      
      console.log('DIY配置加载完成')
    } else {
      console.log('没有配置数据，使用默认设置')
    }
  } catch (error) {
    console.error('加载DIY配置失败:', error)
    // 使用默认配置
    console.log('使用默认模块设置')
  }
}

// 加载Banner图片
const loadBannerImages = async () => {
  try {
    const response: any = await bannerApi.getEventBanners(eventId.value)
    if (response.data) {
      // 确保 response.data 是数组格式
      bannerList.value = Array.isArray(response.data) ? response.data : []
    } else {
      bannerList.value = []
    }
  } catch (error) {
    console.error('加载Banner图片失败:', error)
    bannerList.value = []
  }
}

// 加载赛事信息
const loadEventInfo = async () => {
  try {
    const response: any = await getEventDetailInfo(eventId.value)
    if (response.data) {
      const eventData = response.data
      eventInfo.value = {
        name: eventData.name || '',
        start_time: eventData.start_time || '',
        end_time: eventData.end_time || '',
        location: eventData.location || '',
        address_detail: eventData.address_detail || '',
        organizer_name: eventData.organizer?.name || '',
        co_organizer: eventData.co_organizer || [],
        series: eventData.series?.name || '',
        category: eventData.category?.name || '',
        contact_phone: eventData.contact_phone || '',
        contact_email: eventData.contact_email || '',
        contact_name: eventData.contact_name || '',
        contact_wechat: eventData.contact_wechat || '',
        signup_fields: eventData.signup_fields || [],
        custom_groups: eventData.custom_groups || [],
        age_groups: eventData.age_groups || [],
        registration_start_time: eventData.registration_start_time || '',
        registration_end_time: eventData.registration_end_time || '',
        event_type: eventData.event_type || 1,
        series_name: eventData.series_name || '',
        season: eventData.season || ''
      }
    }
    loading.value = false
  } catch (error) {
    console.error('加载赛事信息失败:', error)
    loading.value = false
  }
}

// 加载比赛项目
const loadEventItems = async () => {
  try {
    const response: any = await getEventItems(eventId.value)
    if (response.data) {
      eventItems.value = response.data
    } else {
      eventItems.value = []
    }
  } catch (error) {
    console.error('加载比赛项目失败:', error)
    eventItems.value = []
  }
}

// 加载详情内容
const loadDetailContent = async () => {
  try {
    const response: any = await contentApi.getEventDetailContent(eventId.value)
    if (response.data) {
      detailContentList.value = [
        { 
          title: '赛事详情', 
          content: response.data.content_data || '暂无详细说明' 
        }
      ]
    } else {
      detailContentList.value = [
        { title: '赛事详情', content: '暂无详细说明' }
      ]
    }
  } catch (error) {
    console.error('加载详情内容失败:', error)
    detailContentList.value = [
      { title: '赛事详情', content: '暂无详细说明' }
    ]
  }
}

// 选择模块
const selectModule = (moduleKey: string) => {
  selectedModule.value = selectedModule.value === moduleKey ? '' : moduleKey
}

// 获取报名状态
const getRegistrationStatus = () => {
  if (!eventInfo.value.registration_start_time || !eventInfo.value.registration_end_time) {
    return '未设置报名时间'
  }
  
  const now = new Date()
  const startTime = new Date(eventInfo.value.registration_start_time)
  const endTime = new Date(eventInfo.value.registration_end_time)
  
  if (now < startTime) {
    return '报名未开始'
  } else if (now > endTime) {
    return '报名已结束'
  } else {
    return '报名进行中'
  }
}

// 获取总参赛人数
const getTotalParticipants = () => {
  return eventItems.value.reduce((total, item) => {
    return total + (item.participant_count || 0)
  }, 0)
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
 * 获取详细地址
 */
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
 * 获取大类颜色
 */
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

/**
 * 获取大类边框颜色
 */
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

/**
 * 获取状态文本
 */
const getStatusText = (status: number) => {
    const statusMap: Record<number, string> = {
        0: '待发布',
        1: '进行中', 
        2: '已结束',
        3: '已作废'
    }
    return statusMap[status] || '未知状态'
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

// 切换模块显示状态
const toggleModule = (moduleKey: string) => {
  if (moduleSettings.value[moduleKey as keyof typeof moduleSettings.value]) {
    moduleSettings.value[moduleKey as keyof typeof moduleSettings.value].enabled = !moduleSettings.value[moduleKey as keyof typeof moduleSettings.value].enabled
  }
}

// 编辑Banner
const editBanner = () => {
  bannerEditShow.value = true
}

// 添加Banner
const addBanner = () => {
  chooseBannerImage()
}

// 删除Banner
const deleteBanner = () => {
  bannerList.value = []
}

// 选择Banner图片
const chooseBannerImage = () => {
  uni.chooseImage({
    count: 9,
    sizeType: ['compressed'],
    sourceType: ['album', 'camera'],
    success: (res) => {
      // 确保 bannerList.value 是数组
      if (!Array.isArray(bannerList.value)) {
        bannerList.value = []
      }
      
      // 这里应该上传图片到服务器
      if (Array.isArray(res.tempFilePaths)) {
        res.tempFilePaths.forEach((path: string) => {
          bannerList.value.push({
            image_url: path,
            sort: bannerList.value.length
          })
        })
      }
    }
  })
}

// 移除Banner图片
const removeBannerImage = (index: number) => {
  if (Array.isArray(bannerList.value) && index >= 0 && index < bannerList.value.length) {
    bannerList.value.splice(index, 1)
  }
}

// 编辑基本信息
const editBasicInfo = () => {
  basicInfoEditShow.value = true
}

// 编辑比赛项目
const editEventItems = () => {
  uni.navigateTo({
    url: `/addon/sport/pages/event/items?event_id=${eventId.value}`
  })
}

// 编辑详情内容
const editDetailContent = () => {
  uni.navigateTo({
    url: `/addon/sport/pages/event/content?event_id=${eventId.value}`
  })
}

// 添加内容
const addContent = () => {
  detailContentList.value.push({
    title: '新内容',
    content: '请输入内容'
  })
}

// 编辑报名操作
const editSignupAction = () => {
  signupEditShow.value = true
}

// 保存配置
const saveConfig = async () => {
  if (isSaving.value) return
  
  isSaving.value = true
  try {
    const configData = {
      event_id: eventId.value,
      config_data: {
        module_settings: moduleSettings.value,
        banner_list: bannerList.value,
        signup_button: {
          text: signupButtonText.value,
          style: signupButtonStyle.value
        }
      }
    }
    
    await diyConfigApi.saveEventDiyConfig(configData)
    uni.showToast({ title: '保存成功', icon: 'success' })
  } catch (error) {
    console.error('保存配置失败:', error)
    uni.showToast({ title: '保存失败', icon: 'error' })
  } finally {
    isSaving.value = false
  }
}

// 预览页面
const previewPage = () => {
  uni.navigateTo({
    url: `/addon/sport/pages/event/signup_show?event_id=${eventId.value}`
  })
}

// 返回上一页
const goBack = () => {
  uni.navigateBack()
}

// 监听按钮样式变化
watch(signupButtonStyleIndex, (newIndex) => {
  signupButtonStyle.value = buttonStyles[newIndex]
})
</script>

<style lang="scss" scoped>
.container {
    min-height: 100vh;
    background-color: #f5f5f5;
    padding-bottom: 120rpx;
}

.loading-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 60vh;
    
    text {
        font-size: 28rpx;
        color: #999;
    }
}

.page-header {
    background-color: white;
    padding: 40rpx 32rpx;
    margin-bottom: 20rpx;
    display: flex;
    justify-content: space-between;
    align-items: center;
    
    .header-left {
        display: flex;
        align-items: center;
        
        .nc-iconfont {
            font-size: 36rpx;
            margin-right: 10rpx;
        }
        
        .header-title {
            font-size: 36rpx;
            font-weight: bold;
            color: #333;
        }
    }
    
    .header-right {
        display: flex;
        gap: 20rpx;
        
        .preview-btn, .save-btn {
            padding: 12rpx 24rpx;
            border-radius: 8rpx;
            font-size: 28rpx;
            border: none;
        }
        
        .preview-btn {
            background: #f0f0f0;
            color: #666;
        }
        
        .save-btn {
            background: #007aff;
            color: white;
            
            &:disabled {
                background: #ccc;
            }
        }
    }
}

.detail-card {
    background-color: white;
    margin: 0 32rpx 20rpx;
    border-radius: 16rpx;
    padding: 32rpx;
    
    &.module-disabled {
        opacity: 0.5;
    }
    
    .card-title {
        margin-bottom: 32rpx;
        padding-bottom: 20rpx;
        border-bottom: 1rpx solid #f0f0f0;
        display: flex;
        justify-content: space-between;
        align-items: center;
        
        .title-text {
            font-size: 32rpx;
            font-weight: bold;
            color: #333;
        }
        
        .module-toggle {
            switch {
                transform: scale(0.8);
            }
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
        }
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
}

.banner-content {
    .banner-carousel {
        .banner-swiper {
            height: 300rpx;
            border-radius: 12rpx;
            overflow: hidden;
            
            .banner-image {
                width: 100%;
                height: 100%;
            }
        }
    }
    
    .banner-placeholder {
        height: 300rpx;
        background: #f8f8f8;
        border: 2rpx dashed #ddd;
        border-radius: 12rpx;
        display: flex;
        align-items: center;
        justify-content: center;
        
        .placeholder-text {
            color: #999;
            font-size: 28rpx;
        }
    }
}

.main-content {
  padding: 20rpx;
}

.diy-preview-container {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
}

.diy-module {
  background: white;
  border-radius: 16rpx;
  padding: 20rpx;
  position: relative;
  
  &.module-disabled {
    opacity: 0.5;
  }
  
  .module-controls {
    position: absolute;
    top: -10rpx;
    right: 20rpx;
    display: flex;
    gap: 10rpx;
    background: white;
    padding: 10rpx;
    border-radius: 8rpx;
    box-shadow: 0 2rpx 8rpx rgba(0,0,0,0.1);
    z-index: 10;
    
    .control-btn {
      padding: 8rpx 16rpx;
      border-radius: 6rpx;
      font-size: 24rpx;
      border: none;
      
      &.add-btn {
        background: #4cd964;
        color: white;
      }
      
      &.delete-btn {
        background: #ff3b30;
        color: white;
      }
      
      &.edit-btn {
        background: #007aff;
        color: white;
      }
    }
  }
  
  .module-content {
    position: relative;
    
    &.selected {
      border: 2rpx dashed #007aff;
    }
  }
  
  .module-toggle {
    position: absolute;
    top: 20rpx;
    right: 20rpx;
    z-index: 5;
  }
}

// Banner模块样式
.banner-module {
  .banner-carousel {
    .banner-swiper {
      height: 300rpx;
      border-radius: 12rpx;
      overflow: hidden;
      
      .banner-image {
        width: 100%;
        height: 100%;
      }
    }
  }
  
  .banner-placeholder {
    height: 300rpx;
    background: #f8f8f8;
    border: 2rpx dashed #ddd;
    border-radius: 12rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    
    .placeholder-text {
      color: #999;
      font-size: 28rpx;
    }
  }
}

// 基本信息模块样式
.basic-info-module {
  .event-basic-info {
    .event-name {
      font-size: 36rpx;
      font-weight: bold;
      color: #333;
      margin-bottom: 20rpx;
      display: block;
    }
    
    .info-row {
      display: flex;
      margin-bottom: 12rpx;
      
      .info-label {
        color: #666;
        font-size: 28rpx;
        width: 120rpx;
      }
      
      .info-value {
        color: #333;
        font-size: 28rpx;
        flex: 1;
      }
    }
  }
}

// 比赛项目模块样式
.event-items-module {
  .event-items-list {
    .section-title {
      font-size: 32rpx;
      font-weight: bold;
      color: #333;
      margin-bottom: 20rpx;
      display: block;
    }
    
    .item-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 16rpx 0;
      border-bottom: 1rpx solid #f0f0f0;
      
      .item-name {
        font-size: 28rpx;
        color: #333;
      }
      
      .item-category {
        font-size: 24rpx;
        color: #999;
      }
    }
    
    .more-items {
      font-size: 24rpx;
      color: #999;
      text-align: center;
      margin-top: 16rpx;
      display: block;
    }
  }
}

// 详情内容模块样式
.detail-content-module {
  .detail-content {
    .section-title {
      font-size: 32rpx;
      font-weight: bold;
      color: #333;
      margin-bottom: 20rpx;
      display: block;
    }
    
    .content-item {
      margin-bottom: 20rpx;
      
      .content-title {
        font-size: 28rpx;
        font-weight: bold;
        color: #333;
        margin-bottom: 8rpx;
        display: block;
      }
      
      .content-text {
        font-size: 26rpx;
        color: #666;
        line-height: 1.6;
      }
    }
    
    .placeholder-text {
      color: #999;
      font-size: 28rpx;
      text-align: center;
      padding: 40rpx 0;
      display: block;
    }
  }
}

// 报名操作模块样式
.signup-action-module {
  .signup-action {
    text-align: center;
    
    .signup-btn {
      width: 100%;
      height: 80rpx;
      border-radius: 40rpx;
      font-size: 32rpx;
      font-weight: bold;
      border: none;
      margin-bottom: 16rpx;
      
      &.primary {
        background: linear-gradient(135deg, #007aff 0%, #0051d5 100%);
        color: white;
      }
      
      &.secondary {
        background: linear-gradient(135deg, #8e8e93 0%, #636366 100%);
        color: white;
      }
      
      &.success {
        background: linear-gradient(135deg, #4cd964 0%, #34c759 100%);
        color: white;
      }
      
      &.warning {
        background: linear-gradient(135deg, #ff9500 0%, #ff6b35 100%);
        color: white;
      }
    }
    
    .signup-tips {
      font-size: 24rpx;
      color: #999;
    }
  }
}

// 弹窗样式
.popup-content {
  background: white;
  border-radius: 20rpx 20rpx 0 0;
  height: 100%;
  display: flex;
  flex-direction: column;
  
  .popup-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 30rpx;
    border-bottom: 1rpx solid #eee;
    
    .popup-title {
      font-size: 32rpx;
      font-weight: bold;
    }
    
    .close-btn {
      font-size: 40rpx;
      color: #999;
    }
  }
  
  .popup-body {
    flex: 1;
    padding: 30rpx;
    overflow-y: auto;
  }
}

.form-group {
  margin-bottom: 30rpx;
  
  .form-label {
    font-size: 28rpx;
    color: #333;
    margin-bottom: 16rpx;
    display: block;
  }
  
  .form-input {
    width: 100%;
    height: 80rpx;
    border: 1rpx solid #ddd;
    border-radius: 8rpx;
    padding: 0 20rpx;
    font-size: 28rpx;
  }
}

.image-list {
  display: flex;
  flex-wrap: wrap;
  gap: 20rpx;
  
  .image-item {
    position: relative;
    width: 200rpx;
    height: 200rpx;
    
    .preview-image {
      width: 100%;
      height: 100%;
      border-radius: 8rpx;
    }
    
    .delete-image-btn {
      position: absolute;
      top: -10rpx;
      right: -10rpx;
      width: 40rpx;
      height: 40rpx;
      border-radius: 50%;
      background: #ff3b30;
      color: white;
      border: none;
      font-size: 24rpx;
    }
  }
  
  .add-image-btn {
    width: 200rpx;
    height: 200rpx;
    border: 2rpx dashed #ddd;
    border-radius: 8rpx;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    
    .add-icon {
      font-size: 48rpx;
      color: #999;
      margin-bottom: 10rpx;
    }
    
    .add-text {
      font-size: 24rpx;
      color: #999;
    }
  }
}

.style-options {
  display: flex;
  flex-wrap: wrap;
  gap: 20rpx;
  
  .style-option {
    &.active {
      border: 2rpx solid #007aff;
      border-radius: 8rpx;
      padding: 4rpx;
    }
    
    .style-btn {
      width: 200rpx;
      height: 60rpx;
      border-radius: 30rpx;
      border: none;
      font-size: 28rpx;
      
      &.primary {
        background: linear-gradient(135deg, #007aff 0%, #0051d5 100%);
        color: white;
      }
      
      &.secondary {
        background: linear-gradient(135deg, #8e8e93 0%, #636366 100%);
        color: white;
      }
      
      &.success {
        background: linear-gradient(135deg, #4cd964 0%, #34c759 100%);
        color: white;
      }
      
      &.warning {
        background: linear-gradient(135deg, #ff9500 0%, #ff6b35 100%);
        color: white;
      }
    }
  }
}
</style>
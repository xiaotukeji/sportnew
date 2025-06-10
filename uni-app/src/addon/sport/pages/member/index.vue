<template>
    <view class="sport-member-page">
        <!-- 顶部用户信息区域 -->
        <view class="user-info-section">
            <view class="bg-gradient-to-r from-blue-500 to-purple-600 p-8 text-white">
                <view class="flex items-center">
                    <!-- 用户头像 -->
                    <view class="avatar mr-4" @click="handleAvatarClick">
                        <image 
                            v-if="userInfo?.headimg" 
                            :src="img(userInfo.headimg)" 
                            class="w-16 h-16 rounded-full"
                            mode="aspectFill"
                        />
                        <view 
                            v-else 
                            class="w-16 h-16 rounded-full bg-white bg-opacity-20 flex items-center justify-center"
                        >
                            <text class="text-2xl">👤</text>
                        </view>
                    </view>
                    
                    <!-- 用户信息 -->
                    <view v-if="userInfo" class="flex-1">
                        <view class="text-lg font-bold mb-1">
                            {{ userInfo.nickname || '运动爱好者' }}
                        </view>
                        <view class="text-sm opacity-80">
                            ID: {{ userInfo.member_no }}
                        </view>
                        <view v-if="userInfo.mobile" class="text-sm opacity-80">
                            {{ userInfo.mobile.replace(userInfo.mobile.substring(3, 7), "****") }}
                        </view>
                        
                        <!-- #ifdef H5 -->
                        <view v-else-if="!userInfo.mobile" @click="bindMobileFn"
                              class="text-xs mt-1 px-2 py-1 border border-white border-opacity-30 rounded-full w-fit bg-white bg-opacity-20">
                            绑定手机号
                        </view>
                        <!-- #endif -->

                        <!-- #ifdef MP-WEIXIN -->
                        <button v-else-if="!userInfo.mobile"
                                class="text-xs mt-1 px-2 py-1 border border-white border-opacity-30 rounded-full bg-white bg-opacity-20"
                                open-type="getPhoneNumber" @getphonenumber="memberStore.bindMobile">
                            绑定手机号
                        </button>
                        <!-- #endif -->
                    </view>
                    
                    <!-- 未登录状态 -->
                    <view v-else class="flex-1" @click="toLogin">
                        <view class="text-lg font-bold mb-2">欢迎使用运动会助手</view>
                        <view class="bg-white bg-opacity-20 rounded-full px-4 py-2 w-fit">
                            <text class="text-sm">点击登录</text>
                        </view>
                    </view>
                </view>
            </view>
        </view>

        <!-- 功能菜单区域 -->
        <view class="menu-section mt-4">
            <!-- 我的赛事 -->
            <view class="menu-item" @click="goToMyEvents">
                <view class="menu-icon">🏆</view>
                <view class="menu-content">
                    <view class="menu-title">我的赛事</view>
                    <view class="menu-desc">查看参与的比赛记录</view>
                </view>
                <view class="menu-arrow">›</view>
            </view>

            <!-- 我的成绩 -->
            <view class="menu-item" @click="goToMyScores">
                <view class="menu-icon">📊</view>
                <view class="menu-content">
                    <view class="menu-title">我的成绩</view>
                    <view class="menu-desc">查看比赛成绩和排名</view>
                </view>
                <view class="menu-arrow">›</view>
            </view>

            <!-- 报名记录 -->
            <view class="menu-item" @click="goToMyRegistrations">
                <view class="menu-icon">📝</view>
                <view class="menu-content">
                    <view class="menu-title">报名记录</view>
                    <view class="menu-desc">查看报名历史</view>
                </view>
                <view class="menu-arrow">›</view>
            </view>

            <!-- 个人设置 -->
            <view class="menu-item" @click="goToSettings">
                <view class="menu-icon">⚙️</view>
                <view class="menu-content">
                    <view class="menu-title">个人设置</view>
                    <view class="menu-desc">修改个人信息和偏好</view>
                </view>
                <view class="menu-arrow">›</view>
            </view>
        </view>

        <!-- 退出登录按钮 -->
        <view v-if="userInfo" class="logout-section mt-8 px-4">
            <view class="logout-btn" @click="handleLogout">
                <text class="text-red-500 text-center">退出登录</text>
            </view>
        </view>

        <!-- 强制绑定手机号 -->
        <bind-mobile ref="bindMobileRef" />
        
        <!-- #ifdef MP-WEIXIN -->
        <!-- 信息填写组件 -->
        <information-filling ref="infoFillRef" />
        <!-- #endif -->
    </view>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import useMemberStore from '@/stores/member';
import { useLogin } from '@/hooks/useLogin';
import { useLoginCheck } from '@/addon/sport/hooks/useLoginCheck';
import useConfigStore from '@/stores/config';
import { img, isWeixinBrowser } from '@/utils/common';
import bindMobile from '@/components/bind-mobile/bind-mobile.vue';

// #ifdef MP-WEIXIN
import informationFilling from '@/components/information-filling/information-filling.vue'
// #endif

// 会员信息
const memberStore = useMemberStore();
const userInfo = computed(() => memberStore.info);

// 登录相关
const login = useLogin();
const { requireLogin } = useLoginCheck();
const configStore = useConfigStore();

// 处理完整的登录逻辑
const toLogin = () => {
    let normalLogin = !configStore.login.is_username && !configStore.login.is_mobile && !configStore.login.is_bind_mobile; // 未开启普通登录
    let authRegisterLogin = !configStore.login.is_auth_register; // 自动注册登录

    // #ifdef H5
    if (isWeixinBrowser()) {
        // 微信浏览器
        if (normalLogin && authRegisterLogin) {
            uni.showToast({ title: '商家未开启登录注册', icon: 'none' })
        } else if (configStore.login.is_username || configStore.login.is_mobile || configStore.login.is_bind_mobile) {
            login.setLoginBack({ url: '/addon/sport/pages/member/index' })
        } else if (normalLogin && configStore.login.is_auth_register && configStore.login.is_force_access_user_info) {
            // 判断是否开启第三方自动注册登录，并且开启强制获取用户信息
            login.getAuthCode({ scopes: 'snsapi_userinfo' })
        } else if (normalLogin && configStore.login.is_auth_register && !configStore.login.is_force_access_user_info) {
            // 判断是否开启第三方自动注册登录，并且关闭强制获取用户信息
            login.getAuthCode({ scopes: 'snsapi_base' })
        }
    } else {
        // 普通浏览器
        if (normalLogin) {
            uni.showToast({ title: '商家未开启登录注册', icon: 'none' })
        } else if (configStore.login.is_username || configStore.login.is_mobile || configStore.login.is_bind_mobile) {
            login.setLoginBack({ url: '/addon/sport/pages/member/index' })
        }
    }
    // #endif

    // #ifdef MP
    if (normalLogin && authRegisterLogin) {
        uni.showToast({ title: '商家未开启登录注册', icon: 'none' })
    } else if (configStore.login.is_username || configStore.login.is_mobile || configStore.login.is_bind_mobile) {
        login.setLoginBack({ url: '/addon/sport/pages/member/index' })
    } else if (normalLogin && configStore.login.is_auth_register && !configStore.login.is_force_access_user_info) {
        // 判断是否开启第三方自动注册登录
        login.getAuthCode()
    } else if (configStore.login.is_auth_register && configStore.login.is_force_access_user_info) {
        // 开启了第三方自动注册登录，但是需要强制获取昵称
        login.setLoginBack({ url: '/addon/sport/pages/member/index' })
    } else if (configStore.login.is_auth_register && configStore.login.is_bind_mobile) {
        // 开启了第三方自动注册登录，但是需要强制获取手机号
        login.setLoginBack({ url: '/addon/sport/pages/member/index' })
    }
    // #endif
};

// 统一处理头像点击事件
const infoFillRef: any = ref(null)
const handleAvatarClick = () => {
    if (userInfo.value) {
        // 已登录：弹出授权头像和昵称对话框
        clickAvatar()
    } else {
        // 未登录：跳转到登录页面
        toLogin()
    }
}

// 点击头像触发信息填写（已登录状态）
const clickAvatar = () => {
    // #ifdef MP-WEIXIN
    if (infoFillRef.value) {
        infoFillRef.value.show = true
    }
    // #endif

    // #ifdef H5
    if (isWeixinBrowser()) {
        login.getAuthCode({ scopes: 'snsapi_userinfo' })
    } else {
        uni.navigateTo({ url: '/app/pages/member/personal' })
    }
    // #endif

    // #ifdef APP-PLUS
    uni.navigateTo({ url: '/app/pages/member/personal' })
    // #endif
}

// 强制绑定手机号
const bindMobileRef: any = ref(null)
const bindMobileFn = () => {
    if (bindMobileRef.value) {
        bindMobileRef.value.open()
    }
}

// 处理退出登录
const handleLogout = () => {
    uni.showModal({
        title: '确认退出',
        content: '确定要退出登录吗？',
        success: (res) => {
            if (res.confirm) {
                memberStore.logout();
                // 重新获取会员信息
                setTimeout(() => {
                    memberStore.getMemberInfo();
                }, 100);
            }
        }
    });
};

// 跳转到我的赛事
const goToMyEvents = () => {
    requireLogin(() => {
        uni.navigateTo({
            url: '/addon/sport/pages/member/my-events'
        });
    }, '/addon/sport/pages/member/index');
};

// 跳转到我的成绩
const goToMyScores = () => {
    requireLogin(() => {
        // TODO: 跳转到我的成绩页面
        uni.showToast({
            title: '功能开发中',
            icon: 'none'
        });
    }, '/addon/sport/pages/member/index');
};

// 跳转到报名记录
const goToMyRegistrations = () => {
    requireLogin(() => {
        // TODO: 跳转到报名记录页面
        uni.showToast({
            title: '功能开发中',
            icon: 'none'
        });
    }, '/addon/sport/pages/member/index');
};

// 跳转到个人设置
const goToSettings = () => {
    requireLogin(() => {
        // TODO: 跳转到个人设置页面
        uni.showToast({
            title: '功能开发中',
            icon: 'none'
        });
    }, '/addon/sport/pages/member/index');
};

// 页面加载时获取会员信息
onMounted(() => {
    if (memberStore.token) {
        memberStore.getMemberInfo();
    }
});
</script>

<style lang="scss" scoped>
.sport-member-page {
    min-height: 100vh;
    background-color: #f5f5f5;
}

.user-info-section {
    .bg-gradient-to-r {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    }
    
    .avatar {
        .w-16 {
            width: 64px;
        }
        .h-16 {
            height: 64px;
        }
        .rounded-full {
            border-radius: 50%;
        }
    }
    
    .flex {
        display: flex;
    }
    
    .items-center {
        align-items: center;
    }
    
    .mr-4 {
        margin-right: 16px;
    }
    
    .flex-1 {
        flex: 1;
    }
    
    .text-lg {
        font-size: 18px;
    }
    
    .font-bold {
        font-weight: bold;
    }
    
    .mb-1 {
        margin-bottom: 4px;
    }
    
    .mb-2 {
        margin-bottom: 8px;
    }
    
    .text-sm {
        font-size: 14px;
    }
    
    .text-xs {
        font-size: 12px;
    }
    
    .opacity-80 {
        opacity: 0.8;
    }
    
    .bg-white {
        background-color: white;
    }
    
    .bg-opacity-20 {
        background-color: rgba(255, 255, 255, 0.2);
    }
    
    .border-opacity-30 {
        border-color: rgba(255, 255, 255, 0.3);
    }
    
    .rounded-full {
        border-radius: 50px;
    }
    
    .px-2 {
        padding-left: 8px;
        padding-right: 8px;
    }
    
    .py-1 {
        padding-top: 4px;
        padding-bottom: 4px;
    }
    
    .px-4 {
        padding-left: 16px;
        padding-right: 16px;
    }
    
    .py-2 {
        padding-top: 8px;
        padding-bottom: 8px;
    }
    
    .w-fit {
        width: fit-content;
    }
    
    .text-2xl {
        font-size: 24px;
    }
    
    .p-8 {
        padding: 32px;
    }
    
    .text-white {
        color: white;
    }
    
    .mt-1 {
        margin-top: 4px;
    }
    
    .border {
        border-width: 1px;
        border-style: solid;
    }
    
    .border-white {
        border-color: white;
    }
}

.menu-section {
    background-color: white;
    margin: 16px;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.menu-item {
    display: flex;
    align-items: center;
    padding: 16px;
    border-bottom: 1px solid #f0f0f0;
    
    &:last-child {
        border-bottom: none;
    }
    
    &:active {
        background-color: #f8f8f8;
    }
}

.menu-icon {
    font-size: 24px;
    width: 40px;
    text-align: center;
    margin-right: 16px;
}

.menu-content {
    flex: 1;
}

.menu-title {
    font-size: 16px;
    font-weight: 500;
    color: #333;
    margin-bottom: 4px;
}

.menu-desc {
    font-size: 12px;
    color: #999;
}

.menu-arrow {
    font-size: 18px;
    color: #ccc;
    margin-left: 8px;
}

.logout-section {
    .logout-btn {
        background-color: white;
        border-radius: 12px;
        padding: 16px;
        text-align: center;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        
        &:active {
            background-color: #f8f8f8;
        }
    }
}

.mt-4 {
    margin-top: 16px;
}

.mt-8 {
    margin-top: 32px;
}

.text-red-500 {
    color: #ef4444;
}

.text-center {
    text-align: center;
}
</style>

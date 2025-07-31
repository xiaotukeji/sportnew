import { computed } from 'vue'
import useMemberStore from '@/stores/member'
import { useLogin } from '@/hooks/useLogin'

/**
 * 通用登录检查 Hook
 * 为 Sport 插件提供统一的登录验证逻辑
 */
export function useLoginCheck() {
    const memberStore = useMemberStore()
    const login = useLogin()
    
    // 当前用户信息
    const userInfo = computed(() => memberStore.info)
    
    // 是否已登录
    const isLoggedIn = computed(() => !!userInfo.value)
    
    /**
     * 检查登录状态
     * @param returnUrl - 登录成功后返回的页面URL
     * @param showModal - 是否显示登录提示弹窗
     * @returns 是否已登录
     */
    const checkLogin = (returnUrl?: string, showModal: boolean = true) => {
        if (!userInfo.value) {
            if (showModal) {
                uni.showModal({
                    title: '需要登录',
                    content: '请先登录后再进行此操作',
                    confirmText: '去登录',
                    cancelText: '取消',
                    success: (res) => {
                        if (res.confirm) {
                            login.setLoginBack({ 
                                url: returnUrl || '/addon/sport/pages/member/index' 
                            })
                        }
                    }
                })
            } else {
                // 直接跳转登录
                login.setLoginBack({ 
                    url: returnUrl || '/addon/sport/pages/member/index' 
                })
            }
            return false
        }
        return true
    }
    
    /**
     * 需要登录的操作包装器
     * @param action - 需要执行的操作
     * @param returnUrl - 登录成功后返回的页面URL
     * @param showModal - 是否显示登录提示弹窗
     */
    const requireLogin = (action: () => void, returnUrl?: string, showModal: boolean = true) => {
        if (checkLogin(returnUrl, showModal)) {
            action()
        }
    }
    
    /**
     * 跳转到登录页面
     * @param returnUrl - 登录成功后返回的页面URL
     */
    const goLogin = (returnUrl?: string) => {
        login.setLoginBack({ 
            url: returnUrl || '/addon/sport/pages/member/index' 
        })
    }
    
    return {
        userInfo,
        isLoggedIn,
        checkLogin,
        requireLogin,
        goLogin
    }
} 
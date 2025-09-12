/**
 * DIY配置相关API接口
 */

import request from '@/utils/request'

/**
 * DIY配置接口
 */
export const diyConfigApi = {
  /**
   * 获取赛事的DIY配置
   * @param eventId 赛事ID
   */
  getEventDiyConfig(eventId: number) {
    return request.get('sport/diy-config', { event_id: eventId })
  },

  /**
   * 保存赛事的DIY配置
   * @param data 配置数据
   */
  saveEventDiyConfig(data: { event_id: number; config_data: any }) {
    return request.post('sport/diy-config', data)
  },

  /**
   * 更新赛事的DIY配置
   * @param data 配置数据
   */
  updateEventDiyConfig(data: { event_id: number; config_data: any }) {
    return request.put('sport/diy-config', data)
  },

  /**
   * 删除赛事的DIY配置
   * @param eventId 赛事ID
   */
  deleteEventDiyConfig(eventId: number) {
    return request.delete('sport/diy-config', { event_id: eventId })
  },

  /**
   * 重置为默认配置
   * @param eventId 赛事ID
   */
  resetToDefaultConfig(eventId: number) {
    return request.post('sport/diy-config/reset', { event_id: eventId })
  },

  /**
   * 获取可用的模块配置
   */
  getAvailableModules() {
    return request.get('sport/diy-config/modules')
  }
}

/**
 * Banner管理接口
 */
export const bannerApi = {
  /**
   * 获取赛事的Banner列表
   * @param eventId 赛事ID
   */
  getEventBanners(eventId: number) {
    return request.get('sport/banner/list', { event_id: eventId })
  },

  /**
   * 上传Banner图片
   * @param data 上传数据
   */
  uploadBanner(data: {
    event_id: number
    image: File
    image_title?: string
    image_link?: string
  }) {
    return request.upload('sport/banner/upload', data)
  },

  /**
   * 更新Banner信息
   * @param data 更新数据
   */
  updateBanner(data: {
    banner_id: number
    image_title?: string
    image_link?: string
    status?: number
  }) {
    return request.put('sport/banner/update', data)
  },

  /**
   * 删除Banner图片
   * @param bannerId Banner ID
   */
  deleteBanner(bannerId: number) {
    return request.delete('sport/banner/delete', { banner_id: bannerId })
  },

  /**
   * 更新Banner排序
   * @param data 排序数据
   */
  updateBannerSort(data: {
    event_id: number
    sort_data: Array<{ id: number; sort: number }>
  }) {
    return request.put('sport/banner/sort', data)
  },

  /**
   * 批量删除赛事的Banner
   * @param eventId 赛事ID
   */
  deleteEventBanners(eventId: number) {
    return request.delete('sport/banner/delete-event', { event_id: eventId })
  }
}

/**
 * 内容管理接口
 */
export const contentApi = {
  /**
   * 获取赛事的详情内容
   * @param eventId 赛事ID
   */
  getEventDetailContent(eventId: number) {
    return request.get('sport/content', { event_id: eventId })
  },

  /**
   * 保存赛事的详情内容
   * @param data 内容数据
   */
  saveEventDetailContent(data: {
    event_id: number
    content_type: string
    content_data: string
    content_images?: any[]
  }) {
    return request.post('sport/content', data)
  },

  /**
   * 更新详情内容
   * @param data 更新数据
   */
  updateDetailContent(data: {
    content_id: number
    content_type?: string
    content_data?: string
    content_images?: any[]
    status?: number
  }) {
    return request.put('sport/content', data)
  },

  /**
   * 删除赛事的详情内容
   * @param eventId 赛事ID
   */
  deleteEventDetailContent(eventId: number) {
    return request.delete('sport/content', { event_id: eventId })
  },

  /**
   * 上传内容图片
   * @param data 上传数据
   */
  uploadContentImage(data: {
    event_id: number
    image: File
    image_title?: string
  }) {
    return request.upload('sport/content/upload-image', data)
  },

  /**
   * 删除内容图片
   * @param data 删除数据
   */
  removeContentImage(data: {
    event_id: number
    image_url: string
  }) {
    return request.delete('sport/content/remove-image', data)
  }
}

/**
 * DIY配置数据类型定义
 */
export interface DIYModule {
  key: string
  name: string
  icon: string
  description: string
  enabled: boolean
  order: number
  properties: any
}

export interface DIYConfig {
  modules: {
    banner: {
      enabled: boolean
      order: number
      properties: {
        images: string[]
        height: number
        autoplay: boolean
        indicator: boolean
        interval: number
      }
    }
    basicInfo: {
      enabled: boolean
      order: number
      properties: {
        showEventName: boolean
        showTimeLocation: boolean
        showOrganizer: boolean
        showCoOrganizer: boolean
        showSeries: boolean
        showCategory: boolean
        showAgeGroups: boolean
        showCustomGroups: boolean
        showContactInfo: boolean
        layout: 'vertical' | 'horizontal'
        cardStyle: 'default' | 'minimal' | 'highlight'
      }
    }
    projects: {
      enabled: boolean
      order: number
      properties: {
        showProjectDetails: boolean
        showRegistrationFee: boolean
        showParticipantCount: boolean
        showAgeGroup: boolean
        showGenderLimit: boolean
        showVenue: boolean
        layout: 'list' | 'grid' | 'card'
        maxDisplay: number
      }
    }
    detailContent: {
      enabled: boolean
      order: number
      properties: {
        content: string
        showRichText: boolean
        showImages: boolean
        maxHeight: number
        showExpand: boolean
      }
    }
    signupAction: {
      enabled: boolean
      order: number
      properties: {
        showRegistrationStatus: boolean
        showRegistrationTime: boolean
        showParticipantCount: boolean
        buttonText: string
        buttonStyle: 'primary' | 'secondary' | 'success' | 'warning'
        buttonSize: 'small' | 'medium' | 'large'
        showProgress: boolean
      }
    }
  }
  global: {
    theme: 'light' | 'dark' | 'auto'
    primaryColor: string
    backgroundColor: string
    borderRadius: number
    spacing: number
  }
}

export interface BannerItem {
  id: number
  event_id: number
  image_url: string
  image_title: string
  image_link: string
  sort: number
  status: number
  create_time: number
  update_time: number
}

export interface ContentItem {
  id: number
  event_id: number
  content_type: string
  content_data: string
  content_images: any[]
  status: number
  create_time: number
  update_time: number
}

import request from '@/utils/request'

/**
 * 协办单位类型枚举
 */
export const CO_ORGANIZER_TYPES = {
    CO_ORGANIZER: 1,    // 协办单位
    SPONSOR: 2,         // 赞助商
    SUPPORT: 3          // 支持单位
} as const

/**
 * 协办单位类型文本映射
 */
export const CO_ORGANIZER_TYPE_TEXTS = {
    [CO_ORGANIZER_TYPES.CO_ORGANIZER]: '协办单位',
    [CO_ORGANIZER_TYPES.SPONSOR]: '赞助商',
    [CO_ORGANIZER_TYPES.SUPPORT]: '支持单位',
    11: '赞助商',  // 兼容旧数据
    12: '赞助商',  // 兼容旧数据
    13: '赞助商',  // 兼容旧数据
} as const

/**
 * 协办单位接口类型定义
 */
export interface CoOrganizerItem {
    id?: number
    event_id: number
    organizer_id?: number
    organizer_type: number
    organizer_name: string
    logo?: string
    contact_name?: string
    contact_phone?: string
    sort?: number
    status?: number
    remark?: string
    create_time?: number
    update_time?: number
    organizer_type_text?: string
    status_text?: string
}

/**
 * 获取赛事协办单位列表
 * @param event_id 赛事ID
 * @param params 查询参数
 * @returns
 */
export function getCoOrganizerList(event_id: number, params: Record<string, any> = {}) {
    return request.get(`sport/event/${event_id}/co-organizers`, params)
}

/**
 * 添加协办单位
 * @param params 协办单位数据
 * @returns
 */
export function addCoOrganizer(params: CoOrganizerItem) {
    return request.post('sport/co-organizer', params, { 
        showErrorMessage: true, 
        showSuccessMessage: true 
    })
}

/**
 * 获取协办单位详情
 * @param id 协办单位ID
 * @returns
 */
export function getCoOrganizerInfo(id: number) {
    return request.get(`sport/co-organizer/${id}`)
}

/**
 * 编辑协办单位
 * @param id 协办单位ID
 * @param params 协办单位数据
 * @returns
 */
export function editCoOrganizer(id: number, params: Partial<CoOrganizerItem>) {
    return request.put(`sport/co-organizer/${id}`, params, { 
        showErrorMessage: true, 
        showSuccessMessage: true 
    })
}

/**
 * 删除协办单位
 * @param id 协办单位ID
 * @returns
 */
export function deleteCoOrganizer(id: number) {
    return request.delete(`sport/co-organizer/${id}`, {}, { 
        showErrorMessage: true, 
        showSuccessMessage: true 
    })
}

/**
 * 批量添加协办单位
 * @param event_id 赛事ID
 * @param co_organizers 协办单位列表
 * @returns
 */
export function batchAddCoOrganizers(event_id: number, co_organizers: Partial<CoOrganizerItem>[]) {
    return request.post('sport/co-organizer/batch', {
        event_id,
        co_organizers
    }, { 
        showErrorMessage: true, 
        showSuccessMessage: true 
    })
}

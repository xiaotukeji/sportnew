import request from '@/utils/request'

/**
 * 协办单位API接口
 */

// 协办单位数据类型定义
export interface CoOrganizerData {
    id?: number
    event_id: number
    organizer_type: number // 1协办单位 2赞助商 3支持单位
    organizer_name: string
    logo?: string
    contact_name?: string
    contact_phone?: string
    remark?: string
    sort?: number
    status?: number
}

// 获取赛事协办单位列表
export const getCoOrganizerList = (eventId: number) => {
    return request.get(`sport/event/${eventId}/co-organizers`)
}

// 添加协办单位
export const addCoOrganizer = (data: CoOrganizerData) => {
    return request.post('sport/co-organizer', data)
}

// 更新协办单位
export const updateCoOrganizer = (id: number, data: Partial<CoOrganizerData>) => {
    return request.put(`sport/co-organizer/${id}`, data)
}

// 删除协办单位
export const deleteCoOrganizer = (id: number) => {
    return request.delete(`sport/co-organizer/${id}`)
}

// 批量删除协办单位
export const batchDeleteCoOrganizers = (ids: number[]) => {
    return request.delete('sport/co-organizer/batch', { ids })
}

// 获取协办单位详情
export const getCoOrganizerInfo = (id: number) => {
    return request.get(`sport/co-organizer/${id}`)
}

// 更新协办单位排序
export const updateCoOrganizerSort = (sortData: Array<{id: number, sort: number}>) => {
    return request.put('sport/co-organizer/sort', { sort_data: sortData })
}

// 单位类型标签映射
export const getOrganizerTypeLabel = (type: number): string => {
    const typeMap: Record<number, string> = {
        1: '协办单位',
        2: '赞助商',
        3: '支持单位'
    }
    return typeMap[type] || '未知类型'
}

// 单位类型选项
export const organizerTypeOptions = [
    { value: 1, label: '协办单位' },
    { value: 2, label: '赞助商' },
    { value: 3, label: '支持单位' }
]

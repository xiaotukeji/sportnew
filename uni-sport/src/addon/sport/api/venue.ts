import request from '@/utils/request'

/**
 * 获取赛事场地列表
 * @param eventId 赛事ID
 * @param params 查询参数
 */
export function getEventVenues(eventId: number, params: any = {}) {
    return request.get(`sport/event/${eventId}/venues`, params)
}

/**
 * 添加赛事场地
 * @param eventId 赛事ID
 * @param data 场地数据
 */
export function addEventVenue(eventId: number, data: any) {
    return request.post(`sport/event/${eventId}/venues`, data)
}

/**
 * 编辑赛事场地
 * @param eventId 赛事ID
 * @param venueId 场地ID
 * @param data 场地数据
 */
export function editEventVenue(eventId: number, venueId: number, data: any) {
    return request.put(`sport/event/${eventId}/venues/${venueId}`, data)
}

/**
 * 删除赛事场地
 * @param eventId 赛事ID
 * @param venueId 场地ID
 */
export function deleteEventVenue(eventId: number, venueId: number) {
    return request.delete(`sport/event/${eventId}/venues/${venueId}`)
}

/**
 * 批量添加场地
 * @param eventId 赛事ID
 * @param data 批量添加数据
 */
export function batchAddVenues(eventId: number, data: any) {
    return request.post(`sport/event/${eventId}/venues/batch`, data)
}

/**
 * 获取项目已分配的场地
 * @param itemId 项目ID
 */
export function getItemVenues(itemId: number) {
    return request.get(`sport/item/${itemId}/venues`)
}

/**
 * 为项目分配场地
 * @param itemId 项目ID
 * @param data 分配数据
 */
export function assignVenueToItem(itemId: number, data: any) {
    return request.post(`sport/item/${itemId}/venues/assign`, data)
}

/**
 * 移除项目场地分配
 * @param itemId 项目ID
 * @param venueId 场地ID
 */
export function removeVenueFromItem(itemId: number, venueId: number) {
    return request.delete(`sport/item/${itemId}/venues/${venueId}`)
}

/**
 * 批量分配场地给项目
 * @param itemId 项目ID
 * @param data 批量分配数据
 */
export function batchAssignVenuesToItem(itemId: number, data: any) {
    return request.post(`sport/item/${itemId}/venues/batch-assign`, data)
}

/**
 * 获取可用场地列表（用于项目选择）
 * @param itemId 项目ID
 * @param params 查询参数
 */
export function getAvailableVenuesForItem(itemId: number, params: any = {}) {
    return request.get(`sport/item/${itemId}/venues/available`, params)
} 
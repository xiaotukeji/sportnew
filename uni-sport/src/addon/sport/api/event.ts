import request from '@/utils/request'

/**
 * 获取赛事列表
 * @param params
 * @returns
 */
export function getEventPageList(params: Record<string, any>) {
    return request.get(`sport/event`, { params })
}

/**
 * 获取我的赛事列表
 * @param params
 * @returns
 */
export function getEventList(params: Record<string, any>) {
    return request.get(`sport/event/my-list`, params)
}

/**
 * 获取赛事详情
 * @param event_id 赛事ID
 * @returns
 */
export function getEventInfo(event_id: number) {
    return request.get(`sport/event/${event_id}`);
}

/**
 * 获取赛事详情页完整信息（包含协办方和号码牌设置）
 * @param event_id 赛事ID
 * @returns
 */
export function getEventDetailInfo(event_id: number) {
    return request.get(`sport/event/${event_id}/detail`);
}

/**
 * 添加赛事
 * @param params
 * @returns
 */
export function addEvent(params: Record<string, any>) {
    return request.post('sport/event', params, { showErrorMessage: true, showSuccessMessage: false })
}

/**
 * 编辑赛事
 * @param event_id 赛事ID
 * @param params
 * @returns
 */
export function editEvent(event_id: number, params: Record<string, any>) {
    return request.put(`sport/event/${event_id}`, params, { showErrorMessage: true, showSuccessMessage: false })
}

/**
 * 删除赛事
 * @param event_id 赛事ID
 * @returns
 */
export function deleteEvent(event_id: number) {
    return request.delete(`sport/event/${event_id}`, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 更新赛事状态
 * @param event_id 赛事ID
 * @param status 状态：0待发布 1进行中 2已结束 3已作废
 * @returns
 */
export function updateEventStatus(event_id: number, status: number) {
    return request.put(`sport/event/${event_id}/status`, { status }, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 获取赛事创建初始化数据
 * @returns
 */
export function getEventCreateInit() {
    return request.get(`sport/event/init`);
}

/**
 * 获取用户主办方列表
 * @param organizer_type 主办方类型：1个人 2单位
 * @returns
 */
export function getOrganizerList(organizer_type?: number) {
    return request.get(`sport/organizer/list`, { 
        params: organizer_type ? { organizer_type } : {} 
    });
}

/**
 * 添加主办方
 * @param params
 * @returns
 */
export function addOrganizer(params: Record<string, any>) {
    return request.post('sport/organizer', params, { showErrorMessage: true, showSuccessMessage: false })
}

/**
 * 获取用户系列赛列表
 * @returns
 */
export function getEventSeriesList() {
    return request.get(`sport/event-series/list`);
}

/**
 * 添加系列赛
 * @param params
 * @returns
 */
export function addEventSeries(params: Record<string, any>) {
    return request.post('sport/event-series', params, { showErrorMessage: true, showSuccessMessage: false })
}

/**
 * 获取赛事状态字典
 * @returns
 */
export function getEventStatusDict() {
    return request.get(`sport/dict/event-status`);
}

/**
 * 获取项目大类列表
 * @returns
 */
export function getCategoryList() {
    return request.get(`sport/category/list`);
}

/**
 * 获取运动分类列表（包含基础项目）
 * @param params
 * @returns
 */
export function getEventCategories(params: { event_id?: number } = {}) {
    return request.get('sport/event/categories', params);
}

/**
 * 获取基础项目列表
 * @param params
 * @returns
 */
export function getBaseItems(params: { category_id?: number; keyword?: string } = {}) {
    return request.get('sport/event/base-items', params);
}

/**
 * 保存赛事项目选择
 * @param data
 * @returns
 */
export function saveEventItems(data: { event_id: number; base_item_ids: number[] }) {
    return request.post('sport/event/items/save', data, { showErrorMessage: true, showSuccessMessage: false });
}

/**
 * 获取赛事已选择的项目
 * @param eventId
 * @returns
 */
export function getEventItems(eventId: number) {
    return request.get(`sport/event/${eventId}/items`);
} 

/**
 * 更新赛事设置
 * @param params
 * @returns
 */
export function updateEventSettings(params: Record<string, any>) {
    return request.put(`sport/event/${params.event_id}/settings`, params, { showErrorMessage: true, showSuccessMessage: false });
}

/**
 * 更新项目设置
 * @param params
 * @returns
 */
export function updateItemSettings(params: Record<string, any>) {
    return request.put(`sport/item/${params.item_id}/settings`, params, { showErrorMessage: true, showSuccessMessage: false });
} 
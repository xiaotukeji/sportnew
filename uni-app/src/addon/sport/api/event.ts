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
 * 获取赛事详情
 * @param event_id 赛事ID
 * @returns
 */
export function getEventInfo(event_id: number) {
    return request.get(`sport/event/${event_id}`);
}

/**
 * 添加赛事
 * @param params
 * @returns
 */
export function addEvent(params: Record<string, any>) {
    return request.post('sport/event', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑赛事
 * @param event_id 赛事ID
 * @param params
 * @returns
 */
export function editEvent(event_id: number, params: Record<string, any>) {
    return request.put(`sport/event/${event_id}`, params, { showErrorMessage: true, showSuccessMessage: true })
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
    return request.post('sport/organizer', params, { showErrorMessage: true, showSuccessMessage: true })
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
    return request.post('sport/event-series', params, { showErrorMessage: true, showSuccessMessage: true })
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
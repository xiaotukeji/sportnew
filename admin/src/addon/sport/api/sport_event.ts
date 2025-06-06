import request from '@/utils/request'

// USER_CODE_BEGIN -- sport_event
/**
 * 获取赛事列表
 * @param params
 * @returns
 */
export function getSportEventList(params: Record<string, any>) {
    return request.get(`sport/sport_event`, {params})
}

/**
 * 获取赛事详情
 * @param id 赛事id
 * @returns
 */
export function getSportEventInfo(id: number) {
    return request.get(`sport/sport_event/${id}`);
}

/**
 * 添加赛事
 * @param params
 * @returns
 */
export function addSportEvent(params: Record<string, any>) {
    return request.post('sport/sport_event', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑赛事
 * @param id
 * @param params
 * @returns
 */
export function editSportEvent(params: Record<string, any>) {
    return request.put(`sport/sport_event/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除赛事
 * @param id
 * @returns
 */
export function deleteSportEvent(id: number) {
    return request.delete(`sport/sport_event/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- sport_event

import request from '@/utils/request'

// USER_CODE_BEGIN -- sport_event_series
/**
 * 获取赛事系列列表
 * @param params
 * @returns
 */
export function getSportEventSeriesList(params: Record<string, any>) {
    return request.get(`sport/sport_event_series`, {params})
}

/**
 * 获取赛事系列详情
 * @param id 赛事系列id
 * @returns
 */
export function getSportEventSeriesInfo(id: number) {
    return request.get(`sport/sport_event_series/${id}`);
}

/**
 * 添加赛事系列
 * @param params
 * @returns
 */
export function addSportEventSeries(params: Record<string, any>) {
    return request.post('sport/sport_event_series', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑赛事系列
 * @param id
 * @param params
 * @returns
 */
export function editSportEventSeries(params: Record<string, any>) {
    return request.put(`sport/sport_event_series/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除赛事系列
 * @param id
 * @returns
 */
export function deleteSportEventSeries(id: number) {
    return request.delete(`sport/sport_event_series/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- sport_event_series

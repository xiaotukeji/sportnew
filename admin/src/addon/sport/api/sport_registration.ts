import request from '@/utils/request'

// USER_CODE_BEGIN -- sport_registration
/**
 * 获取报名记录列表
 * @param params
 * @returns
 */
export function getSportRegistrationList(params: Record<string, any>) {
    return request.get(`sport/sport_registration`, {params})
}

/**
 * 获取报名记录详情
 * @param id 报名记录id
 * @returns
 */
export function getSportRegistrationInfo(id: number) {
    return request.get(`sport/sport_registration/${id}`);
}

/**
 * 添加报名记录
 * @param params
 * @returns
 */
export function addSportRegistration(params: Record<string, any>) {
    return request.post('sport/sport_registration', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑报名记录
 * @param id
 * @param params
 * @returns
 */
export function editSportRegistration(params: Record<string, any>) {
    return request.put(`sport/sport_registration/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除报名记录
 * @param id
 * @returns
 */
export function deleteSportRegistration(id: number) {
    return request.delete(`sport/sport_registration/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- sport_registration

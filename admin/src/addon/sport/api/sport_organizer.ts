import request from '@/utils/request'

// USER_CODE_BEGIN -- sport_organizer
/**
 * 获取主办方列表
 * @param params
 * @returns
 */
export function getSportOrganizerList(params: Record<string, any>) {
    return request.get(`sport/sport_organizer`, {params})
}

/**
 * 获取主办方详情
 * @param id 主办方id
 * @returns
 */
export function getSportOrganizerInfo(id: number) {
    return request.get(`sport/sport_organizer/${id}`);
}

/**
 * 添加主办方
 * @param params
 * @returns
 */
export function addSportOrganizer(params: Record<string, any>) {
    return request.post('sport/sport_organizer', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑主办方
 * @param id
 * @param params
 * @returns
 */
export function editSportOrganizer(params: Record<string, any>) {
    return request.put(`sport/sport_organizer/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除主办方
 * @param id
 * @returns
 */
export function deleteSportOrganizer(id: number) {
    return request.delete(`sport/sport_organizer/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- sport_organizer

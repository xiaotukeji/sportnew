import request from '@/utils/request'

// USER_CODE_BEGIN -- sport_athlete
/**
 * 获取参赛人员列表
 * @param params
 * @returns
 */
export function getSportAthleteList(params: Record<string, any>) {
    return request.get(`sport/sport_athlete`, {params})
}

/**
 * 获取参赛人员详情
 * @param id 参赛人员id
 * @returns
 */
export function getSportAthleteInfo(id: number) {
    return request.get(`sport/sport_athlete/${id}`);
}

/**
 * 添加参赛人员
 * @param params
 * @returns
 */
export function addSportAthlete(params: Record<string, any>) {
    return request.post('sport/sport_athlete', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑参赛人员
 * @param id
 * @param params
 * @returns
 */
export function editSportAthlete(params: Record<string, any>) {
    return request.put(`sport/sport_athlete/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除参赛人员
 * @param id
 * @returns
 */
export function deleteSportAthlete(id: number) {
    return request.delete(`sport/sport_athlete/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- sport_athlete

import request from '@/utils/request'

// USER_CODE_BEGIN -- sport_score
/**
 * 获取比赛成绩列表
 * @param params
 * @returns
 */
export function getSportScoreList(params: Record<string, any>) {
    return request.get(`sport/sport_score`, {params})
}

/**
 * 获取比赛成绩详情
 * @param id 比赛成绩id
 * @returns
 */
export function getSportScoreInfo(id: number) {
    return request.get(`sport/sport_score/${id}`);
}

/**
 * 添加比赛成绩
 * @param params
 * @returns
 */
export function addSportScore(params: Record<string, any>) {
    return request.post('sport/sport_score', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑比赛成绩
 * @param id
 * @param params
 * @returns
 */
export function editSportScore(params: Record<string, any>) {
    return request.put(`sport/sport_score/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除比赛成绩
 * @param id
 * @returns
 */
export function deleteSportScore(id: number) {
    return request.delete(`sport/sport_score/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- sport_score

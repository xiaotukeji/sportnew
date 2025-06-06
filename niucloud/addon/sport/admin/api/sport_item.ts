import request from '@/utils/request'

// USER_CODE_BEGIN -- sport_item
/**
 * 获取比赛项目列表
 * @param params
 * @returns
 */
export function getSportItemList(params: Record<string, any>) {
    return request.get(`sport/sport_item`, {params})
}

/**
 * 获取比赛项目详情
 * @param id 比赛项目id
 * @returns
 */
export function getSportItemInfo(id: number) {
    return request.get(`sport/sport_item/${id}`);
}

/**
 * 添加比赛项目
 * @param params
 * @returns
 */
export function addSportItem(params: Record<string, any>) {
    return request.post('sport/sport_item', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑比赛项目
 * @param id
 * @param params
 * @returns
 */
export function editSportItem(params: Record<string, any>) {
    return request.put(`sport/sport_item/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除比赛项目
 * @param id
 * @returns
 */
export function deleteSportItem(id: number) {
    return request.delete(`sport/sport_item/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- sport_item

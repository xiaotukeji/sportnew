import request from '@/utils/request'

// USER_CODE_BEGIN -- sport_base_item
/**
 * 获取基础项目列表
 * @param params
 * @returns
 */
export function getSportBaseItemList(params: Record<string, any>) {
    return request.get(`sport/sport_base_item`, {params})
}

/**
 * 获取基础项目详情
 * @param id 基础项目id
 * @returns
 */
export function getSportBaseItemInfo(id: number) {
    return request.get(`sport/sport_base_item/${id}`);
}

/**
 * 添加基础项目
 * @param params
 * @returns
 */
export function addSportBaseItem(params: Record<string, any>) {
    return request.post('sport/sport_base_item', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑基础项目
 * @param id
 * @param params
 * @returns
 */
export function editSportBaseItem(params: Record<string, any>) {
    return request.put(`sport/sport_base_item/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除基础项目
 * @param id
 * @returns
 */
export function deleteSportBaseItem(id: number) {
    return request.delete(`sport/sport_base_item/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- sport_base_item

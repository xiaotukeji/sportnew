import request from '@/utils/request'

// USER_CODE_BEGIN -- sport_category
/**
 * 获取项目大类列表
 * @param params
 * @returns
 */
export function getSportCategoryList(params: Record<string, any>) {
    return request.get(`sport/sport_category`, {params})
}

/**
 * 获取项目大类详情
 * @param id 项目大类id
 * @returns
 */
export function getSportCategoryInfo(id: number) {
    return request.get(`sport/sport_category/${id}`);
}

/**
 * 添加项目大类
 * @param params
 * @returns
 */
export function addSportCategory(params: Record<string, any>) {
    return request.post('sport/sport_category', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑项目大类
 * @param id
 * @param params
 * @returns
 */
export function editSportCategory(params: Record<string, any>) {
    return request.put(`sport/sport_category/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除项目大类
 * @param id
 * @returns
 */
export function deleteSportCategory(id: number) {
    return request.delete(`sport/sport_category/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- sport_category

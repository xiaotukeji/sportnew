import request from '@/utils/request'

// USER_CODE_BEGIN -- sport_nav_config
/**
 * 获取导航配置列表
 * @param params
 * @returns
 */
export function getSportNavConfigList(params: Record<string, any>) {
    return request.get(`sport/sport_nav_config`, {params})
}

/**
 * 获取导航配置详情
 * @param id 导航配置id
 * @returns
 */
export function getSportNavConfigInfo(id: number) {
    return request.get(`sport/sport_nav_config/${id}`);
}

/**
 * 添加导航配置
 * @param params
 * @returns
 */
export function addSportNavConfig(params: Record<string, any>) {
    return request.post('sport/sport_nav_config', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑导航配置
 * @param id
 * @param params
 * @returns
 */
export function editSportNavConfig(params: Record<string, any>) {
    return request.put(`sport/sport_nav_config/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除导航配置
 * @param id
 * @returns
 */
export function deleteSportNavConfig(id: number) {
    return request.delete(`sport/sport_nav_config/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- sport_nav_config

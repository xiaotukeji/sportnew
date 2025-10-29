import request from '@/utils/request'

/**
 * 一体化创建赛事
 * @param data 赛事数据
 */
export function addEventQoder(data: any) {
  return request.post('sport/event_qoder/create_all_in_one', data, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 获取创建赛事所需初始化数据
 */
export function getEventQoderInit() {
  return request.get('sport/event_qoder/init')
}
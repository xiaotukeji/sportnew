import request from '@/utils/request'

/**
 * 根据经纬度获取地址信息
 * @param latlng 经纬度字符串，格式：纬度,经度
 */
export function getAddressByLatlng(latlng: string) {
    return request.get('/system/address/latlng', { params: { latlng } })
}

/**
 * 地址搜索
 * @param keyword 搜索关键词
 */
export function searchAddress(keyword: string) {
    return request.get('/system/address/search', { params: { keyword } })
} 
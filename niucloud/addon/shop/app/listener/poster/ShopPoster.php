<?php
declare ( strict_types = 1 );

namespace addon\shop\app\listener\poster;


use addon\shop\app\model\goods\Goods;
use addon\shop\app\model\goods\GoodsSku;
use addon\shop\app\model\goods\Service;
use addon\shop\app\model\exchange\Exchange;
use app\model\member\Member;
use app\service\core\sys\CoreSysConfigService;

/**
 * 商品海报数据
 */
class ShopPoster
{
    /**
     * 商品海报
     * @param $data
     * @return array
     */
    public function handle($data)
    {
        $type = $data[ 'type' ];
        if ($type == 'shop_goods') {
            // 商品 海报模板数据

            $param = $data[ 'param' ];
            $sku_id = $param[ 'sku_id' ] ?? 0;
            $member_id = $param[ 'member_id' ] ?? 0;
            $mode = $param[ 'mode' ] ?? '';

            if ($mode == 'preview') {
                // 预览模式
                $url_data = [
                    [ 'key' => 'sku_id', 'value' => $sku_id ]
                ];
                $return_data = [
                    'nickname' => '会员昵称',
                    'headimg' => 'static/resource/images/default_headimg.png',
                    'goods_name' => '商品名称',
                    'goods_price' => '￥369.00',
                    'goods_market_price' => '￥3690.00',
                    'goods_img' => 'addon/shop/goods_template.png',
                    'url' => [
                        'url' => ( new CoreSysConfigService() )->getSceneDomain()[ 'wap_url' ],
                        'page' => 'addon/shop/pages/goods/detail',
                        'data' => $url_data,
                    ],
                ];
                return $return_data;
            }

            // 查询sku信息
            $sku = ( new GoodsSku() )->where([ [ 'sku_id', '=', $sku_id ] ])->findOrEmpty();

            if ($sku->isEmpty()) return [];

            $goods_id = $sku[ 'goods_id' ];
            $goods = ( new Goods() )->where([ [ 'goods_id', '=', $goods_id ] ])->findOrEmpty();
            if ($goods->isEmpty()) return [];

            $goods_name = $goods[ 'goods_name' ] . $sku[ 'sku_name' ];
//            if (mb_strlen($goods_name, 'UTF-8') > 14) {
//                $goods_name = mb_substr($goods_name, 0, 14, 'UTF-8') . '...';
//            }

//            $service_ids = $goods['service_ids'];
//            if(!empty($service_ids)){
//                // 商品服务
//                $goods_service_model = new Service();
//                $services = $goods_service_model->where([
//                    [ 'service_id', 'in', $service_ids ]
//                ])->column('service_name');
//                $services = implode('·', $services);
//            }

            $sku_img = $sku[ 'sku_image' ];
            if (empty($sku_img)) {
                $sku_img = $goods[ 'goods_cover' ];
            }
            if (empty($sku_img)) {
                $sku_img = 'addon/shop/goods_template.png';
            }
            $market_price_text = $sku[ 'market_price' ] > 0 ? '￥' . $sku[ 'market_price' ] : '';
            $url_data = [
                [ 'key' => 'sku_id', 'value' => $sku_id ]
            ];

            $member_info = [];

            if ($member_id > 0) {
                $url_data[] = [ 'key' => 'mid', 'value' => $member_id ];

                //查询会员信息
                $member_info = ( new Member() )->where([ [ 'member_id', '=', $member_id ] ])->findOrEmpty();

                if (!empty($member_info)) {
                    if (empty($member_info[ 'headimg' ])) {
                        $member_info[ 'headimg' ] = 'static/resource/images/default_headimg.png';
                    }
                }
            }

            $return_data = [
                'goods_name' => $goods_name,
//                'services' => $services,
                'goods_price' => '￥' . $sku[ 'sale_price' ],
                'goods_market_price' => $market_price_text,
                'goods_img' => $sku_img,
                'url' => [
                    'url' => ( new CoreSysConfigService() )->getSceneDomain()[ 'wap_url' ],
                    'page' => 'addon/shop/pages/goods/detail',
                    'data' => $url_data,
                ],
            ];

            if (!empty($member_info)) {
                $return_data[ 'nickname' ] = mb_strlen($member_info[ 'nickname' ]) > 10 ? mb_substr($member_info[ 'nickname' ], 0, 7, 'utf-8') . '...' : $member_info[ 'nickname' ];
                $return_data[ 'headimg' ] = $member_info[ 'headimg' ];
            }
            return $return_data;
        } elseif ($type == 'shop_point_goods') {

            // 积分商品 海报模板数据

            $param = $data[ 'param' ];
            $id = $param[ 'id' ] ?? 0;
            $member_id = $param[ 'member_id' ] ?? 0;
            $mode = $param[ 'mode' ] ?? '';

            if ($mode == 'preview') {
                // 预览模式
                $url_data = [
                    [ 'key' => 'id', 'value' => $id ]
                ];
                $return_data = [
                    'nickname' => '会员昵称',
                    'headimg' => 'static/resource/images/default_headimg.png',
                    'goods_name' => '商品名称',
                    'goods_price' => '积分100+￥369.00',
                    'goods_img' => 'addon/shop/goods_template.png',
                    'url' => [
                        'url' => ( new CoreSysConfigService() )->getSceneDomain()[ 'wap_url' ],
                        'page' => 'addon/shop/pages/point/detail',
                        'data' => $url_data,
                    ],
                ];
                return $return_data;
            }

            // 查询sku信息
            $exchange_info = ( new Exchange() )->withSearch([ 'ids' ], [ 'ids' => $id ])->findOrEmpty();
            if ($exchange_info->isEmpty()) return [];
            $goods_name = $exchange_info[ 'names' ];
//            if (mb_strlen($goods_name, 'UTF-8') > 14) {
//                $goods_name = mb_substr($goods_name, 0, 14, 'UTF-8') . '...';
//            }
            $sku_img = explode(',', $exchange_info[ 'image' ])[ 0 ];
            if (empty($sku_img)) {
                $sku_img = 'addon/shop/goods_template.png';
            }
            $url_data = [
                [ 'key' => 'id', 'value' => $id ]
            ];

            $member_info = [];

            if ($member_id > 0) {
                $url_data[] = [ 'key' => 'mid', 'value' => $member_id ];

                //查询会员信息
                $member_info = ( new Member() )->where([ [ 'member_id', '=', $member_id ] ])->findOrEmpty();

                if (!empty($member_info)) {
                    if (empty($member_info[ 'headimg' ])) {
                        $member_info[ 'headimg' ] = 'static/resource/images/default_headimg.png';
                    }
                }
            }
            $price = $exchange_info[ 'price' ] <= 0 ? '' : '+￥' . $exchange_info[ 'price' ];
            $return_data = [
                'goods_name' => $goods_name,
                'goods_price' => "积分:" . $exchange_info[ 'point' ] . $price,
                'goods_img' => $sku_img,
                'url' => [
                    'url' => ( new CoreSysConfigService() )->getSceneDomain()[ 'wap_url' ],
                    'page' => 'addon/shop/pages/point/detail',
                    'data' => $url_data,
                ],
            ];

            if (!empty($member_info)) {
                $return_data[ 'nickname' ] = mb_strlen($member_info[ 'nickname' ]) > 10 ? mb_substr($member_info[ 'nickname' ], 0, 7, 'utf-8') . '...' : $member_info[ 'nickname' ];
                $return_data[ 'headimg' ] = $member_info[ 'headimg' ];
            }
            return $return_data;
        }
    }
}

<?php
// +----------------------------------------------------------------------
// | Niucloud-admin 企业快速开发的多应用管理平台
// +----------------------------------------------------------------------
// | 官方网址：https://www.niucloud.com
// +----------------------------------------------------------------------
// | niucloud团队 版权所有 开源版本可自由商用
// +----------------------------------------------------------------------
// | Author: Niucloud Team
// +----------------------------------------------------------------------

namespace addon\shop\app\dict\goods;

class GoodsDict
{
    // 实物商品
    const REAL = 'real';

    // 虚拟商品
    const VIRTUAL = 'virtual';

    const SINGLE_TIME = 1;//单次限购
    const SINGLE_PERSON = 2;//单人限购

    //商品是否赠品(0:否 1:是)
    const IS_GIFT = 1;
    const NOT_IS_GIFT = 0;

    //批量设置类型
    const LABEL = 'label';
    const SERVICE = 'service';
    const VIRTUAL_SALE_NUM = 'virtual_sale_num';
    const CATEGORY = 'category';
    const BRAND = 'brand';
    const POSTER = 'poster';
    const DIY_FORM = 'diy_form';
    const GIFT = 'gift';
    const DELIVERY = 'delivery';
    const STOCK = 'stock';

    /**
     * 商品类型
     * @param $type
     * @return array|mixed|string
     */
    public static function getType($type = '')
    {
        $list = [
            self::REAL => [
                'type' => self::REAL,
                'name' => get_lang('dict_shop_goods.real'),
                'desc' => get_lang('dict_shop_goods.real_desc'),
                'path' => '/shop/goods/real_edit',
            ],
            self::VIRTUAL => [
                'type' => self::VIRTUAL,
                'name' => get_lang('dict_shop_goods.virtual'),
                'desc' => get_lang('dict_shop_goods.virtual_desc'),
                'path' => '/shop/goods/virtual_edit',
            ]
        ];
        if ($type == '') return $list;
        return $list[ $type ];
    }

    /**
     * 批量设置
     * @param $type
     * @return array|mixed|string
     */
    public static function getBatchSetDict($type = '')
    {
        $data = [
            self::LABEL => get_lang('dict_shop_goods_batch_set.label'),
            self::SERVICE => get_lang('dict_shop_goods_batch_set.service'),
            self::VIRTUAL_SALE_NUM => get_lang('dict_shop_goods_batch_set.virtual_sale_num'),
            self::CATEGORY => get_lang('dict_shop_goods_batch_set.category'),
            self::BRAND => get_lang('dict_shop_goods_batch_set.brand'),
            self::POSTER => get_lang('dict_shop_goods_batch_set.poster'),
            self::GIFT => get_lang('dict_shop_goods_batch_set.gift'),
            self::DELIVERY => get_lang('dict_shop_goods_batch_set.delivery'),
            self::STOCK => get_lang('dict_shop_goods_batch_set.stock'),
            self::DIY_FORM => get_lang('dict_shop_goods_batch_set.diy_form'),
        ];
        if (!$type) {
            return $data;
        }
        return $data[ $type ] ?? '';
    }
}

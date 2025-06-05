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
namespace addon\shop\app\job\order;

use app\service\core\notice\NoticeService;
use core\base\BaseJob;

/**
 * 调用订单催付通知
 */
class OrderPayRemind extends BaseJob
{
    /**
     * 消费
     * @param $data
     * @return true
     */
    protected function doJob(int $order_id)
    {
        try {
            (new NoticeService())->send('shop_order_pay_remind', ['order_id' => $order_id ]);
            return true;
        } catch (\Exception $e) {
            return false;
        }
    }

}

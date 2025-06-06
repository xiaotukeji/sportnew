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

namespace addon\sport\app\validate\sport_event_series;
use core\base\BaseValidate;
/**
 * 赛事系列验证器
 * Class SportEventSeries
 * @package addon\sport\app\validate\sport_event_series
 */
class SportEventSeries extends BaseValidate
{

       protected $rule = [
            'name' => 'require',
            'organizer_id' => 'require',
            'member_id' => 'require',
            'start_year' => 'require',
            'sort' => 'require',
            'status' => 'require'
        ];

       protected $message = [
            'name.require' => ['common_validate.require', ['name']],
            'organizer_id.require' => ['common_validate.require', ['organizer_id']],
            'member_id.require' => ['common_validate.require', ['member_id']],
            'start_year.require' => ['common_validate.require', ['start_year']],
            'sort.require' => ['common_validate.require', ['sort']],
            'status.require' => ['common_validate.require', ['status']]
        ];

       protected $scene = [
            "add" => ['name', 'organizer_id', 'member_id', 'description', 'start_year', 'end_year', 'sort', 'status', 'remark'],
            "edit" => ['name', 'organizer_id', 'member_id', 'description', 'start_year', 'end_year', 'sort', 'status', 'remark']
        ];

}

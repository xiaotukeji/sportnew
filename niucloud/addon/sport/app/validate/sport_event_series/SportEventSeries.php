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
            'name.require' => '系列赛名称不能为空',
            'start_year.require' => '开始年份不能为空',
            'organizer_id.require' => '主办方ID不能为空',
            'member_id.require' => '用户ID不能为空',
            'sort.require' => '排序不能为空',
            'status.require' => '状态不能为空'
        ];

       protected $scene = [
            "add" => ['name', 'start_year', 'description', 'remark'],
            "edit" => ['name', 'start_year', 'description', 'remark'],
            "admin_add" => ['name', 'organizer_id', 'member_id', 'description', 'start_year', 'end_year', 'sort', 'status', 'remark'],
            "admin_edit" => ['name', 'organizer_id', 'member_id', 'description', 'start_year', 'end_year', 'sort', 'status', 'remark']
        ];

}

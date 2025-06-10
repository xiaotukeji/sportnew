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

namespace addon\sport\app\validate\sport_event;
use core\base\BaseValidate;
/**
 * 赛事验证器
 * Class SportEvent
 * @package addon\sport\app\validate\sport_event
 */
class SportEvent extends BaseValidate
{

       protected $rule = [
            'name' => 'require',
            'event_type' => 'require',
            'year' => 'require',
            'start_time' => 'require',
            'end_time' => 'require',
            'location' => 'require',
            'organizer_id' => 'require',
            'organizer_type' => 'require',
            'sort' => 'require',
            'status' => 'require'
        ];

       protected $message = [
            'name.require' => '赛事名称不能为空',
            'event_type.require' => '赛事类型不能为空',
            'year.require' => '举办年份不能为空',
            'start_time.require' => '开始时间不能为空',
            'end_time.require' => '结束时间不能为空',
            'location.require' => '举办地点不能为空',
            'organizer_id.require' => '主办方不能为空',
            'organizer_type.require' => '举办者类型不能为空',
            'sort.require' => '排序不能为空',
            'status.require' => '状态不能为空'
        ];

       protected $scene = [
            "add" => ['name', 'event_type', 'year', 'start_time', 'end_time', 'location', 'organizer_id'],
            "edit" => ['name', 'event_type', 'year', 'start_time', 'end_time', 'location', 'organizer_id'],
            "admin_add" => ['series_id', 'name', 'event_type', 'year', 'season', 'start_time', 'end_time', 'location', 'organizer_id', 'organizer_type', 'sort', 'status', 'remark'],
            "admin_edit" => ['series_id', 'name', 'event_type', 'year', 'season', 'start_time', 'end_time', 'location', 'organizer_id', 'organizer_type', 'sort', 'status', 'remark']
        ];

}

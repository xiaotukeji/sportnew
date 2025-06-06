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
            'name.require' => ['common_validate.require', ['name']],
            'event_type.require' => ['common_validate.require', ['event_type']],
            'year.require' => ['common_validate.require', ['year']],
            'start_time.require' => ['common_validate.require', ['start_time']],
            'end_time.require' => ['common_validate.require', ['end_time']],
            'location.require' => ['common_validate.require', ['location']],
            'organizer_id.require' => ['common_validate.require', ['organizer_id']],
            'organizer_type.require' => ['common_validate.require', ['organizer_type']],
            'sort.require' => ['common_validate.require', ['sort']],
            'status.require' => ['common_validate.require', ['status']]
        ];

       protected $scene = [
            "add" => ['series_id', 'name', 'event_type', 'year', 'season', 'start_time', 'end_time', 'location', 'organizer_id', 'organizer_type', 'sort', 'status', 'remark'],
            "edit" => ['series_id', 'name', 'event_type', 'year', 'season', 'start_time', 'end_time', 'location', 'organizer_id', 'organizer_type', 'sort', 'status', 'remark']
        ];

}

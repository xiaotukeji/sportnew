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

namespace addon\sport\app\validate\sport_organizer;
use core\base\BaseValidate;
/**
 * 主办方验证器
 * Class SportOrganizer
 * @package addon\sport\app\validate\sport_organizer
 */
class SportOrganizer extends BaseValidate
{

       protected $rule = [
            'organizer_id' => 'require',
            'organizer_type' => 'require',
            'organizer_name' => 'require',
            'sort' => 'require',
            'status' => 'require'
        ];

       protected $message = [
            'organizer_id.require' => ['common_validate.require', ['organizer_id']],
            'organizer_type.require' => ['common_validate.require', ['organizer_type']],
            'organizer_name.require' => ['common_validate.require', ['organizer_name']],
            'sort.require' => ['common_validate.require', ['sort']],
            'status.require' => ['common_validate.require', ['status']]
        ];

       protected $scene = [
            "add" => ['organizer_id', 'member_id', 'organizer_type', 'organizer_name', 'organizer_license', 'contact_name', 'contact_phone', 'sort', 'status', 'remark'],
            "edit" => ['organizer_id', 'member_id', 'organizer_type', 'organizer_name', 'organizer_license', 'contact_name', 'contact_phone', 'sort', 'status', 'remark']
        ];

}

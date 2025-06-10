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
            'organizer_name' => 'require',
            'organizer_type' => 'require',
            'organizer_id' => 'require',
            'sort' => 'require',
            'status' => 'require'
        ];

       protected $message = [
            'organizer_name.require' => '主办方名称不能为空',
            'organizer_type.require' => '举办者类型不能为空',
            'organizer_id.require' => '主办方ID不能为空',
            'sort.require' => '排序不能为空',
            'status.require' => '状态不能为空'
        ];

       protected $scene = [
            "add" => ['organizer_name', 'organizer_type', 'organizer_license', 'contact_name', 'contact_phone', 'remark'],
            "edit" => ['organizer_name', 'organizer_type', 'organizer_license', 'contact_name', 'contact_phone', 'remark'],
            "admin_add" => ['organizer_id', 'member_id', 'organizer_type', 'organizer_name', 'organizer_license', 'contact_name', 'contact_phone', 'sort', 'status', 'remark'],
            "admin_edit" => ['organizer_id', 'member_id', 'organizer_type', 'organizer_name', 'organizer_license', 'contact_name', 'contact_phone', 'sort', 'status', 'remark']
        ];

}

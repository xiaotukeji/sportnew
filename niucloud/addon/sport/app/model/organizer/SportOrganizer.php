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

namespace addon\sport\app\model\organizer;

use core\base\BaseModel;

/**
 * 主办方模型
 * Class SportOrganizer
 * @package addon\sport\app\model\organizer
 */
class SportOrganizer extends BaseModel
{
    /**
     * 数据表主键
     * @var string
     */
    protected $pk = 'id';

    /**
     * 模型名称
     * @var string
     */
    protected $name = 'sport_organizer';

    /**
     * 自动时间戳
     * @var bool
     */
    protected $autoWriteTimestamp = true;

    /**
     * 创建时间字段
     * @var string
     */
    protected $createTime = 'create_time';

    /**
     * 更新时间字段
     * @var string
     */
    protected $updateTime = 'update_time';

    /**
     * 数据类型转换
     * @var array
     */
    protected $type = [
        'id' => 'integer',
        'organizer_id' => 'integer',
        'member_id' => 'integer',
        'organizer_type' => 'integer',
        'sort' => 'integer',
        'status' => 'integer',
        'create_time' => 'integer',
        'update_time' => 'integer',
    ];

    /**
     * 获取器 - 举办者类型文本
     * @param $value
     * @return string
     */
    public function getOrganizerTypeTextAttr($value, $data)
    {
        $types = [
            1 => '个人',
            2 => '单位'
        ];
        return $types[$data['organizer_type']] ?? '未知';
    }

    /**
     * 获取器 - 状态文本
     * @param $value
     * @return string
     */
    public function getStatusTextAttr($value, $data)
    {
        $status = [
            0 => '禁用',
            1 => '启用'
        ];
        return $status[$data['status']] ?? '未知';
    }

    /**
     * 搜索器 - 按主办方名称搜索
     * @param $query
     * @param $value
     * @return void
     */
    public function searchOrganizerNameAttr($query, $value)
    {
        if ($value) {
            $query->where('organizer_name', 'like', '%' . $value . '%');
        }
    }

    /**
     * 搜索器 - 按举办者类型搜索
     * @param $query
     * @param $value
     * @return void
     */
    public function searchOrganizerTypeAttr($query, $value)
    {
        if ($value !== '') {
            $query->where('organizer_type', $value);
        }
    }

    /**
     * 搜索器 - 按会员ID搜索
     * @param $query
     * @param $value
     * @return void
     */
    public function searchMemberIdAttr($query, $value)
    {
        if ($value) {
            $query->where('member_id', $value);
        }
    }

    /**
     * 搜索器 - 按状态搜索
     * @param $query
     * @param $value
     * @return void
     */
    public function searchStatusAttr($query, $value)
    {
        if ($value !== '') {
            $query->where('status', $value);
        }
    }
} 
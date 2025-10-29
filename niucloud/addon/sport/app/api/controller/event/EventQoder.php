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

namespace addon\sport\app\api\controller\event;

use addon\sport\app\service\api\event\EventQoderService;
use core\base\BaseApiController;

/**
 * 改进版赛事控制器
 * Class EventQoder
 * @package addon\sport\app\api\controller\event
 */
class EventQoder extends BaseApiController
{
    /**
     * 一体化创建赛事
     * @return \think\Response
     */
    public function createAllInOne()
    {
        $data = $this->request->params([
            ['name', ''],              // 赛事名称
            ['location', ''],          // 举办地点
            ['address_detail', ''],    // 详细地址
            ['start_date', ''],        // 开始日期
            ['start_time', ''],        // 开始时间
            ['end_date', ''],          // 结束日期
            ['end_time', ''],          // 结束时间
            ['organizer_id', 0],       // 主办方ID
            ['event_type', 1],         // 赛事类型：1独立赛事 2系列赛事
            ['series_id', 0],          // 系列赛ID
            ['base_item_ids', []],     // 基础项目ID数组
            ['item_settings', []],     // 项目设置
            ['venue_assignments', []], // 场地分配
        ]);

        // 验证必填字段
        if (empty($data['name'])) {
            throw new \core\exception\CommonException('请输入赛事名称');
        }
        
        if (empty($data['organizer_id'])) {
            throw new \core\exception\CommonException('请选择主办方');
        }
        
        if (empty($data['location'])) {
            throw new \core\exception\CommonException('请输入举办地点');
        }
        
        if (empty($data['address_detail'])) {
            throw new \core\exception\CommonException('请输入详细地址');
        }
        
        if (empty($data['start_date']) || empty($data['start_time'])) {
            throw new \core\exception\CommonException('请选择开始时间');
        }
        
        if (empty($data['end_date']) || empty($data['end_time'])) {
            throw new \core\exception\CommonException('请选择结束时间');
        }
        
        $start_timestamp = strtotime($data['start_date'] . ' ' . $data['start_time']);
        $end_timestamp = strtotime($data['end_date'] . ' ' . $data['end_time']);
        
        if ($start_timestamp >= $end_timestamp) {
            throw new \core\exception\CommonException('结束时间必须大于开始时间');
        }

        $id = (new EventQoderService())->createAllInOne($data);
        return success('赛事创建成功', ['id' => $id]);
    }

    /**
     * 获取创建赛事所需初始化数据
     * @return \think\Response
     */
    public function init()
    {
        return success((new EventQoderService())->getInit());
    }
}
?>
</file>
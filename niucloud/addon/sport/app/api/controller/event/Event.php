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

use addon\sport\app\service\api\event\EventService;
use core\base\BaseApiController;

/**
 * 赛事控制器
 * Class Event
 * @package addon\sport\app\api\controller\event
 */
class Event extends BaseApiController
{
    /**
     * 获取赛事列表
     * @return \think\Response
     */
    public function list()
    {
        $data = $this->request->params([
            ['name', ''],              // 赛事名称
            ['year', ''],              // 年份
            ['event_type', ''],        // 赛事类型
            ['organizer_type', ''],    // 举办者类型
            ['status', ''],            // 状态
            ['my_events', 0],          // 是否只查看我的赛事
        ]);
        return success((new EventService())->getList($data));
    }

    /**
     * 获取赛事详情
     * @param int $id
     * @return \think\Response
     */
    public function info(int $id)
    {
        return success((new EventService())->getInfo($id));
    }

    /**
     * 添加赛事
     * @return \think\Response
     */
    public function add()
    {
        $data = $this->request->params([
            ['name', ''],              // 赛事名称
            ['location', ''],          // 举办地点
            ['start_time', 0],         // 开始时间
            ['end_time', 0],           // 结束时间
            ['organizer_type', 1],     // 举办者类型：1个人 2单位
            ['organizer_id', 0],       // 主办方ID
            ['event_type', 1],         // 赛事类型：1独立赛事 2系列赛事
            ['series_id', 0],          // 系列赛ID
            ['year', 0],               // 举办年份
            ['season', ''],            // 赛季
            ['remark', ''],            // 备注
        ]);

        // 验证必填字段
        $this->validate($data, 'addon\sport\app\validate\sport_event\SportEvent.add');
        
        $id = (new EventService())->add($data);
        return success('ADD_SUCCESS', ['id' => $id]);
    }

    /**
     * 编辑赛事
     * @param int $id
     * @return \think\Response
     */
    public function edit(int $id)
    {
        $data = $this->request->params([
            ['name', ''],              // 赛事名称
            ['location', ''],          // 举办地点
            ['start_time', 0],         // 开始时间
            ['end_time', 0],           // 结束时间
            ['organizer_type', 1],     // 举办者类型：1个人 2单位
            ['organizer_id', 0],       // 主办方ID
            ['event_type', 1],         // 赛事类型：1独立赛事 2系列赛事
            ['series_id', 0],          // 系列赛ID
            ['year', 0],               // 举办年份
            ['season', ''],            // 赛季
            ['remark', ''],            // 备注
        ]);

        // 验证必填字段
        $this->validate($data, 'addon\sport\app\validate\sport_event\SportEvent.edit');
        
        (new EventService())->edit($id, $data);
        return success('EDIT_SUCCESS');
    }

    /**
     * 删除赛事
     * @param int $id
     * @return \think\Response
     */
    public function delete(int $id)
    {
        (new EventService())->del($id);
        return success('DELETE_SUCCESS');
    }

    /**
     * 获取赛事创建初始化数据
     * @return \think\Response
     */
    public function init()
    {
        return success((new EventService())->getInit());
    }

    /**
     * 获取我的赛事列表
     * @return \think\Response
     */
    public function myList()
    {
        $data = $this->request->params([
            ['status', ''],            // 状态筛选
        ]);
        
        // 调试：记录控制器接收的参数
        \think\facade\Log::info('MyList Controller Debug:', [
            'raw_request_data' => $this->request->param(),
            'processed_data' => $data,
            'request_method' => $this->request->method()
        ]);
        
        return success((new EventService())->getMyList($data));
    }

    /**
     * 更新赛事状态
     * @param int $id
     * @return \think\Response
     */
    public function updateStatus(int $id)
    {
        $data = $this->request->params([
            ['status', 0],  // 新状态：0待发布 1进行中 2已结束 3已作废
        ]);
        
        (new EventService())->updateStatus($id, $data['status']);
        return success('UPDATE_SUCCESS');
    }
} 
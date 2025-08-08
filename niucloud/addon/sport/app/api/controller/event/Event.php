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
            ['location_detail', ''],   // 完整地址
            ['address_detail', ''],    // 详细地址
            ['latitude', null],        // 纬度
            ['longitude', null],       // 经度
            ['start_time', 0],         // 开始时间
            ['end_time', 0],           // 结束时间
            ['registration_start_time', ''], // 报名开始时间
            ['registration_end_time', ''],   // 报名结束时间
            ['organizer_type', 1],     // 举办者类型：1个人 2单位
            ['organizer_id', 0],       // 主办方ID
            ['event_type', 1],         // 赛事类型：1独立赛事 2系列赛事
            ['series_id', 0],          // 系列赛ID
            ['year', 0],               // 举办年份
            ['season', ''],            // 赛季
            ['age_groups', ''],        // 年龄组设置
            ['age_group_display', 0],  // 年龄组显示方式
            ['signup_fields', []],     // 报名字段配置
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
            ['location_detail', ''],   // 完整地址
            ['address_detail', ''],    // 详细地址
            ['latitude', null],        // 纬度
            ['longitude', null],       // 经度
            ['start_time', 0],         // 开始时间
            ['end_time', 0],           // 结束时间
            ['registration_start_time', ''], // 报名开始时间
            ['registration_end_time', ''],   // 报名结束时间
            ['organizer_type', 1],     // 举办者类型：1个人 2单位
            ['organizer_id', 0],       // 主办方ID
            ['event_type', 1],         // 赛事类型：1独立赛事 2系列赛事
            ['series_id', 0],          // 系列赛ID
            ['year', 0],               // 举办年份
            ['season', ''],            // 赛季
            ['age_groups', ''],        // 年龄组设置
            ['age_group_display', 0],  // 年龄组显示方式
            ['signup_fields', []],     // 报名字段配置
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
        // 统一使用params()方法获取参数，与商城购物车保持一致
        $data = $this->request->params([
            ['status', ''],            // 状态筛选
            ['page', 1],              // 页码
            ['limit', 15],            // 每页数量
        ]);
        
        // 调试：记录控制器接收的参数
        \think\facade\Log::info('MyList Controller Debug: raw_request=' . json_encode($this->request->param()) . ', processed_data=' . json_encode($data) . ', method=' . $this->request->method() . ', status=' . $data['status']);
        
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
    
    /**
     * 更新赛事设置
     * @param int $id
     * @return \think\Response
     */
    public function updateSettings(int $id)
    {
        $data = $this->request->params([
            ['status', 0],                          // 赛事状态
            ['sort', 0],                            // 排序权重
            ['registration_start_time', ''],        // 报名开始时间
            ['registration_end_time', ''],          // 报名结束时间
            ['registration_fee', 0],                // 报名费
            ['max_participants', 0],                // 总报名人数限制
            ['group_size', 0],                      // 每组人数
            ['rounds', 0],                          // 比赛轮次
            ['allow_duplicate_registration', 0],    // 是否允许重复报名
            ['age_group_display', 0],               // 是否显示年龄组
            ['show_participant_count', 1],          // 是否显示报名人数
            ['show_progress', 1],                   // 是否显示比赛进度
            ['remark', ''],                         // 备注说明
        ]);
        
        (new EventService())->updateSettings($id, $data);
        return success('UPDATE_SUCCESS');
    }
    
    /**
     * 获取赛事场地列表
     * @param int $id 赛事ID
     * @return \think\Response
     */
    public function venues(int $id)
    {
        $data = $this->request->params([
            ['venue_type', ''],                     // 场地类型筛选
            ['is_available', ''],                   // 可用状态筛选
            ['page', 1],                           // 页码
            ['limit', 15],                         // 每页数量
        ]);
        
        return success((new EventService())->getEventVenues($id, $data));
    }
    
    /**
     * 添加赛事场地
     * @param int $id 赛事ID
     * @return \think\Response
     */
    public function addVenue(int $id)
    {
        $data = $this->request->params([
            ['venue_type', ''],                     // 场地类型
            ['venue_category', ''],                 // 场地分类
            ['name', ''],                          // 场地名称
            ['venue_code', ''],                    // 场地编码
            ['location', ''],                      // 场地位置
            ['capacity', 0],                       // 容纳人数
            ['is_available', 1],                   // 是否可用
            ['remark', ''],                        // 备注
        ]);
        
        // 验证必填字段
        if (empty($data['venue_type']) || empty($data['name']) || empty($data['venue_code'])) {
            return error('请填写完整的场地信息');
        }
        
        $venueId = (new EventService())->addEventVenue($id, $data);
        return success('ADD_SUCCESS', ['id' => $venueId]);
    }
    
    /**
     * 编辑赛事场地
     * @param int $id 赛事ID
     * @param int $venueId 场地ID
     * @return \think\Response
     */
    public function editVenue(int $id, int $venueId)
    {
        $data = $this->request->params([
            ['venue_type', ''],                     // 场地类型
            ['venue_category', ''],                 // 场地分类
            ['name', ''],                          // 场地名称
            ['venue_code', ''],                    // 场地编码
            ['location', ''],                      // 场地位置
            ['capacity', 0],                       // 容纳人数
            ['is_available', 1],                   // 是否可用
            ['remark', ''],                        // 备注
        ]);
        
        // 验证必填字段
        if (empty($data['venue_type']) || empty($data['name']) || empty($data['venue_code'])) {
            return error('请填写完整的场地信息');
        }
        
        (new EventService())->editEventVenue($id, $venueId, $data);
        return success('EDIT_SUCCESS');
    }
    
    /**
     * 删除赛事场地
     * @param int $id 赛事ID
     * @param int $venueId 场地ID
     * @return \think\Response
     */
    public function deleteVenue(int $id, int $venueId)
    {
        (new EventService())->deleteEventVenue($id, $venueId);
        return success('DELETE_SUCCESS');
    }
    
    /**
     * 批量添加场地
     * @param int $id 赛事ID
     * @return \think\Response
     */
    public function batchAddVenues(int $id)
    {
        $data = $this->request->params([
            ['venue_type', ''],                     // 场地类型
            ['venue_category', ''],                 // 场地分类
            ['count', 1],                          // 添加数量
            ['name_prefix', ''],                   // 名称前缀
            ['code_prefix', ''],                   // 编码前缀
            ['location', ''],                      // 场地位置
            ['capacity', 0],                       // 容纳人数
        ]);
        
        // 验证必填字段
        if (empty($data['venue_type']) || empty($data['venue_category']) || $data['count'] <= 0) {
            return error('请填写完整的批量添加信息');
        }
        
        $venueIds = (new EventService())->batchAddEventVenues($id, $data);
        return success('BATCH_ADD_SUCCESS', ['ids' => $venueIds]);
    }
} 
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
     * 获取赛事详情页完整信息（包含协办方和号码牌设置）
     * @param int $id
     * @return \think\Response
     */
    public function detailInfo(int $id)
    {
        return success((new EventService())->getDetailInfo($id));
    }

    /**
     * 添加赛事
     * @return \think\Response
     */
    public function add()
    {
        $data = $this->request->params([
            ['step', 1],               // 步骤：1基础信息 2地点信息 3时间信息 4报名设置 5项目选择 6项目设置 7最终设置
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
            ['show_participant_count', 0], // 显示报名人数
            ['show_progress', 0],      // 显示比赛进度
            ['signup_fields', []],     // 报名字段配置
            ['number_plate_settings', []], // 号码牌设置
            ['remark', ''],            // 备注
            ['contact_name', ''],      // 联系人姓名
            ['contact_phone', ''],     // 联系电话
            ['contact_wechat', ''],    // 微信号
            ['contact_email', ''],     // 邮箱
        ]);

        // 调试信息
        \think\facade\Log::info('Event Controller add - 联系方式数据: ' . json_encode([
            'contact_name' => $data['contact_name'] ?? '未设置',
            'contact_phone' => $data['contact_phone'] ?? '未设置',
            'contact_wechat' => $data['contact_wechat'] ?? '未设置',
            'contact_email' => $data['contact_email'] ?? '未设置'
        ]));
        
        // 根据步骤验证必填字段
        $this->validateStepData($data);
        
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
            ['step', 1],               // 步骤：1基础信息 2地点信息 3时间信息 4报名设置 5项目选择 6项目设置 7最终设置
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
            ['show_participant_count', 0], // 显示报名人数
            ['show_progress', 0],      // 显示比赛进度
            ['signup_fields', []],     // 报名字段配置
            ['number_plate_settings', []], // 号码牌设置
            ['remark', ''],            // 备注
            ['contact_name', ''],      // 联系人姓名
            ['contact_phone', ''],     // 联系电话
            ['contact_wechat', ''],    // 微信号
            ['contact_email', ''],     // 邮箱
        ]);

        // 调试信息
        \think\facade\Log::info('Event Controller edit - 联系方式数据: ' . json_encode([
            'contact_name' => $data['contact_name'] ?? '未设置',
            'contact_phone' => $data['contact_phone'] ?? '未设置',
            'contact_wechat' => $data['contact_wechat'] ?? '未设置',
            'contact_email' => $data['contact_email'] ?? '未设置'
        ]));
        
        // 根据步骤验证必填字段
        $this->validateStepData($data);
        
        (new EventService())->edit($id, $data);
        
        // 返回调试信息给前端
        return success([
            'message' => 'EDIT_SUCCESS',
            'debug' => [
                'step' => $data['step'] ?? 'unknown',
                'submitted_data' => $data,
                'event_id' => $id
            ]
        ]);
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

    /**
     * 获取赛事号码牌规则
     * @param int $id 赛事ID
     * @return \think\Response
     */
    public function getNumberRule(int $id)
    {
        $rule = (new \addon\sport\app\service\api\number_plate\NumberPlateService())->getEventNumberRule($id);
        return success('', $rule);
    }

    /**
     * 保存赛事号码牌规则
     * @param int $id 赛事ID
     * @return \think\Response
     */
    public function saveNumberRule(int $id)
    {
        $data = $this->request->params([
            ['numbering_mode', 1],      // 编号模式：1系统分配 2用户自选
            ['prefix', ''],             // 号码前缀
            ['number_length', 3],       // 数字位数
            ['start_number', 1],        // 起始号码
            ['end_number', 999],        // 结束号码
            ['step', 1],                // 编号步长
            ['reserved_numbers', ''],   // 保留号码列表
            ['disabled_numbers', ''],   // 禁用号码列表
            ['allow_athlete_choice', 0], // 是否允许运动员自选
            ['choice_time_window', 7],  // 自选时间窗口
            ['choice_rules', 'first_come_first_served'], // 自选规则
            ['auto_assign_after_registration', 1], // 报名后是否自动分配
        ]);

        (new \addon\sport\app\service\api\number_plate\NumberPlateService())->saveEventNumberRule($id, $data);
        return success('SAVE_SUCCESS');
    }

    /**
     * 获取可选择的号码列表
     * @param int $id 赛事ID
     * @return \think\Response
     */
    public function getAvailableNumbers(int $id)
    {
        $data = $this->request->params([
            ['item_id', 0], // 项目ID
        ]);

        $numbers = (new \addon\sport\app\service\api\number_plate\NumberPlateService())->getAvailableNumbers($id, $data['item_id']);
        return success('', $numbers);
    }

    /**
     * 获取赛事号码分配列表
     * @param int $id 赛事ID
     * @return \think\Response
     */
    public function getNumberAssignments(int $id)
    {
        $data = $this->request->params([
            ['item_id', ''],           // 项目ID
            ['assignment_type', ''],   // 分配类型
            ['number_plate', ''],      // 号码牌
            ['page', 1],               // 页码
            ['limit', 15],             // 每页数量
        ]);

        $result = (new \addon\sport\app\service\api\number_plate\NumberPlateService())->getNumberAssignments($id, $data);
        return success('', $result);
    }

    /**
     * 取消号码分配
     * @param int $id 赛事ID
     * @param int $assignmentId 分配记录ID
     * @return \think\Response
     */
    public function cancelNumberAssignment(int $id, int $assignmentId)
    {
        (new \addon\sport\app\service\api\number_plate\NumberPlateService())->cancelNumberAssignment($id, $assignmentId);
        return success('CANCEL_SUCCESS');
    }

    /**
     * 根据步骤验证数据
     * @param array $data
     * @throws \core\exception\CommonException
     */
    private function validateStepData(array $data)
    {
        $step = $data['step'] ?? 1;
        
        switch ($step) {
            case 1: // 基础信息
                if (empty($data['name'])) {
                    throw new \core\exception\CommonException('请输入赛事名称');
                }
                if (empty($data['organizer_id'])) {
                    throw new \core\exception\CommonException('请选择主办方');
                }
                break;
                
            case 2: // 地点信息
                if (empty($data['location'])) {
                    throw new \core\exception\CommonException('请选择举办地点');
                }
                if (empty($data['address_detail'])) {
                    throw new \core\exception\CommonException('请输入详细地址');
                }
                break;
                
            case 3: // 时间信息
                if (empty($data['start_time']) || $data['start_time'] <= 0) {
                    throw new \core\exception\CommonException('请选择开始时间');
                }
                if (empty($data['end_time']) || $data['end_time'] <= 0) {
                    throw new \core\exception\CommonException('请选择结束时间');
                }
                if ($data['start_time'] >= $data['end_time']) {
                    throw new \core\exception\CommonException('结束时间必须大于开始时间');
                }
                break;
                
            case 4: // 报名设置
                if (empty($data['signup_fields']) || !is_array($data['signup_fields'])) {
                    throw new \core\exception\CommonException('请至少选择一个报名字段');
                }
                $requiredFields = array_filter($data['signup_fields'], function($field) {
                    return $field['required'] ?? false;
                });
                if (count($data['signup_fields']) < 3 && count($requiredFields) !== count($data['signup_fields'])) {
                    throw new \core\exception\CommonException('请将所有选择的字段设为必填');
                }
                if (count($data['signup_fields']) >= 3 && count($requiredFields) === 0) {
                    throw new \core\exception\CommonException('请至少设置一个必填字段');
                }
                break;
                
            case 5: // 项目选择
                // 项目选择步骤通常不需要特殊验证，因为可能没有选择项目
                break;
                
            case 6: // 项目设置
                // 项目设置步骤的验证在项目设置服务中处理
                break;
                
            case 7: // 最终设置
                // 最终设置步骤通常不需要特殊验证，主要是保存显示设置和号码牌设置
                break;
                
            default:
                throw new \core\exception\CommonException('无效的步骤参数');
        }
    }
} 
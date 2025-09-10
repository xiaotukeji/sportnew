<?php

namespace addon\sport\app\service\api\number_plate;

use addon\sport\app\model\number_rule\SportEventNumberRule;
use addon\sport\app\model\number_assignment\SportEventNumberAssignment;
use core\exception\CommonException;

/**
 * 号码牌设置服务类
 * Class NumberPlateService
 * @package addon\sport\app\service\api\number_plate
 */
class NumberPlateService
{
    /**
     * 当前用户ID
     * @var int
     */
    protected $member_id;

    public function __construct()
    {
        $this->member_id = request()->uid();
    }

    /**
     * 保存或更新赛事号码牌规则
     * @param int $eventId 赛事ID
     * @param array $data 号码牌设置数据
     * @return bool
     * @throws CommonException
     */
    public function saveEventNumberRule($eventId, $data)
    {
        // 验证赛事是否存在且属于当前用户
        $this->checkEventPermission($eventId);

        // 添加调试日志
        \think\facade\Log::info('NumberPlateService saveEventNumberRule Debug: eventId=' . $eventId . ', data=' . json_encode($data));

        // 验证数据
        $this->validateNumberRuleData($data);

        // 查找现有规则
        $rule = SportEventNumberRule::where('event_id', $eventId)->find();

        if ($rule) {
            // 更新现有规则
            \think\facade\Log::info('NumberPlateService 更新现有规则: ' . json_encode($data));
            $rule->save($data);
        } else {
            // 创建新规则
            $data['event_id'] = $eventId;
            \think\facade\Log::info('NumberPlateService 创建新规则: ' . json_encode($data));
            $rule = SportEventNumberRule::create($data);
        }

        // 保存后检查数据
        $savedRule = SportEventNumberRule::where('event_id', $eventId)->find();
        \think\facade\Log::info('NumberPlateService 保存后数据: ' . json_encode($savedRule->toArray()));

        return true;
    }

    /**
     * 获取赛事号码牌规则
     * @param int $eventId 赛事ID
     * @return array|null
     */
    public function getEventNumberRule($eventId)
    {
        $rule = SportEventNumberRule::where('event_id', $eventId)->find();
        
        if (!$rule) {
            return null;
        }

        return $rule->toArray();
    }

    /**
     * 删除赛事号码牌规则
     * @param int $eventId 赛事ID
     * @return bool
     * @throws CommonException
     */
    public function deleteEventNumberRule($eventId)
    {
        // 验证赛事权限
        $this->checkEventPermission($eventId);

        // 删除规则
        SportEventNumberRule::where('event_id', $eventId)->delete();

        // 删除相关分配记录
        SportEventNumberAssignment::where('event_id', $eventId)->delete();

        return true;
    }

    /**
     * 分配号码给报名记录
     * @param int $eventId 赛事ID
     * @param int $registrationId 报名记录ID
     * @param int $athleteId 参赛人员ID
     * @param int $itemId 项目ID
     * @param string|null $selectedNumber 用户选择的号码（可选）
     * @return string 分配的号码
     * @throws CommonException
     */
    public function assignNumber($eventId, $registrationId, $athleteId, $itemId, $selectedNumber = null)
    {
        // 获取号码牌规则
        $rule = SportEventNumberRule::where('event_id', $eventId)->find();
        if (!$rule) {
            throw new CommonException('该赛事未设置号码牌规则');
        }

        // 检查是否已有分配记录
        $existingAssignment = SportEventNumberAssignment::where('event_id', $eventId)
            ->where('registration_id', $registrationId)
            ->find();

        if ($existingAssignment) {
            return $existingAssignment->number_plate;
        }

        $assignedNumber = null;
        $assignmentType = 1; // 默认系统分配

        if ($selectedNumber) {
            // 用户自选号码
            if ($rule->numbering_mode != 2) {
                throw new CommonException('该赛事不允许用户自选号码');
            }

            // 验证用户选择的号码
            if (!$this->validateUserSelectedNumber($rule, $selectedNumber)) {
                throw new CommonException('选择的号码不可用');
            }

            $assignedNumber = $selectedNumber;
            $assignmentType = 2; // 用户自选
        } else {
            // 系统自动分配
            if ($rule->numbering_mode != 1) {
                throw new CommonException('该赛事需要用户自选号码');
            }

            $assignedNumber = $rule->generateNextNumber();
            if (!$assignedNumber) {
                throw new CommonException('没有可用的号码');
            }
        }

        // 创建分配记录
        SportEventNumberAssignment::create([
            'event_id' => $eventId,
            'registration_id' => $registrationId,
            'athlete_id' => $athleteId,
            'item_id' => $itemId,
            'number_plate' => $assignedNumber,
            'assignment_type' => $assignmentType,
            'assignment_time' => time(),
            'assignment_by' => $assignmentType == 2 ? $this->member_id : 0,
            'status' => 1
        ]);

        return $assignedNumber;
    }

    /**
     * 获取用户可选择的号码列表
     * @param int $eventId 赛事ID
     * @param int $itemId 项目ID
     * @return array
     */
    public function getAvailableNumbers($eventId, $itemId)
    {
        // 获取号码牌规则
        $rule = SportEventNumberRule::where('event_id', $eventId)->find();
        if (!$rule || $rule->numbering_mode != 2) {
            return [];
        }

        // 获取已分配的号码
        $assignedNumbers = SportEventNumberAssignment::getAssignedNumbers($eventId);

        // 生成可用号码列表
        $availableNumbers = [];
        $current = $rule->start_number;

        while ($current <= $rule->end_number) {
            $number = $rule->prefix . str_pad($current, $rule->number_length, '0', STR_PAD_LEFT);
            
            if ($rule->isNumberAvailable($number) && !in_array($number, $assignedNumbers)) {
                $availableNumbers[] = [
                    'number' => $number,
                    'display' => $number
                ];
            }
            
            $current += $rule->step;
        }

        return $availableNumbers;
    }

    /**
     * 获取赛事号码分配列表
     * @param int $eventId 赛事ID
     * @param array $params 查询参数
     * @return array
     */
    public function getNumberAssignments($eventId, $params = [])
    {
        $query = SportEventNumberAssignment::where('event_id', $eventId)
            ->where('status', 1)
            ->with(['athlete', 'item']);

        // 按项目筛选
        if (isset($params['item_id']) && $params['item_id']) {
            $query->where('item_id', $params['item_id']);
        }

        // 按分配类型筛选
        if (isset($params['assignment_type']) && $params['assignment_type'] !== '') {
            $query->where('assignment_type', $params['assignment_type']);
        }

        // 按号码搜索
        if (isset($params['number_plate']) && $params['number_plate']) {
            $query->where('number_plate', 'like', '%' . $params['number_plate'] . '%');
        }

        $page = $params['page'] ?? 1;
        $limit = $params['limit'] ?? 15;

        $list = $query->page($page, $limit)->select();
        $total = $query->count();

        return [
            'list' => $list,
            'total' => $total,
            'page' => $page,
            'limit' => $limit
        ];
    }

    /**
     * 取消号码分配
     * @param int $eventId 赛事ID
     * @param int $assignmentId 分配记录ID
     * @return bool
     * @throws CommonException
     */
    public function cancelNumberAssignment($eventId, $assignmentId)
    {
        // 验证赛事权限
        $this->checkEventPermission($eventId);

        $assignment = SportEventNumberAssignment::where('event_id', $eventId)
            ->where('id', $assignmentId)
            ->find();

        if (!$assignment) {
            throw new CommonException('分配记录不存在');
        }

        $assignment->status = 0;
        $assignment->save();

        return true;
    }

    /**
     * 验证号码牌规则数据
     * @param array $data
     * @throws CommonException
     */
    protected function validateNumberRuleData($data)
    {
        if (empty($data['numbering_mode'])) {
            throw new CommonException('请选择编号模式');
        }

        if (!in_array($data['numbering_mode'], [1, 2])) {
            throw new CommonException('编号模式无效');
        }

        if (empty($data['number_length']) || $data['number_length'] < 1 || $data['number_length'] > 6) {
            throw new CommonException('数字位数必须在1-6位之间');
        }

        if (empty($data['start_number']) || $data['start_number'] < 0) {
            throw new CommonException('起始号码必须大于等于0');
        }

        if (empty($data['end_number']) || $data['end_number'] < $data['start_number']) {
            throw new CommonException('结束号码必须大于起始号码');
        }

        if (empty($data['step']) || $data['step'] < 1) {
            throw new CommonException('编号步长必须大于0');
        }

        // 验证保留号码和禁用号码格式
        if (isset($data['reserved_numbers']) && is_string($data['reserved_numbers'])) {
            $reservedNumbers = json_decode($data['reserved_numbers'], true);
            if (!is_array($reservedNumbers)) {
                throw new CommonException('保留号码格式错误');
            }
        }

        if (isset($data['disabled_numbers']) && is_string($data['disabled_numbers'])) {
            $disabledNumbers = json_decode($data['disabled_numbers'], true);
            if (!is_array($disabledNumbers)) {
                throw new CommonException('禁用号码格式错误');
            }
        }
    }

    /**
     * 验证用户选择的号码
     * @param SportEventNumberRule $rule
     * @param string $number
     * @return bool
     */
    protected function validateUserSelectedNumber($rule, $number)
    {
        // 检查号码是否可用
        if (!$rule->isNumberAvailable($number)) {
            return false;
        }

        // 检查号码是否已被分配
        if (SportEventNumberAssignment::isNumberAssigned($rule->event_id, $number)) {
            return false;
        }

        return true;
    }

    /**
     * 验证赛事权限
     * @param int $eventId
     * @throws CommonException
     */
    protected function checkEventPermission($eventId)
    {
        // 这里需要根据实际的权限验证逻辑来实现
        // 暂时跳过，实际项目中需要验证赛事是否属于当前用户
    }
}

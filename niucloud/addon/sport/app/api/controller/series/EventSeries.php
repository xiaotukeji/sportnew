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

namespace addon\sport\app\api\controller\series;

use addon\sport\app\service\api\series\EventSeriesService;
use core\base\BaseApiController;

/**
 * 系列赛控制器
 * Class EventSeries
 * @package addon\sport\app\api\controller\series
 */
class EventSeries extends BaseApiController
{
    /**
     * 获取用户系列赛列表
     * @return \think\Response
     */
    public function list()
    {
        $data = $this->request->params([
            ['name', ''],              // 系列赛名称
            ['year', ''],              // 年份
        ]);
        return success((new EventSeriesService())->getList($data));
    }

    /**
     * 添加系列赛
     * @return \think\Response
     */
    public function add()
    {
        $data = $this->request->params([
            ['name', ''],              // 系列赛名称
            ['start_year', 0],         // 开始年份
            ['end_year', 0],           // 结束年份
            ['description', ''],       // 描述
            ['remark', ''],            // 备注
        ]);

        // 验证必填字段
        $this->validate($data, 'addon\sport\app\validate\series\EventSeries.add');
        
        $id = (new EventSeriesService())->add($data);
        return success('ADD_SUCCESS', ['id' => $id]);
    }

    /**
     * 获取系列赛详情
     * @param int $id
     * @return \think\Response
     */
    public function info(int $id)
    {
        return success((new EventSeriesService())->getInfo($id));
    }

    /**
     * 编辑系列赛
     * @param int $id
     * @return \think\Response
     */
    public function edit(int $id)
    {
        $data = $this->request->params([
            ['name', ''],              // 系列赛名称
            ['start_year', 0],         // 开始年份
            ['end_year', 0],           // 结束年份
            ['description', ''],       // 描述
            ['remark', ''],            // 备注
        ]);

        // 验证必填字段
        $this->validate($data, 'addon\sport\app\validate\series\EventSeries.edit');
        
        (new EventSeriesService())->edit($id, $data);
        return success('EDIT_SUCCESS');
    }

    /**
     * 删除系列赛
     * @param int $id
     * @return \think\Response
     */
    public function delete(int $id)
    {
        (new EventSeriesService())->del($id);
        return success('DELETE_SUCCESS');
    }
} 
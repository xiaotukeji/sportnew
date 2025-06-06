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

namespace addon\sport\app\service\admin\sport_score;

use addon\sport\app\model\sport_score\SportScore;

use core\base\BaseAdminService;


/**
 * 比赛成绩服务层
 * Class SportScoreService
 * @package addon\sport\app\service\admin\sport_score
 */
class SportScoreService extends BaseAdminService
{
    public function __construct()
    {
        parent::__construct();
        $this->model = new SportScore();
    }

    /**
     * 获取比赛成绩列表
     * @param array $where
     * @return array
     */
    public function getPage(array $where = [])
    {
        $field = 'id,match_id,athlete_id,team_id,score_type,score_value,unit,rank,referee_id,is_valid,sort,status,remark,create_time,update_time';
        $order = '';

        $search_model = $this->model->withSearch(["id","match_id","athlete_id","team_id","score_type","score_value","unit","rank","referee_id","is_valid","sort","status","remark","create_time","update_time"], $where)->field($field)->order($order);
        $list = $this->pageQuery($search_model);
        return $list;
    }

    /**
     * 获取比赛成绩信息
     * @param int $id
     * @return array
     */
    public function getInfo(int $id)
    {
        $field = 'id,match_id,athlete_id,team_id,score_type,score_value,unit,rank,referee_id,is_valid,sort,status,remark,create_time,update_time';

        $info = $this->model->field($field)->where([['id', "=", $id]])->findOrEmpty()->toArray();
   $info['status'] = strval($info['status']);
        return $info;
    }

    /**
     * 添加比赛成绩
     * @param array $data
     * @return mixed
     */
    public function add(array $data)
    {
        $res = $this->model->create($data);
        return $res->id;

    }

    /**
     * 比赛成绩编辑
     * @param int $id
     * @param array $data
     * @return bool
     */
    public function edit(int $id, array $data)
    {

        $this->model->where([['id', '=', $id]])->update($data);
        return true;
    }

    /**
     * 删除比赛成绩
     * @param int $id
     * @return bool
     */
    public function del(int $id)
    {
        $model = $this->model->where([['id', '=', $id]])->find();
        $res = $model->delete();
        return $res;
    }

    

}

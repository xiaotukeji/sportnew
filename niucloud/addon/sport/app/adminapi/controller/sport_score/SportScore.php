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

namespace addon\sport\app\adminapi\controller\sport_score;

use core\base\BaseAdminController;
use addon\sport\app\service\admin\sport_score\SportScoreService;


/**
 * 比赛成绩控制器
 * Class SportScore
 * @package addon\sport\app\adminapi\controller\sport_score
 */
class SportScore extends BaseAdminController
{
   /**
    * 获取比赛成绩列表
    * @return \think\Response
    */
    public function lists(){
        $data = $this->request->params([
             ["match_id",""],
             ["athlete_id",""],
             ["team_id",""],
             ["score_type",""],
             ["score_value",""],
             ["unit",""],
             ["rank",""],
             ["referee_id",""],
             ["is_valid",""],
             ["sort",""],
             ["status",""],
             ["remark",""],
             ["create_time",""],
             ["update_time",""]
        ]);
        return success((new SportScoreService())->getPage($data));
    }

    /**
     * 比赛成绩详情
     * @param int $id
     * @return \think\Response
     */
    public function info(int $id){
        return success((new SportScoreService())->getInfo($id));
    }

    /**
     * 添加比赛成绩
     * @return \think\Response
     */
    public function add(){
        $data = $this->request->params([
             ["match_id",0],
             ["athlete_id",0],
             ["team_id",0],
             ["score_type",""],
             ["score_value",0.00],
             ["unit",""],
             ["rank",0],
             ["referee_id",0],
             ["is_valid",0],
             ["sort",0],
             ["status",0],
             ["remark",""],

        ]);
        $this->validate($data, 'addon\sport\app\validate\sport_score\SportScore.add');
        $id = (new SportScoreService())->add($data);
        return success('ADD_SUCCESS', ['id' => $id]);
    }

    /**
     * 比赛成绩编辑
     * @param $id  比赛成绩id
     * @return \think\Response
     */
    public function edit(int $id){
        $data = $this->request->params([
             ["match_id",0],
             ["athlete_id",0],
             ["team_id",0],
             ["score_type",""],
             ["score_value",0.00],
             ["unit",""],
             ["rank",0],
             ["referee_id",0],
             ["is_valid",0],
             ["sort",0],
             ["status",0],
             ["remark",""],

        ]);
        $this->validate($data, 'addon\sport\app\validate\sport_score\SportScore.edit');
        (new SportScoreService())->edit($id, $data);
        return success('EDIT_SUCCESS');
    }

    /**
     * 比赛成绩删除
     * @param $id  比赛成绩id
     * @return \think\Response
     */
    public function del(int $id){
        (new SportScoreService())->del($id);
        return success('DELETE_SUCCESS');
    }

    
}

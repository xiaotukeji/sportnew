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

namespace addon\sport\app\validate\sport_score;
use core\base\BaseValidate;
/**
 * 比赛成绩验证器
 * Class SportScore
 * @package addon\sport\app\validate\sport_score
 */
class SportScore extends BaseValidate
{

       protected $rule = [
            'match_id' => 'require',
            'score_type' => 'require',
            'score_value' => 'require',
            'referee_id' => 'require',
            'is_valid' => 'require',
            'sort' => 'require',
            'status' => 'require'
        ];

       protected $message = [
            'match_id.require' => ['common_validate.require', ['match_id']],
            'score_type.require' => ['common_validate.require', ['score_type']],
            'score_value.require' => ['common_validate.require', ['score_value']],
            'referee_id.require' => ['common_validate.require', ['referee_id']],
            'is_valid.require' => ['common_validate.require', ['is_valid']],
            'sort.require' => ['common_validate.require', ['sort']],
            'status.require' => ['common_validate.require', ['status']]
        ];

       protected $scene = [
            "add" => ['match_id', 'athlete_id', 'team_id', 'score_type', 'score_value', 'unit', 'rank', 'referee_id', 'is_valid', 'sort', 'status', 'remark'],
            "edit" => ['match_id', 'athlete_id', 'team_id', 'score_type', 'score_value', 'unit', 'rank', 'referee_id', 'is_valid', 'sort', 'status', 'remark']
        ];

}

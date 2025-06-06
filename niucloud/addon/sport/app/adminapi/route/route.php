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

use think\facade\Route;

use app\adminapi\middleware\AdminCheckRole;
use app\adminapi\middleware\AdminCheckToken;
use app\adminapi\middleware\AdminLog;

/**
 * 赛程助手
 */
Route::group('sport', function () {

     /***************************************************** hello world ****************************************************/
    Route::get('hello_world', 'addon\sport\app\adminapi\controller\hello_world\Index@index');

})->middleware([
    AdminCheckToken::class,
    AdminCheckRole::class,
    AdminLog::class
]);
// USER_CODE_BEGIN -- sport_category

Route::group('sport', function () {

    //项目大类列表
    Route::get('sport_category', 'addon\sport\app\adminapi\controller\sport_category\SportCategory@lists');
    //项目大类详情
    Route::get('sport_category/:id', 'addon\sport\app\adminapi\controller\sport_category\SportCategory@info');
    //添加项目大类
    Route::post('sport_category', 'addon\sport\app\adminapi\controller\sport_category\SportCategory@add');
    //编辑项目大类
    Route::put('sport_category/:id', 'addon\sport\app\adminapi\controller\sport_category\SportCategory@edit');
    //删除项目大类
    Route::delete('sport_category/:id', 'addon\sport\app\adminapi\controller\sport_category\SportCategory@del');
    
})->middleware([
    AdminCheckToken::class,
    AdminCheckRole::class,
    AdminLog::class
]);
// USER_CODE_END -- sport_category

// USER_CODE_BEGIN -- sport_athlete

Route::group('sport', function () {

    //参赛人员列表
    Route::get('sport_athlete', 'addon\sport\app\adminapi\controller\sport_athlete\SportAthlete@lists');
    //参赛人员详情
    Route::get('sport_athlete/:id', 'addon\sport\app\adminapi\controller\sport_athlete\SportAthlete@info');
    //添加参赛人员
    Route::post('sport_athlete', 'addon\sport\app\adminapi\controller\sport_athlete\SportAthlete@add');
    //编辑参赛人员
    Route::put('sport_athlete/:id', 'addon\sport\app\adminapi\controller\sport_athlete\SportAthlete@edit');
    //删除参赛人员
    Route::delete('sport_athlete/:id', 'addon\sport\app\adminapi\controller\sport_athlete\SportAthlete@del');
    
})->middleware([
    AdminCheckToken::class,
    AdminCheckRole::class,
    AdminLog::class
]);
// USER_CODE_END -- sport_athlete

// USER_CODE_BEGIN -- sport_base_item

Route::group('sport', function () {

    //基础项目列表
    Route::get('sport_base_item', 'addon\sport\app\adminapi\controller\sport_base_item\SportBaseItem@lists');
    //基础项目详情
    Route::get('sport_base_item/:id', 'addon\sport\app\adminapi\controller\sport_base_item\SportBaseItem@info');
    //添加基础项目
    Route::post('sport_base_item', 'addon\sport\app\adminapi\controller\sport_base_item\SportBaseItem@add');
    //编辑基础项目
    Route::put('sport_base_item/:id', 'addon\sport\app\adminapi\controller\sport_base_item\SportBaseItem@edit');
    //删除基础项目
    Route::delete('sport_base_item/:id', 'addon\sport\app\adminapi\controller\sport_base_item\SportBaseItem@del');
    
})->middleware([
    AdminCheckToken::class,
    AdminCheckRole::class,
    AdminLog::class
]);
// USER_CODE_END -- sport_base_item

// USER_CODE_BEGIN -- sport_event

Route::group('sport', function () {

    //赛事列表
    Route::get('sport_event', 'addon\sport\app\adminapi\controller\sport_event\SportEvent@lists');
    //赛事详情
    Route::get('sport_event/:id', 'addon\sport\app\adminapi\controller\sport_event\SportEvent@info');
    //添加赛事
    Route::post('sport_event', 'addon\sport\app\adminapi\controller\sport_event\SportEvent@add');
    //编辑赛事
    Route::put('sport_event/:id', 'addon\sport\app\adminapi\controller\sport_event\SportEvent@edit');
    //删除赛事
    Route::delete('sport_event/:id', 'addon\sport\app\adminapi\controller\sport_event\SportEvent@del');
    
})->middleware([
    AdminCheckToken::class,
    AdminCheckRole::class,
    AdminLog::class
]);
// USER_CODE_END -- sport_event

// USER_CODE_BEGIN -- sport_event_series

Route::group('sport', function () {

    //赛事系列列表
    Route::get('sport_event_series', 'addon\sport\app\adminapi\controller\sport_event_series\SportEventSeries@lists');
    //赛事系列详情
    Route::get('sport_event_series/:id', 'addon\sport\app\adminapi\controller\sport_event_series\SportEventSeries@info');
    //添加赛事系列
    Route::post('sport_event_series', 'addon\sport\app\adminapi\controller\sport_event_series\SportEventSeries@add');
    //编辑赛事系列
    Route::put('sport_event_series/:id', 'addon\sport\app\adminapi\controller\sport_event_series\SportEventSeries@edit');
    //删除赛事系列
    Route::delete('sport_event_series/:id', 'addon\sport\app\adminapi\controller\sport_event_series\SportEventSeries@del');
    
})->middleware([
    AdminCheckToken::class,
    AdminCheckRole::class,
    AdminLog::class
]);
// USER_CODE_END -- sport_event_series

// USER_CODE_BEGIN -- sport_item

Route::group('sport', function () {

    //比赛项目列表
    Route::get('sport_item', 'addon\sport\app\adminapi\controller\sport_item\SportItem@lists');
    //比赛项目详情
    Route::get('sport_item/:id', 'addon\sport\app\adminapi\controller\sport_item\SportItem@info');
    //添加比赛项目
    Route::post('sport_item', 'addon\sport\app\adminapi\controller\sport_item\SportItem@add');
    //编辑比赛项目
    Route::put('sport_item/:id', 'addon\sport\app\adminapi\controller\sport_item\SportItem@edit');
    //删除比赛项目
    Route::delete('sport_item/:id', 'addon\sport\app\adminapi\controller\sport_item\SportItem@del');
    
})->middleware([
    AdminCheckToken::class,
    AdminCheckRole::class,
    AdminLog::class
]);
// USER_CODE_END -- sport_item

// USER_CODE_BEGIN -- sport_event

Route::group('sport', function () {

    //赛事列表
    Route::get('sport_event', 'addon\sport\app\adminapi\controller\sport_event\SportEvent@lists');
    //赛事详情
    Route::get('sport_event/:id', 'addon\sport\app\adminapi\controller\sport_event\SportEvent@info');
    //添加赛事
    Route::post('sport_event', 'addon\sport\app\adminapi\controller\sport_event\SportEvent@add');
    //编辑赛事
    Route::put('sport_event/:id', 'addon\sport\app\adminapi\controller\sport_event\SportEvent@edit');
    //删除赛事
    Route::delete('sport_event/:id', 'addon\sport\app\adminapi\controller\sport_event\SportEvent@del');
    
})->middleware([
    AdminCheckToken::class,
    AdminCheckRole::class,
    AdminLog::class
]);
// USER_CODE_END -- sport_event

// USER_CODE_BEGIN -- sport_event

Route::group('sport', function () {

    //赛事列表
    Route::get('sport_event', 'addon\sport\app\adminapi\controller\sport_event\SportEvent@lists');
    //赛事详情
    Route::get('sport_event/:id', 'addon\sport\app\adminapi\controller\sport_event\SportEvent@info');
    //添加赛事
    Route::post('sport_event', 'addon\sport\app\adminapi\controller\sport_event\SportEvent@add');
    //编辑赛事
    Route::put('sport_event/:id', 'addon\sport\app\adminapi\controller\sport_event\SportEvent@edit');
    //删除赛事
    Route::delete('sport_event/:id', 'addon\sport\app\adminapi\controller\sport_event\SportEvent@del');
    
})->middleware([
    AdminCheckToken::class,
    AdminCheckRole::class,
    AdminLog::class
]);
// USER_CODE_END -- sport_event

// USER_CODE_BEGIN -- sport_nav_config

Route::group('sport', function () {

    //导航配置列表
    Route::get('sport_nav_config', 'addon\sport\app\adminapi\controller\sport_nav_config\SportNavConfig@lists');
    //导航配置详情
    Route::get('sport_nav_config/:id', 'addon\sport\app\adminapi\controller\sport_nav_config\SportNavConfig@info');
    //添加导航配置
    Route::post('sport_nav_config', 'addon\sport\app\adminapi\controller\sport_nav_config\SportNavConfig@add');
    //编辑导航配置
    Route::put('sport_nav_config/:id', 'addon\sport\app\adminapi\controller\sport_nav_config\SportNavConfig@edit');
    //删除导航配置
    Route::delete('sport_nav_config/:id', 'addon\sport\app\adminapi\controller\sport_nav_config\SportNavConfig@del');
    
})->middleware([
    AdminCheckToken::class,
    AdminCheckRole::class,
    AdminLog::class
]);
// USER_CODE_END -- sport_nav_config

// USER_CODE_BEGIN -- sport_organizer

Route::group('sport', function () {

    //主办方列表
    Route::get('sport_organizer', 'addon\sport\app\adminapi\controller\sport_organizer\SportOrganizer@lists');
    //主办方详情
    Route::get('sport_organizer/:id', 'addon\sport\app\adminapi\controller\sport_organizer\SportOrganizer@info');
    //添加主办方
    Route::post('sport_organizer', 'addon\sport\app\adminapi\controller\sport_organizer\SportOrganizer@add');
    //编辑主办方
    Route::put('sport_organizer/:id', 'addon\sport\app\adminapi\controller\sport_organizer\SportOrganizer@edit');
    //删除主办方
    Route::delete('sport_organizer/:id', 'addon\sport\app\adminapi\controller\sport_organizer\SportOrganizer@del');
    
})->middleware([
    AdminCheckToken::class,
    AdminCheckRole::class,
    AdminLog::class
]);
// USER_CODE_END -- sport_organizer

// USER_CODE_BEGIN -- sport_registration

Route::group('sport', function () {

    //报名记录列表
    Route::get('sport_registration', 'addon\sport\app\adminapi\controller\sport_registration\SportRegistration@lists');
    //报名记录详情
    Route::get('sport_registration/:id', 'addon\sport\app\adminapi\controller\sport_registration\SportRegistration@info');
    //添加报名记录
    Route::post('sport_registration', 'addon\sport\app\adminapi\controller\sport_registration\SportRegistration@add');
    //编辑报名记录
    Route::put('sport_registration/:id', 'addon\sport\app\adminapi\controller\sport_registration\SportRegistration@edit');
    //删除报名记录
    Route::delete('sport_registration/:id', 'addon\sport\app\adminapi\controller\sport_registration\SportRegistration@del');
    
})->middleware([
    AdminCheckToken::class,
    AdminCheckRole::class,
    AdminLog::class
]);
// USER_CODE_END -- sport_registration

// USER_CODE_BEGIN -- sport_score

Route::group('sport', function () {

    //比赛成绩列表
    Route::get('sport_score', 'addon\sport\app\adminapi\controller\sport_score\SportScore@lists');
    //比赛成绩详情
    Route::get('sport_score/:id', 'addon\sport\app\adminapi\controller\sport_score\SportScore@info');
    //添加比赛成绩
    Route::post('sport_score', 'addon\sport\app\adminapi\controller\sport_score\SportScore@add');
    //编辑比赛成绩
    Route::put('sport_score/:id', 'addon\sport\app\adminapi\controller\sport_score\SportScore@edit');
    //删除比赛成绩
    Route::delete('sport_score/:id', 'addon\sport\app\adminapi\controller\sport_score\SportScore@del');
    
})->middleware([
    AdminCheckToken::class,
    AdminCheckRole::class,
    AdminLog::class
]);
// USER_CODE_END -- sport_score

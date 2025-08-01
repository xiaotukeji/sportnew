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

use app\api\middleware\ApiCheckToken;
use app\api\middleware\ApiLog;
use app\api\middleware\ApiChannel;
use think\facade\Route;


/**
 * 赛程助手
 */
Route::group('sport', function() {
    /***************************************************** hello world ****************************************************/
    Route::get('hello_world', 'addon\sport\app\api\controller\hello_world\Index@index');

})->middleware(ApiChannel::class)
    ->middleware(ApiCheckToken::class, false) //false表示不验证登录
    ->middleware(ApiLog::class);



Route::group('sport', function() {

    /***************************************************** 赛事管理 ****************************************************/
    
    // 获取赛事列表
    Route::get('event', 'addon\sport\app\api\controller\event\Event@list');
    
    // 获取赛事详情
    Route::get('event/:id', 'addon\sport\app\api\controller\event\Event@info');
    
    // 添加赛事
    Route::post('event', 'addon\sport\app\api\controller\event\Event@add');
    
    // 编辑赛事
    Route::put('event/:id', 'addon\sport\app\api\controller\event\Event@edit');
    
    // 删除赛事
    Route::delete('event/:id', 'addon\sport\app\api\controller\event\Event@delete');
    
    // 获取赛事创建初始化数据
    Route::get('event/init', 'addon\sport\app\api\controller\event\Event@init');
    
    // 获取我的赛事列表
    Route::get('event/my-list', 'addon\sport\app\api\controller\event\Event@myList');
    
    // 更新赛事状态
    Route::put('event/:id/status', 'addon\sport\app\api\controller\event\Event@updateStatus');
    
    // 更新赛事设置
    Route::put('event/:id/settings', 'addon\sport\app\api\controller\event\Event@updateSettings');
    
    /***************************************************** 赛事项目管理 ****************************************************/
    
    // 获取运动分类列表（包含基础项目）
    Route::get('event/categories', 'addon\sport\app\api\controller\event\EventItem@categories');
    
    // 获取基础项目列表
    Route::get('event/base-items', 'addon\sport\app\api\controller\event\EventItem@baseItems');
    
    // 保存赛事项目选择
    Route::post('event/items/save', 'addon\sport\app\api\controller\event\EventItem@save');
    
    // 获取赛事已选择的项目
    Route::get('event/:event_id/items', 'addon\sport\app\api\controller\event\EventItem@getEventItems');
    
    // 更新项目设置
    Route::put('item/:id/settings', 'addon\sport\app\api\controller\event\EventItem@updateItemSettings');
    
    /***************************************************** 主办方管理 ****************************************************/
    
    // 获取用户主办方列表
    Route::get('organizer/list', 'addon\sport\app\api\controller\organizer\Organizer@list');
    
    // 添加主办方
    Route::post('organizer', 'addon\sport\app\api\controller\organizer\Organizer@add');
    
    /***************************************************** 系列赛管理 ****************************************************/
    
    // 获取用户系列赛列表
    Route::get('event-series/list', 'addon\sport\app\api\controller\series\EventSeries@list');
    
    // 添加系列赛
    Route::post('event-series', 'addon\sport\app\api\controller\series\EventSeries@add');

})->middleware(ApiChannel::class)
    ->middleware(ApiCheckToken::class, true) //表示验证登录
    ->middleware(ApiLog::class);


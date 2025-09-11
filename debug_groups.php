<?php
// 调试分组数据的简单脚本
require_once 'niucloud/vendor/autoload.php';

use think\facade\Db;

// 设置数据库配置
$config = [
    'default' => 'mysql',
    'connections' => [
        'mysql' => [
            'type' => 'mysql',
            'hostname' => '127.0.0.1',
            'database' => 'sportnew', // 请根据实际情况修改数据库名
            'username' => 'root',     // 请根据实际情况修改用户名
            'password' => '',         // 请根据实际情况修改密码
            'hostport' => '3306',
            'charset' => 'utf8mb4',
        ]
    ]
];

// 初始化数据库连接
Db::setConfig($config);

try {
    // 查询所有赛事的分组数据
    $groups = Db::table('sport_event_groups')
        ->order('event_id asc, sort asc')
        ->select();
    
    echo "=== 分组数据调试 ===\n";
    echo "总分组数量: " . count($groups) . "\n\n";
    
    foreach ($groups as $group) {
        echo "赛事ID: {$group['event_id']}\n";
        echo "分组ID: {$group['id']}\n";
        echo "分组名称: {$group['group_name']}\n";
        echo "分组类型: {$group['group_type']}\n";
        echo "排序: {$group['sort']}\n";
        echo "状态: {$group['status']}\n";
        echo "创建时间: " . date('Y-m-d H:i:s', $group['create_time']) . "\n";
        echo "更新时间: " . date('Y-m-d H:i:s', $group['update_time']) . "\n";
        echo "---\n";
    }
    
    // 查询最新的几个赛事
    $events = Db::table('sport_event')
        ->order('id desc')
        ->limit(5)
        ->select();
    
    echo "\n=== 最新赛事列表 ===\n";
    foreach ($events as $event) {
        echo "赛事ID: {$event['id']}, 赛事名称: {$event['name']}\n";
    }
    
} catch (Exception $e) {
    echo "错误: " . $e->getMessage() . "\n";
}
?>

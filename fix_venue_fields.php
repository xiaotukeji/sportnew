<?php
/**
 * 修复sport_venue表字段问题
 */

// 引入ThinkPHP框架
require_once __DIR__ . '/niucloud/vendor/autoload.php';

// 加载ThinkPHP
$app = new \think\App();
$app->initialize();

try {
    // 使用ThinkPHP的数据库连接
    $db = \think\facade\Db::connect();
    
    echo "数据库连接成功\n";
    
    // 1. 检查venue_type字段是否存在
    $columns = $db->query("SHOW COLUMNS FROM sport_venue LIKE 'venue_type'");
    $venueTypeExists = !empty($columns);
    
    if (!$venueTypeExists) {
        echo "添加venue_type字段...\n";
        $db->execute("ALTER TABLE `sport_venue` ADD COLUMN `venue_type` varchar(50) NOT NULL DEFAULT '' COMMENT '场地类型编码，如：pingpong_table, badminton_court' AFTER `venue_category`");
        echo "venue_type字段添加成功\n";
    } else {
        echo "venue_type字段已存在\n";
    }
    
    // 2. 从type字段复制数据到venue_type
    echo "更新venue_type字段数据...\n";
    $affectedRows = $db->execute("UPDATE `sport_venue` SET `venue_type` = `type` WHERE `venue_type` = '' OR `venue_type` IS NULL");
    echo "更新了 {$affectedRows} 条记录的venue_type字段\n";
    
    // 3. 从type字段复制数据到venue_category
    echo "更新venue_category字段数据...\n";
    $affectedRows = $db->execute("UPDATE `sport_venue` SET `venue_category` = `type` WHERE `venue_category` = '' OR `venue_category` IS NULL");
    echo "更新了 {$affectedRows} 条记录的venue_category字段\n";
    
    // 4. 检查venue_type索引是否存在
    $indexes = $db->query("SHOW INDEX FROM sport_venue WHERE Key_name = 'idx_venue_type'");
    $venueTypeIndexExists = !empty($indexes);
    
    if (!$venueTypeIndexExists) {
        echo "添加venue_type索引...\n";
        $db->execute("ALTER TABLE `sport_venue` ADD KEY `idx_venue_type` (`venue_type`)");
        echo "venue_type索引添加成功\n";
    } else {
        echo "venue_type索引已存在\n";
    }
    
    // 5. 显示修复结果
    echo "\n修复结果统计:\n";
    $result = $db->query("SELECT 
        COUNT(*) as total_venues,
        COUNT(CASE WHEN venue_type != '' THEN 1 END) as venues_with_type,
        COUNT(CASE WHEN venue_category != '' THEN 1 END) as venues_with_category
    FROM `sport_venue`")[0];
    
    echo "总场地数: {$result['total_venues']}\n";
    echo "有venue_type的场地数: {$result['venues_with_type']}\n";
    echo "有venue_category的场地数: {$result['venues_with_category']}\n";
    
    // 6. 显示表结构
    echo "\n当前sport_venue表结构:\n";
    $columns = $db->query("DESCRIBE sport_venue");
    foreach ($columns as $row) {
        echo "{$row['Field']} - {$row['Type']} - {$row['Comment']}\n";
    }
    
    echo "\n修复完成！\n";
    
} catch (Exception $e) {
    echo "错误: " . $e->getMessage() . "\n";
    echo "错误文件: " . $e->getFile() . "\n";
    echo "错误行号: " . $e->getLine() . "\n";
}
?> 
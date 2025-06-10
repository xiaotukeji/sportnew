<?php
// Sport插件赛事查询调试脚本
// 用于测试数据库查询逻辑

// 直接查询数据库
echo "=== Sport Event 数据库查询调试 ===\n\n";

// 1. 查询所有赛事数据
echo "1. 查询所有赛事数据:\n";
$sql1 = "SELECT id, name, member_id, organizer_id, status FROM sport_event";
echo "SQL: $sql1\n";
echo "请在数据库中执行上述SQL，查看所有赛事数据\n\n";

// 2. 查询member_id=1的赛事
echo "2. 查询member_id=1的赛事:\n";
$sql2 = "SELECT id, name, member_id, organizer_id, status FROM sport_event WHERE member_id = 1";
echo "SQL: $sql2\n";
echo "请在数据库中执行上述SQL，查看结果\n\n";

// 3. 查询organizer表数据
echo "3. 查询organizer表数据:\n";
$sql3 = "SELECT id, organizer_name, member_id FROM sport_organizer";
echo "SQL: $sql3\n";
echo "请在数据库中执行上述SQL，查看主办方数据\n\n";

// 4. 关联查询测试
echo "4. 关联查询测试:\n";
$sql4 = "SELECT se.id, se.name, se.member_id as event_member_id, so.organizer_name, so.member_id as organizer_member_id 
         FROM sport_event se 
         LEFT JOIN sport_organizer so ON se.organizer_id = so.id 
         WHERE se.member_id = 1";
echo "SQL: $sql4\n";
echo "请在数据库中执行上述SQL，验证关联查询\n\n";

echo "=== 测试建议 ===\n";
echo "1. 确认当前登录的用户ID是多少\n";
echo "2. 检查sport_event表中的member_id字段值是否正确\n";
echo "3. 确认API调用时的用户认证状态\n";
echo "4. 查看后端日志中的调试信息\n";
?> 
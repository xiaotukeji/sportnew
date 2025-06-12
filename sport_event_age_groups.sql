-- 赛事表添加年龄组支持
-- 执行时间：2024-03-21

-- 添加年龄组相关字段
ALTER TABLE `sport_event` 
ADD COLUMN `age_groups` TEXT COMMENT '年龄组设置，JSON格式存储多选：["青少年","成年","老年"]' AFTER `status`,
ADD COLUMN `age_group_display` TINYINT(1) DEFAULT 1 COMMENT '是否显示年龄组前缀：0=不显示 1=显示（当选择多个年龄组时自动显示）' AFTER `age_groups`;

-- 为现有数据设置默认值
UPDATE `sport_event` SET 
    `age_groups` = '["不限年龄"]',
    `age_group_display` = 0
WHERE `age_groups` IS NULL;

-- 添加年龄组配置示例
INSERT INTO `sport_event` (`name`, `description`, `start_time`, `end_time`, `registration_start_time`, `registration_end_time`, `location_name`, `location_detail`, `latitude`, `longitude`, `organizer_id`, `series_id`, `poster`, `age_groups`, `age_group_display`, `status`, `member_id`, `create_time`, `update_time`) VALUES
('2024年春季游泳锦标赛', '面向青少年和成年人的游泳比赛', UNIX_TIMESTAMP('2024-05-01 09:00:00'), UNIX_TIMESTAMP('2024-05-03 18:00:00'), UNIX_TIMESTAMP('2024-03-15 00:00:00'), UNIX_TIMESTAMP('2024-04-15 23:59:59'), '市体育中心游泳馆', '一楼比赛大厅', 31.230390, 121.473701, 1, 1, '', '["青少年","成年"]', 1, 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('2024年全民健身游泳赛', '不限年龄的全民参与游泳比赛', UNIX_TIMESTAMP('2024-06-01 09:00:00'), UNIX_TIMESTAMP('2024-06-02 18:00:00'), UNIX_TIMESTAMP('2024-04-15 00:00:00'), UNIX_TIMESTAMP('2024-05-15 23:59:59'), '区游泳中心', '标准50米泳池', 31.240390, 121.483701, 1, 1, '', '["不限年龄"]', 0, 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 查看年龄组配置说明
SELECT '=== 年龄组配置说明 ===' AS info;
SELECT 
    '年龄组字段说明：
    age_groups: JSON格式存储，支持多选
    - ["不限年龄"] - 不显示年龄前缀
    - ["青少年"] - 单一年龄组，不显示前缀  
    - ["青少年","成年"] - 多个年龄组，显示前缀
    - ["青少年","成年","老年"] - 三个年龄组，显示前缀
    
    age_group_display: 控制显示逻辑
    - 0: 不显示年龄前缀（不限年龄或单一年龄组）
    - 1: 显示年龄前缀（多个年龄组时）
    
    项目名称生成逻辑：
    - 不显示前缀：男子100米自由泳、女子100米自由泳
    - 显示前缀：青少年男子100米自由泳、成年男子100米自由泳
    ' AS description; 
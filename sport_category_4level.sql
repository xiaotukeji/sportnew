-- 四级分类结构扩展脚本
-- 支持：一级大类 -> 二级子类 -> 三级项目 -> 四级具体项目
-- 执行时间：2024-03-21

-- 清空现有分类数据，重新建立四级结构
TRUNCATE TABLE `sport_category`;

-- ============================================
-- 一级分类（12个大类）
-- ============================================
INSERT INTO `sport_category` (`id`, `name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
(1, '田径类', 'track_field', 0, 1, '1', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(2, '球类', 'ball_sports', 0, 1, '2', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(3, '水上运动', 'water_sports', 0, 1, '3', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(4, '体操类', 'gymnastics', 0, 1, '4', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(5, '武术类', 'martial_arts', 0, 1, '5', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '极限运动', 'extreme_sports', 0, 1, '6', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(7, '冰雪运动', 'ice_snow_sports', 0, 1, '7', 7, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(8, '格斗类', 'combat_sports', 0, 1, '8', 8, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(9, '射击类', 'shooting', 0, 1, '9', 9, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(10, '棋类', 'chess', 0, 1, '10', 10, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '趣味比赛', 'fun_sports', 0, 1, '11', 11, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(12, '其他', 'others', 0, 1, '12', 12, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ============================================
-- 二级分类（主要运动项目）
-- ============================================

-- 水上运动的二级分类
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('游泳', 'swimming', 3, 2, '3', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('跳水', 'diving', 3, 2, '3', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('水球', 'water_polo', 3, 2, '3', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('花样游泳', 'synchronized_swimming', 3, 2, '3', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 田径类的二级分类  
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('径赛', 'track_events', 1, 2, '1', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('田赛', 'field_events', 1, 2, '1', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('全能', 'combined_events', 1, 2, '1', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 球类的二级分类
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('大球', 'big_ball', 2, 2, '2', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('小球', 'small_ball', 2, 2, '2', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ============================================
-- 三级分类（具体运动种类）
-- ============================================

-- 游泳的三级分类
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
-- 假设游泳的category_id是13
('自由泳', 'freestyle', (SELECT id FROM sport_category WHERE code='swimming'), 3, '3', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('仰泳', 'backstroke', (SELECT id FROM sport_category WHERE code='swimming'), 3, '3', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('蛙泳', 'breaststroke', (SELECT id FROM sport_category WHERE code='swimming'), 3, '3', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('蝶泳', 'butterfly', (SELECT id FROM sport_category WHERE code='swimming'), 3, '3', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('混合泳', 'medley', (SELECT id FROM sport_category WHERE code='swimming'), 3, '3', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('接力', 'relay', (SELECT id FROM sport_category WHERE code='swimming'), 3, '3', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 径赛的三级分类
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('短跑', 'sprint', (SELECT id FROM sport_category WHERE code='track_events'), 3, '1', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('中跑', 'middle_distance', (SELECT id FROM sport_category WHERE code='track_events'), 3, '1', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('长跑', 'long_distance', (SELECT id FROM sport_category WHERE code='track_events'), 3, '1', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('跨栏', 'hurdles', (SELECT id FROM sport_category WHERE code='track_events'), 3, '1', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('接力', 'track_relay', (SELECT id FROM sport_category WHERE code='track_events'), 3, '1', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 田赛的三级分类
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('跳跃', 'jumping', (SELECT id FROM sport_category WHERE code='field_events'), 3, '1', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('投掷', 'throwing', (SELECT id FROM sport_category WHERE code='field_events'), 3, '1', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 大球的三级分类
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('足球', 'football', (SELECT id FROM sport_category WHERE code='big_ball'), 3, '2', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('篮球', 'basketball', (SELECT id FROM sport_category WHERE code='big_ball'), 3, '2', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('排球', 'volleyball', (SELECT id FROM sport_category WHERE code='big_ball'), 3, '2', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 小球的三级分类
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('乒乓球', 'table_tennis', (SELECT id FROM sport_category WHERE code='small_ball'), 3, '2', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('羽毛球', 'badminton', (SELECT id FROM sport_category WHERE code='small_ball'), 3, '2', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('网球', 'tennis', (SELECT id FROM sport_category WHERE code='small_ball'), 3, '2', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 查看四级结构
SELECT '=== 四级分类结构预览 ===' AS info;
SELECT 
    CASE level 
        WHEN 1 THEN CONCAT('【', name, '】')
        WHEN 2 THEN CONCAT('  ├─ ', name)
        WHEN 3 THEN CONCAT('    ├─ ', name)
        ELSE CONCAT('      └─ ', name)
    END AS category_tree,
    level,
    parent_id,
    code
FROM sport_category 
ORDER BY path, sort, level; 
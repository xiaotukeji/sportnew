-- 灵活分类结构设计
-- 支持2-4级不等的分类深度
-- 执行时间：2024-03-21

-- 清空现有分类数据，重新建立灵活结构
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
-- 二级分类（灵活设计）
-- ============================================

-- 【四级结构】水上运动的二级分类
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('游泳', 'swimming', 3, 2, '3', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('跳水', 'diving', 3, 2, '3', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('水球', 'water_polo', 3, 2, '3', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('花样游泳', 'synchronized_swimming', 3, 2, '3', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 【四级结构】田径类的二级分类  
('径赛', 'track_events', 1, 2, '1', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('田赛', 'field_events', 1, 2, '1', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('全能', 'combined_events', 1, 2, '1', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 【三级结构】球类的二级分类
('大球', 'big_ball', 2, 2, '2', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('小球', 'small_ball', 2, 2, '2', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 【二级结构】棋类直接挂项目（不需要三级）
-- 棋类没有二级分类，直接在一级下挂基础项目

-- 【二级结构】趣味比赛直接挂项目
-- 趣味比赛没有二级分类，直接在一级下挂基础项目

-- 【三级结构】体操类的二级分类
('竞技体操', 'artistic_gymnastics', 4, 2, '4', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('艺术体操', 'rhythmic_gymnastics', 4, 2, '4', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('蹦床', 'trampoline', 4, 2, '4', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 【三级结构】武术类的二级分类
('套路', 'taolu', 5, 2, '5', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('散打', 'sanda', 5, 2, '5', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('推手', 'tuishou', 5, 2, '5', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ============================================
-- 三级分类（按需设计）
-- ============================================

-- 【四级结构】游泳的三级分类
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('自由泳', 'freestyle', (SELECT id FROM sport_category WHERE code='swimming'), 3, '3', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('仰泳', 'backstroke', (SELECT id FROM sport_category WHERE code='swimming'), 3, '3', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('蛙泳', 'breaststroke', (SELECT id FROM sport_category WHERE code='swimming'), 3, '3', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('蝶泳', 'butterfly', (SELECT id FROM sport_category WHERE code='swimming'), 3, '3', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('混合泳', 'medley', (SELECT id FROM sport_category WHERE code='swimming'), 3, '3', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('接力', 'relay', (SELECT id FROM sport_category WHERE code='swimming'), 3, '3', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 【四级结构】径赛的三级分类
('短跑', 'sprint', (SELECT id FROM sport_category WHERE code='track_events'), 3, '1', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('中跑', 'middle_distance', (SELECT id FROM sport_category WHERE code='track_events'), 3, '1', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('长跑', 'long_distance', (SELECT id FROM sport_category WHERE code='track_events'), 3, '1', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('跨栏', 'hurdles', (SELECT id FROM sport_category WHERE code='track_events'), 3, '1', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('接力', 'track_relay', (SELECT id FROM sport_category WHERE code='track_events'), 3, '1', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 【四级结构】田赛的三级分类
('跳跃', 'jumping', (SELECT id FROM sport_category WHERE code='field_events'), 3, '1', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('投掷', 'throwing', (SELECT id FROM sport_category WHERE code='field_events'), 3, '1', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 【三级结构】大球的三级分类（最终级别，挂基础项目）
('足球', 'football', (SELECT id FROM sport_category WHERE code='big_ball'), 3, '2', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('篮球', 'basketball', (SELECT id FROM sport_category WHERE code='big_ball'), 3, '2', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('排球', 'volleyball', (SELECT id FROM sport_category WHERE code='big_ball'), 3, '2', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 【三级结构】小球的三级分类（最终级别，挂基础项目）
('乒乓球', 'table_tennis', (SELECT id FROM sport_category WHERE code='small_ball'), 3, '2', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('羽毛球', 'badminton', (SELECT id FROM sport_category WHERE code='small_ball'), 3, '2', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('网球', 'tennis', (SELECT id FROM sport_category WHERE code='small_ball'), 3, '2', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 【三级结构】竞技体操的三级分类（最终级别，挂基础项目）
('自由体操', 'floor_exercise', (SELECT id FROM sport_category WHERE code='artistic_gymnastics'), 3, '4', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('鞍马', 'pommel_horse', (SELECT id FROM sport_category WHERE code='artistic_gymnastics'), 3, '4', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('吊环', 'rings', (SELECT id FROM sport_category WHERE code='artistic_gymnastics'), 3, '4', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('跳马', 'vault', (SELECT id FROM sport_category WHERE code='artistic_gymnastics'), 3, '4', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('双杠', 'parallel_bars', (SELECT id FROM sport_category WHERE code='artistic_gymnastics'), 3, '4', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('单杠', 'horizontal_bar', (SELECT id FROM sport_category WHERE code='artistic_gymnastics'), 3, '4', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('高低杠', 'uneven_bars', (SELECT id FROM sport_category WHERE code='artistic_gymnastics'), 3, '4', 7, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('平衡木', 'balance_beam', (SELECT id FROM sport_category WHERE code='artistic_gymnastics'), 3, '4', 8, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ============================================
-- 查看灵活分类结构
-- ============================================
SELECT '=== 灵活分类结构展示 ===' AS info;

-- 显示不同深度的分类结构
SELECT 
    '【分类深度说明】
    四级结构：水上运动 → 游泳 → 自由泳 → 男子100米自由泳
    三级结构：球类 → 大球 → 足球 → 男子组
    二级结构：棋类 → 中国象棋 → 不分组别
    ' as structure_info;

-- 按分类展示结构
SELECT 
    CASE 
        WHEN level = 1 THEN CONCAT('【', name, '】')
        WHEN level = 2 THEN CONCAT('  ├─ ', name)
        WHEN level = 3 THEN CONCAT('    ├─ ', name)
        ELSE CONCAT('      └─ ', name)
    END AS category_tree,
    CONCAT('(', level, '级)') as level_info,
    CASE 
        WHEN level = 1 AND id IN (10, 11) THEN '→ 直接挂基础项目'
        WHEN level = 2 AND id IN (SELECT id FROM sport_category WHERE parent_id IN (4, 5) AND level = 2) THEN '→ 三级结构'
        WHEN level = 2 AND parent_id = 3 THEN '→ 四级结构' 
        WHEN level = 3 AND parent_id IN (SELECT id FROM sport_category WHERE parent_id = 3) THEN '→ 四级结构'
        WHEN level = 3 THEN '→ 最终级别'
        ELSE ''
    END as structure_type
FROM sport_category 
ORDER BY path, sort, level; 
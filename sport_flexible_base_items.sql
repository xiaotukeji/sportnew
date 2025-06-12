-- 灵活基础项目数据
-- 适配不同深度的分类结构
-- 执行时间：2024-03-21

-- 清空现有基础项目数据
TRUNCATE TABLE `sport_base_item`;

-- ============================================
-- 【四级结构】水上运动项目
-- ============================================

-- 自由泳项目（挂在三级分类下，将生成四级项目）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES

-- 男子自由泳
((SELECT id FROM sport_category WHERE code='freestyle'), '男子50米自由泳', 'male_50m_freestyle', 1, 1, '青少年', '男子50米自由泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='freestyle'), '男子100米自由泳', 'male_100m_freestyle', 1, 1, '青少年', '男子100米自由泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='freestyle'), '男子200米自由泳', 'male_200m_freestyle', 1, 1, '青少年', '男子200米自由泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 女子自由泳
((SELECT id FROM sport_category WHERE code='freestyle'), '女子50米自由泳', 'female_50m_freestyle', 1, 2, '青少年', '女子50米自由泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 11, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='freestyle'), '女子100米自由泳', 'female_100m_freestyle', 1, 2, '青少年', '女子100米自由泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 12, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='freestyle'), '女子200米自由泳', 'female_200m_freestyle', 1, 2, '青少年', '女子200米自由泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 13, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 仰泳项目
((SELECT id FROM sport_category WHERE code='backstroke'), '男子100米仰泳', 'male_100m_backstroke', 1, 1, '青少年', '男子100米仰泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 21, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='backstroke'), '女子100米仰泳', 'female_100m_backstroke', 1, 2, '青少年', '女子100米仰泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 22, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 蛙泳项目
((SELECT id FROM sport_category WHERE code='breaststroke'), '男子100米蛙泳', 'male_100m_breaststroke', 1, 1, '青少年', '男子100米蛙泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 31, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='breaststroke'), '女子100米蛙泳', 'female_100m_breaststroke', 1, 2, '青少年', '女子100米蛙泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 32, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 蝶泳项目
((SELECT id FROM sport_category WHERE code='butterfly'), '男子100米蝶泳', 'male_100m_butterfly', 1, 1, '青少年', '男子100米蝶泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 41, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='butterfly'), '女子100米蝶泳', 'female_100m_butterfly', 1, 2, '青少年', '女子100米蝶泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 42, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ============================================
-- 【四级结构】田径短跑项目
-- ============================================

-- 短跑项目（挂在三级分类下）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
-- 男子短跑
((SELECT id FROM sport_category WHERE code='sprint'), '男子100米', 'male_100m_sprint', 1, 1, '青少年', '男子100米短跑项目', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 51, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='sprint'), '男子200米', 'male_200m_sprint', 1, 1, '青少年', '男子200米短跑项目', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 52, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 女子短跑
((SELECT id FROM sport_category WHERE code='sprint'), '女子100米', 'female_100m_sprint', 1, 2, '青少年', '女子100米短跑项目', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 53, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='sprint'), '女子200米', 'female_200m_sprint', 1, 2, '青少年', '女子200米短跑项目', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 54, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ============================================
-- 【三级结构】球类项目
-- ============================================

-- 足球项目（挂在三级分类下，最终级别）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
((SELECT id FROM sport_category WHERE code='football'), '男子足球', 'male_football', 2, 1, '青少年', '男子11人制足球比赛', 'FIFA标准规则', '足球、球衣、护腿板', '标准足球场', 101, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='football'), '女子足球', 'female_football', 2, 2, '青少年', '女子11人制足球比赛', 'FIFA标准规则', '足球、球衣、护腿板', '标准足球场', 102, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='football'), '混合足球', 'mixed_football', 2, 3, '青少年', '男女混合足球比赛', 'FIFA标准规则', '足球、球衣、护腿板', '标准足球场', 103, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 篮球项目
((SELECT id FROM sport_category WHERE code='basketball'), '男子篮球', 'male_basketball', 2, 1, '青少年', '男子5人制篮球比赛', 'FIBA标准规则', '篮球、球衣、篮球鞋', '标准篮球场', 111, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='basketball'), '女子篮球', 'female_basketball', 2, 2, '青少年', '女子5人制篮球比赛', 'FIBA标准规则', '篮球、球衣、篮球鞋', '标准篮球场', 112, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='basketball'), '混合篮球', 'mixed_basketball', 2, 3, '青少年', '男女混合篮球比赛', 'FIBA标准规则', '篮球、球衣、篮球鞋', '标准篮球场', 113, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 乒乓球项目
((SELECT id FROM sport_category WHERE code='table_tennis'), '男子单打', 'male_table_tennis_singles', 1, 1, '青少年', '男子乒乓球单打比赛', 'ITTF标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 121, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='table_tennis'), '女子单打', 'female_table_tennis_singles', 1, 2, '青少年', '女子乒乓球单打比赛', 'ITTF标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 122, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='table_tennis'), '男子双打', 'male_table_tennis_doubles', 2, 1, '青少年', '男子乒乓球双打比赛', 'ITTF标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 123, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='table_tennis'), '女子双打', 'female_table_tennis_doubles', 2, 2, '青少年', '女子乒乓球双打比赛', 'ITTF标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 124, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='table_tennis'), '混合双打', 'mixed_table_tennis_doubles', 2, 3, '青少年', '混合乒乓球双打比赛', 'ITTF标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 125, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ============================================
-- 【三级结构】体操项目
-- ============================================

-- 体操项目（挂在三级分类下，最终级别）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
((SELECT id FROM sport_category WHERE code='floor_exercise'), '男子自由体操', 'male_floor_exercise', 1, 1, '青少年', '男子自由体操项目', 'FIG标准规则', '体操服、体操鞋', '标准体操垫', 201, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='floor_exercise'), '女子自由体操', 'female_floor_exercise', 1, 2, '青少年', '女子自由体操项目', 'FIG标准规则', '体操服、体操鞋', '标准体操垫', 202, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

((SELECT id FROM sport_category WHERE code='pommel_horse'), '男子鞍马', 'male_pommel_horse', 1, 1, '青少年', '男子鞍马项目', 'FIG标准规则', '体操服、体操鞋', '标准鞍马', 211, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

((SELECT id FROM sport_category WHERE code='rings'), '男子吊环', 'male_rings', 1, 1, '青少年', '男子吊环项目', 'FIG标准规则', '体操服、体操鞋', '标准吊环', 221, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ============================================
-- 【二级结构】棋类项目（直接挂在一级分类下）
-- ============================================

-- 棋类项目（直接挂在一级分类下）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(10, '中国象棋', 'chinese_chess', 1, 3, '青少年', '中国象棋比赛', '中国象棋协会标准规则', '象棋棋盘、象棋子', '标准比赛桌椅', 301, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(10, '国际象棋', 'international_chess', 1, 3, '青少年', '国际象棋比赛', '国际象棋联合会标准规则', '国际象棋棋盘、棋子', '标准比赛桌椅', 302, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(10, '围棋', 'go', 1, 3, '青少年', '围棋比赛', '中国围棋协会标准规则', '围棋棋盘、围棋子', '标准比赛桌椅', 303, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(10, '国际跳棋', 'international_checkers', 1, 3, '青少年', '国际跳棋比赛', '国际跳棋联合会标准规则', '国际跳棋棋盘、棋子', '标准比赛桌椅', 304, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(10, '五子棋', 'gomoku', 1, 3, '青少年', '五子棋比赛', '五子棋协会标准规则', '五子棋棋盘、棋子', '标准比赛桌椅', 305, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ============================================
-- 【二级结构】趣味比赛项目（直接挂在一级分类下）
-- ============================================

-- 趣味比赛项目（直接挂在一级分类下）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(11, '拔河比赛', 'tug_of_war', 2, 3, '青少年', '团队拔河比赛', '国际拔河协会标准规则', '拔河绳、标志线', '平坦场地', 401, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '三人四足', 'three_legged_race', 2, 3, '青少年', '三人四足接力赛', '趣味运动标准规则', '绑腿绳', '平坦跑道', 402, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '袋鼠跳', 'sack_race', 1, 3, '青少年', '袋鼠跳比赛', '趣味运动标准规则', '麻袋或布袋', '平坦跑道', 403, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '背夹球接力', 'back_to_back_ball_relay', 2, 3, '青少年', '背夹球接力比赛', '趣味运动标准规则', '气球或排球', '平坦场地', 404, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '运球跑', 'ball_dribbling_race', 1, 3, '青少年', '运球跑比赛', '趣味运动标准规则', '篮球或足球', '平坦跑道', 405, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '抱团游戏', 'group_hug_game', 2, 3, '青少年', '抱团游戏', '趣味运动标准规则', '无', '开阔场地', 406, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '踢毽子', 'shuttlecock_kicking', 1, 3, '青少年', '踢毽子比赛', '毽球协会标准规则', '毽子', '平坦场地', 407, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '滚铁环', 'iron_ring_rolling', 1, 3, '青少年', '滚铁环比赛', '传统体育项目规则', '铁环、推环棍', '平坦道路', 408, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '跳绳比赛', 'rope_jumping', 1, 3, '青少年', '跳绳比赛', '跳绳协会标准规则', '跳绳', '平坦场地', 409, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ============================================
-- 数据统计
-- ============================================
SELECT '=== 灵活基础项目统计 ===' AS info;

-- 按分类结构统计项目数量
SELECT 
    c.name AS category_name,
    c.level AS category_level,
    COUNT(b.id) AS item_count,
    CASE c.level
        WHEN 1 THEN '直接挂项目（二级结构）'
        WHEN 2 THEN '三级结构的最终级别'
        WHEN 3 THEN '四级结构的最终级别'
        ELSE '其他'
    END AS structure_type
FROM sport_category c
LEFT JOIN sport_base_item b ON c.id = b.category_id
WHERE c.id IN (SELECT DISTINCT category_id FROM sport_base_item WHERE category_id IS NOT NULL)
   OR c.id IN (10, 11)  -- 包含棋类和趣味比赛
GROUP BY c.id, c.name, c.level
ORDER BY c.level, c.sort;

-- 总体统计
SELECT 
    CONCAT('总项目数: ', COUNT(*)) as total_items,
    CONCAT('四级结构项目: ', SUM(CASE WHEN category_id IN (SELECT id FROM sport_category WHERE level = 3) THEN 1 ELSE 0 END)) as level4_items,
    CONCAT('三级结构项目: ', SUM(CASE WHEN category_id IN (SELECT id FROM sport_category WHERE level = 3 AND parent_id NOT IN (SELECT id FROM sport_category WHERE parent_id = 3)) THEN 1 ELSE 0 END)) as level3_items,
    CONCAT('二级结构项目: ', SUM(CASE WHEN category_id IN (10, 11) THEN 1 ELSE 0 END)) as level2_items
FROM sport_base_item; 
-- Sport插件灵活分类结构升级脚本（简化稳定版）
-- 支持2-4级不等的分类深度，智能适配不同运动项目特点
-- 执行时间：2024-03-21

-- ============================================
-- 数据备份
-- ============================================
SELECT '=== 开始备份现有数据 ===' AS info;

-- 备份现有分类数据
DROP TABLE IF EXISTS `sport_category_backup`;
CREATE TABLE `sport_category_backup` LIKE `sport_category`;
INSERT INTO `sport_category_backup` SELECT * FROM `sport_category`;

-- 备份现有基础项目数据
DROP TABLE IF EXISTS `sport_base_item_backup`;
CREATE TABLE `sport_base_item_backup` LIKE `sport_base_item`;
INSERT INTO `sport_base_item_backup` SELECT * FROM `sport_base_item`;

SELECT '数据备份完成' AS backup_status;

-- ============================================
-- 清空现有数据，重建灵活结构
-- ============================================
SELECT '=== 重建灵活分类结构 ===' AS info;

-- 清空数据并重置AUTO_INCREMENT
DELETE FROM `sport_base_item`;
DELETE FROM `sport_category`;
ALTER TABLE `sport_category` AUTO_INCREMENT = 1;
ALTER TABLE `sport_base_item` AUTO_INCREMENT = 1;

-- ============================================
-- 一级分类（12个大类）
-- ============================================
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('田径类', 'track_field', 0, 1, '1', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('球类', 'ball_sports', 0, 1, '2', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('水上运动', 'water_sports', 0, 1, '3', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('体操类', 'gymnastics', 0, 1, '4', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('武术类', 'martial_arts', 0, 1, '5', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('极限运动', 'extreme_sports', 0, 1, '6', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('冰雪运动', 'ice_snow_sports', 0, 1, '7', 7, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('格斗类', 'combat_sports', 0, 1, '8', 8, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('射击类', 'shooting', 0, 1, '9', 9, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('棋类', 'chess', 0, 1, '10', 10, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('趣味比赛', 'fun_sports', 0, 1, '11', 11, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('其他', 'others', 0, 1, '12', 12, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ============================================
-- 二级分类（分批插入，避免复杂查询）
-- ============================================

-- 【四级结构】水上运动的二级分类（parent_id=3）
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('游泳', 'swimming', 3, 2, '3', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('跳水', 'diving', 3, 2, '3', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('水球', 'water_polo', 3, 2, '3', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('花样游泳', 'synchronized_swimming', 3, 2, '3', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 【四级结构】田径类的二级分类（parent_id=1）
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('径赛', 'track_events', 1, 2, '1', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('田赛', 'field_events', 1, 2, '1', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('全能', 'combined_events', 1, 2, '1', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 【三级结构】球类的二级分类（parent_id=2）
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('大球', 'big_ball', 2, 2, '2', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('小球', 'small_ball', 2, 2, '2', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 【三级结构】体操类的二级分类（parent_id=4）
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('竞技体操', 'artistic_gymnastics', 4, 2, '4', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('艺术体操', 'rhythmic_gymnastics', 4, 2, '4', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('蹦床', 'trampoline', 4, 2, '4', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 【三级结构】武术类的二级分类（parent_id=5）
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('套路', 'taolu', 5, 2, '5', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('散打', 'sanda', 5, 2, '5', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('推手', 'tuishou', 5, 2, '5', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ============================================
-- 三级分类（使用固定ID，避免查询）
-- ============================================

-- 【四级结构】游泳的三级分类（parent_id预计为13）
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('自由泳', 'freestyle', 13, 3, '3,13', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('仰泳', 'backstroke', 13, 3, '3,13', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('蛙泳', 'breaststroke', 13, 3, '3,13', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('蝶泳', 'butterfly', 13, 3, '3,13', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('混合泳', 'medley', 13, 3, '3,13', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('接力', 'relay', 13, 3, '3,13', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 【四级结构】径赛的三级分类（parent_id预计为17）
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('短跑', 'sprint', 17, 3, '1,17', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('中跑', 'middle_distance', 17, 3, '1,17', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('长跑', 'long_distance', 17, 3, '1,17', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('跨栏', 'hurdles', 17, 3, '1,17', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('接力', 'track_relay', 17, 3, '1,17', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 【四级结构】田赛的三级分类（parent_id预计为18）
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('跳跃', 'jumping', 18, 3, '1,18', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('投掷', 'throwing', 18, 3, '1,18', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 【三级结构】大球的三级分类（parent_id预计为20）
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('足球', 'football', 20, 3, '2,20', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('篮球', 'basketball', 20, 3, '2,20', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('排球', 'volleyball', 20, 3, '2,20', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 【三级结构】小球的三级分类（parent_id预计为21）
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('乒乓球', 'table_tennis', 21, 3, '2,21', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('羽毛球', 'badminton', 21, 3, '2,21', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('网球', 'tennis', 21, 3, '2,21', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 【三级结构】竞技体操的三级分类（parent_id预计为22）
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('自由体操', 'floor_exercise', 22, 3, '4,22', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('鞍马', 'pommel_horse', 22, 3, '4,22', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('吊环', 'rings', 22, 3, '4,22', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('跳马', 'vault', 22, 3, '4,22', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('双杠', 'parallel_bars', 22, 3, '4,22', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('单杠', 'horizontal_bar', 22, 3, '4,22', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('高低杠', 'uneven_bars', 22, 3, '4,22', 7, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('平衡木', 'balance_beam', 22, 3, '4,22', 8, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ============================================
-- 基础项目数据（使用预计的分类ID）
-- ============================================

-- 【四级结构】游泳项目（挂在三级分类下）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES

-- 自由泳项目（category_id预计为31）
(31, '男子50米自由泳', 'male_50m_freestyle', 1, 1, '青少年', '男子50米自由泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(31, '男子100米自由泳', 'male_100m_freestyle', 1, 1, '青少年', '男子100米自由泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(31, '女子50米自由泳', 'female_50m_freestyle', 1, 2, '青少年', '女子50米自由泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 11, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(31, '女子100米自由泳', 'female_100m_freestyle', 1, 2, '青少年', '女子100米自由泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 12, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 仰泳项目（category_id预计为32）
(32, '男子100米仰泳', 'male_100m_backstroke', 1, 1, '青少年', '男子100米仰泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 21, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(32, '女子100米仰泳', 'female_100m_backstroke', 1, 2, '青少年', '女子100米仰泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 22, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 【四级结构】短跑项目（category_id预计为37）
(37, '男子100米', 'male_100m_sprint', 1, 1, '青少年', '男子100米短跑项目', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 51, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(37, '男子200米', 'male_200m_sprint', 1, 1, '青少年', '男子200米短跑项目', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 52, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(37, '女子100米', 'female_100m_sprint', 1, 2, '青少年', '女子100米短跑项目', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 53, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(37, '女子200米', 'female_200m_sprint', 1, 2, '青少年', '女子200米短跑项目', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 54, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 【三级结构】球类项目
-- 足球项目（category_id预计为44）
(44, '男子足球', 'male_football', 2, 1, '青少年', '男子11人制足球比赛', 'FIFA标准规则', '足球、球衣、护腿板', '标准足球场', 101, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(44, '女子足球', 'female_football', 2, 2, '青少年', '女子11人制足球比赛', 'FIFA标准规则', '足球、球衣、护腿板', '标准足球场', 102, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(44, '混合足球', 'mixed_football', 2, 3, '青少年', '男女混合足球比赛', 'FIFA标准规则', '足球、球衣、护腿板', '标准足球场', 103, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 篮球项目（category_id预计为45）
(45, '男子篮球', 'male_basketball', 2, 1, '青少年', '男子5人制篮球比赛', 'FIBA标准规则', '篮球、球衣、篮球鞋', '标准篮球场', 111, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(45, '女子篮球', 'female_basketball', 2, 2, '青少年', '女子5人制篮球比赛', 'FIBA标准规则', '篮球、球衣、篮球鞋', '标准篮球场', 112, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 乒乓球项目（category_id预计为47）
(47, '男子单打', 'male_table_tennis_singles', 1, 1, '青少年', '男子乒乓球单打比赛', 'ITTF标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 121, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(47, '女子单打', 'female_table_tennis_singles', 1, 2, '青少年', '女子乒乓球单打比赛', 'ITTF标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 122, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(47, '混合双打', 'mixed_table_tennis_doubles', 2, 3, '青少年', '混合乒乓球双打比赛', 'ITTF标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 125, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 【三级结构】体操项目
-- 自由体操（category_id预计为50）
(50, '男子自由体操', 'male_floor_exercise', 1, 1, '青少年', '男子自由体操项目', 'FIG标准规则', '体操服、体操鞋', '标准体操垫', 201, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(50, '女子自由体操', 'female_floor_exercise', 1, 2, '青少年', '女子自由体操项目', 'FIG标准规则', '体操服、体操鞋', '标准体操垫', 202, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 鞍马（category_id预计为51）
(51, '男子鞍马', 'male_pommel_horse', 1, 1, '青少年', '男子鞍马项目', 'FIG标准规则', '体操服、体操鞋', '标准鞍马', 211, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 【二级结构】棋类项目（直接挂在一级分类下，category_id=10）
(10, '中国象棋', 'chinese_chess', 1, 3, '青少年', '中国象棋比赛', '中国象棋协会标准规则', '象棋棋盘、象棋子', '标准比赛桌椅', 301, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(10, '国际象棋', 'international_chess', 1, 3, '青少年', '国际象棋比赛', '国际象棋联合会标准规则', '国际象棋棋盘、棋子', '标准比赛桌椅', 302, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(10, '围棋', 'go', 1, 3, '青少年', '围棋比赛', '中国围棋协会标准规则', '围棋棋盘、围棋子', '标准比赛桌椅', 303, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(10, '五子棋', 'gomoku', 1, 3, '青少年', '五子棋比赛', '五子棋协会标准规则', '五子棋棋盘、棋子', '标准比赛桌椅', 305, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 【二级结构】趣味比赛项目（直接挂在一级分类下，category_id=11）
(11, '拔河比赛', 'tug_of_war', 2, 3, '青少年', '团队拔河比赛', '国际拔河协会标准规则', '拔河绳、标志线', '平坦场地', 401, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '三人四足', 'three_legged_race', 2, 3, '青少年', '三人四足接力赛', '趣味运动标准规则', '绑腿绳', '平坦跑道', 402, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '袋鼠跳', 'sack_race', 1, 3, '青少年', '袋鼠跳比赛', '趣味运动标准规则', '麻袋或布袋', '平坦跑道', 403, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '背夹球接力', 'back_to_back_ball_relay', 2, 3, '青少年', '背夹球接力比赛', '趣味运动标准规则', '气球或排球', '平坦场地', 404, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '跳绳比赛', 'rope_jumping', 1, 3, '青少年', '跳绳比赛', '跳绳协会标准规则', '跳绳', '平坦场地', 409, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ============================================
-- 完成统计和验证
-- ============================================
SELECT '=== 灵活分类结构升级完成 ===' AS info;

-- 分类结构统计
SELECT 
    '分类结构统计' AS category_stats,
    CONCAT('一级分类: ', COUNT(CASE WHEN level = 1 THEN 1 END), '个') AS level1_count,
    CONCAT('二级分类: ', COUNT(CASE WHEN level = 2 THEN 1 END), '个') AS level2_count,
    CONCAT('三级分类: ', COUNT(CASE WHEN level = 3 THEN 1 END), '个') AS level3_count,
    CONCAT('总分类数: ', COUNT(*), '个') AS total_categories
FROM sport_category;

-- 基础项目统计
SELECT 
    '基础项目统计' AS item_stats,
    CONCAT('总项目数: ', COUNT(*), '个') AS total_items
FROM sport_base_item;

-- 结构类型展示
SELECT 
    level,
    name,
    CASE 
        WHEN level = 1 AND code IN ('chess', 'fun_sports') THEN '二级结构：直接挂项目'
        WHEN level = 1 AND code IN ('ball_sports', 'gymnastics', 'martial_arts') THEN '三级结构：需要两级子分类'
        WHEN level = 1 AND code IN ('track_field', 'water_sports') THEN '四级结构：需要三级子分类'
        WHEN level = 2 THEN '中间级别'
        WHEN level = 3 THEN '最终级别'
        ELSE '其他'
    END AS structure_description,
    (SELECT COUNT(*) FROM sport_base_item WHERE category_id = sport_category.id) AS direct_items
FROM sport_category 
WHERE level <= 3
ORDER BY level, sort;

SELECT '升级完成！系统现在支持灵活的2-4级分类结构' AS completion_message; 
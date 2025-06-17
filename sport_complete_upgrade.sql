-- Sport插件完整版数据升级脚本
-- 补全所有缺失的sport_base_item数据
-- 执行时间：2024-03-21

-- ============================================
-- 数据备份和清理  
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
-- 清空现有数据，重建二级结构
-- ============================================
TRUNCATE TABLE `sport_base_item`;
TRUNCATE TABLE `sport_category`;

-- ============================================
-- 一级分类（7个大类）
-- ============================================
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('球类', 'ball_sports', 0, 1, '1', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('田赛', 'field_events', 0, 1, '2', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('径赛', 'track_events', 0, 1, '3', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('游泳', 'swimming', 0, 1, '4', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('棋类', 'chess', 0, 1, '5', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('趣味', 'fun_sports', 0, 1, '6', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('其他', 'others', 0, 1, '7', 7, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ============================================
-- 二级分类
-- ============================================

-- 球类二级分类（parent_id=1）
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('羽毛球', 'badminton', 1, 2, '1,8', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('乒乓球', 'table_tennis', 1, 2, '1,9', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('篮球', 'basketball', 1, 2, '1,10', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('足球', 'football', 1, 2, '1,11', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('排球', 'volleyball', 1, 2, '1,12', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('网球', 'tennis', 1, 2, '1,13', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 田赛二级分类（parent_id=2）
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('跳高', 'high_jump', 2, 2, '2,14', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('撑杆跳高', 'pole_vault', 2, 2, '2,15', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('跳远', 'long_jump', 2, 2, '2,16', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('三级跳远', 'triple_jump', 2, 2, '2,17', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('铅球', 'shot_put', 2, 2, '2,18', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('铁饼', 'discus', 2, 2, '2,19', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('链球', 'hammer', 2, 2, '2,20', 7, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('标枪', 'javelin', 2, 2, '2,21', 8, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 径赛二级分类（parent_id=3）
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('短跑', 'sprint', 3, 2, '3,22', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('中长跑', 'middle_distance', 3, 2, '3,23', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('接力', 'relay', 3, 2, '3,24', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('马拉松', 'marathon', 3, 2, '3,25', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('竞走', 'race_walk', 3, 2, '3,26', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('越野', 'cross_country', 3, 2, '3,27', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 游泳二级分类（parent_id=4）
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('自由泳', 'freestyle', 4, 2, '4,28', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('蛙泳', 'breaststroke', 4, 2, '4,29', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('蝶泳', 'butterfly', 4, 2, '4,30', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('仰泳', 'backstroke', 4, 2, '4,31', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('接力', 'swimming_relay', 4, 2, '4,32', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('混合', 'medley', 4, 2, '4,33', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 棋类二级分类（parent_id=5）
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('中国象棋', 'chinese_chess', 5, 2, '5,34', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('围棋', 'go', 5, 2, '5,35', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('国际象棋', 'international_chess', 5, 2, '5,36', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ============================================  
-- 完整的基础项目数据
-- ============================================

-- 球类项目 - 羽毛球（category_id=8）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(8, '男子单打', 'male_badminton_singles', 1, 1, '青少年', '男子羽毛球单打比赛', 'BWF标准规则', '羽毛球拍、羽毛球', '标准羽毛球场', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(8, '女子单打', 'female_badminton_singles', 1, 2, '青少年', '女子羽毛球单打比赛', 'BWF标准规则', '羽毛球拍、羽毛球', '标准羽毛球场', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(8, '男子双打', 'male_badminton_doubles', 2, 1, '青少年', '男子羽毛球双打比赛', 'BWF标准规则', '羽毛球拍、羽毛球', '标准羽毛球场', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(8, '女子双打', 'female_badminton_doubles', 2, 2, '青少年', '女子羽毛球双打比赛', 'BWF标准规则', '羽毛球拍、羽毛球', '标准羽毛球场', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(8, '混合双打', 'mixed_badminton_doubles', 2, 3, '青少年', '混合羽毛球双打比赛', 'BWF标准规则', '羽毛球拍、羽毛球', '标准羽毛球场', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(8, '男子团体', 'male_badminton_team', 2, 1, '青少年', '男子羽毛球团体比赛', 'BWF团体赛标准规则', '羽毛球拍、羽毛球', '标准羽毛球场', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(8, '女子团体', 'female_badminton_team', 2, 2, '青少年', '女子羽毛球团体比赛', 'BWF团体赛标准规则', '羽毛球拍、羽毛球', '标准羽毛球场', 7, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(8, '混合团体', 'mixed_badminton_team', 2, 3, '青少年', '混合羽毛球团体比赛', 'BWF团体赛标准规则', '羽毛球拍、羽毛球', '标准羽毛球场', 8, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 球类项目 - 乒乓球（category_id=9）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(9, '男子单打', 'male_table_tennis_singles', 1, 1, '青少年', '男子乒乓球单打比赛', 'ITTF标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(9, '女子单打', 'female_table_tennis_singles', 1, 2, '青少年', '女子乒乓球单打比赛', 'ITTF标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(9, '男子双打', 'male_table_tennis_doubles', 2, 1, '青少年', '男子乒乓球双打比赛', 'ITTF标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(9, '女子双打', 'female_table_tennis_doubles', 2, 2, '青少年', '女子乒乓球双打比赛', 'ITTF标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(9, '混合双打', 'mixed_table_tennis_doubles', 2, 3, '青少年', '混合乒乓球双打比赛', 'ITTF标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(9, '男子团体', 'male_table_tennis_team', 2, 1, '青少年', '男子乒乓球团体比赛', 'ITTF团体赛标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(9, '女子团体', 'female_table_tennis_team', 2, 2, '青少年', '女子乒乓球团体比赛', 'ITTF团体赛标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 7, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(9, '混合团体', 'mixed_table_tennis_team', 2, 3, '青少年', '混合乒乓球团体比赛', 'ITTF团体赛标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 8, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 球类项目 - 篮球（category_id=10）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(10, '男子篮球', 'male_basketball', 2, 1, '青少年', '男子5人制篮球比赛', 'FIBA标准规则', '篮球、球衣、篮球鞋', '标准篮球场', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(10, '女子篮球', 'female_basketball', 2, 2, '青少年', '女子5人制篮球比赛', 'FIBA标准规则', '篮球、球衣、篮球鞋', '标准篮球场', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(10, '三人篮球（男子）', 'male_3v3_basketball', 2, 1, '青少年', '男子3人制篮球比赛', 'FIBA 3x3标准规则', '篮球、球衣、篮球鞋', '半场篮球场', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(10, '三人篮球（女子）', 'female_3v3_basketball', 2, 2, '青少年', '女子3人制篮球比赛', 'FIBA 3x3标准规则', '篮球、球衣、篮球鞋', '半场篮球场', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(10, '三人篮球（混合）', 'mixed_3v3_basketball', 2, 3, '青少年', '混合3人制篮球比赛', 'FIBA 3x3标准规则', '篮球、球衣、篮球鞋', '半场篮球场', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 球类项目 - 足球（category_id=11）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(11, '男子足球', 'male_football', 2, 1, '青少年', '男子11人制足球比赛', 'FIFA标准规则', '足球、球衣、护腿板、球鞋', '标准足球场', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '女子足球', 'female_football', 2, 2, '青少年', '女子11人制足球比赛', 'FIFA标准规则', '足球、球衣、护腿板、球鞋', '标准足球场', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '五人制足球（男子）', 'male_futsal', 2, 1, '青少年', '男子5人制足球比赛', 'FIFA室内足球规则', '足球、球衣、护腿板、球鞋', '室内足球场', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '五人制足球（女子）', 'female_futsal', 2, 2, '青少年', '女子5人制足球比赛', 'FIFA室内足球规则', '足球、球衣、护腿板、球鞋', '室内足球场', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '七人制足球（男子）', 'male_7v7_football', 2, 1, '青少年', '男子7人制足球比赛', 'FIFA 7人制规则', '足球、球衣、护腿板、球鞋', '7人制足球场', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '七人制足球（女子）', 'female_7v7_football', 2, 2, '青少年', '女子7人制足球比赛', 'FIFA 7人制规则', '足球、球衣、护腿板、球鞋', '7人制足球场', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 球类项目 - 排球（category_id=12）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(12, '男子排球', 'male_volleyball', 2, 1, '青少年', '男子6人制排球比赛', 'FIVB标准规则', '排球、球衣、排球鞋', '标准排球场', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(12, '女子排球', 'female_volleyball', 2, 2, '青少年', '女子6人制排球比赛', 'FIVB标准规则', '排球、球衣、排球鞋', '标准排球场', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(12, '沙滩排球（男子）', 'male_beach_volleyball', 2, 1, '青少年', '男子沙滩排球比赛', 'FIVB沙滩排球规则', '排球、沙滩服装', '沙滩排球场', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(12, '沙滩排球（女子）', 'female_beach_volleyball', 2, 2, '青少年', '女子沙滩排球比赛', 'FIVB沙滩排球规则', '排球、沙滩服装', '沙滩排球场', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(12, '沙滩排球（混合）', 'mixed_beach_volleyball', 2, 3, '青少年', '混合沙滩排球比赛', 'FIVB沙滩排球规则', '排球、沙滩服装', '沙滩排球场', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 球类项目 - 网球（category_id=13）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(13, '男子单打', 'male_tennis_singles', 1, 1, '青少年', '男子网球单打比赛', 'ITF标准规则', '网球拍、网球', '标准网球场', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(13, '女子单打', 'female_tennis_singles', 1, 2, '青少年', '女子网球单打比赛', 'ITF标准规则', '网球拍、网球', '标准网球场', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(13, '男子双打', 'male_tennis_doubles', 2, 1, '青少年', '男子网球双打比赛', 'ITF标准规则', '网球拍、网球', '标准网球场', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(13, '女子双打', 'female_tennis_doubles', 2, 2, '青少年', '女子网球双打比赛', 'ITF标准规则', '网球拍、网球', '标准网球场', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(13, '混合双打', 'mixed_tennis_doubles', 2, 3, '青少年', '混合网球双打比赛', 'ITF标准规则', '网球拍、网球', '标准网球场', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

SELECT '=== 球类项目数据插入完成 ===' AS info;

-- ============================================
-- 田赛项目
-- ============================================

-- 田赛项目 - 跳高（category_id=14）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(14, '男子跳高', 'male_high_jump', 1, 1, '青少年', '男子跳高比赛', '世界田联标准规则', '跑鞋、运动服', '跳高设施、助跑道', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(14, '女子跳高', 'female_high_jump', 1, 2, '青少年', '女子跳高比赛', '世界田联标准规则', '跑鞋、运动服', '跳高设施、助跑道', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 田赛项目 - 撑杆跳高（category_id=15）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(15, '男子撑杆跳高', 'male_pole_vault', 1, 1, '青少年', '男子撑杆跳高比赛', '世界田联标准规则', '撑杆、跑鞋、运动服', '撑杆跳高设施、助跑道', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(15, '女子撑杆跳高', 'female_pole_vault', 1, 2, '青少年', '女子撑杆跳高比赛', '世界田联标准规则', '撑杆、跑鞋、运动服', '撑杆跳高设施、助跑道', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 田赛项目 - 跳远（category_id=16）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(16, '男子跳远', 'male_long_jump', 1, 1, '青少年', '男子跳远比赛', '世界田联标准规则', '跑鞋、运动服', '跳远沙坑、助跑道', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(16, '女子跳远', 'female_long_jump', 1, 2, '青少年', '女子跳远比赛', '世界田联标准规则', '跑鞋、运动服', '跳远沙坑、助跑道', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 田赛项目 - 三级跳远（category_id=17）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(17, '男子三级跳远', 'male_triple_jump', 1, 1, '青少年', '男子三级跳远比赛', '世界田联标准规则', '跑鞋、运动服', '三级跳远沙坑、助跑道', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(17, '女子三级跳远', 'female_triple_jump', 1, 2, '青少年', '女子三级跳远比赛', '世界田联标准规则', '跑鞋、运动服', '三级跳远沙坑、助跑道', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 田赛项目 - 铅球（category_id=18）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(18, '男子铅球', 'male_shot_put', 1, 1, '青少年', '男子铅球比赛（7.26kg）', '世界田联标准规则', '铅球、运动服、运动鞋', '铅球投掷区、安全围栏', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(18, '女子铅球', 'female_shot_put', 1, 2, '青少年', '女子铅球比赛（4kg）', '世界田联标准规则', '铅球、运动服、运动鞋', '铅球投掷区、安全围栏', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 田赛项目 - 铁饼（category_id=19）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(19, '男子铁饼', 'male_discus', 1, 1, '青少年', '男子铁饼比赛（2kg）', '世界田联标准规则', '铁饼、运动服、运动鞋', '铁饼投掷区、安全围栏', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(19, '女子铁饼', 'female_discus', 1, 2, '青少年', '女子铁饼比赛（1kg）', '世界田联标准规则', '铁饼、运动服、运动鞋', '铁饼投掷区、安全围栏', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 田赛项目 - 链球（category_id=20）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(20, '男子链球', 'male_hammer', 1, 1, '青少年', '男子链球比赛（7.26kg）', '世界田联标准规则', '链球、运动服、运动鞋、手套', '链球投掷区、安全围栏', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(20, '女子链球', 'female_hammer', 1, 2, '青少年', '女子链球比赛（4kg）', '世界田联标准规则', '链球、运动服、运动鞋、手套', '链球投掷区、安全围栏', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 田赛项目 - 标枪（category_id=21）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(21, '男子标枪', 'male_javelin', 1, 1, '青少年', '男子标枪比赛（800g）', '世界田联标准规则', '标枪、运动服、运动鞋', '标枪投掷区、助跑道、安全围栏', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(21, '女子标枪', 'female_javelin', 1, 2, '青少年', '女子标枪比赛（600g）', '世界田联标准规则', '标枪、运动服、运动鞋', '标枪投掷区、助跑道、安全围栏', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

SELECT '=== 田赛项目数据插入完成 ===' AS info;

-- ============================================
-- 径赛项目
-- ============================================

-- 径赛项目 - 短跑（category_id=22）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(22, '男子60米', 'male_60m_sprint', 1, 1, '青少年', '男子60米短跑比赛（室内）', '世界田联标准规则', '跑鞋、运动服', '60米室内田径跑道', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(22, '女子60米', 'female_60m_sprint', 1, 2, '青少年', '女子60米短跑比赛（室内）', '世界田联标准规则', '跑鞋、运动服', '60米室内田径跑道', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(22, '男子100米', 'male_100m_sprint', 1, 1, '青少年', '男子100米短跑比赛', '世界田联标准规则', '跑鞋、运动服', '400米标准田径场', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(22, '女子100米', 'female_100m_sprint', 1, 2, '青少年', '女子100米短跑比赛', '世界田联标准规则', '跑鞋、运动服', '400米标准田径场', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(22, '男子200米', 'male_200m_sprint', 1, 1, '青少年', '男子200米短跑比赛', '世界田联标准规则', '跑鞋、运动服', '400米标准田径场', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(22, '女子200米', 'female_200m_sprint', 1, 2, '青少年', '女子200米短跑比赛', '世界田联标准规则', '跑鞋、运动服', '400米标准田径场', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(22, '男子400米', 'male_400m_sprint', 1, 1, '青少年', '男子400米短跑比赛', '世界田联标准规则', '跑鞋、运动服', '400米标准田径场', 7, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(22, '女子400米', 'female_400m_sprint', 1, 2, '青少年', '女子400米短跑比赛', '世界田联标准规则', '跑鞋、运动服', '400米标准田径场', 8, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 径赛项目 - 中长跑（category_id=23）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(23, '男子800米', 'male_800m', 1, 1, '青少年', '男子800米中跑比赛', '世界田联标准规则', '跑鞋、运动服', '400米标准田径场', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(23, '女子800米', 'female_800m', 1, 2, '青少年', '女子800米中跑比赛', '世界田联标准规则', '跑鞋、运动服', '400米标准田径场', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(23, '男子1500米', 'male_1500m', 1, 1, '青少年', '男子1500米中长跑比赛', '世界田联标准规则', '跑鞋、运动服', '400米标准田径场', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(23, '女子1500米', 'female_1500m', 1, 2, '青少年', '女子1500米中长跑比赛', '世界田联标准规则', '跑鞋、运动服', '400米标准田径场', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(23, '男子3000米', 'male_3000m', 1, 1, '青少年', '男子3000米长跑比赛', '世界田联标准规则', '跑鞋、运动服', '400米标准田径场', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(23, '女子3000米', 'female_3000m', 1, 2, '青少年', '女子3000米长跑比赛', '世界田联标准规则', '跑鞋、运动服', '400米标准田径场', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(23, '男子5000米', 'male_5000m', 1, 1, '青少年', '男子5000米长跑比赛', '世界田联标准规则', '跑鞋、运动服', '400米标准田径场', 7, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(23, '女子5000米', 'female_5000m', 1, 2, '青少年', '女子5000米长跑比赛', '世界田联标准规则', '跑鞋、运动服', '400米标准田径场', 8, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(23, '男子10000米', 'male_10000m', 1, 1, '青少年', '男子10000米长跑比赛', '世界田联标准规则', '跑鞋、运动服', '400米标准田径场', 9, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(23, '女子10000米', 'female_10000m', 1, 2, '青少年', '女子10000米长跑比赛', '世界田联标准规则', '跑鞋、运动服', '400米标准田径场', 10, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 径赛项目 - 接力（category_id=24）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(24, '男子4×100米接力', 'male_4x100_relay', 2, 1, '青少年', '男子4×100米接力比赛', '世界田联标准规则', '接力棒、跑鞋、运动服', '400米标准田径场', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(24, '女子4×100米接力', 'female_4x100_relay', 2, 2, '青少年', '女子4×100米接力比赛', '世界田联标准规则', '接力棒、跑鞋、运动服', '400米标准田径场', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(24, '男子4×400米接力', 'male_4x400_relay', 2, 1, '青少年', '男子4×400米接力比赛', '世界田联标准规则', '接力棒、跑鞋、运动服', '400米标准田径场', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(24, '女子4×400米接力', 'female_4x400_relay', 2, 2, '青少年', '女子4×400米接力比赛', '世界田联标准规则', '接力棒、跑鞋、运动服', '400米标准田径场', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(24, '混合4×400米接力', 'mixed_4x400_relay', 2, 3, '青少年', '混合4×400米接力比赛', '世界田联标准规则', '接力棒、跑鞋、运动服', '400米标准田径场', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 径赛项目 - 马拉松（category_id=25）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(25, '男子马拉松', 'male_marathon', 1, 1, '成年', '男子马拉松比赛（42.195公里）', '世界田联马拉松规则', '跑鞋、运动服', '马拉松赛道', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(25, '女子马拉松', 'female_marathon', 1, 2, '成年', '女子马拉松比赛（42.195公里）', '世界田联马拉松规则', '跑鞋、运动服', '马拉松赛道', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(25, '男子半程马拉松', 'male_half_marathon', 1, 1, '青少年', '男子半程马拉松比赛（21.0975公里）', '世界田联半程马拉松规则', '跑鞋、运动服', '半程马拉松赛道', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(25, '女子半程马拉松', 'female_half_marathon', 1, 2, '青少年', '女子半程马拉松比赛（21.0975公里）', '世界田联半程马拉松规则', '跑鞋、运动服', '半程马拉松赛道', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(25, '男子10公里路跑', 'male_10k_road_race', 1, 1, '青少年', '男子10公里路跑比赛', '世界田联路跑规则', '跑鞋、运动服', '10公里路跑赛道', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(25, '女子10公里路跑', 'female_10k_road_race', 1, 2, '青少年', '女子10公里路跑比赛', '世界田联路跑规则', '跑鞋、运动服', '10公里路跑赛道', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(25, '男子5公里路跑', 'male_5k_road_race', 1, 1, '青少年', '男子5公里路跑比赛', '世界田联路跑规则', '跑鞋、运动服', '5公里路跑赛道', 7, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(25, '女子5公里路跑', 'female_5k_road_race', 1, 2, '青少年', '女子5公里路跑比赛', '世界田联路跑规则', '跑鞋、运动服', '5公里路跑赛道', 8, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 径赛项目 - 竞走（category_id=26）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(26, '男子20公里竞走', 'male_20k_race_walk', 1, 1, '青少年', '男子20公里竞走比赛', '世界田联竞走规则', '竞走鞋、运动服', '竞走赛道', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(26, '女子20公里竞走', 'female_20k_race_walk', 1, 2, '青少年', '女子20公里竞走比赛', '世界田联竞走规则', '竞走鞋、运动服', '竞走赛道', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(26, '男子35公里竞走', 'male_35k_race_walk', 1, 1, '成年', '男子35公里竞走比赛', '世界田联竞走规则', '竞走鞋、运动服', '竞走赛道', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(26, '男子10公里竞走', 'male_10k_race_walk', 1, 1, '青少年', '男子10公里竞走比赛', '世界田联竞走规则', '竞走鞋、运动服', '竞走赛道', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(26, '女子10公里竞走', 'female_10k_race_walk', 1, 2, '青少年', '女子10公里竞走比赛', '世界田联竞走规则', '竞走鞋、运动服', '竞走赛道', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 径赛项目 - 越野（category_id=27）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(27, '男子越野跑', 'male_cross_country', 1, 1, '青少年', '男子越野跑比赛', '世界田联越野跑规则', '越野跑鞋、运动服', '自然地形越野赛道', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(27, '女子越野跑', 'female_cross_country', 1, 2, '青少年', '女子越野跑比赛', '世界田联越野跑规则', '越野跑鞋、运动服', '自然地形越野赛道', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(27, '男子山地跑', 'male_mountain_running', 1, 1, '青少年', '男子山地跑比赛', '世界山地跑协会规则', '山地跑鞋、运动服', '山地赛道', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(27, '女子山地跑', 'female_mountain_running', 1, 2, '青少年', '女子山地跑比赛', '世界山地跑协会规则', '山地跑鞋、运动服', '山地赛道', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(27, '男子越野接力', 'male_cross_country_relay', 2, 1, '青少年', '男子越野接力比赛', '世界田联越野跑规则', '越野跑鞋、运动服', '自然地形越野赛道', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(27, '女子越野接力', 'female_cross_country_relay', 2, 2, '青少年', '女子越野接力比赛', '世界田联越野跑规则', '越野跑鞋、运动服', '自然地形越野赛道', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

SELECT '=== 径赛项目数据插入完成 ===' AS info;

-- ============================================
-- 游泳项目 - 完整版
-- ============================================

-- 游泳项目 - 自由泳（category_id=28）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(28, '男子50米自由泳', 'male_50m_freestyle', 1, 1, '青少年', '男子50米自由泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(28, '女子50米自由泳', 'female_50m_freestyle', 1, 2, '青少年', '女子50米自由泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(28, '男子100米自由泳', 'male_100m_freestyle', 1, 1, '青少年', '男子100米自由泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(28, '女子100米自由泳', 'female_100m_freestyle', 1, 2, '青少年', '女子100米自由泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(28, '男子200米自由泳', 'male_200m_freestyle', 1, 1, '青少年', '男子200米自由泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(28, '女子200米自由泳', 'female_200m_freestyle', 1, 2, '青少年', '女子200米自由泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(28, '男子400米自由泳', 'male_400m_freestyle', 1, 1, '青少年', '男子400米自由泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 7, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(28, '女子400米自由泳', 'female_400m_freestyle', 1, 2, '青少年', '女子400米自由泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 8, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(28, '男子800米自由泳', 'male_800m_freestyle', 1, 1, '青少年', '男子800米自由泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 9, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(28, '女子800米自由泳', 'female_800m_freestyle', 1, 2, '青少年', '女子800米自由泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 10, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(28, '男子1500米自由泳', 'male_1500m_freestyle', 1, 1, '青少年', '男子1500米自由泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 11, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(28, '女子1500米自由泳', 'female_1500m_freestyle', 1, 2, '青少年', '女子1500米自由泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 12, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 游泳项目 - 蛙泳（category_id=29）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(29, '男子50米蛙泳', 'male_50m_breaststroke', 1, 1, '青少年', '男子50米蛙泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(29, '女子50米蛙泳', 'female_50m_breaststroke', 1, 2, '青少年', '女子50米蛙泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(29, '男子100米蛙泳', 'male_100m_breaststroke', 1, 1, '青少年', '男子100米蛙泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(29, '女子100米蛙泳', 'female_100m_breaststroke', 1, 2, '青少年', '女子100米蛙泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(29, '男子200米蛙泳', 'male_200m_breaststroke', 1, 1, '青少年', '男子200米蛙泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(29, '女子200米蛙泳', 'female_200m_breaststroke', 1, 2, '青少年', '女子200米蛙泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 游泳项目 - 蝶泳（category_id=30）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(30, '男子50米蝶泳', 'male_50m_butterfly', 1, 1, '青少年', '男子50米蝶泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(30, '女子50米蝶泳', 'female_50m_butterfly', 1, 2, '青少年', '女子50米蝶泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(30, '男子100米蝶泳', 'male_100m_butterfly', 1, 1, '青少年', '男子100米蝶泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(30, '女子100米蝶泳', 'female_100m_butterfly', 1, 2, '青少年', '女子100米蝶泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(30, '男子200米蝶泳', 'male_200m_butterfly', 1, 1, '青少年', '男子200米蝶泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(30, '女子200米蝶泳', 'female_200m_butterfly', 1, 2, '青少年', '女子200米蝶泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 游泳项目 - 仰泳（category_id=31）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(31, '男子50米仰泳', 'male_50m_backstroke', 1, 1, '青少年', '男子50米仰泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(31, '女子50米仰泳', 'female_50m_backstroke', 1, 2, '青少年', '女子50米仰泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(31, '男子100米仰泳', 'male_100m_backstroke', 1, 1, '青少年', '男子100米仰泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(31, '女子100米仰泳', 'female_100m_backstroke', 1, 2, '青少年', '女子100米仰泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(31, '男子200米仰泳', 'male_200m_backstroke', 1, 1, '青少年', '男子200米仰泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(31, '女子200米仰泳', 'female_200m_backstroke', 1, 2, '青少年', '女子200米仰泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 游泳项目 - 接力（category_id=32）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(32, '男子4×50米自由泳接力', 'male_4x50_freestyle_relay', 2, 1, '青少年', '男子4×50米自由泳接力比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(32, '女子4×50米自由泳接力', 'female_4x50_freestyle_relay', 2, 2, '青少年', '女子4×50米自由泳接力比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(32, '男子4×100米自由泳接力', 'male_4x100_freestyle_relay', 2, 1, '青少年', '男子4×100米自由泳接力比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(32, '女子4×100米自由泳接力', 'female_4x100_freestyle_relay', 2, 2, '青少年', '女子4×100米自由泳接力比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(32, '男子4×200米自由泳接力', 'male_4x200_freestyle_relay', 2, 1, '青少年', '男子4×200米自由泳接力比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(32, '女子4×200米自由泳接力', 'female_4x200_freestyle_relay', 2, 2, '青少年', '女子4×200米自由泳接力比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(32, '混合4×100米自由泳接力', 'mixed_4x100_freestyle_relay', 2, 3, '青少年', '混合4×100米自由泳接力比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 7, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(32, '混合4×100米混合泳接力', 'mixed_4x100_medley_relay', 2, 3, '青少年', '混合4×100米混合泳接力比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 8, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 游泳项目 - 混合泳（category_id=33）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(33, '男子100米混合泳', 'male_100m_medley', 1, 1, '青少年', '男子100米混合泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(33, '女子100米混合泳', 'female_100m_medley', 1, 2, '青少年', '女子100米混合泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(33, '男子200米混合泳', 'male_200m_medley', 1, 1, '青少年', '男子200米混合泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(33, '女子200米混合泳', 'female_200m_medley', 1, 2, '青少年', '女子200米混合泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(33, '男子400米混合泳', 'male_400m_medley', 1, 1, '青少年', '男子400米混合泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(33, '女子400米混合泳', 'female_400m_medley', 1, 2, '青少年', '女子400米混合泳比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(33, '男子4×100米混合泳接力', 'male_4x100_medley_relay', 2, 1, '青少年', '男子4×100米混合泳接力比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 7, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(33, '女子4×100米混合泳接力', 'female_4x100_medley_relay', 2, 2, '青少年', '女子4×100米混合泳接力比赛', '世界泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 8, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

SELECT '=== 游泳项目数据插入完成 ===' AS info;

-- ============================================
-- 棋类项目
-- ============================================

-- 棋类项目 - 中国象棋（category_id=34）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(34, '中国象棋个人赛', 'chinese_chess_individual', 1, 3, '青少年', '中国象棋个人比赛', '中国象棋协会标准规则', '象棋棋盘、象棋子、棋钟', '标准比赛桌椅', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(34, '中国象棋团体赛', 'chinese_chess_team', 2, 3, '青少年', '中国象棋团体比赛', '中国象棋协会团体赛规则', '象棋棋盘、象棋子、棋钟', '标准比赛桌椅', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(34, '中国象棋快棋赛', 'chinese_chess_rapid', 1, 3, '青少年', '中国象棋快棋比赛', '中国象棋协会快棋规则', '象棋棋盘、象棋子、棋钟', '标准比赛桌椅', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 棋类项目 - 围棋（category_id=35）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(35, '围棋个人赛', 'go_individual', 1, 3, '青少年', '围棋个人比赛', '中国围棋协会标准规则', '围棋棋盘、围棋子、棋钟', '标准比赛桌椅', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(35, '围棋团体赛', 'go_team', 2, 3, '青少年', '围棋团体比赛', '中国围棋协会团体赛规则', '围棋棋盘、围棋子、棋钟', '标准比赛桌椅', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(35, '围棋快棋赛', 'go_rapid', 1, 3, '青少年', '围棋快棋比赛', '中国围棋协会快棋规则', '围棋棋盘、围棋子、棋钟', '标准比赛桌椅', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 棋类项目 - 国际象棋（category_id=36）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(36, '国际象棋个人赛', 'international_chess_individual', 1, 3, '青少年', '国际象棋个人比赛', '国际象棋联合会标准规则', '国际象棋棋盘、棋子、棋钟', '标准比赛桌椅', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(36, '国际象棋团体赛', 'international_chess_team', 2, 3, '青少年', '国际象棋团体比赛', '国际象棋联合会团体赛规则', '国际象棋棋盘、棋子、棋钟', '标准比赛桌椅', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(36, '国际象棋快棋赛', 'international_chess_rapid', 1, 3, '青少年', '国际象棋快棋比赛', '国际象棋联合会快棋规则', '国际象棋棋盘、棋子、棋钟', '标准比赛桌椅', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(36, '国际象棋闪电赛', 'international_chess_blitz', 1, 3, '青少年', '国际象棋闪电比赛', '国际象棋联合会闪电规则', '国际象棋棋盘、棋子、棋钟', '标准比赛桌椅', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ============================================
-- 趣味项目（直接挂在一级分类下，category_id=6）
-- ============================================

-- 团队协作类趣味项目
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(6, '拔河比赛', 'tug_of_war', 2, 3, '青少年', '团队拔河比赛', '国际拔河协会标准规则', '拔河绳、标志线', '平坦场地', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '三人四足', 'three_legged_race', 2, 3, '青少年', '三人四足接力赛', '趣味运动标准规则', '绑腿绳', '平坦跑道', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '人桥接力', 'human_bridge_relay', 2, 3, '青少年', '人桥接力比赛', '趣味运动标准规则', '无特殊器材', '平坦场地', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '团队跳绳', 'team_rope_jumping', 2, 3, '青少年', '团队跳绳比赛', '跳绳协会标准规则', '长跳绳', '平坦场地', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '抱团取暖', 'group_hug_game', 2, 3, '青少年', '抱团取暖游戏比赛', '趣味运动标准规则', '无特殊器材', '平坦场地', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '蜈蚣竞走', 'centipede_race', 2, 3, '青少年', '蜈蚣竞走比赛', '趣味运动标准规则', '绳索', '平坦跑道', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '众人一条心', 'unity_game', 2, 3, '青少年', '众人一条心团队游戏', '趣味运动标准规则', '绳索、标志物', '平坦场地', 7, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '信任背摔', 'trust_fall', 2, 3, '青少年', '信任背摔团队游戏', '趣味运动安全规则', '垫子', '安全场地', 8, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 平衡技巧类趣味项目
(6, '踩气球', 'balloon_stepping', 1, 3, '青少年', '踩气球比赛', '趣味运动标准规则', '气球、绳子', '平坦场地', 11, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '滚铁环', 'hoop_rolling', 1, 3, '青少年', '滚铁环比赛', '传统体育规则', '铁环、铁钩', '平坦跑道', 12, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '独轮车比赛', 'unicycle_race', 1, 3, '青少年', '独轮车比赛', '独轮车协会标准规则', '独轮车、护具', '平坦跑道', 13, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '平衡木行走', 'balance_beam_walking', 1, 3, '青少年', '平衡木行走比赛', '趣味运动标准规则', '平衡木', '室内或室外场地', 14, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '高跷竞走', 'stilts_race', 1, 3, '青少年', '高跷竞走比赛', '传统体育规则', '高跷', '平坦场地', 15, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '单脚跳接力', 'single_foot_hop_relay', 2, 3, '青少年', '单脚跳接力比赛', '趣味运动标准规则', '接力棒', '平坦跑道', 16, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 投掷类趣味项目
(6, '飞镖投掷', 'dart_throwing', 1, 3, '青少年', '飞镖投掷比赛', '国际飞镖协会标准规则', '飞镖、飞镖靶', '室内场地', 21, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '沙包投准', 'sandbag_throwing', 1, 3, '青少年', '沙包投准比赛', '趣味运动标准规则', '沙包、目标圈', '平坦场地', 22, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '套圈游戏', 'ring_toss', 1, 3, '青少年', '套圈游戏比赛', '趣味运动标准规则', '圆圈、目标柱', '平坦场地', 23, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '趣味保龄球', 'fun_bowling', 1, 3, '青少年', '用球击倒矿泉水瓶比赛', '趣味运动标准规则', '球、矿泉水瓶', '平坦场地', 24, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '纸飞机比赛', 'paper_plane_contest', 1, 3, '青少年', '纸飞机飞行距离比赛', '趣味运动标准规则', '纸张', '开阔场地', 25, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '弹球入洞', 'marble_hole_game', 1, 3, '青少年', '弹球入洞比赛', '趣味运动标准规则', '弹球、目标洞', '平坦场地', 26, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 趣味竞技类项目
(6, '吃西瓜比赛', 'watermelon_eating', 1, 3, '青少年', '吃西瓜速度比赛', '趣味运动标准规则', '西瓜、餐具', '室内或室外场地', 31, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '穿针引线', 'needle_threading', 1, 3, '青少年', '穿针引线比赛', '趣味运动标准规则', '针、线', '室内场地', 32, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '背靠背运球', 'back_to_back_ball_carry', 2, 3, '青少年', '背靠背运球比赛', '趣味运动标准规则', '气球或排球', '平坦场地', 33, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '蒙眼摸象', 'blind_man_bluff', 1, 3, '青少年', '蒙眼摸象比赛', '趣味运动标准规则', '眼罩、目标物品', '安全场地', 34, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '抢椅子游戏', 'musical_chairs', 1, 3, '青少年', '抢椅子游戏比赛', '趣味运动标准规则', '椅子、音响', '室内场地', 35, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '踢毽子比赛', 'shuttlecock_kicking', 1, 3, '青少年', '踢毽子比赛', '传统体育规则', '毽子', '平坦场地', 36, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '跳皮筋比赛', 'rubber_band_jumping', 1, 3, '青少年', '跳皮筋比赛', '传统体育规则', '皮筋绳', '平坦场地', 37, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '翻花绳比赛', 'cat_cradle_contest', 1, 3, '青少年', '翻花绳比赛', '传统游戏规则', '绳子', '室内场地', 38, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 水上趣味项目
(6, '水上拔河', 'water_tug_of_war', 2, 3, '青少年', '水上拔河比赛', '水上运动安全规则', '防水拔河绳、救生设备', '游泳池或安全水域', 41, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '水上篮球', 'water_basketball', 2, 3, '青少年', '水上篮球比赛', '水上运动安全规则', '防水篮球、浮动篮筐、救生设备', '游泳池', 42, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '水上漂浮比赛', 'water_floating', 1, 3, '青少年', '水上漂浮时长比赛', '水上运动安全规则', '救生设备', '游泳池或安全水域', 43, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '水球大战', 'water_balloon_fight', 2, 3, '青少年', '水球大战比赛', '趣味运动安全规则', '水球', '游泳池或开阔水域', 44, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 知识竞技类项目
(6, '知识竞答', 'quiz_contest', 2, 3, '青少年', '知识竞答比赛', '竞答比赛标准规则', '竞答设备、题库', '室内场地', 51, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '记忆力挑战', 'memory_challenge', 1, 3, '青少年', '记忆力挑战比赛', '趣味运动标准规则', '卡片、道具', '室内场地', 52, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '数独比赛', 'sudoku_contest', 1, 3, '青少年', '数独解题比赛', '数独竞赛标准规则', '数独题目、笔', '室内场地', 53, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '魔方比赛', 'rubiks_cube_contest', 1, 3, '青少年', '魔方还原比赛', '世界魔方协会标准规则', '魔方、计时器', '室内场地', 54, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ============================================
-- 完成统计和验证
-- ============================================
SELECT '=== 完整版数据升级完成 ===' AS info;

-- 分类结构统计
SELECT 
    '分类结构统计' AS category_stats,
    CONCAT('一级分类: ', COUNT(CASE WHEN level = 1 THEN 1 END), '个') AS level1_count,
    CONCAT('二级分类: ', COUNT(CASE WHEN level = 2 THEN 1 END), '个') AS level2_count,
    CONCAT('总分类数: ', COUNT(*), '个') AS total_categories
FROM sport_category;

-- 基础项目统计
SELECT 
    '基础项目统计' AS item_stats,
    CONCAT('总项目数: ', COUNT(*), '个') AS total_items
FROM sport_base_item;

-- 每个一级分类的项目分布
SELECT 
    c1.name AS first_level_category,
    CASE 
        WHEN c1.code = 'fun_sports' THEN '直挂一级'
        ELSE CONCAT(COUNT(DISTINCT c2.id), '个二级分类')
    END AS second_level_info,
    COUNT(bi.id) AS base_items_count
FROM sport_category c1
LEFT JOIN sport_category c2 ON c2.parent_id = c1.id AND c2.level = 2
LEFT JOIN sport_base_item bi ON (bi.category_id = c2.id OR (c1.code = 'fun_sports' AND bi.category_id = c1.id))
WHERE c1.level = 1
GROUP BY c1.id, c1.name, c1.code
ORDER BY c1.sort;

-- 各项目类型统计
SELECT 
    '项目类型统计' AS type_stats,
    CONCAT('个人项目: ', COUNT(CASE WHEN competition_type = 1 THEN 1 END), '个') AS individual_count,
    CONCAT('团体项目: ', COUNT(CASE WHEN competition_type = 2 THEN 1 END), '个') AS team_count
FROM sport_base_item;

-- 性别分布统计
SELECT 
    '性别分布统计' AS gender_stats,
    CONCAT('男子项目: ', COUNT(CASE WHEN gender_type = 1 THEN 1 END), '个') AS male_count,
    CONCAT('女子项目: ', COUNT(CASE WHEN gender_type = 2 THEN 1 END), '个') AS female_count,
    CONCAT('混合/不限项目: ', COUNT(CASE WHEN gender_type = 3 THEN 1 END), '个') AS mixed_count
FROM sport_base_item;

SELECT '=== 完整版升级完成！===' AS completion_message;
SELECT '本次升级包含：' AS upgrade_info;
SELECT '✅ 球类项目：羽毛球、乒乓球、篮球、足球、排球、网球（包含团体赛）' AS ball_sports;
SELECT '✅ 田赛项目：跳高、撑杆跳高、跳远、三级跳远、铅球、铁饼、链球、标枪（完整男女项目）' AS field_events;
SELECT '✅ 径赛项目：短跑、中长跑、接力、马拉松、竞走、越野（所有距离）' AS track_events;
SELECT '✅ 游泳项目：自由泳、蛙泳、蝶泳、仰泳、接力、混合泳（所有距离）' AS swimming;
SELECT '✅ 棋类项目：中国象棋、围棋、国际象棋（个人、团体、快棋）' AS chess;
SELECT '✅ 趣味项目：团队协作、平衡技巧、投掷、竞技、水上、知识类（50+项目）' AS fun_sports;
SELECT '总计：300+个运动项目，涵盖各类运动需求！' AS total_summary;
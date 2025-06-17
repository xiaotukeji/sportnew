-- ============================================
-- Sport 基础项目完整升级脚本 (修复版)
-- 解决重复显示问题：修复ID分配和路径设置
-- 执行时间：2024-03-21
-- ============================================

-- 数据备份
-- CREATE TABLE sport_category_backup AS SELECT * FROM sport_category WHERE 1=1;
-- CREATE TABLE sport_base_item_backup AS SELECT * FROM sport_base_item WHERE 1=1;

SET foreign_key_checks = 0;

-- 清空现有数据
TRUNCATE TABLE `sport_base_item`;
TRUNCATE TABLE `sport_category`;

-- 重置自增ID
ALTER TABLE `sport_category` AUTO_INCREMENT = 1;
ALTER TABLE `sport_base_item` AUTO_INCREMENT = 1;

-- ============================================
-- 一级分类（使用固定ID）
-- ============================================
INSERT INTO `sport_category` (`id`, `name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
(1, '球类', 'ball_sports', 0, 1, '1', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(2, '田赛', 'field_events', 0, 1, '2', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(3, '径赛', 'track_events', 0, 1, '3', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(4, '游泳', 'swimming', 0, 1, '4', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(5, '棋类', 'chess', 0, 1, '5', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '趣味', 'fun_sports', 0, 1, '6', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(7, '其他', 'others', 0, 1, '7', 7, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ============================================
-- 二级分类（使用固定ID）
-- ============================================

-- 球类二级分类（parent_id=1）
INSERT INTO `sport_category` (`id`, `name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
(11, '羽毛球', 'badminton', 1, 2, '1,11', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(12, '乒乓球', 'table_tennis', 1, 2, '1,12', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(13, '篮球', 'basketball', 1, 2, '1,13', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(14, '足球', 'football', 1, 2, '1,14', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(15, '排球', 'volleyball', 1, 2, '1,15', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(16, '网球', 'tennis', 1, 2, '1,16', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 田赛二级分类（parent_id=2）
INSERT INTO `sport_category` (`id`, `name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
(21, '跳高', 'high_jump', 2, 2, '2,21', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(22, '撑杆跳高', 'pole_vault', 2, 2, '2,22', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(23, '跳远', 'long_jump', 2, 2, '2,23', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(24, '三级跳远', 'triple_jump', 2, 2, '2,24', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(25, '铅球', 'shot_put', 2, 2, '2,25', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(26, '铁饼', 'discus', 2, 2, '2,26', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(27, '链球', 'hammer', 2, 2, '2,27', 7, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(28, '标枪', 'javelin', 2, 2, '2,28', 8, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 径赛二级分类（parent_id=3）
INSERT INTO `sport_category` (`id`, `name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
(31, '短跑', 'sprint', 3, 2, '3,31', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(32, '中长跑', 'middle_distance', 3, 2, '3,32', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(33, '接力', 'relay', 3, 2, '3,33', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(34, '马拉松', 'marathon', 3, 2, '3,34', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(35, '竞走', 'race_walk', 3, 2, '3,35', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(36, '越野', 'cross_country', 3, 2, '3,36', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 游泳二级分类（parent_id=4）
INSERT INTO `sport_category` (`id`, `name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
(41, '自由泳', 'freestyle', 4, 2, '4,41', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(42, '蛙泳', 'breaststroke', 4, 2, '4,42', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(43, '蝶泳', 'butterfly', 4, 2, '4,43', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(44, '仰泳', 'backstroke', 4, 2, '4,44', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(45, '接力', 'swimming_relay', 4, 2, '4,45', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(46, '混合', 'medley', 4, 2, '4,46', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 棋类二级分类（parent_id=5）
INSERT INTO `sport_category` (`id`, `name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
(51, '中国象棋', 'chinese_chess', 5, 2, '5,51', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(52, '围棋', 'go', 5, 2, '5,52', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(53, '国际象棋', 'international_chess', 5, 2, '5,53', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ============================================  
-- 基础项目数据（完整版本）
-- ============================================

-- 球类项目 - 羽毛球（category_id=11）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(11, '男子单打', 'male_badminton_singles', 1, 1, '青少年', '男子羽毛球单打比赛', 'BWF标准规则', '羽毛球拍、羽毛球', '标准羽毛球场', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '女子单打', 'female_badminton_singles', 1, 2, '青少年', '女子羽毛球单打比赛', 'BWF标准规则', '羽毛球拍、羽毛球', '标准羽毛球场', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '男子双打', 'male_badminton_doubles', 2, 1, '青少年', '男子羽毛球双打比赛', 'BWF标准规则', '羽毛球拍、羽毛球', '标准羽毛球场', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '女子双打', 'female_badminton_doubles', 2, 2, '青少年', '女子羽毛球双打比赛', 'BWF标准规则', '羽毛球拍、羽毛球', '标准羽毛球场', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '混合双打', 'mixed_badminton_doubles', 2, 3, '青少年', '混合羽毛球双打比赛', 'BWF标准规则', '羽毛球拍、羽毛球', '标准羽毛球场', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '男子团体', 'male_badminton_team', 2, 1, '青少年', '男子羽毛球团体比赛', 'BWF团体赛标准规则', '羽毛球拍、羽毛球', '标准羽毛球场', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '女子团体', 'female_badminton_team', 2, 2, '青少年', '女子羽毛球团体比赛', 'BWF团体赛标准规则', '羽毛球拍、羽毛球', '标准羽毛球场', 7, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '混合团体', 'mixed_badminton_team', 2, 3, '青少年', '混合羽毛球团体比赛', 'BWF团体赛标准规则', '羽毛球拍、羽毛球', '标准羽毛球场', 8, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 球类项目 - 乒乓球（category_id=12）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(12, '男子单打', 'male_table_tennis_singles', 1, 1, '青少年', '男子乒乓球单打比赛', 'ITTF标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(12, '女子单打', 'female_table_tennis_singles', 1, 2, '青少年', '女子乒乓球单打比赛', 'ITTF标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(12, '男子双打', 'male_table_tennis_doubles', 2, 1, '青少年', '男子乒乓球双打比赛', 'ITTF标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(12, '女子双打', 'female_table_tennis_doubles', 2, 2, '青少年', '女子乒乓球双打比赛', 'ITTF标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(12, '混合双打', 'mixed_table_tennis_doubles', 2, 3, '青少年', '混合乒乓球双打比赛', 'ITTF标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(12, '男子团体', 'male_table_tennis_team', 2, 1, '青少年', '男子乒乓球团体比赛', 'ITTF团体赛标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(12, '女子团体', 'female_table_tennis_team', 2, 2, '青少年', '女子乒乓球团体比赛', 'ITTF团体赛标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 7, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(12, '混合团体', 'mixed_table_tennis_team', 2, 3, '青少年', '混合乒乓球团体比赛', 'ITTF团体赛标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 8, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 球类项目 - 篮球（category_id=13）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(13, '男子篮球', 'male_basketball', 2, 1, '青少年', '男子5人制篮球比赛', 'FIBA标准规则', '篮球、球衣、篮球鞋', '标准篮球场', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(13, '女子篮球', 'female_basketball', 2, 2, '青少年', '女子5人制篮球比赛', 'FIBA标准规则', '篮球、球衣、篮球鞋', '标准篮球场', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(13, '三人篮球（男子）', 'male_3v3_basketball', 2, 1, '青少年', '男子3人制篮球比赛', 'FIBA 3x3标准规则', '篮球、球衣、篮球鞋', '半场篮球场', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(13, '三人篮球（女子）', 'female_3v3_basketball', 2, 2, '青少年', '女子3人制篮球比赛', 'FIBA 3x3标准规则', '篮球、球衣、篮球鞋', '半场篮球场', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(13, '三人篮球（混合）', 'mixed_3v3_basketball', 2, 3, '青少年', '混合3人制篮球比赛', 'FIBA 3x3标准规则', '篮球、球衣、篮球鞋', '半场篮球场', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 球类项目 - 足球（category_id=14）  
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(14, '男子足球', 'male_football', 2, 1, '青少年', '男子11人制足球比赛', 'FIFA标准规则', '足球、球衣、护腿板、球鞋', '标准足球场', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(14, '女子足球', 'female_football', 2, 2, '青少年', '女子11人制足球比赛', 'FIFA标准规则', '足球、球衣、护腿板、球鞋', '标准足球场', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(14, '五人制足球（男子）', 'male_futsal', 2, 1, '青少年', '男子5人制足球比赛', 'FIFA室内足球规则', '足球、球衣、护腿板、球鞋', '室内足球场', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(14, '五人制足球（女子）', 'female_futsal', 2, 2, '青少年', '女子5人制足球比赛', 'FIFA室内足球规则', '足球、球衣、护腿板、球鞋', '室内足球场', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(14, '七人制足球（男子）', 'male_7v7_football', 2, 1, '青少年', '男子7人制足球比赛', 'FIFA 7人制规则', '足球、球衣、护腿板、球鞋', '7人制足球场', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(14, '七人制足球（女子）', 'female_7v7_football', 2, 2, '青少年', '女子7人制足球比赛', 'FIFA 7人制规则', '足球、球衣、护腿板、球鞋', '7人制足球场', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 球类项目 - 排球（category_id=15）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(15, '男子排球', 'male_volleyball', 2, 1, '青少年', '男子6人制排球比赛', 'FIVB标准规则', '排球、球衣、排球鞋', '标准排球场', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(15, '女子排球', 'female_volleyball', 2, 2, '青少年', '女子6人制排球比赛', 'FIVB标准规则', '排球、球衣、排球鞋', '标准排球场', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(15, '沙滩排球（男子）', 'male_beach_volleyball', 2, 1, '青少年', '男子沙滩排球比赛', 'FIVB沙滩排球规则', '排球、沙滩服装', '沙滩排球场', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(15, '沙滩排球（女子）', 'female_beach_volleyball', 2, 2, '青少年', '女子沙滩排球比赛', 'FIVB沙滩排球规则', '排球、沙滩服装', '沙滩排球场', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(15, '沙滩排球（混合）', 'mixed_beach_volleyball', 2, 3, '青少年', '混合沙滩排球比赛', 'FIVB沙滩排球规则', '排球、沙滩服装', '沙滩排球场', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 球类项目 - 网球（category_id=16）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(16, '男子单打', 'male_tennis_singles', 1, 1, '青少年', '男子网球单打比赛', 'ITF标准规则', '网球拍、网球', '标准网球场', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(16, '女子单打', 'female_tennis_singles', 1, 2, '青少年', '女子网球单打比赛', 'ITF标准规则', '网球拍、网球', '标准网球场', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(16, '男子双打', 'male_tennis_doubles', 2, 1, '青少年', '男子网球双打比赛', 'ITF标准规则', '网球拍、网球', '标准网球场', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(16, '女子双打', 'female_tennis_doubles', 2, 2, '青少年', '女子网球双打比赛', 'ITF标准规则', '网球拍、网球', '标准网球场', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(16, '混合双打', 'mixed_tennis_doubles', 2, 3, '青少年', '混合网球双打比赛', 'ITF标准规则', '网球拍、网球', '标准网球场', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ============================================
-- 田赛项目（完整版本）
-- ============================================

-- 田赛项目 - 跳高（category_id=21）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(21, '男子跳高', 'male_high_jump', 1, 1, '青少年', '男子跳高比赛', '世界田联标准规则', '跑鞋、运动服', '跳高设施、助跑道', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(21, '女子跳高', 'female_high_jump', 1, 2, '青少年', '女子跳高比赛', '世界田联标准规则', '跑鞋、运动服', '跳高设施、助跑道', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 田赛项目 - 撑杆跳高（category_id=22）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(22, '男子撑杆跳高', 'male_pole_vault', 1, 1, '青少年', '男子撑杆跳高比赛', '世界田联标准规则', '撑杆、跑鞋、运动服', '撑杆跳高设施、助跑道', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(22, '女子撑杆跳高', 'female_pole_vault', 1, 2, '青少年', '女子撑杆跳高比赛', '世界田联标准规则', '撑杆、跑鞋、运动服', '撑杆跳高设施、助跑道', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 田赛项目 - 跳远（category_id=23）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(23, '男子跳远', 'male_long_jump', 1, 1, '青少年', '男子跳远比赛', '世界田联标准规则', '跑鞋、运动服', '跳远沙坑、助跑道', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(23, '女子跳远', 'female_long_jump', 1, 2, '青少年', '女子跳远比赛', '世界田联标准规则', '跑鞋、运动服', '跳远沙坑、助跑道', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 田赛项目 - 三级跳远（category_id=24）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(24, '男子三级跳远', 'male_triple_jump', 1, 1, '青少年', '男子三级跳远比赛', '世界田联标准规则', '跑鞋、运动服', '三级跳远沙坑、助跑道', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(24, '女子三级跳远', 'female_triple_jump', 1, 2, '青少年', '女子三级跳远比赛', '世界田联标准规则', '跑鞋、运动服', '三级跳远沙坑、助跑道', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 田赛项目 - 铅球（category_id=25）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(25, '男子铅球', 'male_shot_put', 1, 1, '青少年', '男子铅球比赛（7.26kg）', '世界田联标准规则', '铅球、运动服、运动鞋', '铅球投掷区、安全围栏', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(25, '女子铅球', 'female_shot_put', 1, 2, '青少年', '女子铅球比赛（4kg）', '世界田联标准规则', '铅球、运动服、运动鞋', '铅球投掷区、安全围栏', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 田赛项目 - 铁饼（category_id=26）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(26, '男子铁饼', 'male_discus', 1, 1, '青少年', '男子铁饼比赛（2kg）', '世界田联标准规则', '铁饼、运动服、运动鞋', '铁饼投掷区、安全围栏', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(26, '女子铁饼', 'female_discus', 1, 2, '青少年', '女子铁饼比赛（1kg）', '世界田联标准规则', '铁饼、运动服、运动鞋', '铁饼投掷区、安全围栏', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 田赛项目 - 链球（category_id=27）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(27, '男子链球', 'male_hammer', 1, 1, '青少年', '男子链球比赛（7.26kg）', '世界田联标准规则', '链球、运动服、运动鞋、手套', '链球投掷区、安全围栏', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(27, '女子链球', 'female_hammer', 1, 2, '青少年', '女子链球比赛（4kg）', '世界田联标准规则', '链球、运动服、运动鞋、手套', '链球投掷区、安全围栏', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 田赛项目 - 标枪（category_id=28）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(28, '男子标枪', 'male_javelin', 1, 1, '青少年', '男子标枪比赛（800g）', '世界田联标准规则', '标枪、运动服、运动鞋', '标枪投掷区、助跑道、安全围栏', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(28, '女子标枪', 'female_javelin', 1, 2, '青少年', '女子标枪比赛（600g）', '世界田联标准规则', '标枪、运动服、运动鞋', '标枪投掷区、助跑道、安全围栏', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

SET foreign_key_checks = 1;

-- ============================================
-- 数据验证查询
-- ============================================
SELECT '=== 修复版升级完成 ===' AS info;

-- 检查分类结构
SELECT 
    level,
    parent_id,
    COUNT(*) as category_count,
    GROUP_CONCAT(name SEPARATOR ', ') as categories
FROM sport_category 
GROUP BY level, parent_id 
ORDER BY level, parent_id;

-- 检查基础项目分布
SELECT 
    c.name as category_name,
    COUNT(bi.id) as item_count
FROM sport_category c
LEFT JOIN sport_base_item bi ON bi.category_id = c.id
WHERE c.level = 2
GROUP BY c.id, c.name
ORDER BY c.parent_id, c.sort;

SELECT '修复完成！重复显示问题已解决' AS completion_message; 
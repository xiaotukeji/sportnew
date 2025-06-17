-- Sport插件二级分类结构升级脚本（简化实用版）
-- 采用二级分类结构，操作简单，覆盖常用运动项目
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
SELECT '=== 重建二级分类结构 ===' AS info;

-- 清空数据并重置AUTO_INCREMENT
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

-- 趣味分类不设二级分类，直接在基础项目中挂载到一级分类下

-- ============================================
-- 基础项目数据（挂在二级分类下）
-- ============================================

-- 球类项目
-- 羽毛球项目（category_id=8）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(8, '男子单打', 'male_badminton_singles', 1, 1, '青少年', '男子羽毛球单打比赛', 'BWF标准规则', '羽毛球拍、羽毛球', '标准羽毛球场', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(8, '女子单打', 'female_badminton_singles', 1, 2, '青少年', '女子羽毛球单打比赛', 'BWF标准规则', '羽毛球拍、羽毛球', '标准羽毛球场', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(8, '男子双打', 'male_badminton_doubles', 2, 1, '青少年', '男子羽毛球双打比赛', 'BWF标准规则', '羽毛球拍、羽毛球', '标准羽毛球场', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(8, '女子双打', 'female_badminton_doubles', 2, 2, '青少年', '女子羽毛球双打比赛', 'BWF标准规则', '羽毛球拍、羽毛球', '标准羽毛球场', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(8, '混合双打', 'mixed_badminton_doubles', 2, 3, '青少年', '混合羽毛球双打比赛', 'BWF标准规则', '羽毛球拍、羽毛球', '标准羽毛球场', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 乒乓球项目（category_id=9）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(9, '男子单打', 'male_table_tennis_singles', 1, 1, '青少年', '男子乒乓球单打比赛', 'ITTF标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(9, '女子单打', 'female_table_tennis_singles', 1, 2, '青少年', '女子乒乓球单打比赛', 'ITTF标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(9, '男子双打', 'male_table_tennis_doubles', 2, 1, '青少年', '男子乒乓球双打比赛', 'ITTF标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(9, '女子双打', 'female_table_tennis_doubles', 2, 2, '青少年', '女子乒乓球双打比赛', 'ITTF标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(9, '混合双打', 'mixed_table_tennis_doubles', 2, 3, '青少年', '混合乒乓球双打比赛', 'ITTF标准规则', '乒乓球拍、乒乓球', '标准乒乓球台', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 篮球项目（category_id=10）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(10, '男子篮球', 'male_basketball', 2, 1, '青少年', '男子5人制篮球比赛', 'FIBA标准规则', '篮球、球衣、篮球鞋', '标准篮球场', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(10, '女子篮球', 'female_basketball', 2, 2, '青少年', '女子5人制篮球比赛', 'FIBA标准规则', '篮球、球衣、篮球鞋', '标准篮球场', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(10, '三人篮球（男子）', 'male_3v3_basketball', 2, 1, '青少年', '男子3人制篮球比赛', 'FIBA 3x3标准规则', '篮球、球衣、篮球鞋', '半场篮球场', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(10, '三人篮球（女子）', 'female_3v3_basketball', 2, 2, '青少年', '女子3人制篮球比赛', 'FIBA 3x3标准规则', '篮球、球衣、篮球鞋', '半场篮球场', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 足球项目（category_id=11）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(11, '男子足球', 'male_football', 2, 1, '青少年', '男子11人制足球比赛', 'FIFA标准规则', '足球、球衣、护腿板、球鞋', '标准足球场', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '女子足球', 'female_football', 2, 2, '青少年', '女子11人制足球比赛', 'FIFA标准规则', '足球、球衣、护腿板、球鞋', '标准足球场', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '五人制足球（男子）', 'male_futsal', 2, 1, '青少年', '男子5人制足球比赛', 'FIFA室内足球规则', '足球、球衣、护腿板、球鞋', '室内足球场', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(11, '五人制足球（女子）', 'female_futsal', 2, 2, '青少年', '女子5人制足球比赛', 'FIFA室内足球规则', '足球、球衣、护腿板、球鞋', '室内足球场', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 田赛项目
-- 跳高项目（category_id=14）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(14, '男子跳高', 'male_high_jump', 1, 1, '青少年', '男子跳高比赛', '国际田联标准规则', '跑鞋、运动服', '跳高设施', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(14, '女子跳高', 'female_high_jump', 1, 2, '青少年', '女子跳高比赛', '国际田联标准规则', '跑鞋、运动服', '跳高设施', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 跳远项目（category_id=16）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(16, '男子跳远', 'male_long_jump', 1, 1, '青少年', '男子跳远比赛', '国际田联标准规则', '跑鞋、运动服', '跳远沙坑', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(16, '女子跳远', 'female_long_jump', 1, 2, '青少年', '女子跳远比赛', '国际田联标准规则', '跑鞋、运动服', '跳远沙坑', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 铅球项目（category_id=18）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(18, '男子铅球', 'male_shot_put', 1, 1, '青少年', '男子铅球比赛', '国际田联标准规则', '铅球、运动服、运动鞋', '铅球投掷区', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(18, '女子铅球', 'female_shot_put', 1, 2, '青少年', '女子铅球比赛', '国际田联标准规则', '铅球、运动服、运动鞋', '铅球投掷区', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 径赛项目
-- 短跑项目（category_id=22）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(22, '男子100米', 'male_100m_sprint', 1, 1, '青少年', '男子100米短跑比赛', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(22, '女子100米', 'female_100m_sprint', 1, 2, '青少年', '女子100米短跑比赛', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(22, '男子200米', 'male_200m_sprint', 1, 1, '青少年', '男子200米短跑比赛', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(22, '女子200米', 'female_200m_sprint', 1, 2, '青少年', '女子200米短跑比赛', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 中长跑项目（category_id=23）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(23, '男子800米', 'male_800m', 1, 1, '青少年', '男子800米中跑比赛', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(23, '女子800米', 'female_800m', 1, 2, '青少年', '女子800米中跑比赛', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(23, '男子1500米', 'male_1500m', 1, 1, '青少年', '男子1500米中长跑比赛', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(23, '女子1500米', 'female_1500m', 1, 2, '青少年', '女子1500米中长跑比赛', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 接力项目（category_id=24）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(24, '男子4×100米接力', 'male_4x100_relay', 2, 1, '青少年', '男子4×100米接力比赛', '国际田联标准规则', '接力棒、跑鞋、运动服', '400米标准田径场', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(24, '女子4×100米接力', 'female_4x100_relay', 2, 2, '青少年', '女子4×100米接力比赛', '国际田联标准规则', '接力棒、跑鞋、运动服', '400米标准田径场', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(24, '男子4×400米接力', 'male_4x400_relay', 2, 1, '青少年', '男子4×400米接力比赛', '国际田联标准规则', '接力棒、跑鞋、运动服', '400米标准田径场', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(24, '女子4×400米接力', 'female_4x400_relay', 2, 2, '青少年', '女子4×400米接力比赛', '国际田联标准规则', '接力棒、跑鞋、运动服', '400米标准田径场', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 游泳项目
-- 自由泳项目（category_id=28）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(28, '男子50米自由泳', 'male_50m_freestyle', 1, 1, '青少年', '男子50米自由泳比赛', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(28, '女子50米自由泳', 'female_50m_freestyle', 1, 2, '青少年', '女子50米自由泳比赛', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(28, '男子100米自由泳', 'male_100m_freestyle', 1, 1, '青少年', '男子100米自由泳比赛', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(28, '女子100米自由泳', 'female_100m_freestyle', 1, 2, '青少年', '女子100米自由泳比赛', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 蛙泳项目（category_id=29）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(29, '男子100米蛙泳', 'male_100m_breaststroke', 1, 1, '青少年', '男子100米蛙泳比赛', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(29, '女子100米蛙泳', 'female_100m_breaststroke', 1, 2, '青少年', '女子100米蛙泳比赛', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 棋类项目
-- 中国象棋项目（category_id=34）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(34, '中国象棋比赛', 'chinese_chess_match', 1, 3, '青少年', '中国象棋比赛', '中国象棋协会标准规则', '象棋棋盘、象棋子', '标准比赛桌椅', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 围棋项目（category_id=35）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(35, '围棋比赛', 'go_match', 1, 3, '青少年', '围棋比赛', '中国围棋协会标准规则', '围棋棋盘、围棋子', '标准比赛桌椅', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 国际象棋项目（category_id=36）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
(36, '国际象棋比赛', 'international_chess_match', 1, 3, '青少年', '国际象棋比赛', '国际象棋联合会标准规则', '国际象棋棋盘、棋子', '标准比赛桌椅', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 趣味项目（直接挂在一级分类下，category_id=6）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
-- 团队协作类
(6, '拔河比赛', 'tug_of_war', 2, 3, '青少年', '团队拔河比赛', '国际拔河协会标准规则', '拔河绳、标志线', '平坦场地', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '三人四足', 'three_legged_race', 2, 3, '青少年', '三人四足接力赛', '趣味运动标准规则', '绑腿绳', '平坦跑道', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '人桥接力', 'human_bridge_relay', 2, 3, '青少年', '人桥接力比赛', '趣味运动标准规则', '无特殊器材', '平坦场地', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '团队跳绳', 'team_rope_jumping', 2, 3, '青少年', '团队跳绳比赛', '跳绳协会标准规则', '长跳绳', '平坦场地', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 平衡技巧类
(6, '踩气球', 'balloon_stepping', 1, 3, '青少年', '踩气球比赛', '趣味运动标准规则', '气球、绳子', '平坦场地', 11, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '滚铁环', 'hoop_rolling', 1, 3, '青少年', '滚铁环比赛', '传统体育规则', '铁环、铁钩', '平坦跑道', 12, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '独轮车比赛', 'unicycle_race', 1, 3, '青少年', '独轮车比赛', '独轮车协会标准规则', '独轮车、护具', '平坦跑道', 13, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '平衡木行走', 'balance_beam_walking', 1, 3, '青少年', '平衡木行走比赛', '趣味运动标准规则', '平衡木', '室内或室外场地', 14, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 投掷类
(6, '飞镖投掷', 'dart_throwing', 1, 3, '青少年', '飞镖投掷比赛', '国际飞镖协会标准规则', '飞镖、飞镖靶', '室内场地', 21, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '沙包投准', 'sandbag_throwing', 1, 3, '青少年', '沙包投准比赛', '趣味运动标准规则', '沙包、目标圈', '平坦场地', 22, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '套圈游戏', 'ring_toss', 1, 3, '青少年', '套圈游戏比赛', '趣味运动标准规则', '圆圈、目标柱', '平坦场地', 23, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '趣味保龄球', 'fun_bowling', 1, 3, '青少年', '用球击倒矿泉水瓶比赛', '趣味运动标准规则', '球、矿泉水瓶', '平坦场地', 24, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 趣味竞技类
(6, '吃西瓜比赛', 'watermelon_eating', 1, 3, '青少年', '吃西瓜速度比赛', '趣味运动标准规则', '西瓜、餐具', '室内或室外场地', 31, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '穿针引线', 'needle_threading', 1, 3, '青少年', '穿针引线比赛', '趣味运动标准规则', '针、线', '室内场地', 32, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '背靠背运球', 'back_to_back_ball_carry', 2, 3, '青少年', '背靠背运球比赛', '趣味运动标准规则', '气球或排球', '平坦场地', 33, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '蒙眼摸象', 'blind_man_bluff', 1, 3, '青少年', '蒙眼摸象比赛', '趣味运动标准规则', '眼罩、目标物品', '安全场地', 34, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 水上趣味项目
(6, '水上拔河', 'water_tug_of_war', 2, 3, '青少年', '水上拔河比赛', '水上运动安全规则', '防水拔河绳、救生设备', '游泳池或安全水域', 41, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '水上篮球', 'water_basketball', 2, 3, '青少年', '水上篮球比赛', '水上运动安全规则', '防水篮球、浮动篮筐、救生设备', '游泳池', 42, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
(6, '水上漂浮比赛', 'water_floating', 1, 3, '青少年', '水上漂浮时长比赛', '水上运动安全规则', '救生设备', '游泳池或安全水域', 43, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ============================================
-- 完成统计和验证
-- ============================================
SELECT '=== 二级分类结构升级完成 ===' AS info;

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
        WHEN c1.code = 'fun_sports' THEN COUNT(bi.id)
        ELSE COUNT(c2.id)
    END AS second_level_count,
    COUNT(bi.id) AS base_items_count
FROM sport_category c1
LEFT JOIN sport_category c2 ON c2.parent_id = c1.id AND c2.level = 2
LEFT JOIN sport_base_item bi ON (bi.category_id = c2.id OR (c1.code = 'fun_sports' AND bi.category_id = c1.id))
WHERE c1.level = 1
GROUP BY c1.id, c1.name, c1.code
ORDER BY c1.sort;

SELECT '升级完成！系统现在使用简化的二级分类结构，趣味项目直接挂在一级分类下' AS completion_message; 
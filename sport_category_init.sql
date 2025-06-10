-- 运动项目分类初始化数据
-- 清空现有数据
TRUNCATE TABLE `sport_category`;

-- 插入一级分类（使用固定ID）
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
(11, '其他', 'others', 0, 1, '11', 11, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 插入二级分类
-- 田径类子项目 (parent_id = 1)
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('短跑', 'sprint', 1, 2, '1,12', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('中跑', 'middle_distance', 1, 2, '1,13', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('长跑', 'long_distance', 1, 2, '1,14', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('马拉松', 'marathon', 1, 2, '1,15', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('接力赛', 'relay', 1, 2, '1,16', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('跳远', 'long_jump', 1, 2, '1,17', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('跳高', 'high_jump', 1, 2, '1,18', 7, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('铅球', 'shot_put', 1, 2, '1,19', 8, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('铁饼', 'discus', 1, 2, '1,20', 9, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 球类子项目 (parent_id = 2)
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('足球', 'football', 2, 2, '2,21', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('篮球', 'basketball', 2, 2, '2,22', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('乒乓球', 'table_tennis', 2, 2, '2,23', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('网球', 'tennis', 2, 2, '2,24', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('排球', 'volleyball', 2, 2, '2,25', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('羽毛球', 'badminton', 2, 2, '2,26', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 水上运动子项目 (parent_id = 3)
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('游泳', 'swimming', 3, 2, '3,27', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('跳水', 'diving', 3, 2, '3,28', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('水球', 'water_polo', 3, 2, '3,29', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('划船', 'rowing', 3, 2, '3,30', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('帆船', 'sailing', 3, 2, '3,31', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 体操类子项目 (parent_id = 4)
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('艺术体操', 'rhythmic_gymnastics', 4, 2, '4,32', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('竞技体操', 'artistic_gymnastics', 4, 2, '4,33', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('蹦床', 'trampoline', 4, 2, '4,34', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 武术类子项目 (parent_id = 5)
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('太极拳', 'tai_chi', 5, 2, '5,35', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('散打', 'sanda', 5, 2, '5,36', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('跆拳道', 'taekwondo', 5, 2, '5,37', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('空手道', 'karate', 5, 2, '5,38', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 极限运动子项目 (parent_id = 6)
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('滑雪', 'skiing', 6, 2, '6,39', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('滑板', 'skateboarding', 6, 2, '6,40', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('攀岩', 'rock_climbing', 6, 2, '6,41', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('跳伞', 'parachuting', 6, 2, '6,42', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 冰雪运动子项目 (parent_id = 7)
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('滑冰', 'ice_skating', 7, 2, '7,43', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('冰雪滑雪', 'alpine_skiing', 7, 2, '7,44', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('冰球', 'hockey', 7, 2, '7,45', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('雪车', 'bobsled', 7, 2, '7,46', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 格斗类子项目 (parent_id = 8)
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('拳击', 'boxing', 8, 2, '8,47', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('摔跤', 'wrestling', 8, 2, '8,48', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('柔道', 'judo', 8, 2, '8,49', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('巴西柔术', 'bjj', 8, 2, '8,50', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 射击类子项目 (parent_id = 9)
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('手枪射击', 'pistol_shooting', 9, 2, '9,51', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('步枪射击', 'rifle_shooting', 9, 2, '9,52', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('飞碟射击', 'trap_shooting', 9, 2, '9,53', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 棋类子项目 (parent_id = 10)
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('中国象棋', 'chinese_chess', 10, 2, '10,54', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('围棋', 'go', 10, 2, '10,55', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('国际象棋', 'international_chess', 10, 2, '10,56', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 其他类子项目 (parent_id = 11)
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('体育舞蹈', 'sports_dance', 11, 2, '11,57', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('自行车', 'cycling', 11, 2, '11,58', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('高尔夫', 'golf', 11, 2, '11,59', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('马术', 'equestrian', 11, 2, '11,60', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()); 
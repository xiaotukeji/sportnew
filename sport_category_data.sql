-- 运动项目分类初始化数据
-- 作者：NiuCloud Team
-- 日期：2024

-- 清空现有数据
TRUNCATE TABLE `sport_category`;

-- 插入一级分类
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
('其他', 'others', 0, 1, '11', 11, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 获取一级分类ID并插入二级分类
-- 田径类子项目
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '短跑', 'sprint', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'track_field';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '中跑', 'middle_distance', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'track_field';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '长跑', 'long_distance', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'track_field';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '马拉松', 'marathon', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'track_field';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '接力赛', 'relay', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'track_field';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '跳远', 'long_jump', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'track_field';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '跳高', 'high_jump', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 7, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'track_field';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '铅球', 'shot_put', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 8, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'track_field';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '铁饼', 'discus', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 9, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'track_field';

-- 球类子项目
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '足球', 'football', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'ball_sports';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '篮球', 'basketball', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'ball_sports';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '乒乓球', 'table_tennis', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'ball_sports';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '网球', 'tennis', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'ball_sports';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '排球', 'volleyball', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'ball_sports';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '羽毛球', 'badminton', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'ball_sports';

-- 水上运动子项目
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '游泳', 'swimming', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'water_sports';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '跳水', 'diving', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'water_sports';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '水球', 'water_polo', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'water_sports';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '划船', 'rowing', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'water_sports';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '帆船', 'sailing', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'water_sports';

-- 体操类子项目
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '艺术体操', 'rhythmic_gymnastics', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'gymnastics';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '竞技体操', 'artistic_gymnastics', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'gymnastics';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '蹦床', 'trampoline', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'gymnastics';

-- 武术类子项目
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '太极拳', 'tai_chi', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'martial_arts';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '散打', 'sanda', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'martial_arts';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '跆拳道', 'taekwondo', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'martial_arts';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '空手道', 'karate', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'martial_arts';

-- 极限运动子项目
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '滑雪', 'skiing', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'extreme_sports';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '滑板', 'skateboarding', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'extreme_sports';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '攀岩', 'rock_climbing', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'extreme_sports';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '跳伞', 'parachuting', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'extreme_sports';

-- 冰雪运动子项目
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '滑冰', 'ice_skating', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'ice_snow_sports';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '冰雪滑雪', 'alpine_skiing', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'ice_snow_sports';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '冰球', 'hockey', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'ice_snow_sports';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '雪车', 'bobsled', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'ice_snow_sports';

-- 格斗类子项目
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '拳击', 'boxing', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'combat_sports';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '摔跤', 'wrestling', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'combat_sports';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '柔道', 'judo', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'combat_sports';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '巴西柔术', 'bjj', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'combat_sports';

-- 射击类子项目
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '手枪射击', 'pistol_shooting', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'shooting';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '步枪射击', 'rifle_shooting', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'shooting';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '飞碟射击', 'trap_shooting', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'shooting';

-- 棋类子项目
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '中国象棋', 'chinese_chess', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'chess';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '围棋', 'go', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'chess';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '国际象棋', 'chess', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'chess';

-- 其他类子项目
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '体育舞蹈', 'sports_dance', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'others';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '自行车', 'cycling', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'others';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '高尔夫', 'golf', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'others';

INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) 
SELECT '马术', 'equestrian', c.id, 2, CONCAT(c.path, ',', (SELECT MAX(id)+1 FROM sport_category)), 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() FROM `sport_category` c WHERE c.code = 'others'; 
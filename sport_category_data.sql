-- 运动项目分类初始化数据
-- 作者：NiuCloud Team
-- 日期：2024

-- 清空现有数据
TRUNCATE TABLE `sport_category`;

-- 插入一级分类
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

-- 插入二级分类
-- 田径类子项目 (parent_id = 1)
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('短跑', 'sprint', 1, 2, '1', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('中跑', 'middle_distance', 1, 2, '1', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('长跑', 'long_distance', 1, 2, '1', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('马拉松', 'marathon', 1, 2, '1', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('接力赛', 'relay', 1, 2, '1', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('跳远', 'long_jump', 1, 2, '1', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('跳高', 'high_jump', 1, 2, '1', 7, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('铅球', 'shot_put', 1, 2, '1', 8, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('铁饼', 'discus', 1, 2, '1', 9, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 球类子项目 (parent_id = 2)
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('足球', 'football', 2, 2, '2', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('篮球', 'basketball', 2, 2, '2', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('乒乓球', 'table_tennis', 2, 2, '2', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('网球', 'tennis', 2, 2, '2', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('排球', 'volleyball', 2, 2, '2', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('羽毛球', 'badminton', 2, 2, '2', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 水上运动子项目 (parent_id = 3)
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('游泳', 'swimming', 3, 2, '3', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('跳水', 'diving', 3, 2, '3', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('水球', 'water_polo', 3, 2, '3', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('划船', 'rowing', 3, 2, '3', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('帆船', 'sailing', 3, 2, '3', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 体操类子项目 (parent_id = 4)
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('艺术体操', 'rhythmic_gymnastics', 4, 2, '4', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('竞技体操', 'artistic_gymnastics', 4, 2, '4', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('蹦床', 'trampoline', 4, 2, '4', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 武术类子项目 (parent_id = 5)
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('太极拳', 'tai_chi', 5, 2, '5', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('散打', 'sanda', 5, 2, '5', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('跆拳道', 'taekwondo', 5, 2, '5', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('空手道', 'karate', 5, 2, '5', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 极限运动子项目 (parent_id = 6)
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('滑雪', 'skiing', 6, 2, '6', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('滑板', 'skateboarding', 6, 2, '6', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('攀岩', 'rock_climbing', 6, 2, '6', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('跳伞', 'parachuting', 6, 2, '6', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 冰雪运动子项目 (parent_id = 7)
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('滑冰', 'ice_skating', 7, 2, '7', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('冰雪滑雪', 'alpine_skiing', 7, 2, '7', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('冰球', 'hockey', 7, 2, '7', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('雪车', 'bobsled', 7, 2, '7', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 格斗类子项目 (parent_id = 8)
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('拳击', 'boxing', 8, 2, '8', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('摔跤', 'wrestling', 8, 2, '8', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('柔道', 'judo', 8, 2, '8', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('巴西柔术', 'bjj', 8, 2, '8', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 射击类子项目 (parent_id = 9)
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('手枪射击', 'pistol_shooting', 9, 2, '9', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('步枪射击', 'rifle_shooting', 9, 2, '9', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('飞碟射击', 'trap_shooting', 9, 2, '9', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 棋类子项目 (parent_id = 10)
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('中国象棋', 'chinese_chess', 10, 2, '10', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('围棋', 'go', 10, 2, '10', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('国际象棋', 'international_chess', 10, 2, '10', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 趣味比赛子项目 (parent_id = 11)
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
-- 传统趣味项目
('拔河比赛', 'tug_of_war', 11, 2, '11', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('三人四足', 'three_legged_race', 11, 2, '11', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('袋鼠跳', 'sack_race', 11, 2, '11', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('摸石头过河', 'stepping_stones', 11, 2, '11', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('踢毽子', 'shuttlecock_kicking', 11, 2, '11', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('跳绳接力', 'rope_skipping_relay', 11, 2, '11', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 球类趣味变种
('背靠背运球', 'back_to_back_ball', 11, 2, '11', 7, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('乒乓板接力', 'ping_pong_relay', 11, 2, '11', 8, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('盲射足球', 'blindfolded_football', 11, 2, '11', 9, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('保龄球大战', 'bowling_battle', 11, 2, '11', 10, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('气球排球', 'balloon_volleyball', 11, 2, '11', 11, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 速度与平衡挑战
('指压板赛跑', 'pressure_plate_race', 11, 2, '11', 12, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('独轮车运粮', 'wheelbarrow_transport', 11, 2, '11', 13, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('转圈射门', 'dizzy_goal', 11, 2, '11', 14, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('平衡木对决', 'balance_beam_duel', 11, 2, '11', 15, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('倒跑接力赛', 'backward_running_relay', 11, 2, '11', 16, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 创意道具类
('充气障碍赛', 'inflatable_obstacle_race', 11, 2, '11', 17, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('枕头大战', 'pillow_fight', 11, 2, '11', 18, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('水球大乱斗', 'water_balloon_fight', 11, 2, '11', 19, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('泡沫滑道赛', 'foam_slide_race', 11, 2, '11', 20, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('彩虹跑', 'color_run', 11, 2, '11', 21, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 智力+体力结合
('谜语接力', 'puzzle_relay', 11, 2, '11', 22, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('拼图寻宝', 'puzzle_treasure_hunt', 11, 2, '11', 23, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('盲人方阵', 'blind_formation', 11, 2, '11', 24, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('记忆翻牌短跑', 'memory_card_sprint', 11, 2, '11', 25, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 搞笑整蛊类
('面粉吹球', 'flour_ball_blowing', 11, 2, '11', 26, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('挤爆气球', 'balloon_popping', 11, 2, '11', 27, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('柠檬挑战', 'lemon_challenge', 11, 2, '11', 28, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('蒙眼互喂', 'blindfolded_feeding', 11, 2, '11', 29, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 其他类子项目 (parent_id = 12)
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
('体育舞蹈', 'sports_dance', 12, 2, '12', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('自行车', 'cycling', 12, 2, '12', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('高尔夫', 'golf', 12, 2, '12', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('马术', 'equestrian', 12, 2, '12', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()); 
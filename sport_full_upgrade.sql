-- Sport插件完整升级脚本
-- 支持四级分类结构、详细基础项目和年龄组功能
-- 执行时间：2024-03-21

-- ============================================
-- 第一步：升级赛事表，添加年龄组支持
-- ============================================

-- 添加年龄组相关字段
ALTER TABLE `sport_event` 
ADD COLUMN `age_groups` TEXT COMMENT '年龄组设置，JSON格式存储多选：["青少年","成年","老年"]' AFTER `status`,
ADD COLUMN `age_group_display` TINYINT(1) DEFAULT 1 COMMENT '是否显示年龄组前缀：0=不显示 1=显示（当选择多个年龄组时自动显示）' AFTER `age_groups`;

-- 为现有数据设置默认值
UPDATE `sport_event` SET 
    `age_groups` = '["不限年龄"]',
    `age_group_display` = 0
WHERE `age_groups` IS NULL;

-- ============================================
-- 第二步：重建四级分类结构
-- ============================================

-- 备份现有分类数据
CREATE TABLE IF NOT EXISTS `sport_category_backup` AS SELECT * FROM `sport_category`;

-- 清空现有分类数据，重新建立四级结构
TRUNCATE TABLE `sport_category`;

-- 一级分类（12个大类）
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

-- 二级分类（主要运动项目）
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
-- 水上运动的二级分类
('游泳', 'swimming', 3, 2, '3', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('跳水', 'diving', 3, 2, '3', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('水球', 'water_polo', 3, 2, '3', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('花样游泳', 'synchronized_swimming', 3, 2, '3', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 田径类的二级分类  
('径赛', 'track_events', 1, 2, '1', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('田赛', 'field_events', 1, 2, '1', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('全能', 'combined_events', 1, 2, '1', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 球类的二级分类
('大球', 'big_ball', 2, 2, '2', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('小球', 'small_ball', 2, 2, '2', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 三级分类（具体运动种类）
INSERT INTO `sport_category` (`name`, `code`, `parent_id`, `level`, `path`, `sort`, `status`, `create_time`, `update_time`) VALUES
-- 游泳的三级分类
('自由泳', 'freestyle', (SELECT id FROM sport_category WHERE code='swimming'), 3, '3', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('仰泳', 'backstroke', (SELECT id FROM sport_category WHERE code='swimming'), 3, '3', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('蛙泳', 'breaststroke', (SELECT id FROM sport_category WHERE code='swimming'), 3, '3', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('蝶泳', 'butterfly', (SELECT id FROM sport_category WHERE code='swimming'), 3, '3', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('混合泳', 'medley', (SELECT id FROM sport_category WHERE code='swimming'), 3, '3', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('接力', 'relay', (SELECT id FROM sport_category WHERE code='swimming'), 3, '3', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 径赛的三级分类
('短跑', 'sprint', (SELECT id FROM sport_category WHERE code='track_events'), 3, '1', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('中跑', 'middle_distance', (SELECT id FROM sport_category WHERE code='track_events'), 3, '1', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('长跑', 'long_distance', (SELECT id FROM sport_category WHERE code='track_events'), 3, '1', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('跨栏', 'hurdles', (SELECT id FROM sport_category WHERE code='track_events'), 3, '1', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('接力', 'track_relay', (SELECT id FROM sport_category WHERE code='track_events'), 3, '1', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 田赛的三级分类
('跳跃', 'jumping', (SELECT id FROM sport_category WHERE code='field_events'), 3, '1', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('投掷', 'throwing', (SELECT id FROM sport_category WHERE code='field_events'), 3, '1', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 大球的三级分类
('足球', 'football', (SELECT id FROM sport_category WHERE code='big_ball'), 3, '2', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('篮球', 'basketball', (SELECT id FROM sport_category WHERE code='big_ball'), 3, '2', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('排球', 'volleyball', (SELECT id FROM sport_category WHERE code='big_ball'), 3, '2', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 小球的三级分类
('乒乓球', 'table_tennis', (SELECT id FROM sport_category WHERE code='small_ball'), 3, '2', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('羽毛球', 'badminton', (SELECT id FROM sport_category WHERE code='small_ball'), 3, '2', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
('网球', 'tennis', (SELECT id FROM sport_category WHERE code='small_ball'), 3, '2', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ============================================
-- 第三步：重建详细基础项目数据
-- ============================================

-- 备份现有基础项目数据
CREATE TABLE IF NOT EXISTS `sport_base_item_backup` AS SELECT * FROM `sport_base_item`;

-- 清空现有基础项目数据
TRUNCATE TABLE `sport_base_item`;

-- 游泳项目详细数据
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES

-- 自由泳项目
-- 男子自由泳
((SELECT id FROM sport_category WHERE code='freestyle'), '男子50米自由泳', 'male_50m_freestyle', 1, 1, '青少年', '男子50米自由泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='freestyle'), '男子100米自由泳', 'male_100m_freestyle', 1, 1, '青少年', '男子100米自由泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='freestyle'), '男子200米自由泳', 'male_200m_freestyle', 1, 1, '青少年', '男子200米自由泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='freestyle'), '男子400米自由泳', 'male_400m_freestyle', 1, 1, '青少年', '男子400米自由泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='freestyle'), '男子800米自由泳', 'male_800m_freestyle', 1, 1, '青少年', '男子800米自由泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='freestyle'), '男子1500米自由泳', 'male_1500m_freestyle', 1, 1, '青少年', '男子1500米自由泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 女子自由泳
((SELECT id FROM sport_category WHERE code='freestyle'), '女子50米自由泳', 'female_50m_freestyle', 1, 2, '青少年', '女子50米自由泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 11, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='freestyle'), '女子100米自由泳', 'female_100m_freestyle', 1, 2, '青少年', '女子100米自由泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 12, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='freestyle'), '女子200米自由泳', 'female_200m_freestyle', 1, 2, '青少年', '女子200米自由泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 13, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='freestyle'), '女子400米自由泳', 'female_400m_freestyle', 1, 2, '青少年', '女子400米自由泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 14, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='freestyle'), '女子800米自由泳', 'female_800m_freestyle', 1, 2, '青少年', '女子800米自由泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 15, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='freestyle'), '女子1500米自由泳', 'female_1500m_freestyle', 1, 2, '青少年', '女子1500米自由泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 16, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 仰泳项目
-- 男子仰泳
((SELECT id FROM sport_category WHERE code='backstroke'), '男子50米仰泳', 'male_50m_backstroke', 1, 1, '青少年', '男子50米仰泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 21, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='backstroke'), '男子100米仰泳', 'male_100m_backstroke', 1, 1, '青少年', '男子100米仰泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 22, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='backstroke'), '男子200米仰泳', 'male_200m_backstroke', 1, 1, '青少年', '男子200米仰泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 23, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 女子仰泳
((SELECT id FROM sport_category WHERE code='backstroke'), '女子50米仰泳', 'female_50m_backstroke', 1, 2, '青少年', '女子50米仰泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 31, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='backstroke'), '女子100米仰泳', 'female_100m_backstroke', 1, 2, '青少年', '女子100米仰泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 32, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='backstroke'), '女子200米仰泳', 'female_200m_backstroke', 1, 2, '青少年', '女子200米仰泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 33, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 蛙泳项目
-- 男子蛙泳
((SELECT id FROM sport_category WHERE code='breaststroke'), '男子50米蛙泳', 'male_50m_breaststroke', 1, 1, '青少年', '男子50米蛙泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 41, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='breaststroke'), '男子100米蛙泳', 'male_100m_breaststroke', 1, 1, '青少年', '男子100米蛙泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 42, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='breaststroke'), '男子200米蛙泳', 'male_200m_breaststroke', 1, 1, '青少年', '男子200米蛙泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 43, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 女子蛙泳
((SELECT id FROM sport_category WHERE code='breaststroke'), '女子50米蛙泳', 'female_50m_breaststroke', 1, 2, '青少年', '女子50米蛙泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 51, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='breaststroke'), '女子100米蛙泳', 'female_100m_breaststroke', 1, 2, '青少年', '女子100米蛙泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 52, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='breaststroke'), '女子200米蛙泳', 'female_200m_breaststroke', 1, 2, '青少年', '女子200米蛙泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 53, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 蝶泳项目
-- 男子蝶泳
((SELECT id FROM sport_category WHERE code='butterfly'), '男子50米蝶泳', 'male_50m_butterfly', 1, 1, '青少年', '男子50米蝶泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 61, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='butterfly'), '男子100米蝶泳', 'male_100m_butterfly', 1, 1, '青少年', '男子100米蝶泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 62, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='butterfly'), '男子200米蝶泳', 'male_200m_butterfly', 1, 1, '青少年', '男子200米蝶泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 63, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 女子蝶泳
((SELECT id FROM sport_category WHERE code='butterfly'), '女子50米蝶泳', 'female_50m_butterfly', 1, 2, '青少年', '女子50米蝶泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 71, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='butterfly'), '女子100米蝶泳', 'female_100m_butterfly', 1, 2, '青少年', '女子100米蝶泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 72, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='butterfly'), '女子200米蝶泳', 'female_200m_butterfly', 1, 2, '青少年', '女子200米蝶泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 73, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 混合泳项目
-- 男子混合泳
((SELECT id FROM sport_category WHERE code='medley'), '男子200米个人混合泳', 'male_200m_medley', 1, 1, '青少年', '男子200米个人混合泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 81, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='medley'), '男子400米个人混合泳', 'male_400m_medley', 1, 1, '青少年', '男子400米个人混合泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 82, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 女子混合泳
((SELECT id FROM sport_category WHERE code='medley'), '女子200米个人混合泳', 'female_200m_medley', 1, 2, '青少年', '女子200米个人混合泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 91, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='medley'), '女子400米个人混合泳', 'female_400m_medley', 1, 2, '青少年', '女子400米个人混合泳项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 92, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 接力项目
((SELECT id FROM sport_category WHERE code='relay'), '男子4×50米自由泳接力', 'male_4x50m_freestyle_relay', 2, 1, '青少年', '男子4×50米自由泳接力项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 101, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='relay'), '男子4×100米自由泳接力', 'male_4x100m_freestyle_relay', 2, 1, '青少年', '男子4×100米自由泳接力项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 102, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='relay'), '女子4×50米自由泳接力', 'female_4x50m_freestyle_relay', 2, 2, '青少年', '女子4×50米自由泳接力项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 111, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='relay'), '女子4×100米自由泳接力', 'female_4x100m_freestyle_relay', 2, 2, '青少年', '女子4×100米自由泳接力项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 112, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='relay'), '混合4×100米自由泳接力', 'mixed_4x100m_freestyle_relay', 2, 3, '青少年', '混合4×100米自由泳接力项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 121, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='relay'), '男子4×100米混合泳接力', 'male_4x100m_medley_relay', 2, 1, '青少年', '男子4×100米混合泳接力项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 122, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='relay'), '女子4×100米混合泳接力', 'female_4x100m_medley_relay', 2, 2, '青少年', '女子4×100米混合泳接力项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 123, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='relay'), '混合4×100米混合泳接力', 'mixed_4x100m_medley_relay', 2, 3, '青少年', '混合4×100米混合泳接力项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 124, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 田径短跑项目示例
-- 男子短跑
((SELECT id FROM sport_category WHERE code='sprint'), '男子100米', 'male_100m_sprint', 1, 1, '青少年', '男子100米短跑项目', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 201, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='sprint'), '男子200米', 'male_200m_sprint', 1, 1, '青少年', '男子200米短跑项目', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 202, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='sprint'), '男子400米', 'male_400m_sprint', 1, 1, '青少年', '男子400米短跑项目', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 203, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 女子短跑
((SELECT id FROM sport_category WHERE code='sprint'), '女子100米', 'female_100m_sprint', 1, 2, '青少年', '女子100米短跑项目', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 211, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='sprint'), '女子200米', 'female_200m_sprint', 1, 2, '青少年', '女子200米短跑项目', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 212, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='sprint'), '女子400米', 'female_400m_sprint', 1, 2, '青少年', '女子400米短跑项目', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 213, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- ============================================
-- 升级完成统计
-- ============================================
SELECT '=== 升级完成统计 ===' AS info;

-- 分类统计
SELECT 
    CONCAT('分类总数: ', COUNT(*)) as category_count,
    CONCAT('一级分类: ', SUM(CASE WHEN level = 1 THEN 1 ELSE 0 END)) as level1,
    CONCAT('二级分类: ', SUM(CASE WHEN level = 2 THEN 1 ELSE 0 END)) as level2,
    CONCAT('三级分类: ', SUM(CASE WHEN level = 3 THEN 1 ELSE 0 END)) as level3
FROM sport_category;

-- 基础项目统计
SELECT 
    CONCAT('基础项目总数: ', COUNT(*)) as base_item_count,
    CONCAT('游泳项目: ', SUM(CASE WHEN category_id IN (SELECT id FROM sport_category WHERE parent_id = (SELECT id FROM sport_category WHERE code='swimming')) THEN 1 ELSE 0 END)) as swimming_items,
    CONCAT('田径项目: ', SUM(CASE WHEN category_id IN (SELECT id FROM sport_category WHERE parent_id IN (SELECT id FROM sport_category WHERE code IN ('track_events', 'field_events'))) THEN 1 ELSE 0 END)) as track_field_items
FROM sport_base_item;

-- 年龄组功能说明
SELECT 
    '年龄组功能已启用：
    - age_groups: JSON格式存储，支持多选
    - age_group_display: 控制显示逻辑
    - 项目名称根据年龄组设置动态生成
    
    使用示例：
    - ["不限年龄"] → 男子100米自由泳
    - ["青少年"] → 男子100米自由泳
    - ["青少年","成年"] → 青少年男子100米自由泳、成年男子100米自由泳
    
    四级分类结构：
    - 一级：水上运动、田径类等12个大类
    - 二级：游泳、径赛、田赛等项目类型
    - 三级：自由泳、短跑等具体运动
    - 四级：男子100米自由泳等详细项目
    ' as upgrade_notes; 
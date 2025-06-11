-- Sport运动会插件卸载脚本
-- 版本：v1.0.0
-- 作者：NiuCloud Team
-- 创建时间：2024-03-21

-- ============================================
-- 删除数据表
-- ============================================

-- 删除导航配置表
DROP TABLE IF EXISTS `sport_nav_config`;

-- 删除主办方表
DROP TABLE IF EXISTS `sport_organizer`;

-- 删除比赛成绩表
DROP TABLE IF EXISTS `sport_score`;

-- 删除报名记录表
DROP TABLE IF EXISTS `sport_registration`;

-- 删除参赛人员表
DROP TABLE IF EXISTS `sport_athlete`;

-- 删除比赛项目表
DROP TABLE IF EXISTS `sport_item`;

-- 删除基础项目表
DROP TABLE IF EXISTS `sport_base_item`;

-- 删除项目大类表
DROP TABLE IF EXISTS `sport_category`;

-- 删除赛事表
DROP TABLE IF EXISTS `sport_event`;

-- 删除赛事系列表
DROP TABLE IF EXISTS `sport_event_series`;

-- 删除数据字典项表
DROP TABLE IF EXISTS `sport_dict_item`;

-- 删除数据字典表
DROP TABLE IF EXISTS `sport_dict`;

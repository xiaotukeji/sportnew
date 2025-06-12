-- 详细基础项目数据
-- 包含具体距离、性别、年龄组信息
-- 执行时间：2024-03-21

-- 清空现有基础项目数据
TRUNCATE TABLE `sport_base_item`;

-- ============================================
-- 游泳项目详细数据
-- ============================================

-- 自由泳项目（假设自由泳的category_id通过查询获得）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES

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
((SELECT id FROM sport_category WHERE code='relay'), '混合4×100米混合泳接力', 'mixed_4x100m_medley_relay', 2, 3, '青少年', '混合4×100米混合泳接力项目', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 124, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 添加短跑项目示例（简化版）
INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
-- 男子短跑
((SELECT id FROM sport_category WHERE code='sprint'), '男子100米', 'male_100m_sprint', 1, 1, '青少年', '男子100米短跑项目', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 201, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='sprint'), '男子200米', 'male_200m_sprint', 1, 1, '青少年', '男子200米短跑项目', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 202, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='sprint'), '男子400米', 'male_400m_sprint', 1, 1, '青少年', '男子400米短跑项目', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 203, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- 女子短跑
((SELECT id FROM sport_category WHERE code='sprint'), '女子100米', 'female_100m_sprint', 1, 2, '青少年', '女子100米短跑项目', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 211, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='sprint'), '女子200米', 'female_200m_sprint', 1, 2, '青少年', '女子200米短跑项目', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 212, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
((SELECT id FROM sport_category WHERE code='sprint'), '女子400米', 'female_400m_sprint', 1, 2, '青少年', '女子400米短跑项目', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 213, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 查看详细项目统计
SELECT '=== 详细基础项目统计 ===' AS info;
SELECT 
    c.name AS category_name,
    COUNT(b.id) AS item_count,
    GROUP_CONCAT(b.name ORDER BY b.sort SEPARATOR ', ') AS items
FROM sport_category c
LEFT JOIN sport_base_item b ON c.id = b.category_id
WHERE c.level = 3  -- 三级分类
GROUP BY c.id, c.name
ORDER BY c.sort; 
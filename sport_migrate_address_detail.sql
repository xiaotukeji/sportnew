-- 数据迁移脚本：从location_detail中分离出address_detail
-- 说明：将现有的location_detail数据分离为location和address_detail
-- 执行时间：2024-12-19
-- 注意：执行前请先备份数据库

-- 第一步：为现有数据迁移address_detail
-- 从location_detail中分离出详细地址部分
UPDATE `sport_event` 
SET `address_detail` = TRIM(SUBSTRING(`location_detail`, LENGTH(`location`) + 1))
WHERE `location_detail` IS NOT NULL 
AND `location_detail` != `location` 
AND `location_detail` LIKE CONCAT(`location`, '%')
AND `address_detail` IS NULL;

-- 第二步：处理location_detail等于location的情况
-- 这种情况下没有详细地址，address_detail保持为NULL
UPDATE `sport_event` 
SET `address_detail` = NULL
WHERE `location_detail` = `location`
AND `address_detail` = '';

-- 第三步：处理location_detail不包含location的情况
-- 这种情况下整个location_detail作为详细地址
UPDATE `sport_event` 
SET `address_detail` = `location_detail`
WHERE `location_detail` IS NOT NULL 
AND `location_detail` != `location` 
AND `location_detail` NOT LIKE CONCAT(`location`, '%')
AND `address_detail` IS NULL;

-- 验证迁移结果
SELECT 
    COUNT(*) as total_records,
    COUNT(CASE WHEN `address_detail` IS NOT NULL THEN 1 END) as has_address_detail,
    COUNT(CASE WHEN `address_detail` IS NULL THEN 1 END) as no_address_detail
FROM `sport_event`;

-- 查看迁移后的数据示例
SELECT 
    `id`,
    `name`,
    `location`,
    `location_detail`,
    `address_detail`
FROM `sport_event` 
LIMIT 10; 
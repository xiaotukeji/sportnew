-- 更新运动分类排序
-- 让田径、球类、棋类、趣味排在前面并默认展开

UPDATE `sport_category` SET `sort` = 1 WHERE `name` = '田径运动';
UPDATE `sport_category` SET `sort` = 2 WHERE `name` = '球类运动';  
UPDATE `sport_category` SET `sort` = 3 WHERE `name` = '棋类运动';
UPDATE `sport_category` SET `sort` = 4 WHERE `name` = '趣味运动';

-- 其他分类按原有顺序排列
UPDATE `sport_category` SET `sort` = 5 WHERE `name` = '水上运动';
UPDATE `sport_category` SET `sort` = 6 WHERE `name` = '体操运动';
UPDATE `sport_category` SET `sort` = 7 WHERE `name` = '武术运动';
UPDATE `sport_category` SET `sort` = 8 WHERE `name` = '举重运动';
UPDATE `sport_category` SET `sort` = 9 WHERE `name` = '自行车运动';
UPDATE `sport_category` SET `sort` = 10 WHERE `name` = '冰雪运动';
UPDATE `sport_category` SET `sort` = 11 WHERE `name` = '极限运动';
UPDATE `sport_category` SET `sort` = 12 WHERE `name` = '综合运动'; 
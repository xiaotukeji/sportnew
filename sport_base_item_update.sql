-- 基础项目数据补充更新脚本
-- 说明：为空白分类补充基础项目数据
-- 执行时间：2024-03-21

-- 删除现有的基础项目数据，重新插入完整数据
TRUNCATE TABLE `sport_base_item`;

-- ============================================
-- 1. 田径类项目 (category_id = 1)
-- ============================================

INSERT INTO `sport_base_item` (`category_id`, `name`, `code`, `competition_type`, `gender_type`, `age_group`, `description`, `rules`, `equipment`, `venue_requirements`, `sort`, `status`, `create_time`, `update_time`) VALUES
-- 短跑
(1, '短跑', 'sprint', 1, 3, '不限', '短跑项目，包括100米、200米、400米', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 20, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 中长跑
(1, '中长跑', 'middle_distance', 1, 3, '不限', '中长跑项目，包括800米、1500米', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 21, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 长跑
(1, '长跑', 'long_distance', 1, 3, '不限', '长跑项目，包括3000米、5000米、10000米', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 22, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 马拉松
(1, '马拉松', 'marathon', 1, 3, '不限', '马拉松项目，包括半程和全程', '国际田联标准规则', '跑鞋、运动服', '标准马拉松路线', 23, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 跨栏
(1, '跨栏', 'hurdles', 1, 3, '不限', '跨栏项目，包括110米栏、400米栏等', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 24, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 障碍跑
(1, '障碍跑', 'steeplechase', 1, 3, '不限', '障碍跑项目，3000米障碍', '国际田联标准规则', '跑鞋、运动服', '400米标准田径场', 25, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 竞走
(1, '竞走', 'race_walking', 1, 3, '不限', '竞走项目，包括20公里、50公里', '国际田联竞走规则', '竞走鞋、运动服', '竞走路线', 26, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 跳远
(1, '跳远', 'long_jump', 1, 3, '不限', '跳远项目', '国际田联标准规则', '跑鞋、运动服', '跳远场地', 27, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 三级跳远
(1, '三级跳远', 'triple_jump', 1, 3, '不限', '三级跳远项目', '国际田联标准规则', '跑鞋、运动服', '三级跳远场地', 28, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 跳高
(1, '跳高', 'high_jump', 1, 3, '不限', '跳高项目', '国际田联标准规则', '跑鞋、运动服', '跳高场地', 29, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 撑杆跳高
(1, '撑杆跳高', 'pole_vault', 1, 3, '不限', '撑杆跳高项目', '国际田联标准规则', '撑杆、跑鞋、运动服', '撑杆跳高场地', 30, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 铅球
(1, '铅球', 'shot_put', 1, 3, '不限', '铅球投掷项目', '国际田联标准规则', '铅球、运动服', '铅球投掷场地', 31, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 铁饼
(1, '铁饼', 'discus_throw', 1, 3, '不限', '铁饼投掷项目', '国际田联标准规则', '铁饼、运动服', '铁饼投掷场地', 32, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 标枪
(1, '标枪', 'javelin_throw', 1, 3, '不限', '标枪投掷项目', '国际田联标准规则', '标枪、运动服', '标枪投掷场地', 33, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 链球
(1, '链球', 'hammer_throw', 1, 3, '不限', '链球投掷项目', '国际田联标准规则', '链球、运动服', '链球投掷场地', 34, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 十项全能
(1, '十项全能', 'decathlon', 1, 1, '不限', '男子十项全能', '国际田联标准规则', '各项器材', '田径场及各项场地', 35, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 七项全能
(1, '七项全能', 'heptathlon', 1, 2, '不限', '女子七项全能', '国际田联标准规则', '各项器材', '田径场及各项场地', 36, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 接力
(1, '接力', 'relay', 2, 3, '不限', '接力跑项目，4人团队', '国际田联标准规则', '接力棒、跑鞋、运动服', '400米标准田径场', 37, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- ============================================
-- 2. 球类项目 (category_id = 2)
-- ============================================

-- 足球
(2, '足球', 'football', 2, 3, '不限', '足球项目，可分11人制、7人制、5人制', 'FIFA标准规则', '足球、球门、球服', '足球场', 50, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 篮球
(2, '篮球', 'basketball', 2, 3, '不限', '篮球项目，可分5人制、3人制', 'FIBA标准规则', '篮球、篮筐、球服', '篮球场', 51, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 排球
(2, '排球', 'volleyball', 2, 3, '不限', '排球项目，包括室内排球和沙滩排球', 'FIVB标准规则', '排球、球网、球服', '排球场', 52, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 乒乓球
(2, '乒乓球', 'table_tennis', 1, 3, '不限', '乒乓球项目，可分单打、双打、混双', 'ITTF标准规则', '乒乓球、球拍、球桌', '标准乒乓球场', 53, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 羽毛球
(2, '羽毛球', 'badminton', 1, 3, '不限', '羽毛球项目，可分单打、双打、混双', 'BWF标准规则', '羽毛球、球拍、球网', '标准羽毛球场', 54, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 网球
(2, '网球', 'tennis', 1, 3, '不限', '网球项目，可分单打、双打、混双', 'ITF标准规则', '网球、球拍、球网', '标准网球场', 55, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 手球
(2, '手球', 'handball', 2, 3, '不限', '手球团体项目', 'IHF标准规则', '手球、球门、球服', '手球场', 56, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 曲棍球
(2, '曲棍球', 'hockey', 2, 3, '不限', '曲棍球团体项目', 'FIH标准规则', '曲棍球、球门、球服', '曲棍球场', 57, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 棒球
(2, '棒球', 'baseball', 2, 3, '不限', '棒球团体项目', 'WBSC标准规则', '棒球、球棒、手套', '棒球场', 58, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 垒球
(2, '垒球', 'softball', 2, 3, '不限', '垒球团体项目', 'WBSC标准规则', '垒球、球棒、手套', '垒球场', 59, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 橄榄球
(2, '橄榄球', 'rugby', 2, 3, '不限', '橄榄球团体项目', 'World Rugby标准规则', '橄榄球、球门、球服', '橄榄球场', 60, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 高尔夫
(2, '高尔夫', 'golf', 1, 3, '不限', '高尔夫球项目', 'R&A标准规则', '高尔夫球、球杆', '高尔夫球场', 61, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- ============================================
-- 3. 水上运动项目 (category_id = 3)
-- ============================================

-- 自由泳
(3, '自由泳', 'freestyle', 1, 3, '不限', '自由泳项目，可分不同距离', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 仰泳
(3, '仰泳', 'backstroke', 1, 3, '不限', '仰泳项目，可分不同距离', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 2, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 蛙泳
(3, '蛙泳', 'breaststroke', 1, 3, '不限', '蛙泳项目，可分不同距离', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 3, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 蝶泳
(3, '蝶泳', 'butterfly', 1, 3, '不限', '蝶泳项目，可分不同距离', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 4, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 混合泳
(3, '个人混合泳', 'individual_medley', 1, 3, '不限', '个人混合泳项目，按蝶泳-仰泳-蛙泳-自由泳顺序', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 5, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 团体接力
(3, '自由泳接力', 'freestyle_relay', 2, 3, '不限', '自由泳接力项目，4人团队', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 6, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 混合接力
(3, '混合泳接力', 'medley_relay', 2, 3, '不限', '混合泳接力项目，按仰泳-蛙泳-蝶泳-自由泳顺序', '国际泳联标准规则', '泳衣、泳帽、泳镜', '50米标准游泳池', 7, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 跳水
(3, '跳水', 'diving', 1, 3, '不限', '跳水项目，包括跳台和跳板', '国际泳联跳水规则', '泳衣', '跳水池', 8, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 水球
(3, '水球', 'water_polo', 2, 3, '不限', '水球团体项目', '国际泳联水球规则', '泳衣、水球', '水球池', 9, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 花样游泳
(3, '花样游泳', 'synchronized_swimming', 1, 3, '不限', '花样游泳艺术项目', '国际泳联花样游泳规则', '泳衣、泳帽', '花样游泳池', 10, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- ============================================
-- 4. 体操类项目 (category_id = 4)
-- ============================================

-- 自由体操
(4, '自由体操', 'floor_exercise', 1, 3, '不限', '自由体操项目', 'FIG标准规则', '体操垫、音响', '体操场地', 300, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 鞍马
(4, '鞍马', 'pommel_horse', 1, 1, '不限', '鞍马项目（男子）', 'FIG标准规则', '鞍马器械', '体操馆', 301, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 吊环
(4, '吊环', 'rings', 1, 1, '不限', '吊环项目（男子）', 'FIG标准规则', '吊环器械', '体操馆', 302, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 跳马
(4, '跳马', 'vault', 1, 3, '不限', '跳马项目', 'FIG标准规则', '跳马器械', '体操馆', 303, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 双杠
(4, '双杠', 'parallel_bars', 1, 1, '不限', '双杠项目（男子）', 'FIG标准规则', '双杠器械', '体操馆', 304, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 单杠
(4, '单杠', 'horizontal_bar', 1, 1, '不限', '单杠项目（男子）', 'FIG标准规则', '单杠器械', '体操馆', 305, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 高低杠
(4, '高低杠', 'uneven_bars', 1, 2, '不限', '高低杠项目（女子）', 'FIG标准规则', '高低杠器械', '体操馆', 306, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 平衡木
(4, '平衡木', 'balance_beam', 1, 2, '不限', '平衡木项目（女子）', 'FIG标准规则', '平衡木器械', '体操馆', 307, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 艺术体操
(4, '艺术体操', 'rhythmic_gymnastics', 1, 2, '不限', '艺术体操项目', 'FIG标准规则', '各种器械（绳、球、棒、带、圈）', '体操场地', 308, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 蹦床
(4, '蹦床', 'trampoline', 1, 3, '不限', '蹦床项目', 'FIG标准规则', '蹦床设备', '体操馆', 309, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- ============================================
-- 5. 武术类项目 (category_id = 5)
-- ============================================

-- 太极拳
(5, '太极拳', 'tai_chi', 1, 3, '不限', '太极拳套路表演', '太极拳竞赛规则', '太极服', '平坦场地', 400, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 长拳
(5, '长拳', 'changquan', 1, 3, '不限', '长拳套路表演', '武术套路竞赛规则', '武术服', '武术场地', 401, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 南拳
(5, '南拳', 'nanquan', 1, 3, '不限', '南拳套路表演', '武术套路竞赛规则', '武术服', '武术场地', 402, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 刀术
(5, '刀术', 'broadsword', 1, 3, '不限', '刀术套路表演', '武术套路竞赛规则', '刀、武术服', '武术场地', 403, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 剑术
(5, '剑术', 'straight_sword', 1, 3, '不限', '剑术套路表演', '武术套路竞赛规则', '剑、武术服', '武术场地', 404, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 棍术
(5, '棍术', 'staff', 1, 3, '不限', '棍术套路表演', '武术套路竞赛规则', '棍、武术服', '武术场地', 405, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 枪术
(5, '枪术', 'spear', 1, 3, '不限', '枪术套路表演', '武术套路竞赛规则', '枪、武术服', '武术场地', 406, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 散打
(5, '散打', 'sanda', 1, 3, '不限', '散打实战项目', '散打竞赛规则', '护具、散打服', '散打场地', 407, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- ============================================
-- 6. 极限运动项目 (category_id = 6)  
-- ============================================

-- 滑板
(6, '滑板', 'skateboarding', 1, 3, '不限', '滑板项目，包括街式和碗池', '国际滑板规则', '滑板、护具', '滑板场', 700, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 攀岩
(6, '攀岩', 'climbing', 1, 3, '不限', '攀岩项目，包括速度、抱石、先锋', 'IFSC标准规则', '攀岩鞋、安全带、绳索', '攀岩墙', 701, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- BMX自行车
(6, 'BMX自行车', 'bmx', 1, 3, '不限', 'BMX自行车项目', 'UCI标准规则', 'BMX自行车、护具', 'BMX赛道', 702, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 轮滑
(6, '轮滑', 'roller_skating', 1, 3, '不限', '轮滑项目，包括速度和花样', '国际轮滑规则', '轮滑鞋、护具', '轮滑场', 703, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- ============================================
-- 7. 冰雪运动项目 (category_id = 7)
-- ============================================

-- 花样滑冰
(7, '花样滑冰', 'figure_skating', 1, 3, '不限', '花样滑冰项目', 'ISU标准规则', '花样滑冰鞋、服装', '滑冰场', 800, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 速度滑冰
(7, '速度滑冰', 'speed_skating', 1, 3, '不限', '速度滑冰项目', 'ISU标准规则', '速滑鞋', '速滑场', 801, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 冰球
(7, '冰球', 'ice_hockey', 2, 3, '不限', '冰球团体项目', 'IIHF标准规则', '冰球杆、冰球、护具', '冰球场', 802, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 滑雪
(7, '滑雪', 'skiing', 1, 3, '不限', '滑雪项目，包括高山、越野、跳台', 'FIS标准规则', '滑雪板、滑雪杖、雪鞋', '滑雪场', 803, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- ============================================
-- 8. 格斗类项目 (category_id = 8)
-- ============================================

-- 拳击
(8, '拳击', 'boxing', 1, 3, '不限', '拳击项目', '国际拳击规则', '拳击手套、护具', '拳击台', 500, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 跆拳道
(8, '跆拳道', 'taekwondo', 1, 3, '不限', '跆拳道项目', 'WT标准规则', '跆拳道服、护具', '跆拳道场地', 501, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 空手道
(8, '空手道', 'karate', 1, 3, '不限', '空手道项目', 'WKF标准规则', '空手道服、护具', '空手道场地', 502, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 柔道
(8, '柔道', 'judo', 1, 3, '不限', '柔道项目', 'IJF标准规则', '柔道服', '柔道垫', 503, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 摔跤
(8, '摔跤', 'wrestling', 1, 3, '不限', '摔跤项目，包括自由式和古典式', 'UWW标准规则', '摔跤服', '摔跤垫', 504, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- ============================================
-- 9. 射击类项目 (category_id = 9)
-- ============================================

-- 气手枪
(9, '气手枪', 'air_pistol', 1, 3, '不限', '10米气手枪射击', 'ISSF标准规则', '气手枪、子弹、靶纸', '射击场', 600, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 气步枪
(9, '气步枪', 'air_rifle', 1, 3, '不限', '10米气步枪射击', 'ISSF标准规则', '气步枪、子弹、靶纸', '射击场', 601, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 飞碟射击
(9, '飞碟射击', 'clay_pigeon_shooting', 1, 3, '不限', '飞碟射击项目', 'ISSF标准规则', '猎枪、子弹、飞碟', '飞碟射击场', 602, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 射箭
(9, '射箭', 'archery', 1, 3, '不限', '射箭项目', 'World Archery标准规则', '弓、箭、靶', '射箭场', 603, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- ============================================
-- 10. 棋类项目 (category_id = 10)
-- ============================================

-- 中国象棋
(10, '中国象棋', 'chinese_chess', 1, 3, '不限', '中国象棋项目，可分个人和团体', '中国象棋竞赛规则', '象棋棋盘、棋子', '室内场地', 200, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 围棋
(10, '围棋', 'go', 1, 3, '不限', '围棋项目，可分个人和团体', '中国围棋规则', '围棋棋盘、棋子', '室内场地', 201, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 国际象棋
(10, '国际象棋', 'international_chess', 1, 3, '不限', '国际象棋项目，可分个人和团体', 'FIDE标准规则', '国际象棋棋盘、棋子', '室内场地', 202, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 跳棋
(10, '跳棋', 'chinese_checkers', 1, 3, '不限', '跳棋项目，多人对战', '跳棋竞赛规则', '跳棋棋盘、棋子', '室内场地', 203, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 五子棋
(10, '五子棋', 'gomoku', 1, 3, '不限', '五子棋项目', '五子棋竞赛规则', '五子棋棋盘、棋子', '室内场地', 204, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- ============================================
-- 11. 趣味比赛项目 (category_id = 11)
-- ============================================

-- 拔河
(11, '拔河', 'tug_of_war', 2, 3, '不限', '传统拔河比赛，团队协作', '传统拔河规则', '拔河绳', '平坦场地', 100, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 三人四足
(11, '三人四足', 'three_legged_race', 2, 3, '不限', '绑腿协作跑步', '团队协调性比赛', '绑腿带', '跑道或平地', 101, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 袋鼠跳
(11, '袋鼠跳', 'sack_race', 1, 3, '不限', '套袋跳跃比赛', '个人趣味竞技', '麻袋或跳袋', '平坦场地', 102, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 踢毽子
(11, '踢毽子', 'shuttlecock_kicking', 1, 3, '不限', '踢毽子计数比赛', '传统民间体育', '毽子', '小范围场地', 103, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 跳绳
(11, '跳绳', 'rope_skipping', 1, 3, '不限', '跳绳项目，可分个人和团体', '跳绳比赛规则', '跳绳', '平坦场地', 104, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 摸石头过河
(11, '摸石头过河', 'stepping_stones', 1, 3, '不限', '踩垫子前进比赛', '平衡和协调性比赛', '垫子或踏板', '平坦场地', 105, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 背靠背运球
(11, '背靠背运球', 'back_to_back_ball', 2, 3, '不限', '两人背夹球移动', '团队协作和默契', '篮球', '平坦场地', 106, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 乒乓板接力
(11, '乒乓板接力', 'ping_pong_relay', 2, 3, '不限', '球拍托球跑步接力', '平衡性和团队配合', '乒乓球拍、乒乓球', '跑道', 107, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 趣味障碍赛
(11, '趣味障碍赛', 'fun_obstacle_race', 1, 3, '不限', '设置各种趣味障碍的闯关比赛', '娱乐性障碍挑战', '各种障碍设施', '开阔场地', 108, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

-- ============================================
-- 12. 其他类项目 (category_id = 12)
-- ============================================

-- 自行车
(12, '自行车', 'cycling', 1, 3, '不限', '自行车项目，包括公路、场地、山地', 'UCI标准规则', '自行车、头盔', '相应赛道', 900, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 体育舞蹈
(12, '体育舞蹈', 'dancesport', 1, 3, '不限', '体育舞蹈项目，包括标准舞和拉丁舞', 'WDSF标准规则', '舞蹈服装、舞鞋', '舞蹈场地', 901, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 马术
(12, '马术', 'equestrian', 1, 3, '不限', '马术项目，包括盛装舞步、障碍和三项赛', 'FEI标准规则', '马、马具、骑手装备', '马术场', 902, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
-- 现代五项
(12, '现代五项', 'modern_pentathlon', 1, 3, '不限', '现代五项全能', 'UIPM标准规则', '各项器材', '综合场地', 903, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());

-- 更新完成提示
SELECT '基础项目数据更新完成！' AS message;
SELECT 
    c.name AS category_name,
    COUNT(b.id) AS item_count
FROM sport_category c
LEFT JOIN sport_base_item b ON c.id = b.category_id
WHERE c.parent_id = 0 AND c.level = 1
GROUP BY c.id, c.name
ORDER BY c.sort; 
-- =======================================================================
-- 高等精灵任务链 - 第4个任务 "Gathering Supplies 收集补给" (采集任务)
-- 日期: 2026-06-11  号段: 任务90015, GO 901150 [reference_custom_entry_naming]
-- 玩法: 游侠给任务 → 点击周围6个补给箱(GOOBER) → 交回游侠
-- 机制: 照狼人破损补给箱60101 - type=10, Data1=questId, 点击自动给RequiredNpcOrGo credit(无需脚本)
-- 采集物: 2252 杂七杂八的地精补给物资(现成物品,图标对)
-- 奖励: 鞋子/护腕 3选一 + 钱 + 经验
-- 导航: 暴风城大门右前方
-- 位置: 游侠在 -9205.855, 374 (暴风城门口右前)
-- =======================================================================

-- ===== 清理(可重复执行) =====
DELETE FROM `gameobject` WHERE `guid` BETWEEN 9501150 AND 9501170;
DELETE FROM `gameobject_template` WHERE `entry` = 901150;
DELETE FROM `quest_template` WHERE `ID` = 90015;
DELETE FROM `creature_queststarter` WHERE `quest` = 90015;
DELETE FROM `creature_questender` WHERE `quest` = 90015;

-- ===== 1. 采集箱 GameObject 模板 (type=3采集箱, 无锁直接采) =====
-- 完整复制狼人破损补给箱60101的全部字段(确认能点),只改entry/name/questId
DROP TEMPORARY TABLE IF EXISTS `tmp_go`;
CREATE TEMPORARY TABLE `tmp_go` AS SELECT * FROM `gameobject_template` WHERE `entry`=60101;
UPDATE `tmp_go` SET `entry`=901150, `name`='Silver Covenant Supplies 银色盟约补给箱', `Data1`=90015;
INSERT INTO `gameobject_template` SELECT * FROM `tmp_go`;
DROP TEMPORARY TABLE `tmp_go`;
  -- 照狼人破损补给箱60101: type=10 GOOBER, Data1=questId, castBarCaption(点击读条), Data5=1
  -- 点击读条完成→自动给RequiredNpcOrGo credit(无需脚本)
  -- type=10 GOOBER可点击, Data1=90015(关联任务,点击给credit), Data5=1(questId触发), 照狼人任务GO 6201
  -- type=3采集箱, displayId=36(补给箱模型), Data0=0(无锁直接采), Data1=901150(关联自己的loot)

-- ===== 2. type=10 GOOBER 点击直接给任务credit, 无需loot表 =====

-- ===== 3. 在暴风城门口右前方放10个补给箱(分散在各高度平面) =====
INSERT INTO `gameobject`
  (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`)
VALUES
  (9501150,901150,0,0,0,1,1,-9193.107,366.65668,74.42173,3.3,0,0,0,1,30,100,1),
  (9501151,901150,0,0,0,1,1,-9188,372,74.42,2.0,0,0,0,1,30,100,1),
  (9501152,901150,0,0,0,1,1,-9198,360,74.42,4.0,0,0,0,1,30,100,1),
  (9501153,901150,0,0,0,1,1,-9184.2295,395.50433,84.97435,3.7,0,0,0,1,30,100,1),
  (9501154,901150,0,0,0,1,1,-9190,390,84.97,1.5,0,0,0,1,30,100,1),
  (9501155,901150,0,0,0,1,1,-9202.562,411.49432,88.42568,4.5,0,0,0,1,30,100,1),
  (9501156,901150,0,0,0,1,1,-9208,405,88.42,2.5,0,0,0,1,30,100,1),
  (9501157,901150,0,0,0,1,1,-9229.244,400.3993,85.714554,1.0,0,0,0,1,30,100,1),
  (9501158,901150,0,0,0,1,1,-9234,395,85.71,3.0,0,0,0,1,30,100,1),
  (9501159,901150,0,0,0,1,1,-9235.807,307.7879,74.37596,2.4,0,0,0,1,30,100,1);

-- ===== 4. 任务本体 (采集6个补给物资, 双语, 导航提示) =====
INSERT INTO `quest_template`
  (`ID`,`QuestType`,`QuestLevel`,`MinLevel`,`QuestSortID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardMoney`,`Flags`,`AllowableRaces`,
   `RequiredNpcOrGo1`,`RequiredNpcOrGoCount1`,
   `RewardChoiceItemID1`,`RewardChoiceItemQuantity1`,`RewardChoiceItemID2`,`RewardChoiceItemQuantity2`,`RewardChoiceItemID3`,`RewardChoiceItemQuantity3`,
   `LogTitle`,`LogDescription`,`QuestDescription`,`QuestCompletionLog`,`ObjectiveText1`)
VALUES
  (90015,2,4,1,12,0,3,180,0,0,
   -901150,6,
   2691,1, 4915,1, 1836,1,
   'Gathering Supplies 收集补给物资',
   'Gather 6 Silver Covenant Supplies scattered in front of Stormwind front gate, to the right, then return to Ranger Allyndia.$B在暴风城大门右前方收集6个银色盟约补给箱中的物资,然后交给游侠艾琳迪亚。',
   'Our supply crates were scattered during the journey. They lie strewn about the field to the right, just before Stormwind front gate. Please gather 6 Silver Covenant Supplies from the crates and bring them back to me.$B$B我们的补给箱在旅途中散落了。它们就散布在暴风城大门右前方的空地上。请从补给箱中收集6份银色盟约的物资,带回给我。',
   'Return 6 Silver Covenant Supplies to Ranger Allyndia at the right front of Stormwind gate.$B在暴风城大门右前方将6份补给物资交给游侠艾琳迪亚。',
   'Silver Covenant Supplies searched 搜查银色盟约补给箱');

-- ===== 5. 任务关联: 游侠艾琳迪亚(900143) 既给又收 =====
INSERT INTO `creature_queststarter` (`id`,`quest`) VALUES (900143,90015);
INSERT INTO `creature_questender` (`id`,`quest`) VALUES (900143,90015);

-- ===== 6. 链条衔接: 第3个任务(90014)做完接第4个(90015) =====
UPDATE `quest_template` SET `RewardNextQuest` = 90015 WHERE `ID` = 90014;


-- ===== 任务链 PrevQuestID (确保链条正确衔接,交完前一个自动给下一个) =====
INSERT INTO `quest_template_addon` (`ID`, `PrevQuestID`) VALUES
  (90013, 90012), (90014, 90013), (90015, 90014)
ON DUPLICATE KEY UPDATE `PrevQuestID`=VALUES(`PrevQuestID`);

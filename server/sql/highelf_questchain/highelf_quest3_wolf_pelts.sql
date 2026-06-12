-- =======================================================================
-- 高等精灵任务链 - 第3个任务 "Wolf Pelts 狼皮收集" (收集任务,自制怪)
-- 日期: 2026-06-11  号段: 任务90014, 怪900140-900143, 物品900200 [reference_custom_entry_naming]
-- 玩法: Aquila(暴风城)给任务 → 去艾尔文森林杀自制狼 收集5张狼皮 → 交给杀怪点附近的NPC
-- 奖励: 经验 + 金钱 + 3件装备选一
-- 双语: 客户端是魔改enUS,双语直接写进本体
-- 怪/NPC位置: 幼狼区域 -8966,-80 (离暴风城出生点仅190码,艾尔文森林)
-- =======================================================================

-- ===== 清理(可重复执行) =====
DELETE FROM `creature_template_model` WHERE `CreatureID` BETWEEN 900140 AND 900143;
DELETE FROM `creature_template` WHERE `entry` BETWEEN 900140 AND 900143;
DELETE FROM `creature` WHERE `guid` BETWEEN 9500140 AND 9500170;
DELETE FROM `creature_loot_template` WHERE `Entry` IN (900140, 900141, 900142);
DELETE FROM `quest_template` WHERE `ID` = 90014;
DELETE FROM `creature_queststarter` WHERE `quest` = 90014;
DELETE FROM `creature_questender` WHERE `quest` = 90014;

-- ===== 1. 任务物品: 用现成的轻毛皮(783),客户端DBC有,图标正确,不自制物品 =====

-- ===== 2. 三只自制狼 (1-3级) =====
INSERT INTO `creature_template`
  (`entry`,`name`,`subname`,`minlevel`,`maxlevel`,`faction`,`npcflag`,`unit_class`,`unit_flags`,`type`,`family`,`HealthModifier`,`lootid`,`AIName`,`MovementType`)
VALUES
  (900140,'Ravenous Wolf Pup 凶饿幼狼','',1,1,31,0,1,0,1,1,0.8,900140,'',1),
  (900141,'Graymane Wolf 灰鬃狼','',2,2,31,0,1,0,1,1,1.0,900141,'',1),
  (900142,'Forest Stalker 森林潜行狼','',3,3,31,0,1,0,1,1,1.2,900142,'',1);

-- ===== 3. 狼的模型 (借用幼狼模型31049) =====
INSERT INTO `creature_template_model`
  (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`)
VALUES
  (900140,0,31049,0.9,1,0),
  (900141,0,31049,1.0,1,0),
  (900142,0,855,1.1,1,0);

-- ===== 4. 狼的掉落: 都掉狼皮(任务物品900200) =====
-- ChanceOrQuestChance 负数=任务掉落几率(-50=50%)
INSERT INTO `creature_loot_template` (`Entry`,`Item`,`Reference`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`) VALUES
-- 凶饿幼狼: 狼皮(任务)+毛皮+皮革+灰装
(900140, 783, 0, 70, 1, 1, 0, 1, 1),
(900140, 2934, 0, 20, 0, 1, 0, 1, 1),
(900140, 39, 0, 8, 0, 1, 1, 1, 1),
(900140, 56, 0, 8, 0, 1, 1, 1, 1),
-- 灰鬃狼
(900141, 783, 0, 80, 1, 1, 0, 1, 1),
(900141, 2934, 0, 22, 0, 1, 0, 1, 1),
(900141, 44, 0, 10, 0, 1, 1, 1, 1),
(900141, 48, 0, 10, 0, 1, 1, 1, 1),
-- 森林潜行狼
(900142, 783, 0, 90, 1, 1, 0, 1, 1),
(900142, 2934, 0, 25, 0, 1, 0, 1, 1),
(900142, 52, 0, 12, 0, 1, 1, 1, 1),
(900142, 57, 0, 12, 0, 1, 1, 1, 1);

-- 狼掉小钱
UPDATE `creature_template` SET `mingold`=1, `maxgold`=8 WHERE `entry`=900140;
UPDATE `creature_template` SET `mingold`=3, `maxgold`=15 WHERE `entry`=900141;
UPDATE `creature_template` SET `mingold`=5, `maxgold`=25 WHERE `entry`=900142;

-- ===== 5. 交任务NPC (放在杀怪点附近,你的建议) =====
INSERT INTO `creature_template`
  (`entry`,`name`,`subname`,`minlevel`,`maxlevel`,`faction`,`npcflag`,`unit_class`,`unit_flags`,`type`,`flags_extra`,`AIName`,`MovementType`)
VALUES
  (900143,'Ranger Allyndia 游侠艾琳迪亚','Silver Covenant 银色盟约',5,5,35,3,2,512,7,0,'',0);

INSERT INTO `creature_template_model`
  (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`)
VALUES
  (900143,0,30311,1.0,1,0);

-- ===== 6. 生成点 =====
-- 3只狼各刷几只在幼狼区(-8966,-80附近)
INSERT INTO `creature`
  (`guid`,`id1`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`MovementType`,`wander_distance`)
VALUES
  -- 凶饿幼狼(1级) x4
  (9500140,900140,0,0,0,1,1,0,-9040,330,93,1.0,120,1,4),
  (9500141,900140,0,0,0,1,1,0,-9080,330,93,2.0,120,1,4),
  (9500142,900140,0,0,0,1,1,0,-9050,370,93,3.0,120,1,4),
  (9500143,900140,0,0,0,1,1,0,-9075,365,93,4.0,120,1,4),
  -- 灰鬃狼(2级) x3
  (9500144,900141,0,0,0,1,1,0,-9030,355,93,1.5,120,1,4),
  (9500145,900141,0,0,0,1,1,0,-9090,350,93,2.5,120,1,4),
  (9500146,900141,0,0,0,1,1,0,-9055,320,93,3.5,120,1,4),
  -- 森林潜行狼(3级) x3
  (9500147,900142,0,0,0,1,1,0,-9035,375,93,0.5,120,1,4),
  (9500148,900142,0,0,0,1,1,0,-9095,370,93,5.0,120,1,4),
  (9500149,900142,0,0,0,1,1,0,-9065,385,93,4.5,120,1,4);
-- 交任务NPC放杀怪点中心,玩家杀完就在旁边交
INSERT INTO `creature`
  (`guid`,`id1`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`MovementType`)
VALUES
  (9500150,900143,0,0,0,1,1,0,-9205.855,374.15195,73.51775,4.3006063,300,0);

-- ===== 7. 任务本体 (收集5张狼皮, 双语) =====
INSERT INTO `quest_template`
  (`ID`,`QuestType`,`QuestLevel`,`MinLevel`,`QuestSortID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardMoney`,`Flags`,`AllowableRaces`,
   `RequiredItemId1`,`RequiredItemCount1`,
   `RewardChoiceItemID1`,`RewardChoiceItemQuantity1`,`RewardChoiceItemID2`,`RewardChoiceItemQuantity2`,`RewardChoiceItemID3`,`RewardChoiceItemQuantity3`,
   `LogTitle`,`LogDescription`,`QuestDescription`,`QuestCompletionLog`,`ObjectiveText1`)
VALUES
  (90014,2,3,1,12,0,3,120,0,0,
   783,5,
   25,1, 2110,1, 6070,1,
   'Wolves at the Gate 城门口的野狼',
   'Slay the wolves near the left side of Stormwind front gate and collect 5 Light Leather, then bring them to Ranger Allyndia who stands among them.$B在暴风城大门口左侧猎杀野狼,收集5张轻毛皮,然后交给站在狼群中的游侠艾琳迪亚。',
   'The wolves gathering near Stormwind gate have grown troublesome. High Priestess Aquila asks that you cull them. Head to the left side of the front gate, slay the wolves there, and gather 5 Light Leather. Bring them to Ranger Allyndia, our scout stationed among the packs.$B$B聚集在暴风城门口的野狼日渐扰人。高阶女祭司阿奎拉请你前去清剿。前往大门口的左侧,猎杀那里的野狼,收集5张轻毛皮,交给我们驻扎在狼群中的斥候——游侠艾琳迪亚。',
   'Bring 5 Light Leather to Ranger Allyndia, near the left of Stormwind gate.$B将5张轻毛皮交给暴风城门口左侧的游侠艾琳迪亚。',
   'Light Leather 轻毛皮');

-- ===== 8. 任务关联: Aquila(900122)给, 游侠艾琳迪亚(900143)收 =====
INSERT INTO `creature_queststarter` (`id`,`quest`) VALUES (900122,90014);
INSERT INTO `creature_questender` (`id`,`quest`) VALUES (900143,90014);

-- ===== 9. 链条衔接: 第2个任务(90013)做完接第3个(90014) =====
UPDATE `quest_template` SET `RewardNextQuest` = 90014 WHERE `ID` = 90013;

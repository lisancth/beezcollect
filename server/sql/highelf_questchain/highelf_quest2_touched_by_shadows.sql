-- =======================================================================
-- 高等精灵/虚空精灵 起始任务链 - 第2个任务 "Touched by Shadows"
-- 日期: 2026-06-11  号段: 任务90013, NPC 900122(Aquila) [reference_custom_entry_naming]
-- 原始: 任务30031, NPC 100139(Aquila Empyrean 高阶女祭司)
-- 衔接: 第1个任务(90012)的Eldreth(900121)给本任务, Aquila(900122)收
--       同时把90012的RewardNextQuest接到90013
-- 模型: Aquila=30311(银色盟约女性高等精灵,现成模型)
-- 奖励: 经验 + 45铜 (和第1个任务一致)
-- =======================================================================

-- 清理(可重复执行)
DELETE FROM `creature_template_model` WHERE `CreatureID` = 900122;
DELETE FROM `creature_template` WHERE `entry` = 900122;
DELETE FROM `creature` WHERE `guid` = 9500122;
DELETE FROM `quest_template` WHERE `ID` = 90013;
DELETE FROM `creature_queststarter` WHERE `quest` = 90013;
DELETE FROM `creature_questender` WHERE `quest` = 90013;

-- 1. 新NPC: Aquila Empyrean (高阶女祭司)
INSERT INTO `creature_template`
  (`entry`,`name`,`subname`,`minlevel`,`maxlevel`,`faction`,`npcflag`,`unit_class`,`unit_flags`,`type`,`flags_extra`,`AIName`,`MovementType`)
VALUES
  (900122,'Aquila Empyrean','High Priestess',60,60,35,3,8,512,7,0,'',0);

-- 2. 模型
INSERT INTO `creature_template_model`
  (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`)
VALUES
  (900122,0,30311,1.1,1,0);

-- 3. 生成点 (法师区, Eldreth旁边)
INSERT INTO `creature`
  (`guid`,`id1`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`MovementType`)
VALUES
  (9500122,900122,0,0,0,1,1,0,-9060.424,348.8209,93.17869,3.016355,300,0);

-- 4. 第2个任务本体 (Eldreth给, Aquila收)
INSERT INTO `quest_template`
  (`ID`,`QuestType`,`QuestLevel`,`MinLevel`,`QuestSortID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardMoney`,`Flags`,`AllowableRaces`,`LogTitle`,`LogDescription`,`QuestDescription`,`QuestCompletionLog`)
VALUES
  (90013,2,3,1,-378,0,3,45,0,0,
   'Touched by Shadows 暗影之触',
   'Speak with High Priestess Aquila Empyrean, near the left side of Stormwind front gate.$B与高阶女祭司阿奎拉·恩匹瑞恩对话,她在暴风城大门口的左侧。',
   'As we honor the fallen, my senses are clouded by an unsettling aura. Shadows are stirring. Please seek out High Priestess Aquila Empyrean, who awaits near the left side of Stormwind front gate, and tell her what I have sensed.$B$B当我们缅怀逝者之时,一股不安的气息扰乱了我的感知。暗影正在涌动。请去寻找高阶女祭司阿奎拉·恩匹瑞恩——她正在暴风城大门口的左侧等候,将我所感知到的一切告诉她。',
   'Speak with High Priestess Aquila Empyrean at the left side of Stormwind gate.$B在暴风城大门口左侧找到高阶女祭司阿奎拉·恩匹瑞恩。');

-- 5. 任务关联: Eldreth(900121)给, Aquila(900122)收
INSERT INTO `creature_queststarter` (`id`,`quest`) VALUES (900121,90013);
INSERT INTO `creature_questender` (`id`,`quest`) VALUES (900122,90013);

-- 6. 衔接链条: 第1个任务(90012)做完自动接第2个(90013)
UPDATE `quest_template` SET `RewardNextQuest` = 90013 WHERE `ID` = 90012;

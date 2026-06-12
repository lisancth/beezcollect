-- =======================================================================
-- 虚空精灵起始任务链 - 第3个任务 (失踪的同胞 / 唤醒晕倒的精灵)
-- 日期: 2026-06-12  号段: 任务90022, NPC 900240/900241/900242 [reference_custom_entry_naming]
-- 衔接: 90021(虚空的试炼) → 90022(失踪的同胞)
-- 玩法: 沿路点击3个晕倒在地的精灵同胞, 唤醒他们(他们站起道谢后消失)
-- ★躺地: creature_addon.bytes1=7 (睡姿, 对NPC稳定生效, 参考濒死的考古学家5569)
-- ★唤醒: voidelf_wake_kin.lua 脚本点击gossip→站起+道谢+给任务credit+消失
-- 双语(魔改enUS客户端,双语写本体)
-- 摆放分工: 我建3个NPC给entry, 用户 .npc add 900240/900241/900242 沿路摆放,
--          摆好后我导出生成点 + 写躺地addon。
-- =======================================================================

DELETE FROM `creature_template_model` WHERE `CreatureID` IN (900240,900241,900242,900243);
DELETE FROM `creature_template` WHERE `entry` IN (900240,900241,900242,900243);
DELETE FROM `creature` WHERE `id1` IN (900240,900241,900242,900243);
DELETE FROM `quest_template` WHERE `ID` = 90022;
DELETE FROM `quest_template_addon` WHERE `ID` = 90022;
DELETE FROM `creature_queststarter` WHERE `quest` = 90022;
DELETE FROM `creature_questender` WHERE `quest` = 90022;

-- 1. 三个晕倒的精灵同胞 (faction35友好, npcflag1可点击对话, type7, 静止不动)
--    minlevel/maxlevel低, 反正不战斗
INSERT INTO `creature_template`
  (`entry`,`name`,`subname`,`minlevel`,`maxlevel`,`faction`,`npcflag`,`unit_class`,`unit_flags`,`type`,`flags_extra`,`AIName`,`MovementType`)
VALUES
  (900240,'Fallen Sin''dorei 倒下的辛多雷','Unconscious 昏迷',5,5,35,1,1,768,7,0,'',0),
  (900241,'Stranded Exile 流落的流亡者','Unconscious 昏迷',5,5,35,1,1,768,7,0,'',0),
  (900242,'Wounded Magister 受伤的魔导师','Unconscious 昏迷',5,5,35,1,1,768,7,0,'',0),
  (900243,'Hidden Survivor 隐匿的幸存者','Unconscious 昏迷',5,5,35,1,1,768,7,0,'',0);

-- 2. 模型 (三种精灵外观区分: 30311女精灵/30310男精灵/195)
INSERT INTO `creature_template_model`
  (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`)
VALUES
  (900240,0,30311,1.0,1,0),   -- 女血精灵
  (900241,0,30310,1.0,1,0),   -- 男血精灵
  (900242,0,30310,1.0,1,0),   -- 男血精灵(原195是冰巨魔,已纠正)
  (900243,0,30311,1.0,1,0);   -- 女血精灵(第4个,藏隐秘处)

-- 3. 任务: 失踪的同胞 (唤醒3个精灵, 用RequiredNpcOrGo点击credit)
--    三个NPC各算1个目标, 凑齐3个完成
INSERT INTO `quest_template`
  (`ID`,`QuestType`,`QuestLevel`,`MinLevel`,`QuestSortID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardMoney`,`Flags`,`AllowableRaces`,
   `RequiredNpcOrGo1`,`RequiredNpcOrGoCount1`,
   `RequiredNpcOrGo2`,`RequiredNpcOrGoCount2`,
   `RequiredNpcOrGo3`,`RequiredNpcOrGoCount3`,
   `RequiredNpcOrGo4`,`RequiredNpcOrGoCount4`,
   `LogTitle`,`LogDescription`,`QuestDescription`,`QuestCompletionLog`)
VALUES
  (90022,2,3,1,2037,0,4,200,0,0,
   900240,1,
   900241,1,
   900242,1,
   900243,1,
   'The Fallen Kin 失踪的同胞',
   'Find and awaken 4 unconscious elves along the path. Click on each to rouse them.$B沿路找到并唤醒4名昏迷的精灵。点击每一位将他们唤醒。',
   'Not all of us made it to safety, $n. Along the path ahead lie our kin -- struck down by the murlocs, or simply overcome by the Void''s pull. They yet breathe. Go to them, rouse them, and send them back to camp. We do not leave our own behind.$B$B并非所有人都安全抵达,$n。前方的路上躺着我们的同胞——被鱼人击倒,或只是被虚空的牵引所压垮。他们还有气息。去找到他们,唤醒他们,让他们返回营地。我们绝不抛下任何一个同胞。',
   'Awaken 4 fallen elves and return to Magister Umbric.$B唤醒4名倒下的精灵,然后返回魔导师乌布里克处。');

-- 4. 任务链衔接 (前置90021)
INSERT INTO `quest_template_addon` (`ID`,`PrevQuestID`,`NextQuestID`) VALUES
  (90022, 90021, 0);

-- 5. 任务关联 (乌布里克给+收)
INSERT INTO `creature_queststarter` (`id`,`quest`) VALUES (900210,90022);
INSERT INTO `creature_questender` (`id`,`quest`) VALUES (900210,90022);

-- 6. 让第2任务完成后自动衔接第3任务
UPDATE `quest_template` SET `RewardNextQuest` = 90022 WHERE `ID` = 90021;

-- 7. 生成点 (用户隐秘摆放的4个精灵, 2026-06-12最终版导出)
INSERT INTO `creature`
  (`guid`,`id1`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`MovementType`)
VALUES
  (10010037,900240,0,0,0,1,1,4307.93,-2757.59,16.5943,3.49627,300,0),
  (10010038,900241,0,0,0,1,1,4258.16,-2850.82,12.2226,6.07626,300,0),
  (10010039,900242,0,0,0,1,1,4150,-2820.67,32.457,0.311418,300,0),
  (10010040,900243,0,0,0,1,1,4169.4,-2712.48,20.8799,6.10763,300,0);

-- 8. ★躺地配置 (creature_addon.bytes1=7 睡姿, 让4个精灵趴在地上, 参考濒死的考古学家5569)
DELETE FROM `creature_addon` WHERE `guid` IN (10010037,10010038,10010039,10010040);
INSERT INTO `creature_addon` (`guid`,`bytes1`,`bytes2`,`emote`) VALUES
  (10010037, 7, 0, 0),
  (10010038, 7, 0, 0),
  (10010039, 7, 0, 0),
  (10010040, 7, 0, 0);

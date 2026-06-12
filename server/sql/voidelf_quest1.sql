-- =======================================================================
-- 虚空精灵起始任务链 - 第1个任务 (流亡精灵苏醒)
-- 日期: 2026-06-11  号段: 任务90020, NPC900210 [reference_custom_entry_naming]
-- 位置: 奎尔萨拉斯出生点旁 (4329.16, -2877.32, 1.026)
-- 双语(魔改enUS客户端,双语写本体)
-- =======================================================================

DELETE FROM `creature_template_model` WHERE `CreatureID` = 900210;
DELETE FROM `creature_template` WHERE `entry` = 900210;
DELETE FROM `creature` WHERE `guid` = 9500210;
DELETE FROM `quest_template` WHERE `ID` = 90020;
DELETE FROM `creature_queststarter` WHERE `quest` = 90020;
DELETE FROM `creature_questender` WHERE `quest` = 90020;

-- 1. 引导NPC (虚空精灵长者/向导)
INSERT INTO `creature_template`
  (`entry`,`name`,`subname`,`minlevel`,`maxlevel`,`faction`,`npcflag`,`unit_class`,`unit_flags`,`type`,`flags_extra`,`AIName`,`MovementType`)
VALUES
  (900210,'Magister Umbric 魔导师乌布里克','Voidborne 虚空裔',60,60,35,3,8,512,7,0,'',0);

-- 2. 模型 (银色盟约女精灵30311,符合虚空精灵=精灵外观)
INSERT INTO `creature_template_model`
  (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`)
VALUES
  (900210,0,30311,1.0,1,0);

-- 3. 生成点 (奎尔萨拉斯出生点旁,玩家给的坐标)
INSERT INTO `creature`
  (`guid`,`id1`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`MovementType`)
VALUES
  (9500210,900210,0,0,0,1,1,0,4329.16,-2877.3242,1.0262085,5.311723,300,0);

-- 4. 第1个任务 (苏醒引导,双语)
INSERT INTO `quest_template`
  (`ID`,`QuestType`,`QuestLevel`,`MinLevel`,`QuestSortID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardMoney`,`Flags`,`AllowableRaces`,
   `LogTitle`,`LogDescription`,`QuestDescription`,`QuestCompletionLog`)
VALUES
  (90020,2,1,1,2037,0,3,45,0,0,
   'Whispers of the Void 虚空的低语',
   'Speak with Magister Umbric to learn of your fate.$B与魔导师乌布里克交谈,了解你的命运。',
   'You have awakened, $n. The Void has touched us all, and yet we endure. I am Umbric, magister of the exiled. We were cast out from Quel''Thalas for daring to wield the Void''s power, but the Alliance has offered us refuge. Steady yourself, and we shall speak of what lies ahead.$B$B你已苏醒,$n。虚空触及了我们每一个人,但我们依然坚守。我是乌布里克,流亡者的魔导师。我们因敢于驾驭虚空之力而被逐出奎尔萨拉斯,但联盟向我们伸出了援手。稳住心神,我们再谈未来之路。',
   'Speak with Magister Umbric.$B与魔导师乌布里克交谈。');

-- 5. 任务关联 (乌布里克既给又收,纯对话任务)
INSERT INTO `creature_queststarter` (`id`,`quest`) VALUES (900210,90020);
INSERT INTO `creature_questender` (`id`,`quest`) VALUES (900210,90020);

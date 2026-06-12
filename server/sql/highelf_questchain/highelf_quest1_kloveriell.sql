-- =======================================================================
-- 高等精灵/虚空精灵 起始任务链 - 第1个任务 (移植自 newRaceSources)
-- 日期: 2026-06-11  号段: 任务90012, NPC 900120/900121 [reference_custom_entry_naming]
-- 原始: 任务30030, NPC 100140(Kloveriell)/100157(Eldreth)
-- 用【带列名】的INSERT,兼容你服务器表结构
-- 模型: Kloveriell=1000179(自定义模型,需客户端patch), Eldreth=28147
-- =======================================================================

DELETE FROM `creature_template_model` WHERE `CreatureID` IN (900120, 900121);
DELETE FROM `creature_template` WHERE `entry` IN (900120, 900121);
DELETE FROM `creature` WHERE `guid` IN (9500120, 9500121);
DELETE FROM `quest_template` WHERE `ID` = 90012;
DELETE FROM `creature_queststarter` WHERE `quest` = 90012;
DELETE FROM `creature_questender` WHERE `quest` = 90012;

INSERT INTO `creature_template`
  (`entry`,`name`,`subname`,`minlevel`,`maxlevel`,`faction`,`npcflag`,`unit_class`,`unit_flags`,`type`,`flags_extra`,`AIName`,`MovementType`)
VALUES
  (900120,'Kloveriell','The Silver Covenant',60,60,35,3,2,512,7,0,'',0),
  (900121,'Eldreth Spellshard','The Exiled Enclave',60,60,35,3,1,0,7,0,'',0);

INSERT INTO `creature_template_model`
  (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`)
VALUES
  (900120,0,30310,1.1,1,0),
  (900121,0,28147,1.1,1,0);

INSERT INTO `creature`
  (`guid`,`id1`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`MovementType`)
VALUES
  (9500120,900120,0,0,0,1,1,0,-8901.8,1077.18,109.229,5.46764,300,0),
  (9500121,900121,0,0,0,1,1,0,-8856.409,1067.1804,114.29768,4.002111,300,0);

INSERT INTO `quest_template`
  (`ID`,`QuestType`,`QuestLevel`,`MinLevel`,`QuestSortID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardMoney`,`Flags`,`AllowableRaces`,`LogTitle`,`LogDescription`,`QuestDescription`,`QuestCompletionLog`)
VALUES
  (90012,2,3,1,-378,0,3,45,0,0,
   'Flowers for a Friend',
   'Meet Eldreth Spellshard at King Llane''s Tomb.',
   'Greetings, $n. I am Kloveriell, a long-standing guardian of the Alliance. Please go meet my old friend Eldreth Spellshard who is paying respects at King Llane''s tomb.',
   'Speak with Eldreth Spellshard.');

INSERT INTO `creature_queststarter` (`id`,`quest`) VALUES (900120,90012);
INSERT INTO `creature_questender` (`id`,`quest`) VALUES (900121,90012);

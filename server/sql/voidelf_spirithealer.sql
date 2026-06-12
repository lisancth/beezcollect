-- =======================================================================
-- 虚空精灵海岸 - 灵魂医者(死亡复活天使)
-- 日期: 2026-06-12  号段: NPC 900230 [reference_custom_entry_naming]
-- 作用: 玩家死后变鬼魂跑到她身边, 点她原地复活(带复活虚弱debuff)
-- 照搬现成灵魂医者6491: npcflag=16385(SPIRITHEALER+GOSSIP), 天使模型5233, faction35
-- 摆放分工: 我建NPC模板给entry 900230, 用户游戏内 .npc add 900230 摆到海岸,
--          摆好后我导出生成点 + 配复活区(game_graveyard/graveyard_zone)。
-- =======================================================================

DELETE FROM `creature_template_model` WHERE `CreatureID` = 900230;
DELETE FROM `creature_template` WHERE `entry` = 900230;
DELETE FROM `creature` WHERE `id1` = 900230;

-- 1. 灵魂医者NPC (照6491配置)
--    npcflag 16385 = SPIRITHEALER(16384) + GOSSIP(1); unit_flags 768; flags_extra 2; type 7
INSERT INTO `creature_template`
  (`entry`,`name`,`subname`,`minlevel`,`maxlevel`,`faction`,`npcflag`,`unit_class`,`unit_flags`,`type`,`flags_extra`,`AIName`,`MovementType`)
VALUES
  (900230,'Soulkeeper of the Exiled 流亡者的守魂者','Spirit Healer 灵魂医者',60,60,35,16385,1,768,7,2,'',1);

-- 2. 模型 (天使外形, 借灵魂医者经典displayId 5233)
INSERT INTO `creature_template_model`
  (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`)
VALUES
  (900230,0,5233,1.0,1,0);

-- 3. 生成点 (用户 .npc add 900230 摆放, 2026-06-12导出)
INSERT INTO `creature`
  (`guid`,`id1`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`MovementType`)
VALUES
  (10010021,900230,0,0,0,1,1,4335.34,-2797.33,5.00187,4.21251,300,1);

-- =======================================================================
-- 4. ★复活区配置 (灵魂医者能复活的核心! 玩家死后鬼魂自动跑向这个复活点)
--    复活点ID 90002 [自制号段], 坐标=天使位置, 绑定到zone2037(奎尔萨拉斯)
-- =======================================================================
DELETE FROM `game_graveyard` WHERE `ID` = 90002;
DELETE FROM `graveyard_zone` WHERE `ID` = 90002 AND `GhostZone` = 2037;

-- 4a. 复活点坐标 (玩家在此处复活, 设在天使身边)
INSERT INTO `game_graveyard` (`ID`,`Map`,`x`,`y`,`z`,`Comment`)
VALUES
  (90002, 0, 4335.34, -2797.33, 5.00187, '虚空精灵海岸复活点(灵魂医者900230)');

-- 4b. 区域绑定 (zone2037奎尔萨拉斯死亡 → 用复活点90002; Faction0=不分阵营)
INSERT INTO `graveyard_zone` (`ID`,`GhostZone`,`Faction`,`Comment`)
VALUES
  (90002, 2037, 0, '奎尔萨拉斯→虚空精灵海岸复活点');

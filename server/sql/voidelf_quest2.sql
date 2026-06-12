-- =======================================================================
-- 虚空精灵起始任务链 - 第2个任务 (虚空的试炼 / 海岸鱼人遭遇战)
-- 日期: 2026-06-12  号段: 任务90021, 怪900220 [reference_custom_entry_naming]
-- 衔接: 90020(虚空的低语) → 90021(虚空的试炼)
-- 玩法: 杀8个被虚空腐蚀的海岸鱼人, 证明你能驾驭虚空之力作战
-- 双语(魔改enUS客户端,双语写本体)
-- 摆放分工: 我建怪模板给entry 900220, 用户游戏内 .npc add 900220 在海岸刷几只,
--          摆好后我从creature表导出生成点SQL补到这里。
-- =======================================================================

DELETE FROM `creature_template_model` WHERE `CreatureID` = 900220;
DELETE FROM `creature_template` WHERE `entry` = 900220;
DELETE FROM `creature_loot_template` WHERE `entry` = 900220;
DELETE FROM `creature` WHERE `id1` = 900220;
DELETE FROM `quest_template` WHERE `ID` = 90021;
DELETE FROM `quest_template_addon` WHERE `ID` IN (90020, 90021);
DELETE FROM `creature_queststarter` WHERE `quest` = 90021;
DELETE FROM `creature_questender` WHERE `quest` = 90021;

-- 1. 自定义怪: 腐潮鱼人 (被虚空腐蚀的海岸鱼人, 1-3级黄色可攻击)
--    MovementType=1 随机巡逻(会走动); lootid=900220 指向下面的掉落表
INSERT INTO `creature_template`
  (`entry`,`name`,`subname`,`minlevel`,`maxlevel`,`faction`,`npcflag`,`unit_class`,`unit_flags`,`type`,`flags_extra`,`AIName`,`MovementType`,
   `lootid`,`HealthModifier`,`DamageModifier`)
VALUES
  (900220,'Tideblight Murloc 腐潮鱼人','Void-touched 虚空所触',1,3,31,0,1,0,7,0,'',1,
   900220,1.0,1.0);

-- 2. 模型 (鱼人外观 displayId 486, 借经典低级鱼人模型)
INSERT INTO `creature_template_model`
  (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`)
VALUES
  (900220,0,486,1.0,1,0);

-- 3. 任务: 虚空的试炼 (杀8个腐潮鱼人, 奖励经验+宝石匕首1917)
INSERT INTO `quest_template`
  (`ID`,`QuestType`,`QuestLevel`,`MinLevel`,`QuestSortID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardMoney`,`Flags`,`AllowableRaces`,
   `RequiredNpcOrGo1`,`RequiredNpcOrGoCount1`,
   `RewardItem1`,`RewardAmount1`,
   `LogTitle`,`LogDescription`,`QuestDescription`,`QuestCompletionLog`)
VALUES
  (90021,2,2,1,2037,0,3,120,0,0,
   900220,8,
   1917,1,
   'Trial of the Void 虚空的试炼',
   'Slay 8 Tideblight Murlocs along the shore. The Void within you is a weapon -- learn to wield it.$B在海岸边消灭8只腐潮鱼人。你体内的虚空就是武器——学会驾驭它。',
   'The shore is no longer safe, $n. The murlocs here have been twisted by the same Void that flows through us -- but where it strengthens us, it has driven them to madness. Cull them. Show me that the Void answers to your will, not the other way around.$B$B海岸已不再安全,$n。这里的鱼人被同样流淌在我们体内的虚空所扭曲——但虚空令我们更强,却只把它们逼向疯狂。清理它们。让我看到虚空听命于你的意志,而非相反。',
   'Slay 8 Tideblight Murlocs and return to Magister Umbric.$B消灭8只腐潮鱼人,然后返回魔导师乌布里克处。');

-- 4. 任务链衔接 (addon表: 90021的前置是90020; 同时让90020完成后自动接90021)
INSERT INTO `quest_template_addon` (`ID`,`PrevQuestID`,`NextQuestID`) VALUES
  (90020, 0, 90021),    -- 第1任务: 后续是第2任务
  (90021, 90020, 0);    -- 第2任务: 前置是第1任务

-- 5. 任务关联 (乌布里克给+收第2任务)
INSERT INTO `creature_queststarter` (`id`,`quest`) VALUES (900210,90021);
INSERT INTO `creature_questender` (`id`,`quest`) VALUES (900210,90021);

-- 6. 让第1任务完成后自动衔接第2任务 (RewardNextQuest)
UPDATE `quest_template` SET `RewardNextQuest` = 90021 WHERE `ID` = 90020;

-- 7. 掉落表 (灰装垃圾 + 几率掉小包, 参考狼人/豺狼人怪的设定)
--    Chance=掉落几率%, 鱼人主题杂物+灰色武器+小几率棕色小包
INSERT INTO `creature_loot_template`
  (`entry`,`Item`,`Reference`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`)
VALUES
  -- 鱼人主题灰色杂物(常掉,卖钱垃圾)
  (900220, 537, 0, 35, 0, 1, 0, 1, 2, '灰暗的狂鱼鳞片'),
  (900220, 770, 0, 25, 0, 1, 0, 1, 1, '尖利的鳄鱼牙齿'),
  (900220, 779, 0, 20, 0, 1, 0, 1, 1, '闪亮的贝壳'),
  -- 灰色破烂武器(偶尔掉)
  (900220,1413, 0,  8, 0, 1, 0, 1, 1, '无力短剑(灰)'),
  (900220,1411, 0,  6, 0, 1, 0, 1, 1, '枯木法杖(灰)'),
  -- ★小几率掉棕色小包(惊喜)
  (900220,15699,0,  4, 0, 1, 0, 1, 1, '棕色小包(几率掉落)'),
  -- 少量铜币(默认money由模板控制, 这里再加点亚麻布)
  (900220,2589, 0, 15, 0, 1, 0, 1, 1, '亚麻布');

-- =======================================================================
-- 8. 生成点 (用户游戏内 .npc add 900220 摆放的19只, 2026-06-12导出)
--    海岸线散布, guid段 10010005~10010028
--    ★所有生成点 MovementType=1 + 怪需 wander_distance>0 才走动!
--      (.npc add 默认wander_distance=0会站着不动, 已统一UPDATE为8)
-- =======================================================================
INSERT INTO `creature`
  (`guid`,`id1`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`MovementType`)
VALUES
  (10010005,900220,0,0,0,1,1,4278.91,-2856.02,4.54978,5.39806,300,8,1),
  (10010006,900220,0,0,0,1,1,4297.93,-2891.61,-1.00325,0.143722,300,8,1),
  (10010007,900220,0,0,0,1,1,4267.49,-2831.36,4.88691,5.06031,300,8,1),
  (10010008,900220,0,0,0,1,1,4299.3,-2796.23,5.44281,5.91639,300,8,1),
  (10010009,900220,0,0,0,1,1,4304.98,-2802.05,5.03861,0.0494568,300,8,1),
  (10010010,900220,0,0,0,1,1,4321.48,-2800.74,5.35241,1.47495,300,8,1),
  (10010011,900220,0,0,0,1,1,4329.35,-2794.45,5.75446,1.48281,300,8,1),
  (10010012,900220,0,0,0,1,1,4361.82,-2814.42,-1.70253,4.79328,300,8,1),
  (10010013,900220,0,0,0,1,1,4356.44,-2834.93,-1.72395,4.7108,300,8,1),
  (10010014,900220,0,0,0,1,1,4343.5,-2833.54,1.3711,4.48698,300,8,1),
  (10010015,900220,0,0,0,1,1,4246.12,-2807.33,7.31079,4.56158,300,8,1),
  (10010016,900220,0,0,0,1,1,4244.47,-2807.08,7.73118,4.56158,300,8,1),
  (10010017,900220,0,0,0,1,1,4215.38,-2790.57,6.95704,2.67271,300,8,1),
  (10010018,900220,0,0,0,1,1,4214.31,-2782.04,6.70857,5.33913,300,8,1),
  (10010024,900220,0,0,0,1,1,4338.88,-2836.29,1.35926,4.57345,300,8,1),
  (10010025,900220,0,0,0,1,1,4261.55,-2850.52,12.2226,6.23848,300,8,1),
  (10010026,900220,0,0,0,1,1,4262.27,-2864.29,11.9258,0.430454,300,8,1),
  (10010027,900220,0,0,0,1,1,4276.78,-2816.5,6.10576,4.47134,300,8,1),
  (10010028,900220,0,0,0,1,1,4271.63,-2784.84,5.50778,5.98715,300,8,1);

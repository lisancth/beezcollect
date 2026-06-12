-- =======================================================================
-- 高等精灵起始任务链 - 简体中文(zhCN)本地化
-- 日期: 2026-06-11
-- 给任务90012/90013 和 NPC 900120/900121/900122 加中文翻译
-- 机制: 任务/NPC本体是英文(默认),中文客户端会读 _locale 表显示中文
-- 所在库: acore_world
-- =======================================================================

-- ============ 任务中文翻译 (quest_template_locale) ============
DELETE FROM `quest_template_locale` WHERE `ID` IN (90012, 90013) AND `locale` = 'zhCN';
INSERT INTO `quest_template_locale`
  (`ID`, `locale`, `Title`, `Details`, `Objectives`, `EndText`, `CompletedText`)
VALUES
-- 任务90012: Flowers for a Friend
(90012, 'zhCN',
 '献给挚友的花',
 '你好,$n。我是克洛维瑞尔,联盟长久以来的守护者,光明的仆从。我们的人民历经磨难,但曾有一段时光,希望如花绽放——那要归功于莱恩·乌瑞恩国王的勇气。他不仅是位伟大的国王,更是我亲密的朋友。$B$B请去见我的老友艾尔德蕾丝·法术碎片吧,她正在莱恩国王之墓前缅怀故人。',
 '与艾尔德蕾丝·法术碎片对话。',
 '愿光明指引你,$n。',
 ''),
-- 任务90013: Touched by Shadows
(90013, 'zhCN',
 '暗影之触',
 '当我们缅怀逝者之时,一股不安的气息扰乱了我的感知。暗影正在涌动。请去寻找高阶女祭司阿奎拉·恩匹瑞恩,将我所感知到的一切告诉她。',
 '与高阶女祭司阿奎拉·恩匹瑞恩对话。',
 '我们必须警惕这股暗影。',
 '');

-- ============ NPC名字中文翻译 (creature_template_locale) ============
DELETE FROM `creature_template_locale` WHERE `entry` IN (900120, 900121, 900122) AND `locale` = 'zhCN';
INSERT INTO `creature_template_locale`
  (`entry`, `locale`, `Name`, `Title`)
VALUES
(900120, 'zhCN', '克洛维瑞尔', '银色盟约'),
(900121, 'zhCN', '艾尔德蕾丝·法术碎片', '流亡飞地'),
(900122, 'zhCN', '阿奎拉·恩匹瑞恩', '高阶女祭司');

-- ============ 繁体中文(zhTW) 也加一份,简繁客户端都能显示中文 ============
DELETE FROM `quest_template_locale` WHERE `ID` IN (90012, 90013) AND `locale` = 'zhTW';
INSERT INTO `quest_template_locale` (`ID`,`locale`,`Title`,`Details`,`Objectives`,`EndText`,`CompletedText`)
SELECT `ID`,'zhTW',`Title`,`Details`,`Objectives`,`EndText`,`CompletedText`
FROM `quest_template_locale` WHERE `ID` IN (90012,90013) AND `locale`='zhCN';

DELETE FROM `creature_template_locale` WHERE `entry` IN (900120,900121,900122) AND `locale` = 'zhTW';
INSERT INTO `creature_template_locale` (`entry`,`locale`,`Name`,`Title`)
SELECT `entry`,'zhTW',`Name`,`Title`
FROM `creature_template_locale` WHERE `entry` IN (900120,900121,900122) AND `locale`='zhCN';

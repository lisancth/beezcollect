-- =======================================================================
-- 高等精灵任务链 - 双语版 (英文+中文 写进本体)
-- 日期: 2026-06-11
-- 原因: 客户端是【魔改的enUS】(GetLocale返回enUS),服务器只发英文本体,不读zhCN翻译表。
--       所以把双语直接写进 quest_template / creature_template 本体。
--       格式: 英文在上, $B$B 换行, 中文在下。
-- 所在库: acore_world
-- =======================================================================

-- ============ 任务1 (90012) 双语 ============
UPDATE `quest_template` SET
  `LogTitle` = 'Flowers for a Friend 献给挚友的花',
  `LogDescription` = 'Meet Eldreth Spellshard at King Llane''s Tomb.$B与艾尔德蕾丝·法术碎片在莱恩国王之墓相见。',
  `QuestDescription` = 'Greetings, $n. I am Kloveriell, a long-standing guardian of the Alliance. Please go meet my old friend Eldreth Spellshard who is paying respects at King Llane''s tomb.$B$B你好,$n。我是克洛维瑞尔,联盟长久以来的守护者。请去见我的老友艾尔德蕾丝·法术碎片吧,她正在莱恩国王之墓前缅怀故人。',
  `QuestCompletionLog` = 'Speak with Eldreth Spellshard.$B与艾尔德蕾丝·法术碎片对话。'
WHERE `ID` = 90012;

-- ============ 任务2 (90013) 双语 ============
UPDATE `quest_template` SET
  `LogTitle` = 'Touched by Shadows 暗影之触',
  `LogDescription` = 'Speak with High Priestess Aquila Empyrean.$B与高阶女祭司阿奎拉·恩匹瑞恩对话。',
  `QuestDescription` = 'As we honor the fallen, my senses are clouded by an unsettling aura. Shadows are stirring. Please seek out High Priestess Aquila Empyrean and tell her what I have sensed.$B$B当我们缅怀逝者之时,一股不安的气息扰乱了我的感知。暗影正在涌动。请去寻找高阶女祭司阿奎拉·恩匹瑞恩,将我所感知到的一切告诉她。',
  `QuestCompletionLog` = 'Speak with High Priestess Aquila Empyrean.$B与高阶女祭司阿奎拉·恩匹瑞恩对话。'
WHERE `ID` = 90013;

-- ============ NPC名字双语 (creature_template 本体) ============
UPDATE `creature_template` SET `name` = 'Kloveriell 克洛维瑞尔', `subname` = 'The Silver Covenant 银色盟约' WHERE `entry` = 900120;
UPDATE `creature_template` SET `name` = 'Eldreth Spellshard 艾尔德蕾丝', `subname` = 'The Exiled Enclave 流亡飞地' WHERE `entry` = 900121;
UPDATE `creature_template` SET `name` = 'Aquila Empyrean 阿奎拉', `subname` = 'High Priestess 高阶女祭司' WHERE `entry` = 900122;

# 高等精灵起始任务链 (银色盟约)

为高等精灵(种族14)在暴风城做的4连任务起始链,移植参考自 newRaceSources 并用自己的号段重做。

## 号段规范 (延续 reference_custom_entry_naming)
- 任务: 90012-90015
- NPC: 900120-900143
- 怪物: 900140-900142
- GameObject: 901150
- 生成点guid: 9500120+, 9501150+

## 任务链 (双语,客户端是魔改enUS所以双语写进本体)

| 任务ID | 名称 | 类型 | 接/交NPC |
|--------|------|------|----------|
| 90012 | 献给挚友的花 | 对话 | 克洛维瑞尔(900120)→艾尔德蕾丝(900121) |
| 90013 | 暗影之触 | 对话 | 艾尔德蕾丝→阿奎拉(900122) |
| 90014 | 城门口的野狼 | 杀怪收集5轻毛皮 | 阿奎拉→游侠艾琳迪亚(900143) |
| 90015 | 收集补给物资 | 采集6补给箱 | 游侠艾琳迪亚(既给又收) |

## 部署顺序 (有依赖,按序执行)
1. highelf_birthpoint_stormwind.sql  -- 高等精灵出生点改暴风城
2. highelf_quest1_kloveriell.sql     -- 任务1+NPC
3. highelf_quest2_touched_by_shadows.sql -- 任务2+NPC
4. highelf_quest3_wolf_pelts.sql     -- 任务3+自制狼+掉落
5. highelf_quest4_supplies.sql       -- 任务4+采集箱
6. highelf_quest_bilingual.sql       -- 任务1/2双语本体
7. highelf_quest_locale_zhCN.sql     -- (备用)locale表翻译

## 关键经验/坑
- **魔改enUS客户端**: GetLocale()返回enUS,服务器只发英文本体,不读zhCN翻译表。
  必须把双语直接写进 quest_template/creature_template 本体。
- **自制物品图标**: 自制item不在客户端DBC,图标乱。改用现成物品(如轻毛皮783)。
- **自制怪模型**: 自定义creature借用现成displayId即可,客户端能显示。
- **采集箱(GO)未完成**: type=10 GOOBER补给箱接任务后会发光,但魔改客户端鼠标
  放上去没有"齿轮"可交互光标(配置与狼人箱60101一字不差却不同结果)。
  疑似客户端对全新GO entry的渲染问题,待解决。
- **重启丢任务**: kill-9重启会丢失玩家内存中未存盘的任务状态(GM .quest add的)。

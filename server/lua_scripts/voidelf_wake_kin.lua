-- =======================================================================
-- 虚空精灵第3任务: 点击唤醒晕倒的精灵同胞
-- 日期: 2026-06-12
-- 效果: 点击躺在路上的晕倒精灵(900240/241/242) → 他站起来 + 道谢紫字
--       + 给玩家任务90022的credit + 3秒后消失(被救走)
-- =======================================================================
-- 机制(参考已验证的虚空精灵躺地脚本):
--   - 三个晕倒精灵躺地 = creature_addon.bytes1=7 (数据库配, 对NPC稳定)
--   - 点击 = RegisterCreatureGossipEvent(entry, 1, fn) [本服GOSSIP_HELLO=1]
--   - 站起 = creature:SetStandState(0); 给credit = player:KilledMonsterCredit(entry)
--   - 消失 = creature:DespawnOrUnsummon(延迟ms)
--   - return true 拦截对话(这些NPC没有任务框,拦截掉默认空菜单即可)
-- =======================================================================

local FALLEN_KIN = { [900240]=true, [900241]=true, [900242]=true, [900243]=true }
local STAND_STATE_STAND = 0
local QUEST_FALLEN_KIN = 90022

local QUEST_STATUS_INCOMPLETE = 3  -- ★进行中是3! (1是COMPLETE,之前写错成1导致点击没反应)

local function OnTalkFallenKin(event, player, creature)
    if not player or not creature then return end
    local entry = creature:GetEntry()
    if not FALLEN_KIN[entry] then return end

    local qstatus = player:GetQuestStatus(QUEST_FALLEN_KIN)
    -- 任务进行中(3) → 唤醒; 任务已完成(1)也允许唤醒剩下的(防卡)
    if qstatus == QUEST_STATUS_INCOMPLETE or qstatus == 1 then
        -- 站起来 + 道谢紫字 + 给任务credit
        creature:SetStandState(STAND_STATE_STAND)
        creature:SendUnitSay("谢谢你……我还以为再也见不到同胞了。", 0)
        player:SendAreaTriggerMessage("|cFF8B00FF你唤醒了一位倒下的同胞。|r")  -- 屏幕中央大字
        player:KilledMonsterCredit(entry)  -- 给任务credit(该NPC算1个目标)
        creature:DespawnOrUnsummon(3000)   -- 3秒后消失(被救走)
    else
        player:SendBroadcastMessage("|cFF8B00FF这位精灵昏迷不醒……(需要先接受任务「失踪的同胞」)|r")
    end
    return true  -- 拦截默认空gossip菜单(这些NPC本身无任务框)
end

-- 三个晕倒精灵都注册点击事件
RegisterCreatureGossipEvent(900240, 1, OnTalkFallenKin)  -- 1 = GOSSIP_EVENT_ON_HELLO
RegisterCreatureGossipEvent(900241, 1, OnTalkFallenKin)
RegisterCreatureGossipEvent(900242, 1, OnTalkFallenKin)
RegisterCreatureGossipEvent(900243, 1, OnTalkFallenKin)

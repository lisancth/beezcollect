-- =======================================================================
-- 虚空精灵出生躺地剧情 (流放苏醒)  —— 回到能用的方案 2026-06-12
-- 效果: 虚空精灵(种族12)首次登录躺在奎尔萨拉斯海岸(StandState睡姿),
--       点击乌布里克(900210) → 站起 + 紫字 + 正常接任务
-- =======================================================================
-- ★为什么这次行: 之前验证过 SetStandState(7)能躺、gossip点NPC时SetStandState(0)能站起。
--   躺不住单纯定时器不行是因为没有"客户端状态刷新触发点", 而点NPC(gossip)正好提供了这个触发。
--   之前唯一没解决的是"接任务" → 关键: gossip回调【return false】放行, 让核心弹任务框。
-- =======================================================================

local RACE_VOIDELF      = 12
local STAND_STATE_SLEEP = 7    -- 躺/睡姿
local STAND_STATE_STAND = 0    -- 站姿
local NPC_UMBRIC        = 900210

-- 首次登录: 躺下
local function OnFirstLogin(event, player)
    if not player then return end
    if player:GetRace() ~= RACE_VOIDELF then return end

    local fullGuid = player:GetGUID()
    -- 进世界1.5秒后躺下(等客户端加载完)
    CreateLuaEvent(function()
        local p = GetPlayerByGUID(fullGuid)
        if not p then return end
        p:SetStandState(STAND_STATE_SLEEP)  -- 躺下
        p:SendBroadcastMessage("|cFF8B00FF你在奎尔萨拉斯的海岸上苏醒……虚空仍在你的血脉中低语。|r")
        p:SendBroadcastMessage("|cFF8B00FFYou awaken on the shores of Quel'Thalas... the Void still whispers in your veins.|r")
    end, 1500, 1)
    -- 再补两次(防被进世界的状态重置冲掉, 让躺姿稳住)
    CreateLuaEvent(function()
        local p = GetPlayerByGUID(fullGuid)
        if p and p:GetStandState() ~= STAND_STATE_SLEEP then p:SetStandState(STAND_STATE_SLEEP) end
    end, 3000, 1)
    CreateLuaEvent(function()
        local p = GetPlayerByGUID(fullGuid)
        if p and p:GetStandState() ~= STAND_STATE_SLEEP then p:SetStandState(STAND_STATE_SLEEP) end
    end, 5000, 1)
end

-- 点击乌布里克: 若还躺着→站起+紫字, 然后【放行】让核心弹任务框
local function OnTalkUmbric(event, player, creature)
    if not player or not creature then return end
    -- 虚空精灵且还躺着 → 演苏醒(站起+紫字)
    if player:GetRace() == RACE_VOIDELF and player:GetStandState() == STAND_STATE_SLEEP then
        player:SetStandState(STAND_STATE_STAND)  -- 站起来(点NPC时客户端会刷新,这步能生效)
        player:SendAreaTriggerMessage("|cFF8B00FF乌布里克的呼唤将你从虚空的低语中唤醒……|r")  -- 屏幕中央大字
        player:SendBroadcastMessage("|cFF8B00FF乌布里克的声音将你唤醒,你挣扎着站起身来。|r")
        player:SendBroadcastMessage("|cFF8B00FFUmbric's voice awakens you. You struggle to your feet.|r")
    end
    -- ★不return true(不拦截) → 让核心继续原生处理这次gossip = 弹出任务对话框
    return false
end

RegisterPlayerEvent(30, OnFirstLogin)                    -- 30 = PLAYER_EVENT_ON_FIRST_LOGIN
RegisterCreatureGossipEvent(NPC_UMBRIC, 1, OnTalkUmbric) -- 1 = GOSSIP_EVENT_ON_HELLO

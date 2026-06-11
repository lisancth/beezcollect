-- =======================================================================
-- ezCollections 独立玩具箱系统服务端引擎 (防报错 & AIO联动版)
-- =======================================================================
local AddonsPrefix = "ezCollections"

-- 👑 【全服玩具大辞典】（3.3.5 典藏完整版）
-- 格式：[物品ID] = "物品ID,Flags(0),资料片(0旧世界/1TBC/2WLK),来源类型(0),描述文字,节日ID(0)"
local ServerToyDictionary = {
    -- ==========================================
    -- 🌍 【旧世界 (Classic) 经典玩具】
    -- ==========================================
    -- 注：itemID 已全部核对修正(原字典大量 itemID 与玩具名对不上，如尖叫者之靴/虚空火箭等被误当玩具)
    [1973]  = "1973,0,0,0,|cFFFFD200掉落：|r世界掉落|n|cFFFFD200区域：|r艾泽拉斯,0",           -- 欺诈宝珠 (变身敌对阵营)
    [21713] = "21713,0,0,0,|cFFFFD200来源：|r春节活动,0",                                     -- 艾露恩的蜡烛 (修正:原8898是奥术书)
    [13379] = "13379,0,0,0,|cFFFFD200掉落：|r巴纳扎尔|n|cFFFFD200区域：|r斯坦索姆,0",         -- 烈焰短笛 (修正:原13398是尖叫者之靴)
    [18660] = "18660,0,0,0,|cFFFFD200来源：|r工程学制造,0",                                   -- 世界放大器 (把自己变小)
    -- [23720] 已移除：23720 实际是「乌龟坐骑」而非铁靴烈酒
    [21519] = "21519,0,0,0,|cFFFFD200来源：|r冬幕节活动,0",                                   -- 槲寄生

    -- ==========================================
    -- 🌌 【燃烧的远征 (TBC) 经典玩具】
    -- ==========================================
    [35275] = "35275,0,1,0,|cFFFFD200掉落：|r凯尔萨斯·逐日者|n|cFFFFD200区域：|r魔导师平台,0", -- 辛多雷宝珠 (修正:原35226是虚空火箭)
    [32782] = "32782,0,1,0,|cFFFFD200掉落：|r泰罗克|n|cFFFFD200区域：|r斯克提斯,0",           -- 迷失雕像 (变身鸦人)
    [34029] = "34029,0,1,0,|cFFFFD200掉落：|r妖术领主玛拉卡斯|n|cFFFFD200区域：|r祖阿曼,0",   -- 小巫毒面具 (修正:原37244是真菌长靴)
    [33223] = "33223,0,1,0,|cFFFFD200来源：|rTCG卡牌兑换,0",                                  -- 钓鱼椅
    [38301] = "38301,0,1,0,|cFFFFD200来源：|rTCG卡牌兑换,0",                                  -- 跳舞球 D.I.S.C.O.
    -- 地精杂烩浓汤(原35227)已移除：实际是地精天气制造机，WotLK无此变身玩具

    -- ==========================================
    -- ❄️ 【巫妖王之怒 (WLK) 经典玩具】
    -- ==========================================
    [37254] = "37254,0,2,0,|cFFFFD200掉落：|r世界掉落|n|cFFFFD200区域：|r诺森德,0",           -- 超级猴子球 (粉色罩子变身大猩猩)
    [52253] = "52253,0,2,0,|cFFFFD200任务：|r影之哀伤,0",                                     -- 希尔瓦娜斯的音乐盒
    [52201] = "52201,0,2,0,|cFFFFD200任务：|r影之哀伤,0",                                     -- 穆拉丁的礼物 (变身冰霜矮人)
    [44606] = "44606,0,2,0,|cFFFFD200商人：|r玩具商|n|cFFFFD200区域：|r达拉然,0",             -- 玩具火车 (修正:原40769是垃圾贩卖机)
    [44430] = "44430,0,2,0,|cFFFFD200成就：|r硬币大师|n|cFFFFD200区域：|r达拉然,0",           -- 达拉然泰坦神铁徽记 (修正:原45022是银色小步兵)
    [44719] = "44719,0,2,0,|cFFFFD200声望：|r狂心氏族,0",                                     -- 狂心美酒 (变身狼獾人)
    [43499] = "43499,0,2,0,|cFFFFD200货币：|r奥杜尔圣物|n|cFFFFD200区域：|r风暴峭壁,0",       -- 铁靴烈酒 (WLK版本矮人变身)
    [34068] = "34068,0,2,0,|cFFFFD200来源：|r万圣节活动,0"                                    -- 沉重的南瓜灯
    -- 银色侍从的旗帜(原46802)已移除：实际是沉重的鱼人卵
}


-- 【核心模块：全局开放接口！】
-- 把它挂载到 _G (全局变量) 上，这样你服务器里的任何其他脚本(比如AIO)都能调用它！
_G.EzAutoAddToy = function(player, toyID)
    -- 安全校验
    if not player or not toyID or not ServerToyDictionary[toyID] then return end
    
    local guidLow = player:GetGUIDLow()
    local query = CharDBQuery("SELECT 1 FROM custom_toybox WHERE guid = " .. guidLow .. " AND toy_id = " .. toyID)
    
    if not query then
        CharDBExecute("INSERT INTO custom_toybox (guid, toy_id) VALUES (" .. guidLow .. ", " .. toyID .. ")")
        -- 修复：ADD:TOY 不能带 :END，客户端 AddList 对每段调 tonumber()，"END"→nil→table index is nil 崩溃刷屏
        player:SendAddonMessage(AddonsPrefix, "ADD:TOY:" .. toyID, 7, player)
        player:SendBroadcastMessage("|cFF00FF00[玩具箱] 💡 滴！新玩具已自动收录入库！|r")
    end
end

-- 本地快捷调用
local AutoAddToy = _G.EzAutoAddToy

-- 【全局】发送玩具总目录给客户端。既在登录时调用，也供 ezCollectionsServer 在客户端请求
-- LIST:DATA:TOYS 时调用(CACHEVERSION 变化清缓存后客户端会重新请求，必须能响应否则玩具箱空白)。
-- 每个玩具单独发一条(规避~255字节上限)且不带END，最后单独发一条纯END收尾。
_G.EzSendToyCatalog = function(player)
    if not player then return end
    player:SendAddonMessage(AddonsPrefix, "COLLECTIONS:TOY:END", 7, player)
    for toyID, toyData in pairs(ServerToyDictionary) do
        player:SendAddonMessage(AddonsPrefix, "LIST:DATA:TOYS:" .. toyID .. "=" .. toyData, 7, player)
    end
    player:SendAddonMessage(AddonsPrefix, "LIST:DATA:TOYS:END", 7, player)
end

-- 【全局】下发该玩家【已收藏】玩具列表(从数据库读，永久记录)。
-- 登录时调用，也供 ezCollectionsServer 在客户端请求 LIST:TOY 时调用(reload后重拉，避免变灰)。
_G.EzSendOwnedToys = function(player)
    if not player then return end
    local guidLow = player:GetGUIDLow()
    local query = CharDBQuery("SELECT toy_id FROM custom_toybox WHERE guid = " .. guidLow)
    local toyList = {"LIST", "TOY"}
    if query then
        repeat table.insert(toyList, tostring(query:GetUInt32(0))) until not query:NextRow()
    end
    table.insert(toyList, "END")
    player:SendAddonMessage(AddonsPrefix, table.concat(toyList, ":"), 7, player)
end


-- 【功能 1】：玩家上线时，扫描背包并发送数据 (超强防崩过滤版)
local function OnPlayerLogin(event, player)
    -- ==========================================
    -- 🛡️ 【终极防线】：绝对安全的机器人拦截 (利用 pcall 防崩溃)
    -- ==========================================
    local isBot = false
    
    -- 尝试 1：检测 AzerothCore 的 Playerbot 接口
    pcall(function() 
        if player:IsBot() then isBot = true end 
    end)
    
    -- 尝试 2：检测真实的玩家 IP (这次 API 名字绝对是对的！)
    pcall(function()
        local ip = player:GetPlayerIP()
        if not ip or ip == "" or ip == "0.0.0.0" then isBot = true end
    end)

    if isBot then return end -- 如果判定是机器人，安静地退出，绝不浪费一丝性能！
    -- ==========================================

    -- 1. 强行激活 UI，发送大辞典
    _G.EzSendToyCatalog(player)

    -- 2. 【上线自动扫描包包】：把你包里已经有的玩具全自动加上！
    for toyID, _ in pairs(ServerToyDictionary) do
        if player:HasItem(toyID) then
            AutoAddToy(player, toyID)
        end
    end
    
    -- 3. 延迟发送已收集的清单 (给数据库扫描留时间)
    local fullGuid = player:GetGUID()
    CreateLuaEvent(function(eventId, delay, repeats)
        local p = GetPlayerByGUID(fullGuid)
        if p then _G.EzSendOwnedToys(p) end
    end, 2000, 1)
end


-- 【触发器 2、3】：修复底层 API 数字报错
local function OnPlayerLoot(event, player, itemID, count) AutoAddToy(player, itemID) end
local function OnQuestReward(event, player, itemID, count) AutoAddToy(player, itemID) end

-- 顺手确保证全局函数生效（给AIO留的后门）
EzAutoAddToy = AutoAddToy

-- 【触发器 4】：GM 命令
local function OnPlayerCommand(event, player, command)
    -- 🔒 安全锁：防止关服时 command 为 nil 导致崩溃刷屏！
    if not command then return end 
    
    if string.find(string.lower(command), "^additem") then
        local toyID = tonumber(string.match(command, "%d+"))
        if toyID then
            CreateLuaEvent(function()
                if player:HasItem(toyID) then AutoAddToy(player, toyID) end
            end, 500, 1)
        end
    end
end

-- 【触发器 5】：手动 #addtoy 命令
local function OnPlayerChat(event, player, msg, type, lang)
    -- 🔒 安全锁：防止关服时 msg 为 nil 导致崩溃刷屏！
    if not msg then return false end 
    
    if string.sub(string.lower(msg), 1, 7) == "#addtoy" then
        local toyID = tonumber(string.match(msg, "%d+"))
        if toyID then AutoAddToy(player, toyID) end
        return false 
    end
end

RegisterPlayerEvent(3, OnPlayerLogin)
RegisterPlayerEvent(4, OnPlayerCommand)
RegisterPlayerEvent(18, OnPlayerChat)
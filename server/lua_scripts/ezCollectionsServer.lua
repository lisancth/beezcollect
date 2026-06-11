local Transmogrify = require ("transmogrification")
local ezCollections = require("ezCollectionSetting")
local VisualWeapon = Transmogrify.VisualWeapon;
local STORE = Transmogrify.STORE;
local SERVERVERSION = ezCollections.SERVERVERSION;
local CACHEVERSION = ezCollections.CACHEVERSION;
local MaxListCount = ezCollections.MaxListCount;
local DEBUG = ezCollections.DEBUG;
local DEVELOPERMODE = ezCollections.DEVELOPERMODE;
local ClientAddonEvents
local MessageQueue = {};
local TransmogWeaponPreviewCreatureEntry = 2334;

local AddonsPrefix = "ezCollections";
local function OutputMessage(msg)
    if (DEBUG) then
        print(msg); -- 修复：使用print替代可能不存在的PrintInfo，防崩
    end
end

-- 删除了导致连环死机的 _ENV.regMask 检查

local LE_TRANSMOG_COLLECTION_TYPE_HEAD = 1;
local LE_TRANSMOG_COLLECTION_TYPE_SHOULDER = 2;
local LE_TRANSMOG_COLLECTION_TYPE_BACK = 3;
local LE_TRANSMOG_COLLECTION_TYPE_CHEST = 4;
local LE_TRANSMOG_COLLECTION_TYPE_TABARD = 5;
local LE_TRANSMOG_COLLECTION_TYPE_SHIRT = 6;
local LE_TRANSMOG_COLLECTION_TYPE_WRIST = 7;
local LE_TRANSMOG_COLLECTION_TYPE_HANDS = 8;
local LE_TRANSMOG_COLLECTION_TYPE_WAIST = 9;
local LE_TRANSMOG_COLLECTION_TYPE_LEGS = 10;
local LE_TRANSMOG_COLLECTION_TYPE_FEET = 11;
local LE_TRANSMOG_COLLECTION_TYPE_WAND = 12;
local LE_TRANSMOG_COLLECTION_TYPE_1H_AXE = 13;
local LE_TRANSMOG_COLLECTION_TYPE_1H_SWORD = 14;
local LE_TRANSMOG_COLLECTION_TYPE_1H_MACE = 15;
local LE_TRANSMOG_COLLECTION_TYPE_DAGGER = 16;
local LE_TRANSMOG_COLLECTION_TYPE_FIST = 17;
local LE_TRANSMOG_COLLECTION_TYPE_SHIELD = 18;
local LE_TRANSMOG_COLLECTION_TYPE_HOLDABLE = 19;
local LE_TRANSMOG_COLLECTION_TYPE_2H_AXE = 20;
local LE_TRANSMOG_COLLECTION_TYPE_2H_SWORD = 21;
local LE_TRANSMOG_COLLECTION_TYPE_2H_MACE = 22;
local LE_TRANSMOG_COLLECTION_TYPE_STAFF = 23;
local LE_TRANSMOG_COLLECTION_TYPE_POLEARM = 24;
local LE_TRANSMOG_COLLECTION_TYPE_BOW = 25;
local LE_TRANSMOG_COLLECTION_TYPE_GUN = 26;
local LE_TRANSMOG_COLLECTION_TYPE_CROSSBOW = 27;
local LE_TRANSMOG_COLLECTION_TYPE_THROWN = 28;
local LE_TRANSMOG_COLLECTION_TYPE_FISHING_POLE = 29;
local LE_TRANSMOG_COLLECTION_TYPE_MISC = 30;
local NUM_LE_TRANSMOG_COLLECTION_TYPES = 30;

local LE_TRANSMOG_SEARCH_TYPE_ITEMS = 1;
local LE_TRANSMOG_SEARCH_TYPE_BASE_SETS = 2;
local LE_TRANSMOG_SEARCH_TYPE_USABLE_SETS = 3;
local NUM_LE_TRANSMOG_SEARCH_TYPES = 3;

local TRANSMOG_SOURCE_BOSS_DROP = 1;
local TRANSMOG_SOURCE_QUEST = 2;
local TRANSMOG_SOURCE_VENDOR = 3;
local TRANSMOG_SOURCE_WORLD_DROP = 4;
local TRANSMOG_SOURCE_ACHIEVEMENT = 5;
local TRANSMOG_SOURCE_PROFESSION = 6;
local TRANSMOG_SOURCE_STORE = 7;
local TRANSMOG_SOURCE_SUBSCRIPTION = 8;
local MAX_TRANSMOG_SOURCES = 8;

local function GetSlotByCategory(category)
    if category == LE_TRANSMOG_COLLECTION_TYPE_HEAD             then return "HEAD";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_SHOULDER     then return "SHOULDER";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_BACK         then return "BACK";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_CHEST        then return "CHEST";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_TABARD       then return "TABARD";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_SHIRT        then return "SHIRT";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_WRIST        then return "WRIST";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_HANDS        then return "HANDS";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_WAIST        then return "WAIST";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_LEGS         then return "LEGS";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_FEET         then return "FEET";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_WAND         then return "WAND";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_1H_AXE       then return "1H_AXE";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_1H_SWORD     then return "1H_SWORD";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_1H_MACE      then return "1H_MACE";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_DAGGER       then return "DAGGER";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_FIST         then return "FIST";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_SHIELD       then return "SHIELD";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_HOLDABLE     then return "HOLDABLE";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_2H_AXE       then return "2H_AXE";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_2H_SWORD     then return "2H_SWORD";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_2H_MACE      then return "2H_MACE";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_STAFF        then return "STAFF";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_POLEARM      then return "POLEARM";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_BOW          then return "BOW";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_GUN          then return "GUN";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_CROSSBOW     then return "CROSSBOW";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_THROWN       then return "THROWN";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_FISHING_POLE then return "FISHING_POLE";
    elseif category == LE_TRANSMOG_COLLECTION_TYPE_MISC         then return "MISC";
    end
    return nil;
end

local function GetCategoryBySlot(Slot)
    if Slot == "HEAD" then             return LE_TRANSMOG_COLLECTION_TYPE_HEAD;
    elseif Slot == "SHOULDER" then     return LE_TRANSMOG_COLLECTION_TYPE_SHOULDER;
    elseif Slot == "BACK" then         return LE_TRANSMOG_COLLECTION_TYPE_BACK;
    elseif Slot == "CHEST" then        return LE_TRANSMOG_COLLECTION_TYPE_CHEST;
    elseif Slot == "TABARD" then       return LE_TRANSMOG_COLLECTION_TYPE_TABARD;
    elseif Slot == "SHIRT" then        return LE_TRANSMOG_COLLECTION_TYPE_SHIRT;
    elseif Slot == "WRIST" then        return LE_TRANSMOG_COLLECTION_TYPE_WRIST;
    elseif Slot == "HANDS" then        return LE_TRANSMOG_COLLECTION_TYPE_HANDS;
    elseif Slot == "WAIST" then        return LE_TRANSMOG_COLLECTION_TYPE_WAIST;
    elseif Slot == "LEGS" then         return LE_TRANSMOG_COLLECTION_TYPE_LEGS;
    elseif Slot == "FEET" then         return LE_TRANSMOG_COLLECTION_TYPE_FEET;
    elseif Slot == "WAND" then         return LE_TRANSMOG_COLLECTION_TYPE_WAND;
    elseif Slot == "1H_AXE" then       return LE_TRANSMOG_COLLECTION_TYPE_1H_AXE;
    elseif Slot == "1H_SWORD" then     return LE_TRANSMOG_COLLECTION_TYPE_1H_SWORD;
    elseif Slot == "1H_MACE" then      return LE_TRANSMOG_COLLECTION_TYPE_1H_MACE;
    elseif Slot == "DAGGER" then       return LE_TRANSMOG_COLLECTION_TYPE_DAGGER;
    elseif Slot == "FIST" then         return LE_TRANSMOG_COLLECTION_TYPE_FIST;
    elseif Slot == "SHIELD" then       return LE_TRANSMOG_COLLECTION_TYPE_SHIELD;
    elseif Slot == "HOLDABLE" then     return LE_TRANSMOG_COLLECTION_TYPE_HOLDABLE;
    elseif Slot == "2H_AXE" then       return LE_TRANSMOG_COLLECTION_TYPE_2H_AXE;
    elseif Slot == "2H_SWORD" then     return LE_TRANSMOG_COLLECTION_TYPE_2H_SWORD;
    elseif Slot == "2H_MACE" then      return LE_TRANSMOG_COLLECTION_TYPE_2H_MACE;
    elseif Slot == "STAFF" then        return LE_TRANSMOG_COLLECTION_TYPE_STAFF;
    elseif Slot == "POLEARM" then      return LE_TRANSMOG_COLLECTION_TYPE_POLEARM;
    elseif Slot == "BOW" then          return LE_TRANSMOG_COLLECTION_TYPE_BOW;
    elseif Slot == "GUN" then          return LE_TRANSMOG_COLLECTION_TYPE_GUN;
    elseif Slot == "CROSSBOW" then     return LE_TRANSMOG_COLLECTION_TYPE_CROSSBOW;
    elseif Slot == "THROWN" then       return LE_TRANSMOG_COLLECTION_TYPE_THROWN;
    elseif Slot == "FISHING_POLE" then return LE_TRANSMOG_COLLECTION_TYPE_FISHING_POLE;
    elseif Slot == "MISC" then         return LE_TRANSMOG_COLLECTION_TYPE_MISC;
    end
    return nil;
end

local function GetCategory(class, subclass, inventoryType)
    local Category = nil;
    class = tonumber(class);
    subclass = tonumber(subclass);
    inventoryType = tonumber(inventoryType);
    if (class == 4) then
        if inventoryType == 1 then Category = LE_TRANSMOG_COLLECTION_TYPE_HEAD;
        elseif inventoryType == 3 then Category = LE_TRANSMOG_COLLECTION_TYPE_SHOULDER;
        elseif inventoryType == 16 then Category = LE_TRANSMOG_COLLECTION_TYPE_BACK;
        elseif inventoryType == 5 or inventoryType == 20 then Category = LE_TRANSMOG_COLLECTION_TYPE_CHEST;
        elseif inventoryType == 19 then Category = LE_TRANSMOG_COLLECTION_TYPE_TABARD;
        elseif inventoryType == 4 then Category = LE_TRANSMOG_COLLECTION_TYPE_SHIRT;
        elseif inventoryType == 9 then Category = LE_TRANSMOG_COLLECTION_TYPE_WRIST;
        elseif inventoryType == 10 then Category = LE_TRANSMOG_COLLECTION_TYPE_HANDS;
        elseif inventoryType == 6 then Category = LE_TRANSMOG_COLLECTION_TYPE_WAIST;
        elseif inventoryType == 7 then Category = LE_TRANSMOG_COLLECTION_TYPE_LEGS;
        elseif inventoryType == 8 then Category = LE_TRANSMOG_COLLECTION_TYPE_FEET;
        elseif inventoryType == 14 then Category = LE_TRANSMOG_COLLECTION_TYPE_SHIELD;
        elseif inventoryType == 23 then Category = LE_TRANSMOG_COLLECTION_TYPE_HOLDABLE;
        elseif inventoryType ~= 11 and inventoryType ~= 12 and inventoryType ~= 2 and inventoryType ~= 0 and inventoryType ~= 28 and subclass == 0 then Category = LE_TRANSMOG_COLLECTION_TYPE_MISC;
        end
    elseif (class == 2) then
        if inventoryType == 26 and (subclass ~= 3 and subclass ~= 18) then Category = LE_TRANSMOG_COLLECTION_TYPE_WAND;
        elseif subclass == 0 and (inventoryType == 13 or inventoryType == 21 or inventoryType == 22) then Category = LE_TRANSMOG_COLLECTION_TYPE_1H_AXE;
        elseif subclass == 7 and (inventoryType == 13 or inventoryType == 21 or inventoryType == 22) then Category = LE_TRANSMOG_COLLECTION_TYPE_1H_SWORD;
        elseif subclass == 4 and (inventoryType == 13 or inventoryType == 21 or inventoryType == 22) then Category = LE_TRANSMOG_COLLECTION_TYPE_1H_MACE;
        elseif subclass == 15 and (inventoryType == 13 or inventoryType == 21 or inventoryType == 22) then Category = LE_TRANSMOG_COLLECTION_TYPE_DAGGER;
        elseif subclass == 13 and (inventoryType == 13 or inventoryType == 21 or inventoryType == 22) then Category = LE_TRANSMOG_COLLECTION_TYPE_FIST;
        elseif inventoryType == 17 and subclass == 1 then Category = LE_TRANSMOG_COLLECTION_TYPE_2H_AXE;
        elseif inventoryType == 17 and subclass == 8 then Category = LE_TRANSMOG_COLLECTION_TYPE_2H_SWORD;
        elseif inventoryType == 17 and subclass == 5 then Category = LE_TRANSMOG_COLLECTION_TYPE_2H_MACE;
        elseif (inventoryType == 17 or inventoryType == 13) and subclass == 10 then Category = LE_TRANSMOG_COLLECTION_TYPE_STAFF;
        elseif inventoryType == 17 and subclass == 6 then Category = LE_TRANSMOG_COLLECTION_TYPE_POLEARM;
        elseif inventoryType == 15 and subclass == 2 then Category = LE_TRANSMOG_COLLECTION_TYPE_BOW;
        elseif inventoryType == 26 and subclass == 3 then Category = LE_TRANSMOG_COLLECTION_TYPE_GUN;
        elseif inventoryType == 26 and subclass == 18 then Category = LE_TRANSMOG_COLLECTION_TYPE_CROSSBOW;
        elseif inventoryType == 25 and subclass == 16 then Category = LE_TRANSMOG_COLLECTION_TYPE_THROWN;
        elseif inventoryType == 17 and subclass == 20 then Category = LE_TRANSMOG_COLLECTION_TYPE_FISHING_POLE;
        elseif inventoryType ~= 0 and subclass == 14 then Category = LE_TRANSMOG_COLLECTION_TYPE_MISC;
        end
    end
    return Category;
end

local function AddMessageQueue(player, messageType, message)
    local guid = player:GetGUIDLow();
    MessageQueue[guid] = MessageQueue[guid] or {};
    table.insert(MessageQueue[guid], {messageType, message});
end

-- 修复列表发送：完美防止数组索引跳跃丢失
local function SendListToAddon(player, prefix, list, func)
    if not list or #list == 0 then return end
    local msgs = {};
    for i=1,#list do
        local index = math.modf((i-1) / MaxListCount) + 1;
        msgs[index] = msgs[index] or "";
        local str = list[i];
        if (func) then str = func(str); end
        msgs[index] = msgs[index]..str..":";
    end
    for k,v in ipairs(msgs) do
        local msg = prefix..v;
        if (k == #msgs) then msg = msg.."END"; end
        player:SendAddonMessage(AddonsPrefix, msg, 0x07, player );
    end
end

local ItemTextStore = {}; 
local CategoryItemStore = {};
local ItemSets = {};

local function init()
    local _items = {};
    for entry,itemData in pairs(Transmogrify:GetItemStore()) do
        local Category = GetCategory(itemData.class, itemData.subclass, itemData.inventoryType);
        if (not Category) then goto continue; end
        
        _items[entry] = {};
        _items[entry].Category = Category;
        _items[entry].SourceMask = 0;
        _items[entry].Text = entry.."I"..itemData.inventoryType;
        
        CategoryItemStore[Category] = CategoryItemStore[Category] or {};
        table.insert(CategoryItemStore[Category], entry);
        
        if (itemData.class == 2) then
            if (VisualWeapon.Enable and (Category == LE_TRANSMOG_COLLECTION_TYPE_1H_AXE or 
              Category == LE_TRANSMOG_COLLECTION_TYPE_1H_SWORD or Category == LE_TRANSMOG_COLLECTION_TYPE_1H_MACE or 
              Category == LE_TRANSMOG_COLLECTION_TYPE_DAGGER or Category == LE_TRANSMOG_COLLECTION_TYPE_FIST or 
              Category == LE_TRANSMOG_COLLECTION_TYPE_SHIELD or Category == LE_TRANSMOG_COLLECTION_TYPE_2H_AXE or 
              Category == LE_TRANSMOG_COLLECTION_TYPE_2H_SWORD or Category == LE_TRANSMOG_COLLECTION_TYPE_2H_MACE or 
              Category == LE_TRANSMOG_COLLECTION_TYPE_STAFF or Category == LE_TRANSMOG_COLLECTION_TYPE_POLEARM)) then
                _items[entry].Text = _items[entry].Text.."E";
            else
                _items[entry].Text = _items[entry].Text.."W";
            end
        end
        
        if (itemData.class == 4) then _items[entry].Text = _items[entry].Text.."A"..itemData.subclass; end
        if (itemData.allowableClass ~= -1) then _items[entry].Text = _items[entry].Text.."L"..string.upper(string.format("%x",itemData.allowableClass)); end
        if (itemData.holidayId ~= 0) then _items[entry].Text = _items[entry].Text.."H"..itemData.holidayId; end
        if (itemData.itemset ~= 0) then
            ItemSets[itemData.itemset] = ItemSets[itemData.itemset] or {};
            table.insert(ItemSets[itemData.itemset], itemData.entry);
        end
        ::continue::
    end
    
    if (ezCollections.QueryQuestRewardItemText ~= "") then
        local QuestQuery = WorldDBQuery(ezCollections.QueryQuestRewardItemText);
        local questItem = {};
        if QuestQuery then
            repeat
                local QuestId = QuestQuery:GetUInt32(0);
                for i=1,QuestQuery:GetColumnCount()-1 do
                    local itemId = QuestQuery:GetUInt32(i);
                    if (_items[itemId]) then
                        questItem[itemId] = questItem[itemId] or {};
                        table.insert(questItem[itemId], QuestId);
                    end
                end
            until not QuestQuery:NextRow();
        end
        for id,questList in pairs(questItem) do
            _items[id].Text = _items[id].Text.."Q"..table.concat(questList,",");
            _items[id].SourceMask = _items[id].SourceMask  + 0x02;
        end
    end
    
    if (ezCollections.QueryNPCVendorItemText ~= "") then
        local VendorQuery = WorldDBQuery("SELECT item FROM npc_vendor where item > 0 GROUP BY item" );
        if VendorQuery then
            repeat
                local item = VendorQuery:GetUInt32(0);
                if (_items[item]) then
                    _items[item].SourceMask = _items[item].SourceMask  + 0x04;
                end
            until not VendorQuery:NextRow();
        end
    end
    
    if (STORE.Enable) then
        for _,v in pairs(Transmogrify:GetShopStoreList()) do
            if _items[v] then
                _items[v].SourceMask = _items[v].SourceMask  + 0x40;
            end
        end
    end
    
    for k,v in pairs(_items) do
        ItemTextStore[v.Category] = ItemTextStore[v.Category] or {};
        if (v.SourceMask ~= 0) then
            _items[k].Text = _items[k].Text.."S"..string.upper(string.format("%02X",v.SourceMask));
        end
        table.insert(ItemTextStore[v.Category], _items[k].Text);
    end
end
init();

local function initPlayerAddonData(player)
    local creature = player:GetNearestCreature( 50, TransmogWeaponPreviewCreatureEntry );
    if (not creature) then
        -- 修复：将假人存在时间从 1000 改为 86400000(24小时)，防止试衣间死机
        player:SpawnCreature(TransmogWeaponPreviewCreatureEntry, player:GetX(), player:GetY(), player:GetZ(), player:GetO(), 1, 86400000 )
    end
    player:SendAddonMessage(AddonsPrefix, "PREVIEWCREATURE:WEAPON:"..TransmogWeaponPreviewCreatureEntry, 0x07, player );
    player:SendAddonMessage(AddonsPrefix, "COLLECTIONS:OWNEDITEM", 0x07, player );
    player:SendAddonMessage(AddonsPrefix, "COLLECTIONS:SKIN", 0x07, player );
    player:SendAddonMessage(AddonsPrefix, "HIDEVISUALSLOTS:HEAD:SHOULDER:SHIRT:CHEST:WAIST:FEET:LEGS:WRIST:HANDS:BACK:TABARD:ENCHANT:", 0x07, player );
    
    if (Transmogrify.RequireToken) then
        player:SendAddonMessage(AddonsPrefix, "TOKEN:"..Transmogrify.TokenEntry, 0x07, player );
    end
    
    if (STORE.Enable and STORE.UrlFormat ~= "" ) then
        player:SendAddonMessage(AddonsPrefix, "COLLECTIONS:STORESKIN", 0x07, player );
        player:SendAddonMessage(AddonsPrefix, "STOREPARAMS:"..STORE.UrlFormat, 0x07, player );
    end
    ClientAddonEvents.GETTRANSMOG.ALL(player);
    -- 修复：reload(RELOADUI) 走这里，但原本只发 OWNEDITEM/SKIN，漏了书籍和玩具的 COLLECTIONS，
    -- 导致 reload 后图书馆/玩具箱收藏全变灰。补发 COLLECTIONS:BOOK + COLLECTIONS:TOY，
    -- 客户端会据此启用收藏并自动回发 LIST:BOOK / LIST:TOY 请求，由对应处理器从数据库重发已收藏列表。
    player:SendAddonMessage(AddonsPrefix, "COLLECTIONS:BOOK:END", 0x07, player );
    player:SendAddonMessage(AddonsPrefix, "COLLECTIONS:TOY:END", 0x07, player );
end

ClientAddonEvents = 
{
    VERSION = function(player, args)
        -- 修复：无论客户端发什么，强行发放“免死金牌”接通连接
        player:SendAddonMessage(AddonsPrefix, "SERVERVERSION:"..tostring(SERVERVERSION)..":OK", 0x07, player );
        player:SendAddonMessage(AddonsPrefix, "CACHEVERSION:"..CACHEVERSION, 0x07, player );
        player:SendAddonMessage(AddonsPrefix, "SEARCHPARAMS:3:1500", 0x07, player );
        player:SendAddonMessage(AddonsPrefix, "SETUPFINISHED", 0x07, player );
        player:SendAddonMessage(AddonsPrefix, "PREVIEWCREATURE:WEAPON:"..TransmogWeaponPreviewCreatureEntry, 0x07, player );
        if (DEVELOPERMODE) then
            if (player:IsGM()) then
                player:SendAddonMessage(AddonsPrefix, "DEVELOPER", 0x07, player );
            end
        end
        -- 修复：VERSION 是 reload 真正走的握手(客户端不发 RELOADUI)。补发各收藏类的 COLLECTIONS，
        -- 让 reload 后客户端重新启用收藏并回发 LIST 请求，由对应处理器重拉，避免变灰/背景板。
        player:SendAddonMessage(AddonsPrefix, "COLLECTIONS:BOOK:END", 0x07, player );
        player:SendAddonMessage(AddonsPrefix, "COLLECTIONS:TOY:END", 0x07, player );
        -- 幻化：reload 后补发外观收藏(OWNEDITEM/SKIN)、隐藏槽位配置、当前装备幻化状态，恢复幻化界面(否则背景板)。
        player:SendAddonMessage(AddonsPrefix, "COLLECTIONS:OWNEDITEM", 0x07, player );
        player:SendAddonMessage(AddonsPrefix, "COLLECTIONS:SKIN", 0x07, player );
        player:SendAddonMessage(AddonsPrefix, "HIDEVISUALSLOTS:HEAD:SHOULDER:SHIRT:CHEST:WAIST:FEET:LEGS:WRIST:HANDS:BACK:TABARD:ENCHANT:", 0x07, player );
        ClientAddonEvents.GETTRANSMOG.ALL(player);
    end,
    
    LIST = {
        OWNEDITEM = function(player, args) SendListToAddon(player, "LIST:OWNEDITEM:", player:GetItemList(), function(item) return item:GetEntry(); end) end,
        -- 图书馆：客户端 reload 后会请求 LIST:BOOK 重拉已收藏列表，必须响应否则书全变灰。
        -- 调用 ezLibraryServer 全局函数，从数据库读永久收藏记录下发。
        BOOK = function(player, args) if _G.EzSendOwnedBooks then _G.EzSendOwnedBooks(player); end end,
        TOY = function(player, args) if _G.EzSendOwnedToys then _G.EzSendOwnedToys(player); end end,
        SKIN = function(player, args) SendListToAddon(player, "LIST:SKIN:", Transmogrify:GetPlayerAllSkins(player)); end,
        STORESKIN = function(player, args) SendListToAddon(player, "LIST:STORESKIN:", Transmogrify:GetShopStoreList()); end,
        ALL = {
            Func = function(player, args)
                local category = table.unpack(args);
                SendListToAddon(player, string.format("LIST:ALL:%s:",category), ItemTextStore[GetCategoryBySlot(category)]);
            end,
            ENCHANT = function(player, args)
                SendListToAddon(player, "LIST:ALL:ENCHANT:", VisualWeapon:GetVisualWeaponItemStort());
            end,
        },
        DATA = {
            SETS = function(player,args)
                player:SendAddonMessage(AddonsPrefix, "LIST:DATA:SETS:END", 0x07, player );
                return true;
            end,
            -- 修复：客户端清缓存(CACHEVERSION变化)后会重新请求 LIST:DATA:TOYS，必须能响应否则玩具箱空白。
            -- 调用 ezToyBoxServer 提供的全局函数重发玩具总目录。
            TOYS = function(player,args)
                if _G.EzSendToyCatalog then _G.EzSendToyCatalog(player); end
                return true;
            end,
            -- 图书馆：客户端清缓存后会请求 LIST:DATA:BOOKS，调用 ezLibraryServer 全局函数重发书籍目录。
            BOOKS = function(player,args)
                if _G.EzSendBookCatalog then _G.EzSendBookCatalog(player); end
                return true;
            end,
            CAMERAS = function(player,args)
                player:SendAddonMessage(AddonsPrefix, "LIST:DATA:CAMERAS:0,0,0,1=1.30,-0.52,-1.15,1.57,:0,0,0,2=0.55,-0.52,-0.70,1.57,:0,0,0,3=0.00,-0.10,-0.47,0.00,:0,0,0,4=0.55,0.00,-0.90,0.00,:0,0,0,5=2.00,-0.52,-1.05,1.57,:0,0,0,6=2.00,-0.52,-1.10,1.57,:0,0,0,7=2.00,-0.52,-1.15,1.57,:0,0,0,8=2.00,-0.52,-0.95,1.57,:0,0,0,9=2.00,-0.52,-0.90,1.57,:0,0,0,10=2.00,-0.52,-0.85,1.57,:0,0,0,11=1.65,-0.52,-1.15,1.57,:0,0,0,12=2.00,-0.52,-1.00,1.57,:0,0,0,13=0.77,0.00,-0.90,0.00,:0,0,0,14=1.35,0.00,-0.88,0.00,:0,0,0,15=1.35,0.00,-0.93,0.00,:0,0,0,16=1.35,0.00,-0.98,0.00,:0,0,0,17=1.35,0.00,-0.78,0.00,:0,0,0,18=1.35,0.00,-0.73,0.00,:0,0,0,19=1.35,0.00,-0.68,0.00,:0,0,0,20=3.20,-0.32,-0.70,3.00,124:END", 0x07, player );
            end,
            SCROLLTOENCHANT = function(player,args)
                local list = {};
                for k,v in pairs(VisualWeapon:GetVisualWeaponData()) do table.insert(list, k.."="..v); end
                SendListToAddon(player, "LIST:DATA:SCROLLTOENCHANT:", list);
            end,
        },
    },
     
    RELOADUI = function(player, args) initPlayerAddonData(player); end,
    
    PRELOADCACHE = {
        ITEMS = function(player, args)
            local num = table.unpack(args);
            AddMessageQueue(player, "PRELOADCACHE:ITEMS:", string.format("PRELOADCACHE:ITEMS:%s:%s",tonumber(num) + MaxListCount * 50,Transmogrify:GetItemDataCount()));
            return true;
        end,
        MOUNTS = function(player, args)
            local num = table.unpack(args);
            AddMessageQueue(player, "PRELOADCACHE:MOUNTS:", string.format("PRELOADCACHE:MOUNTS:%s:%s",tonumber(num) + MaxListCount ,250));
            return true;
        end,
    },
    
    GETTRANSMOG = {
        ALL = function(player, args)
            local msg = "";
            for slot = EQUIPMENT_SLOT_START, EQUIPMENT_SLOT_END-1 do
                local item = player:GetItemByPos(INVENTORY_SLOT_BAG_0, slot);
                if (item) then
                    local fakeEntry, visual =  Transmogrify:GetFakeEntry(item);
                    msg = msg..slot.."="..item:GetEntry();
                    if (fakeEntry and fakeEntry ~= 0) then msg = msg..","..fakeEntry; end
                    if (visual and visual ~= -1) then msg = msg..",,"..visual; end
                    msg = msg..":";
                end
            end
            player:SendAddonMessage(AddonsPrefix, "GETTRANSMOG:ALL:"..msg.."END", 0x07, player );
        end,
        
        Func = function(player, args)
            local item = nil;
            local slot = tonumber(args[1]);
            if (slot) then
                item = player:GetItemByPos(INVENTORY_SLOT_BAG_0, tonumber(slot));
            else
                local bag, slot2 = table.unpack(string.split(args[1]," "))
                item = player:GetItemByPos(tonumber(bag) + INVENTORY_SLOT_BAG_START - 1, tonumber(slot2));
            end
            if (item) then
                local fakeEntry, visual = Transmogrify:GetFakeEntry(item);
                local msg = "GETTRANSMOG:"..args[1].."="..item:GetEntry();
                if (fakeEntry and fakeEntry ~= 0) then msg  = msg..","..fakeEntry; end
                if (visual and visual ~= -1) then msg  = msg..",,"..visual; end
                msg = msg .. ":";
                player:SendAddonMessage(AddonsPrefix, msg, 0x07, player );
            end
        end,
    },
    
    TRANSMOGRIFY = {
        SEARCH = {
            [LE_TRANSMOG_SEARCH_TYPE_ITEMS] = function(player, args)
                local searchToken,categorySlot,query,args2 = table.unpack(args);
                if (categorySlot == "CANCEL") then return; end
                local category = GetCategoryBySlot(categorySlot);
                if (CategoryItemStore[category] ~= nil) then
                    local list = {};
                    for _,v in pairs(CategoryItemStore[category]) do
                        local itemData = Transmogrify:GetItemData(v);
                        local text = itemData.name;
                        if (query and tonumber(query)) then text = tostring(v); end
                        if (query and not string.find(text, query)) then goto continue; end
                        if (args2 and string.find(args2,",")) then
                            local slot,itemId, Enchant = table.unpack(string.split(args2,","));
                        end
                        table.insert(list, v);
                        ::continue::
                    end
                    player:SendAddonMessage(AddonsPrefix, string.format("TRANSMOGRIFY:SEARCH:%s:%s:OK:%s",LE_TRANSMOG_SEARCH_TYPE_ITEMS, searchToken, #list), 0x07, player );
                    
                    -- 修复：原版这里多带了一个未定义的v，会导致点击部位翻页直接崩溃
                    SendListToAddon(player, string.format("TRANSMOGRIFY:SEARCH:%s:%s:RESULTS:",LE_TRANSMOG_SEARCH_TYPE_ITEMS,searchToken), list)
                end
            end,
            [LE_TRANSMOG_SEARCH_TYPE_BASE_SETS] = function(player, args) return "未处理"; end,
            [LE_TRANSMOG_SEARCH_TYPE_USABLE_SETS] = function(player, args) return "未处理"; end,
        },
        
        -- =======================================================================
        -- 【纯净最终版】：底层解析引擎，无任何报错，无任何全服弹字！
        -- =======================================================================
        Func = function(player, args)
            local HandleKey = args[1]
            if HandleKey ~= "COST" and HandleKey ~= "APPLY" then return end
            
            local outfitID = args[2]
            local itemsStartIndex = 3
            
            -- 智能识别并修正OutfitID的暗号位移
            if outfitID and string.find(outfitID, "=") then
                itemsStartIndex = 2
                outfitID = ""
            else
                outfitID = (outfitID == "nil" or not outfitID) and "" or outfitID
            end
            
            local price = 0
            local Token = 0
            local msgParts = {"TRANSMOGRIFY", HandleKey, "OK", "%s", "%s", outfitID}
            
            for i = itemsStartIndex, #args do
                if args[i] ~= "nil" and args[i] ~= "END" and args[i] ~= "" then
                    table.insert(msgParts, args[i])
                    
                    local eqPos = string.find(args[i], "=")
                    if eqPos then
                        local solt = string.sub(args[i], 1, eqPos - 1)
                        local info = string.sub(args[i], eqPos + 1)
                        
                        -- 完美防逗号跳跃解析
                        local parts = {}
                        for match in (info .. ","):gmatch("(.-),") do
                            table.insert(parts, (match == "" or match == "nil") and "0" or match)
                        end
                        
                        local baseEntry = tonumber(parts[1]) or 0
                        local baseEnchant = tonumber(parts[2]) or 0
                        local fakeEntry = tonumber(parts[3]) or 0
                        local fakeEnchant = tonumber(parts[4]) or 0
                        local pendingEntry = tonumber(parts[5]) or 0
                        local pendingEnchant = tonumber(parts[6]) or 0
                        
                        local slotNum = tonumber(solt)
                        if slotNum then
                            local transmogrified = player:GetItemByPos(INVENTORY_SLOT_BAG_0, slotNum - 1)
                            if transmogrified then
                                local currentFakeEntry, visual = Transmogrify:GetFakeEntry(transmogrified)
                                currentFakeEntry = currentFakeEntry or 0
                                visual = visual or -1
                                
                                -- 费用计算
                                if pendingEntry ~= -1 and pendingEntry ~= 0 and currentFakeEntry ~= pendingEntry then
                                    if Transmogrify.RequireGold == 1 then
                                        price = price + (Transmogrify:GetFakePrice(transmogrified) or 0) * (Transmogrify.GoldModifier or 1)
                                    elseif Transmogrify.RequireGold == 2 then
                                        price = price + (Transmogrify.GoldCost or 0)
                                    end
                                    if Transmogrify.RequireToken then Token = Token + (Transmogrify.TokenAmount or 0) end
                                end
                                
                                if VisualWeapon and VisualWeapon.Enable and pendingEnchant ~= -1 and pendingEnchant ~= 0 and visual ~= pendingEnchant then
                                    if Transmogrify.RequireGold == 1 then
                                        price = price + (Transmogrify:GetFakePrice(transmogrified) or 0) * (Transmogrify.GoldModifier or 1) * (VisualWeapon.GoldModifier or 1)
                                    elseif Transmogrify.RequireGold == 2 then
                                        price = price + (Transmogrify.GoldCost or 0) * (VisualWeapon.GoldModifier or 1)
                                    end
                                    if Transmogrify.RequireToken then Token = Token + math.ceil((Transmogrify.TokenAmount or 0) * (VisualWeapon.TokenModifier or 1)) end
                                end
                                
                                -- 执行幻化动作
                                if HandleKey == "APPLY" then
                                    if pendingEntry ~= -1 and pendingEntry ~= 0 and currentFakeEntry ~= pendingEntry then
                                        Transmogrify:SetTransmogrify(player, slotNum - 1, pendingEntry)
                                    end
                                    if VisualWeapon and VisualWeapon.Enable and pendingEnchant ~= -1 and pendingEnchant ~= 0 and visual ~= pendingEnchant then
                                        Transmogrify:SetVisualWeapon(player, slotNum - 1, pendingEnchant)
                                    end
                                    if pendingEntry == -1 or pendingEnchant == -1 then
                                        Transmogrify:DeleteFakeEntry(transmogrified, pendingEntry == -1, pendingEnchant == -1)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            -- 发送最终包裹
            local finalMsg = table.concat(msgParts, ":")
            local sendStr = string.format(finalMsg, price, Token)
            player:SendAddonMessage(AddonsPrefix, sendStr, 0x07, player)
        end,
    },

    PREVIEWCREATURE = {
        WEAPON = function(player, args)
            local creature = player:GetNearestCreature( 50, TransmogWeaponPreviewCreatureEntry );
            if (not creature) then
                player:SpawnCreature( TransmogWeaponPreviewCreatureEntry, player:GetX(), player:GetY(), player:GetZ(), player:GetO(), 1, 86400000 )
            end
            player:SendAddonMessage(AddonsPrefix, "PREVIEWCREATURE:WEAPON:"..TransmogWeaponPreviewCreatureEntry, 0x07, player );
        end,
    },
}

local ADDON_EVENT_ON_MESSAGE = 30;
RegisterServerEvent( ADDON_EVENT_ON_MESSAGE, function(event, sender, chatType, prefix, msg, target)
    if (prefix ~= AddonsPrefix) then return end
    
    local args = {};
    local func = ClientAddonEvents;
    -- 修复：双冒号防崩溃处理
    msg = msg:gsub("::", ":nil:") 
    for k,v in pairs(string.split(msg,":")) do
        if (type(func) ~= "function") then
            if (func[v] ~= nil) then
                func = func[v];
                goto continue;
            elseif (func[tonumber(v)] ~= nil) then
                func = func[tonumber(v)];
                goto continue;
            elseif (func.Func ~= nil) then
                func = func.Func;
                table.insert(args,v);
            end
        else
            if (v == "nil") then v = "" end
            table.insert(args,v);
        end
        ::continue::
    end
    if (type(func) ~= "function") then
        -- ==========================================
        -- 【晓晓专属：解决玩具点击无效和刷屏日志】
        local handled = false
        
        -- 1. 拦截点击玩具的暗号 (TOY:USE:物品ID)
        if string.find(msg, "^TOY:USE:") then
            local toyID = tonumber(string.match(msg, "%d+"))
            if toyID then
                local query = WorldDBQuery("SELECT spellid_1, spellid_2 FROM item_template WHERE entry = " .. toyID)
                if query then
                    local spellID = query:GetUInt32(0)
                    if (spellID == 0) then spellID = query:GetUInt32(1) end
                    if (spellID > 0) then
                        
                        -- 【核心逻辑：智能开关】
                        -- 检查玩家身上是否已经有这个玩具的魔法效果
                        if sender:HasAura(spellID) then
                            sender:RemoveAura(spellID) -- 移除法术 Buff
                            sender:DeMorph()           -- 强行解除外观变形（专治猴子球卡模型！）
                        else
                            -- 如果没有效果，为了防止两个变身玩具冲突，先保底卸妆一次，再施放新的！
                            sender:DeMorph()
                            sender:CastSpell(sender, spellID, true)
                        end
                        
                        handled = true
                    end
                end
            end
        elseif string.find(msg, "^LIST:TOY") then
            handled = true
        end

        -- 如果不是玩具相关的消息，才执行原本的报错打印
        if not handled then
            OutputMessage("[幻化]接收到未经处理的数据\""..msg.."\".");
        end
        -- ==========================================
    else
        local callback = func(sender, args);
        if (callback == false) then
            OutputMessage("[幻化]插件数据\""..msg.."\"未成功处理.");
        elseif (type(callback) == "string") then
            OutputMessage("[幻化]插件数据\""..msg.."\":"..callback..".");
        end
    end
    return false;
end)

local PLAYER_EVENT_ON_LOGIN = 3;
RegisterPlayerEvent(PLAYER_EVENT_ON_LOGIN, function(event, player)
    initPlayerAddonData(player)
end)

for k,player in pairs(GetPlayersInWorld()) do
    player:SendAddonMessage(AddonsPrefix, "VERSIONCHECK", 0x07, player );
    initPlayerAddonData(player);
end

CreateLuaEvent(function(eventId, delay, repeats)
    for k,playerMessageQueue in pairs(MessageQueue) do
        local player = GetPlayerByGUID(k);
        if player then
            for idx,v in pairs(playerMessageQueue) do
                local messageTypetype,message = table.unpack(v);
                player:SendAddonMessage(AddonsPrefix, message, 0x07, player );
                table.remove(playerMessageQueue, idx);
            end
        end
    end
end, 100, 0)
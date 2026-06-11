# beezcollect — ezCollections 收藏系统 (AzerothCore 3.3.5 魔改修复版)

为 **AzerothCore (WotLK 3.3.5)** 服务器适配的 ezCollections 收藏系统,
包含 **幻化 / 玩具箱 / 图书馆 / 坐骑 / 小伙伴(宠物)** 五大收藏功能的完整服务端 + 客户端。

本仓库是在 ezCollections 2.6.4 基础上,针对 3.3.5 客户端 + 魔改种族(地精/狼人/熊猫人/狐人等)
做了大量兼容性修复,并**新增了服务端图书馆(书籍收藏)功能**。

## 目录结构

```
beezcollect/
├── client/
│   └── ezCollections/        # 客户端 addon (放进 游戏目录\Interface\AddOns\)
├── server/
│   ├── lua_scripts/          # 服务端 Eluna Lua 脚本 (放进 服务器\bin\lua_scripts\)
│   │   ├── ezCollectionsServer.lua    # 主服务端(幻化握手/收藏下发)
│   │   ├── ezLibraryServer.lua        # 图书馆系统(新增)
│   │   ├── ezToyBoxServer.lua         # 玩具箱系统
│   │   └── ezCollectionSetting.lua    # 配置(含 CACHEVERSION)
│   └── sql/                  # 数据库建表脚本
│       ├── character_ezcollection_books.sql   # 图书馆收藏表(新增)
│       └── custom_toybox.sql                  # 玩具箱收藏表
└── README.md
```

## 部署步骤

### 1. 数据库
在 `acore_characters` 库执行 `server/sql/` 下的两个 SQL 建表脚本:
```bash
mysql -u acore -p acore_characters < server/sql/character_ezcollection_books.sql
mysql -u acore -p acore_characters < server/sql/custom_toybox.sql
```

### 2. 服务端
把 `server/lua_scripts/` 下的 4 个 .lua 文件放进服务器的 `bin/lua_scripts/` 目录,重启 worldserver。

### 3. 客户端
把 `client/ezCollections/` 整个文件夹放进游戏目录的 `Interface\AddOns\`。

> ⚠️ **客户端 addon 版本必须和服务端 SERVERVERSION 一致(当前 2.6.4)**,否则握手失败界面打不开。

## 重要机制说明

- **CACHEVERSION**:`ezCollectionSetting.lua` 里的版本号。**只要改动了物品/玩具/书籍数据,必须把它 +1**,
  否则客户端用旧缓存不刷新。改完重启服务器,玩家下次登录会自动清缓存重拉。
- **收藏是永久记录**:玩具/书籍收藏写进数据库,删物品/存仓库都不会变灰。
- **reload 恢复**:服务端在 VERSION 握手(reload 走这条)里补发各收藏类数据,所以 `/reload` 后收藏不丢。
- **魔改种族**:`ModelFrames.lua` 和 `Camera.lua` 两张种族表都加了兜底,任何魔改种族都不会崩。

## 已修复的主要问题(本版本)

| 模块 | 问题 | 修复 |
|---|---|---|
| 握手 | addon 加载时 Frame 时序崩溃导致界面打不开 | 多处 nil 保护 |
| 本地化 | enUS 残缺 131 个常量导致界面报错 | 全部补齐 |
| 魔改种族 | 种族表只有 WotLK 10 族,地精/狼人等崩溃 | 两张表补全 + 兜底 |
| 人多卡顿 | 达拉然 inspect 无幻化玩家崩溃刷屏 | nil 保护 |
| 玩具箱 | itemID 录入错误(乌龟坐骑/尖叫者之靴等)+ 空白 | 字典全面核对 + 协议修复 |
| 小伙伴 | 列表灰马 + 名字显示成技能名 + 3D 不显示 | 名字写入本地表 + ClearModel |
| 图书馆 | 服务端完全没实现 | **全新实现(398本书)** |

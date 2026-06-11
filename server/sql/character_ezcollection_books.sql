-- =======================================================================
-- ezCollections 图书馆系统 - 玩家已收藏书籍表
-- 创建日期: 2026-06-10
-- 作用: 永久记录每个角色读过/收藏过哪些书籍(与背包无关,删书/存仓库不影响)
-- 所在库: acore_characters
-- 配套服务端脚本: ezLibraryServer.lua
-- =======================================================================

CREATE TABLE IF NOT EXISTS `character_ezcollection_books` (
  `guid` INT UNSIGNED NOT NULL COMMENT '角色GUID',
  `bookID` INT UNSIGNED NOT NULL COMMENT '书籍ID(=书籍物品 item entry)',
  `unlockTime` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '解锁时间戳',
  PRIMARY KEY (`guid`, `bookID`),
  KEY `idx_guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='ezCollections图书馆-玩家已收藏书籍';

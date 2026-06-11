-- =======================================================================
-- ezCollections 玩具箱系统 - 玩家已收藏玩具表
-- 作用: 永久记录每个角色收藏过哪些玩具(与背包无关,删玩具/存仓库不影响)
-- 所在库: acore_characters
-- 配套服务端脚本: ezToyBoxServer.lua
-- 注: 此表可能已由其他玩具箱模块创建,使用 IF NOT EXISTS 避免冲突
-- =======================================================================

CREATE TABLE IF NOT EXISTS `custom_toybox` (
  `guid` INT UNSIGNED NOT NULL COMMENT '玩家的全局ID',
  `toy_id` INT UNSIGNED NOT NULL COMMENT '玩具的物品ID',
  PRIMARY KEY (`guid`, `toy_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='玩家玩具箱解锁记录';

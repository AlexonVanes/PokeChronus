-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 22, 2025 at 06:41 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pokemonster`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `id` int(11) NOT NULL,
  `name` varchar(32) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `password` char(40) NOT NULL,
  `secret` char(16) DEFAULT NULL,
  `type` int(11) NOT NULL DEFAULT 1,
  `premdays` int(11) NOT NULL DEFAULT 0,
  `lastday` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `email` varchar(255) NOT NULL DEFAULT '',
  `creation` int(11) NOT NULL DEFAULT 0,
  `pontos` int(11) NOT NULL DEFAULT 0,
  `creationIp` varchar(255) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `accounts`
--

INSERT INTO `accounts` (`id`, `name`, `image`, `password`, `secret`, `type`, `premdays`, `lastday`, `email`, `creation`, `pontos`, `creationIp`) VALUES
(1, 'gm', NULL, 'd2d359e4ae582adac36781910ecc7abbb6c45854', NULL, 6, 0, 0, 'dopiaui12345@gmail.com', 1724893110, 0, '16777343'),
(2, 'Testando', NULL, '6ce6f4673054167de30aadc7d04553cde76bf5d4', NULL, 1, 0, 0, 'Testando@gmail.com', 1737507627, 0, '16777343'),
(3, 'dudinha', NULL, '08b3b931fd05ff29f0156f4d45d6951dc41ab4e4', NULL, 1, 0, 0, 'dudinha@gmail.com', 1737509397, 0, '16777343');

-- --------------------------------------------------------

--
-- Table structure for table `account_bans`
--

CREATE TABLE `account_bans` (
  `account_id` int(11) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `banned_at` bigint(20) NOT NULL,
  `expires_at` bigint(20) NOT NULL,
  `banned_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `account_ban_history`
--

CREATE TABLE `account_ban_history` (
  `id` int(10) UNSIGNED NOT NULL,
  `account_id` int(11) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `banned_at` bigint(20) NOT NULL,
  `expired_at` bigint(20) NOT NULL,
  `banned_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `account_viplist`
--

CREATE TABLE `account_viplist` (
  `account_id` int(11) NOT NULL COMMENT 'id of account whose viplist entry it is',
  `player_id` int(11) NOT NULL COMMENT 'id of target player of viplist entry',
  `description` varchar(128) NOT NULL DEFAULT '',
  `icon` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `notify` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `blocked_ips`
--

CREATE TABLE `blocked_ips` (
  `id` int(11) NOT NULL,
  `ip` varchar(45) NOT NULL,
  `timestamp` int(11) NOT NULL,
  `quantidade` int(11) NOT NULL DEFAULT 0,
  `bloqueado` varchar(1) NOT NULL DEFAULT 'F'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bonificacoes`
--

CREATE TABLE `bonificacoes` (
  `id` int(11) NOT NULL,
  `created_admin_id` int(11) NOT NULL,
  `update_admin_id` int(11) DEFAULT NULL,
  `valorMin` int(11) NOT NULL,
  `valorMax` int(11) NOT NULL,
  `porcentagem` int(11) NOT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `date_created` datetime DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `boss_ranking`
--

CREATE TABLE `boss_ranking` (
  `classificacao` int(11) NOT NULL,
  `player` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categoria`
--

CREATE TABLE `categoria` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `descricao` text NOT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'T'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `config_categoria_wiki`
--

CREATE TABLE `config_categoria_wiki` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `descricao` text NOT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'F'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `config_inicio`
--

CREATE TABLE `config_inicio` (
  `id` int(11) NOT NULL,
  `pc` text DEFAULT NULL,
  `mobile32` text DEFAULT NULL,
  `mobile64` text DEFAULT NULL,
  `discord` varchar(255) DEFAULT NULL,
  `facebook` varchar(255) DEFAULT NULL,
  `instagram` varchar(255) DEFAULT NULL,
  `youtube` varchar(255) DEFAULT NULL,
  `regras` longtext DEFAULT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'F'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `config_permission_bazar`
--

CREATE TABLE `config_permission_bazar` (
  `id` int(11) NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `id_account` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `config_permission_bonificacao`
--

CREATE TABLE `config_permission_bonificacao` (
  `id` int(11) NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `id_account` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `config_permission_inicio`
--

CREATE TABLE `config_permission_inicio` (
  `id` int(11) NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `id_account` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `config_permission_noticia`
--

CREATE TABLE `config_permission_noticia` (
  `id` int(11) NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `id_account` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `config_permission_pacotes`
--

CREATE TABLE `config_permission_pacotes` (
  `id` int(11) NOT NULL,
  `criar` varchar(1) DEFAULT 'F',
  `ler` varchar(1) DEFAULT 'F',
  `atualizar` varchar(1) DEFAULT 'F',
  `deletar` varchar(1) DEFAULT 'F',
  `status` varchar(1) DEFAULT 'F',
  `id_account` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `config_permission_promocional`
--

CREATE TABLE `config_permission_promocional` (
  `id` int(11) NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `id_account` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `config_permission_push`
--

CREATE TABLE `config_permission_push` (
  `id` int(11) NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) DEFAULT 'F',
  `id_account` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `config_permission_quests`
--

CREATE TABLE `config_permission_quests` (
  `id` int(11) NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `id_account` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `config_permission_team`
--

CREATE TABLE `config_permission_team` (
  `id` int(11) NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `id_account` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `config_permission_wiki`
--

CREATE TABLE `config_permission_wiki` (
  `id` int(11) NOT NULL,
  `criar` varchar(1) NOT NULL DEFAULT 'F',
  `ler` varchar(1) NOT NULL DEFAULT 'F',
  `atualizar` varchar(1) NOT NULL DEFAULT 'F',
  `deletar` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `id_account` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `config_promocional`
--

CREATE TABLE `config_promocional` (
  `id` int(11) NOT NULL,
  `created_admin_id` int(11) NOT NULL,
  `update_admin_id` int(11) DEFAULT NULL,
  `name_account` varchar(255) NOT NULL,
  `apelido` varchar(255) DEFAULT NULL,
  `porcentagem` int(11) NOT NULL,
  `codigo` text NOT NULL,
  `date_created` datetime DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT current_timestamp(),
  `status` varchar(1) NOT NULL DEFAULT 'F'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `config_quests`
--

CREATE TABLE `config_quests` (
  `id` int(11) NOT NULL,
  `created_admin_id` int(11) NOT NULL,
  `update_admin_id` int(11) DEFAULT NULL,
  `storage` text NOT NULL,
  `name` varchar(255) NOT NULL,
  `descricao` text DEFAULT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'T',
  `date_created` datetime DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `config_team`
--

CREATE TABLE `config_team` (
  `id` int(11) NOT NULL,
  `id_account` int(11) NOT NULL,
  `apelido` varchar(50) NOT NULL,
  `cargo` varchar(50) NOT NULL,
  `imutavel` varchar(1) NOT NULL DEFAULT 'F',
  `status` varchar(1) NOT NULL DEFAULT 'F'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `config_vocations`
--

CREATE TABLE `config_vocations` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `id_vocation` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `config_wiki`
--

CREATE TABLE `config_wiki` (
  `id` int(11) NOT NULL,
  `created_admin_id` int(11) NOT NULL,
  `update_admin_id` int(11) DEFAULT NULL,
  `categoria_id` int(11) NOT NULL,
  `titulo` text NOT NULL,
  `corpo` longtext NOT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `date_created` datetime DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `download`
--

CREATE TABLE `download` (
  `id` int(11) NOT NULL,
  `pc` text NOT NULL,
  `mobile` text NOT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'F'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `global_storage`
--

CREATE TABLE `global_storage` (
  `key` int(10) UNSIGNED NOT NULL,
  `value` varchar(255) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `global_storage`
--

INSERT INTO `global_storage` (`key`, `value`) VALUES
(1, '1');

-- --------------------------------------------------------

--
-- Table structure for table `guilds`
--

CREATE TABLE `guilds` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `ownerid` int(11) NOT NULL,
  `creationdata` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `level` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `gold` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `buffs` blob DEFAULT NULL,
  `wars_won` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `wars_lost` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `motd` varchar(255) NOT NULL DEFAULT '',
  `join_status` tinyint(4) NOT NULL DEFAULT 1,
  `language` tinyint(4) NOT NULL DEFAULT 1,
  `required_level` int(11) NOT NULL DEFAULT 1,
  `emblem` int(11) NOT NULL DEFAULT 1,
  `pacifism` bigint(20) NOT NULL DEFAULT 0,
  `pacifism_status` tinyint(4) NOT NULL DEFAULT 0,
  `buffs_save` bigint(20) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `guilds`
--

INSERT INTO `guilds` (`id`, `name`, `ownerid`, `creationdata`, `level`, `gold`, `buffs`, `wars_won`, `wars_lost`, `motd`, `join_status`, `language`, `required_level`, `emblem`, `pacifism`, `pacifism_status`, `buffs_save`) VALUES
(1, 'Teste', 1, 1725378695, 6, 210000, 0x020202000000000000, 0, 0, '', 1, 1, 50, 0, 0, 0, 1731803288182);

--
-- Triggers `guilds`
--
DELIMITER $$
CREATE TRIGGER `oncreate_guilds` AFTER INSERT ON `guilds` FOR EACH ROW BEGIN
		INSERT INTO `guild_ranks` (`name`, `permissions`, `guild_id`, `leader`) VALUES ('the Leader', -1, NEW.`id`, 1);
		INSERT INTO `guild_ranks` (`name`, `permissions`, `guild_id`, `default`) VALUES ('a Member', 0, NEW.`id`, 1);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `guilds_inbox`
--

CREATE TABLE `guilds_inbox` (
  `id` int(11) NOT NULL,
  `target_id` int(11) NOT NULL DEFAULT 0,
  `guild_id` int(11) NOT NULL DEFAULT 0,
  `date` bigint(20) UNSIGNED NOT NULL,
  `type` tinyint(4) NOT NULL,
  `text` varchar(255) NOT NULL,
  `finished` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `guilds_inbox`
--

INSERT INTO `guilds_inbox` (`id`, `target_id`, `guild_id`, `date`, `type`, `text`, `finished`) VALUES
(1, 0, 0, 1727322665, 6, 'Teste deposited {10000}.', 0),
(2, 0, 0, 1730251379, 5, 'Guild {Brave} has been disbanded by the leader.', 0),
(3, 0, 0, 1730251395, 6, 'Teste deposited {20000}.', 0),
(4, 0, 0, 1731438079, 6, 'Icaro deposited {9990000}.', 0),
(5, 0, 0, 1731803331, 6, 'Icaro deposited {10000}.', 0),
(6, 0, 0, 1732044084, 6, 'Teste deposited {9990000}.', 0);

-- --------------------------------------------------------

--
-- Table structure for table `guilds_inbox_old`
--

CREATE TABLE `guilds_inbox_old` (
  `player_id` int(11) NOT NULL,
  `target_id` int(11) NOT NULL DEFAULT 0,
  `guild_id` int(11) NOT NULL DEFAULT 0,
  `date` bigint(20) UNSIGNED NOT NULL,
  `type` tinyint(4) NOT NULL,
  `text` varchar(255) NOT NULL,
  `finished` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `guilds_player_inbox`
--

CREATE TABLE `guilds_player_inbox` (
  `player_id` int(11) NOT NULL,
  `inbox_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `guilds_player_inbox`
--

INSERT INTO `guilds_player_inbox` (`player_id`, `inbox_id`) VALUES
(1, 4),
(1, 5);

-- --------------------------------------------------------

--
-- Table structure for table `guildwar_kills`
--

CREATE TABLE `guildwar_kills` (
  `id` int(11) NOT NULL,
  `warid` int(11) NOT NULL DEFAULT 0,
  `killer` varchar(50) NOT NULL,
  `target` varchar(50) NOT NULL,
  `killerguild` int(11) NOT NULL DEFAULT 0,
  `targetguild` int(11) NOT NULL DEFAULT 0,
  `time` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `guild_invites`
--

CREATE TABLE `guild_invites` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL DEFAULT 0,
  `guild_id` int(11) NOT NULL DEFAULT 0,
  `date` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `guild_members`
--

CREATE TABLE `guild_members` (
  `player_id` int(11) NOT NULL,
  `guild_id` int(11) NOT NULL,
  `rank_id` int(11) NOT NULL,
  `nick` varchar(15) NOT NULL DEFAULT '',
  `leader` tinyint(4) NOT NULL DEFAULT 0,
  `contribution` bigint(20) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `guild_members`
--

INSERT INTO `guild_members` (`player_id`, `guild_id`, `rank_id`, `nick`, `leader`, `contribution`) VALUES
(1, 1, 1, '', 1, 10000);

-- --------------------------------------------------------

--
-- Table structure for table `guild_ranks`
--

CREATE TABLE `guild_ranks` (
  `id` int(11) NOT NULL,
  `guild_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `permissions` int(11) NOT NULL DEFAULT 0,
  `default` tinyint(4) NOT NULL DEFAULT 0,
  `leader` tinyint(4) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `guild_ranks`
--

INSERT INTO `guild_ranks` (`id`, `guild_id`, `name`, `permissions`, `default`, `leader`) VALUES
(1, 1, 'the Leader', -1, 0, 1),
(2, 1, 'a Member', 0, 1, 0),
(7, 1, 'Membro Novo', 34, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `guild_wars`
--

CREATE TABLE `guild_wars` (
  `id` int(11) NOT NULL,
  `guild1` int(11) NOT NULL DEFAULT 0,
  `guild2` int(11) NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `goldBet` int(11) NOT NULL DEFAULT 0,
  `duration` bigint(20) NOT NULL DEFAULT 0,
  `killsMax` int(11) NOT NULL DEFAULT 0,
  `forced` tinyint(4) NOT NULL DEFAULT 0,
  `started` bigint(20) NOT NULL DEFAULT 0,
  `ended` bigint(20) NOT NULL DEFAULT 0,
  `winner` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `historico_bazar`
--

CREATE TABLE `historico_bazar` (
  `id` int(11) NOT NULL,
  `payment_id` varchar(255) DEFAULT NULL,
  `account_id_comprador` int(11) NOT NULL,
  `account_id_vendedor` int(11) NOT NULL,
  `char_id` int(11) NOT NULL,
  `valor` int(11) NOT NULL,
  `pix` varchar(1) NOT NULL DEFAULT 'F',
  `pago_comprador` varchar(1) NOT NULL DEFAULT 'F',
  `pago_vendedor` varchar(1) NOT NULL DEFAULT 'F',
  `status_pagamento` int(11) DEFAULT NULL,
  `date_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `historico_mp`
--

CREATE TABLE `historico_mp` (
  `id` int(11) NOT NULL,
  `payment_id` varchar(250) DEFAULT NULL,
  `account_id` int(11) NOT NULL,
  `valor` int(11) NOT NULL,
  `multiplicador` int(11) NOT NULL DEFAULT 1,
  `promocional_id` int(11) DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `date_created` date DEFAULT NULL,
  `create_admin_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Triggers `historico_mp`
--
DELIMITER $$
CREATE TRIGGER `set_date_created` BEFORE INSERT ON `historico_mp` FOR EACH ROW BEGIN
    SET NEW.date_created = CURDATE();
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `historico_mp_shop`
--

CREATE TABLE `historico_mp_shop` (
  `id` int(11) NOT NULL,
  `payment_id` varchar(250) NOT NULL,
  `shop_id` int(11) NOT NULL,
  `full` varchar(1) NOT NULL DEFAULT 'F',
  `account_id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `item_id_tibia` int(11) DEFAULT NULL,
  `type` int(11) NOT NULL,
  `quantidade` int(11) NOT NULL,
  `valor` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `date_created` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Triggers `historico_mp_shop`
--
DELIMITER $$
CREATE TRIGGER `set_date_created_historico_mp_shop` BEFORE INSERT ON `historico_mp_shop` FOR EACH ROW BEGIN
    SET NEW.date_created = CURDATE();
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `historico_pagamentos`
--

CREATE TABLE `historico_pagamentos` (
  `id` int(11) NOT NULL,
  `payment_id` varchar(250) DEFAULT NULL,
  `tipo` varchar(255) NOT NULL,
  `account_id` int(11) NOT NULL,
  `player_id` int(11) DEFAULT NULL,
  `currency` varchar(10) DEFAULT NULL,
  `valor` int(11) NOT NULL,
  `id_pacote` int(11) DEFAULT NULL,
  `multiplicador` decimal(5,1) NOT NULL DEFAULT 1.0,
  `promocional_id` int(11) DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `entregue` int(11) NOT NULL DEFAULT 0,
  `qrcode` mediumtext DEFAULT NULL,
  `date_created` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `houses`
--

CREATE TABLE `houses` (
  `id` int(11) NOT NULL,
  `owner` int(11) NOT NULL,
  `paid` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `warnings` int(11) NOT NULL DEFAULT 0,
  `name` varchar(255) NOT NULL,
  `rent` int(11) NOT NULL DEFAULT 0,
  `town_id` int(11) NOT NULL DEFAULT 0,
  `bid` int(11) NOT NULL DEFAULT 0,
  `bid_end` int(11) NOT NULL DEFAULT 0,
  `last_bid` int(11) NOT NULL DEFAULT 0,
  `highest_bidder` int(11) NOT NULL DEFAULT 0,
  `size` int(11) NOT NULL DEFAULT 0,
  `beds` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `houses`
--

INSERT INTO `houses` (`id`, `owner`, `paid`, `warnings`, `name`, `rent`, `town_id`, `bid`, `bid_end`, `last_bid`, `highest_bidder`, `size`, `beds`) VALUES
(1, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 178, 0),
(2, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 207, 0),
(3, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 121, 0),
(4, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 181, 0),
(5, 0, 0, 0, '5', 0, 1, 0, 0, 0, 0, 119, 0),
(6, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 60, 0),
(7, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 71, 0),
(8, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 56, 0),
(9, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 83, 0),
(10, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 77, 0),
(11, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 82, 0),
(12, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 121, 0),
(13, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 121, 0),
(14, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 121, 0),
(15, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 180, 0),
(16, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 121, 0),
(17, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 131, 0),
(18, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 155, 0),
(19, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 200, 0),
(20, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 196, 0),
(21, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 195, 0),
(22, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 145, 0),
(23, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 188, 0),
(24, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 154, 0),
(25, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 59, 0),
(26, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 54, 0),
(27, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 68, 0),
(28, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 88, 0),
(29, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 74, 0),
(30, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 82, 0),
(31, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 81, 0),
(32, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 77, 0),
(33, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 64, 0),
(34, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 89, 0),
(35, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 50, 0),
(36, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 59, 0),
(37, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 454, 0),
(38, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 448, 0),
(39, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 36, 0),
(40, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 30, 0),
(41, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 63, 0),
(42, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 113, 0),
(43, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 56, 0),
(44, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 79, 0),
(45, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 140, 0),
(46, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 66, 0),
(47, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 120, 0),
(48, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 191, 0),
(49, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 30, 0),
(50, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 158, 0),
(51, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 78, 0),
(52, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 22, 0),
(53, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 38, 0),
(54, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 35, 0),
(55, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 27, 0),
(56, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 48, 0),
(57, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 46, 0),
(58, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 40, 0),
(61, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 57, 0),
(62, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 63, 0),
(63, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 264, 0),
(64, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 144, 0),
(65, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 494, 0),
(66, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 63, 0),
(67, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 61, 0),
(68, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 72, 0),
(69, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 69, 0),
(70, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 192, 0),
(71, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 306, 0),
(72, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 238, 0),
(73, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 320, 0),
(74, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 238, 0),
(75, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 223, 0),
(76, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 182, 0),
(77, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 80, 0),
(78, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 39, 0),
(79, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 576, 0),
(80, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 40, 0),
(81, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 295, 0),
(82, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 124, 0),
(83, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 144, 0),
(84, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 108, 0),
(85, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 103, 0),
(86, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 97, 0),
(87, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 106, 0),
(88, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 113, 0),
(89, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 120, 0),
(90, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 217, 0),
(91, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 201, 0),
(92, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 204, 0),
(93, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 87, 0),
(94, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 353, 0),
(95, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 133, 0),
(96, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 146, 0),
(97, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 167, 0),
(98, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 135, 0),
(99, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 163, 0),
(100, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 97, 0),
(101, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 81, 0),
(102, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 178, 0),
(103, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 140, 0),
(104, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 180, 0),
(105, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 173, 0),
(106, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 177, 0),
(107, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 164, 0),
(108, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 56, 0),
(109, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 98, 0),
(110, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 152, 0),
(111, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 224, 0),
(112, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 87, 0),
(113, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 86, 0),
(114, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 99, 0),
(115, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 124, 0),
(116, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 77, 0),
(117, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 102, 0),
(118, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 128, 0),
(119, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 112, 0),
(120, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 96, 0),
(121, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 99, 0),
(122, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 67, 0),
(123, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 40, 0),
(124, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 30, 0),
(125, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 244, 0),
(126, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 173, 0),
(127, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 197, 0),
(128, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 168, 1),
(129, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 399, 1),
(130, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 135, 1),
(131, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 189, 1),
(132, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 243, 1),
(133, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 216, 1),
(134, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 135, 1),
(135, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 112, 1),
(136, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 100, 0),
(137, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 118, 1),
(138, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 81, 0),
(139, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 154, 0),
(140, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 132, 0),
(141, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 166, 0),
(142, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 59, 0),
(143, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 71, 0),
(144, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 73, 0),
(145, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 40, 0),
(146, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 45, 0),
(147, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 56, 0),
(148, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 110, 0),
(149, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 111, 0),
(150, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 126, 0),
(151, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 109, 0),
(152, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 89, 0),
(153, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 55, 0),
(156, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 62, 0),
(157, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 99, 0),
(158, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 89, 0),
(159, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 69, 0),
(160, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 169, 0),
(161, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 38, 0),
(162, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 112, 0),
(163, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 93, 1),
(164, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 72, 1),
(165, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 43, 1),
(166, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 62, 1),
(167, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 48, 1),
(168, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 68, 1),
(169, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 171, 1),
(170, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 156, 1),
(171, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 160, 1),
(172, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 91, 1),
(173, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 117, 1),
(174, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 146, 2),
(175, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 122, 2),
(176, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 253, 2),
(177, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 92, 1),
(178, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 116, 0),
(179, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 153, 0),
(180, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 340, 0),
(181, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 145, 0),
(182, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 103, 0),
(183, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 76, 0),
(184, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 102, 0),
(185, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 75, 0),
(186, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 62, 0),
(187, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 70, 0),
(188, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 145, 0),
(189, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 185, 0),
(191, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 60, 0),
(192, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 73, 0),
(193, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 53, 0),
(194, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 61, 0),
(195, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 71, 0),
(196, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 55, 0),
(197, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 143, 0),
(198, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 168, 0),
(199, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 78, 0),
(200, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 63, 0),
(201, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 27, 0),
(202, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 54, 0),
(203, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 80, 0),
(204, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 145, 0),
(205, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 32, 0),
(206, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 279, 0),
(207, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 52, 0),
(208, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 52, 0),
(209, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 366, 0),
(210, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 403, 0),
(211, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 402, 0),
(212, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 61, 0),
(213, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 224, 0),
(214, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 18, 0),
(215, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 18, 0),
(216, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 84, 0),
(217, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 113, 0),
(218, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 326, 0),
(219, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 160, 0),
(220, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 267, 0),
(221, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 275, 0),
(222, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 33, 0),
(223, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 45, 0),
(224, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 143, 0),
(225, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 234, 0),
(226, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 132, 0),
(227, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 115, 0),
(228, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 259, 0),
(229, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 169, 0),
(230, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 70, 0),
(231, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 60, 0),
(232, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 132, 0),
(233, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 157, 0),
(234, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 215, 0),
(235, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 228, 0),
(236, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 120, 0),
(237, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 49, 0),
(238, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 49, 0),
(239, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 180, 0),
(240, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 165, 0),
(241, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 433, 0),
(242, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 311, 0),
(243, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 411, 0),
(244, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 278, 0),
(245, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 70, 0),
(246, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 54, 0),
(247, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 36, 0),
(248, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 36, 0),
(249, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 121, 0),
(251, 0, 0, 0, 'House #2', 0, 3, 0, 0, 0, 0, 56, 0),
(252, 0, 0, 0, 'House #3', 0, 3, 0, 0, 0, 0, 61, 0),
(253, 0, 0, 0, 'Ceu House #1', 0, 17, 0, 0, 0, 0, 70, 0),
(254, 0, 0, 0, 'Ceu House #2', 0, 17, 0, 0, 0, 0, 72, 0),
(255, 0, 0, 0, 'Ceu House #3', 0, 17, 0, 0, 0, 0, 192, 0),
(256, 0, 0, 0, 'Ceu House #4', 0, 17, 0, 0, 0, 0, 192, 0),
(257, 0, 0, 0, 'Ceu House #5', 0, 17, 0, 0, 0, 0, 208, 0),
(258, 0, 0, 0, 'Ceu House #6', 0, 17, 0, 0, 0, 0, 144, 0),
(259, 0, 0, 0, 'Ceu House #7', 0, 17, 0, 0, 0, 0, 141, 0),
(260, 0, 0, 0, 'Ceu House #8', 0, 17, 0, 0, 0, 0, 141, 0),
(261, 0, 0, 0, 'Ceu House #9', 0, 17, 0, 0, 0, 0, 105, 0),
(262, 0, 0, 0, 'Ceu House #10', 0, 17, 0, 0, 0, 0, 147, 0),
(263, 0, 0, 0, 'Ceu House #11', 0, 17, 0, 0, 0, 0, 181, 0),
(264, 0, 0, 0, 'Ceu House #12', 0, 17, 0, 0, 0, 0, 116, 0),
(265, 0, 0, 0, 'Ceu House #13', 0, 17, 0, 0, 0, 0, 82, 0),
(266, 0, 0, 0, 'Ceu House #14', 0, 17, 0, 0, 0, 0, 163, 0),
(267, 0, 0, 0, 'Ceu House #15', 0, 17, 0, 0, 0, 0, 190, 0),
(268, 0, 0, 0, 'Ceu House #16', 0, 17, 0, 0, 0, 0, 77, 0);

-- --------------------------------------------------------

--
-- Table structure for table `house_lists`
--

CREATE TABLE `house_lists` (
  `house_id` int(11) NOT NULL,
  `listid` int(11) NOT NULL,
  `list` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ip_bans`
--

CREATE TABLE `ip_bans` (
  `ip` int(10) UNSIGNED NOT NULL,
  `reason` varchar(255) NOT NULL,
  `banned_at` bigint(20) NOT NULL,
  `expires_at` bigint(20) NOT NULL,
  `banned_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `market_history`
--

CREATE TABLE `market_history` (
  `id` int(10) UNSIGNED NOT NULL,
  `player_id` int(11) NOT NULL,
  `sale` tinyint(1) NOT NULL DEFAULT 0,
  `itemtype` int(10) UNSIGNED NOT NULL,
  `amount` smallint(5) UNSIGNED NOT NULL,
  `price` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `expires_at` bigint(20) UNSIGNED NOT NULL,
  `inserted` bigint(20) UNSIGNED NOT NULL,
  `state` tinyint(3) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `market_offers`
--

CREATE TABLE `market_offers` (
  `id` int(10) UNSIGNED NOT NULL,
  `player_id` int(11) NOT NULL,
  `itemtype` int(10) UNSIGNED NOT NULL,
  `amount` smallint(5) UNSIGNED NOT NULL,
  `created` bigint(20) UNSIGNED NOT NULL,
  `anonymous` tinyint(1) NOT NULL DEFAULT 0,
  `price` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `currency` int(11) NOT NULL DEFAULT 0,
  `attributes` blob DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `market_offers`
--

INSERT INTO `market_offers` (`id`, `player_id`, `itemtype`, `amount`, `created`, `anonymous`, `price`, `currency`, `attributes`) VALUES
(1, 1, 27645, 1, 1724899863588, 0, 1, 0, 0x24e403),
(2, 1, 27645, 1, 1724899897767, 1, 1, 1, 0x24e303),
(3, 1, 27645, 1, 1724900054374, 0, 1, 1, 0x24e203),
(4, 1, 26677, 1, 1731803185508, 1, 100, 1, 0x2e13000000000000000b0069736265696e6775736564020000000000000000030063643402df77d66600000000030063643602df77d66600000000030063643702df77d6660000000008006c6f6f6b747970650209000000000000000d00706f6b656d61786865616c746802f33a000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000900706f6b656c6576656c0201000000000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d6660000000004006364313202de77d66600000000030063643502e077d666000000000a00706f6b656865616c746802f33a00000000000004006364313102e177d666000000000e00706f6b65657870657269656e63650200000000000000000900706f6b65626f6f7374020000000000000000),
(5, 1, 26672, 1, 1725331406656, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(6, 1, 26672, 1, 1725331406592, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(7, 1, 26672, 1, 1725331406592, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(8, 1, 26672, 1, 1725331406592, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(9, 1, 26672, 1, 1725114715406, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(10, 1, 26672, 1, 1725114715406, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(11, 1, 26672, 1, 1725114715420, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(12, 1, 26672, 1, 1725114715420, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(13, 1, 26672, 1, 1725331406592, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(14, 1, 26672, 1, 1725331406592, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(15, 1, 26672, 1, 1725114714934, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(16, 1, 26672, 1, 1725114714934, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(17, 1, 26672, 1, 1725331407804, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(18, 1, 26672, 1, 1725331407855, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(19, 1, 26672, 1, 1725331407855, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(20, 1, 26672, 1, 1725114715420, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(21, 1, 26672, 1, 1725331406592, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(22, 1, 26672, 1, 1725331407424, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(23, 1, 26672, 1, 1725331407379, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(24, 1, 26672, 1, 1725331407004, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(25, 1, 26672, 1, 1725331408051, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(26, 1, 26672, 1, 1725331407379, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(27, 1, 26672, 1, 1725331407379, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(28, 1, 26672, 1, 1725331407379, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(29, 1, 26672, 1, 1725331407379, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(30, 1, 26672, 1, 1725331407379, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(31, 1, 26672, 1, 1725331407055, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(32, 1, 26672, 1, 1725331407054, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(33, 1, 26672, 1, 1725331407054, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(34, 1, 26672, 1, 1725331407054, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(35, 1, 26672, 1, 1725331407054, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(36, 1, 26672, 1, 1725331407054, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(37, 1, 26672, 1, 1725114726036, 1, 100000, 0, 0x2e15000000000000000b0069736265696e6775736564020100000000000000040063643130020000000000000000030063643902000000000000000003006364380200000000000000000300636437020000000000000000030063643602000000000000000003006364340200000000000000000300636433020000000000000000030063643202000000000000000003006364310200000000000000000800706f6b656e616d6501090043686172697a6172640900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ca0200000000000008006c6f6f6b747970650206000000000000000900706f6b656c6576656c0201000000000000000400636431310200000000000000000a00706f6b656865616c746803295c8fc223b8374104006364313202000000000000000003006364350200000000000000000b00706f6b656c6f6f6b646972020200000000000000),
(38, 1, 26672, 1, 1725114726036, 1, 100000, 0, 0x2e15000000000000000b0069736265696e6775736564020100000000000000040063643130020000000000000000030063643902000000000000000003006364380200000000000000000300636437020000000000000000030063643602000000000000000003006364340200000000000000000300636433020000000000000000030063643202000000000000000003006364310200000000000000000800706f6b656e616d6501090043686172697a6172640900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ca0200000000000008006c6f6f6b747970650206000000000000000900706f6b656c6576656c0201000000000000000400636431310200000000000000000a00706f6b656865616c746803295c8fc223b8374104006364313202000000000000000003006364350200000000000000000b00706f6b656c6f6f6b646972020200000000000000),
(39, 1, 26672, 1, 1725114725996, 1, 100000, 0, 0x2e15000000000000000b0069736265696e6775736564020100000000000000040063643130020000000000000000030063643902000000000000000003006364380200000000000000000300636437020000000000000000030063643602000000000000000003006364340200000000000000000300636433020000000000000000030063643202000000000000000003006364310200000000000000000800706f6b656e616d6501090043686172697a6172640900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ca0200000000000008006c6f6f6b747970650206000000000000000900706f6b656c6576656c0201000000000000000400636431310200000000000000000a00706f6b656865616c746803295c8fc223b8374104006364313202000000000000000003006364350200000000000000000b00706f6b656c6f6f6b646972020200000000000000),
(40, 1, 26672, 1, 1725114725996, 1, 100000, 0, 0x2e15000000000000000b0069736265696e6775736564020100000000000000040063643130020000000000000000030063643902000000000000000003006364380200000000000000000300636437020000000000000000030063643602000000000000000003006364340200000000000000000300636433020000000000000000030063643202000000000000000003006364310200000000000000000800706f6b656e616d6501090043686172697a6172640900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ca0200000000000008006c6f6f6b747970650206000000000000000900706f6b656c6576656c0201000000000000000400636431310200000000000000000a00706f6b656865616c746803295c8fc223b8374104006364313202000000000000000003006364350200000000000000000b00706f6b656c6f6f6b646972020200000000000000),
(41, 1, 26672, 1, 1725114725995, 1, 100000, 0, 0x2e15000000000000000b0069736265696e6775736564020100000000000000040063643130020000000000000000030063643902000000000000000003006364380200000000000000000300636437020000000000000000030063643602000000000000000003006364340200000000000000000300636433020000000000000000030063643202000000000000000003006364310200000000000000000800706f6b656e616d6501090043686172697a6172640900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ca0200000000000008006c6f6f6b747970650206000000000000000900706f6b656c6576656c0201000000000000000400636431310200000000000000000a00706f6b656865616c746803295c8fc223b8374104006364313202000000000000000003006364350200000000000000000b00706f6b656c6f6f6b646972020200000000000000),
(42, 1, 26672, 1, 1725114725995, 1, 100000, 0, 0x2e15000000000000000b0069736265696e6775736564020100000000000000040063643130020000000000000000030063643902000000000000000003006364380200000000000000000300636437020000000000000000030063643602000000000000000003006364340200000000000000000300636433020000000000000000030063643202000000000000000003006364310200000000000000000800706f6b656e616d6501090043686172697a6172640900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ca0200000000000008006c6f6f6b747970650206000000000000000900706f6b656c6576656c0201000000000000000400636431310200000000000000000a00706f6b656865616c746803295c8fc223b8374104006364313202000000000000000003006364350200000000000000000b00706f6b656c6f6f6b646972020200000000000000),
(43, 1, 26672, 1, 1725114725995, 1, 100000, 0, 0x2e15000000000000000b0069736265696e6775736564020100000000000000040063643130020000000000000000030063643902000000000000000003006364380200000000000000000300636437020000000000000000030063643602000000000000000003006364340200000000000000000300636433020000000000000000030063643202000000000000000003006364310200000000000000000800706f6b656e616d6501090043686172697a6172640900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ca0200000000000008006c6f6f6b747970650206000000000000000900706f6b656c6576656c0201000000000000000400636431310200000000000000000a00706f6b656865616c746803295c8fc223b8374104006364313202000000000000000003006364350200000000000000000b00706f6b656c6f6f6b646972020200000000000000),
(44, 1, 26672, 1, 1725331408125, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(45, 1, 26672, 1, 1725331408125, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(46, 1, 26672, 1, 1725331408051, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(47, 1, 26672, 1, 1725114725995, 1, 100000, 0, 0x2e15000000000000000b0069736265696e6775736564020100000000000000040063643130020000000000000000030063643902000000000000000003006364380200000000000000000300636437020000000000000000030063643602000000000000000003006364340200000000000000000300636433020000000000000000030063643202000000000000000003006364310200000000000000000800706f6b656e616d6501090043686172697a6172640900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ca0200000000000008006c6f6f6b747970650206000000000000000900706f6b656c6576656c0201000000000000000400636431310200000000000000000a00706f6b656865616c746803295c8fc223b8374104006364313202000000000000000003006364350200000000000000000b00706f6b656c6f6f6b646972020200000000000000),
(48, 1, 26672, 1, 1725114715693, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(49, 1, 26672, 1, 1725114715676, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(50, 1, 26672, 1, 1725114715676, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(51, 1, 26672, 1, 1725114715676, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(52, 1, 26672, 1, 1725114715676, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(53, 1, 26672, 1, 1725114715676, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(54, 1, 26672, 1, 1725114715676, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(55, 1, 26672, 1, 1725114715628, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(56, 1, 26672, 1, 1725114715628, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(57, 1, 26672, 1, 1725114715628, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(58, 1, 26672, 1, 1725114715628, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(59, 1, 26672, 1, 1725114715628, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(60, 1, 26672, 1, 1725331407003, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(61, 1, 26672, 1, 1725331407003, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(62, 1, 26672, 1, 1725331407003, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(63, 1, 26672, 1, 1725331407003, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(64, 1, 26672, 1, 1725331406974, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(65, 1, 26672, 1, 1725331406945, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(66, 1, 26672, 1, 1725331406945, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(67, 1, 26672, 1, 1725331406945, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(68, 1, 26672, 1, 1725114715077, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(69, 1, 26672, 1, 1725114714934, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(70, 1, 26672, 1, 1725114714964, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(71, 1, 26672, 1, 1725114714969, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(72, 1, 26672, 1, 1725114714970, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(73, 1, 26672, 1, 1725114715077, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(74, 1, 26672, 1, 1725114715077, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(75, 1, 26672, 1, 1725114715077, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(76, 1, 26672, 1, 1725114715077, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(77, 1, 26672, 1, 1725114715420, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(78, 1, 26672, 1, 1725114715312, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(79, 1, 26672, 1, 1725114715312, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(80, 1, 26672, 1, 1725114715312, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(81, 1, 26672, 1, 1725114715312, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(82, 1, 26672, 1, 1725114715312, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(83, 1, 26672, 1, 1725114715312, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(84, 1, 26672, 1, 1725114715348, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000);
INSERT INTO `market_offers` (`id`, `player_id`, `itemtype`, `amount`, `created`, `anonymous`, `price`, `currency`, `attributes`) VALUES
(85, 1, 26672, 1, 1725114715348, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(86, 1, 26672, 1, 1725114715348, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(87, 1, 26672, 1, 1725114715348, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(88, 1, 26672, 1, 1725114715348, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(89, 1, 26672, 1, 1725114715348, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(90, 1, 26672, 1, 1725114715406, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(91, 1, 26672, 1, 1725114715406, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(92, 1, 26672, 1, 1725331406945, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(93, 1, 26672, 1, 1725331406944, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(94, 1, 26672, 1, 1725331406668, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(95, 1, 26672, 1, 1725331406668, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(96, 1, 26672, 1, 1725331406668, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(97, 1, 26672, 1, 1725114715420, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(98, 1, 26672, 1, 1725114715558, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(99, 1, 26672, 1, 1725114715558, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(100, 1, 26672, 1, 1725114715558, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(101, 1, 26672, 1, 1725114715558, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(102, 1, 26672, 1, 1725114715558, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(103, 1, 26672, 1, 1725114715558, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(104, 1, 26672, 1, 1725114715589, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(105, 1, 26672, 1, 1725114715593, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(106, 1, 26672, 1, 1725331407855, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(107, 1, 26672, 1, 1725331407855, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(108, 1, 26672, 1, 1725331407855, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(109, 1, 26672, 1, 1725331408125, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(110, 1, 26672, 1, 1725331408125, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(111, 1, 26672, 1, 1725114726036, 1, 100000, 0, 0x2e15000000000000000b0069736265696e6775736564020100000000000000040063643130020000000000000000030063643902000000000000000003006364380200000000000000000300636437020000000000000000030063643602000000000000000003006364340200000000000000000300636433020000000000000000030063643202000000000000000003006364310200000000000000000800706f6b656e616d6501090043686172697a6172640900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ca0200000000000008006c6f6f6b747970650206000000000000000900706f6b656c6576656c0201000000000000000400636431310200000000000000000a00706f6b656865616c746803295c8fc223b8374104006364313202000000000000000003006364350200000000000000000b00706f6b656c6f6f6b646972020200000000000000),
(112, 1, 26672, 1, 1725114726036, 1, 100000, 0, 0x2e15000000000000000b0069736265696e6775736564020100000000000000040063643130020000000000000000030063643902000000000000000003006364380200000000000000000300636437020000000000000000030063643602000000000000000003006364340200000000000000000300636433020000000000000000030063643202000000000000000003006364310200000000000000000800706f6b656e616d6501090043686172697a6172640900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ca0200000000000008006c6f6f6b747970650206000000000000000900706f6b656c6576656c0201000000000000000400636431310200000000000000000a00706f6b656865616c746803295c8fc223b8374104006364313202000000000000000003006364350200000000000000000b00706f6b656c6f6f6b646972020200000000000000),
(113, 1, 26672, 1, 1725114726066, 1, 100000, 0, 0x2e15000000000000000b0069736265696e6775736564020100000000000000040063643130020000000000000000030063643902000000000000000003006364380200000000000000000300636437020000000000000000030063643602000000000000000003006364340200000000000000000300636433020000000000000000030063643202000000000000000003006364310200000000000000000800706f6b656e616d6501090043686172697a6172640900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ca0200000000000008006c6f6f6b747970650206000000000000000900706f6b656c6576656c0201000000000000000400636431310200000000000000000a00706f6b656865616c746803295c8fc223b8374104006364313202000000000000000003006364350200000000000000000b00706f6b656c6f6f6b646972020200000000000000),
(114, 1, 26672, 1, 1725331408124, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(115, 1, 26672, 1, 1725331408124, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(116, 1, 26672, 1, 1725331408083, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(117, 1, 26672, 1, 1725331408051, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(118, 1, 26672, 1, 1725331408051, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(119, 1, 26672, 1, 1725114715077, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(120, 1, 26672, 1, 1725331407855, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(121, 1, 26672, 1, 1725331408051, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(122, 1, 26672, 1, 1725331408051, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(123, 1, 26677, 1, 1732591858295, 0, 1, 0, 0x2d83383967000000002e06000000000000000b0069736265696e67757365640200000000000000000b00706f6b656c6f6f6b6469720202000000000000000a00706f6b656865616c74680220680000000000000800706f6b656e616d65010d007368696e79206e6f63746f776c0900706f6b65626f6f737402000000000000000008006c6f6f6b7479706502d403000000000000),
(124, 1, 26677, 1, 1732591801143, 1, 10000, 1, 0x2e0f000000000000000b0069736265696e67757365640200000000000000000b00706f6b656c6f6f6b6469720203000000000000000a00706f6b656865616c7468021f740000000000000300636434022f404567000000000300636435023440456700000000030063643202ff3f456700000000030063643102f13f4567000000000300636439020e40456700000000030063643302db3f456700000000030063643602f33f45670000000008006c6f6f6b747970650283000000000000000900706f6b65626f6f73740200000000000000000800706f6b656e616d650106006c617072617303006364380208404567000000000300636437020a40456700000000),
(125, 1, 26672, 1, 1725114726036, 1, 100000, 0, 0x2e15000000000000000b0069736265696e6775736564020100000000000000040063643130020000000000000000030063643902000000000000000003006364380200000000000000000300636437020000000000000000030063643602000000000000000003006364340200000000000000000300636433020000000000000000030063643202000000000000000003006364310200000000000000000800706f6b656e616d6501090043686172697a6172640900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ca0200000000000008006c6f6f6b747970650206000000000000000900706f6b656c6576656c0201000000000000000400636431310200000000000000000a00706f6b656865616c746803295c8fc223b8374104006364313202000000000000000003006364350200000000000000000b00706f6b656c6f6f6b646972020200000000000000),
(126, 1, 26672, 1, 1725114726036, 1, 100000, 0, 0x2e15000000000000000b0069736265696e6775736564020100000000000000040063643130020000000000000000030063643902000000000000000003006364380200000000000000000300636437020000000000000000030063643602000000000000000003006364340200000000000000000300636433020000000000000000030063643202000000000000000003006364310200000000000000000800706f6b656e616d6501090043686172697a6172640900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ca0200000000000008006c6f6f6b747970650206000000000000000900706f6b656c6576656c0201000000000000000400636431310200000000000000000a00706f6b656865616c746803295c8fc223b8374104006364313202000000000000000003006364350200000000000000000b00706f6b656c6f6f6b646972020200000000000000),
(127, 1, 26672, 1, 1725114726036, 1, 100000, 0, 0x2e15000000000000000b0069736265696e6775736564020100000000000000040063643130020000000000000000030063643902000000000000000003006364380200000000000000000300636437020000000000000000030063643602000000000000000003006364340200000000000000000300636433020000000000000000030063643202000000000000000003006364310200000000000000000800706f6b656e616d6501090043686172697a6172640900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ca0200000000000008006c6f6f6b747970650206000000000000000900706f6b656c6576656c0201000000000000000400636431310200000000000000000a00706f6b656865616c746803295c8fc223b8374104006364313202000000000000000003006364350200000000000000000b00706f6b656c6f6f6b646972020200000000000000),
(128, 1, 26672, 1, 1725114715628, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(129, 1, 26672, 1, 1725114715593, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(130, 1, 26672, 1, 1725114715593, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(131, 1, 26672, 1, 1725114715593, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(132, 1, 26672, 1, 1725114726101, 1, 100000, 0, 0x2e15000000000000000b0069736265696e6775736564020100000000000000040063643130020000000000000000030063643902000000000000000003006364380200000000000000000300636437020000000000000000030063643602000000000000000003006364340200000000000000000300636433020000000000000000030063643202000000000000000003006364310200000000000000000800706f6b656e616d6501090043686172697a6172640900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ca0200000000000008006c6f6f6b747970650206000000000000000900706f6b656c6576656c0201000000000000000400636431310200000000000000000a00706f6b656865616c746803295c8fc223b8374104006364313202000000000000000003006364350200000000000000000b00706f6b656c6f6f6b646972020200000000000000),
(133, 1, 26672, 1, 1725114726101, 1, 100000, 0, 0x2e15000000000000000b0069736265696e6775736564020100000000000000040063643130020000000000000000030063643902000000000000000003006364380200000000000000000300636437020000000000000000030063643602000000000000000003006364340200000000000000000300636433020000000000000000030063643202000000000000000003006364310200000000000000000800706f6b656e616d6501090043686172697a6172640900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ca0200000000000008006c6f6f6b747970650206000000000000000900706f6b656c6576656c0201000000000000000400636431310200000000000000000a00706f6b656865616c746803295c8fc223b8374104006364313202000000000000000003006364350200000000000000000b00706f6b656c6f6f6b646972020200000000000000),
(134, 1, 26672, 1, 1725114715593, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(135, 1, 26672, 1, 1725114715593, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(136, 1, 26672, 1, 1725114715041, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(137, 1, 26672, 1, 1725114715041, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(138, 1, 26672, 1, 1725114715041, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(139, 1, 26672, 1, 1725114715041, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(140, 1, 26672, 1, 1725114715005, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(141, 1, 26672, 1, 1725114715005, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(142, 1, 26672, 1, 1725114715406, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(143, 1, 26672, 1, 1725114715406, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(144, 1, 26672, 1, 1725331406945, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(145, 1, 26672, 1, 1725331407425, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(146, 1, 26672, 1, 1725331407425, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(147, 1, 26672, 1, 1725331407425, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(148, 1, 26672, 1, 1725331407425, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(149, 1, 26672, 1, 1725331407589, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(150, 1, 26672, 1, 1725331407589, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(151, 1, 26672, 1, 1725331407590, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(152, 1, 26672, 1, 1725331407590, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(153, 1, 26672, 1, 1725331407590, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(154, 1, 26672, 1, 1725331407590, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(155, 1, 26672, 1, 1725331407635, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(156, 1, 26672, 1, 1725331407635, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(157, 1, 26672, 1, 1725331407635, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(158, 1, 26672, 1, 1725331407635, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(159, 1, 26672, 1, 1725331407635, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(160, 1, 26672, 1, 1725331406656, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(161, 1, 26672, 1, 1725114715041, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(162, 1, 26672, 1, 1725331407004, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(163, 1, 26672, 1, 1725331407635, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(164, 1, 26672, 1, 1725331407635, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000);
INSERT INTO `market_offers` (`id`, `player_id`, `itemtype`, `amount`, `created`, `anonymous`, `price`, `currency`, `attributes`) VALUES
(165, 1, 26672, 1, 1725331407804, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(166, 1, 26672, 1, 1725331407804, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(167, 1, 26672, 1, 1725331407804, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(168, 1, 26672, 1, 1725331407804, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(169, 1, 26672, 1, 1725331407804, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(170, 1, 26672, 1, 1725331407855, 1, 100000, 0, 0x2e1300000000000000030063643202e377d6660000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(171, 1, 26672, 1, 1725114715005, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(172, 1, 26672, 1, 1725114715005, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(173, 1, 26672, 1, 1725114714970, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(174, 1, 26672, 1, 1725114714970, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(175, 1, 26672, 1, 1725114714970, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(176, 1, 26672, 1, 1725114714970, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(177, 1, 27645, 1, 1724900092334, 0, 1, 0, 0x24e103),
(178, 1, 26672, 1, 1725114715005, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(179, 1, 26672, 1, 1725114715005, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(180, 1, 26672, 1, 1725114714934, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(181, 1, 26672, 1, 1725114714934, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(182, 1, 26672, 1, 1725114714934, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(183, 1, 26672, 1, 1725114726135, 1, 100000, 0, 0x2e15000000000000000b0069736265696e6775736564020100000000000000040063643130020000000000000000030063643902000000000000000003006364380200000000000000000300636437020000000000000000030063643602000000000000000003006364340200000000000000000300636433020000000000000000030063643202000000000000000003006364310200000000000000000800706f6b656e616d6501090043686172697a6172640900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ca0200000000000008006c6f6f6b747970650206000000000000000900706f6b656c6576656c0201000000000000000400636431310200000000000000000a00706f6b656865616c746803295c8fc223b8374104006364313202000000000000000003006364350200000000000000000b00706f6b656c6f6f6b646972020200000000000000),
(184, 1, 26672, 1, 1725114726135, 1, 100000, 0, 0x2e15000000000000000b0069736265696e6775736564020100000000000000040063643130020000000000000000030063643902000000000000000003006364380200000000000000000300636437020000000000000000030063643602000000000000000003006364340200000000000000000300636433020000000000000000030063643202000000000000000003006364310200000000000000000800706f6b656e616d6501090043686172697a6172640900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ca0200000000000008006c6f6f6b747970650206000000000000000900706f6b656c6576656c0201000000000000000400636431310200000000000000000a00706f6b656865616c746803295c8fc223b8374104006364313202000000000000000003006364350200000000000000000b00706f6b656c6f6f6b646972020200000000000000),
(185, 1, 26672, 1, 1725114726135, 1, 100000, 0, 0x2e15000000000000000b0069736265696e6775736564020100000000000000040063643130020000000000000000030063643902000000000000000003006364380200000000000000000300636437020000000000000000030063643602000000000000000003006364340200000000000000000300636433020000000000000000030063643202000000000000000003006364310200000000000000000800706f6b656e616d6501090043686172697a6172640900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ca0200000000000008006c6f6f6b747970650206000000000000000900706f6b656c6576656c0201000000000000000400636431310200000000000000000a00706f6b656865616c746803295c8fc223b8374104006364313202000000000000000003006364350200000000000000000b00706f6b656c6f6f6b646972020200000000000000),
(186, 1, 26672, 1, 1725114726101, 1, 100000, 0, 0x2e15000000000000000b0069736265696e6775736564020100000000000000040063643130020000000000000000030063643902000000000000000003006364380200000000000000000300636437020000000000000000030063643602000000000000000003006364340200000000000000000300636433020000000000000000030063643202000000000000000003006364310200000000000000000800706f6b656e616d6501090043686172697a6172640900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ca0200000000000008006c6f6f6b747970650206000000000000000900706f6b656c6576656c0201000000000000000400636431310200000000000000000a00706f6b656865616c746803295c8fc223b8374104006364313202000000000000000003006364350200000000000000000b00706f6b656c6f6f6b646972020200000000000000),
(187, 1, 26672, 1, 1725114726101, 1, 100000, 0, 0x2e15000000000000000b0069736265696e6775736564020100000000000000040063643130020000000000000000030063643902000000000000000003006364380200000000000000000300636437020000000000000000030063643602000000000000000003006364340200000000000000000300636433020000000000000000030063643202000000000000000003006364310200000000000000000800706f6b656e616d6501090043686172697a6172640900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ca0200000000000008006c6f6f6b747970650206000000000000000900706f6b656c6576656c0201000000000000000400636431310200000000000000000a00706f6b656865616c746803295c8fc223b8374104006364313202000000000000000003006364350200000000000000000b00706f6b656c6f6f6b646972020200000000000000),
(188, 1, 26672, 1, 1725114715041, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(189, 1, 26672, 1, 1725114726135, 1, 100000, 0, 0x2e15000000000000000b0069736265696e6775736564020100000000000000040063643130020000000000000000030063643902000000000000000003006364380200000000000000000300636437020000000000000000030063643602000000000000000003006364340200000000000000000300636433020000000000000000030063643202000000000000000003006364310200000000000000000800706f6b656e616d6501090043686172697a6172640900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ca0200000000000008006c6f6f6b747970650206000000000000000900706f6b656c6576656c0201000000000000000400636431310200000000000000000a00706f6b656865616c746803295c8fc223b8374104006364313202000000000000000003006364350200000000000000000b00706f6b656c6f6f6b646972020200000000000000),
(190, 1, 26677, 1, 1730341837072, 0, 110, 1, 0x2e0c000000000000000800706f6b656e616d65010500706172617303006364350217c00a67000000000900706f6b65626f6f73740200000000000000000a00706f6b656865616c7468037c14ae47e15a8d400300636433021ec00a670000000008006c6f6f6b74797065022e000000000000000300636434022fc00a67000000000300636436024bc00a670000000003006364310218c00a670000000003006364320241c00a67000000000b00706f6b656c6f6f6b6469720202000000000000000b0069736265696e6775736564020000000000000000),
(191, 1, 27635, 1, 1730341826998, 1, 100000, 0, 0x240100),
(192, 1, 26677, 1, 1730341806322, 1, 100000, 0, 0x2e11000000000000000b00706f6b656c6f6f6b646972020300000000000000030063643202288f2167000000000b0069736265696e67757365640200000000000000000900706f6b65626f6f7374020000000000000000030063643402428f2167000000000300636436024e8f216700000000030063643702378f2167000000000a00706f6b656865616c7468031f85eb51f8e7e24004006364313102438f216700000000030063643302478f2167000000000800706f6b656e616d6501090063686172697a6152440300636435025e8f216700000000030063643802358f21670000000004006364313002518f2167000000000300636431021e8f216700000000030063643902518f21670000000008006c6f6f6b74797065020600000000000000),
(193, 1, 26672, 1, 1725114726066, 1, 100000, 0, 0x2e15000000000000000b0069736265696e6775736564020100000000000000040063643130020000000000000000030063643902000000000000000003006364380200000000000000000300636437020000000000000000030063643602000000000000000003006364340200000000000000000300636433020000000000000000030063643202000000000000000003006364310200000000000000000800706f6b656e616d6501090043686172697a6172640900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ca0200000000000008006c6f6f6b747970650206000000000000000900706f6b656c6576656c0201000000000000000400636431310200000000000000000a00706f6b656865616c746803295c8fc223b8374104006364313202000000000000000003006364350200000000000000000b00706f6b656c6f6f6b646972020200000000000000),
(194, 1, 26672, 1, 1725114715342, 1, 100000, 0, 0x2e09000000000000000b0069736265696e67757365640201000000000000000b00706f6b656c6f6f6b6469720202000000000000000800706f6b656e616d65010d005368696e79206e6f63746f776c0a00706f6b656865616c746802ec130000000000000900706f6b656c6576656c0201000000000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ec1300000000000008006c6f6f6b7479706502d403000000000000),
(195, 1, 26672, 1, 1725114726135, 1, 100000, 0, 0x2e15000000000000000b0069736265696e6775736564020100000000000000040063643130020000000000000000030063643902000000000000000003006364380200000000000000000300636437020000000000000000030063643602000000000000000003006364340200000000000000000300636433020000000000000000030063643202000000000000000003006364310200000000000000000800706f6b656e616d6501090043686172697a6172640900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ca0200000000000008006c6f6f6b747970650206000000000000000900706f6b656c6576656c0201000000000000000400636431310200000000000000000a00706f6b656865616c746803295c8fc223b8374104006364313202000000000000000003006364350200000000000000000b00706f6b656c6f6f6b646972020200000000000000),
(196, 1, 26672, 1, 1725114726066, 1, 100000, 0, 0x2e15000000000000000b0069736265696e6775736564020100000000000000040063643130020000000000000000030063643902000000000000000003006364380200000000000000000300636437020000000000000000030063643602000000000000000003006364340200000000000000000300636433020000000000000000030063643202000000000000000003006364310200000000000000000800706f6b656e616d6501090043686172697a6172640900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ca0200000000000008006c6f6f6b747970650206000000000000000900706f6b656c6576656c0201000000000000000400636431310200000000000000000a00706f6b656865616c746803295c8fc223b8374104006364313202000000000000000003006364350200000000000000000b00706f6b656c6f6f6b646972020200000000000000),
(197, 1, 26672, 1, 1725114726066, 1, 100000, 0, 0x2e15000000000000000b0069736265696e6775736564020100000000000000040063643130020000000000000000030063643902000000000000000003006364380200000000000000000300636437020000000000000000030063643602000000000000000003006364340200000000000000000300636433020000000000000000030063643202000000000000000003006364310200000000000000000800706f6b656e616d6501090043686172697a6172640900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802ca0200000000000008006c6f6f6b747970650206000000000000000900706f6b656c6576656c0201000000000000000400636431310200000000000000000a00706f6b656865616c746803295c8fc223b8374104006364313202000000000000000003006364350200000000000000000b00706f6b656c6f6f6b646972020200000000000000),
(198, 1, 26672, 1, 1725331406668, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(199, 1, 26672, 1, 1725331406668, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(200, 1, 26672, 1, 1725331406657, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(201, 1, 26672, 1, 1725331406657, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000),
(202, 1, 26672, 1, 1725331406657, 1, 100000, 0, 0x2e120000000000000004006364313002e177d66600000000030063643902e177d66600000000030063643302e077d666000000000800706f6b656e616d65010900426c6173746f697365030063643802df77d666000000000900706f6b656c6576656c02010000000000000004006364313102e177d666000000000a00706f6b656865616c746802f33a000000000000030063643502e077d6660000000004006364313202de77d666000000000900706f6b65626f6f73740200000000000000000e00706f6b65657870657269656e63650200000000000000000d00706f6b656d61786865616c746802f33a00000000000008006c6f6f6b747970650209000000000000000b0069736265696e6775736564020100000000000000030063643702df77d66600000000030063643602df77d66600000000030063643402df77d66600000000);

-- --------------------------------------------------------

--
-- Table structure for table `noticias`
--

CREATE TABLE `noticias` (
  `id` int(11) NOT NULL,
  `created_admin_id` int(11) NOT NULL,
  `update_admin_id` int(11) DEFAULT NULL,
  `titulo` text NOT NULL,
  `texto` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `date_created` datetime DEFAULT current_timestamp(),
  `date_update` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pacotes`
--

CREATE TABLE `pacotes` (
  `id` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `id_item_pacote` int(11) NOT NULL,
  `cor_pacote` varchar(100) NOT NULL,
  `caminho_tag` varchar(255) DEFAULT NULL,
  `caminho_itens` longtext DEFAULT NULL,
  `created_admin_id` int(11) NOT NULL,
  `update_admin_id` int(11) DEFAULT NULL,
  `valor_cortado` decimal(10,2) NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'F',
  `date_created` timestamp NOT NULL DEFAULT current_timestamp(),
  `date_update` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `cod` varchar(1000) NOT NULL,
  `method` varchar(200) NOT NULL,
  `status` varchar(255) NOT NULL,
  `price` float(9,2) DEFAULT NULL,
  `delivery` int(11) NOT NULL DEFAULT 0 COMMENT '0,1',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `mercadopago` int(11) NOT NULL DEFAULT 0,
  `bank_transfer` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pix_payment`
--

CREATE TABLE `pix_payment` (
  `player_id` int(11) NOT NULL,
  `loc_id` int(11) NOT NULL,
  `txid` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `price` varchar(255) NOT NULL,
  `paid` tinyint(1) NOT NULL DEFAULT 0,
  `creation` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

CREATE TABLE `players` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `group_id` int(11) NOT NULL DEFAULT 1,
  `account_id` int(11) NOT NULL DEFAULT 0,
  `level` int(11) NOT NULL DEFAULT 500,
  `vocation` int(11) NOT NULL DEFAULT 0,
  `image` text DEFAULT NULL,
  `health` int(11) NOT NULL DEFAULT 150,
  `healthmax` int(11) NOT NULL DEFAULT 150,
  `experience` bigint(20) NOT NULL DEFAULT 13752,
  `lookbody` int(11) NOT NULL DEFAULT 0,
  `lookfeet` int(11) NOT NULL DEFAULT 0,
  `lookhead` int(11) NOT NULL DEFAULT 0,
  `looklegs` int(11) NOT NULL DEFAULT 0,
  `looktype` int(11) NOT NULL DEFAULT 510,
  `lookaddons` int(11) NOT NULL DEFAULT 0,
  `maglevel` int(11) NOT NULL DEFAULT 0,
  `mana` int(11) NOT NULL DEFAULT 0,
  `manamax` int(11) NOT NULL DEFAULT 0,
  `manaspent` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `soul` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `town_id` int(11) NOT NULL DEFAULT 13,
  `posx` int(11) NOT NULL DEFAULT 54,
  `posy` int(11) NOT NULL DEFAULT 449,
  `posz` int(11) NOT NULL DEFAULT 5,
  `conditions` blob DEFAULT NULL,
  `cap` int(11) NOT NULL DEFAULT 6,
  `sex` int(11) NOT NULL DEFAULT 0,
  `lastlogin` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `lastip` varchar(255) DEFAULT NULL,
  `save` tinyint(1) NOT NULL DEFAULT 1,
  `skull` tinyint(1) NOT NULL DEFAULT 0,
  `skulltime` int(11) NOT NULL DEFAULT 0,
  `lastlogout` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `blessings` tinyint(4) NOT NULL DEFAULT 0,
  `onlinetime` int(11) DEFAULT 0,
  `deletion` bigint(20) NOT NULL DEFAULT 0,
  `balance` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `offlinetraining_time` smallint(5) UNSIGNED NOT NULL DEFAULT 43200,
  `offlinetraining_skill` int(11) NOT NULL DEFAULT -1,
  `stamina` smallint(5) UNSIGNED NOT NULL DEFAULT 2520,
  `skill_fist` int(10) UNSIGNED NOT NULL DEFAULT 10,
  `skill_fist_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_club` int(10) UNSIGNED NOT NULL DEFAULT 10,
  `skill_club_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_sword` int(10) UNSIGNED NOT NULL DEFAULT 10,
  `skill_sword_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_axe` int(10) UNSIGNED NOT NULL DEFAULT 10,
  `skill_axe_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_dist` int(10) UNSIGNED NOT NULL DEFAULT 10,
  `skill_dist_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_shielding` int(10) UNSIGNED NOT NULL DEFAULT 10,
  `skill_shielding_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `skill_fishing` int(10) UNSIGNED NOT NULL DEFAULT 10,
  `skill_fishing_tries` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `pokemons` varchar(2000) NOT NULL DEFAULT '',
  `creationdate` int(11) DEFAULT NULL,
  `lookaura` int(11) NOT NULL DEFAULT 0,
  `lookwings` int(11) NOT NULL DEFAULT 0,
  `lookshader` int(11) NOT NULL DEFAULT 0,
  `diamond` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `players`
--

INSERT INTO `players` (`id`, `name`, `group_id`, `account_id`, `level`, `vocation`, `image`, `health`, `healthmax`, `experience`, `lookbody`, `lookfeet`, `lookhead`, `looklegs`, `looktype`, `lookaddons`, `maglevel`, `mana`, `manamax`, `manaspent`, `soul`, `town_id`, `posx`, `posy`, `posz`, `conditions`, `cap`, `sex`, `lastlogin`, `lastip`, `save`, `skull`, `skulltime`, `lastlogout`, `blessings`, `onlinetime`, `deletion`, `balance`, `offlinetraining_time`, `offlinetraining_skill`, `stamina`, `skill_fist`, `skill_fist_tries`, `skill_club`, `skill_club_tries`, `skill_sword`, `skill_sword_tries`, `skill_axe`, `skill_axe_tries`, `skill_dist`, `skill_dist_tries`, `skill_shielding`, `skill_shielding_tries`, `skill_fishing`, `skill_fishing_tries`, `pokemons`, `creationdate`, `lookaura`, `lookwings`, `lookshader`, `diamond`) VALUES
(1, 'Icaro', 6, 1, 207, 0, NULL, 1145, 1145, 143680170, 114, 29, 114, 62, 3104, 3, 0, 1000, 1000, 0, 37, 1, 2673, 2312, 7, '', 0, 0, 1737560688, '16777343', 1, 0, 0, 1737566599, 0, 905929, 0, 0, 43200, -1, 2506, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, '[{\"name\":\"lapras\",\"boost\":0,\"level\":0,\"looktype\":{\"lookType\":131}},{\"name\":\"noctowl\",\"boost\":0,\"level\":0,\"looktype\":{\"lookType\":815}},{\"name\":\"shiny noctowl\",\"boost\":0,\"level\":0,\"looktype\":{\"lookType\":980}},{\"name\":\"squirtle\",\"boost\":0,\"level\":0,\"looktype\":{\"lookType\":7}},{\"name\":\"scyther\",\"boost\":0,\"level\":0,\"looktype\":{\"lookType\":123}},{\"name\":\"sandslash\",\"boost\":0,\"level\":0,\"looktype\":{\"lookType\":28}}]', 1724893120, 0, 0, 53, 0),
(5, 'Asdasddas', 1, 1, 8, 0, NULL, 150, 150, 4798, 95, 19, 93, 31, 3137, 0, 0, 0, 0, 0, 0, 1, 2589, 2361, 7, 0x010040000002ffffffff0368b901001a001b000000001c00150100000014c0d40100fe, 0, 1, 1737509493, '16777343', 1, 0, 0, 1737509512, 0, 656, 0, 0, 43200, -1, 2518, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, '[{\"looktype\":{\"lookType\":4},\"level\":0,\"name\":\"charmander\",\"boost\":0},{\"looktype\":{\"lookType\":7},\"level\":0,\"name\":\"squirtle\",\"boost\":0},{\"looktype\":{\"lookType\":233},\"level\":0,\"name\":\"pikachu\",\"boost\":0}]', 1734287881, 0, 0, 0, 0),
(6, 'Dasdasdsa', 1, 1, 8, 0, NULL, 150, 150, 4200, 60, 99, 120, 84, 2832, 0, 0, 0, 0, 0, 0, 1, 2589, 2356, 7, 0x010004000002ffffffff03f0d200001a001b000000001c00fe, 0, 1, 1737509006, '16777343', 1, 0, 0, 1737509014, 0, 174, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, '[]', 1737507596, 0, 0, 0, 0),
(7, 'Dudinha', 1, 1, 59, 0, NULL, 405, 405, 3141040, 31, 42, 120, 37, 3116, 0, 0, 255, 255, 0, 3, 13, 2257, 2711, 6, '', 0, 0, 1737520053, '16777343', 1, 0, 0, 1737520614, 0, 1933, 0, 0, 43200, -1, 2517, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, '[{\"boost\":0,\"name\":\"charmander\",\"level\":0,\"looktype\":{\"lookType\":4}},{\"boost\":0,\"name\":\"bulbasaur\",\"level\":0,\"looktype\":{\"lookType\":1}},{\"boost\":0,\"name\":\"pikachu\",\"level\":0,\"looktype\":{\"lookType\":233}},{\"boost\":0,\"name\":\"squirtle\",\"level\":0,\"looktype\":{\"lookType\":7}}]', 1737509029, 0, 0, 0, 0),
(8, 'Eduarda', 1, 3, 222, 0, NULL, 1220, 1220, 179805966, 44, 44, 72, 101, 3116, 0, 0, 1070, 1070, 0, 5, 13, 2265, 2698, 6, '', 0, 0, 1737556738, '16777343', 1, 0, 0, 1737556797, 0, 6200, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, '[{\"looktype\":{\"lookType\":233},\"boost\":0,\"name\":\"pikachu\",\"level\":0},{\"looktype\":{\"lookType\":18},\"boost\":0,\"name\":\"pidgeot\",\"level\":0},{\"looktype\":{\"lookType\":350},\"boost\":0,\"name\":\"shiny ditto\",\"level\":0},{\"looktype\":{\"lookType\":214},\"boost\":0,\"name\":\"shiny charizard\",\"level\":0},{\"looktype\":{\"lookType\":132},\"boost\":0,\"name\":\"ditto\",\"level\":0},{\"looktype\":{\"lookType\":972},\"boost\":0,\"name\":\"shiny typhlosion\",\"level\":0}]', 1737509408, 0, 0, 0, 0),
(9, 'Rei Dos Alpes', 1, 3, 8, 0, NULL, 150, 150, 4200, 38, 35, 80, 115, 2831, 0, 0, 0, 0, 0, 0, 13, 2258, 2710, 6, '', 0, 1, 1737554614, '16777343', 1, 0, 0, 1737554689, 0, 75, 0, 0, 43200, -1, 2520, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, 10, 0, '[]', 1737554608, 0, 0, 0, 0);

--
-- Triggers `players`
--
DELIMITER $$
CREATE TRIGGER `ondelete_players` BEFORE DELETE ON `players` FOR EACH ROW BEGIN
    UPDATE `houses` SET `owner` = 0 WHERE `owner` = OLD.`id`;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `players_online`
--

CREATE TABLE `players_online` (
  `player_id` int(11) NOT NULL
) ENGINE=MEMORY DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `players_stringstorages`
--

CREATE TABLE `players_stringstorages` (
  `player_id` int(11) NOT NULL,
  `key` int(11) NOT NULL,
  `value` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `players_stringstorages`
--

INSERT INTO `players_stringstorages` (`player_id`, `key`, `value`) VALUES
(1, 750000, 'crafts');

-- --------------------------------------------------------

--
-- Table structure for table `player_deaths`
--

CREATE TABLE `player_deaths` (
  `player_id` int(11) NOT NULL,
  `time` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `level` int(11) NOT NULL DEFAULT 1,
  `killed_by` varchar(255) NOT NULL,
  `is_player` tinyint(1) NOT NULL DEFAULT 1,
  `mostdamage_by` varchar(100) NOT NULL,
  `mostdamage_is_player` tinyint(1) NOT NULL DEFAULT 0,
  `unjustified` tinyint(1) NOT NULL DEFAULT 0,
  `mostdamage_unjustified` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_depotitems`
--

CREATE TABLE `player_depotitems` (
  `player_id` int(11) NOT NULL,
  `sid` int(11) NOT NULL COMMENT 'any given range eg 0-100 will be reserved for depot lockers and all > 100 will be then normal items inside depots',
  `pid` int(11) NOT NULL DEFAULT 0,
  `itemtype` mediumint(9) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT 0,
  `attributes` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_inboxitems`
--

CREATE TABLE `player_inboxitems` (
  `player_id` int(11) NOT NULL,
  `sid` int(11) NOT NULL,
  `pid` int(11) NOT NULL DEFAULT 0,
  `itemtype` mediumint(9) NOT NULL,
  `count` smallint(6) NOT NULL DEFAULT 0,
  `attributes` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_items`
--

CREATE TABLE `player_items` (
  `player_id` int(11) NOT NULL DEFAULT 0,
  `pid` int(11) NOT NULL DEFAULT 0,
  `sid` int(11) NOT NULL DEFAULT 0,
  `itemtype` mediumint(9) NOT NULL DEFAULT 0,
  `count` smallint(6) NOT NULL DEFAULT 0,
  `attributes` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `player_items`
--

INSERT INTO `player_items` (`player_id`, `pid`, `sid`, `itemtype`, `count`, `attributes`) VALUES
(6, 2, 101, 2580, 1, ''),
(6, 3, 102, 1987, 1, ''),
(6, 7, 103, 2382, 1, ''),
(6, 8, 104, 7731, 1, ''),
(6, 9, 105, 2270, 1, ''),
(5, 2, 101, 2580, 1, ''),
(5, 3, 102, 1987, 1, 0x2300),
(5, 7, 103, 2382, 1, ''),
(5, 8, 104, 7731, 1, ''),
(5, 9, 105, 2270, 1, ''),
(5, 102, 106, 26677, 1, 0x2e03000000000000000900706f6b65626f6f73740200000000000000000800706f6b656e616d6501070070696b616368750a00706f6b656865616c74680250c3000000000000),
(5, 102, 107, 26677, 1, 0x2e0b000000000000000900706f6b65626f6f73740200000000000000000800706f6b656e616d650108007371756972746c6508006c6f6f6b74797065020700000000000000030063643202a045906700000000030063643102a3459067000000000300636433028b4a906700000000030063643602b84a9067000000000300636437029a4a9067000000000a00706f6b656865616c7468028f010000000000000b00706f6b656c6f6f6b6469720202000000000000000b0069736265696e6775736564020000000000000000),
(5, 102, 108, 26677, 1, 0x2e03000000000000000900706f6b65626f6f73740200000000000000000800706f6b656e616d65010a00636861726d616e6465720a00706f6b656865616c746802d011000000000000),
(5, 102, 109, 26738, 1, ''),
(7, 2, 101, 2580, 1, ''),
(7, 3, 102, 1987, 1, 0x2300),
(7, 7, 103, 2382, 1, ''),
(7, 8, 104, 7731, 1, ''),
(7, 9, 105, 2270, 1, ''),
(7, 102, 106, 26688, 9999, 0x240f27),
(7, 102, 107, 26683, 10000, 0x241027),
(7, 102, 108, 27645, 9994, 0x240a27),
(7, 102, 109, 26677, 1, 0x2e12000000000000000800706f6b656e616d650108007371756972746c650900706f6b65626f6f737402000000000000000008006c6f6f6b7479706502070000000000000003006364310200000000000000000300636432020000000000000000030063643302000000000000000003006364340200000000000000000300636435020000000000000000030063643702000000000000000003006364380200000000000000000300636439020000000000000000040063643130020000000000000000040063643131020000000000000000040063643132020000000000000000030063643602cf729067000000000a00706f6b656865616c746802e5010000000000000b00706f6b656c6f6f6b6469720203000000000000000b0069736265696e6775736564020000000000000000),
(7, 102, 110, 26677, 1, 0x2e120000000000000003006364370200000000000000000800706f6b656e616d6501070070696b616368750900706f6b65626f6f73740200000000000000000300636433020000000000000000030063643502000000000000000003006364360200000000000000000300636438020000000000000000030063643902000000000000000004006364313002000000000000000004006364313102000000000000000004006364313202000000000000000008006c6f6f6b7479706502e900000000000000030063643202d872906700000000030063643102f672906700000000030063643402e2729067000000000a00706f6b656865616c7468022e190000000000000b00706f6b656c6f6f6b6469720201000000000000000b0069736265696e6775736564020000000000000000),
(7, 102, 111, 26672, 1, 0x2e12000000000000000900706f6b65626f6f73740200000000000000000800706f6b656e616d6501090062756c62617361757208006c6f6f6b747970650201000000000000000b00706f6b656c6f6f6b6469720202000000000000000300636431020000000000000000030063643202000000000000000003006364330200000000000000000300636434020000000000000000030063643502000000000000000003006364360200000000000000000300636437020000000000000000030063643802000000000000000003006364390200000000000000000400636431300200000000000000000400636431310200000000000000000400636431320200000000000000000a00706f6b656865616c74680200000000000000000b0069736265696e6775736564020000000000000000),
(7, 102, 112, 26677, 1, 0x2e12000000000000000800706f6b656e616d65010a00636861726d616e6465720900706f6b65626f6f737402000000000000000008006c6f6f6b747970650204000000000000000b00706f6b656c6f6f6b6469720203000000000000000b0069736265696e67757365640200000000000000000a00706f6b656865616c7468037c14ae47e15a8d40030063643102000000000000000003006364320200000000000000000300636433020000000000000000030063643402000000000000000003006364350200000000000000000300636436020000000000000000030063643702000000000000000003006364380200000000000000000300636439020000000000000000040063643130020000000000000000040063643131020000000000000000040063643132020000000000000000),
(9, 2, 101, 2580, 1, ''),
(9, 3, 102, 1987, 1, 0x2300),
(9, 7, 103, 2382, 1, ''),
(9, 8, 104, 7731, 1, ''),
(9, 9, 105, 2270, 1, ''),
(8, 2, 101, 2580, 1, ''),
(8, 3, 102, 1987, 1, 0x2300),
(8, 7, 103, 2382, 1, ''),
(8, 8, 104, 7731, 1, ''),
(8, 9, 105, 2270, 1, ''),
(8, 102, 106, 26677, 1, 0x2e06000000000000000800706f6b656e616d650110007368696e7920747970686c6f73696f6e0900706f6b65626f6f73740200000000000000000b00706f6b656c6f6f6b64697202020000000000000008006c6f6f6b7479706502cc030000000000000a00706f6b656865616c7468027ffb0000000000000b0069736265696e6775736564020000000000000000),
(8, 102, 107, 26677, 1, 0x2e03000000000000000800706f6b656e616d65010500646974746f0900706f6b65626f6f73740200000000000000000a00706f6b656865616c746802d011000000000000),
(8, 102, 108, 26677, 1, 0x2e12000000000000000800706f6b656e616d65010f007368696e792063686172697a6172640900706f6b65626f6f737402000000000000000008006c6f6f6b7479706502d6000000000000000b00706f6b656c6f6f6b6469720203000000000000000b0069736265696e67757365640200000000000000000a00706f6b656865616c7468030ad7a370bd5ce640030063643102000000000000000003006364320200000000000000000300636433020000000000000000030063643402000000000000000003006364350200000000000000000300636436020000000000000000030063643702000000000000000003006364380200000000000000000300636439020000000000000000040063643130020000000000000000040063643131020000000000000000040063643132020000000000000000),
(8, 102, 109, 26677, 1, 0x2e03000000000000000800706f6b656e616d65010b007368696e7920646974746f0900706f6b65626f6f73740200000000000000000a00706f6b656865616c74680250c3000000000000),
(8, 102, 110, 26677, 1, 0x2e11000000000000000900706f6b65626f6f73740200000000000000000800706f6b656e616d6501070070696467656f7408006c6f6f6b747970650212000000000000000b0069736265696e67757365640200000000000000000a00706f6b656865616c746802ba15000000000000030063643102000000000000000003006364320200000000000000000300636433020000000000000000030063643402000000000000000003006364350200000000000000000300636436020000000000000000030063643702000000000000000003006364380200000000000000000300636439020000000000000000040063643130020000000000000000040063643131020000000000000000040063643132020000000000000000),
(8, 102, 111, 27645, 92, 0x245c00),
(8, 102, 112, 2160, 9998, 0x240e27),
(8, 102, 113, 27645, 9997, 0x240d27),
(8, 102, 114, 26672, 1, 0x2e12000000000000000800706f6b656e616d6501070070696b616368750900706f6b65626f6f73740200000000000000000b00706f6b656c6f6f6b64697202020000000000000008006c6f6f6b7479706502e9000000000000000300636431020000000000000000030063643202000000000000000003006364330200000000000000000300636434020000000000000000030063643502000000000000000003006364360200000000000000000300636437020000000000000000030063643802000000000000000003006364390200000000000000000400636431300200000000000000000400636431310200000000000000000400636431320200000000000000000a00706f6b656865616c74680200000000000000000b0069736265696e6775736564020000000000000000),
(1, 2, 101, 2580, 1, ''),
(1, 3, 102, 1987, 1, 0x2300),
(1, 7, 103, 2382, 1, ''),
(1, 8, 104, 7731, 1, ''),
(1, 9, 105, 2270, 1, ''),
(1, 102, 106, 26672, 1, 0x2e0a000000000000000300636437024c139167000000000900706f6b65626f6f73740200000000000000000800706f6b656e616d6501090073616e64736c617368030063643802401391670000000008006c6f6f6b74797065021c0000000000000003006364360244139167000000000300636435023b1391670000000003006364340241139167000000000a00706f6b656865616c74680200000000000000000b0069736265696e6775736564020000000000000000),
(1, 102, 107, 26672, 1, 0x2e12000000000000000900706f6b65626f6f73740200000000000000000800706f6b656e616d650107007363797468657208006c6f6f6b74797065027b000000000000000300636431020000000000000000030063643202000000000000000003006364330200000000000000000300636434020000000000000000030063643502000000000000000003006364370200000000000000000400636431310200000000000000000400636431320200000000000000000b00706f6b656c6f6f6b6469720203000000000000000400636431300212139167000000000300636436020713916700000000030063643802e7129167000000000300636439021d139167000000000a00706f6b656865616c74680200000000000000000b0069736265696e6775736564020000000000000000),
(1, 102, 108, 2160, 10000, 0x241027),
(1, 102, 109, 27645, 9986, 0x240227),
(1, 102, 110, 26677, 1, 0x2e12000000000000000900706f6b65626f6f73740200000000000000000800706f6b656e616d650108007371756972746c6508006c6f6f6b747970650207000000000000000300636431020000000000000000030063643202000000000000000003006364330200000000000000000300636434020000000000000000030063643502000000000000000003006364360200000000000000000300636437020000000000000000030063643802000000000000000003006364390200000000000000000400636431300200000000000000000400636431310200000000000000000400636431320200000000000000000a00706f6b656865616c746802d7010000000000000b00706f6b656c6f6f6b6469720203000000000000000b0069736265696e6775736564020000000000000000),
(1, 102, 111, 26677, 1, 0x2df4079167000000002e06000000000000000b00706f6b656c6f6f6b64697202000000000000000008006c6f6f6b7479706502d4030000000000000900706f6b65626f6f73740200000000000000000800706f6b656e616d65010d007368696e79206e6f63746f776c0a00706f6b656865616c746802bc640000000000000b0069736265696e6775736564020000000000000000),
(1, 102, 112, 26677, 1, 0x2e120000000000000008006c6f6f6b74797065022f030000000000000900706f6b65626f6f73740200000000000000000800706f6b656e616d650107006e6f63746f776c0300636431020000000000000000030063643202000000000000000003006364330200000000000000000300636434020000000000000000030063643502000000000000000003006364360200000000000000000300636437020000000000000000030063643802000000000000000003006364390200000000000000000400636431300200000000000000000400636431310200000000000000000400636431320200000000000000000a00706f6b656865616c746802f6390000000000000b00706f6b656c6f6f6b6469720203000000000000000b0069736265696e6775736564020000000000000000),
(1, 102, 113, 40609, 1, 0x240100),
(1, 102, 114, 26677, 1, 0x2e0f00000000000000030063643102201e5f67000000000300636439022eea9067000000000300636433023d1e5f67000000000900706f6b65626f6f73740200000000000000000800706f6b656e616d650106006c617072617303006364370237ea90670000000008006c6f6f6b747970650283000000000000000300636438022fea90670000000003006364360229ea90670000000003006364350225ea90670000000003006364340222ea90670000000003006364320238ea9067000000000a00706f6b656865616c746802b66b0000000000000b00706f6b656c6f6f6b6469720200000000000000000b0069736265696e6775736564020000000000000000),
(1, 102, 115, 26738, 1, '');

-- --------------------------------------------------------

--
-- Table structure for table `player_namelocks`
--

CREATE TABLE `player_namelocks` (
  `player_id` int(11) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `namelocked_at` bigint(20) NOT NULL,
  `namelocked_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_seller`
--

CREATE TABLE `player_seller` (
  `id` int(11) NOT NULL,
  `account_seller` int(11) NOT NULL,
  `char_id` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `pix_blocked` varchar(1) NOT NULL DEFAULT 'F',
  `date_pix_blocked` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_spells`
--

CREATE TABLE `player_spells` (
  `player_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `player_storage`
--

CREATE TABLE `player_storage` (
  `player_id` int(11) NOT NULL DEFAULT 0,
  `key` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `value` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `player_storage`
--

INSERT INTO `player_storage` (`player_id`, `key`, `value`) VALUES
(1, 5009, 1),
(1, 10002, 1),
(1, 71344, 48),
(1, 72703, 26),
(1, 395000, 1),
(1, 604000, 0),
(1, 764003, 1),
(1, 764007, 4),
(1, 870006, 1),
(1, 870010, 1),
(1, 870016, 1),
(1, 870022, 1),
(1, 870045, 1),
(1, 870065, 1),
(1, 870069, 1),
(1, 870094, 1),
(1, 870114, 1),
(1, 870131, 1),
(1, 870649, 1),
(1, 1980000, 1732591862),
(5, 5009, 1),
(5, 71344, 0),
(5, 72703, 14),
(5, 604000, 0),
(6, 5009, 1),
(6, 71344, 0),
(6, 72703, 1),
(6, 604000, 0),
(7, 5009, 1),
(7, 71344, 0),
(7, 72703, 29),
(7, 604000, 0),
(8, 5009, 1),
(8, 71344, 1),
(8, 72703, 42),
(8, 604000, 0),
(9, 5009, 1),
(9, 71344, 0),
(9, 72703, 1),
(9, 604000, 0);

-- --------------------------------------------------------

--
-- Table structure for table `pokeball_stats`
--

CREATE TABLE `pokeball_stats` (
  `player_id` int(11) NOT NULL,
  `pokemonName` varchar(255) NOT NULL,
  `poke` int(11) NOT NULL DEFAULT 0,
  `great` int(11) NOT NULL DEFAULT 0,
  `ultra` int(11) NOT NULL DEFAULT 0,
  `saffari` int(11) NOT NULL DEFAULT 0,
  `master` int(11) NOT NULL DEFAULT 0,
  `moon` int(11) NOT NULL DEFAULT 0,
  `tinker` int(11) NOT NULL DEFAULT 0,
  `sora` int(11) NOT NULL DEFAULT 0,
  `dusk` int(11) NOT NULL DEFAULT 0,
  `yume` int(11) NOT NULL DEFAULT 0,
  `tale` int(11) NOT NULL DEFAULT 0,
  `net` int(11) NOT NULL DEFAULT 0,
  `janguru` int(11) NOT NULL DEFAULT 0,
  `magu` int(11) NOT NULL DEFAULT 0,
  `fast` int(11) NOT NULL DEFAULT 0,
  `heavy` int(11) NOT NULL DEFAULT 0,
  `premier` int(11) NOT NULL DEFAULT 0,
  `delta` int(11) NOT NULL DEFAULT 0,
  `esferadepal` int(11) NOT NULL DEFAULT 0,
  `esferamega` int(11) NOT NULL DEFAULT 0,
  `esferagiga` int(11) NOT NULL DEFAULT 0,
  `esferatera` int(11) NOT NULL DEFAULT 0,
  `esferaultra` int(11) NOT NULL DEFAULT 0,
  `esferalendaria` int(11) NOT NULL DEFAULT 0,
  `super` int(11) NOT NULL DEFAULT 0,
  `especial` int(11) NOT NULL DEFAULT 0,
  `divine` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pokemon_points`
--

CREATE TABLE `pokemon_points` (
  `player_id` int(11) NOT NULL,
  `pokemonName` varchar(255) NOT NULL,
  `pontos` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `push`
--

CREATE TABLE `push` (
  `id` int(11) NOT NULL,
  `create_admin_id` int(11) NOT NULL,
  `titulo` varchar(100) NOT NULL,
  `mensagem` varchar(200) NOT NULL,
  `date_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `redeem_codes`
--

CREATE TABLE `redeem_codes` (
  `id` int(11) NOT NULL,
  `serial` text DEFAULT NULL,
  `type` text DEFAULT NULL,
  `player_id` int(11) DEFAULT NULL,
  `max_uses` int(11) DEFAULT NULL,
  `total_used` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `server_config`
--

CREATE TABLE `server_config` (
  `config` varchar(50) NOT NULL,
  `value` varchar(256) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `server_config`
--

INSERT INTO `server_config` (`config`, `value`) VALUES
('motd_hash', 'a6afd77936a557689fc7902fc7a227c78df6fb55'),
('motd_num', '2'),
('players_record', '2');

-- --------------------------------------------------------

--
-- Table structure for table `shop_historico`
--

CREATE TABLE `shop_historico` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `shop_item_id` int(11) NOT NULL,
  `item_id_tibia` int(11) DEFAULT NULL,
  `type` int(11) NOT NULL,
  `quantidade` int(11) NOT NULL,
  `full` varchar(1) NOT NULL DEFAULT 'F',
  `desconto` int(11) DEFAULT NULL,
  `valor` int(11) NOT NULL,
  `entregue` int(11) NOT NULL DEFAULT 0,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shop_history`
--

CREATE TABLE `shop_history` (
  `id` int(11) NOT NULL,
  `account` int(11) NOT NULL,
  `player` int(11) NOT NULL,
  `date` datetime NOT NULL,
  `title` varchar(100) NOT NULL,
  `price` int(11) NOT NULL,
  `count` int(11) NOT NULL DEFAULT 0,
  `target` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shop_image`
--

CREATE TABLE `shop_image` (
  `id` int(11) NOT NULL,
  `shop_item_id` int(11) NOT NULL,
  `tipo` int(11) NOT NULL DEFAULT 1,
  `caminho` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shop_item`
--

CREATE TABLE `shop_item` (
  `id` int(11) NOT NULL,
  `item_id_tibia` int(11) DEFAULT NULL,
  `created_admin_id` int(11) DEFAULT NULL,
  `update_admin_id` int(11) DEFAULT NULL,
  `categoria_id` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `quantidade` int(11) NOT NULL,
  `maximo` int(11) DEFAULT NULL,
  `descricao` text NOT NULL,
  `desconto` int(11) DEFAULT NULL,
  `valor` int(11) NOT NULL,
  `status` varchar(1) NOT NULL DEFAULT 'T',
  `date_created` datetime DEFAULT NULL,
  `date_update` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `suporte`
--

CREATE TABLE `suporte` (
  `id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `update_admin_id` int(11) DEFAULT NULL,
  `image1` text DEFAULT NULL,
  `image2` text DEFAULT NULL,
  `titulo` varchar(50) NOT NULL,
  `descricao` varchar(200) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `date_created` datetime NOT NULL,
  `date_update` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `suporte_respostas`
--

CREATE TABLE `suporte_respostas` (
  `id` int(11) NOT NULL,
  `suporte_id` int(11) NOT NULL,
  `account_id` int(11) DEFAULT NULL,
  `admin_id` int(11) DEFAULT NULL,
  `resposta` varchar(200) NOT NULL,
  `date_created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tile_store`
--

CREATE TABLE `tile_store` (
  `house_id` int(11) NOT NULL,
  `data` longblob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tokenvalidat`
--

CREATE TABLE `tokenvalidat` (
  `id` int(11) NOT NULL,
  `id_account` int(11) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `expired` varchar(1) DEFAULT 'F',
  `validation_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `verificar_callback`
--

CREATE TABLE `verificar_callback` (
  `id` int(11) NOT NULL,
  `passou` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `account_bans`
--
ALTER TABLE `account_bans`
  ADD PRIMARY KEY (`account_id`),
  ADD KEY `banned_by` (`banned_by`);

--
-- Indexes for table `account_ban_history`
--
ALTER TABLE `account_ban_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `banned_by` (`banned_by`);

--
-- Indexes for table `account_viplist`
--
ALTER TABLE `account_viplist`
  ADD UNIQUE KEY `account_player_index` (`account_id`,`player_id`),
  ADD KEY `player_id` (`player_id`);

--
-- Indexes for table `blocked_ips`
--
ALTER TABLE `blocked_ips`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bonificacoes`
--
ALTER TABLE `bonificacoes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `boss_ranking`
--
ALTER TABLE `boss_ranking`
  ADD PRIMARY KEY (`classificacao`,`player`);

--
-- Indexes for table `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `config_categoria_wiki`
--
ALTER TABLE `config_categoria_wiki`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `config_inicio`
--
ALTER TABLE `config_inicio`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `config_permission_bazar`
--
ALTER TABLE `config_permission_bazar`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `config_permission_bonificacao`
--
ALTER TABLE `config_permission_bonificacao`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `config_permission_inicio`
--
ALTER TABLE `config_permission_inicio`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `config_permission_noticia`
--
ALTER TABLE `config_permission_noticia`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `config_permission_pacotes`
--
ALTER TABLE `config_permission_pacotes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `config_permission_promocional`
--
ALTER TABLE `config_permission_promocional`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `config_permission_push`
--
ALTER TABLE `config_permission_push`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `config_permission_quests`
--
ALTER TABLE `config_permission_quests`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `config_permission_team`
--
ALTER TABLE `config_permission_team`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `config_permission_wiki`
--
ALTER TABLE `config_permission_wiki`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `config_promocional`
--
ALTER TABLE `config_promocional`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `config_quests`
--
ALTER TABLE `config_quests`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `config_team`
--
ALTER TABLE `config_team`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `config_vocations`
--
ALTER TABLE `config_vocations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `config_wiki`
--
ALTER TABLE `config_wiki`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `download`
--
ALTER TABLE `download`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `global_storage`
--
ALTER TABLE `global_storage`
  ADD UNIQUE KEY `key` (`key`);

--
-- Indexes for table `guilds`
--
ALTER TABLE `guilds`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `ownerid` (`ownerid`);

--
-- Indexes for table `guilds_inbox`
--
ALTER TABLE `guilds_inbox`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `guilds_inbox_old`
--
ALTER TABLE `guilds_inbox_old`
  ADD KEY `player_id` (`player_id`);

--
-- Indexes for table `guilds_player_inbox`
--
ALTER TABLE `guilds_player_inbox`
  ADD KEY `player_id` (`player_id`),
  ADD KEY `inbox_id` (`inbox_id`);

--
-- Indexes for table `guildwar_kills`
--
ALTER TABLE `guildwar_kills`
  ADD PRIMARY KEY (`id`),
  ADD KEY `warid` (`warid`);

--
-- Indexes for table `guild_invites`
--
ALTER TABLE `guild_invites`
  ADD PRIMARY KEY (`id`),
  ADD KEY `guild_id` (`guild_id`) USING BTREE,
  ADD KEY `player_id` (`player_id`,`guild_id`) USING BTREE;

--
-- Indexes for table `guild_members`
--
ALTER TABLE `guild_members`
  ADD PRIMARY KEY (`player_id`),
  ADD KEY `guild_id` (`guild_id`),
  ADD KEY `rank_id` (`rank_id`);

--
-- Indexes for table `guild_ranks`
--
ALTER TABLE `guild_ranks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `guild_id` (`guild_id`);

--
-- Indexes for table `guild_wars`
--
ALTER TABLE `guild_wars`
  ADD PRIMARY KEY (`id`),
  ADD KEY `guild1` (`guild1`),
  ADD KEY `guild2` (`guild2`),
  ADD KEY `winner` (`winner`);

--
-- Indexes for table `historico_bazar`
--
ALTER TABLE `historico_bazar`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `historico_mp`
--
ALTER TABLE `historico_mp`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `historico_mp_shop`
--
ALTER TABLE `historico_mp_shop`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `historico_pagamentos`
--
ALTER TABLE `historico_pagamentos`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `houses`
--
ALTER TABLE `houses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `owner` (`owner`),
  ADD KEY `town_id` (`town_id`);

--
-- Indexes for table `house_lists`
--
ALTER TABLE `house_lists`
  ADD KEY `house_id` (`house_id`);

--
-- Indexes for table `ip_bans`
--
ALTER TABLE `ip_bans`
  ADD PRIMARY KEY (`ip`),
  ADD KEY `banned_by` (`banned_by`);

--
-- Indexes for table `market_history`
--
ALTER TABLE `market_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `player_id` (`player_id`,`sale`);

--
-- Indexes for table `market_offers`
--
ALTER TABLE `market_offers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sale` (`itemtype`),
  ADD KEY `created` (`created`),
  ADD KEY `player_id` (`player_id`);

--
-- Indexes for table `noticias`
--
ALTER TABLE `noticias`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pacotes`
--
ALTER TABLE `pacotes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pix_payment`
--
ALTER TABLE `pix_payment`
  ADD UNIQUE KEY `txid` (`txid`),
  ADD UNIQUE KEY `loc` (`loc_id`);

--
-- Indexes for table `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `vocation` (`vocation`);

--
-- Indexes for table `players_online`
--
ALTER TABLE `players_online`
  ADD PRIMARY KEY (`player_id`);

--
-- Indexes for table `players_stringstorages`
--
ALTER TABLE `players_stringstorages`
  ADD PRIMARY KEY (`player_id`,`key`);

--
-- Indexes for table `player_deaths`
--
ALTER TABLE `player_deaths`
  ADD KEY `player_id` (`player_id`),
  ADD KEY `killed_by` (`killed_by`),
  ADD KEY `mostdamage_by` (`mostdamage_by`);

--
-- Indexes for table `player_depotitems`
--
ALTER TABLE `player_depotitems`
  ADD UNIQUE KEY `player_id_2` (`player_id`,`sid`);

--
-- Indexes for table `player_inboxitems`
--
ALTER TABLE `player_inboxitems`
  ADD UNIQUE KEY `player_id_2` (`player_id`,`sid`);

--
-- Indexes for table `player_items`
--
ALTER TABLE `player_items`
  ADD KEY `player_id` (`player_id`),
  ADD KEY `sid` (`sid`);

--
-- Indexes for table `player_namelocks`
--
ALTER TABLE `player_namelocks`
  ADD PRIMARY KEY (`player_id`),
  ADD KEY `namelocked_by` (`namelocked_by`);

--
-- Indexes for table `player_seller`
--
ALTER TABLE `player_seller`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `player_spells`
--
ALTER TABLE `player_spells`
  ADD KEY `player_id` (`player_id`);

--
-- Indexes for table `player_storage`
--
ALTER TABLE `player_storage`
  ADD PRIMARY KEY (`player_id`,`key`);

--
-- Indexes for table `pokeball_stats`
--
ALTER TABLE `pokeball_stats`
  ADD PRIMARY KEY (`player_id`,`pokemonName`);

--
-- Indexes for table `pokemon_points`
--
ALTER TABLE `pokemon_points`
  ADD PRIMARY KEY (`player_id`,`pokemonName`);

--
-- Indexes for table `push`
--
ALTER TABLE `push`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `redeem_codes`
--
ALTER TABLE `redeem_codes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`,`player_id`);

--
-- Indexes for table `server_config`
--
ALTER TABLE `server_config`
  ADD PRIMARY KEY (`config`);

--
-- Indexes for table `shop_historico`
--
ALTER TABLE `shop_historico`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `shop_history`
--
ALTER TABLE `shop_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `account` (`account`),
  ADD KEY `player` (`player`);

--
-- Indexes for table `shop_image`
--
ALTER TABLE `shop_image`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `shop_item`
--
ALTER TABLE `shop_item`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `suporte`
--
ALTER TABLE `suporte`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `suporte_respostas`
--
ALTER TABLE `suporte_respostas`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tile_store`
--
ALTER TABLE `tile_store`
  ADD KEY `house_id` (`house_id`);

--
-- Indexes for table `tokenvalidat`
--
ALTER TABLE `tokenvalidat`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `verificar_callback`
--
ALTER TABLE `verificar_callback`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `account_ban_history`
--
ALTER TABLE `account_ban_history`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `blocked_ips`
--
ALTER TABLE `blocked_ips`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bonificacoes`
--
ALTER TABLE `bonificacoes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `categoria`
--
ALTER TABLE `categoria`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `config_categoria_wiki`
--
ALTER TABLE `config_categoria_wiki`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `config_inicio`
--
ALTER TABLE `config_inicio`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `config_permission_bazar`
--
ALTER TABLE `config_permission_bazar`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `config_permission_bonificacao`
--
ALTER TABLE `config_permission_bonificacao`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `config_permission_inicio`
--
ALTER TABLE `config_permission_inicio`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `config_permission_noticia`
--
ALTER TABLE `config_permission_noticia`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `config_permission_pacotes`
--
ALTER TABLE `config_permission_pacotes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `config_permission_promocional`
--
ALTER TABLE `config_permission_promocional`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `config_permission_push`
--
ALTER TABLE `config_permission_push`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `config_permission_quests`
--
ALTER TABLE `config_permission_quests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `config_permission_team`
--
ALTER TABLE `config_permission_team`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `config_permission_wiki`
--
ALTER TABLE `config_permission_wiki`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `config_promocional`
--
ALTER TABLE `config_promocional`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `config_quests`
--
ALTER TABLE `config_quests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `config_team`
--
ALTER TABLE `config_team`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `config_vocations`
--
ALTER TABLE `config_vocations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `config_wiki`
--
ALTER TABLE `config_wiki`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `download`
--
ALTER TABLE `download`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `guilds`
--
ALTER TABLE `guilds`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `guilds_inbox`
--
ALTER TABLE `guilds_inbox`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `guildwar_kills`
--
ALTER TABLE `guildwar_kills`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `guild_invites`
--
ALTER TABLE `guild_invites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `guild_ranks`
--
ALTER TABLE `guild_ranks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `guild_wars`
--
ALTER TABLE `guild_wars`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `historico_bazar`
--
ALTER TABLE `historico_bazar`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `historico_mp`
--
ALTER TABLE `historico_mp`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `historico_mp_shop`
--
ALTER TABLE `historico_mp_shop`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `historico_pagamentos`
--
ALTER TABLE `historico_pagamentos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `houses`
--
ALTER TABLE `houses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=269;

--
-- AUTO_INCREMENT for table `market_history`
--
ALTER TABLE `market_history`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `market_offers`
--
ALTER TABLE `market_offers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=209;

--
-- AUTO_INCREMENT for table `noticias`
--
ALTER TABLE `noticias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pacotes`
--
ALTER TABLE `pacotes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `players`
--
ALTER TABLE `players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `player_seller`
--
ALTER TABLE `player_seller`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `push`
--
ALTER TABLE `push`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shop_historico`
--
ALTER TABLE `shop_historico`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shop_history`
--
ALTER TABLE `shop_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shop_image`
--
ALTER TABLE `shop_image`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shop_item`
--
ALTER TABLE `shop_item`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `suporte`
--
ALTER TABLE `suporte`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `suporte_respostas`
--
ALTER TABLE `suporte_respostas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tokenvalidat`
--
ALTER TABLE `tokenvalidat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `verificar_callback`
--
ALTER TABLE `verificar_callback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `account_bans`
--
ALTER TABLE `account_bans`
  ADD CONSTRAINT `account_bans_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `account_bans_ibfk_2` FOREIGN KEY (`banned_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `account_ban_history`
--
ALTER TABLE `account_ban_history`
  ADD CONSTRAINT `account_ban_history_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `account_ban_history_ibfk_2` FOREIGN KEY (`banned_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `account_viplist`
--
ALTER TABLE `account_viplist`
  ADD CONSTRAINT `account_viplist_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `account_viplist_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `guilds`
--
ALTER TABLE `guilds`
  ADD CONSTRAINT `guilds_ibfk_1` FOREIGN KEY (`ownerid`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `guilds_inbox_old`
--
ALTER TABLE `guilds_inbox_old`
  ADD CONSTRAINT `guilds_inbox_old_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `guilds_player_inbox`
--
ALTER TABLE `guilds_player_inbox`
  ADD CONSTRAINT `guilds_player_inbox_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `guilds_player_inbox_ibfk_2` FOREIGN KEY (`inbox_id`) REFERENCES `guilds_inbox` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `guildwar_kills`
--
ALTER TABLE `guildwar_kills`
  ADD CONSTRAINT `guildwar_kills_ibfk_1` FOREIGN KEY (`warid`) REFERENCES `guild_wars` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `guild_invites`
--
ALTER TABLE `guild_invites`
  ADD CONSTRAINT `guild_invites_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `guild_members`
--
ALTER TABLE `guild_members`
  ADD CONSTRAINT `guild_members_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `guild_members_ibfk_2` FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `guild_members_ibfk_3` FOREIGN KEY (`rank_id`) REFERENCES `guild_ranks` (`id`);

--
-- Constraints for table `guild_ranks`
--
ALTER TABLE `guild_ranks`
  ADD CONSTRAINT `guild_ranks_ibfk_1` FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `guild_wars`
--
ALTER TABLE `guild_wars`
  ADD CONSTRAINT `guild_wars_ibfk_1` FOREIGN KEY (`guild1`) REFERENCES `guilds` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `guild_wars_ibfk_2` FOREIGN KEY (`guild2`) REFERENCES `guilds` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `guild_wars_ibfk_3` FOREIGN KEY (`winner`) REFERENCES `guilds` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `house_lists`
--
ALTER TABLE `house_lists`
  ADD CONSTRAINT `house_lists_ibfk_1` FOREIGN KEY (`house_id`) REFERENCES `houses` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `ip_bans`
--
ALTER TABLE `ip_bans`
  ADD CONSTRAINT `ip_bans_ibfk_1` FOREIGN KEY (`banned_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `market_history`
--
ALTER TABLE `market_history`
  ADD CONSTRAINT `market_history_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `market_offers`
--
ALTER TABLE `market_offers`
  ADD CONSTRAINT `market_offers_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `players`
--
ALTER TABLE `players`
  ADD CONSTRAINT `players_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `player_deaths`
--
ALTER TABLE `player_deaths`
  ADD CONSTRAINT `player_deaths_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `player_depotitems`
--
ALTER TABLE `player_depotitems`
  ADD CONSTRAINT `player_depotitems_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `player_inboxitems`
--
ALTER TABLE `player_inboxitems`
  ADD CONSTRAINT `player_inboxitems_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `player_items`
--
ALTER TABLE `player_items`
  ADD CONSTRAINT `player_items_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `player_namelocks`
--
ALTER TABLE `player_namelocks`
  ADD CONSTRAINT `player_namelocks_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `player_namelocks_ibfk_2` FOREIGN KEY (`namelocked_by`) REFERENCES `players` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `player_spells`
--
ALTER TABLE `player_spells`
  ADD CONSTRAINT `player_spells_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `player_storage`
--
ALTER TABLE `player_storage`
  ADD CONSTRAINT `player_storage_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `shop_history`
--
ALTER TABLE `shop_history`
  ADD CONSTRAINT `shop_history_ibfk_1` FOREIGN KEY (`account`) REFERENCES `accounts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `shop_history_ibfk_2` FOREIGN KEY (`player`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `tile_store`
--
ALTER TABLE `tile_store`
  ADD CONSTRAINT `tile_store_ibfk_1` FOREIGN KEY (`house_id`) REFERENCES `houses` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

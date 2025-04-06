-- --------------------------------------------------------
-- Hôte:                         127.0.0.1
-- Version du serveur:           8.0.30 - MySQL Community Server - GPL
-- SE du serveur:                Win64
-- HeidiSQL Version:             12.1.0.6537
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Listage de la structure de la base pour mkadia
CREATE DATABASE IF NOT EXISTS `mkadia` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `mkadia`;

-- Listage de la structure de table mkadia. cache
CREATE TABLE IF NOT EXISTS `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Listage des données de la table mkadia.cache : ~0 rows (environ)

-- Listage de la structure de table mkadia. cache_locks
CREATE TABLE IF NOT EXISTS `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Listage des données de la table mkadia.cache_locks : ~0 rows (environ)

-- Listage de la structure de table mkadia. categories
CREATE TABLE IF NOT EXISTS `categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Listage des données de la table mkadia.categories : ~5 rows (environ)
INSERT INTO `categories` (`id`, `name`, `image_url`, `created_at`, `updated_at`) VALUES
	(1, 'All', 'http://10.0.2.2:8000/img/grid.png', '2025-04-04 22:09:03', '2025-04-04 22:09:03'),
	(2, 'Fruit', 'http://10.0.2.2:8000/img/fruits.png', '2025-04-04 22:09:03', '2025-04-04 22:09:03'),
	(3, 'Vegetable', 'http://10.0.2.2:8000/img/vegetable.png', '2025-04-04 22:09:03', '2025-04-04 22:09:03'),
	(4, 'Milk & Egg', 'http://10.0.2.2:8000/img/milkegg.png', '2025-04-04 22:09:03', '2025-04-04 22:09:03'),
	(5, 'Meat', 'http://10.0.2.2:8000/img/meat.png', '2025-04-04 22:09:03', '2025-04-04 22:09:03');

-- Listage de la structure de table mkadia. client_profiles
CREATE TABLE IF NOT EXISTS `client_profiles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `client_profiles_user_id_foreign` (`user_id`),
  CONSTRAINT `client_profiles_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Listage des données de la table mkadia.client_profiles : ~1 rows (environ)
INSERT INTO `client_profiles` (`id`, `user_id`, `email`, `phone`, `address`, `avatar_url`, `created_at`, `updated_at`) VALUES
	(1, 2, 'client@mkadia.com', '0612345678', '123 Avenue Hassan II, Casablanca', NULL, '2025-04-04 22:09:02', '2025-04-04 22:09:02'),
	(2, 6, 'client@example.com', '123456789', '123 Main St', 'https://example.com/avatar.jpg', '2025-04-04 22:09:03', '2025-04-04 22:09:03');

-- Listage de la structure de table mkadia. driver_profiles
CREATE TABLE IF NOT EXISTS `driver_profiles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `latitude` decimal(10,8) NOT NULL,
  `longitude` decimal(11,8) NOT NULL,
  `is_available` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `driver_profiles_user_id_foreign` (`user_id`),
  CONSTRAINT `driver_profiles_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Listage des données de la table mkadia.driver_profiles : ~3 rows (environ)
INSERT INTO `driver_profiles` (`id`, `user_id`, `phone`, `latitude`, `longitude`, `is_available`, `created_at`, `updated_at`) VALUES
	(1, 3, '0698765432', 33.57310000, -7.58980000, 1, '2025-04-04 22:09:03', '2025-04-04 22:09:03'),
	(2, 4, '0612345678', 48.85660000, 2.35220000, 1, '2025-04-04 22:09:03', '2025-04-04 22:09:03'),
	(3, 5, '0698765432', 48.85340000, 2.34880000, 0, '2025-04-04 22:09:03', '2025-04-04 22:09:03');

-- Listage de la structure de table mkadia. failed_jobs
CREATE TABLE IF NOT EXISTS `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Listage des données de la table mkadia.failed_jobs : ~0 rows (environ)

-- Listage de la structure de table mkadia. jobs
CREATE TABLE IF NOT EXISTS `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Listage des données de la table mkadia.jobs : ~0 rows (environ)

-- Listage de la structure de table mkadia. job_batches
CREATE TABLE IF NOT EXISTS `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Listage des données de la table mkadia.job_batches : ~0 rows (environ)

-- Listage de la structure de table mkadia. migrations
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Listage des données de la table mkadia.migrations : ~0 rows (environ)
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
	(1, '0001_01_01_000000_create_users_table', 1),
	(2, '0001_01_01_000001_create_cache_table', 1),
	(3, '0001_01_01_000002_create_jobs_table', 1),
	(4, '2025_03_04_105744_create_categories_table', 1),
	(5, '2025_03_08_155408_create_personal_access_tokens_table', 1),
	(6, '2025_03_11_152327_create_products_table', 1),
	(7, '2025_03_11_152410_create_drivers_table', 1),
	(8, '2025_03_11_152434_create_orders_table', 1),
	(9, '2025_03_21_142800_create_order_items_table', 1),
	(10, '2025_03_21_142850_create_promotions_table', 1),
	(11, '2025_03_21_142928_create_reviews_table', 1),
	(12, '2025_03_21_143006_create_product_reviews_table', 1),
	(13, '2025_04_01_232913_create_clients_table', 1),
	(14, '2025_04_01_233113_create_sessions_table', 1);

-- Listage de la structure de table mkadia. orders
CREATE TABLE IF NOT EXISTS `orders` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `driver_id` bigint unsigned DEFAULT NULL,
  `total_amount` decimal(8,2) NOT NULL,
  `order_date` datetime NOT NULL,
  `delivery_address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `order_status` enum('pending','confirmed','assigned','in_progress','delivered','completed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `estimated_delivery_time` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `orders_user_id_foreign` (`user_id`),
  KEY `orders_driver_id_foreign` (`driver_id`),
  CONSTRAINT `orders_driver_id_foreign` FOREIGN KEY (`driver_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Listage des données de la table mkadia.orders : ~10 rows (environ)
INSERT INTO `orders` (`id`, `user_id`, `driver_id`, `total_amount`, `order_date`, `delivery_address`, `order_status`, `estimated_delivery_time`, `created_at`, `updated_at`) VALUES
	(1, 2, 3, 76.00, '2025-04-04 22:13:24', 'saada n 5 rue 2', 'delivered', NULL, '2025-04-04 22:13:24', '2025-04-05 17:59:32'),
	(2, 2, 4, 43.00, '2025-04-04 23:51:26', 'werty 4567', 'delivered', NULL, '2025-04-04 23:51:26', '2025-04-05 14:40:24'),
	(3, 2, 3, 29.80, '2025-04-05 00:16:00', 'werty 4567', 'delivered', NULL, '2025-04-05 00:16:00', '2025-04-05 17:59:16'),
	(4, 1, 4, 28.18, '2025-04-05 09:25:43', '123 Rue de Test', 'assigned', NULL, '2025-04-05 09:25:43', '2025-04-05 17:20:56'),
	(5, 2, 3, 37.50, '2025-04-05 14:55:12', 'azib darai', 'delivered', NULL, '2025-04-05 14:55:12', '2025-04-05 20:22:35'),
	(6, 2, 3, 19.90, '2025-04-05 18:05:12', 'jihad', 'delivered', NULL, '2025-04-05 18:05:12', '2025-04-06 11:07:51'),
	(7, 2, 3, 56.20, '2025-04-05 20:24:29', 'yarbi', 'delivered', NULL, '2025-04-05 20:24:29', '2025-04-06 11:07:49'),
	(8, 2, 3, 19.90, '2025-04-05 22:12:48', 'rftyu ijkme', 'delivered', NULL, '2025-04-05 22:12:48', '2025-04-06 11:07:47'),
	(9, 2, 3, 19.90, '2025-04-05 23:46:40', 'asdfghjkl;', 'delivered', NULL, '2025-04-05 23:46:40', '2025-04-06 11:07:57'),
	(10, 2, 3, 59.50, '2025-04-06 12:01:28', 'quartier saada rue 5 N 5', 'delivered', NULL, '2025-04-06 11:01:28', '2025-04-06 11:09:48');

-- Listage de la structure de table mkadia. order_items
CREATE TABLE IF NOT EXISTS `order_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint unsigned NOT NULL,
  `product_id` bigint unsigned NOT NULL,
  `price` decimal(8,2) NOT NULL,
  `quantity` int NOT NULL,
  `total` decimal(8,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_items_order_id_foreign` (`order_id`),
  KEY `order_items_product_id_foreign` (`product_id`),
  CONSTRAINT `order_items_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Listage des données de la table mkadia.order_items : ~19 rows (environ)
INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `price`, `quantity`, `total`, `created_at`, `updated_at`) VALUES
	(1, 1, 2, 1.50, 6, 9.00, '2025-04-04 22:13:24', '2025-04-04 22:13:24'),
	(2, 1, 12, 2.00, 6, 12.00, '2025-04-04 22:13:24', '2025-04-04 22:13:24'),
	(3, 1, 17, 7.00, 5, 35.00, '2025-04-04 22:13:24', '2025-04-04 22:13:24'),
	(4, 1, 6, 0.80, 5, 4.00, '2025-04-04 22:13:24', '2025-04-04 22:13:24'),
	(5, 2, 2, 1.50, 6, 9.00, '2025-04-04 23:51:26', '2025-04-04 23:51:26'),
	(6, 2, 17, 7.00, 3, 21.00, '2025-04-04 23:51:26', '2025-04-04 23:51:26'),
	(7, 3, 17, 7.00, 1, 7.00, '2025-04-05 00:16:00', '2025-04-05 00:16:00'),
	(8, 3, 12, 2.00, 1, 2.00, '2025-04-05 00:16:00', '2025-04-05 00:16:00'),
	(9, 3, 3, 1.00, 9, 9.00, '2025-04-05 00:16:00', '2025-04-05 00:16:00'),
	(10, 4, 1, 10.99, 2, 21.98, '2025-04-05 09:25:43', '2025-04-05 09:25:43'),
	(11, 5, 11, 1.00, 25, 25.00, '2025-04-05 14:55:12', '2025-04-05 14:55:12'),
	(12, 6, 7, 1.00, 9, 9.00, '2025-04-05 18:05:12', '2025-04-05 18:05:12'),
	(13, 7, 17, 7.00, 6, 42.00, '2025-04-05 20:24:29', '2025-04-05 20:24:29'),
	(14, 8, 2, 1.50, 6, 9.00, '2025-04-05 22:12:49', '2025-04-05 22:12:49'),
	(15, 9, 2, 1.50, 6, 9.00, '2025-04-05 23:46:40', '2025-04-05 23:46:40'),
	(16, 10, 1, 1.20, 1, 1.20, '2025-04-06 11:01:28', '2025-04-06 11:01:28'),
	(17, 10, 6, 0.80, 1, 0.80, '2025-04-06 11:01:28', '2025-04-06 11:01:28'),
	(18, 10, 12, 2.00, 4, 8.00, '2025-04-06 11:01:28', '2025-04-06 11:01:28'),
	(19, 10, 17, 7.00, 5, 35.00, '2025-04-06 11:01:28', '2025-04-06 11:01:28');

-- Listage de la structure de table mkadia. personal_access_tokens
CREATE TABLE IF NOT EXISTS `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Listage des données de la table mkadia.personal_access_tokens : ~4 rows (environ)
INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
	(19, 'App\\Models\\User', 4, 'auth-token', 'b788b9b631c5b2345a789743ac245b95861cac613fc56bc626147a4d76b1a98b', '["driver"]', NULL, NULL, '2025-04-05 09:05:31', '2025-04-05 09:05:31'),
	(50, 'App\\Models\\User', 1, 'auth-token', 'c009db17ac02741ec3b9efc6e8c455568ccf4aacdef0666e864ded5e18e9d523', '["admin"]', NULL, NULL, '2025-04-06 11:03:30', '2025-04-06 11:03:30'),
	(51, 'App\\Models\\User', 3, 'auth-token', 'd13afd436bd0faf5995c842b8c4b36a18f38c4f50440d490d7d437b6d5a09d31', '["driver"]', NULL, NULL, '2025-04-06 11:07:37', '2025-04-06 11:07:37'),
	(53, 'App\\Models\\User', 2, 'auth-token', '9ad954c15a6f519e0de0daddda3d518da45667499b325da5b9abceaf4cd7340b', '["client"]', NULL, NULL, '2025-04-06 11:12:44', '2025-04-06 11:12:44');

-- Listage de la structure de table mkadia. products
CREATE TABLE IF NOT EXISTS `products` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(8,2) NOT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `weight` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rate` decimal(3,2) DEFAULT NULL,
  `category_id` bigint unsigned NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `products_category_id_foreign` (`category_id`),
  CONSTRAINT `products_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Listage des données de la table mkadia.products : ~19 rows (environ)
INSERT INTO `products` (`id`, `name`, `description`, `price`, `image_url`, `weight`, `rate`, `category_id`, `quantity`, `created_at`, `updated_at`) VALUES
	(1, 'Orange', 'The orange is a juicy, sweet, and tangy fruit from the citrus family.', 1.20, 'http://10.0.2.2:8000/img/fruits.png', '500 grams', 3.00, 2, 997, '2025-04-04 22:09:03', '2025-04-06 11:01:28'),
	(2, 'Apple', 'The apple is a sweet fruit from the rose family.', 1.50, 'http://10.0.2.2:8000/img/fruits.png', '500 grams', 4.00, 2, 976, '2025-04-04 22:09:03', '2025-04-05 23:46:40'),
	(3, 'Banana', 'The banana is a tropical fruit known for its sweetness.', 1.00, 'http://10.0.2.2:8000/img/fruits.png', '500 grams', 5.00, 2, 991, '2025-04-04 22:09:03', '2025-04-05 00:16:00'),
	(4, 'Grapes', 'Grapes are small, juicy Fruit that grow in clusters.', 2.00, 'http://10.0.2.2:8000/img/fruits.png', '500 grams', 4.00, 2, 1000, '2025-04-04 22:09:03', '2025-04-04 22:09:03'),
	(5, 'Pineapple', 'Pineapple is a tropical fruit with a sweet and tangy flavor.', 3.00, 'http://10.0.2.2:8000/img/fruits.png', '500 grams', 5.00, 2, 1000, '2025-04-04 22:09:03', '2025-04-04 22:09:03'),
	(6, 'Carrot', 'Carrot is a root vegetable, usually orange in color.', 0.80, 'http://10.0.2.2:8000/img/vegetable.png', '500 grams', 4.00, 3, 994, '2025-04-04 22:09:03', '2025-04-06 11:01:28'),
	(7, 'Potato', 'Potato is a starchy vegetable commonly used in various dishes.', 1.00, 'http://10.0.2.2:8000/img/vegetable.png', '500 grams', 3.00, 3, 991, '2025-04-04 22:09:03', '2025-04-05 18:05:12'),
	(8, 'Tomato', 'Tomato is a red, juicy fruit often used as a vegetable in cooking.', 1.20, 'http://10.0.2.2:8000/img/vegetable.png', '500 grams', 5.00, 3, 1000, '2025-04-04 22:09:03', '2025-04-04 22:09:03'),
	(9, 'Cucumber', 'Cucumber is a refreshing vegetable with a mild flavor.', 1.50, 'http://10.0.2.2:8000/img/vegetable.png', '500 grams', 4.00, 3, 1000, '2025-04-04 22:09:03', '2025-04-04 22:09:03'),
	(10, 'Lettuce', 'Lettuce is a leafy green vegetable commonly used in salads.', 1.00, 'http://10.0.2.2:8000/img/vegetable.png', '500 grams', 4.00, 3, 1000, '2025-04-04 22:09:03', '2025-04-04 22:09:03'),
	(11, 'Milk', 'Milk is a dairy product rich in calcium and vitamins.', 1.00, 'http://10.0.2.2:8000/img/milkegg.png', '1 liter', 4.00, 4, 975, '2025-04-04 22:09:03', '2025-04-05 14:55:12'),
	(12, 'Eggs', 'Eggs are a high-protein food product from hens.', 2.00, 'http://10.0.2.2:8000/img/milkegg.png', '12 pieces', 5.00, 4, 989, '2025-04-04 22:09:03', '2025-04-06 11:01:28'),
	(13, 'Butter', 'Butter is a dairy product made from churned cream.', 3.00, 'http://10.0.2.2:8000/img/milkegg.png', '250 grams', 5.00, 4, 1000, '2025-04-04 22:09:03', '2025-04-04 22:09:03'),
	(14, 'Cheese', 'Cheese is a dairy product made from milk through curdling.', 4.00, 'http://10.0.2.2:8000/img/milkegg.png', '200 grams', 4.00, 4, 1000, '2025-04-04 22:09:03', '2025-04-04 22:09:03'),
	(15, 'Yogurt', 'Yogurt is a dairy product made by fermenting milk with bacteria.', 1.50, 'http://10.0.2.2:8000/img/milkegg.png', '500 grams', 4.00, 4, 1000, '2025-04-04 22:09:03', '2025-04-04 22:09:03'),
	(16, 'Chicken Breast', 'Chicken breast is a lean and versatile meat.', 5.00, 'http://10.0.2.2:8000/img/meat.png', '500 grams', 5.00, 5, 1000, '2025-04-04 22:09:03', '2025-04-04 22:09:03'),
	(17, 'Beef Steak', 'Beef steak is a tender and flavorful cut of meat.', 7.00, 'http://10.0.2.2:8000/img/meat.png', '500 grams', 5.00, 5, 980, '2025-04-04 22:09:03', '2025-04-06 11:01:28'),
	(18, 'Chicken', 'Chicken is a versatile meat rich in protein.', 6.00, 'http://10.0.2.2:8000/img/meat.png', '500 grams', 4.00, 5, 1000, '2025-04-04 22:09:03', '2025-04-04 22:09:03'),
	(19, 'Lamb Leg', 'Lamb leg is a tender and flavorful meat from young sheep.', 8.00, 'http://10.0.2.2:8000/img/meat.png', '500 grams', 4.00, 5, 1000, '2025-04-04 22:09:03', '2025-04-04 22:09:03');

-- Listage de la structure de table mkadia. product_reviews
CREATE TABLE IF NOT EXISTS `product_reviews` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `review_id` bigint unsigned NOT NULL,
  `product_id` bigint unsigned NOT NULL,
  `rating` tinyint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_reviews_review_id_foreign` (`review_id`),
  KEY `product_reviews_product_id_foreign` (`product_id`),
  CONSTRAINT `product_reviews_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_reviews_review_id_foreign` FOREIGN KEY (`review_id`) REFERENCES `reviews` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Listage des données de la table mkadia.product_reviews : ~0 rows (environ)

-- Listage de la structure de table mkadia. promotions
CREATE TABLE IF NOT EXISTS `promotions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `type` enum('percentage','fixed_amount','free_shipping') COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` decimal(10,2) NOT NULL DEFAULT '0.00',
  `min_purchase_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `usage_limit` int NOT NULL DEFAULT '0',
  `usage_count` int NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `promotions_code_unique` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Listage des données de la table mkadia.promotions : ~6 rows (environ)
INSERT INTO `promotions` (`id`, `code`, `title`, `description`, `type`, `value`, `min_purchase_amount`, `usage_limit`, `usage_count`, `is_active`, `start_date`, `end_date`, `image_url`, `created_at`, `updated_at`) VALUES
	(1, 'SUMMER20', 'Réduction d\'été', 'Obtenez 20 % de réduction sur tous les produits', 'percentage', 20.00, 50.00, 100, 1, 1, '2025-04-04 22:09:03', '2025-05-04 22:09:03', 'http://10.0.2.2:8000/img/promo35%midmouth.png', '2025-04-04 22:09:03', '2025-04-06 10:59:36'),
	(2, 'WELCOME10', 'Bienvenue', 'Obtenez 10 % de réduction sur votre première commande', 'percentage', 10.00, 0.00, 4, 2, 1, '2025-04-04 22:09:03', '2025-10-04 22:09:03', 'http://10.0.2.2:8000/img/promo35%midmouth.png', '2025-04-04 22:09:03', '2025-04-06 11:00:49'),
	(3, 'SAVE15', 'Économisez 15 €', 'Obtenez 15 € de réduction sur votre commande', 'fixed_amount', 15.00, 100.00, 6, 0, 1, '2025-04-04 22:09:03', '2025-04-18 22:09:03', 'http://10.0.2.2:8000/img/promo35%midmouth.png', '2025-04-04 22:09:03', '2025-04-04 22:09:03'),
	(4, 'FIVEOFF', '5 € de réduction', 'Obtenez 5 € de réduction sur votre commande', 'fixed_amount', 5.00, 20.00, 8, 0, 1, '2025-04-04 22:09:03', '2026-04-04 22:09:03', 'http://10.0.2.2:8000/img/promo35%midmouth.png', '2025-04-04 22:09:03', '2025-04-04 22:09:03'),
	(5, 'FREESHIP', 'Livraison gratuite', 'Livraison gratuite sur toutes les commandes', 'free_shipping', 0.00, 0.00, 2, 0, 1, '2025-04-04 22:09:03', '2025-04-11 22:09:03', 'http://10.0.2.2:8000/img/promo35%midmouth.png', '2025-04-04 22:09:03', '2025-04-04 22:09:03'),
	(6, 'SHIP50', 'Livraison gratuite (commandes plus de 50 €)', 'Livraison gratuite pour les commandes supérieures à 50 €', 'free_shipping', 0.00, 50.00, 9, 0, 1, '2025-04-04 22:09:03', '2025-05-04 22:09:03', 'http://10.0.2.2:8000/img/promo35%midmouth.png', '2025-04-04 22:09:03', '2025-04-04 22:09:03');

-- Listage de la structure de table mkadia. reviews
CREATE TABLE IF NOT EXISTS `reviews` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `delivery_rating` tinyint unsigned NOT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `reviews_order_id_foreign` (`order_id`),
  KEY `reviews_user_id_foreign` (`user_id`),
  CONSTRAINT `reviews_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Listage des données de la table mkadia.reviews : ~0 rows (environ)

-- Listage de la structure de table mkadia. sessions
CREATE TABLE IF NOT EXISTS `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Listage des données de la table mkadia.sessions : ~0 rows (environ)

-- Listage de la structure de table mkadia. users
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('client','driver','admin') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Listage des données de la table mkadia.users : ~14 rows (environ)
INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `created_at`, `updated_at`) VALUES
	(1, 'Admin Mkadia', 'admin@mkadia.com', '$2y$12$18f1w4gx4uClvl7nrm.eKuL3b0GjWRG4j/lK60a.pFE5sm5iNaNri', 'admin', '2025-04-04 22:09:02', '2025-04-04 22:09:02'),
	(2, 'Client Test', 'client@mkadia.com', '$2y$12$KwWYAUr0daQLQEgZYj7jJOhWOAL4jyUTTsLKyPCvkHpdvoaHYGfUS', 'client', '2025-04-04 22:09:02', '2025-04-04 22:09:02'),
	(3, 'Livreur Test', 'livreur@mkadia.com', '$2y$12$kCaCSZtnkVNGxfIonqgmcepjuoOgzMQ7Gf8rVZgWScwpX/q4OdJz6', 'driver', '2025-04-04 22:09:03', '2025-04-04 22:09:03'),
	(4, 'John Driver', 'driver1@example.com', '$2y$12$sY25eAKHPTMr/xalsPXRQ.J2M.Vgb7H8Fr1QRMcj5clOwmly1qwI.', 'driver', '2025-04-04 22:09:03', '2025-04-04 22:09:03'),
	(5, 'Jane Driver', 'driver2@example.com', '$2y$12$faLaBuIAlPpQHrnvsjgiWefhL4m0Q2.dobP35lgW7hh48jV.IPAHS', 'driver', '2025-04-04 22:09:03', '2025-04-04 22:09:03'),
	(6, 'John Client', 'client@example.com', '$2y$12$80M0E5LV.d4OOlCdJ/ilfu7O4b/EapiGFPu7otnwP641EGlngrVmS', 'client', '2025-04-04 22:09:03', '2025-04-04 22:09:03'),
	(7, 'Admin', 'admin@gmail.com', '$2y$12$96MtLws/CSsDNBY1LTR76u9FE0oigYE5iK8p9lmU4bhWSarRRIxYu', 'admin', '2025-04-04 22:09:04', '2025-04-04 22:09:04'),
	(8, 'Admin Mkadia', 'admin@mkadia.com', '$2y$12$OjPHCdm.5mA.Li8A0KeJu.4d8Ci6DNu6AaqEuaJSRINmC1iZo6YWa', 'admin', '2025-04-05 14:11:32', '2025-04-05 14:11:32'),
	(9, 'Client Test', 'client@mkadia.com', '$2y$12$Q8BaisQcpGL6ZHp48lULa.bfjbzQNv6XTV2xz/xTFT4NzX5kggNqG', 'client', '2025-04-05 14:11:33', '2025-04-05 14:11:33'),
	(10, 'Admin Mkadia', 'admin@mkadia.com', '$2y$12$QD8bUmCUKWJ0mM2D6bZURe/2rKuWOu9Sa/sRmGX8m9YPOtyIIU/My', 'admin', '2025-04-05 14:11:59', '2025-04-05 14:11:59'),
	(11, 'Client Test', 'client@mkadia.com', '$2y$12$AXRu7WHLz8m8htLDD9ejC.ORHq8ufZue6kcXbJKJsvQwjopjQGsL2', 'client', '2025-04-05 14:11:59', '2025-04-05 14:11:59'),
	(12, 'John Client', 'client@example.com', '$2y$12$PaXfvZS7Kkni0X0/h8.BP.tAl/A32n12D.Po5Ned9sf4X/c2bqpCO', 'client', '2025-04-05 14:12:29', '2025-04-05 14:12:29'),
	(13, 'Admin Mkadia', 'admin@mkadia.com', '$2y$12$0FDjZ7x51VkdzY6DreNmh.ozsdhIrn/4AGAVpMu7vKcEPQaBYUqA6', 'admin', '2025-04-05 14:13:37', '2025-04-05 14:13:37'),
	(14, 'Client Test', 'client@mkadia.com', '$2y$12$ldsjoI5fnW8NKvb0sTatsuiH8hn/9hm1RTxWJnM2SgN97CigCq8Xe', 'client', '2025-04-05 14:13:38', '2025-04-05 14:13:38');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;

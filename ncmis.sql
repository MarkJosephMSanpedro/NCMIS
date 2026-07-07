-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 14, 2026 at 09:44 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ncmis`
--

-- --------------------------------------------------------

--
-- Table structure for table `asset_maintenance_logs`
--

CREATE TABLE `asset_maintenance_logs` (
  `id` int(11) NOT NULL,
  `asset_type` enum('PC','Device') DEFAULT NULL,
  `asset_id` int(11) DEFAULT NULL,
  `action` varchar(100) DEFAULT NULL,
  `previous_status` varchar(50) DEFAULT NULL,
  `new_status` varchar(50) DEFAULT NULL,
  `performed_by` varchar(255) DEFAULT NULL,
  `performed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `borrow_requests`
--

CREATE TABLE `borrow_requests` (
  `borrow_id` int(11) NOT NULL,
  `student_id` varchar(20) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `middle_initial` varchar(5) DEFAULT NULL,
  `device_id` int(11) NOT NULL,
  `borrow_date` date NOT NULL,
  `return_date` date DEFAULT NULL,
  `reason` text NOT NULL,
  `status` enum('Pending','Approved','Returned') DEFAULT 'Pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `borrow_requests`
--

INSERT INTO `borrow_requests` (`borrow_id`, `student_id`, `last_name`, `first_name`, `middle_initial`, `device_id`, `borrow_date`, `return_date`, `reason`, `status`) VALUES
(8, '2021-0442', 'Bautista', 'Renato', 'SD', 4, '2025-09-29', '2025-09-29', 're', 'Returned'),
(9, '2021-0442', 'Bautista', 'Renato', 'SD', 1, '2025-09-29', NULL, '33', 'Pending');

-- --------------------------------------------------------

--
-- Table structure for table `concerns`
--

CREATE TABLE `concerns` (
  `concern_id` int(11) NOT NULL,
  `description` text NOT NULL,
  `status` enum('Pending','Ongoing','Resolved') DEFAULT 'Pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `resolution_feedback` text DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `concerns`
--

INSERT INTO `concerns` (`concern_id`, `description`, `status`, `created_at`, `updated_at`, `resolution_feedback`, `user_id`) VALUES
(13, 'sadadadwa', 'Pending', '2025-03-24 09:26:15', '2025-03-24 09:26:15', NULL, 10),
(17, 'sdadawdadwad', 'Pending', '2025-03-24 10:16:17', '2025-03-24 10:16:17', NULL, 9);

-- --------------------------------------------------------

--
-- Table structure for table `concern_devices`
--

CREATE TABLE `concern_devices` (
  `concern_id` int(11) NOT NULL,
  `device_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `concern_devices`
--

INSERT INTO `concern_devices` (`concern_id`, `device_id`) VALUES
(13, 1),
(17, 1);

-- --------------------------------------------------------

--
-- Table structure for table `concern_history`
--

CREATE TABLE `concern_history` (
  `id` int(11) NOT NULL,
  `concern_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `description` text NOT NULL,
  `status` enum('Pending','Ongoing','Resolved') NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `resolution_feedback` text NOT NULL,
  `faculty_name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `devices` text DEFAULT NULL,
  `archived_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `concern_history`
--

INSERT INTO `concern_history` (`id`, `concern_id`, `user_id`, `description`, `status`, `created_at`, `updated_at`, `resolution_feedback`, `faculty_name`, `email`, `devices`, `archived_at`) VALUES
(6, 9, 0, 'adadawdawd', 'Resolved', '2025-03-24 17:10:54', '2025-03-24 17:11:04', 'dadawdadawdad', 'auro', 'matthewjohnsantos2004@gmail.com', '[{\"device_name\":\"PC2\",\"department_name\":\"Dean\'s Office\"}]', '2025-03-24 09:11:11'),
(7, 14, 9, 'adadadwa', 'Resolved', '2025-03-24 17:26:20', '2025-03-24 17:26:48', 'adadwadad', 'me', 'matthewjohnsantos143@gmail.com', '[{\"device_name\":\"PC1\",\"department_name\":\"Dean\'s Office\"}]', '2025-03-24 09:27:10'),
(8, 11, 0, 'fasfadfwa', 'Resolved', '2025-03-24 17:25:27', '2025-03-24 18:06:46', 'sdadwadadw', 'auro', 'matthewjohnsantos2004@gmail.com', '[{\"device_name\":\"PC1\",\"department_name\":\"Dean\'s Office\"}]', '2025-03-24 10:06:49'),
(9, 12, 9, 'adadadad', 'Resolved', '2025-03-24 17:25:32', '2025-03-24 18:15:28', 'adadawdad', 'auro', 'matthewjohnsantos2004@gmail.com', '[{\"device_name\":\"PC1\",\"department_name\":\"Dean\'s Office\"}]', '2025-03-24 10:15:31'),
(10, 16, 9, 'dadawdawdawdaw', 'Resolved', '2025-03-24 18:16:12', '2025-03-24 18:16:30', 'adadwadaw', 'auro', 'matthewjohnsantos2004@gmail.com', '[{\"device_name\":\"PC1\",\"department_name\":\"Dean\'s Office\"}]', '2025-03-24 10:16:33'),
(11, 15, 10, 'asdadawdadadw', 'Resolved', '2025-03-24 17:26:27', '2025-03-24 18:19:37', 'adadawd', 'me', 'matthewjohnsantos143@gmail.com', '[{\"device_name\":\"PC1\",\"department_name\":\"Dean\'s Office\"},{\"device_name\":\"PC2\",\"department_name\":\"Dean\'s Office\"}]', '2025-03-24 10:19:41'),
(12, 18, 9, 'adadawdawda', 'Resolved', '2025-03-24 18:16:21', '2025-03-24 18:19:58', 'tite', 'auro', 'matthewjohnsantos2004@gmail.com', '[{\"device_name\":\"PC1\",\"department_name\":\"Dean\'s Office\"}]', '2025-03-24 10:20:04'),
(13, 19, 9, 'dadadwadaw', 'Resolved', '2025-03-24 20:42:28', '2025-03-24 20:42:42', 'dadwdadw', 'auro', 'matthewjohnsantos2004@gmail.com', '[{\"device_name\":\"PC1\",\"department_name\":\"Dean\'s Office\"}]', '2025-03-24 12:48:26');

-- --------------------------------------------------------

--
-- Table structure for table `consumables`
--

CREATE TABLE `consumables` (
  `accession_id` int(11) NOT NULL,
  `item_name` varchar(255) NOT NULL,
  `category` varchar(100) DEFAULT NULL,
  `brand` varchar(100) DEFAULT NULL,
  `quantity` int(11) DEFAULT 0,
  `unit` varchar(50) DEFAULT NULL,
  `department_id` int(11) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `status` enum('Available','Low Stock','Out of Stock','Damaged') DEFAULT 'Available',
  `description` text DEFAULT NULL,
  `date_added` datetime DEFAULT current_timestamp(),
  `last_updated` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `added_by` varchar(255) DEFAULT NULL,
  `is_archived` tinyint(1) DEFAULT 0,
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `consumables`
--

INSERT INTO `consumables` (`accession_id`, `item_name`, `category`, `brand`, `quantity`, `unit`, `department_id`, `location`, `status`, `description`, `date_added`, `last_updated`, `added_by`, `is_archived`, `deleted_at`) VALUES
(9, 'Bond Paper A4', 'Office Supplies', 'Double A', 50, 'Reams', 1, 'Stock Room', '', 'For printing documents', '2026-03-03 11:32:50', '2026-04-14 10:00:45', 'admin', 1, '2026-04-14 10:00:45'),
(10, 'Printer Ink Black', 'Printer Supplies', 'HP', 20, 'Cartridges', 1, 'IT Office', '', 'HP 678 Black Ink', '2026-03-03 11:32:50', '2026-04-14 10:00:43', 'admin', 1, '2026-04-14 10:00:43'),
(11, 'Ballpen Blue', 'Office Supplies', 'Pilot', 90, 'Pieces', 1, 'Stock Room', '', 'For general writing', '2026-03-03 11:32:50', '2026-04-14 10:00:40', 'staff1', 1, '2026-04-14 10:00:40'),
(12, 'Stapler Wire', 'Office Supplies', 'Dong-A', 30, 'Boxes', 1, 'Admin Office', '', 'Standard size stapler wire', '2026-03-03 11:32:50', '2026-04-14 10:00:35', 'staff2', 1, '2026-04-14 10:00:35'),
(13, 'Alcohol 70%', 'Cleaning Supplies', 'Green Cross', 118, 'Bottles', 1, 'Clinic', '', 'For sanitation', '2026-03-03 11:32:50', '2026-04-14 10:00:32', 'nurse1', 1, '2026-04-14 10:00:32'),
(14, 'Face Mask', 'Medical Supplies', 'Generic', 200, 'Pieces', 1, 'Clinic', '', 'Disposable masks', '2026-03-03 11:32:50', '2026-04-14 10:00:29', 'nurse1', 1, '2026-04-14 10:00:29'),
(15, 'Whiteboard Marker', 'Office Supplies', 'Pilot', 40, 'Pieces', 1, 'Classroom A', '', 'Black markers', '2026-03-03 11:32:50', '2026-04-14 10:00:26', 'teacher1', 1, '2026-04-14 10:00:26'),
(16, 'USB Flash Drive 16GB', 'IT Supplies', 'SanDisk', 15, 'Pieces', 1, 'IT Office', '', 'For file storage', '2026-03-03 11:32:50', '2026-04-14 10:00:21', 'admin', 1, '2026-04-14 10:00:21'),
(17, 'rj45', 'internet', 'chinese', 3, 'pieces', 1, 'Computer Lab A', 'Available', 'sd', '2026-03-20 00:16:43', '2026-04-13 10:58:08', 'admin', 1, '2026-04-13 10:58:08'),
(47, 'SSD', NULL, NULL, 10, NULL, NULL, NULL, 'Available', NULL, '2026-03-29 21:38:34', '2026-04-13 10:57:19', NULL, 1, '2026-04-13 10:57:19'),
(48, 'Casing: 3 (3)', NULL, NULL, 5, NULL, NULL, NULL, 'Available', NULL, '2026-03-29 22:11:20', '2026-04-13 10:58:05', NULL, 1, '2026-04-13 10:58:05'),
(49, 'RAM: 234 (1)', NULL, NULL, 5, NULL, NULL, NULL, 'Available', NULL, '2026-03-29 22:17:24', '2026-04-13 10:58:02', NULL, 1, '2026-04-13 10:58:02'),
(50, 'PSU: 2 (1)', NULL, NULL, 5, NULL, NULL, NULL, 'Available', NULL, '2026-03-29 22:44:10', '2026-04-13 10:58:00', NULL, 1, '2026-04-13 10:58:00'),
(51, 'Storage: 123 (1)', NULL, NULL, 5, NULL, NULL, NULL, 'Available', NULL, '2026-03-29 22:51:58', '2026-04-13 10:57:58', NULL, 1, '2026-04-13 10:57:58'),
(52, 'RAM: 3 (3)', NULL, NULL, 5, NULL, NULL, NULL, 'Available', NULL, '2026-03-29 22:57:11', '2026-04-13 10:57:56', NULL, 1, '2026-04-13 10:57:56'),
(53, 'GPU: as (1)', NULL, NULL, 5, NULL, NULL, NULL, 'Available', NULL, '2026-03-29 22:59:38', '2026-04-13 10:57:53', NULL, 1, '2026-04-13 10:57:53'),
(54, 'GPU', NULL, NULL, 5, NULL, NULL, NULL, '', NULL, '2026-03-29 23:32:09', '2026-04-13 10:57:51', NULL, 1, '2026-04-13 10:57:51'),
(55, 'Casing', 'electronics', 'blue11', 10, 'wire', 3, 'mis', 'Available', '', NULL, '2026-04-13 10:57:49', NULL, 1, '2026-04-13 10:57:49'),
(56, 'Motherboard', 'wafdaw', 'fafaw', 15, 'fdawf', 3, 'mis', 'Available', '', NULL, '2026-04-13 10:57:29', NULL, 1, '2026-04-13 10:57:29'),
(57, 'Power Supply', 'electronics', 'rg65', 5, 'item', 3, 'mis office ', '', '', '2026-03-31 00:00:00', '2026-04-13 10:57:25', NULL, 1, '2026-04-13 10:57:25'),
(58, 'USB Cable', 'electronics', '', 23, 'wire', 3, 'mis', '', '', '2026-04-13 00:00:00', '2026-04-13 10:56:53', NULL, 1, '2026-04-13 10:56:53'),
(59, 'RJ45 Connector', 'electronics', '', 15, '', 3, 'mis', 'Available', '', '2026-04-14 00:00:00', NULL, NULL, 0, NULL),
(60, 'HDMI Cable', 'electronics', '', 5, '', 3, '', 'Available', '', '2026-04-14 00:00:00', NULL, NULL, 0, NULL),
(61, 'Power Cable', '', '', 10, '', 3, 'mis', 'Available', '', '2026-04-14 00:00:00', NULL, NULL, 0, NULL),
(62, 'USB Cable', 'electronics', '', 6, '', 3, 'mis', 'Available', '', '2026-04-14 00:00:00', NULL, NULL, 0, NULL),
(63, 'Extension Cord', 'electronics', '', 5, '', 3, 'mis', 'Available', '', '2026-04-14 00:00:00', NULL, NULL, 0, NULL),
(64, 'Ethernet Cable (Cat6)', 'electronics', '', 5, '', 3, 'mis', 'Available', '', '0000-00-00 00:00:00', NULL, NULL, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `consumable_transactions`
--

CREATE TABLE `consumable_transactions` (
  `transaction_id` int(11) NOT NULL,
  `accession_id` int(11) NOT NULL,
  `item_name` varchar(255) DEFAULT NULL,
  `action` enum('RECEIVE','RETURN') NOT NULL,
  `quantity` int(11) NOT NULL,
  `previous_stock` int(11) DEFAULT NULL,
  `new_stock` int(11) DEFAULT NULL,
  `reference_no` varchar(100) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `performed_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `consumable_transactions`
--
-- NOTE: Initial consumable transaction rows removed to avoid shipping test/sample data in the SQL dump.
-- If you need seeded transactions for development, re-add explicit INSERT statements carefully.

-- --------------------------------------------------------

--
-- Table structure for table `damage_reports`
--

CREATE TABLE `damage_reports` (
  `id` int(11) NOT NULL,
  `pcid` int(11) NOT NULL,
  `reported_by` varchar(255) DEFAULT NULL,
  `damage_type` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `date_reported` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `damage_reports`
--

INSERT INTO `damage_reports` (`id`, `pcid`, `reported_by`, `damage_type`, `description`, `date_reported`) VALUES
(4, 71, 'System', 'General Damage', 'Bulk marked as damaged', '2026-03-20 15:23:27'),
(5, 84, 'System', 'General Damage', 'Bulk marked as damaged', '2026-03-20 15:23:27'),
(9, 70, 'System', 'General Damage', 'Bulk marked as damaged', '2026-03-21 02:43:45'),
(10, 71, 'System', 'General Damage', 'Bulk marked as damaged', '2026-03-21 02:43:45'),
(11, 84, 'System', 'General Damage', 'Bulk marked as damaged', '2026-03-21 02:43:45'),
(12, 86, 'System', 'General Damage', 'Bulk marked as damaged', '2026-03-29 11:55:12'),
(13, 85, 'System', 'General Damage', 'Bulk marked as damaged', '2026-03-29 15:14:42'),
(14, 71, 'System', 'General Damage', 'Bulk marked as damaged', '2026-03-31 09:33:37'),
(15, 85, 'System', 'General Damage', 'Bulk marked as damaged', '2026-03-31 13:23:31'),
(16, 85, 'System', 'General Damage', 'Bulk marked as damaged', '2026-03-31 13:24:35'),
(17, 96, 'System', 'General Damage', 'Bulk marked as damaged', '2026-03-31 14:22:16'),
(18, 116, 'System', 'General Damage', 'Bulk marked as damaged', '2026-03-31 14:26:19'),
(19, 116, 'System', 'General Damage', 'Bulk marked as damaged', '2026-03-31 14:26:45'),
(20, 116, 'System', 'General Damage', 'Bulk marked as damaged', '2026-03-31 14:27:06'),
(21, 106, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-02 20:50:32'),
(22, 105, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-02 21:21:07'),
(23, 106, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-02 22:05:58'),
(24, 106, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-02 22:15:25'),
(25, 106, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-02 22:19:37'),
(26, 106, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-02 22:23:43'),
(27, 106, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-03 23:23:03'),
(28, 106, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-03 23:23:20'),
(29, 106, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-04 12:00:46'),
(30, 106, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-06 13:16:03'),
(31, 87, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-06 16:07:46'),
(32, 121, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-08 22:11:41'),
(33, 121, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-08 22:20:00'),
(34, 121, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-08 22:30:02'),
(35, 121, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-08 23:44:43'),
(36, 103, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-12 13:11:16');

-- --------------------------------------------------------

--
-- Table structure for table `damage_types`
--

CREATE TABLE `damage_types` (
  `damage_type_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `severity_level` enum('Low','Medium','High','Critical') DEFAULT 'Low',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `department_id` int(11) NOT NULL,
  `department_name` varchar(100) NOT NULL,
  `department_code` varchar(10) DEFAULT NULL,
  `category` varchar(50) NOT NULL DEFAULT 'other',
  `max_pc_allowed` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`department_id`, `department_name`, `department_code`, `category`, `max_pc_allowed`) VALUES
(1, 'Dean\'s Office', 'DO', 'Office', 0),
(3, 'MIS OFFICE', NULL, 'Office', 0),
(25, 'CLC', NULL, 'Laboratory', 0),
(29, 'CLB', NULL, 'Laboratory', 0),
(30, 'CLA', NULL, 'Laboratory', 40),
(31, 'Registar', NULL, 'Office', 10),
(32, 'Clinic', NULL, 'Facility', 2);

-- --------------------------------------------------------

--
-- Table structure for table `devices`
--

CREATE TABLE `devices` (
  `device_id` int(11) NOT NULL,
  `item_name` varchar(150) NOT NULL,
  `brand_model` varchar(100) DEFAULT NULL,
  `department_id` int(11) DEFAULT NULL,
  `serial_number` varchar(100) DEFAULT NULL,
  `quantity` int(11) DEFAULT 0,
  `device_type` varchar(50) DEFAULT NULL,
  `status` enum('Available','Borrowed','Damaged','Disposed') DEFAULT 'Available'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `devices`
--

INSERT INTO `devices` (`device_id`, `item_name`, `brand_model`, `department_id`, `serial_number`, `quantity`, `device_type`, `status`) VALUES
(1, 'PC1', NULL, 1, NULL, 0, NULL, 'Available'),
(3, 'PC2', NULL, 1, NULL, 0, NULL, 'Available'),
(4, 'Projector', 'Epson EB-X07', 1, 'PRJ-001', 5, 'Electronics', 'Available'),
(5, 'Mouse', 'a4tech', 1, 'm2025', 29, 'Computer accessory', 'Available'),
(6, 'a4Tech Mouse', 'a4Tech', 1, NULL, 1, 'Mouse', 'Available'),
(7, 'inplay keyboard 2', 'inplay', 1, NULL, 1, 'keyboard', 'Available');

-- --------------------------------------------------------

--
-- Table structure for table `devices_full`
--

CREATE TABLE `devices_full` (
  `accession_id` int(11) NOT NULL,
  `device_id` int(11) DEFAULT NULL,
  `item_name` varchar(255) NOT NULL,
  `brand_model` varchar(255) DEFAULT NULL,
  `quantity` int(11) DEFAULT 1,
  `acquisition_cost` decimal(12,2) DEFAULT NULL,
  `date_acquired` date DEFAULT NULL,
  `accountable` varchar(255) DEFAULT NULL,
  `serial_no` varchar(255) NOT NULL,
  `municipal_serial_no` varchar(255) DEFAULT NULL,
  `device_type` varchar(255) DEFAULT NULL,
  `department_id` int(11) DEFAULT NULL,
  `status` varchar(50) DEFAULT 'Available',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `last_checked` date DEFAULT NULL,
  `maintenance_interval_days` int(11) DEFAULT 30,
  `health_score` int(11) DEFAULT 100,
  `risk_level` varchar(20) DEFAULT 'Low',
  `is_archived` tinyint(1) DEFAULT 0,
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `devices_full`
--

INSERT INTO `devices_full` (`accession_id`, `device_id`, `item_name`, `brand_model`, `quantity`, `acquisition_cost`, `date_acquired`, `accountable`, `serial_no`, `municipal_serial_no`, `device_type`, `department_id`, `status`, `created_at`, `updated_at`, `last_checked`, `maintenance_interval_days`, `health_score`, `risk_level`, `is_archived`, `deleted_at`) VALUES
(14, NULL, 'Mouse', 'a4Tech', 1, 400.00, '2025-10-25', 'John Doe', 'SN-0103', 'MUN-0001241', 'Mouse', 1, 'Available', '2025-10-25 13:19:00', '2026-04-03 05:44:49', '2026-03-31', 30, 100, 'Low', 0, NULL),
(15, NULL, 'inplay keyboard 1', 'inplay', 5, 1000.00, '0000-00-00', 'John Doe', 'SN-000001', 'MUN-0001252', 'keynoard', 1, 'Available', '2025-10-26 02:09:23', '2026-04-03 05:44:49', '2026-03-31', 30, 100, 'Low', 0, NULL),
(16, NULL, 'Epson EB-X08', 'Epson', 1, 3000.00, '2025-10-27', 'John Doe', 'SN-003', 'MUN-000125', 'projector', 1, 'Available', '2025-10-26 17:13:39', '2026-04-03 05:44:49', '2026-03-31', 30, 100, 'Low', 0, NULL),
(17, NULL, '3', '2', 1, 213321.00, '2025-10-27', '213', '123', '123', '213', 1, 'Available', '2025-10-27 02:00:09', '2026-04-03 05:44:49', '2026-03-31', 30, 100, 'Low', 0, NULL),
(18, NULL, '4', '3', 1, 3.00, '0000-00-00', '3', '3', '4', '3', 1, 'Available', '2025-10-27 03:27:22', '2026-04-03 05:44:49', '2026-03-31', 30, 100, 'Low', 0, NULL),
(19, NULL, 'ye', 'ye', 1, 123.00, '0000-00-00', 'ye', 'ye', 'ye', 'ye', 1, 'Available', '2025-10-27 04:52:19', '2026-04-03 05:44:49', '2026-03-31', 30, 100, 'Low', 0, NULL),
(20, NULL, '123', '123', 1, 123.00, '2025-10-27', '123', 'SN68546784', 'MSN68546858', '123', 1, 'Available', '2025-10-27 05:08:05', '2026-04-03 05:44:49', '2026-03-31', 30, 100, 'Low', 0, NULL),
(21, NULL, '123', '123', 1, 123.00, '2025-10-27', '123', 'SN70555644', 'MSN70555662', '23', 1, 'Available', '2025-10-27 05:08:25', '2026-04-03 05:44:49', '2026-03-31', 30, 100, 'Low', 0, NULL),
(22, NULL, '123', '123', 1, 123.00, '2025-10-27', '123', 'SN70555772', 'MSN70555748', '23', 1, 'Available', '2025-10-27 05:08:25', '2026-04-03 05:44:49', '2026-03-31', 30, 100, 'Low', 0, NULL),
(23, NULL, '123', '123', 1, 123.00, '2025-10-27', '123', 'SN70555841', 'MSN70555872', '23', 1, 'Available', '2025-10-27 05:08:25', '2026-04-03 05:44:49', '2026-03-31', 30, 100, 'Low', 0, NULL),
(24, NULL, '444', '444', 1, 4444.00, '2025-10-27', '44', 'SN73088694', 'MSN73088666', '4', 1, 'Available', '2025-10-27 05:08:50', '2026-04-03 05:44:49', '2026-03-31', 30, 100, 'Low', 0, NULL),
(25, NULL, '444', '444', 1, 4444.00, '2025-10-27', '44', 'SN73088849', 'MSN73088823', '4', 1, 'Available', '2025-10-27 05:08:50', '2026-04-03 05:44:49', '2026-03-31', 30, 100, 'Low', 0, NULL),
(26, NULL, '444', '444', 1, 4444.00, '2025-10-27', '44', 'SN73088928', 'MSN73088926', '4', 1, 'Available', '2025-10-27 05:08:50', '2026-04-03 05:44:49', '2026-03-31', 30, 100, 'Low', 0, NULL),
(27, NULL, 'e', 'e', 1, 4.00, '2025-10-27', 'e', 'SN73089018', 'MSN73089037', 'e', 1, 'Available', '2025-10-27 05:08:50', '2026-04-03 05:44:49', '2026-03-31', 30, 100, 'Low', 0, NULL),
(28, NULL, 'samsung', 'j710f', 1, 37373.00, '2026-01-08', 'John Doe', 'SN84335477', 'MSN84335434', 'Computer accessory', 1, 'Available', '2026-01-08 12:54:03', '2026-04-03 05:44:49', '2026-03-31', 30, 100, 'Low', 0, NULL),
(29, NULL, 'samsung', 'j710f', 1, 37373.00, '2026-01-08', 'John Doe', 'SN84335566', 'MSN84335570', 'Computer accessory', 1, 'Available', '2026-01-08 12:54:03', '2026-04-03 05:44:49', '2026-03-31', 30, 100, 'Low', 0, NULL),
(30, NULL, 'samsung', 'j710f', 1, 37373.00, '2026-01-08', 'John Doe', 'SN84335692', 'MSN84335696', 'Computer accessory', 1, 'Available', '2026-01-08 12:54:03', '2026-04-03 05:44:49', '2026-03-31', 30, 100, 'Low', 0, NULL),
(31, NULL, 'samsung', 'j710f', 1, 37373.00, '2026-01-08', 'John Doe', 'SN84335774', 'MSN84335773', 'Computer accessory', 1, 'Available', '2026-01-08 12:54:03', '2026-04-03 05:44:49', '2026-03-29', 30, 100, 'Low', 0, NULL),
(32, NULL, 'samsung', 'j710f', 1, 37373.00, '2026-01-08', 'John Doe', 'SN84335776', 'MSN84335780', 'Computer accessory', 1, 'Available', '2026-01-08 12:54:03', '2026-04-03 05:44:49', '2026-03-29', 30, 100, 'Low', 0, NULL),
(33, NULL, 'samsung', 'j710f', 1, 37373.00, '2026-01-08', 'John Doe', 'SN84335886', 'MSN84335887', 'Computer accessory', 1, 'Available', '2026-01-08 12:54:03', '2026-04-03 05:44:49', '2026-03-29', 30, 100, 'Low', 0, NULL),
(34, NULL, 'samsung', 'j710f', 1, 37373.00, '2026-01-08', 'John Doe', 'SN84335837', 'MSN84335842', 'Computer accessory', 1, 'Available', '2026-01-08 12:54:03', '2026-04-03 05:44:49', '2026-03-29', 30, 100, 'Low', 0, NULL),
(35, NULL, 'samsung', 'j710f', 1, 37373.00, '2026-01-08', 'John Doe', 'SN84335981', 'MSN84335979', 'Computer accessory', 1, 'Available', '2026-01-08 12:54:03', '2026-04-03 05:44:49', '2026-03-29', 30, 100, 'Low', 0, NULL),
(36, NULL, 'samsung', 'j710f', 1, 37373.00, '2026-01-08', 'John Doe', 'SN84335952', 'MSN84335917', 'Computer accessory', 1, 'Available', '2026-01-08 12:54:03', '2026-04-03 05:44:49', '2026-03-29', 30, 100, 'Low', 0, NULL),
(37, NULL, 'samsung', 'j710f', 1, 37373.00, '2026-01-08', 'John Doe', 'SN84336013', 'MSN84336085', 'Computer accessory', 1, 'Available', '2026-01-08 12:54:03', '2026-04-03 05:44:49', '2026-03-29', 30, 100, 'Low', 0, NULL),
(38, NULL, 'samsung', 'j710f', 1, 37373.00, '2026-01-08', 'John Doe', 'SN84336064', 'MSN84336071', 'Computer accessory', 1, 'Available', '2026-01-08 12:54:03', '2026-04-03 05:44:49', '2026-03-29', 30, 100, 'Low', 0, NULL),
(39, NULL, 'xiaomi', 'redmi', 1, 24242.00, '2026-01-08', 'John Doe', 'SN89003666', 'MSN89003624', '4', 1, 'Available', '2026-01-08 12:54:50', '2026-04-03 05:44:49', '2026-03-29', 30, 100, 'Low', 0, NULL),
(40, NULL, 'xiaomi', 'redmiew', 1, 24242.00, '2026-01-08', 'John Doe', 'SN89003858', 'MSN89003858', '4', 1, 'Available', '2026-01-08 12:54:50', '2026-04-03 05:44:49', '2026-03-23', 30, 100, 'Low', 0, NULL),
(47, NULL, 'SSD', NULL, 10, NULL, NULL, NULL, 'SN51433555', 'MSN51433580', 'Consumable', NULL, 'Available', '2026-03-29 13:38:34', '2026-04-09 08:38:11', '2026-03-29', 30, 100, 'Low', 1, '2026-04-09 16:38:11'),
(48, NULL, 'Casing: 3 (3)', 'gpu 340', 5, NULL, NULL, 'dean', 'SN48035141', 'MSN48035151', 'Consumable', NULL, 'Available', '2026-03-29 14:11:20', '2026-04-12 05:38:04', '2026-04-12', 30, 100, 'Low', 0, NULL),
(49, NULL, 'RAM: 234 (1)', 'gpu 341', 5, NULL, '2026-03-19', 'dean', 'SN84432710', 'MSN84432762', 'Consumable', 3, 'Available', '2026-03-29 14:17:24', '2026-04-09 08:31:39', '2026-03-29', 30, 100, 'Low', 1, '2026-04-09 16:31:39'),
(50, NULL, 'PSU: 2 (1)', 'psu999', 5, NULL, '2026-03-31', 'dean', 'SN45036218', 'MSN45036475', 'Consumable', 3, 'Surrendered', '2026-03-29 14:44:10', '2026-04-12 05:25:16', '2026-03-29', 30, 100, 'Low', 0, NULL),
(51, NULL, 'Storage: 123 (1)', 'storage700', 5, 15000.00, '2026-03-27', 'dean', 'SN91805162', 'MSN91805266', 'Consumable', 3, 'Available', '2026-03-29 14:51:58', '2026-04-09 02:00:35', '2026-03-29', 30, 100, 'Low', 1, '2026-04-09 10:00:35'),
(52, NULL, 'RAM: 3 (3)', 'ram3001', 5, 5000.00, '2026-03-07', 'dean', 'SN23123553', 'MSN23123624', 'Consumable', 3, 'Available', '2026-03-29 14:57:11', '2026-04-12 05:04:10', '2026-04-01', 30, 100, 'Low', 1, '2026-04-12 13:04:10'),
(55, NULL, 'Casing', 'casin300', 10, 1500.00, '2026-03-25', 'dean', 'SN93696351', 'MSN93696313', 'Consumable', 3, 'Surrendered', '2026-03-31 01:35:36', '2026-04-08 15:10:10', '2026-04-06', 30, 100, 'Low', 0, NULL),
(56, NULL, 'Motherboard', 'motherboard999', 15, 7000.00, '2026-04-04', 'dean', 'SN34373791', 'MSN34374499', 'Consumable', 3, 'Available', '2026-03-31 05:35:43', '2026-04-10 12:30:46', '2026-04-08', 30, 100, 'Low', 1, '2026-04-10 20:30:46'),
(57, NULL, 'Power Supply', 'power34444', 5, 5000.00, '2026-04-03', 'dean', 'SN68526992', 'MSN68527255', 'Consumable', 3, 'Available', '2026-04-03 03:24:45', '2026-04-12 05:03:04', '2026-04-12', 30, 100, 'Low', 1, '2026-04-09 16:18:51'),
(58, NULL, 'flash drive 8gb', 'sandisk', 1, 1000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN10847315', 'MSN10847363', 'storage', 3, 'Available', '2026-04-14 01:11:48', '2026-04-14 01:11:48', NULL, 1825, 100, 'Low', 0, NULL),
(59, NULL, 'flash drive 8gb', 'sandisk', 1, 1000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN10847612', 'MSN10847689', 'storage', 3, 'Available', '2026-04-14 01:11:48', '2026-04-14 01:11:48', NULL, 1825, 100, 'Low', 0, NULL),
(60, NULL, 'flash drive 8gb', 'sandisk', 1, 1000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN10847830', 'MSN10847826', 'storage', 3, 'Available', '2026-04-14 01:11:48', '2026-04-14 01:11:48', NULL, 1825, 100, 'Low', 0, NULL),
(61, NULL, 'flash drive 8gb', 'sandisk', 1, 1000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN10847970', 'MSN10847926', 'storage', 3, 'Available', '2026-04-14 01:11:48', '2026-04-14 01:11:48', NULL, 1825, 100, 'Low', 0, NULL),
(62, NULL, 'flash drive 8gb', 'sandisk', 1, 1000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN10848034', 'MSN10848076', 'storage', 3, 'Available', '2026-04-14 01:11:48', '2026-04-14 01:11:48', NULL, 1825, 100, 'Low', 0, NULL),
(63, NULL, '500W 80+ Bronze', 'Cool Master', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN71018253', 'MSN71018266', 'Electronics', 3, 'Available', '2026-04-14 01:55:10', '2026-04-14 01:55:10', NULL, 1825, 100, 'Low', 0, NULL),
(64, NULL, '500W 80+ Bronze', 'Cool Master', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN71018370', 'MSN71018318', 'Electronics', 3, 'Available', '2026-04-14 01:55:10', '2026-04-14 01:55:10', NULL, 1825, 100, 'Low', 0, NULL),
(65, NULL, '500W 80+ Bronze', 'Cool Master', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN71018698', 'MSN71018644', 'Electronics', 3, 'Available', '2026-04-14 01:55:10', '2026-04-14 01:55:10', NULL, 1825, 100, 'Low', 0, NULL),
(66, NULL, '500W 80+ Bronze', 'Cool Master', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN71018867', 'MSN71018860', 'Electronics', 3, 'Available', '2026-04-14 01:55:10', '2026-04-14 01:55:10', NULL, 1825, 100, 'Low', 0, NULL),
(67, NULL, '500W 80+ Bronze', 'Cool Master', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN71019043', 'MSN71019080', 'Electronics', 3, 'Available', '2026-04-14 01:55:10', '2026-04-14 01:55:10', NULL, 1825, 100, 'Low', 0, NULL),
(68, NULL, '500W 80+ Bronze', 'Cool Master', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN71019161', 'MSN71019125', 'Electronics', 3, 'Available', '2026-04-14 01:55:10', '2026-04-14 01:55:10', NULL, 1825, 100, 'Low', 0, NULL),
(69, NULL, '500W 80+ Bronze', 'Cool Master', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN71019276', 'MSN71019274', 'Electronics', 3, 'Available', '2026-04-14 01:55:10', '2026-04-14 01:55:10', NULL, 1825, 100, 'Low', 0, NULL),
(70, NULL, '500W 80+ Bronze', 'Cool Master', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN71019447', 'MSN71019410', 'Electronics', 3, 'Available', '2026-04-14 01:55:10', '2026-04-14 01:55:10', NULL, 1825, 100, 'Low', 0, NULL),
(71, NULL, '500W 80+ Bronze', 'Cool Master', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN71019574', 'MSN71019517', 'Electronics', 3, 'Available', '2026-04-14 01:55:10', '2026-04-14 01:55:10', NULL, 1825, 100, 'Low', 0, NULL),
(72, NULL, '500W 80+ Bronze', 'Cool Master', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN71019767', 'MSN71019774', 'Electronics', 3, 'Available', '2026-04-14 01:55:10', '2026-04-14 01:55:10', NULL, 1825, 100, 'Low', 0, NULL),
(73, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77365971', 'MSN77365914', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(74, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77366087', 'MSN77366010', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(75, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77366118', 'MSN77366157', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(76, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77366492', 'MSN77366469', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(77, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77366855', 'MSN77366824', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(78, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77367037', 'MSN77367034', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(79, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77367213', 'MSN77367213', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(80, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77367345', 'MSN77367363', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(81, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77367437', 'MSN77367420', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(82, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77367531', 'MSN77367531', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(83, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77367794', 'MSN77367711', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(84, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77367825', 'MSN77367883', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(85, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77367933', 'MSN77367933', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(86, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77368086', 'MSN77368010', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(87, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77368125', 'MSN77368179', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(88, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77369021', 'MSN77369099', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(89, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77369236', 'MSN77369267', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(90, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77369319', 'MSN77369375', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(91, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77369690', 'MSN77369683', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(92, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77370140', 'MSN77370191', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(93, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77370342', 'MSN77370347', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(94, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77370562', 'MSN77370559', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(95, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77370690', 'MSN77370693', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(96, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77370730', 'MSN77370729', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(97, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77370846', 'MSN77370888', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(98, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77370913', 'MSN77370961', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(99, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77371032', 'MSN77371043', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(100, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77371138', 'MSN77371167', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(101, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77371276', 'MSN77371256', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(102, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77371498', 'MSN77371461', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(103, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77371815', 'MSN77371888', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(104, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77371981', 'MSN77372029', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(105, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77372156', 'MSN77372134', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(106, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77372465', 'MSN77372416', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(107, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77372738', 'MSN77372735', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(108, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77372955', 'MSN77372912', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(109, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77373082', 'MSN77373044', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(110, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77396190', 'MSN77396152', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(111, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77396287', 'MSN77396223', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(112, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77396368', 'MSN77396336', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(113, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77396431', 'MSN77396499', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(114, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77397145', 'MSN77397234', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(115, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77397382', 'MSN77397362', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(116, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77397448', 'MSN77397443', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(117, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77397523', 'MSN77397581', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(118, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77397687', 'MSN77397635', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(119, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77397755', 'MSN77397735', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(120, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77397855', 'MSN77397813', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(121, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77397934', 'MSN77397971', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(122, NULL, 'Motherboard', 'Asus B650M', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN77398066', 'MSN77398020', 'Electronics', 3, 'Available', '2026-04-14 01:56:13', '2026-04-14 01:56:13', NULL, 365, 100, 'Low', 0, NULL),
(123, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81293029', 'MSN81293167', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(124, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81293469', 'MSN81293464', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(125, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81293527', 'MSN81293597', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(126, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81293617', 'MSN81293682', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(127, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81293696', 'MSN81293661', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(128, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81293765', 'MSN81293734', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(129, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81293984', 'MSN81293940', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(130, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81294385', 'MSN81294320', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(131, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81294751', 'MSN81294722', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(132, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81294947', 'MSN81294923', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(133, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81295053', 'MSN81295087', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(134, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81295841', 'MSN81295830', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(135, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81296069', 'MSN81296029', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(136, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81296170', 'MSN81296164', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(137, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81296267', 'MSN81296268', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(138, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81296345', 'MSN81296394', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(139, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81296320', 'MSN81296327', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(140, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81296440', 'MSN81296447', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(141, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81296592', 'MSN81296596', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(142, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81296659', 'MSN81296688', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(143, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81296646', 'MSN81296661', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(144, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81296733', 'MSN81296775', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(145, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81296813', 'MSN81296854', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(146, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81296940', 'MSN81296964', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(147, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81296923', 'MSN81296997', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(148, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81297077', 'MSN81297050', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(149, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81297154', 'MSN81297171', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(150, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81297112', 'MSN81297141', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(151, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81297340', 'MSN81297372', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(152, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81297572', 'MSN81297579', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(153, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81297685', 'MSN81297680', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(154, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81297957', 'MSN81297991', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(155, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81298081', 'MSN81298045', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(156, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81298157', 'MSN81298125', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(157, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81298236', 'MSN81298212', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(158, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81298318', 'MSN81298335', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(159, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81298381', 'MSN81298345', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(160, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81298446', 'MSN81298459', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(161, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81298565', 'MSN81298544', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(162, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81298697', 'MSN81298658', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(163, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81298793', 'MSN81298781', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(164, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81299395', 'MSN81299326', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(165, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81299538', 'MSN81299541', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(166, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81299657', 'MSN81299611', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(167, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81299877', 'MSN81299872', 'Electronics', 3, 'Available', '2026-04-14 01:56:52', '2026-04-14 01:56:52', NULL, 730, 100, 'Low', 0, NULL),
(168, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81299953', 'MSN81299979', 'Electronics', 3, 'Available', '2026-04-14 01:56:53', '2026-04-14 01:56:53', NULL, 730, 100, 'Low', 0, NULL),
(169, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81300193', 'MSN81300147', 'Electronics', 3, 'Available', '2026-04-14 01:56:53', '2026-04-14 01:56:53', NULL, 730, 100, 'Low', 0, NULL),
(170, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81300141', 'MSN81300129', 'Electronics', 3, 'Available', '2026-04-14 01:56:53', '2026-04-14 01:56:53', NULL, 730, 100, 'Low', 0, NULL),
(171, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81300294', 'MSN81300275', 'Electronics', 3, 'Available', '2026-04-14 01:56:53', '2026-04-14 01:56:53', NULL, 730, 100, 'Low', 0, NULL),
(172, NULL, 'RAM', '8GB DDR4 3200MHz', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN81300393', 'MSN81300358', 'Electronics', 3, 'Available', '2026-04-14 01:56:53', '2026-04-14 01:56:53', NULL, 730, 100, 'Low', 0, NULL),
(173, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86264166', 'MSN86264111', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(174, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86264380', 'MSN86264393', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(175, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86264562', 'MSN86264597', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(176, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86264646', 'MSN86264656', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(177, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86264723', 'MSN86264783', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(178, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86264898', 'MSN86264823', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(179, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86264973', 'MSN86264944', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(180, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86265042', 'MSN86265017', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(181, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86265170', 'MSN86265121', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(182, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86265271', 'MSN86265226', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(183, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86265259', 'MSN86265217', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(184, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86265364', 'MSN86265374', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(185, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86265439', 'MSN86265492', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(186, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86265577', 'MSN86265531', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(187, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86266387', 'MSN86266326', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(188, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86266530', 'MSN86266515', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(189, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86266790', 'MSN86266743', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(190, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86266815', 'MSN86266846', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(191, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86267072', 'MSN86267044', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(192, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86267283', 'MSN86267285', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(193, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86267482', 'MSN86267455', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(194, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86267816', 'MSN86267825', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(195, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86268049', 'MSN86268057', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(196, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86268192', 'MSN86268147', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(197, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86268229', 'MSN86268220', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(198, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86268394', 'MSN86268399', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(199, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86268459', 'MSN86268426', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(200, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86268524', 'MSN86268555', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(201, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86268670', 'MSN86268698', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(202, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86268720', 'MSN86268790', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(203, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86268728', 'MSN86268891', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(204, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86268873', 'MSN86268841', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(205, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86269143', 'MSN86269154', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(206, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86269577', 'MSN86269548', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(207, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86269673', 'MSN86269670', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(208, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86269782', 'MSN86269782', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(209, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86269920', 'MSN86269947', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(210, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86270098', 'MSN86270022', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(211, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86270171', 'MSN86270184', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(212, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86270288', 'MSN86270276', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(213, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86270383', 'MSN86270396', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(214, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86270325', 'MSN86270346', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(215, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86270474', 'MSN86270419', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(216, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86270577', 'MSN86270510', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(217, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86270786', 'MSN86270730', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(218, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86270921', 'MSN86270914', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(219, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86271153', 'MSN86271184', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(220, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86271272', 'MSN86271222', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(221, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86271395', 'MSN86271357', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(222, NULL, 'Storage (SSD)', '256GB SSD', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN86271416', 'MSN86271445', 'Electronics', 3, 'Available', '2026-04-14 01:57:42', '2026-04-14 01:57:42', NULL, 1095, 100, 'Low', 0, NULL),
(223, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91358772', 'MSN91358784', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(224, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91359046', 'MSN91359055', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(225, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91359287', 'MSN91359254', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(226, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91359523', 'MSN91359569', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(227, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91359791', 'MSN91359783', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(228, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91359918', 'MSN91359934', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(229, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91360131', 'MSN91360198', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(230, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91360289', 'MSN91360268', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(231, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91360348', 'MSN91360331', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(232, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91360570', 'MSN91360527', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(233, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91361484', 'MSN91361483', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(234, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91361674', 'MSN91361637', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(235, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91361729', 'MSN91361779', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(236, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91361944', 'MSN91362079', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(237, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91362111', 'MSN91362141', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(238, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91362387', 'MSN91362384', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(239, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91362467', 'MSN91362439', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(240, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91362927', 'MSN91362995', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(241, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91363082', 'MSN91363079', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(242, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91363232', 'MSN91363264', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(243, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91363420', 'MSN91363488', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(244, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91364210', 'MSN91364297', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(245, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91364492', 'MSN91364489', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(246, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91364622', 'MSN91364663', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(247, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91364737', 'MSN91364786', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(248, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91364981', 'MSN91364983', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL);
INSERT INTO `devices_full` (`accession_id`, `device_id`, `item_name`, `brand_model`, `quantity`, `acquisition_cost`, `date_acquired`, `accountable`, `serial_no`, `municipal_serial_no`, `device_type`, `department_id`, `status`, `created_at`, `updated_at`, `last_checked`, `maintenance_interval_days`, `health_score`, `risk_level`, `is_archived`, `deleted_at`) VALUES
(249, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91365052', 'MSN91365097', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(250, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91365275', 'MSN91365251', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(251, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91365358', 'MSN91365375', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(252, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91365494', 'MSN91365464', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(253, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91365527', 'MSN91365551', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(254, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91365613', 'MSN91365615', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(255, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91365747', 'MSN91365793', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(256, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91366279', 'MSN91366243', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(257, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91366512', 'MSN91366553', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(258, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91366712', 'MSN91366754', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(259, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91367074', 'MSN91367035', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(260, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91367287', 'MSN91367273', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(261, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91367349', 'MSN91367355', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(262, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91367530', 'MSN91367511', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(263, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91368041', 'MSN91368079', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(264, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91368322', 'MSN91368390', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(265, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91368439', 'MSN91368429', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(266, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91368533', 'MSN91368560', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(267, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91368644', 'MSN91368610', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(268, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91368845', 'MSN91368857', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(269, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91368951', 'MSN91368950', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(270, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91369034', 'MSN91369061', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(271, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91369214', 'MSN91369276', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(272, NULL, 'Graphics Card (GPU)', 'Integrated Graphics (Ryzen 5 5600G)', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN91370689', 'MSN91370625', 'Electronics', 3, 'Available', '2026-04-14 01:58:33', '2026-04-14 01:58:33', NULL, 1095, 100, 'Low', 0, NULL),
(273, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96638712', 'MSN96638711', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(274, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96638987', 'MSN96638916', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(275, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96639045', 'MSN96639061', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(276, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96639188', 'MSN96639175', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(277, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96639231', 'MSN96639232', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(278, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96639433', 'MSN96639484', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(279, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96639530', 'MSN96639523', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(280, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96639573', 'MSN96639594', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(281, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96640044', 'MSN96640088', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(282, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96640410', 'MSN96640439', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(283, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96640527', 'MSN96640537', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(284, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96640691', 'MSN96640637', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(285, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96640724', 'MSN96640772', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(286, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96640840', 'MSN96640880', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(287, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96641018', 'MSN96641112', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(288, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96641212', 'MSN96641288', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(289, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96641641', 'MSN96641647', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(290, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96641884', 'MSN96641851', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(291, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96642074', 'MSN96642067', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(292, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96642219', 'MSN96642240', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(293, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96642382', 'MSN96642399', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(294, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96642518', 'MSN96642550', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(295, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96642652', 'MSN96642644', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(296, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96642636', 'MSN96642653', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(297, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96642768', 'MSN96642785', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(298, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96642871', 'MSN96642887', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(299, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96642835', 'MSN96642827', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(300, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96643149', 'MSN96643190', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(301, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96643323', 'MSN96643368', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(302, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96643583', 'MSN96643568', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(303, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96643780', 'MSN96643760', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(304, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96643812', 'MSN96643844', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(305, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96643954', 'MSN96643978', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(306, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96644112', 'MSN96644123', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(307, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96644261', 'MSN96644226', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(308, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96644448', 'MSN96644445', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(309, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96644430', 'MSN96644485', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(310, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96644571', 'MSN96644553', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(311, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96644638', 'MSN96644687', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(312, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96644868', 'MSN96644886', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(313, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96645083', 'MSN96645014', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(314, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96645063', 'MSN96645025', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(315, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96645136', 'MSN96645266', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(316, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96645313', 'MSN96645339', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(317, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96645344', 'MSN96645386', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(318, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96645447', 'MSN96645480', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(319, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96645516', 'MSN96645557', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(320, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96645514', 'MSN96645550', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(321, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96645622', 'MSN96645679', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(322, NULL, 'Power Supply (PSU)', '500W 80+ Bronze', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN96645674', 'MSN96645688', 'Electronics', 3, 'Available', '2026-04-14 01:59:26', '2026-04-14 01:59:26', NULL, 1825, 100, 'Low', 0, NULL),
(323, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25857453', 'MSN25857464', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(324, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25857619', 'MSN25857672', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(325, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25857755', 'MSN25857735', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(326, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25857863', 'MSN25857834', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(327, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25858022', 'MSN25858093', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(328, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25858240', 'MSN25858268', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(329, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25858378', 'MSN25858381', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(330, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25858452', 'MSN25858446', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(331, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25858593', 'MSN25858545', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(332, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25858678', 'MSN25858654', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(333, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25858765', 'MSN25858765', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(334, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25858878', 'MSN25858845', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(335, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25858919', 'MSN25858983', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(336, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25859028', 'MSN25859047', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(337, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25859118', 'MSN25859184', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(338, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25859211', 'MSN25859261', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(339, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25859215', 'MSN25859277', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(340, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25859337', 'MSN25859384', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(341, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25859499', 'MSN25859439', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(342, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25859437', 'MSN25859476', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(343, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25859564', 'MSN25859552', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(344, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25859679', 'MSN25859697', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(345, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25860013', 'MSN25860092', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(346, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25860170', 'MSN25860148', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(347, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25860372', 'MSN25860370', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(348, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25860536', 'MSN25860567', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(349, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25860667', 'MSN25860660', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(350, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25860825', 'MSN25860871', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(351, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25860923', 'MSN25860916', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(352, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25861063', 'MSN25861085', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(353, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25861124', 'MSN25861154', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(354, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25861261', 'MSN25861229', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(355, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25861352', 'MSN25861310', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(356, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25861691', 'MSN25861695', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(357, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25861970', 'MSN25861924', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(358, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25862041', 'MSN25862026', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(359, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25862141', 'MSN25862159', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(360, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25862220', 'MSN25862223', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(361, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25862398', 'MSN25862393', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(362, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25862410', 'MSN25862440', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(363, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25862558', 'MSN25862520', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(364, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25862565', 'MSN25862599', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(365, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25862644', 'MSN25862620', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(366, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25862747', 'MSN25862764', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(367, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25862885', 'MSN25862818', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(368, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25862964', 'MSN25862996', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(369, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25863187', 'MSN25863121', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(370, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25863381', 'MSN25863330', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(371, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25863481', 'MSN25863481', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(372, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25863519', 'MSN25863531', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(373, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25863799', 'MSN25863790', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(374, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25863858', 'MSN25863838', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(375, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25863935', 'MSN25863930', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(376, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25864012', 'MSN25864046', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(377, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25864038', 'MSN25864039', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(378, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25864129', 'MSN25864179', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(379, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25864295', 'MSN25864226', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(380, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25864391', 'MSN25864332', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(381, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25864331', 'MSN25864326', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(382, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25864546', 'MSN25864538', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(383, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25864714', 'MSN25864730', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(384, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25865074', 'MSN25865092', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(385, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25865189', 'MSN25865135', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(386, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25865372', 'MSN25865320', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(387, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25865482', 'MSN25865430', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(388, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25865551', 'MSN25865579', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(389, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25865611', 'MSN25865623', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(390, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25865722', 'MSN25865788', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(391, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25865848', 'MSN25865873', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(392, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25865942', 'MSN25865935', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(393, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25866052', 'MSN25866017', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(394, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25866266', 'MSN25866292', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(395, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25866864', 'MSN25866891', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(396, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25867043', 'MSN25867021', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(397, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25867660', 'MSN25867620', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(398, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25867918', 'MSN25867950', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(399, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25868319', 'MSN25868316', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(400, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25868821', 'MSN25868868', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(401, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25868925', 'MSN25868948', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(402, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25869011', 'MSN25869069', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(403, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25869134', 'MSN25869194', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(404, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25869287', 'MSN25869247', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(405, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25869346', 'MSN25869329', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(406, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25869359', 'MSN25869336', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(407, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25869414', 'MSN25869487', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(408, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25869530', 'MSN25869527', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(409, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25869546', 'MSN25869575', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(410, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25869952', 'MSN25869925', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(411, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25870281', 'MSN25870211', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(412, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25870313', 'MSN25870391', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(413, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25870494', 'MSN25870457', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(414, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25870551', 'MSN25870550', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(415, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25870646', 'MSN25870639', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(416, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25870625', 'MSN25870631', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(417, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25870722', 'MSN25870762', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(418, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25870871', 'MSN25870824', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(419, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25870914', 'MSN25870937', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(420, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25871074', 'MSN25871052', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(421, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25871198', 'MSN25871191', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(422, NULL, 'Mouse', 'a4Tech', 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN25871283', 'MSN25871292', '', 3, 'Available', '2026-04-14 02:04:18', '2026-04-14 02:04:18', NULL, 1825, 100, 'Low', 0, NULL),
(423, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28865980', 'MSN28865941', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(424, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28866155', 'MSN28866120', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(425, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28866329', 'MSN28866325', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(426, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28866555', 'MSN28866565', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(427, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28866758', 'MSN28866734', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(428, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28866859', 'MSN28866851', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(429, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28866915', 'MSN28866973', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(430, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28867076', 'MSN28867088', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(431, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28867162', 'MSN28867146', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(432, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28867235', 'MSN28867227', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(433, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28867318', 'MSN28867365', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(434, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28867420', 'MSN28867476', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(435, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28867454', 'MSN28867467', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(436, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28867535', 'MSN28867528', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(437, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28867699', 'MSN28867692', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(438, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28868158', 'MSN28868139', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(439, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28868494', 'MSN28868435', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(440, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28868571', 'MSN28868529', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(441, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28868664', 'MSN28868649', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(442, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28868897', 'MSN28868814', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(443, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28869046', 'MSN28869039', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(444, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28869140', 'MSN28869187', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(445, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28869249', 'MSN28869221', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(446, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28869485', 'MSN28869418', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(447, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28869974', 'MSN28869925', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(448, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28870012', 'MSN28870090', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(449, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28870210', 'MSN28870249', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(450, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28870393', 'MSN28870347', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(451, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28870490', 'MSN28870433', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(452, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28870547', 'MSN28870533', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(453, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28870625', 'MSN28870641', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(454, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28870638', 'MSN28870669', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(455, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28870740', 'MSN28870751', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(456, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28870812', 'MSN28870889', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(457, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28870927', 'MSN28870910', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(458, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28871411', 'MSN28871426', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(459, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28871682', 'MSN28871647', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(460, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28871929', 'MSN28871946', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(461, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28872073', 'MSN28872052', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(462, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28872187', 'MSN28872119', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(463, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28872223', 'MSN28872299', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(464, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28872397', 'MSN28872381', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(465, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28872489', 'MSN28872430', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(466, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28872493', 'MSN28872473', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(467, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28874275', 'MSN28874216', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(468, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28874647', 'MSN28874676', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(469, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28874795', 'MSN28874724', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(470, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28874855', 'MSN28874859', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(471, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28875069', 'MSN28875065', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(472, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28875152', 'MSN28875165', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(473, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28875275', 'MSN28875230', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(474, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28875388', 'MSN28875387', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(475, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28875389', 'MSN28875369', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(476, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28875418', 'MSN28875447', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(477, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28875526', 'MSN28875592', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(478, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28875651', 'MSN28875625', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(479, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28875758', 'MSN28875761', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(480, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28875827', 'MSN28875816', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(481, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28875988', 'MSN28875940', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(482, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28875974', 'MSN28875980', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(483, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28876340', 'MSN28876322', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(484, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28876438', 'MSN28876429', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL);
INSERT INTO `devices_full` (`accession_id`, `device_id`, `item_name`, `brand_model`, `quantity`, `acquisition_cost`, `date_acquired`, `accountable`, `serial_no`, `municipal_serial_no`, `device_type`, `department_id`, `status`, `created_at`, `updated_at`, `last_checked`, `maintenance_interval_days`, `health_score`, `risk_level`, `is_archived`, `deleted_at`) VALUES
(485, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28876532', 'MSN28876568', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(486, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28876613', 'MSN28876643', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(487, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28876737', 'MSN28876762', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(488, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28876863', 'MSN28876853', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(489, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28876910', 'MSN28876931', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(490, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28877049', 'MSN28877016', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(491, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28877120', 'MSN28877187', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(492, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28877222', 'MSN28877210', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(493, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28877370', 'MSN28877354', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(494, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28877329', 'MSN28877352', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(495, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28877493', 'MSN28877478', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(496, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28877523', 'MSN28877557', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(497, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28877519', 'MSN28877538', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(498, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28877912', 'MSN28877941', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(499, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28878046', 'MSN28878067', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(500, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28878212', 'MSN28878297', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(501, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28878392', 'MSN28878356', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(502, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28878462', 'MSN28878496', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(503, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28878426', 'MSN28878423', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(504, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28878539', 'MSN28878595', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(505, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28878668', 'MSN28878642', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(506, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28878766', 'MSN28878733', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(507, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28878730', 'MSN28878725', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(508, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28878887', 'MSN28878892', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(509, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28878973', 'MSN28878996', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(510, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28878930', 'MSN28878921', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(511, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28879025', 'MSN28879099', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(512, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28879118', 'MSN28879190', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(513, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28879484', 'MSN28879448', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(514, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28879633', 'MSN28879689', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(515, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28879831', 'MSN28879860', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(516, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28879992', 'MSN28879914', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(517, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28880083', 'MSN28880022', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(518, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28880157', 'MSN28880148', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(519, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28880329', 'MSN28880345', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(520, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28880387', 'MSN28880350', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(521, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28880425', 'MSN28880433', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL),
(522, NULL, 'Keyboard', 'a4Tech', 1, 0.00, '2026-04-15', 'Sir Aurum', 'SN28880511', 'MSN28880526', 'Electronics', 3, 'Available', '2026-04-14 02:04:48', '2026-04-14 02:04:48', NULL, 1825, 100, 'Low', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `devices_units`
--

CREATE TABLE `devices_units` (
  `accession_id` int(11) NOT NULL,
  `device_id` int(11) NOT NULL,
  `serial_number` varchar(100) DEFAULT NULL,
  `status` enum('Available','Borrowed','Damaged','Disposed') DEFAULT 'Available'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `devices_units`
--

INSERT INTO `devices_units` (`accession_id`, `device_id`, `serial_number`, `status`) VALUES
(1, 4, 'PRJ-001', 'Borrowed'),
(2, 4, 'PRJ-002', 'Available'),
(3, 4, 'PRJ-003', 'Available'),
(4, 4, 'PRJ-004', 'Borrowed'),
(5, 4, 'PRJ-005', 'Available'),
(6, 5, 'm2025', 'Available'),
(7, 5, NULL, 'Available'),
(8, 5, NULL, 'Available'),
(9, 5, NULL, 'Available'),
(10, 5, NULL, 'Available'),
(11, 5, NULL, 'Available'),
(12, 5, NULL, 'Available'),
(13, 5, NULL, 'Available'),
(14, 5, NULL, 'Available'),
(15, 5, NULL, 'Available'),
(16, 5, NULL, 'Available'),
(17, 5, NULL, 'Available'),
(18, 5, NULL, 'Available'),
(19, 5, NULL, 'Available'),
(20, 5, NULL, 'Available'),
(21, 5, NULL, 'Available'),
(22, 5, NULL, 'Available'),
(23, 5, NULL, 'Available'),
(24, 5, NULL, 'Available'),
(25, 5, NULL, 'Available'),
(26, 5, NULL, 'Available'),
(27, 5, NULL, 'Available'),
(28, 5, NULL, 'Available'),
(29, 5, NULL, 'Available'),
(30, 5, NULL, 'Available'),
(31, 5, NULL, 'Available'),
(32, 5, NULL, 'Available'),
(33, 5, NULL, 'Available'),
(34, 5, NULL, 'Available'),
(35, 6, 'M03', 'Available');

-- --------------------------------------------------------

--
-- Table structure for table `device_damage_reports`
--

CREATE TABLE `device_damage_reports` (
  `id` int(11) NOT NULL,
  `accession_id` int(11) DEFAULT NULL,
  `reported_by` varchar(255) DEFAULT NULL,
  `damage_type` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `date_reported` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `device_damage_reports`
--

INSERT INTO `device_damage_reports` (`id`, `accession_id`, `reported_by`, `damage_type`, `description`, `date_reported`) VALUES
(1, 40, 'System', 'General Damage', 'Bulk marked as damaged', '2026-03-20 16:05:59'),
(2, 40, 'System', 'General Damage', 'Bulk marked as damaged', '2026-03-21 03:02:34'),
(3, 40, 'System', 'General Damage', 'Bulk marked as damaged', '2026-03-23 05:37:54'),
(4, 55, 'System', 'General Damage', 'Bulk marked as damaged', '2026-03-31 10:28:50'),
(5, 56, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-02 19:22:44'),
(6, 55, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-02 19:26:40'),
(7, 56, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-02 22:39:24'),
(8, 57, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-04 12:00:24'),
(9, 55, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-06 15:57:56'),
(10, 55, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-06 16:34:57'),
(11, 57, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-08 22:36:58'),
(12, 57, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-08 22:44:38'),
(13, 57, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-08 22:47:32'),
(14, 56, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-08 23:17:45'),
(15, 56, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-08 23:42:25'),
(16, 48, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-12 13:25:52'),
(17, 48, 'System', 'General Damage', 'Bulk marked as damaged', '2026-04-12 13:37:57');

-- --------------------------------------------------------

--
-- Table structure for table `inventory_audit_log`
--

CREATE TABLE `inventory_audit_log` (
  `audit_id` bigint(20) UNSIGNED NOT NULL,
  `entity_type` enum('PC','DEVICE') NOT NULL,
  `entity_id` int(11) NOT NULL,
  `action` enum('CREATE','UPDATE','DELETE','SOFT_DELETE','RESTORE','BULK_UPDATE','STATUS_CHANGE','MAINTENANCE','CHECKED') NOT NULL,
  `field_name` varchar(100) DEFAULT NULL,
  `old_value` text DEFAULT NULL,
  `new_value` text DEFAULT NULL,
  `performed_by` int(11) NOT NULL,
  `performed_at` datetime NOT NULL DEFAULT current_timestamp(),
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory_audit_log`
--

INSERT INTO `inventory_audit_log` (`audit_id`, `entity_type`, `entity_id`, `action`, `field_name`, `old_value`, `new_value`, `performed_by`, `performed_at`, `ip_address`, `user_agent`) VALUES
(1, 'PC', 83, 'UPDATE', 'pcname', 'pc300', 'pc3001', 9, '2026-01-08 21:23:32', NULL, NULL),
(2, 'PC', 83, 'UPDATE', 'pcname', 'pc3001', 'pc30014', 9, '2026-01-08 21:25:21', NULL, NULL),
(3, 'PC', 84, 'UPDATE', 'maintenance_interval_days', '30', '1', 9, '2026-03-23 06:07:34', NULL, NULL),
(4, 'PC', 84, 'UPDATE', 'maintenance_interval_days', '1', '2', 9, '2026-03-23 06:07:42', NULL, NULL),
(5, 'PC', 84, 'UPDATE', 'maintenance_interval_days', '2', '3', 9, '2026-03-23 06:07:51', NULL, NULL),
(6, 'PC', 86, 'UPDATE', 'maintenance_interval_days', '1', '2', 9, '2026-03-25 22:28:19', NULL, NULL),
(7, 'PC', 105, 'UPDATE', 'status', 'Available', 'In Used', 9, '2026-04-02 22:59:01', NULL, NULL),
(8, 'PC', 105, 'UPDATE', 'status', 'In Used', 'Available', 9, '2026-04-02 22:59:13', NULL, NULL),
(9, 'PC', 20, 'UPDATE', 'pcname', 'pc-clb-20', 'pc-cla', 9, '2026-04-14 09:05:42', NULL, NULL),
(10, 'PC', 20, 'UPDATE', 'department_id', '29', '30', 9, '2026-04-14 09:05:42', NULL, NULL),
(11, 'PC', 20, 'UPDATE', 'location', 'Computer Lab B', NULL, 9, '2026-04-14 09:05:42', NULL, NULL),
(12, 'PC', 20, 'UPDATE', 'acquisition_cost', '35000.00', '35000', 9, '2026-04-14 09:05:42', NULL, NULL),
(13, 'PC', 20, 'UPDATE', 'date_acquired', '2026-04-13', '2026-04-14', 9, '2026-04-14 09:05:42', NULL, NULL),
(14, 'PC', 20, 'UPDATE', 'accountable', 'dean', 'Mindalita Ocampo-Cruz, DIT\'', 9, '2026-04-14 09:05:42', NULL, NULL),
(15, 'PC', 20, 'UPDATE', 'serial_no', 'SN-1776093550382-259759', 'SN-1776128688959-179303', 9, '2026-04-14 09:05:42', NULL, NULL),
(16, 'PC', 20, 'UPDATE', 'municipal_serial_no', 'MSN-1776093550382-918871', 'MSN-1776128688959-291507', 9, '2026-04-14 09:05:42', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `inventory_settings`
--

CREATE TABLE `inventory_settings` (
  `id` int(11) NOT NULL,
  `auto_check_days` int(11) NOT NULL DEFAULT 0,
  `enabled` tinyint(1) DEFAULT 1,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inventory_status_logs`
--

CREATE TABLE `inventory_status_logs` (
  `id` int(11) NOT NULL,
  `item_type` enum('PC','Device') DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `old_status` varchar(50) DEFAULT NULL,
  `new_status` varchar(50) DEFAULT NULL,
  `changed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `maintenance_history`
--

CREATE TABLE `maintenance_history` (
  `id` int(11) NOT NULL,
  `pcid` int(11) DEFAULT NULL,
  `asset_type` enum('PC','Device') NOT NULL,
  `asset_id` int(11) NOT NULL,
  `action` varchar(100) NOT NULL,
  `remarks` text DEFAULT NULL,
  `performed_by` varchar(255) DEFAULT NULL,
  `old_status` varchar(100) DEFAULT NULL,
  `new_status` varchar(100) DEFAULT NULL,
  `risk_level` varchar(20) DEFAULT NULL,
  `health_score` int(11) DEFAULT NULL,
  `performed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `maintenance_history`
--

INSERT INTO `maintenance_history` (`id`, `pcid`, `asset_type`, `asset_id`, `action`, `remarks`, `performed_by`, `old_status`, `new_status`, `risk_level`, `health_score`, `performed_at`) VALUES
(2, NULL, 'Device', 27, 'Manual inspection completed', 'Marked as checked manually', 'System', 'Needs Checking', 'Available', 'Low', 100, '2025-12-29 22:18:38'),
(5, NULL, 'Device', 27, 'Bulk status update', 'Bulk marked as Damaged', 'System', 'Available', 'Damaged', 'High', 40, '2025-12-30 22:21:37'),
(6, NULL, 'Device', 27, 'Bulk status update', 'Bulk marked as Available', 'System', 'Damaged', 'Available', 'Low', 100, '2025-12-30 22:22:02'),
(7, NULL, 'Device', 27, 'Bulk status update', 'Bulk marked as In Used', 'System', 'Available', 'In Used', 'Low', 100, '2025-12-30 22:22:08'),
(8, NULL, 'Device', 27, 'Manual inspection completed', 'Marked as checked manually', 'System', 'In Used', 'Available', 'Low', 100, '2026-01-08 12:52:49'),
(9, NULL, 'Device', 16, 'Manual inspection completed', 'Marked as checked manually', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-01-08 12:53:11'),
(10, 83, 'PC', 83, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-02-22 15:06:05'),
(17, 76, 'PC', 76, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-03-17 12:26:18'),
(18, 72, 'PC', 72, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-03-17 12:26:18'),
(20, 84, 'PC', 84, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-03-20 18:43:38'),
(21, 71, 'PC', 71, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-03-20 18:43:38'),
(22, 70, 'PC', 70, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-20 18:43:38'),
(24, 84, 'PC', 84, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-20 18:43:38'),
(25, 71, 'PC', 71, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-20 18:43:38'),
(26, 70, 'PC', 70, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-20 18:43:38'),
(28, 84, 'PC', 84, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-03-20 18:43:49'),
(29, 71, 'PC', 71, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-03-20 18:43:49'),
(30, 70, 'PC', 70, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-03-20 18:43:49'),
(32, 84, 'PC', 84, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-20 18:43:49'),
(33, 71, 'PC', 71, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-20 18:43:49'),
(34, 70, 'PC', 70, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-20 18:43:49'),
(37, NULL, 'Device', 40, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-03-20 19:02:27'),
(38, NULL, 'Device', 40, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-03-22 21:37:47'),
(39, NULL, 'Device', 40, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-03-22 21:39:38'),
(40, 71, 'PC', 71, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-29 03:54:35'),
(41, 86, 'PC', 86, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-29 03:55:00'),
(42, 85, 'PC', 85, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-29 03:55:00'),
(43, 84, 'PC', 84, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-29 03:55:00'),
(44, 86, 'PC', 86, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-03-29 03:55:17'),
(45, NULL, 'Device', 31, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-29 03:55:30'),
(46, NULL, 'Device', 32, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-29 03:55:30'),
(47, NULL, 'Device', 33, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-29 03:55:30'),
(48, NULL, 'Device', 34, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-29 03:55:30'),
(49, NULL, 'Device', 35, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-29 03:55:30'),
(50, NULL, 'Device', 36, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-29 03:55:30'),
(51, NULL, 'Device', 37, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-29 03:55:30'),
(52, NULL, 'Device', 38, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-29 03:55:30'),
(53, NULL, 'Device', 39, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-29 03:55:30'),
(54, 86, 'PC', 86, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-03-29 04:05:20'),
(55, 85, 'PC', 85, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-29 04:12:07'),
(56, 84, 'PC', 84, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-29 04:12:07'),
(57, NULL, 'Device', 47, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-29 14:53:56'),
(58, NULL, 'Device', 48, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-29 14:53:56'),
(59, NULL, 'Device', 49, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-29 14:53:56'),
(60, NULL, 'Device', 50, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-29 14:53:56'),
(61, NULL, 'Device', 51, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-29 14:53:56'),
(62, NULL, 'Device', 29, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-30 23:25:49'),
(63, NULL, 'Device', 30, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-30 23:25:49'),
(64, NULL, 'Device', 19, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-30 23:25:59'),
(65, NULL, 'Device', 20, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-30 23:25:59'),
(66, NULL, 'Device', 21, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-30 23:25:59'),
(67, NULL, 'Device', 22, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-30 23:25:59'),
(68, NULL, 'Device', 23, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-30 23:25:59'),
(69, NULL, 'Device', 24, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-30 23:25:59'),
(70, NULL, 'Device', 25, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-30 23:25:59'),
(71, NULL, 'Device', 26, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-30 23:25:59'),
(72, NULL, 'Device', 27, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-30 23:25:59'),
(73, NULL, 'Device', 28, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-30 23:25:59'),
(74, NULL, 'Device', 14, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-30 23:26:10'),
(75, NULL, 'Device', 15, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-30 23:26:10'),
(76, NULL, 'Device', 16, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-30 23:26:10'),
(77, NULL, 'Device', 17, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-30 23:26:10'),
(78, NULL, 'Device', 18, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-30 23:26:10'),
(79, 85, 'PC', 85, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-03-31 01:33:24'),
(80, 70, 'PC', 70, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-03-31 01:33:31'),
(81, NULL, 'Device', 55, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-31 02:28:33'),
(82, 71, 'PC', 71, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-03-31 05:23:04'),
(83, 85, 'PC', 85, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-03-31 05:23:53'),
(84, 85, 'PC', 85, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-03-31 05:24:43'),
(85, NULL, 'Device', 56, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-31 05:36:14'),
(86, 96, 'PC', 96, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-31 05:40:54'),
(87, 95, 'PC', 95, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-31 05:40:54'),
(88, 94, 'PC', 94, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-31 05:40:54'),
(89, 93, 'PC', 93, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-31 05:40:54'),
(90, 92, 'PC', 92, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-31 05:40:54'),
(91, 91, 'PC', 91, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-31 05:40:54'),
(92, 90, 'PC', 90, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-31 05:40:54'),
(93, 89, 'PC', 89, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-31 05:40:54'),
(94, 88, 'PC', 88, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-31 05:40:54'),
(95, 87, 'PC', 87, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-31 05:40:54'),
(96, 96, 'PC', 96, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-31 05:40:54'),
(97, 95, 'PC', 95, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-31 05:40:54'),
(98, 94, 'PC', 94, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-31 05:40:54'),
(99, 93, 'PC', 93, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-31 05:40:54'),
(100, 92, 'PC', 92, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-31 05:40:54'),
(101, 91, 'PC', 91, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-31 05:40:54'),
(102, 90, 'PC', 90, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-31 05:40:54'),
(103, 89, 'PC', 89, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-31 05:40:54'),
(104, 88, 'PC', 88, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-31 05:40:54'),
(105, 87, 'PC', 87, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-31 05:40:54'),
(106, 96, 'PC', 96, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-03-31 06:22:27'),
(107, 116, 'PC', 116, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-31 06:26:56'),
(108, 115, 'PC', 115, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-31 06:26:56'),
(109, 114, 'PC', 114, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-31 06:26:56'),
(110, 113, 'PC', 113, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-31 06:26:56'),
(111, 112, 'PC', 112, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-31 06:26:56'),
(112, 111, 'PC', 111, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-31 06:26:56'),
(113, 110, 'PC', 110, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-31 06:26:56'),
(114, 109, 'PC', 109, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-31 06:26:56'),
(115, 108, 'PC', 108, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-31 06:26:56'),
(116, 107, 'PC', 107, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-03-31 06:26:56'),
(117, 116, 'PC', 116, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-31 06:26:56'),
(118, 115, 'PC', 115, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-31 06:26:56'),
(119, 114, 'PC', 114, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-31 06:26:56'),
(120, 113, 'PC', 113, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-31 06:26:56'),
(121, 112, 'PC', 112, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-31 06:26:56'),
(122, 111, 'PC', 111, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-31 06:26:56'),
(123, 110, 'PC', 110, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-31 06:26:56'),
(124, 109, 'PC', 109, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-31 06:26:56'),
(125, 108, 'PC', 108, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-31 06:26:56'),
(126, 107, 'PC', 107, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-03-31 06:26:56'),
(127, NULL, 'Device', 55, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-01 15:17:08'),
(128, NULL, 'Device', 52, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-04-01 15:46:16'),
(129, 107, 'PC', 107, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 10:49:05'),
(130, 106, 'PC', 106, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-04-02 10:49:05'),
(131, 105, 'PC', 105, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-04-02 10:49:05'),
(132, 104, 'PC', 104, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-04-02 10:49:05'),
(133, 103, 'PC', 103, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-04-02 10:49:05'),
(134, 102, 'PC', 102, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-04-02 10:49:05'),
(135, 101, 'PC', 101, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-04-02 10:49:05'),
(136, 100, 'PC', 100, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-04-02 10:49:05'),
(137, 99, 'PC', 99, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-04-02 10:49:05'),
(138, 98, 'PC', 98, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-04-02 10:49:05'),
(139, 107, 'PC', 107, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 10:49:05'),
(140, 106, 'PC', 106, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 10:49:05'),
(141, 105, 'PC', 105, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 10:49:05'),
(142, 104, 'PC', 104, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 10:49:05'),
(143, 103, 'PC', 103, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 10:49:05'),
(144, 102, 'PC', 102, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 10:49:05'),
(145, 101, 'PC', 101, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 10:49:05'),
(146, 100, 'PC', 100, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 10:49:05'),
(147, 99, 'PC', 99, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 10:49:05'),
(148, 98, 'PC', 98, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 10:49:05'),
(149, 87, 'PC', 87, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 10:49:17'),
(150, 85, 'PC', 85, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 10:49:17'),
(151, 84, 'PC', 84, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-04-02 10:49:17'),
(152, 71, 'PC', 71, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 10:49:17'),
(153, 87, 'PC', 87, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 10:49:17'),
(154, 85, 'PC', 85, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 10:49:17'),
(155, 84, 'PC', 84, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 10:49:17'),
(156, 71, 'PC', 71, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 10:49:17'),
(157, 118, 'PC', 118, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 10:55:07'),
(158, 116, 'PC', 116, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-02 10:55:07'),
(159, 115, 'PC', 115, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 10:55:07'),
(160, 114, 'PC', 114, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 10:55:07'),
(161, 113, 'PC', 113, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 10:55:07'),
(162, 112, 'PC', 112, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 10:55:07'),
(163, 111, 'PC', 111, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 10:55:07'),
(164, 110, 'PC', 110, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 10:55:07'),
(165, 118, 'PC', 118, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-04-02 10:55:23'),
(166, 116, 'PC', 116, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-04-02 10:55:23'),
(167, 115, 'PC', 115, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-04-02 10:55:23'),
(168, 114, 'PC', 114, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-04-02 10:55:23'),
(169, 113, 'PC', 113, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-04-02 10:55:23'),
(170, 112, 'PC', 112, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-04-02 10:55:23'),
(171, 111, 'PC', 111, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-04-02 10:55:23'),
(172, 110, 'PC', 110, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-04-02 10:55:23'),
(173, 109, 'PC', 109, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-04-02 10:55:23'),
(174, 108, 'PC', 108, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-04-02 10:55:23'),
(175, NULL, 'Device', 55, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-02 11:28:34'),
(176, NULL, 'Device', 56, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-02 11:28:34'),
(177, 107, 'PC', 107, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 12:50:16'),
(178, 107, 'PC', 107, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-04-02 12:50:23'),
(179, 106, 'PC', 106, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-02 12:50:39'),
(180, 105, 'PC', 105, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 12:50:39'),
(181, 104, 'PC', 104, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 12:50:39'),
(182, 103, 'PC', 103, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 12:50:39'),
(183, 102, 'PC', 102, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 12:50:39'),
(184, 101, 'PC', 101, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 12:50:39'),
(185, 100, 'PC', 100, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 12:50:39'),
(186, 99, 'PC', 99, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 12:50:39'),
(187, 98, 'PC', 98, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 12:50:39'),
(188, 97, 'PC', 97, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Needs Checking', 'Available', 'Low', 100, '2026-04-02 12:50:39'),
(189, 106, 'PC', 106, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 12:50:39'),
(190, 105, 'PC', 105, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 12:50:39'),
(191, 104, 'PC', 104, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 12:50:39'),
(192, 103, 'PC', 103, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 12:50:39'),
(193, 102, 'PC', 102, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 12:50:39'),
(194, 101, 'PC', 101, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 12:50:39'),
(195, 100, 'PC', 100, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 12:50:39'),
(196, 99, 'PC', 99, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 12:50:39'),
(197, 98, 'PC', 98, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 12:50:39'),
(198, 97, 'PC', 97, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-02 12:50:39'),
(199, 105, 'PC', 105, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-02 13:22:02'),
(200, 106, 'PC', 106, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-02 14:15:19'),
(201, 106, 'PC', 106, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-02 14:19:30'),
(202, 106, 'PC', 106, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-02 14:20:59'),
(217, 70, 'PC', 70, 'Manual inspection completed', 'Backfilled from maintenance_logs on 2026-04-02', 'System', 'Needs Checking', 'Available', 'Low', NULL, '2025-12-27 10:16:56'),
(218, 71, 'PC', 71, 'Manual inspection completed', 'Backfilled from maintenance_logs on 2026-04-02', 'System', 'Needs Checking', 'Available', 'Low', NULL, '2025-12-27 19:28:15'),
(219, 72, 'PC', 72, 'Manual inspection completed', 'Backfilled from maintenance_logs on 2026-04-02', 'System', 'Needs Checking', 'Available', 'Low', NULL, '2025-12-27 19:30:20'),
(220, NULL, 'PC', 73, 'Manual inspection completed', 'Backfilled from maintenance_logs on 2026-04-02', 'System', 'Needs Checking', 'Available', 'Low', NULL, '2025-12-27 19:33:01'),
(221, NULL, 'PC', 75, 'Manual inspection completed', 'Backfilled from maintenance_logs on 2026-04-02', 'System', 'Needs Checking', 'Available', 'Low', NULL, '2025-12-27 19:40:41'),
(222, 76, 'PC', 76, 'Manual inspection completed', 'Backfilled from maintenance_logs on 2026-04-02', 'System', 'Needs Checking', 'Available', 'Low', NULL, '2025-12-27 19:53:27'),
(223, NULL, 'PC', 77, 'Manual inspection completed', 'Backfilled from maintenance_logs on 2026-04-02', 'System', 'Needs Checking', 'Available', 'Low', NULL, '2025-12-27 19:55:58'),
(224, NULL, 'PC', 78, 'Manual inspection completed', 'Backfilled from maintenance_logs on 2026-04-02', 'System', 'Needs Checking', 'Available', 'Low', NULL, '2025-12-27 19:56:29'),
(225, NULL, 'PC', 79, 'Manual inspection completed', 'Backfilled from maintenance_logs on 2026-04-02', 'System', 'Needs Checking', 'Available', 'Low', NULL, '2025-12-27 19:58:06'),
(226, NULL, 'PC', 80, 'Manual inspection completed', 'Backfilled from maintenance_logs on 2026-04-02', 'System', 'Needs Checking', 'Available', 'Low', NULL, '2025-12-29 22:45:47'),
(227, NULL, 'PC', 81, 'Bulk inspection completed', 'Backfilled from maintenance_logs on 2026-04-02', 'System', 'Available', 'Available', 'Low', NULL, '2025-12-30 22:18:04'),
(228, NULL, 'PC', 81, 'Bulk surrender', 'Backfilled from maintenance_logs on 2026-04-02', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-02-22 15:06:05'),
(229, NULL, 'PC', 80, 'Bulk inspection completed', 'Backfilled from maintenance_logs on 2026-04-02', 'System', 'Damaged', 'Available', 'Low', NULL, '2026-03-04 04:37:18'),
(230, NULL, 'PC', 79, 'Bulk inspection completed', 'Backfilled from maintenance_logs on 2026-04-02', 'System', 'Damaged', 'Available', 'Low', NULL, '2026-03-04 04:37:18'),
(231, NULL, 'PC', 75, 'Bulk inspection completed', 'Backfilled from maintenance_logs on 2026-04-02', 'System', 'Available', 'Available', 'Low', NULL, '2026-03-17 12:22:32'),
(232, NULL, 'PC', 75, 'Bulk inspection completed', 'Backfilled from maintenance_logs on 2026-04-02', 'System', 'Damaged', 'Available', 'Low', NULL, '2026-03-17 12:27:39'),
(233, NULL, 'PC', 69, 'Bulk inspection completed', 'Backfilled from maintenance_logs on 2026-04-02', 'System', 'Available', 'Available', 'Low', NULL, '2026-03-20 18:43:38'),
(234, NULL, 'PC', 69, 'Bulk inspection completed', 'Backfilled from maintenance_logs on 2026-04-02', 'System', 'Available', 'Available', 'Low', NULL, '2026-03-20 18:43:38'),
(235, NULL, 'PC', 69, 'Bulk inspection completed', 'Backfilled from maintenance_logs on 2026-04-02', 'System', 'Damaged', 'Available', 'Low', NULL, '2026-03-20 18:43:49'),
(236, NULL, 'PC', 69, 'Bulk inspection completed', 'Backfilled from maintenance_logs on 2026-04-02', 'System', 'Available', 'Available', 'Low', NULL, '2026-03-20 18:43:49'),
(237, 70, 'PC', 70, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Surrendered', 'Surrendered', 'Medium', 78, '2026-04-03 01:01:18'),
(238, 72, 'PC', 72, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Surrendered', 'Surrendered', 'High', 0, '2026-04-03 01:01:18'),
(239, 76, 'PC', 76, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Surrendered', 'Surrendered', 'High', 0, '2026-04-03 01:01:18'),
(240, 83, 'PC', 83, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Surrendered', 'Surrendered', 'Medium', 60, '2026-04-03 01:01:18'),
(241, 86, 'PC', 86, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Surrendered', 'Surrendered', 'High', 0, '2026-04-03 01:01:18'),
(242, 88, 'PC', 88, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Available', 'Available', 'Medium', 70, '2026-04-03 01:01:18'),
(243, 89, 'PC', 89, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Available', 'Available', 'Medium', 70, '2026-04-03 01:01:18'),
(244, 90, 'PC', 90, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Available', 'Available', 'Medium', 70, '2026-04-03 01:01:18'),
(245, 91, 'PC', 91, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Available', 'Available', 'Medium', 70, '2026-04-03 01:01:18'),
(246, 92, 'PC', 92, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Available', 'Available', 'Medium', 70, '2026-04-03 01:01:18'),
(247, 93, 'PC', 93, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Available', 'Available', 'Medium', 70, '2026-04-03 01:01:18'),
(248, 94, 'PC', 94, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Available', 'Available', 'Medium', 70, '2026-04-03 01:01:18'),
(249, 95, 'PC', 95, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Available', 'Available', 'Medium', 70, '2026-04-03 01:01:18'),
(250, 96, 'PC', 96, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Available', 'Available', 'Medium', 70, '2026-04-03 01:01:18'),
(251, 106, 'PC', 106, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Damaged', 'Damaged', 'High', 0, '2026-04-03 01:01:18'),
(252, 108, 'PC', 108, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Surrendered', 'Surrendered', 'Medium', 70, '2026-04-03 01:01:18'),
(253, 109, 'PC', 109, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Surrendered', 'Surrendered', 'Medium', 70, '2026-04-03 01:01:18'),
(254, NULL, 'Device', 56, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Damaged', 'Damaged', 'High', 0, '2026-04-03 01:01:18'),
(255, 106, 'PC', 106, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-03 02:44:22'),
(256, NULL, 'Device', 57, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Available', 'Available', 'Medium', 60, '2026-04-03 03:24:48'),
(257, 70, 'PC', 70, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Surrendered', 'Surrendered', 'Low', 100, '2026-04-03 05:44:49'),
(258, 72, 'PC', 72, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Surrendered', 'Surrendered', 'Low', 99, '2026-04-03 05:44:49'),
(259, 76, 'PC', 76, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Surrendered', 'Surrendered', 'Low', 99, '2026-04-03 05:44:49'),
(260, 83, 'PC', 83, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Surrendered', 'Surrendered', 'Low', 97, '2026-04-03 05:44:49'),
(261, 86, 'PC', 86, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Surrendered', 'Surrendered', 'Low', 99, '2026-04-03 05:44:49'),
(262, 88, 'PC', 88, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Available', 'Available', 'Low', 100, '2026-04-03 05:44:49'),
(263, 89, 'PC', 89, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Available', 'Available', 'Low', 100, '2026-04-03 05:44:49'),
(264, 90, 'PC', 90, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Available', 'Available', 'Low', 100, '2026-04-03 05:44:49'),
(265, 91, 'PC', 91, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Available', 'Available', 'Low', 100, '2026-04-03 05:44:49'),
(266, 92, 'PC', 92, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Available', 'Available', 'Low', 100, '2026-04-03 05:44:49'),
(267, 93, 'PC', 93, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Available', 'Available', 'Low', 100, '2026-04-03 05:44:49'),
(268, 94, 'PC', 94, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Available', 'Available', 'Low', 100, '2026-04-03 05:44:49'),
(269, 95, 'PC', 95, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Available', 'Available', 'Low', 100, '2026-04-03 05:44:49'),
(270, 96, 'PC', 96, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Available', 'Available', 'Low', 100, '2026-04-03 05:44:49'),
(271, 108, 'PC', 108, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Surrendered', 'Surrendered', 'Low', 100, '2026-04-03 05:44:49'),
(272, 109, 'PC', 109, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Surrendered', 'Surrendered', 'Low', 100, '2026-04-03 05:44:49'),
(273, NULL, 'Device', 57, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Available', 'Available', 'Low', 100, '2026-04-03 05:44:49'),
(274, NULL, 'Device', 57, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Damaged', 'Damaged', 'High', 0, '2026-04-03 07:03:39'),
(275, NULL, 'Device', 57, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-03 09:28:01'),
(276, 106, 'PC', 106, 'Bulk marked as damaged', 'Bulk marked as damaged', 'System', 'Available', 'Damaged', 'High', 100, '2026-04-03 15:23:03'),
(277, 106, 'PC', 106, 'Bulk marked as damaged', 'Bulk marked as damaged', 'System', 'Damaged', 'Damaged', 'High', 0, '2026-04-03 15:23:20'),
(278, 106, 'PC', 106, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-03 15:23:29'),
(279, NULL, 'Device', 57, 'Bulk marked as damaged', 'Bulk marked as damaged', 'System', 'Available', 'Damaged', 'High', 100, '2026-04-04 04:00:24'),
(280, 106, 'PC', 106, 'Bulk marked as damaged', 'Bulk marked as damaged', 'System', 'Available', 'Damaged', 'High', 100, '2026-04-04 04:00:46'),
(281, 106, 'PC', 106, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-04 04:04:39'),
(282, NULL, 'Device', 57, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-04 04:05:04'),
(283, 106, 'PC', 106, 'Bulk marked as damaged', 'Bulk marked as damaged', 'System', 'Available', 'Damaged', 'High', 100, '2026-04-06 05:16:03'),
(284, 106, 'PC', 106, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-06 05:16:16'),
(285, NULL, 'Device', 56, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-06 05:16:39'),
(286, NULL, 'Device', 56, 'Manual inspection completed', 'Marked as checked manually', 'System', 'Available', 'Available', 'Low', 100, '2026-04-06 07:57:46'),
(287, NULL, 'Device', 56, 'Manual inspection completed', 'Marked as checked manually', 'System', 'Available', 'Available', 'Low', 100, '2026-04-06 07:57:47'),
(288, NULL, 'Device', 56, 'Manual inspection completed', 'Marked as checked manually', 'System', 'Available', 'Available', 'Low', 100, '2026-04-06 07:57:48'),
(289, NULL, 'Device', 57, 'Manual inspection completed', 'Marked as checked manually', 'System', 'Available', 'Available', 'Low', 100, '2026-04-06 07:57:49'),
(290, NULL, 'Device', 55, 'Manual inspection completed', 'Marked as checked manually', 'System', 'Available', 'Available', 'Low', 100, '2026-04-06 07:57:51'),
(291, NULL, 'Device', 55, 'Bulk marked as damaged', 'Bulk marked as damaged', 'System', 'Available', 'Damaged', 'High', 100, '2026-04-06 07:57:56'),
(292, NULL, 'Device', 55, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-06 07:58:08'),
(293, 87, 'PC', 87, 'Bulk marked as damaged', 'Bulk marked as damaged', 'System', 'Available', 'Damaged', 'High', 100, '2026-04-06 08:07:46'),
(294, NULL, 'Device', 55, 'Bulk marked as damaged', 'Bulk marked as damaged', 'System', 'Available', 'Damaged', 'High', 100, '2026-04-06 08:34:57'),
(295, NULL, 'Device', 55, 'Bulk surrender', 'Bulk surrendered', 'System', 'Damaged', 'Surrendered', 'High', NULL, '2026-04-06 13:04:18'),
(296, NULL, 'Device', 55, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'High', NULL, '2026-04-06 13:04:35'),
(297, 121, 'PC', 121, 'Bulk marked as damaged', 'Bulk marked as damaged', 'System', 'Available', 'Damaged', 'High', 100, '2026-04-08 14:11:41'),
(298, 121, 'PC', 121, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-08 14:14:53'),
(299, 121, 'PC', 121, 'Bulk marked as damaged', 'Bulk marked as damaged', 'System', 'Available', 'Damaged', 'High', 100, '2026-04-08 14:20:00'),
(300, 121, 'PC', 121, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-08 14:21:05'),
(301, 121, 'PC', 121, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-08 14:22:58'),
(302, 121, 'PC', 121, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-08 14:28:49'),
(303, 121, 'PC', 121, 'Bulk marked as damaged', 'Bulk marked as damaged', 'System', 'Available', 'Damaged', 'High', 100, '2026-04-08 14:30:02'),
(304, 121, 'PC', 121, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-08 14:30:10'),
(305, NULL, 'Device', 57, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-08 14:30:21'),
(306, NULL, 'Device', 57, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-08 14:35:39'),
(307, NULL, 'Device', 57, 'Bulk marked as damaged', 'Bulk marked as damaged', 'System', 'Available', 'Damaged', 'High', 100, '2026-04-08 14:36:58'),
(308, NULL, 'Device', 57, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-08 14:37:05'),
(309, NULL, 'Device', 57, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-08 14:39:20'),
(310, NULL, 'Device', 57, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-08 14:43:52'),
(311, NULL, 'Device', 57, 'Bulk marked as damaged', 'Bulk marked as damaged', 'System', 'Available', 'Damaged', 'High', 100, '2026-04-08 14:44:38'),
(312, NULL, 'Device', 57, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-08 14:47:22'),
(313, NULL, 'Device', 57, 'Bulk marked as damaged', 'Bulk marked as damaged', 'System', 'Available', 'Damaged', 'High', 100, '2026-04-08 14:47:32'),
(314, NULL, 'Device', 57, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-08 14:59:33'),
(315, NULL, 'Device', 57, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-08 15:01:58'),
(316, 121, 'PC', 121, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-08 15:04:10'),
(317, NULL, 'Device', 57, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-08 15:04:53'),
(318, NULL, 'Device', 56, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-08 15:10:02'),
(319, NULL, 'Device', 57, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-08 15:10:02'),
(320, NULL, 'Device', 55, 'Auto Risk Update', 'Updated via Manage Inventory risk recalculation', 'System', 'Surrendered', 'Surrendered', 'Low', 100, '2026-04-08 15:10:10'),
(321, NULL, 'Device', 56, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-08 15:13:16'),
(322, NULL, 'Device', 56, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-08 15:17:17'),
(323, NULL, 'Device', 56, 'Bulk marked as damaged', 'Bulk marked as damaged', 'System', 'Available', 'Damaged', 'High', 100, '2026-04-08 15:17:45'),
(324, NULL, 'Device', 56, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-08 15:17:54'),
(325, NULL, 'Device', 56, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-08 15:20:40'),
(326, NULL, 'Device', 56, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-08 15:21:57'),
(327, NULL, 'Device', 57, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-08 15:24:33'),
(328, NULL, 'Device', 56, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-08 15:27:24'),
(329, 121, 'PC', 121, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-08 15:28:14'),
(330, NULL, 'Device', 56, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-08 15:29:04'),
(331, NULL, 'Device', 56, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-08 15:32:38'),
(332, NULL, 'Device', 56, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-08 15:34:25'),
(333, NULL, 'Device', 56, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-08 15:38:42'),
(334, NULL, 'Device', 56, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-08 15:42:16'),
(335, NULL, 'Device', 56, 'Bulk marked as damaged', 'Bulk marked as damaged', 'System', 'Available', 'Damaged', 'High', 100, '2026-04-08 15:42:25'),
(336, NULL, 'Device', 56, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-08 15:42:36'),
(337, 121, 'PC', 121, 'Bulk marked as damaged', 'Bulk marked as damaged', 'System', 'Available', 'Damaged', 'High', 100, '2026-04-08 15:44:43'),
(338, 121, 'PC', 121, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-08 15:44:52'),
(339, 103, 'PC', 103, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Available', 'Available', 'Low', 100, '2026-04-12 05:02:00'),
(340, 103, 'PC', 103, 'Bulk marked as damaged', 'Bulk marked as damaged', 'System', 'Available', 'Damaged', 'High', 100, '2026-04-12 05:11:16'),
(341, 103, 'PC', 103, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-12 05:11:51'),
(342, NULL, 'Device', 50, 'Bulk surrender', 'Bulk surrendered', 'System', 'Available', 'Surrendered', 'Low', NULL, '2026-04-12 05:25:16'),
(343, NULL, 'Device', 48, 'Bulk marked as damaged', 'Bulk marked as damaged', 'System', 'Available', 'Damaged', 'High', 100, '2026-04-12 05:25:52'),
(344, NULL, 'Device', 48, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-12 05:26:04'),
(345, NULL, 'Device', 48, 'Bulk marked as damaged', 'Bulk marked as damaged', 'System', 'Available', 'Damaged', 'High', 100, '2026-04-12 05:37:57'),
(346, NULL, 'Device', 48, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-12 05:38:05'),
(347, 101, 'PC', 101, 'Bulk surrender', 'Bulk surrendered', 'System', 'Available', 'Surrendered', 'Low', NULL, '2026-04-13 03:24:29'),
(348, 100, 'PC', 100, 'Bulk surrender', 'Bulk surrendered', 'System', 'Available', 'Surrendered', 'Low', NULL, '2026-04-13 03:24:37'),
(349, 87, 'PC', 87, 'Bulk inspection completed', 'Bulk marked as checked', 'System', 'Damaged', 'Available', 'Low', 100, '2026-04-13 03:34:40');

-- --------------------------------------------------------

--
-- Table structure for table `maintenance_history_backfill_20260402`
--

CREATE TABLE `maintenance_history_backfill_20260402` (
  `id` int(11) NOT NULL,
  `pcid` int(11) DEFAULT NULL,
  `asset_type` enum('PC','Device') NOT NULL,
  `asset_id` int(11) NOT NULL,
  `action` varchar(100) NOT NULL,
  `remarks` text DEFAULT NULL,
  `performed_by` varchar(255) DEFAULT NULL,
  `old_status` varchar(100) DEFAULT NULL,
  `new_status` varchar(100) DEFAULT NULL,
  `risk_level` varchar(20) DEFAULT NULL,
  `health_score` int(11) DEFAULT NULL,
  `performed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `maintenance_history_backfill_20260402`
--

INSERT INTO `maintenance_history_backfill_20260402` (`id`, `pcid`, `asset_type`, `asset_id`, `action`, `remarks`, `performed_by`, `old_status`, `new_status`, `risk_level`, `health_score`, `performed_at`) VALUES
(10, 83, 'PC', 83, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-02-22 15:06:05'),
(17, 76, 'PC', 76, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-03-17 12:26:18'),
(18, 72, 'PC', 72, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-03-17 12:26:18'),
(54, 86, 'PC', 86, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-03-29 04:05:20'),
(80, 70, 'PC', 70, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-03-31 01:33:31'),
(165, 118, 'PC', 118, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-04-02 10:55:23'),
(166, 116, 'PC', 116, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-04-02 10:55:23'),
(167, 115, 'PC', 115, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-04-02 10:55:23'),
(168, 114, 'PC', 114, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-04-02 10:55:23'),
(169, 113, 'PC', 113, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-04-02 10:55:23'),
(170, 112, 'PC', 112, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-04-02 10:55:23'),
(171, 111, 'PC', 111, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-04-02 10:55:23'),
(172, 110, 'PC', 110, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-04-02 10:55:23'),
(173, 109, 'PC', 109, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-04-02 10:55:23'),
(174, 108, 'PC', 108, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-04-02 10:55:23'),
(178, 107, 'PC', 107, 'Bulk surrender', 'Bulk surrendered', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-04-02 12:50:23'),
(228, NULL, 'PC', 81, 'Bulk surrender', 'Backfilled from maintenance_logs on 2026-04-02', 'System', 'Surrendered', 'Surrendered', 'Low', NULL, '2026-02-22 15:06:05');

-- --------------------------------------------------------

--
-- Table structure for table `maintenance_logs`
--

CREATE TABLE `maintenance_logs` (
  `id` int(11) NOT NULL,
  `asset_type` enum('PC','DEVICE') NOT NULL,
  `asset_id` int(11) NOT NULL,
  `previous_status` varchar(100) DEFAULT NULL,
  `new_status` varchar(100) DEFAULT NULL,
  `previous_risk_level` varchar(20) DEFAULT NULL,
  `new_risk_level` varchar(20) DEFAULT NULL,
  `action` varchar(255) NOT NULL,
  `performed_by` varchar(255) DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `performed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `maintenance_logs`
--

INSERT INTO `maintenance_logs` (`id`, `asset_type`, `asset_id`, `previous_status`, `new_status`, `previous_risk_level`, `new_risk_level`, `action`, `performed_by`, `remarks`, `performed_at`) VALUES
(1, 'PC', 70, 'Needs Checking', 'Available', 'Medium', 'Low', 'Manual inspection completed', NULL, NULL, '2025-12-27 10:16:56'),
(2, 'PC', 71, 'Needs Checking', 'Available', 'Medium', 'Low', 'Manual inspection completed', NULL, NULL, '2025-12-27 19:28:15'),
(3, 'PC', 72, 'Needs Checking', 'Available', 'Medium', 'Low', 'Manual inspection completed', NULL, NULL, '2025-12-27 19:30:20'),
(4, 'PC', 73, 'Needs Checking', 'Available', 'Medium', 'Low', 'Manual inspection completed', NULL, NULL, '2025-12-27 19:33:01'),
(5, 'PC', 75, 'Needs Checking', 'Available', 'Medium', 'Low', 'Manual inspection completed', NULL, NULL, '2025-12-27 19:40:41'),
(6, 'PC', 76, 'Needs Checking', 'Available', 'Medium', 'Low', 'Manual inspection completed', NULL, NULL, '2025-12-27 19:53:27'),
(7, 'PC', 77, 'Needs Checking', 'Available', 'Medium', 'Low', 'Manual inspection completed', NULL, NULL, '2025-12-27 19:55:58'),
(8, 'PC', 78, 'Needs Checking', 'Available', 'Medium', 'Low', 'Manual inspection completed', NULL, NULL, '2025-12-27 19:56:29'),
(9, 'PC', 79, 'Needs Checking', 'Available', 'Medium', 'Low', 'Manual inspection completed', NULL, NULL, '2025-12-27 19:58:06'),
(12, 'DEVICE', 27, 'Needs Checking', 'Available', 'Medium', 'Low', 'Manual inspection completed', NULL, NULL, '2025-12-29 22:18:38'),
(13, 'PC', 80, 'Needs Checking', 'Available', 'Medium', 'Low', 'Manual inspection completed', NULL, NULL, '2025-12-29 22:45:47'),
(14, 'PC', 81, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2025-12-30 22:18:04'),
(15, 'DEVICE', 27, 'Available', 'Damaged', 'Low', 'High', 'Bulk status update', NULL, NULL, '2025-12-30 22:21:37'),
(16, 'DEVICE', 27, 'Damaged', 'Available', 'High', 'Low', 'Bulk status update', NULL, NULL, '2025-12-30 22:22:02'),
(17, 'DEVICE', 27, 'Available', 'In Used', 'Low', 'Low', 'Bulk status update', NULL, NULL, '2025-12-30 22:22:08'),
(18, 'DEVICE', 27, 'In Used', 'Available', 'Low', 'Low', 'Manual inspection completed', NULL, NULL, '2026-01-08 12:52:49'),
(19, 'DEVICE', 16, 'Needs Checking', 'Available', 'Medium', 'Low', 'Manual inspection completed', NULL, NULL, '2026-01-08 12:53:11'),
(20, 'PC', 83, 'Surrendered', 'Surrendered', 'Low', 'Low', 'Bulk surrender', NULL, NULL, '2026-02-22 15:06:05'),
(21, 'PC', 81, 'Surrendered', 'Surrendered', 'Low', 'Low', 'Bulk surrender', NULL, NULL, '2026-02-22 15:06:05'),
(24, 'PC', 80, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-04 04:37:18'),
(25, 'PC', 79, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-04 04:37:18'),
(26, 'PC', 75, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-17 12:22:32'),
(27, 'PC', 76, 'Surrendered', 'Surrendered', 'Low', 'Low', 'Bulk surrender', NULL, NULL, '2026-03-17 12:26:18'),
(28, 'PC', 72, 'Surrendered', 'Surrendered', 'Low', 'Low', 'Bulk surrender', NULL, NULL, '2026-03-17 12:26:18'),
(29, 'PC', 75, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-17 12:27:39'),
(30, 'PC', 84, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-20 18:43:38'),
(31, 'PC', 71, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-20 18:43:38'),
(32, 'PC', 70, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-20 18:43:38'),
(33, 'PC', 69, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-20 18:43:38'),
(34, 'PC', 84, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-20 18:43:38'),
(35, 'PC', 71, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-20 18:43:38'),
(36, 'PC', 70, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-20 18:43:38'),
(37, 'PC', 69, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-20 18:43:38'),
(38, 'PC', 84, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-20 18:43:49'),
(39, 'PC', 71, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-20 18:43:49'),
(40, 'PC', 70, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-20 18:43:49'),
(41, 'PC', 69, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-20 18:43:49'),
(42, 'PC', 84, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-20 18:43:49'),
(43, 'PC', 71, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-20 18:43:49'),
(44, 'PC', 70, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-20 18:43:49'),
(45, 'PC', 69, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-20 18:43:49'),
(55, 'DEVICE', 40, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-20 19:02:27'),
(56, 'DEVICE', 40, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-22 21:37:47'),
(57, 'DEVICE', 40, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-22 21:39:38'),
(58, 'PC', 71, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-29 03:54:35'),
(59, 'PC', 86, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-29 03:55:00'),
(60, 'PC', 85, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-29 03:55:00'),
(61, 'PC', 84, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-29 03:55:00'),
(62, 'PC', 86, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-29 03:55:17'),
(63, 'DEVICE', 31, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-29 03:55:30'),
(64, 'DEVICE', 32, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-29 03:55:30'),
(65, 'DEVICE', 33, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-29 03:55:30'),
(66, 'DEVICE', 34, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-29 03:55:30'),
(67, 'DEVICE', 35, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-29 03:55:30'),
(68, 'DEVICE', 36, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-29 03:55:30'),
(69, 'DEVICE', 37, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-29 03:55:30'),
(70, 'DEVICE', 38, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-29 03:55:30'),
(71, 'DEVICE', 39, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-29 03:55:30'),
(72, 'PC', 86, 'Surrendered', 'Surrendered', 'Low', 'Low', 'Bulk surrender', NULL, NULL, '2026-03-29 04:05:20'),
(73, 'PC', 85, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-29 04:12:07'),
(74, 'PC', 84, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-29 04:12:07'),
(75, 'DEVICE', 47, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-29 14:53:56'),
(76, 'DEVICE', 48, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-29 14:53:56'),
(77, 'DEVICE', 49, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-29 14:53:56'),
(78, 'DEVICE', 50, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-29 14:53:56'),
(79, 'DEVICE', 51, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-29 14:53:56'),
(80, 'DEVICE', 29, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-30 23:25:49'),
(81, 'DEVICE', 30, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-30 23:25:49'),
(82, 'DEVICE', 19, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-30 23:25:59'),
(83, 'DEVICE', 20, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-30 23:25:59'),
(84, 'DEVICE', 21, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-30 23:25:59'),
(85, 'DEVICE', 22, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-30 23:25:59'),
(86, 'DEVICE', 23, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-30 23:25:59'),
(87, 'DEVICE', 24, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-30 23:25:59'),
(88, 'DEVICE', 25, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-30 23:25:59'),
(89, 'DEVICE', 26, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-30 23:25:59'),
(90, 'DEVICE', 27, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-30 23:25:59'),
(91, 'DEVICE', 28, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-30 23:25:59'),
(92, 'DEVICE', 14, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-30 23:26:10'),
(93, 'DEVICE', 15, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-30 23:26:10'),
(94, 'DEVICE', 16, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-30 23:26:10'),
(95, 'DEVICE', 17, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-30 23:26:10'),
(96, 'DEVICE', 18, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-30 23:26:10'),
(97, 'PC', 85, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 01:33:24'),
(98, 'PC', 70, 'Surrendered', 'Surrendered', 'Low', 'Low', 'Bulk surrender', NULL, NULL, '2026-03-31 01:33:31'),
(99, 'DEVICE', 55, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 02:28:33'),
(100, 'PC', 71, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 05:23:04'),
(101, 'PC', 85, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 05:23:53'),
(102, 'PC', 85, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 05:24:43'),
(103, 'DEVICE', 56, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 05:36:14'),
(104, 'PC', 96, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 05:40:54'),
(105, 'PC', 95, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 05:40:54'),
(106, 'PC', 94, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 05:40:54'),
(107, 'PC', 93, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 05:40:54'),
(108, 'PC', 92, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 05:40:54'),
(109, 'PC', 91, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 05:40:54'),
(110, 'PC', 90, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 05:40:54'),
(111, 'PC', 89, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 05:40:54'),
(112, 'PC', 88, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 05:40:54'),
(113, 'PC', 87, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 05:40:54'),
(114, 'PC', 96, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 05:40:54'),
(115, 'PC', 95, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 05:40:54'),
(116, 'PC', 94, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 05:40:54'),
(117, 'PC', 93, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 05:40:54'),
(118, 'PC', 92, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 05:40:54'),
(119, 'PC', 91, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 05:40:54'),
(120, 'PC', 90, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 05:40:54'),
(121, 'PC', 89, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 05:40:54'),
(122, 'PC', 88, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 05:40:54'),
(123, 'PC', 87, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 05:40:54'),
(124, 'PC', 96, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 06:22:27'),
(125, 'PC', 116, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 06:26:56'),
(126, 'PC', 115, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 06:26:56'),
(127, 'PC', 114, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 06:26:56'),
(128, 'PC', 113, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 06:26:56'),
(129, 'PC', 112, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 06:26:56'),
(130, 'PC', 111, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 06:26:56'),
(131, 'PC', 110, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 06:26:56'),
(132, 'PC', 109, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 06:26:56'),
(133, 'PC', 108, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 06:26:56'),
(134, 'PC', 107, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 06:26:56'),
(135, 'PC', 116, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 06:26:56'),
(136, 'PC', 115, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 06:26:56'),
(137, 'PC', 114, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 06:26:56'),
(138, 'PC', 113, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 06:26:56'),
(139, 'PC', 112, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 06:26:56'),
(140, 'PC', 111, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 06:26:56'),
(141, 'PC', 110, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 06:26:56'),
(142, 'PC', 109, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 06:26:56'),
(143, 'PC', 108, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 06:26:56'),
(144, 'PC', 107, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-03-31 06:26:56'),
(145, 'DEVICE', 55, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-01 15:17:08'),
(146, 'DEVICE', 52, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-01 15:46:16'),
(147, 'PC', 107, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:05'),
(148, 'PC', 106, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:05'),
(149, 'PC', 105, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:05'),
(150, 'PC', 104, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:05'),
(151, 'PC', 103, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:05'),
(152, 'PC', 102, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:05'),
(153, 'PC', 101, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:05'),
(154, 'PC', 100, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:05'),
(155, 'PC', 99, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:05'),
(156, 'PC', 98, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:05'),
(157, 'PC', 107, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:05'),
(158, 'PC', 106, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:05'),
(159, 'PC', 105, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:05'),
(160, 'PC', 104, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:05'),
(161, 'PC', 103, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:05'),
(162, 'PC', 102, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:05'),
(163, 'PC', 101, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:05'),
(164, 'PC', 100, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:05'),
(165, 'PC', 99, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:05'),
(166, 'PC', 98, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:05'),
(167, 'PC', 87, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:17'),
(168, 'PC', 85, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:17'),
(169, 'PC', 84, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:17'),
(170, 'PC', 71, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:17'),
(171, 'PC', 87, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:17'),
(172, 'PC', 85, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:17'),
(173, 'PC', 84, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:17'),
(174, 'PC', 71, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:49:17'),
(175, 'PC', 118, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:55:07'),
(176, 'PC', 116, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:55:07'),
(177, 'PC', 115, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:55:07'),
(178, 'PC', 114, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:55:07'),
(179, 'PC', 113, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:55:07'),
(180, 'PC', 112, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:55:07'),
(181, 'PC', 111, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:55:07'),
(182, 'PC', 110, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 10:55:07'),
(183, 'PC', 118, 'Surrendered', 'Surrendered', 'Low', 'Low', 'Bulk surrender', NULL, NULL, '2026-04-02 10:55:23'),
(184, 'PC', 116, 'Surrendered', 'Surrendered', 'Low', 'Low', 'Bulk surrender', NULL, NULL, '2026-04-02 10:55:23'),
(185, 'PC', 115, 'Surrendered', 'Surrendered', 'Low', 'Low', 'Bulk surrender', NULL, NULL, '2026-04-02 10:55:23'),
(186, 'PC', 114, 'Surrendered', 'Surrendered', 'Low', 'Low', 'Bulk surrender', NULL, NULL, '2026-04-02 10:55:23'),
(187, 'PC', 113, 'Surrendered', 'Surrendered', 'Low', 'Low', 'Bulk surrender', NULL, NULL, '2026-04-02 10:55:23'),
(188, 'PC', 112, 'Surrendered', 'Surrendered', 'Low', 'Low', 'Bulk surrender', NULL, NULL, '2026-04-02 10:55:23'),
(189, 'PC', 111, 'Surrendered', 'Surrendered', 'Low', 'Low', 'Bulk surrender', NULL, NULL, '2026-04-02 10:55:23'),
(190, 'PC', 110, 'Surrendered', 'Surrendered', 'Low', 'Low', 'Bulk surrender', NULL, NULL, '2026-04-02 10:55:23'),
(191, 'PC', 109, 'Surrendered', 'Surrendered', 'Low', 'Low', 'Bulk surrender', NULL, NULL, '2026-04-02 10:55:23'),
(192, 'PC', 108, 'Surrendered', 'Surrendered', 'Low', 'Low', 'Bulk surrender', NULL, NULL, '2026-04-02 10:55:23'),
(193, 'DEVICE', 55, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 11:28:34'),
(194, 'DEVICE', 56, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 11:28:34'),
(195, 'PC', 107, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 12:50:16'),
(196, 'PC', 107, 'Surrendered', 'Surrendered', 'Low', 'Low', 'Bulk surrender', NULL, NULL, '2026-04-02 12:50:23'),
(197, 'PC', 106, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 12:50:39'),
(198, 'PC', 105, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 12:50:39'),
(199, 'PC', 104, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 12:50:39'),
(200, 'PC', 103, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 12:50:39'),
(201, 'PC', 102, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 12:50:39'),
(202, 'PC', 101, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 12:50:39'),
(203, 'PC', 100, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 12:50:39'),
(204, 'PC', 99, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 12:50:39'),
(205, 'PC', 98, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 12:50:39'),
(206, 'PC', 97, 'Needs Checking', 'Available', 'Medium', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 12:50:39'),
(207, 'PC', 106, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 12:50:39'),
(208, 'PC', 105, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 12:50:39'),
(209, 'PC', 104, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 12:50:39'),
(210, 'PC', 103, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 12:50:39'),
(211, 'PC', 102, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 12:50:39'),
(212, 'PC', 101, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 12:50:39'),
(213, 'PC', 100, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 12:50:39'),
(214, 'PC', 99, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 12:50:39'),
(215, 'PC', 98, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 12:50:39'),
(216, 'PC', 97, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 12:50:39'),
(217, 'PC', 105, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 13:22:02'),
(218, 'PC', 106, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 14:15:19'),
(219, 'PC', 106, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 14:19:30'),
(220, 'PC', 106, 'Damaged', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-02 14:20:59'),
(221, 'PC', 106, 'Damaged', 'Available', 'High', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-03 02:44:22'),
(222, 'DEVICE', 57, 'Damaged', 'Available', 'High', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-03 09:28:01'),
(223, 'PC', 106, 'Available', 'Damaged', 'Low', 'High', 'Bulk marked as damaged', NULL, NULL, '2026-04-03 15:23:03'),
(224, 'PC', 106, 'Damaged', 'Damaged', 'High', 'High', 'Bulk marked as damaged', NULL, NULL, '2026-04-03 15:23:20'),
(225, 'PC', 106, 'Damaged', 'Available', 'High', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-03 15:23:29'),
(226, 'DEVICE', 57, 'Available', 'Damaged', 'Low', 'High', 'Bulk marked as damaged', NULL, NULL, '2026-04-04 04:00:24'),
(227, 'PC', 106, 'Available', 'Damaged', 'Low', 'High', 'Bulk marked as damaged', NULL, NULL, '2026-04-04 04:00:46'),
(228, 'PC', 106, 'Damaged', 'Available', 'High', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-04 04:04:39'),
(229, 'DEVICE', 57, 'Damaged', 'Available', 'High', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-04 04:05:04'),
(230, 'PC', 106, 'Available', 'Damaged', 'Low', 'High', 'Bulk marked as damaged', NULL, NULL, '2026-04-06 05:16:03'),
(231, 'PC', 106, 'Damaged', 'Available', 'High', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-06 05:16:16'),
(232, 'DEVICE', 56, 'Damaged', 'Available', 'High', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-06 05:16:39'),
(233, 'DEVICE', 56, 'Available', 'Available', 'Low', 'Low', 'Manual inspection completed', NULL, NULL, '2026-04-06 07:57:46'),
(234, 'DEVICE', 56, 'Available', 'Available', 'Low', 'Low', 'Manual inspection completed', NULL, NULL, '2026-04-06 07:57:47'),
(235, 'DEVICE', 56, 'Available', 'Available', 'Low', 'Low', 'Manual inspection completed', NULL, NULL, '2026-04-06 07:57:48'),
(236, 'DEVICE', 57, 'Available', 'Available', 'Low', 'Low', 'Manual inspection completed', NULL, NULL, '2026-04-06 07:57:49'),
(237, 'DEVICE', 55, 'Available', 'Available', 'Low', 'Low', 'Manual inspection completed', NULL, NULL, '2026-04-06 07:57:51'),
(238, 'DEVICE', 55, 'Available', 'Damaged', 'Low', 'High', 'Bulk marked as damaged', NULL, NULL, '2026-04-06 07:57:56'),
(239, 'DEVICE', 55, 'Damaged', 'Available', 'High', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-06 07:58:08'),
(240, 'PC', 87, 'Available', 'Damaged', 'Low', 'High', 'Bulk marked as damaged', NULL, NULL, '2026-04-06 08:07:46'),
(241, 'DEVICE', 55, 'Available', 'Damaged', 'Low', 'High', 'Bulk marked as damaged', NULL, NULL, '2026-04-06 08:34:57'),
(242, 'DEVICE', 55, 'Damaged', 'Surrendered', 'High', 'High', 'Bulk surrender', NULL, NULL, '2026-04-06 13:04:18'),
(243, 'DEVICE', 55, 'Surrendered', 'Surrendered', 'High', 'High', 'Bulk surrender', NULL, NULL, '2026-04-06 13:04:35'),
(244, 'PC', 121, 'Available', 'Damaged', 'Low', 'High', 'Bulk marked as damaged', NULL, NULL, '2026-04-08 14:11:41'),
(245, 'PC', 121, 'Damaged', 'Available', 'High', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 14:14:53'),
(246, 'PC', 121, 'Available', 'Damaged', 'Low', 'High', 'Bulk marked as damaged', NULL, NULL, '2026-04-08 14:20:00'),
(247, 'PC', 121, 'Damaged', 'Available', 'High', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 14:21:05'),
(248, 'PC', 121, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 14:22:58'),
(249, 'PC', 121, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 14:28:49'),
(250, 'PC', 121, 'Available', 'Damaged', 'Low', 'High', 'Bulk marked as damaged', NULL, NULL, '2026-04-08 14:30:02'),
(251, 'PC', 121, 'Damaged', 'Available', 'High', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 14:30:10'),
(252, 'DEVICE', 57, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 14:30:21'),
(253, 'DEVICE', 57, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 14:35:39'),
(254, 'DEVICE', 57, 'Available', 'Damaged', 'Low', 'High', 'Bulk marked as damaged', NULL, NULL, '2026-04-08 14:36:58'),
(255, 'DEVICE', 57, 'Damaged', 'Available', 'High', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 14:37:05'),
(256, 'DEVICE', 57, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 14:39:20'),
(257, 'DEVICE', 57, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 14:43:52'),
(258, 'DEVICE', 57, 'Available', 'Damaged', 'Low', 'High', 'Bulk marked as damaged', NULL, NULL, '2026-04-08 14:44:38'),
(259, 'DEVICE', 57, 'Damaged', 'Available', 'High', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 14:47:22'),
(260, 'DEVICE', 57, 'Available', 'Damaged', 'Low', 'High', 'Bulk marked as damaged', NULL, NULL, '2026-04-08 14:47:32'),
(261, 'DEVICE', 57, 'Damaged', 'Available', 'High', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 14:59:33'),
(262, 'DEVICE', 57, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 15:01:58'),
(263, 'PC', 121, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 15:04:10'),
(264, 'DEVICE', 57, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 15:04:53'),
(265, 'DEVICE', 56, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 15:10:02'),
(266, 'DEVICE', 57, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 15:10:02'),
(267, 'DEVICE', 56, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 15:13:16'),
(268, 'DEVICE', 56, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 15:17:17'),
(269, 'DEVICE', 56, 'Available', 'Damaged', 'Low', 'High', 'Bulk marked as damaged', NULL, NULL, '2026-04-08 15:17:45'),
(270, 'DEVICE', 56, 'Damaged', 'Available', 'High', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 15:17:54'),
(271, 'DEVICE', 56, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 15:20:40'),
(272, 'DEVICE', 56, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 15:21:57'),
(273, 'DEVICE', 57, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 15:24:33'),
(274, 'DEVICE', 56, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 15:27:24'),
(275, 'PC', 121, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 15:28:14'),
(276, 'DEVICE', 56, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 15:29:04'),
(277, 'DEVICE', 56, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 15:32:37'),
(278, 'DEVICE', 56, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 15:34:25'),
(279, 'DEVICE', 56, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 15:38:42'),
(280, 'DEVICE', 56, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 15:42:16'),
(281, 'DEVICE', 56, 'Available', 'Damaged', 'Low', 'High', 'Bulk marked as damaged', NULL, NULL, '2026-04-08 15:42:25'),
(282, 'DEVICE', 56, 'Damaged', 'Available', 'High', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 15:42:36'),
(283, 'PC', 121, 'Available', 'Damaged', 'Low', 'High', 'Bulk marked as damaged', NULL, NULL, '2026-04-08 15:44:43'),
(284, 'PC', 121, 'Damaged', 'Available', 'High', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-08 15:44:52'),
(285, 'PC', 103, 'Available', 'Available', 'Low', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-12 05:02:00'),
(286, 'PC', 103, 'Available', 'Damaged', 'Low', 'High', 'Bulk marked as damaged', NULL, NULL, '2026-04-12 05:11:16'),
(287, 'PC', 103, 'Damaged', 'Available', 'High', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-12 05:11:51'),
(288, 'DEVICE', 50, 'Available', 'Surrendered', 'Low', 'Low', 'Bulk surrender', NULL, NULL, '2026-04-12 05:25:16'),
(289, 'DEVICE', 48, 'Available', 'Damaged', 'Low', 'High', 'Bulk marked as damaged', NULL, NULL, '2026-04-12 05:25:52'),
(290, 'DEVICE', 48, 'Damaged', 'Available', 'High', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-12 05:26:04'),
(291, 'DEVICE', 48, 'Available', 'Damaged', 'Low', 'High', 'Bulk marked as damaged', NULL, NULL, '2026-04-12 05:37:57'),
(292, 'DEVICE', 48, 'Damaged', 'Available', 'High', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-12 05:38:05'),
(293, 'PC', 101, 'Available', 'Surrendered', 'Low', 'Low', 'Bulk surrender', NULL, NULL, '2026-04-13 03:24:29'),
(294, 'PC', 100, 'Available', 'Surrendered', 'Low', 'Low', 'Bulk surrender', NULL, NULL, '2026-04-13 03:24:37'),
(295, 'PC', 87, 'Damaged', 'Available', 'High', 'Low', 'Bulk inspection completed', NULL, NULL, '2026-04-13 03:34:40');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `action` varchar(255) NOT NULL,
  `target_type` varchar(50) DEFAULT NULL,
  `target_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `action`, `target_type`, `target_id`, `created_at`) VALUES
(1, 9, 'Added new PC: PC1333 (Serial: SN-0000051)', 'PC', 0, '2025-10-21 19:21:18'),
(2, 9, 'Added new PC: pc418pm (Serial: SN-000001f24)', 'PC', 0, '2025-10-23 08:18:17');

-- --------------------------------------------------------

--
-- Table structure for table `pcinfofull`
--

CREATE TABLE `pcinfofull` (
  `pcid` int(11) NOT NULL,
  `pcname` varchar(255) NOT NULL,
  `department_id` int(11) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `acquisition_cost` decimal(12,2) DEFAULT NULL,
  `date_acquired` date DEFAULT NULL,
  `accountable` varchar(255) DEFAULT NULL,
  `serial_no` varchar(255) NOT NULL,
  `municipal_serial_no` varchar(255) DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `monitor` varchar(255) DEFAULT NULL,
  `motherboard` varchar(255) DEFAULT NULL,
  `ram` varchar(255) DEFAULT NULL,
  `storage` varchar(255) DEFAULT NULL,
  `gpu` varchar(255) DEFAULT NULL,
  `psu` varchar(255) DEFAULT NULL,
  `casing` varchar(255) DEFAULT NULL,
  `other_parts` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `last_checked` date DEFAULT NULL,
  `maintenance_interval_days` int(11) DEFAULT 30,
  `health_score` int(11) DEFAULT 100,
  `risk_level` varchar(20) DEFAULT 'Low',
  `is_archived` tinyint(1) DEFAULT 0,
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pcinfofull`
--

INSERT INTO `pcinfofull` (`pcid`, `pcname`, `department_id`, `location`, `quantity`, `acquisition_cost`, `date_acquired`, `accountable`, `serial_no`, `municipal_serial_no`, `status`, `note`, `monitor`, `motherboard`, `ram`, `storage`, `gpu`, `psu`, `casing`, `other_parts`, `created_at`, `updated_at`, `last_checked`, `maintenance_interval_days`, `health_score`, `risk_level`, `is_archived`, `deleted_at`) VALUES
(1, 'pc-clb-01', 29, 'Computer Lab B', 1, 35000.00, '2026-04-13', 'dean', 'SN-1776093550372-490436', 'MSN-1776093550372-787857', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-13 15:19:10', '2026-04-13 15:19:10', '2026-04-13', 1825, 100, 'Low', 0, NULL),
(2, 'pc-clb-02', 29, 'Computer Lab B', 1, 35000.00, '2026-04-13', 'dean', 'SN-1776093550374-799561', 'MSN-1776093550374-250363', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-13 15:19:10', '2026-04-13 15:19:10', '2026-04-13', 1825, 100, 'Low', 0, NULL),
(3, 'pc-clb-03', 29, 'Computer Lab B', 1, 35000.00, '2026-04-13', 'dean', 'SN-1776093550374-472134', 'MSN-1776093550374-325154', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-13 15:19:10', '2026-04-13 15:19:10', '2026-04-13', 1825, 100, 'Low', 0, NULL),
(4, 'pc-clb-04', 29, 'Computer Lab B', 1, 35000.00, '2026-04-13', 'dean', 'SN-1776093550374-709961', 'MSN-1776093550374-598718', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-13 15:19:10', '2026-04-13 15:19:10', '2026-04-13', 1825, 100, 'Low', 0, NULL),
(5, 'pc-clb-05', 29, 'Computer Lab B', 1, 35000.00, '2026-04-13', 'dean', 'SN-1776093550375-724466', 'MSN-1776093550375-242096', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-13 15:19:10', '2026-04-13 15:19:10', '2026-04-13', 1825, 100, 'Low', 0, NULL),
(6, 'pc-clb-06', 29, 'Computer Lab B', 1, 35000.00, '2026-04-13', 'dean', 'SN-1776093550375-743900', 'MSN-1776093550375-575053', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-13 15:19:10', '2026-04-13 15:19:10', '2026-04-13', 1825, 100, 'Low', 0, NULL),
(7, 'pc-clb-07', 29, 'Computer Lab B', 1, 35000.00, '2026-04-13', 'dean', 'SN-1776093550376-471939', 'MSN-1776093550376-241200', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-13 15:19:10', '2026-04-13 15:19:10', '2026-04-13', 1825, 100, 'Low', 0, NULL),
(8, 'pc-clb-08', 29, 'Computer Lab B', 1, 35000.00, '2026-04-13', 'dean', 'SN-1776093550376-790632', 'MSN-1776093550376-388991', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-13 15:19:10', '2026-04-13 15:19:10', '2026-04-13', 1825, 100, 'Low', 0, NULL),
(9, 'pc-clb-09', 29, 'Computer Lab B', 1, 35000.00, '2026-04-13', 'dean', 'SN-1776093550377-748699', 'MSN-1776093550377-652861', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-13 15:19:10', '2026-04-13 15:19:10', '2026-04-13', 1825, 100, 'Low', 0, NULL),
(10, 'pc-clb-10', 29, 'Computer Lab B', 1, 35000.00, '2026-04-13', 'dean', 'SN-1776093550377-349049', 'MSN-1776093550377-503958', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-13 15:19:10', '2026-04-13 15:19:10', '2026-04-13', 1825, 100, 'Low', 0, NULL),
(11, 'pc-clb-11', 29, 'Computer Lab B', 1, 35000.00, '2026-04-13', 'dean', 'SN-1776093550378-898513', 'MSN-1776093550378-248886', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-13 15:19:10', '2026-04-13 15:19:10', '2026-04-13', 1825, 100, 'Low', 0, NULL),
(12, 'pc-clb-12', 29, 'Computer Lab B', 1, 35000.00, '2026-04-13', 'dean', 'SN-1776093550379-861458', 'MSN-1776093550379-833222', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-13 15:19:10', '2026-04-13 15:19:10', '2026-04-13', 1825, 100, 'Low', 0, NULL),
(13, 'pc-clb-13', 29, 'Computer Lab B', 1, 35000.00, '2026-04-13', 'dean', 'SN-1776093550379-678272', 'MSN-1776093550379-542022', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-13 15:19:10', '2026-04-13 15:19:10', '2026-04-13', 1825, 100, 'Low', 0, NULL),
(14, 'pc-clb-14', 29, 'Computer Lab B', 1, 35000.00, '2026-04-13', 'dean', 'SN-1776093550379-628391', 'MSN-1776093550379-775734', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-13 15:19:10', '2026-04-13 15:19:10', '2026-04-13', 1825, 100, 'Low', 0, NULL),
(15, 'pc-clb-15', 29, 'Computer Lab B', 1, 35000.00, '2026-04-13', 'dean', 'SN-1776093550380-293098', 'MSN-1776093550380-191138', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-13 15:19:10', '2026-04-13 15:19:10', '2026-04-13', 1825, 100, 'Low', 0, NULL),
(16, 'pc-clb-16', 29, 'Computer Lab B', 1, 35000.00, '2026-04-13', 'dean', 'SN-1776093550380-154153', 'MSN-1776093550380-626415', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-13 15:19:10', '2026-04-13 15:19:10', '2026-04-13', 1825, 100, 'Low', 0, NULL),
(17, 'pc-clb-17', 29, 'Computer Lab B', 1, 35000.00, '2026-04-13', 'dean', 'SN-1776093550381-520963', 'MSN-1776093550381-845124', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-13 15:19:10', '2026-04-13 15:19:10', '2026-04-13', 1825, 100, 'Low', 0, NULL),
(18, 'pc-clb-18', 29, 'Computer Lab B', 1, 35000.00, '2026-04-13', 'dean', 'SN-1776093550381-677038', 'MSN-1776093550381-458541', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-13 15:19:10', '2026-04-13 15:19:10', '2026-04-13', 1825, 100, 'Low', 0, NULL),
(19, 'pc-clb-19', 29, 'Computer Lab B', 1, 35000.00, '2026-04-13', 'dean', 'SN-1776093550381-763796', 'MSN-1776093550381-476228', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-13 15:19:10', '2026-04-13 15:19:10', '2026-04-13', 1825, 100, 'Low', 0, NULL),
(21, 'pc-cla-01', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003625-395319', 'MSN-1776129003625-274978', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(22, 'pc-cla-02', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003625-677425', 'MSN-1776129003625-226234', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(23, 'pc-cla-03', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003625-435065', 'MSN-1776129003625-198385', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(24, 'pc-cla-04', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003625-139476', 'MSN-1776129003625-266822', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(25, 'pc-cla-05', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003625-488989', 'MSN-1776129003625-154082', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(26, 'pc-cla-06', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003625-961764', 'MSN-1776129003625-862560', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(27, 'pc-cla-07', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003625-229534', 'MSN-1776129003625-298388', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(28, 'pc-cla-08', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003625-390205', 'MSN-1776129003625-909758', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(29, 'pc-cla-09', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003625-363183', 'MSN-1776129003625-289009', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(30, 'pc-cla-10', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003625-385337', 'MSN-1776129003625-740633', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(31, 'pc-cla-11', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003625-131825', 'MSN-1776129003625-711763', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(32, 'pc-cla-12', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003625-834994', 'MSN-1776129003625-628990', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(33, 'pc-cla-13', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003625-899452', 'MSN-1776129003625-613543', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(34, 'pc-cla-14', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003625-763418', 'MSN-1776129003625-363722', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(35, 'pc-cla-15', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003625-673285', 'MSN-1776129003625-628680', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(36, 'pc-cla-16', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003625-611063', 'MSN-1776129003625-978609', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(37, 'pc-cla-17', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003625-704581', 'MSN-1776129003625-943778', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(38, 'pc-cla-18', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003625-680462', 'MSN-1776129003625-757109', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(39, 'pc-cla-19', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003625-903473', 'MSN-1776129003625-749927', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(40, 'pc-cla-20', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003625-386922', 'MSN-1776129003625-307727', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(41, 'pc-cla-21', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003625-668324', 'MSN-1776129003625-924162', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(42, 'pc-cla-22', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003625-451110', 'MSN-1776129003625-990382', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(43, 'pc-cla-23', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003625-891080', 'MSN-1776129003625-562110', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(44, 'pc-cla-24', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003625-771782', 'MSN-1776129003625-840466', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(45, 'pc-cla-25', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003626-497224', 'MSN-1776129003626-626779', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(46, 'pc-cla-26', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003626-596524', 'MSN-1776129003626-553912', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(47, 'pc-cla-27', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003626-315798', 'MSN-1776129003626-234911', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(48, 'pc-cla-28', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003626-313475', 'MSN-1776129003626-622983', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(49, 'pc-cla-29', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003626-270337', 'MSN-1776129003626-970173', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(50, 'pc-cla-30', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003626-470090', 'MSN-1776129003626-966437', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(51, 'pc-cla-31', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003626-334299', 'MSN-1776129003626-561623', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(52, 'pc-cla-32', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003626-911224', 'MSN-1776129003626-658282', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(53, 'pc-cla-33', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003626-469240', 'MSN-1776129003626-884261', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(54, 'pc-cla-34', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003626-752397', 'MSN-1776129003626-779204', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(55, 'pc-cla-35', 30, '30', 1, 35000.00, '2026-04-14', 'Mindalita Ocampo-Cruz, DIT\'', 'SN-1776129003626-638352', 'MSN-1776129003626-601559', 'Available', '', NULL, 'gigabyte a320m', 'ramsta 8gb RAM', 'ramsta 500gb SSD', 'GTX 1050 Ti', 'Corsair 500W', 'CoolerMaster', 'wifi dongle', '2026-04-14 01:10:05', '2026-04-14 01:10:05', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(56, 'pc-do-01', 1, '1', 1, 0.00, '2026-04-14', 'dean', 'SN-1776131078988-426437', 'MSN-1776131078988-938942', 'Available', '', NULL, 'Asus B650M-AYW WIFI Motherboard', '8GB DDR4 3200MHz', '256GB SSD', 'GTX 1650', '500W 80+ Bronze PSU (Corsair / FSP / Cooler Master)', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:44:46', '2026-04-14 01:44:46', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(57, 'pc-do-02', 1, '1', 1, 0.00, '2026-04-14', 'dean', 'SN-1776131078988-365987', 'MSN-1776131078988-790541', 'Available', '', NULL, 'Asus B650M-AYW WIFI Motherboard', '8GB DDR4 3200MHz', '256GB SSD', 'GTX 1650', '500W 80+ Bronze PSU (Corsair / FSP / Cooler Master)', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:44:46', '2026-04-14 01:44:46', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(58, 'pc-do-03', 1, '1', 1, 0.00, '2026-04-14', 'dean', 'SN-1776131078988-555828', 'MSN-1776131078988-637499', 'Available', '', NULL, 'Asus B650M-AYW WIFI Motherboard', '8GB DDR4 3200MHz', '256GB SSD', 'GTX 1650', '500W 80+ Bronze PSU (Corsair / FSP / Cooler Master)', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:44:46', '2026-04-14 01:44:46', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(59, 'pc-do-04', 1, '1', 1, 0.00, '2026-04-14', 'dean', 'SN-1776131078988-258640', 'MSN-1776131078988-597721', 'Available', '', NULL, 'Asus B650M-AYW WIFI Motherboard', '8GB DDR4 3200MHz', '256GB SSD', 'GTX 1650', '500W 80+ Bronze PSU (Corsair / FSP / Cooler Master)', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:44:46', '2026-04-14 01:44:46', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(60, 'Clinic Pc', 32, NULL, 1, 0.00, '2026-04-14', 'Sir Aurum', 'SN-1776131110341-321514', 'MSN-1776131110341-231657', 'Available', '', NULL, 'ASUS PRIME B450', '8GB DDR4 3200MHz', '512GB SSD', 'GTX 1050 Ti', '500W 80+ Bronze PSU (Corsair / FSP / Cooler Master)', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:46:45', '2026-04-14 01:46:45', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(61, 'pc-mis-office-01', 3, '3', 1, 0.00, '2026-04-09', 'Sir Aurum', 'SN-1776131298657-715063', 'MSN-1776131298657-579346', 'Available', '', NULL, 'ASUS PRIME B450', '8GB DDR4 3200MHz', '512GB SSD', 'GTX 1650', 'Corsair 500W', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:48:18', '2026-04-14 01:48:18', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(62, 'pc-mis-office-02', 3, '3', 1, 0.00, '2026-04-09', 'Sir Aurum', 'SN-1776131298657-240109', 'MSN-1776131298657-750552', 'Available', '', NULL, 'ASUS PRIME B450', '8GB DDR4 3200MHz', '512GB SSD', 'GTX 1650', 'Corsair 500W', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:48:18', '2026-04-14 01:48:18', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(63, 'pc-mis-office-03', 3, '3', 1, 0.00, '2026-04-09', 'Sir Aurum', 'SN-1776131298657-153609', 'MSN-1776131298657-305531', 'Available', '', NULL, 'ASUS PRIME B450', '8GB DDR4 3200MHz', '512GB SSD', 'GTX 1650', 'Corsair 500W', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:48:18', '2026-04-14 01:48:18', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(64, 'pc-mis-office-04', 3, '3', 1, 0.00, '2026-04-09', 'Sir Aurum', 'SN-1776131298657-411359', 'MSN-1776131298657-781884', 'Available', '', NULL, 'ASUS PRIME B450', '8GB DDR4 3200MHz', '512GB SSD', 'GTX 1650', 'Corsair 500W', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:48:18', '2026-04-14 01:48:18', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(65, 'pc-registar-01', 31, '31', 1, 0.00, '2026-04-15', 'dean', 'SN-1776131535999-625421', 'MSN-1776131535999-963468', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '256GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21', 'wifi dangle', '2026-04-14 01:52:16', '2026-04-14 01:52:16', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(66, 'pc-registar-02', 31, '31', 1, 0.00, '2026-04-15', 'dean', 'SN-1776131535999-830166', 'MSN-1776131535999-797003', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '256GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21', 'wifi dangle', '2026-04-14 01:52:16', '2026-04-14 01:52:16', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(67, 'pc-registar-03', 31, '31', 1, 0.00, '2026-04-15', 'dean', 'SN-1776131535999-679651', 'MSN-1776131535999-640322', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '256GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21', 'wifi dangle', '2026-04-14 01:52:16', '2026-04-14 01:52:16', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(68, 'pc-registar-04', 31, '31', 1, 0.00, '2026-04-15', 'dean', 'SN-1776131535999-573862', 'MSN-1776131535999-405694', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '256GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21', 'wifi dangle', '2026-04-14 01:52:16', '2026-04-14 01:52:16', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(69, 'pc-registar-05', 31, '31', 1, 0.00, '2026-04-15', 'dean', 'SN-1776131535999-899319', 'MSN-1776131535999-637784', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '256GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21', 'wifi dangle', '2026-04-14 01:52:16', '2026-04-14 01:52:16', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(70, 'pc-registar-06', 31, '31', 1, 0.00, '2026-04-15', 'dean', 'SN-1776131535999-420359', 'MSN-1776131535999-831225', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '256GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21', 'wifi dangle', '2026-04-14 01:52:16', '2026-04-14 01:52:16', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(71, 'pc-registar-07', 31, '31', 1, 0.00, '2026-04-15', 'dean', 'SN-1776131535999-537280', 'MSN-1776131535999-976036', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '256GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21', 'wifi dangle', '2026-04-14 01:52:16', '2026-04-14 01:52:16', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(72, 'pc-registar-08', 31, '31', 1, 0.00, '2026-04-15', 'dean', 'SN-1776131535999-586839', 'MSN-1776131535999-272328', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '256GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21', 'wifi dangle', '2026-04-14 01:52:16', '2026-04-14 01:52:16', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(73, 'pc-clc-01', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647204-533943', 'MSN-1776131647204-602381', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(74, 'pc-clc-02', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647204-834230', 'MSN-1776131647204-282444', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(75, 'pc-clc-03', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647204-233776', 'MSN-1776131647204-283156', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(76, 'pc-clc-04', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647204-363543', 'MSN-1776131647204-601806', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(77, 'pc-clc-05', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647204-178310', 'MSN-1776131647204-197767', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(78, 'pc-clc-06', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647204-811543', 'MSN-1776131647204-821996', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(79, 'pc-clc-07', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647204-875342', 'MSN-1776131647204-225178', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(80, 'pc-clc-08', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647204-161032', 'MSN-1776131647204-538867', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(81, 'pc-clc-09', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647204-714231', 'MSN-1776131647204-403112', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(82, 'pc-clc-10', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647204-525837', 'MSN-1776131647204-557314', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(83, 'pc-clc-11', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-119423', 'MSN-1776131647205-560578', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(84, 'pc-clc-12', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-561742', 'MSN-1776131647205-902145', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(85, 'pc-clc-13', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-667232', 'MSN-1776131647205-897184', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(86, 'pc-clc-14', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-767252', 'MSN-1776131647205-457608', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(87, 'pc-clc-15', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-920704', 'MSN-1776131647205-137697', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(88, 'pc-clc-16', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-291608', 'MSN-1776131647205-857475', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(89, 'pc-clc-17', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-418382', 'MSN-1776131647205-246068', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(90, 'pc-clc-18', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-295332', 'MSN-1776131647205-827902', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(91, 'pc-clc-19', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-894929', 'MSN-1776131647205-380247', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(92, 'pc-clc-20', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-179477', 'MSN-1776131647205-979976', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(93, 'pc-clc-21', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-240628', 'MSN-1776131647205-812476', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(94, 'pc-clc-22', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-752382', 'MSN-1776131647205-787232', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(95, 'pc-clc-23', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-708766', 'MSN-1776131647205-204806', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(96, 'pc-clc-24', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-879880', 'MSN-1776131647205-272244', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(97, 'pc-clc-25', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-745897', 'MSN-1776131647205-366243', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(98, 'pc-clc-26', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-474242', 'MSN-1776131647205-700893', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(99, 'pc-clc-27', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-372569', 'MSN-1776131647205-732741', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(100, 'pc-clc-28', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-319058', 'MSN-1776131647205-622242', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(101, 'pc-clc-29', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-735355', 'MSN-1776131647205-825523', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(102, 'pc-clc-30', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-138824', 'MSN-1776131647205-328095', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(103, 'pc-clc-31', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-792433', 'MSN-1776131647205-681267', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(104, 'pc-clc-32', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-919500', 'MSN-1776131647205-689305', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(105, 'pc-clc-33', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-726703', 'MSN-1776131647205-457314', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(106, 'pc-clc-34', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-801409', 'MSN-1776131647205-734074', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(107, 'pc-clc-35', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-986028', 'MSN-1776131647205-846931', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(108, 'pc-clc-36', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-605055', 'MSN-1776131647205-654686', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(109, 'pc-clc-37', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-600807', 'MSN-1776131647205-414157', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(110, 'pc-clc-38', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-794468', 'MSN-1776131647205-677989', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(111, 'pc-clc-39', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-470068', 'MSN-1776131647205-224141', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(112, 'pc-clc-40', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-786206', 'MSN-1776131647205-680528', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL),
(113, 'pc-clc-41', 25, '25', 1, 0.00, '2026-04-10', 'Sir Aurum', 'SN-1776131647205-929238', 'MSN-1776131647205-168441', 'Available', '', NULL, 'Asus B650M', '8GB DDR4 3200MHz', '512GB SSD', 'Integrated Graphics (Ryzen 5 5600G)', '500W 80+ Bronze', 'DarkFlash DLM21 Micro ATX Case', 'wifi dangle', '2026-04-14 01:54:07', '2026-04-14 01:54:07', '2026-04-14', 1825, 100, 'Low', 0, NULL);

--
-- Triggers `pcinfofull`
--
DELIMITER $$
CREATE TRIGGER `before_insert_pcinfofull` BEFORE INSERT ON `pcinfofull` FOR EACH ROW BEGIN
  DECLARE next_id INT;
  IF NEW.serial_no IS NULL OR NEW.serial_no = '' THEN
    SELECT IFNULL(MAX(pcid), 0) + 1 INTO next_id FROM pcinfofull;
    SET NEW.serial_no = CONCAT('SN-', LPAD(next_id, 6, '0'));
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `pcparts`
--

CREATE TABLE `pcparts` (
  `part_id` int(11) NOT NULL,
  `pcid` varchar(50) NOT NULL,
  `monitor` varchar(100) DEFAULT NULL,
  `motherboard` varchar(100) DEFAULT NULL,
  `ram` varchar(100) DEFAULT NULL,
  `storage` varchar(100) DEFAULT NULL,
  `gpu` varchar(100) DEFAULT NULL,
  `psu` varchar(100) DEFAULT NULL,
  `casing` varchar(100) DEFAULT NULL,
  `other_parts` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pcparts`
--

INSERT INTO `pcparts` (`part_id`, `pcid`, `monitor`, `motherboard`, `ram`, `storage`, `gpu`, `psu`, `casing`, `other_parts`) VALUES
(7, 'PC-953FF49C', '1', '1', '1', '1', '1', '1', '1', '1'),
(8, 'PC-30143C90', '7', '7', '66', '5', '4', '4', '3', 'e');

-- --------------------------------------------------------

--
-- Table structure for table `pcs`
--

CREATE TABLE `pcs` (
  `pcid` varchar(50) NOT NULL,
  `pcname` varchar(100) NOT NULL,
  `department_id` int(11) DEFAULT NULL,
  `status` enum('Active','In Repair','Decommissioned') DEFAULT 'Active',
  `note` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pcs`
--

INSERT INTO `pcs` (`pcid`, `pcname`, `department_id`, `status`, `note`) VALUES
('PC-30143C90', '66', 1, 'Active', '88'),
('PC-953FF49C', '2', 1, 'Active', '1');

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `student_id` varchar(20) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `middle_initial` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`student_id`, `last_name`, `first_name`, `middle_initial`) VALUES
('2021-0442', 'Bautista', 'Renato', 'SD');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `username` varchar(50) NOT NULL,
  `faculty_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`permissions`)),
  `first_name` varchar(50) DEFAULT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `faculty_name`, `email`, `password`, `is_admin`, `is_active`, `created_at`, `updated_at`, `permissions`, `first_name`, `middle_name`, `last_name`) VALUES
(9, 'admin', 'santos, matthew S.', 'matthewjohnsantos2004@gmail.com', 'scrypt:32768:8:1$ryLUIe9RsrDae4ph$d62414102427f2911938fc93a342514c4064c148112be99a3aa808a83bf62eca63b5ab43f9b0cc8341e01f21f8968882b1eb26c91b737a8872e9950ff25befd0', 1, 1, '2025-03-24 02:34:16', '2025-10-27 04:03:59', '{\"dashboard\": {\"view\": true, \"edit\": true}, \"inventory\": {\"view\": true, \"edit\": true}, \"qrlist\": {\"view\": true, \"edit\": true}, \"report\": {\"view\": true, \"edit\": true}, \"dept\": {\"view\": true, \"edit\": false}}', 'matthew', 's', 'santos'),
(10, 'user', 'me', 'matthewjohnsantos143@gmail.com', 'scrypt:32768:8:1$LQ4mixntjhzilHyY$7e9f133cb8da3b06625ac3ee3164c9d8fb97983226c64ddfecddad0fa9fd76a5821f391e3d1595c4029544ae4a3f253a0952f1496174f3b46093503766ff5fcb', 0, 1, '2025-03-24 09:25:58', '2026-03-31 02:31:48', '{\"dashboard\": {\"view\": true, \"edit\": false}, \"inventory\": {\"view\": true, \"edit\": false}, \"qrlist\": {\"view\": true, \"edit\": false}, \"report\": {\"view\": true, \"edit\": false}, \"dept\": {\"view\": true, \"edit\": false}}', 'matthew', 's', 'santos'),
(11, 'rbautista', 'BA, Re', 'renatobautista17@gmail.com', 'scrypt:32768:8:1$Gc5JBZzptDeAvn9b$cf555f0d8ead0898962845e3fba4f6ef99fc3ab7e7c0a4f86f09d766054ed4dcfdc99174d15db62bad4701f583feb1fea555bcd14f9593675ee30e3b7891a037', 1, 1, '2025-10-26 15:24:49', '2026-04-06 14:06:27', '{\"dashboard\": {\"view\": true, \"edit\": true}, \"inventory\": {\"view\": true, \"edit\": true}, \"qrlist\": {\"view\": true, \"edit\": true}, \"report\": {\"view\": true, \"edit\": true}, \"dept\": {\"view\": true, \"edit\": true}}', 'Renato', 'sd', 'Bautista');

-- --------------------------------------------------------

--
-- Table structure for table `user_activity_log`
--

CREATE TABLE `user_activity_log` (
  `log_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `username` varchar(100) NOT NULL,
  `role` varchar(20) NOT NULL,
  `action` varchar(120) NOT NULL,
  `module` varchar(120) DEFAULT NULL,
  `details` text DEFAULT NULL,
  `http_method` varchar(10) DEFAULT NULL,
  `route` varchar(255) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_activity_log`
--

INSERT INTO `user_activity_log` (`log_id`, `user_id`, `username`, `role`, `action`, `module`, `details`, `http_method`, `route`, `ip_address`, `created_at`) VALUES
(1, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-03 10:00:31'),
(2, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-03 14:31:09'),
(3, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-03 14:51:04'),
(4, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-03 15:13:24'),
(5, 9, 'admin', 'Admin', 'Logout', 'Authentication', 'User signed out', 'POST', '/login/logout', '127.0.0.1', '2026-04-03 15:19:09'),
(6, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-03 15:19:12'),
(7, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/pc/bulk-damaged -> 200', 'POST', '/inventory/pc/bulk-damaged', '127.0.0.1', '2026-04-03 15:23:03'),
(8, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/pc/bulk-damaged -> 200', 'POST', '/inventory/pc/bulk-damaged', '127.0.0.1', '2026-04-03 15:23:20'),
(9, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/pc/bulk-check -> 200', 'POST', '/inventory/pc/bulk-check', '127.0.0.1', '2026-04-03 15:23:29'),
(10, 9, 'admin', 'Admin', 'View Page', 'Qrcode', 'Visited /qrcodegenerator', 'GET', '/qrcodegenerator', '127.0.0.1', '2026-04-04 03:49:53'),
(11, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-04 03:49:53'),
(12, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-04 03:50:00'),
(13, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-04 03:50:01'),
(14, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-04 03:50:08'),
(15, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 03:50:21'),
(16, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:00:12'),
(17, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device-bulk-damaged -> 200', 'POST', '/inventory/device-bulk-damaged', '127.0.0.1', '2026-04-04 04:00:24'),
(18, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/pc/bulk-damaged -> 200', 'POST', '/inventory/pc/bulk-damaged', '127.0.0.1', '2026-04-04 04:00:46'),
(19, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-04 04:01:40'),
(20, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-04 04:01:49'),
(21, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:02:50'),
(22, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-04 04:02:54'),
(23, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:03:03'),
(24, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:04:32'),
(25, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/pc/bulk-check -> 200', 'POST', '/inventory/pc/bulk-check', '127.0.0.1', '2026-04-04 04:04:39'),
(26, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-04 04:05:04'),
(27, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:06:54'),
(28, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:08:47'),
(29, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /manage_device/export-selected-devices -> 404', 'POST', '/manage_device/export-selected-devices', '127.0.0.1', '2026-04-04 04:09:14'),
(30, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:18:43'),
(31, 9, 'admin', 'Admin', 'View Page', 'Qrcode', 'Visited /qrcodegenerator', 'GET', '/qrcodegenerator', '127.0.0.1', '2026-04-04 04:20:43'),
(32, 9, 'admin', 'Admin', 'View Page', 'Stock Room', 'Visited /stock_room/stock-room', 'GET', '/stock_room/stock-room', '127.0.0.1', '2026-04-04 04:20:45'),
(33, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:23:05'),
(34, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:25:53'),
(35, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:28:02'),
(36, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:31:33'),
(37, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:31:39'),
(38, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:33:36'),
(39, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:34:58'),
(40, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:36:34'),
(41, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:39:27'),
(42, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:40:54'),
(43, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:41:58'),
(44, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:42:46'),
(45, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:45:10'),
(46, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:47:11'),
(47, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:49:44'),
(48, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:52:29'),
(49, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:52:43'),
(50, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:55:42'),
(51, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:58:56'),
(52, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 04:59:56'),
(53, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 05:01:00'),
(54, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 05:03:44'),
(55, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 05:05:22'),
(56, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 05:10:04'),
(57, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 05:12:03'),
(58, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 05:12:59'),
(59, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 05:13:58'),
(60, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 05:19:49'),
(61, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 05:22:57'),
(62, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 05:24:29'),
(63, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 05:30:05'),
(64, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 05:30:19'),
(65, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 05:32:17'),
(66, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 05:34:53'),
(67, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 05:37:11'),
(68, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 05:38:55'),
(69, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 05:43:23'),
(70, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 05:44:27'),
(71, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 05:46:12'),
(72, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=surrendered', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 05:53:31'),
(73, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=surrendered&surrendered_page=1&surrendered_per_page=10', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 05:56:03'),
(74, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=surrendered&surrendered_page=1&surrendered_per_page=10', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 05:56:32'),
(75, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=surrendered&surrendered_page=1&surrendered_per_page=10', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 05:59:23'),
(76, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 06:00:05'),
(77, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 06:00:36'),
(78, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 06:01:02'),
(79, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 06:02:20'),
(80, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 06:04:37'),
(81, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 06:06:26'),
(82, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=surrendered', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 06:07:42'),
(83, 9, 'admin', 'Admin', 'View Page', 'Manage User', 'Visited /manage-user', 'GET', '/manage-user', '127.0.0.1', '2026-04-04 06:07:51'),
(84, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-04 06:07:53'),
(85, 9, 'admin', 'Admin', 'View Page', 'Manage User', 'Visited /manage-user', 'GET', '/manage-user', '127.0.0.1', '2026-04-04 06:10:19'),
(86, 9, 'admin', 'Admin', 'View Page', 'Stock Room', 'Visited /stock_room/stock-room', 'GET', '/stock_room/stock-room', '127.0.0.1', '2026-04-04 06:10:24'),
(87, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-04 06:10:45'),
(88, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-04 06:16:52'),
(89, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-04 06:18:53'),
(90, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-04 06:21:08'),
(91, 9, 'admin', 'Admin', 'Logout', 'Authentication', 'User signed out', 'POST', '/login/logout', '127.0.0.1', '2026-04-04 06:21:24'),
(92, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-04 06:25:06'),
(93, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-04 06:25:07'),
(94, 9, 'admin', 'Admin', 'Logout', 'Authentication', 'User signed out', 'POST', '/login/logout', '127.0.0.1', '2026-04-04 06:25:16'),
(95, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-04 06:26:49'),
(96, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-04 06:26:49'),
(97, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-04 06:34:28'),
(98, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-04 06:35:28'),
(99, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-04 06:36:03'),
(100, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 06:36:05'),
(101, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 06:38:37'),
(102, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 06:40:03'),
(103, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 06:43:12'),
(104, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 06:43:15'),
(105, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 06:45:28'),
(106, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-04 06:48:51'),
(107, 9, 'admin', 'Admin', 'View Page', 'Qrcode', 'Visited /qrcodegenerator', 'GET', '/qrcodegenerator', '127.0.0.1', '2026-04-04 06:49:06'),
(108, 9, 'admin', 'Admin', 'View Page', 'Manage User', 'Visited /manage-user', 'GET', '/manage-user', '127.0.0.1', '2026-04-04 06:49:08'),
(109, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-04 06:49:09'),
(110, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-04 06:49:10'),
(111, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-04 06:49:37'),
(112, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-04 06:51:36'),
(113, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log?page=1&per_page=20&role=all&search=', 'GET', '/activity-log', '127.0.0.1', '2026-04-04 06:53:17'),
(114, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log?page=1&per_page=20&role=all&search=', 'GET', '/activity-log', '127.0.0.1', '2026-04-04 06:53:18'),
(115, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-04 06:53:40'),
(116, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-04 06:56:04'),
(117, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-04 06:58:04'),
(118, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log?page=1&per_page=20&role=all&search=&log_date=', 'GET', '/activity-log', '127.0.0.1', '2026-04-04 06:59:11'),
(119, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log?page=2&per_page=10&role=admin&search=&log_date=', 'GET', '/activity-log', '127.0.0.1', '2026-04-04 07:01:21'),
(120, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log?page=2&per_page=10&role=admin&search=&log_date=', 'GET', '/activity-log', '127.0.0.1', '2026-04-04 07:02:03'),
(121, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log?page=1&per_page=10&role=all&search=&log_date=2026-04-03', 'GET', '/activity-log', '127.0.0.1', '2026-04-04 07:04:59'),
(122, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log?page=1&per_page=10&role=all&search=&log_date=2026-04-03', 'GET', '/activity-log', '127.0.0.1', '2026-04-04 07:07:36'),
(123, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log?page=1&per_page=10&role=all&search=&log_date=2026-04-03', 'GET', '/activity-log', '127.0.0.1', '2026-04-04 07:07:53'),
(124, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log?page=1&per_page=10&role=all&search=admin&log_date=2026-04-03', 'GET', '/activity-log', '127.0.0.1', '2026-04-04 07:10:15'),
(125, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log?page=1&per_page=10&role=all&search=admin&log_date=2026-04-03', 'GET', '/activity-log', '127.0.0.1', '2026-04-04 07:10:24'),
(126, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log?page=1&per_page=10&role=all&search=admin&log_date=2026-04-03', 'GET', '/activity-log', '127.0.0.1', '2026-04-04 07:10:29'),
(127, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log?page=1&per_page=10&role=all&search=admin&log_date=2026-04-03', 'GET', '/activity-log', '127.0.0.1', '2026-04-04 07:14:09'),
(128, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log?page=1&per_page=10&role=all&search=admin&log_date=2026-04-03', 'GET', '/activity-log', '127.0.0.1', '2026-04-04 07:14:18'),
(129, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-04 07:22:15'),
(130, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-04 07:22:29'),
(131, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-04 07:26:21'),
(132, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-04 07:26:26'),
(133, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-04 07:26:26'),
(134, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-04 07:26:34'),
(135, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-04 07:30:46'),
(136, 9, 'admin', 'Admin', 'Submit', 'Manage Department', 'POST /add-department -> 200', 'POST', '/add-department', '127.0.0.1', '2026-04-04 07:31:06'),
(137, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-04 07:32:36'),
(138, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-04 07:36:23'),
(139, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-04 07:38:00'),
(140, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-04 07:43:23'),
(141, 9, 'admin', 'Admin', 'View Page', 'Qrcode', 'Visited /qrcodegenerator', 'GET', '/qrcodegenerator', '127.0.0.1', '2026-04-04 07:43:25'),
(142, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-04 07:44:32'),
(143, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-04 07:44:35'),
(144, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-06 05:12:04'),
(145, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-06 05:12:18'),
(146, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 05:12:19'),
(147, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-06 05:12:29'),
(148, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 05:12:36'),
(149, 9, 'admin', 'Admin', 'View Page', 'Qrcode', 'Visited /qrcodegenerator', 'GET', '/qrcodegenerator', '127.0.0.1', '2026-04-06 05:12:52'),
(150, 9, 'admin', 'Admin', 'View Page', 'Stock Room', 'Visited /stock_room/stock-room', 'GET', '/stock_room/stock-room', '127.0.0.1', '2026-04-06 05:12:56'),
(151, 9, 'admin', 'Admin', 'View Page', 'Manage User', 'Visited /manage-user', 'GET', '/manage-user', '127.0.0.1', '2026-04-06 05:13:01'),
(152, 9, 'admin', 'Admin', 'View Page', 'Stock Room', 'Visited /stock_room/stock-room', 'GET', '/stock_room/stock-room', '127.0.0.1', '2026-04-06 05:13:02'),
(153, 9, 'admin', 'Admin', 'View Page', 'Manage User', 'Visited /manage-user', 'GET', '/manage-user', '127.0.0.1', '2026-04-06 05:13:13'),
(154, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-06 05:13:23'),
(155, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-06 05:13:46'),
(156, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-06 05:14:06'),
(157, 9, 'admin', 'Admin', 'View Page', 'Damage Report', 'Visited /damage-report', 'GET', '/damage-report', '127.0.0.1', '2026-04-06 05:14:09'),
(158, 9, 'admin', 'Admin', 'View Page', 'Maintenance', 'Visited /maintenance/history', 'GET', '/maintenance/history', '127.0.0.1', '2026-04-06 05:14:11'),
(159, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transaction_history', 'GET', '/transaction_history', '127.0.0.1', '2026-04-06 05:14:14'),
(160, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 05:14:23'),
(161, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-06 05:14:27'),
(162, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 05:14:35'),
(163, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 05:15:08'),
(164, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 05:15:16'),
(165, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-06 05:15:52'),
(166, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 05:15:55'),
(167, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/pc/bulk-damaged -> 200', 'POST', '/inventory/pc/bulk-damaged', '127.0.0.1', '2026-04-06 05:16:03'),
(168, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/pc/bulk-check -> 200', 'POST', '/inventory/pc/bulk-check', '127.0.0.1', '2026-04-06 05:16:16'),
(169, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-06 05:16:39'),
(170, 9, 'admin', 'Admin', 'View Page', 'Qrcode', 'Visited /qrcodegenerator', 'GET', '/qrcodegenerator', '127.0.0.1', '2026-04-06 05:16:51'),
(171, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-06 05:17:11'),
(172, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-06 05:17:35'),
(173, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 05:17:56'),
(174, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-06 05:20:41'),
(175, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 05:21:55'),
(176, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-06 05:22:05'),
(177, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 05:22:11'),
(178, 9, 'admin', 'Admin', 'View Page', 'Qrcode', 'Visited /qrcodegenerator', 'GET', '/qrcodegenerator', '127.0.0.1', '2026-04-06 05:22:18'),
(179, 9, 'admin', 'Admin', 'View Page', 'Stock Room', 'Visited /stock_room/stock-room', 'GET', '/stock_room/stock-room', '127.0.0.1', '2026-04-06 05:22:47'),
(180, 9, 'admin', 'Admin', 'View Page', 'Manage User', 'Visited /manage-user', 'GET', '/manage-user', '127.0.0.1', '2026-04-06 05:22:54'),
(181, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-06 05:22:59'),
(182, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-06 05:23:31'),
(183, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-06 05:23:49'),
(184, 9, 'admin', 'Admin', 'View Page', 'Damage Report', 'Visited /damage-report', 'GET', '/damage-report', '127.0.0.1', '2026-04-06 05:24:10'),
(185, 9, 'admin', 'Admin', 'View Page', 'Maintenance', 'Visited /maintenance/history', 'GET', '/maintenance/history', '127.0.0.1', '2026-04-06 05:24:13'),
(186, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-06 05:24:16'),
(187, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 05:24:17'),
(188, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 05:24:50'),
(189, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-06 07:46:18'),
(190, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-06 07:52:28'),
(191, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 07:52:28'),
(192, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-06 07:52:32'),
(193, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 07:52:35'),
(194, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 07:52:39'),
(195, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-06 07:52:49'),
(196, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 07:52:55'),
(197, 9, 'admin', 'Admin', 'Add Item', 'PC Management', 'POST /add-pcinfofull -> 500', 'POST', '/add-pcinfofull', '127.0.0.1', '2026-04-06 07:53:44'),
(198, 9, 'admin', 'Admin', 'Add Item', 'PC Management', 'POST /add-pcinfofull -> 500', 'POST', '/add-pcinfofull', '127.0.0.1', '2026-04-06 07:54:02'),
(199, 9, 'admin', 'Admin', 'Add Item', 'PC Management', 'POST /add-pcinfofull -> 200', 'POST', '/add-pcinfofull', '127.0.0.1', '2026-04-06 07:55:05'),
(200, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory/pc-filter-modal', 'GET', '/manage_inventory/pc-filter-modal', '127.0.0.1', '2026-04-06 07:55:27'),
(201, 9, 'admin', 'Admin', 'View Page', 'Qrcode', 'Visited /qrcodegenerator', 'GET', '/qrcodegenerator', '127.0.0.1', '2026-04-06 07:55:53'),
(202, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-06 07:55:57'),
(203, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-06 07:56:11'),
(204, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 07:56:12'),
(205, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 07:56:13'),
(206, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/DEVICE/56/check -> 200', 'POST', '/inventory/DEVICE/56/check', '127.0.0.1', '2026-04-06 07:57:46'),
(207, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/DEVICE/56/check -> 200', 'POST', '/inventory/DEVICE/56/check', '127.0.0.1', '2026-04-06 07:57:47'),
(208, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/DEVICE/56/check -> 200', 'POST', '/inventory/DEVICE/56/check', '127.0.0.1', '2026-04-06 07:57:48'),
(209, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/DEVICE/57/check -> 200', 'POST', '/inventory/DEVICE/57/check', '127.0.0.1', '2026-04-06 07:57:49'),
(210, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/DEVICE/55/check -> 200', 'POST', '/inventory/DEVICE/55/check', '127.0.0.1', '2026-04-06 07:57:51'),
(211, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device-bulk-damaged -> 200', 'POST', '/inventory/device-bulk-damaged', '127.0.0.1', '2026-04-06 07:57:56'),
(212, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-06 07:58:08'),
(213, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?department_id=&status=&accountable=&serial_no=&item_name=casing&brand_model=&device_type=&date_from=&date_to=&section=items&ui_section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 07:58:23'),
(214, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory/pc-filter-modal', 'GET', '/manage_inventory/pc-filter-modal', '127.0.0.1', '2026-04-06 07:58:46'),
(215, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-06 07:58:55'),
(216, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-06 07:59:37'),
(217, 9, 'admin', 'Admin', 'View Page', 'Damage Report', 'Visited /damage-report', 'GET', '/damage-report', '127.0.0.1', '2026-04-06 07:59:41'),
(218, 9, 'admin', 'Admin', 'View Page', 'Maintenance', 'Visited /maintenance/history', 'GET', '/maintenance/history', '127.0.0.1', '2026-04-06 07:59:43'),
(219, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transaction_history', 'GET', '/transaction_history', '127.0.0.1', '2026-04-06 07:59:55'),
(220, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 08:00:02'),
(221, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 08:00:49'),
(222, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 08:01:00'),
(223, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-06 08:02:09'),
(224, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 08:02:12'),
(225, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-06 08:05:16'),
(226, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 08:06:22'),
(227, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 08:06:53'),
(228, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 08:07:28'),
(229, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory/pc-filter-modal', 'GET', '/manage_inventory/pc-filter-modal', '127.0.0.1', '2026-04-06 08:07:36'),
(230, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/pc/bulk-damaged -> 200', 'POST', '/inventory/pc/bulk-damaged', '127.0.0.1', '2026-04-06 08:07:46'),
(231, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-06 08:09:55'),
(232, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 08:10:20'),
(233, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-06 08:10:30'),
(234, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-06 08:10:34'),
(235, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-06 08:10:36'),
(236, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-06 08:10:37'),
(237, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-06 08:10:38'),
(238, 9, 'admin', 'Admin', 'View Page', 'Manage User', 'Visited /manage-user', 'GET', '/manage-user', '127.0.0.1', '2026-04-06 08:10:39'),
(239, 9, 'admin', 'Admin', 'View Page', 'Stock Room', 'Visited /stock_room/stock-room', 'GET', '/stock_room/stock-room', '127.0.0.1', '2026-04-06 08:10:40'),
(240, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 08:10:43'),
(241, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-06 08:10:56'),
(242, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 08:12:37'),
(243, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 08:14:00'),
(244, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 08:15:07'),
(245, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-06 08:16:45'),
(246, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 08:16:47'),
(247, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 08:17:04'),
(248, 9, 'admin', 'Admin', 'View Page', 'Qrcode', 'Visited /qrcodegenerator', 'GET', '/qrcodegenerator', '127.0.0.1', '2026-04-06 08:17:30'),
(249, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 08:17:35'),
(250, 9, 'admin', 'Admin', 'View Page', 'Qrcode', 'Visited /qrcodegenerator', 'GET', '/qrcodegenerator', '127.0.0.1', '2026-04-06 08:17:36'),
(251, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 08:17:39'),
(252, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc&page=3&per_page=10', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 08:20:06'),
(253, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc&page=3&per_page=10', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 08:20:15'),
(254, 9, 'admin', 'Admin', 'View Page', 'Maintenance', 'Visited /maintenance/history', 'GET', '/maintenance/history', '127.0.0.1', '2026-04-06 08:20:19'),
(255, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 08:21:13'),
(256, 9, 'admin', 'Admin', 'View Page', 'Qrcode', 'Visited /qrcodegenerator', 'GET', '/qrcodegenerator', '127.0.0.1', '2026-04-06 08:23:34'),
(257, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 08:23:36'),
(258, 9, 'admin', 'Admin', 'View Page', 'Qrcode', 'Visited /qrcodegenerator', 'GET', '/qrcodegenerator', '127.0.0.1', '2026-04-06 08:25:44'),
(259, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-06 08:26:48'),
(260, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 08:26:50'),
(261, 9, 'admin', 'Admin', 'View Page', 'Stock Room', 'Visited /stock_room/stock-room', 'GET', '/stock_room/stock-room', '127.0.0.1', '2026-04-06 08:26:55'),
(262, 9, 'admin', 'Admin', 'View Page', 'Manage User', 'Visited /manage-user', 'GET', '/manage-user', '127.0.0.1', '2026-04-06 08:27:31'),
(263, 9, 'admin', 'Admin', 'View Page', 'Manage User', 'Visited /manage-user', 'GET', '/manage-user', '127.0.0.1', '2026-04-06 08:28:25'),
(264, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-06 08:28:36'),
(265, 9, 'admin', 'Admin', 'View Page', 'Manage User', 'Visited /manage-user', 'GET', '/manage-user', '127.0.0.1', '2026-04-06 08:28:40'),
(266, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-06 08:29:05'),
(267, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-06 08:29:35'),
(268, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-06 08:29:37'),
(269, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 08:29:40'),
(270, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-06 08:29:43'),
(271, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 08:29:44'),
(272, 9, 'admin', 'Admin', 'View Page', 'Qrcode', 'Visited /qrcodegenerator', 'GET', '/qrcodegenerator', '127.0.0.1', '2026-04-06 08:31:11'),
(273, 9, 'admin', 'Admin', 'View Page', 'Manage User', 'Visited /manage-user', 'GET', '/manage-user', '127.0.0.1', '2026-04-06 08:31:13'),
(274, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-06 08:31:15'),
(275, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-06 08:31:17'),
(276, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-06 08:31:19'),
(277, 9, 'admin', 'Admin', 'View Page', 'Damage Report', 'Visited /damage-report', 'GET', '/damage-report', '127.0.0.1', '2026-04-06 08:31:21'),
(278, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 08:31:37'),
(279, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory/pc-filter-modal', 'GET', '/manage_inventory/pc-filter-modal', '127.0.0.1', '2026-04-06 08:33:02'),
(280, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device-bulk-damaged -> 200', 'POST', '/inventory/device-bulk-damaged', '127.0.0.1', '2026-04-06 08:34:57'),
(281, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-06 08:35:15'),
(282, 9, 'admin', 'Admin', 'View Page', 'Damage Report', 'Visited /damage-report', 'GET', '/damage-report', '127.0.0.1', '2026-04-06 08:35:21'),
(283, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-06 08:35:24'),
(284, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 08:35:35'),
(285, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-06 08:35:39'),
(286, 9, 'admin', 'Admin', 'View Page', 'Damage Report', 'Visited /damage-report', 'GET', '/damage-report', '127.0.0.1', '2026-04-06 08:36:13'),
(287, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 08:36:16'),
(288, 9, 'admin', 'Admin', 'View Page', 'Maintenance', 'Visited /maintenance/history', 'GET', '/maintenance/history', '127.0.0.1', '2026-04-06 08:36:35'),
(289, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transaction_history', 'GET', '/transaction_history', '127.0.0.1', '2026-04-06 08:36:41'),
(290, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 08:36:43'),
(291, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-06 12:21:13'),
(292, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-06 12:21:17'),
(293, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 12:21:18'),
(294, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-06 12:21:23'),
(295, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 12:21:25'),
(296, 9, 'admin', 'Admin', 'View Page', 'Manage User', 'Visited /manage-user', 'GET', '/manage-user', '127.0.0.1', '2026-04-06 12:23:15'),
(297, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 12:27:47'),
(298, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-06 12:45:48'),
(299, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-06 12:45:51'),
(300, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 12:45:51'),
(301, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 12:45:57'),
(302, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 12:46:02'),
(303, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 12:46:47'),
(304, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 12:48:51'),
(305, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-06 12:49:00'),
(306, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 12:49:05'),
(307, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 12:52:56'),
(308, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 12:52:58'),
(309, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 12:52:58'),
(310, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 12:53:53'),
(311, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 12:54:12'),
(312, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 12:55:17'),
(313, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 12:57:38'),
(314, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=surrendered&surrendered_page=1&surrendered_per_page=10', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 13:00:23'),
(315, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=surrendered&surrendered_page=1&surrendered_per_page=10', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 13:04:08'),
(316, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-surrender -> 200', 'POST', '/inventory/device/bulk-surrender', '127.0.0.1', '2026-04-06 13:04:18'),
(317, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 13:04:25'),
(318, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-surrender -> 200', 'POST', '/inventory/device/bulk-surrender', '127.0.0.1', '2026-04-06 13:04:35'),
(319, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=surrendered', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 13:10:36'),
(320, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=surrendered', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 13:14:14'),
(321, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=surrendered', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 13:15:34'),
(322, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=surrendered_item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 13:21:02'),
(323, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=surrendered_item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 13:24:03');
INSERT INTO `user_activity_log` (`log_id`, `user_id`, `username`, `role`, `action`, `module`, `details`, `http_method`, `route`, `ip_address`, `created_at`) VALUES
(324, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=surrendered_item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 13:26:53'),
(325, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 13:30:27'),
(326, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 13:34:31'),
(327, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 13:40:29'),
(328, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-06 13:41:22'),
(329, 9, 'admin', 'Admin', 'View Page', 'Maintenance', 'Visited /maintenance/history', 'GET', '/maintenance/history', '127.0.0.1', '2026-04-06 13:41:30'),
(330, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 13:41:45'),
(331, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 13:42:25'),
(332, 9, 'admin', 'Admin', 'View Page', 'Qrcode', 'Visited /qrcodegenerator', 'GET', '/qrcodegenerator', '127.0.0.1', '2026-04-06 13:42:47'),
(333, 9, 'admin', 'Admin', 'View Page', 'Stock Room', 'Visited /stock_room/stock-room', 'GET', '/stock_room/stock-room', '127.0.0.1', '2026-04-06 13:42:49'),
(334, 9, 'admin', 'Admin', 'View Page', 'Manage User', 'Visited /manage-user', 'GET', '/manage-user', '127.0.0.1', '2026-04-06 13:42:52'),
(335, 9, 'admin', 'Admin', 'View Page', 'Manage User', 'Visited /manage-user', 'GET', '/manage-user', '127.0.0.1', '2026-04-06 13:59:17'),
(336, 9, 'admin', 'Admin', 'View Page', 'Manage User', 'Visited /manage-user', 'GET', '/manage-user', '127.0.0.1', '2026-04-06 14:05:32'),
(337, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-06 14:06:05'),
(338, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-06 14:06:08'),
(339, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-06 14:06:08'),
(340, 9, 'admin', 'Admin', 'View Page', 'Manage User', 'Visited /manage-user', 'GET', '/manage-user', '127.0.0.1', '2026-04-06 14:06:12'),
(341, 9, 'admin', 'Admin', 'Deactivate User', 'User Management', 'POST /deactivate-user -> 302', 'POST', '/deactivate-user', '127.0.0.1', '2026-04-06 14:06:21'),
(342, 9, 'admin', 'Admin', 'View Page', 'Manage User', 'Visited /manage-user', 'GET', '/manage-user', '127.0.0.1', '2026-04-06 14:06:21'),
(343, 9, 'admin', 'Admin', 'Activate User', 'User Management', 'POST /activate-user -> 302', 'POST', '/activate-user', '127.0.0.1', '2026-04-06 14:06:27'),
(344, 9, 'admin', 'Admin', 'View Page', 'Manage User', 'Visited /manage-user', 'GET', '/manage-user', '127.0.0.1', '2026-04-06 14:06:27'),
(345, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-06 14:06:34'),
(346, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-06 14:07:49'),
(347, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-06 14:07:52'),
(348, 9, 'admin', 'Admin', 'View Page', 'Maintenance', 'Visited /maintenance/history', 'GET', '/maintenance/history', '127.0.0.1', '2026-04-06 14:07:53'),
(349, 9, 'admin', 'Admin', 'View Page', 'Maintenance', 'Visited /maintenance/history', 'GET', '/maintenance/history', '127.0.0.1', '2026-04-06 14:10:37'),
(350, 9, 'admin', 'Admin', 'View Page', 'Maintenance', 'Visited /maintenance/history', 'GET', '/maintenance/history', '127.0.0.1', '2026-04-06 14:15:21'),
(351, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 14:15:32'),
(352, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory/pc-filter-modal', 'GET', '/manage_inventory/pc-filter-modal', '127.0.0.1', '2026-04-06 14:16:40'),
(353, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 14:29:41'),
(354, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 14:35:41'),
(355, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 14:35:52'),
(356, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 14:37:37'),
(357, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 14:39:43'),
(358, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-06 14:43:32'),
(359, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-08 13:22:44'),
(360, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-08 13:22:48'),
(361, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-08 13:22:51'),
(362, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 13:23:10'),
(363, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 13:27:18'),
(364, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory/pc-filter-modal', 'GET', '/manage_inventory/pc-filter-modal', '127.0.0.1', '2026-04-08 13:27:47'),
(365, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc&page=1&per_page=10', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 13:33:53'),
(366, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory/pc-filter-modal', 'GET', '/manage_inventory/pc-filter-modal', '127.0.0.1', '2026-04-08 13:33:54'),
(367, 9, 'admin', 'Admin', 'View Page', 'Qrcode', 'Visited /qrcodegenerator', 'GET', '/qrcodegenerator', '127.0.0.1', '2026-04-08 13:34:13'),
(368, 9, 'admin', 'Admin', 'View Page', 'Stock Room', 'Visited /stock_room/stock-room', 'GET', '/stock_room/stock-room', '127.0.0.1', '2026-04-08 13:34:28'),
(369, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-08 13:34:41'),
(370, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-08 13:34:42'),
(371, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-08 13:34:51'),
(372, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-08 13:34:53'),
(373, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-08 13:38:12'),
(374, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-08 13:38:24'),
(375, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-08 13:38:53'),
(376, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-08 13:38:57'),
(377, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-08 13:38:58'),
(378, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-08 13:39:00'),
(379, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-08 13:40:24'),
(380, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-08 13:44:04'),
(381, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-08 13:44:28'),
(382, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-08 13:47:54'),
(383, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-08 13:47:55'),
(384, 9, 'admin', 'Admin', 'View Page', 'Damage Report', 'Visited /damage-report', 'GET', '/damage-report', '127.0.0.1', '2026-04-08 13:47:57'),
(385, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-08 13:47:58'),
(386, 9, 'admin', 'Admin', 'View Page', 'Damage Report', 'Visited /damage-report', 'GET', '/damage-report', '127.0.0.1', '2026-04-08 13:48:12'),
(387, 9, 'admin', 'Admin', 'View Page', 'Maintenance', 'Visited /maintenance/history', 'GET', '/maintenance/history', '127.0.0.1', '2026-04-08 13:48:13'),
(388, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transaction_history', 'GET', '/transaction_history', '127.0.0.1', '2026-04-08 13:48:16'),
(389, 9, 'admin', 'Admin', 'View Page', 'Maintenance', 'Visited /maintenance/history', 'GET', '/maintenance/history', '127.0.0.1', '2026-04-08 13:48:19'),
(390, 9, 'admin', 'Admin', 'View Page', 'Maintenance', 'Visited /maintenance/history', 'GET', '/maintenance/history', '127.0.0.1', '2026-04-08 13:53:15'),
(391, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transaction_history', 'GET', '/transaction_history', '127.0.0.1', '2026-04-08 13:53:32'),
(392, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transaction_history', 'GET', '/transaction_history', '127.0.0.1', '2026-04-08 14:00:54'),
(393, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transaction_history', 'GET', '/transaction_history', '127.0.0.1', '2026-04-08 14:03:26'),
(394, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-08 14:05:42'),
(395, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-08 14:11:30'),
(396, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 14:11:35'),
(397, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/pc/bulk-damaged -> 200', 'POST', '/inventory/pc/bulk-damaged', '127.0.0.1', '2026-04-08 14:11:41'),
(398, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-08 14:11:47'),
(399, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 14:12:25'),
(400, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-08 14:12:27'),
(401, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-08 14:14:36'),
(402, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 14:14:48'),
(403, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/pc/bulk-check -> 200', 'POST', '/inventory/pc/bulk-check', '127.0.0.1', '2026-04-08 14:14:53'),
(404, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 14:15:33'),
(405, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/pc/bulk-damaged -> 200', 'POST', '/inventory/pc/bulk-damaged', '127.0.0.1', '2026-04-08 14:20:00'),
(406, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/pc/bulk-check -> 200', 'POST', '/inventory/pc/bulk-check', '127.0.0.1', '2026-04-08 14:21:05'),
(407, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 14:21:11'),
(408, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 14:21:29'),
(409, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 14:22:53'),
(410, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/pc/bulk-check -> 200', 'POST', '/inventory/pc/bulk-check', '127.0.0.1', '2026-04-08 14:22:59'),
(411, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 14:28:42'),
(412, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/pc/bulk-check -> 200', 'POST', '/inventory/pc/bulk-check', '127.0.0.1', '2026-04-08 14:28:49'),
(413, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/pc/bulk-damaged -> 200', 'POST', '/inventory/pc/bulk-damaged', '127.0.0.1', '2026-04-08 14:30:02'),
(414, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/pc/bulk-check -> 200', 'POST', '/inventory/pc/bulk-check', '127.0.0.1', '2026-04-08 14:30:10'),
(415, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-08 14:30:21'),
(416, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 14:35:33'),
(417, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-08 14:35:39'),
(418, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device-bulk-damaged -> 200', 'POST', '/inventory/device-bulk-damaged', '127.0.0.1', '2026-04-08 14:36:58'),
(419, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-08 14:37:05'),
(420, 9, 'admin', 'Admin', 'View Page', 'Qrcode', 'Visited /qrcodegenerator', 'GET', '/qrcodegenerator', '127.0.0.1', '2026-04-08 14:38:05'),
(421, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 14:39:06'),
(422, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-08 14:39:20'),
(423, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 14:43:47'),
(424, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-08 14:43:52'),
(425, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device-bulk-damaged -> 200', 'POST', '/inventory/device-bulk-damaged', '127.0.0.1', '2026-04-08 14:44:38'),
(426, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 14:47:17'),
(427, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-08 14:47:22'),
(428, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device-bulk-damaged -> 200', 'POST', '/inventory/device-bulk-damaged', '127.0.0.1', '2026-04-08 14:47:32'),
(429, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 14:59:28'),
(430, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-08 14:59:33'),
(431, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-08 15:01:43'),
(432, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-08 15:01:45'),
(433, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-08 15:01:45'),
(434, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 15:01:50'),
(435, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-08 15:01:58'),
(436, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/pc/bulk-check -> 200', 'POST', '/inventory/pc/bulk-check', '127.0.0.1', '2026-04-08 15:04:10'),
(437, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 15:04:48'),
(438, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-08 15:04:53'),
(439, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 15:07:31'),
(440, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-08 15:10:02'),
(441, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /manage_inventory/run-device-risk-update -> 200', 'POST', '/manage_inventory/run-device-risk-update', '127.0.0.1', '2026-04-08 15:10:10'),
(442, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /manage_inventory/run-risk-update -> 200', 'POST', '/manage_inventory/run-risk-update', '127.0.0.1', '2026-04-08 15:10:18'),
(443, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 15:13:10'),
(444, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-08 15:13:16'),
(445, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 15:17:13'),
(446, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-08 15:17:17'),
(447, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 15:17:39'),
(448, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device-bulk-damaged -> 200', 'POST', '/inventory/device-bulk-damaged', '127.0.0.1', '2026-04-08 15:17:45'),
(449, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-08 15:17:54'),
(450, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 15:20:36'),
(451, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-08 15:20:40'),
(452, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-08 15:21:35'),
(453, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 15:21:37'),
(454, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-08 15:21:40'),
(455, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-08 15:21:41'),
(456, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 15:21:46'),
(457, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-08 15:21:57'),
(458, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-08 15:24:15'),
(459, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-08 15:24:16'),
(460, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-08 15:24:21'),
(461, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-08 15:24:22'),
(462, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 15:24:24'),
(463, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-08 15:24:33'),
(464, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 15:27:19'),
(465, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-08 15:27:24'),
(466, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/pc/bulk-check -> 200', 'POST', '/inventory/pc/bulk-check', '127.0.0.1', '2026-04-08 15:28:14'),
(467, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 15:28:56'),
(468, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-08 15:29:04'),
(469, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 15:32:32'),
(470, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-08 15:32:38'),
(471, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 15:34:21'),
(472, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-08 15:34:25'),
(473, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 15:36:21'),
(474, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-08 15:36:59'),
(475, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 15:37:00'),
(476, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-08 15:37:04'),
(477, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-08 15:37:04'),
(478, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 15:37:09'),
(479, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 15:38:36'),
(480, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-08 15:38:42'),
(481, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-08 15:41:57'),
(482, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-08 15:42:02'),
(483, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-08 15:42:02'),
(484, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-08 15:42:07'),
(485, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 15:42:09'),
(486, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-08 15:42:16'),
(487, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device-bulk-damaged -> 200', 'POST', '/inventory/device-bulk-damaged', '127.0.0.1', '2026-04-08 15:42:26'),
(488, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-08 15:42:36'),
(489, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transaction_history', 'GET', '/transaction_history', '127.0.0.1', '2026-04-08 15:42:47'),
(490, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-08 15:43:48'),
(491, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 15:43:49'),
(492, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/pc/bulk-damaged -> 200', 'POST', '/inventory/pc/bulk-damaged', '127.0.0.1', '2026-04-08 15:44:43'),
(493, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/pc/bulk-check -> 200', 'POST', '/inventory/pc/bulk-check', '127.0.0.1', '2026-04-08 15:44:52'),
(494, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transaction_history', 'GET', '/transaction_history', '127.0.0.1', '2026-04-08 15:44:57'),
(495, 9, 'admin', 'Admin', 'View Page', 'Maintenance', 'Visited /maintenance/history', 'GET', '/maintenance/history', '127.0.0.1', '2026-04-08 15:46:11'),
(496, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-08 15:46:26'),
(497, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 15:46:28'),
(498, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-08 23:36:24'),
(499, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-08 23:36:27'),
(500, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-08 23:36:27'),
(501, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 23:36:33'),
(502, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 23:38:46'),
(503, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 23:39:09'),
(504, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 23:40:12'),
(505, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 23:41:47'),
(506, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-08 23:42:35'),
(507, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-08 23:42:38'),
(508, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-08 23:42:38'),
(509, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-08 23:42:47'),
(510, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 23:42:49'),
(511, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 23:42:50'),
(512, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 23:43:02'),
(513, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 23:43:08'),
(514, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 23:43:09'),
(515, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 23:43:09'),
(516, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 23:47:52'),
(517, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-08 23:49:26'),
(518, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 00:11:27'),
(519, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 00:11:29'),
(520, 9, 'admin', 'Admin', 'Logout', 'Authentication', 'User signed out', 'POST', '/login/logout', '127.0.0.1', '2026-04-09 00:11:44'),
(521, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-09 00:11:47'),
(522, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 00:11:47'),
(523, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 00:12:09'),
(524, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 00:12:10'),
(525, 9, 'admin', 'Admin', 'Logout', 'Authentication', 'User signed out', 'POST', '/login/logout', '127.0.0.1', '2026-04-09 00:12:21'),
(526, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-09 00:12:23'),
(527, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 00:12:23'),
(528, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 00:12:50'),
(529, 9, 'admin', 'Admin', 'Logout', 'Authentication', 'User signed out', 'POST', '/login/logout', '127.0.0.1', '2026-04-09 00:12:59'),
(530, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-09 00:15:36'),
(531, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 00:15:37'),
(532, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 00:15:41'),
(533, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 00:15:53'),
(534, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 00:16:55'),
(535, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-09 00:17:30'),
(536, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-09 00:17:33'),
(537, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 00:17:33'),
(538, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 00:21:17'),
(539, 9, 'admin', 'Admin', 'Logout', 'Authentication', 'User signed out', 'POST', '/login/logout', '127.0.0.1', '2026-04-09 00:21:30'),
(540, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-09 00:21:32'),
(541, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 00:21:32'),
(542, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 00:21:34'),
(543, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 00:23:03'),
(544, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 00:24:00'),
(545, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 00:27:24'),
(546, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 00:27:28'),
(547, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 00:27:32'),
(548, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 00:29:06'),
(549, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 00:29:10'),
(550, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 00:29:12'),
(551, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 00:29:29'),
(552, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=surrendered', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 00:29:31'),
(553, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 00:29:35'),
(554, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 00:29:36'),
(555, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 00:29:41'),
(556, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 00:30:50'),
(557, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 00:30:51'),
(558, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-09 00:31:23'),
(559, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-09 00:31:26'),
(560, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 00:31:26'),
(561, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 00:31:30'),
(562, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-09 00:36:32'),
(563, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-09 00:36:35'),
(564, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 00:36:35'),
(565, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 00:36:39'),
(566, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 00:39:59'),
(567, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 00:43:29'),
(568, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 00:43:56'),
(569, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 00:44:27'),
(570, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 00:44:34'),
(571, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-09 00:44:35'),
(572, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 00:44:37'),
(573, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 00:44:54'),
(574, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-09 00:47:11'),
(575, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-09 00:47:26'),
(576, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 00:47:27'),
(577, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 00:47:31'),
(578, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 00:49:17'),
(579, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 00:49:43'),
(580, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 01:57:29'),
(581, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 01:57:35'),
(582, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 01:57:38'),
(583, 9, 'admin', 'Admin', 'Delete Item', 'PC Management', 'POST /delete-pc/121 -> 200', 'POST', '/delete-pc/121', '127.0.0.1', '2026-04-09 01:57:45'),
(584, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 01:57:48'),
(585, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 01:58:48'),
(586, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 02:00:05'),
(587, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 02:00:19'),
(588, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:00:23'),
(589, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/51 -> 200', 'POST', '/manage_inventory/delete-item/51', '127.0.0.1', '2026-04-09 02:00:35'),
(590, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 02:00:38'),
(591, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 02:00:53'),
(592, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:00:57'),
(593, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/49 -> 200', 'POST', '/manage_inventory/delete-item/49', '127.0.0.1', '2026-04-09 02:01:17'),
(594, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/47 -> 404', 'POST', '/delete-item/47', '127.0.0.1', '2026-04-09 02:01:22'),
(595, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/47 -> 404', 'POST', '/delete-item/47', '127.0.0.1', '2026-04-09 02:01:29'),
(596, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/56 -> 404', 'POST', '/delete-item/56', '127.0.0.1', '2026-04-09 02:01:37'),
(597, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/29 -> 404', 'POST', '/delete-item/29', '127.0.0.1', '2026-04-09 02:01:48'),
(598, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/14 -> 404', 'POST', '/delete-item/14', '127.0.0.1', '2026-04-09 02:02:03'),
(599, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/14 -> 404', 'POST', '/delete-item/14', '127.0.0.1', '2026-04-09 02:02:19'),
(600, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/14 -> 404', 'POST', '/delete-item/14', '127.0.0.1', '2026-04-09 02:02:45'),
(601, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/14 -> 404', 'POST', '/delete-item/14', '127.0.0.1', '2026-04-09 02:03:00'),
(602, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item&item_page=4&per_page=10', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:06:10'),
(603, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/49 -> 404', 'POST', '/delete-item/49', '127.0.0.1', '2026-04-09 02:06:19'),
(604, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/49 -> 404', 'POST', '/delete-item/49', '127.0.0.1', '2026-04-09 02:06:22'),
(605, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item&item_page=1&per_page=10', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:08:07'),
(606, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/49 -> 200', 'POST', '/manage_inventory/delete-item/49', '127.0.0.1', '2026-04-09 02:08:14'),
(607, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 02:08:20'),
(608, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:08:24'),
(609, 9, 'admin', 'Admin', 'Delete Item', 'PC Management', 'POST /delete-pc/121 -> 200', 'POST', '/delete-pc/121', '127.0.0.1', '2026-04-09 02:08:36'),
(610, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/49 -> 200', 'POST', '/manage_inventory/delete-item/49', '127.0.0.1', '2026-04-09 02:08:44'),
(611, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/49 -> 404', 'POST', '/delete-item/49', '127.0.0.1', '2026-04-09 02:08:51'),
(612, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 02:09:11'),
(613, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:09:18'),
(614, 9, 'admin', 'Admin', 'Delete Item', 'PC Management', 'POST /delete-pc/121 -> 200', 'POST', '/delete-pc/121', '127.0.0.1', '2026-04-09 02:09:22'),
(615, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:09:26'),
(616, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:09:36'),
(617, 9, 'admin', 'Admin', 'Delete Item', 'PC Management', 'POST /delete-pc/121 -> 200', 'POST', '/delete-pc/121', '127.0.0.1', '2026-04-09 02:09:41'),
(618, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:09:45'),
(619, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 02:09:47'),
(620, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 02:09:50'),
(621, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:09:52'),
(622, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:13:32'),
(623, 9, 'admin', 'Admin', 'Delete Item', 'PC Management', 'POST /delete-pc/121 -> 200', 'POST', '/delete-pc/121', '127.0.0.1', '2026-04-09 02:13:46'),
(624, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:13:49'),
(625, 9, 'admin', 'Admin', 'Delete Item', 'PC Management', 'POST /delete-pc/121 -> 200', 'POST', '/delete-pc/121', '127.0.0.1', '2026-04-09 02:13:55'),
(626, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:14:02'),
(627, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 02:14:04'),
(628, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 02:14:07'),
(629, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 02:14:14'),
(630, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:14:16'),
(631, 9, 'admin', 'Admin', 'Delete Item', 'PC Management', 'POST /delete-pc/121 -> 200', 'POST', '/delete-pc/121', '127.0.0.1', '2026-04-09 02:14:21'),
(632, 9, 'admin', 'Admin', 'Delete Item', 'PC Management', 'POST /delete-pc/106 -> 200', 'POST', '/delete-pc/106', '127.0.0.1', '2026-04-09 02:14:30'),
(633, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 02:14:34'),
(634, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:14:38'),
(635, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 02:15:03'),
(636, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:15:08'),
(637, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:18:29'),
(638, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 02:18:38'),
(639, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:19:52'),
(640, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/49 -> 200', 'POST', '/manage_inventory/delete-item/49', '127.0.0.1', '2026-04-09 02:20:02'),
(641, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/49 -> 404', 'POST', '/delete-item/49', '127.0.0.1', '2026-04-09 02:20:10'),
(642, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:20:13'),
(643, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/57 -> 200', 'POST', '/manage_inventory/delete-item/57', '127.0.0.1', '2026-04-09 02:20:25'),
(644, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 02:20:30'),
(645, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:20:54'),
(646, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:21:01'),
(647, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/57 -> 200', 'POST', '/manage_inventory/delete-item/57', '127.0.0.1', '2026-04-09 02:21:07'),
(648, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/57 -> 404', 'POST', '/delete-item/57', '127.0.0.1', '2026-04-09 02:21:15'),
(649, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/57 -> 404', 'POST', '/delete-item/57', '127.0.0.1', '2026-04-09 02:21:17'),
(650, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:23:51'),
(651, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/57 -> 200', 'POST', '/manage_inventory/delete-item/57', '127.0.0.1', '2026-04-09 02:23:56'),
(652, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 02:24:04'),
(653, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:24:07'),
(654, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:27:23'),
(655, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/57 -> 200', 'POST', '/manage_inventory/delete-item/57', '127.0.0.1', '2026-04-09 02:27:31'),
(656, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 02:27:35');
INSERT INTO `user_activity_log` (`log_id`, `user_id`, `username`, `role`, `action`, `module`, `details`, `http_method`, `route`, `ip_address`, `created_at`) VALUES
(657, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:27:36'),
(658, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 02:27:36'),
(659, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:27:41'),
(660, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/57 -> 200', 'POST', '/manage_inventory/delete-item/57', '127.0.0.1', '2026-04-09 02:27:58'),
(661, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:32:02'),
(662, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/57 -> 200', 'POST', '/manage_inventory/delete-item/57', '127.0.0.1', '2026-04-09 02:32:08'),
(663, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/57 -> 200', 'POST', '/manage_inventory/delete-item/57', '127.0.0.1', '2026-04-09 02:32:08'),
(664, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/57 -> 404', 'POST', '/delete-item/57', '127.0.0.1', '2026-04-09 02:32:15'),
(665, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/57 -> 404', 'POST', '/delete-item/57', '127.0.0.1', '2026-04-09 02:32:15'),
(666, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:48:46'),
(667, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/57 -> 200', 'POST', '/manage_inventory/delete-item/57', '127.0.0.1', '2026-04-09 02:48:51'),
(668, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/57 -> 200', 'POST', '/manage_inventory/delete-item/57', '127.0.0.1', '2026-04-09 02:48:51'),
(669, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/57 -> 404', 'POST', '/delete-item/57', '127.0.0.1', '2026-04-09 02:49:01'),
(670, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/57 -> 404', 'POST', '/delete-item/57', '127.0.0.1', '2026-04-09 02:49:01'),
(671, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 02:49:13'),
(672, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/57 -> 200', 'POST', '/manage_inventory/delete-item/57', '127.0.0.1', '2026-04-09 02:49:17'),
(673, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 03:39:01'),
(674, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/57 -> 200', 'POST', '/manage_inventory/delete-item/57', '127.0.0.1', '2026-04-09 03:40:43'),
(675, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/51 -> 404', 'POST', '/delete-item/51', '127.0.0.1', '2026-04-09 03:40:58'),
(676, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/51 -> 404', 'POST', '/delete-item/51', '127.0.0.1', '2026-04-09 03:41:01'),
(677, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/51 -> 404', 'POST', '/delete-item/51', '127.0.0.1', '2026-04-09 03:41:08'),
(678, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 03:42:49'),
(679, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 03:43:01'),
(680, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 03:47:06'),
(681, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/57 -> 404', 'POST', '/delete-item/57', '127.0.0.1', '2026-04-09 03:47:11'),
(682, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 03:47:29'),
(683, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/49 -> 404', 'POST', '/delete-item/49', '127.0.0.1', '2026-04-09 03:47:35'),
(684, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 03:53:33'),
(685, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/57 -> 404', 'POST', '/delete-item/57', '127.0.0.1', '2026-04-09 03:53:40'),
(686, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/57 -> 404', 'POST', '/delete-item/57', '127.0.0.1', '2026-04-09 07:00:00'),
(687, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 07:00:03'),
(688, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/57 -> 404', 'POST', '/delete-item/57', '127.0.0.1', '2026-04-09 07:00:11'),
(689, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 07:00:15'),
(690, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 07:02:32'),
(691, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 07:03:30'),
(692, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 07:04:11'),
(693, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/57 -> 404', 'POST', '/delete-item/57', '127.0.0.1', '2026-04-09 07:04:16'),
(694, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 07:04:26'),
(695, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 07:04:28'),
(696, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 07:04:38'),
(697, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-09 07:30:11'),
(698, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-09 07:30:15'),
(699, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 07:30:15'),
(700, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 07:30:17'),
(701, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 07:30:30'),
(702, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/57 -> 404', 'POST', '/delete-item/57', '127.0.0.1', '2026-04-09 07:30:37'),
(703, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 07:34:37'),
(704, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/57 -> 404', 'POST', '/delete-item/57', '127.0.0.1', '2026-04-09 07:34:46'),
(705, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/57 -> 404', 'POST', '/delete-item/57', '127.0.0.1', '2026-04-09 07:34:58'),
(706, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/56 -> 404', 'POST', '/delete-item/56', '127.0.0.1', '2026-04-09 07:35:07'),
(707, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 07:35:40'),
(708, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 07:41:11'),
(709, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 07:41:14'),
(710, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/57 -> 404', 'POST', '/delete-item/57', '127.0.0.1', '2026-04-09 07:41:21'),
(711, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 07:43:38'),
(712, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/57 -> 404', 'POST', '/delete-item/57', '127.0.0.1', '2026-04-09 07:43:44'),
(713, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 07:48:51'),
(714, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-09 07:50:04'),
(715, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-09 07:50:07'),
(716, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 07:50:07'),
(717, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-09 07:50:12'),
(718, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-09 07:50:18'),
(719, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-09 07:51:16'),
(720, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-09 07:51:20'),
(721, 9, 'admin', 'Admin', 'View Page', 'Manage User', 'Visited /manage-user', 'GET', '/manage-user', '127.0.0.1', '2026-04-09 07:51:22'),
(722, 9, 'admin', 'Admin', 'View Page', 'Stock Room', 'Visited /stock_room/stock-room', 'GET', '/stock_room/stock-room', '127.0.0.1', '2026-04-09 07:51:22'),
(723, 9, 'admin', 'Admin', 'View Page', 'Qrcode', 'Visited /qrcodegenerator', 'GET', '/qrcodegenerator', '127.0.0.1', '2026-04-09 07:51:23'),
(724, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 07:51:25'),
(725, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/50 -> 404', 'POST', '/delete-item/50', '127.0.0.1', '2026-04-09 07:51:38'),
(726, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 07:53:05'),
(727, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/57 -> 404', 'POST', '/delete-item/57', '127.0.0.1', '2026-04-09 07:53:12'),
(728, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/52 -> 404', 'POST', '/delete-item/52', '127.0.0.1', '2026-04-09 07:53:30'),
(729, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-09 07:55:14'),
(730, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-09 07:55:16'),
(731, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 07:55:17'),
(732, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 07:59:27'),
(733, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 07:59:52'),
(734, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-09 08:00:21'),
(735, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-09 08:00:25'),
(736, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 08:00:25'),
(737, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-09 08:02:13'),
(738, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-09 08:02:16'),
(739, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 08:02:16'),
(740, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 08:02:49'),
(741, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-09 08:04:27'),
(742, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-09 08:04:41'),
(743, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 08:04:41'),
(744, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 08:04:46'),
(745, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-09 08:04:47'),
(746, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 08:04:58'),
(747, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-09 08:12:21'),
(748, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-09 08:12:24'),
(749, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 08:12:24'),
(750, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 08:12:27'),
(751, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/57 -> 404', 'POST', '/delete-item/57', '127.0.0.1', '2026-04-09 08:12:35'),
(752, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 08:16:08'),
(753, 9, 'admin', 'Admin', 'Submit', 'System', 'POST /delete-item/57 -> 404', 'POST', '/delete-item/57', '127.0.0.1', '2026-04-09 08:16:13'),
(754, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 08:18:46'),
(755, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/57 -> 200', 'POST', '/manage_inventory/delete-item/57', '127.0.0.1', '2026-04-09 08:18:51'),
(756, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 08:18:51'),
(757, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/49 -> 200', 'POST', '/manage_inventory/delete-item/49', '127.0.0.1', '2026-04-09 08:19:00'),
(758, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 08:19:00'),
(759, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/49 -> 200', 'POST', '/manage_inventory/delete-item/49', '127.0.0.1', '2026-04-09 08:19:07'),
(760, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 08:19:07'),
(761, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/49 -> 200', 'POST', '/manage_inventory/delete-item/49', '127.0.0.1', '2026-04-09 08:19:13'),
(762, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 08:19:13'),
(763, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 08:19:18'),
(764, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 08:21:59'),
(765, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 08:22:02'),
(766, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/49 -> 200', 'POST', '/manage_inventory/delete-item/49', '127.0.0.1', '2026-04-09 08:22:08'),
(767, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 08:22:08'),
(768, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 08:31:34'),
(769, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/49 -> 200', 'POST', '/manage_inventory/delete-item/49', '127.0.0.1', '2026-04-09 08:31:39'),
(770, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 08:31:40'),
(771, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/47 -> 200', 'POST', '/manage_inventory/delete-item/47', '127.0.0.1', '2026-04-09 08:31:49'),
(772, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 08:31:50'),
(773, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/47 -> 200', 'POST', '/manage_inventory/delete-item/47', '127.0.0.1', '2026-04-09 08:31:57'),
(774, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 08:31:58'),
(775, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 08:34:39'),
(776, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/47 -> 200', 'POST', '/manage_inventory/delete-item/47', '127.0.0.1', '2026-04-09 08:34:47'),
(777, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 08:34:47'),
(778, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-09 08:35:19'),
(779, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-09 08:35:22'),
(780, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 08:35:22'),
(781, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 08:35:26'),
(782, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 08:35:31'),
(783, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 08:37:05'),
(784, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/47 -> 200', 'POST', '/manage_inventory/delete-item/47', '127.0.0.1', '2026-04-09 08:37:10'),
(785, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 08:37:11'),
(786, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-09 08:37:51'),
(787, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-09 08:37:55'),
(788, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 08:37:55'),
(789, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 08:38:03'),
(790, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/47 -> 200', 'POST', '/manage_inventory/delete-item/47', '127.0.0.1', '2026-04-09 08:38:11'),
(791, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 08:38:11'),
(792, 9, 'admin', 'Admin', 'Delete Item', 'PC Management', 'POST /delete-pc/105 -> 200', 'POST', '/delete-pc/105', '127.0.0.1', '2026-04-09 08:38:38'),
(793, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 08:38:42'),
(794, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 08:38:45'),
(795, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 08:38:47'),
(796, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-09 08:47:43'),
(797, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-09 08:47:45'),
(798, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 08:47:45'),
(799, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 08:47:57'),
(800, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 08:48:03'),
(801, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 08:48:08'),
(802, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-09 12:33:43'),
(803, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 12:33:50'),
(804, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-09 12:33:53'),
(805, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-09 12:33:58'),
(806, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-09 12:37:31'),
(807, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-10 12:07:05'),
(808, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-10 12:07:09'),
(809, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-10 12:07:09'),
(810, 9, 'admin', 'Admin', 'View Page', 'Maintenance', 'Visited /maintenance/history', 'GET', '/maintenance/history', '127.0.0.1', '2026-04-10 12:07:13'),
(811, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transaction_history', 'GET', '/transaction_history', '127.0.0.1', '2026-04-10 12:07:58'),
(812, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-10 12:07:59'),
(813, 9, 'admin', 'Admin', 'View Page', 'Damage Report', 'Visited /damage-report', 'GET', '/damage-report', '127.0.0.1', '2026-04-10 12:08:00'),
(814, 9, 'admin', 'Admin', 'View Page', 'Maintenance', 'Visited /maintenance/history', 'GET', '/maintenance/history', '127.0.0.1', '2026-04-10 12:08:01'),
(815, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-10 12:08:02'),
(816, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-10 12:08:03'),
(817, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-10 12:08:03'),
(818, 9, 'admin', 'Admin', 'View Page', 'Manage User', 'Visited /manage-user', 'GET', '/manage-user', '127.0.0.1', '2026-04-10 12:08:05'),
(819, 9, 'admin', 'Admin', 'View Page', 'Stock Room', 'Visited /stock_room/stock-room', 'GET', '/stock_room/stock-room', '127.0.0.1', '2026-04-10 12:08:05'),
(820, 9, 'admin', 'Admin', 'View Page', 'Qrcode', 'Visited /qrcodegenerator', 'GET', '/qrcodegenerator', '127.0.0.1', '2026-04-10 12:08:06'),
(821, 9, 'admin', 'Admin', 'View Page', 'Stock Room', 'Visited /stock_room/stock-room', 'GET', '/stock_room/stock-room', '127.0.0.1', '2026-04-10 12:08:07'),
(822, 9, 'admin', 'Admin', 'View Page', 'Qrcode', 'Visited /qrcodegenerator', 'GET', '/qrcodegenerator', '127.0.0.1', '2026-04-10 12:08:10'),
(823, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-10 12:08:12'),
(824, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-10 12:08:13'),
(825, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-10 12:08:14'),
(826, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-10 12:30:32'),
(827, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-10 12:30:35'),
(828, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-10 12:30:35'),
(829, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-10 12:30:40'),
(830, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/56 -> 200', 'POST', '/manage_inventory/delete-item/56', '127.0.0.1', '2026-04-10 12:30:46'),
(831, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-10 12:30:47'),
(832, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-10 12:30:50'),
(833, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-10 12:32:24'),
(834, 9, 'admin', 'Admin', 'Delete Item', 'PC Management', 'POST /delete-pc/104 -> 200', 'POST', '/delete-pc/104', '127.0.0.1', '2026-04-10 12:32:30'),
(835, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-10 12:32:35'),
(836, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-10 12:37:03'),
(837, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-10 12:37:04'),
(838, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-10 12:38:54'),
(839, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-10 12:41:38'),
(840, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-11 12:59:26'),
(841, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-11 12:59:28'),
(842, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-11 12:59:29'),
(843, 9, 'admin', 'Admin', 'Logout', 'Authentication', 'User signed out', 'POST', '/login/logout', '127.0.0.1', '2026-04-11 12:59:39'),
(844, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-11 13:00:58'),
(845, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-11 13:00:58'),
(846, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-11 13:01:27'),
(847, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-11 13:02:15'),
(848, 9, 'admin', 'Admin', 'View Page', 'Qrcode', 'Visited /qrcodegenerator', 'GET', '/qrcodegenerator', '127.0.0.1', '2026-04-11 13:04:29'),
(849, 9, 'admin', 'Admin', 'View Page', 'Stock Room', 'Visited /stock_room/stock-room', 'GET', '/stock_room/stock-room', '127.0.0.1', '2026-04-11 13:04:56'),
(850, 9, 'admin', 'Admin', 'View Page', 'Manage User', 'Visited /manage-user', 'GET', '/manage-user', '127.0.0.1', '2026-04-11 13:05:56'),
(851, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-11 13:06:22'),
(852, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-11 13:07:43'),
(853, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-11 13:07:46'),
(854, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-11 13:07:47'),
(855, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-11 13:07:54'),
(856, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-11 13:08:29'),
(857, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-11 13:08:30'),
(858, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-11 13:08:31'),
(859, 9, 'admin', 'Admin', 'View Page', 'Manage User', 'Visited /manage-user', 'GET', '/manage-user', '127.0.0.1', '2026-04-11 13:08:32'),
(860, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-11 13:08:35'),
(861, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-11 13:11:06'),
(862, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-11 13:11:08'),
(863, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-11 13:11:08'),
(864, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-11 13:11:12'),
(865, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '192.168.1.243', '2026-04-11 13:14:19'),
(866, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '192.168.1.243', '2026-04-11 13:14:20'),
(867, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '192.168.1.243', '2026-04-11 13:14:23'),
(868, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-11 13:18:20'),
(869, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-11 13:18:23'),
(870, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-11 13:18:23'),
(871, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-11 13:18:26'),
(872, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-11 13:21:41'),
(873, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-11 13:21:46'),
(874, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-11 13:21:46'),
(875, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-11 13:21:49'),
(876, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-11 13:23:11'),
(877, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-11 13:23:32'),
(878, 9, 'admin', 'Admin', 'View Page', 'Damage Report', 'Visited /damage-report', 'GET', '/damage-report', '127.0.0.1', '2026-04-11 13:23:56'),
(879, 9, 'admin', 'Admin', 'View Page', 'Maintenance', 'Visited /maintenance/history', 'GET', '/maintenance/history', '127.0.0.1', '2026-04-11 13:24:16'),
(880, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transaction_history', 'GET', '/transaction_history', '127.0.0.1', '2026-04-11 13:25:07'),
(881, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-11 13:25:38'),
(882, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-12 05:01:44'),
(883, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-12 05:01:48'),
(884, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-12 05:01:49'),
(885, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-12 05:01:54'),
(886, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/pc/bulk-check -> 200', 'POST', '/inventory/pc/bulk-check', '127.0.0.1', '2026-04-12 05:02:00'),
(887, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-12 05:02:32'),
(888, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-12 05:02:51'),
(889, 9, 'admin', 'Admin', 'Mark Selected as Checked', 'Consumable Management', 'POST /consumable/bulk-check -> 200', 'POST', '/consumable/bulk-check', '127.0.0.1', '2026-04-12 05:03:04'),
(890, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /manage_inventory/run-device-risk-update -> 200', 'POST', '/manage_inventory/run-device-risk-update', '127.0.0.1', '2026-04-12 05:03:24'),
(891, 9, 'admin', 'Admin', 'Delete Item', 'Item Management', 'POST /manage_inventory/delete-item/52 -> 200', 'POST', '/manage_inventory/delete-item/52', '127.0.0.1', '2026-04-12 05:04:10'),
(892, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-12 05:04:10'),
(893, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transaction_history', 'GET', '/transaction_history', '127.0.0.1', '2026-04-12 05:05:35'),
(894, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-12 05:05:37'),
(895, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-12 05:05:44'),
(896, 9, 'admin', 'Admin', 'Export File', 'PC Management', 'POST /manage_pc/export-selected-pcs -> 200', 'POST', '/manage_pc/export-selected-pcs', '127.0.0.1', '2026-04-12 05:06:34'),
(897, 9, 'admin', 'Admin', 'Export File', 'PC Management', 'POST /manage_pc/export-selected-pcs -> 200', 'POST', '/manage_pc/export-selected-pcs', '127.0.0.1', '2026-04-12 05:06:47'),
(898, 9, 'admin', 'Admin', 'Export File', 'PC Management', 'POST /manage_pc/export-selected-pcs -> 200', 'POST', '/manage_pc/export-selected-pcs', '127.0.0.1', '2026-04-12 05:06:53'),
(899, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc&page=1&per_page=10', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-12 05:10:12'),
(900, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item&page=1&per_page=10', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-12 05:10:20'),
(901, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/pc/bulk-damaged -> 200', 'POST', '/inventory/pc/bulk-damaged', '127.0.0.1', '2026-04-12 05:11:16'),
(902, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/pc/bulk-check -> 200', 'POST', '/inventory/pc/bulk-check', '127.0.0.1', '2026-04-12 05:11:51'),
(903, 9, 'admin', 'Admin', 'Export File', 'PC Management', 'POST /manage_pc/export-selected-pcs -> 200', 'POST', '/manage_pc/export-selected-pcs', '127.0.0.1', '2026-04-12 05:12:06'),
(904, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-12 05:15:48'),
(905, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-12 05:25:00'),
(906, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-12 05:25:04'),
(907, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-12 05:25:04'),
(908, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-12 05:25:08'),
(909, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-surrender -> 200', 'POST', '/inventory/device/bulk-surrender', '127.0.0.1', '2026-04-12 05:25:16'),
(910, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device-bulk-damaged -> 200', 'POST', '/inventory/device-bulk-damaged', '127.0.0.1', '2026-04-12 05:25:52'),
(911, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-12 05:26:05'),
(912, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-12 05:29:24'),
(913, 9, 'admin', 'Admin', 'Submit', 'Manage Item', 'POST /manage_inventory/export-selected-devices -> 200', 'POST', '/manage_inventory/export-selected-devices', '127.0.0.1', '2026-04-12 05:29:29'),
(914, 9, 'admin', 'Admin', 'Submit', 'Manage Item', 'POST /manage_inventory/export-selected-devices -> 200', 'POST', '/manage_inventory/export-selected-devices', '127.0.0.1', '2026-04-12 05:31:31'),
(915, 9, 'admin', 'Admin', 'Export File', 'PC Management', 'POST /manage_pc/export-selected-pcs -> 200', 'POST', '/manage_pc/export-selected-pcs', '127.0.0.1', '2026-04-12 05:31:51'),
(916, 9, 'admin', 'Admin', 'Export File', 'PC Management', 'POST /manage_pc/export-selected-pcs -> 200', 'POST', '/manage_pc/export-selected-pcs', '127.0.0.1', '2026-04-12 05:35:08'),
(917, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-12 05:37:39'),
(918, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-12 05:37:40'),
(919, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-12 05:37:43'),
(920, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-12 05:37:43'),
(921, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-12 05:37:47'),
(922, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device-bulk-damaged -> 200', 'POST', '/inventory/device-bulk-damaged', '127.0.0.1', '2026-04-12 05:37:57'),
(923, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/device/bulk-check -> 200', 'POST', '/inventory/device/bulk-check', '127.0.0.1', '2026-04-12 05:38:05'),
(924, 9, 'admin', 'Admin', 'Export File', 'PC Management', 'POST /manage_pc/export-selected-pcs -> 200', 'POST', '/manage_pc/export-selected-pcs', '127.0.0.1', '2026-04-12 05:38:13'),
(925, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-12 05:50:46'),
(926, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-12 05:50:49'),
(927, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-12 05:50:49'),
(928, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-12 05:50:55'),
(929, 9, 'admin', 'Admin', 'Export File', 'PC Management', 'POST /manage_pc/export-selected-pcs -> 200', 'POST', '/manage_pc/export-selected-pcs', '127.0.0.1', '2026-04-12 05:50:58'),
(930, 9, 'admin', 'Admin', 'View Page', 'Qrcode', 'Visited /qrcodegenerator', 'GET', '/qrcodegenerator', '127.0.0.1', '2026-04-12 05:51:15'),
(931, 9, 'admin', 'Admin', 'View Page', 'Stock Room', 'Visited /stock_room/stock-room', 'GET', '/stock_room/stock-room', '127.0.0.1', '2026-04-12 05:51:17'),
(932, 9, 'admin', 'Admin', 'View Page', 'Manage User', 'Visited /manage-user', 'GET', '/manage-user', '127.0.0.1', '2026-04-12 05:51:19'),
(933, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-12 05:51:20'),
(934, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-12 05:51:21'),
(935, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-12 05:51:24'),
(936, 9, 'admin', 'Admin', 'Export File', 'Reports', 'GET /export-reports?name=&category=all&department=all&status=all&date_from=&date_to= -> 200', 'GET', '/export-reports', '127.0.0.1', '2026-04-12 05:51:25'),
(937, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-12 05:53:36'),
(938, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-12 05:53:37'),
(939, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-12 05:53:52'),
(940, 9, 'admin', 'Admin', 'Export File', 'Reports', 'GET /export-reports?name=&category=all&department=all&status=all&date_from=&date_to= -> 200', 'GET', '/export-reports', '127.0.0.1', '2026-04-12 05:53:54'),
(941, 9, 'admin', 'Admin', 'View Page', 'Damage Report', 'Visited /damage-report', 'GET', '/damage-report', '127.0.0.1', '2026-04-12 05:54:13'),
(942, 9, 'admin', 'Admin', 'View Page', 'Damage Report', 'Visited /damage-report', 'GET', '/damage-report', '127.0.0.1', '2026-04-12 05:54:16'),
(943, 9, 'admin', 'Admin', 'View Page', 'Damage Report', 'Visited /damage-report', 'GET', '/damage-report', '127.0.0.1', '2026-04-12 05:54:18'),
(944, 9, 'admin', 'Admin', 'View Page', 'Damage Report', 'Visited /damage-report', 'GET', '/damage-report', '127.0.0.1', '2026-04-12 05:56:22'),
(945, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-12 05:56:46'),
(946, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transaction_history', 'GET', '/transaction_history', '127.0.0.1', '2026-04-12 05:56:47'),
(947, 9, 'admin', 'Admin', 'View Page', 'Maintenance', 'Visited /maintenance/history', 'GET', '/maintenance/history', '127.0.0.1', '2026-04-12 05:56:48'),
(948, 9, 'admin', 'Admin', 'View Page', 'Maintenance', 'Visited /maintenance/history', 'GET', '/maintenance/history', '127.0.0.1', '2026-04-12 06:04:25'),
(949, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-13 00:09:55'),
(950, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-13 00:10:19'),
(951, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-13 00:10:20'),
(952, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 00:10:26'),
(953, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 00:10:30'),
(954, 9, 'admin', 'Admin', 'Delete Item', 'PC Management', 'POST /delete-pc/103 -> 200', 'POST', '/delete-pc/103', '127.0.0.1', '2026-04-13 00:10:35'),
(955, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-13 00:10:37'),
(956, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 00:11:41'),
(957, 9, 'admin', 'Admin', 'Delete Item', 'PC Management', 'POST /delete-pc/102 -> 200', 'POST', '/delete-pc/102', '127.0.0.1', '2026-04-13 00:11:47'),
(958, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-13 00:11:59'),
(959, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-13 00:13:21'),
(960, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 00:16:19'),
(961, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-13 00:27:11'),
(962, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-13 00:27:13'),
(963, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-13 00:27:13'),
(964, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-13 00:50:23'),
(965, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-13 00:50:26'),
(966, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-13 00:50:26'),
(967, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 00:50:39'),
(968, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 00:50:54'),
(969, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 00:51:12'),
(970, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-13 00:51:45'),
(971, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 00:52:05'),
(972, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable&page=2&per_page=10', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 00:53:46'),
(973, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-13 00:54:32'),
(974, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-13 00:54:35'),
(975, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-13 00:54:35'),
(976, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 00:54:39'),
(977, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 00:57:35'),
(978, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-13 01:01:29'),
(979, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-13 01:01:31'),
(980, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-13 01:01:31'),
(981, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 01:01:37'),
(982, 9, 'admin', 'Admin', 'Delete Item', 'Consumable Management', 'POST /delete-consumable/57 -> 400', 'POST', '/delete-consumable/57', '127.0.0.1', '2026-04-13 01:01:53'),
(983, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 01:09:47'),
(984, 9, 'admin', 'Admin', 'Delete Item', 'Consumable Management', 'POST /delete-consumable/57 -> 400', 'POST', '/delete-consumable/57', '127.0.0.1', '2026-04-13 01:09:51'),
(985, 9, 'admin', 'Admin', 'Delete Item', 'Consumable Management', 'POST /delete-consumable/57 -> 400', 'POST', '/delete-consumable/57', '127.0.0.1', '2026-04-13 01:10:06'),
(986, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 01:10:49'),
(987, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 01:17:14'),
(988, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 01:21:04'),
(989, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 01:54:27'),
(990, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 01:54:40'),
(991, 9, 'admin', 'Admin', 'Submit', 'Manage Consumable', 'POST /archive-consumable/54 -> 200', 'POST', '/archive-consumable/54', '127.0.0.1', '2026-04-13 01:54:47');
INSERT INTO `user_activity_log` (`log_id`, `user_id`, `username`, `role`, `action`, `module`, `details`, `http_method`, `route`, `ip_address`, `created_at`) VALUES
(992, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 01:54:52'),
(993, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 01:54:57'),
(994, 9, 'admin', 'Admin', 'Submit', 'Manage Consumable', 'POST /archive-consumable/57 -> 200', 'POST', '/archive-consumable/57', '127.0.0.1', '2026-04-13 01:55:09'),
(995, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 01:55:16'),
(996, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 01:59:16'),
(997, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-13 01:59:21'),
(998, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 01:59:23'),
(999, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 02:00:24'),
(1000, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 02:03:02'),
(1001, 9, 'admin', 'Admin', 'Add Item', 'Consumable Management', 'POST /add-consumable -> 200', 'POST', '/add-consumable', '127.0.0.1', '2026-04-13 02:03:51'),
(1002, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 02:03:57'),
(1003, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 02:11:39'),
(1004, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 02:22:05'),
(1005, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 02:24:29'),
(1006, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 02:26:36'),
(1007, 9, 'admin', 'Admin', 'Submit', 'Manage Consumable', 'POST /archive-consumable/58 -> 200', 'POST', '/archive-consumable/58', '127.0.0.1', '2026-04-13 02:26:54'),
(1008, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable&consumable_page=1&per_page=10', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 02:27:02'),
(1009, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable&consumable_page=1&per_page=10', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 02:28:26'),
(1010, 9, 'admin', 'Admin', 'Submit', 'Manage Consumable', 'POST /archive-consumable/58 -> 200', 'POST', '/archive-consumable/58', '127.0.0.1', '2026-04-13 02:28:31'),
(1011, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 02:28:39'),
(1012, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 02:31:27'),
(1013, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 02:34:41'),
(1014, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-13 02:50:08'),
(1015, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-13 02:50:10'),
(1016, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-13 02:50:10'),
(1017, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 02:50:15'),
(1018, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 02:56:35'),
(1019, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-13 02:56:48'),
(1020, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 02:56:49'),
(1021, 9, 'admin', 'Admin', 'Submit', 'Manage Consumable', 'POST /archive-consumable/58 -> 200', 'POST', '/archive-consumable/58', '127.0.0.1', '2026-04-13 02:56:54'),
(1022, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 02:57:02'),
(1023, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 02:57:07'),
(1024, 9, 'admin', 'Admin', 'Submit', 'Manage Consumable', 'POST /archive-consumable/47 -> 200', 'POST', '/archive-consumable/47', '127.0.0.1', '2026-04-13 02:57:19'),
(1025, 9, 'admin', 'Admin', 'Submit', 'Manage Consumable', 'POST /archive-consumable/57 -> 200', 'POST', '/archive-consumable/57', '127.0.0.1', '2026-04-13 02:57:25'),
(1026, 9, 'admin', 'Admin', 'Submit', 'Manage Consumable', 'POST /archive-consumable/56 -> 200', 'POST', '/archive-consumable/56', '127.0.0.1', '2026-04-13 02:57:29'),
(1027, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 02:57:32'),
(1028, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 02:57:44'),
(1029, 9, 'admin', 'Admin', 'Submit', 'Manage Consumable', 'POST /archive-consumable/55 -> 200', 'POST', '/archive-consumable/55', '127.0.0.1', '2026-04-13 02:57:49'),
(1030, 9, 'admin', 'Admin', 'Submit', 'Manage Consumable', 'POST /archive-consumable/54 -> 200', 'POST', '/archive-consumable/54', '127.0.0.1', '2026-04-13 02:57:51'),
(1031, 9, 'admin', 'Admin', 'Submit', 'Manage Consumable', 'POST /archive-consumable/53 -> 200', 'POST', '/archive-consumable/53', '127.0.0.1', '2026-04-13 02:57:53'),
(1032, 9, 'admin', 'Admin', 'Submit', 'Manage Consumable', 'POST /archive-consumable/52 -> 200', 'POST', '/archive-consumable/52', '127.0.0.1', '2026-04-13 02:57:56'),
(1033, 9, 'admin', 'Admin', 'Submit', 'Manage Consumable', 'POST /archive-consumable/51 -> 200', 'POST', '/archive-consumable/51', '127.0.0.1', '2026-04-13 02:57:58'),
(1034, 9, 'admin', 'Admin', 'Submit', 'Manage Consumable', 'POST /archive-consumable/50 -> 200', 'POST', '/archive-consumable/50', '127.0.0.1', '2026-04-13 02:58:00'),
(1035, 9, 'admin', 'Admin', 'Submit', 'Manage Consumable', 'POST /archive-consumable/49 -> 200', 'POST', '/archive-consumable/49', '127.0.0.1', '2026-04-13 02:58:02'),
(1036, 9, 'admin', 'Admin', 'Submit', 'Manage Consumable', 'POST /archive-consumable/48 -> 200', 'POST', '/archive-consumable/48', '127.0.0.1', '2026-04-13 02:58:05'),
(1037, 9, 'admin', 'Admin', 'Submit', 'Manage Consumable', 'POST /archive-consumable/17 -> 200', 'POST', '/archive-consumable/17', '127.0.0.1', '2026-04-13 02:58:08'),
(1038, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 02:58:10'),
(1039, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 03:03:39'),
(1040, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-13 03:06:10'),
(1041, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-13 03:06:13'),
(1042, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-13 03:06:13'),
(1043, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 03:06:19'),
(1044, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-13 03:15:06'),
(1045, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-13 03:15:09'),
(1046, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-13 03:15:09'),
(1047, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 03:15:15'),
(1048, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=consumable', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 03:20:22'),
(1049, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-13 03:20:24'),
(1050, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-13 03:33:35'),
(1051, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 03:33:43'),
(1052, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-13 03:34:17'),
(1053, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-13 03:34:26'),
(1054, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 03:34:34'),
(1055, 9, 'admin', 'Admin', 'Submit', 'Manage Inventory', 'POST /inventory/pc/bulk-check -> 200', 'POST', '/inventory/pc/bulk-check', '127.0.0.1', '2026-04-13 03:34:40'),
(1056, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-13 03:34:44'),
(1057, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-13 03:34:49'),
(1058, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 03:34:52'),
(1059, 9, 'admin', 'Admin', 'View Page', 'Qrcode', 'Visited /qrcodegenerator', 'GET', '/qrcodegenerator', '127.0.0.1', '2026-04-13 03:34:54'),
(1060, 9, 'admin', 'Admin', 'View Page', 'Stock Room', 'Visited /stock_room/stock-room', 'GET', '/stock_room/stock-room', '127.0.0.1', '2026-04-13 03:34:56'),
(1061, 9, 'admin', 'Admin', 'View Page', 'Manage User', 'Visited /manage-user', 'GET', '/manage-user', '127.0.0.1', '2026-04-13 03:35:01'),
(1062, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-13 03:35:02'),
(1063, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 03:35:03'),
(1064, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-13 04:10:13'),
(1065, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-13 04:10:16'),
(1066, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-13 04:10:16'),
(1067, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 04:10:27'),
(1068, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 04:27:16'),
(1069, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-13 06:09:08'),
(1070, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-13 06:09:11'),
(1071, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-13 06:09:12'),
(1072, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 06:09:28'),
(1073, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-13 06:09:30'),
(1074, 9, 'admin', 'Admin', 'DELETE Request', 'Manage Department', 'DELETE /delete-department/29 -> 409', 'DELETE', '/delete-department/29', '127.0.0.1', '2026-04-13 06:10:21'),
(1075, 9, 'admin', 'Admin', 'DELETE Request', 'Manage Department', 'DELETE /delete-department/29 -> 409', 'DELETE', '/delete-department/29', '127.0.0.1', '2026-04-13 06:10:30'),
(1076, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-13 06:12:29'),
(1077, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-13 06:18:00'),
(1078, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-13 06:26:51'),
(1079, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-13 06:26:54'),
(1080, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-13 06:26:54'),
(1081, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transaction_history', 'GET', '/transaction_history', '127.0.0.1', '2026-04-13 06:26:58'),
(1082, 9, 'admin', 'Admin', 'View Page', 'Maintenance', 'Visited /maintenance/history', 'GET', '/maintenance/history', '127.0.0.1', '2026-04-13 06:26:59'),
(1083, 9, 'admin', 'Admin', 'View Page', 'Damage Report', 'Visited /damage-report', 'GET', '/damage-report', '127.0.0.1', '2026-04-13 06:27:01'),
(1084, 9, 'admin', 'Admin', 'View Page', 'Maintenance', 'Visited /maintenance/history', 'GET', '/maintenance/history', '127.0.0.1', '2026-04-13 06:27:02'),
(1085, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-13 06:27:21'),
(1086, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-13 06:27:27'),
(1087, 9, 'admin', 'Admin', 'DELETE Request', 'Manage Department', 'DELETE /delete-department/28 -> 200', 'DELETE', '/delete-department/28', '127.0.0.1', '2026-04-13 06:27:40'),
(1088, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-13 06:42:21'),
(1089, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-13 06:42:24'),
(1090, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-13 06:42:24'),
(1091, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-13 06:42:28'),
(1092, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-13 06:47:06'),
(1093, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-13 07:03:13'),
(1094, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-13 07:09:07'),
(1095, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-13 07:48:05'),
(1096, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-13 07:48:09'),
(1097, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-13 07:48:10'),
(1098, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 07:48:14'),
(1099, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transaction_history', 'GET', '/transaction_history', '127.0.0.1', '2026-04-13 07:48:16'),
(1100, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 07:48:17'),
(1101, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transaction_history', 'GET', '/transaction_history', '127.0.0.1', '2026-04-13 07:48:23'),
(1102, 9, 'admin', 'Admin', 'View Page', 'Maintenance', 'Visited /maintenance/history', 'GET', '/maintenance/history', '127.0.0.1', '2026-04-13 07:48:25'),
(1103, 9, 'admin', 'Admin', 'View Page', 'Damage Report', 'Visited /damage-report', 'GET', '/damage-report', '127.0.0.1', '2026-04-13 07:48:34'),
(1104, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-13 07:48:35'),
(1105, 9, 'admin', 'Admin', 'View Page', 'Activity Log', 'Visited /activity-log', 'GET', '/activity-log', '127.0.0.1', '2026-04-13 07:48:37'),
(1106, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-13 07:48:41'),
(1107, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 07:48:51'),
(1108, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 07:52:19'),
(1109, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 07:56:41'),
(1110, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transaction_history', 'GET', '/transaction_history', '127.0.0.1', '2026-04-13 07:56:48'),
(1111, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 07:56:50'),
(1112, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 08:09:03'),
(1113, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-13 08:15:05'),
(1114, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-13 08:15:07'),
(1115, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-13 08:15:08'),
(1116, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-13 08:15:13'),
(1117, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc&page=1&per_page=50', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 15:16:37'),
(1118, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc&page=1&per_page=50', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 15:18:34'),
(1119, 9, 'admin', 'Admin', 'Submit', 'Manage Pc', 'POST /batch_add_pcinfofull -> 200', 'POST', '/batch_add_pcinfofull', '127.0.0.1', '2026-04-13 15:19:10'),
(1120, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc&page=1&per_page=50', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-13 15:19:13'),
(1121, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc&page=1&per_page=50', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 01:01:22'),
(1122, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-14 01:02:02'),
(1123, 9, 'admin', 'Admin', 'Submit', 'Manage Department', 'POST /add-department -> 201', 'POST', '/add-department', '127.0.0.1', '2026-04-14 01:02:25'),
(1124, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-14 01:02:31'),
(1125, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 01:02:35'),
(1126, 9, 'admin', 'Admin', 'Edit Item', 'PC Management', 'POST /update-pcinfofull -> 200', 'POST', '/update-pcinfofull', '127.0.0.1', '2026-04-14 01:05:42'),
(1127, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc&page=1&per_page=10', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 01:06:47'),
(1128, 9, 'admin', 'Admin', 'Submit', 'Manage Pc', 'POST /batch_add_pcinfofull -> 500', 'POST', '/batch_add_pcinfofull', '127.0.0.1', '2026-04-14 01:07:26'),
(1129, 9, 'admin', 'Admin', 'Submit', 'Manage Pc', 'POST /batch_add_pcinfofull -> 500', 'POST', '/batch_add_pcinfofull', '127.0.0.1', '2026-04-14 01:08:07'),
(1130, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc&page=1&per_page=10', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 01:09:28'),
(1131, 9, 'admin', 'Admin', 'Submit', 'Manage Pc', 'POST /batch_add_pcinfofull -> 200', 'POST', '/batch_add_pcinfofull', '127.0.0.1', '2026-04-14 01:10:05'),
(1132, 9, 'admin', 'Admin', 'Add Item', 'Item Management', 'POST /manage_inventory/add-device -> 302', 'POST', '/manage_inventory/add-device', '127.0.0.1', '2026-04-14 01:11:48'),
(1133, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 01:11:48'),
(1134, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-14 01:33:30'),
(1135, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-14 01:33:31'),
(1136, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /?fbclid=IwY2xjawRKeZRleHRuA2FlbQIxMABicmlkETFUc0ZQTG5lSkQ3Q0Q1QWFPc3J0YwZhcHBfaWQQMjIyMDM5MTc4ODIwMDg5MgABHoXXmtUknRwwLlZF8u-qgNQjpeM8Kr2v-VmGtzo8PuHind9PtO8hJrfb3MKj_aem_QweY2Ue9vZU2WSiopN47Wg', 'GET', '/', '127.0.0.1', '2026-04-14 01:37:09'),
(1137, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-14 01:37:21'),
(1138, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-14 01:37:22'),
(1139, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-14 01:37:39'),
(1140, 9, 'admin', 'Admin', 'PUT Request', 'Manage Department', 'PUT /update-department/1 -> 200', 'PUT', '/update-department/1', '127.0.0.1', '2026-04-14 01:38:00'),
(1141, 9, 'admin', 'Admin', 'PUT Request', 'Manage Department', 'PUT /update-department/3 -> 200', 'PUT', '/update-department/3', '127.0.0.1', '2026-04-14 01:38:14'),
(1142, 9, 'admin', 'Admin', 'Submit', 'Manage Department', 'POST /add-department -> 201', 'POST', '/add-department', '127.0.0.1', '2026-04-14 01:38:44'),
(1143, 9, 'admin', 'Admin', 'Submit', 'Manage Department', 'POST /add-department -> 201', 'POST', '/add-department', '127.0.0.1', '2026-04-14 01:39:02'),
(1144, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-14 01:39:11'),
(1145, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 01:40:06'),
(1146, 9, 'admin', 'Admin', 'View Page', 'Stock Room', 'Visited /stock_room/stock-room', 'GET', '/stock_room/stock-room', '127.0.0.1', '2026-04-14 01:41:30'),
(1147, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-14 01:41:45'),
(1148, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 01:41:50'),
(1149, 9, 'admin', 'Admin', 'Submit', 'Manage Pc', 'POST /batch_add_pcinfofull -> 200', 'POST', '/batch_add_pcinfofull', '127.0.0.1', '2026-04-14 01:44:46'),
(1150, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-14 01:44:52'),
(1151, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 01:45:14'),
(1152, 9, 'admin', 'Admin', 'Add Item', 'PC Management', 'POST /add-pcinfofull -> 200', 'POST', '/add-pcinfofull', '127.0.0.1', '2026-04-14 01:46:45'),
(1153, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-14 01:47:02'),
(1154, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 01:47:10'),
(1155, 9, 'admin', 'Admin', 'Submit', 'Manage Pc', 'POST /batch_add_pcinfofull -> 200', 'POST', '/batch_add_pcinfofull', '127.0.0.1', '2026-04-14 01:48:18'),
(1156, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 01:49:07'),
(1157, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /?fbclid=IwY2xjawRKfLRleHRuA2FlbQIxMABicmlkETFUc0ZQTG5lSkQ3Q0Q1QWFPc3J0YwZhcHBfaWQQMjIyMDM5MTc4ODIwMDg5MgABHlm6GW0ZXKoTIFf1DRMD8GjOO4B4cj6J5-2xSWhJIFet5aLO6GwkWdqXIH_b_aem_3XIyr5cyC2bjzTdtMTO3TA', 'GET', '/', '127.0.0.1', '2026-04-14 01:50:28'),
(1158, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-14 01:50:33'),
(1159, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-14 01:50:33'),
(1160, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 01:50:38'),
(1161, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-14 01:50:43'),
(1162, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 01:50:53'),
(1163, 9, 'admin', 'Admin', 'Submit', 'Manage Pc', 'POST /batch_add_pcinfofull -> 200', 'POST', '/batch_add_pcinfofull', '127.0.0.1', '2026-04-14 01:52:16'),
(1164, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-14 01:52:23'),
(1165, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 01:52:32'),
(1166, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-14 01:52:48'),
(1167, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 01:52:53'),
(1168, 9, 'admin', 'Admin', 'Submit', 'Manage Pc', 'POST /batch_add_pcinfofull -> 200', 'POST', '/batch_add_pcinfofull', '127.0.0.1', '2026-04-14 01:54:07'),
(1169, 9, 'admin', 'Admin', 'Add Item', 'Item Management', 'POST /manage_inventory/add-device -> 302', 'POST', '/manage_inventory/add-device', '127.0.0.1', '2026-04-14 01:55:10'),
(1170, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 01:55:10'),
(1171, 9, 'admin', 'Admin', 'Add Item', 'Item Management', 'POST /manage_inventory/add-device -> 302', 'POST', '/manage_inventory/add-device', '127.0.0.1', '2026-04-14 01:56:14'),
(1172, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 01:56:14'),
(1173, 9, 'admin', 'Admin', 'Add Item', 'Item Management', 'POST /manage_inventory/add-device -> 302', 'POST', '/manage_inventory/add-device', '127.0.0.1', '2026-04-14 01:56:53'),
(1174, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 01:56:53'),
(1175, 9, 'admin', 'Admin', 'Add Item', 'Item Management', 'POST /manage_inventory/add-device -> 302', 'POST', '/manage_inventory/add-device', '127.0.0.1', '2026-04-14 01:57:42'),
(1176, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 01:57:43'),
(1177, 9, 'admin', 'Admin', 'Add Item', 'Item Management', 'POST /manage_inventory/add-device -> 302', 'POST', '/manage_inventory/add-device', '127.0.0.1', '2026-04-14 01:58:33'),
(1178, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 01:58:33'),
(1179, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-14 01:58:43'),
(1180, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 01:58:47'),
(1181, 9, 'admin', 'Admin', 'Add Item', 'Item Management', 'POST /manage_inventory/add-device -> 302', 'POST', '/manage_inventory/add-device', '127.0.0.1', '2026-04-14 01:59:26'),
(1182, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 01:59:26'),
(1183, 9, 'admin', 'Admin', 'Add Item', 'Consumable Management', 'POST /add-consumable -> 200', 'POST', '/add-consumable', '127.0.0.1', '2026-04-14 02:00:10'),
(1184, 9, 'admin', 'Admin', 'Submit', 'Manage Consumable', 'POST /archive-consumable/16 -> 200', 'POST', '/archive-consumable/16', '127.0.0.1', '2026-04-14 02:00:21'),
(1185, 9, 'admin', 'Admin', 'Submit', 'Manage Consumable', 'POST /archive-consumable/15 -> 200', 'POST', '/archive-consumable/15', '127.0.0.1', '2026-04-14 02:00:26'),
(1186, 9, 'admin', 'Admin', 'Submit', 'Manage Consumable', 'POST /archive-consumable/14 -> 200', 'POST', '/archive-consumable/14', '127.0.0.1', '2026-04-14 02:00:29'),
(1187, 9, 'admin', 'Admin', 'Submit', 'Manage Consumable', 'POST /archive-consumable/13 -> 200', 'POST', '/archive-consumable/13', '127.0.0.1', '2026-04-14 02:00:32'),
(1188, 9, 'admin', 'Admin', 'Submit', 'Manage Consumable', 'POST /archive-consumable/12 -> 200', 'POST', '/archive-consumable/12', '127.0.0.1', '2026-04-14 02:00:35'),
(1189, 9, 'admin', 'Admin', 'Submit', 'Manage Consumable', 'POST /archive-consumable/11 -> 200', 'POST', '/archive-consumable/11', '127.0.0.1', '2026-04-14 02:00:40'),
(1190, 9, 'admin', 'Admin', 'Submit', 'Manage Consumable', 'POST /archive-consumable/10 -> 200', 'POST', '/archive-consumable/10', '127.0.0.1', '2026-04-14 02:00:43'),
(1191, 9, 'admin', 'Admin', 'Submit', 'Manage Consumable', 'POST /archive-consumable/9 -> 200', 'POST', '/archive-consumable/9', '127.0.0.1', '2026-04-14 02:00:45'),
(1192, 9, 'admin', 'Admin', 'Add Item', 'Consumable Management', 'POST /add-consumable -> 200', 'POST', '/add-consumable', '127.0.0.1', '2026-04-14 02:01:01'),
(1193, 9, 'admin', 'Admin', 'Add Item', 'Consumable Management', 'POST /add-consumable -> 200', 'POST', '/add-consumable', '127.0.0.1', '2026-04-14 02:01:54'),
(1194, 9, 'admin', 'Admin', 'Add Item', 'Consumable Management', 'POST /add-consumable -> 200', 'POST', '/add-consumable', '127.0.0.1', '2026-04-14 02:02:15'),
(1195, 9, 'admin', 'Admin', 'Add Item', 'Consumable Management', 'POST /add-consumable -> 200', 'POST', '/add-consumable', '127.0.0.1', '2026-04-14 02:02:39'),
(1196, 9, 'admin', 'Admin', 'Add Item', 'Consumable Management', 'POST /add-consumable -> 200', 'POST', '/add-consumable', '127.0.0.1', '2026-04-14 02:03:11'),
(1197, 9, 'admin', 'Admin', 'Edit Item', 'Consumable Management', 'POST /update-consumable -> 200', 'POST', '/update-consumable', '127.0.0.1', '2026-04-14 02:03:20'),
(1198, 9, 'admin', 'Admin', 'Add Item', 'Item Management', 'POST /manage_inventory/add-device -> 302', 'POST', '/manage_inventory/add-device', '127.0.0.1', '2026-04-14 02:04:18'),
(1199, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 02:04:19'),
(1200, 9, 'admin', 'Admin', 'Add Item', 'Item Management', 'POST /manage_inventory/add-device -> 302', 'POST', '/manage_inventory/add-device', '127.0.0.1', '2026-04-14 02:04:48'),
(1201, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 02:04:49'),
(1202, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?department_id=&status=&accountable=&serial_no=&item_name=Mouse&brand_model=&device_type=&date_from=&date_to=&section=items&ui_section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 02:05:31'),
(1203, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /?fbclid=IwY2xjawRKl5hleHRuA2FlbQIxMABicmlkETEydGhVWE5jS2JxamRJbzZhc3J0YwZhcHBfaWQQMjIyMDM5MTc4ODIwMDg5MgABHr5ya8tR-V5goID8I_E0UsS16D7l7jZ4VLMNmTN90K8eO_e1pTZZHc9y50Be_aem_7zgMUYXoyui94-QwqvUoeQ', 'GET', '/', '127.0.0.1', '2026-04-14 03:45:13'),
(1204, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-14 03:45:30'),
(1205, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-14 03:45:31'),
(1206, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 03:45:40'),
(1207, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /?fbclid=IwY2xjawRKpqFleHRuA2FlbQIxMQBzcnRjBmFwcF9pZAwzNTA2ODU1MzE3MjgAAR7RDyQetyEuCwWfPlUOiXD_z1YCwxCIFJRuR4dw-F3Hu07etrLmXq-9O-AFhw_aem_xC6ZjoRTw5ANlIGv2oz6Sg', 'GET', '/', '127.0.0.1', '2026-04-14 04:49:22'),
(1208, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /?fbclid=IwY2xjawRKp55leHRuA2FlbQIxMQBzcnRjBmFwcF9pZAwzNTA2ODU1MzE3MjgAAR5FnyI1huibhye6edJGfTfwDl73ZKyc40NrbZ1yE-B_LFZmh8kRer7V3_htYw_aem_f8ObYXOR_x2ZYXTX84d10Q', 'GET', '/', '127.0.0.1', '2026-04-14 04:53:35'),
(1209, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-14 04:53:52'),
(1210, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-14 04:53:53'),
(1211, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-14 04:54:46'),
(1212, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-14 04:54:47'),
(1213, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 04:55:03'),
(1214, 9, 'admin', 'Admin', 'View Page', 'Qrcode', 'Visited /qrcodegenerator', 'GET', '/qrcodegenerator', '127.0.0.1', '2026-04-14 04:55:35'),
(1215, 9, 'admin', 'Admin', 'View Page', 'Stock Room', 'Visited /stock_room/stock-room', 'GET', '/stock_room/stock-room', '127.0.0.1', '2026-04-14 04:55:52'),
(1216, 9, 'admin', 'Admin', 'View Page', 'Manage User', 'Visited /manage-user', 'GET', '/manage-user', '127.0.0.1', '2026-04-14 04:56:02'),
(1217, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-14 04:56:10'),
(1218, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /?fbclid=IwY2xjawRKqjpleHRuA2FlbQIxMABicmlkETF1dWxHRGFkNDFWeXo2cmlTc3J0YwZhcHBfaWQQMjIyMDM5MTc4ODIwMDg5MgABHhRheTFGJaa5wpc6BsVz7U0EkpfnlDAbRsx4NxMHUqfd8QOc_31CZ6_pVA1N_aem_9DBKBlQotxcJsm_dgehe9w', 'GET', '/', '127.0.0.1', '2026-04-14 05:04:43'),
(1219, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-14 05:04:48'),
(1220, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-14 05:04:48'),
(1221, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-14 05:04:58'),
(1222, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 05:05:02'),
(1223, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc&page=2&per_page=10', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 05:05:19'),
(1224, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc&page=3&per_page=10', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 05:05:29'),
(1225, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc&page=1&per_page=10', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 05:05:57'),
(1226, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item&page=1&per_page=10&item_page=2', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 05:07:12'),
(1227, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item&page=1&per_page=10&item_page=1', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 05:08:30'),
(1228, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc&page=2&per_page=10&item_page=1', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 05:09:13'),
(1229, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-14 05:09:31'),
(1230, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-14 05:09:31'),
(1231, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=item&page=1&per_page=10', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 05:13:39'),
(1232, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 05:14:00'),
(1233, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc&page=3&per_page=50', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 05:14:24'),
(1234, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc&page=2&per_page=50', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 05:26:26'),
(1235, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc&page=2&per_page=50', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 05:26:35'),
(1236, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc&page=2&per_page=50', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 05:26:44'),
(1237, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc&page=3&per_page=50', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 05:27:50'),
(1238, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /', 'GET', '/', '127.0.0.1', '2026-04-14 05:27:58'),
(1239, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-14 05:28:02'),
(1240, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-14 05:28:03'),
(1241, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 05:28:07'),
(1242, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-14 05:32:16'),
(1243, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 05:33:01'),
(1244, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-14 05:33:40'),
(1245, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-14 05:34:04'),
(1246, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 05:34:08'),
(1247, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-14 05:34:33'),
(1248, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 05:36:07'),
(1249, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc&page=1&per_page=5', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 05:36:41'),
(1250, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-14 05:37:33'),
(1251, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-14 05:39:14'),
(1252, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 05:39:17'),
(1253, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-14 05:40:04'),
(1254, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 05:41:05'),
(1255, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-14 05:41:16'),
(1256, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-14 05:50:58'),
(1257, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 05:51:01'),
(1258, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-14 05:51:25'),
(1259, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /?fbclid=IwY2xjawRKtTZleHRuA2FlbQIxMQBzcnRjBmFwcF9pZAwzNTA2ODU1MzE3MjgAAR61-UMCOSynWpITxcDnp9tqJiNl3GqmQod5G-XNc3qrkYTKpyWus0jXtY7Tfw_aem_laHlCL0YPZR5SaNbSGnRMw', 'GET', '/', '127.0.0.1', '2026-04-14 05:51:35'),
(1260, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-14 05:51:53'),
(1261, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-14 05:51:53'),
(1262, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-14 05:58:59'),
(1263, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 05:59:02'),
(1264, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc&page=2&per_page=10', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 06:01:29'),
(1265, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-14 06:02:48'),
(1266, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-14 06:04:13'),
(1267, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 06:04:16'),
(1268, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?section=pc', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 06:05:07'),
(1269, 9, 'admin', 'Admin', 'View Page', 'Qrcode', 'Visited /qrcodegenerator', 'GET', '/qrcodegenerator', '127.0.0.1', '2026-04-14 06:06:04'),
(1270, 9, 'admin', 'Admin', 'View Page', 'Qrcode', 'Visited /qrcodegenerator', 'GET', '/qrcodegenerator', '127.0.0.1', '2026-04-14 06:09:45'),
(1271, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 06:09:50'),
(1272, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory/pc-filter-modal', 'GET', '/manage_inventory/pc-filter-modal', '127.0.0.1', '2026-04-14 06:10:25'),
(1273, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?department_id=&status=&accountable=&serial_no=&item_name=&brand_model=&device_type=&date_from=&date_to=&section=items&ui_section=item', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 06:11:00'),
(1274, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?department_id=&status=&accountable=&serial_no=&item_name=&brand_model=&device_type=&date_from=&date_to=&section=item&ui_section=item&item_page=1&per_page=50&search=Aurum', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 06:15:18'),
(1275, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?department_id=&status=&accountable=&serial_no=&item_name=&brand_model=&device_type=&date_from=&date_to=&section=pc&ui_section=item&item_page=1&per_page=50', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 06:15:45'),
(1276, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /?fbclid=IwY2xjawRKvyFleHRuA2FlbQIxMQBzcnRjBmFwcF9pZAwzNTA2ODU1MzE3MjgAAR5q41Fq4recOpXDy_hukM2B77w3HrrbRLhS2SNn9sQ-LngoP-5W_AccTDhgGA_aem_hO9miuiQOqwnzHfed2mvAw', 'GET', '/', '127.0.0.1', '2026-04-14 06:33:53'),
(1277, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-14 06:36:06'),
(1278, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-14 06:36:06'),
(1279, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-14 06:36:19'),
(1280, 9, 'admin', 'Admin', 'View Page', 'Transaction', 'Visited /transactions', 'GET', '/transactions', '127.0.0.1', '2026-04-14 06:36:37'),
(1281, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 06:37:56'),
(1282, 9, 'admin', 'Admin', 'View Page', 'Stock Room', 'Visited /stock_room/stock-room', 'GET', '/stock_room/stock-room', '127.0.0.1', '2026-04-14 06:41:35'),
(1283, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 06:41:46'),
(1284, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-14 06:42:54'),
(1285, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 06:44:34'),
(1286, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-14 06:45:19'),
(1287, 9, 'admin', 'Admin', 'Export File', 'Reports', 'GET /export-reports?name=&category=all&department=all&status=all&date_from=&date_to= -> 200', 'GET', '/export-reports', '127.0.0.1', '2026-04-14 06:45:24'),
(1288, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 06:47:18'),
(1289, 9, 'admin', 'Admin', 'View Page', 'Archive', 'Visited /archive', 'GET', '/archive', '127.0.0.1', '2026-04-14 06:51:32'),
(1290, 9, 'admin', 'Admin', 'View Page', 'Manage User', 'Visited /manage-user', 'GET', '/manage-user', '127.0.0.1', '2026-04-14 06:51:48'),
(1291, 9, 'admin', 'Admin', 'View Page', 'Manage Department', 'Visited /manage-department', 'GET', '/manage-department', '127.0.0.1', '2026-04-14 06:51:51'),
(1292, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 06:52:30'),
(1293, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 06:54:11'),
(1294, 9, 'admin', 'Admin', 'View Page', 'Report', 'Visited /reportgenerator', 'GET', '/reportgenerator', '127.0.0.1', '2026-04-14 06:54:14'),
(1295, 9, 'admin', 'Admin', 'View Page', 'Stock Room', 'Visited /stock_room/stock-room', 'GET', '/stock_room/stock-room', '127.0.0.1', '2026-04-14 06:55:15'),
(1296, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 06:56:10'),
(1297, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory?department_id=&status=&accountable=&serial_no=&item_name=&brand_model=&device_type=&date_from=&date_to=&section=item&ui_section=item&item_page=1&per_page=50', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 07:37:58'),
(1298, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 07:39:19'),
(1299, 9, 'admin', 'Admin', 'View Page', 'Index', 'Visited /?fbclid=IwY2xjawRKzvFleHRuA2FlbQIxMQBicmlkETFkV3FBZHRIWjZpMk1iemZTc3J0YwZhcHBfaWQBMAABHpxdw5Uo4iQexXpIX-uVlO0y_asxCJEYbtYfnJjWWSYfjrV82EjKw0VGFThe_aem_nssOmJ-U12bPijNJcLE6fw', 'GET', '/', '127.0.0.1', '2026-04-14 07:41:22'),
(1300, 9, 'admin', 'Admin', 'Login', 'Authentication', 'User signed in successfully', 'POST', '/login/', '127.0.0.1', '2026-04-14 07:41:25'),
(1301, 9, 'admin', 'Admin', 'View Page', 'Dashboard', 'Visited /dashboardload', 'GET', '/dashboardload', '127.0.0.1', '2026-04-14 07:41:26'),
(1302, 9, 'admin', 'Admin', 'View Page', 'Manage Inventory', 'Visited /manage_inventory', 'GET', '/manage_inventory', '127.0.0.1', '2026-04-14 07:41:31');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `asset_maintenance_logs`
--
ALTER TABLE `asset_maintenance_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `borrow_requests`
--
ALTER TABLE `borrow_requests`
  ADD PRIMARY KEY (`borrow_id`),
  ADD KEY `fk_borrow_device` (`device_id`);

--
-- Indexes for table `concerns`
--
ALTER TABLE `concerns`
  ADD PRIMARY KEY (`concern_id`);

--
-- Indexes for table `concern_devices`
--
ALTER TABLE `concern_devices`
  ADD PRIMARY KEY (`concern_id`,`device_id`),
  ADD KEY `device_id` (`device_id`);

--
-- Indexes for table `concern_history`
--
ALTER TABLE `concern_history`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `consumables`
--
ALTER TABLE `consumables`
  ADD PRIMARY KEY (`accession_id`),
  ADD KEY `department_id` (`department_id`);

--
-- Indexes for table `consumable_transactions`
--
ALTER TABLE `consumable_transactions`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `accession_id` (`accession_id`);

--
-- Indexes for table `damage_reports`
--
ALTER TABLE `damage_reports`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pcid` (`pcid`);

--
-- Indexes for table `damage_types`
--
ALTER TABLE `damage_types`
  ADD PRIMARY KEY (`damage_type_id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`department_id`);

--
-- Indexes for table `devices`
--
ALTER TABLE `devices`
  ADD PRIMARY KEY (`device_id`),
  ADD KEY `department_id` (`department_id`);

--
-- Indexes for table `devices_full`
--
ALTER TABLE `devices_full`
  ADD PRIMARY KEY (`accession_id`),
  ADD UNIQUE KEY `serial_no` (`serial_no`),
  ADD UNIQUE KEY `municipal_serial_no` (`municipal_serial_no`),
  ADD KEY `fk_department` (`department_id`);

--
-- Indexes for table `devices_units`
--
ALTER TABLE `devices_units`
  ADD PRIMARY KEY (`accession_id`),
  ADD KEY `device_id` (`device_id`);

--
-- Indexes for table `device_damage_reports`
--
ALTER TABLE `device_damage_reports`
  ADD PRIMARY KEY (`id`),
  ADD KEY `accession_id` (`accession_id`);

--
-- Indexes for table `inventory_audit_log`
--
ALTER TABLE `inventory_audit_log`
  ADD PRIMARY KEY (`audit_id`),
  ADD KEY `idx_entity` (`entity_type`,`entity_id`),
  ADD KEY `idx_action` (`action`),
  ADD KEY `idx_user` (`performed_by`),
  ADD KEY `idx_date` (`performed_at`);

--
-- Indexes for table `inventory_settings`
--
ALTER TABLE `inventory_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `inventory_status_logs`
--
ALTER TABLE `inventory_status_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `maintenance_history`
--
ALTER TABLE `maintenance_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_maintenance_pc` (`pcid`);

--
-- Indexes for table `maintenance_history_backfill_20260402`
--
ALTER TABLE `maintenance_history_backfill_20260402`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_maintenance_pc` (`pcid`);

--
-- Indexes for table `maintenance_logs`
--
ALTER TABLE `maintenance_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pcinfofull`
--
ALTER TABLE `pcinfofull`
  ADD PRIMARY KEY (`pcid`),
  ADD UNIQUE KEY `pcname` (`pcname`),
  ADD UNIQUE KEY `serial_no` (`serial_no`),
  ADD UNIQUE KEY `municipal_serial_no` (`municipal_serial_no`),
  ADD KEY `department_id` (`department_id`);

--
-- Indexes for table `pcparts`
--
ALTER TABLE `pcparts`
  ADD PRIMARY KEY (`part_id`),
  ADD KEY `pcid` (`pcid`);

--
-- Indexes for table `pcs`
--
ALTER TABLE `pcs`
  ADD PRIMARY KEY (`pcid`),
  ADD KEY `department_id` (`department_id`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`student_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `user_activity_log`
--
ALTER TABLE `user_activity_log`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `idx_user_activity_created_at` (`created_at`),
  ADD KEY `idx_user_activity_role` (`role`),
  ADD KEY `idx_user_activity_user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `asset_maintenance_logs`
--
ALTER TABLE `asset_maintenance_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `borrow_requests`
--
ALTER TABLE `borrow_requests`
  MODIFY `borrow_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `concerns`
--
ALTER TABLE `concerns`
  MODIFY `concern_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `concern_history`
--
ALTER TABLE `concern_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `consumables`
--
ALTER TABLE `consumables`
  MODIFY `accession_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT for table `consumable_transactions`
--
ALTER TABLE `consumable_transactions`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `damage_reports`
--
ALTER TABLE `damage_reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `damage_types`
--
ALTER TABLE `damage_types`
  MODIFY `damage_type_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `department_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `devices`
--
ALTER TABLE `devices`
  MODIFY `device_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `devices_full`
--
ALTER TABLE `devices_full`
  MODIFY `accession_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=523;

--
-- AUTO_INCREMENT for table `devices_units`
--
ALTER TABLE `devices_units`
  MODIFY `accession_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `device_damage_reports`
--
ALTER TABLE `device_damage_reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `inventory_audit_log`
--
ALTER TABLE `inventory_audit_log`
  MODIFY `audit_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `inventory_settings`
--
ALTER TABLE `inventory_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inventory_status_logs`
--
ALTER TABLE `inventory_status_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `maintenance_history`
--
ALTER TABLE `maintenance_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=350;

--
-- AUTO_INCREMENT for table `maintenance_history_backfill_20260402`
--
ALTER TABLE `maintenance_history_backfill_20260402`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=229;

--
-- AUTO_INCREMENT for table `maintenance_logs`
--
ALTER TABLE `maintenance_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=296;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `pcinfofull`
--
ALTER TABLE `pcinfofull`
  MODIFY `pcid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=114;

--
-- AUTO_INCREMENT for table `pcparts`
--
ALTER TABLE `pcparts`
  MODIFY `part_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `user_activity_log`
--
ALTER TABLE `user_activity_log`
  MODIFY `log_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1303;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `borrow_requests`
--
ALTER TABLE `borrow_requests`
  ADD CONSTRAINT `fk_borrow_device` FOREIGN KEY (`device_id`) REFERENCES `devices` (`device_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `concern_devices`
--
ALTER TABLE `concern_devices`
  ADD CONSTRAINT `concern_devices_ibfk_1` FOREIGN KEY (`concern_id`) REFERENCES `concerns` (`concern_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `concern_devices_ibfk_2` FOREIGN KEY (`device_id`) REFERENCES `devices` (`device_id`);

--
-- Constraints for table `consumables`
--
ALTER TABLE `consumables`
  ADD CONSTRAINT `consumables_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`);

--
-- Constraints for table `consumable_transactions`
--
ALTER TABLE `consumable_transactions`
  ADD CONSTRAINT `consumable_transactions_ibfk_1` FOREIGN KEY (`accession_id`) REFERENCES `consumables` (`accession_id`);

--
-- Constraints for table `damage_reports`
--
ALTER TABLE `damage_reports`
  ADD CONSTRAINT `damage_reports_ibfk_1` FOREIGN KEY (`pcid`) REFERENCES `pcinfofull` (`pcid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `devices`
--
ALTER TABLE `devices`
  ADD CONSTRAINT `devices_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`);

--
-- Constraints for table `devices_full`
--
ALTER TABLE `devices_full`
  ADD CONSTRAINT `fk_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`) ON DELETE SET NULL;

--
-- Constraints for table `devices_units`
--
ALTER TABLE `devices_units`
  ADD CONSTRAINT `devices_units_ibfk_1` FOREIGN KEY (`device_id`) REFERENCES `devices` (`device_id`);

--
-- Constraints for table `device_damage_reports`
--
ALTER TABLE `device_damage_reports`
  ADD CONSTRAINT `device_damage_reports_ibfk_1` FOREIGN KEY (`accession_id`) REFERENCES `devices_full` (`accession_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `maintenance_history`
--
ALTER TABLE `maintenance_history`
  ADD CONSTRAINT `fk_maintenance_pc` FOREIGN KEY (`pcid`) REFERENCES `pcinfofull` (`pcid`) ON DELETE CASCADE;

--
-- Constraints for table `pcinfofull`
--
ALTER TABLE `pcinfofull`
  ADD CONSTRAINT `pcinfofull_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`);

--
-- Constraints for table `pcparts`
--
ALTER TABLE `pcparts`
  ADD CONSTRAINT `pcparts_ibfk_1` FOREIGN KEY (`pcid`) REFERENCES `pcs` (`pcid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `pcs`
--
ALTER TABLE `pcs`
  ADD CONSTRAINT `pcs_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

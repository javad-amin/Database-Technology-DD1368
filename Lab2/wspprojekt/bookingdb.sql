-- phpMyAdmin SQL Dump
-- version 4.7.7
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 26, 2018 at 12:41 AM
-- Server version: 10.1.30-MariaDB
-- PHP Version: 7.2.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bookingdb`
--

-- --------------------------------------------------------

--
-- Table structure for table `business_partner`
--

CREATE TABLE `business_partner` (
  `partner_id` int(11) NOT NULL,
  `name` text COLLATE utf8_swedish_ci,
  `position` text COLLATE utf8_swedish_ci,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;

--
-- Dumping data for table `business_partner`
--

INSERT INTO `business_partner` (`partner_id`, `name`, `position`, `user_id`) VALUES
(1, 'Businesstest1', 'HR Manager', 1),
(2, 'Businesstest2', 'Programmer', 3);

-- --------------------------------------------------------

--
-- Table structure for table `facility`
--

CREATE TABLE `facility` (
  `facility_id` int(11) NOT NULL,
  `name` text COLLATE utf8_swedish_ci,
  `facility_cost` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;

--
-- Dumping data for table `facility`
--

INSERT INTO `facility` (`facility_id`, `name`, `facility_cost`) VALUES
(1, 'TV', 50),
(2, 'Projector', 30);

-- --------------------------------------------------------

--
-- Table structure for table `facility_in`
--

CREATE TABLE `facility_in` (
  `facility_in_id` int(11) NOT NULL,
  `facility_id` int(11) DEFAULT NULL,
  `room_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;

--
-- Dumping data for table `facility_in`
--

INSERT INTO `facility_in` (`facility_in_id`, `facility_id`, `room_id`) VALUES
(1, 1, 1),
(2, 2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `meeting`
--

CREATE TABLE `meeting` (
  `meeting_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `room_id` int(11) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `booking_cost` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;

--
-- Dumping data for table `meeting`
--

INSERT INTO `meeting` (`meeting_id`, `user_id`, `room_id`, `start_time`, `end_time`, `booking_cost`) VALUES
(28, 6, 1, '2018-04-27 05:00:00', '2018-04-27 08:00:00', 170),
(34, 1, 7, '2018-04-30 08:30:00', '2018-04-30 12:30:00', 120);

-- --------------------------------------------------------

--
-- Table structure for table `participant`
--

CREATE TABLE `participant` (
  `participant_id` int(11) NOT NULL,
  `meeting_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `partner_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;

--
-- Dumping data for table `participant`
--

INSERT INTO `participant` (`participant_id`, `meeting_id`, `user_id`, `partner_id`) VALUES
(36, 34, 2, NULL),
(37, 34, 3, NULL),
(38, 34, NULL, 2),
(39, 34, 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `position`
--

CREATE TABLE `position` (
  `position_id` int(11) NOT NULL,
  `position` text COLLATE utf8_swedish_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;

--
-- Dumping data for table `position`
--

INSERT INTO `position` (`position_id`, `position`) VALUES
(1, 'HR Manager'),
(2, 'Programmer'),
(3, 'IT Consultant'),
(4, 'Scrum master'),
(5, 'Artist'),
(6, 'Executive');

-- --------------------------------------------------------

--
-- Table structure for table `room`
--

CREATE TABLE `room` (
  `room_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;

--
-- Dumping data for table `room`
--

INSERT INTO `room` (`room_id`) VALUES
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10);

-- --------------------------------------------------------

--
-- Table structure for table `team`
--

CREATE TABLE `team` (
  `team_id` int(11) NOT NULL,
  `name` text COLLATE utf8_swedish_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;

--
-- Dumping data for table `team`
--

INSERT INTO `team` (`team_id`, `name`) VALUES
(1, 'Team Darwin'),
(2, 'Team Newton');

-- --------------------------------------------------------

--
-- Table structure for table `team_totalcost_log`
--

CREATE TABLE `team_totalcost_log` (
  `teamcostlog_id` int(11) NOT NULL,
  `team_id` int(11) DEFAULT NULL,
  `meeting_id` int(11) DEFAULT NULL,
  `cost` int(11) DEFAULT NULL,
  `name` text COLLATE utf8_swedish_ci,
  `start_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;

--
-- Dumping data for table `team_totalcost_log`
--

INSERT INTO `team_totalcost_log` (`teamcostlog_id`, `team_id`, `meeting_id`, `cost`, `name`, `start_time`) VALUES
(7, 2, 18, 112, 'Team Newton', '2018-04-24 17:56:00'),
(8, 1, 19, 170, 'Team Darwin', '2018-04-25 18:00:00'),
(9, 1, 20, 260, 'Team Darwin', '2018-04-27 08:30:00'),
(10, 2, 21, 230, 'Team Newton', '2018-04-26 03:00:00'),
(11, 2, 22, 60, 'Team Newton', '2018-04-25 19:00:00'),
(17, 3, 28, 170, 'Team Test', '2018-04-27 05:00:00'),
(18, 3, 29, 60, 'Team Test', '2018-04-28 15:00:00'),
(19, 2, 30, 140, 'Team Newton', '2018-04-29 15:00:00'),
(23, 2, 34, 120, 'Team Newton', '2018-04-30 08:30:00');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `user_name` text COLLATE utf8_swedish_ci,
  `user_fullname` text COLLATE utf8_swedish_ci,
  `user_pass` text COLLATE utf8_swedish_ci,
  `user_email` text COLLATE utf8_swedish_ci,
  `user_level` int(11) DEFAULT '0',
  `user_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `user_activated` int(11) DEFAULT '0',
  `position_id` int(11) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_swedish_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `user_name`, `user_fullname`, `user_pass`, `user_email`, `user_level`, `user_date`, `user_activated`, `position_id`, `team_id`) VALUES
(1, 'user1', 'Bobby Brown', '$2y$10$RVhL5r9q9YutgM1w9oNpFOd3Nu/GnCKVWSiffgLpi8b4.viyAUMPu', 'user1@gmail.com', 1, '2018-04-21 20:24:08', 1, 6, 2),
(2, 'user2', 'Sarah Greene', '$2y$10$njaFt0p2MsHgiAb9mhDym.sCMXj16tmt9o1cwZw5PKWn.jts38aeO', 'user2@gmail.com', 0, '2018-04-24 17:06:47', 1, 2, 1),
(3, 'user3', 'Philip Thomson', '$2y$10$75sYLkYlUSygfHXuVGi5wOz7LwcCIz52MMYBR94y/TmsdHIjKHRQG', 'user3@gmail.com', 0, '2018-04-24 19:10:29', 1, 4, 1),
(6, 'user4', 'Test McTestyface', '$2y$10$hnd1EtyKsoReK4x8y9WXB.Xqz/tANYa5VoI3uOYEm7tlwR0bhiNrW', 'user4@gmail.com', 0, '2018-04-25 21:10:22', 1, 3, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `business_partner`
--
ALTER TABLE `business_partner`
  ADD PRIMARY KEY (`partner_id`),
  ADD KEY `businessP_user_id_fk` (`user_id`);

--
-- Indexes for table `facility`
--
ALTER TABLE `facility`
  ADD PRIMARY KEY (`facility_id`);

--
-- Indexes for table `facility_in`
--
ALTER TABLE `facility_in`
  ADD PRIMARY KEY (`facility_in_id`),
  ADD KEY `facilityIn_facility_id_fk` (`facility_id`),
  ADD KEY `facilityIn_room_id_fk` (`room_id`);

--
-- Indexes for table `meeting`
--
ALTER TABLE `meeting`
  ADD PRIMARY KEY (`meeting_id`),
  ADD KEY `meeting_room_id_fk` (`room_id`),
  ADD KEY `meeting_user_id_fk` (`user_id`);

--
-- Indexes for table `participant`
--
ALTER TABLE `participant`
  ADD PRIMARY KEY (`participant_id`),
  ADD KEY `participant_meeting_id_fk` (`meeting_id`),
  ADD KEY `participant_partner_id_fk` (`partner_id`),
  ADD KEY `participant_user_id_fk` (`user_id`);

--
-- Indexes for table `position`
--
ALTER TABLE `position`
  ADD PRIMARY KEY (`position_id`);

--
-- Indexes for table `room`
--
ALTER TABLE `room`
  ADD PRIMARY KEY (`room_id`);

--
-- Indexes for table `team`
--
ALTER TABLE `team`
  ADD PRIMARY KEY (`team_id`);

--
-- Indexes for table `team_totalcost_log`
--
ALTER TABLE `team_totalcost_log`
  ADD PRIMARY KEY (`teamcostlog_id`),
  ADD KEY `teamCostLog_team_id_fk` (`team_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `user_position_id_fk` (`position_id`),
  ADD KEY `user_team_id_fk` (`team_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `business_partner`
--
ALTER TABLE `business_partner`
  MODIFY `partner_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `facility`
--
ALTER TABLE `facility`
  MODIFY `facility_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `facility_in`
--
ALTER TABLE `facility_in`
  MODIFY `facility_in_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `meeting`
--
ALTER TABLE `meeting`
  MODIFY `meeting_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `participant`
--
ALTER TABLE `participant`
  MODIFY `participant_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `position`
--
ALTER TABLE `position`
  MODIFY `position_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `room`
--
ALTER TABLE `room`
  MODIFY `room_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `team`
--
ALTER TABLE `team`
  MODIFY `team_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `team_totalcost_log`
--
ALTER TABLE `team_totalcost_log`
  MODIFY `teamcostlog_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `business_partner`
--
ALTER TABLE `business_partner`
  ADD CONSTRAINT `businessP_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `facility_in`
--
ALTER TABLE `facility_in`
  ADD CONSTRAINT `facilityIn_facility_id_fk` FOREIGN KEY (`facility_id`) REFERENCES `facility` (`facility_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `facilityIn_room_id_fk` FOREIGN KEY (`room_id`) REFERENCES `room` (`room_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `meeting`
--
ALTER TABLE `meeting`
  ADD CONSTRAINT `meeting_room_id_fk` FOREIGN KEY (`room_id`) REFERENCES `room` (`room_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `meeting_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `participant`
--
ALTER TABLE `participant`
  ADD CONSTRAINT `participant_meeting_id_fk` FOREIGN KEY (`meeting_id`) REFERENCES `meeting` (`meeting_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `participant_partner_id_fk` FOREIGN KEY (`partner_id`) REFERENCES `business_partner` (`partner_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `participant_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_position_id_fk` FOREIGN KEY (`position_id`) REFERENCES `position` (`position_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `user_team_id_fk` FOREIGN KEY (`team_id`) REFERENCES `team` (`team_id`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

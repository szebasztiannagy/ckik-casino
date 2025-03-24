-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2025. Már 24. 11:36
-- Kiszolgáló verziója: 10.4.32-MariaDB
-- PHP verzió: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `casino`
--

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `history`
--

CREATE TABLE `history` (
  `id` int(11) NOT NULL,
  `type` enum('roulette','coinflip','withdraw','deposit') NOT NULL,
  `result` int(11) DEFAULT NULL,
  `bet` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `picked` int(11) DEFAULT NULL,
  `amount` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `history`
--

INSERT INTO `history` (`id`, `type`, `result`, `bet`, `created_at`, `picked`, `amount`, `user_id`) VALUES
(1, 'roulette', 1, 1500, '2025-03-24 08:50:14', 1, 10000, 5),
(2, 'roulette', 0, 1000, '2025-03-24 10:23:20', 4, 1000, 5);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `balance` decimal(10,2) DEFAULT 1000.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- A tábla adatainak kiíratása `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password_hash`, `created_at`, `balance`) VALUES
(1, 'nszebi', 'nagyszebasztian15@gmail.com', 'cf43e029efe6476e1f7f84691f89c876818610c2eaeaeb881103790a48745b82', '2025-03-03 08:48:10', 1000.00),
(2, 'a', 'a@xn--4ca.hu', '$2b$10$04UbZFtQGN8z516abxOzrOdsUS76sYx3WL5xXsiRHcZK3Zdx57FNy', '2025-03-24 08:40:16', 1000.00),
(3, 'asd', 'asd@asd.cc', '$2b$10$3eAnFKCYtwmKg2xbuWFWAu0xXct9DVLdOPS7WaK5uoemRvkgRWKQe', '2025-03-24 08:40:33', 1000.00),
(4, 'cc', 'cc@cc.cc', '$2b$10$04UbZFtQGN8z516abxOzrO.JccD7iy0Acgtyj9YCtyUtC9FMDXr56', '2025-03-24 08:41:42', 1000.00),
(5, 'qq@qq.qq', 'qq@qq.qq', '$2b$10$k.j961Cv6UuOqbBeP8AUFuhsNEcMPZdimoQiRop6WuDTeUKMcGoFO', '2025-03-24 08:43:40', 100000.00),
(6, 'admin', 'admin@a.com', '$2b$10$IVmbiHhztlgSHoQlg0g50O7kiJQoH6ulp.HKcVbIr3c9l.Pzn3.oe', '2025-03-24 08:56:40', 1000.00);

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `history`
--
ALTER TABLE `history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `history` (`user_id`);

--
-- A tábla indexei `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `history`
--
ALTER TABLE `history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT a táblához `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `history`
--
ALTER TABLE `history`
  ADD CONSTRAINT `history` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

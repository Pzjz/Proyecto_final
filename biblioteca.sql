-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 30-11-2023 a las 02:51:29
-- Versión del servidor: 10.4.24-MariaDB
-- Versión de PHP: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `biblioteca`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `almacena_libro` (`id` INT, `nombreLibro` VARCHAR(50), `autor` VARCHAR(50), `cantidad` INT)   INSERT INTO libros (id,nombreLibro,autor,cantidad) VALUES (id,nombreLibro,autor,cantidad)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `almacena_usuario` (`cedula` INT, `nombre` VARCHAR(50), `apellido` VARCHAR(50), `libro` INT)   INSERT INTO usuarios (cedula,nombre,apellido,libro) VALUES (cedula,nombre,apellido,libro)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `borrar_usuario` (IN `cedulaIngresa` INT)   DELETE FROM usuarios WHERE cedula = cedulaIngresa$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `libros`
--

CREATE TABLE `libros` (
  `id` int(11) DEFAULT NULL,
  `nombreLibro` varchar(50) DEFAULT NULL,
  `autor` varchar(50) DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `libros`
--

INSERT INTO `libros` (`id`, `nombreLibro`, `autor`, `cantidad`) VALUES
(1, 'Cien años de soledad', 'Gabo', 5),
(2, 'Cincuenta sombras de grey', 'Juan villa', 5),
(3, 'Don Quijada', 'Andres', 5);

--
-- Disparadores `libros`
--
DELIMITER $$
CREATE TRIGGER `condicionLibro` BEFORE UPDATE ON `libros` FOR EACH ROW BEGIN
IF NEW.cantidad <= 2 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'No se permite el prestamo por que quedan menos de 3 libros.';
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `cedula` int(11) DEFAULT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `apellido` varchar(50) DEFAULT NULL,
  `libro` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Disparadores `usuarios`
--
DELIMITER $$
CREATE TRIGGER `restarLibro` AFTER INSERT ON `usuarios` FOR EACH ROW UPDATE libros
SET cantidad = cantidad - 1
WHERE id = NEW.libro
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `sumar_libro` AFTER DELETE ON `usuarios` FOR EACH ROW UPDATE libros
SET cantidad = cantidad + 1
WHERE id = OLD.libro
$$
DELIMITER ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `libros`
--
ALTER TABLE `libros`
  ADD KEY `Índice 1` (`id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD KEY `Índice 1` (`cedula`),
  ADD KEY `libro` (`libro`);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `libro` FOREIGN KEY (`libro`) REFERENCES `libros` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

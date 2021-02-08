-- Author:       Luca Lombardini
-- Academic_y:   2020/2021
-- Purpose:      (Master Degree) Digital Integrated Systems' Final Project
-- Contacts:     s277972@studenti.polito.it
--               lombamari2@gmail.com
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY late_status_pla IS
	PORT(	STATUS	: IN std_logic;
		LSB	: IN std_logic;
		CC	: IN std_logic;
		LSB_out	: OUT std_logic;
		CC_val	: OUT std_logic);
END ENTITY;

ARCHITECTURE behav OF late_status_pla IS
BEGIN
	CC_val <= CC AND STATUS; -- jump when ATTENTION and START asserted
	LSB_out<= ( LSB AND NOT(CC) ) OR ( STATUS AND CC ); -- if the state is dormant, remain in the same region, otherwise, STATUS tells which region is next
END ARCHITECTURE;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 			Jason Murphy
-- 
-- Create Date:    20:05:06 01/14/2016 
-- Design Name: 
-- Module Name:    MAX7219Int - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MAX7219Int is port (
	regAddr, regDataIn : in std_logic_vector(7 downto 0);
	regDataOut : out std_logic_vector(7 downto 0);
	writeData, FPGAClk, readData : in std_logic;
	MDIO, MDC, MDIOLoad : out std_logic);
end MAX7219Int;

architecture Behavioral of MAX7219Int is
signal writeDataSig : std_logic_vector(1 downto 0);
signal readDataSig : std_logic_vector(1 downto 0);
signal MDIOReg : std_logic_vector(15 downto 0);
signal bitCount : std_logic_vector(11 downto 0);
signal regDataOutSig : std_logic_vector(7 downto 0);

begin
	process(fpgaClk) is
	begin
		if rising_edge(fpgaClk) then	
			writeDataSig <= writeDataSig(0) & writeData;
			readDataSig <= readDataSig(0) & readData;
			if bitCount < "111111111111" then
				bitCount <= bitCount + 1;
			else
				MDIOLoad <= '1';
			end if;
			if writeDataSig = "10" then
				bitCount <= "000000000000";
				MDIOReg <= regAddr & regDataIn;
				MDIOLoad <= '0';
			end if;
			if bitCount(7 downto 0) = "00000000" then
				MDIO <= MDIOReg(15);
				MDIOReg <= MDIOReg(14 downto 0) & '0';
			end if;
			MDC <= bitCount(7);
			if readDataSig = "10" then
				regDataOutSig <= regAddr xor "10101010";
			end if;
			regDataOut <= regDataOutSig;
		end if;
	end process;
end Behavioral;

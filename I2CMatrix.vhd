----------------------------------------------------------------------------------
-- Engineer: 				Jason Murphy
-- Create Date:    		13:06:42 12/20/2015 
-- Design Name: 			
-- Module Name:    		Top - Behavioral 
-- Project Name: 			I2CMatrix
-- Target Devices: 		Spartan 6 (xc6slx9-3tqg144)
-- Tool versions: 		ISE 14.7
-- Description: 			Top Module implementing I2C interface to MAX7219 Display Driver
-- Dependencies: 			.ucf Logipi pinouts
-- Revision: 				V1.0 Tested
-- Revision 				0.01 - File Created
-- Additional Comments: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity I2CMatrix is port( 
	MDIO : out std_logic;
	MDC : out std_logic;
	MDIOLoad : out std_logic;
	fpgaClk : in std_logic; 
	sda : inout std_logic;
	sck : in std_logic;
	sdaTest, sckTest : out std_logic);
end I2CMatrix;

architecture Behavioral of I2CMatrix is

component I2CInt port( 
	sda : inout std_logic;
	sck, fpgaClk : in std_logic; 
	regAddr : out std_logic_vector (7 downto 0);
	regDataIn : in std_logic_vector (7 downto 0);
	regDataOut : out std_logic_vector (7 downto 0);
	readData, writeData : out std_logic;
	sdaTest, sckTest : out std_logic); 
end component;

component MAX7219Int port(
	regAddr, regDataIn : in std_logic_vector(7 downto 0);
	regDataOut : out std_logic_vector(7 downto 0);
	writeData, FPGAClk, readData : in std_logic;
	MDIO, MDC, MDIOLoad : out std_logic);
end component;

signal regDataInSig, regDataOutSig : std_logic_vector (7 downto 0);
signal regAddrSig : std_logic_vector (7 downto 0);
signal writeDataSig, readDataSig, sckSig : std_logic;

begin

I2C1 : I2CInt port map
(
	sda => sda,
	sck => sck,
	fpgaClk => fpgaClk, 
	regAddr => regAddrSig,
	regDataIn => regDataInSig,
	regDataOut => regDataOutSig,
	readData => readDataSig,
	writeData => writeDataSig,
	sdaTest => sdaTest,
	sckTest => sckTest
);
  
 MAX72191 : MAX7219Int port map
 (
	regAddr => regAddrSig,
	regDataIn => regDataOutSig,
	regDataOut => regDataInSig,
	writeData => writeDataSig,
	fpgaClk => fpgaClk,
	readData => readDataSig,
	MDIO => MDIO,
	MDC => MDC,
	MDIOLoad => MDIOLoad
 );

end Behavioral;

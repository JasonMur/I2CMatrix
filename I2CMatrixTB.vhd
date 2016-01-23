--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:36:38 01/15/2016
-- Design Name:   
-- Module Name:   
-- Project Name:  I2CMatrix
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: I2CMatrix
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY I2CMatrixTB IS
END I2CMatrixTB;
 
ARCHITECTURE behavior OF I2CMatrixTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT I2CMatrix
    PORT(
         MDIO : OUT  std_logic;
         MDC : OUT  std_logic;
         MDIOLoad : OUT  std_logic;
         fpgaClk : IN  std_logic;
         sda : INOUT  std_logic;
         sck : IN  std_logic;
         sdaTest : OUT  std_logic;
         sckTest : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
SIGNAL MDIOSig, MDCSig, fpgaClkSig :  std_logic := '1';
signal sckSig, sdaSig : std_logic;
constant FPGACLOCKPERIOD : time := 10 ns; -- 50Mhz
constant I2CCLOCKPERIOD : time := 5 us; -- 100Khz
signal deviceAddrSig : std_logic_vector(7 downto 0) := "01100010"; --0x62
signal regAddrSig : std_logic_vector(7 downto 0) := "00001001"; --0x09
signal regDataSig : std_logic_vector(7 downto 0) := "00000000"; --0xAA;
signal writeSequence : std_logic_vector (26 downto 0);
signal bitCount : integer range 0 to 27;
signal regCount : integer range 0 to 7;
signal testSig : integer range 0 to 25;
signal readDataSig, writeDataSig, MDIOLoadSig, sdaTest, sckTest : std_logic;

BEGIN

-- Component Instantiation
uut: I2CMatrix PORT MAP(
	MDIO => MDIOSig,
	MDC => MDCSig,
	MDIOLoad => MDIOLoadSig,
	fpgaClk => fpgaClkSig,
	sda => sdaSig,
	sck => sckSig,
	sdaTest => sdaTest,
	sckTest => sckTest
	);

--  Test Bench Statements
clkProcess :process
begin
	fpgaClkSig <= '0';
   wait for FPGACLOCKPERIOD;
   fpgaClkSig <= '1';
   wait for FPGACLOCKPERIOD;
end process;
   
-- Stimulus process
stimProc: process
begin        
	
	bitCount <= 0;
	--I2C Start Signal
	wait for I2CCLOCKPERIOD;
	sdaSig <= '0';
	wait for I2CCLOCKPERIOD/2;
	sckSig <= '0';
	wait for I2CCLOCKPERIOD/2;
	writeSequence <= deviceAddrSig(6 downto 0) & "0Z" & regAddrSig & 'Z' & regDataSig & 'Z';
	wait for I2CCLOCKPERIOD/2;
	writeBits: while bitCount <= 26 loop
		sdaSig <= writeSequence(26-bitCount);
		bitCount <= bitCount + 1;
		wait for I2CCLOCKPERIOD;
		sckSig <= '1';
		wait for I2CCLOCKPERIOD;
		sckSig <= '0';
	end loop writeBits;
	
	sdaSig <= '0';
	wait for I2CCLOCKPERIOD;
	sckSig <= '1';
	wait for I2CCLOCKPERIOD/2;
	sdaSig <= '1';

	
	writeSequence <= "11000100Z00001010Z00001000Z";
	
	wait for I2CCLOCKPERIOD*5;
	bitCount <= 0;
	--I2C Start Signal
	wait for I2CCLOCKPERIOD;
	sdaSig <= '0';
	wait for I2CCLOCKPERIOD/2;
	sckSig <= '0';
	wait for I2CCLOCKPERIOD;
	
--Write sequence Device Address, Register Address, 2 x Register Bytes
	writeBits2: while bitCount <= 26 loop
		sdaSig <= writeSequence(26-bitCount);
		bitCount <= bitCount + 1;
		wait for I2CCLOCKPERIOD;
		sckSig <= '1';
		wait for I2CCLOCKPERIOD;
		sckSig <= '0';
	end loop writeBits2;
	
	-- I2C Stop Signal
	sdaSig <= '0';
	wait for I2CCLOCKPERIOD;
	sckSig <= '1';
	wait for I2CCLOCKPERIOD/2;
	sdaSig <= '1';
	
	
	writeSequence <= "11000100Z00001011Z00000111Z";
	
	wait for I2CCLOCKPERIOD*5;
	bitCount <= 0;
	--I2C Start Signal
	wait for I2CCLOCKPERIOD;
	sdaSig <= '0';
	wait for I2CCLOCKPERIOD/2;
	sckSig <= '0';
	wait for I2CCLOCKPERIOD;
--Write sequence Device Address, Register Address, 2 x Register Bytes
	writeBits3: while bitCount <= 26 loop
		sdaSig <= writeSequence(26-bitCount);
		bitCount <= bitCount + 1;
		wait for I2CCLOCKPERIOD;
		sckSig <= '1';
		wait for I2CCLOCKPERIOD;
		sckSig <= '0';
	end loop writeBits3;
	
	-- I2C Stop Signal
	sdaSig <= '0';
	wait for I2CCLOCKPERIOD;
	sckSig <= '1';
	wait for I2CCLOCKPERIOD/2;
	sdaSig <= '1';
	
	
	writeSequence <= "11000100Z00001100Z00000001Z";
	
	wait for I2CCLOCKPERIOD*5;
	bitCount <= 0;
	--I2C Start Signal
	wait for I2CCLOCKPERIOD;
	sdaSig <= '0';
	wait for I2CCLOCKPERIOD/2;
	sckSig <= '0';
	wait for I2CCLOCKPERIOD;
--Write sequence Device Address, Register Address, 2 x Register Bytes
	writeBits4: while bitCount <= 26 loop
		sdaSig <= writeSequence(26-bitCount);
		bitCount <= bitCount + 1;
		wait for I2CCLOCKPERIOD;
		sckSig <= '1';
		wait for I2CCLOCKPERIOD;
		sckSig <= '0';
	end loop writeBits4;
	
	-- I2C Stop Signal
	sdaSig <= '0';
	wait for I2CCLOCKPERIOD;
	sckSig <= '1';
	wait for I2CCLOCKPERIOD/2;
	sdaSig <= '1';
	
	writeSequence <= "11000100Z00000001Z10101010Z";
	
	wait for I2CCLOCKPERIOD*5;
	bitCount <= 0;
	--I2C Start Signal
	wait for I2CCLOCKPERIOD;
	sdaSig <= '0';
	wait for I2CCLOCKPERIOD/2;
	sckSig <= '0';
	wait for I2CCLOCKPERIOD;

--Write sequence Device Address, Register Address, 2 x Register Bytes
	writeBits5: while bitCount <= 17 loop
		sdaSig <= writeSequence(26-bitCount);
		bitCount <= bitCount + 1;
		wait for I2CCLOCKPERIOD;
		sckSig <= '1';
		wait for I2CCLOCKPERIOD;
		sckSig <= '0';
	end loop writeBits5;
	
	regCount <= 0;
		
	writeReg: while regCount < 8 loop
		bitCount <= 18;
		wait for I2CCLOCKPERIOD/2;
		writeBits6: while bitCount <= 26 loop
			sdaSig <= writeSequence(26-bitCount);
			bitCount <= bitCount + 1;
			wait for I2CCLOCKPERIOD;
			sckSig <= '1';
			wait for I2CCLOCKPERIOD;
			sckSig <= '0';
		end loop writeBits6;
		regCount <= regCount +1;
		writeSequence(8 downto 1) <= not (writeSequence(8 downto 1));
	end loop writeReg;
	
	-- I2C Stop Signal
	sdaSig <= '0';
	wait for I2CCLOCKPERIOD;
	sckSig <= '1';
	wait for I2CCLOCKPERIOD/2;
	sdaSig <= '1';
	
	
	writeSequence <= "11000100Z00000001ZZZZZZZZZ0";
	
	wait for I2CCLOCKPERIOD*5;
	bitCount <= 0;
	--I2C Start Signal
	wait for I2CCLOCKPERIOD;
	sdaSig <= '0';
	wait for I2CCLOCKPERIOD/2;
	sckSig <= '0';
	wait for I2CCLOCKPERIOD;
--Write sequence Device Address, Register Address, 2 x Register Bytes
	readBits1: while bitCount <= 17 loop
		sdaSig <= writeSequence(26-bitCount);
		bitCount <= bitCount + 1;
		wait for I2CCLOCKPERIOD;
		sckSig <= '1';
		wait for I2CCLOCKPERIOD;
		sckSig <= '0';
	end loop readBits1;
	
	-- I2C Stop Signal
	sdaSig <= '0';
	wait for I2CCLOCKPERIOD;
	sckSig <= '1';
	wait for I2CCLOCKPERIOD/2;
	sdaSig <= '1';
	
	writeSequence <= "11000101ZZZZZZZZZ0ZZZZZZZZ1";
	
	wait for I2CCLOCKPERIOD*5;
	bitCount <= 0;
	--I2C Start Signal
	wait for I2CCLOCKPERIOD;
	sdaSig <= '0';
	wait for I2CCLOCKPERIOD/2;
	sckSig <= '0';
	wait for I2CCLOCKPERIOD;
--Write sequence Device Address, Register Address, 2 x Register Bytes
	readBits2: while bitCount <= 26 loop
		sdaSig <= writeSequence(26-bitCount);
		bitCount <= bitCount + 1;
		wait for I2CCLOCKPERIOD;
		sckSig <= '1';
		wait for I2CCLOCKPERIOD;
		sckSig <= '0';
	end loop readBits2;
	
	-- I2C Stop Signal
	sdaSig <= '0';
	wait for I2CCLOCKPERIOD;
	sckSig <= '1';
	wait for I2CCLOCKPERIOD/2;
	sdaSig <= '1';
	
	
	wait;
end process;
--  End Test Bench 

 END;

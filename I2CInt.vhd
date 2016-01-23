----------------------------------------------------------------------------------
-- Engineer: 				Jason Murphy
-- Create Date:   		19:44:31 12/09/2015 
-- Design Name: 			I2CInt
-- Module Name:   		I2CInt - Behavioral 
-- Project Name: 			I2CMatrix
-- Target Devices: 		Spartan 6 xc6slx9-3tgg144
-- Tool versions: 		ISE 14.7
-- Description: 			Simple I2C interface with 8 bit reg allowing multibyte read/write
-- Dependencies: 			
-- Revision: 				V1.0 Tested 
-- Revision 				0.01 - File Created
-- Additional Comments: 
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity I2CInt is port( 
	sda : inout std_logic := 'Z';
	sck, fpgaClk : in std_logic; 
	regAddr : out std_logic_vector (7 downto 0);
	regDataIn : in std_logic_vector (7 downto 0);
	regDataOut : out std_logic_vector (7 downto 0);
	readData, writeData : out std_logic := '1';
	sdaTest, sckTest : out std_logic);
end entity; 

architecture Behavioral of I2CInt is 
	constant thisDeviceAddr : std_logic_vector (6 downto 0) := "1100010"; 	--0x62
	signal sclReg, sdaReg : std_logic_vector (1 downto 0) := "11"; 		--input debounce register 
	signal output, writeNotRead : std_logic := '1'; 			--default is writing data and output high
	signal bitCount : integer range 0 to 17 := 0; 				--counting I2C bits read/written
	signal byteCount : integer range 0 to 3 := 0; 				--counting I2C bytes read/written
	signal regAddrSig, inputBuff : std_logic_vector(7 downto 0); 		--buffer for storing input bytes
	
begin
	process(fpgaClk) is
	begin
		if rising_edge(fpgaClk) then			
			sclReg <= sclReg(0) & sck; --debounce clock
			sdaReg <= sdaReg(0) & sda; --debounce data
			sdaTest <= sda;
			sckTest <= sck;
			if sclReg = "11" and sdaReg = "10" then	--On Start Event
				bitCount <= 0; 			--Reset bit count
			end if;
			
------------------Finite State Machine---------------------
			if sclReg = "01" then			--On rising edge sck
				output <= '1'; 			--Set serial output high
				writeData <= '1';		--Disable //ell write
				readData <= '1';		--Disable //ell read
				bitCount <= bitCount + 1;	--Increment bit counter
				inputBuff <= inputBuff(6 downto 0) & sdaReg(1);	--continuously read serial data bits 
				if bitCount = 7 then					--When the first byte has been read
					if inputBuff(6 downto 0) = thisDeviceAddr then	--For this device address
						byteCount <= 1;				--Increment the byte count
						writeNotRead <= not sdaReg(1)		--Load read/write opcode
						readData <= not sdaReg(1); 		-- If opcode is read load first byte of //ell data
						output <= '0';				-- Acknowledge first byte of serial data read
					end if;	
				elsif bitCount = 8 then
					if sdaReg(1) = '1' then		--If NACK or end of data received
						sda <= 'Z';		--Set output to High impedance
						bitCount <= 17;		--Move to idle state
					else
						output <= writeNotRead or regDataIn(7);	--Generate first bit of output on read cycles
					end if;
				elsif bitCount > 8 and bitCount < 16 the			--For All subsequent bits
					output <= writeNotRead or regDataIn(15-bitCount); 	--Generate output data on read cycles
				elsif bitCount = 16 then 						--When a byte of data has been read 
					if writeNotRead = '1' the					--And this is a write cycle
						if byteCount = 1 then 					--And this is the 2nd byte of data
							regAddrSig <= inputBuff(6 downto 0) & sdaReg(1);--Get the register Address
							byteCount <= 2;  				--increment byte count
						elsif byteCount > 1 then 				--if this is a data byte (i.e. all subsequent bytes)
							regDataOut <= inputBuff(6 downto 0) & sdaReg(1);--Load a byte of data to be written
							writeData <= '0'; 				--Indicate byte is ready to write
							byteCount <= 3; 				--increment byte count
						end if;
						if byteCount > 2 then 					--if this is a multiple byte write sequence			
							regAddrSig <= regAddrSig + 1; 			--increment the register address
						end if;
						output <= '0'			 			--Acknowledge byte has been read
					else					--If this is a read cycle
						regAddrSig <= regAddrSig + 1; 	--Increment register address for each byte read
						readData <= '0'; 		--Load the next data byte
					end if;
					bitCount <= 8;  			--set bit counter to loop back and process the next byte
				end if;
			end if;
-------------------------------------------------------------------------

--------------------Open collector output driver-------------------------
			if sclReg = "10" then		--on scl falling edge
				if output = '0' then 												
					sda <= '0'; 	--set the output to '0'
				else
					sda <= 'Z';	--or High Impedance (scl has a 10k pull up)
				end if;
			end if;	
-------------------------------------------------------------------------
		end if;
	end process;
	regAddr <= regAddrSig; 	--Write the reg addr to the output (using a signal allows address increment)
end Behavioral;

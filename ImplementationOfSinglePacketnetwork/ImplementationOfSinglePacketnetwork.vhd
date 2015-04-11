----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:57:13 01/14/2015 
-- Design Name: 
-- Module Name:    ImplementationOfSinglePacketnetwork- Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity ImplementationOfSinglePacketnetworkis 
port(
clock : in std_logic;
universalEnable : in std_logic;
reset : in std_logic;
--TStates : in std_logic_vector(2 downto 1);
PacketValueOn : in std_logic_vector(12 downto 1);
Enable : in std_logic_vector(16 downto 1);
TstatesOut : out std_logic_vector(2 downto 1);
RegisterValue1 : out std_logic_vector(12 downto 1);
RegisterValue2 : out std_logic_vector(12 downto 1);
RegisterValue3 : out std_logic_vector(12 downto 1);
RegisterValue4 : out std_logic_vector(12 downto 1);
RegisterValue5 : out std_logic_vector(12 downto 1);
RegisterValue6 : out std_logic_vector(12 downto 1);
RegisterValue7 : out std_logic_vector(12 downto 1);
RegisterValue8 : out std_logic_vector(12 downto 1);
RegisterValue9 : out std_logic_vector(12 downto 1);
RegisterValue10 : out std_logic_vector(12 downto 1);
RegisterValue11 : out std_logic_vector(12 downto 1);
RegisterValue12 : out std_logic_vector(12 downto 1);
RegisterValue13: out std_logic_vector(12 downto 1);
RegisterValue14 : out std_logic_vector(12 downto 1);
RegisterValue15 : out std_logic_vector(12 downto 1);
RegisterValue16 : out std_logic_vector(12 downto 1)
);
end noc3;

architecture Behavioral of ImplementationOfSinglePacketnetworkis
component Demux4x1
PORT(
clock: in std_logic;
inputLines : in std_logic_vector(12 downto 1);
selectLines : in std_logic_vector(2 downto 1);
enable : in std_logic;
outputLines1 : out std_logic_vector(12 downto 1); 
outputLines2 : out std_logic_vector(12 downto 1); 
outputLines3 : out std_logic_vector(12 downto 1); 
outputLines4 : out std_logic_vector(12 downto 1)); 
end component;
component selectLinesInMain
port(
clock : in std_logic;
 enableFromHost1 : in std_logic;
enableFromHost2 : in std_logic;
enableFromHost3 : in std_logic;
enableFromHost4 : in std_logic;
enableFromHost5 : in std_logic;
enableFromHost6 : in std_logic;
enableFromHost7 : in std_logic;
enableFromHost8 : in std_logic;
enableFromHost9 : in std_logic;
enableFromHost10 : in std_logic;
enableFromHost11: in std_logic;
enableFromHost12: in std_logic;
enableFromHost13: in std_logic;
enableFromHost14: in std_logic;
enableFromHost15: in std_logic;
enableFromHost16: in std_logic;
AddressOfSideRouter : out std_logic_vector(2 downto 1));
end component;


component host
port(clock : in std_logic;
resetHost : in std_logic;
Tstate : in std_logic_vector(2 downto 1);
FirstPacket : in std_logic_vector(12 downto 1);
inputLines :in std_logic_vector(12 downto 1); 
outputLines :out std_logic_vector(12 downto 1);
RegisterValue : out std_logic_vector(12 downto 1);
enable:in std_logic);
end component;
component mainRouter
port(clock : in std_logic;
resetMain : in std_logic;
enabletoMain : in std_logic;
enablefromSiderouter: in std_logic_vector(2 downto 1);
inputLinesFromSideRouterOne : in std_logic_vector(12 downto 1);
inputLinesFromSideRouterTwo : in std_logic_vector(12 downto 1);
inputLinesFromSideRouterThree : in std_logic_vector(12 downto 1);
inputLinesFromSideRouterFour : in std_logic_vector(12 downto 1);
outputLinesToSideRouterOne : out std_logic_vector(12 downto 1);
outputLinesToSideRouterTwo : out std_logic_vector(12 downto 1);
outputLinesToSideRouterThree : out std_logic_vector(12 downto 1);
outputLinesToSideRouterFour : out std_logic_vector(12 downto 1);
Tstate : in std_logic_vector(2 downto 1));
end component;
component mux4x1
PORT(
clock: in std_logic;
inputLines1 : in std_logic_vector(12 downto 1);
inputLines2 : in std_logic_vector(12 downto 1);
inputLines3 : in std_logic_vector(12 downto 1);
inputLines4 : in std_logic_vector(12 downto 1);
selectLines : in std_logic_vector(2 downto 1);
enable : in std_logic;
outputLines : out std_logic_vector(12 downto 1));  
end component;
component priorityenc
port( 
clock :in std_logic;
a: in std_logic ;
b: in std_logic ;
c: in std_logic ;
d: in std_logic ;
f: out std_logic_vector(2 downto 1);
enable:in std_logic
);
end component;
component sideRouter
port(clock : in std_logic;
enable : in std_logic;
Tstate : in std_logic_vector(2 downto 1);
AddressLines : out std_logic_vector(2 downto 1);
inputLinesFromMux : in std_logic_vector(12 downto 1);
outputLinesToDemux : out std_logic_vector(12 downto 1);
inputLinesFromMain : in std_logic_vector(12 downto 1);
outputLinesToMain : out std_logic_vector(12 downto 1));
end component;

signal TStatesVariable : std_logic_vector(2 downto 1);
signal TStates : std_logic_vector(2 downto 1);

signal addressofsiderouter : std_logic_vector(2 downto 1);

signal AddressLinesToDemux1 : std_logic_vector(2 downto 1);
signal AddressLinesToDemux2 : std_logic_vector(2 downto 1);
signal AddressLinesToDemux3 : std_logic_vector(2 downto 1);
signal AddressLinesToDemux4 : std_logic_vector(2 downto 1);


signal linesFromHost1ToMux :std_logic_vector(12 downto 1);
signal linesFromHost2ToMux :std_logic_vector(12 downto 1);
signal linesFromHost3ToMux :std_logic_vector(12 downto 1);
signal linesFromHost4ToMux :std_logic_vector(12 downto 1);
signal linesFromHost5ToMux :std_logic_vector(12 downto 1);
signal linesFromHost6ToMux :std_logic_vector(12 downto 1);
signal linesFromHost7ToMux :std_logic_vector(12 downto 1);
signal linesFromHost8ToMux :std_logic_vector(12 downto 1);
signal linesFromHost9ToMux :std_logic_vector(12 downto 1);
signal linesFromHost10ToMux :std_logic_vector(12 downto 1);
signal linesFromHost11ToMux :std_logic_vector(12 downto 1);
signal linesFromHost12ToMux :std_logic_vector(12 downto 1);
signal linesFromHost13ToMux :std_logic_vector(12 downto 1);
signal linesFromHost14ToMux :std_logic_vector(12 downto 1);
signal linesFromHost15ToMux :std_logic_vector(12 downto 1);
signal linesFromHost16ToMux :std_logic_vector(12 downto 1);


signal linesFromDeMuxtoHost1 :std_logic_vector(12 downto 1);
signal linesFromDeMuxtoHost2 :std_logic_vector(12 downto 1);
signal linesFromDeMuxtoHost3 :std_logic_vector(12 downto 1);
signal linesFromDeMuxtoHost4 :std_logic_vector(12 downto 1);
signal linesFromDeMuxtoHost5 :std_logic_vector(12 downto 1);
signal linesFromDeMuxtoHost6 :std_logic_vector(12 downto 1);
signal linesFromDeMuxtoHost7 :std_logic_vector(12 downto 1);
signal linesFromDeMuxtoHost8 :std_logic_vector(12 downto 1);
signal linesFromDeMuxtoHost9 :std_logic_vector(12 downto 1);
signal linesFromDeMuxtoHost10 :std_logic_vector(12 downto 1);
signal linesFromDeMuxtoHost11 :std_logic_vector(12 downto 1);
signal linesFromDeMuxtoHost12:std_logic_vector(12 downto 1);
signal linesFromDeMuxtoHost13 :std_logic_vector(12 downto 1);
signal linesFromDeMuxtoHost14 :std_logic_vector(12 downto 1);
signal linesFromDeMuxtoHost15 :std_logic_vector(12 downto 1);
signal linesFromDeMuxtoHost16 :std_logic_vector(12 downto 1);


signal linesFromMuxtoSiderouter1 :std_logic_vector(12 downto 1);
signal linesFromMuxtoSiderouter2 :std_logic_vector(12 downto 1);
signal linesFromMuxtoSiderouter3 :std_logic_vector(12 downto 1);
signal linesFromMuxtoSiderouter4 :std_logic_vector(12 downto 1);

signal linesFromSiderouter1toDemux :std_logic_vector(12 downto 1);
signal linesFromSiderouter2toDemux :std_logic_vector(12 downto 1);
signal linesFromSiderouter3toDemux :std_logic_vector(12 downto 1);
signal linesFromSiderouter4toDemux :std_logic_vector(12 downto 1);


signal linesFromSiderouter1toMainRouter :std_logic_vector(12 downto 1);
signal linesFromSiderouter2toMainRouter :std_logic_vector(12 downto 1);
signal linesFromSiderouter3toMainRouter :std_logic_vector(12 downto 1);
signal linesFromSiderouter4toMainRouter :std_logic_vector(12 downto 1);

signal linesFromMainRoutertoSiderouter1 :std_logic_vector(12 downto 1);
signal linesFromMainRoutertoSiderouter2 :std_logic_vector(12 downto 1);
signal linesFromMainRoutertoSiderouter3 :std_logic_vector(12 downto 1);
signal linesFromMainRoutertoSiderouter4 :std_logic_vector(12 downto 1);

signal linesFromEncoderToMux1 : std_logic_vector(2 downto 1);
signal linesFromEncoderToMux2 : std_logic_vector(2 downto 1);
signal linesFromEncoderToMux3 : std_logic_vector(2 downto 1);
signal linesFromEncoderToMux4 : std_logic_vector(2 downto 1);

--signal linestoencoder1 : std_logic_vector(4 downto 1);
--signal linestoencoder2 : std_logic_vector(4 downto 1);
--signal linestoencoder3 : std_logic_vector(4 downto 1);
--signal linestoencoder4 : std_logic_vector(4 downto 1);

begin

Process(clock,UniversalEnable,reset)
begin
if(clock'Event and clock = '1' and UniversalEnable = '1') then
if(reset = '1') then
TStatesVariable <= "00";
else
if(TStatesVariable = "00") then
TStatesVariable <= "01";
end if;
if(TStatesVariable = "01") then
TStatesVariable<= "10";
end if;
if(TStatesVariable = "10") then
TStatesVariable <= "11";
end if;
if(TStatesVariable = "11") then
TStatesVariable <= "00";
end if;
end if;
end if;
end process;


--now we have taken transfer of 1 packet from h1
H1 : host port map(clock,reset,TStates,PacketValueOn,linesFromDeMuxtoHost1,linesFromHost1ToMux,RegisterValue1,Enable(1));
H2 : host port map(clock,reset,TStates,"000000000000",linesFromDeMuxtoHost2,linesFromHost2ToMux,RegisterValue2,Enable(2));
H3 : host port map(clock,reset,TStates,"000000000000",linesFromDeMuxtoHost3,linesFromHost3ToMux,RegisterValue3,Enable(3));
H4 : host port map(clock,reset,TStates,"000000000000",linesFromDeMuxtoHost4,linesFromHost4ToMux,RegisterValue4,Enable(4));
H5 : host port map(clock,reset,TStates,"000000000000",linesFromDeMuxtoHost5,linesFromHost5ToMux,RegisterValue5,Enable(5));
H6 : host port map(clock,reset,TStates,"000000000000",linesFromDeMuxtoHost6,linesFromHost6ToMux,RegisterValue6,Enable(6));
H7 : host port map(clock,reset,TStates,"000000000000",linesFromDeMuxtoHost7,linesFromHost7ToMux,RegisterValue7,Enable(7));
H8 : host port map(clock,reset,TStates,"000000000000",linesFromDeMuxtoHost8,linesFromHost8ToMux,RegisterValue8,Enable(8));
H9 : host port map(clock,reset,TStates,"000000000000",linesFromDeMuxtoHost9,linesFromHost9ToMux,RegisterValue9,Enable(9));
H10 : host port map(clock,reset,TStates,"000000000000",linesFromDeMuxtoHost10,linesFromHost10ToMux,RegisterValue10,Enable(10));
H11 : host port map(clock,reset,TStates,"000000000000",linesFromDeMuxtoHost11,linesFromHost11ToMux,RegisterValue11,Enable(11));
H12: host port map(clock,reset,TStates,"000000000000",linesFromDeMuxtoHost12,linesFromHost12ToMux,RegisterValue12,Enable(12));
H13: host port map(clock,reset,TStates,"000000000000",linesFromDeMuxtoHost13,linesFromHost13ToMux,RegisterValue13,Enable(13));
H14: host port map(clock,reset,TStates,"000000000000",linesFromDeMuxtoHost14,linesFromHost14ToMux,RegisterValue14,Enable(14));
H15: host port map(clock,reset,TStates,"000000000000",linesFromDeMuxtoHost15,linesFromHost15ToMux,RegisterValue15,Enable(15));
H16 : host port map(clock,reset,TStates,"000000000000",linesFromDeMuxtoHost16,linesFromHost16ToMux,RegisterValue16,Enable(16));

digitalLogicforSideRouterAddress : selectLinesInMain port map(clock,enable(1),enable(2),enable(3),enable(4),enable(5),enable(6),enable(7),enable(8),enable(9),enable(10),enable(11),enable(12),enable(13),enable(14),enable(15),enable(16),addressofsiderouter);

encoder1 : priorityenc port map(clock,enable(1),enable(2),enable(3),enable(4),linesFromEncoderToMux1,'1');
encoder2 : priorityenc port map(clock,enable(5),enable(6),enable(7),enable(8),linesFromEncoderToMux2,'1');
encoder3 : priorityenc port map(clock,enable(9),enable(10),enable(11),enable(12),linesFromEncoderToMux3,'1');
encoder4 : priorityenc port map(clock,enable(13),enable(14),enable(15),enable(16),linesFromEncoderToMux4,'1');

mux1 : mux4x1 port map(clock,linesFromHost1ToMux,linesFromHost2ToMux,linesFromHost3ToMux,linesFromHost4ToMux,linesFromEncoderToMux1,'1',linesFromMuxtoSiderouter1);
mux2 : mux4x1 port map(clock,linesFromHost5toMux,linesFromHost6ToMux,linesFromHost7ToMux,linesFromHost8ToMux,linesFromEncoderToMux2,'1',linesFromMuxtoSiderouter2);
mux3 : mux4x1 port map(clock,linesFromHost9toMux,linesFromHost10ToMux,linesFromHost11ToMux,linesFromHost12ToMux,linesFromEncoderToMux3,'1',linesFromMuxtoSiderouter3);
mux4 : mux4x1 port map(clock,linesFromHost13ToMux,linesFromHost14ToMux,linesFromHost15ToMux,linesFromHost16toMux,linesFromEncoderToMux4,'1',linesFromMuxtoSiderouter4);

demux1 : Demux4x1 port map(clock,linesFromSiderouter1toDemux,AddressLinesTodemux1,'1',linesFromDeMuxtoHost1,linesFromDeMuxtoHost2,linesFromDeMuxtoHost3,linesFromDeMuxtoHost4);
demux2 : Demux4x1 port map(clock,linesFromSiderouter2toDemux,AddressLinesTodemux2,'1',linesFromDeMuxtoHost5,linesFromDeMuxtoHost6,linesFromDeMuxtoHost7,linesFromDeMuxtoHost8);
demux3 : Demux4x1 port map(clock,linesFromSiderouter3toDemux,AddressLinesTodemux3,'1',linesFromDeMuxtoHost9,linesFromDeMuxtoHost10,linesFromDeMuxtoHost11,linesFromDeMuxtoHost12);
demux4 : Demux4x1 port map(clock,linesFromSiderouter4toDemux,AddressLinesTodemux4,'1',linesFromDeMuxtoHost13,linesFromDeMuxtoHost14,linesFromDeMuxtoHost15,linesFromDeMuxtoHost16);

--recheck the enable
sideRouter1 : sideRouter port map(clock,'1',Tstates,AddressLinestoDemux1,linesFromMuxtoSiderouter1,linesFromSiderouter1toDemux,linesFromMainRoutertoSiderouter1,linesFromSiderouter1toMainRouter);
sideRouter2 : sideRouter port map(clock,'1',Tstates,AddressLinestoDemux2,linesFromMuxtoSiderouter2,linesFromSiderouter2toDemux,linesFromMainRoutertoSiderouter2,linesFromSiderouter2toMainRouter);
sideRouter3 : sideRouter port map(clock,'1',Tstates,AddressLinestoDemux3,linesFromMuxtoSiderouter3,linesFromSiderouter3toDemux,linesFromMainRoutertoSiderouter3,linesFromSiderouter3toMainRouter);
sideRouter4 : sideRouter port map(clock,'1',Tstates,AddressLinestoDemux4,linesFromMuxtoSiderouter4,linesFromSiderouter4toDemux,linesFromMainRoutertoSiderouter4,linesFromSiderouter4toMainRouter);


bahutmainrouter : mainrouter port map(clock,reset,'1',addressofsiderouter,linesFromSiderouter1toMainRouter,
linesFromSiderouter2toMainRouter,linesFromSiderouter3toMainRouter,linesFromSiderouter4toMainRouter,
linesFromMainRoutertoSiderouter1, linesFromMainRoutertoSiderouter2,linesFromMainRoutertoSiderouter3,
linesFromMainRoutertoSiderouter4, Tstates);


Tstates <=TStatesVariable;
TstatesOut<=TstatesVariable;


end Behavioral;
----------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux4x1 is
PORT(
clock: in std_logic;
inputLines1 : in std_logic_vector(12 downto 1);
inputLines2 : in std_logic_vector(12 downto 1);
inputLines3 : in std_logic_vector(12 downto 1);
inputLines4 : in std_logic_vector(12 downto 1);
selectLines : in std_logic_vector(2 downto 1);
enable : in std_logic;
outputLines : out std_logic_vector(12 downto 1)); 
end mux4x1;

architecture behOfmux4x1 of mux4x1 is
begin
process(clock, enable)
begin
if(enable = '1' and clock'Event and clock = '1') then
if(selectLines = "00") then
outputLines(12 downto 1) <= inputLines1;
end if;
if(selectLines = "01") then
outputLines(12 downto 1) <= inputLines2;
end if;
if(selectLines = "10") then
outputLines(12 downto 1) <= inputLines3;
end if;
if(selectLines = "11") then
outputLines(12 downto 1) <= inputLines4;
end if;
end if;
end process;
end behOfmux4x1;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Demux4x1 is
PORT(
clock: in std_logic;
inputLines : in std_logic_vector(12 downto 1);
selectLines : in std_logic_vector(2 downto 1);
enable : in std_logic;
outputLines1 : out std_logic_vector(12 downto 1); 
outputLines2 : out std_logic_vector(12 downto 1); 
outputLines3 : out std_logic_vector(12 downto 1); 
outputLines4 : out std_logic_vector(12 downto 1)); 

end Demux4x1;

architecture behOfDemux4x1 of Demux4x1 is
begin
process(clock, enable)
begin
if(enable = '1' and clock'Event and clock = '1') then
if(selectLines = "00") then
outputLines1 <= inputLines(12 downto 1);
end if;
if(selectLines = "01") then
outputLines2 <= inputLines(12 downto 1);
end if;
if(selectLines = "10") then
outputLines3 <= inputLines(12 downto 1);
end if;
if(selectLines = "11") then
outputLines4 <= inputLines(12 downto 1);
end if;
end if;
end process;
end behOfDemux4x1;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity priorityenc is 
port( 
clock :in std_logic;
a: in std_logic ;
b: in std_logic ;
c: in std_logic ;
d: in std_logic ;
f: out std_logic_vector(2 downto 1);
enable:in std_logic
);
end priorityenc; 

architecture behavOfEnc of priorityenc is
begin
process(clock,enable)
begin
if(clock'event and clock='1' and enable='1') then
f(2)<= ((not a) and b ) or ( (not c) and (not a));
f(1) <= (not a) and (not b); 
end if;
end process ;
end behavOfEnc ; 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity host is
port(clock : in std_logic;
resetHost : in std_logic ;
Tstate : in std_logic_vector(2 downto 1);
FirstPacket : in std_logic_vector(12 downto 1);
inputLines :in std_logic_vector(12 downto 1); 
outputLines :out std_logic_vector(12 downto 1);
RegisterValue : out std_logic_vector(12 downto 1);
enable:in std_logic);
end host;
architecture behavofhost of host is 
signal samplePacket : std_logic_vector(12 downto 1);
begin
process(clock,enable,resetHost)
begin
if(clock'Event and clock = '1' and enable = '1') then
if(resetHost='1') then
samplePacket <= firstPacket;
end if;
if(Tstate = "00") then
outputLines<=samplePacket;
end if;
if(Tstate = "11") then
samplePacket <= inputLines;
end if;
end if;
end process;

RegisterValue <= samplePacket;

end behavofhost;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity sideRouter is
port(clock : in std_logic;
enable : in std_logic;
Tstate : in std_logic_vector(2 downto 1);
AddressLines : out std_logic_vector(2 downto 1);
--AddressOfSideRouter : out std_logic_vector(2 downto 1);
inputLinesFromMux : in std_logic_vector(12 downto 1);
outputLinesToDemux : out std_logic_vector(12 downto 1);
inputLinesFromMain : in std_logic_vector(12 downto 1);
outputLinesToMain : out std_logic_vector(12 downto 1));
end sideRouter;

architecture behavOfSideRouter of sideRouter is
--variable samplePacket : std_logic_vector(12 downto 1)  := "000000000000";
begin

process(clock,enable)
begin
if(clock'Event and clock = '1' and enable = '1') then

if(Tstate = "01") then
outputLinesToMain<=inputLinesFromMux ;
end if;
if(Tstate = "10") then
outputLinesToDemux<=inputLinesFromMain ;
end if;
end if;
end process;

process(inputLinesFromMain)
begin
AddressLines(2) <= inputLinesFromMain(12);
AddressLines(1) <= inputLinesFromMain(11);
end process;

end behavOfSideRouter;
--RegisterValue <= samplePacket;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mainRouter is 
port(clock : in std_logic;
resetMain : in std_logic ; 
enabletoMain : in std_logic;
enablefromSiderouter: in std_logic_vector(2 downto 1);
inputLinesFromSideRouterOne : in std_logic_vector(12 downto 1);
inputLinesFromSideRouterTwo : in std_logic_vector(12 downto 1);
inputLinesFromSideRouterThree : in std_logic_vector(12 downto 1);
inputLinesFromSideRouterFour : in std_logic_vector(12 downto 1);
outputLinesToSideRouterOne : out std_logic_vector(12 downto 1);
outputLinesToSideRouterTwo : out std_logic_vector(12 downto 1);
outputLinesToSideRouterThree : out std_logic_vector(12 downto 1);
outputLinesToSideRouterFour : out std_logic_vector(12 downto 1);
Tstate : in std_logic_vector(2 downto 1));
end mainRouter;

architecture behavofMain of mainRouter is 
signal samplePacket : std_logic_vector(12 downto 1);

begin 
process(clock , enabletoMain,resetMain) 
begin 
if(clock'Event and clock = '1' and enabletoMain = '1') then
if(resetMain='1') then
samplePacket <= "000000000000";
end if;
if (Tstate = "01") then 
if (enablefromSiderouter="00") then
samplePacket<= inputLinesFromSideRouterOne;
end if;
if (enablefromSiderouter="01") then
samplePacket<= inputLinesFromSideRouterTwo;
end if;
if (enablefromSiderouter="10") then
samplePacket<= inputLinesFromSideRouterThree;
end if;
if (enablefromSiderouter="11") then
samplePacket<= inputLinesFromSideRouterFour;
end if;

end if;
if (Tstate = "10") then
if (samplePacket(4) = '0' and samplepacket(3) = '0') then
outputLinesToSideRouterOne <= samplepacket ;
end if;
if (samplepacket(4) = '0' and samplepacket(3) = '1') then
outputLinesToSideRouterTwo <= samplepacket ;
end if;
if (samplepacket(4) = '1' and samplepacket(3) = '0') then
outputLinesToSideRouterThree <= samplepacket ;
end if;
if (samplepacket(4) = '1' and samplepacket(3) = '1') then
outputLinesToSideRouterFour <= samplepacket ;
end if;
end if ;
end if;
end process;
end behavofMain ;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity selectLinesInMain is
port(
clock : in std_logic;
 enableFromHost1 : in std_logic;
enableFromHost2 : in std_logic;
enableFromHost3 : in std_logic;
enableFromHost4 : in std_logic;
enableFromHost5 : in std_logic;
enableFromHost6 : in std_logic;
enableFromHost7 : in std_logic;
enableFromHost8 : in std_logic;
enableFromHost9 : in std_logic;
enableFromHost10 : in std_logic;
enableFromHost11: in std_logic;
enableFromHost12: in std_logic;
enableFromHost13: in std_logic;
enableFromHost14: in std_logic;
enableFromHost15: in std_logic;
enableFromHost16: in std_logic;
AddressOfSideRouter : out std_logic_vector(2 downto 1));
end selectLinesInMain;

architecture behavOfselectLines of selectLinesInMain is
begin
process(clock)
begin
if(clock'event and clock='1') then
if(enableFromHost1='1' or enableFromHost2='1' or enableFromHost3='1' or enableFromHost4='1' ) then
AddressOfSideRouter<="00";
end if; 
if(enableFromHost5='1' or enableFromHost6='1' or enableFromHost7='1' or enableFromHost8='1' ) then
AddressOfSideRouter<="01";
end if; 
if(enableFromHost9='1' or enableFromHost10='1' or enableFromHost11='1' or enableFromHost12='1' ) then
AddressOfSideRouter<="10";
end if; 
if(enableFromHost13='1' or enableFromHost14='1' or enableFromHost15='1' or enableFromHost16='1' ) then
AddressOfSideRouter<="11";
end if; 
end if;
end process;
end behavOfselectLines;


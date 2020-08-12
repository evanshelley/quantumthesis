--Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
--Date        : Tue Aug 11 13:43:02 2020
--Host        : DESKTOP-P11O3F8 running 64-bit major release  (build 9200)
--Command     : generate_target lockin_wrapper.bd
--Design      : lockin_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity lockin_wrapper is
  port (
    clk : in STD_LOGIC;
    sq1 : out STD_LOGIC_VECTOR ( 95 downto 0 );
    sq2 : out STD_LOGIC_VECTOR ( 95 downto 0 );
    tunnel : in STD_LOGIC_VECTOR ( 2 downto 0 )
  );
end lockin_wrapper;

architecture STRUCTURE of lockin_wrapper is
  component lockin is
  port (
    clk : in STD_LOGIC;
    sq1 : out STD_LOGIC_VECTOR ( 95 downto 0 );
    sq2 : out STD_LOGIC_VECTOR ( 95 downto 0 );
    tunnel : in STD_LOGIC_VECTOR ( 2 downto 0 )
  );
  end component lockin;
begin
lockin_i: component lockin
     port map (
      clk => clk,
      sq1(95 downto 0) => sq1(95 downto 0),
      sq2(95 downto 0) => sq2(95 downto 0),
      tunnel(2 downto 0) => tunnel(2 downto 0)
    );
end STRUCTURE;

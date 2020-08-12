--Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
--Date        : Tue Jul 28 13:51:23 2020
--Host        : DESKTOP-P11O3F8 running 64-bit major release  (build 9200)
--Command     : generate_target lockin.bd
--Design      : lockin
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity lockin is
  port (
    clk : in STD_LOGIC;
    filteredout : out STD_LOGIC_VECTOR ( 23 downto 0 )
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of lockin : entity is "lockin,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=lockin,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=2,numReposBlks=2,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of lockin : entity is "lockin.hwdef";
end lockin;

architecture STRUCTURE of lockin is
  component lockin_dds_compiler_0_0 is
  port (
    aclk : in STD_LOGIC;
    m_axis_data_tvalid : out STD_LOGIC;
    m_axis_data_tdata : out STD_LOGIC_VECTOR ( 15 downto 0 );
    m_axis_phase_tvalid : out STD_LOGIC;
    m_axis_phase_tdata : out STD_LOGIC_VECTOR ( 15 downto 0 )
  );
  end component lockin_dds_compiler_0_0;
  component lockin_fir_compiler_0_1 is
  port (
    aclk : in STD_LOGIC;
    s_axis_data_tvalid : in STD_LOGIC;
    s_axis_data_tready : out STD_LOGIC;
    s_axis_data_tdata : in STD_LOGIC_VECTOR ( 15 downto 0 );
    m_axis_data_tvalid : out STD_LOGIC;
    m_axis_data_tdata : out STD_LOGIC_VECTOR ( 23 downto 0 )
  );
  end component lockin_fir_compiler_0_1;
  signal clk_1 : STD_LOGIC;
  signal dds_compiler_0_m_axis_data_tdata : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal dds_compiler_0_m_axis_data_tvalid : STD_LOGIC;
  signal fir_compiler_0_m_axis_data_tdata : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal NLW_dds_compiler_0_m_axis_phase_tvalid_UNCONNECTED : STD_LOGIC;
  signal NLW_dds_compiler_0_m_axis_phase_tdata_UNCONNECTED : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal NLW_fir_compiler_0_m_axis_data_tvalid_UNCONNECTED : STD_LOGIC;
  signal NLW_fir_compiler_0_s_axis_data_tready_UNCONNECTED : STD_LOGIC;
begin
  clk_1 <= clk;
  filteredout(23 downto 0) <= fir_compiler_0_m_axis_data_tdata(23 downto 0);
dds_compiler_0: component lockin_dds_compiler_0_0
     port map (
      aclk => clk_1,
      m_axis_data_tdata(15 downto 0) => dds_compiler_0_m_axis_data_tdata(15 downto 0),
      m_axis_data_tvalid => dds_compiler_0_m_axis_data_tvalid,
      m_axis_phase_tdata(15 downto 0) => NLW_dds_compiler_0_m_axis_phase_tdata_UNCONNECTED(15 downto 0),
      m_axis_phase_tvalid => NLW_dds_compiler_0_m_axis_phase_tvalid_UNCONNECTED
    );
fir_compiler_0: component lockin_fir_compiler_0_1
     port map (
      aclk => clk_1,
      m_axis_data_tdata(23 downto 0) => fir_compiler_0_m_axis_data_tdata(23 downto 0),
      m_axis_data_tvalid => NLW_fir_compiler_0_m_axis_data_tvalid_UNCONNECTED,
      s_axis_data_tdata(15 downto 0) => dds_compiler_0_m_axis_data_tdata(15 downto 0),
      s_axis_data_tready => NLW_fir_compiler_0_s_axis_data_tready_UNCONNECTED,
      s_axis_data_tvalid => dds_compiler_0_m_axis_data_tvalid
    );
end STRUCTURE;

--Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
--Date        : Tue Aug 11 13:43:02 2020
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
    sq1 : out STD_LOGIC_VECTOR ( 95 downto 0 );
    sq2 : out STD_LOGIC_VECTOR ( 95 downto 0 );
    tunnel : in STD_LOGIC_VECTOR ( 2 downto 0 )
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of lockin : entity is "lockin,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=lockin,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=15,numReposBlks=15,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of lockin : entity is "lockin.hwdef";
end lockin;

architecture STRUCTURE of lockin is
  component lockin_dds_compiler_0_1 is
  port (
    aclk : in STD_LOGIC;
    m_axis_data_tvalid : out STD_LOGIC;
    m_axis_data_tdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axis_phase_tvalid : out STD_LOGIC;
    m_axis_phase_tdata : out STD_LOGIC_VECTOR ( 15 downto 0 )
  );
  end component lockin_dds_compiler_0_1;
  component lockin_xlslice_0_1 is
  port (
    Din : in STD_LOGIC_VECTOR ( 31 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 13 downto 0 )
  );
  end component lockin_xlslice_0_1;
  component lockin_xlslice_1_1 is
  port (
    Din : in STD_LOGIC_VECTOR ( 31 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 13 downto 0 )
  );
  end component lockin_xlslice_1_1;
  component lockin_mult_gen_0_0 is
  port (
    CLK : in STD_LOGIC;
    A : in STD_LOGIC_VECTOR ( 13 downto 0 );
    B : in STD_LOGIC_VECTOR ( 13 downto 0 );
    P : out STD_LOGIC_VECTOR ( 27 downto 0 )
  );
  end component lockin_mult_gen_0_0;
  component lockin_mult_gen_1_0 is
  port (
    CLK : in STD_LOGIC;
    A : in STD_LOGIC_VECTOR ( 13 downto 0 );
    B : in STD_LOGIC_VECTOR ( 13 downto 0 );
    P : out STD_LOGIC_VECTOR ( 27 downto 0 )
  );
  end component lockin_mult_gen_1_0;
  component lockin_fir_compiler_0_0 is
  port (
    aclk : in STD_LOGIC;
    s_axis_data_tvalid : in STD_LOGIC;
    s_axis_data_tready : out STD_LOGIC;
    s_axis_data_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axis_data_tvalid : out STD_LOGIC;
    m_axis_data_tdata : out STD_LOGIC_VECTOR ( 47 downto 0 )
  );
  end component lockin_fir_compiler_0_0;
  component lockin_fir_compiler_1_0 is
  port (
    aclk : in STD_LOGIC;
    s_axis_data_tvalid : in STD_LOGIC;
    s_axis_data_tready : out STD_LOGIC;
    s_axis_data_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axis_data_tvalid : out STD_LOGIC;
    m_axis_data_tdata : out STD_LOGIC_VECTOR ( 47 downto 0 )
  );
  end component lockin_fir_compiler_1_0;
  component lockin_mult_gen_2_0 is
  port (
    CLK : in STD_LOGIC;
    A : in STD_LOGIC_VECTOR ( 47 downto 0 );
    B : in STD_LOGIC_VECTOR ( 47 downto 0 );
    P : out STD_LOGIC_VECTOR ( 95 downto 0 )
  );
  end component lockin_mult_gen_2_0;
  component lockin_mult_gen_3_0 is
  port (
    CLK : in STD_LOGIC;
    A : in STD_LOGIC_VECTOR ( 47 downto 0 );
    B : in STD_LOGIC_VECTOR ( 47 downto 0 );
    P : out STD_LOGIC_VECTOR ( 95 downto 0 )
  );
  end component lockin_mult_gen_3_0;
  component lockin_mult_gen_4_0 is
  port (
    CLK : in STD_LOGIC;
    A : in STD_LOGIC_VECTOR ( 10 downto 0 );
    B : in STD_LOGIC_VECTOR ( 2 downto 0 );
    P : out STD_LOGIC_VECTOR ( 13 downto 0 )
  );
  end component lockin_mult_gen_4_0;
  component lockin_dds_compiler_0_0 is
  port (
    aclk : in STD_LOGIC;
    m_axis_data_tvalid : out STD_LOGIC;
    m_axis_data_tdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axis_phase_tvalid : out STD_LOGIC;
    m_axis_phase_tdata : out STD_LOGIC_VECTOR ( 15 downto 0 )
  );
  end component lockin_dds_compiler_0_0;
  component lockin_xlslice_2_0 is
  port (
    Din : in STD_LOGIC_VECTOR ( 31 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 10 downto 0 )
  );
  end component lockin_xlslice_2_0;
  component lockin_xlconcat_0_0 is
  port (
    In0 : in STD_LOGIC_VECTOR ( 27 downto 0 );
    In1 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    dout : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  end component lockin_xlconcat_0_0;
  component lockin_xlconcat_0_1 is
  port (
    In0 : in STD_LOGIC_VECTOR ( 27 downto 0 );
    In1 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    dout : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  end component lockin_xlconcat_0_1;
  component lockin_xlconstant_0_0 is
  port (
    dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component lockin_xlconstant_0_0;
  signal clk_1 : STD_LOGIC;
  signal dds_compiler_0_m_axis_data_tdata : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal dds_compiler_1_m_axis_data_tdata : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal fir_compiler_0_m_axis_data_tdata : STD_LOGIC_VECTOR ( 47 downto 0 );
  signal fir_compiler_1_m_axis_data_tdata : STD_LOGIC_VECTOR ( 47 downto 0 );
  signal mult_gen_0_P : STD_LOGIC_VECTOR ( 27 downto 0 );
  signal mult_gen_1_P : STD_LOGIC_VECTOR ( 27 downto 0 );
  signal mult_gen_2_P : STD_LOGIC_VECTOR ( 95 downto 0 );
  signal mult_gen_3_P : STD_LOGIC_VECTOR ( 95 downto 0 );
  signal mult_gen_4_P : STD_LOGIC_VECTOR ( 13 downto 0 );
  signal tunnel_1 : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal xlconcat_0_dout : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xlconcat_1_dout : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xlconstant_0_dout : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xlslice_0_Dout : STD_LOGIC_VECTOR ( 13 downto 0 );
  signal xlslice_1_Dout : STD_LOGIC_VECTOR ( 13 downto 0 );
  signal xlslice_2_Dout : STD_LOGIC_VECTOR ( 10 downto 0 );
  signal NLW_dds_compiler_0_m_axis_data_tvalid_UNCONNECTED : STD_LOGIC;
  signal NLW_dds_compiler_0_m_axis_phase_tvalid_UNCONNECTED : STD_LOGIC;
  signal NLW_dds_compiler_0_m_axis_phase_tdata_UNCONNECTED : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal NLW_dds_compiler_1_m_axis_data_tvalid_UNCONNECTED : STD_LOGIC;
  signal NLW_dds_compiler_1_m_axis_phase_tvalid_UNCONNECTED : STD_LOGIC;
  signal NLW_dds_compiler_1_m_axis_phase_tdata_UNCONNECTED : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal NLW_fir_compiler_0_m_axis_data_tvalid_UNCONNECTED : STD_LOGIC;
  signal NLW_fir_compiler_0_s_axis_data_tready_UNCONNECTED : STD_LOGIC;
  signal NLW_fir_compiler_1_m_axis_data_tvalid_UNCONNECTED : STD_LOGIC;
  signal NLW_fir_compiler_1_s_axis_data_tready_UNCONNECTED : STD_LOGIC;
begin
  clk_1 <= clk;
  sq1(95 downto 0) <= mult_gen_2_P(95 downto 0);
  sq2(95 downto 0) <= mult_gen_3_P(95 downto 0);
  tunnel_1(2 downto 0) <= tunnel(2 downto 0);
dds_compiler_0: component lockin_dds_compiler_0_1
     port map (
      aclk => clk_1,
      m_axis_data_tdata(31 downto 0) => dds_compiler_0_m_axis_data_tdata(31 downto 0),
      m_axis_data_tvalid => NLW_dds_compiler_0_m_axis_data_tvalid_UNCONNECTED,
      m_axis_phase_tdata(15 downto 0) => NLW_dds_compiler_0_m_axis_phase_tdata_UNCONNECTED(15 downto 0),
      m_axis_phase_tvalid => NLW_dds_compiler_0_m_axis_phase_tvalid_UNCONNECTED
    );
dds_compiler_1: component lockin_dds_compiler_0_0
     port map (
      aclk => clk_1,
      m_axis_data_tdata(31 downto 0) => dds_compiler_1_m_axis_data_tdata(31 downto 0),
      m_axis_data_tvalid => NLW_dds_compiler_1_m_axis_data_tvalid_UNCONNECTED,
      m_axis_phase_tdata(15 downto 0) => NLW_dds_compiler_1_m_axis_phase_tdata_UNCONNECTED(15 downto 0),
      m_axis_phase_tvalid => NLW_dds_compiler_1_m_axis_phase_tvalid_UNCONNECTED
    );
fir_compiler_0: component lockin_fir_compiler_0_0
     port map (
      aclk => clk_1,
      m_axis_data_tdata(47 downto 0) => fir_compiler_0_m_axis_data_tdata(47 downto 0),
      m_axis_data_tvalid => NLW_fir_compiler_0_m_axis_data_tvalid_UNCONNECTED,
      s_axis_data_tdata(31 downto 0) => xlconcat_0_dout(31 downto 0),
      s_axis_data_tready => NLW_fir_compiler_0_s_axis_data_tready_UNCONNECTED,
      s_axis_data_tvalid => xlconstant_0_dout(0)
    );
fir_compiler_1: component lockin_fir_compiler_1_0
     port map (
      aclk => clk_1,
      m_axis_data_tdata(47 downto 0) => fir_compiler_1_m_axis_data_tdata(47 downto 0),
      m_axis_data_tvalid => NLW_fir_compiler_1_m_axis_data_tvalid_UNCONNECTED,
      s_axis_data_tdata(31 downto 0) => xlconcat_1_dout(31 downto 0),
      s_axis_data_tready => NLW_fir_compiler_1_s_axis_data_tready_UNCONNECTED,
      s_axis_data_tvalid => xlconstant_0_dout(0)
    );
mult_gen_0: component lockin_mult_gen_0_0
     port map (
      A(13 downto 0) => mult_gen_4_P(13 downto 0),
      B(13 downto 0) => xlslice_0_Dout(13 downto 0),
      CLK => clk_1,
      P(27 downto 0) => mult_gen_0_P(27 downto 0)
    );
mult_gen_1: component lockin_mult_gen_1_0
     port map (
      A(13 downto 0) => mult_gen_4_P(13 downto 0),
      B(13 downto 0) => xlslice_1_Dout(13 downto 0),
      CLK => clk_1,
      P(27 downto 0) => mult_gen_1_P(27 downto 0)
    );
mult_gen_2: component lockin_mult_gen_2_0
     port map (
      A(47 downto 0) => fir_compiler_0_m_axis_data_tdata(47 downto 0),
      B(47 downto 0) => fir_compiler_0_m_axis_data_tdata(47 downto 0),
      CLK => clk_1,
      P(95 downto 0) => mult_gen_2_P(95 downto 0)
    );
mult_gen_3: component lockin_mult_gen_3_0
     port map (
      A(47 downto 0) => fir_compiler_1_m_axis_data_tdata(47 downto 0),
      B(47 downto 0) => fir_compiler_1_m_axis_data_tdata(47 downto 0),
      CLK => clk_1,
      P(95 downto 0) => mult_gen_3_P(95 downto 0)
    );
mult_gen_4: component lockin_mult_gen_4_0
     port map (
      A(10 downto 0) => xlslice_2_Dout(10 downto 0),
      B(2 downto 0) => tunnel_1(2 downto 0),
      CLK => clk_1,
      P(13 downto 0) => mult_gen_4_P(13 downto 0)
    );
xlconcat_0: component lockin_xlconcat_0_0
     port map (
      In0(27 downto 0) => mult_gen_0_P(27 downto 0),
      In1(3 downto 0) => B"0000",
      dout(31 downto 0) => xlconcat_0_dout(31 downto 0)
    );
xlconcat_1: component lockin_xlconcat_0_1
     port map (
      In0(27 downto 0) => mult_gen_1_P(27 downto 0),
      In1(3 downto 0) => B"0000",
      dout(31 downto 0) => xlconcat_1_dout(31 downto 0)
    );
xlconstant_0: component lockin_xlconstant_0_0
     port map (
      dout(0) => xlconstant_0_dout(0)
    );
xlslice_0: component lockin_xlslice_0_1
     port map (
      Din(31 downto 0) => dds_compiler_0_m_axis_data_tdata(31 downto 0),
      Dout(13 downto 0) => xlslice_0_Dout(13 downto 0)
    );
xlslice_1: component lockin_xlslice_1_1
     port map (
      Din(31 downto 0) => dds_compiler_0_m_axis_data_tdata(31 downto 0),
      Dout(13 downto 0) => xlslice_1_Dout(13 downto 0)
    );
xlslice_2: component lockin_xlslice_2_0
     port map (
      Din(31 downto 0) => dds_compiler_1_m_axis_data_tdata(31 downto 0),
      Dout(10 downto 0) => xlslice_2_Dout(10 downto 0)
    );
end STRUCTURE;

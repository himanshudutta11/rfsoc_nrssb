library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ofdm_decimator_v1_0 is
	port (
		aclk	: in std_logic;
		aresetn	: in std_logic;
		s_real_axis_tready	: out std_logic;
		s_real_axis_tdata	: in std_logic_vector(31 downto 0);
		s_real_axis_tvalid	: in std_logic;
		s_imag_axis_tready	: out std_logic;
		s_imag_axis_tdata	: in std_logic_vector(31 downto 0);
		s_imag_axis_tvalid	: in std_logic;
		m_axis_tvalid	: out std_logic;
		m_axis_tdata	: out std_logic_vector(31 downto 0);
        m_symbol_axis_tdata : out std_logic_vector(31 downto 0);
        m_symbol_axis_tvalid : out std_logic;
        m_observe_axis_tdata : out std_logic_vector(31 downto 0);
        m_observe_axis_tvalid : out std_logic
	);
end ofdm_decimator_v1_0;

architecture arch_imp of ofdm_decimator_v1_0 is

COMPONENT fir_decimator_stage_0
  PORT (
    aresetn : IN STD_LOGIC;
    aclk : IN STD_LOGIC;
    s_axis_data_tvalid : IN STD_LOGIC;
    s_axis_data_tready : OUT STD_LOGIC;
    s_axis_data_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    m_axis_data_tvalid : OUT STD_LOGIC;
    m_axis_data_tready : IN STD_LOGIC;
    m_axis_data_tdata : OUT STD_LOGIC_VECTOR(47 DOWNTO 0)
  );
END COMPONENT;

COMPONENT fir_decimator_stage_1
  PORT (
    aresetn : IN STD_LOGIC;
    aclk : IN STD_LOGIC;
    s_axis_data_tvalid : IN STD_LOGIC;
    s_axis_data_tready : OUT STD_LOGIC;
    s_axis_data_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_data_tvalid : OUT STD_LOGIC;
    m_axis_data_tready : IN STD_LOGIC;
    m_axis_data_tdata : OUT STD_LOGIC_VECTOR(47 DOWNTO 0)
  );
END COMPONENT;

COMPONENT fir_decimator_stage_2
  PORT (
    aresetn : IN STD_LOGIC;
    aclk : IN STD_LOGIC;
    s_axis_data_tvalid : IN STD_LOGIC;
    s_axis_data_tready : OUT STD_LOGIC;
    s_axis_data_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_data_tvalid : OUT STD_LOGIC;
    m_axis_data_tready : IN STD_LOGIC;
    m_axis_data_tdata : OUT STD_LOGIC_VECTOR(47 DOWNTO 0)
  );
END COMPONENT;

COMPONENT fir_decimator_stage_3
  PORT (
    aresetn : IN STD_LOGIC;
    aclk : IN STD_LOGIC;
    s_axis_data_tvalid : IN STD_LOGIC;
    s_axis_data_tready : OUT STD_LOGIC;
    s_axis_data_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_data_tvalid : OUT STD_LOGIC;
    m_axis_data_tready : IN STD_LOGIC;
    m_axis_data_tdata : OUT STD_LOGIC_VECTOR(47 DOWNTO 0)
  );
END COMPONENT;

signal sig_s_axis_tvalid_combined : std_logic;
signal sig_s_axis_tdata_combined : std_logic_vector(63 downto 0);
signal sig_s_axis_tready_distributed : std_logic;

signal sig_m_axis_tvalid_stage_0 : std_logic;
signal sig_m_axis_tdata_stage_0 : std_logic_vector(47 downto 0);
signal sig_m_axis_tready_stage_0 : std_logic;
signal sig_m_axis_tdata_stage_0_convert : std_logic_vector(31 downto 0);

signal sig_m_axis_tvalid_stage_1 : std_logic;
signal sig_m_axis_tdata_stage_1 : std_logic_vector(47 downto 0);
signal sig_m_axis_tready_stage_1 : std_logic;
signal sig_m_axis_tdata_stage_1_convert : std_logic_vector(31 downto 0);

signal sig_m_axis_tvalid_stage_2 : std_logic;
signal sig_m_axis_tdata_stage_2 : std_logic_vector(47 downto 0);
signal sig_m_axis_tready_stage_2 : std_logic;
signal sig_m_axis_tdata_stage_2_convert : std_logic_vector(31 downto 0);

signal sig_m_axis_tdata_stage_3 : std_logic_vector(47 downto 0);
signal sig_m_axis_tvalid : std_logic;

begin

fir_stage_0_inst : fir_decimator_stage_0
  PORT MAP (
    aresetn => aresetn,
    aclk => aclk,
    s_axis_data_tvalid => sig_s_axis_tvalid_combined,
    s_axis_data_tready => sig_s_axis_tready_distributed,
    s_axis_data_tdata => sig_s_axis_tdata_combined,
    m_axis_data_tvalid => sig_m_axis_tvalid_stage_0,
    m_axis_data_tready => sig_m_axis_tready_stage_0,
    m_axis_data_tdata => sig_m_axis_tdata_stage_0
  );

fir_stage_1_inst : fir_decimator_stage_1
  PORT MAP (
    aresetn => aresetn,
    aclk => aclk,
    s_axis_data_tvalid => sig_m_axis_tvalid_stage_0,
    s_axis_data_tready => sig_m_axis_tready_stage_0,
    s_axis_data_tdata => sig_m_axis_tdata_stage_0_convert,
    m_axis_data_tvalid => sig_m_axis_tvalid_stage_1,
    m_axis_data_tready => sig_m_axis_tready_stage_1,
    m_axis_data_tdata => sig_m_axis_tdata_stage_1
  );

fir_stage_2_inst : fir_decimator_stage_2
  PORT MAP (
    aresetn => aresetn,
    aclk => aclk,
    s_axis_data_tvalid => sig_m_axis_tvalid_stage_1,
    s_axis_data_tready => sig_m_axis_tready_stage_1,
    s_axis_data_tdata => sig_m_axis_tdata_stage_1_convert,
    m_axis_data_tvalid => sig_m_axis_tvalid_stage_2,
    m_axis_data_tready => sig_m_axis_tready_stage_2,
    m_axis_data_tdata => sig_m_axis_tdata_stage_2
  );

fir_stage_3_inst : fir_decimator_stage_3
  PORT MAP (
    aresetn => aresetn,
    aclk => aclk,
    s_axis_data_tvalid => sig_m_axis_tvalid_stage_2,
    s_axis_data_tready => sig_m_axis_tready_stage_2,
    s_axis_data_tdata => sig_m_axis_tdata_stage_2_convert,
    m_axis_data_tvalid => sig_m_axis_tvalid,
    m_axis_data_tready => '1',
    m_axis_data_tdata => sig_m_axis_tdata_stage_3
  );
  
sig_m_axis_tdata_stage_0_convert <= sig_m_axis_tdata_stage_0(47 downto 47) & sig_m_axis_tdata_stage_0(45 downto 31) & sig_m_axis_tdata_stage_0(23 downto 23) & sig_m_axis_tdata_stage_0(21 downto 7);
sig_m_axis_tdata_stage_1_convert <= sig_m_axis_tdata_stage_1(47 downto 47) & sig_m_axis_tdata_stage_1(45 downto 31) & sig_m_axis_tdata_stage_1(23 downto 23) & sig_m_axis_tdata_stage_1(21 downto 7);
sig_m_axis_tdata_stage_2_convert <= sig_m_axis_tdata_stage_2(47 downto 47) & sig_m_axis_tdata_stage_2(45 downto 31) & sig_m_axis_tdata_stage_2(23 downto 23) & sig_m_axis_tdata_stage_2(21 downto 7);
m_axis_tdata <= sig_m_axis_tdata_stage_3(47 downto 47) & sig_m_axis_tdata_stage_3(45 downto 31) & sig_m_axis_tdata_stage_3(23 downto 23) & sig_m_axis_tdata_stage_3(21 downto 7);
m_axis_tvalid <= sig_m_axis_tvalid;

s_real_axis_tready <= sig_s_axis_tready_distributed;
s_imag_axis_tready <= sig_s_axis_tready_distributed;

sig_s_axis_tvalid_combined <= s_real_axis_tvalid and s_imag_axis_tvalid;
sig_s_axis_tdata_combined <= s_imag_axis_tdata(31 downto 16) & s_real_axis_tdata(31 downto 16) & s_imag_axis_tdata(15 downto 0) & s_real_axis_tdata(15 downto 0);

m_symbol_axis_tvalid <= sig_m_axis_tvalid;
m_symbol_axis_tdata <= sig_m_axis_tdata_stage_3(47 downto 47) & sig_m_axis_tdata_stage_3(45 downto 31) & sig_m_axis_tdata_stage_3(23 downto 23) & sig_m_axis_tdata_stage_3(21 downto 7);
m_observe_axis_tvalid <= sig_m_axis_tvalid_stage_0;
m_observe_axis_tdata <= sig_m_axis_tdata_stage_0_convert;

end arch_imp;

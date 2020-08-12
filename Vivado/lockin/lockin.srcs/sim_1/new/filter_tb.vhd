----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.07.2020 13:44:59
-- Design Name: 
-- Module Name: filter_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity filter_tb is
    
end filter_tb;

architecture Behavioral of filter_tb is

component lockin
        port (clk : in std_logic;
              tunnel : in std_logic_vector(2 downto 0);
                sq1 : out std_logic_vector(95 downto 0);
                sq2 : out std_logic_vector(95 downto 0));
    end component;
    
    signal clock : std_logic := '0';
    signal tunnel : std_logic_vector(2 downto 0) := "001";
        signal sq1 : std_logic_vector(95 downto 0);
        signal sq2 : std_logic_vector(95 downto 0);
        shared variable i : integer := 0;


begin

    UUT: lockin port map (clk => clock, tunnel => tunnel, sq1 => sq1, sq2 => sq2);
    
    process
        begin
        
        tunnel <= "001";
        
        -- toggle every 5ns means 100MHz clock, T = 10ns
        -- separated into 10 cycles -> 100ns
        
        for i in 1 to 60 loop
            wait for 5ns;
            clock <= not clock;
        end loop;
        

        tunnel <= "100";
        
        for i in 1 to 60 loop
                    wait for 5ns;
                    clock <= not clock;
                end loop;
                
                
        tunnel <= "001";
        
        
        
        for i in 1 to 200 loop
                            wait for 5ns;
                            clock <= not clock;
                        end loop;

        
        tunnel <= "100";
        
        for i in 1 to 120 loop
            wait for 5ns;
            clock <= not clock;
        end loop;
        
        
        tunnel <= "001";


    for i in 1 to 200 loop
                            wait for 5ns;
                            clock <= not clock;
                    end loop;



--        -- 100ns start
--        clock <= not clock;
--        wait for 5ns;
--        clock <= not clock;
--        wait for 5ns;
--        clock <= not clock;
--        wait for 5ns;
--        clock <= not clock;
--        wait for 5ns;
--        clock <= not clock;
--        wait for 5ns;
--        clock <= not clock;
--        wait for 5ns;
--        clock <= not clock;
--        wait for 5ns;
--        clock <= not clock;
--        wait for 5ns;
--        clock <= not clock;
--        wait for 5ns;
--        clock <= not clock;
--        wait for 5ns;
--        clock <= not clock;
--        wait for 5ns;
--        clock <= not clock;
--        wait for 5ns;
--        clock <= not clock;
--        wait for 5ns;
--        clock <= not clock;
--        wait for 5ns;
--        clock <= not clock;
--        wait for 5ns;
--        clock <= not clock;
--        wait for 5ns;
--        clock <= not clock;
--        wait for 5ns;
--        clock <= not clock;
--        wait for 5ns;
--        clock <= not clock;
--        wait for 5ns;
--        clock <= not clock;
--        wait for 5ns;
--        -- 100ns end


       
        end process;


end Behavioral;

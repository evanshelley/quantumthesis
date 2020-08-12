@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xsim filter_tb_behav -key {Behavioral:sim_1:Functional:filter_tb} -tclbatch filter_tb.tcl -view C:/Users/Evan/Documents/Thesis/Vivado and Keysight/Vivado Project/lockin/filter_tb_behav1.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0

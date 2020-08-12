
################################################################
# This is a generated script based on design: lockin
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2017.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source lockin_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7k70tfbv676-1
}


# CHANGE DESIGN NAME HERE
set design_name lockin

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set clk [ create_bd_port -dir I -type clk clk ]
  set_property -dict [ list \
CONFIG.FREQ_HZ {100000000} \
 ] $clk
  set sq1 [ create_bd_port -dir O -from 95 -to 0 sq1 ]
  set sq2 [ create_bd_port -dir O -from 95 -to 0 sq2 ]
  set tunnel [ create_bd_port -dir I -from 2 -to 0 tunnel ]

  # Create instance: dds_compiler_0, and set properties
  set dds_compiler_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:dds_compiler:6.0 dds_compiler_0 ]
  set_property -dict [ list \
CONFIG.DATA_Has_TLAST {Not_Required} \
CONFIG.Has_Phase_Out {true} \
CONFIG.Latency {7} \
CONFIG.M_DATA_Has_TUSER {Not_Required} \
CONFIG.Noise_Shaping {None} \
CONFIG.Output_Frequency1 {0} \
CONFIG.Output_Width {14} \
CONFIG.PINC1 {1100110011010} \
CONFIG.Parameter_Entry {Hardware_Parameters} \
CONFIG.PartsPresent {Phase_Generator_and_SIN_COS_LUT} \
CONFIG.Phase_Increment {Fixed} \
CONFIG.Phase_Width {16} \
CONFIG.S_PHASE_Has_TUSER {Not_Required} \
 ] $dds_compiler_0

  # Create instance: dds_compiler_1, and set properties
  set dds_compiler_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:dds_compiler:6.0 dds_compiler_1 ]
  set_property -dict [ list \
CONFIG.DATA_Has_TLAST {Not_Required} \
CONFIG.Has_Phase_Out {true} \
CONFIG.Latency {4} \
CONFIG.M_DATA_Has_TUSER {Not_Required} \
CONFIG.Noise_Shaping {None} \
CONFIG.Output_Frequency1 {0} \
CONFIG.Output_Width {11} \
CONFIG.PINC1 {1100110011010} \
CONFIG.Parameter_Entry {Hardware_Parameters} \
CONFIG.PartsPresent {Phase_Generator_and_SIN_COS_LUT} \
CONFIG.Phase_Increment {Fixed} \
CONFIG.Phase_Width {16} \
CONFIG.S_PHASE_Has_TUSER {Not_Required} \
 ] $dds_compiler_1

  # Create instance: fir_compiler_0, and set properties
  set fir_compiler_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_compiler_0 ]
  set_property -dict [ list \
CONFIG.Clock_Frequency {100} \
CONFIG.CoefficientSource {COE_File} \
CONFIG.Coefficient_File {filtercoeff.coe} \
CONFIG.Coefficient_Fractional_Bits {18} \
CONFIG.Coefficient_Reload {false} \
CONFIG.Coefficient_Sets {1} \
CONFIG.Coefficient_Sign {Unsigned} \
CONFIG.Coefficient_Structure {Inferred} \
CONFIG.Coefficient_Width {16} \
CONFIG.ColumnConfig {5} \
CONFIG.Data_Fractional_Bits {0} \
CONFIG.Data_Sign {Signed} \
CONFIG.Data_Width {28} \
CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
CONFIG.Optimization_Goal {Speed} \
CONFIG.Optimization_List {Data_Path_Fanout,Pre-Adder_Pipeline,Coefficient_Fanout,Control_Path_Fanout,Control_Column_Fanout,Control_Broadcast_Fanout,Control_LUT_Pipeline,No_BRAM_Read_First_Mode,Optimal_Column_Lengths,Other} \
CONFIG.Optimization_Selection {All} \
CONFIG.Output_Rounding_Mode {Full_Precision} \
CONFIG.Output_Width {47} \
CONFIG.Quantization {Quantize_Only} \
CONFIG.RateSpecification {Frequency_Specification} \
CONFIG.SamplePeriod {1} \
CONFIG.Sample_Frequency {100} \
 ] $fir_compiler_0

  # Create instance: fir_compiler_1, and set properties
  set fir_compiler_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fir_compiler:7.2 fir_compiler_1 ]
  set_property -dict [ list \
CONFIG.Clock_Frequency {100} \
CONFIG.CoefficientSource {COE_File} \
CONFIG.Coefficient_File {filtercoeff.coe} \
CONFIG.Coefficient_Fractional_Bits {18} \
CONFIG.Coefficient_Sets {1} \
CONFIG.Coefficient_Sign {Unsigned} \
CONFIG.Coefficient_Structure {Inferred} \
CONFIG.Coefficient_Width {16} \
CONFIG.ColumnConfig {5} \
CONFIG.Data_Width {28} \
CONFIG.Filter_Architecture {Systolic_Multiply_Accumulate} \
CONFIG.Optimization_Goal {Speed} \
CONFIG.Optimization_List {Data_Path_Fanout,Pre-Adder_Pipeline,Coefficient_Fanout,Control_Path_Fanout,Control_Column_Fanout,Control_Broadcast_Fanout,Control_LUT_Pipeline,No_BRAM_Read_First_Mode,Optimal_Column_Lengths,Other} \
CONFIG.Optimization_Selection {All} \
CONFIG.Output_Rounding_Mode {Full_Precision} \
CONFIG.Output_Width {47} \
CONFIG.Quantization {Quantize_Only} \
CONFIG.Sample_Frequency {100} \
 ] $fir_compiler_1

  # Create instance: mult_gen_0, and set properties
  set mult_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_0 ]
  set_property -dict [ list \
CONFIG.MultType {Parallel_Multiplier} \
CONFIG.OptGoal {Speed} \
CONFIG.OutputWidthHigh {27} \
CONFIG.PortAWidth {14} \
CONFIG.PortBWidth {14} \
 ] $mult_gen_0

  # Create instance: mult_gen_1, and set properties
  set mult_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_1 ]
  set_property -dict [ list \
CONFIG.OutputWidthHigh {27} \
CONFIG.PortAWidth {14} \
CONFIG.PortBWidth {14} \
 ] $mult_gen_1

  # Create instance: mult_gen_2, and set properties
  set mult_gen_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_2 ]
  set_property -dict [ list \
CONFIG.OutputWidthHigh {95} \
CONFIG.PortAWidth {48} \
CONFIG.PortBWidth {48} \
 ] $mult_gen_2

  # Create instance: mult_gen_3, and set properties
  set mult_gen_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_3 ]
  set_property -dict [ list \
CONFIG.OutputWidthHigh {95} \
CONFIG.PortAWidth {48} \
CONFIG.PortBWidth {48} \
 ] $mult_gen_3

  # Create instance: mult_gen_4, and set properties
  set mult_gen_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_4 ]
  set_property -dict [ list \
CONFIG.OutputWidthHigh {13} \
CONFIG.PortAWidth {11} \
CONFIG.PortBWidth {3} \
 ] $mult_gen_4

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {28} \
CONFIG.IN1_WIDTH {4} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {28} \
CONFIG.IN1_WIDTH {4} \
 ] $xlconcat_1

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {29} \
CONFIG.DIN_TO {16} \
CONFIG.DOUT_WIDTH {14} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {13} \
CONFIG.DOUT_WIDTH {14} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {26} \
CONFIG.DIN_TO {16} \
CONFIG.DOUT_WIDTH {11} \
 ] $xlslice_2

  # Create port connections
  connect_bd_net -net clk_1 [get_bd_ports clk] [get_bd_pins dds_compiler_0/aclk] [get_bd_pins dds_compiler_1/aclk] [get_bd_pins fir_compiler_0/aclk] [get_bd_pins fir_compiler_1/aclk] [get_bd_pins mult_gen_0/CLK] [get_bd_pins mult_gen_1/CLK] [get_bd_pins mult_gen_2/CLK] [get_bd_pins mult_gen_3/CLK] [get_bd_pins mult_gen_4/CLK]
  connect_bd_net -net dds_compiler_0_m_axis_data_tdata [get_bd_pins dds_compiler_0/m_axis_data_tdata] [get_bd_pins xlslice_0/Din] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net dds_compiler_1_m_axis_data_tdata [get_bd_pins dds_compiler_1/m_axis_data_tdata] [get_bd_pins xlslice_2/Din]
  connect_bd_net -net fir_compiler_0_m_axis_data_tdata [get_bd_pins fir_compiler_0/m_axis_data_tdata] [get_bd_pins mult_gen_2/A] [get_bd_pins mult_gen_2/B]
  connect_bd_net -net fir_compiler_1_m_axis_data_tdata [get_bd_pins fir_compiler_1/m_axis_data_tdata] [get_bd_pins mult_gen_3/A] [get_bd_pins mult_gen_3/B]
  connect_bd_net -net mult_gen_0_P [get_bd_pins mult_gen_0/P] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net mult_gen_1_P [get_bd_pins mult_gen_1/P] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net mult_gen_2_P [get_bd_ports sq1] [get_bd_pins mult_gen_2/P]
  connect_bd_net -net mult_gen_3_P [get_bd_ports sq2] [get_bd_pins mult_gen_3/P]
  connect_bd_net -net mult_gen_4_P [get_bd_pins mult_gen_0/A] [get_bd_pins mult_gen_1/A] [get_bd_pins mult_gen_4/P]
  connect_bd_net -net tunnel_1 [get_bd_ports tunnel] [get_bd_pins mult_gen_4/B]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins fir_compiler_0/s_axis_data_tdata] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins fir_compiler_1/s_axis_data_tdata] [get_bd_pins xlconcat_1/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins fir_compiler_0/s_axis_data_tvalid] [get_bd_pins fir_compiler_1/s_axis_data_tvalid] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins mult_gen_0/B] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins mult_gen_1/B] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins mult_gen_4/A] [get_bd_pins xlslice_2/Dout]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""



# project.tcl
#
# Creates the Vivado project from sources. Hand-maintained: keep this to the
# bare minimum needed to recreate the project. The block design itself lives
# in tcl/bd.tcl and is always exported from Vivado, never hand-edited.
#
# Usage: vivado -mode batch -source tcl/project.tcl -tclargs <proj_dir>

set repo_root [file normalize [file join [file dirname [info script]] ..]]
set proj_name kr260
set proj_dir  [expr {[llength $argv] > 0 ? [lindex $argv 0] : "$repo_root/build/gui"}]

# TODO: confirm part / board part against the Vivado 2026.1.1 board store.
set part       xck26-sfvc784-2LV-c
set board_part xilinx.com:kr260_som:part0:1.1

create_project $proj_name $proj_dir -part $part
set_property board_part $board_part [current_project]
set_property target_language Verilog [current_project]

# --- Block design ---
# TODO: source $repo_root/tcl/bd.tcl and generate the BD wrapper.

# --- RTL ---
add_files -fileset sources_1 [glob $repo_root/rtl/top/*.sv]
set_property top kr260_top [get_filesets sources_1]

# --- Constraints (unmanaged Tcl) ---
add_files -fileset constrs_1 [list \
    $repo_root/syn/io_ports.tcl \
    $repo_root/syn/timing.tcl \
]

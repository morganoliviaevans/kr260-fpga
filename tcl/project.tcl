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
set part      xck26-sfvc784-2LV-c

create_project $proj_name $proj_dir -part $part
set_property target_language Verilog [current_project]

# --- Block design ---
# bd.tcl bails out with a bare `return` on a Vivado version mismatch, so check
# that the BD actually got created.
source $repo_root/tcl/bd.tcl
if {[get_files -quiet kr260.bd] eq ""} {
    error "tcl/bd.tcl did not create the kr260 block design (Vivado version mismatch?)"
}

# --- RTL ---
add_files -fileset sources_1 [glob $repo_root/rtl/*.sv]
set_property top kr260_top [get_filesets sources_1]

# --- Constraints ---
# Order matters: each decode layer uses variables set by the one before it.
add_files -fileset constrs_1 [list \
    $repo_root/syn/k26_fpga.xdc \
    $repo_root/syn/k26_som.xdc \
    $repo_root/syn/kr260_carrier.xdc \
    $repo_root/syn/io_ports.tcl \
    $repo_root/syn/timing.tcl \
]

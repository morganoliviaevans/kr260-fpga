# build.tcl
#
# Headless build: recreate the project from scratch, run through bitstream,
# then copy build products and reports into out/ for check-in.
#
# Usage: vivado -mode batch -source tcl/build.tcl

set repo_root [file normalize [file join [file dirname [info script]] ..]]
set proj_dir  $repo_root/build/batch
set out_dir   $repo_root/out
set jobs      [expr {[info exists ::env(JOBS)] ? $::env(JOBS) : 8}]

file delete -force $proj_dir
set argv [list $proj_dir]
source $repo_root/tcl/project.tcl

launch_runs impl_1 -to_step write_bitstream -jobs $jobs
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} {
    error "impl_1 did not complete"
}

set synth_dir [get_property DIRECTORY [get_runs synth_1]]
set impl_dir  [get_property DIRECTORY [get_runs impl_1]]
set top       [get_property top [current_fileset]]

# --- Reports and run logs (replaced wholesale each build) ---
# vivado.log only points at the run logs, so grab each runme.log directly.
# The Makefile copies vivado.log itself once Vivado exits.
file delete -force $out_dir/reports $out_dir/logs
file mkdir $out_dir/reports $out_dir/logs
foreach rpt [glob -nocomplain $synth_dir/*.rpt $impl_dir/*.rpt] {
    file copy $rpt $out_dir/reports/
}
file copy $synth_dir/runme.log $out_dir/logs/synth_1.log
file copy $impl_dir/runme.log  $out_dir/logs/impl_1.log

# --- Build products ---
file delete -force {*}[glob -nocomplain $out_dir/kr260.*]
file copy $impl_dir/$top.bit $out_dir/kr260.bit
if {[file exists $impl_dir/$top.ltx]} {
    file copy $impl_dir/$top.ltx $out_dir/kr260.ltx
}
write_hw_platform -fixed -include_bit -force $out_dir/kr260.xsa

# .bit.bin for loading from Linux on the PS (fpgautil / xmutil).
set bif $proj_dir/kr260.bif
set fh [open $bif w]
puts $fh "all: { $out_dir/kr260.bit }"
close $fh
exec $::env(XILINX_VIVADO)/bin/bootgen -arch zynqmp -image $bif -process_bitstream bin -w

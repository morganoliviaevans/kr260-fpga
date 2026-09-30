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

# TODO: pin down exactly which products the target needs (.bit / .bin / .xsa)
# and which reports are worth committing.
file mkdir $out_dir/reports
open_run impl_1
report_timing_summary -file $out_dir/reports/timing_summary.rpt
report_utilization    -file $out_dir/reports/utilization.rpt
write_hw_platform -fixed -include_bit -force $out_dir/kr260.xsa
file copy -force [glob $proj_dir/*.runs/impl_1/*.bit] $out_dir/kr260.bit

# helpers.tcl
#
# Convenience procs for the Vivado Tcl console. Sourced automatically by
# `make gui`; to load by hand: source <repo>/tcl/helpers.tcl

set ::kr260_repo_root [file normalize [file join [file dirname [info script]] ..]]

# Validate the open block design and export it to tcl/bd.tcl.
proc dump_bd {} {
    if {[current_bd_design -quiet] eq ""} {
        error "dump_bd: no block design is open"
    }
    set bd_tcl $::kr260_repo_root/tcl/bd.tcl
    validate_bd_design -force
    write_bd_tcl -force $bd_tcl
    puts "dump_bd: wrote $bd_tcl"
}

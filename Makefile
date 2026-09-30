VIVADO ?= vivado
GUI_XPR := build/gui/kr260.xpr

.PHONY: project gui build clean

# Create the GUI project (only if it doesn't already exist).
project: $(GUI_XPR)

$(GUI_XPR):
	mkdir -p build
	cd build && $(VIVADO) -mode batch -source ../tcl/project.tcl

# Open the GUI project, creating it first if needed.
gui: $(GUI_XPR)
	cd build && $(VIVADO) -mode gui -source ../tcl/helpers.tcl gui/kr260.xpr &

# Full headless build from a clean project; products land in out/.
build:
	mkdir -p build
	cd build && $(VIVADO) -mode batch -source ../tcl/build.tcl

clean:
	git clean -fXd

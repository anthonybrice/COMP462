#
# Defines the part type that this project uses.
#
PART=__MSP432P401R__

#
# The base directory for MSPWare.
#
ROOT=.
DLIB_ROOT=./driver/driverlib/MSP432P4xx

#
# Include the common make definitions.
#
include Makefile.defs

#
# Where to find header files that do not live in the source directory.
#
IPATH=.
IPATH+=./driver/inc/
IPATH+=${DLIB_ROOT}
IPATH+=./driver/inc/CMSIS
#
# The default rule, which causes the adc14_multiple_channel_no_repeat example to be built.
#
all: ${COMPILER}
all: ${COMPILER}/lab1.axf

#
# The rule to clean out all the build products.
#
clean:
	@rm -rf ${COMPILER} ${wildcard *~}

#
# The rule to create the target directory.
#
${COMPILER}:
	@mkdir -p ${COMPILER}

#
# Rules for building the lab1.
#
${COMPILER}/lab1.axf: ${COMPILER}/msp432_startup_${COMPILER}.o
${COMPILER}/lab1.axf: ${COMPILER}/lab1.o
${COMPILER}/lab1.axf: ${ROOT}/driver/driverlib/MSP432P4xx/${COMPILER}/msp432p4xx_driverlib.a
${COMPILER}/lab1.axf: lab1_gcc.ld
SCATTERgcc_lab1=lab1_gcc.ld
#${COMPILER}/lab1.axf: msp432p401r.cmd
#SCATTERgcc_lab1=msp432p401r.cmd
ENTRY_lab1=ResetISR
CFLAGSgcc=-DTARGET_IS_MSP432P4XX



#
# Include the automatically generated dependency files.
#
ifneq (${MAKECMDGOALS},clean)
-include ${wildcard ${COMPILER}/*.d} __dummy__
endif

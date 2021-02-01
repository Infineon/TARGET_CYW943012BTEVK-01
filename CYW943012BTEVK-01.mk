#
# Copyright 2016-2021, Cypress Semiconductor Corporation (an Infineon company) or
# an affiliate of Cypress Semiconductor Corporation.  All rights reserved.
#
# This software, including source code, documentation and related
# materials ("Software") is owned by Cypress Semiconductor Corporation
# or one of its affiliates ("Cypress") and is protected by and subject to
# worldwide patent protection (United States and foreign),
# United States copyright laws and international treaty provisions.
# Therefore, you may use this Software only as provided in the license
# agreement accompanying the software package from which you
# obtained this Software ("EULA").
# If no EULA applies, Cypress hereby grants you a personal, non-exclusive,
# non-transferable license to copy, modify, and compile the Software
# source code solely for use in connection with Cypress's
# integrated circuit products.  Any reproduction, modification, translation,
# compilation, or representation of this Software except as specified
# above is prohibited without the express written permission of Cypress.
#
# Disclaimer: THIS SOFTWARE IS PROVIDED AS-IS, WITH NO WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, NONINFRINGEMENT, IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. Cypress
# reserves the right to make changes to the Software without notice. Cypress
# does not assume any liability arising out of the application or use of the
# Software or any product or circuit described in the Software. Cypress does
# not authorize its products for use in any products where a malfunction or
# failure of the Cypress product may reasonably be expected to result in
# significant property damage, injury or death ("High Risk Product"). By
# including Cypress's product in a High Risk Product, the manufacturer
# of such system or application assumes all risk of such use and in doing
# so agrees to indemnify Cypress against all liability.
#

ifeq ($(WHICHFILE),true)
$(info Processing $(lastword $(MAKEFILE_LIST)))
endif

#
# Device definition
#
DEVICE=CYW43012C0WKWBG
CHIP=43012
CHIP_REV=C0
BLD=A

# CSP baselib and BSP path variables
CY_TARGET_DEVICE?=$(CHIP)$(CHIP_REV)
CY_APP_PATCH_LIBS+=$(CY_$(CY_TARGET_DEVICE)_APP_PATCH_LIBS)
COMPONENTS+=$(CY_TARGET_DEVICE) $(COMPONENTS_$(CY_TARGET_DEVICE))
ifeq ($(SEARCH_$(CY_TARGET_DEVICE)),)
# internal only - app deploys will always initialize this in mtb.mk
SEARCH_$(CY_TARGET_DEVICE)?=$(IN_REPO_BTSDK_ROOT)/wiced_btsdk/dev-kit/baselib/$(CY_TARGET_DEVICE)
SEARCH+=$(SEARCH_$(CY_TARGET_DEVICE))
endif
CY_BSP_PATH?=$(SEARCH_TARGET_$(TARGET))
CY_BASELIB_PATH?=$(SEARCH_$(CY_TARGET_DEVICE))/COMPONENT_$(CY_TARGET_DEVICE)
CY_BASELIB_CORE_PATH?=$(SEARCH_core-make)
CY_INTERNAL_BASELIB_PATH?=$(patsubst %/,%,$(CY_BASELIB_PATH))
override CY_DEVICESUPPORT_SEARCH_PATH:=$(call CY_MACRO_SEARCH,devicesupport.xml,$(CY_INTERNAL_BASELIB_PATH))

#
# Define the features for this target
#

# No FLASH on this board
# Begin address of flash0, off-chip sflash
#CY_FLASH0_BEGIN_ADDR=0xFF000000
# Available flash = 4 Mb, 512k x 8
#CY_FLASH0_LENGTH=0x00080000

# Entry-point symbol for application
CY_CORE_APP_ENTRY:=spar_crt_setup

# this is a platform value, need to determine underlying logic to calculate a safe value
PLATFORM_DIRECT_LOAD_BASE_ADDR = 0x230000
#
# TARGET UART parameters
#
# Max. supported baudrate by this platform
CY_CORE_DEFINES+=-DHCI_UART_MAX_BAUD=3000000
# default baud rate is 3M, that is the max supported on macOS
CY_CORE_DEFINES+=-DHCI_UART_DEFAULT_BAUD=3000000
# this platform does not expose PUART
CY_CORE_DEFINES+=-DNO_PUART_SUPPORT
ifneq ($(KITPROG3_USE_1_STOP_BIT),1)
# need to set 2 stop bits for KitProg3 at 3M baud rate
CY_CORE_DEFINES+=-DKITPROG3_USE_2_STOP_BITS
endif
# this platform need switch PTU_FIFO between SPI and UART
CY_CORE_DEFINES+=-DSWITCH_PTU_CHECK

#
# TARGET swd interface setup
#
# TBD for this board
ifeq ($(ENABLE_DEBUG),1)
CY_CORE_DEFINES+=-DSWD_CLK=SWDCK_ON_P8
CY_CORE_DEFINES+=-DSWD_IO=SWDIO_ON_P6
endif

#
# Patch variables
#
CY_CORE_PATCH=$(CY_INTERNAL_BASELIB_PATH)/internal/43012C0/patches/wlcsp_sLNA_CYW943012M2BT1LV/patch.elf
CY_CORE_CGSLIST=$(CY_INTERNAL_BASELIB_PATH)/internal/43012C0/patches/wlcsp_sLNA_CYW943012M2BT1LV/patch.cgs
CY_CORE_PATCH_CFLAGS=$(CY_INTERNAL_BASELIB_PATH)/internal/43012C0/gcc/43012C0.cflag
CY_CORE_PATCH_LIB_PATH=libraries/prebuilt

#
# Variables for pre-build and post-build processing
#
CY_CORE_HDF=$(CY_INTERNAL_BASELIB_PATH)/internal/43012C0/configdef43012C0.hdf
CY_CORE_HCI_ID=$(CY_INTERNAL_BASELIB_PATH)/platforms/IDFILE.txt
CY_CORE_BTP=$(CY_BSP_PATH)/$(TARGET).btp
CY_CORE_CGSLIST+=$(CY_BSP_PATH)/$(TARGET).cgs

CY_CORE_MINIDRIVER=$(CY_BSP_PATH)/uart.hex

CY_CORE_LD_DEFS+=\
	SRAM_BEGIN_ADDR=0x00200000 \
	SRAM_LENGTH=0x00051000 \
	ISTATIC_BEGIN=0xFF000C00 \
	ISTATIC_LEN=1024 \
	IRAM_BEGIN=0x0021D858 \
	IRAM_LEN=0x000334A8 \
	IAON_BEGIN=0x00000000 \
	IAON_LEN=0x00208298 \
	NUM_PATCH_ENTRIES=192
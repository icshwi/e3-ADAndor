#
#  Copyright (c) 2017 - Present  European Spallation Source ERIC
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
#
# Author  : Jeong Han Lee
# email   : jeonghan.lee@gmail.com
# Date    : Thursday, May 17 17:36:32 CEST 2018
# version : 0.0.1


where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

include $(E3_REQUIRE_TOOLS)/driver.makefile

ifneq ($(strip $(ASYN_DEP_VERSION)),)
asyn_VERSION=$(ASYN_DEP_VERSION)
endif

ifneq ($(strip $(ADCORE_DEP_VERSION)),)
ADCore_VERSION=$(ADCORE_DEP_VERSION)
endif


# Exclude linux-ppc64e6500
EXCLUDE_ARCHS = linux-ppc64e6500


# *** ISSUES
# driver.makefile recursively read all include directories which were installed.
# The only way to exclude header files is....



iocStats_VERSION=
autosave_VERSION=
#asyn_VERSION=
busy_VERSION=
modbus_VERSION=
ipmiComm_VERSION=
sequencer_VERSION=
sscan_VERSION=

std_VERSION=
ip_VERSION=
calc_VERSION=
pcre_VERSION=
stream_VERSION=
s7plc_VERSION=
recsync_VERSION=

devlib2_VERSION=
mrfioc2_VERSION=

exprtk_VERSION=
motor_VERSION=
ecmc_VERSION=
EthercatMC_VERSION=
ecmctraining_VERSION=


keypress_VERSION=
sysfs_VERSION=
symbolname_VERSION=
memDisplay_VERSION=
regdev_VERSION=
i2cDev_VERSION=

tosca_VERSION=
tsclib_VERSION=
ifcdaqdrv2_VERSION=

## The main issue is nds3, it is mandatory to disable it
## 
nds3_VERSION=
nds3epics_VERSION=
ifc14edrv_VERSION=
ifcfastint_VERSION=


nds_VERSION=
loki_VERSION=
nds_VERSION=
sis8300drv_VERSION=
sis8300_VERSION=
sis8300llrfdrv_VERSION=
sis8300llrf_VERSION=


ADSupport_VERSION=
#ADCore_VERSION=
ADSimDetector_VERSION=
#ADAndor_VERSION=
ADAndor3_VERSION=
ADPointGrey_VERSION=
ADProsilica_VERSION=

amcpico8_VERSION=
adpico8_VERSION=
adsis8300_VERSION=
adsis8300bcm_VERSION=
adsis8300bpm_VERSION=
adsis8300fc_VERSION=




SUPPORT:=andorSupport

APP:=andorApp
APPDB:=$(APP)/Db
APPSRC:=$(APP)/src


## We will use XML2 as the system lib, instead of ADSupport
## Do we need to load libxml2 when we start iocsh?

USR_INCLUDES += -I/usr/include/libxml2
LIB_SYS_LIBS += xml2	



HEADERS += $(SUPPORT)/ATMCD32D.h
HEADERS += $(SUPPORT)/atmcdLXd.h
HEADERS += $(SUPPORT)/ShamrockCIF.h

DBDS += $(APPSRC)/andorCCDSupport.dbd
DBDS += $(APPSRC)/shamrockSupport.dbd


SOURCES += $(APPSRC)/andorCCD.cpp
SOURCES += $(APPSRC)/shamrockDummy.cpp


ifeq ($(T_A),linux-x86_64)
USR_LDFLAGS += -Wl,--enable-new-dtags
USR_LDFLAGS += -Wl,-rpath=$(E3_MODULES_VENDOR_LIBS_LOCATION)
USR_LDFLAGS += -L$(E3_MODULES_VENDOR_LIBS_LOCATION)
USR_LDFLAGS += -landor
USR_LDFLAGS += -lshamrockcif

endif


VENDOR_LIBS += $(SUPPORT)/os/linux-x86_64/libandor-x86_64.so.2.102.30034.0
VENDOR_LIBS += $(SUPPORT)/os/linux-x86_64/libandor.so.2
VENDOR_LIBS += $(SUPPORT)/os/linux-x86_64/libandor.so
VENDOR_LIBS += $(SUPPORT)/os/linux-x86_64/libshamrockcif-x86_64.so.2.102.30034.0
VENDOR_LIBS += $(SUPPORT)/os/linux-x86_64/libshamrockcif.so.2
VENDOR_LIBS += $(SUPPORT)/os/linux-x86_64/libshamrockcif.so
#VENDOR_LIBS += $(SUPPORT)/os/linux-x86_64/libUSBI2C.so
#VENDOR_LIBS += $(SUPPORT)/os/linux-x86_64/libUSBI2C.so.2
#VENDOR_LIBS += $(SUPPORT)/os/linux-x86_64/libUSBI2C-x86_64.so.2.102.30034.0


# We have to convert all to db 
TEMPLATES += $(wildcard $(APPDB)/*.db)

# TEMPLATES += $(APPDB)/andorCCD.template
# TEMPLATES += $(APPDB)/shamrock.template




## This RULE should be used in case of inflating DB files 
## db rule is the default in RULES_DB, so add the empty one
## Please look at e3-mrfioc2 for example.

USR_DBFLAGS += -I . -I ..
USR_DBFLAGS += -I $(EPICS_BASE)/db
USR_DBFLAGS += -I $(APPDB)

# 
#
USR_DBFLAGS += -I $(E3_SITELIBS_PATH)/ADCore_$(ADCORE_DEP_VERSION)_db

SUBS=$(wildcard $(APPDB)/*.substitutions)
TMPS=$(wildcard $(APPDB)/*.template)

db: $(SUBS) $(TMPS)

$(SUBS):
	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
	@rm -f  $(basename $(@)).db.d  $(basename $(@)).db
	@$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db -S $@  > $(basename $(@)).db.d
	@$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db -S $@

$(TMPS):
	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
	@rm -f  $(basename $(@)).db.d  $(basename $(@)).db
	@$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db $@  > $(basename $(@)).db.d
	@$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db $@


.PHONY: db $(SUBS) $(TMPS)



# Overwrite
# RULES_VLIBS
# CONFIG_E3

vlibs: $(VENDOR_LIBS)

$(VENDOR_LIBS):
	@$(SUDO) install -m 755 -d $(E3_MODULES_VENDOR_LIBS_LOCATION)/
	@$(SUDO) install -m 644 $@ $(E3_MODULES_VENDOR_LIBS_LOCATION)/

.PHONY: $(VENDOR_LIBS) vlibs


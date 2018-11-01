# 
# Makefile for building Subutai Base Templates
#

# Settings
ZPOOL=subutai
ZFS_BUILD=build
VERSION=0.4.0
OWNER=lbthomsen

# 
# Derrived settings
#
BUILD=/$(ZPOOL)/$(ZFS_BUILD)

$(BUILD): /$(ZPOOL)
	@sudo zfs create $(ZPOOL)/$(ZFS_BUILD)

/$(ZPOOL):
	@echo "The zpool $(ZPOOL) does not exit" ; exit 1

clean: 
	@sudo zfs destroy $(ZPOOL)/$(ZFS_BUILD)

.PHONY: all clean
# vim: ts=8 nowrap autoindent

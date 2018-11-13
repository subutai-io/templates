# 
# Makefile for building Subutai Base Templates
#

# 
# Derrived settings
#
BUILD=/$(ZPOOL)/$(ZFS_BUILD)
OS=$(BUILD)/$(NAME)
ROOTFS=$(BUILD)/$(NAME)/rootfs
VARFS=$(BUILD)/$(NAME)/$(ROOTFS)/var
OPTFS=$(BUILD)/$(NAME)/$(ROOTFS)/opt
HOMEFS=$(BUILD)/$(NAME)/$(ROOTFS)/home

all: | $(ROOTFS)/etc/

$(ROOTFS)/etc/:  $(HOMEFS)/ $(OPTFS)/ $(VARFS)/
	@sudo debootstrap $(BASE) /${ROOTFS}

$(HOMEFS)/: $(ROOTFS)/
	@sudo zfs create $(ZPOOL)/$(ZFS_BUILD)/$(NAME)/rootfs/home

$(OPTFS)/: | $(ROOTFS)/
	@sudo zfs create $(ZPOOL)/$(ZFS_BUILD)/$(NAME)/rootfs/opt

$(VARFS)/: | $(ROOTFS)/
	@sudo zfs create $(ZPOOL)/$(ZFS_BUILD)/$(NAME)/rootfs/var

$(ROOTFS)/: | $(OS)/
	@sudo zfs create $(ZPOOL)/$(ZFS_BUILD)/$(NAME)/rootfs

$(OS)/: | $(BUILD)/
	@sudo zfs create $(ZPOOL)/$(ZFS_BUILD)/$(NAME)

$(BUILD)/: /$(ZPOOL)/
	@sudo zfs create $(ZPOOL)/$(ZFS_BUILD)

/$(ZPOOL)/:
	@echo "The zpool $(ZPOOL) does not exit" ; exit 1

clean: 
	@sudo bash -c '[ -d "$(BUILD)" ] && zfs destroy -r $(ZPOOL)/$(ZFS_BUILD) || true'

.PHONY: all clean
# vim: ts=8 nowrap autoindent

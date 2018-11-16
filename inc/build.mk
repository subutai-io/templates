# 
# Makefile for building Subutai Base Templates
#

# 
# Derrived settings
#
BUILD=/$(ZPOOL)/$(ZFS_BUILD)
OS=$(BUILD)/$(NAME)
ROOTFS=$(BUILD)/$(NAME)/rootfs
VARFS=$(ROOTFS)/var
OPTFS=$(ROOTFS)/opt
HOMEFS=$(ROOTFS)/home
CACHE=/var/tmp/debootstrap

all: $(ROOTFS)/etc

$(ROOTFS)/etc: $(HOMEFS) $(OPTFS) $(VARFS) $(CACHE)
	@sudo debootstrap --cache-dir=$(CACHE) --include=$(EXTRA) $(BASE) /$(ROOTFS) $(REP)

$(HOMEFS): $(ROOTFS)
	@echo "Checking $(HOMEFS)"
	@sudo bash -c '[ -d "$(HOMEFS)" ] || zfs create $(ZPOOL)/$(ZFS_BUILD)/$(NAME)/rootfs/home || true'

$(OPTFS): $(ROOTFS)
	@echo "Checking $(OPTFS)"
	@sudo bash -c '[ -d "$(OPTFS)" ] || zfs create $(ZPOOL)/$(ZFS_BUILD)/$(NAME)/rootfs/opt || true'

$(VARFS): $(ROOTFS)
	@echo "Checking $(VARFS)"
	@sudo bash -c '[ -d "$(VARFS)" ] || zfs create $(ZPOOL)/$(ZFS_BUILD)/$(NAME)/rootfs/var || true'

$(ROOTFS): $(OS)
	@echo "Checking $(ROOTFS)"
	@sudo bash -c '[ -d "$(ROOTFS)" ] || zfs create $(ZPOOL)/$(ZFS_BUILD)/$(NAME)/rootfs || true'

$(OS): $(BUILD)
	@sudo bash -c '[ -d "$(OS)" ] || zfs create $(ZPOOL)/$(ZFS_BUILD)/$(NAME) || true'

$(BUILD): /$(ZPOOL)
	@sudo bash -c '[ -d "$(BUILD)" ] || zfs create $(ZPOOL)/$(ZFS_BUILD) || true'

/$(ZPOOL):
	@echo "The zpool $(ZPOOL) does not exit" ; exit 1

$(CACHE): 
	@sudo bash -c '[ -d "$(CACHE)" ] || mkdir $(CACHE)'

clean: 
	@sudo bash -c '[ -d "$(BUILD)" ] && zfs destroy -r $(ZPOOL)/$(ZFS_BUILD) || true'

.PHONY: all clean
# vim: ts=8 nowrap autoindent

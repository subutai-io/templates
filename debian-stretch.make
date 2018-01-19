# Creates debian-stretch subutai template

BTRFS=/var/snap/subutai-master/common/lxc
BUILD=$(BTRFS)/bld

all: $(BUILD)

$(BUILD): sudo btrfs
	@sudo btrfs subvolume create $(BUILD)

btrfs: 
	@[ -d $(BTRFS) ]

sudo:
	@sudo -v

clean: sudo btrfs
	@sudo btrfs subvolume delete $(BUILD)

.PHONY: all sudo btrfs clean

# vim: ts=8 nowrap autoindent

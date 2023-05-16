.PHONY: clean download

clean:
	umount out/mnt; rm -rf out
	./scripts/clear_diskutil.sh

install_darwin:
	brew bundle

kill_qemu:
	-killall qemu-system-aarch64

start_qemu: kill_qemu
	OBJC_DISABLE_INITIALIZE_FORK_SAFETY=yes ./scripts/raspios_qemu.sh ${IMG_FILE} true

setup_raspios_img: kill_qemu
	OBJC_DISABLE_INITIALIZE_FORK_SAFETY=yes ./scripts/setup_raspios_image.sh

download: clean
	./scripts/download_mount_raspios.sh 

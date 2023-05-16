.PHONY: clean download

clean:
	umount out/mnt; rm -rf out

setup_raspios_img: 
	./scripts/setup_raspios_image.sh ${FILE}

download: clean
	./scripts/download_raspios.sh 

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

define Device/Default
	PROFILES := Default
	KERNEL_LOADADDR := 0x41000000
	SOC := ipq5018
	DEVICE_DTS = $$(SOC)-$(lastword $(subst _, ,$(1)))
	DEVICE_DTS_CONFIG := config@1
	DEVICE_DTS_DIR := $(DTS_DIR)/qcom
	IMAGES := sysupgrade.bin
	IMAGE/sysupgrade.bin = sysupgrade-tar | append-metadata
	IMAGE/sysupgrade.bin/squashfs :=
endef

define Device/FitImage
  KERNEL_SUFFIX := -fit-uImage.itb
  KERNEL_NAME := Image
  KERNEL = kernel-bin | gzip | fit gzip $$(KDIR)/image-$$(DEVICE_DTS).dtb
  KERNEL_INITRAMFS = kernel-bin | gzip | fit gzip $$(KDIR)/image-$$(DEVICE_DTS).dtb
endef

define Device/FitImageLzma
	KERNEL_SUFFIX := -uImage.itb
	KERNEL = kernel-bin | lzma | fit lzma $$(KDIR)/image-$$(DEVICE_DTS).dtb
	KERNEL_NAME := Image
endef

define Device/FitImageLzmaQca
	KERNEL_SUFFIX := -uImage.itb
	KERNEL_NAME := Image
  	KERNEL = kernel-bin | gzip | fit gzip $$(KDIR)/image-$$(DEVICE_DTS).dtb
  	KERNEL_INITRAMFS = kernel-bin | gzip | fit gzip $$(KDIR)/image-$$(DEVICE_DTS).dtb
endef

define Device/EmmcImage
	IMAGES += factory.bin
	IMAGE/factory.bin := append-rootfs | pad-rootfs | pad-to 64k
	IMAGE/sysupgrade.bin/squashfs := append-rootfs | pad-to 64k | sysupgrade-tar rootfs=$$$$@ | append-metadata
endef

define Device/UbiFit
	KERNEL_IN_UBI := 1
	FILESYSTEMS := squashfs ubifs ubi
	ROOTFSNAME_IN_UBI := ubi_rootfs
  	KERNEL_NAME := Image
  	IMAGES := sysupgrade.tar nand-factory.img factory.ubi
  	IMAGE/sysupgrade.tar := sysupgrade-tar | append-metadata | append-gl-metadata
  	IMAGE/nand-factory.img := append-ubi | qsdk-ipq-factory-nand | append-metadata
	IMAGE/factory.ubi := append-ubi
endef

include $(SUBTARGET).mk

$(eval $(call BuildImage))

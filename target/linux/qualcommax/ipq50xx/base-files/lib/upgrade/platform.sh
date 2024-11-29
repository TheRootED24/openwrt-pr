PART_NAME=firmware
REQUIRE_IMAGE_METADATA=1

RAMFS_COPY_BIN='fw_printenv fw_setenv head'
RAMFS_COPY_DATA='/etc/fw_env.config /var/lock/fw_printenv.lock'

platform_check_image() {
	return 0;
}

platform_do_upgrade() {
	case "$(board_name)" in
	linksys,mx2000|\
	linksys,mx5500)
		boot_part="$(fw_printenv -n boot_part)"
		if [ "$boot_part" -eq "1" ]; then
		fw_setenv boot_part 2
			CI_KERNPART="alt_kernel"
			CI_UBIPART="alt_rootfs"
		else
			fw_setenv boot_part 1
			CI_UBIPART="rootfs"
		fi
		fw_setenv boot_part_ready 3
		fw_setenv auto_recovery yes
		nand_do_upgrade "$1"
		;;
	glinet,gl-b3000)
		REQUIRE_IMAGE_METADATA=0
		CI_UBIPART="rootfs"
		[ "$(find_mtd_chardev rootfs)" ] && CI_UBIPART="rootfs"
		nand_do_upgrade "$1"
       		;;
	*)
		default_do_upgrade "$1"
		;;
	esac
}

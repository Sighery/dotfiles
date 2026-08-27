{ lib, pkgs, ... }:

{
  # Disk configuration inspired by:
  # https://prince213.top/blog/2025/01/21/nixos-rpi/
  # https://www.eisfunke.com/posts/2023/uefi-boot-on-raspberry-pi-3.html
  disko.devices.disk.main = {
    device = lib.mkDefault "/dev/mmcblk0";
    type = "disk";

    content = {
      type = "gpt";

      efiGptPartitionFirst = false;

      partitions = {
        ESP = {
          priority = 1;
          size = "1G";
          type = "EF00";

          hybrid = {
            mbrPartitionType = "0x0c";
          };

          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };

        };

        root = {
          size = "100%";

          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };
}

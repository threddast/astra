{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.impermanence;
in {
  options.modules.hardware.impermanence = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {

    home-manager.users.${config.user.name} = {
      imports = [
        inputs.impermanence.nixosModules.home-manager.impermanence
      ];
      home.persistence."/persist/home/${config.user.name}" = mkAliasDefinitions options.home.persist;
    };

    boot.initrd.supportedFilesystems = [ "btrfs" ];

    fileSystems = {
      "/" = {
        device = "none";
        fsType = "tmpfs";
      };
      "/boot" = {
        device = "/dev/disk/by-label/boot";
        fsType = "vfat";
      };
      "/nix" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "btrfs";
        options = ["subvol=nix" "noatime" "compress=zstd"];
      };
      "/persist" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "btrfs";
        options = ["subvol=persist" "compress=zstd"];
        neededForBoot = true;
      };
      "/swap" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "btrfs";
        options = ["subvol=swap" "noatime"];
      };
    };

    swapDevices = [{
      device = "/swap/swapfile";
      size = 16000;
    }];

    user.packages = with pkgs; [
      btrfs-progs
    ];
  };
}

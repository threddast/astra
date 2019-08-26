# Common configuration across systems. This should be required by
# configuration.$HOSTNAME.nix files.

{ config, pkgs, options, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    <home-manager/nixos>
    /etc/nixos/hardware-configuration.nix
  ];

  nix.nixPath = options.nix.nixPath.default ++ [
    "config=/etc/dotfiles/config"
  ];

  # Nothing in /tmp should survive a reboot
  boot.cleanTmpDir = true;
  # Use simple bootloader; I prefer the on-demand BIOs boot menu
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = with pkgs; [
      # Just the bear necessities~
      coreutils
      git
      wget
      vim
      unzip
      bc
      # Support for extra filesystems
      bashmount  # convenient mounting
      sshfs
      exfat
      ntfs3g
      hfsprogs
    ];
    variables = {
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_BIN_HOME = "$HOME/.local/bin";
    };
    shellAliases = {
      ne = "nix-env";
      nu = "sudo nix-channel --update && sudo nixos-rebuild -I config=$HOME/.dotfiles/config switch";
      nre = "sudo nixos-rebuild -I config=$HOME/.dotfiles/config";
      ngc = "nix-collect-garbage -d && sudo nix-collect-garbage -d";
    };
  };

  time.timeZone = "America/Toronto";
  # time.timeZone = "Europe/Copenhagen";

  # Set up hlissner user account
  nix.trustedUsers = [ "root" "@wheel" ];
  users.users.hlissner = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "video" "networkmanager" ];
    shell = pkgs.zsh;
  };

  home-manager.users.hlissner = {
    xdg.enable = true;
    home.file."bin" = { source = ./bin; recursive = true; };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?
}
# Ao -- my home development and user-facing server

{ config, lib, pkgs, ... }:

with lib.my;
{
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];


  ## Modules
  modules = {
    services = {
      fail2ban.enable = true;
      ssh.enable = true;
    };

  };

  ## Local config
  time.timeZone = "Europe/Zurich";
  networking.networkmanager.enable = true;


}

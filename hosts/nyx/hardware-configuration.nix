{ config, lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd.availableKernelModules = [ "ohci_pci" "ehci_pci" "ahci" "firewire_ohci" "usb_storage" "usbhid" "sd_mod" "sr_mod" "sdhci_pci" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" "wl" ];
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  };

  ## Modules
  modules.hardware.impermanence.enable = true;

  ## CPU
  nix.settings.max-jobs = lib.mkDefault 2;
  powerManagement.cpuFreqGovernor = "ondemand";
  hardware.cpu.intel.updateMicrocode = true;

  ## Networking
  networking.interfaces.enp0s10.useDHCP = true;

}

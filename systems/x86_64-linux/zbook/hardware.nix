{ pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    blacklistedKernelModules = [ "eeepc_wmi" ];

    kernelPackages = pkgs.linuxPackages_latest;
    kernel.sysctl."kernel.sysrq" = 1;

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usb_storage"
        "uas"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
    };
  };

  hardware = {
    display = {
      outputs = {
        "eDP-1" = {
          mode = "1920x1080@60";
        };
        "DP-7" = {
          mode = "1920x1080@60";
        };
        "DP-8" = {
          mode = "1680x1050@60";
        };
        "DP-9" = {
          mode = "1920x1080@60";
        };
      };
    };
    enableRedistributableFirmware = true;
  };
}

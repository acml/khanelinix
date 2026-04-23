{
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    blacklistedKernelModules = [ "eeepc_wmi" ];

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usb_storage"
        "uas"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];

      # Early loading in initramfs
      kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];
    };

    # Required for NVENC device nodes
    kernelModules = [ "nvidia_uvm" ];

    # Alternative: use boot.kernelParams
    kernelParams = [
      "nvidia_drm.modeset=1"
      "nvidia_drm.fbdev=1" # For framebuffer support
    ];
  };

  hardware = {
    enableRedistributableFirmware = true;
  };
}

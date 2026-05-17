{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    blacklistedKernelModules = [ "eeepc_wmi" ];

    kernelPackages = pkgs.linuxPackages_latest;

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

    kernelParams = [
      "nvidia_drm.modeset=1"
      "nvidia_drm.fbdev=1" # For framebuffer support
    ];
  };

  hardware = {
    enableRedistributableFirmware = true;

    # Enable OpenGL
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia = {

      # forceFullCompositionPipeline = true;
      # Modesetting is required.
      # modesetting.enable = lib.mkForce true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = true;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = true;

      # Dynamic Boost. It is a technology found in NVIDIA Max-Q design laptops with RTX GPUs.
      # It intelligently and automatically shifts power between
      # the CPU and GPU in real-time based on the workload of your game or application.
      dynamicBoost.enable = lib.mkForce true;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      open = true;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      # nvidiaSettings = lib.mkForce false;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      # package = config.boot.kernelPackages.nvidiaPackages.production;
      # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      #   version = "570.133.07";
      #   # this is the third one it will complain is wrong
      #   sha256_64bit = "sha256-LUPmTFgb5e9VTemIixqpADfvbUX1QoTT2dztwI3E3CY=";
      #   # unused
      #   sha256_aarch64 = "sha256-2l8N83Spj0MccA8+8R1uqiXBS0Ag4JrLPjrU3TaXHnM=";
      #   # this is the second one it will complain is wrong
      #   openSha256 = "sha256-9l8N83Spj0MccA8+8R1uqiXBS0Ag4JrLPjrU3TaXHnM=";
      #   # this is the first one it will complain is wrong
      #   settingsSha256 = "sha256-XMk+FvTlGpMquM8aE8kgYK2PIEszUZD2+Zmj2OpYrzU=";
      #   persistencedSha256 = "sha256-G1V7JtHQbfnSRfVjz/LE2fYTlh9okpCbE4dfX9oYSg8=";
      # };

      # Nvidia Optimus PRIME. It is a technology developed by Nvidia to optimize
      # the power consumption and performance of laptops equipped with their GPUs.
      # It seamlessly switches between the integrated graphics,
      # usually from Intel, for lightweight tasks to save power,
      # and the discrete Nvidia GPU for performance-intensive tasks.
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        #!! VERIFY these IDs using `lspci | grep -E 'VGA|3D'`!!
        # Convert hex (e.g., 00:02.0) to decimal PCI:Bus:Device:Function
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
        sync.enable = false;
        reverseSync.enable = false;
      };
    };

    # Enable access to nvidia from containers (Docker, Podman)
    nvidia-container-toolkit.enable = false;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [
    # "modesetting"
    "nvidia"
  ];

  # Set up a udev rule to create named symlinks for the pci paths.
  #
  # This is necessary because wlroots splits the DRM_DEVICES on
  # `:`, which is part of the pci path.
  services.udev.packages =
    let
      pciPath =
        xorgBusId:
        let
          components = lib.drop 1 (lib.splitString ":" xorgBusId);
          toHex = i: lib.toLower (lib.toHexString (lib.toInt i));

          domain = "0000"; # Apparently the domain is practically always set to 0000
          bus = lib.fixedWidthString 2 "0" (toHex (builtins.elemAt components 0));
          device = lib.fixedWidthString 2 "0" (toHex (builtins.elemAt components 1));
          function = builtins.elemAt components 2; # The function is supposedly a decimal number
        in
        "dri/by-path/pci-${domain}:${bus}:${device}.${function}-card";

      pCfg = config.hardware.nvidia.prime;
      igpuPath = pciPath (if pCfg.intelBusId != "" then pCfg.intelBusId else pCfg.amdgpuBusId);
      dgpuPath = pciPath pCfg.nvidiaBusId;
    in
    [
      (pkgs.writeTextDir "lib/udev/rules.d/61-gpu-offload.rules" ''
        SYMLINK=="${igpuPath}", SYMLINK+="dri/igpu1"
        SYMLINK=="${dgpuPath}", SYMLINK+="dri/dgpu1"
      '')

      # pkgs.khanelinix.r8152-udev-rules
      (pkgs.writeTextFile {
        name = "50-usb-realtek-net.rules";
        text = pkgs.lib.fileContents ./50-usb-realtek-net.rules;
        destination = "/etc/udev/rules.d/50-usb-realtek-net.rules";
      })
    ];
}

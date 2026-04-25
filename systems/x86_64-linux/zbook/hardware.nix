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
      # extraPackages = with pkgs; [
      #   intel-media-driver # Modern Intel VAAPI driver (iHD)
      #   libvdpau-va-gl # VDPAU frontend for VAAPI
      #   nvidia-vaapi-driver # VAAPI backend for Nvidia
      #   intel-gpu-tools # Useful Intel GPU utilities
      #   # vulkan-tools          # Optional: for Vulkan diagnostics
      # ];
      # extraPackages32 = with pkgs.pkgsi686Linux; [
      #   intel-media-driver # 32-bit Intel VAAPI
      # ];
      extraPackages = with pkgs; [
        intel-compute-runtime
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        libva-vdpau-driver
        mesa
        nv-codec-headers-12
        # vaapiVdpau # VA-API to VDPAU wrapper
        libvdpau-va-gl # VDPAU to VA-API wrapper (reverse)
        nvidia-vaapi-driver # VA-API driver for NVIDIA
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        intel-media-driver
        intel-vaapi-driver
        libva-vdpau-driver
        mesa
        # vaapiVdpau
        libvdpau-va-gl
      ];
    };

    nvidia = {

      # forceFullCompositionPipeline = true;
      # Modesetting is required.
      # modesetting.enable = lib.mkForce true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = lib.mkForce true;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = lib.mkForce false;

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
      # open = lib.mkForce true;

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
          enable = lib.mkForce true;
          enableOffloadCmd = lib.mkForce true;
        };

        #!! VERIFY these IDs using `lspci | grep -E 'VGA|3D'`!!
        # Convert hex (e.g., 00:02.0) to decimal PCI:Bus:Device:Function
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
        sync.enable = lib.mkForce false;
        reverseSync.enable = lib.mkForce false;
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
}

{ pkgs, ... }:

{

  # Enable OpenGL
  hardware.graphics = {
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
}

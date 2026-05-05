{
  lib,
  stdenv,
  fetchFromGitHub,
  udevCheckHook,
}:

stdenv.mkDerivation {
  pname = "r8152-udev-rules";
  version = 20260428;

  src = fetchFromGitHub {
    owner = "wget";
    repo = "realtek-r8152-linux";
    rev = "v2.16.3.20221209";
    sha256 = "sha256-RaYuprQFbWAy8CtSZOau0Qlo3jtZnE1AhHBgzASopSA=";
  };

  nativeBuildInputs = [ udevCheckHook ];

  doInstallCheck = true;

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/lib/udev/rules.d
    cp 50-usb-realtek-net.rules $out/lib/udev/rules.d/50-usb-realtek-net.rules
  '';

  meta = {
    homepage = "https://github.com/wget/realtek-r8152-linux";
    description = "Udev rules for Realtek RTL8152/RTL8153 USB Ethernet adapters";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
  };
}

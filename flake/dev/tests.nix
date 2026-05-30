{
  inputs,
  lib,
  self,
  ...
}:
{
  imports = lib.optional (inputs.nix-unit ? modules) inputs.nix-unit.modules.flake.default;

  # Pure `lib.khanelinix` helper tests, run via `nix flake check` (check
  # `nix-unit`) or ad hoc with `nix-unit --flake .#tests` from the dev shell.
  # Cases live next to the library in `lib/tests`.
  flake.tests = lib.mkIf (inputs.nix-unit ? modules) (import ../../lib/tests { inherit self lib; });
}

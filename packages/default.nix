{ pkgs }:

let
  inherit (pkgs) lib;
in

builtins.readDir ./.
|> lib.filterAttrs (
  name: kind:
  (kind == "directory" && builtins.pathExists ./${name}/default.nix)
  || (kind == "regular" && name != "default.nix" && lib.hasSuffix ".nix" name)
)
|> lib.attrNames
|> map (name: pkgs.callPackage ./${name} { })

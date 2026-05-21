{
  newScope,
  symlinkJoin,
  flake,
}:

let
  callPackage = newScope { inherit flake; };

  packages = {
    neovim-ssh = callPackage ./neovim-ssh.nix { };
  };
in

symlinkJoin {
  name = "neovim-remote";
  paths = builtins.attrValues packages;
  passthru = { inherit packages; };
}

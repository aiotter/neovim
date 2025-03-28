{ lib, fetchurl, hostPlatform, runCommand }:

let
  version = "0.23.2";

  hashfile = fetchurl {
    url = "https://github.com/elixir-tools/next-ls/releases/download/v${version}/next_ls_checksums.txt";
    hash = "sha256-om/d+DAymFFjJ3E9CacVqHse0SFXw4hG0xEgrSEdsyU=";
  };

  filename = builtins.getAttr hostPlatform.system {
    x86_64-linux = "next_ls_linux_amd64";
    aarch64-linux = "next_ls_linux_arm64";
    x86_64-darwin = "next_ls_darwin_amd64";
    aarch64-darwin = "next_ls_darwin_arm64";
  };

  sha256 = with lib; pipe hashfile
    [
      builtins.readFile
      (splitString "\n")
      (findSingle (hasSuffix filename) null null)
      (splitString " ")
      builtins.head
    ];

  file = fetchurl {
    url = "https://github.com/elixir-tools/next-ls/releases/download/v${version}/${filename}";
    inherit sha256;
    postFetch = "chmod +x *";
  };
in

runCommand "nextls-${version}" { } "cp ${file} $out && chmod a+x $out"

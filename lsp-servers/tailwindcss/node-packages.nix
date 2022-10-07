# This file has been generated by node2nix 1.11.1. Do not edit!

{nodeEnv, fetchurl, fetchgit, nix-gitignore, stdenv, lib, globalBuildInputs ? []}:

let
  sources = {};
in
{
  "@tailwindcss/language-server" = nodeEnv.buildNodePackage {
    name = "_at_tailwindcss_slash_language-server";
    packageName = "@tailwindcss/language-server";
    version = "0.0.9";
    src = fetchurl {
      url = "https://registry.npmjs.org/@tailwindcss/language-server/-/language-server-0.0.9.tgz";
      sha512 = "x0rvJkO8TmwhJWjBH7z4Qn1SLaaYYtvY8Liw5SnMX62u6QuNZ0R0XU9P7nVQg+x0rxakC8oQgS2+wfYRNUyHgQ==";
    };
    buildInputs = globalBuildInputs;
    meta = {
      description = "Tailwind CSS Language Server";
      homepage = "https://github.com/tailwindlabs/tailwindcss-intellisense/tree/HEAD/packages/tailwindcss-language-server#readme";
      license = "MIT";
    };
    production = true;
    bypassCache = true;
    reconstructLock = true;
  };
}
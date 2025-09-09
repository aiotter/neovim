{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "erlls";
  version = "0.0.14";

  src = fetchFromGitHub {
    owner = "sile";
    repo = pname;
    rev = version;
    hash = "sha256-YM9OM67eTIrDCNzgg9kXk7OZwZkKe1To6XAMvP7J+/k=";
  };

  cargoHash = "sha256-IZsN8vHW1LikDA5V/EYzYJfRCGeyqE44GiOL3+bmqvU=";
  # cargoLock = {
  #   lockFile = "${src}/Cargo.lock";
  #   allowBuiltinFetchGit = true;
  # };

  meta = with lib; {
    description = "Erlang language server";
    homepage = "https://github.com/sile/erlls";
    license = with licenses; [asl20 mit];
    maintainers = [];
  };
}

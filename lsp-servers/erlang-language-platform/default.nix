{ lib, stdenv, fetchFromGitHub, rustPlatform, jdk17, sbt }:

let
  eqwalizer = stdenv.mkDerivation rec {
    pname = "eqwalizer";
    version = "v0.23.6";
    src = fetchFromGitHub {
        owner = "whatsapp";
        repo = pname;
        rev = version;
        hash = "sha256-OSYEGmuiAGmBQQo0NA7CWR+HraAsmJxD/IPt4J9wFVg=";
      };
    sourceRoot = "${src.name}/${pname}";
    nativeBuildInputs = [jdk17 sbt];
    buildPhase = "sbt assembly";
  };
in

rustPlatform.buildRustPackage rec {
  pname = "erlang-language-platform";
  version = "2023-12-15";

  src = fetchFromGitHub {
    owner = "whatsapp";
    repo = pname;
    rev = version;
    hash = "sha256-f5MoYJ6Wua/3GupIOV0ROlUWoF9WcIhed3V317p9Ejc=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    allowBuiltinFetchGit = true;
  };

  buildPhase = "ELP_EQWALIZER_PATH=${eqwalizer}/bin/eqwalizer.jar cargo build";
  nativeBuildInputs = [jdk17];

  meta = with lib; {
    description = "Erlang Language Platform. LSP server and CLI.";
    homepage = "https://whatsapp.github.io/erlang-language-platform/";
    license = with licenses; [asl20 mit];
    maintainers = [];
  };
}

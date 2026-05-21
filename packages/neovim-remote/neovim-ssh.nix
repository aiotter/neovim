{
  lib,
  writeShellApplication,
  nix,
  openssh,
  coreutils,
  flake,
}:

writeShellApplication rec {
  name = "nvim-ssh";

  runtimeInputs = [
    nix
    openssh
    coreutils
  ];

  text = ''
    usage() {
      cat <<'EOF'
    ${meta.description}

    Usage:
      nvim-ssh user@host[:port] /absolute/path [nvim-args...]
      nvim-ssh ssh://user@host[:port] /absolute/path [nvim-args...]
      nvim-ssh ssh-ng://user@host[:port] /absolute/path [nvim-args...]

    Environment:
      NVIM_SSH_ATTR  Flake app/package attr to run on the remote host. Default: default

    Examples:
      nvim-ssh nixos:2222 /home/me/project
      nvim-ssh ssh://nixos:2222 /home/me/project
      nvim-ssh ssh://nixos /home/me/project/init.lua +'set number'
    EOF
    }

    die() {
      printf 'nvim-ssh: %s\n' "$*" >&2
      exit 1
    }

    quote() {
      printf '%q' "$1"
    }

    case "''${1:-}" in
      -h|--help)
        usage
        exit 0
        ;;
    esac

    if [ "$#" -lt 2 ]; then
      usage >&2
      exit 2
    fi

    store_uri="$1"
    remote_path="$2"
    shift 2

    flake_path=${lib.escapeShellArg flake}
    attr="''${NVIM_SSH_ATTR:-default}"

    case "$attr" in
      *[!A-Za-z0-9._-]*|"")
        die "unsafe flake attr: $attr"
        ;;
    esac

    case "$store_uri" in
      ssh://*)
        ssh_authority="''${store_uri#ssh://}"
        ;;
      ssh-ng://*)
        ssh_authority="''${store_uri#ssh-ng://}"
        ;;
      *)
        ssh_authority="$store_uri"
        store_uri="ssh://$store_uri"
        ;;
    esac

    ssh_authority="''${ssh_authority%%\?*}"
    ssh_authority="''${ssh_authority%%/*}"

    ssh_dest="$ssh_authority"
    ssh_args=()
    if [[ "$ssh_authority" =~ ^(.+):([0-9]+)$ ]]; then
      ssh_dest="''${BASH_REMATCH[1]}"
      ssh_args=(-p "''${BASH_REMATCH[2]}")
    fi

    [ -n "$ssh_dest" ] || die "missing SSH destination in store URL"
    [ "''${remote_path#/}" != "$remote_path" ] || die "remote path must be absolute"

    nix --option accept-flake-config true flake archive --to "$store_uri" "$flake_path"

    nvim_args=""
    for arg in "$@"; do
      nvim_args="$nvim_args $(quote "$arg")"
    done

    remote_path_q=$(quote "$remote_path")
    flake_path_q=$(quote "$flake_path")
    attr_q=$(quote "$attr")

    read -r -d "" remote_command <<EOF || true
    set -euo pipefail
    target=$remote_path_q
    flake_path=$flake_path_q
    attr=$attr_q

    if [ -d "\$target" ]; then
      cd "\$target"
      exec nix --option accept-flake-config true run "\$flake_path#\$attr" -- .$nvim_args
    fi

    dir=\$(dirname -- "\$target")
    file=\$(basename -- "\$target")
    cd "\$dir"
    exec nix --option accept-flake-config true run "\$flake_path#\$attr" -- "\$file"$nvim_args
    EOF

    exec ssh -t "''${ssh_args[@]}" "$ssh_dest" "$remote_command"
  '';

  meta = {
    description = "Run this flake's Neovim on a remote Nix host over SSH.";
  };
}

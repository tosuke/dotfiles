#!/bin/sh

# -e: exit on error
# -u: exit on unset variables
set -eu

if ! chezmoi="$(command -v chezmoi)"; then
	bin_dir="${HOME}/.local/bin"
	chezmoi="${bin_dir}/chezmoi"
	echo "Installing chezmoi to '${chezmoi}'" >&2
	if command -v curl >/dev/null; then
		chezmoi_install_script="$(curl -fsSL get.chezmoi.io)"
	elif command -v wget >/dev/null; then
		chezmoi_install_script="$(wget -qO- get.chezmoi.io)"
	else
		echo "To install chezmoi, you must have curl or wget installed." >&2
		exit 1
	fi
	sh -c "${chezmoi_install_script}" -- -b "${bin_dir}"
	unset chezmoi_install_script bin_dir
fi

export PATH="${PATH}:${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin"
export AQUA_GLOBAL_CONFIG="${AQUA_GLOBAL_CONFIG:-${XDG_CONFIG_HOME:-$HOME/.config}/aquaproj-aqua/aqua.yaml}"
export AQUA_POLICY_CONFIG="${AQUA_POLICY_CONFIG:-${XDG_CONFIG_HOME:-$HOME/.config}/aquaproj-aqua/aqua-policy.yaml}"
if ! command -v aqua; then
    aqua_installer="$(mktemp)"
    if command -v curl >/dev/null; then
        curl -fsSL -o "${aqua_installer}" https://raw.githubusercontent.com/aquaproj/aqua-installer/v2.2.0/aqua-installer
    elif command -v wget >/dev/null; then
        wget -qO "${aqua_installer}" https://raw.githubusercontent.com/aquaproj/aqua-installer/v2.2.0/aqua-installer
    else
        echo "To install aqua, you must have curl or wget installed." >&2
        exit 1
    fi
    echo "d13118c3172d90ffa6be205344b93e8621de9bf47c852d80da188ffa6985c276  ${aqua_installer}" | sha256sum -c
    chmod +x "${aqua_installer}"
    "${aqua_installer}"
    rm "${aqua_installer}"
fi
# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"

set -- init --source="${script_dir}"

echo "Running 'chezmoi $*'" >&2
# exec: replace current process with chezmoi
"$chezmoi" "$@"
"$chezmoi" apply --source="${script_dir}"

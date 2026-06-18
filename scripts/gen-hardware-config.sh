#!/usr/bin/env bash
# gen-hardware-config.sh
#
# Generates the per-device hardware-configuration.nix for this flake.
# default/hardware-configuration.nix is gitignored — it contains machine-specific
# data (disk UUIDs, ESP mount point, kernel modules) and must be regenerated on
# each machine before the first build.
#
# Usage: scripts/gen-hardware-config.sh
# Run from anywhere; the script resolves the repo root relative to itself.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TARGET="${REPO_ROOT}/default/hardware-configuration.nix"
BACKUP="${TARGET}.bak"

echo "Repo root: ${REPO_ROOT}"
echo "Target:    ${TARGET}"
echo ""

# Back up existing file if present
if [[ -f "${TARGET}" ]]; then
    cp "${TARGET}" "${BACKUP}"
    echo "Existing hardware-configuration.nix backed up to:"
    echo "  ${BACKUP}"
    echo ""
fi

# Generate hardware config (requires sudo for nixos-generate-config)
echo "Running: sudo nixos-generate-config --show-hardware-config"
sudo nixos-generate-config --show-hardware-config > "${TARGET}"

echo ""
echo "Written: ${TARGET}"
echo ""
echo "----------------------------------------------------------------------"
echo "NEXT STEPS — check your ESP (EFI System Partition) mount point"
echo "----------------------------------------------------------------------"
echo ""
echo "Run one of the following to find where your ESP is mounted:"
echo "  findmnt /boot /boot/efi"
echo "  lsblk -f"
echo ""
echo "Then edit ${TARGET} to match:"
echo ""
echo "  ESP at /boot (default):"
echo "    Nothing to add. Works as-is."
echo ""
echo "  ESP at /boot/efi (separate EFI partition):"
echo "    Add to hardware-configuration.nix:"
echo "      boot.loader.efi.efiSysMountPoint = \"/boot/efi\";"
echo ""
echo "  No EFI / BIOS-only (e.g. a legacy-boot VM):"
echo "    Add to hardware-configuration.nix:"
echo "      boot.loader.grub.efiSupport = lib.mkForce false;"
echo "      boot.loader.efi.canTouchEfiVariables = lib.mkForce false;"
echo "      boot.loader.grub.devices = lib.mkForce [ \"/dev/vda\" ];  # whole disk"
echo "    (Confirm disk name with lsblk — often /dev/vda or /dev/sda in a VM.)"
echo "    (lib.mkForce is required to override the committed config defaults.)"
echo ""
echo "See README.md for full details on each case."
echo "----------------------------------------------------------------------"

#!/usr/bin/env bash
# Gryps installer.
# Puts `gryps` in ~/.local/bin from a GitHub Release tarball, then installs
# the Chromium that Playwright drives.
#
#   curl -fsSL https://raw.githubusercontent.com/daskinnyman/gryps-release/main/install.sh | bash
#
# GRYPS_VERSION=0.1.0 picks a release; GRYPS_PREFIX changes ~/.local;
# GRYPS_TARBALL=<file> installs a local tarball; GRYPS_DRY_RUN=1 prints the npm command.
set -euo pipefail

REPO="${GRYPS_REPO:-daskinnyman/gryps-release}"
VERSION="${GRYPS_VERSION:-latest}"
PREFIX="${GRYPS_PREFIX:-${HOME}/.local}"

die() { printf 'gryps-install: %s\n' "$*" >&2; exit 1; }
log() { printf 'gryps-install: %s\n' "$*" >&2; }

[[ "${EUID:-$(id -u)}" -ne 0 ]] || die "refusing to run as root (do not use sudo)"
command -v node >/dev/null 2>&1 || die "Node.js 20.19+ or 22.12+ is required"
command -v npm >/dev/null 2>&1 || die "npm is required (ships with Node.js)"
node -e "const [a,b]=process.versions.node.split('.').map(Number);
process.exit((a===20&&b>=19)||(a===22&&b>=12)||a>22?0:1)" \
  || die "Node.js 20.19+ or 22.12+ required (found $(node -p 'process.versions.node'))"

WORK_DIR=""
trap '[[ -n "${WORK_DIR}" ]] && rm -rf "${WORK_DIR}"' EXIT

if [[ -n "${GRYPS_TARBALL:-}" ]]; then
  tarball="${GRYPS_TARBALL}"
else
  command -v curl >/dev/null 2>&1 || die "curl is required"
  WORK_DIR="$(mktemp -d)"
  if [[ "${VERSION}" == "latest" ]]; then
    base="https://github.com/${REPO}/releases/latest/download"
    name="gryps.tgz"
  else
    base="https://github.com/${REPO}/releases/download/v${VERSION#v}"
    name="gryps-${VERSION#v}.tgz"
  fi
  tarball="${WORK_DIR}/${name}"
  curl -fsSL -o "${tarball}" "${base}/${name}" || die "failed to download ${base}/${name}"
fi
[[ -f "${tarball}" ]] || die "tarball not found: ${tarball}"

# The package's postinstall runs `playwright install chromium`.
install_cmd=(npm install -g --omit=dev --prefix "${PREFIX}" "${tarball}")
if [[ "${GRYPS_DRY_RUN:-}" == "1" ]]; then
  printf '%s\n' "${install_cmd[*]}"
  exit 0
fi

log "installing into ${PREFIX}"
mkdir -p "${PREFIX}/bin"
"${install_cmd[@]}"
[[ -x "${PREFIX}/bin/gryps" ]] || die "install finished but ${PREFIX}/bin/gryps is missing"

case ":${PATH}:" in
  *":${PREFIX}/bin:"*) ;;
  *) log "add ${PREFIX}/bin to PATH:"
     log "  echo 'export PATH=\"${PREFIX}/bin:\$PATH\"' >> ~/.zshrc && source ~/.zshrc" ;;
esac

log "installed ${PREFIX}/bin/gryps ($("${PREFIX}/bin/gryps" --version))"
log "next: gryps skills"
log "      gryps run --skill smoke --target <url> --agent \"claude -p --allowedTools=Bash\""

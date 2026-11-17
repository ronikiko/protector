#!/usr/bin/env bash
# Protector tool runner — pinned, Docker-based wrappers for the external
# scanners so the flow works without native installs. Read-only against the
# repo; no secret is ever printed in full by these wrappers.
set -euo pipefail

# Pinned image digests-by-tag (bump deliberately, never 'latest').
TRIVY_IMG="aquasec/trivy:0.58.1"
TRUFFLEHOG_IMG="trufflesecurity/trufflehog:3.88.0"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

usage() {
  cat <<EOF
Usage: scripts/run-tools.sh <command> [args]

  trufflehog              Scan full git history for verified secrets
  trivy-fs                Filesystem scan: deps + misconfig (HIGH,CRITICAL)
  trivy-image <img:tag>   Scan a container image the product ships
EOF
}

require_docker() {
  command -v docker >/dev/null 2>&1 || { echo "docker not found" >&2; exit 2; }
}

cmd="${1:-}"; shift || true
case "$cmd" in
  trufflehog)
    require_docker
    # Scan the repo's git history; --only-verified cuts noise to live secrets.
    docker run --rm -v "$REPO_ROOT:/repo:ro" "$TRUFFLEHOG_IMG" \
      git file:///repo --only-verified --no-update
    ;;
  trivy-fs)
    require_docker
    docker run --rm -v "$REPO_ROOT:/repo:ro" "$TRIVY_IMG" \
      fs --scanners vuln,secret,misconfig \
      --severity HIGH,CRITICAL --ignore-unfixed /repo
    ;;
  trivy-image)
    require_docker
    img="${1:?image:tag required}"
    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock "$TRIVY_IMG" \
      image --severity HIGH,CRITICAL --ignore-unfixed "$img"
    ;;
  ""|-h|--help) usage ;;
  *) echo "unknown command: $cmd" >&2; usage; exit 2 ;;
esac

#!/usr/bin/env bash
# One-shot publisher: create the public repo (if missing), push main, verify.
# Token is read from the environment only; it is never written to disk or printed.
set -euo pipefail

: "${GITHUB_TOKEN:?Usage: GITHUB_TOKEN=<token> ./publish.sh}"

OWNER="${GITHUB_OWNER:-wenrs-lab}"
REPO="${GITHUB_REPO:-ai-delivery-pm}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ASKPASS="$(mktemp /tmp/gh-askpass.XXXXXX)"
cat > "$ASKPASS" <<'SH'
#!/bin/sh
case "$1" in
  *Username*) printf '%s' "x-access-token" ;;
  *Password*) printf '%s' "$GITHUB_TOKEN" ;;
  *) printf '%s' "" ;;
esac
SH
chmod +x "$ASKPASS"
trap 'rm -f "$ASKPASS"' EXIT

echo "[1/3] Ensuring public repo $OWNER/$REPO exists..."
GITHUB_TOKEN="$GITHUB_TOKEN" OWNER="$OWNER" REPO="$REPO" REPO_DIR="$REPO_DIR" python3 - <<'PY'
import json, os, urllib.request, urllib.error
from pathlib import Path

tok = os.environ["GITHUB_TOKEN"]
owner, repo = os.environ["OWNER"], os.environ["REPO"]
desc = json.loads((Path(os.environ["REPO_DIR"]) / ".codebuddy-plugin" / "plugin.json").read_text(encoding="utf-8"))["description"]

def call(method, path, payload=None):
    data = json.dumps(payload).encode() if payload is not None else None
    req = urllib.request.Request("https://api.github.com" + path, data=data, method=method, headers={
        "Accept": "application/vnd.github+json",
        "Authorization": "Bearer " + tok,
        "User-Agent": "workbuddy-publisher",
        "Content-Type": "application/json",
    })
    try:
        with urllib.request.urlopen(req, timeout=20) as r:
            return r.status, json.load(r)
    except urllib.error.HTTPError as e:
        body = e.read().decode()
        try: body = json.loads(body)
        except Exception: pass
        return e.code, body

status, me = call("GET", "/user")
if status != 200:
    raise SystemExit(f"Token invalid ({status}): {me}")
login = me.get("login", "")
print("    authenticated as:", login)
if login.lower() != owner.lower():
    raise SystemExit(f"Token belongs to {login}, not {owner}. Use a token from the {owner} account.")

status, existing = call("GET", f"/repos/{owner}/{repo}")
if status == 200:
    print("    repo already exists:", existing["html_url"])
elif status == 404:
    status, created = call("POST", "/user/repos", {
        "name": repo,
        "description": desc,
        "private": False,
        "has_issues": True,
    })
    if status not in (201,):
        raise SystemExit(f"Create repo failed ({status}): {created}")
    print("    created:", created["html_url"])
else:
    raise SystemExit(f"Repo lookup failed ({status}): {existing}")
PY

echo "[2/3] Pushing main..."
cd "$REPO_DIR"
git -c credential.helper= -c core.askPass="$ASKPASS" push -u origin main

echo "[3/3] Verifying remote contents..."
GITHUB_TOKEN="$GITHUB_TOKEN" OWNER="$OWNER" REPO="$REPO" python3 - <<'PY'
import json, os, urllib.request
owner, repo = os.environ["OWNER"], os.environ["REPO"]
req = urllib.request.Request(f"https://api.github.com/repos/{owner}/{repo}/git/trees/main?recursive=1", headers={
    "Accept": "application/vnd.github+json",
    "Authorization": "Bearer " + os.environ["GITHUB_TOKEN"],
    "User-Agent": "workbuddy-publisher",
})
with urllib.request.urlopen(req, timeout=20) as r:
    tree = json.load(r)
files = [t["path"] for t in tree.get("tree", []) if t["type"] == "blob"]
print(f"    {len(files)} files on GitHub:")
for f in files:
    print("     -", f)
print(f"\nDone: https://github.com/{owner}/{repo}")
PY

#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
source_dir="$script_dir/sloth"
codex_root=${CODEX_HOME:-"$HOME/.codex"}
pets_dir="$codex_root/pets"
target_dir="$pets_dir/sloth"
timestamp=$(date +%Y%m%d-%H%M%S)
backup_dir=""

verify_sha256() {
  expected=$1
  file=$2
  actual=""

  if command -v shasum >/dev/null 2>&1; then
    actual=$(shasum -a 256 "$file" | awk '{print $1}')
  elif command -v sha256sum >/dev/null 2>&1; then
    actual=$(sha256sum "$file" | awk '{print $1}')
  else
    printf '%s\n' "未找到 SHA-256 工具，跳过哈希校验：$file"
    return 0
  fi

  if [ "$actual" != "$expected" ]; then
    printf '%s\n' "校验失败：$file" >&2
    exit 1
  fi
}

if [ ! -f "$source_dir/pet.json" ] || [ ! -f "$source_dir/spritesheet.png" ]; then
  printf '%s\n' "安装包不完整：找不到 sloth/pet.json 或 sloth/spritesheet.png。" >&2
  exit 1
fi

verify_sha256 "d5f947c32102cc831a7ce48301bbe06b258950426914dc23e8bda647ccc30bc0" "$source_dir/pet.json"
verify_sha256 "a7f35a2f888b943fe175d142ec4435f7959e2f5d9a93942fc272ff606175417c" "$source_dir/spritesheet.png"

mkdir -p "$pets_dir"

if [ -e "$target_dir" ] || [ -L "$target_dir" ]; then
  backup_dir="${target_dir}.backup-${timestamp}"
  mv "$target_dir" "$backup_dir"
fi

if ! mkdir "$target_dir" || ! cp "$source_dir/pet.json" "$source_dir/spritesheet.png" "$target_dir/"; then
  failed_dir="${target_dir}.failed-${timestamp}"
  if [ -e "$target_dir" ] || [ -L "$target_dir" ]; then
    mv "$target_dir" "$failed_dir"
  fi
  if [ -n "$backup_dir" ] && [ -e "$backup_dir" ]; then
    mv "$backup_dir" "$target_dir"
  fi
  printf '%s\n' "安装失败；旧版本已尽量恢复。" >&2
  exit 1
fi

printf '%s\n' "sloth 已安装到：$target_dir"
if [ -n "$backup_dir" ]; then
  printf '%s\n' "旧版本备份在：$backup_dir"
fi
printf '%s\n' "请在桌面应用的 Settings > Pets 中选择 Refresh，然后选择“懒懒”。"

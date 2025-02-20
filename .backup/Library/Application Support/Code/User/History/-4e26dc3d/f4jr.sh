#!/usr/bin/env bash

set -e

BASE_CONFIG="base"
CONFIG_SUFFIX=".yml"

META_DIR="meta"
CONFIG_DIR="configs"
PROFILES_DIR="profiles"

DOTBOT_DIR="meta/dotbot"
DOTBOT_BIN="bin/dotbot"

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "${BASE_DIR}"
git submodule update --init --recursive --remote

for config in ${@}; do
	configFile="$(mktemp)" ; echo -e "$(<"${BASE_DIR}/${META_DIR}/${BASE_CONFIG}${CONFIG_SUFFIX}")\n$(<"${BASE_DIR}/${META_DIR}/${CONFIG_DIR}/${config}${CONFIG_SUFFIX}")" > "$configFile"
	"${BASE_DIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASE_DIR}" --plugin-dir "${META_DIR}/dotbot-brew" --plugin-dir "${META_DIR}/dotbot-asdf" -c "$configFile" ; rm -f "$configFile"
done

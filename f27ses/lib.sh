#!/usr/bin/env bash

# Utility functions for f27s quickstart scripts.
#
# Copyright 2022, Donny Johnson
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

OUTPUT_FILE="$PWD/install.log.adoc"

function reset_log() {
    if [ -z "$LOG_CLEARED" ]; then
        printf "%s\n" "Clearing $OUTPUT_FILE" >&2 &&
        printf "%s\n\n" "= Install log" > "$OUTPUT_FILE" &&
        export LOG_CLEARED=1
    else
        printf "%s\n" "Not clearing log." >&2
    fi
}

function log() {
    local timestamp=""
    if [[ "$1" =~ ^= ]]; then
        timestamp=""
    else
        timestamp="$(date +%FT%H:%M:%S):: "
    fi
    printf "%s%s\n" "$timestamp" "$1"
    if [[ -n "$OUTPUT_FILE" ]]; then
        printf "%s%s\n\n" "$timestamp" "$1" >> "$OUTPUT_FILE"
    fi
}

function install_packages() {
    log "=== Installing packages" &&
    log "Packages requested: $@" &&
    local packages_to_install="$(pacman -T "$@")"
    if [[ -z "$packages_to_install" ]]; then
        log "No packages needed to install."
        return 0
    fi
    log "Packages to install: $packages_to_install" &&
    pacman -Sy &&
    pacman -S $packages_to_install &&
    log "Packages installed"

}

function build_adoc() {
    if which asciidoc >/dev/null 2>&1; then
        printf "%s\n" "Running \`asciidoctor \"${OUTPUT_FILE}\"\`" >&2 &&
        asciidoctor "$OUTPUT_FILE"
    else
        printf "%s\n" "Cannot asciidoctor on ${OUTPUT_FILE}.  If you wish to have this generated, install asciidoctor (\`pacman -S ruby && gem install asciidoctor\`)." >&2
    fi
}

function ensure_bashrc_path_prepend() {
    local path_line="$(printf 'export PATH="%s:$PATH"' "$1")"

    if grep -Fqx "$path_line"; then
        log "'$path_line' already in ~/.bashrc" &&
        return 0
    fi

    log "Adding '$path_line' to ~/.bashrc" &&
    printf '%s\n' "$path_line"
}

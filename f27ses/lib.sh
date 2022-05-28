#!/usr/bin/env bash

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

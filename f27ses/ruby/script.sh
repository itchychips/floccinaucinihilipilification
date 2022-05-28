#!/usr/bin/env bash

. ../lib.sh

reset_log &&

PATH_STRING='export PATH="$HOME/.gem/ruby/2.7.0/bin:$PATH"'
BASHRC="$HOME/.bashrc"

log "== Installing Ruby" &&

install_packages ruby &&

log "=== Ensuring path is updated for gems" &&
if [ ! -f "$BASHRC" ]; then
    log "'$BASHRC' not found." &&
    touch "$BASHRC" &&
    log "'$BASHRC' created."
else
    log "'$BASHRC' exists."
fi
log "Testing if '$PATH_STRING' is in '$BASHRC'" &&
if ! grep -Fq "$PATH_STRING" "$BASHRC"; then
    log "Adding '$PATH_STRING' to '$BASHRC'" &&
    echo "$PATH_STRING" >> "$BASHRC"
else
    log "Exists."
fi

log "=== Done." &&
log "Compeleted successfully." &&
log "Do \`. ~/.bashrc\` to use updated PATH if necessary." &&
build_adoc

#!/usr/bin/env bash

# F27s quickstart script for ruby.
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

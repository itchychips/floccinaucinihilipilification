#!/usr/bin/env bash

# F27s quickstart script for Node Version Manager (nvm).
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

. ../lib.sh &&

# Name this different from NVM_DIR so we don't step on the official export.
NVM_INSTALL_DIR="$HOME/.nvm"
NVM_BASHRC_LINES=(
'export NVM_DIR="$HOME/.nvm"'
'[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm'
'[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion'
)

reset_log &&

log "== Installing nvm" &&
if [ -d "$NVM_INSTALL_DIR" ] && [ ! -d "$NVM_INSTALL_DIR/.git" ]; then
    log "ERROR: '$NVM_INSTALL_DIR' is not a git repository.  Cowardly refusing to continue." &&
    log "ACTION: Remove or move '$NVM_INSTALL_DIR' and re-run this script." &&
    return 1
elif [ ! -d "$NVM_INSTALL_DIR" ]; then
    log "Cloning into '$NVM_INSTALL_DIR'" &&
    git clone "https://github.com/nvm-sh/nvm.git" "$NVM_INSTALL_DIR"
else
    log "'$NVM_INSTALL_DIR' already exists."
fi &&
log "Checking out tag for version v0.39.1 as recommended by dev's git intructions" &&
pushd "$NVM_INSTALL_DIR" &&
git fetch --all &&
git checkout v0.39.1 &&
popd &&

log "Ensuring lines for NVM activate on shell spawn are in ~/.bashrc" &&
for line in "${NVM_BASHRC_LINES[@]}"; do
    if ! grep -Fxq "$line" ~/.bashrc; then
        log "Adding '$line'" &&
        printf '%s\n' "$line" >> ~/.bashrc
    else
        log "'$line' already added."
    fi
done &&

log "== Done"
log "Do '~/.bashrc' now to use in current shell."

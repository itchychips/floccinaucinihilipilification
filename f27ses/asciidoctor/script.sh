#!/usr/bin/env bash

# F27s quickstart script for asciidoctor.
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

../ruby/script.sh &&
log "=== Dot-sourcing ~/.bashrc for PATH updates" &&
. ~/.bashrc &&

log "== Installing asciidoctor" &&
gem install asciidoctor &&
log "=== Done" &&
log "You should be able to use asciidoctor now." &&
build_adoc

#!/usr/bin/env bash

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

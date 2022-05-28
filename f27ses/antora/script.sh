#!/usr/bin/env bash

# F27s quickstart script for Antora.
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

DOCS_SITE_DIR="docs-site"

#https://github.com/nvm-sh/nvm.git
#git submodule add https://github.com/nvm-sh/nvm.git

log "== Installing Antora" &&

install_packages unzip &&

log "=== Updating nvm submodule" &&
git submodule update nvm &&
log "=== Dot-source nvm/nvm.sh" && 
. nvm/nvm.sh &&
log "=== Installing and using latest node version via nvm" &&
nvm install node &&
nvm use node &&
log "=== Creating and changing into directory '$DOCS_SITE_DIR'" &&
mkdir -p "$DOCS_SITE_DIR" &&
pushd "$DOCS_SITE_DIR" &&
log "=== Running quickstart instructions from Antora devs" &&
node -e "fs.writeFileSync('package.json', '{}')" &&
npm i -D -E @antora/cli@3.0.0 @antora/site-generator@3.0.0 &&
log "=== Creating Antora playbook" &&
cat << EOF > antora-playbook.yml
site:
  title: Antora Docs
  start_page: component-b::index.adoc
content:
  sources:
  - url: https://gitlab.com/antora/demo/demo-component-a.git
    branches: HEAD
  - url: https://gitlab.com/antora/demo/demo-component-b.git
    branches: [v2.0, v1.0]
    start_path: docs
ui:
  bundle:
    url: https://gitlab.com/antora/antora-ui-default/-/jobs/artifacts/HEAD/raw/build/ui-bundle.zip?job=bundle-stable
    snapshot: true
EOF
[[ $? -eq 0 ]] &&
log "=== Running antora run command" &&
log "> npx antora --fetch antora-playbook.yml" &&
npx antora --fetch antora-playbook.yml &&
log "=== Done." &&
log "Script successful" &&
log "Open xref:docs-site/build/site/index.html[] to see the site!" &&
build_adoc

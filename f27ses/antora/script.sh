#!/usr/bin/env bash

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

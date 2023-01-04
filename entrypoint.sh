#!/bin/sh

set -eu

INSTANCE_NAME=$INSTANCE_NAME
PRIVATE_KEY=$PRIVATE_KEY
SHELL_SCRIPT=$1

INSTANCE_ID=${INSTANCE_NAME##*-}
INSTANCE_URL=$INSTANCE_NAME.dev.odoo.com

echo "Instance id : $INSTANCE_ID"
echo "Instance name : $INSTANCE_NAME"
echo "Instance URL :$INSTANCE_ID@$INSTANCE_URL"

echo "Configure SSH"
mkdir -p ~/.ssh
chmod 0700 ~/.ssh
echo "$PRIVATE_KEY" >> ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa
ssh-keygen -f ~/.ssh/id_rsa -y > ~/.ssh/id_rsa.pub && chmod 644 ~/.ssh/id_rsa.pub
ssh-keyscan -H $INSTANCE_URL > ~/.ssh/known_hosts 2> /dev/null && chmod 600 ~/.ssh/known_hosts
alias odoo_sh_ssh='ssh -i ~/.ssh/id_rsa -o UserKnownHostsFile=/github/home/.ssh/known_hosts'
alias odoo_sh_scp='scp -i ~/.ssh/id_rsa -o UserKnownHostsFile=/github/home/.ssh/known_hosts'

echo "Odoo.sh pass shell script : $SHELL_SCRIPT"
SHELL_SCRIPT_FILE=${SHELL_SCRIPT##*/}
odoo_sh_ssh $INSTANCE_ID@$INSTANCE_URL "mkdir -p github_actions"
odoo_sh_scp $GITHUB_WORKSPACE/$SHELL_SCRIPT $INSTANCE_ID@$INSTANCE_URL:/home/odoo/github_actions/$SHELL_SCRIPT_FILE
odoo_sh_ssh $INSTANCE_ID@$INSTANCE_URL "cat /home/odoo/github_actions/$SHELL_SCRIPT_FILE | odoo-bin shell --no-http"
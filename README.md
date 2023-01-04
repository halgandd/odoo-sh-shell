# Odoo.sh shell
This action execute a python script on odoo.sh instance shell

## Inputs

## `script`

**Required** The path of the script in repository.

# Usage

```yaml
- uses: actions/checkout@v3
  with:
    fetch-depth: 1
- uses: halgandd/odoo-sh-shell@v1
  with:
    script: .github/odoo_init.py
  env:
    INSTANCE_NAME: '${{secrets.ODOOSH_INSTANCE_NAME}}'
    PRIVATE_KEY: '${{secrets.SSH_PRIVATE_KEY}}'
```
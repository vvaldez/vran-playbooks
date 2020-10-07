# Ansible Playbook: Add director to site group

This playbook will:

- Add the `director` host to the `site_{{ site_name }}` group

## Usage

This playbook is meant to be imported by another playbook. The following is an `import_playbook` example usage.

```sh
- import_playbook: ../blocks/add-director-to-site-group.yml
```

## Requirements

No requirements

## Playbook variables

The following variables are required to be set.

| Variable | Type | Description |
| -------- | ---- | ----------- |
| `site_name` | string | The name of the site to add director to. e.g. if the group name is `site_edge1` the value of `site_name` should be `edge`

## Inventory requirements

- There is a `site_{{ site_name }}` group

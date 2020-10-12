# Ansible Playbook: Ansible generated templates - upload

This playbook will:

- Generate the output OOO templates on the local file system
  - The output templates will be placed into a temporary folder at path `templates/{{ template_pack }}/.tmp`.
- Place the generated templates onto the Director system
  - Create `/home/stack/ansible-generated` if it does not exist
  - If `/home/stack/ansible-generated` does exist, then backup it's current contents to `/var/tmp/ansible-generated_{{ date }}`
  - Place the generated templates onto the Director system using the template module
  - Remove the temporary templates on the local file system at `templates/{{ template_pack }}/.tmp`

## Usage

The following is an example run of the playbook using Ansible CLI.

**Note:** Always run the playbook from the top level directory of `ansible-playbook`

```sh
ansible-playbook \
  -i ../ansible-inventory/tewksbury1/inventory/hosts.yml \
  playbooks/ansible-generated-templates-upload.yml
```

## Requirements

This playbook has the following role requirements:

- `template-directory`

## Playbook variables

The following variables can be optionally set, and have default values, if not set.

| Variable | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| `relative_path_to_templates` | string | `templates/{{ template_pack }}` | The path to folder holding input templates and the template task generation file. The path should be relative to this playbook. **Note:** This relative path **has** to be in the current directory or a subdirectory. It **cannot** lead thru a parent directory. This is due to the jinja2 macro import being used within the templates, no current workaround exists.
| `output_dir` | string | `templates/{{ template_pack }}/.tmp` | The path to the directory to place generated output templates. A folder named `ansible-generated` will be created at this path, with the output templates being generated within. This folder will be removed at the end of the playbook.

## Inventory requirements

- The requirements are really based on what is contained within the task generation file (`tasks-to-generate-templates.yml`). One pack of templates can have completely different logic and inventory requirements than another. Refer to each specific template pack's documentation.

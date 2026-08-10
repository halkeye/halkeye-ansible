# halkeye.git

Ansible role to install git with rustup support for source compilation.

## Description

This role handles the installation of git, including the setup of rustup when compiling git from source. Modern versions of git require Rust to compile, so this role ensures that rustup is installed and configured before attempting source compilation.

## Features

- Installs rustup globally via apt package manager when git source compilation is enabled
- Sets the stable Rust toolchain as default
- Delegates to `geerlingguy.git` role for actual git installation
- Idempotent - only updates toolchain if not already set to stable

## Requirements

- Ansible 9.6 or higher

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
git_install_from_source: false
```

Whether to install git from source. When set to `true`, rustup will be installed first.

```yaml
git_install_from_source_force_update: false
```

If git is already installed at an older version, force a new source build.

```yaml
git_version: "2.55.0"
```

The version of git to install when building from source.

## Dependencies

- `geerlingguy.git` - Used for the actual git installation

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: halkeye.git
      become: true
      git_install_from_source: true
      git_version: "2.55.0"
```

## License

MIT

## Author Information

This role was created by Gavin Mogan.

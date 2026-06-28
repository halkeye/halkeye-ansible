halkeye.desktop
===============

Creates `.desktop` launcher entries in `~/.local/share/applications` and
deploys their icons to `~/.local/share/icons/halkeye`.

Role Variables
--------------

- `desktop_applications_dir` - where `.desktop` files are written
  (default `~/.local/share/applications`).
- `desktop_icon_dir` - where icons shipped via `icon_src` are deployed
  (default `~/.local/share/icons/halkeye`).
- `desktop_files` - list of desktop entries to create. Per-item keys:

  | key | required | description |
  | --- | --- | --- |
  | `filename` | yes | `.desktop` file name, e.g. `pikvm.desktop` |
  | `name` | yes | `Name=` shown in launchers |
  | `exec` | | `Exec=` command line |
  | `icon` | | `Icon=` path or icon name |
  | `icon_src` | | icon file shipped in this role's `files/` dir; deployed to `desktop_icon_dir` and used as `Icon=` (takes precedence over `icon`) |
  | `comment` | | `Comment=` description |
  | `generic_name` | | `GenericName=` |
  | `path` | | `Path=` working directory |
  | `type` | | `Type=` (default `Application`) |
  | `terminal` | | `Terminal=` (default `false`) |
  | `nodisplay` | | `NoDisplay=` (default `false`) |
  | `startup_notify` | | `StartupNotify=` (default `true`) |
  | `prefers_non_default_gpu` | | `PrefersNonDefaultGPU=` (default `false`) |
  | `categories` | | list of menu categories |
  | `mimetype` | | list of mime types / url schemes handled |

To add an icon, drop the image into this role's `files/` directory and set
`icon_src` to its filename.

Example Playbook
----------------

    - hosts: all
      roles:
        - role: halkeye.desktop
          desktop_files:
            - filename: pikvm.desktop
              name: pikvm
              exec: google-chrome --app=http://172.16.10.124/
              icon_src: pikvm-logo.png

License
-------

MIT

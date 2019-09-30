# Dotfiles

On this repository I hold my opinionated dotfiles, system configuration files,
and bootstrap scripts to quickly set up some systems. I am using, at the moment,
[dotdrop](https://github.com/deadc0de6/dotdrop) for the dotfiles and system
files configuration.

---

I decided to go for dotdrop since I was looking for something that would allow
me to configure both local dotfiles as well as system configuration files that I
might want to transfer.

However, I manage different systems, both at home and at work, so I wanted
something that would allow me to keep different profiles for each different
host, or rather, something that would allow me to inherit most of the stuff, and
just modify, if needed, a few small bits for each different profile.

At first I thought of having a common branch, and then a new branch for each
different system. But that would require quite a lot of management from me,
doing rebases and keeping N branches up to date with the common one at all
times, on top of resolving merge conflicts that might show up on each rebase.

Another option I thought of was relying on a common folder from which the rest
of the dotfiles would inherit from, and then different folders for each
different host, that would inherit the common files and, if needed, just
override the few variables.

That idea was soon discarded. Once I started taking a look at my dotfiles, I
realised some of them weren't shell scripts, so I'd have to rely on that
configuration file and its parser implementing some kind of inheritance
system, which most do not.

That's when I started to look around and found dotdrop. Some of its many
features are listed on its main page, but for my usecase, the main ones are:

- Templating so I can keep a single copy of the file, and use `if` clauses on
  the templates for each different profile that might need a small change.
- Easily import files. In some cases it requires manual copying and
  configuration, but in most cases it's as easy as
  `./dotdrop.sh import ~/.dotfile`.
- Symlinking. I prefer to have my dotfiles, and some of my system files, set as
  symlinks rather than hard copies.
- Easily deploy different profiles.
- And nice to have, dry-run and compare.

---

### Dotfiles

These are under `dotfiles`. Dotdrop takes care of managing and deploying them,
but, as long as you take care of copying them to their original name and
destination you can manage them manually. This is all configured under
`config.yaml`, the default cfg used by dotdrop.

The only slightly significant thing in there might be the `nord-xresources`
submodule. This is the current `Xresources` theme I use. However, I wanted a
small change from the original theme, so I made my own fork and that's what I
have I cloned here.

As for how it's used, `Xresources` let's you include variables from another
file, so I simply use dotdrop to get this file from the submodule, and then set
its destination to a symlinked hidden folder on HOME that the original (also
symlinked) `.Xresources` file will include from.

---

### System files

A few of my system configuration files are stored under `system`, with its
configuration file being `system-config.yaml`. **Careful with these files.
Deploy only after checking them, at your own risk.**

You can deploy one single file or directory by specifying it's _dotfile name_:
`sudo ./dotdrop.sh --cfg=system-config.yaml f_fstab`.

`sudo` must be used, since dotdrop needs those privileges to copy or link to
root-owned directories. And `cfg` must be specified so that dotdrop knows not to
use the default `config.yaml` file.

---

### Bootstrapping

Some systems might have it's own directories with bootstrap scripts among other
utils. You might find its own README explaining the utils. Or you might just
have to check the scripts themselves to see what they'll do.

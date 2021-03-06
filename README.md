# Dotfiles

On this repository I hold my opinionated dotfiles, system configuration files,
and bootstrap scripts to quickly set up some systems. I am using, at the
moment, [dotdrop](https://github.com/deadc0de6/dotdrop) for the dotfiles and
system files configuration.

---

I decided to go for dotdrop since I was looking for something that would allow
me to configure both local dotfiles as well as system configuration files that
I might want to transfer.

However, I manage different systems, both at home and at work, so I wanted
something that would allow me to keep different profiles for each different
host, or rather, something that would allow me to inherit most of the stuff,
and just modify, if needed, a few small bits for each different profile.

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
  `bash dotdrop.sh import ~/.dotfile`.
- Symlinking. I prefer to have my dotfiles, and some of my system files, set as
  symlinks rather than hard copies.
- Easily deploy different profiles.
- And nice to have, dry-run and compare.

---

### Dotfiles

These are under `dotfiles`. Dotdrop takes care of managing and deploying them,
but, as long as you take care of copying them to their original name and
destination you can manage them manually. This is all configured under
`config.yaml`, the default cfg used by Dotdrop.

---

### System files

A few of my system configuration files are stored under `system`, with its
configuration file being `system-config.yaml`. **Careful with these files.
Deploy only after checking them, at your own risk.**

You can deploy one single file or directory by specifying it's _dotfile name_:
`sudo bash dotdrop.sh --cfg=system-config.yaml install f_fstab`.

`sudo` must be used, since dotdrop needs those privileges to copy or link to
root-owned directories. And `cfg` must be specified so that dotdrop knows not
to use the default `config.yaml` file.

---

### Bootstrapping

Some systems might have it's own directories with bootstrap scripts among other
utils. You might find its own README explaining the utils. Or you might just
have to check the scripts themselves to see what they'll do.

One such util is my `f_vscode_packages` dotfile. It's not actually a dotfile,
rather it's an up to date list of my currently in use VSCode packages. It
still gets moved into the VSCode settings directory, but this is fine, since
using Dotdrop allows me to template this file, making it so I can have
different packages for each profile, and allows me to set a post action on the
templated file, so once it's generated, and moved, I can run a command to
dynamically install each final package.

### Manjaro Bootstraping

```bash
git clone --recurse-submodules -j8 https://github.com/Sighery/dotfiles.git
cd dotfiles/manjaro-setup
bash bootstrap.sh --help
```

And then keep an eye on the text, since some commands do require input, and/or
sudo privileges. Although it will mostly work on its own.

The `bootstrap.sh` takes a few optional arguments. It also has some logic to
automatically choose the proper profile. Execute `bash bootstrap.sh --help` to
see an up to date explanation of all the arguments and usage.

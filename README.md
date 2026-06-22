# Dotfiles

### Private secrets flake

My secrets, managed by sops-nix, as well as sensitive data that is not quite
secrets, is in a separate private repository.

SSH access would be an option, but Github provides no fine-grained permissions
for SSH. Personal Access Tokens (PAT) do allow for this, where you can specify
a repository, as well as specific permissions to it.

So I generate a new PAT for my private repo, with Contents read-only
permission.

To then use this in my systems, I need this env variable:

```sh
export NIX_CONFIG='access-tokens = github.com=pat_here'
```

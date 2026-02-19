# Nix Quick Start Guide

> **TL;DR**: One command to rule them all: `nix develop`

## Install Nix (One-Time Setup)

```bash
# Install Nix with flakes enabled (recommended)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Or use the official installer
sh <(curl -L https://nixos.org/nix/install) --daemon
```

After installation, restart your terminal.

## Using This Project

### Quick Commands

```bash
# Enter development environment (loads Zola)
nix develop

# Start development server
nix run .#serve

# Build the site
nix run .#build

# Check content and templates
nix run .#check
```

### Development Workflow

```bash
# Clone the repo
git clone https://github.com/praseodym/blog.git
cd blog

# Enter dev environment
nix develop

# Now you have Zola available:
$ zola --version
zola 0.19.2

# Start development server with live reload
$ zola serve
Building site...
-> Creating 2 pages (0 orphan) and 0 sections
Done in 45ms.

Web server is available at http://127.0.0.1:1111

# Make changes to content/templates/styles
# Browser auto-reloads!
```

### Building for Production

```bash
# Build the static site
nix build

# Output is in ./result/
ls -la result/
# index.html  style.css  images/  feed.xml  sitemap.xml  ...

# Serve locally to test
python -m http.server -d result 8000
# Visit http://localhost:8000
```

## Automatic Environment Loading (Optional)

Install direnv for automatic environment loading:

```bash
# macOS
brew install direnv

# Linux (Debian/Ubuntu)
sudo apt install direnv

# Or use Nix itself!
nix profile install nixpkgs#direnv

# Add to ~/.bashrc or ~/.zshrc
eval "$(direnv hook bash)"  # for bash
eval "$(direnv hook zsh)"   # for zsh

# Allow direnv in this project
cd blog
direnv allow
```

Now when you `cd` into the project directory, the environment loads automatically! ✨

```bash
$ cd ~/blog
direnv: loading ~/blog/.envrc
🚀 Zola development environment loaded!

Available commands:
  zola serve    - Start development server with live reload
  zola build    - Build the static site
  zola check    - Check content and templates

Zola version: zola 0.19.2

$ # Zola is now available!
$ zola --version
zola 0.19.2

$ cd ..
direnv: unloading
$ zola --version
zola: command not found  # Environment cleaned up
```

## Common Tasks

### Update Zola Version

```bash
# Update all dependencies (including Zola)
nix flake update

# Check what changed
git diff flake.lock

# Commit the update
git add flake.lock
git commit -m "Update Zola and dependencies"
```

### Troubleshooting

#### "experimental Nix feature 'flakes' is disabled"

Add to `~/.config/nix/nix.conf`:
```
experimental-features = nix-command flakes
```

#### "error: getting status of '/nix/var/nix/...': Permission denied"

Run with sudo or use multi-user install (default for macOS):
```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

#### Check if Nix is properly installed

```bash
# Check Nix version
nix --version

# Check if flakes are enabled
nix flake show
# Should show the flake outputs
```

#### Clean build cache

```bash
# Remove old build results
rm result result-*

# Clean Nix store (frees disk space)
nix-collect-garbage -d
```

## What Gets Installed?

When you run `nix develop`, Nix creates an isolated environment with:

- **Zola 0.19.2** - Static site generator
- **Git** - Version control (if not already installed)

**Important:** These are NOT installed globally! They only exist in the Nix environment.

```bash
$ which zola
zola: command not found

$ nix develop
$ which zola
/nix/store/abc123.../bin/zola  # Isolated Nix store

$ exit
$ which zola
zola: command not found  # Gone!
```

This keeps your system clean and prevents version conflicts.

## Comparison: With vs Without Nix

### Traditional Installation

```bash
# macOS
brew install zola

# Linux - download binary
wget https://github.com/getzola/zola/releases/download/v0.19.2/zola-v0.19.2-x86_64-unknown-linux-gnu.tar.gz
tar -xzf zola-v0.19.2-x86_64-unknown-linux-gnu.tar.gz
sudo mv zola /usr/local/bin/

# Windows
choco install zola
# or download .exe manually

# Then
zola serve
```

**Problems:**
- Different installation for each OS
- Pollutes system PATH
- Version management is manual
- "Works on my machine" issues

### With Nix

```bash
# Any OS (Linux, macOS, WSL)
nix develop

# Then
zola serve
```

**Benefits:**
- Same command on all platforms
- Isolated (doesn't pollute system)
- Exact version control
- Reproducible builds

## Do I Need Nix?

**You need Nix if:**
- ✅ You want reproducible builds
- ✅ You work on multiple machines
- ✅ You want the exact same environment as CI
- ✅ You don't want to manage versions manually

**You don't need Nix if:**
- ❌ You already have Zola installed and it works
- ❌ You never contribute to the project
- ❌ You can't install Nix (restricted system)

**Good news:** Even if you don't use Nix locally, GitHub Actions uses it automatically! 🎉

## Resources

- 📖 Full setup guide: [NIX_SETUP.md](NIX_SETUP.md)
- 📊 Benefits analysis: [NIX_MIGRATION_BENEFITS.md](NIX_MIGRATION_BENEFITS.md)
- 🌐 Learn Nix: [Zero to Nix](https://zero-to-nix.com/)
- 📚 Nix manual: [nix.dev](https://nix.dev/)

## Need Help?

1. Check [NIX_SETUP.md](NIX_SETUP.md) for detailed documentation
2. Check [NIX_MIGRATION_BENEFITS.md](NIX_MIGRATION_BENEFITS.md) for comparisons
3. Search [NixOS Discourse](https://discourse.nixos.org/)
4. Ask in `#nix` channel on [NixOS Discord](https://discord.gg/RbvHtGa)

---

**Happy hacking with Nix!** 🚀

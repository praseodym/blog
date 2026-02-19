# Nix Development Environment Setup

This project uses Nix flakes for reproducible development and builds.

## Prerequisites

1. **Install Nix** (if not already installed):
   ```bash
   # Single-user installation
   sh <(curl -L https://nixos.org/nix/install) --daemon

   # Or for macOS/Linux with systemd
   sh <(curl -L https://nixos.org/nix/install) --daemon
   ```

2. **Enable Flakes** (add to `~/.config/nix/nix.conf` or `/etc/nix/nix.conf`):
   ```
   experimental-features = nix-command flakes
   ```

## Quick Start

### Development Shell

Enter the development environment with Zola and all tools:

```bash
nix develop
```

This provides:
- Zola static site generator
- Git version control
- Shell with helpful commands

### Build the Site

```bash
# Using flake apps
nix run .#build

# Or build the package
nix build
```

### Serve Locally

```bash
# Using flake app (with live reload)
nix run .#serve

# Or in dev shell
nix develop
zola serve
```

### Check the Site

```bash
# Verify content and templates
nix run .#check
```

## Using direnv (Optional but Recommended)

For automatic environment loading when entering the directory:

1. **Install direnv**:
   ```bash
   # macOS
   brew install direnv

   # Linux
   nix-env -i direnv
   # or: apt install direnv / pacman -S direnv / etc.
   ```

2. **Hook into your shell** (add to `~/.bashrc` or `~/.zshrc`):
   ```bash
   eval "$(direnv hook bash)"  # for bash
   eval "$(direnv hook zsh)"   # for zsh
   ```

3. **Allow direnv** in this directory:
   ```bash
   direnv allow
   ```

Now the development environment loads automatically when you `cd` into the project!

## Flake Structure

### Outputs

The flake provides several outputs:

#### Development Shells
```bash
nix develop              # Default dev shell with Zola
```

#### Packages
```bash
nix build                # Build the static site (default)
nix build .#build        # Build without full installation
```

#### Apps
```bash
nix run .#serve          # Serve the site locally
nix run .#build          # Build the site
nix run .#check          # Check content and templates
```

#### Checks (for CI)
```bash
nix flake check          # Run all checks
```

## GitHub Actions Integration

The GitHub Actions workflow uses Nix for reproducible builds:

```yaml
- uses: DeterminateSystems/nix-installer-action@main
- uses: DeterminateSystems/magic-nix-cache-action@main
- run: nix build
```

This ensures:
- ✅ Same Zola version locally and in CI
- ✅ Reproducible builds
- ✅ Faster CI with binary caching
- ✅ Single source of truth (flake.nix)

## Common Commands

### Development
```bash
# Enter dev environment
nix develop

# In dev shell:
zola serve              # Start dev server (http://127.0.0.1:1111)
zola build              # Build static site
zola check              # Verify content
```

### Production Build
```bash
# Build the site
nix build

# Output is in ./result/
ls -la result/

# Serve built site
python -m http.server -d result 8000
```

### Update Dependencies
```bash
# Update flake inputs (updates Zola version)
nix flake update

# Lock specific input
nix flake lock --update-input nixpkgs
```

### Check Everything
```bash
# Run all checks defined in flake
nix flake check

# Show what will be checked
nix flake show
```

## Troubleshooting

### Flakes not enabled
```
error: experimental Nix feature 'nix-command' is disabled
```

**Solution:** Add to `~/.config/nix/nix.conf`:
```
experimental-features = nix-command flakes
```

### Permission denied
```
error: opening lock file '/nix/var/nix/...': Permission denied
```

**Solution:** Install Nix in multi-user mode with `--daemon` or run with sudo:
```bash
sudo nix flake check
```

### Zola version mismatch

**Check version:**
```bash
nix develop -c zola --version
```

**Update to latest:**
```bash
nix flake update
```

## Benefits of Using Nix

1. **Reproducibility**: Same Zola version everywhere (dev, CI, prod)
2. **No system pollution**: Zola installed in isolated environment
3. **Easy updates**: `nix flake update` updates all dependencies
4. **Fast CI**: Binary cache reuses builds across runs
5. **Declarative**: Everything in `flake.nix`
6. **Cross-platform**: Works on Linux, macOS, WSL

## Without Nix

If you don't want to use Nix, you can still:

1. Install Zola manually: https://www.getzola.org/documentation/getting-started/installation/
2. Use the GitHub Actions workflow (it will use Nix internally)
3. Build with Docker (create a Dockerfile if needed)

## Resources

- [Nix Flakes Documentation](https://nixos.wiki/wiki/Flakes)
- [Zola Documentation](https://www.getzola.org/documentation/)
- [nixpkgs Zola Package](https://search.nixos.org/packages?query=zola)

## See Also

- `flake.nix` - Nix flake configuration
- `.envrc` - direnv configuration (auto-loads dev shell)
- `.github/workflows/deploy.yml` - GitHub Actions using Nix

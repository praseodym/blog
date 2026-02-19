# Deployment Guide

This site is built with [Zola](https://www.getzola.org/), a fast static site generator written in Rust.

## Prerequisites

You need to have Zola installed on your system. See [Zola installation instructions](https://www.getzola.org/documentation/getting-started/installation/) for your platform.

### Quick Install

**macOS:**
```bash
brew install zola
```

**Linux:**
```bash
# Download the latest release from GitHub
# Or use snap:
snap install zola --edge
```

**Windows:**
```bash
# Using Scoop:
scoop install zola

# Using Chocolatey:
choco install zola
```

## Local Development

### Building the Site

To build the site locally:

```bash
zola build
```

This will generate the static site in the `public/` directory.

### Testing Locally

To serve the site locally with live reload:

```bash
zola serve
```

By default, the site will be available at `http://127.0.0.1:1111/blog/`. The server will automatically reload when you make changes to content or templates.

Additional serve options:
- `zola serve --open` - Opens the site in your default browser
- `zola serve --port 8080` - Use a different port
- `zola serve --interface 0.0.0.0` - Make the server accessible from other devices on your network

## Deployment

### Automatic Deployment (GitHub Actions)

The site is automatically deployed to GitHub Pages when changes are pushed to the main branch.

The deployment workflow (`.github/workflows/deploy.yml`) performs the following steps:
1. Checks out the repository
2. Installs Zola
3. Builds the site with `zola build`
4. Uploads the `public/` directory as a Pages artifact
5. Deploys to GitHub Pages

### GitHub Pages Setup

To enable GitHub Pages deployment:

1. Go to your repository settings on GitHub
2. Navigate to "Pages" in the sidebar
3. Under "Build and deployment":
   - Source: Select "GitHub Actions"
4. The custom domain should be configured at the repository level if needed

### Manual Deployment

If you need to deploy manually:

1. Build the site:
   ```bash
   zola build
   ```

2. The `public/` directory contains the complete static site

3. Deploy the contents of `public/` to your hosting provider

## Troubleshooting

### Build Failures

If the build fails, check:
- `config.toml` syntax is correct
- All templates exist and have valid syntax
- Content files have valid front matter
- Image and asset paths are correct

### Local Preview Issues

If the local preview doesn't look right:
- Check the `base_url` in `config.toml`
- Ensure all assets are in the `static/` directory
- Clear your browser cache

## Migration Notes

This site was migrated from Jekyll to Zola. Key differences:

- **Configuration**: `config.toml` instead of `_config.yml`
- **Content**: `content/` directory instead of `_posts/`
- **Templates**: `templates/` directory instead of `_layouts/` and `_includes/`
- **Styles**: `sass/` directory (same concept, different location)
- **Static files**: `static/` directory instead of root-level assets
- **Build output**: `public/` directory instead of `_site/`

## Additional Resources

- [Zola Documentation](https://www.getzola.org/documentation/)
- [Zola Themes](https://www.getzola.org/themes/)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)

# 🚀 Robust Ship Template - Setup Guide

This guide walks you through setting up the Robust Ship system for any project type.

## Prerequisites

- **Git** - Version control system
- **At least one of these based on your project:**
  - **Node.js 16+** (for JavaScript/TypeScript projects)
  - **Python 3.8+** (for Python projects)
  - **Go 1.19+** (for Go projects)
  - **Rust/Cargo** (for Rust projects)
  - **PHP 7.4+** (for PHP projects)
  - **Ruby 2.7+** (for Ruby projects)

## Installation

### 1. Copy Template to Your Project

```bash
# Method 1: Clone this repository
git clone https://github.com/petpawlooza/robust-ship-template.git
cp -r robust-ship-template/* /path/to/your/project/
cd /path/to/your/project
rm -rf robust-ship-template

# Method 2: Direct download
curl -sSL https://github.com/petpawlooza/robust-ship-template/archive/main.zip -o template.zip
unzip template.zip && cp -r robust-ship-template-main/* /path/to/your/project/
cd /path/to/your/project
rm -rf template.zip robust-ship-template-main
```

### 2. Run Interactive Setup

```bash
chmod +x setup.sh
./setup.sh
```

The setup script will:
- Auto-detect your project type and configuration
- Ask about your preferred tools and workflows
- Generate a `.ship-config.json` configuration file
- Make `ship.sh` executable
- Provide setup completion summary

### 3. Configuration File

After setup, you'll have a `.ship-config.json` file:

```json
{
  "project": {
    "name": "my-project",
    "type": "react",
    "framework": "vite"
  },
  "packageManager": "npm",
  "commands": {
    "install": "npm ci",
    "build": "npm run build",
    "test": "npm test",
    "lint": "npm run lint",
    "format": "npm run format",
    "typeCheck": "npm run type-check"
  },
  "deployment": {
    "platform": "vercel",
    "prodCommand": "vercel --prod --yes",
    "previewCommand": "vercel --yes"
  },
  "quality": {
    "enforceTypes": true,
    "enforceLinting": true,
    "enforceTests": true,
    "enforceSecurity": true,
    "enforceBuild": true
  }
}
```

## Project-Specific Setup

### React/Vue/Angular Projects

Ensure you have these scripts in `package.json`:

```json
{
  "scripts": {
    "build": "vite build", // or appropriate build command
    "test": "jest", // or your test runner
    "lint": "eslint . --ext .js,.jsx,.ts,.tsx",
    "format": "prettier --write .",
    "type-check": "tsc --noEmit"
  }
}
```

### Python Projects

For **pip** projects, ensure you have:
- `requirements.txt` or `requirements-dev.txt`
- Test configuration (pytest, unittest)

For **poetry** projects:
- `pyproject.toml` with development dependencies
- Configured linting tools (pylint, black, mypy)

### Go Projects

Ensure you have:
- `go.mod` file
- Tests using standard `go test`
- Optional: `.golangci.yml` for advanced linting

### Rust Projects

Ensure you have:
- `Cargo.toml` file
- Tests using `cargo test`
- Optional: `clippy` for linting

## Deployment Platform Setup

### Vercel
1. Install Vercel CLI: `npm i -g vercel`
2. Login: `vercel login`
3. Link project: `vercel link` (optional)

### Netlify
1. Install Netlify CLI: `npm i -g netlify-cli`
2. Login: `netlify login`
3. Link site: `netlify link` (optional)

### Railway
1. Install Railway CLI: `npm i -g @railway/cli`
2. Login: `railway login`
3. Link project: `railway link` (optional)

### GitHub Pages
1. Install gh-pages: `npm i -D gh-pages`
2. Ensure build output goes to `dist` or `build` directory

### Custom Deployment
Configure your own deployment commands in the setup process.

## Environment Variables

Some deployments may require environment variables:

### For Vercel:
```bash
vercel env add VARIABLE_NAME
```

### For Netlify:
```bash
netlify env:set VARIABLE_NAME value
```

### For Railway:
```bash
railway variables set VARIABLE_NAME=value
```

## Verification

Test your setup:

```bash
# Preview what ship.sh would do
./ship.sh --dry-run

# Run with basic checks
./ship.sh --quick "test: verify setup"

# Full quality enforcement
./ship.sh "feat: initial robust ship setup"
```

## Customization

### Adding Custom Commands

Edit `.ship-config.json` to modify commands:

```json
{
  "commands": {
    "install": "yarn install --frozen-lockfile",
    "build": "yarn build && yarn analyze",
    "test": "yarn test --coverage",
    "lint": "yarn lint --fix",
    "format": "yarn prettier --write .",
    "typeCheck": "yarn type-check"
  }
}
```

### Custom Quality Enforcement

Adjust quality settings:

```json
{
  "quality": {
    "enforceTypes": true,      // Fail on TypeScript errors
    "enforceLinting": true,    // Fail on linting errors
    "enforceTests": false,     // Allow test failures
    "enforceSecurity": true,   // Fail on security issues
    "enforceBuild": true       // Fail on build errors
  }
}
```

### Project-Specific Scripts

Add project-specific validation:

1. Create `scripts/custom-checks.sh`
2. Make it executable: `chmod +x scripts/custom-checks.sh`
3. Add to `.ship-config.json`:

```json
{
  "commands": {
    "custom": "scripts/custom-checks.sh"
  }
}
```

## Troubleshooting

### Common Issues

1. **"Configuration file not found"**
   - Run `./setup.sh` first

2. **"Command not found" errors**
   - Ensure required tools are installed
   - Check your PATH

3. **Permission denied on ship.sh**
   - Run: `chmod +x ship.sh`

4. **Build failures**
   - Verify build command works: `npm run build`
   - Check for missing dependencies

5. **Test failures**
   - Verify test command works: `npm test`
   - Consider setting `enforceTests: false` temporarily

### Getting Help

1. Check the configuration: `cat .ship-config.json`
2. Run in debug mode: `./ship.sh --dry-run`
3. Use force mode for emergencies: `./ship.sh --force`
4. Check individual commands manually

## Next Steps

After successful setup:

1. **Read the main [README](../README.md)** for usage examples
2. **Configure your CI/CD** to use robust ship
3. **Train your team** on the new workflow
4. **Customize** the quality checks for your needs
5. **Share** the template with other projects

---

**Need help?** Check the [Troubleshooting Guide](./TROUBLESHOOTING.md) or open an issue.
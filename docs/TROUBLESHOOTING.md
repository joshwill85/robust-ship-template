# 🔧 Troubleshooting Guide

Common issues and solutions when using Robust Ship Template.

## Setup Issues

### "Configuration file not found"

**Problem**: Running `./ship.sh` without configuration.

**Solution**:
```bash
# Run setup first
./setup.sh

# Verify configuration was created
ls -la .ship-config.json
cat .ship-config.json
```

### "Permission denied" on setup.sh or ship.sh

**Problem**: Scripts are not executable.

**Solution**:
```bash
# Make scripts executable
chmod +x setup.sh ship.sh

# Verify permissions
ls -la setup.sh ship.sh
```

### Setup script fails to detect project type

**Problem**: Auto-detection doesn't recognize your project.

**Solution**:
1. Ensure you have project files (`package.json`, `requirements.txt`, etc.)
2. Select "Other" during setup and configure manually
3. Create minimal project files if needed:

```bash
# For Node.js project
echo '{"name": "my-project", "version": "1.0.0"}' > package.json

# For Python project  
echo "# My Python Project" > requirements.txt

# For Go project
go mod init my-project

# For Rust project
cargo init .
```

## Command Issues

### "Command not found" errors

**Problem**: Required tools are not installed or not in PATH.

**Solutions by Project Type**:

**Node.js Projects**:
```bash
# Install Node.js (use version manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install --lts
nvm use --lts

# Install package manager
npm install -g yarn pnpm
```

**Python Projects**:
```bash
# Install Python (use pyenv)
curl https://pyenv.run | bash
pyenv install 3.11.0
pyenv global 3.11.0

# Install package managers
pip install poetry pipenv
```

**Go Projects**:
```bash
# Install Go
wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
```

**Rust Projects**:
```bash
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
```

### Commands fail with unclear errors

**Problem**: Command execution fails without clear reason.

**Debug Steps**:
```bash
# Run commands individually to isolate issue
npm ci
npm run build
npm test
npm run lint

# Check for missing scripts in package.json
cat package.json | grep -A 10 "scripts"

# Verify tools are installed
which node npm yarn
node --version
npm --version
```

## Build Issues

### Build fails with missing dependencies

**Problem**: Dependencies not installed or outdated.

**Solution**:
```bash
# Clean install
rm -rf node_modules package-lock.json yarn.lock
npm install
# or
yarn install --frozen-lockfile

# For Python
pip install -r requirements.txt
# or
poetry install
```

### TypeScript compilation errors

**Problem**: Type errors blocking build.

**Solutions**:
```bash
# Check TypeScript configuration
cat tsconfig.json

# Fix common issues manually
npx tsc --noEmit

# Allow errors temporarily (not recommended)
# Edit .ship-config.json:
{
  "quality": {
    "enforceTypes": false
  }
}
```

### Build runs out of memory

**Problem**: Large projects fail with memory errors.

**Solution**:
```bash
# Increase Node.js memory limit
NODE_OPTIONS="--max-old-space-size=4096" npm run build

# Or permanently in package.json:
{
  "scripts": {
    "build": "NODE_OPTIONS=\"--max-old-space-size=4096\" vite build"
  }
}
```

## Test Issues

### Tests fail unexpectedly

**Problem**: Tests pass locally but fail in Robust Ship.

**Solutions**:
```bash
# Run tests manually first
npm test

# Check test environment
NODE_ENV=test npm test

# Run specific test files
npm test -- --verbose
npm test -- src/components/Button.test.js

# Check for environment dependencies
# (database connections, external services)
```

### No tests configured

**Problem**: Test command not set up properly.

**Solution**:
```bash
# Add test script to package.json
{
  "scripts": {
    "test": "jest",
    "test": "vitest",
    "test": "react-scripts test"
  }
}

# Or disable test enforcement temporarily
# Edit .ship-config.json:
{
  "quality": {
    "enforceTests": false
  }
}
```

## Linting Issues

### ESLint configuration conflicts

**Problem**: Linting fails with configuration errors.

**Solutions**:
```bash
# Check ESLint configuration
cat .eslintrc.js
cat eslint.config.js

# Fix configuration file
npx eslint --init

# Run ESLint manually
npx eslint . --ext .js,.jsx,.ts,.tsx

# Auto-fix common issues
npx eslint . --ext .js,.jsx,.ts,.tsx --fix
```

### Prettier conflicts with ESLint

**Problem**: Formatting and linting rules conflict.

**Solution**:
```bash
# Install compatibility packages
npm install --save-dev eslint-config-prettier eslint-plugin-prettier

# Update .eslintrc.js
{
  "extends": ["prettier"],
  "plugins": ["prettier"],
  "rules": {
    "prettier/prettier": "error"
  }
}
```

## Deployment Issues

### Vercel deployment fails

**Problem**: Vercel CLI not working or authentication issues.

**Solutions**:
```bash
# Install/update Vercel CLI
npm install -g vercel@latest

# Login to Vercel
vercel login

# Test deployment manually
vercel --version
vercel

# Check project configuration
cat vercel.json
```

### Netlify deployment fails

**Problem**: Netlify CLI issues or build failures.

**Solutions**:
```bash
# Install/update Netlify CLI
npm install -g netlify-cli@latest

# Login to Netlify
netlify login

# Test deployment manually
netlify --version
netlify deploy

# Check build settings
cat netlify.toml
```

### Environment variables missing in deployment

**Problem**: App works locally but fails in deployment.

**Solutions**:
```bash
# Set environment variables in deployment platform
vercel env add NODE_ENV
netlify env:set NODE_ENV production

# Check local environment
cat .env
cat .env.local

# Verify variables in build logs
```

## Git Issues

### Git push fails

**Problem**: Unable to push to remote repository.

**Solutions**:
```bash
# Check git status
git status
git remote -v

# Check authentication
git config user.name
git config user.email

# Force push if needed (dangerous)
git push --force-with-lease

# Or skip git push temporarily
./ship.sh --no-push
```

### Git repository not initialized

**Problem**: Not in a git repository.

**Solution**:
```bash
# Initialize git repository
git init
git add .
git commit -m "Initial commit"

# Add remote if needed
git remote add origin https://github.com/username/repo.git
```

### Large files or secrets detected

**Problem**: Git blocks commits due to large files or secrets.

**Solutions**:
```bash
# Remove large files
find . -size +100M -name "*.zip" -name "*.tar.gz" -delete

# Use Git LFS for large files
git lfs install
git lfs track "*.zip"
git add .gitattributes

# Remove secrets from code
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch secrets.env'
```

## Performance Issues

### Ship.sh runs too slowly

**Problem**: Quality checks take too long.

**Solutions**:
```bash
# Use quick mode for faster shipping
./ship.sh --quick

# Skip specific checks temporarily
# Edit .ship-config.json to disable slow checks

# Parallelize tests
npm test -- --maxWorkers=4

# Use incremental builds
# Configure your build tool for incremental compilation
```

### Memory usage too high

**Problem**: System runs out of memory during shipping.

**Solutions**:
```bash
# Close other applications
# Increase swap space on Linux
# Use smaller batch sizes for processing

# For Node.js increase memory
export NODE_OPTIONS="--max-old-space-size=4096"
```

## Emergency Procedures

### Critical production fix needed

**Problem**: Need to ship urgently despite quality issues.

**Solutions**:
```bash
# Force mode (use with extreme caution)
./ship.sh --force "emergency: critical production fix"

# Quick mode for hotfixes
./ship.sh --quick "hotfix: urgent security patch"

# Skip problematic checks temporarily
./ship.sh --loose "hotfix: urgent fix"

# Direct deployment bypass
git add .
git commit -m "emergency: critical fix"
git push
# Deploy manually with platform CLI
```

### Configuration completely broken

**Problem**: Can't run ship.sh at all due to config issues.

**Solutions**:
```bash
# Reset configuration
rm .ship-config.json
./setup.sh

# Use template configuration
curl -sSL https://raw.githubusercontent.com/joshwill85/robust-ship-template/main/examples/react-vite/.ship-config.json > .ship-config.json

# Manual minimal configuration
echo '{
  "project": {"name": "my-project", "type": "other", "framework": "other"},
  "packageManager": "npm",
  "commands": {
    "install": "echo skip",
    "build": "echo skip", 
    "test": "echo skip",
    "lint": "echo skip",
    "format": "echo skip",
    "typeCheck": "echo skip"
  },
  "deployment": {
    "platform": "None",
    "prodCommand": "echo skip",
    "previewCommand": "echo skip"
  },
  "quality": {
    "enforceTypes": false,
    "enforceLinting": false,
    "enforceTests": false,
    "enforceSecurity": false,
    "enforceBuild": false
  }
}' > .ship-config.json
```

## Getting Help

### Debug Information to Collect

When seeking help, collect this information:

```bash
# System information
uname -a
node --version
npm --version
git --version

# Project information
cat package.json
cat .ship-config.json
ls -la

# Recent errors
./ship.sh --dry-run 2>&1 | tail -50

# Git status
git status
git log --oneline -5
```

### Where to Get Help

1. **GitHub Issues**: [Report bugs and issues](https://github.com/joshwill85/robust-ship-template/issues)
2. **Discussions**: [Ask questions and share ideas](https://github.com/joshwill85/robust-ship-template/discussions)
3. **Documentation**: Review all docs in the `/docs` folder
4. **Examples**: Check `/examples` for working configurations

### Creating Good Issue Reports

Include in your issue report:
- **Operating System**: macOS, Linux distribution, Windows
- **Project Type**: React, Python, Go, etc.
- **Error Messages**: Full error output
- **Configuration**: Your `.ship-config.json` file
- **Steps to Reproduce**: Exact commands that cause the issue
- **Expected vs Actual**: What you expected to happen vs what happened

## Prevention

### Best Practices to Avoid Issues

1. **Test commands individually** before using ship.sh
2. **Keep dependencies up to date** regularly
3. **Use version managers** for Node.js, Python, etc.
4. **Commit frequently** to avoid large changesets
5. **Monitor build times** and optimize slow steps
6. **Document custom configurations** for your team
7. **Test in clean environments** periodically

### Regular Maintenance

```bash
# Weekly maintenance
npm audit fix
npm update
./ship.sh --dry-run

# Monthly maintenance  
npm outdated
git gc
./setup.sh  # Review configuration
```
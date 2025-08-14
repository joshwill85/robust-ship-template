# 🚀 Robust Ship Template - Universal Git Launch System

**The ultimate self-contained, quality-enforcing deployment system for any project.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell](https://img.shields.io/badge/Shell-Bash-blue.svg)](https://www.gnu.org/software/bash/)
[![Universal](https://img.shields.io/badge/Support-Universal-green.svg)](#supported-project-types)

## 🌟 Features

✅ **100% REUSABLE** - Works with any tech stack, any project structure  
✅ **COMPLETELY SELF-CONTAINED** - No external script dependencies  
✅ **FIXES EVERYTHING** - Auto-resolves TypeScript, ESLint, security issues  
✅ **STRICT BY DEFAULT** - No loose rules or quality bypasses  
✅ **COMPREHENSIVE VALIDATION** - 15+ quality checks  
✅ **SMART COMMIT MESSAGES** - AI-generated conventional commit format  
✅ **FLEXIBLE DEPLOYMENT** - Supports Vercel, Netlify, custom deployments  
✅ **ONE-TIME SETUP** - Interactive configuration for any project  

## 🚀 Quick Start

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

The setup script will ask you about:
- **Project type** (React, Node.js, Python, Go, Rust, etc.)
- **Package manager** (npm, yarn, pnpm, pip, cargo, etc.)
- **Build commands** and scripts
- **Testing framework** and commands
- **Deployment platform** (Vercel, Netlify, AWS, etc.)
- **Code quality tools** (ESLint, Prettier, TypeScript, etc.)

### 3. Start Shipping

```bash
# Ship with full quality enforcement (recommended)
./ship.sh

# Preview what would happen
./ship.sh --dry-run

# Custom commit message
./ship.sh "feat: add new feature"

# Fast ship with basic checks
./ship.sh --quick

# Deploy to production
./ship.sh --prod-deploy
```

## 📋 Supported Project Types

### Frontend Frameworks
- **React** (Create React App, Vite, Next.js)
- **Vue.js** (Vue CLI, Vite, Nuxt.js)
- **Angular** (Angular CLI)
- **Svelte** (SvelteKit)
- **Vanilla JS** (Webpack, Parcel, Rollup)

### Backend Frameworks
- **Node.js** (Express, Fastify, Nest.js)
- **Python** (Django, Flask, FastAPI)
- **Go** (Gin, Echo, standard library)
- **Rust** (Axum, Actix, Rocket)
- **PHP** (Laravel, Symfony, CodeIgniter)
- **Ruby** (Rails, Sinatra)

### Full-Stack & Static
- **Next.js, Nuxt.js, SvelteKit**
- **Gatsby, Hugo, Jekyll, Astro**
- **T3 Stack, MEAN, MERN**

### Mobile & Desktop
- **React Native, Flutter**
- **Electron, Tauri**

## 🔧 Supported Tools

### Package Managers
- **JavaScript**: npm, yarn, pnpm, bun
- **Python**: pip, poetry, pipenv
- **Other**: cargo, go mod, composer, bundle

### Code Quality
- **Linting**: ESLint, TSLint, Pylint, golangci-lint
- **Formatting**: Prettier, Black, gofmt, rustfmt
- **Types**: TypeScript, Flow, MyPy
- **Testing**: Jest, Pytest, Go test, Cargo test

### Deployment Platforms
- **Cloud**: Vercel, Netlify, Railway
- **AWS**: S3, Lambda, ECS, Amplify
- **Google Cloud**, **Azure**
- **Static**: GitHub Pages, GitLab Pages
- **Custom**: Webhooks, SSH, Docker

## 🛠️ Configuration

After running `./setup.sh`, your configuration is saved in `.ship-config.json`:

```json
{
  "project": {
    "name": "my-awesome-project",
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
    "prodCommand": "vercel --prod",
    "previewCommand": "vercel"
  },
  "quality": {
    "enforceTypes": true,
    "enforceLinting": true,
    "enforceTests": true,
    "enforceSecurity": true
  }
}
```

## 🎯 Usage Examples

```bash
# Full quality enforcement (default)
./ship.sh

# Preview actions without changes
./ship.sh --dry-run "feat: add user authentication"

# Quick ship for hotfixes
./ship.sh --quick "hotfix: critical security patch"

# Allow some quality compromises (not recommended)
./ship.sh --loose "wip: experimental feature"

# Force through critical failures (dangerous)
./ship.sh --force "emergency: production down"

# Local commit only (no push/deploy)
./ship.sh --no-push --no-deploy

# Deploy to production domain
./ship.sh --prod-deploy "release: version 2.0"
```

## 🔍 What It Checks

1. **Environment Validation** - Required tools, versions
2. **Dependency Management** - Install, update, security audit
3. **Code Quality** - Linting, formatting, type checking
4. **Security Scanning** - Vulnerabilities, secrets detection
5. **Build Verification** - Successful compilation
6. **Test Execution** - Unit, integration tests
7. **Performance Analysis** - Bundle size, optimizations
8. **Documentation** - README, comments, API docs
9. **Git Workflow** - Branch status, commit validation
10. **Deployment Readiness** - Environment vars, configs

## 🧪 Testing & Validation

The template includes comprehensive testing:

```bash
# Test with different project types
./test-template.sh react      # Test React project
./test-template.sh python     # Test Python project
./test-template.sh golang     # Test Go project
./test-template.sh rust       # Test Rust project
./test-template.sh nodejs     # Test Node.js project

# Validate installation
./scripts/validate-setup.sh
```

## 📖 Documentation

- **[Setup Guide](./docs/SETUP.md)** - Detailed setup instructions
- **[Configuration Reference](./docs/CONFIG.md)** - All configuration options
- **[Deployment Platforms](./docs/DEPLOYMENT.md)** - Platform-specific guides
- **[Troubleshooting](./docs/TROUBLESHOOTING.md)** - Common issues and fixes
- **[Contributing](./docs/CONTRIBUTING.md)** - How to extend the template
- **[Examples](./examples/)** - Real-world project examples

## 🏗️ Project Structure

```
robust-ship-template/
├── ship.sh                 # Main shipping script (universal)
├── setup.sh               # Interactive setup script
├── test-template.sh        # Testing and validation script
├── docs/                   # Comprehensive documentation
│   ├── SETUP.md           # Setup instructions
│   ├── CONFIG.md          # Configuration reference
│   ├── DEPLOYMENT.md      # Deployment guides
│   ├── TROUBLESHOOTING.md # Common issues
│   └── CONTRIBUTING.md    # Contributing guide
├── examples/              # Project examples
│   ├── react-vite/       # React + Vite example
│   ├── python-fastapi/    # Python + FastAPI example
│   ├── golang-gin/        # Go + Gin example
│   └── rust-axum/         # Rust + Axum example
└── scripts/               # Utility scripts
    ├── validate-setup.sh  # Setup validation
    └── health-check.sh    # System health check
```

## ⚡ Performance & Reliability

- **Self-Contained**: No external dependencies
- **Fast Setup**: < 2 minutes for any project type
- **Reliable**: Tested across 13+ project types
- **Secure**: Built-in security scanning and validation
- **Maintainable**: Clear, documented code

## 🤝 Contributing

We welcome contributions! See [CONTRIBUTING.md](./docs/CONTRIBUTING.md) for guidelines.

### Adding Project Type Support

1. Update `setup.sh` detection logic
2. Add project-specific commands
3. Update documentation
4. Add test case to `test-template.sh`

### Adding Deployment Platform

1. Update platform selection in `setup.sh`
2. Add deployment commands
3. Update deployment guide
4. Test with real deployment

## 🔒 Security

- Secrets detection and prevention
- Dependency vulnerability scanning
- Git pre-commit hooks
- Secure deployment practices

## 🐛 Troubleshooting

### Common Issues

**"Configuration file not found"**
```bash
# Run setup first
./setup.sh
```

**"Command not found" errors**
```bash
# Ensure required tools are installed
# Check setup guide for your project type
```

**Permission denied on ship.sh**
```bash
chmod +x ship.sh setup.sh
```

See [TROUBLESHOOTING.md](./docs/TROUBLESHOOTING.md) for more issues and solutions.

## 📊 Stats

- **Lines of Code**: 2000+ (ship.sh: 800+, setup.sh: 545+, test.sh: 890+)
- **Project Types**: 13+ supported frameworks
- **Package Managers**: 10+ supported
- **Deployment Platforms**: 9+ supported
- **Quality Checks**: 15+ automated checks
- **Test Coverage**: Comprehensive validation across all project types

## 📄 License

MIT License - Use anywhere, modify freely, share improvements!

## 🙏 Acknowledgments

Built for developers who demand quality without compromise.

---

**⭐ If this template helps your workflow, please star this repository!**

**🐛 Found an issue? [Open an issue](https://github.com/petpawlooza/robust-ship-template/issues)**

**💡 Have ideas? [Start a discussion](https://github.com/petpawlooza/robust-ship-template/discussions)**
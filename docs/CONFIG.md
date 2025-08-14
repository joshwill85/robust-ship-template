# 📋 Configuration Reference

Complete reference for configuring Robust Ship Template for your project.

## Configuration File Structure

The `.ship-config.json` file contains all configuration for your project:

```json
{
  "project": {
    "name": "string",
    "type": "string",
    "framework": "string"
  },
  "packageManager": "string",
  "commands": {
    "install": "string",
    "build": "string",
    "test": "string",
    "lint": "string",
    "format": "string",
    "typeCheck": "string"
  },
  "deployment": {
    "platform": "string",
    "prodCommand": "string",
    "previewCommand": "string"
  },
  "quality": {
    "enforceTypes": boolean,
    "enforceLinting": boolean,
    "enforceTests": boolean,
    "enforceSecurity": boolean,
    "enforceBuild": boolean
  },
  "setupVersion": "string",
  "setupDate": "string"
}
```

## Project Configuration

### `project.name`
- **Type**: `string`
- **Description**: Human-readable name of your project
- **Example**: `"my-awesome-app"`

### `project.type`
- **Type**: `string`
- **Required**: Yes
- **Description**: Primary project type/language
- **Valid Values**: 
  - `"react"` - React applications
  - `"vue"` - Vue.js applications  
  - `"angular"` - Angular applications
  - `"svelte"` - Svelte applications
  - `"nextjs"` - Next.js applications
  - `"nuxtjs"` - Nuxt.js applications
  - `"nodejs"` - Node.js backend applications
  - `"python"` - Python applications
  - `"golang"` - Go applications
  - `"rust"` - Rust applications
  - `"php"` - PHP applications
  - `"ruby"` - Ruby applications
  - `"static"` - Static site projects
  - `"other"` - Custom project type

### `project.framework`
- **Type**: `string`
- **Description**: Specific framework or build tool
- **Examples**: `"vite"`, `"cra"`, `"nextjs"`, `"django"`, `"flask"`

## Package Manager

### `packageManager`
- **Type**: `string`
- **Required**: Yes
- **Description**: Package manager command to use
- **Valid Values**:
  - **JavaScript/TypeScript**: `"npm"`, `"yarn"`, `"pnpm"`, `"bun"`
  - **Python**: `"pip"`, `"poetry"`, `"pipenv"`
  - **Other**: `"go"`, `"cargo"`, `"composer"`, `"bundle"`

## Commands Configuration

All commands are shell commands that will be executed by Robust Ship.

### `commands.install`
- **Type**: `string`
- **Description**: Command to install dependencies
- **Examples**:
  ```json
  "npm ci"                    // npm (production)
  "yarn install --frozen-lockfile"  // yarn (production)
  "pip install -r requirements.txt" // Python pip
  "poetry install"            // Python poetry
  "go mod download"           // Go
  "cargo fetch"               // Rust
  ```

### `commands.build`
- **Type**: `string`
- **Description**: Command to build the project
- **Examples**:
  ```json
  "npm run build"             // JavaScript/TypeScript
  "cargo build --release"     // Rust
  "go build ./..."            // Go
  "echo 'No build required'"  // Skip build step
  ```

### `commands.test`
- **Type**: `string`
- **Description**: Command to run tests
- **Examples**:
  ```json
  "npm test"                  // JavaScript/TypeScript
  "python -m pytest"         // Python
  "go test ./..."             // Go
  "cargo test"                // Rust
  "echo 'No tests configured'" // Skip tests
  ```

### `commands.lint`
- **Type**: `string`
- **Description**: Command to run linting
- **Examples**:
  ```json
  "eslint . --ext .js,.jsx,.ts,.tsx"  // ESLint
  "pylint src/"                       // Python
  "golangci-lint run"                 // Go
  "cargo clippy"                      // Rust
  ```

### `commands.format`
- **Type**: `string`
- **Description**: Command to format code
- **Examples**:
  ```json
  "prettier --write ."        // Prettier
  "black src/"                // Python Black
  "gofmt -w ."                // Go fmt
  "cargo fmt"                 // Rust fmt
  ```

### `commands.typeCheck`
- **Type**: `string`
- **Description**: Command to run type checking
- **Examples**:
  ```json
  "tsc --noEmit"              // TypeScript
  "mypy src/"                 // Python mypy
  "go vet ./..."              // Go vet
  "cargo check"               // Rust check
  ```

## Deployment Configuration

### `deployment.platform`
- **Type**: `string`
- **Description**: Deployment platform name
- **Valid Values**: `"Vercel"`, `"Netlify"`, `"Railway"`, `"AWS"`, `"GitHub Pages"`, `"Custom Script"`, `"None"`

### `deployment.prodCommand`
- **Type**: `string`
- **Description**: Command to deploy to production
- **Examples**:
  ```json
  "vercel --prod --yes"       // Vercel production
  "netlify deploy --prod"     // Netlify production
  "railway deploy"            // Railway
  "gh-pages -d dist"          // GitHub Pages
  "echo 'No deployment'"      // Skip deployment
  ```

### `deployment.previewCommand`
- **Type**: `string`
- **Description**: Command to deploy preview/staging
- **Examples**:
  ```json
  "vercel --yes"              // Vercel preview
  "netlify deploy"            // Netlify preview
  "railway deploy"            // Railway
  ```

## Quality Enforcement

Controls which quality checks are enforced (cause failure) vs. advisory (warnings only).

### `quality.enforceTypes`
- **Type**: `boolean`
- **Default**: `true`
- **Description**: Fail if type checking fails
- **Use Case**: Set to `false` for gradual TypeScript adoption

### `quality.enforceLinting`
- **Type**: `boolean`
- **Default**: `true`
- **Description**: Fail if linting fails
- **Use Case**: Set to `false` to allow warnings

### `quality.enforceTests`
- **Type**: `boolean`
- **Default**: `true`
- **Description**: Fail if tests fail
- **Use Case**: Set to `false` for WIP features

### `quality.enforceSecurity`
- **Type**: `boolean`
- **Default**: `true`
- **Description**: Fail if security audit fails
- **Use Case**: Set to `false` for non-production environments

### `quality.enforceBuild`
- **Type**: `boolean`
- **Default**: `true`
- **Description**: Fail if build fails
- **Use Case**: Should almost always be `true`

## Example Configurations

### React + Vite + npm
```json
{
  "project": {
    "name": "react-vite-app",
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
    "platform": "Vercel",
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

### Python + Poetry + Django
```json
{
  "project": {
    "name": "django-api",
    "type": "python",
    "framework": "django"
  },
  "packageManager": "poetry",
  "commands": {
    "install": "poetry install",
    "build": "echo 'Python: No build step required'",
    "test": "poetry run pytest",
    "lint": "poetry run pylint src/",
    "format": "poetry run black src/",
    "typeCheck": "poetry run mypy src/"
  },
  "deployment": {
    "platform": "Railway",
    "prodCommand": "railway deploy",
    "previewCommand": "railway deploy"
  },
  "quality": {
    "enforceTypes": true,
    "enforceLinting": true,
    "enforceTests": true,
    "enforceSecurity": true,
    "enforceBuild": false
  }
}
```

### Go + Standard Tools
```json
{
  "project": {
    "name": "go-api",
    "type": "golang",
    "framework": "golang"
  },
  "packageManager": "go",
  "commands": {
    "install": "go mod download",
    "build": "go build ./...",
    "test": "go test ./...",
    "lint": "golangci-lint run",
    "format": "gofmt -w .",
    "typeCheck": "go vet ./..."
  },
  "deployment": {
    "platform": "Railway",
    "prodCommand": "railway deploy",
    "previewCommand": "railway deploy"
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

### Rust + Cargo
```json
{
  "project": {
    "name": "rust-api",
    "type": "rust",
    "framework": "rust"
  },
  "packageManager": "cargo",
  "commands": {
    "install": "cargo fetch",
    "build": "cargo build --release",
    "test": "cargo test",
    "lint": "cargo clippy",
    "format": "cargo fmt",
    "typeCheck": "cargo check"
  },
  "deployment": {
    "platform": "Railway",
    "prodCommand": "railway deploy",
    "previewCommand": "railway deploy"
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

## Advanced Configuration

### Custom Commands

You can add custom commands for specific workflows:

```json
{
  "commands": {
    "install": "npm ci",
    "build": "npm run build",
    "test": "npm test",
    "lint": "npm run lint && npm run lint:css",
    "format": "npm run prettier && npm run format:css",
    "typeCheck": "npm run type-check",
    "customCheck": "./scripts/custom-validation.sh"
  }
}
```

### Environment-Specific Commands

Use shell conditionals for environment-specific behavior:

```json
{
  "commands": {
    "build": "NODE_ENV=production npm run build",
    "test": "NODE_ENV=test npm test",
    "deploy": "if [ \"$ENVIRONMENT\" = \"production\" ]; then vercel --prod; else vercel; fi"
  }
}
```

### Complex Deployment

Chain multiple deployment steps:

```json
{
  "deployment": {
    "platform": "Custom Script",
    "prodCommand": "npm run build && aws s3 sync dist/ s3://my-bucket --delete && aws cloudfront create-invalidation --distribution-id ABCD1234",
    "previewCommand": "npm run build && aws s3 sync dist/ s3://my-staging-bucket --delete"
  }
}
```

## Configuration Validation

Robust Ship validates your configuration on startup:

- **Required fields**: `project.type`, `packageManager`
- **Command validation**: Checks that commands are executable
- **Platform validation**: Warns about missing deployment tools

## Updating Configuration

To update your configuration:

1. Edit `.ship-config.json` manually, or
2. Run `./setup.sh` again to reconfigure interactively

## Best Practices

1. **Keep commands simple**: Complex logic belongs in scripts
2. **Use absolute paths**: When referencing custom scripts
3. **Test commands individually**: Ensure each command works standalone
4. **Version control**: Consider adding `.ship-config.json` to git
5. **Environment variables**: Use env vars for secrets and environment-specific values

## Troubleshooting Configuration

### Configuration Not Found
```bash
# Run setup to create configuration
./setup.sh
```

### Invalid JSON
```bash
# Validate JSON syntax
node -e "JSON.parse(require('fs').readFileSync('.ship-config.json', 'utf8'))"
```

### Command Failures
```bash
# Test individual commands
npm run build
npm test
npm run lint
```

### Deployment Issues
```bash
# Test deployment commands manually
vercel --version
netlify --version
```
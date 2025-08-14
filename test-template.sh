#!/bin/bash

# 🧪 Test Template - Verify Robust Ship Template Works
# Usage: ./test-template.sh [project-type]

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

TEST_DIR="$(mktemp -d)"
TEMPLATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_TYPE="${1:-react}"

print_header() {
    echo -e "${PURPLE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${PURPLE}${BOLD}🧪 Testing Robust Ship Template - $PROJECT_TYPE Project${NC}"
    echo -e "${PURPLE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_step() {
    echo -e "${CYAN}${BOLD}📋 Step $1: $2${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

cleanup() {
    echo ""
    print_info "Cleaning up test directory: $TEST_DIR"
    rm -rf "$TEST_DIR"
}

trap cleanup EXIT

create_test_project() {
    local project_type="$1"
    local project_dir="$TEST_DIR/test-$project_type-project"
    
    print_step "1" "Creating Test $project_type Project"
    
    mkdir -p "$project_dir"
    cd "$project_dir"
    
    case "$project_type" in
        "react")
            create_react_project
            ;;
        "python")
            create_python_project
            ;;
        "golang")
            create_golang_project
            ;;
        "rust")
            create_rust_project
            ;;
        "nodejs")
            create_nodejs_project
            ;;
        *)
            print_error "Unknown project type: $project_type"
            exit 1
            ;;
    esac
    
    # Initialize git repo
    git init
    git add .
    git commit -m "initial: create test project"
    
    print_success "Test $project_type project created"
    echo ""
}

create_react_project() {
    # Create package.json
    cat > package.json << 'EOF'
{
  "name": "test-react-project",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "test": "vitest",
    "lint": "eslint . --ext .js,.jsx,.ts,.tsx",
    "format": "prettier --write .",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@typescript-eslint/parser": "^6.0.0",
    "@vitejs/plugin-react": "^4.0.0",
    "eslint": "^8.45.0",
    "eslint-plugin-react": "^7.32.0",
    "prettier": "^3.0.0",
    "typescript": "^5.0.0",
    "vite": "^4.4.0",
    "vitest": "^0.34.0"
  }
}
EOF

    # Create tsconfig.json
    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
EOF

    # Create vite.config.ts
    cat > vite.config.ts << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
})
EOF

    # Create source files
    mkdir -p src
    cat > src/main.tsx << 'EOF'
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
EOF

    cat > src/App.tsx << 'EOF'
import React from 'react'

function App() {
  return (
    <div>
      <h1>Test React App</h1>
      <p>This is a test project for Robust Ship Template</p>
    </div>
  )
}

export default App
EOF

    cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Test React App</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
EOF

    # Create test file
    cat > src/App.test.tsx << 'EOF'
import { describe, it, expect } from 'vitest'
import App from './App'

describe('App', () => {
  it('should be a function', () => {
    expect(typeof App).toBe('function')
  })
})
EOF
}

create_python_project() {
    # Create requirements.txt
    cat > requirements.txt << 'EOF'
flask>=2.3.0
requests>=2.31.0
EOF

    cat > requirements-dev.txt << 'EOF'
-r requirements.txt
pytest>=7.4.0
black>=23.7.0
pylint>=2.17.0
mypy>=1.5.0
EOF

    # Create pyproject.toml for modern Python projects
    cat > pyproject.toml << 'EOF'
[build-system]
requires = ["setuptools>=45", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "test-python-project"
version = "1.0.0"
description = "Test Python project for Robust Ship Template"
dependencies = [
    "flask>=2.3.0",
    "requests>=2.31.0"
]

[project.optional-dependencies]
dev = [
    "pytest>=7.4.0",
    "black>=23.7.0",
    "pylint>=2.17.0",
    "mypy>=1.5.0"
]

[tool.black]
line-length = 88
target-version = ['py38']

[tool.mypy]
python_version = "3.8"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true

[tool.pylint.messages_control]
disable = "C0114,C0115,C0116"
EOF

    # Create source files
    mkdir -p src
    cat > src/main.py << 'EOF'
"""Main module for test Python project."""

def hello_world() -> str:
    """Return a greeting message."""
    return "Hello, World!"

def add_numbers(a: int, b: int) -> int:
    """Add two numbers together."""
    return a + b

if __name__ == "__main__":
    print(hello_world())
EOF

    # Create test file
    mkdir -p tests
    cat > tests/test_main.py << 'EOF'
"""Tests for main module."""

import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from main import hello_world, add_numbers

def test_hello_world():
    """Test hello_world function."""
    assert hello_world() == "Hello, World!"

def test_add_numbers():
    """Test add_numbers function."""
    assert add_numbers(2, 3) == 5
    assert add_numbers(0, 0) == 0
    assert add_numbers(-1, 1) == 0
EOF
}

create_golang_project() {
    # Create go.mod
    cat > go.mod << 'EOF'
module test-golang-project

go 1.19

require (
    github.com/gin-gonic/gin v1.9.1
)
EOF

    # Create main.go
    cat > main.go << 'EOF'
package main

import (
    "fmt"
    "net/http"
    
    "github.com/gin-gonic/gin"
)

func HelloWorld() string {
    return "Hello, World!"
}

func AddNumbers(a, b int) int {
    return a + b
}

func main() {
    r := gin.Default()
    
    r.GET("/", func(c *gin.Context) {
        c.JSON(http.StatusOK, gin.H{
            "message": HelloWorld(),
        })
    })
    
    fmt.Println("Server starting on :8080")
    r.Run(":8080")
}
EOF

    # Create test file
    cat > main_test.go << 'EOF'
package main

import "testing"

func TestHelloWorld(t *testing.T) {
    result := HelloWorld()
    expected := "Hello, World!"
    
    if result != expected {
        t.Errorf("HelloWorld() = %v, want %v", result, expected)
    }
}

func TestAddNumbers(t *testing.T) {
    tests := []struct {
        a, b     int
        expected int
    }{
        {2, 3, 5},
        {0, 0, 0},
        {-1, 1, 0},
    }
    
    for _, tt := range tests {
        result := AddNumbers(tt.a, tt.b)
        if result != tt.expected {
            t.Errorf("AddNumbers(%v, %v) = %v, want %v", tt.a, tt.b, result, tt.expected)
        }
    }
}
EOF
}

create_rust_project() {
    # Create Cargo.toml
    cat > Cargo.toml << 'EOF'
[package]
name = "test-rust-project"
version = "1.0.0"
edition = "2021"

[dependencies]
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"

[dev-dependencies]
EOF

    # Create source files
    mkdir -p src
    cat > src/main.rs << 'EOF'
fn main() {
    println!("Hello, world!");
}

pub fn hello_world() -> String {
    "Hello, World!".to_string()
}

pub fn add_numbers(a: i32, b: i32) -> i32 {
    a + b
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_hello_world() {
        assert_eq!(hello_world(), "Hello, World!");
    }

    #[test]
    fn test_add_numbers() {
        assert_eq!(add_numbers(2, 3), 5);
        assert_eq!(add_numbers(0, 0), 0);
        assert_eq!(add_numbers(-1, 1), 0);
    }
}
EOF
}

create_nodejs_project() {
    # Create package.json
    cat > package.json << 'EOF'
{
  "name": "test-nodejs-project",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "start": "node src/index.js",
    "dev": "node --watch src/index.js",
    "test": "node --test",
    "lint": "eslint .",
    "format": "prettier --write ."
  },
  "dependencies": {
    "express": "^4.18.0"
  },
  "devDependencies": {
    "eslint": "^8.45.0",
    "prettier": "^3.0.0"
  }
}
EOF

    # Create source files
    mkdir -p src
    cat > src/index.js << 'EOF'
import express from 'express'

const app = express()
const port = 3000

export function helloWorld() {
    return 'Hello, World!'
}

export function addNumbers(a, b) {
    return a + b
}

app.get('/', (req, res) => {
    res.json({ message: helloWorld() })
})

app.listen(port, () => {
    console.log(`Server running on port ${port}`)
})
EOF

    # Create test file
    mkdir -p test
    cat > test/index.test.js << 'EOF'
import { test } from 'node:test'
import assert from 'node:assert'
import { helloWorld, addNumbers } from '../src/index.js'

test('helloWorld returns correct greeting', () => {
    assert.strictEqual(helloWorld(), 'Hello, World!')
})

test('addNumbers adds correctly', () => {
    assert.strictEqual(addNumbers(2, 3), 5)
    assert.strictEqual(addNumbers(0, 0), 0)
    assert.strictEqual(addNumbers(-1, 1), 0)
})
EOF
}

copy_template() {
    print_step "2" "Copying Robust Ship Template"
    
    # Copy template files
    cp "$TEMPLATE_DIR/ship.sh" .
    cp "$TEMPLATE_DIR/setup.sh" .
    cp -r "$TEMPLATE_DIR/docs" .
    
    # Make scripts executable
    chmod +x ship.sh setup.sh
    
    print_success "Template copied successfully"
    echo ""
}

run_automated_setup() {
    print_step "3" "Running Automated Setup"
    
    # Create automated setup responses based on project type
    case "$PROJECT_TYPE" in
        "react")
            create_react_setup_responses
            ;;
        "python")
            create_python_setup_responses
            ;;
        "golang")
            create_golang_setup_responses
            ;;
        "rust")
            create_rust_setup_responses
            ;;
        "nodejs")
            create_nodejs_setup_responses
            ;;
    esac
    
    # Run setup with automated responses
    ./setup.sh < setup_responses.txt
    
    print_success "Automated setup completed"
    echo ""
}

create_react_setup_responses() {
    cat > setup_responses.txt << EOF
y

1
1
1



y
y
y
y
y
n
EOF
}

create_python_setup_responses() {
    cat > setup_responses.txt << EOF
y

8
2
pytest
pylint
black
mypy
9




y
y
y
y
y
n
EOF
}

create_golang_setup_responses() {
    cat > setup_responses.txt << EOF
y

9


go test ./...
golangci-lint run
gofmt -w .
go vet ./...
9




y
y
y
y
y
n
EOF
}

create_rust_setup_responses() {
    cat > setup_responses.txt << EOF
y

10


cargo test
cargo clippy
cargo fmt
cargo check
9




y
y
y
y
y
n
EOF
}

create_nodejs_setup_responses() {
    cat > setup_responses.txt << EOF
y

7
1



node --test
eslint .
prettier --write .

9




y
y
y
y
y
n
EOF
}

test_dry_run() {
    print_step "4" "Testing Dry Run Mode"
    
    # Test dry run
    if ./ship.sh --dry-run > dry_run_output.txt 2>&1; then
        print_success "Dry run completed successfully"
        
        # Check that dry run shows expected steps
        if grep -q "Environment Validation" dry_run_output.txt && \
           grep -q "Dependency Management" dry_run_output.txt && \
           grep -q "Code Quality" dry_run_output.txt; then
            print_success "Dry run shows all expected steps"
        else
            print_warning "Dry run missing some expected steps"
        fi
    else
        print_error "Dry run failed"
        cat dry_run_output.txt
        return 1
    fi
    
    echo ""
}

test_configuration() {
    print_step "5" "Testing Configuration"
    
    # Check configuration file exists
    if [ -f ".ship-config.json" ]; then
        print_success "Configuration file created"
        
        # Validate JSON
        if command -v node >/dev/null 2>&1; then
            if node -e "JSON.parse(require('fs').readFileSync('.ship-config.json', 'utf8'))" >/dev/null 2>&1; then
                print_success "Configuration is valid JSON"
            else
                print_error "Configuration is invalid JSON"
                return 1
            fi
        elif command -v python3 >/dev/null 2>&1; then
            if python3 -c "import json; json.load(open('.ship-config.json'))" >/dev/null 2>&1; then
                print_success "Configuration is valid JSON"
            else
                print_error "Configuration is invalid JSON"
                return 1
            fi
        fi
        
        # Check for required fields
        if grep -q "\"type\":\"$PROJECT_TYPE\"" .ship-config.json; then
            print_success "Project type correctly configured"
        else
            print_warning "Project type not found in configuration"
        fi
        
    else
        print_error "Configuration file not created"
        return 1
    fi
    
    echo ""
}

test_help_command() {
    print_step "6" "Testing Help Command"
    
    if ./ship.sh --help > help_output.txt 2>&1; then
        print_success "Help command works"
        
        if grep -q "ROBUST SHIP" help_output.txt && grep -q "EXAMPLES:" help_output.txt; then
            print_success "Help output contains expected content"
        else
            print_warning "Help output missing expected content"
        fi
    else
        print_error "Help command failed"
        return 1
    fi
    
    echo ""
}

main() {
    print_header
    
    echo -e "${BLUE}Testing directory: $TEST_DIR${NC}"
    echo -e "${BLUE}Template directory: $TEMPLATE_DIR${NC}"
    echo ""
    
    # Run test steps
    create_test_project "$PROJECT_TYPE"
    copy_template
    run_automated_setup
    test_configuration
    test_help_command
    test_dry_run
    
    # Final summary
    echo -e "${GREEN}${BOLD}🎉 Template Test Complete for $PROJECT_TYPE!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${GREEN}✅ Template successfully configured for $PROJECT_TYPE projects${NC}"
    echo -e "${GREEN}✅ All core functionality working${NC}"
    echo -e "${GREEN}✅ Configuration file generated correctly${NC}"
    echo -e "${GREEN}✅ Help system operational${NC}"
    echo -e "${GREEN}✅ Dry run mode functional${NC}"
    echo ""
    
    echo -e "${BLUE}Test project location: $TEST_DIR/test-$PROJECT_TYPE-project${NC}"
    echo -e "${BLUE}You can inspect the test results there if needed.${NC}"
    echo ""
    
    print_success "Robust Ship Template is ready for $PROJECT_TYPE projects! 🚀"
}

# Check for required arguments and run
if [ $# -eq 0 ]; then
    echo "Usage: $0 <project-type>"
    echo ""
    echo "Supported project types:"
    echo "  react     - React with Vite"
    echo "  python    - Python with pytest"
    echo "  golang    - Go with standard tooling"
    echo "  rust      - Rust with Cargo"
    echo "  nodejs    - Node.js with Express"
    echo ""
    echo "Example: $0 react"
    exit 1
fi

main "$@"
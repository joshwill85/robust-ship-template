#!/bin/bash

# 🚀 Robust Ship Template - Interactive Setup
# Universal configuration for any project type

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

# Configuration file
CONFIG_FILE=".ship-config.json"

print_header() {
    echo -e "${PURPLE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${PURPLE}${BOLD}🚀 Robust Ship Template - Interactive Setup${NC}"
    echo -e "${PURPLE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${BLUE}Welcome! This setup will configure the Robust Ship system for your project.${NC}"
    echo -e "${BLUE}We'll ask a few questions to customize it perfectly for your workflow.${NC}"
    echo ""
}

print_step() {
    echo -e "${CYAN}${BOLD}📋 Step $1: $2${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Function to prompt for input with default
prompt_input() {
    local prompt="$1"
    local default="$2"
    local response
    
    if [ -n "$default" ]; then
        echo -e -n "${YELLOW}$prompt [$default]: ${NC}"
    else
        echo -e -n "${YELLOW}$prompt: ${NC}"
    fi
    
    read response
    echo "${response:-$default}"
}

# Function to prompt for selection
prompt_select() {
    local prompt="$1"
    shift
    local options=("$@")
    local choice
    
    echo -e "${YELLOW}$prompt${NC}"
    for i in "${!options[@]}"; do
        echo "  $((i+1)). ${options[i]}"
    done
    
    while true; do
        echo -e -n "${YELLOW}Enter choice (1-${#options[@]}): ${NC}"
        read choice
        
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#options[@]}" ]; then
            echo "${options[$((choice-1))]}"
            break
        else
            echo -e "${RED}Invalid choice. Please select 1-${#options[@]}.${NC}"
        fi
    done
}

# Function to prompt yes/no
prompt_yes_no() {
    local prompt="$1"
    local default="$2"
    local response
    
    while true; do
        if [ "$default" = "y" ]; then
            echo -e -n "${YELLOW}$prompt [Y/n]: ${NC}"
        elif [ "$default" = "n" ]; then
            echo -e -n "${YELLOW}$prompt [y/N]: ${NC}"
        else
            echo -e -n "${YELLOW}$prompt (y/n): ${NC}"
        fi
        
        read response
        response="${response:-$default}"
        
        case "$response" in
            [Yy]|[Yy][Ee][Ss])
                echo "true"
                break
                ;;
            [Nn]|[Nn][Oo])
                echo "false"
                break
                ;;
            *)
                echo -e "${RED}Please answer yes or no.${NC}"
                ;;
        esac
    done
}

# Auto-detect project characteristics
auto_detect_project() {
    local project_type="unknown"
    local framework="unknown"
    local package_manager="unknown"
    
    # Detect project type and framework
    if [ -f "package.json" ]; then
        package_manager="npm"
        if [ -f "yarn.lock" ]; then
            package_manager="yarn"
        elif [ -f "pnpm-lock.yaml" ]; then
            package_manager="pnpm"
        elif [ -f "bun.lockb" ]; then
            package_manager="bun"
        fi
        
        # Check for React/Next.js/Vue/etc.
        if grep -q "\"react\"" package.json; then
            project_type="react"
            if grep -q "\"next\"" package.json; then
                framework="nextjs"
            elif grep -q "\"vite\"" package.json; then
                framework="vite"
            elif grep -q "\"create-react-app\"" package.json; then
                framework="cra"
            fi
        elif grep -q "\"vue\"" package.json; then
            project_type="vue"
            if grep -q "\"nuxt\"" package.json; then
                framework="nuxtjs"
            elif grep -q "\"vite\"" package.json; then
                framework="vite"
            fi
        elif grep -q "\"svelte\"" package.json; then
            project_type="svelte"
            if grep -q "\"@sveltejs/kit\"" package.json; then
                framework="sveltekit"
            fi
        elif grep -q "\"angular\"" package.json; then
            project_type="angular"
            framework="angular-cli"
        elif grep -q "\"express\"" package.json; then
            project_type="nodejs"
            framework="express"
        elif grep -q "\"fastify\"" package.json; then
            project_type="nodejs"
            framework="fastify"
        else
            project_type="nodejs"
        fi
    elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
        project_type="python"
        if [ -f "pyproject.toml" ]; then
            package_manager="poetry"
        else
            package_manager="pip"
        fi
        
        if [ -f "manage.py" ]; then
            framework="django"
        elif grep -q "flask" requirements.txt 2>/dev/null; then
            framework="flask"
        elif grep -q "fastapi" requirements.txt 2>/dev/null; then
            framework="fastapi"
        fi
    elif [ -f "Cargo.toml" ]; then
        project_type="rust"
        package_manager="cargo"
    elif [ -f "go.mod" ]; then
        project_type="golang"
        package_manager="go"
    elif [ -f "composer.json" ]; then
        project_type="php"
        package_manager="composer"
    elif [ -f "Gemfile" ]; then
        project_type="ruby"
        package_manager="bundle"
    fi
    
    echo "$project_type|$framework|$package_manager"
}

# Generate package.json scripts if they don't exist
generate_package_scripts() {
    local project_type="$1"
    local framework="$2"
    
    if [ ! -f "package.json" ]; then
        return
    fi
    
    # Check for missing scripts and suggest additions
    local scripts_to_add=""
    
    if ! grep -q "\"build\"" package.json; then
        case "$framework" in
            "vite")
                scripts_to_add="$scripts_to_add    \"build\": \"vite build\","
                ;;
            "nextjs")
                scripts_to_add="$scripts_to_add    \"build\": \"next build\","
                ;;
            "cra")
                scripts_to_add="$scripts_to_add    \"build\": \"react-scripts build\","
                ;;
            *)
                scripts_to_add="$scripts_to_add    \"build\": \"echo 'No build script configured'\","
                ;;
        esac
    fi
    
    if ! grep -q "\"lint\"" package.json; then
        scripts_to_add="$scripts_to_add    \"lint\": \"eslint . --ext .js,.jsx,.ts,.tsx\","
    fi
    
    if ! grep -q "\"format\"" package.json; then
        scripts_to_add="$scripts_to_add    \"format\": \"prettier --write .\","
    fi
    
    if [ -n "$scripts_to_add" ]; then
        echo -e "${BLUE}Suggested package.json scripts to add:${NC}"
        echo -e "${scripts_to_add%,}"
        echo ""
        if [ "$(prompt_yes_no "Add these scripts to package.json?" "n")" = "true" ]; then
            # Logic to add scripts would go here
            print_info "You can manually add these scripts to your package.json"
        fi
    fi
}

# Main setup process
main() {
    print_header
    
    # Check if already configured
    if [ -f "$CONFIG_FILE" ]; then
        print_warning "Configuration file $CONFIG_FILE already exists."
        if [ "$(prompt_yes_no "Do you want to reconfigure?" "n")" = "false" ]; then
            echo "Setup cancelled."
            exit 0
        fi
    fi
    
    # Auto-detect current project
    print_step "1" "Project Detection"
    detection_result=$(auto_detect_project)
    IFS='|' read -r detected_type detected_framework detected_pm <<< "$detection_result"
    
    if [ "$detected_type" != "unknown" ]; then
        print_success "Detected $detected_type project with $detected_framework using $detected_pm"
    else
        print_info "Could not auto-detect project type."
    fi
    echo ""
    
    # Project Information
    print_step "2" "Project Information"
    
    PROJECT_NAME=$(prompt_input "Project name" "$(basename "$(pwd)")")
    
    PROJECT_TYPE=$(prompt_select "Select project type:" \
        "React" "Vue.js" "Angular" "Svelte" "Next.js" "Nuxt.js" "Node.js" \
        "Python (Django/Flask)" "Go" "Rust" "PHP" "Ruby" "Static Site" "Other")
    
    # Convert selection to lowercase identifier
    case "$PROJECT_TYPE" in
        "React") PROJECT_TYPE="react" ;;
        "Vue.js") PROJECT_TYPE="vue" ;;
        "Angular") PROJECT_TYPE="angular" ;;
        "Svelte") PROJECT_TYPE="svelte" ;;
        "Next.js") PROJECT_TYPE="nextjs" ;;
        "Nuxt.js") PROJECT_TYPE="nuxtjs" ;;
        "Node.js") PROJECT_TYPE="nodejs" ;;
        "Python (Django/Flask)") PROJECT_TYPE="python" ;;
        "Go") PROJECT_TYPE="golang" ;;
        "Rust") PROJECT_TYPE="rust" ;;
        "PHP") PROJECT_TYPE="php" ;;
        "Ruby") PROJECT_TYPE="ruby" ;;
        "Static Site") PROJECT_TYPE="static" ;;
        "Other") PROJECT_TYPE="other" ;;
    esac
    
    if [ "$PROJECT_TYPE" = "react" ] || [ "$PROJECT_TYPE" = "vue" ] || [ "$PROJECT_TYPE" = "svelte" ]; then
        FRAMEWORK=$(prompt_select "Select framework/bundler:" \
            "Vite" "Create React App" "Webpack" "Parcel" "Other")
        FRAMEWORK=$(echo "$FRAMEWORK" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')
    else
        FRAMEWORK="$PROJECT_TYPE"
    fi
    
    echo ""
    
    # Package Manager
    print_step "3" "Package Manager"
    
    case "$PROJECT_TYPE" in
        "react"|"vue"|"angular"|"svelte"|"nextjs"|"nuxtjs"|"nodejs")
            PACKAGE_MANAGER=$(prompt_select "Select package manager:" "npm" "yarn" "pnpm" "bun")
            ;;
        "python")
            PACKAGE_MANAGER=$(prompt_select "Select package manager:" "pip" "poetry" "pipenv")
            ;;
        "golang")
            PACKAGE_MANAGER="go"
            ;;
        "rust")
            PACKAGE_MANAGER="cargo"
            ;;
        "php")
            PACKAGE_MANAGER="composer"
            ;;
        "ruby")
            PACKAGE_MANAGER="bundle"
            ;;
        *)
            PACKAGE_MANAGER=$(prompt_input "Package manager command" "$detected_pm")
            ;;
    esac
    
    echo ""
    
    # Commands Configuration
    print_step "4" "Build & Quality Commands"
    
    # Set defaults based on project type and package manager
    case "$PROJECT_TYPE" in
        "react"|"vue"|"angular"|"svelte"|"nextjs"|"nuxtjs"|"nodejs")
            INSTALL_CMD="$PACKAGE_MANAGER install"
            if [ "$PACKAGE_MANAGER" = "npm" ]; then
                INSTALL_CMD="npm ci"
            fi
            BUILD_CMD="$PACKAGE_MANAGER run build"
            TEST_CMD="$PACKAGE_MANAGER test"
            LINT_CMD="$PACKAGE_MANAGER run lint"
            FORMAT_CMD="$PACKAGE_MANAGER run format"
            TYPE_CHECK_CMD="$PACKAGE_MANAGER run type-check"
            ;;
        "python")
            if [ "$PACKAGE_MANAGER" = "poetry" ]; then
                INSTALL_CMD="poetry install"
                TEST_CMD="poetry run pytest"
                LINT_CMD="poetry run pylint src/"
                FORMAT_CMD="poetry run black src/"
            else
                INSTALL_CMD="pip install -r requirements.txt"
                TEST_CMD="python -m pytest"
                LINT_CMD="pylint src/"
                FORMAT_CMD="black src/"
            fi
            BUILD_CMD="echo 'Python: No build step required'"
            TYPE_CHECK_CMD="mypy src/"
            ;;
        "golang")
            INSTALL_CMD="go mod download"
            BUILD_CMD="go build ./..."
            TEST_CMD="go test ./..."
            LINT_CMD="golangci-lint run"
            FORMAT_CMD="gofmt -w ."
            TYPE_CHECK_CMD="go vet ./..."
            ;;
        "rust")
            INSTALL_CMD="cargo fetch"
            BUILD_CMD="cargo build --release"
            TEST_CMD="cargo test"
            LINT_CMD="cargo clippy"
            FORMAT_CMD="cargo fmt"
            TYPE_CHECK_CMD="cargo check"
            ;;
        *)
            INSTALL_CMD="echo 'No install command configured'"
            BUILD_CMD="echo 'No build command configured'"
            TEST_CMD="echo 'No test command configured'"
            LINT_CMD="echo 'No lint command configured'"
            FORMAT_CMD="echo 'No format command configured'"
            TYPE_CHECK_CMD="echo 'No type check configured'"
            ;;
    esac
    
    INSTALL_CMD=$(prompt_input "Install dependencies command" "$INSTALL_CMD")
    BUILD_CMD=$(prompt_input "Build command" "$BUILD_CMD")
    TEST_CMD=$(prompt_input "Test command" "$TEST_CMD")
    LINT_CMD=$(prompt_input "Lint command" "$LINT_CMD")
    FORMAT_CMD=$(prompt_input "Format command" "$FORMAT_CMD")
    TYPE_CHECK_CMD=$(prompt_input "Type check command" "$TYPE_CHECK_CMD")
    
    echo ""
    
    # Deployment Configuration
    print_step "5" "Deployment Configuration"
    
    DEPLOY_PLATFORM=$(prompt_select "Select deployment platform:" \
        "Vercel" "Netlify" "Railway" "AWS" "Google Cloud" "Azure" \
        "GitHub Pages" "GitLab Pages" "Custom Script" "None")
    
    case "$DEPLOY_PLATFORM" in
        "Vercel")
            PROD_DEPLOY_CMD="vercel --prod --yes"
            PREVIEW_DEPLOY_CMD="vercel --yes"
            ;;
        "Netlify")
            PROD_DEPLOY_CMD="netlify deploy --prod"
            PREVIEW_DEPLOY_CMD="netlify deploy"
            ;;
        "Railway")
            PROD_DEPLOY_CMD="railway deploy"
            PREVIEW_DEPLOY_CMD="railway deploy"
            ;;
        "GitHub Pages")
            PROD_DEPLOY_CMD="gh-pages -d dist"
            PREVIEW_DEPLOY_CMD="echo 'GitHub Pages: preview not supported'"
            ;;
        "Custom Script")
            PROD_DEPLOY_CMD=$(prompt_input "Production deploy command" "echo 'Configure your deploy command'")
            PREVIEW_DEPLOY_CMD=$(prompt_input "Preview deploy command" "echo 'Configure your preview command'")
            ;;
        "None")
            PROD_DEPLOY_CMD="echo 'No deployment configured'"
            PREVIEW_DEPLOY_CMD="echo 'No deployment configured'"
            ;;
        *)
            PROD_DEPLOY_CMD="echo 'Custom deployment: configure manually'"
            PREVIEW_DEPLOY_CMD="echo 'Custom deployment: configure manually'"
            ;;
    esac
    
    if [ "$DEPLOY_PLATFORM" != "None" ]; then
        PROD_DEPLOY_CMD=$(prompt_input "Production deploy command" "$PROD_DEPLOY_CMD")
        PREVIEW_DEPLOY_CMD=$(prompt_input "Preview deploy command" "$PREVIEW_DEPLOY_CMD")
    fi
    
    echo ""
    
    # Quality Enforcement Settings
    print_step "6" "Quality Enforcement Settings"
    
    ENFORCE_TYPES=$(prompt_yes_no "Enforce type checking?" "y")
    ENFORCE_LINT=$(prompt_yes_no "Enforce linting?" "y")
    ENFORCE_TESTS=$(prompt_yes_no "Enforce tests passing?" "y")
    ENFORCE_SECURITY=$(prompt_yes_no "Enforce security audit?" "y")
    ENFORCE_BUILD=$(prompt_yes_no "Enforce successful build?" "y")
    
    echo ""
    
    # Generate Configuration
    print_step "7" "Generating Configuration"
    
    cat > "$CONFIG_FILE" << EOF
{
  "project": {
    "name": "$PROJECT_NAME",
    "type": "$PROJECT_TYPE",
    "framework": "$FRAMEWORK"
  },
  "packageManager": "$PACKAGE_MANAGER",
  "commands": {
    "install": "$INSTALL_CMD",
    "build": "$BUILD_CMD", 
    "test": "$TEST_CMD",
    "lint": "$LINT_CMD",
    "format": "$FORMAT_CMD",
    "typeCheck": "$TYPE_CHECK_CMD"
  },
  "deployment": {
    "platform": "$DEPLOY_PLATFORM",
    "prodCommand": "$PROD_DEPLOY_CMD",
    "previewCommand": "$PREVIEW_DEPLOY_CMD"
  },
  "quality": {
    "enforceTypes": $ENFORCE_TYPES,
    "enforceLinting": $ENFORCE_LINT,
    "enforceTests": $ENFORCE_TESTS,
    "enforceSecurity": $ENFORCE_SECURITY,
    "enforceBuild": $ENFORCE_BUILD
  },
  "setupVersion": "1.0.0",
  "setupDate": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF
    
    print_success "Configuration saved to $CONFIG_FILE"
    
    # Make ship.sh executable
    chmod +x ship.sh
    print_success "Made ship.sh executable"
    
    # Generate .gitignore additions if needed
    if [ ! -f ".gitignore" ] || ! grep -q ".ship-config.json" .gitignore; then
        echo ""
        if [ "$(prompt_yes_no "Add .ship-config.json to .gitignore?" "n")" = "true" ]; then
            echo ".ship-config.json" >> .gitignore
            print_success "Added .ship-config.json to .gitignore"
        fi
    fi
    
    # Final summary
    echo ""
    print_step "8" "Setup Complete!"
    
    echo -e "${GREEN}${BOLD}🎉 Robust Ship is now configured for your $PROJECT_TYPE project!${NC}"
    echo ""
    echo -e "${BLUE}Quick start commands:${NC}"
    echo -e "  ${YELLOW}./ship.sh${NC}                 - Ship with full quality enforcement"
    echo -e "  ${YELLOW}./ship.sh --dry-run${NC}       - Preview what would happen"
    echo -e "  ${YELLOW}./ship.sh --quick${NC}         - Fast ship with basic checks"
    echo -e "  ${YELLOW}./ship.sh --help${NC}          - See all options"
    echo ""
    echo -e "${BLUE}Configuration file: ${YELLOW}$CONFIG_FILE${NC}"
    echo -e "${BLUE}Documentation: ${YELLOW}https://github.com/petpawlooza/robust-ship-template${NC}"
    echo ""
    
    if [ "$(prompt_yes_no "Would you like to run a test ship now?" "n")" = "true" ]; then
        echo ""
        print_info "Running test ship in dry-run mode..."
        ./ship.sh --dry-run
    fi
    
    echo ""
    echo -e "${GREEN}Happy shipping! 🚀${NC}"
}

# Run main function
main "$@"
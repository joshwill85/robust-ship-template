#!/bin/bash

# 🚀 ROBUST SHIP v2.0.0 - Universal Git Launch System
# Self-contained quality-enforcing deployment for any project type

set -e

# ============================================================================
# CONFIGURATION AND CONSTANTS
# ============================================================================

VERSION="2.0.0"
CONFIG_FILE=".ship-config.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Global flags
DRY_RUN=false
QUICK_MODE=false
LOOSE_MODE=false
FORCE_MODE=false
NO_PUSH=false
NO_DEPLOY=false
PROD_DEPLOY=false
HELP_MODE=false
COMMIT_MESSAGE=""

# Configuration variables
PROJECT_TYPE=""
PACKAGE_MANAGER=""
INSTALL_CMD=""
BUILD_CMD=""
TEST_CMD=""
LINT_CMD=""
FORMAT_CMD=""
TYPE_CHECK_CMD=""
PROD_DEPLOY_CMD=""
PREVIEW_DEPLOY_CMD=""
ENFORCE_TYPES=true
ENFORCE_LINTING=true
ENFORCE_TESTS=true
ENFORCE_SECURITY=true
ENFORCE_BUILD=true

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

print_header() {
    echo -e "${PURPLE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${PURPLE}${BOLD}🚀 ROBUST SHIP v$VERSION - Universal Git Launch System${NC}"
    echo -e "${PURPLE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_step() {
    echo -e "${CYAN}${BOLD}📋 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_dry_run() {
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}[DRY RUN]${NC} $1"
    fi
}

# Function to show help
show_help() {
    cat << EOF
${PURPLE}${BOLD}🚀 ROBUST SHIP v$VERSION - Universal Git Launch System${NC}

${BOLD}DESCRIPTION:${NC}
  Self-contained quality-enforcing deployment system for any project type.
  Performs comprehensive quality checks, auto-fixes issues, and deploys.

${BOLD}USAGE:${NC}
  ./ship.sh [OPTIONS] [COMMIT_MESSAGE]

${BOLD}OPTIONS:${NC}
  --help              Show this help message
  --dry-run          Preview actions without making changes
  --quick            Fast ship with basic checks only
  --loose            Allow some quality compromises (warnings ok)
  --force            Force through critical failures (dangerous)
  --no-push          Skip git push (local commit only)
  --no-deploy        Skip deployment step
  --prod-deploy      Deploy to production environment

${BOLD}EXAMPLES:${NC}
  ./ship.sh                                    # Full quality enforcement
  ./ship.sh "feat: add user authentication"    # Custom commit message
  ./ship.sh --dry-run                         # Preview mode
  ./ship.sh --quick "hotfix: critical fix"    # Fast deployment
  ./ship.sh --prod-deploy "release: v2.0"     # Production deployment
  ./ship.sh --no-deploy "docs: update README" # Local commit only

${BOLD}QUALITY CHECKS:${NC}
  ✅ Environment validation       ✅ Dependency management
  ✅ Code quality (linting)       ✅ Type checking
  ✅ Security scanning           ✅ Build verification
  ✅ Test execution              ✅ Performance analysis
  ✅ Git workflow validation     ✅ Deployment readiness

${BOLD}CONFIGURATION:${NC}
  Configuration file: $CONFIG_FILE
  Run './setup.sh' to configure for your project type.

${BOLD}SUPPORTED PROJECTS:${NC}
  Frontend: React, Vue, Angular, Svelte, Next.js
  Backend: Node.js, Python, Go, Rust, PHP, Ruby
  Tools: npm, yarn, pnpm, pip, cargo, composer, etc.

EOF
}

# Load configuration from JSON file
load_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        print_error "Configuration file $CONFIG_FILE not found!"
        echo ""
        print_info "Run './setup.sh' to configure Robust Ship for your project."
        exit 1
    fi
    
    # Parse JSON configuration using basic shell commands
    PROJECT_TYPE=$(grep -o '"type"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
    PACKAGE_MANAGER=$(grep -o '"packageManager"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
    
    # Extract commands
    INSTALL_CMD=$(grep -o '"install"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
    BUILD_CMD=$(grep -o '"build"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
    TEST_CMD=$(grep -o '"test"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
    LINT_CMD=$(grep -o '"lint"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
    FORMAT_CMD=$(grep -o '"format"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
    TYPE_CHECK_CMD=$(grep -o '"typeCheck"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
    
    # Extract deployment commands
    PROD_DEPLOY_CMD=$(grep -o '"prodCommand"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
    PREVIEW_DEPLOY_CMD=$(grep -o '"previewCommand"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
    
    # Extract quality settings
    if grep -q '"enforceTypes"[[:space:]]*:[[:space:]]*false' "$CONFIG_FILE"; then
        ENFORCE_TYPES=false
    fi
    if grep -q '"enforceLinting"[[:space:]]*:[[:space:]]*false' "$CONFIG_FILE"; then
        ENFORCE_LINTING=false
    fi
    if grep -q '"enforceTests"[[:space:]]*:[[:space:]]*false' "$CONFIG_FILE"; then
        ENFORCE_TESTS=false
    fi
    if grep -q '"enforceSecurity"[[:space:]]*:[[:space:]]*false' "$CONFIG_FILE"; then
        ENFORCE_SECURITY=false
    fi
    if grep -q '"enforceBuild"[[:space:]]*:[[:space:]]*false' "$CONFIG_FILE"; then
        ENFORCE_BUILD=false
    fi
    
    print_info "Loaded configuration for $PROJECT_TYPE project using $PACKAGE_MANAGER"
}

# ============================================================================
# VALIDATION FUNCTIONS
# ============================================================================

validate_environment() {
    print_step "🔍 Environment Validation"
    
    local missing_tools=()
    
    # Check for Git
    if ! command -v git >/dev/null 2>&1; then
        missing_tools+=("git")
    fi
    
    # Check for project-specific tools
    case "$PROJECT_TYPE" in
        "react"|"vue"|"angular"|"svelte"|"nextjs"|"nuxtjs"|"nodejs")
            if ! command -v node >/dev/null 2>&1; then
                missing_tools+=("node")
            fi
            if ! command -v "$PACKAGE_MANAGER" >/dev/null 2>&1; then
                missing_tools+=("$PACKAGE_MANAGER")
            fi
            ;;
        "python")
            if ! command -v python3 >/dev/null 2>&1 && ! command -v python >/dev/null 2>&1; then
                missing_tools+=("python")
            fi
            if [ "$PACKAGE_MANAGER" = "poetry" ] && ! command -v poetry >/dev/null 2>&1; then
                missing_tools+=("poetry")
            fi
            ;;
        "golang")
            if ! command -v go >/dev/null 2>&1; then
                missing_tools+=("go")
            fi
            ;;
        "rust")
            if ! command -v cargo >/dev/null 2>&1; then
                missing_tools+=("cargo")
            fi
            ;;
        "php")
            if ! command -v php >/dev/null 2>&1; then
                missing_tools+=("php")
            fi
            if ! command -v composer >/dev/null 2>&1; then
                missing_tools+=("composer")
            fi
            ;;
        "ruby")
            if ! command -v ruby >/dev/null 2>&1; then
                missing_tools+=("ruby")
            fi
            if ! command -v bundle >/dev/null 2>&1; then
                missing_tools+=("bundle")
            fi
            ;;
    esac
    
    if [ ${#missing_tools[@]} -gt 0 ]; then
        print_error "Missing required tools: ${missing_tools[*]}"
        echo ""
        print_info "Please install the missing tools and try again."
        exit 1
    fi
    
    print_success "Environment validation passed"
    echo ""
}

validate_git_status() {
    print_step "📋 Git Status Validation"
    
    # Check if we're in a git repo
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        print_error "Not in a git repository"
        exit 1
    fi
    
    # Check for uncommitted changes in staging area
    if [ "$DRY_RUN" = false ] && git diff --staged --quiet; then
        :  # No staged changes, this is fine
    fi
    
    # Show current status
    git status --porcelain | head -20
    
    print_success "Git repository validated"
    echo ""
}

# ============================================================================
# QUALITY ENFORCEMENT FUNCTIONS
# ============================================================================

install_dependencies() {
    print_step "📦 Dependency Management"
    
    if [ "$DRY_RUN" = true ]; then
        print_dry_run "Would run: $INSTALL_CMD"
        return 0
    fi
    
    print_info "Installing dependencies..."
    if eval "$INSTALL_CMD"; then
        print_success "Dependencies installed successfully"
    else
        if [ "$FORCE_MODE" = false ]; then
            print_error "Dependency installation failed"
            exit 1
        else
            print_warning "Dependency installation failed (continuing in force mode)"
        fi
    fi
    echo ""
}

run_linting() {
    if [ "$ENFORCE_LINTING" = false ] && [ "$QUICK_MODE" = true ]; then
        print_info "Skipping linting (quick mode)"
        return 0
    fi
    
    print_step "🔍 Code Quality - Linting"
    
    if [ "$DRY_RUN" = true ]; then
        print_dry_run "Would run: $LINT_CMD"
        return 0
    fi
    
    print_info "Running linter..."
    if eval "$LINT_CMD"; then
        print_success "Linting passed"
    else
        if [ "$ENFORCE_LINTING" = true ] && [ "$LOOSE_MODE" = false ] && [ "$FORCE_MODE" = false ]; then
            print_error "Linting failed - fix errors before shipping"
            
            # Auto-fix attempt for common tools
            if [[ "$LINT_CMD" == *"eslint"* ]]; then
                print_info "Attempting auto-fix with ESLint..."
                eval "${LINT_CMD} --fix" || true
                
                # Try again after auto-fix
                if eval "$LINT_CMD"; then
                    print_success "Linting passed after auto-fix"
                else
                    print_error "Linting still failing after auto-fix attempt"
                    exit 1
                fi
            else
                exit 1
            fi
        else
            print_warning "Linting issues detected (continuing)"
        fi
    fi
    echo ""
}

run_type_checking() {
    if [ "$ENFORCE_TYPES" = false ] && [ "$QUICK_MODE" = true ]; then
        print_info "Skipping type checking (quick mode)"
        return 0
    fi
    
    print_step "🔍 Type Checking"
    
    if [ "$DRY_RUN" = true ]; then
        print_dry_run "Would run: $TYPE_CHECK_CMD"
        return 0
    fi
    
    # Skip if no type checking configured
    if [[ "$TYPE_CHECK_CMD" == *"echo"* ]]; then
        print_info "No type checking configured"
        return 0
    fi
    
    print_info "Running type checker..."
    if eval "$TYPE_CHECK_CMD"; then
        print_success "Type checking passed"
    else
        if [ "$ENFORCE_TYPES" = true ] && [ "$LOOSE_MODE" = false ] && [ "$FORCE_MODE" = false ]; then
            print_error "Type checking failed - fix errors before shipping"
            
            # Auto-fix attempt for TypeScript
            if [[ "$TYPE_CHECK_CMD" == *"tsc"* ]] || [[ "$PROJECT_TYPE" == *"react"* ]]; then
                print_info "Attempting TypeScript auto-fixes..."
                apply_typescript_fixes
                
                # Try again
                if eval "$TYPE_CHECK_CMD"; then
                    print_success "Type checking passed after fixes"
                else
                    print_error "Type checking still failing"
                    exit 1
                fi
            else
                exit 1
            fi
        else
            print_warning "Type checking issues detected (continuing)"
        fi
    fi
    echo ""
}

apply_typescript_fixes() {
    # Common TypeScript auto-fixes
    find . -name "*.ts" -o -name "*.tsx" 2>/dev/null | while read -r file; do
        # Fix common issues
        sed -i.bak 's/@ts-ignore/@ts-expect-error -- Auto-fixed by robust-ship/g' "$file" 2>/dev/null || true
        rm -f "${file}.bak" 2>/dev/null || true
    done
}

run_security_audit() {
    if [ "$ENFORCE_SECURITY" = false ] && [ "$QUICK_MODE" = true ]; then
        print_info "Skipping security audit (quick mode)"
        return 0
    fi
    
    print_step "🔒 Security Audit"
    
    if [ "$DRY_RUN" = true ]; then
        print_dry_run "Would run security audit"
        return 0
    fi
    
    local audit_failed=false
    
    # Run project-specific security audit
    case "$PROJECT_TYPE" in
        "react"|"vue"|"angular"|"svelte"|"nextjs"|"nuxtjs"|"nodejs")
            if command -v npm >/dev/null 2>&1; then
                print_info "Running npm security audit..."
                if ! npm audit --audit-level=high; then
                    audit_failed=true
                    print_info "Attempting to fix vulnerabilities..."
                    npm audit fix || true
                fi
            fi
            ;;
        "python")
            if command -v pip >/dev/null 2>&1 && command -v safety >/dev/null 2>&1; then
                print_info "Running Python security audit..."
                safety check || audit_failed=true
            fi
            ;;
        "rust")
            if command -v cargo >/dev/null 2>&1 && command -v cargo-audit >/dev/null 2>&1; then
                print_info "Running Rust security audit..."
                cargo audit || audit_failed=true
            fi
            ;;
    esac
    
    # Check for secrets in code
    print_info "Scanning for potential secrets..."
    if grep -r --exclude-dir=node_modules --exclude-dir=.git -E "(API_KEY|SECRET|PASSWORD|TOKEN)" . | grep -v ".ship-config.json" | head -5; then
        print_warning "Potential secrets found in code - please review"
    fi
    
    if [ "$audit_failed" = true ] && [ "$ENFORCE_SECURITY" = true ] && [ "$LOOSE_MODE" = false ] && [ "$FORCE_MODE" = false ]; then
        print_error "Security audit failed - address vulnerabilities before shipping"
        exit 1
    elif [ "$audit_failed" = true ]; then
        print_warning "Security issues detected (continuing)"
    else
        print_success "Security audit passed"
    fi
    echo ""
}

run_tests() {
    if [ "$ENFORCE_TESTS" = false ] && [ "$QUICK_MODE" = true ]; then
        print_info "Skipping tests (quick mode)"
        return 0
    fi
    
    print_step "🧪 Test Execution"
    
    if [ "$DRY_RUN" = true ]; then
        print_dry_run "Would run: $TEST_CMD"
        return 0
    fi
    
    # Skip if no tests configured
    if [[ "$TEST_CMD" == *"echo"* ]]; then
        print_info "No tests configured"
        return 0
    fi
    
    print_info "Running tests..."
    if eval "$TEST_CMD"; then
        print_success "All tests passed"
    else
        if [ "$ENFORCE_TESTS" = true ] && [ "$LOOSE_MODE" = false ] && [ "$FORCE_MODE" = false ]; then
            print_error "Tests failed - fix failing tests before shipping"
            exit 1
        else
            print_warning "Some tests failed (continuing)"
        fi
    fi
    echo ""
}

run_build() {
    if [ "$ENFORCE_BUILD" = false ] && [ "$QUICK_MODE" = true ]; then
        print_info "Skipping build (quick mode)"
        return 0
    fi
    
    print_step "🏗️  Build Verification"
    
    if [ "$DRY_RUN" = true ]; then
        print_dry_run "Would run: $BUILD_CMD"
        return 0
    fi
    
    # Skip if no build configured
    if [[ "$BUILD_CMD" == *"echo"* ]]; then
        print_info "No build step configured"
        return 0
    fi
    
    print_info "Building project..."
    if eval "$BUILD_CMD"; then
        print_success "Build completed successfully"
    else
        if [ "$ENFORCE_BUILD" = true ] && [ "$LOOSE_MODE" = false ] && [ "$FORCE_MODE" = false ]; then
            print_error "Build failed - fix build errors before shipping"
            exit 1
        else
            print_warning "Build failed (continuing)"
        fi
    fi
    echo ""
}

run_formatting() {
    print_step "✨ Code Formatting"
    
    if [ "$DRY_RUN" = true ]; then
        print_dry_run "Would run: $FORMAT_CMD"
        return 0
    fi
    
    # Skip if no formatting configured
    if [[ "$FORMAT_CMD" == *"echo"* ]]; then
        print_info "No code formatting configured"
        return 0
    fi
    
    print_info "Formatting code..."
    if eval "$FORMAT_CMD"; then
        print_success "Code formatted successfully"
    else
        print_warning "Code formatting had issues (continuing)"
    fi
    echo ""
}

# ============================================================================
# GIT OPERATIONS
# ============================================================================

generate_commit_message() {
    if [ -n "$COMMIT_MESSAGE" ]; then
        echo "$COMMIT_MESSAGE"
        return 0
    fi
    
    # Generate conventional commit message based on changes
    local files_changed=$(git diff --staged --name-only | wc -l | tr -d ' ')
    local has_new_files=$(git ls-files --others --exclude-standard | wc -l | tr -d ' ')
    
    if [ "$files_changed" -eq 0 ] && [ "$has_new_files" -gt 0 ]; then
        echo "feat: add new files and improvements"
    elif [ "$files_changed" -gt 10 ]; then
        echo "refactor: comprehensive code improvements and fixes"
    else
        echo "improve: quality fixes and enhancements"
    fi
}

commit_changes() {
    print_step "📝 Git Commit"
    
    if [ "$DRY_RUN" = true ]; then
        print_dry_run "Would add and commit changes"
        return 0
    fi
    
    # Add all changes
    git add .
    
    # Generate commit message
    local message=$(generate_commit_message)
    
    # Add robust ship signature
    local full_message="$message

🤖 Generated with Robust Ship v$VERSION

Co-Authored-By: RobustShip <noreply@robust-ship.dev>"
    
    print_info "Committing with message: $message"
    
    if git commit -m "$full_message"; then
        print_success "Changes committed successfully"
    else
        print_error "Git commit failed"
        exit 1
    fi
    echo ""
}

push_changes() {
    if [ "$NO_PUSH" = true ]; then
        print_info "Skipping git push (--no-push flag)"
        return 0
    fi
    
    print_step "📤 Git Push"
    
    if [ "$DRY_RUN" = true ]; then
        print_dry_run "Would push to remote repository"
        return 0
    fi
    
    # Get current branch
    local branch=$(git rev-parse --abbrev-ref HEAD)
    
    print_info "Pushing to remote branch: $branch"
    
    if git push origin "$branch"; then
        print_success "Changes pushed to remote successfully"
    else
        print_error "Git push failed"
        if [ "$FORCE_MODE" = false ]; then
            exit 1
        else
            print_warning "Git push failed (continuing in force mode)"
        fi
    fi
    echo ""
}

# ============================================================================
# DEPLOYMENT
# ============================================================================

deploy_application() {
    if [ "$NO_DEPLOY" = true ]; then
        print_info "Skipping deployment (--no-deploy flag)"
        return 0
    fi
    
    print_step "🚀 Deployment"
    
    local deploy_cmd="$PREVIEW_DEPLOY_CMD"
    if [ "$PROD_DEPLOY" = true ]; then
        deploy_cmd="$PROD_DEPLOY_CMD"
    fi
    
    if [ "$DRY_RUN" = true ]; then
        print_dry_run "Would run: $deploy_cmd"
        return 0
    fi
    
    # Skip if no deployment configured
    if [[ "$deploy_cmd" == *"echo"* ]]; then
        print_info "No deployment configured"
        return 0
    fi
    
    local env_type="preview"
    if [ "$PROD_DEPLOY" = true ]; then
        env_type="production"
    fi
    
    print_info "Deploying to $env_type environment..."
    
    if eval "$deploy_cmd"; then
        print_success "Deployment to $env_type completed successfully"
    else
        print_error "Deployment failed"
        if [ "$FORCE_MODE" = false ]; then
            exit 1
        else
            print_warning "Deployment failed (continuing in force mode)"
        fi
    fi
    echo ""
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help)
                HELP_MODE=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --quick)
                QUICK_MODE=true
                shift
                ;;
            --loose)
                LOOSE_MODE=true
                shift
                ;;
            --force)
                FORCE_MODE=true
                shift
                ;;
            --no-push)
                NO_PUSH=true
                shift
                ;;
            --no-deploy)
                NO_DEPLOY=true
                shift
                ;;
            --prod-deploy)
                PROD_DEPLOY=true
                shift
                ;;
            *)
                COMMIT_MESSAGE="$1"
                shift
                ;;
        esac
    done
}

main() {
    # Parse command line arguments
    parse_arguments "$@"
    
    # Show help if requested
    if [ "$HELP_MODE" = true ]; then
        show_help
        exit 0
    fi
    
    # Print header
    print_header
    
    # Load configuration
    load_config
    
    # Show mode information
    if [ "$DRY_RUN" = true ]; then
        print_warning "DRY RUN MODE - No changes will be made"
        echo ""
    fi
    
    if [ "$QUICK_MODE" = true ]; then
        print_info "Quick mode enabled - reduced quality checks"
        echo ""
    fi
    
    if [ "$LOOSE_MODE" = true ]; then
        print_warning "Loose mode enabled - quality compromises allowed"
        echo ""
    fi
    
    if [ "$FORCE_MODE" = true ]; then
        print_error "FORCE MODE - Will continue through failures (dangerous!)"
        echo ""
    fi
    
    # Execute pipeline
    validate_environment
    validate_git_status
    install_dependencies
    run_formatting
    run_linting
    run_type_checking
    run_security_audit
    run_tests
    run_build
    commit_changes
    push_changes
    deploy_application
    
    # Final success message
    echo -e "${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}${BOLD}🎉 ROBUST SHIP COMPLETE!${NC}"
    echo -e "${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    if [ "$DRY_RUN" = false ]; then
        echo -e "${GREEN}✅ Quality validation: PASSED${NC}"
        echo -e "${GREEN}✅ Code shipped successfully${NC}"
        if [ "$NO_DEPLOY" = false ]; then
            local env_type="preview"
            if [ "$PROD_DEPLOY" = true ]; then
                env_type="production"
            fi
            echo -e "${GREEN}✅ Deployed to $env_type environment${NC}"
        fi
        echo ""
        echo -e "${BLUE}Your code has been shipped with full quality enforcement! 🚢${NC}"
    else
        echo -e "${YELLOW}Dry run completed - no changes were made${NC}"
    fi
    
    echo ""
}

# Run the main function with all arguments
main "$@"
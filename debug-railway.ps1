# Laravel Railway Deployment Debugger
# Script untuk debugging aplikasi Laravel sebelum deploy ke Railway
# Jalankan: .\debug-railway.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  LARAVEL RAILWAY DEPLOYMENT DEBUGGER" -ForegroundColor Cyan
Write-Host "  Kos Harmoni Pro" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$issues = @()
$warnings = @()

# 1. Check PHP Version
Write-Host "[1/15] Checking PHP..." -ForegroundColor Yellow
$phpVersion = php -v 2>&1 | Select-String "PHP [0-9]"
if ($phpVersion) {
    Write-Host "  ✓ PHP found: $phpVersion" -ForegroundColor Green
} else {
    Write-Host "  ✗ PHP not found!" -ForegroundColor Red
    $issues += "PHP not installed"
}
Write-Host ""

# 2. Check Composer
Write-Host "[2/15] Checking Composer..." -ForegroundColor Yellow
$composerVersion = composer --version 2>&1 | Select-String "Composer"
if ($composerVersion) {
    Write-Host "  ✓ Composer found: $composerVersion" -ForegroundColor Green
} else {
    Write-Host "  ✗ Composer not found!" -ForegroundColor Red
    $issues += "Composer not installed"
}
Write-Host ""

# 3. Check composer.json
Write-Host "[3/15] Checking composer.json..." -ForegroundColor Yellow
if (Test-Path "composer.json") {
    Write-Host "  ✓ composer.json exists" -ForegroundColor Green
    try {
        $composerContent = Get-Content "composer.json" -Raw | ConvertFrom-Json
        Write-Host "  ✓ composer.json is valid JSON" -ForegroundColor Green
        
        # Check required packages
        $required = @("laravel/framework", "livewire/livewire", "tailwindcss/tailwindcss")
        foreach ($pkg in $required) {
            if ($composerContent.require.$pkg -or $composerContent."require-dev".$pkg) {
                Write-Host "    ✓ $pkg found" -ForegroundColor Green
            } else {
                Write-Host "    ⚠ $pkg not found (may be optional)" -ForegroundColor Yellow
            }
        }
    } catch {
        Write-Host "  ✗ composer.json is INVALID JSON!" -ForegroundColor Red
        $issues += "composer.json has syntax errors"
    }
} else {
    Write-Host "  ✗ composer.json NOT FOUND!" -ForegroundColor Red
    $issues += "Missing composer.json"
}
Write-Host ""

# 4. Check composer.lock
Write-Host "[4/15] Checking composer.lock..." -ForegroundColor Yellow
if (Test-Path "composer.lock") {
    Write-Host "  ✓ composer.lock exists" -ForegroundColor Green
} else {
    Write-Host "  ⚠ composer.lock not found (run: composer install)" -ForegroundColor Yellow
    $warnings += "Missing composer.lock"
}
Write-Host ""

# 5. Check .env.example
Write-Host "[5/15] Checking .env.example..." -ForegroundColor Yellow
if (Test-Path ".env.example") {
    Write-Host "  ✓ .env.example exists" -ForegroundColor Green
    $envContent = Get-Content ".env.example" -Raw
    $requiredVars = @("APP_KEY", "APP_ENV", "APP_DEBUG", "DB_CONNECTION", "DB_HOST", "DB_DATABASE")
    foreach ($var in $requiredVars) {
        if ($envContent -match $var) {
            Write-Host "    ✓ $var found" -ForegroundColor Green
        } else {
            Write-Host "    ⚠ $var not found" -ForegroundColor Yellow
            $warnings += "Missing $var in .env.example"
        }
    }
} else {
    Write-Host "  ✗ .env.example NOT FOUND!" -ForegroundColor Red
    $issues += "Missing .env.example"
}
Write-Host ""

# 6. Check Dockerfile
Write-Host "[6/15] Checking Dockerfile..." -ForegroundColor Yellow
$dockerfilePaths = @("Dockerfile", "Dockerfile.railway")
$dockerfileFound = $false
foreach ($path in $dockerfilePaths) {
    if (Test-Path $path) {
        Write-Host "  ✓ $path exists" -ForegroundColor Green
        $dockerfileFound = $true
        
        $dockerfileContent = Get-Content $path -Raw
        $requiredKeywords = @("FROM", "RUN", "CMD", "EXPOSE")
        foreach ($keyword in $requiredKeywords) {
            if ($dockerfileContent -match $keyword) {
                Write-Host "    ✓ $keyword instruction found" -ForegroundColor Green
            } else {
                Write-Host "    ⚠ $keyword instruction missing" -ForegroundColor Yellow
            }
        }
        break
    }
}
if (-not $dockerfileFound) {
    Write-Host "  ✗ Dockerfile NOT FOUND!" -ForegroundColor Red
    $issues += "Missing Dockerfile"
}
Write-Host ""

# 7. Check railway.json
Write-Host "[7/15] Checking railway.json..." -ForegroundColor Yellow
if (Test-Path "railway.json") {
    Write-Host "  ✓ railway.json exists" -ForegroundColor Green
    try {
        $railwayContent = Get-Content "railway.json" -Raw | ConvertFrom-Json
        Write-Host "  ✓ railway.json is valid JSON" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ railway.json is INVALID JSON!" -ForegroundColor Red
        $issues += "railway.json has syntax errors"
    }
} else {
    Write-Host "  ⚠ railway.json not found (will use default)" -ForegroundColor Yellow
    $warnings += "Missing railway.json"
}
Write-Host ""

# 8. Check migrations for duplicates
Write-Host "[8/15] Checking migrations for duplicates..." -ForegroundColor Yellow
$migrationsPath = "database\migrations"
if (Test-Path $migrationsPath) {
    $migrations = Get-ChildItem $migrationsPath -Filter "*.php"
    $tableNames = @{}
    foreach ($migration in $migrations) {
        $content = Get-Content $migration.FullName -Raw
        if ($content -match "create_([a-z_]+)_table") {
            $tableName = $matches[1]
            if ($tableNames.ContainsKey($tableName)) {
                Write-Host "  ✗ DUPLICATE TABLE: $tableName" -ForegroundColor Red
                Write-Host "    - Found in: $($tableNames[$tableName])" -ForegroundColor Red
                Write-Host "    - Also in: $($migration.Name)" -ForegroundColor Red
                $issues += "Duplicate migration for table: $tableName"
            } else {
                $tableNames[$tableName] = $migration.Name
            }
        }
    }
    if ($issues.Count -eq 0 -or -not ($issues -match "Duplicate")) {
        Write-Host "  ✓ No duplicate migrations found" -ForegroundColor Green
    }
} else {
    Write-Host "  ✗ migrations folder NOT FOUND!" -ForegroundColor Red
    $issues += "Missing migrations folder"
}
Write-Host ""

# 9. Check app structure
Write-Host "[9/15] Checking app structure..." -ForegroundColor Yellow
$requiredFolders = @(
    "app\Http\Controllers",
    "app\Models",
    "app\Livewire",
    "database\seeders",
    "resources\views",
    "routes",
    "public"
)
foreach ($folder in $requiredFolders) {
    if (Test-Path $folder) {
        $itemCount = (Get-ChildItem $folder -File -Recurse).Count
        Write-Host "  ✓ $folder exists ($itemCount files)" -ForegroundColor Green
    } else {
        Write-Host "  ✗ $folder NOT FOUND!" -ForegroundColor Red
        $issues += "Missing folder: $folder"
    }
}
Write-Host ""

# 10. Check routes
Write-Host "[10/15] Checking routes..." -ForegroundColor Yellow
if (Test-Path "routes\web.php") {
    Write-Host "  ✓ routes/web.php exists" -ForegroundColor Green
    $routesContent = Get-Content "routes\web.php" -Raw
    $routeCount = ([regex]::Matches($routesContent, "Route::")).Count
    Write-Host "    Found $routeCount route definitions" -ForegroundColor Gray
    
    if ($routesContent -match "Route::get\s*\(\s*['\"/]\s*['\"/]") {
        Write-Host "    ✓ Homepage route found" -ForegroundColor Green
    }
} else {
    Write-Host "  ✗ routes/web.php NOT FOUND!" -ForegroundColor Red
    $issues += "Missing routes/web.php"
}
Write-Host ""

# 11. Check models
Write-Host "[11/15] Checking models..." -ForegroundColor Yellow
$modelsPath = "app\Models"
if (Test-Path $modelsPath) {
    $models = Get-ChildItem $modelsPath -Filter "*.php"
    Write-Host "  ✓ Found $($models.Count) models" -ForegroundColor Green
    
    $requiredModels = @("User", "Tenant", "Room", "Invoice", "Payment")
    foreach ($model in $requiredModels) {
        $modelFile = "$modelsPath\$model.php"
        if (Test-Path $modelFile) {
            Write-Host "    ✓ $model model exists" -ForegroundColor Green
        } else {
            Write-Host "    ⚠ $model model not found" -ForegroundColor Yellow
            $warnings += "Missing model: $model"
        }
    }
} else {
    Write-Host "  ✗ Models folder NOT FOUND!" -ForegroundColor Red
    $issues += "Missing Models folder"
}
Write-Host ""

# 12. Check storage permissions
Write-Host "[12/15] Checking storage folder..." -ForegroundColor Yellow
if (Test-Path "storage") {
    Write-Host "  ✓ storage folder exists" -ForegroundColor Green
    $subfolders = @("app", "framework", "logs")
    foreach ($sub in $subfolders) {
        $subPath = "storage\$sub"
        if (Test-Path $subPath) {
            Write-Host "    ✓ storage/$sub exists" -ForegroundColor Green
        } else {
            Write-Host "    ⚠ storage/$sub missing" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "  ✗ storage folder NOT FOUND!" -ForegroundColor Red
    $issues += "Missing storage folder"
}
Write-Host ""

# 13. Check bootstrap/cache
Write-Host "[13/15] Checking bootstrap/cache..." -ForegroundColor Yellow
if (Test-Path "bootstrap\cache") {
    Write-Host "  ✓ bootstrap/cache exists" -ForegroundColor Green
} else {
    Write-Host "  ⚠ bootstrap/cache not found" -ForegroundColor Yellow
    $warnings += "Missing bootstrap/cache folder"
}
Write-Host ""

# 14. Check public/index.php
Write-Host "[14/15] Checking public/index.php..." -ForegroundColor Yellow
if (Test-Path "public\index.php") {
    Write-Host "  ✓ public/index.php exists" -ForegroundColor Green
    $indexContent = Get-Content "public\index.php" -Raw
    if ($indexContent -match "require.*autoload.php" -and $indexContent -match "require.*bootstrap/app.php") {
        Write-Host "    ✓ Required includes found" -ForegroundColor Green
    } else {
        Write-Host "    ⚠ Some includes may be missing" -ForegroundColor Yellow
    }
} else {
    Write-Host "  ✗ public/index.php NOT FOUND!" -ForegroundColor Red
    $issues += "Missing public/index.php"
}
Write-Host ""

# 15. Check artisan
Write-Host "[15/15] Checking artisan..." -ForegroundColor Yellow
if (Test-Path "artisan") {
    Write-Host "  ✓ artisan file exists" -ForegroundColor Green
    try {
        $artisanOutput = php artisan --version 2>&1
        if ($artisanOutput -match "Laravel") {
            Write-Host "    ✓ Artisan working: $artisanOutput" -ForegroundColor Green
        } else {
            Write-Host "    ⚠ Artisan may have issues" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "    ⚠ Could not test artisan" -ForegroundColor Yellow
    }
} else {
    Write-Host "  ✗ artisan NOT FOUND!" -ForegroundColor Red
    $issues += "Missing artisan file"
}
Write-Host ""

# SUMMARY
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  DEBUG SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($issues.Count -eq 0) {
    Write-Host "🎉 EXCELLENT! No critical issues found!" -ForegroundColor Green
    Write-Host "   Application is ready for Railway deployment!" -ForegroundColor Green
} else {
    Write-Host "⚠️  CRITICAL ISSUES FOUND: $($issues.Count)" -ForegroundColor Red
    foreach ($issue in $issues) {
        Write-Host "   • $issue" -ForegroundColor Red
    }
}

Write-Host ""

if ($warnings.Count -gt 0) {
    Write-Host "⚠️  WARNINGS: $($warnings.Count)" -ForegroundColor Yellow
    foreach ($warning in $warnings) {
        Write-Host "   • $warning" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan

# RECOMMENDATIONS
Write-Host "RECOMMENDATIONS:" -ForegroundColor White
Write-Host ""

if ($issues.Count -eq 0) {
    Write-Host "✅ Application is ready to deploy!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor White
    Write-Host "  1. git add . && git commit -m 'Ready for deploy'" -ForegroundColor Cyan
    Write-Host "  2. git push origin main" -ForegroundColor Cyan
    Write-Host "  3. Deploy to Railway following the guide" -ForegroundColor Cyan
} else {
    Write-Host "❌ Fix these issues before deploying:" -ForegroundColor Red
    Write-Host ""
    if ($issues -match "composer") {
        Write-Host "  • Run: composer install" -ForegroundColor Cyan
    }
    if ($issues -match "Duplicate") {
        Write-Host "  • Remove duplicate migration files" -ForegroundColor Cyan
    }
    if ($issues -match "Missing.*folder") {
        Write-Host "  • Create missing folders" -ForegroundColor Cyan
    }
    if ($issues -match "Missing.*php") {
        Write-Host "  • Check if files were deleted accidentally" -ForegroundColor Cyan
    }
}

Write-Host ""
Write-Host "For detailed deployment guide, see: DEPLOY_RAILWAY.md" -ForegroundColor Gray
Write-Host "========================================" -ForegroundColor Cyan

# Hostinger Static Hosting Build Script for Windows
# Run: .\build-hostinger.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  HOSTINGER STATIC HOSTING BUILD" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Build Vite assets
Write-Host "[1/5] Building Vite assets..." -ForegroundColor Yellow
try {
    npm run build
    Write-Host "  ✓ Vite build complete" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Vite build failed" -ForegroundColor Red
    exit 1
}

# Step 2: Create dist folder
Write-Host "[2/5] Creating dist folder..." -ForegroundColor Yellow
if (Test-Path "dist") {
    Remove-Item -Path "dist" -Recurse -Force
}
New-Item -ItemType Directory -Path "dist" -Force | Out-Null
Write-Host "  ✓ dist folder created" -ForegroundColor Green

# Step 3: Copy essential files
Write-Host "[3/5] Copying files to dist..." -ForegroundColor Yellow
Copy-Item -Path "public\build" -Destination "dist\build" -Recurse -Force
Copy-Item -Path "public\index.php" -Destination "dist\index.php" -Force
if (Test-Path "public\favicon.ico") {
    Copy-Item -Path "public\favicon.ico" -Destination "dist\favicon.ico" -Force
}
if (Test-Path "public\robots.txt") {
    Copy-Item -Path "public\robots.txt" -Destination "dist\robots.txt" -Force
}
Write-Host "  ✓ Files copied" -ForegroundColor Green

# Step 4: Create .htaccess
Write-Host "[4/5] Creating .htaccess..." -ForegroundColor Yellow
$htaccess = @"
<IfModule mod_rewrite.c>
    <IfModule mod_negotiation.c>
        Options -MultiViews -Indexes
    </IfModule>

    RewriteEngine On

    # Handle Authorization Header
    RewriteCond %{HTTP:Authorization} .
    RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]

    # Redirect Trailing Slashes If Not A Folder...
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteCond %{REQUEST_URI} (.+)/$
    RewriteRule ^ %1 [L,R=301]

    # Send Requests To Front Controller...
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteRule ^ index.php [L]
</IfModule>
"@
$htaccess | Out-File -FilePath "dist\.htaccess" -Encoding UTF8
Write-Host "  ✓ .htaccess created" -ForegroundColor Green

# Step 5: Create static fallback HTML
Write-Host "[5/5] Creating static fallback..." -ForegroundColor Yellow
$html = @"
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kos Harmoni Pro - Sistem Manajemen Kos</title>
    <link rel="stylesheet" href="/build/assets/app-D09FrdlG.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', system-ui, sans-serif; 
            display: flex; 
            justify-content: center; 
            align-items: center; 
            min-height: 100vh; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .container { 
            text-align: center; 
            padding: 3rem; 
            background: white; 
            border-radius: 1.5rem; 
            box-shadow: 0 25px 50px -12px rgba(0,0,0,0.25);
            max-width: 500px;
            margin: 1rem;
        }
        .logo { 
            width: 80px; 
            height: 80px; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            font-size: 2.5rem;
        }
        h1 { 
            color: #1f2937; 
            margin-bottom: 0.5rem;
            font-size: 1.75rem;
        }
        h2 {
            color: #6b7280;
            font-weight: 500;
            margin-bottom: 1.5rem;
            font-size: 1rem;
        }
        p { 
            color: #6b7280; 
            line-height: 1.6;
            margin-bottom: 1rem;
        }
        .status {
            display: inline-block;
            padding: 0.5rem 1rem;
            background: #dcfce7;
            color: #166534;
            border-radius: 9999px;
            font-size: 0.875rem;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">🏠</div>
        <h1>Kos Harmoni Pro</h1>
        <h2>Sistem Manajemen Kos</h2>
        <p>Aplikasi berhasil di-deploy ke Hostinger.<br>Silakan login ke admin panel untuk mengelola data kos.</p>
        <span class="status">✓ Sistem Online</span>
    </div>
</body>
</html>
"@
$html | Out-File -FilePath "dist\index.html" -Encoding UTF8
Write-Host "  ✓ Static fallback created" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  BUILD COMPLETE! ✅" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Files in dist folder:" -ForegroundColor White
Get-ChildItem "dist" | ForEach-Object { Write-Host "  - $($_.Name)" -ForegroundColor Gray }
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor White
Write-Host "  1. Upload 'dist' folder contents to Hostinger public_html" -ForegroundColor Yellow
Write-Host "  2. Or zip the dist folder and upload via File Manager" -ForegroundColor Yellow
Write-Host ""

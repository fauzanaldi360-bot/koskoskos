#!/bin/bash

# Hostinger Static Hosting Build Script
# This script prepares the Laravel app for Hostinger static hosting

echo "🏗️  Building for Hostinger Static Hosting..."

# Step 1: Build Vite assets
echo "📦 Building Vite assets..."
npm run build

# Step 2: Create dist folder
echo "📁 Creating dist folder..."
mkdir -p dist

# Step 3: Copy essential files to dist
echo "📋 Copying files to dist..."
cp -r public/build dist/
cp public/index.php dist/
cp public/favicon.ico dist/ 2>/dev/null || true
cp public/robots.txt dist/ 2>/dev/null || true

# Step 4: Create .htaccess for Laravel
echo "⚙️  Creating .htaccess..."
cat > dist/.htaccess << 'EOF'
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
EOF

# Step 5: Update index.php to work without vendor
echo "🔧 Updating index.php for static hosting..."
sed -i 's|require __DIR__.'\''/../vendor/autoload.php'\''|// Static hosting - no vendor|g' dist/index.php
sed -i 's|$app = require_once __DIR__.'\''/../bootstrap/app.php'\''|// Static hosting - no bootstrap|g' dist/index.php

# Step 6: Create a simple static HTML as fallback
echo "🌐 Creating static fallback..."
cat > dist/index.html << 'EOF'
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kos Harmoni Pro - Maintenance</title>
    <script src="/build/assets/app-BU6mFzGd.js" defer></script>
    <link rel="stylesheet" href="/build/assets/app-D09FrdlG.css">
    <style>
        body { font-family: system-ui, sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; background: #f3f4f6; }
        .container { text-align: center; padding: 2rem; background: white; border-radius: 1rem; box-shadow: 0 10px 40px rgba(0,0,0,0.1); }
        h1 { color: #1f2937; margin-bottom: 1rem; }
        p { color: #6b7280; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚧 Kos Harmoni Pro</h1>
        <p>Aplikasi dalam mode maintenance.<br>Silakan hubungi administrator.</p>
    </div>
</body>
</html>
EOF

echo "✅ Build complete! dist/ folder ready for Hostinger."
echo "📤 Upload the 'dist' folder contents to Hostinger public_html"

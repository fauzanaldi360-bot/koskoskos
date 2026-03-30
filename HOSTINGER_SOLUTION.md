# Solusi Hostinger - LANGKAH DEMI LANGKAH

## 🚨 MASALAH
Hostinger static hosting mencari folder `dist/` setelah build, tapi Laravel build ke `public/build/`.

## ✅ SOLUSI (2 CARA)

### CARA 1: Build Manual di Local (REKOMENDASI)

**Step 1: Build di komputer Anda**
```powershell
cd C:\Users\Asus\Downloads\kospekanbaru4-lokasi-main
npm run build
```

**Step 2: Buat folder dist dan copy file**
```powershell
# Buat folder dist
mkdir dist

# Copy file yang sudah di-build
cp -r public/build dist/
cp public/index.php dist/
```

**Step 3: Upload ke Hostinger**
1. Zip folder `dist`
2. Upload ke Hostinger File Manager
3. Extract ke `public_html`

---

### CARA 2: Pakai Script PowerShell

**Jalankan:**
```powershell
.\build-hostinger.ps1
```

Script ini otomatis:
1. Build Vite assets
2. Buat folder `dist/`
3. Copy semua file perlu
4. Buat .htaccess
5. Buat index.html static

**Setelah selesai:**
- Upload isi folder `dist/` ke Hostinger public_html

---

### CARA 3: Deploy ke Railway (LEBIH MUDAH!)

**Kenapa Railway lebih baik:**
- ✅ No "output directory" error
- ✅ Auto-deploy dari GitHub
- ✅ Database MySQL gratis
- ✅ Support Laravel runtime
- ✅ SSL otomatis

**Langkah:**
1. Push ke GitHub (sudah)
2. Buka https://railway.app
3. New Project → Deploy from GitHub repo
4. Tambah MySQL database
5. Selesai!

---

## 📝 RINGKASAN

| Platform | Hasil |
|----------|-------|
| Hostinger Static | ⚠️ Perlu build manual, tidak support PHP runtime |
| Railway | ✅ Support Laravel, auto-deploy, database gratis |

**REKOMENDASI: Gunakan Railway!** Sudah siap semua config (Dockerfile, railway.json).

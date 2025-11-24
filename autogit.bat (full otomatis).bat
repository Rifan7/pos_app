@echo off
echo =====================================================
echo   AUTO GIT: Pull -> Add -> Commit -> Push
echo =====================================================
echo.

echo [1] Menarik update terbaru dari GitHub...
git pull origin master
echo.

echo [2] Menambahkan semua perubahan...
git add .
echo.

echo [3] Masukkan pesan commit:
set /p message=Commit message: 
git commit -m "%message%"
echo.

echo [4] Mengirim ke GitHub...
git push origin master
echo.

echo =====================================================
echo   Selesai! Semua sinkron dengan GitHub.
echo =====================================================
pause
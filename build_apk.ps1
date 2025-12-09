# ============================================
# Script para Build do APK - JW Quiz Flutter
# ============================================
# Execute este script para gerar o APK do app
# 
# Uso:
#   .\build_apk.ps1          -> Build release (padrao, otimizado ~66MB)
#   .\build_apk.ps1 debug    -> Build debug (para testes, ~190MB)
#   .\build_apk.ps1 clean    -> Limpa builds anteriores
# ============================================

param(
    [string]$BuildType = "release"
)

$ErrorActionPreference = "Continue"

Clear-Host
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   JW Quiz Flutter - Build APK Script" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se estamos na pasta correta
if (-not (Test-Path "pubspec.yaml")) {
    Write-Host "[ERRO] Este script deve ser executado na pasta raiz do projeto Flutter!" -ForegroundColor Red
    Write-Host "       Navegue ate a pasta do projeto e tente novamente." -ForegroundColor Red
    pause
    exit 1
}

Write-Host "[INFO] Tipo de build: $BuildType" -ForegroundColor Yellow
Write-Host ""

# Se for clean, limpa e sai
if ($BuildType -eq "clean") {
    Write-Host "[LIMPEZA] Executando flutter clean..." -ForegroundColor Yellow
    flutter clean
    Write-Host "          Limpeza concluida!" -ForegroundColor Green
    Write-Host ""
    pause
    exit 0
}

# 1. Obter dependencias
Write-Host "[1/4] Limpando cache anterior..." -ForegroundColor Yellow
flutter clean 2>$null
Write-Host "      Cache limpo!" -ForegroundColor Green
Write-Host ""

# 2. Obter dependencias
Write-Host "[2/4] Obtendo dependencias (pub get)..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERRO] Falha ao obter dependencias!" -ForegroundColor Red
    pause
    exit 1
}
Write-Host "      Dependencias atualizadas!" -ForegroundColor Green
Write-Host ""

# 3. Gerar arquivos de localizacao
Write-Host "[3/4] Gerando arquivos de localizacao..." -ForegroundColor Yellow
flutter gen-l10n 2>$null
Write-Host "      Localizacoes geradas!" -ForegroundColor Green
Write-Host ""

# 4. Build do APK
Write-Host "[4/4] Gerando APK ($BuildType)..." -ForegroundColor Yellow
Write-Host "      Isso pode levar alguns minutos..." -ForegroundColor Gray
Write-Host ""

if ($BuildType -eq "debug") {
    flutter build apk --debug
} else {
    # Release otimizado para ARM64 (maioria dos celulares modernos)
    flutter build apk --release --target-platform android-arm64
}

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Red
    Write-Host "[ERRO] Falha ao gerar o APK!" -ForegroundColor Red
    Write-Host "       Verifique os erros acima." -ForegroundColor Red
    Write-Host "============================================" -ForegroundColor Red
    pause
    exit 1
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "   BUILD CONCLUIDO COM SUCESSO!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""

# Mostrar localizacao do APK
$apkPath = "build\app\outputs\flutter-apk\app-release.apk"
if ($BuildType -eq "debug") {
    $apkPath = "build\app\outputs\flutter-apk\app-debug.apk"
}

if (Test-Path $apkPath) {
    $apkInfo = Get-Item $apkPath
    $apkSizeMB = [math]::Round($apkInfo.Length / 1MB, 2)
    
    Write-Host "APK gerado em:" -ForegroundColor Cyan
    Write-Host "  $((Get-Location).Path)\$apkPath" -ForegroundColor White
    Write-Host ""
    Write-Host "Tamanho: $apkSizeMB MB" -ForegroundColor Cyan
    Write-Host ""
    
    # Abrir a pasta automaticamente
    Write-Host "Abrindo pasta do APK..." -ForegroundColor Yellow
    explorer.exe (Split-Path $apkPath)
} else {
    Write-Host "APK gerado, mas nao foi possivel localizar o arquivo." -ForegroundColor Yellow
}

Write-Host ""
pause

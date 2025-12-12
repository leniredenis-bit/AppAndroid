# ============================================
# Script para Build do APK - JW Quiz Flutter
# ============================================
# Execute este script para gerar o APK do app
# 
# Uso:
#   .\build_apk.ps1          -> Build release (padrao, otimizado)
#   .\build_apk.ps1 debug    -> Build debug (para testes)
#   .\build_apk.ps1 clean    -> Limpa builds anteriores
#   .\build_apk.ps1 quick    -> Build rapido sem clean (debug)
# ============================================

param(
    [string]$BuildType = "release"
)

$ErrorActionPreference = "Continue"

# Funcao para pausar
function Pause-Script {
    Write-Host ""
    Write-Host "Pressione qualquer tecla para continuar..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

Clear-Host
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   JW SPLASH GAMES - Build APK Script" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se estamos na pasta correta
if (-not (Test-Path "pubspec.yaml")) {
    Write-Host "[ERRO] Este script deve ser executado na pasta raiz do projeto Flutter!" -ForegroundColor Red
    Write-Host "       Navegue ate a pasta do projeto e tente novamente." -ForegroundColor Red
    Pause-Script
    exit 1
}

# Verificar se Flutter esta instalado
$flutterVersion = flutter --version 2>$null
if (-not $flutterVersion) {
    Write-Host "[ERRO] Flutter nao encontrado!" -ForegroundColor Red
    Write-Host "       Certifique-se de que o Flutter esta no PATH." -ForegroundColor Red
    Pause-Script
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
    Pause-Script
    exit 0
}

# Build rapido (sem clean)
if ($BuildType -eq "quick") {
    Write-Host "[1/2] Obtendo dependencias..." -ForegroundColor Yellow
    flutter pub get
    Write-Host ""
    Write-Host "[2/2] Gerando APK debug (rapido)..." -ForegroundColor Yellow
    flutter build apk --debug
    
    if ($LASTEXITCODE -eq 0) {
        $apkPath = "build\app\outputs\flutter-apk\app-debug.apk"
        if (Test-Path $apkPath) {
            $apkInfo = Get-Item $apkPath
            $apkSizeMB = [math]::Round($apkInfo.Length / 1MB, 2)
            Write-Host ""
            Write-Host "============================================" -ForegroundColor Green
            Write-Host "   BUILD RAPIDO CONCLUIDO!" -ForegroundColor Green
            Write-Host "============================================" -ForegroundColor Green
            Write-Host ""
            Write-Host "APK: $apkPath" -ForegroundColor Cyan
            Write-Host "Tamanho: $apkSizeMB MB" -ForegroundColor Cyan
            explorer.exe (Split-Path $apkPath)
        }
    } else {
        Write-Host "[ERRO] Falha no build!" -ForegroundColor Red
    }
    Pause-Script
    exit 0
}

# 1. Limpar cache anterior
Write-Host "[1/4] Limpando cache anterior..." -ForegroundColor Yellow
flutter clean 2>$null
Write-Host "      Cache limpo!" -ForegroundColor Green
Write-Host ""

# 2. Obter dependencias
Write-Host "[2/4] Obtendo dependencias (pub get)..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERRO] Falha ao obter dependencias!" -ForegroundColor Red
    Pause-Script
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

$startTime = Get-Date

if ($BuildType -eq "debug") {
    flutter build apk --debug
    $apkPath = "build\app\outputs\flutter-apk\app-debug.apk"
} else {
    # Release otimizado
    flutter build apk --release
    $apkPath = "build\app\outputs\flutter-apk\app-release.apk"
}

$endTime = Get-Date
$buildTime = [math]::Round(($endTime - $startTime).TotalMinutes, 1)

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Red
    Write-Host "[ERRO] Falha ao gerar o APK!" -ForegroundColor Red
    Write-Host "       Verifique os erros acima." -ForegroundColor Red
    Write-Host "============================================" -ForegroundColor Red
    Pause-Script
    exit 1
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "   BUILD CONCLUIDO COM SUCESSO!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""

# Mostrar informacoes do APK
if (Test-Path $apkPath) {
    $apkInfo = Get-Item $apkPath
    $apkSizeMB = [math]::Round($apkInfo.Length / 1MB, 2)
    
    Write-Host "APK gerado em:" -ForegroundColor Cyan
    Write-Host "  $((Get-Location).Path)\$apkPath" -ForegroundColor White
    Write-Host ""
    Write-Host "Tamanho: $apkSizeMB MB" -ForegroundColor Cyan
    Write-Host "Tempo de build: $buildTime minutos" -ForegroundColor Cyan
    Write-Host ""
    
    # Abrir a pasta automaticamente
    Write-Host "Abrindo pasta do APK..." -ForegroundColor Yellow
    explorer.exe (Split-Path $apkPath)
} else {
    Write-Host "APK gerado, mas nao foi possivel localizar o arquivo." -ForegroundColor Yellow
    Write-Host "Verifique a pasta: build\app\outputs\flutter-apk\" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   PROXIMOS PASSOS:" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "1. Copie o APK para seu celular" -ForegroundColor White
Write-Host "2. Permita instalacao de fontes desconhecidas" -ForegroundColor White
Write-Host "3. Instale e teste o app!" -ForegroundColor White
Write-Host ""
Write-Host "Dica: Use '.\build_apk.ps1 quick' para builds rapidos" -ForegroundColor Gray
Write-Host ""

Pause-Script

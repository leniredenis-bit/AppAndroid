# ============================================
# Script para Commit e Push - JW Quiz Flutter
# ============================================
# Execute este script para enviar alteracoes ao GitHub
# 
# Uso:
#   .\git_push.ps1                    -> Commit com mensagem padrao
#   .\git_push.ps1 "Minha mensagem"   -> Commit com mensagem personalizada
# ============================================

param(
    [string]$Mensagem = ""
)

Clear-Host
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   JW Quiz Flutter - Git Push Script" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se estamos na pasta correta
if (-not (Test-Path ".git")) {
    Write-Host "[ERRO] Este script deve ser executado na pasta raiz do projeto!" -ForegroundColor Red
    Write-Host "       Navegue ate a pasta do projeto e tente novamente." -ForegroundColor Red
    pause
    exit 1
}

# Mostrar status atual
Write-Host "[INFO] Verificando alteracoes..." -ForegroundColor Yellow
Write-Host ""
git status --short

$alteracoes = git status --porcelain
if ([string]::IsNullOrWhiteSpace($alteracoes)) {
    Write-Host ""
    Write-Host "[INFO] Nenhuma alteracao para commit!" -ForegroundColor Yellow
    Write-Host ""
    pause
    exit 0
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Se nao passou mensagem, pedir ao usuario
if ([string]::IsNullOrWhiteSpace($Mensagem)) {
    $Mensagem = Read-Host "Digite a mensagem do commit (ou Enter para mensagem padrao)"
    if ([string]::IsNullOrWhiteSpace($Mensagem)) {
        $dataHora = Get-Date -Format "dd/MM/yyyy HH:mm"
        $Mensagem = "Atualizacao - $dataHora"
    }
}

Write-Host ""
Write-Host "[1/3] Adicionando arquivos..." -ForegroundColor Yellow
git add .
Write-Host "      Arquivos adicionados!" -ForegroundColor Green
Write-Host ""

Write-Host "[2/3] Fazendo commit..." -ForegroundColor Yellow
Write-Host "      Mensagem: $Mensagem" -ForegroundColor Gray
git commit -m "$Mensagem"
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERRO] Falha ao fazer commit!" -ForegroundColor Red
    pause
    exit 1
}
Write-Host "      Commit realizado!" -ForegroundColor Green
Write-Host ""

Write-Host "[3/3] Enviando para GitHub (push)..." -ForegroundColor Yellow
git push
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERRO] Falha ao enviar para GitHub!" -ForegroundColor Red
    Write-Host "       Verifique sua conexao e credenciais." -ForegroundColor Red
    pause
    exit 1
}
Write-Host "      Push concluido!" -ForegroundColor Green
Write-Host ""

Write-Host "============================================" -ForegroundColor Green
Write-Host "   ALTERACOES ENVIADAS COM SUCESSO!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Repositorio: https://github.com/leniredenis-bit/AppAndroid" -ForegroundColor Cyan
Write-Host ""
pause

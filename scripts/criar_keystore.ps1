# ============================================
# Cria a chave de upload (keystore) do Android - JW Splash Games
# ============================================
# Execute UMA VEZ. A keystore identifica voce como dono do app na Play Store.
#  - Fica FORA do repositorio: %USERPROFILE%\keystores\jwsplashgames-upload.jks
#  - Gera android\key.properties (ignorado pelo git)
#  - FACA BACKUP da .jks e da senha (gerenciador de senhas + nuvem privada).
#    Com o Play App Signing ativo, uma chave de upload perdida pode ser
#    redefinida pelo suporte do Google, mas isso leva dias.
#
# Uso (na raiz do projeto):  powershell -ExecutionPolicy Bypass -File scripts\criar_keystore.ps1
# ============================================

$ErrorActionPreference = "Stop"

$keystoreDir  = Join-Path $env:USERPROFILE "keystores"
$keystorePath = Join-Path $keystoreDir "jwsplashgames-upload.jks"
$alias        = "upload"
$propsPath    = Join-Path $PSScriptRoot "..\android\key.properties"

if (Test-Path $keystorePath) {
    Write-Host "[ERRO] Ja existe uma keystore em $keystorePath" -ForegroundColor Red
    Write-Host "       Nao sobrescreva: ela e necessaria para atualizar o app." -ForegroundColor Red
    exit 1
}

# Localiza o keytool (PATH ou JAVA_HOME)
$keytool = (Get-Command keytool -ErrorAction SilentlyContinue).Source
if (-not $keytool -and $env:JAVA_HOME) { $keytool = Join-Path $env:JAVA_HOME "bin\keytool.exe" }
if (-not $keytool -or -not (Test-Path $keytool)) {
    Write-Host "[ERRO] keytool nao encontrado. Configure JAVA_HOME (JDK 17+)." -ForegroundColor Red
    exit 1
}

$secure  = Read-Host "Escolha uma senha para a keystore (min. 6 caracteres)" -AsSecureString
$secure2 = Read-Host "Repita a senha" -AsSecureString
$pass  = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure))
$pass2 = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure2))
if ($pass -ne $pass2 -or $pass.Length -lt 6) {
    Write-Host "[ERRO] Senhas diferentes ou muito curtas." -ForegroundColor Red
    exit 1
}

New-Item -ItemType Directory -Force $keystoreDir | Out-Null

& $keytool -genkeypair -v `
    -keystore $keystorePath `
    -alias $alias `
    -keyalg RSA -keysize 2048 -validity 10000 `
    -storepass $pass -keypass $pass `
    -dname "CN=JW Splash Games, O=JW Splash Games, C=BR"

if ($LASTEXITCODE -ne 0) { Write-Host "[ERRO] Falha ao gerar a keystore." -ForegroundColor Red; exit 1 }

$storeFile = $keystorePath -replace '\', '/'
@"
storePassword=$pass
keyPassword=$pass
keyAlias=$alias
storeFile=$storeFile
"@ | Set-Content -Encoding ascii $propsPath

Write-Host ""
Write-Host "Keystore criada: $keystorePath" -ForegroundColor Green
Write-Host "Configuracao:    android\key.properties" -ForegroundColor Green
Write-Host ""
Write-Host "AGORA: faca backup da .jks e anote a senha em local seguro!" -ForegroundColor Yellow

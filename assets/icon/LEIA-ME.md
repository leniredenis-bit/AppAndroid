# Arte do ícone e splash

Coloque aqui os arquivos abaixo e rode os comandos.

| Arquivo | Tamanho | Observações |
|---|---|---|
| `app_icon.png` | 1024×1024 | Ícone completo, **sem transparência** (Apple recusa alfa). Usado no iOS, web e Android antigo. |
| `app_icon_foreground.png` | 1024×1024 | Mesmo desenho com fundo transparente; mantenha o conteúdo nos 66% centrais (o Android recorta em círculo/squircle). |
| `splash_logo.png` | 1152×1152 | Logo com fundo transparente; conteúdo dentro de um círculo de ~768px (regra do Android 12+). |

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

Depois confira em um aparelho Android e no TestFlight. Esta pasta não está
listada em `assets:` do pubspec, então os arquivos não aumentam o tamanho do app.

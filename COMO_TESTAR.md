# 🧪 Como Testar o App Flutter

## Pré-requisitos

Antes de começar, certifique-se de que o Flutter está no PATH do PowerShell:

```powershell
$env:Path += ";C:\tools\flutter\bin"
```

> **Dica**: Adicione essa linha ao seu perfil do PowerShell para não precisar repetir.

## Método 1: Teste no Chrome (Mais Rápido)

```powershell
# No diretório do projeto:
cd "C:\Users\NOTEBOOK 63\Desktop\Bot Benefícios\jw_quiz_flutter"

# Executar no Chrome
flutter run -d chrome
```

### O que testar:
1. **Tela Welcome**
   - Botão "Começar" deve navegar para Home
   - Botão "Estatísticas" mostra mensagem (em breve)

2. **Tela Home**
   - **Filtros de Dificuldade**: Clique em Fácil/Médio/Difícil
     - Deve destacar o selecionado
     - Clicar novamente desmarca
   - **Filtros de Tags**: Clique em Gênesis/Êxodo/Evangelhos/Profetas
     - Deve destacar o selecionado
     - Clicar novamente desmarca
   - **Botão "Quiz Clássico"**: 
     - Clica e inicia o quiz
     - Respeita filtros selecionados
   - **Outros botões**: Mostram "em breve"

3. **Tela Quiz**
   - ✅ Timer de 30s deve contar regressivamente
   - ✅ Timer fica vermelho quando ≤10s
   - ✅ Clicar em alternativa:
     - Verde se correta
     - Vermelho se errada
     - Avança automaticamente após 2s
   - ✅ Pontuação aumenta a cada acerto
   - ✅ Ao final, mostra dialog com resultado
   - ✅ Botão "Voltar" retorna para Home

### Testar Filtros:
- **Sem filtros**: Deve sortear 10 perguntas aleatórias
- **Dificuldade Fácil**: Apenas perguntas fáceis
- **Tag Gênesis**: Apenas perguntas de Gênesis
- **Fácil + Gênesis**: Intersecção (pode não ter perguntas)

## Método 2: Teste no Android Emulador

### Pré-requisitos:
1. Instalar Android Studio
2. Configurar emulador Android

### Comandos:
```powershell
# Listar dispositivos disponíveis
flutter devices

# Executar no emulador
flutter run -d emulator-5554
```

## Método 3: Build para Web

```powershell
# Build otimizado para produção
flutter build web

# Os arquivos estarão em: build/web/
# Para servir localmente:
cd build/web
python -m http.server 8000
# Acesse: http://localhost:8000
```

## 🐛 Problemas Comuns

### 1. "flutter não reconhecido"
```powershell
# Solução:
$env:Path += ";C:\tools\flutter\bin"
flutter --version
```

### 2. "Nenhuma pergunta encontrada"
- Verifique se `assets/data/perguntas_atualizado.json` existe
- Verifique se `pubspec.yaml` tem:
  ```yaml
  flutter:
    assets:
      - assets/audio/
      - assets/data/
  ```
- Execute: `flutter pub get`

### 3. Chrome não abre
```powershell
# Verificar se Chrome está instalado:
flutter doctor

# Tentar com outro navegador:
flutter run -d edge
```

### 4. Erro de build web (shader)
- Isso é um bug conhecido do Flutter
- Use `flutter run -d chrome` para desenvolvimento
- Ou teste no Android

## 📊 Checklist de Testes

### Tela Welcome
- [ ] Título "JW Quiz" aparece
- [ ] Emoji 📖 aparece
- [ ] Botão "Começar" funciona
- [ ] Navega para Home ao clicar

### Tela Home
- [ ] Filtros de dificuldade são clicáveis
- [ ] Filtros de tags são clicáveis
- [ ] Seleção/deseleção funciona
- [ ] Botão Quiz Clássico inicia quiz
- [ ] Outros botões mostram "em breve"

### Tela Quiz
- [ ] Timer inicia em 30s
- [ ] Timer decrementa
- [ ] Timer fica vermelho em 10s
- [ ] Alternativas são clicáveis
- [ ] Feedback de cor (verde/vermelho)
- [ ] Pontuação aumenta
- [ ] Avança para próxima pergunta
- [ ] 10 perguntas no total
- [ ] Dialog de resultado aparece
- [ ] Mostra pontuação correta
- [ ] Mostra acertos/total
- [ ] Botão "Voltar" funciona

### Filtros
- [ ] Sem filtro: 10 perguntas aleatórias
- [ ] Filtro dificuldade funciona
- [ ] Filtro tag funciona
- [ ] Combinação de filtros funciona
- [ ] Mensagem se não há perguntas

## 🚀 Performance

### Verificar:
- [ ] Navegação é fluida (sem lag)
- [ ] Timer é preciso (1s = 1s)
- [ ] Transições são suaves
- [ ] Feedback visual é instantâneo
- [ ] Carregamento de perguntas é rápido

## 📱 Responsividade

### Testar em diferentes tamanhos:
- [ ] Desktop (Chrome)
- [ ] Tablet (emulador)
- [ ] Mobile (emulador)
- [ ] Resize da janela (Chrome)

## 🎨 UI/UX

### Verificar:
- [ ] Cores correspondem ao design (azul escuro)
- [ ] Botões têm padding adequado
- [ ] Texto é legível
- [ ] Emoji aparecem corretamente
- [ ] Cards têm bordas arredondadas
- [ ] Espaçamento é consistente

## 📝 Logs e Debug

### Ver logs no console:
```powershell
# Console do Flutter mostra:
- Erros de compilação
- Warnings
- Print statements
- Hot reload status
```

### Debug no Chrome:
1. Abrir DevTools (F12)
2. Ver console para erros JavaScript
3. Network tab para ver carregamento de assets

## 🔄 Hot Reload

Durante o desenvolvimento:
- Salvar arquivo → Hot reload automático
- Mudanças de UI aparecem instantaneamente
- Estado do app é preservado

## ✅ Resultado Esperado

Ao finalizar os testes, você deve ter:
- ✅ App rodando sem crashes
- ✅ Navegação fluida entre telas
- ✅ Quiz funcional com timer e pontuação
- ✅ Filtros funcionando corretamente
- ✅ Feedback visual claro
- ✅ Performance adequada

## 🎯 Próximos Testes (Após Implementação)

Quando implementar:
- **Memory Game**: Teste lógica de pares, virar cartas
- **Audio**: Teste play/pause, volume
- **Persistência**: Teste salvar/carregar dados
- **Estatísticas**: Teste cálculos e gráficos

---

**Bons testes! 🚀**

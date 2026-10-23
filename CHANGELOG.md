# Changelog

Formato: versão (`pubspec.yaml`) · data · mudanças. Use as linhas "Para a loja" como texto de "Novidades".

## 1.0.0+2 · preparação para as lojas (21/10/2026)
**Para a loja:** Primeira versão! Quiz bíblico, 8 minigames (incluindo o novo Colorir) e multiplayer online.

### Minigames (revisão completa: docs/dev/REVISAO_MINIGAMES.md)
- 🆕 Colorir: importe qualquer desenho de contorno (as áreas são detectadas automaticamente), 7 desenhos + tela livre, balde, pincel, borracha, brilho, tons, desfazer, zoom, progresso salvo e "virar quebra-cabeça"
- Quebra-Cabeça reescrito (encaixe correto, toque preciso, bandeja, 9–36 peças)
- Labirinto reescrito (30 níveis, gemas, deslizar, cavernas escuras com lanterna)
- Sequência Rápida + Cristal unificadas em Sequência Cristal (notas musicais, 3 modos)
- Forca com cena ilustrada, 50 palavras com dicas por idioma, acentos corrigidos
- Caça-Palavras: dificuldades, dicas, toque-toque, grade sempre solucionável
- Memória: virada 3D, combos, espiada inicial, grade que sempre cabe
- Jogo da Velha: IA em 3 níveis, resultado animado
- Efeitos sonoros reais (antes não existiam), menu redesenhado, conquistas corrigidas e traduzidas

### Lançamento
- Multiplayer online real com Firebase (login anônimo, regras de segurança, fim de rodada automático, timeout do anfitrião)
- Android: assinatura de release, App Bundle, permissões mínimas (sem câmera/galeria/ID de publicidade)
- iOS: bundle ID, Firebase no projeto Xcode, Podfile, somente iPhone, build via Codemagic
- Política de privacidade atualizada (app + web) e aviso de app independente
- Créditos das músicas (CC BY 4.0) na tela Sobre; removidos itens provisórios
- Corrigida a música de fundo de 5 minigames
- Documentação reorganizada

## 1.0.0+1 · versão de testes (dez/2025)
- Quiz com 1.180 perguntas (PT/EN/ES), 8 minigames, conquistas, estatísticas
- Analytics, Crashlytics e chat de suporte Crisp
- APK distribuído para testes no Android

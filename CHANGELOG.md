# Changelog

Formato: versão (`pubspec.yaml`) · data · mudanças. Use as linhas "Para a loja" como texto de "Novidades".

## 1.0.0+2 · preparação para as lojas (21/10/2026)
**Para a loja:** Primeira versão! Quiz bíblico, 8 minigames (incluindo o novo Colorir) e multiplayer online.

### App (docs/dev/PLANO_MELHORIAS_APP.md)
- Tema claro e escuro de verdade, com contraste revisado; texto maior; liga/desliga de vibração; zerar progresso
- Nova tela inicial com Pergunta do Dia (programável por data, link para o texto diário), destaque do Quiz e atalhos
- Quiz: barra de tempo animada, letras A–D, sequência de acertos com bônus, modo estudo, tempo esgotado conta nas
  estatísticas, confirmação ao sair, tela final com estrelas e revisão dos erros, "Jogar de novo"
- Janela "Personalizar" (dificuldade, tema, quantidade) para o Clássico e o Torta na Cara
- Torta na Cara: nomes dos jogadores, torta voando em quem erra, tela de campeão e revanche
- Estatísticas (gráfico de evolução, temas fortes e fracos), Conquistas ("quase lá"), Configurações, Sobre e Termos redesenhados
- Música e cronômetros pausam com o app em segundo plano; volumes salvos valem desde a abertura
- Boas-vindas só na primeira vez (com escolha de idioma); textos restantes traduzidos (PT/EN/ES)
- Ícones e textos proporcionais ao tamanho dos cartões; largura máxima em telas grandes

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

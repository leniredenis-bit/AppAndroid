# 📝 Ajustes Pendentes (para revisar depois)

Lista única de coisas para ajustar mais tarde. Itens novos entram aqui; ao fazer, mova para o `CHANGELOG.md`.
Prioridade: 🔴 alta · 🟡 média · 🟢 baixa

## Conteúdo
- 🟡 **Pergunta do Dia alinhada ao texto diário**: preencher `assets/data/pergunta_do_dia.json` com
  `"AAAA-MM-DD": "id_da_pergunta"` (ou perguntas novas) seguindo o tema do texto diário de cada dia.
  ⚠️ Não copiar o texto diário para o app (direitos autorais): usar só a referência e o link para
  o site oficial, como já é feito.
- 🟡 Criar perguntas novas específicas para a Pergunta do Dia (hoje usa o banco existente).
- 🟢 Mais desenhos para colorir (Davi e Golias, Jardim do Éden, Moisés e o mar…).
- 🟢 Rever o texto dos Termos sobre a Tradução do Novo Mundo ("usada com permissão") — só manter se houver permissão.

## App
- 🟡 Testar no celular a sensação do novo Quiz (barra de tempo, avanço automático em 12s) e da Home.
- 🟡 Pergunta do Dia: decidir se vale pontos/conquista própria (ex.: "7 dias seguidos").
- 🟢 Multiplayer e minigames ficam sempre escuros (visual de jogo). Reavaliar depois do teste com usuários.
- 🟡 Testar a fórmula do timer com pessoas reais (palavras ÷ 2 + 10s; +5s nas difíceis).
- 🟢 Salvar pintura do Colorir na galeria do celular (exige plugin e permissão).
- 🟢 Sons específicos no Labirinto e revisão geral de volumes no aparelho.
- 🟢 Mais idiomas (FR, DE, IT) e avatar personalizável.

## Técnico / lançamento
- 🔴 Aceitar a licença do Android SDK (`flutter doctor --android-licenses`) para gerar o APK.
- 🔴 Arte do ícone e da splash (`assets/icon/LEIA-ME.md`).
- 🟡 Limpeza automática de salas antigas no Firebase.
- 🟢 Upload de dSYM do Crashlytics no iOS.

Ideias maiores e antigas: [dev/IDEIAS_FUTURAS.md](dev/IDEIAS_FUTURAS.md) · Plano de lançamento: [../PLANO_LANCAMENTO.md](../PLANO_LANCAMENTO.md)

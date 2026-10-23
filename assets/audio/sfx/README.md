# Efeitos Sonoros (SFX)

Todos os arquivos `.wav` desta pasta são **sintetizados** por `scripts/generate_sfx.py`
(sem samples de terceiros, sem licença a creditar). Para ajustar um som, edite o script e rode:

```bash
python scripts/generate_sfx.py
```

Uso no código: `AudioService().playSfx('snap')` ou os atalhos `playClick()`, `playMatch()`, `playNote(3)`…

| Som | Uso |
|---|---|
| click, pop, whoosh | interface |
| card_flip, match, mismatch, combo | memória |
| correct, wrong, star | acertos / estrelas |
| victory, game_over | fim de partida |
| snap, pickup | quebra-cabeça |
| step, bump, gem | labirinto |
| paint, erase | colorir |
| note_0 … note_8 | notas dos cristais (sequência) |

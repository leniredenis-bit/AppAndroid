# 🖼️ Imagens para Quebra-Cabeça

## Arquivos Necessários

Para o jogo de Quebra-Cabeça funcionar completamente, adicione as seguintes imagens nesta pasta:

- `puzzle1.jpg` - Imagem 1 (sugestão: paisagem bíblica, natureza)
- `puzzle2.jpg` - Imagem 2 (sugestão: animais, flores)
- `puzzle3.jpg` - Imagem 3 (sugestão: arte religiosa)
- `puzzle4.jpg` - Imagem 4 (sugestão: cena bíblica)

## Especificações

- **Formato**: JPG ou PNG
- **Tamanho recomendado**: 500x500 pixels (quadrada)
- **Peso máximo**: 500KB por imagem
- **Licença**: Use imagens de domínio público ou com licença CC0

## Fontes Recomendadas

1. **Unsplash** (CC0): https://unsplash.com/
2. **Pixabay** (CC0): https://pixabay.com/
3. **Pexels** (CC0): https://pexels.com/
4. **Wikimedia Commons**: https://commons.wikimedia.org/

## Categorias Sugeridas

- Natureza criada por Deus (flores, montanhas, oceanos)
- Animais
- Paisagens tranquilas
- Arte inspiradora (não fotografias de pessoas para evitar questões de privacidade)

## Solução Temporária

Se preferir testar o jogo antes de adicionar imagens:

1. Comente as linhas do `_systemImages` no arquivo `jigsaw_puzzle_game.dart`
2. Use apenas a opção de "Carregar da Galeria" para selecionar imagens do dispositivo
3. Ou baixe 4 imagens quadradas de 500x500px e renomeie como indicado acima

## Exemplo de Busca no Unsplash

```
puzzle1.jpg: "mountain landscape" 500x500
puzzle2.jpg: "colorful flowers" 500x500
puzzle3.jpg: "ocean sunset" 500x500  
puzzle4.jpg: "forest pathway" 500x500
```

Após adicionar as imagens, execute:
```bash
flutter pub get
```

E reinicie o app para carregar os assets.

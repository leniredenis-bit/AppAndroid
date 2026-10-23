# Guia de Contribuicao Unificado (JW)

Este guia unifica o fluxo de contribuicao para o ecossistema JW com foco no AppAndroid.

## Regras gerais

- Trabalhar em branch curta e objetiva
- Commit pequeno e com mensagem clara (Conventional Commits)
- Testar antes de abrir PR
- Atualizar documentacao quando alterar comportamento

## Padrao de branches

- feature/nome-curto
- fix/nome-curto
- docs/nome-curto
- refactor/nome-curto
- test/nome-curto

## Padrao de commits

- feat: nova funcionalidade
- fix: correcao de bug
- docs: documentacao
- refactor: refatoracao sem alterar regra de negocio
- test: testes
- chore: manutencao

## Fluxo recomendado

1. Sincronize branch principal
2. Crie branch de trabalho
3. Implemente com escopo pequeno
4. Rode validacoes
5. Abra PR com descricao clara

## Validacoes minimas

### Para AppAndroid (Flutter)

- flutter pub get
- flutter analyze
- flutter test
- flutter run (emulador/dispositivo)

### Para referencias JW-Quiz (Web)

Quando houver alteracao na parte web, validar localmente via servidor HTTP e checar console sem erros.

## Qualidade de codigo

- Nomes claros e consistentes
- Evitar funcoes longas
- Comentarios apenas quando agregam contexto
- Sem credenciais em codigo

## Documentacao

- Mudou fluxo? atualize guia correspondente
- Mudou requisito de build/publicacao? atualize checklist de publicacao
- Mudou setup local? atualize guias de ambiente

## Escopo oficial do repositorio

A partir desta consolidacao, o foco de desenvolvimento passa a ser AppAndroid.
Arquivos de outros repositorios JW ficam como referencia historica ou funcional.

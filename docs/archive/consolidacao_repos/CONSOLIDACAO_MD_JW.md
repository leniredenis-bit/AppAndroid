# Consolidacao Markdown JW

## Lista de tarefas (inicio ao fim)

- [x] Inventariar todos os .md de AppAndroid, JW-Quiz, JWQuizFlutter e JWQuizAndroid
- [x] Detectar duplicados exatos por hash SHA-256
- [x] Escolher arquivo canonico por prioridade (AppAndroid > JW-Quiz > JWQuizFlutter > JWQuizAndroid)
- [x] Copiar somente os arquivos canonicos para revisao em AppAndroid/docs/jw_unificado/unificados
- [x] Separar conflitos de mesmo nome com conteudo diferente em AppAndroid/docs/jw_unificado/conflitos_nome
- [x] Gerar relatorios tecnicos (JSON) para rastreabilidade
- [x] Revisar conflitos de nome e gerar versoes finais unificadas
- [x] Aprovar limpeza final (manter apenas versao final em AppAndroid e arquivar o restante) — concluido em 21/10/2026

## Resumo

- Total de arquivos analisados: 84
- Arquivos canonicos (unicos por conteudo): 54
- Duplicados exatos removidos da revisao: 30
- Grupos de duplicados exatos: 30
- Nomes com conflito de conteudo: 3

## Estrutura gerada

- AppAndroid/docs/jw_unificado/md_inventory.json
- AppAndroid/docs/jw_unificado/canonicos.json
- AppAndroid/docs/jw_unificado/duplicados_exatos.json
- AppAndroid/docs/jw_unificado/conflitos_nome.json
- AppAndroid/docs/jw_unificado/unificados/...
- AppAndroid/docs/jw_unificado/conflitos_nome/...
- AppAndroid/docs/jw_unificado/finais/README_JW_UNIFICADO.md
- AppAndroid/docs/jw_unificado/finais/CONTRIBUTING_JW_UNIFICADO.md
- AppAndroid/docs/jw_unificado/finais/COMO_CRIAR_APK_UNIFICADO.md

## Criterio de canonico

- Prioridade por repositorio: AppAndroid, depois JW-Quiz, depois JWQuizFlutter, depois JWQuizAndroid
- Em empate: caminho relativo menor

## Limpeza final (21/10/2026)

- Docs do AppAndroid reorganizadas: ver `docs/README.md` e `PLANO_LANCAMENTO.md` na raiz.
- Mantidos aqui: relatorios JSON, versoes `finais/` e as docs originais do projeto web (`docs_JW-Quiz_original/`).
- Removidos (eram copias identicas de arquivos que continuam nos repositorios de origem e no historico git):
  `unificados/AppAndroid`, `unificados/JWQuizFlutter`, `unificados/JWQuizAndroid`, `conflitos_nome/`.
- Copia integral anterior a limpeza: `../AppAndroid_backup_2026-10-21/docs/jw_unificado`.

"""
Script para REMOVER o campo 'referencia' (texto completo) do JSON de perguntas.

SITUAÇÃO ATUAL (após inversão manual):
{
  "texto_biblico": "Gênesis 6:13-14",      ← Referência (será link clicável)
  "referencia": "Depois, Deus disse..."    ← Texto completo (REMOVER - direitos autorais)
}

RESULTADO FINAL:
{
  "texto_biblico": "Gênesis 6:13-14",      ← Apenas a referência como link
  "referencia": null                        ← Removido
}

MOTIVO: Evitar violação de direitos autorais ao copiar textos bíblicos completos.
SOLUÇÃO: Manter apenas a referência bíblica que vira um link clicável para JW.org/app.
"""

import json
import os

# Caminho do arquivo
INPUT_FILE = r"c:\Users\NOTEBOOK 63\Desktop\Bot Benefícios\jw_quiz_flutter\assets\data\perguntas_atualizado.json"
OUTPUT_FILE = r"c:\Users\NOTEBOOK 63\Desktop\Bot Benefícios\jw_quiz_flutter\assets\data\perguntas.json"
BACKUP_FILE = r"c:\Users\NOTEBOOK 63\Desktop\Bot Benefícios\jw_quiz_flutter\assets\data\perguntas_antes_remover_texto.json"

def remover_texto_completo():
    """Remove o campo referencia (que agora contém o texto completo) de todas as perguntas"""
    
    print("🔄 Removendo textos bíblicos completos do JSON...")
    print("   (Mantendo apenas as referências como links)\n")
    
    # 1. Fazer backup do arquivo atual
    if os.path.exists(INPUT_FILE):
        import shutil
        shutil.copy(INPUT_FILE, BACKUP_FILE)
        print(f"✅ Backup criado: {BACKUP_FILE}\n")
    
    # 2. Carregar JSON
    print(f"📖 Lendo arquivo: {INPUT_FILE}")
    with open(INPUT_FILE, 'r', encoding='utf-8') as f:
        perguntas = json.load(f)
    
    print(f"📊 Total de perguntas: {len(perguntas)}\n")
    
    # 3. Remover campo 'referencia' (que tem o texto completo)
    perguntas_processadas = 0
    total_chars_removidos = 0
    
    for pergunta in perguntas:
        # Medir quantos caracteres estamos removendo (para relatório)
        if pergunta.get('referencia'):
            total_chars_removidos += len(pergunta['referencia'])
        
        # REMOVER o texto completo (agora em 'referencia')
        pergunta['referencia'] = None
        perguntas_processadas += 1
    
    # 4. Salvar arquivo limpo
    print(f"💾 Salvando arquivo limpo: {OUTPUT_FILE}")
    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        json.dump(perguntas, f, ensure_ascii=False, indent=2)
    
    # 5. Relatório
    tamanho_antes = os.path.getsize(INPUT_FILE)
    tamanho_depois = os.path.getsize(OUTPUT_FILE)
    economia = tamanho_antes - tamanho_depois
    
    print("\n" + "="*70)
    print("✅ LIMPEZA CONCLUÍDA COM SUCESSO!")
    print("="*70)
    print(f"📊 Perguntas processadas: {perguntas_processadas}")
    print(f"📝 Caracteres de texto removidos: {total_chars_removidos:,}")
    print(f"💾 Tamanho antes: {tamanho_antes:,} bytes")
    print(f"💾 Tamanho depois: {tamanho_depois:,} bytes")
    print(f"✂️  Economia de espaço: {economia:,} bytes ({economia/tamanho_antes*100:.1f}%)")
    print(f"\n📁 Arquivo final: {OUTPUT_FILE}")
    print(f"💾 Backup: {BACKUP_FILE}")
    print("\n🎯 PRÓXIMOS PASSOS:")
    print("1. Verificar o arquivo perguntas.json gerado")
    print("2. Testar o app - as referências devem aparecer como links clicáveis")
    print("3. Clicar em uma referência deve abrir JW Library (se instalado) ou jw.org")
    print("4. Se tudo OK, pode deletar perguntas_atualizado.json")
    print("="*70)

if __name__ == "__main__":
    try:
        remover_texto_completo()
    except Exception as e:
        print(f"\n❌ ERRO: {e}")
        import traceback
        traceback.print_exc()

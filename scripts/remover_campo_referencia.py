"""
Script para APENAS REMOVER o campo 'referencia' do JSON.
NÃO inverte nada, apenas remove o campo que contém o texto completo.

ENTRADA (já invertido manualmente):
{
  "texto_biblico": "Gênesis 6:13-14",      ← Mantém (é a referência)
  "referencia": "Depois, Deus disse..."    ← REMOVE (texto completo)
}

SAÍDA:
{
  "texto_biblico": "Gênesis 6:13-14",      ← Mantém
  "referencia": null                        ← Removido
}
"""

import json
import os

# Caminhos
INPUT_FILE = r"c:\Users\NOTEBOOK 63\Desktop\Bot Benefícios\jw_quiz_flutter\assets\data\perguntas_atualizado.json"
OUTPUT_FILE = r"c:\Users\NOTEBOOK 63\Desktop\Bot Benefícios\jw_quiz_flutter\assets\data\perguntas.json"

def remover_campo_referencia():
    """Remove APENAS o campo referencia, sem inverter nada"""
    
    print("🗑️  Removendo campo 'referencia' (texto completo)...")
    print("   Mantendo 'texto_biblico' (referência bíblica)\n")
    
    # Carregar JSON
    print(f"📖 Lendo: {INPUT_FILE}")
    with open(INPUT_FILE, 'r', encoding='utf-8') as f:
        perguntas = json.load(f)
    
    print(f"📊 Total de perguntas: {len(perguntas)}\n")
    
    # APENAS remover o campo 'referencia'
    chars_removidos = 0
    for pergunta in perguntas:
        if pergunta.get('referencia'):
            chars_removidos += len(str(pergunta['referencia']))
        pergunta['referencia'] = None  # Apenas isto!
    
    # Salvar
    print(f"💾 Salvando: {OUTPUT_FILE}")
    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        json.dump(perguntas, f, ensure_ascii=False, indent=2)
    
    # Relatório
    tamanho_antes = os.path.getsize(INPUT_FILE)
    tamanho_depois = os.path.getsize(OUTPUT_FILE)
    economia = tamanho_antes - tamanho_depois
    
    print("\n" + "="*70)
    print("✅ SUCESSO!")
    print("="*70)
    print(f"📝 Caracteres removidos: {chars_removidos:,}")
    print(f"💾 Antes: {tamanho_antes:,} bytes")
    print(f"💾 Depois: {tamanho_depois:,} bytes")
    print(f"✂️  Economia: {economia:,} bytes ({economia/tamanho_antes*100:.1f}%)")
    print(f"\n📁 Arquivo gerado: {OUTPUT_FILE}")
    print("="*70)

if __name__ == "__main__":
    try:
        remover_campo_referencia()
    except Exception as e:
        print(f"\n❌ ERRO: {e}")
        import traceback
        traceback.print_exc()

import json
import os
import time
from deep_translator import GoogleTranslator
from tqdm import tqdm

# Caminhos dos arquivos
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
INPUT_FILE = os.path.join(BASE_DIR, 'assets', 'data', 'perguntas.json')
OUTPUT_FILE_EN = os.path.join(BASE_DIR, 'assets', 'data', 'perguntas_en_gpt.json')
OUTPUT_FILE_ES = os.path.join(BASE_DIR, 'assets', 'data', 'perguntas_es_gpt.json')

# Mapeamento de livros bíblicos (PT -> EN / ES)
# Adicione mais livros conforme necessário
BIBLE_BOOKS = {
    "Gênesis": {"en": "Genesis", "es": "Génesis"},
    "Êxodo": {"en": "Exodus", "es": "Éxodo"},
    "Levítico": {"en": "Leviticus", "es": "Levítico"},
    "Números": {"en": "Numbers", "es": "Números"},
    "Deuteronômio": {"en": "Deuteronomy", "es": "Deuteronomio"},
    "Josué": {"en": "Joshua", "es": "Josué"},
    "Juízes": {"en": "Judges", "es": "Jueces"},
    "Rute": {"en": "Ruth", "es": "Rut"},
    "1 Samuel": {"en": "1 Samuel", "es": "1 Samuel"},
    "2 Samuel": {"en": "2 Samuel", "es": "2 Samuel"},
    "1 Reis": {"en": "1 Kings", "es": "1 Reyes"},
    "2 Reis": {"en": "2 Kings", "es": "2 Reyes"},
    "1 Crônicas": {"en": "1 Chronicles", "es": "1 Crónicas"},
    "2 Crônicas": {"en": "2 Chronicles", "es": "2 Crónicas"},
    "Esdras": {"en": "Ezra", "es": "Esdras"},
    "Neemias": {"en": "Nehemiah", "es": "Nehemías"},
    "Ester": {"en": "Esther", "es": "Ester"},
    "Jó": {"en": "Job", "es": "Job"},
    "Salmos": {"en": "Psalms", "es": "Salmos"},
    "Provérbios": {"en": "Proverbs", "es": "Proverbios"},
    "Eclesiastes": {"en": "Ecclesiastes", "es": "Eclesiastés"},
    "Cântico de Salomão": {"en": "Song of Solomon", "es": "Cantar de los Cantares"},
    "Isaías": {"en": "Isaiah", "es": "Isaías"},
    "Jeremias": {"en": "Jeremiah", "es": "Jeremías"},
    "Lamentações": {"en": "Lamentations", "es": "Lamentaciones"},
    "Ezequiel": {"en": "Ezekiel", "es": "Ezequiel"},
    "Daniel": {"en": "Daniel", "es": "Daniel"},
    "Oseias": {"en": "Hosea", "es": "Oseas"},
    "Joel": {"en": "Joel", "es": "Joel"},
    "Amós": {"en": "Amos", "es": "Amós"},
    "Obadias": {"en": "Obadiah", "es": "Abdías"},
    "Jonas": {"en": "Jonah", "es": "Jonás"},
    "Miqueias": {"en": "Micah", "es": "Miqueas"},
    "Naum": {"en": "Nahum", "es": "Nahúm"},
    "Habacuque": {"en": "Habakkuk", "es": "Habacuc"},
    "Sofonias": {"en": "Zephaniah", "es": "Sofonías"},
    "Ageu": {"en": "Haggai", "es": "Hageo"},
    "Zacarias": {"en": "Zechariah", "es": "Zacarías"},
    "Malaquias": {"en": "Malachi", "es": "Malaquías"},
    "Mateus": {"en": "Matthew", "es": "Mateo"},
    "Marcos": {"en": "Mark", "es": "Marcos"},
    "Lucas": {"en": "Luke", "es": "Lucas"},
    "João": {"en": "John", "es": "Juan"},
    "Atos": {"en": "Acts", "es": "Hechos"},
    "Romanos": {"en": "Romans", "es": "Romanos"},
    "1 Coríntios": {"en": "1 Corinthians", "es": "1 Corintios"},
    "2 Coríntios": {"en": "2 Corinthians", "es": "2 Corintios"},
    "Gálatas": {"en": "Galatians", "es": "Gálatas"},
    "Efésios": {"en": "Ephesians", "es": "Efesios"},
    "Filipenses": {"en": "Philippians", "es": "Filipenses"},
    "Colossenses": {"en": "Colossians", "es": "Colosenses"},
    "1 Tessalonicenses": {"en": "1 Thessalonians", "es": "1 Tesalonicenses"},
    "2 Tessalonicenses": {"en": "2 Thessalonians", "es": "2 Tesalonicenses"},
    "1 Timóteo": {"en": "1 Timothy", "es": "1 Timoteo"},
    "2 Timóteo": {"en": "2 Timothy", "es": "2 Timoteo"},
    "Tito": {"en": "Titus", "es": "Tito"},
    "Filemom": {"en": "Philemon", "es": "Filemón"},
    "Hebreus": {"en": "Hebrews", "es": "Hebreos"},
    "Tiago": {"en": "James", "es": "Santiago"},
    "1 Pedro": {"en": "1 Peter", "es": "1 Pedro"},
    "2 Pedro": {"en": "2 Peter", "es": "2 Pedro"},
    "1 João": {"en": "1 John", "es": "1 Juan"},
    "2 João": {"en": "2 John", "es": "2 Juan"},
    "3 João": {"en": "3 John", "es": "3 Juan"},
    "Judas": {"en": "Jude", "es": "Judas"},
    "Apocalipse": {"en": "Revelation", "es": "Apocalipsis"},
    "Apocalipse (Revelação)": {"en": "Revelation", "es": "Apocalipsis"}
}

def translate_text(text, target_lang):
    if not text:
        return text
    try:
        # Tenta traduzir
        translated = GoogleTranslator(source='pt', target=target_lang).translate(text)
        return translated
    except Exception as e:
        print(f"Erro ao traduzir '{text}': {e}")
        return text

def translate_bible_reference(ref, target_lang):
    if not ref:
        return ref
    
    # Tenta substituir o nome do livro
    for pt_book, translations in BIBLE_BOOKS.items():
        if pt_book in ref:
            return ref.replace(pt_book, translations[target_lang])
    
    return ref

def process_translations():
    print("Lendo arquivo de perguntas...")
    with open(INPUT_FILE, 'r', encoding='utf-8') as f:
        questions = json.load(f)

    # Limitar para teste se necessário, ou processar tudo
    # questions = questions[:10] 

    translated_en = []
    translated_es = []

    print(f"Iniciando tradução de {len(questions)} perguntas...")

    # Check if partial files exist to resume? For now, just overwrite or start fresh.
    # To make it robust, we could load existing and skip.
    
    for i, q in enumerate(tqdm(questions)):
        try:
            # Copia estrutura base
            q_en = q.copy()
            q_es = q.copy()

            # Traduzir para Inglês
            q_en['pergunta'] = translate_text(q['pergunta'], 'en')
            q_en['opcoes'] = [translate_text(opt, 'en') for opt in q['opcoes']]
            q_en['resposta_correta'] = translate_text(q['resposta_correta'], 'en')
            q_en['tags'] = [translate_text(tag, 'en') for tag in q['tags']]
            q_en['texto_biblico'] = translate_bible_reference(q['texto_biblico'], 'en')

            # Traduzir para Espanhol
            q_es['pergunta'] = translate_text(q['pergunta'], 'es')
            q_es['opcoes'] = [translate_text(opt, 'es') for opt in q['opcoes']]
            q_es['resposta_correta'] = translate_text(q['resposta_correta'], 'es')
            q_es['tags'] = [translate_text(tag, 'es') for tag in q['tags']]
            q_es['texto_biblico'] = translate_bible_reference(q['texto_biblico'], 'es')

            translated_en.append(q_en)
            translated_es.append(q_es)
            
            # Salvar a cada 50 itens para garantir progresso
            if (i + 1) % 50 == 0:
                with open(OUTPUT_FILE_EN, 'w', encoding='utf-8') as f:
                    json.dump(translated_en, f, ensure_ascii=False, indent=2)
                with open(OUTPUT_FILE_ES, 'w', encoding='utf-8') as f:
                    json.dump(translated_es, f, ensure_ascii=False, indent=2)

        except Exception as e:
            print(f"Erro no item {i}: {e}")
            # Salva o que tem e continua ou para? Melhor continuar.
            continue

    print("Salvando arquivos finais...")
    with open(OUTPUT_FILE_EN, 'w', encoding='utf-8') as f:
        json.dump(translated_en, f, ensure_ascii=False, indent=2)
    
    with open(OUTPUT_FILE_ES, 'w', encoding='utf-8') as f:
        json.dump(translated_es, f, ensure_ascii=False, indent=2)

    print("Concluído!")

if __name__ == "__main__":
    process_translations()

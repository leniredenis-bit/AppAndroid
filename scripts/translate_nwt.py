import json
import time
import re
from deep_translator import GoogleTranslator

# --- CONFIGURAÇÕES DO USUÁRIO ---
# Escolha o modo de operação:
# 'traduzir_en' -> Traduz do PT para Inglês (com glossário NWT)
# 'traduzir_es' -> Traduz do PT para Espanhol (com glossário NWT)
# 'revisar_pt'  -> Não traduz, apenas corrige termos do PT para o padrão NWT
MODO_OPERACAO = 'traduzir_en' 

ARQUIVO_ENTRADA = 'assets/data/perguntas.json'  # Seu arquivo original
# O nome do arquivo de saída será gerado automaticamente baseado no modo

# --- GLOSSÁRIOS NWT (Expandi com termos chave da teologia TJ) ---
GLOSSARIO = {
    'en': {
        # Termos Fundamentais
        "Jeová": "Jehovah",
        "Senhor": "Lord",
        "Deus": "God",
        
        # Terminologia Específica
        "cruz": "torture stake",
        "madeiro": "stake",
        "estaca": "stake",
        "estaca de tortura": "torture stake",
        "inferno": "the Grave",
        "hades": "the Grave",
        "sheol": "the Grave",
        "espírito santo": "holy spirit",
        "Espírito Santo": "holy spirit",
        
        # Estrutura Bíblica
        "Antigo Testamento": "Hebrew Scriptures",
        "Novo Testamento": "Christian Greek Scriptures",
        "Velho Testamento": "Hebrew Scriptures",
        
        # Doutrinas e Expressões
        "graça": "undeserved kindness",
        "bondade imerecida": "undeserved kindness",
        "igreja": "congregation",
        "congregação": "congregation",
        "reino de Deus": "Kingdom of God",
        "Reino de Deus": "Kingdom of God",
        "fim do mundo": "conclusion of the system of things",
        "fim dos tempos": "last days",
        "sistema de coisas": "system of things",
        "presença": "presence",
        "vinda": "coming",
        "alma": "soul",
        "sábado": "Sabbath",
        "páscoa": "Passover",
        "Páscoa": "Passover",
        "magos": "astrologers",
        "reis magos": "astrologers",
        "sábios": "wise men",
        "gentios": "people of the nations",
        "nações": "nations",
        
        # Nomes próprios bíblicos
        "Noé": "Noah",
        "Moisés": "Moses",
        "Abraão": "Abraham",
        "Davi": "David",
        "Daniel": "Daniel",
        "José": "Joseph",
        "Elias": "Elijah",
        "Paulo": "Paul",
        "Judas Iscariotes": "Judas Iscariot",
        "Pedro": "Peter",
        "Tiago": "James",
        "Tomé": "Thomas",
        "João Batista": "John the Baptist",
        "Maria": "Mary",
        "Jesus": "Jesus",
        "Josué": "Joshua",
        "Calebe": "Caleb",
        "Arão": "Aaron",
        "Samuel": "Samuel",
        "Golias": "Goliath",
        "Ester": "Esther",
        "Rute": "Ruth",
        "Jezabel": "Jezebel",
        "Saulo": "Saul",
        "Salomão": "Solomon",
        "Isaías": "Isaiah",
        "Jeremias": "Jeremiah",
        "Ezequiel": "Ezekiel",
        "João": "John",
        "Mateus": "Matthew",
        "Marcos": "Mark",
        "Lucas": "Luke",
        "Simão": "Simon",
        "André": "Andrew",
        "Filipe": "Philip",
        "Bartolomeu": "Bartholomew",
        "Natanael": "Nathanael",
        "Jacó": "Jacob",
        "Esaú": "Esau",
        "Isaque": "Isaac",
        "Sara": "Sarah",
        "Rebeca": "Rebekah",
        "Raquel": "Rachel",
        "Lia": "Leah",
        "Ana": "Hannah",
        "Eva": "Eve",
        "Adão": "Adam",
        "Caim": "Cain",
        "Abel": "Abel",
        "Sansão": "Samson",
        "Gideão": "Gideon",
        "Jefté": "Jephthah",
        "Débora": "Deborah",
        "Eliseu": "Elisha",
        "Natã": "Nathan",
        "Bate-Seba": "Bathsheba",
        "Absalão": "Absalom",
        "Lázaro": "Lazarus",
        "Marta": "Martha",
        "Zacarias": "Zechariah",
        "Isabel": "Elizabeth",
        "Estêvão": "Stephen",
        "Jonas": "Jonah",
        "Oseias": "Hosea",
        "Ló": "Lot",
        "Raabe": "Rahab",
        "Abigail": "Abigail",
        "Neemias": "Nehemiah",
        "Esdras": "Ezra",
        "Ananias": "Ananias",
        "Safira": "Sapphira",
        "Silas": "Silas",
        "Barnabé": "Barnabas",
        "Timóteo": "Timothy",
        
        # Lugares
        "Jerusalém": "Jerusalem",
        "Belém": "Bethlehem",
        "Nazaré": "Nazareth",
        "Egito": "Egypt",
        "Israel": "Israel",
        "Babilônia": "Babylon",
        "Nínive": "Nineveh",
        "Jericó": "Jericho",
        "Cafarnaum": "Capernaum",
        "Getsêmani": "Gethsemane",
        "Gólgota": "Golgotha",
        "Éden": "Eden",
        "Sinai": "Sinai",
        "Carmelo": "Carmel",
        "Sodoma": "Sodom",
        "Roma": "Rome",
        "Atenas": "Athens",
        "Corinto": "Corinth",
        "Filipos": "Philippi",
        "Betânia": "Bethany",
        "Damasco": "Damascus",
        
        # Livros da Bíblia
        "Gênesis": "Genesis",
        "Êxodo": "Exodus",
        "Levítico": "Leviticus",
        "Números": "Numbers",
        "Deuteronômio": "Deuteronomy",
        "Juízes": "Judges",
        "Salmos": "Psalms",
        "Provérbios": "Proverbs",
        "Eclesiastes": "Ecclesiastes",
        "Apocalipse": "Revelation",
        "Atos": "Acts",
        "Romanos": "Romans",
        "Coríntios": "Corinthians",
        "Gálatas": "Galatians",
        "Efésios": "Ephesians",
        "Filipenses": "Philippians",
        "Colossenses": "Colossians",
        "Tessalonicenses": "Thessalonians",
        "Timóteo": "Timothy",
        "Tito": "Titus",
        "Filemom": "Philemon",
        "Hebreus": "Hebrews",
        "Apocalipse (Revelação)": "Revelation",
        "Crônicas": "Chronicles",
        "Lamentações": "Lamentations",
        "Cântico de Salomão": "Song of Solomon",
        "Obadias": "Obadiah",
        "Miqueias": "Micah",
        "Naum": "Nahum",
        "Habacuque": "Habakkuk",
        "Sofonias": "Zephaniah",
        "Ageu": "Haggai",
        "Malaquias": "Malachi",
        "Amós": "Amos",
        "Joel": "Joel",
        "Judas": "Jude"
    },
    'es': {
        # Termos Fundamentais
        "Jeová": "Jehová",
        "Senhor": "Señor",
        "Deus": "Dios",
        
        # Terminologia Específica
        "cruz": "madero de tormento",
        "madeiro": "madero",
        "estaca": "madero",
        "estaca de tortura": "madero de tormento",
        "inferno": "la Tumba",
        "hades": "la Tumba",
        "sheol": "el Seol",
        "espírito santo": "espíritu santo",
        "Espírito Santo": "espíritu santo",
        
        # Estrutura Bíblica
        "Antigo Testamento": "Escrituras Hebreas",
        "Novo Testamento": "Escrituras Griegas Cristianas",
        
        # Doutrinas e Expressões
        "graça": "bondad inmerecida",
        "bondade imerecida": "bondad inmerecida",
        "igreja": "congregación",
        "congregação": "congregación",
        "reino de Deus": "Reino de Dios",
        "Reino de Deus": "Reino de Dios",
        "fim do mundo": "conclusión del sistema de cosas",
        "sistema de coisas": "sistema de cosas",
        "presença": "presencia",
        "sábado": "sábado",
        "páscoa": "Pascua",
        "Páscoa": "Pascua",
        "magos": "astrólogos",
        "reis magos": "astrólogos",
        "gentios": "gente de las naciones",
        
        # Nomes próprios bíblicos
        "Noé": "Noé",
        "Moisés": "Moisés",
        "Abraão": "Abraham",
        "Davi": "David",
        "Daniel": "Daniel",
        "José": "José",
        "Elias": "Elías",
        "Paulo": "Pablo",
        "Judas Iscariotes": "Judas Iscariote",
        "Pedro": "Pedro",
        "Tiago": "Santiago",
        "Tomé": "Tomás",
        "João Batista": "Juan el Bautista",
        "Maria": "María",
        "Jesus": "Jesús",
        "Josué": "Josué",
        "Calebe": "Caleb",
        "Arão": "Aarón",
        "Samuel": "Samuel",
        "Golias": "Goliat",
        "Ester": "Ester",
        "Rute": "Rut",
        "Jezabel": "Jezabel",
        "Saulo": "Saulo",
        "Salomão": "Salomón",
        "Isaías": "Isaías",
        "Jeremias": "Jeremías",
        "Ezequiel": "Ezequiel",
        "João": "Juan",
        "Mateus": "Mateo",
        "Marcos": "Marcos",
        "Lucas": "Lucas",
        "Simão": "Simón",
        "André": "Andrés",
        "Filipe": "Felipe",
        "Bartolomeu": "Bartolomé",
        "Natanael": "Natanael",
        "Jacó": "Jacob",
        "Esaú": "Esaú",
        "Isaque": "Isaac",
        "Sara": "Sara",
        "Rebeca": "Rebeca",
        "Raquel": "Raquel",
        "Lia": "Lea",
        "Ana": "Ana",
        "Eva": "Eva",
        "Adão": "Adán",
        "Caim": "Caín",
        "Abel": "Abel",
        "Sansão": "Sansón",
        "Gideão": "Gedeón",
        "Jefté": "Jefté",
        "Débora": "Débora",
        "Eliseu": "Eliseo",
        "Natã": "Natán",
        "Bate-Seba": "Betsabé",
        "Absalão": "Absalón",
        "Lázaro": "Lázaro",
        "Marta": "Marta",
        "Zacarias": "Zacarías",
        "Isabel": "Isabel",
        "Estêvão": "Esteban",
        "Jonas": "Jonás",
        "Oseias": "Oseas",
        "Ló": "Lot",
        "Raabe": "Rahab",
        "Abigail": "Abigail",
        "Neemias": "Nehemías",
        "Esdras": "Esdras",
        "Ananias": "Ananías",
        "Safira": "Safira",
        "Silas": "Silas",
        "Barnabé": "Bernabé",
        "Timóteo": "Timoteo",
        
        # Lugares
        "Jerusalém": "Jerusalén",
        "Belém": "Belén",
        "Nazaré": "Nazaret",
        "Egito": "Egipto",
        "Israel": "Israel",
        "Babilônia": "Babilonia",
        "Nínive": "Nínive",
        "Jericó": "Jericó",
        "Cafarnaum": "Capernaúm",
        "Getsêmani": "Getsemaní",
        "Gólgota": "Gólgota",
        "Éden": "Edén",
        "Sinai": "Sinaí",
        "Carmelo": "Carmelo",
        "Sodoma": "Sodoma",
        "Roma": "Roma",
        "Atenas": "Atenas",
        "Corinto": "Corinto",
        "Filipos": "Filipos",
        "Betânia": "Betania",
        "Damasco": "Damasco",
        
        # Livros da Bíblia
        "Gênesis": "Génesis",
        "Êxodo": "Éxodo",
        "Levítico": "Levítico",
        "Números": "Números",
        "Deuteronômio": "Deuteronomio",
        "Juízes": "Jueces",
        "Salmos": "Salmos",
        "Provérbios": "Proverbios",
        "Eclesiastes": "Eclesiastés",
        "Apocalipse": "Apocalipsis",
        "Atos": "Hechos",
        "Romanos": "Romanos",
        "Coríntios": "Corintios",
        "Gálatas": "Gálatas",
        "Efésios": "Efesios",
        "Filipenses": "Filipenses",
        "Colossenses": "Colosenses",
        "Tessalonicenses": "Tesalonicenses",
        "Timóteo": "Timoteo",
        "Tito": "Tito",
        "Filemom": "Filemón",
        "Hebreus": "Hebreos",
        "Apocalipse (Revelação)": "Apocalipsis",
        "Crônicas": "Crónicas",
        "Lamentações": "Lamentaciones",
        "Cântico de Salomão": "Cantar de los Cantares",
        "Obadias": "Abdías",
        "Miqueias": "Miqueas",
        "Naum": "Nahúm",
        "Habacuque": "Habacuc",
        "Sofonias": "Sofonías",
        "Ageu": "Hageo",
        "Malaquias": "Malaquías",
        "Amós": "Amós",
        "Joel": "Joel",
        "Judas": "Judas"
    }
}

def aplicar_glossario(texto, idioma):
    if not texto or not isinstance(texto, str):
        return texto
    
    dicionario = GLOSSARIO.get(idioma, {})
    
    # Ordena chaves por tamanho (decrescente) para evitar que "magos" substitua "reis magos" pela metade
    termos_ordenados = sorted(dicionario.keys(), key=len, reverse=True)
    
    novo_texto = texto
    for termo_orig in termos_ordenados:
        termo_subst = dicionario[termo_orig]
        
        # Regex para substituir ignorando maiúsculas/minúsculas (case insensitive)
        # A flag re.IGNORECASE faz a mágica
        padrao = re.compile(re.escape(termo_orig), re.IGNORECASE)
        novo_texto = padrao.sub(termo_subst, novo_texto)
             
    return novo_texto

def processar_arquivo():
    # Definição de parâmetros baseados no modo
    if MODO_OPERACAO == 'traduzir_en':
        idioma_alvo = 'en'
        sufixo = '_en_gpt'
        traduzir = True
    elif MODO_OPERACAO == 'traduzir_es':
        idioma_alvo = 'es'
        sufixo = '_es_gpt'
        traduzir = True
    elif MODO_OPERACAO == 'revisar_pt':
        idioma_alvo = 'pt'
        sufixo = '_pt_revisado'
        traduzir = False
    else:
        print("Modo inválido.")
        return

    arquivo_saida = ARQUIVO_ENTRADA.replace('.json', f'{sufixo}.json')
    
    print(f"--- Iniciando Processo: {MODO_OPERACAO} ---")
    
    try:
        with open(ARQUIVO_ENTRADA, 'r', encoding='utf-8') as f:
            dados = json.load(f)
    except FileNotFoundError:
        print(f"Erro: O arquivo {ARQUIVO_ENTRADA} não foi encontrado.")
        return

    # Inicializa tradutor apenas se necessário
    tradutor = None
    if traduzir:
        tradutor = GoogleTranslator(source='pt', target=idioma_alvo)
    
    total = len(dados)
    dados_processados = []

    for i, item in enumerate(dados):
        novo_item = item.copy()
        
        try:
            # --- Processamento da PERGUNTA ---
            texto_pergunta = item['pergunta']
            if traduzir:
                texto_pergunta = tradutor.translate(texto_pergunta)
                time.sleep(0.05)  # Pequeno delay para evitar bloqueio
            # Aplica glossário (seja no texto traduzido ou no original em PT)
            novo_item['pergunta'] = aplicar_glossario(texto_pergunta, idioma_alvo)
            
            # --- Processamento das OPÇÕES ---
            novas_opcoes = []
            for opcao in item['opcoes']:
                texto_opt = opcao
                if traduzir:
                    texto_opt = tradutor.translate(texto_opt)
                    time.sleep(0.05)
                novas_opcoes.append(aplicar_glossario(texto_opt, idioma_alvo))
            novo_item['opcoes'] = novas_opcoes
            
            # --- Processamento da RESPOSTA CORRETA ---
            texto_resp = item['resposta_correta']
            if traduzir:
                texto_resp = tradutor.translate(texto_resp)
                time.sleep(0.05)
            novo_item['resposta_correta'] = aplicar_glossario(texto_resp, idioma_alvo)
            
            # --- Processamento das TAGS ---
            if traduzir:
                novas_tags = []
                for tag in item['tags']:
                    # Primeiro aplica glossário, depois traduz se não estiver no glossário
                    tag_com_glossario = aplicar_glossario(tag, idioma_alvo)
                    if tag_com_glossario == tag:  # Se não mudou, traduz
                        tag_t = tradutor.translate(tag)
                        time.sleep(0.05)
                        novas_tags.append(tag_t)
                    else:
                        novas_tags.append(tag_com_glossario)
                novo_item['tags'] = novas_tags
            else:
                # Se for revisar_pt, aplica glossário nas tags
                novo_item['tags'] = [aplicar_glossario(tag, idioma_alvo) for tag in item['tags']]

            # --- Processamento do TEXTO BÍBLICO ---
            if item.get('texto_biblico'):
                texto_bib = item['texto_biblico']
                # Aplica glossário primeiro (para livros da Bíblia)
                texto_bib = aplicar_glossario(texto_bib, idioma_alvo)
                # Não traduz o resto, pois são referências (números de capítulos/versículos)
                novo_item['texto_biblico'] = texto_bib

            dados_processados.append(novo_item)
            
            # Feedback visual
            if (i + 1) % 10 == 0:
                print(f"Processado {i+1}/{total}: ID {item.get('id')}")

        except Exception as e:
            print(f"Erro no ID {item.get('id')}: {e}")
            dados_processados.append(item) # Mantém original em caso de erro crítico

    # Salvar
    with open(arquivo_saida, 'w', encoding='utf-8') as f:
        json.dump(dados_processados, f, indent=2, ensure_ascii=False)
    
    print(f"--- Sucesso! Arquivo gerado: {arquivo_saida} ---")

if __name__ == "__main__":
    processar_arquivo()

#!/usr/bin/env python3
"""
Script para corrigir 'Key? key' para 'super.key' em constructors.
"""

import re
from pathlib import Path

def fix_super_key_in_file(file_path):
    """Corrige Key? key para super.key em um arquivo."""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original_content = content
    
    # Pattern 1: const ClassName({Key? key}) : super(key: key);
    pattern1 = r'(\w+)\(\{Key\?\s+key\}\)\s*:\s*super\(key:\s*key\);'
    replacement1 = r'\1({super.key});'
    content = re.sub(pattern1, replacement1, content)
    
    # Pattern 2: const ClassName({
    #              Key? key,
    #              required this.field,
    #            }) : super(key: key);
    pattern2 = r'(\{)\s*Key\?\s+key,\s*'
    replacement2 = r'\1\n    super.key,\n    '
    content = re.sub(pattern2, replacement2, content)
    
    # Pattern 3: Remove : super(key: key) quando já tem super.key
    pattern3 = r'\}\)\s*:\s*super\(key:\s*key\);'
    replacement3 = r'});'
    content = re.sub(pattern3, replacement3, content)
    
    if content != original_content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        return True
    return False

def main():
    files_to_fix = [
        'lib/screens/multiplayer/create_room_screen.dart',
        'lib/screens/multiplayer/final_result_screen.dart',
        'lib/screens/multiplayer/join_room_screen.dart',
        'lib/screens/multiplayer/lobby_screen.dart',
        'lib/screens/multiplayer/multiplayer_menu_screen.dart',
        'lib/screens/multiplayer/multiplayer_quiz_screen.dart',
        'lib/screens/multiplayer/round_result_screen.dart',
        'lib/screens/quiz_screen.dart',
        'lib/screens/stats_screen.dart',
        'lib/screens/welcome_screen.dart',
        'lib/widgets/settings_dialog.dart',
    ]
    
    fixed_count = 0
    
    print("🔧 Corrigindo super.key...\n")
    
    for file_path in files_to_fix:
        path = Path(file_path)
        if path.exists():
            if fix_super_key_in_file(path):
                print(f"✅ {file_path}")
                fixed_count += 1
        else:
            print(f"⚠️  Arquivo não encontrado: {file_path}")
    
    print(f"\n✨ Concluído! {fixed_count} arquivos modificados")

if __name__ == '__main__':
    main()

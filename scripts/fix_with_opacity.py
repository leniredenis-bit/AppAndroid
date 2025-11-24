#!/usr/bin/env python3
"""
Script para substituir .withOpacity() por .withValues(alpha:)
em todos os arquivos Dart do projeto.
"""

import re
import os
from pathlib import Path

def fix_with_opacity_in_file(file_path):
    """Substitui withOpacity por withValues em um arquivo."""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original_content = content
    
    # Pattern: .withOpacity(0.5) -> .withValues(alpha: 0.5)
    # Precisa capturar valores decimais como 0.1, 0.05, etc.
    pattern = r'\.withOpacity\(([\d.]+)\)'
    replacement = r'.withValues(alpha: \1)'
    
    content = re.sub(pattern, replacement, content)
    
    if content != original_content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        return True
    return False

def main():
    # Encontrar todos os arquivos .dart no projeto
    lib_path = Path('lib')
    dart_files = list(lib_path.rglob('*.dart'))
    
    fixed_count = 0
    total_files = 0
    
    print(f"🔍 Encontrados {len(dart_files)} arquivos Dart")
    print("📝 Corrigindo withOpacity()...\n")
    
    for dart_file in dart_files:
        if fix_with_opacity_in_file(dart_file):
            print(f"✅ {dart_file}")
            fixed_count += 1
        total_files += 1
    
    print(f"\n✨ Concluído!")
    print(f"📊 {fixed_count}/{total_files} arquivos modificados")

if __name__ == '__main__':
    main()

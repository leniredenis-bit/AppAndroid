# 🚀 INÍCIO RÁPIDO - Transformar em App Mobile

## ⚡ 3 PASSOS SIMPLES

### 1️⃣ INSTALAR NODE.JS
1. Baixe: https://nodejs.org/ (versão LTS)
2. Execute o instalador
3. Reinicie o VS Code
4. Teste: `node --version`

### 2️⃣ CONFIGURAR CAPACITOR
```powershell
cd "c:\Users\NOTEBOOK 63\Desktop\Bot Benefícios\quiz-biblico"
npm install @capacitor/core @capacitor/cli @capacitor/android
npx cap init "Quiz Bíblico JW" com.jwquiz.app
npx cap add android
npx cap sync
```

### 3️⃣ BUILD ANDROID
```powershell
npx cap open android
```
No Android Studio:
- Build → Generate Signed Bundle (AAB)
- Crie um keystore quando solicitado
- Aguarde o build
- Arquivo gerado: `android/app/release/app-release.aab`

---

## 📚 DOCUMENTAÇÃO COMPLETA

- **Guia Detalhado:** `GUIA_MOBILE_CAPACITOR.md` (passo a passo completo)
- **Comandos Rápidos:** `COMANDOS_RAPIDOS.md` (copiar e colar)

---

## 💰 CUSTOS

- Google Play: **US$25** (uma vez)
- Apple Store: **US$99/ano**
- Mac para iOS: **US$20-60** (aluguel pontual)

---

## ✅ CHECKLIST

- [ ] Node.js instalado
- [ ] Capacitor configurado
- [ ] Android Studio instalado
- [ ] AAB gerado
- [ ] Conta Google Play criada
- [ ] App publicado!

---

## 🆘 PRECISA DE AJUDA?

Leia `GUIA_MOBILE_CAPACITOR.md` ou me pergunte! 🚀

**Tempo estimado:** 1-2 dias para publicar no Google Play

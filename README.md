# 🎨 Custom Font Service

<p align="left">
  <img src="https://img.shields.io/badge/Rojo-7.7.0--rc.1-orange?style=for-the-badge&logo=roblox" />
  <img src="https://img.shields.io/badge/Luau-Success-blue?style=for-the-badge&logo=lua" />
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" />
</p>

**Custom Font Service**, Roblox projelerinde **Roblox dışından yüklenmiş (custom PNG tabanlı)** fontları merkezi bir yapı üzerinden yönetmek, UI elemanlarına dinamik olarak font atamak ve **Rojo workflow** ile uyumlu çalışmak için geliştirilmiş bir Luau servis modülüdür.

---

## ✨ Özellikler

- 🎨 `Font.new(fontName)` ile custom font oluşturma  
- 📦 Merkezi font yönetimi  
- 🧩 Instance tabanlı servis (`CustomFontService.new()`)  
- ⚡ UI elemanlarına dinamik font atama  
- 🔁 TextLabel, TextButton, TextBox desteği  
- 🛠️ Rojo ile tam uyum  
- 🚀 Hafif ve performanslı yapı  

---

## 🚀 Kurulum (Setup)

### 1️⃣ Projeyi Build Et

```bash
rojo build -o "customFontService.rbxlx"
```

## 2️⃣ Roblox Studio

- Oluşan `.rbxlx` dosyasını **Roblox Studio**’da aç  
- `customFontService` modülünü **ReplicatedStorage** (veya kendi `shared` klasör yapına) taşı  

---

## 🧠 Çalışma Mantığı

- Fontlar, **Roblox dışından yüklenmiş custom PNG font asset’leri** kullanır  
- Her font `Font.new(fontName)` ile oluşturulur  
- Fontlar servis instance’ı içinde saklanır  
- UI elemanlarına fontlar **isim üzerinden** atanır  

---

## 📦 Kullanım (Usage)

### 1️⃣ Servisi Oluştur

```lua
local CustomFontService = require(ReplicatedStorage.customFontService)

local FontService = CustomFontService.new()
```

### 2️⃣ Font Oluşturma

```lua
FontService:CreateFont(
    "InterBold",
    Font.new("Inter-Bold")
)
```

> `Font.new()` içine verilen isim, Roblox dışından yüklenmiş font asset’ini temsil eder.

---

### 3️⃣ UI Elemanına Font Atama

```lua
FontService:ApplyFont(TextLabel, "InterBold")
```

## 🧩 API Referansı

### `CustomFontService.new()`

Yeni bir custom font service instance’ı oluşturur.

---

### `CreateFont(name: string, font: Font)`

Yeni bir font kaydı oluşturur.

**Parametreler:**
- `name` → Font adı  
- `font` → `Font.new()` ile oluşturulmuş font  

---

### `ApplyFont(instance: GuiObject, fontName: string)`

Belirtilen UI objesine font uygular.

---

### `GetFont(fontName: string): Font`

Kayıtlı bir fontu döndürür.

---

## 📁 Örnek Rojo Dosya Yapısı

```text
src/
 ├─ shared/
 │   └─ customFontService.lua
 ├─ client/
 └─ server/
 ```

 ## 🛡️ Best Practices

- Fontları UI oluşturulmadan **önce** register et  
- Aynı fontu tekrar tekrar oluşturma  
- Font isimlerini **sabit (constant)** olarak kullan  

---

## 🤝 Katkıda Bulunma

Pull request ve issue’lar açıktır.  
Büyük değişiklikler için önce issue açılması önerilir.

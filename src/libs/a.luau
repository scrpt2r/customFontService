--[[
local textSpriteHandler = require(script.Parent.textSpriteHandler) -- Modülü aldık varsayıyorum

function __main__:renderAsRich(tree, attributes)
    -- Attribute'ları birleştir (Renk, boyut vs.)
    local currentAttributes = mergeAttributes(attributes, tree.attributes)

    for k, node in ipairs(tree.children) do
        if typeof(node) == "string" then
            local length = string.len(node)
            local text = string.split(node, "")

            for i = 1, length do
                local letter = text[i]
                
                -- BOŞLUK KONTROLÜ (Önemli)
                if letter == " " then
                    -- Boşluk kadar sağa kay (Örn: 20 piksel)
                    self.Cursor = self.Cursor + Vector2.new(20, 0)
                    continue -- Döngüyü pas geç, resim basma
                end

                local encodedLetter = unicode.convert(letter)
                -- Eğer harf yoksa '?' (63) kullan
                local charData = self.fontData[encodedLetter] or self.fontData[63]

                if charData then
                    -- 1. SPRITE OLUŞTUR (textSpriteHandler kullanarak)
                    -- Not: textSpriteHandler.new içine ImageLabel parametrelerini gönderiyoruz
                    local sprite = textSpriteHandler.new("ImageLabel", false) 
                    
                    -- 2. RESMİ YÜKLE (Atlas ID ve Koordinatlar)
                    -- charData'nın içinde muhtemelen x, y, width, height var
                    sprite.Instance.Image = self.fontData.AtlasImageID -- Atlas ID'si nerede tutuluyorsa
                    sprite.Instance.ImageRectOffset = Vector2.new(charData.x, charData.y)
                    sprite.Instance.ImageRectSize = Vector2.new(charData.width, charData.height)
                    
                    -- 3. POZİSYONLAMA (Scale Mantığı ile)
                    -- Bir önceki konuşmamızdaki formülü buraya gömüyoruz:
                    local finalX = self.Cursor.X + (charData.xoffset or 0)
                    local finalY = self.Cursor.Y + (charData.yoffset or 0)

                    sprite.Instance.Size = UDim2.fromScale(
                        charData.width / self.ReferenceSize.X,
                        charData.height / self.ReferenceSize.Y
                    )
                    
                    sprite.Instance.Position = UDim2.fromScale(
                        finalX / self.ReferenceSize.X,
                        finalY / self.ReferenceSize.Y
                    )

                    -- 4. RICH TEXT ÖZELLİKLERİ (Renk vs.)
                    if currentAttributes then
                        if currentAttributes.color then
                            -- fontEditor burada devreye girebilir: Hex to Color3 çevirimi için
                            -- sprite.Instance.ImageColor3 = fontEditor.HexToColor(currentAttributes.color)
                             print("Renk uygulanacak:", currentAttributes.color)
                        end
                        -- Başka efektler (Shake, Wave) varsa sprite'a tag ekle
                    end

                    -- 5. SAHNEYE KOY
                    sprite.Instance.Parent = self.Container

                    -- 6. İMLECİ İLERLET
                    -- Bir sonraki harf, bu harfin genişliği + biraz boşluk (xadvance) kadar öteye gitmeli
                    local advance = charData.xadvance or charData.width
                    self.Cursor = self.Cursor + Vector2.new(advance, 0)
                end
            end
            
        elseif typeof(node) == "table" then
            -- Recursive devam et
            self:renderAsRich(node, currentAttributes)
        end
    end
end
]]

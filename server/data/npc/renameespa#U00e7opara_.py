import xml.etree.ElementTree as ET

# Dados fornecidos (IDs e nomes de itens)
stored_items = {
    26731: "leaf stone",
    26723: "boost stone",
    26736: "water stone",
    26735: "venom stone",
    26734: "thunder stone",
    26733: "rock stone",
    26732: "punch stone",
    26728: "fire stone",
    26730: "ice stone",
    26724: "cocoon stone",
    26749: "ancient stone",
    26725: "crystal stone",
    26726: "darkness stone",
    26742: "earth stone",
    26727: "enigma stone",
    26747: "metal stone",
    26748: "sun stone",
    26743: "feather stone",
    26746: "king's rock stone",
    26744: "dragon stone",
    41605: "Bug gosme",
    41607: "Enchanted gem",
    41608: "Bandaid",
    41609: "Rough Gemstone",
    41611: "Dragon Scale",
    41612: "Ghost Essence",
    41613: "Earth Ball",
    27634: "bicycle",
    27658: "bag of pollen",
    27680: "bird beak",
    27681: "bitten apple",
    27672: "bottle of poison",
    27687: "comb",
    27818: "strange rock",
    27706: "feather",
    27684: "electric box",
    27700: "future orb",
    27685: "sandbag",
    27686: "horn",
    27667: "dragon tooth",
    27665: "nail",
    27656: "pot of lava",
    27679: "pot of moss bug",
    27695: "ruby",
    27719: "straw",
    27683: "tooth",
    27668: "water gem",
    27702: "stone orb",
    27690: "bat wing",
    27794: "horn drill",
    27682: "rat tail",
    27694: "wool ball",
    27663: "old amber",
    27661: "helix fossil",
    27734: "electric rat tail",
    27688: "fox tail",
    27691: "bug antenna",
    27660: "leaves",
    27800: "piece of diglett",
    27820: "bull tail",
    27676: "ice bra",
    27652: "gyarados tail",
    27697: "karate duck",
    27693: "luck medallion",
    27806: "magma foot",
    27803: "male ear",
    27704: "magnet",
    27677: "electric tail",
    27659: "bulb",
    27713: "crab claw",
    27804: "owl feather",
    27705: "farfetch'd stick",
    27780: "fire tail",
    27698: "punch machine",
    27714: "bone",
    27670: "seed",
    27678: "water pendant",
    27709: "locksmith of shell",
    27776: "bear paw",
    27721: "blue ball",
    27696: "psyduck mug",
    27790: "gem star",
    27778: "giant ruby",
    27781: "seal tail",
    27772: "squirrel tail",
    27730: "steel wings",
    27779: "cat ear",
    27773: "moth wing",
    27784: "dark gem",
    27737: "old skull",
    27757: "aerodactyl wing",
    27766: "big bat wing",
    27729: "mystic shell hat",
    27748: "rock trunk",
    27754: "magnetic tail",
    27728: "brush tail",
    27749: "long seal tail",
    27771: "blue kick machine",
    27731: "stone shell",
    27753: "blue ball tail",
    27707: "ice block",
    27653: "articuno feather",
    27654: "zapdos feather",
    27655: "moltres feather",
    27720: "pot of pure water",
    27722: "evil pendant",
    27770: "blue rat ear",
    27739: "lava shell",
    27741: "head top",
    27742: "nature pendant",
    27743: "poisonous flower",
    28569: "ice orb",
    28570: "thunder orb",
    28571: "fire orb",
}

def update_shop_sellable(value, stored_items):
    # O valor de "shop_sellable" contém itens separados por vírgula, como: "burning charcoal, 23498, 100; ..."
    updated_values = []
    items = value.split(";")
    
    for item in items:
        if item.strip():
            parts = item.split(",")
            if len(parts) == 3:
                name, item_id, quantity = parts[0].strip(), parts[1].strip(), parts[2].strip()
                item_id = int(item_id)
                
                # Se o ID estiver no dicionário, substitui o nome e o ID
                if item_id in stored_items:
                    new_name = stored_items[item_id]
                    updated_values.append(f"{new_name}, {item_id}, {quantity}")
                else:
                    updated_values.append(item)  # Mantém o item inalterado se não for encontrado
                
    return "; ".join(updated_values) + ";"  # Retorna a string atualizada

def process_xml(file_path, output_path, stored_items):
    tree = ET.parse(file_path)
    root = tree.getroot()
    not_found_items = []

    # Itera sobre cada item no XML
    for item in root.findall(".//parameter[@key='shop_sellable']"):
        value = item.get("value")
        updated_value = update_shop_sellable(value, stored_items)
        item.set("value", updated_value)

    # Salva o arquivo XML atualizado
    tree.write(output_path)

    # Exibe os itens que não foram encontrados
    if not_found_items:
        print("Itens não encontrados:")
        for not_found in not_found_items:
            print(not_found)

# Caminho do arquivo XML original
xml_file_path = 'Marks.xml'
# Caminho do arquivo XML atualizado
updated_xml_path = 'updated_mark.xml'

# Processa o XML e substitui os itens
process_xml(xml_file_path, updated_xml_path, stored_items)

function stringToTable(inputString)
    local tableFunction = load("return " .. inputString)
    local dataTable = tableFunction()
    return dataTable
end

function getBallSpecialAttribute(key, tableString)
    local dataTable = stringToTable(tableString)
    return dataTable[key]
end

-- Tabela de mapeamento: índice do held → itemId da sprite
HELD_INDEX_TO_ITEMID = {
    -- Accuracy (1-13) = 30001-30013
    [1] = 30001, [2] = 30002, [3] = 30003, [4] = 30004, [5] = 30005, [6] = 30006, [7] = 30007,
    [8] = 30008, [9] = 30009, [10] = 30010, [11] = 30011, [12] = 30012, [13] = 30013,
    
    -- Agility (14-26) = 30014-30026
    [14] = 30014, [15] = 30015, [16] = 30016, [17] = 30017, [18] = 30018, [19] = 30019, [20] = 30020,
    [21] = 30021, [22] = 30022, [23] = 30023, [24] = 30024, [25] = 30025, [26] = 30026,
    
    -- Attack (27-39) = 30027-30039
    [27] = 30027, [28] = 30028, [29] = 30029, [30] = 30030, [31] = 30031, [32] = 30032, [33] = 30033,
    [34] = 30034, [35] = 30035, [36] = 30036, [37] = 30037, [38] = 30038, [39] = 30039,
    
    -- Boost (40-52) = 30040-30052
    [40] = 30040, [41] = 30041, [42] = 30042, [43] = 30043, [44] = 30044, [45] = 30045, [46] = 30046,
    [47] = 30047, [48] = 30048, [49] = 30049, [50] = 30050, [51] = 30051, [52] = 30052,
    
    -- Critical (53-65) = 30053-30065
    [53] = 30053, [54] = 30054, [55] = 30055, [56] = 30056, [57] = 30057, [58] = 30058, [59] = 30059,
    [60] = 30060, [61] = 30061, [62] = 30062, [63] = 30063, [64] = 30064, [65] = 30065,
    
    -- Defense (66-78) = 30066-30078
    [66] = 30066, [67] = 30067, [68] = 30068, [69] = 30069, [70] = 30070, [71] = 30071, [72] = 30072,
    [73] = 30073, [74] = 30074, [75] = 30075, [76] = 30076, [77] = 30077, [78] = 30078,
    
    -- Elemental (79-91) = 30079-30091
    [79] = 30079, [80] = 30080, [81] = 30081, [82] = 30082, [83] = 30083, [84] = 30084, [85] = 30085,
    [86] = 30086, [87] = 30087, [88] = 30088, [89] = 30089, [90] = 30090, [91] = 30091,
    
    -- Experience (92-104) = 30092-30104
    [92] = 30092, [93] = 30093, [94] = 30094, [95] = 30095, [96] = 30096, [97] = 30097, [98] = 30098,
    [99] = 30099, [100] = 30100, [101] = 30101, [102] = 30102, [103] = 30103, [104] = 30104,
    
    -- Cooldown (105-107) = 30105-30107
    [105] = 30105, [106] = 30106, [107] = 30107,
    
    -- Lucky (147-159) - Série 36xxx (T1-T7) e série 30xxx (T8-T13)
    [147] = 36334, -- T1
    [148] = 36359, -- T2
    [149] = 36384, -- T3
    [150] = 36409, -- T4
    [151] = 36434, -- T5
    [152] = 36459, -- T6
    [153] = 36484, -- T7
    [154] = 30125, -- T8
    [155] = 30126, -- T9
    [156] = 30127, -- T10
    [157] = 30128, -- T11
    [158] = 30129, -- T12
    [159] = 30130, -- T13
}

-- Tabela de mapeamento: índice do held → nome
HELD_INDEX_TO_NAME = {
    -- Accuracy (1-13)
    [1] = "X-Accuracy T1", [2] = "X-Accuracy T2", [3] = "X-Accuracy T3", [4] = "X-Accuracy T4",
    [5] = "X-Accuracy T5", [6] = "X-Accuracy T6", [7] = "X-Accuracy T7", [8] = "X-Accuracy T8",
    [9] = "X-Accuracy T9", [10] = "X-Accuracy T10", [11] = "X-Accuracy T11", [12] = "X-Accuracy T12", [13] = "X-Accuracy T13",
    
    -- Agility (14-26)
    [14] = "X-Agility T1", [15] = "X-Agility T2", [16] = "X-Agility T3", [17] = "X-Agility T4",
    [18] = "X-Agility T5", [19] = "X-Agility T6", [20] = "X-Agility T7", [21] = "X-Agility T8",
    [22] = "X-Agility T9", [23] = "X-Agility T10", [24] = "X-Agility T11", [25] = "X-Agility T12", [26] = "X-Agility T13",
    
    -- Attack (27-39)
    [27] = "X-Attack T1", [28] = "X-Attack T2", [29] = "X-Attack T3", [30] = "X-Attack T4",
    [31] = "X-Attack T5", [32] = "X-Attack T6", [33] = "X-Attack T7", [34] = "X-Attack T8",
    [35] = "X-Attack T9", [36] = "X-Attack T10", [37] = "X-Attack T11", [38] = "X-Attack T12", [39] = "X-Attack T13",
    
    -- Boost (40-52)
    [40] = "X-Boost T1", [41] = "X-Boost T2", [42] = "X-Boost T3", [43] = "X-Boost T4",
    [44] = "X-Boost T5", [45] = "X-Boost T6", [46] = "X-Boost T7", [47] = "X-Boost T8",
    [48] = "X-Boost T9", [49] = "X-Boost T10", [50] = "X-Boost T11", [51] = "X-Boost T12", [52] = "X-Boost T13",
    
    -- Critical (53-65)
    [53] = "X-Critical T1", [54] = "X-Critical T2", [55] = "X-Critical T3", [56] = "X-Critical T4",
    [57] = "X-Critical T5", [58] = "X-Critical T6", [59] = "X-Critical T7", [60] = "X-Critical T8",
    [61] = "X-Critical T9", [62] = "X-Critical T10", [63] = "X-Critical T11", [64] = "X-Critical T12", [65] = "X-Critical T13",
    
    -- Defense (66-78)
    [66] = "X-Defense T1", [67] = "X-Defense T2", [68] = "X-Defense T3", [69] = "X-Defense T4",
    [70] = "X-Defense T5", [71] = "X-Defense T6", [72] = "X-Defense T7", [73] = "X-Defense T8",
    [74] = "X-Defense T9", [75] = "X-Defense T10", [76] = "X-Defense T11", [77] = "X-Defense T12", [78] = "X-Defense T13",
    
    -- Elemental (79-91)
    [79] = "X-Elemental T1", [80] = "X-Elemental T2", [81] = "X-Elemental T3", [82] = "X-Elemental T4",
    [83] = "X-Elemental T5", [84] = "X-Elemental T6", [85] = "X-Elemental T7", [86] = "X-Elemental T8",
    [87] = "X-Elemental T9", [88] = "X-Elemental T10", [89] = "X-Elemental T11", [90] = "X-Elemental T12", [91] = "X-Elemental T13",
    
    -- Experience (92-104)
    [92] = "X-Experience T1", [93] = "X-Experience T2", [94] = "X-Experience T3", [95] = "X-Experience T4",
    [96] = "X-Experience T5", [97] = "X-Experience T6", [98] = "X-Experience T7", [99] = "X-Experience T8",
    [100] = "X-Experience T9", [101] = "X-Experience T10", [102] = "X-Experience T11", [103] = "X-Experience T12", [104] = "X-Experience T13",
    
    -- Cooldown (105-107)
    [105] = "X-Cooldown T1", [106] = "X-Cooldown T2", [107] = "X-Cooldown T3",
    
    -- Harden (108-120)
    [108] = "X-Harden T1", [109] = "X-Harden T2", [110] = "X-Harden T3", [111] = "X-Harden T4",
    [112] = "X-Harden T5", [113] = "X-Harden T6", [114] = "X-Harden T7", [115] = "X-Harden T8",
    [116] = "X-Harden T9", [117] = "X-Harden T10", [118] = "X-Harden T11", [119] = "X-Harden T12", [120] = "X-Harden T13",
    
    -- Haste (121-133)
    [121] = "X-Haste T1", [122] = "X-Haste T2", [123] = "X-Haste T3", [124] = "X-Haste T4",
    [125] = "X-Haste T5", [126] = "X-Haste T6", [127] = "X-Haste T7", [128] = "X-Haste T8",
    [129] = "X-Haste T9", [130] = "X-Haste T10", [131] = "X-Haste T11", [132] = "X-Haste T12", [133] = "X-Haste T13",
    
    -- Hellfire (134-146)
    [134] = "X-Hellfire T1", [135] = "X-Hellfire T2", [136] = "X-Hellfire T3", [137] = "X-Hellfire T4",
    [138] = "X-Hellfire T5", [139] = "X-Hellfire T6", [140] = "X-Hellfire T7", [141] = "X-Hellfire T8",
    [142] = "X-Hellfire T9", [143] = "X-Hellfire T10", [144] = "X-Hellfire T11", [145] = "X-Hellfire T12", [146] = "X-Hellfire T13",
    
    -- Lucky (147-159)
    [147] = "X-Lucky T1", [148] = "X-Lucky T2", [149] = "X-Lucky T3", [150] = "X-Lucky T4",
    [151] = "X-Lucky T5", [152] = "X-Lucky T6", [153] = "X-Lucky T7", [154] = "X-Lucky T8",
    [155] = "X-Lucky T9", [156] = "X-Lucky T10", [157] = "X-Lucky T11", [158] = "X-Lucky T12", [159] = "X-Lucky T13",
    
    -- Poison (160-172)
    [160] = "X-Poison T1", [161] = "X-Poison T2", [162] = "X-Poison T3", [163] = "X-Poison T4",
    [164] = "X-Poison T5", [165] = "X-Poison T6", [166] = "X-Poison T7", [167] = "X-Poison T8",
    [168] = "X-Poison T9", [169] = "X-Poison T10", [170] = "X-Poison T11", [171] = "X-Poison T12", [172] = "X-Poison T13",
    
    -- Rage (173-179)
    [173] = "X-Rage T1", [174] = "X-Rage T2", [175] = "X-Rage T3", [176] = "X-Rage T4",
    [177] = "X-Rage T5", [178] = "X-Rage T6", [179] = "X-Rage T7",
    
    -- Strafe (186-211)
    [186] = "X-Strafe T1", [187] = "X-Strafe T2", [188] = "X-Strafe T3", [189] = "X-Strafe T4",
    [190] = "X-Strafe T5", [191] = "X-Strafe T6", [192] = "X-Strafe T7", [193] = "X-Strafe T8",
    [194] = "X-Strafe T9", [195] = "X-Strafe T10", [196] = "X-Strafe T11", [197] = "X-Strafe T12", [198] = "X-Strafe T13",
    
    -- Vitality (212-224)
    [212] = "X-Vitality T1", [213] = "X-Vitality T2", [214] = "X-Vitality T3", [215] = "X-Vitality T4",
    [216] = "X-Vitality T5", [217] = "X-Vitality T6", [218] = "X-Vitality T7", [219] = "X-Vitality T8",
    [220] = "X-Vitality T9", [221] = "X-Vitality T10", [222] = "X-Vitality T11", [223] = "X-Vitality T12", [224] = "X-Vitality T13",
    
    -- Y-Cure (238-250)
    [238] = "Y-Cure T1", [239] = "Y-Cure T2", [240] = "Y-Cure T3", [241] = "Y-Cure T4",
    [242] = "Y-Cure T5", [243] = "Y-Cure T6", [244] = "Y-Cure T7", [245] = "Y-Cure T8",
    [246] = "Y-Cure T9", [247] = "Y-Cure T10", [248] = "Y-Cure T11", [249] = "Y-Cure T12", [250] = "Y-Cure T13",
}

-- Converte índice de held para itemId do sprite
function getHeldItemId(heldIndex)
    if not heldIndex or heldIndex == 0 then
        return 0
    end
    
    return HELD_INDEX_TO_ITEMID[heldIndex] or (heldIndex + 30000)
end

-- Converte índice de held para nome
function getHeldName(heldIndex)
    if not heldIndex or heldIndex == 0 then
        return ""
    end
    
    return HELD_INDEX_TO_NAME[heldIndex] or "Unknown Held"
end
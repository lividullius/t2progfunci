
-- Listas de memória com programas convertidos do assembly

-- Programa 1: Resp = A + B - 2
-- A = 240, B = 241, Constante 2 = 245, Resp = 251
prog1 :: [(Int, Int)]
prog1 = [
    (0, 2),  (1, 240),    -- LOD A
    (2, 14), (3, 241),    -- ADD B
    (4, 16), (5, 245),    -- SUB 2
    (6, 4),  (7, 251),    -- STO Resp
    (8, 20), (9, 18),     -- HLT, NOP
    (240, 10),            -- A = 10
    (241, 5),             -- B = 5
    (245, 2),             -- constante 2
    (251, 0)              -- Resp (posição da tela)
    ]

-- Programa 2: Resp = A * B (usando somas sucessivas)
-- A = 240, B = 241, contador = 245, resultado = 247, constante 1 = 248
prog2 :: [(Int, Int)]
prog2 = [
    (0, 2),  (1, 244),    -- LOD 0
    (2, 4),  (3, 245),    -- STO contador
    (4, 2),  (5, 246),    -- LOD 0
    (6, 4),  (7, 247),    -- STO resultado

    (8, 2),  (9, 245),    -- LOD contador
    (10,10), (11,240),   -- CPE A
    (12,8), (13,28),     -- JMZ fim

    (14,2), (15,247),    -- LOD resultado
    (16,14), (17,241),   -- ADD B
    (18,4),  (19,247),   -- STO resultado

    (20,2), (21,245),    -- LOD contador
    (22,14), (23,248),   -- ADD 1
    (24,4),  (25,245),   -- STO contador

    (26,6),  (27,8),     -- JMP 8

    (28,2),  (29,247),   -- LOD resultado
    (30,4),  (31,251),   -- STO Resp
    (32,20), (33,18),    -- HLT, NOP

    -- Dados
    (240, 3),  -- A
    (241, 4),  -- B
    (244, 0),  -- constante 0 (para inicialização)
    (245, 0),  -- contador
    (246, 0),  -- constante 0 (para resultado)
    (247, 0),  -- resultado
    (248, 1),  -- constante 1
    (251, 0)   -- Resp
    ]

-- Programa 3: while (A < 5) { A++; Resp += 2; }
-- A = 240, Resp = 251, constantes 0, 1, 2, 5 nos endereços 244–247
prog3 :: [(Int, Int)]
prog3 = [
    (0, 2),  (1, 244),    -- LOD 0
    (2, 4),  (3, 240),    -- STO A
    (4, 2),  (5, 245),    -- LOD 1
    (6, 4),  (7, 251),    -- STO Resp

    (8, 2),  (9, 240),    -- LOD A
    (10,10), (11,246),   -- CPE 5
    (12,8),  (13,28),     -- JMZ fim

    (14,2), (15,240),    -- LOD A
    (16,14), (17,245),   -- ADD 1
    (18,4),  (19,240),   -- STO A

    (20,2), (21,251),    -- LOD Resp
    (22,14), (23,247),   -- ADD 2
    (24,4),  (25,251),   -- STO Resp

    (26,6),  (27,8),     -- JMP 8

    (28,20), (29,18),    -- HLT, NOP

    -- Dados
    (240, 0),  -- A
    (244, 0),  -- constante 0
    (245, 1),  -- constante 1
    (246, 5),  -- constante 5 (limite do loop)
    (247, 2),  -- constante 2
    (251, 0)   -- Resp
    ]

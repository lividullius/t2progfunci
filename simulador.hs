import System.IO


type Memoria = [(Int,Int)]
type Estado = (Memoria, Int, Int)  -- (memoria, acumulador, flag)


main :: IO ()
main = do
    putStrLn "=== Simulador de Computador Hipotético ==="
    putStrLn "1 - Executar programa do arquivo"
    putStrLn "2 - Programa 1: Resp = A + B - 2"
    putStrLn "3 - Programa 2: Resp = A * B"
    putStrLn "4 - Programa 3: Loop while"
    putStrLn "Escolha uma opção:"
    opcao <- getLine
    
    case opcao of
        "1" -> executarDoArquivo
        "2" -> testarPrograma1
        "3" -> testarPrograma2  
        "4" -> testarPrograma3
        _   -> putStrLn "Opção inválida"


executarDoArquivo :: IO ()
executarDoArquivo = do
    putStrLn "Digite o nome do arquivo:"
    nomeArquivo <- getLine
    conteudo <- readFile nomeArquivo
    let memoria = lerMemoriaDoArquivo conteudo
    putStrLn "Memória carregada do arquivo:"
    mostrarMemoria memoria
    let memoriaFinal = executar memoria
    putStrLn "\nMemória após execução:"
    mostrarMemoria memoriaFinal
    mostrarVideo memoriaFinal

-- Converte conteúdo do arquivo em memória
lerMemoriaDoArquivo :: String -> Memoria
lerMemoriaDoArquivo conteudo = 
    let linhas = lines conteudo
        linhasValidas = filter (not . null) linhas
    in map lerLinha linhasValidas
  where
    lerLinha linha = 
        let [endereco, valor] = map read (words linha)
        in (endereco, valor)

-- FUNÇÃO PRINCIPAL DE EXECUÇÃO
-- Recebe uma memória e retorna uma memória resultante da execução
-- Assume que o programa começa no endereço 0
executar :: Memoria -> Memoria
executar memoria = 
    let estadoInicial = (memoria, 0, 0)  -- (memoria, acc=0, eqz=0)
        (memoriaFinal, _, _) = cicloExecucao estadoInicial 0
    in memoriaFinal

-- Ciclo principal: busca, decodificação e execução
cicloExecucao :: Estado -> Int -> Estado
cicloExecucao estado@(memoria, acc, eqz) pc
    | pc >= 256 = estado  -- Proteção contra overflow
    | otherwise = 
        let codigoInstr = readMem memoria pc
        in if codigoInstr == 20  -- HLT
           then estado
           else 
               let endereco = readMem memoria (pc + 1)
                   novoEstado = executarInstrucao codigoInstr endereco estado
                   novoPc = calcularNovoPc codigoInstr endereco estado (pc + 2)
               in cicloExecucao novoEstado novoPc

-- Calcula o novo PC baseado na instrução
calcularNovoPc :: Int -> Int -> Estado -> Int -> Int
calcularNovoPc codigo endereco (_, acc, eqz) pcPadrao = 
    case codigo of
        6  -> endereco        -- JMP
        8  -> if eqz == 1 then endereco else pcPadrao  -- JMZ
        _  -> pcPadrao

-- Executa uma instrução específica
executarInstrucao :: Int -> Int -> Estado -> Estado
executarInstrucao codigo endereco estado = 
    case codigo of
        2  -> execLOD endereco estado    -- LOD
        4  -> execSTO endereco estado    -- STO
        6  -> estado                     -- JMP (PC handled separately)
        8  -> estado                     -- JMZ (PC handled separately)
        10 -> execCPE endereco estado    -- CPE
        14 -> execADD endereco estado    -- ADD
        16 -> execSUB endereco estado    -- SUB
        18 -> execNOP estado             -- NOP
        20 -> estado                     -- HLT
        _  -> execNOP estado             -- Instrução inválida = NOP

-- IMPLEMENTAÇÃO DAS INSTRUÇÕES

-- Instrução NOP - Não executa ação nenhuma
execNOP :: Estado -> Estado
execNOP (mem, acc, eqz) = (mem, acc, eqz)

-- Instrução LOD - Carrega conteúdo do endereço no acumulador
execLOD :: Int -> Estado -> Estado
execLOD endereco (mem, acc, eqz) = 
    let novoAcc = readMem mem endereco
        novoEqz = if novoAcc == 0 then 1 else 0
    in (mem, novoAcc, novoEqz)

-- Instrução STO - Armazena conteúdo do acumulador no endereço
execSTO :: Int -> Estado -> Estado
execSTO endereco (mem, acc, eqz) = 
    let novaMem = writeMem mem endereco acc
    in (novaMem, acc, eqz)

-- Instrução CPE - Compara endereço com acumulador
execCPE :: Int -> Estado -> Estado
execCPE endereco (mem, acc, eqz) = 
    let valor = readMem mem endereco
        novoAcc = if valor == acc then 0 else 1
        novoEqz = if novoAcc == 0 then 1 else 0
    in (mem, novoAcc, novoEqz)

-- Instrução ADD - Adiciona conteúdo do endereço ao acumulador
execADD :: Int -> Estado -> Estado
execADD endereco (mem, acc, eqz) = 
    let valor = readMem mem endereco
        novoAcc = limitarBits (acc + valor)
        novoEqz = if novoAcc == 0 then 1 else 0
    in (mem, novoAcc, novoEqz)

-- Instrução SUB - Subtrai conteúdo do endereço do acumulador
execSUB :: Int -> Estado -> Estado
execSUB endereco (mem, acc, eqz) = 
    let valor = readMem mem endereco
        novoAcc = limitarBits (acc - valor)
        novoEqz = if novoAcc == 0 then 1 else 0
    in (mem, novoAcc, novoEqz)

-- FUNÇÕES AUXILIARES PARA MEMÓRIA

-- Ler a memória - Retorna o conteúdo do endereço
readMem :: Memoria -> Int -> Int
readMem [] _ = 0  -- Endereço não encontrado retorna 0
readMem (m:ms) e
    | e == fst m = snd m
    | e /= fst m = readMem ms e

-- Escrever na memória - Armazena conteúdo em um endereço
writeMem :: Memoria -> Int -> Int -> Memoria
writeMem [] endereco valor = [(endereco, valor)]
writeMem (m:ms) endereco valor
    | endereco == fst m = (endereco, valor) : ms
    | otherwise = m : writeMem ms endereco valor

-- Limita valores a 8 bits (0-255)
limitarBits :: Int -> Int
limitarBits valor 
    | valor < 0 = 256 + (valor `mod` 256)
    | valor > 255 = valor `mod` 256
    | otherwise = valor

-- PROGRAMAS DE TESTE

-- Programa 1: Resp = A + B - 2
-- A=240, B=241, Resp=251, constante 2=245
prog1 :: Memoria
prog1 = [(0,2),(1,240),    -- LOD A
         (2,14),(3,241),   -- ADD B  
         (4,16),(5,245),   -- SUB 2
         (6,4),(7,251),    -- STO Resp
         (8,20),(9,18),    -- HLT NOP
         (240,10),(241,5),(245,2),(251,0)]

testarPrograma1 :: IO ()
testarPrograma1 = do
    putStrLn "Executando Programa 1: Resp = A + B - 2"
    putStrLn "A = 10, B = 5"
    putStrLn "Esperado: Resp = 13"
    let resultado = executar prog1
    putStrLn "\nResultado:"
    mostrarVideo resultado

-- Programa 2: Resp = A * B (multiplicação por somas sucessivas)
prog2 :: Memoria  
prog2 = [(0,2),(1,244),     -- LOD 0 (contador)
         (2,4),(3,245),     -- STO contador
         (4,2),(5,246),     -- LOD 0 (resultado)
         (6,4),(7,247),     -- STO resultado
         -- Loop
         (8,2),(9,245),     -- LOD contador
         (10,10),(11,240),  -- CPE A
         (12,8),(13,24),    -- JMZ fim
         (14,2),(15,247),   -- LOD resultado
         (16,14),(17,241),  -- ADD B
         (18,4),(19,247),   -- STO resultado
         (20,2),(21,245),   -- LOD contador
         (22,14),(23,248),  -- ADD 1
         (24,4),(25,245),   -- STO contador
         (26,6),(27,8),     -- JMP loop
         -- Fim
         (28,2),(29,247),   -- LOD resultado
         (30,4),(31,251),   -- STO Resp
         (32,20),(33,18),   -- HLT NOP
         -- Dados
         (240,3),(241,4),   -- A=3, B=4
         (244,0),(245,0),(246,0),(247,0),(248,1),(251,0)]

testarPrograma2 :: IO ()
testarPrograma2 = do
    putStrLn "Executando Programa 2: Resp = A * B"
    putStrLn "A = 3, B = 4"
    putStrLn "Esperado: Resp = 12"
    let resultado = executar prog2
    putStrLn "\nResultado:"
    mostrarVideo resultado

-- Programa 3: A = 0; Resp = 1; while(A < 5) { A = A + 1; Resp = Resp + 2; }
prog3 :: Memoria
prog3 = [(0,2),(1,244),     -- LOD 0
         (2,4),(3,240),     -- STO A (A = 0)
         (4,2),(5,245),     -- LOD 1
         (6,4),(7,251),     -- STO Resp (Resp = 1)
         -- Loop
         (8,2),(9,240),     -- LOD A
         (10,10),(11,246),  -- CPE 5
         (12,8),(13,24),    -- JMZ fim (se A == 5)
         (14,2),(15,240),   -- LOD A
         (16,14),(17,245),  -- ADD 1
         (18,4),(19,240),   -- STO A (A = A + 1)
         (20,2),(21,251),   -- LOD Resp
         (22,14),(23,247),  -- ADD 2
         (24,4),(25,251),   -- STO Resp (Resp = Resp + 2)
         (26,6),(27,8),     -- JMP loop
         -- Fim
         (28,20),(29,18),   -- HLT NOP
         -- Dados
         (240,0),(244,0),(245,1),(246,5),(247,2),(251,0)]

testarPrograma3 :: IO ()
testarPrograma3 = do
    putStrLn "Executando Programa 3: while loop"
    putStrLn "A = 0; Resp = 1; while(A < 5) { A++; Resp += 2; }"
    putStrLn "Esperado: A = 5, Resp = 11"
    let resultado = executar prog3
    putStrLn "\nResultado:"
    putStrLn $ "A (240): " ++ show (readMem resultado 240)
    putStrLn $ "Resp (251): " ++ show (readMem resultado 251)

-- FUNÇÕES DE EXIBIÇÃO

mostrarMemoria :: Memoria -> IO ()
mostrarMemoria memoria = 
    let memoriaOrdenada = ordenarMemoria memoria
    in mapM_ (\(end, val) -> putStrLn $ show end ++ " " ++ show val) memoriaOrdenada

mostrarVideo :: Memoria -> IO ()
mostrarVideo memoria = do
    putStrLn "=== SAÍDA DE VÍDEO (251-255) ==="
    putStrLn $ "251: " ++ show (readMem memoria 251)
    putStrLn $ "252: " ++ show (readMem memoria 252)
    putStrLn $ "253: " ++ show (readMem memoria 253)
    putStrLn $ "254: " ++ show (readMem memoria 254)
    putStrLn $ "255: " ++ show (readMem memoria 255)

-- Ordenação simples da memória para exibição
ordenarMemoria :: Memoria -> Memoria
ordenarMemoria [] = []
ordenarMemoria (x:xs) = 
    let menores = [y | y <- xs, fst y <= fst x]
        maiores = [y | y <- xs, fst y > fst x]
    in ordenarMemoria menores ++ [x] ++ ordenarMemoria maiores

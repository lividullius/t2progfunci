--pra criar o simulador tem que definir os tipos e estado da máquina

module Simulador where
--tipo para representar a memória: lista de pares (endereço, valor)
type Memory = [(Int, Int)]

--estado completo do computador
data State = State {
    memory :: Memory,  -- Memória do computador
    acc    :: Int,     -- Registrador acumulador
    eqz    :: Bool,    -- Flag que indica se o ACC é zero
    ci     :: Int      -- Contador de instruções
} deriving Show

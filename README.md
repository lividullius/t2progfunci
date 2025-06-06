# t2pf
Trabalho 2 Programação Funcional

Desenvolvido por: Filipe Freitas, Lívia Nöer e Otávio Kozak

Objetivo:
Construir um simulador de um computador hipotético usando Haskell, trabalhando principalmente com funções recursivas, manipulação de listas e simulação de execução de instruções.


  Simulador de Computador Hipotético — Programação Funcional
 ============================================================

  Este programa simula um computador de arquitetura simplificada com as seguintes características:

  ▶ Memória:
    - 256 posições de memória endereçadas de 0 a 255
    - Cada posição armazena um valor inteiro de 8 bits (0 a 255)
    - As posições de 251 a 255 representam a “memória de vídeo”
      (valores nelas são exibidos ao final da execução)

  ▶ Registradores:
    - ACC (Acumulador): registrador de 8 bits onde ocorrem as operações aritméticas
    - EQZ (Flag Zero): fica em 1 se o valor do ACC for igual a zero, 0 caso contrário
    - CI (Contador de Instruções): aponta para a próxima instrução a ser executada
    - RI (Registrador de Instrução): carrega uma instrução de 16 bits (código + endereço)

  ▶ Instruções:
    Cada instrução ocupa 2 posições consecutivas da memória:
      [código da instrução, endereço de memória]

    Conjunto de instruções suportadas (tabela simplificada):

      02 LOD <end>  — Carrega valor do endereço <end> no ACC
      04 STO <end>  — Armazena ACC no endereço <end>
      06 JMP <end>  — Salta para a instrução no endereço <end>
      08 JMZ <end>  — Salta para <end> se EQZ = 1 (ACC == 0)
      10 CPE <end>  — Compara valor do endereço com ACC
                     (ACC = 0 se iguais, ACC = 1 caso contrário)
      14 ADD <end>  — Soma valor do endereço ao ACC
      16 SUB <end>  — Subtrai valor do endereço do ACC
      18 NOP        — Nenhuma operação
      20 HLT        — Encerra execução

  ▶ Execução:
    A CPU realiza um ciclo contínuo de:
      1. Busca da instrução (busca RI)
      2. Decodificação do código e endereço
      3. Execução da instrução e atualização do estado

    O ciclo termina quando a instrução HLT (código 20) é encontrada.

  ▶ Representação em Haskell:
    - A memória é modelada como uma lista de pares (endereço, valor)
      Exemplo: [(0,2),(1,240)] representa a instrução LOD 240

    - O estado do computador é representado como uma tupla:
        (Memoria, ACC, EQZ)

    - O simulador é interativo e permite executar:
        1. Programas carregados a partir de arquivo
        2. Programas de teste embutidos

  ============================================================




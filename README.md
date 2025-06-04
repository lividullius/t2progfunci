# t2pf
Trabalho 2 Programação Funcional

Desenvolvido por: Filipe Freitas, Lívia Nöer e Otávio Kozak

Objetivo:
Construir um simulador de um computador hipotético usando Haskell, trabalhando principalmente com funções recursivas, manipulação de listas e simulação de execução de instruções.

Estrutura do trabalho:

1. Código Haskell do simulador
   
- Definição do estado da máquina

- Manipulação da memória

- Execução das instruções

- Laço de execução (run)

- Impressão da saída da "memória de vídeo"

2. Definição da lista de memória para cada programa teste os programas já convertidos em assembly e armazenados como listas de tuplas 3 listas:

- programa1: Resp = A + B – 2;

- programa2:  Resp = A * B; 

- programa3: A = 0; Resp = 1; while(A < 5) { A = A + 1; Resp = Resp + 2; }

3. Código em Assembly para cada programa teste

- traduzir cada programa imperativo (1, 2 e 3) em instruções da máquina simulada

4. Função main do teste

- simular os tres programas e imprimir os resultados

5. Bônus: leitura via arquivo texto



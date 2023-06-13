#lang racket
(require racket/gui)
(require db)

; definindo as variaveis a b c 
(define a 0)
(define b 0)
(define c 0)

; função para calcular o delta
(define(delta a b c)
  (-(* b b)(* 4 a c))
)

;função que calcula o x1
(define (x1 a b c)
  (/ (+ (- b) (sqrt (delta a b c))) (* 2 a))
)

;função que calcula o x2
(define (x2 a b c)
  (/ (- (- b) (sqrt (delta a b c))) (* 2 a))
)

;função que calcula o vertice do eixo x
(define (v1 a b c)
  (/ (- b) (* 2 a))
)

;função que calcula o vertice do eixo y
(define (v2 a b c)
  (/ (- (delta a b c)) (* 4 a))
)

; define o tamanho da janela e o nome da mesma
(define frame (new frame%
                       [label "Trabalho 3 de paradigmas"]
                       [width 400]
                       [height 300]))
; cria um label e uma caixa de texto para inserir os valores
(define A (new text-field%
                        (label "Valor A:")
                        (parent frame )
                        ))
; cria um label e uma caixa de texto para inserir os valores
(define B (new text-field%
                        (label "Valor B:")
                        (parent frame )
                        ))
; cria um label e uma caixa de texto para inserir os valores
(define C (new text-field%
                        (label "Valor C:")
                        (parent frame )
                        ))
; cria um butão e uma chamada para o que fazer após o botão ser precionado
(new button% [parent frame]
    [label "OK"]
    [callback (lambda (button event)

                (set! a (string->number(send A get-value))) ; pega os valores das caixas de texto converte para valor numerico
                (set! b (string->number(send B get-value)))
                (set! c (string->number(send C get-value)))
                (send msg1 set-value (~a(x1 a b c))) ; executa as funções criadas e manda o resultado para as caixas de texto 
                (send msg2 set-value (~a(x2 a b c)))
                (send msg3 set-value (~a(v1 a b c)))
                (send msg4 set-value (~a(v2 a b c)))
                (define SQLite(sqlite3-connect #:database "H:/HD baixados/sqlite/bancoParadigmas.db")) ; conecta ao banco de dados atraves do caminho
                (query-exec SQLite "insert into valores (a, b, c, delta, x1, x2, v1, v2) values (?, ?, ?, ?, ?, ?, ?, ?);" a b c (delta a b c) (x1 a b c) (x2 a b c) (v1 a b c) (v2 a b c)) ;; manda os valores pegos para o banco de dados
                (query-rows SQLite "SELECT * FROM valores;")) ; pega os valores do banco 
                ])
; aqui é criado os labels e as caixas de texto que recebera o resultado das funções que foram executadas ali nas linhas 63 até 66
(define msg1 (new text-field% [parent frame]
                 [label "x1:       "]))
(define msg2 (new text-field% [parent frame]
                 [label "x2:      "]))
(define msg3 (new text-field% [parent frame]
                 [label "vx:       "]))
(define msg4 (new text-field% [parent frame]
                 [label "vy:       "]))
(send frame show #t)





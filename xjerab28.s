; Autor reseni: Jakub Jerabek xjerab28
; Pocet cyklu k serazeni puvodniho retezce: 4630
; Pocet cyklu razeni sestupne serazeneho retezce: 5848
; Pocet cyklu razeni vzestupne serazeneho retezce: 328
; Pocet cyklu razeni retezce s vasim loginem: 1072
; Implementovany radici algoritmus: Bubble Sort
; ------------------------------------------------

; DATA SEGMENT
                .data
; login:          .asciiz "vitejte-v-inp-2023"    ; puvodni uvitaci retezec
; login:          .asciiz "vvttpnjiiee3220---"  ; sestupne serazeny retezec
; login:          .asciiz "---0223eeiijnpttvv"  ; vzestupne serazeny retezec
 login:          .asciiz "xjerab28"            ; SEM DOPLNTE VLASTNI LOGIN
                                                ; A POUZE S TIMTO ODEVZDEJTE

params_sys5:    .space  8   ; misto pro ulozeni adresy pocatku
                            ; retezce pro vypis pomoci syscall 5
                            ; (viz nize - "funkce" print_string)

; CODE SEGMENT
.text
main:
    daddi   r4, r0, login   ; adresa retezce do r4

    jal     bubble_sort_loop     ; zavolání bubble sort algoritmu
    jal     print_string    ; vypis pomoci print_string - viz nize

    syscall 0   ; halt

bubble_sort_loop:
    daddi   r8, r0, 0        ; swap pocitadlo
    loop_inner:
        lb      r5, 0(r4)    ; hodnoty aktuálního znaku do r5
        lb      r6, 1(r4)    ; hodnoty následujícího znaku do r6

        ; vypočítání rozdílu ASCII hodnot
        sub     r7, r5, r6

        ; pokud je r7 kladné, znamená to, že r5 > r6, takze swap
        beqz    r7, skip_swap
        bgez    r7, swap_chars

    skip_swap:
        addi   r4, r4, 1    ; posunutí na další znak v řetězci
        lb      r9, 1(r4)
        beqz    r9, end_inner_loop ; pokud jsme prošli celé pole, ukonči vnitřní smyčku
        j       loop_inner   ; opakování vnitřní smyčky

    swap_chars:
        ; prohození znaků
        addi    r8, r8, 1
        sb      r6, 0(r4)    ; uložení r6 na pozici aktuálního znaku
        sb      r5, 1(r4)    ; uložení r5 na pozici následujícího znaku
        j       skip_swap    ; přeskočení dalšího kroku prohození

    end_inner_loop:
        daddi   r4, r0, login ; nastavení ukazatele na začátek řetězce
        beqz    r8, end
        j bubble_sort_loop
    end:
        jr      r31 ; návrat na původní pozici

print_string:   ; adresa retezce se očekává v r4
    sw      r4, params_sys5(r0)
    daddi   r14, r0, params_sys5    ; adresa pro syscall 5 musí být v r14
    syscall 5   ; systémová procedura - vypis retezce na terminal
    jr      r31 ; návrat - r31 je určen na návratovou adresu

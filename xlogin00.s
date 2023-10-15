; Autor reseni: Jakub Jerabek xjerab28
; Pocet cyklu k serazeni puvodniho retezce:
; Pocet cyklu razeni sestupne serazeneho retezce:
; Pocet cyklu razeni vzestupne serazeneho retezce:
; Pocet cyklu razeni retezce s vasim loginem:
; Implementovany radici algoritmus: Bubble Sort
; ------------------------------------------------

; DATA SEGMENT
.data
login:          .asciiz "vitejte-v-inp-2023"    ; puvodni uvitaci retezec

params_sys5:    .space  8   ; misto pro ulozeni adresy pocatku
                            ; retezce pro vypis pomoci syscall 5
                            ; (viz nize - "funkce" print_string)

; CODE SEGMENT
.text
main:
    daddi   r4, r0, login   ; adresa retezce do r4
    jal     bubble_sort     ; zavolání bubble sort algoritmu
    jal     print_string    ; vypis pomoci print_string - viz nize

    syscall 0   ; halt

bubble_sort:
    daddi   r1, r0, 0        ; 0 pro kontrolu zda jsem na konci stringu
    loop:
        daddi   r2, r0, 0        ; inicializace proměnné pro kontrolu průchodu polem
        
        loop_inner:
            lb      r5, 0(r4)    ; načtení ASCII hodnoty aktuálního znaku do r5
            lb      r6, 1(r4)    ; načtení ASCII hodnoty následujícího znaku do r6

            ; vypočítání rozdílu ASCII hodnot
            dsub     r7, r5, r6 ; r5 - r6
            
            ; vzdy druhy registr minus treti registr
            
            ; pokud je r7 kladné, znamená to, že r6 > r5, takže prohodíme znaky
            ;beqz    r7, skip_swap
            bgez    r7, swap_chars

        skip_swap:
            daddi    r2, r2, 1    ; zvýšení hodnoty pro kontrolu průchodu polem
            daddi    r3, r3, 1    ; zvýšení hodnoty pro kontrolu druhého znaku ve porovnání
            ;beqz    r4, end_inner_loop ; pokud jsme prošli celé pole, ukonči vnitřní smyčku
            daddi   r4, r4, 1    ; posunutí na další znak v řetězci
            j       loop_inner   ; opakování vnitřní smyčky

        swap_chars:
            ; prohození znaků
            sb      r6, 0(r4)    ; uložení r6 na pozici aktuálního znaku
            sb      r5, 1(r4)    ; uložení r5 na pozici následujícího znaku
            j       skip_swap    ; přeskočení dalšího kroku prohození

        end_inner_loop:
            addi    r1, r1, 1    ; zvýšení hodnoty pro kontrolu celého pole
            daddi   r4, r0, login ; nastavení ukazatele na začátek řetězce
            dsub     r7, r3, r1                     ; pokud r3 > r1 tak skok
            ;beqz    r7, end
            bgez     r7, loop ; pokud jsme neprošli celé pole, opakuj vnější smyčku
        end:
            jr      r31 ; návrat na původní pozici

print_string:   ; adresa retezce se očekává v r4
    sw      r4, params_sys5(r0)
    daddi   r14, r0, params_sys5    ; adresa pro syscall 5 musí být v r14
    syscall 5   ; systémová procedura - vypis retezce na terminal
    jr      r31 ; návrat - r31 je určen na návratovou adresu

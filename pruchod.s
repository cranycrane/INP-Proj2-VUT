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

; Načtení adresy řetězce do registru $a0
    
    ; Inicializace indexu na 0
    daddi $t0, r0, 0
    
loop:
    ; Načtení znaku ze řetězce na adrese uložené v $a0 + $t0 a uložení do registru $t1
    lb r9, 0(r4)
    
    ; Test, zda byl načtený znak nulový (konec řetězce)
    beq r9, r0, end
    
    ; Výpis znaku (např. na konzoli)
    ; Zde by měla být vaše implementace výpisu znaku, například pomocí syscall nebo jiných funkcí
    
    ; Inkrementace indexu
    addi r4, r4, 1
    
    ; Skok na začátek smyčky
    j loop

end:

    jal     print_string    ; vypis pomoci print_string - viz nize

    syscall 0   ; halt


print_string:   ; adresa retezce se očekává v r4
    sw      r4, params_sys5(r0)
    daddi   r14, r0, params_sys5    ; adresa pro syscall 5 musí být v r14
    syscall 5   ; systémová procedura - vypis retezce na terminal
    jr      r31 ; návrat - r31 je určen na návratovou adresu

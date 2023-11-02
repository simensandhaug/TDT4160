.data
function_error_str: .string "ERROR: Woops, programmet returnerte ikke fra et funksjonskall!"
left_bracket: .string "["
right_bracket: .string "]"
comma: .string ","
space: .string " "

.text

# Test Mode
# Sett a7 til 1 for å teste med veridene under Test - Start
# Sett a7 til 0 når du skal levere
li a7, 0
beq a7, zero, load_complete

# Test - Start
li a0 50
li a1 390
li a2 14
li a3 21
li a4 -20
li a5 2000
#Test Slutt

load_complete:

# Globale Registre:
# s0-s5 : Foreløpig liste
# s6    : Har byttet verdier denne syklusen (0/1)

# Hopp forbi funksjoner
j main


# Funksjoner:
    
swap:
    # Args: a0, a1
    # Outputs: a0, a1
    
    # Sammenlikn a0 og a1
    bge a1, a0, swap_complete
    # Putt den minste av dem i a0 og den største i a1
    mv t0, a0
    mv a0, a1
    mv a1, t0
    # Hvis den byttet a0 og a1, sett den globale variablen s6 til 1 for å markere dette til resten av koden
    li s6, 1
    j swap_complete
    
swap_complete:
    ret


# Hvis programmet kommer hit har den ikke greid å returnere fra funksjonen over
# Dette bør aldri skje
la a0, function_error_str
li a7, 4
ecall


# Main
main:
    # Last in s0-s5 med verdiene fra a0-a5
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    
loop:
    # Reset verdibytteindikator (en instruksjon)
    li s6, 0
    
    # Sorter alle
    # Repeter følgende logikk:
    # Ta s[i] og s[i+1], og lagre dem som argumenter
    # Kall funksjonen `swap` som sorterer dem
    # Nå skal `swap` ha outputet de to verdiene i to registre
    # Putt den minste verdien i s[i], og den største i s[i+1]
    # Repeter for i=0..4
    
    # 0 <-> 1
    mv a0, s0
    mv a1, s1
    call swap
    mv s0, a0
    mv s1, a1
    
    # 1 <-> 2
    mv a0, s1
    mv a1, s2
    call swap
    mv s1, a0
    mv s2, a1

    # 2 <-> 3
    mv a0, s2
    mv a1, s3
    call swap
    mv s2, a0
    mv s3, a1

    # 3 <-> 4
    mv a0, s3
    mv a1, s4
    call swap
    mv s3, a0
    mv s4, a1

    # 4 <-> 5
    mv a0, s4
    mv a1, s5
    call swap
    mv s4, a0
    mv s5, a1
    
    # Fortsett loop hvis noe ble endret (en instruksjon)
    # Hvis ingenting ble byttet er listen sortert
    beqz s6, loop_end
    j loop
    
loop_end:
    
    # Flytt alt til output-registrene
    mv a0, s0
    mv a1, s1
    mv a2, s2
    mv a3, s3
    mv a4, s4
    mv a5, s5
    j print_array
    
print_element:
    li a7, 1
    ecall
    ret
    
print_comma_and_space:
    li a7, 4
    la a0, comma
    ecall
    la a0, space
    ecall
    ret

print_array:
    mv t0, a0  # Save the original value of a0
    
    # Print start bracket
    la a0, left_bracket
    li a7, 4
    ecall

    # Print first element
    mv a0, s0
    call print_element
    call print_comma_and_space

    # Print second element
    mv a0, s1
    call print_element
    call print_comma_and_space

    # Print third element
    mv a0, s2
    call print_element
    call print_comma_and_space

    # Print fourth element
    mv a0, s3
    call print_element
    call print_comma_and_space

    # Print fifth element
    mv a0, s4
    call print_element
    call print_comma_and_space

    # Print sixth element
    mv a0, s5
    call print_element

    # Print end bracket
    la a0, right_bracket
    li a7, 4
    ecall

    mv a0, t0  # Restore the original value of a0
    
    li a7, 10
    ecall # Exit
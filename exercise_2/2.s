start:
    add t0, a0, a1 # t0 = a0 + a1
    add t1, a2, a3 # t1 = a2 + a3
    add t2, a4, a5 # t2 = a4 + a5
    mv a0, t0  # Initially set a0 to t0
max:
    bgt t1, a0, set_a0_t1  # If t1 > a0, a0 = t1 then run max again
    bgt t2, a0, set_a0_t2  # If t2 > a0, a0 = t2 then run max again
    j exit  # Else, exit
set_a0_t1:
    mv a0, t1  # a0 = t1
    j max  # Run max again
set_a0_t2:
    mv a0, t2  # a0 = t2
    j max  # Run max again
exit:
    li a7, 10
    ecall
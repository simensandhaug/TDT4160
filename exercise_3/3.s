_start:
    #li a0, 2401
    li a1, 0
    mv a2, a0
    li t0, 2
find_GD:
    rem t1, a2, t0
    beq t1, zero, set_GD
    addi t0, t0, 1
    j find_GD
set_GD:
    div a0, a2, t0
check_PS:
    li t3, 0             # Lower bound
    mv t4, a2            # Upper bound
    li t5, 0             # Mid
    binary_search:
        add t5, t3, t4
        srai t5, t5, 1
        mul t6, t5, t5
        beq t6, a2, set_PS
        blt t6, a2, set_low
        mv t4, t5
        addi t4, t4, -1
        j continue
    set_low:
        mv t3, t5
        addi t3, t3, 1
    continue:
        ble t3, t4, binary_search
        j end   
set_PS:
    li a1, 1
end:
    li a7, 10
    ecall
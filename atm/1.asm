mov r2, #00h
mov a, 30h
mov b, 30h
mul ab
mov 67h, a
mov r0, #31h
add a, r0
mov r1, a
mov 68h, r1
mov a, 67h
add a, r1
mov 69h, a
mov r3, 69h
mov r4, 68h
mov r5, 67h
mov b, r3
label:
ljmp addition
faltu_label:
here: sjmp here

addition:
djnz r5, faltu_label_1
ljmp faltu_label

faltu_label_1:
clr a
add a, @r0
add a, @r1
mov b,a
inc r0
inc r1
inc r2
inc b
ljmp addition





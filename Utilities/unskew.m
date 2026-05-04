function r = unskew(A)
    r1 = A(3, 2);
    r2 = A(1, 3);
    r3 = A(2, 1);
    r = [r1; r2; r3];
end
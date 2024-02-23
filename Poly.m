function [phipol] = Poly(l1,m)
clear phipol L
phipol = [];
exp1 = 1;
L = [];
while(exp1<=m)
    phipol = [phipol l1.^exp1];
    if exp1 < m
        L = [];
    for i = 1:length(l1)
        exp2 = 1;
        for j = i+1:length(l1)
            while exp2<m
                L = [L l1(i)^exp1*l1(j)^exp2];
                exp2 = exp2+1;
            end
        end
    end
    phipol = [phipol L];
    end
    exp1 = exp1 + 1;
end
end

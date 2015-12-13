% Author: Weichen Xu
% Date: 10/21/2015
% Compute correaltion of Matrix A . B
% Set border to undefined
function m = correlation_WCX(A, B)
[Ax, Ay] = size(A);
[Bx, By] = size(B);
m = zeros(Ax,Ay);
for i = 1:Ax
    for j = 1:Ay
        correlation = 0;
        if i==1 || i==Ax || j==1 || j==Ay
            continue;
        end
        for k = 1:Bx
            for l = 1:By
                correlation = B(k, l)*A(i+k-floor(Bx/2)-1, j+l-floor(By/2)-1) + correlation;
            end
        end
        m(i, j) = correlation;
    end
end
end
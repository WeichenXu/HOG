% Normalize the input vector by L2 method
% Author: Weichen Xu
% Date: 12/13/2015

function v_normalized = normalize_L2_WCX(v)
v_normalized = v;
v = v.^2;
divide = sqrt(sum(v));
v_normalized = v_normalized/divide;
end
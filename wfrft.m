% function file : wfrft 
function y = wfrft(x, ALPHA, NWFRFT)
% disp('wfrft.m is running...')

[Length, nSym] = size(x);
if Length ~= NWFRFT
    error('length of x is not N !');
end
w = zeros(1,4);
for i=1:1:4
    w(i)=cos(pi*(ALPHA-i+1)/4)*cos(2*pi*(ALPHA-i+1)/4)*exp(-1j*3*pi*(ALPHA-i+1)/4);
end
y = zeros(Length, nSym);
for sym_id = 1:nSym
    x0 = x(:,sym_id)';
    x1 = fft(x0,NWFRFT)/NWFRFT^.5;
    x2 = [ x0(1) fliplr(x0(2:end)) ];
    x3 = [ x1(1) fliplr(x1(2:end)) ];
    temp = w(1)*x0 + w(2)*x1 + w(3)*x2 + w(4)*x3;
    y(:,sym_id) = temp';
end

end % end of function wfrft

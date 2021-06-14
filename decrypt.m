%DECRYPTION FUNCTION-----------------
function [P] = decrypt(S,C)
% call global variables
global w; global r;
% mod parameter for modulus sums
m=uint64(pow2(w));

C=reshape(C, [2 length(C)/2]);
P=uint64(zeros(size(C)));

for p=1:size(C,2)
    %sum with m to recover from mod operation from encryption process
    A=C(1,p)+m;
    B=C(2,p)+m;
    
    for i=r+1:-1:2
        B=bitxor(ROTR(mod(B-S(2*i,:),m),A,w),A);
        A=bitxor(ROTR(mod(A-S(2*i-1,:),m),B,w),B);
    end
    B=mod(B-S(2,:),m);
    A=mod(A-S(1,:),m);
    P(1,p)=A;
    P(2,p)=B;
end
P=reshape(P,[size(P,1)*size(P,2) 1]);
    function q=ROTR(x,y,w)
        q=mod(bitor(bitsra(x,bitand(y,(w-1))),...
            bitshift(x,w-bitand(y,(w-1)))),pow2(w));
    end
end
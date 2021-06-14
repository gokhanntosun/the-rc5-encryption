%ENCRYPTION FUNCTION-----------------
function [C] = encrypt(S,Pl)
% call global variables
global w; global r;
% mod parameter for modulus sums
m=uint64(pow2(w));

%reshape plaintext array, blocks of 2
if mod(length(Pl),2)==1
    P=[Pl; 0];
elseif mod(length(Pl),2)==0
    P=Pl;
end

P=reshape(P, [2 length(P)/2]);
C=uint64(zeros(2,size(P,2)));

for p=1:size(P,2)
    %current blocks of plaintext
    A=uint64(P(1,p));
    B=uint64(P(2,p));
    
    %begin encryption
    
    A=mod(A+S(1,:),m);%first update of A
    B=mod(B+S(2,:),m);%first update of B
    for i=2:r+1
        %process first plaintext block
        A=mod(ROTL(bitxor(A,B),B,w)+S(2*i-1,:),m);
        %process second plaintext block
        B=mod(ROTL(bitxor(B,A),A,w)+S(2*i,:),m);
    end
    C(:,p)=[A B]';
end
C=reshape(C,[size(C,1)*size(C,2) 1]);

    function q=ROTL(x,y,w)
        q=mod(bitor(bitshift(x,bitand(y,(w-1))),...
            bitsra(x,w-bitand(y,(w-1)))),pow2(w));
    end
end
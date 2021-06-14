%KEY EXPANSION FUNCTION--------------
function [S] = setup(K_str)
% call global variables
global w;global r;global b;
% required parameters
t=2*(r+1);              % expanded key array length
u=w/8;                  % number of bytes per word (4)
c=floor(max(b,1))/u;    % words per key
m=uint64(pow2(w));      % modulo parameters for modulo sums

% process secret key
K_ch=char(strrep(K_str," ",""));        % turn into char array
% split the secret key into bytes
for i=1:2:length(K_ch)
    K(0.5*(i+1),:)=['0x' K_ch(i:i+1)];  % add 0x prefix and divide by bytes
end
K=uint64(str2num(K));                   % convert to unsigned integer

% look-up table for magit constants
P=uint64(((w==16)*47073)+((w==32)*3084996963)+((w==64)*13249961062380153451));
Q=uint64(((w==16)*40503)+((w==32)*2654435769)+((w==64)*11400714819323198485));

% convert key from bytes to words
L=uint64(zeros(c,1));
for i=b:-1:1
    L(ceil(i/u),:)=bitshift(L(ceil(i/u),:),8)+K(i,:);
end

% fill expanded key array, sub-keys
S(1,1)=P;
for i=2:t
    S(i,1)=mod(S(i-1,1)+Q,m);
end

% mix the secret key
i=0;j=0;%loop variables
A=0;B=0;%loop variables
for k=0:3*max(t,c)-1
    %update subkey array
    S(i+1,:)=ROTL(mod(S(i+1,:)+(A+B),m),3,w);
    A=S(i+1,:);
    
    %update word array
    L(j+1,:)=ROTL(mod(L(j+1,:)+(A+B),m),(A+B),w);
    B=L(j+1,:);
    
    %update indexes
    i=mod(i+1,t);
    j=mod(j+1,c);
end

    function q=ROTL(x,y,w)
        q=mod(bitor(bitshift(x,bitand(y,(w-1))),...
            bitsra(x,w-bitand(y,(w-1)))),pow2(w));
    end
end
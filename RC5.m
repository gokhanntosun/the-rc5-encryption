%MAIN--------------------------------
clear; close all;
% specify RC5 scheme by specifying w, r and b parameters
% [RC5-w/r/b]

% nominal values are defined as follow
global w; w=32; % word length
global r; r=12; % # of rounds
global b; b=16; % # of bytes in secret key
% [RC5-12/12/16]

% secret key, must be of type string
K="91 5F 46 19 BE 41 B2 51 63 55 A5 01 10 A9 CE 91";

% sample plain text, must be column vector
P=uint64(randi([pow2(31) pow2(32)],[50 1]));

% sub-keys
S=setup(K);

% encrypt to obtain ciphertext
C=encrypt(S,P);

% plaintext
Pd=decrypt(S,C);

% store plaintext and en/decryption results in a table
T=table(dec2hex(P),dec2hex(C),dec2hex(Pd)...
    ,'VariableNames',{'Plaintext','Ciphertext','Decrypted Text'});

% save table as txt file
writetable(T, 'RC5.txt');

%{
Some text vectors provided in the original paper:

1. key = 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
   plaintext 00000000 00000000  --->  ciphertext EEDBA521 6D8F4B15  

2. key = 91 5F 46 19 BE 41 B2 51 63 55 A5 01 10 A9 CE 91 
   plaintext EEDBA521 6D8F4B15  --->  ciphertext AC13C0F7 52892B5B  

3. key = 78 33 48 E7 5A EB 0F 2F D7 B1 69 BB 8D C1 67 87 
   plaintext AC13C0F7 52892B5B  --->  ciphertext B7B3422F 92FC6903  

4. key = DC 49 DB 13 75 A5 58 4F 64 85 B4 13 B5 F1 2B AF 
   plaintext B7B3422F 92FC6903  --->  ciphertext B278C165 CC97D184  

5. key = 52 69 F1 49 D4 1B A0 15 24 97 57 4D 7F 15 31 25 
   plaintext B278C165 CC97D184  --->  ciphertext 15E444EB 249831DA  
%}



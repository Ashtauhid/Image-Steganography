 clc;
clear all;
close all;
% Global Variable Declarations
preallocations;

% Initial input plaintext and key
% plaintext = '0123456789ABCDEF';
plaintext = 'Hello world';
plaintext = zerofill(plaintext);
% key = 'MachinIntllignce';
key = input('Type in a secret key/password (16 characters or less):\n','s');
key = zerofill(key);

% Key Schedule
round_keys = key_schedule(double(key));
% Message Encryption
ciphertext = aes_encryption(plaintext,round_keys);
fprintf('\nCiphertext is\n')
disp(char(ciphertext));
fprintf('\n****END OF ENCRYPTION****\n\n');
% Message Decryption
ciphertext = [170	198	66	45	220	242	161	223	57	167	66	67	47	19	227	66];
plaintext_recov = aes_decryption(ciphertext, round_keys);


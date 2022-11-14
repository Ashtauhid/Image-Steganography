clc;
clear all; 
close all;

r = 16;
c = 8;
key = input('Enter a key between 0 to 255: ');
keyBin = de2bi(key,8);
for a = 1:r
    keyBinary(a,:) = keyBin;
end

% Compression
block_size = 8;

I11 = imread('C:\Users\Ashraful Tauhid\Desktop\Encypted.jpg');
I1 = im2double(I11); 
I1 = I1*255;    
no1 = (floor(size(I1,1)/(block_size)))*block_size;
no2 = (floor(size(I1,2)/block_size))*block_size;
I1 = imresize(I1,[no1,no2]);
     
    
I = I1;
Red = I(:,:,1);
T = dctmtx(block_size);
dct = @(block_struct) T* block_struct.data*T';
  
B1 = blockproc(I,[8,8],dct);
   
transformed = cat(1,B1);
    
%% table generation


quantization_table = ones(8,8);
quantization_table(1,1) = 16;quantization_table(1,2) = 11;quantization_table(1,3) = 10;quantization_table(1,4) = 16;
quantization_table(2,1) = 12;quantization_table(2,2) = 12;quantization_table(2,3) = 14;
quantization_table(3,1) = 14;quantization_table(3,2) = 13;
quantization_table(4,1) = 14;
    
    
%% quantization
quant=int64(zeros(size(I1,1),size(I1,1),1));
recon=double(zeros(size(I1,1),size(I1,1),1));
for k=1:1
    for i=1:block_size:size(I1,1)
        for j=1:block_size:size(I1,2)
            for ii=1:block_size
                for jj=1:block_size
                    aa=B1(i+ii-1,j+jj-1,k);
                    quant(i+ii-1,j+jj-1,k)=(aa);
                    quant(i+ii-1,j+jj-1,k)=(aa/quantization_table(ii,jj));
                    
                end
            end
        end
    end
end

quantCopy = quant;
%% only dc value matrix
for x=1:size(I1,1)/block_size
    for y=1:size(I1,2)/block_size
        onlyDC(x,y) = quant((x*8)-7,(y*8)-7);
    end
end


dcMatrixTransposed = onlyDC';
dcMatrixReshaped = reshape(dcMatrixTransposed,[(size(I1,1)/block_size)*(size(I1,2)/block_size),1]);
dcMatrixBinary = de2bi(dcMatrixReshaped,8);
for k = 1:r*c
    messageBits(k) = dcMatrixBinary(k,1);
end

d = 1;
for a = 1:r
    for b = 1:c
        messageBin(a,b) = messageBits(d);
        d = d+1;
    end
end
messageBin = xor(keyBinary,messageBin);
messageDec = bi2de(messageBin);
messageDec = messageDec'
message = char(messageDec);
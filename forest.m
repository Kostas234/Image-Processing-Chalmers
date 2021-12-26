clear all; clc;

load('forest.mat');
I = forestgray;
figure;
imshow(I,[]);

[M,N] = size(I);
Q = 2*N -1;
P = 2*M -1;
I = im2double(I);
I = log(1 + I);

% zero padding
I = padarray(I,[P-M Q-N],0,'post'); 

% DFT
I = fftshift(fft2(I));

% Distance function
[U,V] = meshgrid(1:Q,1:P);
centerU = ceil(Q/2);
centerV = ceil(P/2);
D = (U - centerU).^2 + (V - centerV).^2;

% HP Filter
for D0=1:5:80
gammaH = 1; % <1 = blur, 1.5
gammaL = 0.15; %1.15, 0.1
c = 1; % 5
%D0 = 80; 8
H = (gammaH - gammaL)*(1 - exp(-c*(D/(D0^2)))) + gammaL;

% Filtering the image
If = H.*I;

% Inverse FFT
If = ifft2(ifftshift(If));

% Remove padding and inverse log
If = If(1:M,1:N);
If = exp(If);

If= real(If);
%figure;
imshow(If,[]);
end
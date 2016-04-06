clear all; close all; clc;
load Testdata
L=15; % spatial domain
n=64; % Fourier modes
x2=linspace(-L,L,n+1); x=x2(1:n); y=x; z=x;
k=(2*pi/(2*L))*[0:(n/2-1) -n/2:-1]; ks=fftshift(k);
[X,Y,Z]=meshgrid(x,y,z);
[Kx,Ky,Kz]=meshgrid(ks,ks,ks);
[KxU,KyU,KzU]=meshgrid(k,k,k); % unshifted meshgrid in space domian

UAve = zeros(n,n,n); 
for j = 1:20
    Unt = fftn(reshape(Undata(j,:),n,n,n)); % FFT data in each measurement
    UAve = UAve + Unt; % add up data in frequency domain
end
UAve = abs(UAve)/20; % get the mean
[v,I] = max(UAve(:)); % extract the maximum, which is the main frequency
[ii,jj,kk] = ind2sub([n,n,n],I);% returns 3 subscript arrays equal to I

CentreX = KxU(ii,jj,kk); % Center frequency
CentreY = KyU(ii,jj,kk);
CnetreZ = KzU(ii,jj,kk);

filter = exp(-2.*((KxU-KxU(ii,jj,kk)).^2+(KyU-KyU(ii,jj,kk)).^2 +(KzU-KzU(ii,jj,kk)).^2)); % 3-D Gaussian filter

for j = 1:20
    Unt = fftn(reshape(Undata(j,:),n,n,n)); % FFT data in each measurement
    Untf = Unt.*filter; % multiply by the filter
    Unf = ifftn(Untf); % transform back to spatial domain
    [v2,I2] = max(Unf(:)); % extract the path with the max number
    [ii2,jj2,kk2] = ind2sub([n,n,n],I2); % returns 3 subscript arrays equal to I2
    a(j) = X(ii2,jj2,kk2); % x-coordinate
    b(j) = Y(ii2,jj2,kk2); % y-coordinate
    c(j) = Z(ii2,jj2,kk2); % z-coordinate
end
plot3(a,b,c);grid on;
xlabel('x-coordinate'), ylabel('y-coordinate'), zlabel('z-coordinate'); 
ans = [a(20), b(20), c(20)]; % final answer - marble position





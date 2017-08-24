
clc
clear

ALPHA = [0 0.7 0.9 1];
EbN0dB = 0:12;
BER = [];
for alpha = ALPHA
    BER = [ BER; BBER_WFRFT_SYSTEM(EbN0dB, ALPHA) ];
end

h=figure(1);
semilogy(SNR,BER(1,:),'-go','MarkerSize',8,'LineWidth',2);
hold on
semilogy(SNR,BER(2,:),'-r*','MarkerSize',8,'LineWidth',2);
semilogy(SNR,BER(3,:),'-bs','MarkerSize',8,'LineWidth',2);
semilogy(SNR,BER(4,:),'-k+','MarkerSize',8,'LineWidth',2);
%semilogy(SNR,BER(5,:),'-r+','MarkerSize',8,'LineWidth',1);
hold off
legend( ['0'],['0.7'],['0.9'], ['1'] );
FX=xlabel('Eb/N0(dB)');
FY=ylabel('BER');
set(FX,'FontSize',14);
set(FY,'FontSize',14);
grid on;

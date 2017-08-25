
clc
clear

ALPHA = [0 0.3 0.5 1];
EbN0dB = 0:12;
BER = zeros(length(EbN0dB),length(ALPHA));
for alpha_id = 1:length(ALPHA)
    for ebn0db_id = 1:length(EbN0dB)
        BER(ebn0db_id,alpha_id) = BER_WFRFT_SYSTEM(EbN0dB(ebn0db_id), ALPHA(alpha_id));
    end
end

h=figure(1);
semilogy(EbN0dB,BER(:,1),'-go','MarkerSize',8,'LineWidth',2);
hold on
semilogy(EbN0dB,BER(:,2),'-r*','MarkerSize',8,'LineWidth',2);
semilogy(EbN0dB,BER(:,3),'-k+','MarkerSize',8,'LineWidth',2);
semilogy(EbN0dB,BER(:,4),'-bs','MarkerSize',8,'LineWidth',2);
%semilogy(EbN0dB,BER(:,5),'-ro','MarkerSize',8,'LineWidth',1);
hold off
legend( ['0'],['0.3'] ,['0.5'], ['1'] );
FX=xlabel('Eb/N0(dB)');
FY=ylabel('BER');
set(FX,'FontSize',14);
set(FY,'FontSize',14);
grid on;

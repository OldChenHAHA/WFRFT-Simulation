clc;clear;close all

%%%%%%%%%%%%%%
% Parameters %
%%%%%%%%%%%%%%
SNRdB = 15;
alpha = 1;
number_of_wfrft_carriers = 1024;%2048;
number_of_used_carriers = 1024;%1200;
number_of_cp = 128;%144;
number_of_wfrft_symbols = 5;

index_of_used_carriers = 1:number_of_used_carriers;
% index_of_used_carriers = [ 2:number_of_used_carriers/2+1  number_of_wfrft_carriers-number_of_used_carriers/2+1 :number_of_wfrft_carriers ];

tx_bit = randsrc(1,number_of_used_carriers*number_of_wfrft_symbols*2,[0 1]);
tx_I = 2*(tx_bit(1:2:end) - 0.5);
tx_Q = 2*(tx_bit(2:2:end) - 0.5);
tx_qpsk = reshape(1/sqrt(2)*complex(tx_I,tx_Q),number_of_used_carriers,number_of_wfrft_symbols);
tx_temp = zeros(number_of_wfrft_carriers,number_of_wfrft_symbols);
tx_temp(index_of_used_carriers,:) = tx_qpsk;

tx_wfrft_qpsk = wfrft(tx_temp,alpha,number_of_wfrft_carriers);
tx_cp_wfrft = [ tx_wfrft_qpsk(end-number_of_cp+1:end,:) ; tx_wfrft_qpsk ];
tx_signal = reshape(tx_cp_wfrft,1,number_of_wfrft_symbols*(number_of_cp+number_of_wfrft_carriers));

% channel
r_awgn_cp_wfrft = awgn(tx_signal, SNRdB, 'measured');
k = 1:length(r_awgn_cp_wfrft);
r_awgn_cp_wfrft = r_awgn_cp_wfrft.*exp(1j*2*pi*0.4*k/number_of_wfrft_carriers);

[CPStartPoint,FCO] = MLOFDMSyn(r_awgn_cp_wfrft, number_of_cp, number_of_wfrft_carriers, SNRdB);

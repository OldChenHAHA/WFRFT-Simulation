function [MSE_CPpos, MSE_FCOval] = MSE_MLSyn(EbN0dB, alpha, real_FCOval, number_of_cp)

% Simulatoin Parameters
%EbN0dB = 8;
sim_max_times = 100;
%alpha = 1;

% Frame Parameters
number_of_wfrft_carriers = 2048;%2048;
number_of_used_carriers = 2048;%1200;
%number_of_cp = 144;%144;
number_of_wfrft_symbols = 3;
length_of_cpSymbol = number_of_cp+number_of_wfrft_carriers;

index_of_used_carriers = 1:number_of_used_carriers;
%index_of_used_carriers = [ 2:number_of_used_carriers/2+1  number_of_wfrft_carriers-number_of_used_carriers/2+1 :number_of_wfrft_carriers ];


real_CPpos = 1 + length_of_cpSymbol;
real_FCOval = 0.4;
sim_CPpos = zeros(1,sim_max_times);
sim_FCOval = zeros(1,sim_max_times);

for sim_cnt = 1:sim_max_times

    %% Transmiter %%
    tx_bit = randsrc(1,number_of_used_carriers*number_of_wfrft_symbols*2,[0 1]);
    tx_I = 2*(tx_bit(1:2:end) - 0.5);
    tx_Q = 2*(tx_bit(2:2:end) - 0.5);
    tx_qpsk = reshape(1/sqrt(2)*complex(tx_I,tx_Q),number_of_used_carriers,number_of_wfrft_symbols);
    tx_temp = zeros(number_of_wfrft_carriers,number_of_wfrft_symbols);
    tx_temp(index_of_used_carriers,:) = tx_qpsk;

    tx_wfrft_qpsk = wfrft(tx_temp,alpha,number_of_wfrft_carriers);
    tx_cp_wfrft = [ tx_wfrft_qpsk(end-number_of_cp+1:end,:) ; tx_wfrft_qpsk ];
    tx_signal = reshape(tx_cp_wfrft,1,number_of_wfrft_symbols*length_of_cpSymbol);

    %% channel %%
    % awgn
    channel_data = tx_signal;
	EbN0linear = 10^(EbN0dB/10);
	Es = sum(abs(channel_data).^2)/length_of_cpSymbol;
    Eb = Es/2;
	N0 = Eb/EbN0linear;
	var = N0/2;
	sigma = sqrt(var);
	rv1 = randn(1,numel(channel_data));
	rv2 = randn(1,numel(channel_data));
	noise = sigma.*complex(rv1,rv2);

	channel_data = channel_data + noise;

    % add Frequency offset
    k = 1:length(channel_data);
    channel_data = channel_data.*exp(1j*2*pi*real_FCOval*k/number_of_wfrft_carriers);

    %% Receiver %%
    randpos = randsrc(1,1,number_of_cp:length_of_cpSymbol-1);
    rx_channel_data = channel_data(randpos+1:randpos+2*number_of_wfrft_carriers+number_of_cp);
    [CPStartPoint,FCO] = MLOFDMSyn(rx_channel_data, number_of_cp, number_of_wfrft_carriers, EbN0dB);
    CPStartPoint = randpos + CPStartPoint;
    sim_CPpos(sim_cnt) = CPStartPoint;
    sim_FCOval(sim_cnt) = FCO;

end % end of the sim_max_times

MSE_CPpos = 1/sim_max_times*sum((sim_CPpos-real_CPpos).^2);
MSE_FCOval = 1/sim_max_times*sum((sim_FCOval-real_FCOval).^2);

end

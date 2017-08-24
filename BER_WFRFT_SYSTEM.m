function BER = BER_WFRFT_SYSTEM(EbN0dB, ALPHA)

%%%%%%%%%%%%%%
% Parameters %
%%%%%%%%%%%%%%
snr_max_times = 10^9;
MAX_ERROR_BITS = 200;

number_of_wfrft_carriers = 1024;%2048;
number_of_used_carriers = 1024;%1200;
number_of_cp = 128;%144;
number_of_wfrft_symbols = 1; % dont change

index_of_used_carriers = 1:number_of_used_carriers;
% index_of_used_carriers = [ 2:number_of_used_carriers/2+1  number_of_wfrft_carriers-number_of_used_carriers/2+1 :number_of_wfrft_carriers ];

%==============Filter Design==============%
Fs = 16;  % Sampling Frequency
N  = 64;         % Order
Fc = 2;          % Cutoff Frequency
TM = 'Rolloff';  % Transition Mode
R  = 0.25;       % Rolloff
DT = 'Normal';   % Design Type
% Create the window vector for the design algorithm.
win = hamming(N+1);
% Calculate the coefficients using the FIR1 function.
H  = firrcos(N, Fc/(Fs/2), R, 2, TM, DT, [], win);
%=========================================%

total_errbit = 0;
total_bit = 0;
for sim_time_cnt = 1:snr_max_times

	%=============Transmiter=================%
	% Generate user bit
	tx_bit = randsrc(1,number_of_used_carriers*number_of_wfrft_symbols*2,[0 1]);
	% Qpsk modulate
	tx_I = 2*(tx_bit(1:2:end) - 0.5);
	tx_Q = 2*(tx_bit(2:2:end) - 0.5); % Eb=1 : energy per bit is 1
	tx_qpsk = reshape(1/sqrt(2)*complex(tx_I,tx_Q),number_of_used_carriers,number_of_wfrft_symbols);
	% Map qpsk data into wfrft carriers
	tx_temp = zeros(number_of_wfrft_carriers,number_of_wfrft_symbols);
	tx_temp(index_of_used_carriers,:) = tx_qpsk;
	% Wfrft transform
	tx_wfrft_qpsk = wfrft(tx_temp,ALPHA,number_of_wfrft_carriers);
	% Add CP
	tx_cp_wfrft = [ tx_wfrft_qpsk(end-number_of_cp+1:end,:) ; tx_wfrft_qpsk ];
	% Reshape data to one dimension
	tx_signal = reshape(tx_cp_wfrft,1,number_of_wfrft_symbols*(number_of_cp+number_of_wfrft_carriers));

	% Upsample data
	tx_upsampled_data = upsample(tx_signal,16);
	% Tx Filter
	tx_filter_output = conv(tx_upsampled_data,H);

	%==============Channel=================%
	channel_data = tx_filter_output;
	EbN0linear = 10^(EbN0dB/10);
	Es = sum(abs(channel_data).^2)/(number_of_cp+number_of_wfrft_carriers);
    Eb = Es/2;
	N0 = Eb/EbN0linear;
	var = N0/2;
	sigma = sqrt(var);
	rv1 = randn(1,numel(channel_data));
	rv2 = randn(1,numel(channel_data));
	noise = sigma.*complex(rv1,rv2);

	channel_awgn_data = channel_data + noise;
    % channel_awgn_data = channel_data;
    % channel_awgn_data = awgn(channel_data,13.0103,'measured');
	%==============Receiver===============%
	% Rx Filter
	rx_filter_output = conv(channel_awgn_data,H);
    % check figure
    % figure;
    % title('tx_filter_output');
    % stem(real(tx_filter_output(1:160)));
    % figure;
    % title('rx_filter_output');
    % stem(real(rx_filter_output(1:160)));
    % check over
	% Downsample data
    rx_filter_output = rx_filter_output(57:end);
	shift = 6; % default: 8. downsample shift in [0,n-1]
	rx_upsampled_data = downsample(rx_filter_output,16,shift);
    rx_upsampled_data = rx_upsampled_data(1:number_of_cp+number_of_wfrft_carriers);

	% Reshape data into matrix
	rx_signal_matrix = reshape(rx_upsampled_data,(number_of_cp+number_of_wfrft_carriers),number_of_wfrft_symbols);
	% Remove CP
	rx_data_nocp = rx_signal_matrix(number_of_cp+1:end,:);
	% Wfrft -alpha transform
	rx_iwfrft_data = wfrft(rx_data_nocp,-ALPHA,number_of_wfrft_carriers);
	% Subcarrier demap
	rx_demap_data = rx_iwfrft_data(index_of_used_carriers,:);
	% Qpsk demod
	rx_qpsk = reshape(rx_demap_data,1,number_of_used_carriers*number_of_wfrft_symbols);
	rx_I = real(rx_qpsk)>0 + 0;
	rx_Q = imag(rx_qpsk)>0 + 0;
	rx_bit = zeros(size(tx_bit));
	rx_bit(1:2:end) = rx_I;
	rx_bit(2:2:end) = rx_Q;

	[errbit,~]=biterr(rx_bit,tx_bit);
	total_errbit = total_errbit + errbit;
	total_bit = total_bit + length(tx_bit);

    if total_errbit > MAX_ERROR_BITS
        break;
    end

end % end of for sim_cnt

BER = total_errbit/total_bit;
end

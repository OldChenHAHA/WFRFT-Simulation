function [CPStartPoint, FCO] = MLOFDMSyn(data, CP_LENGTH, NFFT, SNRdB)
%MLOFDMSYN ML estimation of time and frequency offset in OFDM systems
%   Detailed explanation goes here
%   Van De Beek J J, Sandell M, Borjesson P O.
%   00599949.pdf
%   ML estimation of time and frequency offset in OFDM systems[J].
%   IEEE Transactions on Signal Processing, 1997, 45(7): 1800-1805

%   Authors: Neil Judson
%   Copyright 2016 Neil Judson
%   $Revision: 1.2 $  $Date: 2016/07/27 10:30:00 $

% plot gamma figure, 0--OFF 1--ON
figure_ON = 0;

%% 时延
dataDelay = data;
data = [dataDelay(NFFT+1:end) zeros(1,NFFT)];

%% 自相关、能量
selfMult = dataDelay .* conj(data);
dataDelayPwr = dataDelay .* conj(dataDelay);
dataPwr = data .* conj(data);
gammaLength = length(selfMult) - NFFT;
%gammaLength = 500;
gamma = zeros(1,gammaLength);
phi = zeros(1,gammaLength);

for m = 1:1:gammaLength
    gamma(m) = sum(selfMult(m:m+CP_LENGTH-1));
    phi(m) = 1/2*sum(dataDelayPwr(m:m+CP_LENGTH-1)+dataPwr(m:m+CP_LENGTH-1));
end

%% 时间同步
SNR_linear = 10 ^ (SNRdB/10);
rou =  SNR_linear / (SNR_linear+1);
gammaAbs = abs(gamma);
target = gammaAbs - rou*phi;
CPStartPoint = find(target(1:gammaLength)==max(target(1:gammaLength)));
CPStartPoint = CPStartPoint(1); % CP起始位置

%% 小数频偏估计
% FCO = -atan(imag(gamma(CPStartPoint))/real(gamma(CPStartPoint))) / 2 / pi;
FCO = (-1/2/pi)*angle(gamma(CPStartPoint));
if figure_ON == 1
    subplot(2,1,1);
    plot(target,'LineWidth',1);
    FX=xlabel('Time (samples)');
    FY=ylabel('\theta');
    set(FX,'FontSize',10);
    set(FY,'FontSize',15,'rotation',0.0);
    grid on;
    
    subplot(2,1,2);
    fco = (-1/2/pi)*angle(gamma);
    plot(fco,'LineWidth',1);
    set(gca,'YLim',[-0.5 0.5]);%X轴的数据显示范围
    set(gca,'YTick',[-0.5:0.25:0.5]);%设置要显示坐标刻度
    axis([1 length(fco) -0.6 0.6]);
    FX=xlabel('Time (samples)');
    FY=ylabel('\epsilon ');
    set(FX,'FontSize',10);
    set(FY,'FontSize',15,'rotation',0.0);
    grid on;


end

end

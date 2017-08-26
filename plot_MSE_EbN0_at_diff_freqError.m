clc;close all;clear

% parameter

EbN0dB = [0:2:24];
ALPHA = [1];
FCO = [0.25];
number_of_cp = [8 12 18];

MSE_CPpos_matrix = zeros(length(EbN0dB),length(ALPHA),length(FCO),length(number_of_cp));
MSE_FCOval_matrix = zeros(length(EbN0dB),length(ALPHA),length(FCO),length(number_of_cp));
for number_of_cp_id = 1:length(number_of_cp)
    for fco_id = 1:length(FCO)
        for alpha_id = 1:length(ALPHA)
            for ebn0db_id = 1:length(EbN0dB)
                [MSE_CPpos, MSE_FCOval] = MSE_MLSyn(EbN0dB(ebn0db_id), ALPHA(alpha_id), FCO(fco_id), number_of_cp(number_of_cp_id));
                MSE_CPpos_matrix(ebn0db_id,alpha_id,fco_id,number_of_cp_id) = MSE_CPpos;
                MSE_FCOval_matrix(ebn0db_id,alpha_id,fco_id,number_of_cp_id) = MSE_FCOval;
            end
        end
    end
end
%% 估计性能与频偏无关 画图
% figure;
% x = FCO;
% y = reshape(MSE_FCOval_matrix(1,1,:,1),1,length(x));
% semilogy(x,y,'-bo','MarkerSize',8,'LineWidth',2);
% hold on
% y = reshape(MSE_FCOval_matrix(2,1,:,1),1,length(x));
% semilogy(x,y,'-r*','MarkerSize',8,'LineWidth',2);
% y = reshape(MSE_FCOval_matrix(3,1,:,1),1,length(x));
% semilogy(x,y,'-k+','MarkerSize',8,'LineWidth',2);
% %semilogy(EbN0dB,BER(:,4),'-bs','MarkerSize',8,'LineWidth',2);
% %semilogy(EbN0dB,BER(:,5),'-ro','MarkerSize',8,'LineWidth',1);
% hold off
% legend( ['EbN0 = 5dB'],['EbN0 = 10dB'] ,['EbN0 = 15dB'] );
% FX=xlabel('\epsilon');
% FY=ylabel('MSE of frequency estimator');
% set(FX,'FontSize',14);
% set(FY,'FontSize',14);
% grid on;
% 
% 
% figure;
% x = FCO;
% y = reshape(MSE_CPpos_matrix(1,1,:,1),1,length(x));
% semilogy(x,y,'-bo','MarkerSize',8,'LineWidth',2);
% hold on
% y = reshape(MSE_CPpos_matrix(2,1,:,1),1,length(x));
% semilogy(x,y,'-r*','MarkerSize',8,'LineWidth',2);
% y = reshape(MSE_CPpos_matrix(3,1,:,1),1,length(x));
% semilogy(x,y,'-k+','MarkerSize',8,'LineWidth',2);
% %semilogy(EbN0dB,BER(:,4),'-bs','MarkerSize',8,'LineWidth',2);
% %semilogy(EbN0dB,BER(:,5),'-ro','MarkerSize',8,'LineWidth',1);
% hold off
% legend( ['EbN0 = 5dB'],['EbN0 = 10dB'] ,['EbN0 = 15dB'] );
% FX=xlabel('\epsilon');
% FY=ylabel('MSE of time estimator');
% set(FX,'FontSize',14);
% set(FY,'FontSize',14);
% grid on;

%% 估计性能与alpha阶数无关 画图
% figure;
% x = ALPHA;
% y = reshape(MSE_FCOval_matrix(1,:,1,1),1,length(x));
% semilogy(x,y,'-bo','MarkerSize',8,'LineWidth',2);
% hold on
% y = reshape(MSE_FCOval_matrix(2,:,1,1),1,length(x));
% semilogy(x,y,'-r*','MarkerSize',8,'LineWidth',2);
% y = reshape(MSE_FCOval_matrix(3,:,1,1),1,length(x));
% semilogy(x,y,'-k+','MarkerSize',8,'LineWidth',2);
% %semilogy(EbN0dB,BER(:,4),'-bs','MarkerSize',8,'LineWidth',2);
% %semilogy(EbN0dB,BER(:,5),'-ro','MarkerSize',8,'LineWidth',1);
% hold off
% legend( ['EbN0 = 5dB'],['EbN0 = 10dB'] ,['EbN0 = 15dB'] );
% FX=xlabel('\alpha of WFRFT');
% FY=ylabel('MSE of frequency estimator');
% set(FX,'FontSize',14);
% set(FY,'FontSize',14);
% grid on;
% 
% figure;
% x = ALPHA;
% y = reshape(MSE_CPpos_matrix(1,:,1,1),1,length(x));
% semilogy(x,y,'-bo','MarkerSize',8,'LineWidth',2);
% hold on
% y = reshape(MSE_CPpos_matrix(2,:,1,1),1,length(x));
% semilogy(x,y,'-r*','MarkerSize',8,'LineWidth',2);
% y = reshape(MSE_CPpos_matrix(3,:,1,1),1,length(x));
% semilogy(x,y,'-k+','MarkerSize',8,'LineWidth',2);
% %semilogy(EbN0dB,BER(:,4),'-bs','MarkerSize',8,'LineWidth',2);
% %semilogy(EbN0dB,BER(:,5),'-ro','MarkerSize',8,'LineWidth',1);
% hold off
% legend( ['EbN0 = 5dB'],['EbN0 = 10dB'] ,['EbN0 = 15dB'] );
% FX=xlabel('\alpha of WFRFT');
% FY=ylabel('MSE of time estimator');
% set(FX,'FontSize',14);
% set(FY,'FontSize',14);
% grid on;

%% 估计性能与循环前缀长度 画图
figure;
x = EbN0dB;
y = reshape(MSE_FCOval_matrix(:,1,1,1),1,length(x));
semilogy(x,y,'-bo','MarkerSize',8,'LineWidth',2);
hold on
y = reshape(MSE_FCOval_matrix(:,1,1,2),1,length(x));
semilogy(x,y,'-r*','MarkerSize',8,'LineWidth',2);
y = reshape(MSE_FCOval_matrix(:,1,1,3),1,length(x));
semilogy(x,y,'-k+','MarkerSize',8,'LineWidth',2);
%semilogy(EbN0dB,BER(:,4),'-bs','MarkerSize',8,'LineWidth',2);
%semilogy(EbN0dB,BER(:,5),'-ro','MarkerSize',8,'LineWidth',1);
hold off
legend( ['CP Length = 8'],['CP Length = 12'] ,['CP Length = 18'] );
FX=xlabel('EbN0(dB)');
FY=ylabel('MSE of frequency estimator');
set(FX,'FontSize',14);
set(FY,'FontSize',14);
grid on;

figure;
x = EbN0dB;
y = reshape(MSE_CPpos_matrix(:,1,1,1),1,length(x));
semilogy(x,y,'-bo','MarkerSize',8,'LineWidth',2);
hold on
y = reshape(MSE_CPpos_matrix(:,1,1,2),1,length(x));
semilogy(x,y,'-r*','MarkerSize',8,'LineWidth',2);
y = reshape(MSE_CPpos_matrix(:,1,1,3),1,length(x));
semilogy(x,y,'-k+','MarkerSize',8,'LineWidth',2);
%semilogy(EbN0dB,BER(:,4),'-bs','MarkerSize',8,'LineWidth',2);
%semilogy(EbN0dB,BER(:,5),'-ro','MarkerSize',8,'LineWidth',1);
hold off
legend( ['CP Length = 8'],['CP Length = 12'] ,['CP Length = 18'] );
FX=xlabel('EbN0(dB)');
FY=ylabel('MSE of time estimator');
set(FX,'FontSize',14);
set(FY,'FontSize',14);
grid on;
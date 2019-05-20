

clear all;
clc;
close all;


%% ��λ��ʼ��
num=50;
x_true=50*rand(num,2)';     %��ʵλ��



disp(x_true);
M=20;                                                                   %����������Ŀ
runs=100;                                                             %���ؿ���Ĵ���
maxstd=5;
p0=10;                                                                %��ʼ���书��
n=2.8;                                                                    %����Ӱ������

B=zeros(2,1);
H=zeros(2,2);
jaco=zeros(2,2);
est_biased_lls=zeros(num,2);
%AL=zeros(M-1,2);
len=sqrt(3);%dd1����
%% ������λ�÷ֲ��龰��ѡ��
Ellipse=0;
Circle=1;
Rect=0;
RandDeployment=0;
 
    %------------------------������Բ�ηֲ�
elseif Circle==1
    dist_x=0;                                                         %target��Բ���ĵĺ�����֮��
    dist_y=0;                                                         %target��Բ���ĵ�������֮��
    a=5;                                                              %Բ�İ뾶
    
    i=0;
    for j=1:num
        for seita=0:2*pi/M:2*pi-2*pi/M
            i=i+1;
            position(1,i,j)=x_true(1,j)+dist_x+a*cos(seita);
            position(2,i,j)=x_true(2,j)+dist_y+a*sin(seita);
        end
    i=i-M;
    end
       disp(position);

%%
k=1;
steps=0.1;
for j=1:num
for std=0.1:steps:maxstd+0.1
    
    sigma=std;

    for i=1:runs
        i
        %% ����RSS�����Լ���ص����ⷽ��
        %--------------------------------����RSS����
        
        x_real=x_true(1,j);                                      %��ʵ��Ŀ���λ��
        y_real=x_true(2,j);
        for t=1:M
            rss(j,t)=p0-10*n*log10(sqrt((y_real-position(2,t,j))^2+(x_real-position(1,t,j))^2))+sigma*randn(1);       %RSS����           
            d_hat(j,t)=exp(log(10)*(p0-rss(j,t))/(10*n));    %�ȼ��ھ��������
        end
        
        %% ��λ�㷨���� LS����ʵ��     
        %% --------------------------------------------------------α����LLS(���ⷽ������õ���α���Ի���������Ŀ����һ��)
        beta=log(10)/(5*n);
        for o=1:M-1
            A_LLS(o,:,j)=[2*(position(1,M,j)-position(1,o,j))  2*(position(2,M,j)-position(2,o,j))];
            H_biased_lls(j,o)=d_hat(j,o)^2-d_hat(j,M)^2+position(1,M,j)^2-position(1,o,j)^2+position(2,M,j)^2-position(2,o,j)^2;
                  end
        %��С���˹��ƽ��
        AL=A_LLS(:,:,j);      
       % disp(AL);
        est_biased_lls(j,:)=    (AL'*AL)\AL'*H_biased_lls(j,:)';
     
        
        %--------------------------------------------------------α����LLS
             %  erro_value= est_biased_lls-x_true';
       avg_erro(j,:)=sqrt((est_biased_lls(j,1)-x_true(1,j)')^2+(est_biased_lls(j,2)-x_true(2,j)')^2);
        
        
%              error_biased_lls(i,j)=(((x_real-x_biased_lls)^2+(y_real-y_biased_lls)^2))/2;%%
end
end



end

       %disp(erro_value);
       disp(avg_erro);
       avg_avg_erro=mean(avg_erro);
       disp(avg_avg_erro);
%����Ŀ����ʵλ�������λ�õķֲ�
figure
for j=1:num
       hold on;
plot(x_true(1,j),x_true(2,j),'k+','MarkerSize',8);
   hold on;
   plot(est_biased_lls(j,1),est_biased_lls(j,2),'ko','MarkerSize',5,'LineWidth',1);
 end
 hold off;
xlabel('x(m)');
ylabel('y(m)');
xlim([-2 52])
ylim([-2 52])
jj=legend('��ʵλ��','����λ��','location','NorthWest');
set(jj,'Fontsize',8);
title('����λ�ú���ʵλ������ֲ��Ա�ͼ');
hold on;
%ƽ����λ���
figure
plot(1:num,avg_erro,'black-','LineWidth',2);
hold on;
 plot([1,num],[avg_avg_erro,avg_avg_erro],'red-','LineWidth',2); 
  hold on;
xlabel('��λ����');
ylabel('��λ��m��');
xlim([0 num])
ylim([0 2])
kk=legend('���ζ�λ���','50�ζ�λ����ֵ','location','NorthWest');
set(kk,'Fontsize',8);
title('ƽ����λ���ͼ');
hold on;
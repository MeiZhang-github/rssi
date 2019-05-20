

clear all;
clc;
close all;


%% 定位初始化
num=50;
x_true=50*rand(num,2)';     %真实位置



disp(x_true);
M=20;                                                                   %传感器的数目
runs=100;                                                             %蒙特卡洛的次数
maxstd=5;
p0=10;                                                                %初始发射功率
n=2.8;                                                                    %环境影响因子

B=zeros(2,1);
H=zeros(2,2);
jaco=zeros(2,2);
est_biased_lls=zeros(num,2);
%AL=zeros(M-1,2);
len=sqrt(3);%dd1步长
%% 传感器位置分布情景的选择
Ellipse=0;
Circle=1;
Rect=0;
RandDeployment=0;
 
    %------------------------传感器圆形分布
elseif Circle==1
    dist_x=0;                                                         %target与圆中心的横坐标之差
    dist_y=0;                                                         %target与圆中心的纵坐标之差
    a=5;                                                              %圆的半径
    
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
        %% 产生RSS量测以及相关的量测方程
        %--------------------------------产生RSS量测
        
        x_real=x_true(1,j);                                      %真实的目标的位置
        y_real=x_true(2,j);
        for t=1:M
            rss(j,t)=p0-10*n*log10(sqrt((y_real-position(2,t,j))^2+(x_real-position(1,t,j))^2))+sigma*randn(1);       %RSS量测           
            d_hat(j,t)=exp(log(10)*(p0-rss(j,t))/(10*n));    %等价于距离的量测
        end
        
        %% 定位算法多种 LS具体实现     
        %% --------------------------------------------------------伪线性LLS(量测方程相减得到的伪线性化，方程数目减少一个)
        beta=log(10)/(5*n);
        for o=1:M-1
            A_LLS(o,:,j)=[2*(position(1,M,j)-position(1,o,j))  2*(position(2,M,j)-position(2,o,j))];
            H_biased_lls(j,o)=d_hat(j,o)^2-d_hat(j,M)^2+position(1,M,j)^2-position(1,o,j)^2+position(2,M,j)^2-position(2,o,j)^2;
                  end
        %最小二乘估计结果
        AL=A_LLS(:,:,j);      
       % disp(AL);
        est_biased_lls(j,:)=    (AL'*AL)\AL'*H_biased_lls(j,:)';
     
        
        %--------------------------------------------------------伪线性LLS
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
%画出目标真实位置与估计位置的分布
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
jj=legend('真实位置','估计位置','location','NorthWest');
set(jj,'Fontsize',8);
title('估计位置和真实位置坐标分布对比图');
hold on;
%平均定位误差
figure
plot(1:num,avg_erro,'black-','LineWidth',2);
hold on;
 plot([1,num],[avg_avg_erro,avg_avg_erro],'red-','LineWidth',2); 
  hold on;
xlabel('定位次数');
ylabel('定位误差（m）');
xlim([0 num])
ylim([0 2])
kk=legend('单次定位误差','50次定位误差均值','location','NorthWest');
set(kk,'Fontsize',8);
title('平均定位误差图');
hold on;
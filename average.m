%用来求不同情况下的平均定位误差对比图
x=[3 8 12]
y=[0.6916,0.6463,0.5641]

 scatter(x,y,'k')  ;
 hold on;
plot(x,y,'black-','LineWidth',2);

xlabel('信标节点数目');
ylabel('平均定位误差（m）');
title('不同信标节点数目平均定位误差图');
ylim([0.4 0.8]);
grid on;
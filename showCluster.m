function [ ] = showCluster( data , radius, colorTable)
% 显示所有数据
% data 全部数据
% radius 画圆的半径
% colorTable 颜色表

clf;
figure(1);
% 还没有聚类的点画小圆点.
cl = data((data(:, 4) == 0), :);
plot(cl(:, 1), cl(:, 2), '.')
hold on

% 簇编号1的点画红色*
for i=1:length(colorTable)
    cl = data((data(:, 4) == i), :);
    plot(cl(:, 1), cl(:, 2), ['*', colorTable(i)])
    hold on;
end

% 噪声点的点画黑色点，并用黑色圆圈标出eps范围
cl = data((data(:, 4) == -1), :);
plot(cl(:, 1), cl(:, 2), 'dk')
for i=1:length(cl(:, 1))
    drawCircle(cl(i, 1), cl(i, 2), radius, 'k');
end
hold on;

% 边界点用红色圆圈标出eps范围
cl = data((data(:, 5) == 2 ), :);
for i=1:length(cl(:, 1))
    % TODO： bug
    drawCircle(cl(i, 1), cl(i, 2), radius, char(colorTable(cl(i, 4))));
end

axis([-6, 6, -6, 6])
grid on;    % 画出网格
pause(0.001);
end


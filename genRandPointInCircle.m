function [ pt ] = genRandPointInCircle( x, y, radius, num, t1)
% 在以x y 为圆心，radius为半径的圆内生成num个随机点 非空间数据全部设置为t1
% 每个数据结构如下：
% pt(x, y, t1, cluster_label, type)
% x, y: position
% t1 : non-spatial data
% cluster_label :聚类标号 0:NAN  -1:noise  1~N 普通的簇编号
% type : 点类型 : 0:NAN  1:core object 2:边界点
rrand = radius * rand(num, 1);
rtheta = 180 * rand(num, 1);
pt = zeros(num, 4);
pt(:, 1) = x + rrand .* sin(rtheta);
pt(:, 2) = y + rrand .* cos(rtheta);
pt(:, 3) = t1;
pt(:, 4) = 0;
pt(:, 5) = 0;
end


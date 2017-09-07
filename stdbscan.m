%% 生成模拟数据，如不需要生成模拟数据请注释本段
clc;clear;
POINT_NUM = 100;     % 模拟数据总点数
NOISE_POINT_NUM = 5; % 模拟噪声点数
pt1 = genRandPointInCircle(0, 0, 1, POINT_NUM/4, 1);
pt2 = genRandPointInCircle(0, 2, 2, POINT_NUM/2, 4);
pt3 = genRandPointInCircle(-4, 0, 1, POINT_NUM/4 - NOISE_POINT_NUM, 3);
pt4 = genRandPointInCircle(0, 0, 6, NOISE_POINT_NUM, 2);
D = [pt1; pt2; pt3; pt4];

%% 输入参数 eps1 eps2 minpts Δε
EPS1 = 1;
EPS2 = 1.2;
MINPTS = 5;
DELTA_E = 1.1;

%% ST-DBSCAN开始
clusterLabelColor = ['r', 'g', 'c', 'b'];
clf;                % 清空所有figure
clusterLabel = 0;   % 初始化簇标号
for i=1:length(D(:, 1))                                             	%(i)
    if D(i, 4) == 0    %该点没有被处理过（不是核心点和噪声）            %(ii)
        X = retrieveNeighbors(D, i, EPS1, EPS2, 0);                 	%(iii)
        if length(X) < MINPTS  %是噪声，不是核心点
            D(i, 4) = -1;                                               %(iv)
%             showCluster(D, EPS1, clusterLabelColor);
        else                                        % construct a new cluster(v)
            clusterLabel = clusterLabel + 1;
            clusterItem = D(i, 3);       % 簇内点的属性值为当前核心点属性值
            D(i ,4) = clusterLabel;     %给核心点标号
            queue = i;        %将核心点加入队列                                         %(vi)
            
            while isempty(queue) == 0
                ptCurrent = queue(1);  % 队列操作 pop
                queue(1) = [];        
                Y = retrieveNeighbors(D, ptCurrent, EPS1, EPS2, clusterLabel);
                
                if length(Y) >= MINPTS   %队列中的当前点也是核心点
                    for j=1:length(Y)                                       %(vii)
                        % |Cluter_Ave() - o.value| < e
                        %判断当前点的邻居是否加入队列（噪声/未处理的点+属性，邻居一定符合空间条件）
                        if ((D(Y(j), 4) == -1) || (D(Y(j), 4) == 0)) && abs(mean(clusterItem) - D(Y(j), 3)) < DELTA_E
                            D(Y(j), 4) = clusterLabel;          % mark o with current cluster label
                            clusterItem = [clusterItem, D(Y(j), 3)];
                            queue = [queue, Y(j)] ;             % 队列操作 push
%                             showCluster(D, EPS1, clusterLabelColor);
                        end
                    end
                else % 队列中的点是边界点，以下几行和论文中有所不同，把不是core object的点作为边界一并加入簇中，但不再继续扩展
                    D(ptCurrent, 4) = clusterLabel;
                    clusterItem = [clusterItem, D(ptCurrent, 3)];
                    %showCluster(D, EPS1, clusterLabelColor);
                end
            end
        end
    end
end

showCluster(D, EPS1, clusterLabelColor);



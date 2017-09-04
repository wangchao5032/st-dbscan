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
EPS1 = 0.8;
EPS2 = 1.2;
MINPTS = 5;
DELTA_E = 1.1;

%% ST-DBSCAN开始
clf;                % 清空所有figure
clusterLabel = 0;   % 初始化簇标号
for i=1:length(D(:, 1))                                             	%(i)
    if D(i, 4) == 0                                                     %(ii)
        X = retrieveNeighbors(D, i, EPS1, EPS2, 0);                 	%(iii)
        if length(X) < MINPTS
            D(i, 4) = -1;                                               %(iv)
            showCluster(D, EPS1);
        else                                        % construct a new cluster(v)
            clusterLabel = clusterLabel + 1;
            clusterItem = [];       % 簇内数据项
            for j=1:length(X)
                D(X(j), 4) = clusterLabel;
                D(X(j), 5) = 1;    % 数据类型设置为core object  
                clusterItem = [clusterItem, D(X(j), 3)];    %为了计算这个簇的数据平均值，所以需要把这个簇中的所有数据都存下来。详见ST-DBSCAN文章3.3
                showCluster(D, EPS1);
            end
            
            queue = X;                                                 %(vi)
            
            while isempty(queue) == 0
                ptCurrent = queue(1);  % 队列操作 pop
                queue(1) = [];        
                Y = retrieveNeighbors(D, ptCurrent, EPS1, EPS2, clusterLabel);
                
                if length(Y) >= MINPTS
                    for j=1:length(Y)                                       %(vii)
                        
                        % is not marked as noise
                        if D(Y(j), 4) == -1
                            isNotNoise = 0;
                        else
                            isNotNoise = 1;
                        end
                        
                        % is in not in a cluster
                        if D(Y(j), 4) == 0
                            isNotInCluster = 1;
                        else
                            isNotInCluster = 0;
                        end
                        
                        % TODO：论文这里似乎有些啰嗦，感觉isNotNoist和isNotInCluster有点冗余
                        % |Cluter_Ave() - o.value| < e
                        if (isNotNoise && isNotInCluster) && abs(mean(clusterItem) - D(Y(j), 3)) < DELTA_E
                            D(Y(j), 4) = clusterLabel;          % mark o with current cluster label
                            D(Y(j), 5) = 1;                     % 数据类型设置为 core object 
                            clusterItem = [clusterItem, D(Y(j), 3)];
                            queue = [queue, Y(j)] ;             % 队列操作 push
                            showCluster(D, EPS1);
                        end

                    end
                else % 以下几行和论文中有所不同，把不是core object的点作为边界一并加入簇中，但不再继续扩展
                    D(ptCurrent, 4) = clusterLabel;
                    D(ptCurrent, 5) = 2;    %数据类型设置为 border 
                    clusterItem = [clusterItem, D(ptCurrent, 3)];
                    showCluster(D, EPS1);
                end
                
            end
            
        end
        
    end
end

showCluster(D, EPS1);



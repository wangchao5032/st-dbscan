function [ neighbors ] = retrieveNeighbors( data, coreIndex, eps1, eps2, clusterLabel)
x = data(coreIndex, 1);
y = data(coreIndex, 2);
t1 = data(coreIndex, 3);

neighbors = [];
for i=1:length(data)
    % TODO: 这里的判决条件是我自己加的，文献中没有详细说，待详细思考
    % 如果周围点还没有标记过或者已经标记为当前簇，才算作有效的点
    if data(i, 4) ==0 || data(i, 4) == clusterLabel
        dis1 = sqrt((data(i, 1) - x)^2 + (data(i, 2) - y)^2);
        dis2 = abs(data(i, 3) - t1);
        if dis1 <= eps1 && dis2 <= eps2
            neighbors = [neighbors, i];
        end
    else
        continue ;
    end
end

end


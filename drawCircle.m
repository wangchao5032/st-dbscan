function [ ] = drawCircle( x, y, r, color)
% 以圆心x y，半径r画圆，边的颜色为color 
    leftBottomPos = [x - r, y - r, 2*r, 2*r];
    rectangle('Position',leftBottomPos,'Curvature',[1 1],'EdgeColor', color)
end


function (delta_x, delta_y, delta_l) = distance_var(p1, p2)
    delta_x = 0.3*(p1(2)-p2(2));
    delta_y = 0.3*(p1(1)-p2(1));
    delta_l = sqrt((delta_x)^2 + (delta_y)^2);
     fprintf('delta_x is %d cm\n', delta_x)
     fprintf('delta_y is %d cm\n', delta_y)
     fprintf('delta_l is %d cm\n', delta_l)
end
function z = delta_capacity_basic(x, y)

if (x ~= 0) && (y ~= 0)
    z = -(x + y) * log2((x + y)/2) + x * log2(x) + y * log2(y);
else
    if (x == 0) && (y ~= 0)
        z = y;
    else
        if (y == 0) && (x ~= 0)
            z = x;
        else
            z = 0;
        end
    end
end

end
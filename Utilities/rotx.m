function R = rotx(theta)

    if isnumeric(theta)
        tolerance = 1e-10;
    
        if abs(mod(theta, pi) - pi/2) < tolerance
            cos_theta = 0;
        else
            cos_theta = cos(theta);
        end
        
        if abs(mod(theta, pi) - pi/2) < tolerance
            sin_theta = 1;
        elseif abs(mod(theta, pi) - 3*pi/2) < tolerance
            sin_theta = -1;
        else
            sin_theta = sin(theta);
        end
            R = [1 0 0; 0 cos_theta -sin_theta; 0 sin_theta cos_theta];
    else
        R = [1 0 0; 0 cos(theta) -sin(theta); 0 sin(theta) cos(theta)];
    end
end
function [t, y] = extract_sim_signal(out, fieldName)

t = out.tout;
t = t(:);

sig = out.(fieldName);

if isa(sig,'timeseries')
    y = sig.Data;
else
    y = sig;
end

y = squeeze(y);

if size(y,1) ~= length(t) && size(y,2) == length(t)
    y = y.';
end

y = y(:);

if length(y) ~= length(t)
    error('Signal %s has length %d but tout has length %d.', ...
        fieldName, length(y), length(t));
end

end
function [t,v] = extract_v_from_out(out)

t = out.tout;
t = t(:);
Nt = length(t);

v_data = out.v;

if isa(v_data,'timeseries')
    v_data = v_data.Data;
end

if ndims(v_data) == 3 && size(v_data,1) == 6 && size(v_data,2) == 1
    v = squeeze(v_data).';
else
    v_s = squeeze(v_data);

    if size(v_s,1) == 6 && size(v_s,2) == Nt
        v = v_s.';
    elseif size(v_s,1) == Nt && size(v_s,2) == 6
        v = v_s;
    else
        error('Could not interpret out.v dimensions.');
    end
end

end
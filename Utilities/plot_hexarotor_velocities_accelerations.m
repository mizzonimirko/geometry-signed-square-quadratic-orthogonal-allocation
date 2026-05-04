function plot_hexarotor_velocities_accelerations(out, bA, fontSize,param)
% plot_hexarotor_v(out, bA, fontSize)
% Plots sign-normalized actuator velocities:
%   v_tilde_i = sign(bA_i) v_i
%
% Inputs:
%   out      : Simulink output structure
%   bA       : 6x1 null-space vector
%   fontSize : optional

if nargin < 3
    fontSize = 40;
end

figFolder = 'Figures';

if ~exist(figFolder,'dir')
    mkdir(figFolder);
end


%% Extract time
t = out.tout;
t = t(:);
Nt = length(t);

%% Extract v
v_data = out.v;

if isa(v_data,'timeseries')
    v_data = v_data.Data;
end

%% Convert to N x 6
if ndims(v_data) == 3 && size(v_data,1) == 6 && size(v_data,2) == 1

    v = squeeze(v_data);

    if size(v,1) == 6
        v = v.';
    end

else

    v_s = squeeze(v_data);

    if size(v_s,1) == 6 && size(v_s,2) == Nt
        v = v_s.';
    elseif size(v_s,1) == Nt && size(v_s,2) == 6
        v = v_s;
    else
        error('Could not interpret out.v dimensions. Expected 6 x 1 x N.');
    end
end

%% Final consistency
if size(v,1) ~= Nt || size(v,2) ~= 6
    error('Dimension mismatch: t is %d x 1, but v is %d x %d.', ...
          Nt, size(v,1), size(v,2));
end

%% Normalize using bA sign
bA = bA(:);

if length(bA) ~= 6
    error('bA must be a 6x1 vector.');
end

s = sign(bA).';      % 1 x 6
v = v .* s;          % N x 6

%% Numerical derivative
vdot = zeros(size(v));

for i = 1:6
    vdot(:,i) = gradient(v(:,i), t);
end

%% Remove initial derivative artifact
tCut = 1.0;   % seconds to remove from derivative plot

idxKeep = t >= t(1) + tCut;

t_dot = t(idxKeep);
vdot_plot = vdot(idxKeep,:);

%% Colors
cols = lines(6);

%% Figure 1: velocities
fig1=figure('Color','w','Position',[80 80 1500 1200]);

ax1 = axes;
hold(ax1,'on');
grid(ax1,'on');
box(ax1,'on');

set(ax1, ...
    'FontName','Helvetica', ...
    'FontSize',fontSize, ...
    'LineWidth',1.2, ...
    'TickLabelInterpreter','latex');

for i = 1:6
    plot(ax1, t, v(:,i), '-', ...
        'Color', cols(i,:), ...
        'LineWidth', 2.5);
end

xlabel(ax1,'$t$','Interpreter','latex','FontSize',fontSize);
ylabel(ax1,'$ v_i$','Interpreter','latex','FontSize',fontSize+5);

xlim(ax1,[t(1) t(end)]);
ax1.XAxis.Exponent = 0;

legend(ax1, ...
    {'$v_1$','$v_2$','$v_3$','$v_4$','$v_5$','$v_6$'}, ...
    'Interpreter','latex', ...
    'FontSize',round(fontSize), ...
    'Location','southoutside', ...
    'Orientation','horizontal', ...
    'Box','on');

drawnow;

set(fig1,'Renderer','painters');
set(fig1,'PaperPositionMode','auto');
set(fig1,'InvertHardcopy','off');

drawnow;



filename = fullfile(figFolder, ...
    sprintf('Fig1_L%d-C%.3f-velocities.pdf', param.layer_id, param.Cbar)); 
print(fig1, filename, '-dpdf', '-painters', '-bestfit');



%% Figure 2: derivatives
fig2=figure('Color','w','Position',[120 120 1500 1200]);

ax2 = axes;
hold(ax2,'on');
grid(ax2,'on');
box(ax2,'on');

set(ax2, ...
    'FontName','Helvetica', ...
    'FontSize',fontSize, ...
    'LineWidth',1.2, ...
    'TickLabelInterpreter','latex');

for i = 1:6
    plot(ax2, t_dot, vdot_plot(:,i), '-', ...
        'Color', cols(i,:), ...
        'LineWidth', 2.5);
end

xlabel(ax2,'$t$','Interpreter','latex','FontSize',fontSize);
ylabel(ax2,'$\dot{v}_i$','Interpreter','latex','FontSize',fontSize+5);

xlim(ax2,[t_dot(1) t_dot(end)]);
ax2.XAxis.Exponent = 0;

legend(ax2, ...
    {'$\dot{v}_1$','$\dot{v}_2$','$\dot{v}_3$', ...
     '$\dot{v}_4$','$\dot{v}_5$','$\dot{v}_6$'}, ...
    'Interpreter','latex', ...
    'FontSize',(fontSize), ...
    'Location','southoutside', ...
    'Orientation','horizontal', ...
    'Box','on');
drawnow;

set(fig2,'Renderer','painters');
set(fig2,'PaperPositionMode','auto');
set(fig2,'InvertHardcopy','off');

drawnow;





filename = fullfile(figFolder, ...
    sprintf('Fig2_L%d-C%.3f-accelerations.pdf', param.layer_id, param.Cbar));
print(fig2, filename, '-dpdf', '-painters', '-bestfit');
disp('Figure correctly saved in the Figure folder.')
%exportgraphics(fig2, filename,  'ContentType','image', 'Resolution',600, 'BackgroundColor','none');



end
function plot_position_tracking_with_eR(out, fontSize, param)
% plot_position_tracking_with_eR(out, fontSize, param)
% One figure with:
%   p_des,x p_des,y p_des,z
%   p_x     p_y     p_z
%   ||e_R||
%
% Expected:
%   out.p      : 3 x 1 x N, or 3 x N, or N x 3
%   out.p_des  : 3 x 1 x N, or 3 x N, or N x 3
%   out.eRNorm : N x 1, 1 x N, timeseries, or 1 x 1 x N
%   out.tout   : N x 1

if nargin < 2
    fontSize = 40;
end

if nargin < 3
    param.layer_id = 0;
    param.Cbar = 0;
end


figFolder = 'Figures';

if ~exist(figFolder,'dir')
    mkdir(figFolder);
end

%% Time
t = out.tout;
t = t(:);
Nt = length(t);

%% Extract signals
p     = extract_3d_signal(out.p, Nt);
p_des = extract_3d_signal(out.p_des, Nt);
eR    = extract_scalar_signal(out.eRNorm, Nt);

%% Colors
cols_p = lines(3);
col_eR = [0 0 0];

%% Figure
fig1 = figure('Color','w','Position',[100 100 1500 600]);

ax1 = axes;
hold(ax1,'on');
grid(ax1,'on');
box(ax1,'on');

set(ax1, ...
    'FontName','Helvetica', ...
    'FontSize',fontSize-8, ...
    'LineWidth',1.2, ...
    'TickLabelInterpreter','latex');

%% Position tracking: desired dashed, actual solid
plot(ax1,t,p_des(:,1),'--','Color',cols_p(1,:),'LineWidth',2.3);
plot(ax1,t,p_des(:,2),'--','Color',cols_p(2,:),'LineWidth',2.3);
plot(ax1,t,p_des(:,3),'--','Color',cols_p(3,:),'LineWidth',2.3);

plot(ax1,t,p(:,1),'-','Color',cols_p(1,:),'LineWidth',2.1);
plot(ax1,t,p(:,2),'-','Color',cols_p(2,:),'LineWidth',2.1);
plot(ax1,t,p(:,3),'-','Color',cols_p(3,:),'LineWidth',2.1);

%% e_R norm on the same plot
plot(ax1,t,eR,'-','Color',col_eR,'LineWidth',2.0);

xlabel(ax1,'$t$','Interpreter','latex','FontSize',fontSize-6);
ylabel(ax1,'${p},p_d,\|{e}_R\|$','Interpreter','latex','FontSize',fontSize-3);

xlim(ax1,[t(1) t(end)]);
ax1.XAxis.Exponent = 0;

legend(ax1, ...
    {'$p_{d,x}$','$p_{d,y}$','$p_{d,z}$', ...
     '$p_x$','$p_y$','$p_z$', ...
     '$\|{e}_R\|$'}, ...
    'Interpreter','latex', ...
    'FontSize',fontSize-15, ...
    'Location','northoutside', ...
    'Orientation','horizontal', ...
    'Box','on');

drawnow;

set(fig1,'Renderer','painters');
set(fig1,'PaperPositionMode','auto');
set(fig1,'InvertHardcopy','off');

drawnow;

filename = fullfile(figFolder, sprintf('Fig3_position_eR.pdf'));


print(fig1, filename, '-dpdf', '-painters', '-bestfit');
disp('Figure correctly saved in the Figure folder.')

end

%% ========================================================================
% Helper: extract 3D vector signal as N x 3
%% ========================================================================
function y = extract_3d_signal(sig, Nt)

if isa(sig,'timeseries')
    sig = sig.Data;
end

sig = squeeze(sig);

if size(sig,1) == 3 && size(sig,2) == Nt
    y = sig.';
elseif size(sig,1) == Nt && size(sig,2) == 3
    y = sig;
else
    error('Could not interpret signal dimensions. Expected 3 x 1 x N, 3 x N, or N x 3.');
end

end

%% ========================================================================
% Helper: extract scalar signal as N x 1
%% ========================================================================
function y = extract_scalar_signal(sig, Nt)

if isa(sig,'timeseries')
    sig = sig.Data;
end

sig = squeeze(sig);

if isvector(sig)
    y = sig(:);
else
    if size(sig,1) == 1 && size(sig,2) == 1 && size(sig,3) == Nt
        y = squeeze(sig);
        y = y(:);
    else
        error('Could not interpret scalar signal dimensions.');
    end
end

if length(y) ~= Nt
    error('Scalar signal length is %d, but tout length is %d.', length(y), Nt);
end

end
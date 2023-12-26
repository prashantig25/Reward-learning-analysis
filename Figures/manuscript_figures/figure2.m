%% INITIALISE VARIABLES

clc
clearvars
colors_manuscript; % colors for plot
linewidth_arrow = 0.5; % arrow width
headlength_arrow = 5; % arrow headlength
fontsize_trial = 7.5; % font size
font_name = 'Arial'; % font name
horz_align = 'center'; % alignment
vert_align = 'middle';
bg_color = 'none'; % background color for text boxes
face_alpha = 0; % face alpha
edge_color = 'none'; % edge color for text boxes
trialtext_width = 0.07; 
trialtext_height = 0.1;
screen_width = 3; % screen dimensions for trial
screen_height = 2;
linewidth_screens = 0.7; % line width for screens
fontsize_title = 9; % font size for plot titles
linewidth_axes = 0.5; % line width for axes
font_size = 6;

% load all required data
load("ecoperf_mix.mat","ecoperf_mix") % economic performance
load("ecoperf_perc.mat","ecoperf_perc")
load("ecoperf_rew.mat","ecoperf_rew")
load("mean_curves.mat","mean_curves") % learning
load("sem_curves.mat","sem_curves")
%% INITIALISE TILE LAYOUT

figure
set(gcf,'Position',[100 100 600 400])
t = tiledlayout(3,4);
t.TileSpacing = 'compact';
t.Padding = 'compact';
ax3 = nexttile(3,[2 2]);
ax5 = nexttile(9,[1 2]);
ax12 = nexttile(12,[1,1]);
ax11 = nexttile(11,[1,1]);
ax1 = nexttile(1,[2,2]);

%% PLOT TRIAL PROCEDURE

% axes position adjustments
position_change = [0, 0, -0.05, 0]; 
new_pos = change_position(ax1,position_change);
ax1_new = axes('Units', 'Normalized', 'Position', new_pos);
box(ax1_new, 'on');
delete(ax1);

start_x = 0.7; % start-x for screens
start_y = 8;
adjust_x = 2.3; % adjustments for screens
adjust_y = -1.8;
num_screens = 4; % number of screens

% PLOT SCREENS
for n = 1:num_screens
    rectangle('Position',[start_x start_y screen_width screen_height],'LineWidth',linewidth_screens, ...
        'FaceColor',color_screen)
    start_x = start_x + adjust_x;
    start_y = start_y + adjust_y;
    axis([0 11 0 11]);
end

% PLOT SLIDER
line([7.8,10.5],[3,3],'color','k','LineWidth',2)
center_X = 9.5;  % X-coordinate of the center
center_Y = 3.0;  % Y-coordinate of the center
radius = 0.17;   % Radius of the circle
rectangle('Position', [center_X - radius, center_Y - radius, 2 * radius, 2 * radius], ...
    'Curvature', [1, 1], 'EdgeColor', 'k', 'FaceColor', 'w', 'LineWidth', 1);

% PLOT FIXATION CROSS
fix_width = 0.08;
fix_height = 0.2;
fix_xpos = [2,4.3,8.9];
fix_ypos = [9.2,7.45,3.8];
num_fix = 3;
for n = 1:num_fix
    fix1 = annotation("textbox",'String','+','FontSize',10,'LineStyle','none');
    fix1.Parent = ax1_new;
    fix1.Position = [fix_xpos(n) fix_ypos(n) fix_width fix_height];
end

% PLOT ARROW 
ar1 = annotation('arrow','LineWidth',linewidth_arrow,'HeadLength',headlength_arrow);
ar1.Parent = ax1_new;
ar1.X = [1 6];
ar1.Y = [5,1];

% ADD TEXTBOXES
all_strings = {'Fixation (0.5)','Choice (1 s)',...
    'Reward feedback (1 s)','Reported contingency parameter (7 s)'};
num_strings = 4;
text_xpos = [0.7,3,5.3,7.6];
text_ypos = [7.8,5.95,4.2,2.4];
horzalign_trial = 'Left';
vertalign_trial = 'Top';
for n = 1:num_strings
    string = all_strings{n};
    position = [text_xpos(n) text_ypos(n) trialtext_width trialtext_height];
    annotate_textbox(ax1_new,position,string,font_name,5.5, ...
        horzalign_trial,vertalign_trial,bg_color,face_alpha,edge_color);
end

fb1 = annotation("textbox",'LineWidth',1.5,'String', ...
    'You win 1 point!','FontSize',fontsize_trial,'LineStyle','none', ...
    'Color',fb_green,'FontName','Arial','FontWeight','bold', ...
    'HorizontalAlignment','center');
fb1.Parent = ax1_new;
fb1.Position = [6.8 6.2 .07 .1];
set(gca, 'Color', 'None')
box off
axis off
%% PLOT S-A-R CONTINGENCY

pos = ax3.Position;
ax3_new = axes('Units', 'Normalized', 'Position', pos);
box(ax3_new, 'on');
delete(ax3);

axis([0 1 0 1])
title('Task contingency','FontWeight','normal',FontName=font_name,Position=[0.5,0.95], ...
    Parent=ax3_new,FontSize=fontsize_title)
line([0 1], [0.89 0.89],'Color','k','LineWidth',linewidth_axes);

% ADD TEXTBOXES
all_strings = {'State 0','State 1'};
num_strings = 2;
text_xpos = [0.2, 0.65];
text_ypos = [0.86, 0.86];
statebox_width = 0.1;
for n = 1:num_strings
    string = all_strings(n);
    position = [text_xpos(n) text_ypos(n) statebox_width statebox_width];
    annotate_textbox(ax3_new,position,string,font_name,fontsize_trial, ...
        horz_align,vert_align,bg_color,face_alpha,edge_color);
end

all_strings = {'Right stronger','Left stronger'};
text_xpos = text_xpos - 0.05;
text_ypos = text_ypos - 0.06;
for n = 1:num_strings
    string = all_strings(n);
    position = [text_xpos(n) text_ypos(n) 0.25 0.08];
    annotate_textbox(ax3_new,position,string,font_name,fontsize_trial, ...
        horz_align,vert_align,bg_color,face_alpha,edge_color);
end

% ADD ROTATED TEXT BOXES
xpos = 0.01;
ypos = [0.55,0.3,0.8];
allstrings = {{'Economic', 'decision'},{'Contigency' 'parameter'},{'', 'Stimulus'}};
num_strings = 3;
for n = 1:num_strings
    txt = text(xpos,ypos(n),allstrings{1,n});
    txt.FontSize = fontsize_trial;
    txt.FontWeight = 'normal';
    txt.Rotation = 90;
    txt.LineStyle = 'none';
    txt.FontName = font_name;
    txt.HorizontalAlignment = horz_align;
end

t1 = annotation("textbox",[0.15,0.5,0.25,0.08],'LineWidth',0.5,'String', ...
    'Left   Right','FontSize',7,'LineStyle','-','Color','k','FontName','Arial', ...
    'HorizontalAlignment','center',Parent=gca,VerticalAlignment='middle');


t2 = annotation("textbox",[0.6 0.5,0.25,0.08],'LineWidth',0.5,'String', ...
    'Left   Right','FontSize',7,'LineStyle','-','Color','k','FontName','Arial', ...
    'HorizontalAlignment','center',Parent=gca,VerticalAlignment='middle');

annotation("textbox",[0.22,0.36,0.1,0.047],'LineWidth',1.5,'String', ...
    'μ = 0.9','FontSize',6,'LineStyle','none','Color','k','FontName','Arial', ...
    'HorizontalAlignment','center','EdgeColor','k','BackgroundColor',[238, 238, 238]/256, ...
    'VerticalAlignment','middle','FaceAlpha',0.7,Parent=gca)

annotation("textbox",[0.67,0.36,0.1,0.047],'LineWidth',1.5,'String', ...
    'μ = 0.9','FontSize',6,'LineStyle','none','Color','k','FontName','Arial', ...
    'HorizontalAlignment','center','EdgeColor','k','BackgroundColor',[238, 238, 238]/256, ...
    'VerticalAlignment','middle','FaceAlpha',0.7,Parent=gca)

annotation("textbox",[0.15,0.27,0.25,0.08],'LineWidth',0.5,'String', ...
    '0.9     0.1','FontSize',7,'LineStyle','-','Color','k','FontName','Arial', ...
    'HorizontalAlignment','center',Parent=gca)

annotation("textbox",[0.6,0.27,0.25,0.08],'LineWidth',0.5,'String', ...
    '0.1     0.9','FontSize',7,'LineStyle','-','Color','k','FontName','Arial', ...
    'HorizontalAlignment','center',Parent=gca)

annotation("textbox",[0.15,0.73,0.25,0.08],'LineWidth',0.5,'String', ...
    '','FontSize',7,'LineStyle','-','Color','k','FontName','Arial', ...
    'HorizontalAlignment','center',Parent=gca)

annotation("textbox",[0.6,0.73,0.25,0.08],'LineWidth',0.5,'String', ...
    '','FontSize',7,'LineStyle','-','Color','k','FontName','Arial', ...
    'HorizontalAlignment','center',Parent=gca)

a1 = annotation('arrow',[0.5 0.5],[0.6 0.4],'LineWidth',0.7,'Color',[128,128,128]./255,'LineStyle','-','HeadLength',headlength_arrow);
a1.Parent = gca;
set(gca, 'Color', 'None','FontName','Arial')
box off
axis off
%% PLOT CONDITIONS

pos = ax5.Position;
ax5_new = axes('Units', 'Normalized', 'Position', pos);
box(ax5_new, 'on');
delete(ax5);

title('Uncertainty','FontWeight','normal',FontName=font_name,Parent=gca,FontSize=fontsize_title)
axis([0 1 0 1])
set(ax5_new,'Color','none')
axis off

% CREATE BOX
yline(0.75)
xline(0.33)
xline(0.66)

% ADD TEXT BOXES
all_strings = {'Both','Perceptual','Reward','0.7         0.3','0.9         0.1',...
    '0.7         0.3'}; % string for each text box
num_strings = 6; % number of strings
text_xpos = [0.07, 0.395, 0.73, 0.71, 0.38, 0.05]; % x-position
text_ypos = [0.8, 0.8, 0.8, 0.15, 0.15, 0.15]; % y-posisiton
box_width = 0.2; % text box width
box_height = 0.15; % text box height
for n = 1:num_strings
    string = all_strings(n);
    position = [text_xpos(n) text_ypos(n) box_width box_height];
    annotate_textbox(ax5_new,position,string,font_name,fontsize_trial, ...
        horz_align,vert_align,bg_color,face_alpha,edge_color);
end
%% DESCRIPTIVE PLOTS
 
position_change = [0, 0.03, 0, 0];
new_pos = change_position(ax12,position_change);
ax12_new = axes('Units', 'Normalized', 'Position', new_pos);
box(ax12_new, 'on');
delete(ax12);

% PLOT SLIDER DATA
colors_name = [mix;perc;rew]; % colors for plot lines
legend_names = {'Both','Perceptual','Reward'}; % legend names
title_name = {'Learning curve'}; % figure title
xlabelname = {'Trial'}; % x-axis label name
ylabelname = {''}; % y-axis label name
x = 1:25; % x-axis
hold on
lg_curves(x,mean_curves./100,sem_curves./100,colors_name,legend_names,title_name,xlabelname,ylabelname)
xlim([1,25])
set(gca,'color','none','FontName',font_name,'FontSize',font_size,'LineWidth',linewidth_axes)

new_pos = change_position(ax11,position_change);
ax11_new = axes('Units', 'Normalized', 'Position', new_pos);
box(ax11_new, 'on');
delete(ax11);

% MEAN ECONOMIC PERFORMANCE ACROSS SUBJECTS
y = [ecoperf_mix;ecoperf_perc;ecoperf_rew;];
num_subjs = length(ecoperf_mix);
mix_avg = nanmean(ecoperf_mix,1);
perc_avg = nanmean(ecoperf_perc,1);
rew_avg = nanmean(ecoperf_rew,1);
mean_avg = [mix_avg; perc_avg;rew_avg;];

% SEM ACROSS SUBJECTS
mix_sd = nanstd(ecoperf_mix,1)/sqrt(num_subjs);
perc_sd = nanstd(ecoperf_perc,1)/sqrt(num_subjs);
rew_sd = nanstd(ecoperf_rew,1)/sqrt(num_subjs);
mean_sd = [mix_sd; perc_sd;rew_sd;];
xticks = [1:length(mean_sd)];

% FIGURE PROPERTIES
xticklabs = {'Both','Perceptual','Reward'};% x-axis tick labels
title_name = {'Economic performance'}; % figure title
legend_names = {''}; % legend names
xlabelname = {''}; % x-axis label name
ylabelname = {''};%{'Mean economic'; 'performance'}; % y-axis label name
colors_name = dim_gray; % bar colors

y = mean(y,2);
mean_avg = mean(mean_avg,2);
mean_sd = mean(mean_sd,2);
% PLOT CHOICE DATA
bar_plots(y,mean_avg,mean_sd,num_subjs,length(mean_avg),length(legend_names), ...
    legend_names,xticks,xticklabs,title_name,xlabelname,ylabelname,colors_name) 
set(gca,'color','none','FontName','Arial','FontSize',6,'YLim',[0.5,1],'LineWidth',0.5)

%% ADD EXTERNAL PNGs

patch_dim = 0.035;
pos_y = 0.8125; pos_x = [0.65,0.61,0.84,0.8];
image_png = {'lowcon_patch.png','highcon_patch.png','highcon_patch.png','lowcon_patch.png'};
num_pngs = 4;
for n = 1:num_pngs
    axes('pos',[pos_x(n) pos_y patch_dim patch_dim]);
    imshow(image_png{n});
    hold on
end

patch_dim = 0.05;
pos_y = 0.19; pos_x = 0.07;
image_png = {'lowcon_patch.png','lowcon_patch.png','lowcon_patch.png','lowcon_patch.png','highcon_patch.png','lowcon_patch.png',};
num_pngs = 6;
adjust_x = 0.07;
for n = 1:num_pngs
    axes('pos',[pos_x pos_y patch_dim patch_dim]);
    imshow(image_png{n});
    hold on
    pos_x = pos_x + adjust_x;
end

patch_dim = 0.04;
pos_y = 0.74; pos_x = 0.17;
image_png = {'lowcon_patch.png','highcon_patch.png'};
num_pngs = 2;
adjust_x = 0.05;
for n = 1:num_pngs
    axes('pos',[pos_x pos_y patch_dim patch_dim]);
    imshow('lowcon_patch.png');
    hold on
    pos_x = pos_x + adjust_x;
end
%% SAVE AS PNG

fig = gcf; % use `fig = gcf` ("Get Current Figure") if want to print the currently displayed figure
fig.PaperPositionMode = 'auto'; % To make Matlab respect the size of the plot on screen
print(fig, 'fig2_13.png', '-dpng', '-r600') 
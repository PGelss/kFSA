% Application of kFSA to the Fermi-Pasta-Ulam-Tsingou model
%
% For more details on this example, see 
%
%   P. Gelß, S. Klus, I. Schuster, C. Schütte,
%   "Feature space approximation for kernel-based
%   supervised learning", arXiv, 2020.
%
% Contact: p.gelss@fu-berlin.de


function FPU_plot

% load results
data_full = load('../results/FPU_results_full.mat');
data_kFSA = load('../results/FPU_results_kFSA.mat');

% plot number of extracted samples
figure;

h = findobj(gca,'Type','line');
hold on;
box on
for i=4:2:18
  plot([i,i],[0,2000], 'color', [0.8, 0.8, 0.8], 'Linewidth', 1.25)
end
for i=500:500:1500
  plot([2,20],[i,i], 'color', [0.8, 0.8, 0.8], 'Linewidth', 1.25)
end
colorOrder = get(gca, 'ColorOrder');
lw = 2;   
fs = 20;  
set(gca,'ColorOrderIndex',1)
plot(2:20, data_kFSA.number_of_samples_kFSA, ':o', 'Linewidth', lw, 'MarkerFaceColor', colorOrder(1,:))
xlabel('$$d$$', 'Interpreter', 'LaTeX')
ylabel('$$|\tilde{X}|$$', 'Interpreter', 'LaTeX')
xticks(2:2:20)
xlim([2, 20])
set(h,'LineWidth',lw);
set(findobj(gca,'Type','text'),'FontSize',fs)
set(gca,'FontSize',fs);
set(gca,'LineWidth',lw); 
set(get(gca,'xlabel'),'Fontsize',25); 
set(get(gca,'ylabel'),'Fontsize',25);   
set(gca, 'Layer', 'Top')
set(0,'DefaultTextFontname', 'CMU Serif')
print(gcf, 'FPU_1','-dpng', '-r300')

% plot approximation errors
figure;

h = findobj(gca,'Type','line');
lw = 2;   
fs = 20;   
hold on;
box on
for i=4:2:18
  plot([i,i],[10^-11, 10^-5], 'color', [0.8, 0.8, 0.8], 'Linewidth', 1.25, 'HandleVisibility','off')
end
for i=10.^[-11:-5]
  plot([2,20],[i,i], 'color', [0.8, 0.8, 0.8], 'Linewidth', 1.25, 'HandleVisibility','off')
end
colorOrder = get(gca, 'ColorOrder');
y1 = prctile(data_full.errors_full,[5],1);
y2 = prctile(data_full.errors_full,[95],1);
patch([2:20 20:-1:2], [y1 fliplr(y2)],colorOrder(1,:),'EdgeColor','none','FaceAlpha',0.3,'HandleVisibility','off')
set(gca,'ColorOrderIndex',1)
plot(2:20,median(data_full.errors_full,1), 'Linewidth', lw)
y1 = prctile(data_kFSA.errors_kFSA,[5],1);
y2 = prctile(data_kFSA.errors_kFSA,[95],1);
patch([2:20 20:-1:2], [y1 fliplr(y2)],colorOrder(2,:),'EdgeColor','none','FaceAlpha',0.3,'HandleVisibility','off')
set(gca,'ColorOrderIndex',2)
plot(2:20,median(data_kFSA.errors_kFSA,1), 'Linewidth', lw)
set(gca, 'YScale', 'log')
xlabel('$$d$$', 'Interpreter', 'LaTeX')
ylabel('$$|| \Theta^\prime - \Theta_{\mathsf{exact}} ||_F / || \Theta_{\mathsf{exact}} ||_F  $$', 'Interpreter', 'LaTeX')
legend({'full set','kFSA with $$\varepsilon=10^{-10}$$'}, 'Interpreter', 'LaTeX', 'Location', 'north west');
xticks(2:2:20)
xlim([2, 20])
ylim([10^-11, 10^-5])
set(h,'LineWidth',lw);
set(findobj(gca,'Type','text'),'FontSize',fs)
set(gca,'FontSize',fs);
set(gca,'LineWidth',lw); 
set(get(gca,'xlabel'),'Fontsize',25); 
set(get(gca,'ylabel'),'Fontsize',25);   
set(gca, 'Layer', 'Top')
set(0,'DefaultTextFontname', 'CMU Serif')
print(gcf, 'FPU_2','-dpng', '-r300')


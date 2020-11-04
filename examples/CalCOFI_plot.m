% Application of kFSA to the CalCOFI data set, see
%
%   California Cooperative Oceanic Fisheries Investigations
%   CalCOFI hydrographic database, 2020
%   https://calcofi.org
%
% For more details on this example, see 
%
%   P. Gelß, S. Klus, I. Schuster, C. Schütte,
%   "Feature space approximation for kernel-based
%   supervised learning", arXiv, 2020.
%
% Contact: p.gelss@fu-berlin.de


function CalCOFI_plot  

% load results
results = load('../results/CalCOFI_results.mat');

% plot mean squared errors 
figure
h = findobj(gca,'Type','line');
hold on;
box on
for i=50:50:250
  plot([i,i],[0.01, 0.035], 'color', [0.8, 0.8, 0.8], 'Linewidth', 1.25,'HandleVisibility','off')
end
for i=0.015:0.005:0.03
  plot([10, 300],[i,i], 'color', [0.8, 0.8, 0.8], 'Linewidth', 1.25,'HandleVisibility','off')
end
lw = 2;   
fs = 20;  
set(gca,'ColorOrderIndex',1)
plot(results.kappas, results.errors_kFSA, 'Linewidth', lw);
plot(results.kappas, results.errors_Nys([1,2],:), 'Linewidth', lw)
xlabel('$$\kappa$$', 'Interpreter', 'LaTeX')
ylabel('mean squared error', 'Interpreter', 'LaTeX')
xlim([results.kappas(1), results.kappas(end)])
legend({'kFSA with $$\varepsilon=10^{-10}$$','kFSA with $$\varepsilon=10^{-6}$$', 'kFSA with $$\varepsilon=10^{-2}$$', 'Nystr{\"o}m $$\left(\varepsilon = 10^{-10}\right)$$', 'Nystr{\"o}m $$\left(\varepsilon = 10^{-6}\right)$$'}, 'Location', 'northeast', 'Interpreter', 'LaTeX')
set(h,'LineWidth',lw);
set(findobj(gca,'Type','text'),'FontSize',fs)
set(gca,'FontSize',fs);
set(gca,'LineWidth',lw); 
set(get(gca,'xlabel'),'Fontsize',25); 
set(get(gca,'ylabel'),'Fontsize',25);   
set(gca, 'Layer', 'Top')
set(0,'DefaultTextFontname', 'CMU Serif')
print(gcf, 'CalCOFI_1','-dpng', '-r300')

% plot number of samples
figure
h = findobj(gca,'Type','line');
hold on;
box on
for i=50:50:250
  plot([i,i],[0, 7000], 'color', [0.8, 0.8, 0.8], 'Linewidth', 1.25,'HandleVisibility','off')
end
for i=1000:1000:6000
  plot([10, 300],[i,i], 'color', [0.8, 0.8, 0.8], 'Linewidth', 1.25,'HandleVisibility','off')
end
lw = 2;   
fs = 20; 
set(gca,'ColorOrderIndex',1)
plot(results.kappas, results.number_of_samples, 'Linewidth', lw);
xlabel('$$\kappa$$', 'Interpreter', 'LaTeX')
ylabel('number of samples', 'Interpreter', 'LaTeX')
xlim([results.kappas(1), results.kappas(end)])
legend({'$$\varepsilon=10^{-10}$$','$$\varepsilon=10^{-6}$$', '$$\varepsilon=10^{-2}$$'}, 'Location', 'northwest', 'Interpreter', 'LaTeX')
set(h,'LineWidth',lw);
set(findobj(gca,'Type','text'),'FontSize',fs)
set(gca,'FontSize',fs);
set(gca,'LineWidth',lw); 
set(get(gca,'xlabel'),'Fontsize',25); 
set(get(gca,'ylabel'),'Fontsize',25);   
set(gca, 'Layer', 'Top')
set(0,'DefaultTextFontname', 'CMU Serif')
print(gcf, 'CalCOFI_2','-dpng', '-r300')

% load CalCOFI data (not included in repository)
data = load('/srv/public/data/CalCOFI/data.mat');
y_train = data.y_train;
y_test = data.y_test;

% plot histogram
figure
h = findobj(gca,'Type','line');
hold on;
box on
for i=1:6
  plot([i,i],[0, 1500], 'color', [0.8, 0.8, 0.8], 'Linewidth', 1.25,'HandleVisibility','off')
end
for i=500:500:1000
  plot([0, 7],[i,i], 'color', [0.8, 0.8, 0.8], 'Linewidth', 1.25,'HandleVisibility','off')
end
lw = 2;   
fs = 20;  
set(gca,'ColorOrderIndex',1)
histogram([y_train, y_test], 100, 'FaceAlpha', 1, 'FaceColor', [0, 0.4470, 0.7410]);
xlabel('dissolved oxygen in \emph{ml/L}', 'Interpreter', 'LaTeX')
y=ylabel('number of samples', 'Interpreter', 'LaTeX');
set(y, 'Units', 'Normalized', 'Position', [-0.066, 0.5, 0]);
xlim([0, 7])
set(h,'LineWidth',lw);
set(findobj(gca,'Type','text'),'FontSize',fs)
set(gca,'FontSize',fs);
set(gca,'LineWidth',lw); 
set(get(gca,'xlabel'),'Fontsize',25); 
set(get(gca,'ylabel'),'Fontsize',25);   
set(gca, 'Layer', 'Top')
set(0,'DefaultTextFontname', 'CMU Serif')
a=get(gcf,'Position');
set(gcf,'Position',[a(1),a(2),2.35*a(3),0.75*a(4)])
print(gcf, 'CalCOFI_3','-dpng', '-r300')


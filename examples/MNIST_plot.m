% Application of kFSA to the MNIST data set
%
% For more details on this example, see 
%
%   P. Gelß, S. Klus, I. Schuster, C. Schütte,
%   "Feature space approximation for kernel-based
%   supervised learning", arXiv, 2020.
%
% Contact: p.gelss@fu-berlin.de

function MNIST_plot

% plot bar graph

epsilon = [0, 0.01, 0.1, 0.25, 0.5];
kappa = 0.5;
numbers = zeros(1, 10);
results = load('../results/MNIST_results.mat');
for i=1:length(epsilon)
    eps = epsilon(i);
    ind = find((abs(results.kappa-0.5)<10^-8 & abs(results.epsilon-eps)<10^-8));
    numbers(i,:) = results.number_of_samples(ind,:);
end
figure
h = findobj(gca,'Type','line');
hold on;
box on;
for i=1000:1000:7000
  plot([-1,10],[i,i], 'color', [0.8, 0.8, 0.8], 'Linewidth', 1.25,'HandleVisibility','off')
end
lw = 2;   
fs = 20;  
set(gca,'ColorOrderIndex',1)
bar(0:9,numbers')
xticks(0:9)
xlabel('digit', 'Interpreter', 'LaTeX')
ylabel('number of samples', 'Interpreter', 'LaTeX')
xlim([-1, 10])
ylim([0,7999])
set(h,'LineWidth',lw);
set(findobj(gca,'Type','text'),'FontSize',fs)
set(gca,'FontSize',fs);
set(gca,'LineWidth',lw); 
set(get(gca,'xlabel'),'Fontsize',25); 
set(get(gca,'ylabel'),'Fontsize',25);   
set(gca, 'Layer', 'Top')
set(0,'DefaultTextFontname', 'CMU Serif')
h=gca; h.XAxis.TickLength = [0 0];
leg=legend({'$$\varepsilon=0$$','$$\varepsilon=0.01$$','$$\varepsilon=0.1$$','$$\varepsilon=0.25$$','$$\varepsilon=0.5$$'}, 'NumColumns', 5, 'Interpreter', 'LaTeX', 'FontSize', 17, 'Location', 'north');
leg.ItemTokenSize = [15,18];
print(gcf, 'MNIST_1','-dpng', '-r300')


% plot classification rates

epsilon = 0:0.01:1;
kappa = 0.1:0.1:1;
figure
colorOrder = get(gca, 'ColorOrder');
hold on;
color_ind=1;
results = load('../results/MNIST_results.mat');
for k=kappa
	numbers = zeros(1, 10);
	for i=1:length(epsilon)
	    eps = epsilon(i);
	    ind = find((abs(results.kappa-k)<10^-8 & abs(results.epsilon-eps)<10^-8));
	    c(i) = results.classification_rate(ind);
	end
	set(gca,'ColorOrderIndex',color_ind)
	plot3(epsilon, k*ones(1, length(epsilon)), fliplr(c))
	set(gca,'ColorOrderIndex',color_ind)
	fill3([0, epsilon, 1], k*ones(1, length(epsilon) + 2), [67.84, fliplr(c), 67.84], colorOrder(color_ind,:), 'EdgeColor', 'none', 'FaceAlpha', 0.3)
	color_ind = color_ind+1;
	if color_ind==8
		color_ind=1;
	end
end
view(3)
h = findobj(gca,'Type','line');
lw = 2;   
fs = 20;   
grid on;xlabel('$$\varepsilon$$', 'Interpreter', 'LaTeX')
xticks([0, 0.5, 1])
xticklabels([1, 0.5, 0])
ylabel('$$\kappa$$', 'Interpreter', 'LaTeX')
yticks(0:0.1:1)
yticklabels({'0', ' ', '0.2', ' ', '0.4', ' ', '0.6', ' ', '0.8', ' ', '1'})
zlabel('classification rate', 'Interpreter', 'LaTeX')
set(h,'LineWidth',lw);
set(findobj(gca,'Type','text'),'FontSize',fs)
set(gca,'FontSize',fs);
set(gca,'LineWidth',lw); 
set(get(gca,'xlabel'),'Fontsize',25); 
set(get(gca,'ylabel'),'Fontsize',25);   
set(0,'DefaultTextFontname', 'CMU Serif')
print(gcf, 'MNIST_2','-dpng', '-r300')
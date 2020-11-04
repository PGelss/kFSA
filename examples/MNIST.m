% Application of kFSA to the MNIST data set
%
% For more details on this example, see 
%
%   P. Gelß, S. Klus, I. Schuster, C. Schütte,
%   "Feature space approximation for kernel-based
%   supervised learning", arXiv, 2020.
%
% Contact: p.gelss@fu-berlin.de

function MNIST

% parameters
kappa = 0.1:0.1:1;
epsilon = 0.01:0.01:1;
reg_coeff = 10^-10;

% load MNIST data (no included in repository)
data = load('/srv/public/data/mnist/MNIST_reduced.mat');
x_train = data.x_train;
y_train = data.y_train;
x_test = data.x_test;
y_test = data.y_test;

% determine label vector
labels_train = (0:9)*y_train;

% normalize images
x_train = x_train*diag(1./max(x_train, [], 1));
x_test = x_test*diag(1./max(x_test, [], 1));

% loop over kappa
for k = kappa

    % loop over categories
    for j =0:9

        % find indices corresponding to current category
        inds{j+1} = find(labels_train==j);

        % apply kFSA with minimum threshold
        kernel = @(X_1,X_2) mnist_kernel(X_1, X_2, k);
        [indices{j+1}, appr_errors{j+1}] = kFSA(x_train(:, inds{j+1}), kernel, epsilon(1));

    end

    % loop over epsilon>0
    for eps=[0, epsilon]

        if eps>0

            % combine extracted indices corresponding to current threshold
            inds_all=[];
            for j=0:9
                subs=find(appr_errors{j+1}>=eps);
                inds_all = [inds_all, inds{j+1}(indices{j+1}(subs))];
                number_of_samples(j+1)=length(subs);
            end

            % classification
            theta = regression(x_train, y_train, kernel, inds_all, 0);

        else

            % combine all indices
            inds_all=[];
            for j=0:9
                subs=find(labels_train==j);
                inds_all = [inds_all, subs];
                number_of_samples(j+1)=length(subs);
            end
            
            % classification with additional regression if eps=0
            theta = regression(x_train, y_train, kernel, inds_all, 10^-10);

        end
        classification_rate = classify(x_train, inds_all, x_test, y_test, kernel, theta);

        display(['kappa: ', num2str(k), ', eps: ',num2str(eps),', nos: ', num2str(number_of_samples), ', correct: ',num2str(classification_rate)])
        save(['../results/MNIST_results_k_',num2str(k),'_eps_',num2str(eps)], 'number_of_samples', 'classification_rate');
    end

end

save_as_single_file(kappa, epsilon);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function save_as_single_file(kappa_list, epsilon_list)

n = 1;
number_of_samples = zeros(1,10);
epsilon_list = [0, epsilon_list];
for i=1:length(kappa_list)
    for j=1:length(epsilon_list)
        k = kappa_list(i);
        eps = epsilon_list(j);
        data = load(['../results/MNIST_results_k_',num2str(k),'_eps_',num2str(eps)], '-mat');
        kappa(n) = k;
        epsilon(n) = eps;
        number_of_samples(n,:) = data.number_of_samples;
        classification_rate(n) = data.classification_rate;
        n = n + 1:
    end
end
save('../results/MNIST_results.mat', 'kappa', 'epsilon', 'number_of_samples', 'classification_rate');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  


function cr = classify(x_train, indices, x_test, y_test, kernel, theta)

% test phase
G = kernel(x_train(:, indices), x_test);

% one-hot encoding
res = theta*G;
[~, argmax] = max(res,[],1);
lbl = zeros(size(res));
for i=1:size(lbl,2)
  lbl(argmax(i),i) = 1;
end

% amount of correctly identified samples
cr = 100-100*0.5*sum(abs(y_test-lbl), 'all')/size(x_test,2);


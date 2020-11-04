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
%
% You need the following Matlab code to run this script:
%
%   Cameron Musco, "Recursive Nyström Method"
%   https://github.com/cnmusco/recursive-nystrom

function CalCOFI

warning('off','all')

% parameters
kappa = 10:10:300;
epsilon = [10^-10, 10^-6, 10^-2];
reg_coeff = 10^-10;

% load CalCOFI data (data not included in repository)
data = load('/srv/public/data/CalCOFI/data.mat');
x_train = data.x_train;
y_train = data.y_train;
x_test = data.x_test(:,:);
y_test = data.y_test;

% normalize data
L = min(x_train, [], 2);
U = max(x_train, [], 2);
x_train = (x_train - L)./(U - L);
x_test = (x_test - L)./(U - L);

% regression
for k_ind=1:length(kappa)

    k = kappa(k_ind);
    
    % define kernel
    kernel = @(X_1,X_2) gaussian_kernel(X_1, X_2, k);

    % apply kFSA with minimum threshold
    [indices, appr_errors] = kFSA(x_train, kernel, epsilon(1));

    % loop over given threholds
    for eps_ind=1:length(epsilon)

        eps = epsilon(eps_ind);

        % find indices with approximation errors smaller than current threshold
        sub = find(appr_errors>eps);
        indices_tmp = indices(sub);

        % regression with samples extracted by kFSA
        theta = regression(x_train, y_train, kernel, indices_tmp, reg_coeff);

        % test phase
        G = kernel(x_train(:, indices_tmp), x_test);
        reg_error_kFSA = norm(y_test - theta*G).^2/size(x_test,2);

        % apply Nyström method with same number of samples
        kFunc = @(X,rowInd,colInd) gaussianKernel(X,rowInd,colInd, k);
        [C, W, indices_tmp] = recursiveNystrom(x_train',length(indices_tmp),kFunc);

        % regression with samples extracted by Nyström method
        theta = regression(x_train, y_train, kernel, indices_tmp, reg_coeff);

        % test phase
        G = kernel(x_train(:, indices_tmp), x_test);
        reg_error_nys = norm(y_test - theta*G).^2/size(x_test,2);

        % save results
        errors_kFSA(eps_ind, k_ind) = reg_error_kFSA;
        errors_Nys(eps_ind, k_ind) = reg_error_nys;
        number_of_samples(eps_ind, k_ind) = length(indices_tmp);
        kappas(k_ind) = k;
        epsilons(eps_ind) = eps;
        
        display(['kappa=',num2str(k),', eps=',num2str(eps),':  NOS=',num2str(length(indices_tmp)),', MSE_kFSA=',num2str(reg_error_kFSA),', MSE_Nys=',num2str(reg_error_nys)])

    end

end
save('../results/CalCOFI_results_test.mat', 'errors_kFSA', 'errors_Nys', 'number_of_samples', 'kappas', 'epsilons');






    
    

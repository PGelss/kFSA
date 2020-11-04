% Application of kFSA to the Fermi-Pasta-Ulam-Tsingou model
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
%   John D'Errico, "Partitions of an integer"
%   https://www.mathworks.com/matlabcentral/fileexchange/12009-partitions-of-an-integer


function FPU

% parameters
beta = 0.7;   % coupling strength
eps = 10^-10; % threshold for kFSA

% define kernel function
kernel = @(X_1,X_2) polynomial_kernel(X_1, X_2, 1, 3);

% regression without kFSA
for k=1:1000
  for d=2:20

    % sample space dimension
    display(['d=', num2str(d)])
    display('===========================================')
    display(' ')

    % feature space dimension
    n = nchoosek(d+3,3);
    display([' feature space dimension:       ', num2str(n)])

    % generate training data
    [x_train, y_train] = fpu_data(d,2000,beta);

    % consider all samples
    indices = 1:2000;
    display([' number of samples:             ', num2str(length(indices))])

    % regression
    theta = regression(x_train, y_train, kernel, indices, 0);

    % compare exact and apprroximate coefficient matrixes
    C_1 = approximate_coefficients(x_train, indices, theta, n);
    C_2 = exact_coefficients(d, n, beta);
    rel_err = norm(C_1-C_2)/norm(C_2);
    errors_full(k, d-1) = rel_err;
    display([' relative approximation error:  ', num2str(rel_err)])
    display(' ')

  end
end

display(' ')

% regression with kFSA
for k=1:100
  for d=2:20

    % sample space dimension
    display(['d=', num2str(d)])
    display('===========================================')
    display(' ')

    % feature space dimension
    n = nchoosek(d+3,3);
    display([' feature space dimension:       ', num2str(n)])

    % generate training data
    [x_train, y_train] = fpu_data(d,2000,beta);

    % apply kFSA
    [indices, ~] = kFSA(x_train, kernel, eps);
    display([' number of samples:             ', num2str(length(indices))])

    % regression
    theta = regression(x_train, y_train, kernel, indices, 0);

    % compare exact and apprroximate coefficient matrixes
    C_1 = approximate_coefficients(x_train, indices, theta, n);
    C_2 = exact_coefficients(d, n, beta);
    rel_err = norm(C_1-C_2)/norm(C_2);
    errors_kFSA(k, d-1) = rel_err;
    number_of_samples_kFSA(d-1) = length(indices);
    display([' relative approximation error:  ', num2str(rel_err)])
    display(' ')
  end
end
save('../results/FPU_results_kFSA.mat', 'errors_full', 'errors_kFSA', 'number_of_samples_kFSA');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  


function [x, y] = fpu_data(d, m, beta)

% Generate training data for FPU model.
%
% Parameters
% ----------
%
% d : int
%     sample dimension, i.e., number of oscillators
%
% m : int
%     number of samples
%
% beta: float
%     coupling strength
%
%
% Returns
% -------
%
%  x : d x m array
%     sample matrix
%
%  y : d x m array
%     corresponding derivatives

% random displacements in [-0.1, 0.1]
x = 0.2*rand(d, m)-0.1;

% compute derivatives
y = zeros(d, m);
for j=1:m
    y(1,j) = x(2,j) - 2*x(1,j) + beta*( ( x(2,j) - x(1,j) )^3 - x(1,j)^3 );
    for i=2:d-1
        y(i,j) = x(i+1,j) - 2*x(i,j) + x(i-1,j) + beta*( ( x(i+1,j) - x(i,j) )^3 - ( x(i,j) - x(i-1,j) )^3 );
    end
    y(end, j) = -2*x(end,j) + x(end-1,j) + beta*( -x(end,j)^3 - ( x(end,j) - x(end-1,j) )^3 );
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  


function c = multicoeff (k), 

% Compute multinomial coefficient.
%
% % Parameters
% ----------
%
% k : list of ints
%     list of exponents
%
% Returns
% -------
%
%  c : int
%     mutlinomial coefficient (sum(k) over k)

% use representation as product of binomial coefficients
c = 1; 
for i=1:length(k), 
  c = c* nchoosek(sum(k(1:i)),k(i)); 
end; 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  


function C = approximate_coefficients(x_train, indices, theta, n)

% Compute approximate coefficient matrix.
%
% Parameters
% ----------
%
% x_train : d x m array
%     input matrix
%
% indices : list of ints
%     index set of size m'
%
% theta : d x m' array
%     solution of regression problem
%
% n : int
%     feature space dimension
%
% Returns
% -------
%
% C : d x n array
%     coefficient matrix

d = size(x_train, 1);
x_train = x_train(:, indices);
tdt = zeros(size(x_train,2), n);
part = partitions(3,ones(1,d+1));
D = zeros(1,n);
for i=1:n
    v = ones(size(x_train,2),1);
    for j = 1:size(x_train,1)
        v = v.*(x_train(j,:).^part(i,j+1))';
    end
    a = sqrt(multicoeff(part(i,:)));
    D(i) = a;
    tdt(:,i) = a*v;
end
coefficients = theta*tdt;
C = coefficients*diag(D);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  


function C = exact_coefficients(d, n, beta)

% Compute exact coefficient matrix.
%
% Parameters
% ----------
%
% d : int
%     sample space dimension
%
% n : int
%     feature space dimension
%
% beta : float
%     coupling strength
%
% Returns
% -------
%
% C : d x n array
%     coefficient matrix

C = zeros(d, n);
part = partitions(3,ones(1,d+1));
for j=1:d
  for i=1:n
    if j>1
      if (part(i,j)==1) && (part(i,1)==2)  % i-1 ^ 1
        C(j,i) = 1;
      end
      if (part(i,j)==3) % i-1 ^ 3
        C(j,i) = beta;
      end
      if (part(i,j)==1) && (part(i,j+1)==2) % i-1 ^ 1, i ^ 2
        C(j,i) = 3*beta;
      end
      if (part(i,j)==2) && (part(i,j+1)==1) % i-1 ^ 2, i ^ 1
        C(j,i) = -3*beta;
      end
    end
    if (part(i,j+1)==1) && (part(i,1)==2) % i ^ 1
      C(j,i) = -2;
    end
    if (part(i,j+1)==3) % i ^ 3
      C(j,i) = -2*beta;
    end
    if j<d
      if (part(i,j+2)==1) && (part(i,1)==2) % i+1 ^ 1
        C(j,i) = 1;
      end
      if (part(i,j+2)==3) % i+1 ^ 3
        C(j,i) = beta;
      end
      if (part(i,j+2)==1) && (part(i,j+1)==2) % i+1 ^ 1, i ^ 2
        C(j,i) = 3*beta;
      end
      if (part(i,j+2)==2) && (part(i,j+1)==1) % i+1 ^ 2, i ^ 1
        C(j,i) = -3*beta;
      end
    end
  end
end


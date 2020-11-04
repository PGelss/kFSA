function theta = regression(x_train, y_train, kernel, indices, gamma)

% Solve reduced regression problem corresponding to given index set.
%
% Parameters
% ----------
%
% x_train : d x m array
%     input matrix
%
% y_train : d' x m array
%     output matrix
%
% kernel : function handle
%     kernel function used to construct the Gram matrix
%
% indices : list of ints
%     index set of size m'
%
% gamma: float
%     additional regularization parameter
%
% Returns
% -------
%
%  theta : d' x m' array
%     solution


G = kernel(x_train(:,indices), x_train);

if gamma==0
	
	theta = y_train/G;

elseif size(G,1)<size(G,2)

	b = y_train*G';
	G = G*G' + gamma*eye(length(indices));
    theta = b/G;

else
	
	theta = y_train/(G + gamma*eye(length(indices)));

end



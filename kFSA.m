%% kernel-based feature space approximation
%
% This file implements Algorithm 1 from 
%
%   P. Gelß, S. Klus, I. Schuster, C. Schütte,
%   "Feature space approximation for kernel-based
%   supervised learning", arXiv, 2020
%  
% See the included m-files for application examples.
%
% Contact: p.gelss@fu-berlin.de
%
% Parameters
% ----------
%
% X : d x m array
%     matrix containing m samples with dimension d
%
% kernel : function handle
%     kernel function used to construct the Gram matrix
%
% eps : float
%     threshold for the approximation errors
%
%
% Returns
% -------
%
%  indices : list
%     extracted sample indices
%
%  errors : list
%     corresponding approximation errors


function [indices, errors] = kFSA(X, kernel, eps)

    % compute Gram matrix
    G = kernel(X,X);
    G_diag = diag(G);

    % list of potential indices
    left = 1:size(X,2);

    % find first sample point
    for i=1:size(X,2)
        maximum_distances(i) = sum(diag(G)-G(:,i).^2/G(i,i));
    end
    [~,indices] = min(maximum_distances);
    errors = inf;
    left = left(left~=indices);

    % compute Z
    Z = G(indices,indices)^-1*G(indices, left);     

    while (~isempty(left))

        % compute approximation errors
        appr_errors = G_diag(left)-sum(G(indices,left).*Z,1)';

        % find sample corresponding to maximum approximation error
        [error, sub_index] = max(appr_errors);
        index = left(sub_index);

        % remove samples with approximation errors smaller than eps
        keep = find(appr_errors>eps);
        keep = keep(keep~=sub_index);
        left = left(keep);

        if error>eps

            % add index and error to corresponding lists
            errors(end+1) = error;
            indices(end+1) = index;

            % update Z
            L = (1/error)*(G(index, left) - G(index, indices(1:end-1))*Z(:,keep));
            Z = [Z(:,keep) - Z(:,sub_index)*L; L];

        end

    end

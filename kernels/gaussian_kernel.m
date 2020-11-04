function G = gaussian_kernel(x_1, x_2, kappa)

% Construct Gram matrix corresponding to a Gaussian kernel.
%
% Parameters
% ----------
%
% x_1 : d x m array
%     first sample matrix
%
% x_2 : d x m' array
%     second sample matrix
%
% kappa : float
%     kernel parameter
%
% Returns
% -------
%
%  G : m x m' array
%     Gram matrix


G = zeros(size(x_1,2), size(x_2,2));

for i=1:size(x_1,2)
    G(i,:) = exp(-kappa * (vecnorm(x_2 - x_1(:, i)).^2));
end
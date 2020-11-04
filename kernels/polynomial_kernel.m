function G = polynomial_kernel(x_1, x_2, kappa, q)

% Construct Gram matrix corresponding to a polynomial kernel.
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
% kappa, q: float
%     kernel parameters
%
%
% Returns
% -------
%
%  G : m x m' array
%     Gram matrix


G = zeros(size(x_1,2), size(x_2,2));

for i=1:size(x_1,2)
    G(i,:) = (kappa+x_1(:,i)'*x_2).^q;
end
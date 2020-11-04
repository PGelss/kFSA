function G = mnist_kernel(x_1, x_2, kappa)

% Construct Gram matrix corresponding to the MNIST kernel.
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


G = ones(size(x_1,2), size(x_2,2));

% partition each image into 9 different blocks
pixels = reshape((1:196), [14, 14]);
subpixels{1} = reshape(pixels(2:5, 2:5), [16 1]);
subpixels{2} = reshape(pixels(2:5, 6:9), [16 1]);
subpixels{3} = reshape(pixels(2:5, 10:13), [16 1]);
subpixels{4} = reshape(pixels(6:9, 2:5), [16 1]);
subpixels{5} = reshape(pixels(6:9, 6:9), [16 1]);
subpixels{6} = reshape(pixels(6:9, 10:13), [16 1]);
subpixels{7} = reshape(pixels(10:13, 2:5), [16 1]);
subpixels{8} = reshape(pixels(10:13, 6:9), [16 1]);
subpixels{9} = reshape(pixels(10:13, 10:13), [16 1]);

% loop over blocks
for i=1:length(subpixels)

    G_tmp = ones(size(G));

    % loop over subpixels
    for j=1:length(subpixels{i})
        arg = x_1(subpixels{i}(j),:)'-x_2(subpixels{i}(j),:);
        G_tmp = G_tmp.*cos(kappa * arg);
    end

    G = G.*(G_tmp+1);
    
end

G = G-1;
G = (1/511)*G;
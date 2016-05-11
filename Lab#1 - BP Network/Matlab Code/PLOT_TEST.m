function [ ] = PLOT_TEST( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

TRAIN = csvread('sub_train_v4.csv');
[H, W] = size(TRAIN);

for event = 41 : 45
    smooth_t = zeros(1, W);
    for i = 110 : 6040
        temp = 0;
        for j = i - 100 : i + 100
            temp = temp + TRAIN(event, j);
        end
        smooth_t(1, i) = temp / 80;
    end
    TRAIN(event, 1)
    figure, plot(smooth_t(1,1:2048));
end

end


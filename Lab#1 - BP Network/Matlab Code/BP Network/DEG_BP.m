function [ net, REF_PRED_FIX ] = DEG_BP( net )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

process = 'loading sub_train.csv ...'
TRAIN = csvread('sub_train_v4.csv');
[H, W] = size(TRAIN);

REF_TRAIN = zeros(H, 2);
for i = 1 : H
    pos = mod(TRAIN(i, 1)-1, 2) + 1;
    REF_TRAIN(i, pos) = 1;
end

TRAIN(:, 1) = [];
TRAIN = TRAIN';
REF_TRAIN = REF_TRAIN';

if nargin == 0
    net = newff(minmax(TRAIN), [500, 500, 1000, 2], { 'logsig' 'logsig' 'logsig' 'logsig' }, 'trainscg');
end

net.trainparam.show = 50 ;
net.trainparam.epochs = 500000 ;
net.trainparam.goal = 0;
net.trainParam.lr = 0.01;

net = train(net, TRAIN, REF_TRAIN);

process = 'loading sub_test.csv ...'
TEST = csvread('sub_test_v4.csv');
[H, W] = size(TEST);

REF_TEST = zeros(H, 2);
for i = 1 : H
    pos = mod(TEST(i, 1)-1, 2) + 1;
    REF_TEST(i, pos) = 1;
end

TEST(:, 1) = [];
TEST = TEST';
REF_TEST = REF_TEST';

process = 'predicting test ...'
REF_PRED = sim(net, TEST);
REF_PRED_FIX = zeros(H, 3);

[s1 , s2] = size( REF_PRED ) ;
hitNum = 0 ;
for i = 1 : s2
    [m , Index] = max( REF_PRED( : ,  i ) ) ;
    [m1 , Index1] = max( REF_TEST( : ,  i ) ) ;
    REF_PRED_FIX(i, 1) = i;
    REF_PRED_FIX(i, 2) = Index1;
    REF_PRED_FIX(i, 3) = Index;
    if( Index  == Index1   ) 
        hitNum = hitNum + 1 ; 
    end
end

csvwrite('prediction.csv', REF_PRED');
csvwrite('prediction_fix.csv', REF_PRED_FIX);

hitNum = hitNum
total = H
percent = double(hitNum/H)

end


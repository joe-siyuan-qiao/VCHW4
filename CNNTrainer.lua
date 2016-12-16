--[[----------------------------------------------------------------------------
Training and testing for a Convolutional Neural Network

Author:
Siyuan Qiao, siyuan.qiao@jhu.edu
Ph.D. Student, Department of Computer Science, Johns Hopkins University
260 Malone Hall, 3400 North Charles Street, Baltimore, MD
------------------------------------------------------------------------------]]

require 'nn'
require 'util'

--------------------------------------------------------------------------------
-- parse arguments
local cmd = torch.CmdLine()
cmd:text()
cmd:text('Training a Convlutional Neural Network for MNIST dataset')
cmd:text()
cmd:text('Options:')
cmd:option('-numSteps', 1000, 'max number of training steps')
cmd:option('-lr', 0.05, 'learning rate')
cmd:option('-net', 2, 'the number of convolutional layers {0, 1, 2}')
cmd:option('-testStep', 50, 'test the accuracy every testStep steps')
local config = cmd:parse(arg)

--------------------------------------------------------------------------------
-- initilize the convolutional neural network

-- two layer convolutional neural network
twolayercnn = nn.Sequential()
twolayercnn:add(nn.SpatialConvolutionMM(1, 32, 5, 5))
twolayercnn:add(nn.ReLU())
twolayercnn:add(nn.SpatialMaxPooling(2, 2))
twolayercnn:add(nn.SpatialConvolutionMM(32, 64, 5, 5))
twolayercnn:add(nn.ReLU())
twolayercnn:add(nn.SpatialMaxPooling(2, 2))
twolayercnn:add(nn.Reshape(64 * 5 * 5))
twolayercnn:add(nn.Linear(64 * 5 * 5, 10))

-- one layer convolutional neural network
onelayercnn = nn.Sequential()
onelayercnn:add(nn.SpatialConvolutionMM(1, 32, 5, 5))
onelayercnn:add(nn.ReLU())
onelayercnn:add(nn.SpatialMaxPooling(2, 2))
onelayercnn:add(nn.Reshape(32 * 14 * 14))
onelayercnn:add(nn.Linear(32 * 14 * 14, 10))

-- linear classifier
zerolayercnn = nn.Sequential()
zerolayercnn:add(nn.Reshape(32 * 32))
zerolayercnn:add(nn.Linear(32 * 32, 10))

-- network setup and criteirion
crit = nn.CrossEntropyCriterion()
cnnTable = {zerolayercnn, onelayercnn, twolayercnn}
cnn = cnnTable[config.net + 1]

--------------------------------------------------------------------------------
-- loading the training dataset
paths.dofile('batches.lua')
print('| loading dataset')
mnistTrain = torch.load('data/trainingData.t7')
mnistTest = torch.load('data/testData.t7')
testImages, testLabels = mnistTest:getNextBatch(1000)

--------------------------------------------------------------------------------
-- start training loop
print('| start training')
for i = 1, config.numSteps do
  local images, labels = mnistTrain:getNextBatch(100)
  local scores = cnn:forward(images)
  local loss = crit:forward(scores, labels)
  local dScores = crit:backward(scores, labels)
  cnn:backward(images, dScores)
  cnn:updateParameters(config.lr)
  cnn:zeroGradParameters()
  if i % config.testStep == 0 then
    local preds = cnn:forward(testImages)
    print(string.format('[test] | step %05d | accuracy: %07.5f ', i,
        accuracy(preds, testLabels)))
  end
  collectgarbage()
end

local modelDir = paths.concat('pretrained', string.format('model-net-%d.t7',
    config.net))
print('| save model to ' .. modelDir)
torch.save(modelDir, cnn:clone('weight', 'bias'))

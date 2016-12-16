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
local config = cmd:parse(arg)

--------------------------------------------------------------------------------
-- initilize the convolutional neural network
cnn = nn.Sequential()
cnn:add(nn.SpatialConvolutionMM(1, 32, 5, 5))
cnn:add(nn.ReLU())
cnn:add(nn.SpatialMaxPooling(2, 2))
cnn:add(nn.SpatialConvolutionMM(32, 64, 5, 5))
cnn:add(nn.ReLU())
cnn:add(nn.SpatialMaxPooling(2, 2))
cnn:add(nn.Reshape(64 * 5 *5))
cnn:add(nn.Linear(64 * 5 * 5, 10))
crit = nn.CrossEntropyCriterion()

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
  if i % 100 == 0 then
    local preds = cnn:forward(testImages)
    print(string.format('[test] | step %05d | accuracy: %07.5f ', i,
        accuracy(preds, testLabels)))
  end
  collectgarbage()
end

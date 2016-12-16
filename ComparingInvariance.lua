--[[----------------------------------------------------------------------------
Comparing Invariance of the three trained networks

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
cmd:text('Comparing Invariance of the three trained networks')
cmd:text()
cmd:text('Options:')
cmd:option('-net', 2, 'the number of convolutional layers {0, 1, 2}')
local config = cmd:parse(arg)

--------------------------------------------------------------------------------
-- loading the pretrained network
local modelDir = paths.concat('pretrained', string.format('model-net-%d.t7',
    config.net))
print('| loading model from ' .. modelDir)
local cnn = torch.load(modelDir)

--------------------------------------------------------------------------------
-- loading three test dataset
print('| loading the test dataset')
local center, leftShifts, rightShifts
center = torch.load(paths.concat('data', 'translations', 'center.t7'))
leftShifts = torch.load(paths.concat('data', 'translations', 'leftShifts.t7'))
rightShifts = torch.load(paths.concat('data', 'translations', 'rightShifts.t7'))

--------------------------------------------------------------------------------
-- compute the score vectors
vCenter = cnn:forward(center)
local vLeftShifts = {}
local vRightShifts = {}
for i = 1, 5 do vLeftShifts[i] = cnn:forward(leftShifts[i]) end
for i = 1, 5 do vRightShifts[i] = cnn:forward(rightShifts[i]) end

--------------------------------------------------------------------------------
-- normalize the score vectors
vCenter = normalize(vCenter)
for i = 1, 5 do vLeftShifts[i] = normalize(vLeftShifts[i]) end
for i = 1, 5 do vRightShifts[i] = normalize(vRightShifts[i]) end
collectgarbage()

--------------------------------------------------------------------------------
-- compute the average distance
vAvgDistance = {}
for i = 1, 5 do vAvgDistance[i] = avgDistance(vCenter, vLeftShifts[6 - i]) end
vAvgDistance[6] = 0.0
for i = 1, 5 do vAvgDistance[i + 6] = avgDistance(vCenter, vRightShifts[i]) end

log = '| average distance:\n'
for i = 1, 11 do
  log = log .. string.format('| [%d]\t| %07.5f \n', i, vAvgDistance[i])
end
print(log)

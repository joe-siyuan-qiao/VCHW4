## The final project of Probabilistic Models of the Visual Cortex

The training and testing codes for the three neural networks are all implemented in CNNTrainer.lua. The help manual can be found by

```
[in]: th CNNTrainer.lua -help

[out]: Training a Convlutional Neural Network for MNIST dataset

Options:
  -numSteps max number of training steps [1000]
  -lr       learning rate [0.05]
  -net      the number of convolutional layers {0, 1, 2} [2]
  -testStep test the accuracy every testStep steps [50]
```
The output of training and testing two convolutional layer network
```
[in]: th CNNTrainer.lua -net 2
[out]:
| loading dataset
| start training
[test] | step 00050 | accuracy: 0.88400
[test] | step 00100 | accuracy: 0.91900
[test] | step 00150 | accuracy: 0.94500
[test] | step 00200 | accuracy: 0.93800
[test] | step 00250 | accuracy: 0.96500
[test] | step 00300 | accuracy: 0.96500
[test] | step 00350 | accuracy: 0.97200
[test] | step 00400 | accuracy: 0.96700
[test] | step 00450 | accuracy: 0.94800
[test] | step 00500 | accuracy: 0.96600
[test] | step 00550 | accuracy: 0.97000
[test] | step 00600 | accuracy: 0.96500
[test] | step 00650 | accuracy: 0.97100
[test] | step 00700 | accuracy: 0.96700
[test] | step 00750 | accuracy: 0.98200
[test] | step 00800 | accuracy: 0.97900
[test] | step 00850 | accuracy: 0.98400
[test] | step 00900 | accuracy: 0.98000
[test] | step 00950 | accuracy: 0.98200
[test] | step 01000 | accuracy: 0.98600
```
The output of training and testing one convolutional layer network
```
[in]: th CNNTrainer.lua -net 1
[out]:
| loading dataset
| start training
[test] | step 00050 | accuracy: 0.89100
[test] | step 00100 | accuracy: 0.91700
[test] | step 00150 | accuracy: 0.93200
[test] | step 00200 | accuracy: 0.94000
[test] | step 00250 | accuracy: 0.95300
[test] | step 00300 | accuracy: 0.96300
[test] | step 00350 | accuracy: 0.96300
[test] | step 00400 | accuracy: 0.97100
[test] | step 00450 | accuracy: 0.95700
[test] | step 00500 | accuracy: 0.96400
[test] | step 00550 | accuracy: 0.96300
[test] | step 00600 | accuracy: 0.96700
[test] | step 00650 | accuracy: 0.97000
[test] | step 00700 | accuracy: 0.96800
[test] | step 00750 | accuracy: 0.97200
[test] | step 00800 | accuracy: 0.97300
[test] | step 00850 | accuracy: 0.97400
[test] | step 00900 | accuracy: 0.97800
[test] | step 00950 | accuracy: 0.97500
[test] | step 01000 | accuracy: 0.97500
```
The output of training and testing linear classifier
```
[in]: th CNNTrainer.lua -net 0
[out]:
| loading dataset
| start training
[test] | step 00050 | accuracy: 0.85200
[test] | step 00100 | accuracy: 0.87300
[test] | step 00150 | accuracy: 0.88500
[test] | step 00200 | accuracy: 0.87700
[test] | step 00250 | accuracy: 0.89800
[test] | step 00300 | accuracy: 0.89900
[test] | step 00350 | accuracy: 0.90400
[test] | step 00400 | accuracy: 0.90600
[test] | step 00450 | accuracy: 0.89200
[test] | step 00500 | accuracy: 0.89700
[test] | step 00550 | accuracy: 0.90000
[test] | step 00600 | accuracy: 0.89800
[test] | step 00650 | accuracy: 0.90200
[test] | step 00700 | accuracy: 0.90400
[test] | step 00750 | accuracy: 0.89800
[test] | step 00800 | accuracy: 0.90100
[test] | step 00850 | accuracy: 0.90600
[test] | step 00900 | accuracy: 0.91000
[test] | step 00950 | accuracy: 0.91300
[test] | step 01000 | accuracy: 0.91200
```
To plot the learning curve
```lua
for i = 50, 1000, 50 do
    table.insert(x, i)
end
y0 = {0.85200, 0.87300, 0.88500, 0.87700, 0.89800, 0.89900, 0.90400, 0.90600,
    0.89200, 0.89700, 0.90000, 0.89800, 0.90200, 0.90400, 0.89800, 0.90100,
    0.90600, 0.91000, 0.91300, 0.91200}
y1 = {0.89100, 0.91700, 0.93200, 0.94000, 0.95300, 0.96300, 0.96300, 0.97100,
    0.95700, 0.96400, 0.96300, 0.96700, 0.97000, 0.96800, 0.97200, 0.97300,
    0.97400, 0.97800,0.97500, 0.97500}
y2 = {0.88400, 0.91900, 0.94500, 0.93800, 0.96500, 0.96500, 0.97200, 0.96700,
    0.94800, 0.96600, 0.97000, 0.96500, 0.97100, 0.96700, 0.98200, 0.97900,
    0.98400, 0.98000, 0.98200, 0.98600}
x = torch.Tensor(x)
y0 = torch.Tensor(y0)
y1 = torch.Tensor(y1)
y2 = torch.Tensor(y2)
gnuplot.plot({'Linear Classifier', x, y0, '-'}, {'One Convolutional Layer', x,
    y1, '-'}, {'Two Convolutional Layers', x, y2, '-'})
```
The learning curves are shown as follows.

![The Learning Curve](learning_curve.png)

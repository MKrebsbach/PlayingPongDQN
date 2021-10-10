15.06.2021
This code was written by Michael Krebsbach with inspiration from/ parts from:

# Sources:
The code was inspired by the paper
	"Playing Atari with Deep Reinforcement Learning" 
	Mnih et al.
	2013
	https://www.cs.toronto.edu/~vmnih/docs/dqn.pdf
	accessed on 15.06.2021 09:44

as well as
	https://towardsdatascience.com/deep-q-network-dqn-ii-b6bf911b6b2c
	accessed on 15.06.2021 09:45

The Pong engine was adjusted from 
	Silas Henderson
	https://www.mathworks.com/matlabcentral/fileexchange/69833-pong/
	accessed on 15.06.2021 06:46

The gradient calculation was adjusted from the Matlab code following the book 
	Matlab Deep Learning - With Machine Learning, Neural Networks and Artificial Intelligence
	Phil Kim
	ISBN-13 (pbk): 978-1-4842-2844-9
	ISBN-13 (electronic): 978-1-4842-2845-6
	DOI 10.1007/978-1-4842-2845-6
	Springer Science+Business Media New York
	2017
	Chapter 2

--------------------------------------------------------------------------------------------------------
The code can train two (2 Layer) neural networks to play Pong against each other 
as well as human vs neural network.

# How to train and to play:
RunDQN.m    trains two Networks (Agent1, Agent2) by playing Pong against each other. Has to be executed before running the following.

TestRun.m   displays 5 games either played randomly (random=true) or by the agents (random = false).

Pong.m      lets you play Pong against Agent2

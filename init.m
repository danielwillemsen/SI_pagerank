%% Initialization script used in all main files
%
% Mario Coppola, 2019

clear; close all; clc;
addpath(genpath(pwd)); % Add all paths
rng('shuffle'); % Shuffle random seed
format compact;
set(0, 'defaulttextinterpreter', 'latex'); % Needed for plot printing to LaTex
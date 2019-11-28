
This repository holds the MATLAB code for the paper:

**"PageRank: a Novel Micro-Macro Link for Evaluation and Optimization of Swarm Behavior via a Local Analysis"**
*Mario Coppola, Jian Guo, Eberhard Gill, Guido de Croon, 2019.*

The code has been developed using MATLAB 2019a on Ubuntu 18.04. It is not guaranteed that it will function as originally intended for other set-ups. In particular, please note that some functions used, especially those pertaining to graph analysis, are not included in older versions of MATLAB.

To run and reproduce the results, the following scripts can be used:

## Pattern Formation
* `main_patternformation_optimization.m`
Runs the Phase 1 and Phase 2 optimizations for a specified patterns and stores the output
* `main_patternformation_analysis_phase1.m`
Analyzes the results of Phase 1 from the optimization
* `main_patternformation_analysis_phase2.m`
Analyzes the results of Phase 2 from the optimization
* `main_patternformation_evaluation.m`
Evaluates the performance differences
* `main_patternformation_evaluation_lineNE.m`
Evaluates the performance differences for the line pattern, with different number of robots

## Consensus
### Default case
* `main_consensus_optimization.m`
Optimizes the consensus behavior
* `main_consensus_evaluation.m`
Evaluates the performance of the optimized solutions
* `main_consensus_analysis.m`
Analyzes the data and makes the relevant figures

### Binary variant
* `main_consensus_binary_optimization.m`
Optimizes the binary variant of the consensus behavior
* `main_consensus_binary_evaluation.m`
Evaluates the performance of optimized solutions

## Aggregation
### Optimization
* `main_aggregation_optimization.m`
Optimizes the behavior for aggregation
* `main_aggregation_analysis.m`
Analyzes the results of the optimization (not simulations)

### Swarmulator simulations
* `main_swarmulator_batch_script_generator.m`
Generates a script that can run several iterations of Swarmulator for different properties.
* `main_swarmulator_analysis.m`
Analyzes the results of the simulations

### Evaluation times
* `main_evaluationtime_evaluate.m`
Does sample PageRank computations for all behaviors and measures the evaluation time
* `main_evaluationtime_analysis.m`
Analyzes the results of the evaluation

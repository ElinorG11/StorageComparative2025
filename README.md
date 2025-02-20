This repository contains code for a comparative study of traditional and reinforcement-learning-based energy storage control methods. The project evaluates the performance of classical optimal control techniques, such as Pontryagin’s Minimum Principle and Dynamic Programming, against reinforcement learning approaches like PPO, SAC, and TD3.

# **Comparative Study: Traditional vs. Reinforcement Learning-Based Energy Storage Control**

## **Overview**


This repository contains code and analysis for evaluating energy storage management strategies using both classical optimal control methods and reinforcement learning (RL) approaches. The goal is to understand the trade-offs between traditional control techniques, which rely on known physical models, and RL-based policies, which learn optimal control strategies from experience.

The study focuses on three increasingly complex energy storage scenarios:
1. **Ideal storage devices** with convex cost functions.
2. **Lossy storage devices**, introducing efficiency losses in energy storage operations.
3. **Lossy storage devices with transmission line losses**, incorporating additional grid-level uncertainties.

## **Key Features**


- **Traditional control algorithms**:
  - Pontryagin’s Minimum Principle (PMP)
  - Dynamic Programming (DP)
  - Shortest Path Algorithm (SP)
- **Reinforcement learning methods**:
  - Proximal Policy Optimization (PPO)
  - Soft Actor-Critic (SAC)
  - Twin Delayed DDPG (TD3)
- **Comparison metrics**:
  - Daily generation costs over 100 test days
  - Mean and variance of energy costs for each algorithm
  - Sensitivity analysis to system uncertainties


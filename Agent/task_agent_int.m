function [data_int] = task_agent_int(taskCond,agentnum)
% function task_agent_int simulates the interaction between task and agent.
%
% OUTPUT:
%   data_int: simulated interaction stored in a table

% INTIALIZATION OF REQUIRED CLASSES
task = Task();
agent = Agent();

task.condition = taskCond; % add the relevant experimental condition
agent.condition = taskCond; % similarly for the agent
agent.agent = agentnum; % add the agent type

task.taskMu();
agent.getSigma();

% NUMBER OF TRIALS
T = task.T;

% PRE-ALLOCATE ARRAYS
s = NaN(1,T); % state array
u = NaN(1,T); % task generated contrast difference array
o = NaN(1,T); % subjective observation of contrast difference array
r = NaN(1,T); % task generated reward
e_mu_t = zeros(1,T); % updated contingency parameter array
a = NaN(1,T); % economic decision array
pi_1 = NaN(1,T); % belief state for s = 1 array
pi_0 = NaN(1,T); % belief state for s = 0 array
corr = NaN(1,T); % economic performance array
trial = NaN(1,T); % trial number array
condition = NaN(1,T); % experimental condition array
contrast = NaN(1,T); % contrast array
congruence = NaN(1,T); % congruence array
v_a_1 = NaN(1,T); % expected value of a = 1 array

% INITIALISE TABLE TO SAVE VARIABLES
data_int = table();

for i = 1:T

    task.state_sample(); % task generated state
    task.contrast_sample(); % task generated contrast difference
    agent.observation_sample(task.c_t);% contrast based observation sampled
    agent.decide_e(agent.o_t); % economic decision
    task.reward_sample(agent.a_t);% economic choice based reward
    agent.learn(task.r_t); % update based on reward

    if or(and(task.s_t == 0,agent.a_t == 0),and(task.s_t == 1,agent.a_t == 1)) % for mu > 0.5
        corr(i) = 1;
    else
        corr(i) = 0;
    end

    % STORING SIMULATED VARIABLES
    s(i) = task.s_t;
    u(i) = task.c_t;
    o(i) = agent.o_t;
    pi_1(i) = agent.pi_1 ;
    pi_0(i) = agent.pi_0;
    e_mu_t(i) = agent.G;
    v_a_1(i) = agent.v_a_t(1);
    a(i) = agent.a_t;
    q_0(i) = agent.q_0;
    q_1(i) = agent.q_1;
    r(i) = task.r_t;
    trial(i) = i ;
end

% STORE VARIABLES IN TABLE
data_int.state = s.';
data_int.action = a.';
data_int.reward = r.';
data_int.state_0 = pi_0.';
data_int.state_1 = pi_1.';
data_int.mu = e_mu_t.';
data_int.trials = trial.';
data_int.correct = corr.';
data_int.contrast_diff = u.';
data_int.subjective_obs = o.';
data_int.condition = condition.';
data_int.contrast = contrast.';
data_int.value_a1 = v_a_1.';
data_int.congruence = congruence.';

end

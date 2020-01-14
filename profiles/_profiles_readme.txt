The profiles folder contains all files that profile the side-channel
leakage of the leakage nodes in the factor graph



- \profiles\specify_profile_<technique> specifies how to build profiles from e.g. a training dataset
It can range from univariate/multivariate Gaussian templates to LRA, neural nets etc.
It can be simulated profiles or profiles that are estimated using a training dataset

- \profiles\compute_prob_<technique>.m specifies how to compute probabilities from a profiling technique
It computes probabilities for all traces in a node (if the leaky value is constant) or it computes
probabilities for a single traces in a node (if the leaky value is random)

- \profiles\generate_attack_traces_<technique>.m generates attack traces from the attack values produced in 
specify_attack_values_<cipher>.m 
It can be replaced by real traces or other simulation techniques

All three \profiles\specify_profile_<technique>.m and \profiles\compute_prob_<technique>.m and \profiles\generate_attack_traces_<technique>.m
need to be in accordance with each other



- \core\generate_attack_traces.m links main.m to the correct leakage simulation process

- \core\compute_probability.m links belief_propagation.m to the correct probability computation technique

- \core\specify_profile.m links specify_sasca.m the  to the correct profiling technique




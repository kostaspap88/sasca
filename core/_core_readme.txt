Core readme


- \core\belief_propagation.m contains the BP algorithm

- \core\compute_factor_message.m specifies how BP computes messages from factors and links (if needed) to \operators\

- \core\compute_var_message.m is specifies how BP computes messages from variables

- \core\compute_probability is specifies how BP computes leakage probabilities and links to \profiles\

- \core\generate_attack_traces.m creates the attack traces and links to \profiles\

- \core\generate_factor_graph.m creates the factor graph using the specifications from global variable 'spec'

- \core\specify_attack_values.m creates the attack values and links to \cipher\

- \core\specify_config.m specifies the global variable 'spec'

- \core\specify_factor_graph.m specifies the FG and links to \cipher\

- \core\specify_profile.m specifie the leakage type and links to \profiles\

- \core\start_sasca.m begins the specifications and the constructions of global variable fg
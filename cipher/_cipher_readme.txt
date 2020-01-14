The profiles folder contains all files that specify the cipher
structure and values



- \cipher\specify_factor_graph_<cipher> specifies the structure of your cipher

- \cipher\specify_attack_values_<technique>.m specifies and generates the attack values needed for sasca

Both specify_factor_graph_<cipher>.m and specify_attack_values_<technique>.m need to be in accordance with each other

- \core\specify_factor_graph.m links specify_sasca.m to the correct cipher factor graph structure

- \core\specify_attack_values.m links the main.m to the correct cipher attack values

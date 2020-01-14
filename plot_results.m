function plot_results(average_rank, average_success_rate, std_rank, std_success_rate)

global spec fg 

% plot the factor graph
figure;
plot(fg)
title('Factor Graph')


% plot the secret's rank vs. the number of attack traces
figure;
errorbar(spec.AttackTracesVector, average_rank, std_rank, '-o', 'LineWidth', 1.1)
ylim([0 2^spec.SizeDict(spec.SecretVar) + 0.1])
xlim([1 spec.NoAttackTraces+1])
title('Key Rank vs. Number of Attack Traces')
xlabel('Number of Attack Traces')
ylabel('Key Rank')


% plot the success rate vs. the number of attack traces
figure;
errorbar(spec.AttackTracesVector, average_success_rate, std_success_rate, '-o', 'LineWidth', 1.1)
ylimit_up = 1.1;
ylimit_down = 0;   
ylim([ylimit_down ylimit_up])
xlim([1 spec.NoAttackTraces+1])
title('Success Rate vs. Number of Attack Traces')
xlabel('Number of Attack Traces')
ylabel('Success Rate')


end
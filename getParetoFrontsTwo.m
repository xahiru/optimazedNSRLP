function [ ACTIONS ] = getParetoFrontsTwo( ATTACK_ACTIONS,DEFENCE_ACTIONS, G, player )

ATTACKER = 1;
DEFENDER = 2;

ACTIONS = DEFENCE_ACTIONS;

DEF_length = length(DEFENCE_ACTIONS(:,1));
ATT_length = length(ATTACK_ACTIONS(:,1));

REWARD_COMBINATIONS = nan(DEF_length,ATT_length,1);
state_reward = getStateScore(G)





end


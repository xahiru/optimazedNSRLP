function [ reward ] = rewardFunc(state, node, action, cost ,player)

% rewardFunc(G,n,[2,s_actionIndex(p)], virus_removal_cost,player);
           

state2 = state;
ATTACKER =1;
DEFENDER =2;
SERVICE =1;
VIRUS = 2;
DATA = 3;

if(action(1) ==  SERVICE) 
    if player == ATTACKER
        state2.Nodes.Services(node,action(2)) = 0;
    end
    
    if player == DEFENDER
        state2.Nodes.Services(node,action(2)) = 1;
    end
end

if(action(1) ==  VIRUS) 
    if player == ATTACKER
        state2.Nodes.Infected(node,action(2)) = 1;
    end
    
    if player == DEFENDER
        state2.Nodes.Infected(node,action(2)) = 0;
    end
end

if(action(1) ==  DATA) 
    if player == ATTACKER
        state2.Nodes.DataCompromised(node,action(2)) = 0;
    end
end

score1 = getStateScore(state);

score2 = getStateScore(state2);

reward = score2-score1;


 if player == ATTACKER
        reward(3) = score2(3) + cost;
 end

if player == DEFENDER
         reward(3) = cost;
% cost

end

end

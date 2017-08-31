%%
% This is the main RL entry

%% Game initialization
% clear all;
numberOfNodes = 5;
gameRounds = 25;

AttackerPoints = 500;
DeffenderPoints = 500;

DEFENDER =2;
ATTACKER =1;

service_cost = 12;
virus_install_cost = 24;
virus_removal_cost = 12; %cost of removal should be the opposite of stealing data + installing virus
steal_data_cost = 8;

cost_vector = [service_cost,virus_install_cost,virus_removal_cost,steal_data_cost];  

% services_lable = {'http', 'ftp', 'dns','ntp', 'telnet'};
services_lable = {'http', 'ftp', 'dns'};


dataState = 1;
virusState = 1;

points = (1:2);
points(1,1) = AttackerPoints;
points(1,2) = DeffenderPoints;

serviceIndexLegth = length(services_lable);
virusStatColIndex = serviceIndexLegth+virusState;
dataStateColIndex = virusStatColIndex+dataState;




GTwo = zeros(numberOfNodes,dataStateColIndex);
GTwo(:,dataStateColIndex) = ones(length(GTwo(1,:)),1);

learnRate = 0.8;

epsilon = 0.3;


discount = 0.8; % When assessing the value of a state & action, how important is the value of the future states?



clear A nodes dataState virusState
%% Test
tic
% A_VALID_ACTIONS = getValidActions(G,numberOfNodes,serviceIndexLegth,virusStatColIndex,dataStateColIndex, ATTACKER,points(ATTACKER),cost_vector);
AB_VALID_ACTIONS = getValidActionTwo(GTwo,numberOfNodes,serviceIndexLegth,virusStatColIndex,dataStateColIndex, ATTACKER,points(ATTACKER))
DB_VALID_ACTIONS = getValidActionTwo(GTwo,numberOfNodes,serviceIndexLegth,virusStatColIndex,dataStateColIndex, DEFENDER,points(DEFENDER))

% length(B_VALID_ACTIONS)
toc

%% Tets2
tic
 ACTIONS  = getParetoFrontsTwo( AB_VALID_ACTIONS,DB_VALID_ACTIONS, GTwo, DEFENDER )
toc
%% Do Qlearning

%
% Create a Q-table
points(ATTACKER) = AttackerPoints;
points(DEFENDER) = DeffenderPoints;


graphData = zeros(gameRounds,3,3,5); %gameRound, reward vector length, three tyeps of test (n), 5 loops 
   


 tic
for m = 1 : 2
    
    for n = 1: 3
        %n = 1  normal (Pareto and Qlearning)
        %n = 2 onlyQlearning with Random
        %n = 3 complete Random
        % Create a Q-table
        
        points(ATTACKER) = AttackerPoints;
        points(DEFENDER) = DeffenderPoints;
        QTABLE = cell(int16(gameRounds * 2 * points(ATTACKER) / service_cost) ,4); %4 dim
        qTableSize = size(QTABLE,1);      
    
        
     for o = 1 : gameRounds

        % reset points
        points(ATTACKER) = AttackerPoints;
        points(DEFENDER) = DeffenderPoints;
        cumulative_game_reward = [0, 0, 0];
        G1 = GTwo;

        % Get valid action
        A_VALID_ACTIONS = getValidActions(G1,ATTACKER,points(ATTACKER),cost_vector);
        D_VALID_ACTIONS = getValidActions(G1,DEFENDER,points(DEFENDER), cost_vector);

        while (~isempty(A_VALID_ACTIONS) && ~isempty(D_VALID_ACTIONS) )

            % Get Pareto Fronts
            A_PARETO_ACTIONS = A_VALID_ACTIONS;
            D_PARETO_ACTIONS = D_VALID_ACTIONS;
            % A_PARETO_ACTIONS = getParetoFronts(D_VALID_ACTIONS, A_VALID_ACTIONS, G1, ATTACKER);
            if n == 1
                D_PARETO_ACTIONS = getParetoFronts(A_VALID_ACTIONS, D_VALID_ACTIONS, G1, DEFENDER);
            end
            % Choose Actions
            A_ACTION = [randi(length(A_PARETO_ACTIONS(:,1))), 0]; 
            
            if n == 2 || n ==3
                D_ACTION = [randi(length(D_PARETO_ACTIONS(:,1))), 0];
            end
            % A_ACTION = getQTableAction(G1, A_PARETO_ACTIONS, ATTACKER, QTABLE);    
            if n == 1 || n == 2
                D_ACTION = getQTableAction(G1, D_PARETO_ACTIONS, DEFENDER, QTABLE, qTableSize,epsilon);
            end
            % Update the Game state
            G2 = updateState(G1, A_PARETO_ACTIONS(A_ACTION(1),:), ATTACKER);
            G2 = updateState(G2, D_PARETO_ACTIONS(D_ACTION(1),:), DEFENDER);

            % update points
            maintanance_cost = getStateScore(G2);
            points(ATTACKER) = points(ATTACKER) - getActionCost(A_PARETO_ACTIONS(A_ACTION(1),:), ATTACKER, cost_vector )- maintanance_cost(3);
            points(DEFENDER) = points(DEFENDER) - getActionCost(D_PARETO_ACTIONS(D_ACTION(1),:), DEFENDER, cost_vector );

            % add the state transition reward to the cumulative game reward
            transition_reward = getTransitionReward(G2, A_PARETO_ACTIONS(A_ACTION(1),:), D_PARETO_ACTIONS(D_ACTION(1),:), cost_vector );        
    %         transition_reward = rewardFunc(G1,D_PARETO_ACTIONS{D_ACTION(1),1}, D_PARETO_ACTIONS{D_ACTION(1),2} , getActionCost(D_PARETO_ACTIONS(D_ACTION(1),:), 2, cost_vector), DEFENDER);


            cumulative_game_reward = cumulative_game_reward + transition_reward;

            % Get valid action
            A_VALID_ACTIONS = getValidActions(G2, ATTACKER,points(ATTACKER),cost_vector);
            D_VALID_ACTIONS = getValidActions(G2, DEFENDER,points(DEFENDER), cost_vector);
            
            if n == 1 || n == 2
                QTABLE =  updateQValue(G1,G2,D_ACTION(2),D_PARETO_ACTIONS(D_ACTION(1),:),transition_reward, QTABLE, qTableSize, learnRate, discount, D_VALID_ACTIONS,DEFENDER); 
            end
            G1 = G2;


        end


        graphData(o,:,n,m) = cumulative_game_reward;
        % REWARD_VECTOR(n) = cumulative_game_reward; 
     end
     
   end
end
toc
%% Plots

% figure1 = plot(graphData(:,:,1,1));

plot(graphData(:,:,1,1));

% fitobject = fit(graphData(:,1),find(graphData(:,1)) ,'poly2');

% plot(f,graphData(:,1),find(graphData(:,1)));

% Y = Graphdata2(:,1,3)
% % X = [1:25;]




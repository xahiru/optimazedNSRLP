function [ ACTIONS ] = getParetoFronts( ATTACK_ACTIONS,DEFENCE_ACTIONS, G, player )
%GETPARETOFRONTS Summary of this function goes here
%   Detailed explanation goes here

ATTACKER = 1;
DEFENDER = 2;

ACTIONS = DEFENCE_ACTIONS;


COMBINED_REWARD = cell(length(DEFENCE_ACTIONS),length(ATTACK_ACTIONS),1);
state_reward = getStateScore(G);
state_reward(3) = 0;


for n = 1: size(DEFENCE_ACTIONS,1)
    
    for m = 1: size(ATTACK_ACTIONS,1)
        
         temp_attack = ATTACK_ACTIONS{m,3};
         temp_def = DEFENCE_ACTIONS{n,3};

        if (player == ATTACKER) 
             temp_attack = DEFENCE_ACTIONS{n,3};
             temp_def = ATTACK_ACTIONS{m,3};
        end

         if (~isempty(temp_attack) && ~isempty(temp_def));
         temp_reward = state_reward + temp_def + temp_attack;
         temp_reward(3) = temp_attack(3) - temp_def(3);
             
         COMBINED_REWARD{n,m, 1} = temp_reward;
         COMBINED_REWARD{n,m, 2} = 1;
         
         end
        

    end
end

for n = 1: size(DEFENCE_ACTIONS,1)
    
    for m = 1: size(ATTACK_ACTIONS,1)

        for o = 1: size(ATTACK_ACTIONS,1)

               current_reward = COMBINED_REWARD{n,m,1};
               alt_reward = COMBINED_REWARD{n,o,1};

              if(player == DEFENDER)
                if(length(find(current_reward >= alt_reward)) == length(current_reward) && length(find(current_reward > alt_reward)))
                   COMBINED_REWARD{n, m , 2} = 0;
                   break;
                end
              end
              
              if(player == ATTACKER)
                if(length(find(current_reward <= alt_reward)) == length(current_reward) && length(find(current_reward < alt_reward)))
                   COMBINED_REWARD{n, m , 2} = 0;
                   break;
                end
              end
        end
     end
end
 

for d1 =1:  size(DEFENCE_ACTIONS,1)

    for d2 = 1: size(DEFENCE_ACTIONS,1)

        if (d1 ~= d2 ) 

            for a2 = 1: size(ATTACK_ACTIONS,1)
                
                dominated = 0;

                if ( COMBINED_REWARD{d2, a2 , 2} == 1 )
                    dominated = 1;

                    for a1 = 1: size(ATTACK_ACTIONS,1)

                         if(COMBINED_REWARD{d1, a1 , 2} == 1)
          
                             current_reward = COMBINED_REWARD{d2,a2,1};
                             alt_reward = COMBINED_REWARD{d1,a1,1};
                             
                             if(player == DEFENDER)
                                 if(~(length(find(current_reward >= alt_reward)) == length(current_reward) && length(find(current_reward > alt_reward))))
                                    dominated = 0;

                                 end
                             end
                             
                             if(player == ATTACKER)
                                 if(~(length(find(current_reward <= alt_reward)) == length(current_reward) && length(find(current_reward < alt_reward))))
                                    dominated = 0;

                                 end
                             end
                             
                             
                         end
                       
                    end
                end

                if( dominated )
                    % remove current defense  
                    ACTIONS{d1,1} = 0;
                    break;
                end
            end

%             if (dominated )
%                 break;
%             end 
        end 
     end
end

ACTIONS(cellfun(@(x)x==0, ACTIONS(:,1)),:) = [];



end


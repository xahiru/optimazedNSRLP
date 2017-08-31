function [ ACTIONS ] = getParetoFrontsTwo( ATTACK_ACTIONS,DEFENCE_ACTIONS, G, player )

ATTACKER = 1;
DEFENDER = 2;

ACTIONS = DEFENCE_ACTIONS;

DEF_length = length(DEFENCE_ACTIONS(:,1));
ATT_length = length(ATTACK_ACTIONS(:,1));

COMBINED_REWARD = nan(DEF_length,ATT_length,3,1);
state_reward = getStateScoreTwo(G,3,4,5,player)

for n = 1: DEF_length   
    for m = 1: ATT_length
         temp_attack = ATTACK_ACTIONS(m,5:7);
         temp_def = DEFENCE_ACTIONS(n,5:7);

        if (player == ATTACKER) 
             temp_attack = DEFENCE_ACTIONS(n,5:7);
             temp_def = ATTACK_ACTIONS(m,5:7);
        end
        
         if (~isempty(temp_attack) && ~isempty(temp_def));
         temp_reward = state_reward + temp_def + temp_attack;
         temp_reward(3) = temp_attack(3) - temp_def(3);
             
         COMBINED_REWARD(n,m, 1:3,1) = temp_reward;
         COMBINED_REWARD(n,m, :,2) = 1; %just using one dim of 3
         end
        
    end
end


for n = 1: DEF_length
    
    for m = 1: ATT_length

        for o = 1: ATT_length
            if(m ~= o)
            
                   current_reward = COMBINED_REWARD(n,m,:,1);
                   alt_reward = COMBINED_REWARD(n,o,:,1);

                  if(player == DEFENDER)
                        if(length(find(current_reward >= alt_reward)) == length(current_reward) && length(find(current_reward > alt_reward)))
                           COMBINED_REWARD(n, m ,:, 2) = 0;
                           break;
                        end
                  end

                  if(player == ATTACKER)
                        if(length(find(current_reward <= alt_reward)) == length(current_reward) && length(find(current_reward < alt_reward)))
                           COMBINED_REWARD(n, m ,:, 2) = 0;
                           break;
                        end
                  end
            end
        end
     end
end


for d1 =1:  DEF_length

    for d2 = 1: DEF_length
        if (d1 ~= d2 ) 
            
            for a2 = 1: ATT_length
                
                dominated = 0;

                if ( COMBINED_REWARD(d2, a2 ,1, 2) == 1 )
                    dominated = 1;

                    for a1 = 1: ATT_length

                         if(COMBINED_REWARD(d1, a1 ,1, 2) == 1)
          
                             current_reward = COMBINED_REWARD(d2,a2,:,1);
                             alt_reward = COMBINED_REWARD(d1,a1,:,1);
                             
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
                    ACTIONS(d1,:) = nan;
                    break;
                end
            end

%             if (dominated )
%                 break;
%             end 
        end 
     end
end



end


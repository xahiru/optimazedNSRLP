function [ QTABLE] = updateQValue(G1,G2,QValueIndex,ACTION, transition_reward, QTABLE, qTableSize, learnRate, discount, VALID_ACTIONS, player)
    

    if ~isempty(VALID_ACTIONS)
        
        maxQAIndex = getQTableAction(G2,VALID_ACTIONS,player,QTABLE,qTableSize, 0); %epsilon =0
        maxQA = [0,0,0];
        if maxQAIndex(2) ~= 0
            maxQA = QTABLE{maxQAIndex(2),4};
        end
            
        if(QValueIndex == 0)
            QValueIndex = find(cellfun(@isempty,QTABLE),1);
            QTABLE{QValueIndex,1} = G1;
            QTABLE{QValueIndex,2} = [ACTION{1},ACTION{1,2}];
            QTABLE{QValueIndex,3} = player;
            QTABLE{QValueIndex,4} = [0, 0, 0];
            
        end
       
        
        QTABLE{QValueIndex,4} = QTABLE{QValueIndex,4} + learnRate * (transition_reward + discount * maxQA - QTABLE{QValueIndex,4});
        

    end

end


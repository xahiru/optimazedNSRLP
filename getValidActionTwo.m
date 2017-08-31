function [ ACTIONS ] = getValidActionTwo(G,numberOfNodes,serviceIndexLength, virusStatColIndex, dataStateColIndex, player, points)



service_cost = 12;
virus_install_cost = 24;
virus_removal_cost = 12; %cost of removal should be the opposite of stealing data + installing virus
steal_data_cost = 8;

service_weight = [1,5,20];
data_weight = [2, 10];

%store node sevice index
ATTACKER = 1;
DEFENDER = 2;

if player == ATTACKER
    
    ACTIONS = nan(length(find(G(:,virusStatColIndex) & G(:,dataStateColIndex)))+ length(find(~G(:,virusStatColIndex)))+length(find(G(:,1:serviceIndexLength))),7);
    
    
    actionsIndex = 1;

    for n = 1:3
        G_Copy = G;
        switch n
            case 1 %service
                [row,col] =  find(G(:,1:serviceIndexLength));
                 if (points >= service_cost && ~isempty(col))
                     
                        % new matrix
                        endIndex = length(col);
                        ACTIONS(actionsIndex:endIndex,1:2) =  [row,col];
                        ACTIONS(actionsIndex:endIndex,3) = 1;
                        ACTIONS(actionsIndex:endIndex,6) =  0;
                        maintanance_cost_deff_n_cost =  1 + service_cost;
                        ACTIONS(actionsIndex: endIndex,7) = maintanance_cost_deff_n_cost;
                        
                         
                         link_weight_diff = 0;
                         
%                          maintanance_cost = length(find(~G(:,1:serviceIndexLength))) + length(find(G(:,virusStatColIndex)));
%                          ACTIONS(actionsIndex: endIndex,7) = maintanance_cost + service_cost
%                         ACTIONS(actionsIndex: endIndex,7) =  length(find(~G(:,1:serviceIndexLength))) + length(find(G(:,virusStatColIndex))) + service_cost;
                         
                        
                        for m = 1: length(col)
                            G_Copy = G;
                            G_Copy(row(m),col(m)) = 0;
                            ns = length(find(G_Copy(:,col(m))));
                            link = (ns * (ns-1))/2 ;
                            if(link)
                              link_weight_diff = link * service_weight(col(m));
                            else
                               link_weight_diff = 0;
                            end
                            
                             ACTIONS(m,4) = col(m);
                             ACTIONS(m,5) = link_weight_diff;
                             
                         
                        end
                        
                        actionsIndex = actionsIndex+endIndex;
                        
               end
                
            case 2 %virus
                
%                 maintanance_cost = length(find(~G(:,1:serviceIndexLength))) + length(find(G(:,virusStatColIndex)));
                
%                     maintanance_cost_deff = 1
                    row = find(~G(:,virusStatColIndex))
                    endIndex = actionsIndex+length(row)-1
                     if (points >= virus_install_cost && ~isempty(row))
                         
                        ACTIONS(actionsIndex:endIndex,1) =  row; 
                        ACTIONS(actionsIndex:endIndex,2) =  virusStatColIndex;
                        ACTIONS(actionsIndex:endIndex,3) = 2;
                        ACTIONS(actionsIndex:endIndex,4) = 1;
                        ACTIONS(actionsIndex:endIndex,5) = 0;%link_weight_diff
                        ACTIONS(actionsIndex:endIndex,6) =  data_weight(1);%diff
%                         ACTIONS(actionsIndex:endIndex,7) = maintanance_cost + virus_install_cost;
                        maintanance_cost_deff_n_cost = 1 + virus_install_cost;
                        ACTIONS(actionsIndex: endIndex,7) =maintanance_cost_deff_n_cost;
                     end
                     actionsIndex = endIndex+1;
                
            case 3 %data
                row =  find(G(:,virusStatColIndex) & G(:,dataStateColIndex));
                endIndex = actionsIndex+length(row)-1;
                if (points >= steal_data_cost && ~isempty(row))
                    ACTIONS(actionsIndex:endIndex,1) =  row;
                    ACTIONS(actionsIndex:endIndex,2) = dataStateColIndex;
                        ACTIONS(actionsIndex:endIndex,3) = 3;
                        ACTIONS(actionsIndex:endIndex,4) = 1;
                        ACTIONS(actionsIndex:endIndex,5) = 0;%link_weight_diff
                        ACTIONS(actionsIndex:endIndex,6) =  data_weight(2);%diff
%                         ACTIONS(actionsIndex:endIndex,7) = maintanance_cost + virus_install_cost;
                        maintanance_cost_deff_n_cost = 1 + steal_data_cost;
                        ACTIONS(actionsIndex: endIndex,7) =maintanance_cost_deff_n_cost; 
                end    
                %actionsIndex = endIndex;
                
        end
    end
end    


if player == DEFENDER
    ACTIONS = nan(length(find(G(:,virusStatColIndex)))+length(find(~G(:,1:serviceIndexLength))),7);
    actionsIndex = 1;
     for n = 1:2
        
        switch n
            case 1 %service
                [row,col] =  find(~G(:,1:serviceIndexLength));
                 if (points >= service_cost && ~isempty(col))
                     
                     
                     
                        % new matrix
                        endIndex = length(col);
                        ACTIONS(actionsIndex:endIndex,1:2) =  [row,col];
                        ACTIONS(actionsIndex:endIndex,3) = 1;
                        
                        
                        ACTIONS(actionsIndex:endIndex,6) =  0 ;
                        ACTIONS(actionsIndex:endIndex,7) = service_cost;
                        link_weight_diff = 0;
                         
                      for m = 1: length(col)
                            G_Copy = G;
                            G_Copy(row(m),col(m)) = 1;
                            ns = length(find(G_Copy(:,col(m)))); 
                            link = (ns * (ns-1))/2 ;
                            if(link)
                              link_weight_diff = link * service_weight(col(m));
                            else
                              link_weight_diff = 0;
                            end
                            
                             ACTIONS(m,4) = col(m);
                             ACTIONS(m,5) = link_weight_diff;
                             
                        end
                        
                        actionsIndex = actionsIndex+endIndex;
               end
                
            case 2 %virus
                
%                 maintanance_cost = length(find(~G(:,1:serviceIndexLength))) + length(find(G(:,virusStatColIndex)));
                      
                    row = find(G(:,virusStatColIndex));
                    endIndex = actionsIndex+length(row)-1;
                    if (points >= virus_removal_cost && ~isempty(row))
                        ACTIONS(actionsIndex:endIndex,1) =  row; 
                        ACTIONS(actionsIndex:endIndex,2) =  virusStatColIndex;
                        ACTIONS(actionsIndex:endIndex,3) = 2;
                        ACTIONS(actionsIndex:endIndex,4) = 1;
                        ACTIONS(actionsIndex:endIndex,5) = 0;%link_weight_diff
                        ACTIONS(actionsIndex:endIndex,6) =  data_weight(1);
                        ACTIONS(actionsIndex:endIndex,7) =  virus_install_cost;
                        
                    end
              
        end
    
    end

end


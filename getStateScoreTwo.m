function [ score ] = getStateScoreTwo( G, serviceIndexLength, virusStatColIndex, dataStateColIndex,player)

service_weight = [1,5,20];
data_weight = [2, 10];


maintanance_cost =0;

service_links2 = 0;

if player == 1 % ATTACKER = 1;
    maintanance_cost = length(find(~G(:,1:serviceIndexLength))) + length(find(G(:,virusStatColIndex)));

end
  
  [row,col] =  find(G(:,1:serviceIndexLength));
  col = unique(col);
  
  for n = 1:(length(col))
          
          ns = length(find(G(:,n(1))));
          link = (ns * (ns-1))/2 ;
          if(link)
              
             linkweight = link * service_weight(col(n));
            service_links2 = service_links2 + linkweight;
          end
  end
    
    secure = length(find(~G(:,virusStatColIndex))) * data_weight(1) + length(find(G(:,dataStateColIndex))) * data_weight (2); 
    score = [service_links2,secure,maintanance_cost];
    

end


function [ score ] = getStateScoreTwo( G, serviceIndexLength, virusStatColIndex, dataStateColIndex,player)
%GETSTATESCORE Summary of this function goes here
%   Detailed explanation goes here

service_weight = [1,5,20];
data_weight = [2, 10];
% cols = G(:,1:serviceIndexLength); probably a mistake for not condition
% player

ATTACKER = 1;


maintanance_cost =0;

service_links2 = 0;

if player == ATTACKER
    maintanance_cost = length(find(~G(:,1:serviceIndexLength))) + length(find(G(:,virusStatColIndex)));
    G = ~G;
%    cols = ~G(:,1:serviceIndexLength);
% else

%    cols = G(:,1:serviceIndexLength);
    
end
  
  
  [row,col] =  find(G(:,1:serviceIndexLength));
  col = unique(col);
  
  for n = 1:(length(col))
          %get the number of running services 
          ns = length(find(G(:,n(1))));
          link = (ns * (ns-1))/2 ;
          if(link)
%              link = link * service_weight(n);
             linkweight = link * service_weight(col(n));
            
%            total_service1_cost = total_service1_cost + service_cost(n)
            service_links2 = service_links2 + linkweight;
          end
  end
    
    
    secure = length(find(~G(:,virusStatColIndex))) * data_weight(1) + length(find(G(:,dataStateColIndex))) * data_weight (2); 
    
    score = [service_links2,secure,maintanance_cost];
    

end


function output = k_means_cluster(training_file,K,iteration)

input_file = training_file;

inputData=load(input_file);
k = K;
iterations = iteration;
import java.util.HashMap;
newMap = java.util.HashMap;
import java.util.ArrayList;
newlist = java.util.ArrayList;


[r,c] = size(inputData);

modval = mod(r,k);
xr = 0;

R = randperm(r);

for ki = 1:k
    
    if ki==k
        
        rows = floor(r/k) + modval;
    else
         rows = floor(r/k);
    end
    
    
    columns = c-1;
    
    S = zeros(rows,c-1);
    
    o = xr+1;
    p = xr+rows;
    
    for ri = o:p
        
           newlist.add(inputData(R(ri),:));  
        
    end
    
    newMap.put(ki,newlist);
    newlist = java.util.ArrayList;
    xr = ri;
    
end

for i = 1 : iterations+1
    
meanarr = zeros(k,c-1);

for s = 1:k
newList = newMap.get(s);
sd   = newList.size();
S = zeros(sd,c-1);

%Populate data in S matrix
for e = 0:sd-1   
    n= newList.get(e);
    for l = 1:c-1
        S(e+1,l) = n(l,1);
    end
end

%Calculate mean and store in Mean Array
for cr = 1 : c-1
m = S(:,cr);
meanarr_val = mean(m);
meanarr(s,cr) = meanarr_val;
end

end

%Calculate Error
sum_fin = 0;
for ki = 1:k
    
    list = newMap.get(ki);
     sum_v = 0;
     
    for v = 0:list.size()-1
        
        m = list.get(v);       
        sum_in = 0;
        for cv = 1:c-1
           sum_in =  sum_in + (m(cv,1)-meanarr(ki,cv)).^2;
        end
        sum_in = sqrt(sum_in);
        sum_v = sum_v + sum_in;
        
    end
    
    sum_fin = sum_v + sum_fin;
    
end

%To update clusters

%Create a new map with empty lists
newMapTemp = java.util.HashMap;
newlist = java.util.ArrayList;

%Calculate ecludean distance and take the shortes one

       for ri = 1:r 
    
        cluster_no = 0;
        min_val = intmax;
        %To compute ecludean distance between three means and find lowest
         for ck = 1:k
             sum_ck = 0;
             for cj = 1:c-1
                 
                sum_ck = sum_ck + (inputData(ri,cj)- meanarr(ck,cj)).^2;
             
             end
             
             sum_ck = sqrt(sum_ck);
             if(min_val>sum_ck)
                min_val = sum_ck;
                cluster_no = ck;
             end
             
         end
        
         if newMapTemp.containsKey(cluster_no)
         newlistTemp = newMapTemp.get(cluster_no);
         newlistTemp.add(inputData(ri,:));  
         newMapTemp.put(cluster_no,newlistTemp);
         else
           newlistTemp = java.util.ArrayList;
           newlistTemp.add(inputData(ri,:));
           newMapTemp.put(cluster_no,newlistTemp);
         end
         
       end

newMap = newMapTemp;

if i==1
    fprintf('After initialization: error = %.4f\n',sum_fin);
else
     fprintf('After iteration %d: error = %.4f\n',i-1,sum_fin);
end

end

end

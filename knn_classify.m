function output = knn_classify(trainingFile,testFile,kval)
training_file = trainingFile;
test_file = testFile;
k = kval;
%training_file = 'pendigits_training.txt';
%test_file = 'pendigits_test.txt';
%k = 3;
%Loading the input files
trainingData = load(training_file);
testData = load(test_file);
 
%Finding the size of inout files
[r,c] = size(trainingData);
[rt,ct] = size(testData);
 
%Excluding the last column, which is class
inTrainingData = trainingData(:,1:c-1);
inTestData = testData(:,1:ct-1);

%Finding the mean and std of training data
meanVector = mean(inTrainingData);
 
stdVecotr = zeros(1,c-1);
 
for n = 1:c-1
    meanval = meanVector(1,n);  
    sum = 0;
        for m =  1:r
          sum = sum+((inTrainingData(m,n)-meanval)*(inTrainingData(m,n)-meanval));                
        end        
      stdVecotr(1,n) = sqrt((1/r)*(sum));  
end
 
 
% Normalizing training Data
 for m =  1:r
     for n = 1:c-1
         
      inTrainingData(m,n) =  (inTrainingData(m,n)-meanVector(1,n))/(stdVecotr(1,n));
         
     end    
 end
 
 
 
 
 
% Normalizing test Data
 for m =  1:rt
     for n = 1:ct-1
         
      inTestData(m,n) =  (inTestData(m,n)-meanVector(1,n))/(stdVecotr(1,n));
         
     end    
 end
 
 %Calculating Ecludean Distance for every test data over all training data 
 clRt  =  zeros(rt,1);


for n = 1:rt
   distVectorR  =  zeros(r,1);
   for m = 1:r
       %Finding the ecludean distance between one test object and many
       %training samples
          sum = 0;
          for l = 1:c-1
            sum = sum + ((inTestData(n,l) - inTrainingData(m,l))*(inTestData(n,l) - inTrainingData(m,l)));
          end
          distVectorR(m) =  sqrt(sum); 
   end 
   
 if k==1 
     minVal = min(distVectorR(:));
     count = 0.0; 
     flag = 0;
     indx = 0;
     
     for o = 1:r 
         
         if distVectorR(o,1) == minVal
             
             count = count+1;  
             indx = o;
             
             if trainingData(o,c) == testData(n,ct)        
             flag = 1;
             end
         end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
     end
     
     if flag == 1
         clRt(n) = 1.0/count;
     else
         clRt(n) = 0.0;
     end

     fprintf('ID=%5d, predicted=%3d, true=%3d, accuracy=%4.2f\n', n-1, trainingData(indx,c), testData(n,ct), clRt(n));


 else
     count = 0.0; 
     flag = 0;
     indx = 0;
 distVectorRSort = sort(distVectorR);
 distVectorRSortk = distVectorRSort(1:k);
 
 import java.util.HashMap
 newMap = java.util.HashMap;
    
 for kv = 1:k

     [tf, index] = ismember(distVectorRSort(kv), distVectorR);
       
    if newMap.containsKey(trainingData(index,c))
       val = newMap.get(trainingData(index,c));
       newMap.put(trainingData(index,c),val+1);
    else
        newMap.put(trainingData(index,c),1);
    end
    
 end
     maxVal = 0;
     % To find the maximum value
     for h = 1 : newMap.size()
         val = newMap.keySet().toArray();
         valv  = val(h);
        if maxVal <= newMap.get(valv) 
           maxVal = newMap.get(valv);
        end
     end
     
     for h = 1 : newMap.size()
        val = newMap.keySet().toArray();
        valv  = val(h);
         if newMap.get(valv) == maxVal
             count = count+1;
             predicted_class = val(h);
             if val(h) == testData(n,ct)
                 flag = 1;
             end
         end
         
     end
     if flag == 1
         clRt(n) = 1.0/count;
     else
         clRt(n) = 0.0;
     end

   fprintf('ID=%5d, predicted=%3d, true=%3d, accuracy=%4.2f\n', n-1, predicted_class, testData(n,ct), clRt(n));

 end

end


S = 0;
for s = 1:rt
S = S + clRt(s);
end

fprintf('classification accuracy=%6.4f\n', (S)/rt);

end
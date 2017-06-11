function output = neural_network(ftraining_file,ftest_file,flayers,funits_per_layer,frounds)

test_file = ftest_file;

training_file = ftraining_file;

layers = flayers;

units_per_layer = funits_per_layer;

rounds = frounds;


%Loading training file

inputData = load(training_file);

 

%Calculating size of input file

[r,c] = size(inputData);

 

%True Class 

k = inputData(:,c);

unique_class = unique(k);

no_of_classes = numel(unique(k));

 

 
%Calculating U

U = c+((layers-2)*units_per_layer)+no_of_classes;

 

%Initializing T

tn = zeros(r,U);

for tr = 1:r  
    in = k(tr);
    tn(tr , c+find(unique_class == in)+((layers-2)*units_per_layer)) = 1;

end

 

%adding the bias input and removing last column in input data

xn = zeros(r,c);

 

%To calculate the normalized input

normalizedInputData = inputData(:,1:c-1);

maxval = max(max(normalizedInputData));

 

normalizedData = inputData(:,1:c-1);

 

[nr,nc] = size(normalizedData);

 

for nir = 1:nr

    for nic = 1:nc

        normalizedData(nir,nic) =  normalizedData(nir,nic)/maxval;

    end

end

 

for xr = 1:r

    for xc = 1:c

        

        if xc ==1

        xn(xr,xc) = 1;

      

        else

        xn(xr,xc) =  normalizedData(xr,xc-1);

        end

        

    end    

end

 

%Initializing the weights to random numbers between 

rmin=-.05;

rmax= 0.05;

 

wsize = U;

%rand('seed',100);

%w=ones(wsize,wsize)*0.0315;

w=rmin+rand(wsize,wsize)*(rmax-rmin);

%w = zeros(wsize,wsize);

wold = w;

 
 

%Iterate over number of rounds and repeat steps 4,5 and 6

learning_rate = 1;
 Error = 0;
 threshold = -1;
 
for rn = 1:rounds

    esum = 0;
    %Step 4,5 and 6 - For every row
   
    old_error = Error;
    
    for n = 1:r

    %Initializing Z

    z = zeros(1,U); 


    %Update the input layer, set inputs equal to xn


        for j = 1:c
       
        z(j) = xn(n,j);

        end

        

        %Creating an array a, which will store, for every

        % perceptron Pj, the weighted sum of the inputs of Pj

        a = zeros(1,U); 

        

        %Calculatung A and Z

        if layers>2 

            aa = c+1;

            bb = c+units_per_layer;

            

        for L = 2:layers

            

            if L == 2

                for pj = aa:bb     
                       
                    sum = 0;

                    for i = 1 : aa-1

                       sum = sum + (w(pj,i)*z(i));

                    end

                    a(1,pj) = sum;

                    z(1,pj) = 1/(1+exp(-a(1,pj)));

                end

                

                

            elseif L == layers
     

                aa = U-no_of_classes+1;

                bb = U;

                for pj = aa:bb

                  

                   sum = w(pj,1)*z(1);

                   for i = preva : prevb

                   sum = sum + (w(pj,i)*z(i));

                    

                   end   

                   a(1,pj) = sum;

                   z(1,pj) = 1/(1+exp(-a(1,pj)));

                   

                    

                end 

                

            else                 

              for pj = aa:bb

                

                  sum = w(pj,1)*z(1);

                  for i = preva : prevb

                      sum = sum + (w(pj,i)*z(i));

                  end   

                   a(1,pj) = sum;

                   z(1,pj) = 1/(1+exp(-a(1,pj)));  

                   

              end 

             

            end

            preva = aa; 

            prevb = bb;

            

            aa = aa+units_per_layer; 

            bb = bb+units_per_layer;

            

            end

        else


            % For layers equal to 2

            aa = c+1;

            bb = U;

              for pj = aa:bb
                   
                   sum = 0;

                   for i = 1 : c

                   sum = sum + (w(pj,i)*z(1,i));

                  end   

                   a(1,pj) = sum;

                   z(1,pj) = 1/(1+exp(-a(1,pj)));

               end    

          

        end

        

          %Updating Weights for weights in output layer

          delta = zeros(1,U);
      

          if layers>2
            
              for oj = U-no_of_classes +1 : U

              delta(1,oj) = (z(oj) - tn(n,oj)) * z(oj) * (1-z(oj));

           

             % This is for bias input in the L-1 layer 

             w(oj,1) = w(oj,1) - (learning_rate * delta(1,oj)*z(1));

             

            for pi = U-no_of_classes-units_per_layer+1:U-no_of_classes 

                
              w(oj,pi) = w(oj,pi) - (learning_rate * delta(1,oj)*z(1,pi));

             

            end  

          end   

          end

          if layers == 2
            
            % For  layers = 2

           for oj = c+1 : U

              delta(1,oj) = (z(1,oj) - tn(n,oj)) * z(1,oj) * (1-z(1,oj));          

             % This is for bias input in the L-1 layer 

             %w(oj,1) = w(oj,1) - (learning_rate * delta(oj)*z(1));
           

            for pi = 1:c 

           
              w(oj,pi) = w(oj,pi) - (learning_rate * delta(1,oj)*z(1,pi));
             

            end  

          end

          end

          % For Hidden Layers, this is required only when layers>2

          if layers>2

             %For l=L-1 to 2

                 aa = U-no_of_classes-units_per_layer+1;

                 bb = U-no_of_classes; 
            

                 k =layers-1;

              for L = k:-1:2  
                    
                  if(L==2)

                  ai = 1;

                  bi = c;

                  else

                  ai = aa-units_per_layer;

                  bi = bb-units_per_layer;

                  end    

                  %For each perceptron Pj in layer l

                  for pj= aa:bb

                     %To update delta  

                      %U is layer L+1  

                      if L == k  

                         ua = U - no_of_classes + 1;

                         ub = U;

                      else


                          ua = prevaa;

                          ub = prevbb;

                      end

                      %To find delta (Iterating over next layer to find sum)

                      sum = 0;

                      for u = ua:ub
                       
                         sum = sum + (delta(1,u)*w(u,pj));

                      end

                      delta(1,pj) = sum * z(pj)*(1- z(pj));

                 

                  

                  % For each perceptron Pi in preceeding layer l-1: To

                  % update weights in layer l

      

                   w(pj,1) = w(pj,1) - (learning_rate * delta(pj) * z(1));


                  for pi= ai:bi                                                  
                     
                    w(pj,pi) = w(pj,pi) - (learning_rate * delta(pj) * z(1,pi));
                   
                  end
                  
                  end  

                  %To find the starting and ending units in previous layer

                  %for next iteration         
                 

                  prevaa = aa;

                  prevbb = bb;


                  aa = aa - units_per_layer;

                  bb = bb - units_per_layer;

              end

          end
          
          % For each xn, summing all perceptrons - to find squared error
          for ej = U-no_of_classes+1 : U
          esum = esum + ((tn(n,ej)-z(ej))*(tn(n,ej)-z(ej)));
          end
       
          Error = Error + esum;
    end 
          Error = 0.5 * Error;
          
          if abs(Error - old_error) < threshold
            break;
          end
        learning_rate = learning_rate * 0.98;



end

 

wnew = w - wold;



%Classification

%Loading training file

inputData = load(test_file);

 

%Calculating size of input file

[r,c] = size(inputData);

 

%Matrix to store results

result = zeros(r,4);

 

%True Class 

k = inputData(:,c);

 

 

%adding the bias input and removing last column in input data

xn = zeros(r,c);

 

%To calculate the normalized input

normalizedInputData = inputData(:,1:c-1);

maxval = max(max(normalizedInputData));

 

normalizedData = inputData(:,1:c-1);

 
[nr,nc] = size(normalizedData);

 

for nir = 1:nr

    for nic = 1:nc

        normalizedData(nir,nic) =  normalizedData(nir,nic)/maxval;

    end

end

 

for xr = 1:r

    for xc = 1:c

        

        if xc ==1

        xn(xr,xc) = 1;

      

        else

        xn(xr,xc) =  normalizedData(xr,xc-1);

        end

        

    end    

end

 

 

    %Step 4,5 and 6 - For every row

    for n = 1:r

    %Initializing Z

    zi = zeros(1,U); 

 

    %Update the input layer, set inputs equal to xn

 

        for j = 1:c
        
        zi(j) = xn(n,j);

        end

        

        %Creating an array a, which will store, for every

        % perceptron Pj, the weighted sum of the inputs of Pj

        a = zeros(1,U); 

        

        %Calculatung A and Z

        if layers>2  

            aa = c+1;

            bb = c+units_per_layer;

            

        for L = 2:layers

            

            if L == 2

                for pj = aa:bb     
              
                    sum = 0;

                    for i = 1 : c

                       sum = sum + (w(pj,i)*zi(i));

                    end

                    a(1,pj) = sum;

                    zi(1,pj) = 1/(1+exp(-a(1,pj)));

                    

                end

                

                

            elseif L == layers

                

                aa = U-no_of_classes+1;

                bb = U;

                for pj = aa:bb 
                   
                   sum = zi(1)*w(pj,1);

                   for i = preva : prevb

                   sum = sum + (w(pj,i)*zi(i));

                  end   

                   a(1,pj) = sum;

                   zi(1,pj) = 1/(1+exp(-a(1,pj)));

                   %disp(zi(1,pj))

                end 

            % For hidden layer    

            else   

              for pj = aa:bb  
               
                  sum = zi(1)*w(pj,1);

                  for i = preva : prevb

                      sum = sum + (w(pj,i)*zi(i));

                  end   

                   a(1,pj) = sum;

                   zi(1,pj) = 1/(1+exp(-a(1,pj)));

                                 

              end 

            end

            preva = aa; 

            prevb = bb;          

            aa = aa+units_per_layer; 

            bb = bb+units_per_layer;

            

        end               

        end

        

        

        if layers ==2          

              % For layers equal to 2

            aa = c+1;

            bb = U;

              for pj = aa:bb
                   
                   sum = 0;

                   for i = 1 : c

                   sum = sum + (w(pj,i)*zi(1,i));

                  end   

                   a(1,pj) = sum;

                   zi(1,pj) = 1/(1+exp(-a(1,pj)));

               end    

               

        end   

        count = 0;

        flag = 0;

        zu = zi(U-no_of_classes+1:U);

        

        maxz = max(zu);

        [q,f] = size(zu);

        for zii = 1:f  

            if zu(zii) == maxz

               predicted = unique_class(zii);

               count = count+1;

              if k(n,1) == unique_class(zii) && flag == 0

                   

                   flag = 1;

               end    

            end  

        end    
        

        if flag ==1

           accuracy = 1/count;

        elseif flag == 0

           accuracy = 0;

        

        end    

        

       result(n,1) =  n-1;

       result(n,2) = predicted;

       result(n,3) =  k(n) ;

       result(n,4) = accuracy;

    end    

    acc_matrix = result(:,4);

    totsum = 0;

    for p = 1 : r

        totsum = totsum+acc_matrix(p);

    end   
  
    clasification_acc =totsum/r;
    
   
    [l,m] = size(result);
    
    for s = 1 : l
    fprintf('ID=%5d, predicted=%3d, true=%3d, accuracy=%4.2f\n', result(s,1),result(s,2),result(s,3),result(s,4));
    end
    
    fprintf('classification accuracy=%6.4f\n',clasification_acc);
end

 

 


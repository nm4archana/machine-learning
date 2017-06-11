function output = pca_power(training_file,test_file,m,iterations) 
%inputData = load('satellite_training.txt');
%inputData_test = load('satellite_test.txt');
inputData=load(training_file);
inputData_test=load(test_file);
M = m;
bk = iterations;
[r,c] = size(inputData);
[rt,rc] = size(inputData_test);

x = zeros(r,M,c-1,1);

input_test_new = inputData_test(:,1:rc-1);


for m = 1:M
  for i = 1:r
    for j = 1:c-1
        x(i,m,j,1) = inputData(i,j);
    end
  end
end


eigenVector = zeros(c-1,M);

S = zeros(c-1,c-1);


newData = inputData;


for d = 1:M

% To find covariance matrix
for i = 1:c-1   
    for j = 1:c-1
        
       meani = mean(newData(:,i)) ;     
       meanj = mean(newData(:,j))  ;    
       sum = 0;
       
       for l = 1:r 
        li = newData(l,i);
        lj = newData(l,j);

         sum = sum+((li-meani)*(lj-meanj));       
       end  
       
       S(i,j) = sum/r;
         
    end   
end

%Finding Ud - using poer method, based on the above covairiance\
%u = ones(c-1,1);
u = rand(c-1,1);

for b = 1:bk

    u = (S * u)/norm(S*u);

end


eigenVector(:,d) = u;


for n = 1:r 
    
    tempVec = squeeze(x(n,d,:));

    x(n,d+1,:) = tempVec - (transpose(u)* tempVec * u);
   
end 

  newData = squeeze(x(:,d+1,:));
  
end
 

for i = 1:M
   fprintf('Eigenvector %d',i);
   for k = 1:c-1
       fprintf('\n %3d: %.4f',k,eigenVector(k,i));
   end 
   fprintf('\n\n');
end

for i = 1:rt
    
    fprintf('Test object %d',i-1);
    
    for m = 1 : M
        k =  transpose(input_test_new(i,:));
        u = eigenVector(:,m);
        val = transpose(u)*k;
        fprintf('\n %3d: %.4f',m,val);
    end
    fprintf('\n\n');
end
end

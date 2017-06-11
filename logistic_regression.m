function output = logistic_regression(training_file,degree,test_file)
inputData = load(training_file);
inputData_test = load(test_file);
[r,c] = size(inputData);
[rtest,ctest] = size(inputData_test);

% T Matrix
t = inputData(:,c);
tt = inputData_test(:,ctest);

for rt = 1:r
    if t(rt) ~= 1
      
        t(rt) = 0;
        
    end
end

for rtt = 1:rtest 
    if tt(rtt) ~= 1
      
        tt(rtt) = 0;
        
    end
end


if degree == 1
%Calculate Phi matrix
phi = zeros(r,c);

for n = 1:r
    phi(n,1) = 1;
    for m = 2:c
        
         phi(n,m) = inputData(n,m-1);
         
    end
end

flag = true;

Y = zeros(r,1);
w = zeros(c,1);


while flag 
cnt = 0;
%Calculate Y Matrix
%For degree 1

for yt = 1:r
        
    %y(x) = sigma(w' * phi(x))
    phix = zeros(c,1);
    phix(1) = 1;
    
    for d = 2:c
        
        phix(d) = inputData(yt,d-1);
     
    end    
   
    A = transpose(w) * phix;
     
    Y(yt) = 1/(1+exp(-A));
    
end

%R Matrix

R = zeros(r,r);

for N = 1:r
 
    R(N,N) = Y(N)*(1-Y(N));
    
end

wnew = w - inv((transpose(phi)*R*phi)) * transpose(phi) * (Y-t);


error = 0;

for n = 1:r 
    
error = error+( (t(n)*log(Y(n))) + ((1-t(n))*log(1-Y(n))));

end

if cnt == 0
    errorOld = error+0.0001;
end

if sumabs(wnew-w)<0.0001 
flag = false;

elseif abs(errorOld-error)<0.000;    
 flag = false;

else
w = wnew;
errorOld = error; 
flag = true;


end


cnt = cnt+1;
end
end


if degree == 2
%For degree 2
%Calculate Phi matrix
phi = zeros(r,((c-1)*2)+1);


for n = 1:r
    phi(n,1) = 1;
    
        k=1;
        
    for m = [2:2:(((c-1)*2)+1)]  

         phi(n,m) = inputData(n,k);
         phi(n,m+1) = inputData(n,k)*inputData(n,k);
        
         k=k+1;
    end
end

flag = true;

Y = zeros(r,1);
w = zeros(((c-1)*2)+1,1);


while flag 
cnt = 0;
%Calculate Y Matrix
%For degree 1

for yt = 1:r
        
    %y(x) = sigma(w' * phi(x))
    phix = zeros(((c-1)*2)+1,1);
    phix(1) = 1;
    
     k = 1;
    for d = [2:2:(((c-1)*2)+1)]  
        
        phix(d) = inputData(yt,k);
        phix(d+1) = inputData(yt,k)*inputData(yt,k);
       
        
      k = k+1;
    end    
   
    A = transpose(w) * phix;
     
    Y(yt) = 1/(1+exp(-A));
    
end

%R Matrix

R = zeros(r,r);

for N = 1:r
 
    R(N,N) = Y(N)*(1-Y(N));
    
end

wnew = w - inv((transpose(phi)*R*phi)) * transpose(phi) * (Y-t);


error = 0;

for n = 1:r 
    
error = error+( (t(n)*log(Y(n))) + ((1-t(n))*log(1-Y(n))));

end

if cnt == 0
    errorOld = error+0.0001;
end

if sumabs(wnew-w)<0.0001 
flag = false;

 elseif abs(errorOld-error)<0.000 
 flag = false;

else
w = wnew;
errorOld = error; 
flag = true;

end

cnt = cnt+1;
end

end


len = length(wnew);
for n = 1:len
 fprintf('w%d=%.4f\n',n-1,wnew(n));
end

%end

% Classification 

% Degree 1
% For degree 1

if degree == 1
PcxtZero = zeros(rtest,1);
PcxtOne = zeros(rtest,1);

for yt = 1:rtest
  
    phixt = zeros(ctest,1);
    phixt(1) = 1;
    
    for d = 2:ctest
        
        phixt(d) = inputData_test(yt,d-1);
     
    end    
   
    Atest = transpose(wnew) * phixt;
     
    PcxtOne(yt) = 1/(1+exp(-Atest));
    
    PcxtZero(yt) = 1-PcxtOne(yt);
  
end

accuracy = 0;
probability = 0;
predicted = 0;


for yt = 1:rtest
    curraccuracy = 0;
     if PcxtZero(yt)==0.5 && PcxtOne(yt)==0.5
     predicted=1;
     curraccuracy = 0.5;
     probability = PcxtZero(yt);
     accuracy = accuracy+0.5;
     end;
     
     if(PcxtZero(yt)>0.5)
     probability = PcxtZero(yt);
     predicted = 0; 
     end
     
     if(PcxtOne(yt)>0.5)
     probability = PcxtZero(yt);
     predicted = 1;
     end
    
     if(PcxtZero(yt)>0.5 && tt(yt)==0)
       curraccuracy = 1;
      accuracy = accuracy+1;
     end
     
      if(PcxtOne(yt)>0.5 && tt(yt)==1)
       curraccuracy = 1;
      accuracy = accuracy+1;
     end
     
  fprintf('ID=%5d, predicted=%3d, probability = %.4f, true=%3d, accuracy=%4.2f\n',yt-1, predicted,probability, tt(yt), curraccuracy);

end 
fprintf('classification accuracy=%6.4f\n', (accuracy/rtest));
end


if degree==2
    
PcxtZero = zeros(rtest,1);
PcxtOne = zeros(rtest,1);

for yt = 1:rtest
  
   phixt = zeros(((ctest-1)*2)+1,1);
   phixt(1) = 1;
     k = 1;
    for d = [2:2:(((ctest-1)*2)+1)]  
        
        phixt(d) = inputData_test(yt,k);
        phixt(d+1) = inputData_test(yt,k)*inputData_test(yt,k);
           
      k = k+1;
    end    
   
    Atest = transpose(wnew) * phixt;
     
    PcxtOne(yt) = 1/(1+exp(-Atest));
    
    PcxtZero(yt) = 1-PcxtOne(yt);
  
end

accuracy = 0;
probability = 0;
predicted = 0;


for yt = 1:rtest
     curraccuracy = 0;
     
     if PcxtZero(yt)==0.5 && PcxtOne(yt)==0.5
     predicted = 1;
     probability = PcxtZero(yt);
     curraccuracy = 0.5;
     accuracy = accuracy+0.5;
     end;
     
     if(PcxtZero(yt)>0.5)
      probability = PcxtZero(yt);
      predicted = 0;
     end
     
     if(PcxtOne(yt)>0.5)
     probability =  PcxtOne(yt);  
     predicted = 1;   
     end
    
     if(PcxtZero(yt)>0.5 && tt(yt)==0)
      curraccuracy = 1;
      accuracy = accuracy+1;
     end
     
      if(PcxtOne(yt)>0.5 && tt(yt)==1)
      curraccuracy = 1;
      accuracy = accuracy+1;
      end  
      fprintf('ID=%5d, predicted=%3d, probability = %.4f, true=%3d, accuracy=%4.2f\n',yt-1, predicted,probability, tt(yt), curraccuracy);

end 
fprintf('classification accuracy=%6.4f\n', (accuracy/rtest));

end

end

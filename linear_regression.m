function output = linear_regression(path,degreeM,lambda)

%Reading input data
inputData = load(path);

%inputs
x = inputData(:,1); 
%outputs
t = inputData(:,2);

%no of training inputs
N = length(x);
M = degreeM+1;

%phi matrix
phi = zeros(N,M);

for r = 1:N   
    for c = 1:M      
        phi(r,c) = phi(r,c)+(x(r)^(c-1));       
    end  
end

%Create Identity Matrix and multiply it with lambda
I = eye(M);

%Find transpose of phi
phiTranspose = transpose(phi);

if lambda==0
  w = inv((phiTranspose*phi))*phiTranspose*t;
else
  w = inv((I*lambda) + (phiTranspose*phi))*phiTranspose*t;
end

if(degreeM==1)
{
fprintf('w0=%.4f\n',w(1));
fprintf('w1=%.4f\n',w(2));
fprintf('w2=%.4f\n',0);
};
else
{
fprintf('w0=%.4f\n',w(1));
fprintf('w1=%.4f\n',w(2));
fprintf('w2=%.4f\n',w(3)); 
};
end

function output = svd_power(data_file,m,iterations) 
inputDataL=load(data_file);
M = m;
bk = iterations;

UData = inputDataL * inputDataL';
[r,c] = size(UData);

x = zeros(r,M,c,1);

for m = 1:M
  for i = 1:r
    for j = 1:c
        x(i,m,j,1) = UData(i,j);
    end
  end
end


U = zeros(c,M);
Sv = zeros(M,M);


% Finding U Vector
S = zeros(c,c);

newData = UData;


for d = 1:M

S = newData;
%Finding Ud - using power method, based on the above covairiance\
u = ones(c,1);
%u = rand(c,1);

for b = 1:bk

    u = (S * u)/norm(S*u);

end


U(:,d) = u;

Sv(d,d) = sqrt(u'*S*u);

for n = 1:r 
    
    tempVec = squeeze(x(n,d,:));

    x(n,d+1,:) = tempVec - (transpose(u)* tempVec * u);
   
end 

  newData = squeeze(x(:,d+1,:));
  
end

%Printing Matrix U
fprintf('Matrix U:\n');
for k = 1:r
    fprintf('Row%3d: ',k);
    for l = 1:M
    fprintf('%8.4f ',U(k,l));
    end
    fprintf('\n');
end 
fprintf('\n');


%Printing Matrix S
fprintf('Matrix S:\n');
for k = 1:M
    fprintf('Row%3d: ',k);
    for l = 1:M
    fprintf('%8.4f ',Sv(k,l));
    end
    fprintf('\n');
end 
fprintf('\n');


% Finding V Vector

VData = inputDataL' * inputDataL;
[r,c] = size(VData);
V = zeros(c,M);
x = zeros(r,M,c,1);

for m = 1:M
  for i = 1:r
    for j = 1:c
        x(i,m,j,1) = VData(i,j);
    end
  end
end

S = zeros(c,c);
newData = VData;


for d = 1:M

S = newData;
%Finding Ud - using power method, based on the above covairiance\
u = ones(c,1);
%u = rand(c,1);

for b = 1:bk

    u = (S * u)/norm(S*u);

end

V(:,d) = u;

for n = 1:r 
    
    tempVec = squeeze(x(n,d,:));

    x(n,d+1,:) = tempVec - (transpose(u)* tempVec * u);
   
end 

  newData = squeeze(x(:,d+1,:));
  
end

%Printing Matrix V
fprintf('Matrix V:\n');
for k = 1:r
    fprintf('Row%3d: ',k);
    for l = 1:M
    fprintf('%8.4f ',V(k,l));
    end
    fprintf('\n');
end 
fprintf('\n');


svd = U*Sv*V';

[r,c] = size(svd);

%Printing Matrix SVD
fprintf('Reconstruction (U*S*V''):\n');
for k = 1:r
    fprintf('Row%3d: ',k);
    for l = 1:c
    fprintf('%8.4f ',svd(k,l));
    end
    fprintf('\n');
end 
fprintf('\n');
end
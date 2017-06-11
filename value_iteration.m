function output = value_iteration(envfile,reward,g,k);
env_file = envfile;
non_terminal_reward = reward;
gamma = g;
no_of_iterations = k;
import java.util.ArrayList;
newList = java.util.ArrayList;

cnt = 0;
fid = fopen(env_file);
tline = fgetl(fid);


while ischar(tline)
     %disp(tline)
    tline_prev= tline;
    tline = fgetl(fid);
   
    cnt=cnt+1;
end

tline_split = strsplit(tline_prev,',');

[rt,ct] = size(tline_split);

U = zeros(cnt,ct);
cn=1;

fid = fopen(env_file);
tline = fgetl(fid);
index_arr = zeros(1,2);

while ischar(tline)
 
   tline_split = strsplit(tline,',');
   
   for i = 1:ct
       if tline_split{1,i} == '.'           
        val = non_terminal_reward;
       elseif tline_split{1,i} == 'X' 
        val = 0;
       else
           val = str2num(tline_split{1,i});
           index_arr(1,1) = cn;
           index_arr(1,2) = i;
           newList.add(index_arr);
           index_arr = zeros(1,2);

       end
        U(cn,i) = val; 
   end
   
    tline = fgetl(fid);
    cn=cn+1;
end

fclose(fid);

[r,c] = size(U);

initial_matrix = U;


for iter = 1:no_of_iterations-1
 
for i = 1:r
    for j = 1:c
      flag = 0;      
          for l = 0:newList.size()-1
             index_arr = newList.get(l);
              if i == index_arr(1,1) && j==index_arr(2,1) || U(i,j) == 0
                  flag = 1;
                  break;
              end
          end
              
        if flag==1
         continue;
        end
        
        
        lefti = i; leftj = j-1;
        upi = i+1; upj = j;
        dwni = i-1; dwnj = j;
        righti = i; rightj = j+1;
        
        %To move left
        %Direction 1  - Left - i,j-1 
        
        %Left
        
        if leftj<=0 || U(lefti,leftj)==0
            val_1 = 0.8 * U(i,j);
            
        else 
             val_1 = 0.8 * U(lefti,leftj);
        end
        
        %Up - i+1,j  
      
        if upi>r || U(upi,upj)==0
            val_2 = 0.1 * U(i,j);
            
        else
            val_2 = 0.1 * U(upi,upj);
            
        end
        
        %Down -  i-1,j
         
         if dwni<=0 || U(dwni,dwnj)==0
             val_3 = 0.1 * U(i,j);
         else
            val_3 = 0.1 * U(dwni,dwnj);
         end
        
         max_val_1 = val_1+val_2+val_3;
         
         
        %To move right
        %Direction 2 - Right - i,j+1     
        
        %Right
   
         if rightj>c || U(righti,rightj)==0
            val_1 = 0.8 * U(i,j);
            
        else 
             val_1 = 0.8 * U(righti,rightj);
         end
        
        
        %Up
        
        if upi>r || U(upi,upj)==0
            val_2 = 0.1 * U(i,j);
            
        else
            val_2 = 0.1 * U(upi,upj);
            
        end
        
        %Down
         if dwni<=0 || U(dwni,dwnj)==0
             val_3 = 0.1 * U(i,j);
         else
            val_3 = 0.1 * U(dwni,dwnj);
         end
        
         max_val_2 = val_1+val_2+val_3;
         
         
        %Move up
        %Direction 3 - Up - i+1,j 
        
        %up
         if upi>r || U(upi,upj)==0
            val_1 = 0.8 * U(i,j);
            
        else
            val_1 = 0.8 * U(upi,upj);
            
         end
        
        %left
        if leftj<=0 || U(lefti,leftj)==0
            val_2 = 0.1 * U(i,j);
            
        else 
             val_2 = 0.1 * U(lefti,leftj);
        end
        
        %right
        if rightj>c || U(righti,rightj)==0
            val_3 = 0.1 * U(i,j);
            
        else 
             val_3 = 0.1 * U(righti,rightj);
        end
        
         max_val_3 = val_1+val_2+val_3;
        %Move Down
        %Direction 4 - Down - i-1,j
        
        %Down
         if dwni<=0 || U(dwni,dwnj)==0
             val_1 = 0.8 * U(i,j);
         else
            val_1 = 0.8 * U(dwni,dwnj);
         end
        
        %left
        if leftj<=0 || U(lefti,leftj)==0
            val_2 = 0.1 * U(i,j);
            
        else 
             val_2 = 0.1 * U(lefti,leftj);
        end
        
        %right
        if rightj>c || U(righti,rightj)==0
            val_3 = 0.1 * U(i,j);
            
        else 
             val_3 = 0.1 * U(righti,rightj);
        end
        
        max_val_4 = val_1+val_2+val_3;
        
        
        max_val = max([max_val_1(:),max_val_2(:),max_val_3(:),max_val_4(:)]);
        
        U(i,j)  = initial_matrix(i,j)  + (gamma * max_val);
    end
end

 
end


[ru,cu] = size(U);

for ui = 1:ru
   for uj = 1:cu
       
       fprintf('%6.3f',U(ui,uj));
       if uj~=cu
       fprintf(',');
       end
       
   end    
    fprintf('\n');
end












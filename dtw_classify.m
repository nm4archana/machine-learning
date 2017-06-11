function output = dtw_classify(trainingFile,testFile)

%training_file = 'asl_training.txt';
%test_file = 'asl_test.txt';
training_file = trainingFile;
test_file = testFile;

 fid1 = fopen(training_file);
 tline1 = fgetl(fid1);
  k1=0;
  flagval1 = 0;
  exit_val1 = 0;
  import java.util.HashMap;
  newMap = java.util.HashMap;
  chkFlag = 0;
  import java.util.HashMap;
  newMap_matrix = java.util.HashMap;



fid = fopen(test_file);
tline = fgetl(fid);
k=0;
flagval = 0;
exit_val = 0;
min_cost = intmax;
ob_count = 0; 
acc_count = 0;
%Parsing training file
while ischar(tline1) 
  
    if startsWith(tline1,'object ID')
    flagval1 = 0;
    test_object_id_arr1 =strsplit(tline1,':');
    test_object_id1 = strtrim(test_object_id_arr1{1,2});
   % fprintf('Object ID: %s\n',test_object_id1);
    
    elseif startsWith(tline1,'class label')
    flagval1 = 0;
    test_class_label_arr1 = strsplit(tline1,':');
    test_class_label1 =  strtrim(test_class_label_arr1{1,2});
   % fprintf('Class Label: %s\n',test_class_label1);
    
    elseif startsWith(tline1,'dominant hand trajectory')
    flagval1 =1 ; 
    
    elseif startsWith(tline1,'------------------') 
    
    if k1~=0
  
    B_Split = strsplit(B,',');
    
    B_len = length(B_Split)-1;
    n1 = B_len/2; 
    B_matrix = zeros(n1,2);    
    i1 = 1;
    
    m1=1;
    while i1<=B_len
    q = string(B_Split{1,i1});
    w = string(B_Split{1,i1+1});
    B_matrix(m1,1) = q;
    B_matrix(m1,2) = w;
    i1 = i1+2;
    m1=m1+1;
    end
       
    newMap_matrix.put(test_object_id1,{B_matrix,test_class_label1});
    
      end
    
    flagval1 = 0;
    B = '';
    it1 = 0;
       
    elseif flagval1==1         
        it1 = it1+1;
        at  = regexp(tline1, '([^ \t][^\t]*)', 'match');
        a1t =  at{1,1};
        a2t =  at{1,2}; 
        B = strcat(B,sprintf('%s,%s,',a1t,a2t));
        
    end   
    if exit_val1==1
       break; 
    end
    
     tline1 = fgetl(fid1);
     if string(tline1) == string(-1)
     exit_val1=1;
     tline1 = '--------------------';
     end
     k1=k1+1;
    end

while ischar(tline)    
     min_val = intmax;
    if startsWith(tline,'object ID')
    flagval = 0;
    test_object_id_arr =strsplit(tline,':');
    test_object_id = strtrim(test_object_id_arr{1,2});
    %fprintf('Object ID: %s\n',test_object_id);
    
    elseif startsWith(tline,'class label')
    flagval = 0;
    test_class_label_arr = strsplit(tline,':');
    test_class_label =  strtrim(test_class_label_arr{1,2});
    %fprintf('Class Label: %s\n',test_class_label);
    
    elseif startsWith(tline,'dominant hand trajectory')
    flagval =1 ; 
    
    elseif startsWith(tline,'------------------') 
    
    if k~=0
  
    A_Split = strsplit(A,',');
    
    A_len = length(A_Split)-1;
    n = A_len/2; 
    A_matrix = zeros(n,2);    
    i = 1;
    
    m=1;
    while i<=A_len
    q = string(A_Split{1,i});
    w = string(A_Split{1,i+1});
    A_matrix(m,1) = q;
    A_matrix(m,2) = w;
    i = i+2;
    m=m+1;
    end
    %disp(A_matrix); 
    
    %--------------------------------------------------------------------------------  
    %Calculate cost of each training data and compare it with previous cost

        
        k1=0;
        flagval1 = 0;
        exit_val1 = 0;
        import java.util.HashMap;
        newMap = java.util.HashMap;
        
        
        len = newMap_matrix.size();
    
     for l = 1:len
     chkFlag = 0;
     chkflg_val = 0;
    %Computing DTW between A_Matrix and B_Matrix and find the min cost
      val = newMap_matrix.keySet().toArray();
      B_val = newMap_matrix.get(val(l));
      B_matrix = B_val(1);
      training_class_id = B_val(2);
      [M,ct] = size(B_matrix);
      [N,cte] = size(A_matrix);
      C = zeros(M,N);
      C(1,1) = sqrt((B_matrix(1,1)-A_matrix(1,1)).^2+(B_matrix(1,2)-A_matrix(1,2)).^2);
    
      for i = 2:M
          C(i,1) = C(i-1,1) + sqrt((B_matrix(i,1)-A_matrix(1,1)).^2+(B_matrix(i,2)-A_matrix(1,2)).^2);
      end
      
      for j = 2:N
          C(1,j) = C(1,j-1) + sqrt((B_matrix(1,1)-A_matrix(j,1)).^2+(B_matrix(1,2)-A_matrix(j,2)).^2);  
      end
     
      for i=2:M
          for j=2:N
              a=C(i-1,j);
              b=C(i,j-1);
              c=C(i-1,j-1);
              C(i,j) = min([a,b,c])+sqrt((B_matrix(i,1)-A_matrix(j,1)).^2+(B_matrix(i,2)-A_matrix(j,2)).^2);
              
          end
      end 
      
     
      z = C(M,N);
      
        if z <= min_val
             %disp(min_val)
             %disp(1);
             min_val = z;

             if str2double(string(training_class_id)) == str2double(string(test_class_label))
               
             chkFlag = 1;          
             else
             chkFlag=0;
             end
             
             if newMap.containsKey(min_val)
             d = newMap.get(min_val);
             v = d(1);
             chkflg_val = d(2);
             
             if chkflg_val==1 && chkFlag==0
                 chkFlag=1;
             end
             
             val_k = {v+1,chkFlag,training_class_id};
             newMap.put(min_val,val_k);
             else
             val_k = {1,chkFlag,training_class_id};
             newMap.put(min_val,val_k);
             end
        end

   
    end

     
   %-------------------------------------------------------------------------------- 
       
       count = newMap.get(min_val);
       
       
       if count(2,1) ==1
       cval = count(1,1);
       accuracy = 1/cval;
       else 
       accuracy = 0; 
       end
       
       predicted_class = count(3,1);
       acc_count = acc_count+accuracy;
       
       
        fprintf('ID=%s, predicted=%s, true=%s, accuracy=%4.2f, distance = %.2f\n', test_object_id, predicted_class, test_class_label, accuracy, min_val);
        ob_count = ob_count+1;
        accuracy = 0;
    
       end
      
       
    flagval = 0;
    A = '';
    it = 0;
    
    
    elseif flagval==1         
        it = it+1;
        a  = regexp(tline, '([^ \t][^\t]*)', 'match');
        a1 =  a{1,1};
        a2 =  a{1,2}; 
        sprintf('%s %s\n',a1,a2);
        A = strcat(A,sprintf('%s,%s,',a1,a2));
        
    end   
    if exit_val==1
       break; 
    end
     tline = fgetl(fid);
     if string(tline) == string(-1)
     exit_val=1;
     tline = '--------------------';
     end
     k=k+1;
  
     
  
end
   %Classification Accuracy
   classification_accuracy =  acc_count/ob_count;
   
   fprintf('classification accuracy=%6.4f\n', classification_accuracy);

fclose(fid);

end


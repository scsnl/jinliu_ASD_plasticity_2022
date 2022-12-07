clear,clc
%% set the file path
% For window 10 
% file_path = fullfile('C:','Users','jinliu5','Box','Jin Liu','2019 ASD Learning Math Whizz');
% For Mac at home
file_path = fullfile(filesep,'Users','jinjin','Box','Jin Liu','2019 ASD Learning Math Whizz')
load(fullfile(file_path,'7. data, scripts and results','subject_lists','Image_sublist_pre_post_activation.mat'));

% For window 10 
% oak_path = fullfile('Z:','menon','projects','jinliu5','2019_ASD_MathWhiz');
% For Mac 
oak_path = fullfile(filesep,'Volumes','menon','projects','jinliu5','2019_ASD_MathWhiz')
cd(oak_path)
%% NRP_ROI calculation
group_time= {'TD_pre';'TD_post';'Copy_of_ASD_pre';'Copy_of_ASD_post'};
contrast = {'trained-rest';'untrained-rest'};
group = {'TD';'Copy_of_ASD'}
ROI_input = {'IPS_L','IPS_R','MTL_L','MTL_R'}
ROI_output = {'IPS_L','IPS_R','MTL_L','MTL_R'}

 for l=1:length(ROI_input)
 mask_V=spm_vol(fullfile(oak_path,'data','imaging','roi','BPI_rois',[ROI_input{l} '.nii']));
 [mask_Y,XYZmm]=spm_read_vols(mask_V); 
 all_mask{l,1}=mask_Y;
 end
 clear mask_V XYZmm mask_Y
 output_path = fullfile(oak_path,'results','taskfmri','groupstats','rsa','NRD_ROI',contrast{k},filesep);
 mkdir(output_path);
 
 for k=1:2
     for j=1:2
         file_path1 = fullfile(oak_path,'results','taskfmri','groupstats','activation',contrast{k},[group{j},'_pre',filesep]);
         file_list1 = dir(file_path1);
         file_list1(1:2,:)=[];
         
         file_path2 = fullfile(oak_path,'results','taskfmri','groupstats','activation',contrast{k},[group{j},'_post',filesep]);
         file_list2 = dir(file_path2);
         file_list2(1:2,:)=[];
         
         for i=1:length(file_list1)
             AllVolume1 = [file_path1,file_list1(i).name]
             V_tmp1=spm_vol(AllVolume1);
             [Y_tmp1,XYZmm] = spm_read_vols(V_tmp1);
             
             AllVolume2 = [file_path2,file_list2(i).name]
             V_tmp2=spm_vol(AllVolume2);
             [Y_tmp2,XYZmm] = spm_read_vols(V_tmp2);
             
             for l=1:length(ROI_input)
                 mask_Y= all_mask{l,1};
                 
                 if j==1
                     r=corr(Y_tmp1(find(mask_Y~=0)),Y_tmp2(find(mask_Y~=0)));
                     TD_NRD(i,l)=-(0.5.*log((1+r)/(1-r)));
                 end
                 if j==2
                     r=corr(Y_tmp1(find(mask_Y~=0)),Y_tmp2(find(mask_Y~=0)));
                     ASD_NRD(i,l)=-(0.5*log((1+r)/(1-r)));
                 end
             end
         end
     end
     
     if j==1
     output_name=[output_path 'NRD_ROIs_TD.mat'];
     save(output_name,'TD_NRD');
     elseif j==2
      output_name=[output_path 'NRD_ROIs_ASD.mat'];
     save(output_name,'ASD_NRD');
     end

 end
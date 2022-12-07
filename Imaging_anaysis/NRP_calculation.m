clear,clc
%% NRD pattern separation
% This script is used to calculate the neural representational plasticity 
% between pre and post- training for train and untrained problems
% for each subjects in ASD Whizz project
%
% Jin Liu
% 1/6/2021
%
%% setting file path and loading data
% setting project path
oak_path = fullfile(filesep,'Volumes','menon','projects','jinliu5','2019_ASD_MathWhiz');
box_path = fullfile(filesep,'Users','jinjin','Box','Jin Liu','2019 ASD Learning Math Whizz');    
%  cd(oak_path)

% load final imaging sublist 
load(fullfile(box_path,'7. data, scripts and results','analysis','Imaging','Image_sublist_pre_post.mat'));
twogroup = {'Copy_of_ASD';'TD'};
contrast = {'trained-rest';'untrained-rest'};

for u=1:2
    for l=1:2
        mkdir(fullfile(oak_path,'results','taskfmri','groupstats','rsa',[contrast{u} '_pre_VS_' contrast{u} '_post'],'analysis',['NRD_' twogroup{l}]));
        
        input_path = fullfile(oak_path,'results','taskfmri','groupstats','rsa', [contrast{u} '_pre_VS_' contrast{u} '_post'],'analysis',twogroup{l},filesep);
        file_path=dir(input_path);
        file_path(1:2,:)=[];
        
        for i=1:length(file_path)
            Y_temp =zeros(91,109,91);
            
            AllVolume = [input_path,file_path(i).name];
            V = spm_vol(AllVolume);
            [Y_temp,XYZmm]=spm_read_vols(V);
            
            Y_change=-Y_temp;
            OutputName = fullfile(oak_path,'results','taskfmri','groupstats','rsa',[contrast{u} '_pre_VS_' contrast{u} '_post'],'analysis', ['NRD_' twogroup{l}],[file_path(i).name(1:4),'_NRD_plasticity.nii']);
            y_Write(Y_change,V,OutputName);
        end
    end
end
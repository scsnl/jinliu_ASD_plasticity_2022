clear,clc
%% Neural representational plasticity (NRP) and learning GLM analysis
% This script is used to calculate the correlation between pre-post neural
% representational dissimilarity and learning gain in two groups for train
% and untrained problems in ASD Whizz project
%
% Jin Liu
% 1/6/2021
%
%% set the file path
box_path = fullfile(filesep,'Users','jinjin','Box','Jin Liu','2019 ASD Learning Math Whizz');
oak_path = fullfile(filesep,'Volumes','menon','projects','jinliu5','2019_ASD_MathWhiz');
%  cd(oak_path)

% load final imaging sublist
load(fullfile(box_path,'7. data, scripts and results','analysis','Imaging','Image_sublist_pre_post.mat'));
Image_ASD_sublist=Image_sublist(Image_sublist(:,5)==1,1);
Image_TD_sublist=Image_sublist(Image_sublist(:,5)==2,1);

%% preparation for correlation between rsa and beh
% loading data
behavior = {'scan task performance';'strategy assessment'};
beh_index = {'taskscan_change_ACC';'RT_strategy_performance'};
beh_file = {'scan task performance';'strategy assessment'};
beh_outputname = {'scantask';'strategyRT'};
group = {'ASD';'TD'};

%% correlation between rsa (pre/post) and beh
Mask_lable = 'wholebrain';
MaskFile =  fullfile(oak_path,'data','imaging','common_mask_subject45_pre_post_grey02.nii');
contrast = {'trained-rest';'untrained-rest'}

for u=1:2
    for k=1:length(behavior)
        beh_path = fullfile(box_path,'7. data, scripts and results','analysis','Behavior',behavior{k},[beh_index{k},'.mat']);
        load(beh_path);
        
        if k==1
            group_scan=scantask_change_ACC;
        elseif k==2
            group_scan=RT_strategy_performance;
        end
        
        output_path=fullfile(oak_path,'results','taskfmri','groupstats','rsa','pre_post_anova','association analysis','final',beh_file{k});
        mkdir(output_path)
        % correlation acorss group
        [com_sub,IA1,IB1] = intersect(group_scan(:,1),Image_sublist(:,1));
        
        if ismember(k,2)
            pre_train = group_scan(IA1,3);
            pre_untrain = group_scan(IA1,4);
            post_train = group_scan(IA1,5);
            post_untrain = group_scan(IA1,6);
            change_train = (post_train-pre_train)./pre_train;
            change_untrain = (post_untrain-pre_untrain)./pre_untrain;
            
        elseif ismember(k,1)
            pre_train = group_scan(IA1,5)
            pre_untrain = group_scan(IA1,7)
            post_train = group_scan(IA1,6)
            post_untrain = group_scan(IA1,8)
            change_train = (post_train-pre_train)./pre_train;
            change_untrain = (post_untrain-pre_untrain)./pre_untrain;
            
        end
        
        clear temp_change
        image_name=Image_sublist(IB1,1);
        for l=1:length(image_name)
            if ismember(image_name(l),Image_ASD_sublist)
                temp_change{l,1} = fullfile(oak_path,'results','taskfmri','groupstats','rsa',[contrast{u} '_pre_VS_' contrast{u} '_post'],'analysis',['NRD_Copy_of_' group{1}],[num2str(image_name(l)),'_NRD_plasticity.nii']);
            elseif ismember(image_name(l),Image_TD_sublist)
                temp_change{l,1} = fullfile(oak_path,'results','taskfmri','groupstats','rsa',[contrast{u} '_pre_VS_' contrast{u} '_post'],'analysis',['NRD_' group{2}],[num2str(image_name(l)),'_NRD_plasticity.nii']);
            end
            DependentDirs{1}=temp_change;
            Covariates=[];
        end
        if ismember(k,[1,2])
            if strmatch(contrast{u},'trained-rest')
                SeedSeries=change_train;
                OtherCovariates{1} = [Image_sublist(IB1,5),Image_sublist(IB1,5).*SeedSeries,Covariates];
                OutputName = fullfile(output_path,['all_',beh_outputname{k},'_change_',Mask_lable '_trained_interaction'])
                y_Correlation_Image_jin_interaction(DependentDirs,SeedSeries,OutputName,MaskFile,[],OtherCovariates);
                
            elseif strmatch(contrast{u},'untrained-rest')
                SeedSeries=change_untrain;
                OtherCovariates{1} = [Image_sublist(IB1,5),Image_sublist(IB1,5).*SeedSeries,Covariates];
                OutputName = fullfile(output_path,['all_',beh_outputname{k},'_change_',Mask_lable '_untrained_interaction'])
                y_Correlation_Image_jin_interaction(DependentDirs,SeedSeries,OutputName,MaskFile,[],OtherCovariates);
                
            end
        end
    end
end


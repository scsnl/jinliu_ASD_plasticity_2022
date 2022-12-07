clear,clc
%% set the file path
oak_path = fullfile(filesep,'Volumes','menon','projects','jinliu5','2019_ASD_MathWhiz');
box_path = fullfile(filesep,'Users','jinjin','Box','Jin Liu','2019 ASD Learning Math Whizz');    
%  cd(oak_path)

%% preparation parameters
load(fullfile(box_path,'7. data, scripts and results','analysis','Imaging','Image_sublist_pre_post.mat'));
Image_ASD_sublist=Image_sublist(Image_sublist(:,5)==1,1);
Image_TD_sublist=Image_sublist(Image_sublist(:,5)==2,1);
behavior = {'scan task performance'};
beh_index = {'taskscan_change_ACC'};
group = {'Copy_of_ASD';'TD'};
Mask_lable = 'wholebrain';
contrast = {'trained-rest_pre_VS_trained-rest_post';'untrained-rest_pre_VS_untrained-rest_post'};
MaskData =  fullfile(oak_path,'data','imaging','common_mask_subject45_pre_post_grey02.nii');
nSub = size(Image_sublist,1);
beh_outputname = {'scantask_change'};
Effect={'interaction'};
correction = {'GRF0005_005_com'}

%% ROI definition from trained condition
% trained pre vs post RSA (NRP)
ROIDef_all=[];

% ACC - interaction
ROIDef_name{1,1}={'R CB';'R pPHG';'L pPHG';'R FEF';'R IPS';'R MOG';'R MFG'};
ROIDef{1} = [20 -40 -34 5];
ROIDef{2} = [30 -48 2 5];
ROIDef{3} = [-16 -36 -14 5];
ROIDef{4} = [28 -20 60 5];
ROIDef{5} = [30 -64 50 5];
ROIDef{6} = [30 -78 16 5];
ROIDef{7} = [28 38 28 5];
ROIDef_all{1,1}=ROIDef;ROIDef=[];

%% ROI Signal 
type = {'trained';'untrained'};
for j=1:2
    for i=1:length(beh_outputname)
        Outputpath = fullfile(oak_path,'results','taskfmri','groupstats','rsa','pre_post_anova','association analysis','final',behavior{i},'posthoc','wholebrain',beh_outputname{i},correction{1},filesep);
        mkdir(Outputpath);
        
        if exist(fullfile(oak_path,'results','taskfmri','groupstats','rsa','pre_post_anova','association analysis','final',behavior{i},['all_' beh_outputname{i} '_wholebrain_' type{j} '_' Effect{1} '_' correction{1} '.nii']))
            
            for k=1:length(group)
                AllVolume = fullfile(oak_path,'results','taskfmri','groupstats','rsa',contrast{j},'analysis',['NRD_' group{k}],filesep);
                ROIDef = ROIDef_all{i,1};
                
                if ~isempty(ROIDef)
                    OutputName = [Outputpath,group{k}, '_' type{j} '_' Effect{1} '_' correction{1}];
                    [ROISignals] = y_ExtractROISignal(AllVolume, ROIDef, OutputName, MaskData);
                end

            end
        end
    end
end

%% pics for association with beh
% interaction
Behavior_new_name_pic = {'ACC gain'};
behavior = {'scan task performance'};
for i=1:length(beh_outputname)
    for u=1:2 % trained and untrained
        Outputpath = fullfile(box_path,'7. data, scripts and results','results','Imaging','figures','pre_vs_post','association',[beh_outputname{i} '_new'],correction{1},filesep);
        mkdir(Outputpath);
        
        beh_path = fullfile(box_path,'7. data, scripts and results','analysis','Behavior',behavior{i},[beh_index{i},'.mat']);
        load(beh_path); 
        
        if u==1
            group_scan=scantask_change_ACC;
            SeedSeries = (group_scan(:,6)-group_scan(:,5))./group_scan(:,5); % train post-pre/pre
        elseif u==2
            group_scan=scantask_change_ACC;
            SeedSeries = (group_scan(:,8)-group_scan(:,7))./group_scan(:,7); % untrain post-pre/pre
        end
        
        PID_tmp = group_scan(:,1);
        ROIDef = ROIDef_name{i,1};
        num_ROI = length(ROIDef_name{i,1});
        
        if ~isempty(ROIDef)  
            input=fullfile(oak_path,'results','taskfmri','groupstats','rsa','pre_post_anova','association analysis','final',behavior{i},'posthoc','wholebrain',beh_outputname{i},correction{1},['ROISignals_' group{1}, '_' type{u} '_' Effect{1} '_' correction{1} '.mat']);
            if exist(input)
                
                for h=1:num_ROI
                    clear temp_sig r1 p1 r2 p2 x1 x2 y1 y2
                    for k=1:length(group)
                        input=fullfile(oak_path,'results','taskfmri','groupstats','rsa','pre_post_anova','association analysis','final',behavior{i},'posthoc','wholebrain',beh_outputname{i},correction{1},['ROISignals_' group{k}, '_' type{u} '_' Effect{1} '_' correction{1} '.mat']);
                        temp_sig=importdata(input);
                        
                        if k==1
                            [com_sub,IA,IB] = intersect(PID_tmp,Image_ASD_sublist);
                            [r1,p1]=corr(temp_sig(IB,h),SeedSeries(IA));
                            x1 = temp_sig(IB,h); y1 = SeedSeries(IA);
                        elseif k==2
                            [com_sub,IA,IB] = intersect(PID_tmp,Image_TD_sublist);
                            [r2,p2]=corr(temp_sig(IB,h),SeedSeries(IA));
                            x2 = temp_sig(IB,h); y2 = SeedSeries(IA);
                        end
                    end
                    
                    if u==1
                        output_name = [Outputpath, beh_outputname{i}, '_',  ROIDef{h} '.jpg'];
                    elseif u==2
                        mkdir(fullfile(box_path,'7. data, scripts and results','results','Imaging','figures','pre_vs_post','association',[beh_outputname{i} '_new'],correction{1},filesep,'SI'));
                        output_name = [Outputpath,'SI',filesep,beh_outputname{i}, '_', type{u}, '_', ROIDef{h} '.jpg'];
                    end
                    
                    beh_corr_scatter_2group(x1,y1,x2,y2,'NRD',['ASD: r = ' num2str(r1,3) ' p = ' num2str(p1,3)],['TD: r = ' num2str(r2,3) ' p = ' num2str(p2,3)],Behavior_new_name_pic{i},[ROIDef{h} ' ' type{u}],output_name)
                end
            end
            
        end
    end
end

 

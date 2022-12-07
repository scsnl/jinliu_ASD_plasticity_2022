clear,clc
%% math verification performance
% This script is used to calculate and plot the accuracy performance on math varification task 
% before and after training in ASD Whizz project
%
% Jin Liu
% 12/26/2020
%
%% setting file path and loading data
% setting project path
file_path = fullfile(filesep,'Users','jinjin','Box','Jin Liu','2019 ASD Learning Math Whizz');    
addpath(fullfile(file_path,'7. data, scripts and results','analysis','figure code','final_fig'));
addpath(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','stat_code','mixed_between_within_anova'));
addpath(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','stat_code','computeCohen_d'));

% setting behavioral data path
load(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','scan task performance','info_sub67.mat')); % whole subjectlist before quality control
load(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','scan task performance','info_sub63.mat')); % final subjectlist of the project

% loading the math verification data during fMRI scan
PID = xlsread(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','scan task performance','whiz_scanner_behavioral_data_all_corrected.xlsx'),1,'A2:A7589'); % PID
session = xlsread(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','scan task performance','whiz_scanner_behavioral_data_all_corrected.xlsx'),1,'B2:B7589'); % four runs at each time point
Choice_ACC = xlsread(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','scan task performance','whiz_scanner_behavioral_data_all_corrected.xlsx'),1,'F2:F7589'); % Accuracy
[~,~,training_set] = xlsread(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','scan task performance','whiz_scanner_behavioral_data_all_corrected.xlsx'),1,'O2:O7589'); % training group index (A/B)
load(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','scan task performance','PID_train_group.mat')); % training index for each participants
load(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','scan task performance','sublist_nores.mat')); % subject with no response
load(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','scan task performance','sublist_lowacc.mat')); % subject with random accuracy

%% data quality control
% reorganize data according to final subjectlist
analysis_list = Sub_info(:,1);
lowacc(:,1)=Sub_info63(:,1);
 for i=1:length(lowacc(:,1))
    lowacc(i,2:9)=Lowacc_ind(find(analysis_list==lowacc(i,1)),1:8);
 end

noresponse(:,1)=Sub_info63(:,1);
 for i=1:length(noresponse(:,1))
    noresponse(i,2:9)=RESP_ind(find(analysis_list==noresponse(i,1)),1:8);
 end

new_PID_train_group(:,1)=Sub_info63(:,1);
 for i=1:length(Sub_info63(:,1))
    new_PID_train_group(i,2)=PID_train_group(find(PID_train_group(:,1)==Sub_info63(i,1)),2);
 end
clear PID_train_group

%% calculating accuracy
session_label=[11,12,13,14,21,22,23,24]; % four runs in each scan session in total

% accuracy for trained problems
ACC_performance_train = zeros(length(Sub_info63(:,1)),8);
for i=1:length(Sub_info63(:,1))
    for j=1:8
        if noresponse(i,j+1)==1 & lowacc(i,j+1)==1 % only data showing non-random responses are included (nonresponse <= 30% and accuracy >= 50%)
            if new_PID_train_group(i,2)==1
                temp=Choice_ACC(find(PID==Sub_info63(i,1) & strcmp(training_set, 'GroupA')==1 & session == session_label(j))); % identify trained problems for group A
                ACC_performance_train(i,j)=sum(temp)/length(temp); 
            elseif new_PID_train_group(i,2)==2
                temp=Choice_ACC(find(PID==Sub_info63(i,1) & strcmp(training_set, 'GroupB')==1 & session == session_label(j))); % identify trained problems for group B
                ACC_performance_train(i,j)=sum(temp)/length(temp);
            end
        end
    end
end

% accuracy for untrained problems
ACC_performance_untrain = zeros(length(Sub_info63(:,1)),8);
for i=1:length(Sub_info63(:,1))
    for j=1:8
        if noresponse(i,j+1)==1 & lowacc(i,j+1)==1 % only data showing non-random responses are included (nonresponse <= 30% and accuracy >= 50%)
            if new_PID_train_group(i,2)==1
                temp=Choice_ACC(find(PID==Sub_info63(i,1) & strcmp(training_set, 'GroupA')==0 & session == session_label(j)));
                ACC_performance_untrain(i,j)=sum(temp)/length(temp);
            elseif new_PID_train_group(i,2)==2
                temp=Choice_ACC(find(PID==Sub_info63(i,1) & strcmp(training_set, 'GroupB')==0 & session == session_label(j)));
                ACC_performance_untrain(i,j)=sum(temp)/length(temp);
            end
        end
    end
end

for i=1:length(ACC_performance_train)
    length1(i,1)=length(find(ACC_performance_train(i,1:4)~=0)); % number of runs included at pre 
end
for i=1:length(ACC_performance_train)
    length2(i,1)=length(find(ACC_performance_train(i,5:8)~=0)); % number of runs included at post
end

% data for two types of problems in two groups at pre- and post-training
ASD_pre_ACC_train=sum(ACC_performance_train(find(Sub_info63(:,5)==1),1:4),2)./length1(find(Sub_info63(:,5)==1),:);
ASD_pre_ACC_untrain=sum(ACC_performance_untrain(find(Sub_info63(:,5)==1),1:4),2)./length1(find(Sub_info63(:,5)==1),:);
ASD_post_ACC_train=sum(ACC_performance_train(find(Sub_info63(:,5)==1),5:8),2)./length2(find(Sub_info63(:,5)==1),:);
ASD_post_ACC_untrain=sum(ACC_performance_untrain(find(Sub_info63(:,5)==1),5:8),2)./length2(find(Sub_info63(:,5)==1),:);

TD_pre_ACC_train=sum(ACC_performance_train(find(Sub_info63(:,5)==2),1:4),2)./length1(find(Sub_info63(:,5)==2),:);
TD_pre_ACC_untrain=sum(ACC_performance_untrain(find(Sub_info63(:,5)==2),1:4),2)./length1(find(Sub_info63(:,5)==2),:);
TD_post_ACC_train=sum(ACC_performance_train(find(Sub_info63(:,5)==2),5:8),2)./length2(find(Sub_info63(:,5)==2),:);
TD_post_ACC_untrain=sum(ACC_performance_untrain(find(Sub_info63(:,5)==2),5:8),2)./length2(find(Sub_info63(:,5)==2),:);

ACC_performance_pre_train = sum(ACC_performance_train(:,1:4),2)./length1;
ACC_performance_post_train = sum(ACC_performance_train(:,5:8),2)./length2;
ACC_performance_pre_untrain = sum(ACC_performance_untrain(:,1:4),2)./length1;
ACC_performance_post_untrain = sum(ACC_performance_untrain(:,5:8),2)./length2;

num_ASD=length(find(Sub_info63(:,5)==1));
num_TD=length(find(Sub_info63(:,5)==2));
fprintf(['Number of participants for analysis: ASD = ' num2str(num_ASD) ' TD = ' num2str(num_TD) '\n\n']);

%% Two-way (time by group) repeated measures ANOVA
% trained problems
data_for_anova = [ACC_performance_pre_train;ACC_performance_post_train];
group = [Sub_info63(:,5);Sub_info63(:,5)];
pre_post = [ones(size(ACC_performance_pre_train,1),1);ones(size(ACC_performance_post_train,1),1)*2];
sub_ind = [(1:length(ACC_performance_pre_train))';(1:length(ACC_performance_post_train))'];
X = [data_for_anova group pre_post sub_ind];
[SSQs, DFs, MSQs, Fs, Ps]=mixed_between_within_anova(X,0);
% effect size
partial_eta_square = SSQs{3}/(SSQs{3}+SSQs{5})
partial_eta_square = SSQs{1}/(SSQs{1}+SSQs{2})
partial_eta_square = SSQs{4}/(SSQs{4}+SSQs{5})

% untrained problems
data_for_anova = [ACC_performance_pre_untrain;ACC_performance_post_untrain];
group = [Sub_info63(:,5);Sub_info63(:,5)];
pre_post = [ones(size(ACC_performance_pre_untrain,1),1);ones(size(ACC_performance_post_untrain,1),1)*2];
sub_ind = [(1:length(ACC_performance_pre_untrain))';(1:length(ACC_performance_post_untrain))'];
X = [data_for_anova group pre_post sub_ind];
[SSQs, DFs, MSQs, Fs, Ps]=mixed_between_within_anova(X,0);
% effect size
partial_eta_square = SSQs{3}/(SSQs{3}+SSQs{5})
partial_eta_square = SSQs{1}/(SSQs{1}+SSQs{2})
partial_eta_square = SSQs{4}/(SSQs{4}+SSQs{5})

%%  posthoc ttest (trained)
% paired ttest between pre and post in each group
% ASD
mean_sd(1,1)=mean(ACC_performance_pre_train(Sub_info63(:,5)==1));
mean_sd(1,2)=std(ACC_performance_pre_train(Sub_info63(:,5)==1));
mean_sd(1,3)=mean(ACC_performance_post_train(Sub_info63(:,5)==1));
mean_sd(1,4)=std(ACC_performance_post_train(Sub_info63(:,5)==1));
[h,p,ci,stats] = ttest(ACC_performance_pre_train(Sub_info63(:,5)==1),ACC_performance_post_train(Sub_info63(:,5)==1)); % ASD pre-post trained
t_session(1)=stats.tstat;df_session(1)=stats.df;p_session(1)=p;
d(1) = computeCohen_d(ACC_performance_pre_train(Sub_info63(:,5)==1),ACC_performance_post_train(Sub_info63(:,5)==1),'paired');

% TD
mean_sd(2,1)=mean(ACC_performance_pre_train(Sub_info63(:,5)==2));
mean_sd(2,2)=std(ACC_performance_pre_train(Sub_info63(:,5)==2));
mean_sd(2,3)=mean(ACC_performance_post_train(Sub_info63(:,5)==2));
mean_sd(2,4)=std(ACC_performance_post_train(Sub_info63(:,5)==2));
[h,p,ci,stats] = ttest(ACC_performance_pre_train(Sub_info63(:,5)==2),ACC_performance_post_train(Sub_info63(:,5)==2)); % TD pre-post trained
t_session(2)=stats.tstat;df_session(2)=stats.df;p_session(2)=p;
d(2) = computeCohen_d(ACC_performance_pre_train(Sub_info63(:,5)==2),ACC_performance_post_train(Sub_info63(:,5)==2),'paired');

% report
disp('Paired Ttest Analysis Table for ACC(trained) in each group')
fprintf('------------------------------------------------------------------------------\n');
disp('      pre(mean) pre(sd) post(mean) post(sd)   t      df     Cohens''d    P')
fprintf('------------------------------------------------------------------------------\n');
fprintf('ASD %9.2f%9.3f%9.2f%9.3f%9.2f%9.2f%9.2f%9.3f\n\n',mean_sd(1,1),mean_sd(1,2),mean_sd(1,3),mean_sd(1,4),t_session(1),df_session(1),d(1),p_session(1));
fprintf('TD  %9.2f%9.3f%9.2f%9.3f%9.2f%9.2f%9.2f%9.3f\n\n', mean_sd(2,1),mean_sd(2,2),mean_sd(2,3),mean_sd(2,4),t_session(2),df_session(2),d(2),p_session(2));
fprintf('------------------------------------------------------------------------------\n');


% two sample ttest at pre and at post
% pre 
[h,p,ci,stats] = ttest2(ACC_performance_pre_train(Sub_info63(:,5)==1),ACC_performance_pre_train(Sub_info63(:,5)==2)); % pre ASD-TD trained
t_session(1)=stats.tstat;df_session(1)=stats.df;p_session(1)=p;
d(1) = computeCohen_d(ACC_performance_pre_train(Sub_info63(:,5)==1),ACC_performance_pre_train(Sub_info63(:,5)==2));

% post
[h,p,ci,stats] = ttest2(ACC_performance_post_train(Sub_info63(:,5)==1),ACC_performance_post_train(Sub_info63(:,5)==2)); % post ASD-TD trained
t_session(2)=stats.tstat;df_session(2)=stats.df;p_session(2)=p;
d(2) = computeCohen_d(ACC_performance_post_train(Sub_info63(:,5)==1),ACC_performance_post_train(Sub_info63(:,5)==2));

disp('Two-sample Ttest Analysis Table for ACC(trained) at pre and post')
fprintf('------------------------------------------------------------------------------\n');
disp('        ASD(mean) ASD(sd) TD (mean) TD(sd)    t       df    Cohens''d    P')
fprintf('------------------------------------------------------------------------------\n');
fprintf('Pre  %9.2f%9.3f%9.2f%9.3f%9.2f%9.2f%9.2f%9.3f\n\n', mean_sd(1,1),mean_sd(1,2),mean_sd(2,1),mean_sd(2,2),t_session(1),df_session(1),d(1),p_session(1));
fprintf('Post %9.2f%9.3f%9.2f%9.3f%9.2f%9.2f%9.2f%9.3f\n\n', mean_sd(1,3),mean_sd(1,4),mean_sd(2,3),mean_sd(2,4),t_session(2),df_session(2),d(2),p_session(2));
fprintf('------------------------------------------------------------------------------\n');


%%  posthoc ttest (untrained)
% paired ttest between pre and post in each group
% ASD
mean_sd(1,1)=mean(ACC_performance_pre_untrain(Sub_info63(:,5)==1));
mean_sd(1,2)=std(ACC_performance_pre_untrain(Sub_info63(:,5)==1));
mean_sd(1,3)=mean(ACC_performance_post_untrain(Sub_info63(:,5)==1));
mean_sd(1,4)=std(ACC_performance_post_untrain(Sub_info63(:,5)==1));
[h,p,ci,stats] = ttest(ACC_performance_pre_untrain(Sub_info63(:,5)==1),ACC_performance_post_untrain(Sub_info63(:,5)==1)); % ASD pre-post trained
t_session(1)=stats.tstat;df_session(1)=stats.df;p_session(1)=p;
d(1) = computeCohen_d(ACC_performance_pre_untrain(Sub_info63(:,5)==1),ACC_performance_post_untrain(Sub_info63(:,5)==1),'paired');

% TD
mean_sd(2,1)=mean(ACC_performance_pre_untrain(Sub_info63(:,5)==2));
mean_sd(2,2)=std(ACC_performance_pre_untrain(Sub_info63(:,5)==2));
mean_sd(2,3)=mean(ACC_performance_post_untrain(Sub_info63(:,5)==2));
mean_sd(2,4)=std(ACC_performance_post_untrain(Sub_info63(:,5)==2));
[h,p,ci,stats] = ttest(ACC_performance_pre_untrain(Sub_info63(:,5)==2),ACC_performance_post_untrain(Sub_info63(:,5)==2)); % TD pre-post trained
t_session(2)=stats.tstat;df_session(2)=stats.df;p_session(2)=p;
d(2) = computeCohen_d(ACC_performance_pre_untrain(Sub_info63(:,5)==2),ACC_performance_post_untrain(Sub_info63(:,5)==2),'paired');

% report
disp('Paired Ttest Analysis Table for ACC(untrained) in each group')
fprintf('------------------------------------------------------------------------------\n');
disp('      pre(mean) pre(sd) post(mean) post(sd)   t      df     Cohens''d     P')
fprintf('------------------------------------------------------------------------------\n');
fprintf('ASD %9.2f%9.3f%9.2f%9.3f%9.2f%9.2f%9.2f%9.3f\n\n', mean_sd(1,1),mean_sd(1,2),mean_sd(1,3),mean_sd(1,4),t_session(1),df_session(1),d(1),p_session(1));
fprintf('TD  %9.2f%9.3f%9.2f%9.3f%9.2f%9.2f%9.2f%9.3f\n\n', mean_sd(2,1),mean_sd(2,2),mean_sd(2,3),mean_sd(2,4),t_session(2),df_session(2),d(2),p_session(2));
fprintf('------------------------------------------------------------------------------\n');


% two sample ttest at pre and at post
% pre 
[h,p,ci,stats] = ttest2(ACC_performance_pre_untrain(Sub_info63(:,5)==1),ACC_performance_pre_untrain(Sub_info63(:,5)==2)); % pre ASD-TD untrained
t_session(1)=stats.tstat;df_session(1)=stats.df;p_session(1)=p;
d(1) = computeCohen_d(ACC_performance_pre_untrain(Sub_info63(:,5)==1),ACC_performance_pre_untrain(Sub_info63(:,5)==2));

% post
[h,p,ci,stats] = ttest2(ACC_performance_post_untrain(Sub_info63(:,5)==1),ACC_performance_post_untrain(Sub_info63(:,5)==2)); % post ASD-TD untrained
t_session(2)=stats.tstat;df_session(2)=stats.df;p_session(2)=p;
d(2) = computeCohen_d(ACC_performance_post_untrain(Sub_info63(:,5)==1),ACC_performance_post_untrain(Sub_info63(:,5)==2));

disp('Two-sample Ttest Analysis Table for ACC(untrained) at pre and post')
fprintf('------------------------------------------------------------------------------\n');
disp('      ASD(mean) ASD(sd) TD (mean)  TD(sd)      t       df    Cohens''d     P')
fprintf('------------------------------------------------------------------------------\n');
fprintf('Pre  %9.2f%9.3f%9.2f%9.3f%9.2f%9.2f%9.2f%9.3f\n\n', mean_sd(1,1),mean_sd(1,2),mean_sd(2,1),mean_sd(2,2),t_session(1),df_session(1),d(1),p_session(1));
fprintf('Post %9.2f%9.3f%9.2f%9.3f%9.2f%9.2f%9.2f%9.3f\n\n', mean_sd(1,3),mean_sd(1,4),mean_sd(2,3),mean_sd(2,4),t_session(2),df_session(2),d(2),p_session(2));
fprintf('------------------------------------------------------------------------------\n');

%% Accuracy gain (post-pre)/pre
% trained
ASD_accgain=(ACC_performance_post_train(Sub_info63(:,5)==1)-ACC_performance_pre_train(Sub_info63(:,5)==1))./ACC_performance_pre_train(Sub_info63(:,5)==1);
TD_accgain=(ACC_performance_post_train(Sub_info63(:,5)==2)-ACC_performance_pre_train(Sub_info63(:,5)==2))./ACC_performance_pre_train(Sub_info63(:,5)==2);
[h,p,ci,stats] = ttest2(ASD_accgain,TD_accgain); % ASD-TD trained
t_session(1)=stats.tstat;df_session(1)=stats.df;p_session(1)=p;
d(1) = computeCohen_d(ASD_accgain,TD_accgain);

% plot
output_path = fullfile(file_path,'7. data, scripts and results','results','Behavior','figures','ASD_TD_scanACCgain_trained.tiff');
bar_group_small(ASD_accgain,TD_accgain,[-0.35 0.45],[-0.2 0 0.2],[-20 0 20], {'ASD','TD'}, 'Accuracy gain (%)', output_path);

disp('Two-sample Ttest Analysis Table for ACC gain (trained)')
fprintf('--------------------------------------------------------------------------------\n');
disp('         ASD(mean) ASD(sd) TD (mean)  TD(sd)     t       df    Cohens''d     P')
fprintf('--------------------------------------------------------------------------------\n');
fprintf('ACCgain %9.2f%9.3f%9.2f%9.3f%9.2f%9.2f%9.2f%9.3f\n\n', mean(ASD_accgain),std(ASD_accgain),mean(TD_accgain),std(TD_accgain),t_session(1),df_session(1),d(1),p_session(1));
fprintf('--------------------------------------------------------------------------------\n');

% untrained 
ASD_accgain=(ACC_performance_post_untrain(Sub_info63(:,5)==1)-ACC_performance_pre_untrain(Sub_info63(:,5)==1))./ACC_performance_pre_untrain(Sub_info63(:,5)==1);
TD_accgain=(ACC_performance_post_untrain(Sub_info63(:,5)==2)-ACC_performance_pre_untrain(Sub_info63(:,5)==2))./ACC_performance_pre_untrain(Sub_info63(:,5)==2);
[h,p,ci,stats] = ttest2(ASD_accgain,TD_accgain); % ASD-TD untrained
t_session(2)=stats.tstat;df_session(2)=stats.df;p_session(2)=p;
d(2) = computeCohen_d(ASD_accgain,TD_accgain);

% plot
output_path = fullfile(file_path,'7. data, scripts and results','results','Behavior','figures','supplementary','ASD_TD_scanACCgain_untrained.tiff');
bar_group_small(ASD_accgain,TD_accgain,[-0.8 0.9],[-0.5 0 0.5],[-50 0 50], {'ASD','TD'}, 'Accuracy gain (%)', output_path);

disp('Two-sample Ttest Analysis Table for ACC gain (untrained)')
fprintf('--------------------------------------------------------------------------------\n');
disp('         ASD(mean) ASD(sd) TD (mean)  TD(sd)     t       df     Cohens''d    P')
fprintf('--------------------------------------------------------------------------------\n');
fprintf('ACCgain %9.2f%9.3f%9.2f%9.3f%9.2f%9.2f%9.2f%9.3f\n\n', mean(ASD_accgain),std(ASD_accgain),mean(TD_accgain),std(TD_accgain),t_session(2),df_session(2),d(2),p_session(2));
fprintf('--------------------------------------------------------------------------------\n');


%% plot
output_path = fullfile(file_path,'7. data, scripts and results','results','Behavior','figures','ASD_scanACC_trained.tiff');
bar_time(ASD_pre_ACC_train*100,ASD_post_ACC_train*100,[157, 211, 250],[25, 25, 112],[30 110],[40, 60, 80, 100], {'40','60','80','100'}, {'Pre','Post'}, 'ASD','Accuracy (%)', output_path,'ascend');
output_path = fullfile(file_path,'7. data, scripts and results','results','Behavior','figures','TD_scanACC_trained.tiff');
bar_time(TD_pre_ACC_train*100,TD_post_ACC_train*100,[255 166 158],[128 0 0],[30 110], [40, 60, 80, 100], {'40','60','80','100'},{'Pre','Post'}, 'TD','Accuracy (%)', output_path,'ascend');

output_path = fullfile(file_path,'7. data, scripts and results','results','Behavior','figures','supplementary','ASD_scanACC_untrained.tiff');
bar_time(ASD_pre_ACC_untrain*100,ASD_post_ACC_untrain*100,[157, 211, 250],[25, 25, 112],[30 110],[40, 60, 80, 100], {'40','60','80','100'}, {'Pre','Post'}, 'ASD','Accuracy (%)', output_path,'ascend');
output_path = fullfile(file_path,'7. data, scripts and results','results','Behavior','figures','supplementary','TD_scanACC_untrained.tiff');
bar_time(TD_pre_ACC_untrain*100,TD_post_ACC_untrain*100,[255 166 158],[128 0 0],[30 110], [40, 60, 80, 100], {'40','60','80','100'},{'Pre','Post'}, 'TD','Accuracy (%)', output_path,'ascend');

%% save ACC performance
scantask_change_ACC(:,1)=Sub_info63(:,1);
scantask_change_ACC(:,2)=Sub_info63(:,5);
scantask_change_ACC(:,3)=ACC_performance_post_train-ACC_performance_pre_train;
scantask_change_ACC(:,4)=ACC_performance_post_untrain-ACC_performance_pre_untrain;
scantask_change_ACC(:,5)=ACC_performance_pre_train;
scantask_change_ACC(:,6)=ACC_performance_post_train
scantask_change_ACC(:,7)=ACC_performance_pre_untrain;
scantask_change_ACC(:,8)=ACC_performance_post_untrain;

scantask_change_title = {'PID','ASD/TD','ACC for trained(post-pre)','ACC for untrained(post-pre)','ACC for trained (pre)','ACC for trained (post)','ACC for untrained (pre)','ACC for untrained (post)'};
save(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','scan task performance','taskscan_change_ACC.mat'),'scantask_change_ACC','scantask_change_title');
clear,clc
%% math production performance
% This script is used to calculate and plot the accuracy and response time performance on math production task 
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

% loading the math production data
load(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','scan task performance','PID_train_group.mat')); % training index
load(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','scan task performance','scanbeh_sublist.mat'));% list from scan behaviral data
[PID,~,~] = xlsread(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','strategy assessment','whiz_strategy_assessment_data_Jul312020.xlsx'),1,'B2:B4124'); % PID
[~,~,pre_post] = xlsread(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','strategy assessment','whiz_strategy_assessment_data_Jul312020.xlsx'),1,'A2:A4124');% pre/post index
[~,~,traingroup] = xlsread(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','strategy assessment','whiz_strategy_assessment_data_Jul312020.xlsx'),1,'V2:V4124');% problems set index
triallable = xlsread(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','strategy assessment','whiz_strategy_assessment_data_Jul312020.xlsx'),1,'P2:P4124'); % formal trials
accuracy_first = xlsread(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','strategy assessment','whiz_strategy_assessment_data_Jul312020.xlsx'),1,'I2:I4124'); % accuracy
equationRT = xlsread(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','strategy assessment','whiz_strategy_assessment_data_Jul312020.xlsx'),1,'O2:O4124'); % RT
[spoilRT,~,~] = xlsread(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','strategy assessment','whiz_strategy_assessment_data_Jul312020.xlsx'),1,'W2:W4124'); % error RT index

% fill the Nan values to make all variable with same rows
accuracy_first_fix(4:4123,1) = accuracy_first;
accuracy_first_fix(1:3,1) = NaN;
equationRT_fix(4:4123,1) = equationRT;
equationRT_fix(1:3,1) = NaN;
triallable_fix(4:4123,1)=triallable;
triallable_fix(1:3,1) = NaN;
spoilRT_fix(1:61,1) = NaN;
spoilRT_fix(62:4044,1)=spoilRT;
spoilRT_fix(4045:4123,1) = NaN;
clear strategy accuracy_first equationRT triallable

% subjectlist for strategy
strategy_sublist=unique(PID);
final_scanbeh_sublist=intersect(strategy_sublist(:,1),scanbeh_sublist(:,1));

new_PID_train_group(:,1)=final_scanbeh_sublist;
 for i=1:length(final_scanbeh_sublist)
    new_PID_train_group(i,2)=PID_train_group(find(PID_train_group==final_scanbeh_sublist(i)),2);
 end
clear PID_train_group

 for i=1:length(final_scanbeh_sublist)
    final_scanbeh_sublist(i,2:13)=scanbeh_sublist(find(scanbeh_sublist(:,1)==final_scanbeh_sublist(i,1)),2:13);
 end

%% calculating RT
RT_strategy = zeros(length(final_scanbeh_sublist),5);
RT_strategy(:,1)=final_scanbeh_sublist(:,1);
for i=1:length(final_scanbeh_sublist)
         % RT for trained at pre
         if new_PID_train_group(i,2)==1
         temp=equationRT_fix(find(PID==final_scanbeh_sublist(i) & ~isnan(triallable_fix) & strcmp(pre_post, 'Strategy_Assessment_ASD_Whiz_KeyPad_PreScan') & strcmp(traingroup,'A')==1 & accuracy_first_fix==1 & ismember(spoilRT_fix,1)==0));
         RT_strategy(i,2)=sum(temp)/length(~isnan(temp));
         elseif new_PID_train_group(i,2)==2
         temp=equationRT_fix(find(PID==final_scanbeh_sublist(i) & ~isnan(triallable_fix) & strcmp(pre_post, 'Strategy_Assessment_ASD_Whiz_KeyPad_PreScan') & strcmp(traingroup,'B')==1 & accuracy_first_fix==1 & ismember(spoilRT_fix,1)==0));
         RT_strategy(i,2)=sum(temp)/length(~isnan(temp));
         end
         
         % RT for untrained at pre
         if new_PID_train_group(i,2)==1
         temp=equationRT_fix(find(PID==final_scanbeh_sublist(i) & ~isnan(triallable_fix) & strcmp(pre_post, 'Strategy_Assessment_ASD_Whiz_KeyPad_PreScan') & strcmp(traingroup,'A')==0 & accuracy_first_fix==1 & ismember(spoilRT_fix,1)==0));
         RT_strategy(i,3)=sum(temp)/length(~isnan(temp));
         elseif new_PID_train_group(i,2)==2
         temp=equationRT_fix(find(PID==final_scanbeh_sublist(i) & ~isnan(triallable_fix) & strcmp(pre_post, 'Strategy_Assessment_ASD_Whiz_KeyPad_PreScan') & strcmp(traingroup,'B')==0 & accuracy_first_fix==1 & ismember(spoilRT_fix,1)==0));
         RT_strategy(i,3)=sum(temp)/length(~isnan(temp));
         end
         
         % RT for trained at post
         if new_PID_train_group(i,2)==1
         temp=equationRT_fix(find(PID==final_scanbeh_sublist(i) & ~isnan(triallable_fix) & strcmp(pre_post, 'Strategy_Assessment_ASD_Whiz_KeyPad_PostScan')& strcmp(traingroup,'A')==1 & accuracy_first_fix==1 & ismember(spoilRT_fix,1)==0));
         RT_strategy(i,4)=sum(temp)/length(~isnan(temp));
         elseif new_PID_train_group(i,2)==2
         temp=equationRT_fix(find(PID==final_scanbeh_sublist(i) & ~isnan(triallable_fix) & strcmp(pre_post, 'Strategy_Assessment_ASD_Whiz_KeyPad_PostScan')& strcmp(traingroup,'B')==1 & accuracy_first_fix==1 & ismember(spoilRT_fix,1)==0));
         RT_strategy(i,4)=sum(temp)/length(~isnan(temp));
         end
         
         % RT for untrained at post
         if new_PID_train_group(i,2)==1
         temp=equationRT_fix(find(PID==final_scanbeh_sublist(i) & ~isnan(triallable_fix) & strcmp(pre_post, 'Strategy_Assessment_ASD_Whiz_KeyPad_PostScan')& strcmp(traingroup,'A')==0 & accuracy_first_fix==1 & ismember(spoilRT_fix,1)==0));
         RT_strategy(i,5)=sum(temp)/length(~isnan(temp));
         elseif new_PID_train_group(i,2)==2
         temp=equationRT_fix(find(PID==final_scanbeh_sublist(i) & ~isnan(triallable_fix) & strcmp(pre_post, 'Strategy_Assessment_ASD_Whiz_KeyPad_PostScan')& strcmp(traingroup,'B')==0 & accuracy_first_fix==1 & ismember(spoilRT_fix,1)==0));
         RT_strategy(i,5)=sum(temp)/length(~isnan(temp));
         end
end

% data quality control
[C,ind,~] = intersect(final_scanbeh_sublist(:,1),[7648 7849]);
% 7648 and 7849 showed outlier RT at post 
% notes showing 7648 and 7849 did not cooperate in the strategy assessment
fixoutlier=final_scanbeh_sublist;
fixoutlier(ind,:)=[];
RT_strategy_fix=RT_strategy;
RT_strategy_fix(ind,:)=[];

% data for two types of problems in two groups at pre- and post-training
ASD_pre_train =RT_strategy_fix(find(fixoutlier(:,5) ==1),2).*0.001;
ASD_pre_untrain =RT_strategy_fix(find(fixoutlier(:,5) ==1),3).*0.001;
ASD_post_train =RT_strategy_fix(find(fixoutlier(:,5) ==1),4).*0.001;
ASD_post_untrain =RT_strategy_fix(find(fixoutlier(:,5) ==1),5).*0.001;

TD_pre_train =RT_strategy_fix(find(fixoutlier(:,5) ==2),2).*0.001;
TD_pre_untrain =RT_strategy_fix(find(fixoutlier(:,5) ==2),3).*0.001;
TD_post_train =RT_strategy_fix(find(fixoutlier(:,5) ==2),4).*0.001;
TD_post_untrain =RT_strategy_fix(find(fixoutlier(:,5) ==2),5).*0.001;

RT_performance_pre_train = RT_strategy_fix(:,2).*0.001;
RT_performance_pre_untrain = RT_strategy_fix(:,3).*0.001;
RT_performance_post_train = RT_strategy_fix(:,4).*0.001;
RT_performance_post_untrain = RT_strategy_fix(:,5).*0.001;

num_ASD = length(find(fixoutlier(:,5) == 1));
num_TD = length(find(fixoutlier(:,5) == 2));
fprintf(['Number of participants for analysis: ASD = ' num2str(num_ASD) ' TD = ' num2str(num_TD) '\n\n']);

%% Two-way (time by group) repeated measures ANOVA
% trained problems
data_for_anova = [RT_performance_pre_train;RT_performance_post_train];
group = [fixoutlier(:,5);fixoutlier(:,5)];
pre_post_ind = [ones(size(RT_performance_pre_train,1),1);ones(size(RT_performance_post_train,1),1)*2];
sub_ind = [(1:length(RT_performance_pre_train))';(1:length(RT_performance_post_train))'];
X = [data_for_anova group pre_post_ind sub_ind];
[SSQs, DFs, MSQs, Fs, Ps]=mixed_between_within_anova(X,0);
% effect size
partial_eta_square = SSQs{3}/(SSQs{3}+SSQs{5})
partial_eta_square = SSQs{1}/(SSQs{1}+SSQs{2})
partial_eta_square = SSQs{4}/(SSQs{4}+SSQs{5})

% untrained problems
data_for_anova = [RT_performance_pre_untrain;RT_performance_post_untrain];
group = [fixoutlier(:,5);fixoutlier(:,5)];
pre_post_ind = [ones(size(RT_performance_pre_untrain,1),1);ones(size(RT_performance_post_untrain,1),1)*2];
sub_ind = [(1:length(RT_performance_pre_untrain))';(1:length(RT_performance_post_untrain))'];
X = [data_for_anova group pre_post_ind sub_ind];
[SSQs, DFs, MSQs, Fs, Ps]=mixed_between_within_anova(X,0);
% effect size
partial_eta_square = SSQs{3}/(SSQs{3}+SSQs{5})
partial_eta_square = SSQs{1}/(SSQs{1}+SSQs{2})
partial_eta_square = SSQs{4}/(SSQs{4}+SSQs{5})

%% posthoc ttest (trained)
% paired ttest between pre and post in each group
% ASD
mean_sd(1,1)=mean(ASD_pre_train);
mean_sd(1,2)=std(ASD_pre_train);
mean_sd(1,3)=mean(ASD_post_train);
mean_sd(1,4)=std(ASD_post_train);
[h,p,ci,stats] = ttest(ASD_pre_train,ASD_post_train); % ASD pre-post trained
t_session(1)=stats.tstat;df_session(1)=stats.df;p_session(1)=p;
d(1) = computeCohen_d(ASD_pre_train,ASD_post_train,'paired');

% TD
mean_sd(2,1)=mean(TD_pre_train);
mean_sd(2,2)=std(TD_pre_train);
mean_sd(2,3)=mean(TD_post_train);
mean_sd(2,4)=std(TD_post_train);
[h,p,ci,stats] = ttest(TD_pre_train,TD_post_train); % TD pre-post trained
t_session(2)=stats.tstat;df_session(2)=stats.df;p_session(2)=p;
d(2) = computeCohen_d(TD_pre_train,TD_post_train,'paired');

% report
disp('Paired Ttest Analysis Table for RT(trained) in each group');
fprintf('---------------------------------------------------------------------------\n');
disp('      pre(mean) pre(sd) post(mean) post(sd)   t       df     Cohens''d   P')
fprintf('---------------------------------------------------------------------------\n');
fprintf('ASD %9.2f%9.3f%9.2f%9.3f%9.2f%9.2f%9.2f%9.3f\n\n', mean_sd(1,1),mean_sd(1,2),mean_sd(1,3),mean_sd(1,4),t_session(1),df_session(1),d(1),p_session(1));
fprintf('TD  %9.2f%9.3f%9.2f%9.3f%9.2f%9.2f%9.2f%9.3f\n\n', mean_sd(2,1),mean_sd(2,2),mean_sd(2,3),mean_sd(2,4),t_session(2),df_session(2),d(2),p_session(2));
fprintf('---------------------------------------------------------------------------\n');


% two sample ttest at pre and at post
% pre 
[h,p,ci,stats] = ttest2(ASD_pre_train,TD_pre_train); % pre ASD-TD trained
t_session(1)=stats.tstat;df_session(1)=stats.df;p_session(1)=p;
d(1) = computeCohen_d(ASD_pre_train,TD_pre_train);

% post
[h,p,ci,stats] = ttest2(ASD_post_train,TD_post_train); % post ASD-TD trained
t_session(2)=stats.tstat;df_session(2)=stats.df;p_session(2)=p;
d(2) = computeCohen_d(ASD_post_train,TD_post_train);

disp('Two-sample Ttest Analysis Table for RT(trained) at pre and post')
fprintf('---------------------------------------------------------------------------\n');
disp('        ASD(mean) ASD(sd) TD(mean) TD(sd)     t      df     Cohens''d    P')
fprintf('---------------------------------------------------------------------------\n');
fprintf('Pre %9.2f%9.3f%9.2f%9.3f%9.2f%9.2f%9.2f%9.3f\n\n', mean_sd(1,1),mean_sd(1,2),mean_sd(2,1),mean_sd(2,2),t_session(1),df_session(1),d(1),p_session(1));
fprintf('Post%9.2f%9.3f%9.2f%9.3f%9.2f%9.2f%9.2f%9.3f\n\n', mean_sd(1,3),mean_sd(1,4),mean_sd(2,3),mean_sd(2,4),t_session(2),df_session(2),d(2),p_session(2));
fprintf('---------------------------------------------------------------------------\n');

%% posthoc ttest (untrained)
% paired ttest between pre and post in each group
% ASD
mean_sd(1,1)=mean(ASD_pre_untrain);
mean_sd(1,2)=std(ASD_pre_untrain);
mean_sd(1,3)=mean(ASD_post_untrain);
mean_sd(1,4)=std(ASD_post_untrain);
[h,p,ci,stats] = ttest(ASD_pre_untrain,ASD_post_untrain); % ASD pre-post untrained
t_session(1)=stats.tstat;df_session(1)=stats.df;p_session(1)=p;
d(1) = computeCohen_d(ASD_pre_untrain,ASD_post_untrain,'paired');

% TD
mean_sd(2,1)=mean(TD_pre_untrain);
mean_sd(2,2)=std(TD_pre_untrain);
mean_sd(2,3)=mean(TD_post_untrain);
mean_sd(2,4)=std(TD_post_untrain);
[h,p,ci,stats] = ttest(TD_pre_untrain,TD_post_untrain); % TD pre-post untrained
t_session(2)=stats.tstat;df_session(2)=stats.df;p_session(2)=p;
d(2) = computeCohen_d(TD_pre_untrain,TD_post_untrain,'paired');

% report
disp('Paired Ttest Analysis Table for RT(untrained) in each group');
fprintf('-----------------------------------------------------------------------------\n');
disp('      pre(mean) pre(sd) post(mean) post(sd)   t       df     Cohens''d   P')
fprintf('-----------------------------------------------------------------------------\n');
fprintf('ASD %9.2f%9.3f%9.2f%9.3f%9.2f%9.2f%9.2f%9.3f\n\n', mean_sd(1,1),mean_sd(1,2),mean_sd(1,3),mean_sd(1,4),t_session(1),df_session(1),d(1),p_session(1));
fprintf('TD  %9.2f%9.3f%9.2f%9.3f%9.2f%9.2f%9.2f%9.3f\n\n', mean_sd(2,1),mean_sd(2,2),mean_sd(2,3),mean_sd(2,4),t_session(2),df_session(2),d(2),p_session(2));
fprintf('-----------------------------------------------------------------------------\n');


% two sample ttest at pre and at post
% pre 
[h,p,ci,stats] = ttest2(ASD_pre_untrain,TD_pre_untrain); % pre ASD-TD untrained
t_session(1)=stats.tstat;df_session(1)=stats.df;p_session(1)=p;
d(1) = computeCohen_d(ASD_pre_untrain,TD_pre_untrain);

% post
[h,p,ci,stats] = ttest2(ASD_post_untrain,TD_post_untrain); % post ASD-TD untrained
t_session(2)=stats.tstat;df_session(2)=stats.df;p_session(2)=p;
d(2) = computeCohen_d(ASD_post_untrain,TD_post_untrain);

disp('Two-sample Ttest Analysis Table for RT(untrained) at pre and post')
fprintf('-----------------------------------------------------------------------------\n');
disp('        ASD(mean) ASD(sd) TD(mean) TD(sd)     t      df     Cohens''d    P')
fprintf('-----------------------------------------------------------------------------\n');
fprintf('Pre %9.2f%9.3f%9.2f%9.3f%9.2f%9.2f%9.2f%9.3f\n\n', mean_sd(1,1),mean_sd(1,2),mean_sd(2,1),mean_sd(2,2),t_session(1),df_session(1),d(1),p_session(1));
fprintf('Post%9.2f%9.3f%9.2f%9.3f%9.2f%9.2f%9.2f%9.3f\n\n', mean_sd(1,3),mean_sd(1,4),mean_sd(2,3),mean_sd(2,4),t_session(2),df_session(2),d(2),p_session(2));
fprintf('-----------------------------------------------------------------------------\n');

%% RT gains (post-pre)/pre
% trained
ASD_accgain=(RT_performance_post_train(fixoutlier(:,5)==1)-RT_performance_pre_train(fixoutlier(:,5)==1))./RT_performance_pre_train(fixoutlier(:,5)==1);
TD_accgain=(RT_performance_post_train(fixoutlier(:,5)==2)-RT_performance_pre_train(fixoutlier(:,5)==2))./RT_performance_pre_train(fixoutlier(:,5)==2);
[h,p,ci,stats] = ttest2(ASD_accgain,TD_accgain); %trained
t_session(1)=stats.tstat;df_session(1)=stats.df;p_session(1)=p;
d(1) = computeCohen_d(ASD_accgain,TD_accgain);

% plot
output_path = fullfile(file_path,'7. data, scripts and results','results','Behavior','figures','ASD_TD_strategyRTgain_trained.tiff');
bar_group_small(ASD_accgain,TD_accgain,[-1.1 1],[-0.5 0 0.5],[-50 0 50], {'ASD','TD'}, 'RT gain (%)', output_path);

disp('Two-sample Ttest Analysis Table for RT gain (trained)');
fprintf('-------------------------------------------------------------------------------\n');
disp('        ASD(mean) ASD(sd) TD (mean)  TD(sd)      t       df    Cohens''d    P')
fprintf('-------------------------------------------------------------------------------\n');
fprintf('ACCgain%9.2f%9.3f%9.2f%9.3f%9.2f%9.2f%9.2f%9.3f\n\n',mean(ASD_accgain),std(ASD_accgain),mean(TD_accgain),std(TD_accgain),t_session(1),df_session(1),d(1),p_session(1));
fprintf('-------------------------------------------------------------------------------\n');

% untrained
ASD_accgain=(RT_performance_post_untrain(fixoutlier(:,5)==1)-RT_performance_pre_untrain(fixoutlier(:,5)==1))./RT_performance_pre_untrain(fixoutlier(:,5)==1);
TD_accgain=(RT_performance_post_untrain(fixoutlier(:,5)==2)-RT_performance_pre_untrain(fixoutlier(:,5)==2))./RT_performance_pre_untrain(fixoutlier(:,5)==2);
[h,p,ci,stats] = ttest2(ASD_accgain,TD_accgain); %untrained
t_session(2)=stats.tstat;df_session(2)=stats.df;p_session(2)=p;
d(2) = computeCohen_d(ASD_accgain,TD_accgain);

% plot
output_path = fullfile(file_path,'7. data, scripts and results','results','Behavior','figures','supplementary','ASD_TD_strategyRTgain_untrained.tiff');
bar_group_small(ASD_accgain,TD_accgain,[-1.1 1],[-0.5 0 0.5],[-50 0 50], {'ASD','TD'}, 'RT gain (%)', output_path)

disp('Two-sample Ttest Analysis Table for RT gain (untrained)');
fprintf('--------------------------------------------------------------------------------\n');
disp('        ASD(mean) ASD(sd) TD (mean)  TD(sd)     t       df    Cohens''d    P')
fprintf('--------------------------------------------------------------------------------\n');
fprintf('ACCgain%9.2f%9.3f%9.2f%9.3f%9.2f%9.2f%9.2f%9.3f\n\n', mean(ASD_accgain),std(ASD_accgain),mean(TD_accgain),std(TD_accgain),t_session(2),df_session(2),d(2),p_session(2));
fprintf('--------------------------------------------------------------------------------\n');


%% save RT data
RT_strategy_performance(:,1) = RT_strategy_fix(:,1);
RT_strategy_performance(:,2) = fixoutlier(:,5);
RT_strategy_performance(:,3:6) = RT_strategy_fix(:,2:5);
RT_strategy_performance_title = {'PID','ASD/TD','pre trained','pre untrained','post trained','post_untrained'};
save(fullfile(file_path,'7. data, scripts and results','analysis','Behavior','strategy assessment','RT_strategy_performance.mat'),'RT_strategy_performance','RT_strategy_performance_title')

%% pics for RT
output_path = fullfile(file_path,'7. data, scripts and results','results','Behavior','figures','ASD_strategyRT_trained.tiff');
bar_time(ASD_pre_train,ASD_post_train,[157, 211, 250],[25, 25, 112],[0 13],[0, 5, 10], {'0','5','10'},{'Pre','Post'}, 'ASD','RT (s)', output_path,'descend')
output_path = fullfile(file_path,'7. data, scripts and results','results','Behavior','figures','TD_strategyRT_trained.tiff');
bar_time(TD_pre_train,TD_post_train,[255 166 158],[128 0 0],[0 13], [0, 5, 10], {'0','5','10'},{'Pre','Post'}, 'TD','RT (s)', output_path,'descend')

output_path = fullfile(file_path,'7. data, scripts and results','results','Behavior','figures','supplementary','ASD_strategyRT_untrained.tiff');
bar_time(ASD_pre_untrain,ASD_post_untrain,[157, 211, 250],[25, 25, 112],[0 15],[0, 5, 10, 15], {'0','5','10','15'},{'Pre','Post'}, 'ASD','RT (s)', output_path,'descend')
output_path = fullfile(file_path,'7. data, scripts and results','results','Behavior','figures','supplementary','TD_strategyRT_untrained.tiff');
bar_time(TD_pre_untrain,TD_post_untrain,[255 166 158],[128 0 0],[0 15], [0, 5,10, 15], {'0','5','10','15'},{'Pre','Post'}, 'TD','RT (s)', output_path,'descend')

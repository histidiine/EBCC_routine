function [data_learner,data_nonlearner,data_fastlearner,data_slowlearner]=plot_cum_based_on_cluster(data_matrix_all,cidx,mergeChoice)


switch mergeChoice

    case 'merge'
        data_learner=data_matrix_all(:,cidx==1|cidx==2);
        figure;
        plot_ind_cumulative_CR(data_learner, 'Learners', 0,'tog');
        
    case 'separate'
        data_fastlearner=data_matrix_all(:,cidx==1);
        data_slowlearner=data_matrix_all(:,cidx==2);
        figure;
        plot_ind_cumulative_CR(data_fastlearner, 'Fast Learners', 0,'tog');
        figure;
        plot_ind_cumulative_CR(data_slowlearner, 'Slow Learners', 0,'tog');
        
end

data_nonlearner=data_matrix_all(:,cidx==3);

figure;
plot_ind_cumulative_CR(data_nonlearner, 'Non-Learners', 0,'tog');
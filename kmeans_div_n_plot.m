function [cidx, ctrs, sumD]=kmeans_div_n_plot(nclusters,X)
% INPUTS:
% 1) nclusters
% 2) X

opts = statset('Display','final');
[cidx, ctrs, tempsum] = kmeans(X,nclusters,'Replicates',30,'Options',opts);
if size(X,2) > 1
    yaxis=2
else
    yaxis =1;
end
[~, order_cl]=sort(ctrs(:,yaxis),'descend');
temp_cidx=cidx;
for cl = 1:nclusters
    temp_cidx(cidx==order_cl(cl))=cl;
end
cidx=temp_cidx;
sumD=sum(tempsum);
xlim_weight=0.01;
outpos=[0.25,0.15,0.3,0.7];
color_indx{2,:}={'g','r'};
color_indx{3,:}={'g','b','r'};
color_indx{4,:}={'g','b',[0.5977    0.1953    0.7969],'r'};
sz=100;

switch size(X,2)
    
    case 1 % 1 variable
        
        figure;
        set(gcf,'units','normalized','OuterPosition',outpos);

        for cl = 1:nclusters
            cluster{cl}=X(cidx==cl);
            x_axis{cl}=ones(length(cluster{cl}),1);
            x_axis{cl}=x_axis{cl}-0.15 + 0.25.*rand(length(x_axis{cl}),1);
            scatter(x_axis{cl}, cluster{cl},sz,color_indx{nclusters}{1,cl},'.');
            hold on;
            plot(1,ctrs(cl),'kx','MarkerSize',12);
            hold on;
        end
        
        xl=[-1 3];
        xlim(xl)
        
        
    case 2 % 2 variables
        
        figure;
        set(gcf,'units','normalized','OuterPosition',outpos);

        for cl = 1:nclusters
            cluster{cl}=[X(cidx==cl,1),X(cidx==cl,2)];
            x_axis{cl}= cluster{cl}(:,1);
            y_axis{cl}= cluster{cl}(:,2);
            scatter(x_axis{cl}, y_axis{cl},sz,color_indx{nclusters}{1,cl},'.');
            hold on;
            plot(ctrs(cl,1),ctrs(cl,2),'kx','MarkerSize',12);
            hold on;
        end
        
        xl=xlim;
        xl=[xl(:,1)-(xlim_weight*xl(:,2)), xl(:,2)+xlim_weight*xl(:,2)];
        xlim(xl)
        
    case 3 % 3 variables
        
        figure;
        set(gcf,'units','normalized','OuterPosition',outpos);

        for cl = 1:nclusters
            cluster{cl}=[X(cidx==cl,1),X(cidx==cl,2),X(cidx==cl,3)];
            x_axis{cl}= cluster{cl}(:,1);
            y_axis{cl}= cluster{cl}(:,2);
            scatter(x_axis{cl}, y_axis{cl},sz,color_indx{nclusters}{1,cl},'.');
            hold on;
            plot(ctrs(cl,1),ctrs(cl,2),'kx','MarkerSize',12);
            hold on;
        end
        
        xl=xlim;
        xl=[xl(:,1)-(xlim_weight*xl(:,2)), xl(:,2)+xlim_weight*xl(:,2)];
        xlim(xl)
        
end



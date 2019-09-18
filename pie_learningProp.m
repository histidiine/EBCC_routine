function pie_learningProp(learning_gp,color_indx)

nclusters=size(learning_gp,1);

colormap_def=[0 0 0];
for gp = 1:size(learning_gp,2)

    for cl = 1:nclusters
        nlearn_clust(cl)=size(learning_gp{cl,gp},2);
        colormap_def=[colormap_def;color_indx{nclusters}{1,cl}];
    end
    colormap_def(1,:)=[];
    
    figure;
    h=pie(nlearn_clust);
    colormap(colormap_def);
    set(h(2:2:end),'FontSize',28);

end



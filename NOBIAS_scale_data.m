function data = NOBIAS_scale_data(data)
if isfield(data,'scale_factor')
    disp('data already be scaled')
else
    scale_factor = std(data.obs(:))/5; % 5 is a number that works for the simulation data
    data.obs = data.obs/scale_factor;
    data.obs_corr= data.obs_corr/(scale_factor*scale_factor);% step correlation is a product
    
    data.scale_factor = scale_factor;
end
end
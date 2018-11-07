opts = get_opts();

trajectories = [];
for iCam = 1:opts.num_cam
    trajectories_c = dlmread(fullfile(opts.experiment_root, opts.experiment_name, 'L3-identities', sprintf('cam%d_%s.txt',iCam, opts.sequence_names{opts.sequence})));
    [rowNum, ~] = size(trajectories_c);
    trajectories = [trajectories; [ones(rowNum, 1) .* iCam, trajectories_c(:,1:8), ones(rowNum, 2)]];
end

trajectories(:, [2, 3]) = trajectories(:, [3, 2]);
mkdir(sprintf('%s/%s/result',opts.experiment_root, opts.experiment_name));
filename = sprintf('%s/%s/result/result_%s.mat',opts.experiment_root, opts.experiment_name, opts.sequence_names{opts.sequence});
save(filename,'trajectories');
%{
addpath("./duke");

[rowNum, ~] = size(trajectories);
worldCoords = [];
for iRow = 1:4%rowNum
    [newWorldCoord, ] = image2world(trajectories(iRow, 8:9) ./ [opts.image_width, opts.image_height], trajectories(iRow, 1));
    trajectories(iRow, 8:9)% ./ [opts.image_width, opts.image_height]
    trajectories(iRow, 1)
    worldCoords = [worldCoords; newWorldCoord];
end

trainData1 = [trajectories, worldCoords];
%}

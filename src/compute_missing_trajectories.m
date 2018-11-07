opts = get_opts();

addpath("src/missing_trajectories");

inputFilename = sprintf('%s/%s/result/result_%s.mat',opts.experiment_root, opts.experiment_name, opts.sequence_names{opts.sequence});
load(inputFilename);

[idNum, ~] = max(trajectories(:, 2));
identities = struct("trajectories", []);
missingTrajectories = [];
for i = 1:idNum
    % split trajectories by id, and sort by frame
    newIdTrajectories = trajectories(trajectories(:, 2) == i, :);
    
    identities(i).trajectories = sortrows(delete_conflicts(newIdTrajectories), 3);
    identities(i).breakpoints = [];
    
    [trajectoryNum, ~] = size(identities(i).trajectories);
    %{
    % one person can only be found once in the same frame
    j = 2;
    while j <= trajectoryNum
        if identities(i).trajectories(j, 3) == identities(i).trajectories(j - 1, 3)
            identities(i).trajectories(j, :) = [];
            trajectoryNum = trajectoryNum - 1;
        else
            j = j + 1;
        end
    end
    %}

    % find all the breakpoints
    for j = opts.breakpoint.segment_length: trajectoryNum
        if identities(i).trajectories(j, 3) - identities(i).trajectories(j - 1, 3) > opts.breakpoint.threshold
            newBreakpoint = [identities(i).trajectories(j - 1, 3), identities(i).trajectories(j, 3)];
            identities(i).breakpoints = [identities(i).breakpoints; newBreakpoint];
        end
    end
    
    % compute other information
    [rowNum, ~] = size(identities(i).breakpoints);
    startPoints = [];
    endPoints = [];
    velocities = [];
    meanVelocities = [];
    for iRow = 1: rowNum
        startFrame = identities(i).breakpoints(iRow, 1);
        endFrame = identities(i).breakpoints(iRow, 2);
        newStartPoint = identities(i).trajectories(identities(i).trajectories(:, 3) == startFrame, [1 8 9]);
        newEndPoint = identities(i).trajectories(identities(i).trajectories(:, 3) == endFrame, [1 8 9]);
        startPoints = [startPoints; newStartPoint(2:3)];
        endPoints = [endPoints; newEndPoint(2:3)];

        startPoint = identities(i).trajectories(identities(i).trajectories(:, 3) == startFrame - opts.breakpoint.segment_length, [1 8 9]);
        endPoint = identities(i).trajectories(identities(i).trajectories(:, 3) == endFrame + opts.breakpoint.segment_length, [1 8 9]);
        startVelocity = getVelocity(opts.breakpoint.segment_length, startPoint, newStartPoint, true);
        endVelocity = getVelocity(opts.breakpoint.segment_length, newEndPoint, endPoint, true);
        velocities = [velocities; [startVelocity, endVelocity]];

        newMeanVelocity = getVelocity(endFrame - startFrame, newStartPoint(2: 3), newEndPoint(2: 3), false);
        meanVelocities = [meanVelocities; norm(newMeanVelocity)];
    end
    idMissingTrajectories = [ones(rowNum, 1) .* i, identities(i).breakpoints, startPoints, endPoints, velocities, meanVelocities];
    missingTrajectories = [missingTrajectories; idMissingTrajectories];
end

outputFilename = sprintf('%s/%s/result/missing_trajectories_%s.mat',opts.experiment_root, opts.experiment_name, opts.sequence_names{opts.sequence});
save(outputFilename, 'missingTrajectories');
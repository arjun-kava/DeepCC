function newTrajectories = delete_conflicts(trajectories)

    trajectoriesInCams = [];
    camIds = unique(trajectories(:, 1));
    
    %{
    if length(camIds) < 2
        newTrajectories = trajectories;
        return
    end
    %}
        
    for index = 1: length(camIds)
        camId = camIds(index);
        framesInCam = trajectories(trajectories(:, 1) == camId, 3);
        trajectoriesInCams = [trajectoriesInCams; [camId, min(framesInCam), max(framesInCam)]];
    end
    
    trajectoriesInCams = sortrows(trajectoriesInCams, 2);
    deleteList = [];
    for index = 2: length(camIds)
        if (trajectoriesInCams(index, 2) <= trajectoriesInCams(index - 1, 3))
            deleteList = [deleteList; trajectoriesInCams(index, 1)];
        end
    end
    
    for index = 1: length(deleteList)
        camId = deleteList(index);
        trajectories(trajectories(:, 1) == camId, :) = [];
    end
        
    newTrajectories = trajectories;
end


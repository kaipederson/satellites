lat = -89.41145475527613;
long = 43.07255162648905;
location = [long, lat];
neighbors = [long, lat, long, lat + 1.5, long, lat - 1.5, long - 1.5, lat, long + 1.5, lat, powerlong + 1.5, lat + 1.5, long  + 1.5, lat - 1.5, long - 1.5, lat  - 1.5, long + 1.5, lat - 1.5];
location = ["north", "south", "west", "east"];
for points = 1:2:20

    startTime = datetime(2021,9,14,0,0,0);
    stopTime = startTime + days(1);
    sampleTime = 1;
    sc = satelliteScenario(startTime, stopTime, sampleTime);
    sat = satellite(sc, "constellation_curr");
    
    for idx = 1:numel(sat)
        name = sat(idx).Name;
        conicalSensor(sat(idx),"Name",name,"MaxViewAngle",130);
    end
    
    % Retrieve the cameras
    %cam = [sat.ConicalSensors];
    
    name = "Madison";
    minElevationAngle = 25; % degrees
    geoSite = groundStation(sc, long, lat, "Name", name, "MinElevationAngle",minElevationAngle);
    geoSite2 = groundStation(sc, neighbors(points), neighbors(points + 1), "Name", "Neighbor", "MinElevationAngle",minElevationAngle);
    
    for idx = 1:numel(sat)
        ac(idx) = access(geoSite2, sat(idx), geoSite);
%         sat(idx).Name
%         accessIntervals(ac)
    end
    %accessIntervals(ac)
    for idx = 1:numel(ac)
        [s,time] = accessStatus(ac(idx));
        
        if idx == 1
            % Initialize system-wide access status vector in the first iteration
            systemWideAccessStatus = s;
        else
            % Update system-wide access status vector by performing a logical OR
            % with access status for the current camera-site access
            % analysis
            systemWideAccessStatus = or(systemWideAccessStatus,s);
        end
    end
    
    % plot(time,systemWideAccessStatus,"LineWidth",2);
    % grid on;
    % xlabel("Time");
    % ylabel("System-Wide Access Status");
    
    n = nnz(systemWideAccessStatus);
    systemWideAccessDuration = n*sc.SampleTime; % seconds
    scenarioDuration = seconds(sc.StopTime - sc.StartTime);
    systemWideAccessPercentage = (systemWideAccessDuration/scenarioDuration)*100
    

end
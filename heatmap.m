lat = -122.3321;
long = 47.6062;
fifty_km_minutes = 0.4522;

n_neighbors = ones(2,16);
s_neighbors = ones(2,16);
w_neighbors = ones(2,16);
e_neighbors = ones(2,16);
nw_neighbors = ones(2,16);
sw_neighbors = ones(2,16);
ne_neighbors = ones(2,16);
se_neighbors = ones(2,16);
for i = 1:16
    n_neighbors(1, i) = long;
    s_neighbors(1, i) = long;
    w_neighbors(1, i) = long  - 2*i*fifty_km_minutes;
    e_neighbors(1, i) = long  + 2*i*fifty_km_minutes; 
    n_neighbors(2, i) = lat   + 2*i*fifty_km_minutes;
    s_neighbors(2, i) = lat   - 2*i*fifty_km_minutes;
    w_neighbors(2, i) = lat;
    e_neighbors(2, i) = lat;

    nw_neighbors(1, i) = long  - 2*i*fifty_km_minutes;
    sw_neighbors(1, i) = long  - 2*i*fifty_km_minutes;
    ne_neighbors(1, i) = long  + 2*i*fifty_km_minutes;
    se_neighbors(1, i) = long  + 2*i*fifty_km_minutes;
    nw_neighbors(2, i) = lat   + 2*i*fifty_km_minutes;
    sw_neighbors(2, i) = lat   - 2*i*fifty_km_minutes;
    ne_neighbors(2, i) = lat   + 2*i*fifty_km_minutes;
    se_neighbors(2, i) = lat   - 2*i*fifty_km_minutes; 
end

neighbors = [n_neighbors; s_neighbors; w_neighbors; e_neighbors; nw_neighbors; sw_neighbors; ne_neighbors; se_neighbors];
% l = [n_neighbors, s_neighbors, w_neighbors, e_neighbors, nw_neighbors, sw_neighbors, ne_neighbors, se_neighbors];
% l = l';
% locations = table([l(:,1)],[l(:,2)]);
% locations.Properties.VariableNames = {'Lat' 'Long'}
% 
% %for points = 1:16
%     geoplot(locations.Lat, locations.Long,'r*')
% %end

results = ones(16,16);

location = ["north", "north", "south", "south", "west", "west", "east", "east","northwest", "northwest", "southwest", "southwest", "northeast", "northeast", "southeast", "southeast"];

for direction = 1:2:16
    "Begin " + location(direction) + ":"
    for points = 1:16
        startTime = datetime(2021,9,14,0,0,0);
        stopTime = startTime + days(1);
        sampleTime = 15;
        sc = satelliteScenario(startTime, stopTime, sampleTime);
        sat = satellite(sc, "constellation_curr");
        
        for idx = 1:numel(sat)
            name = sat(idx).Name;
            conicalSensor(sat(idx),"Name",name,"MaxViewAngle",130);
        end
        
        name = "Center";
        minElevationAngle = 25; % degrees
        geoSite = groundStation(sc, long, lat, "Name", name, "MinElevationAngle",minElevationAngle);
        geoSite2 = groundStation(sc, neighbors(direction, points), neighbors(direction + 1, points), "Name", "Neighbor", "MinElevationAngle",minElevationAngle);
        %geoplot(neighbors(direction, points), neighbors(direction + 1, points),'r-*')
        for idx = 1:numel(sat)
            ac(idx) = access(geoSite2, sat(idx), geoSite);
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
    
        n = nnz(systemWideAccessStatus);
        systemWideAccessDuration = n*sc.SampleTime; % seconds
        scenarioDuration = seconds(sc.StopTime - sc.StartTime);
        access_percentage = (systemWideAccessDuration/scenarioDuration)*100
        results(direction, points) = systemWideAccessDuration/60;

    end
end
    xlswrite(['Seattle.xlsx'],results)
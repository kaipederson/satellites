startTime = datetime(2021,9,14,0,0,0);
stopTime = startTime + days(1);
sampleTime = 1;
sc = satelliteScenario(startTime, stopTime, sampleTime);
sat = satellite(sc, "constellation_curr")
hide([sat.Orbit])
leadTime = 3600;                                          % seconds
trailTime = leadTime;
%gt = groundTrack(sat,"LeadTime",leadTime,"TrailTime",trailTime)


%gs = groundStation(sc, 43.07255162648905, -89.41145475527613)

for idx = 1:numel(sat)
    name = sat(idx).Name;
    conicalSensor(sat(idx),"Name",name,"MaxViewAngle",130);
end

% Retrieve the cameras
cam = [sat.ConicalSensors];

name = "Madison";
minElevationAngle = 25; % degrees
geoSite = groundStation(sc, 43.07255162648905, -89.41145475527613, "Name", name, "MinElevationAngle",minElevationAngle)

for idx = 1:numel(cam)
    access(cam(idx),geoSite);
end

% Retrieve the access analysis objects
ac = [cam.Accesses];

% Properties of access analysis objects
ac(1)
accessIntervals(ac)
time = datetime(2021,9,14,02,50,04);
pos = states(sat(1),time,"CoordinateFrame","geographic");
angle = satcom.internal.linkbudgetApp.computeElevation(43.07255162648905, -89.41145475527613, 0, pos(1), pos(2), pos(3))
name = sat(1).Name
tx_opps = [];
prev_angle = 0;

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

n = nnz(systemWideAccessStatus)
systemWideAccessDuration = n*sc.SampleTime % seconds
scenarioDuration = seconds(sc.StopTime - sc.StartTime)
systemWideAccessPercentage = (systemWideAccessDuration/scenarioDuration)*100



hide([sat.Orbit])
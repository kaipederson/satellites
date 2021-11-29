startTime = datetime(2021,9,14,0,0,0);
stopTime = startTime + days(1);
sampleTime = 10;
sc = satelliteScenario(startTime, stopTime, sampleTime);
sat = satellite(sc, "constellation_curr")
hide([sat.Orbit])
leadTime = 3600;                                          % seconds
trailTime = leadTime;
%gt = groundTrack(sat,"LeadTime",leadTime,"TrailTime",trailTime)


%gs = groundStation(sc, 43.07255162648905, -89.41145475527613)

for idx = 1:numel(sat)
    name = sat(idx).Name + " Camera";
    conicalSensor(sat(idx),"Name",name,"MaxViewAngle",130);
end

% Retrieve the cameras
cam = [sat.ConicalSensors]
%this segment shows the fov of the cameras, but is a little misleading
fov = fieldOfView(cam([cam.Name] == "7530 Camera"));
fov = fieldOfView(cam([cam.Name] == "40054 Camera"));
fov = fieldOfView(cam([cam.Name] == "20442 Camera"));
fov = fieldOfView(cam([cam.Name] == "43937 Camera"));
fov = fieldOfView(cam([cam.Name] == "42017 Camera"));
fov = fieldOfView(cam([cam.Name] == "44881 Camera"));
fov = fieldOfView(cam([cam.Name] == "40903 Camera"));
fov = fieldOfView(cam([cam.Name] == "39444 Camera"));

name = "Madison";
minElevationAngle = 25; % degrees
geoSite = groundStation(sc, 43.07255162648905, -89.41145475527613, "Name", "Madison", "MinElevationAngle",minElevationAngle);
geoSite2 = groundStation(sc, 44.0805, -103.2310, "Name", "Seattle", "MinElevationAngle",minElevationAngle);

for idx = 1:numel(cam)
    access(cam(idx),geoSite);
    access(cam(idx),geoSite2);
end

% Retrieve the access analysis objects
ac = [cam.Accesses];
for idx = 1:numel(ac)
    ac(idx).LineColor = 'green';
end

% Properties of access analysis objects
ac(1)

hide([sat.Orbit])
play(sc)
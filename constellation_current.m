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
    name = sat(idx).Name + " Camera";
    conicalSensor(sat(idx),"Name",name,"MaxViewAngle",130);
end

% Retrieve the cameras
cam = [sat.ConicalSensors]
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

% for hr = 0:23
%     for min = 0:59 
%         for sec = 0:5:59
%             time = datetime(2021,9,14,hr,min,sec);
%             pos = states(sat(1),time,"CoordinateFrame","geographic");
% 
%             angle = satcom.internal.linkbudgetApp.computeElevation(43.07255162648905, -89.41145475527613, 0, pos(1), pos(2), pos(3));
%             if angle >= 25
%                 if angle > prev_angle && prev_angle < 25
%                     prev_angle = angle;
%                     tx_opp = ['START'; string(time); string(pos);angle];
%                     tx_opps = [tx_opps, tx_opp];
%                 end
% %                 tx_opp = [angle; string(time)];
% %                 tx_opps = [tx_opps, tx_opp];
%             elseif prev_angle > 25
%                 tx_opp = ['END'; string(time); string(pos);angle];
%                 tx_opps = [tx_opps, tx_opp];
%             end 
%             prev_angle = angle;
%         end
%     end
% end

hide([sat.Orbit])
play(sc)
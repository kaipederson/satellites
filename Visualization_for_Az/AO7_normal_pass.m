startTime = datetime(2021,9,15,19,40,0);
stopTime = datetime(2021,9,15,19,50,0);
sampleTime = 1;
sc = satelliteScenario(startTime, stopTime, sampleTime);
sat = satellite(sc, "AO7(7530)_TLE")

leadTime = 3600;                                          % seconds
trailTime = leadTime;
gt = groundTrack(sat,"LeadTime",leadTime,"TrailTime",trailTime)

%gs = groundStation(sc, 43.07255162648905, -89.41145475527613)

% old_data = xlsread('AO_73.xlsx');
% if ~isempty(old_data)
%     delete(old_data)
% end

for idx = 1:numel(sat)
    name = sat(idx).Name + " Camera";
    conicalSensor(sat(idx),"Name",name,"MaxViewAngle",90);
end


% Retrieve the cameras
cam = [sat.ConicalSensors]
fov = fieldOfView(cam([cam.Name] == "7530 Camera"))
name = "Madison";
minElevationAngle = 25; % degrees
geoSite = groundStation(sc, 43.07255162648905, -89.41145475527613, "Name",name, "MinElevationAngle",minElevationAngle);

for idx = 1:numel(cam)
    access(cam(idx),geoSite);
end

% Retrieve the access analysis objects
ac = [cam.Accesses];

% Properties of access analysis objects
ac(1)



play(sc);
tx_opps = [];
prev_angle = 0;

for hr = 19
    for min = 40:50
        for sec = 0:15:45
            time = datetime(2021,9,15,hr,min,sec);
            pos = states(sat(1),time,"CoordinateFrame","geographic");
            angle = satcom.internal.linkbudgetApp.computeElevation(43.07255162648905, -89.41145475527613, 0, pos(1), pos(2), pos(3));
            az = aer(gs, sat, time);
            tx_opp = [string(time);angle;az];
            tx_opps = [tx_opps, tx_opp];
        end
    end
end
% 
xlswrite('normal_pass1.xlsx',tx_opps)
% 
% %play(sc)
%usin git now
startTime = datetime(2021,9,9,0,0,0);
stopTime = startTime + days(1);
sampleTime = 60;
sc = satelliteScenario(startTime, stopTime, sampleTime);
CAS_6 = satellite(sc, "CAS6_TLE", 'Name', 'CAS-6')
JO_97 = satellite(sc, "JO97_TLE", 'Name', 'JO-97')
AO_73 = satellite(sc, "AO73_TLE", 'Name', 'AO-73')
gs_la_crosse = groundStation(sc, 43.81810593877638, -91.21248032918966, 'Name', 'La Crosse')
gs_madison_erb = groundStation(sc, 43.07255162648905, -89.41145475527613, 'Name', 'ERB')

% time = datetime(2021,7,15,11,18,23)
% pos_AO_73 = states(AO_73(1),time,"CoordinateFrame","geographic")
% time = datetime(2021,7,15,17,24,42)
% pos_CAS_6 = states(CAS_6(1),time,"CoordinateFrame","geographic")
% time = datetime(2021,7,15,17,19,28)
% pos_CAS_4 = states(CAS_4(1),time,"CoordinateFrame","geographic")

play(sc)
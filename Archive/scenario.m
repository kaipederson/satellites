%usin git now
startTime = datetime(2021,9,21,0,0,0);
stopTime = startTime + days(1);
sampleTime = 60;
sc = satelliteScenario(startTime, stopTime, sampleTime);
CAS_6 = satellite(sc, "Current_TLEs/CAS6(44881)_TLE", 'Name', 'CAS6')
PSAT = satellite(sc, "Current_TLEs/PSAT(40054)_TLE", 'Name', 'PSAT')
LO19 = satellite(sc, "Current_TLEs/LO19(20442)_TLE", 'Name', 'LO19')
FO99 = satellite(sc, "Current_TLEs/FO99(43937)_TLE", 'Name', 'FO99')
EO88 = satellite(sc, "Current_TLEs/EO88(42017)_TLE", 'Name', 'EO88')
CAS3 = satellite(sc, "Current_TLEs/CAS3(40903)_TLE", 'Name', 'CAS3')
AO73 = satellite(sc, "Current_TLEs/AO73(39444)_TLE", 'Name', 'AO73')
AO7 = satellite(sc, "Current_TLEs/AO7(7530)_TLE", 'Name', 'AO7')


gs_la_crosse = groundStation(sc, 43.81810593877638, -91.21248032918966, 'Name', 'La Crosse')
gs_madison_erb = groundStation(sc, 43.07255162648905, -89.41145475527613, 'Name', 'ERB')


play(sc)
%usin git now
startTime = datetime(2021,9,15,1,57,39);
stopTime = startTime + days(1);
sampleTime = 60;
sc = satelliteScenario(startTime, stopTime, sampleTime);
CAS_6 = satellite(sc, "DOSAAF-85(44909)_TLE", 'Name', 'new')
CAS_4 = satellite(sc, "DOSAAF-85(44909)_TLE_15AUG", 'Name', 'old')
CAS_4 = satellite(sc, "DOSAAF-85(44909)_TLE_08SEP", 'Name', 'old')
gs_la_crosse = groundStation(sc, 43.81810593877638, -91.21248032918966, 'Name', 'La Crosse')
gs_madison_erb = groundStation(sc, 43.07255162648905, -89.41145475527613, 'Name', 'ERB')


play(sc)
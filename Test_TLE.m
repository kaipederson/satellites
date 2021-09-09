%usin git now
startTime = datetime(2021,7,15,1,57,39);
stopTime = startTime + days(1);
sampleTime = 1;
sc = satelliteScenario(startTime, stopTime, sampleTime);
AO_73 = satellite(sc, "AO73_TLE", 'Name', 'AO-73')
gs_la_crosse = groundStation(sc, 43.81810593877638, -91.21248032918966, 'Name', 'La Crosse')
gs_madison_erb = groundStation(sc, 43.07255162648905, -89.41145475527613, 'Name', 'ERB')

tx_opps = [];

for hr = 0:23
    for min = 0:59 
        for sec = 0:10:59
            time = datetime(2021,7,15,hr,min,sec);
            pos_AO_73 = states(AO_73(1),time,"CoordinateFrame","geographic");

            angle = satcom.internal.linkbudgetApp.computeElevation(43.81810593877638, -91.21248032918966, 0, pos_AO_73(1), pos_AO_73(2), pos_AO_73(3));
            if angle > 25
                tx_opps = [tx_opps, angle, string(time)];
            end
        end
    end
end


%play(sc)
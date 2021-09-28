startTime = datetime(2021,9,22,0,0,0);
stopTime = startTime + days(1);
sampleTime = 1;
sc = satelliteScenario(startTime, stopTime, sampleTime);
sat = satellite(sc, "FO99(43937)_TLE")
gs_la_crosse = groundStation(sc, 43.81810593877638, -91.21248032918966, 'Name', 'La Crosse')
gs_madison_erb = groundStation(sc, 43.07255162648905, -89.41145475527613, 'Name', 'ERB')

% old_data = xlsread('AO_73.xlsx');
% if ~isempty(old_data)
%     delete(old_data)
% end

tx_opps = [];
prev_angle = 0;

for hr = 0:23
    for min = 0:59 
        for sec = 0:10:59
            time = startTime;
            pos = states(sat(1),time,"CoordinateFrame","geographic");

            angle = satcom.internal.linkbudgetApp.computeElevation(43.07255162648905, -89.41145475527613, 0, pos(1), pos(2), pos(3))
            if angle >= 35
                if angle > prev_angle && prev_angle < 25
                    prev_angle = angle;
                    tx_opp = ['START'; string(time); string(pos);angle];
                    tx_opps = [tx_opps, tx_opp];
                end
            elseif prev_angle > 25
                tx_opp = ['END'; string(time); string(pos);angle];
                tx_opps = [tx_opps, tx_opp];
            end 
            prev_angle = angle;
        end
    end
end

xlswrite('Output_Coverage_EXP/FO99.xlsx',tx_opps)

%play(sc)
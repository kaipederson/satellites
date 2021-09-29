startTime = datetime(2021,9,21,0,0,0);
stopTime = startTime + days(1);
sampleTime = 1;
sc = satelliteScenario(startTime, stopTime, sampleTime);
sat = satellite(sc, "AO7(7530)_TLE")
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
        for sec = 0:5:59
            time = datetime(2021,9,15,hr,min,sec);
            pos = states(sat(1),time,"CoordinateFrame","geographic");

            angle = satcom.internal.linkbudgetApp.computeElevation(46.83406483753299, -121.72637640528434, 3048, pos(1), pos(2), pos(3));
            if angle >= 25
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

xlswrite('Coverage_Output_Rainier/AO_7.xlsx',tx_opps)

%play(sc)
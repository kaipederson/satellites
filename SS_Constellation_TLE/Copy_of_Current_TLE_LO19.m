startTime = datetime(2021,9,15,0,0,0);
stopTime = startTime + days(1);
sampleTime = 1;
sc = satelliteScenario(startTime, stopTime, sampleTime);
sat = satellite(sc, "LO19(20442)_TLE")
gs_la_crosse = groundStation(sc, 43.81810593877638, -91.21248032918966, 'Name', 'La Crosse')
gs_madison_erb = groundStation(sc, 43.07255162648905, -89.41145475527613, 'Name', 'ERB')

% old_data = xlsread('AO_73.xlsx');
% if ~isempty(old_data)
%     delete(old_data)
% end

tx_opps = [];
prev_angle = 0;



            time = datetime(2021,9,15,09,02,20);
            pos = states(sat(1),time,"CoordinateFrame","geographic");
            angle = satcom.internal.linkbudgetApp.computeElevation(43.07255162648905, -89.41145475527613, 0, pos(1), pos(2), pos(3));
            az = aer(gs_madison_erb, sat, time);
            tx_opp = ['START'; string(time); string(pos);angle;az];
            tx_opps = [tx_opps, tx_opp];

            
            time = datetime(2021,9,15,09,08,35);
            pos = states(sat(1),time,"CoordinateFrame","geographic");
            angle = satcom.internal.linkbudgetApp.computeElevation(43.07255162648905, -89.41145475527613, 0, pos(1), pos(2), pos(3));
            az = aer(gs_madison_erb, sat, time);
            tx_opp = ['END'; string(time); string(pos);angle;az];
            tx_opps = [tx_opps, tx_opp];
            
                        time = datetime(2021,9,15,20,20,10);
            pos = states(sat(1),time,"CoordinateFrame","geographic");
            angle = satcom.internal.linkbudgetApp.computeElevation(43.07255162648905, -89.41145475527613, 0, pos(1), pos(2), pos(3));
            az = aer(gs_madison_erb, sat, time);
            tx_opp = ['START'; string(time); string(pos);angle;az];
            tx_opps = [tx_opps, tx_opp];

            
            time = datetime(2021,9,15,20,26,00);
            pos = states(sat(1),time,"CoordinateFrame","geographic");
            angle = satcom.internal.linkbudgetApp.computeElevation(43.07255162648905, -89.41145475527613, 0, pos(1), pos(2), pos(3));
            az = aer(gs_madison_erb, sat, time);
            tx_opp = ['END'; string(time); string(pos);angle;az];
            tx_opps = [tx_opps, tx_opp];
            


xlswrite('Error_Window_LO19.xlsx',tx_opps)

%play(sc)
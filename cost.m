% ******************************************************************
% *   cost.m
% *   The code to help to put a economic value to losses
% ******************************************************************

% Initial parameter

% param_turbine: Power of each turbine in MW
param_turbine = 5;

param_fullyrated = 0;


% param_cables
% Dimension/mm2 | Cost | Rated Current / kA | resistance/km | number of turbines it can
% power
% Fill in separately
load param_cables.mat

% param_voltage in kV
param_voltage = 66000;

% param_failure Cable Availability Failure Rate in failures/km/annum
param_failure = 0.0094;

% param_MTTR Cable Availability MTTR in days
param_MTTR = 60;

param_rate = 0.03;
param_energy_price = 150;
param_WFlife = 25;

% Dimension of the cable
for r = 1:size(results,1);
    
    if((r == 1) || (results(r,1)~= results(r-1,1)))
        results(r,5) = capacity/2;
    else
        results(r,5) = results(r-1,5)-1;
    end
    
end
results(:,5) = abs(results(:,5));

if param_fullyrated == 1
    results(:,6) = max(results(:,5));
else 
    results(:,6) = results(:,5);
    
    % Make the "zeros" into 1
    ListOfZeros = find(results(:,6)==0);
    results(ListOfZeros,6)=1;
end

    WT_current = param_turbine*1000000/param_voltage;

    param_cables(:,5) = floor(param_cables(:,3)./WT_current);

    for r = 1:size(results,1)
        [row,~] = find(param_cables(:,5)>=results(r,6),1);
        results(r,7) = row;
    end


% I2R losses in MWh
% Resistance of cable/km * distance * current^2
results(:,8) =  param_cables(results(:,7),4) .* results(:,4) .* power(results(:,5)*WT_current,2);

% CapEx
results(:,9) = param_cables(results(:,6),2) .* results(:,4);

% Risk of cable Outage in MW/year

if param_fullyrated == 1
    results(:,10) = 0;
else
    results(:,10) = sign(results(:,5)).*((results(:,5)-1) .* (param_turbine) .* results(:,4)) .* param_failure .* param_MTTR*24/8760 ;
end

% NPV losses
CashFlow(1:param_WFlife) = (sum(results(:,8))+sum(results(:,10)))/1000000*param_energy_price*8760;
CashFlow(1) = CashFlow(1) + sum(results(:,9));
NPV_losses = pvvar(CashFlow, param_rate)











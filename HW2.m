% Homework #2
% This script records my attempt to solving the provided questions to the
% assigned Homework #2

% Goal: We aim to minimize the time that it takes for the bath temperature to settle to (and,
% remain within) of the desired temperature (that is, within 5% of the step up from )
%-------------------------------------------------------------------------
% Part I: whats wrong with S_u, why is it a problem?

clear; close all; clc;

% Below are lines containing provided information and proportional
% controller results to observe.
%-------------------------------------------------------------------------

% System constraints and paramaters
Temp_Min = 10; % allowable minimum Temperature (C)
Temp_Max = 50; % allowable maximum Temperature (C)
Delay = 12; % due to water pipe travel (s) 
V_Bath = 1; % Liters
Flow_rate = 0.02; % dV/dt (L/s)
T_0 = 35; % Reference Temperature (t < 0)
T_1 = 45; % Desired Temperature (t > 0)

dT = T_1 - T_0; % Temperature Change
a_0 = Flow_rate/V_Bath; % Plant Parameter (s^-1)


% Plant model and Pade Approximation
F_2_2 = RR_pade(Delay,2,2); % F_2,2
G_0 = RR_tf(1, [1/a_0, 1]); % e^-ds/(s/a_0 + 1)
P = 1/0.5; % Loop Prefactor

G = F_2_2*G_0; % Delayed Plant

% Initial Controller: Proportional
K = 1; % To change later
D = K;

% Closed-loop Transfer Functions
% T = Y/R
T = G*D/(1 + G*D);
% S_u = U/R
S_u = D/(1+G*D);

% Figures
figure(1) 
RR_rlocus(G) 
axis([-.4 .3 -.3 .3])

figure(2)
g.T=200; 
RR_step(T_0+dT*P*T,g); 
axis([0 200 32 55]); 
title('Bath Temperature y(t)')

figure(3) 
RR_step(T_0+dT*P*S_u,g); 
axis([0 200 40 60]);
title('Valve/Input Temperature u(t)')

% ------------------------------------------------------------------------ 

% Initial Observation: As mentioned in the homework assignment, when using
% proportional control with K = 1, the step response of the transfer
% function T(s) appears valid. However, there is an issue with the step
% response associated with S_u(s), since the commanded input temperature
% does not obey the temperature constraints defined at the beginning of
% the experiment. The response reaches approximately 55 degrees Celsius,
% even though the maximum allowable input temperature is 50 degrees Celsius.

%% 
% Part II: Modifying the controller with the goal of having a faster setting time, 
% keeping the commanded input temperature less than 50 degrees Celsius, and making
% sure that the steady state value is the desired temperature, 45 degrees
% Celsius.

clear; close all; clc;

% System constraints and paramaters (Unchanged)
Temp_Min = 10; % allowable minimum Temperature (C)
Temp_Max = 50; % allowable maximum Temperature (C)
Delay = 12; % due to water pipe travel (s) 
V_Bath = 1; % Liters
Flow_rate = 0.02; % dV/dt (L/s)
T_0 = 35; % Reference Temperature (t < 0)
T_1 = 45; % Desired Temperature (t > 0)

dT = T_1 - T_0; % Temperature Change
a_0 = Flow_rate/V_Bath; % Plant Parameter (s^-1)


% Plant model and Pade Approximation (Unchanged)
F_2_2 = RR_pade(Delay,2,2); % F_2,2
G_0 = RR_tf(1, [1/a_0, 1]); % e^-ds/(s/a_0 + 1)
P = 1/0.5; % Loop Prefactor

G = F_2_2*G_0; % Delayed Plant

% Controller (Changed): Lead Controller (z < p)

% Note: The lead controller failed to meet the design requirement because
% the bath temperature did not reach the desired 45 degree Celsius
% steady-state value.

% Controller (Changed): Lead-Lag Controller

K = 0.27; 

% (z < p)
z_lead = 0.02;
p_lead = 0.06;
D_lead = RR_tf([1,z_lead], [1,p_lead]);

% (z > p)
% At steady-state, G(0)=1 and the desired 45 degree Celcius output requires T(0)=0.5.
% From T(0)=G(0)D(0)/(1+G(0)D(0)), D(0) must be equal to 1 to satisfy T(0).
z_lag = 0.2;
% Choosing lag ratio so D(0) = 1, ensuring the bath settles at the desired
% value, 45 degrees Celsius
lag_ratio = 1/(K*(z_lead/p_lead)); 
% Solving for the lag pole needed to satisfy D(0) = 1
p_lag = z_lag/lag_ratio; 
D_lag = RR_tf([1,z_lag], [1,p_lag]); 

% Complete Controller
D = K*D_lead*D_lag;

% Closed-loop Transfer Functions (Unchanged)
% T = Y/R
T = G*D/(1 + G*D);
% S_u = U/R
S_u = D/(1+G*D);

% Figures (Unchanged)
figure(1) 
RR_rlocus(G) 
axis([-.4 .3 -.3 .3])

figure(2)
g.T=200; 
RR_step(T_0+dT*P*T,g); 
axis([0 200 32 55]); 
title('Bath Temperature y(t)')
grid on
hold on

yline(44.5,'--')
yline(45.5,'--')
yline(45,':')

figure(3) 
RR_step(T_0+dT*P*S_u,g); 
axis([0 200 40 60]);
title('Valve/Input Temperature u(t)')

%%
% Part III: Having found a valid linear feedback controller using RR_pade(d,2,2),
% Now testing if this same controller still works with RR_pade(d,16,13),
% approximation of e^-ds.

clear; close all; clc;

% System constraints and paramaters (Unchanged)
Temp_Min = 10; % allowable minimum Temperature (C)
Temp_Max = 50; % allowable maximum Temperature (C)
Delay = 12; % due to water pipe travel (s) 
V_Bath = 1; % Liters
Flow_rate = 0.02; % dV/dt (L/s)
T_0 = 35; % Reference Temperature (t < 0)
T_1 = 45; % Desired Temperature (t > 0)

dT = T_1 - T_0; % Temperature Change
a_0 = Flow_rate/V_Bath; % Plant Parameter (s^-1)


% Plant model and Pade Approximation (Unchanged)
F_16_13 = RR_pade(Delay,16,13); % F_2,2
G_0 = RR_tf(1, [1/a_0, 1]); % e^-ds/(s/a_0 + 1)
P = 1/0.5; % Loop Prefactor

G = F_16_13*G_0; % Delayed Plant

% Controller: Lead-Lag Controller

K = 0.27; 

% (z < p)
z_lead = 0.02;
p_lead = 0.06;
D_lead = RR_tf([1,z_lead], [1,p_lead]);

% (z > p)
% At steady-state, G(0)=1 and the desired 45 degree Celcius output requires T(0)=0.5.
% From T(0)=G(0)D(0)/(1+G(0)D(0)), D(0) must be equal to 1 to satisfy T(0).
z_lag = 0.2;
% Choosing lag ratio so D(0) = 1, ensuring the bath settles at the desired
% value, 45 degrees Celsius
lag_ratio = 1/(K*(z_lead/p_lead)); 
% Solving for the lag pole needed to satisfy D(0) = 1
p_lag = z_lag/lag_ratio; % Finds p_lag that'll satisfy the equation above
D_lag = RR_tf([1,z_lag], [1,p_lag]); 

% Complete Controller
D = K*D_lead*D_lag;

% Closed-loop Transfer Functions (Unchanged)
% T = Y/R
T = G*D/(1 + G*D);
% S_u = U/R
S_u = D/(1+G*D);

% Figures (Unchanged)
figure(1) 
RR_rlocus(G) 
axis([-.4 .3 -.3 .3])

figure(2)
g.T=200; 
RR_step(T_0+dT*P*T,g); 
axis([0 200 32 55]); 
title('Bath Temperature y(t)')
grid on
hold on

yline(44.5,'--')
yline(45.5,'--')
yline(45,':')

figure(3) 
RR_step(T_0+dT*P*S_u,g); 
axis([0 200 40 60]);
title('Valve/Input Temperature u(t)')

% Observation: Does it still work? Yes! The step plots generated using the
% new F_16_13 approximation are still completely valid. After researching
% why this is the case, I've come to learn that ideally for robust
% controller designs, higher order Pade approximations should generate
% very similar plots to lower order ones.
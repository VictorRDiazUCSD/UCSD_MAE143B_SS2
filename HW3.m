% Homework #3
% The purpose of this script is to record my process to solving the
% questions provided for Homework #3

% Considering a plant G(s) = e^ds/(s+a) with delay d and stable pole at 
% s = -a, and proportional control design, D(s) = K

% Provided code to use for Questions #1, #2, and #3
% d=0.1; % Delay
% a=1; % Pole
% G=RR_pade(d,2,2)*RR_tf(1,[1 a]); % Plant TF with Approximation
% D=1; % Controller
% L=G*D; 
% figure(1)
% RR_rlocus(L);

%%
% Question #1
% For sufficiently small, is this system stable or unstable?

clear; close all; clc;

% Provided
d=0.1; % Delay
a=1; % Pole
G=RR_pade(d,2,2)*RR_tf(1,[1 a]); % Plant TF with Approximation
K = 16.5 % Gain Test Value
D=K; % Controller 
L=G*D; % Open-loop system
figure(1)
RR_rlocus(L);

% Observations: Lowering the gain to values within the range 0<K<16.5, the system 
% becomes entirely stable. The closed-loop poles remain on the LHP, left of the imaginary axis.

% Note: The system appear to be marginally stable at the critical gain of K ~= 16.5

%%
% Question #2
% For sufficiently large , is this system stable or unstable?

clear; close all; clc;

% Provided
d=0.1; % Delay
a=1; % Pole
G=RR_pade(d,2,2)*RR_tf(1,[1 a]); % Plant TF with Approximation
K = 17 % Gain Test Value
D=K; % Controller 
L=G*D; % Open-loop system
figure(1)
RR_rlocus(L);

% Observations: Increasing the gain to values K>16.5, the system becomes
% unstable. the open-loop poles move into the right-half plane, resulting
% in the system to be unstable. 

%%
% Question #3
% For the purpose of calculations, now take d = 0.1 and a = 1. Approximate the delay with a 2,2
% Padé expression. What value of K puts the system on the verge of instability?

% Answer: Based on testing a range of K values, K ~= 16.5 puts the system
% on the verge of instability. At this gain value, the closed-loop poles lie
% approximately on the imaginary axis, making the system marginally stable.
% For K > 16, the closed-loop poles move into the right-half plane,
% causing the system to become unstable.

%%
% Question #4
% Part A: Calculate the value of omega (w) for which the branch of the root locus
% crosses the imaginary axis:

clear; close all; clc;

% Provided Script
d=0.1; % Delay
a=1; % Pole
G=RR_pade(d,2,2)*RR_tf(1,[1 a]); % Plant TF with Approximation
K = 1 % Original gain
D=K; % Controller 
L=G*D; % Open-loop system
figure(1)
RR_rlocus(L);

% Observation: After zooming in on the root-locus plot, the branch intersects 
% with the imaginary axis at around w ~= 16.5.

% Part B: Execute the provided code to solve for controller D

omega = 16.45; % Frequency at which the root locus crosses the imaginary axis

% New provided code
figure(2), 
D=1*real(RR_evaluate(-1/L,i*omega)) 
RR_rlocus(G*D); 

% Observation: After implementing the newly provided code together with the 
% approximate omega (w) value, we are able to directly determine the critical value
% of K. In further detail, equation 10.6 shows that gain K can be determined from
% known closed loop poles using K = -a(s)/b(s). Knowing that the root loci 
% crosses the imaginary axis at s = j*w, the w seen on the plot can be
% utilized directly as an input for -1/L(j*w) to solve for K. Ultimately,
% this allows the critical gain to be determined without trial and error.

%%
% Question #5
% Now approximate the delay with a 16,12 Padé expression

% Part A: Following the above approach, what value of now puts the system 
% on the verge of instability?

clear; close all; clc;

% Provided Script
d=0.1; % Delay
a=1; % Pole
G=RR_pade(d,16,12)*RR_tf(1,[1 a]); % Plant TF with 16,12 Pade approximation
K=1; % Original gain unchanged
D=K; % Controller 
L=G*D; % Open-loop system
figure(1)    % Not relevant for this question
RR_rlocus(L);  

% Approximate omega values
omega_1 = 16.32;
omega_2 = 78.65;

% New provided code
figure(2), 
D_1=1*real(RR_evaluate(-1/L,i*omega_1))
D_2=1*real(RR_evaluate(-1/L,i*omega_2)) 
RR_rlocus(L); 

% Observation: After implementing the new order for the Pade approximation and
% repeating the process utilized in Question #4, the new root-locus plot has
% two different branches that intersect the imaginary axis, meaning that there
% are two corresponding omega values. With D(s) = K, each omega value can be
% used to determine a corresponding gain K. The minimum positive K between the
% two is the critical gain that puts the system at the verge of instability.
% After computing D for both, omega_1 generates the smaller gain, giving 
% a critical value of K = 16.35.

%%
% Question #6
% On an attached page, show two Nyquist plots, one in the case that is about half of the critical
% value reported in q.3 and q.4, and one in which is about twice this critical value. Describe precisely,
% below, how one of these Nyquist plots shows instability of the closed loop, and one shows stability. 

clear; close all; clc;

% From Question #4
%----------------------------------------------------------------------
% Provided Script
d=0.1; % Delay
a=1; % Pole
G=RR_pade(d,2,2)*RR_tf(1,[1 a]); % Plant TF with Approximation
K = 1 % Original gain
D=K; % Controller 
L=G*D; % Open-loop TF

% Frequency at which the root locus crosses the imaginary axis
omega = 16.45; 
%----------------------------------------------------------------------

% Two cases to look at, when the critical value is halved and doubled 

% K values: D = K
D=1*real(RR_evaluate(-1/L,i*omega)); 
D_half = D / 2; % Half of the critical gain from Question #4
D_double = D * 2; % Twice the critical gain from Question #4

% Open-Loop Transfer Functions
L_half = G*D_half
L_double = G*D_double


% Nyquist plots for the two cases
g.R = 100;
figure(3);
RR_nyquist(L_half,g);

figure(4);
RR_nyquist(L_double, g);
%%
% Checking open-loop poles through Root-Locus to support observation
figure(1)
RR_rlocus(L_half)
figure(2)
RR_rlocus(L_double)

% Observation: After generating the figures with respect to both cases,
% at half of the critical value, the Nyquist plot does not encircle the
% critical point -1 + j0. Since there are no open-loop poles in the RHP,
% the lack of encirclements indicates no closed-loop poles in the RHP,
% meaning the system is stable. On the other hand, when doubling the
% critical value, the corresponding Nyquist plot encircles the critical
% point -1 + j0. Since there are no open-loop poles in the RHP, this
% encirclement indicates closed-loop poles in the RHP, meaning the system
% is unstable.


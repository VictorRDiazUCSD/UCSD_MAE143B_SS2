% Homework #1
% The purpose of this code is to record my process to solving all the
% problems given in HW1
%%
% Problem #1: Design a lead compensator D_lead = (s+z)/(s+p) to give
% exactly 60 degrees of phase lead at w_g = 10 rad/s

clc;clear;close;

% Having looked at the plot 10.17(c), at 60 degrees, my alpha is around 13 

% Parameters
w_g = 10; % rad/s  <- given

alpha = 13; % <- found

% solving for p and z

z = w_g/sqrt(alpha);

p = w_g*sqrt(alpha);

% Bode Plot of D_Lead designed
D_lead = tf([1, z], [1, p]);
bode(D_lead);
grid on;

%%
% Problem #2(a): Design a lag compensator D_lag=(s+z)/(s+p) to increase low
% frequency gain by a factor of exactly z/p = 100 while reducing the phase
% at w_g = 10 rad/s by 5 degrees

clc;clear;close;

% Parameters
w_g = 10; % rad/s  <- given

degree = 5; % <- given

% solving for p and z
syms p 

Equation = atand(w_g/(100*p)) - atand(w_g/p) == (-1)*degree;

p_2 = vpasolve(Equation, p, 0.01); % Steers it toward the smaller positive root

% Converting symbolic numeric to normal numeric
p_2 = double(p_2);

z_2 = double(100*p_2);

% Bode Plot of D_Lag designed
D_lag = tf([1, z_2], [1, p_2]);
bode(D_lag);
grid on;

%%
% Problem #2(b): Design a double lag compensator D_lag=(s+z)/(s+p) to
% achieve the same spec as in q.2a

clc;clear;close;

% Parameters
w_g = 10; % rad/s  <- given

degree = 5; % <- given

% solving for p and z
syms p 

Equation = 2*(atand(w_g/(100*p)) - atand(w_g/p)) == (-1)*degree;

p_2 = vpasolve(Equation, p, 0.01); % Steers it toward the smaller positive root

% Converting symbolic numeric to normal numeric
p_2 = double(p_2);

z_2 = double(10*p_2);

% Bode Plot of D_Lag designed
D_lag = tf([1, z_2], [1, p_2]);

D_doublelag = D_lag^2;

bode(D_doublelag);
grid on;

%%
% Problem #3(a): Design a 4th-order Butterworth low-pass filter, for
% attenuating high-frequency noise, while reducing the phase at w_g = 10
% rad/s by 5 degrees.

clc;clear;close;

% Design the Butterworth filter parameters
n = 4; % Order of the filter

w_g = 10; %(rad/s)

w_c = 1; % Cut-off frequency

degree = 5 % reduction

% Calculate the transfer function for the Butterworth filter

Tranfer_Function_N = RR_LPF_butterworth(n,w_c);

% After plugging in s_hat into the normalized transfer function,
% and getting to the tan form, where q = w_g/wc.
syms q

Equation = -atand((2.6131*q-2.6131*q^3)/(q^4+3.4142*q^2+1)) == -5;

q_sol = vpasolve(Equation, q, 0.01);

% Convert symbolic numeric to normal numeric
q_sol = double(q_sol);

% Calculate the cut-off frequency based on the solution for q
w_c = w_g / q_sol;

% Bode plot of designed butterworth filter

D_butterworth = tf(1, [1 2.6131*w_c^3 3.4142*w_c^2 2.6131*w_c 1]);

bode(D_butterworth);
grid on

%%
% Problem #3(a): Design a 4th-order Butterworth low-pass filter, for
% attenuating high-frequency noise, while reducing the phase at w_g = 10
% rad/s by 5 degrees.

clc;clear;close;

% Design the Butterworth filter parameters
n = 4; % Order of the filter

w_g = 10; %(rad/s)

w_c = 1; % Cut-off frequency

degree = 5; % reduction

% Calculate the transfer function for the Butterworth filter
D_normal = RR_LPF_butterworth(n,w_c);

% After plugging in s_hat into the normalized transfer function,
% and getting to the tan form, where q = w_g/wc.
syms q

Equation = -atand((2.6131*q-2.6131*q^3)/(q^4+3.4142*q^2+1)) == -5;

q_sol = vpasolve(Equation, q, 0.01);

% Converting symbolic numeric to normal numeric
q_sol = double(q_sol);

% Calculate the cut-off frequency based on the solution for q
w_c = w_g / q_sol;

% Bode plot of designed butterworth filter
D_butterworth = tf(1, [1 2.6131*w_c^3 3.4142*w_c^2 2.6131*w_c 1]);

bode(D_butterworth);
grid on

%%
% Problem #3(b): Design a 4th order Inverse Chebyshev filter, for
% attenuating high frequency noise, while reducing the phase at w_g = 10
% rad/s by 5 degrees (take delta = .001).

%-----------------------------------------------------------------------
% Problem #3(a): Copy and pasted to plot both bodes together

clc;clear;close;

% Design the Butterworth filter parameters
n = 4; % Order of the filter

w_g = 10; %(rad/s)

degree = 5; % reduction

% Calculating the normal transfer function for the Butterworth filter
D_normal = RR_LPF_butterworth(n,1);

% After plugging in s_hat into the normalized transfer function,
% and getting to the tan form, where q = w_g/wc.
syms q

Equation = -atand((2.6131*q-2.6131*q^3)/(q^4+3.4142*q^2+1)) == -5;

q_sol = vpasolve(Equation, q, 0.01);

% Converting symbolic numeric to normal numeric
q_sol = double(q_sol);

% Calculate the cut-off frequency based on the solution for q
w_c = w_g / q_sol;

% Bode plot of designed butterworth filter
D_butterworth = tf(1, [1 2.6131*w_c^3 3.4142*w_c^2 2.6131*w_c 1]);

bode(D_butterworth);
grid on
hold on
%----------------------------------------------------------------------

% Design the Inverse Chebyshev filter parameters 
delta = 0.001; % Given delta for the filter design

% Design the transfer function for the Inverse Chebyshev filter
D_inverseChebyshev = RR_LPF_inv_chebyshev(n, delta, 1);

% After plugging in s_hat into the normalized transfer function,
% and getting to the tan form, where r = w_g/wc.

syms r

Equation_r = atand(0/(0.001*r^4+0.0080*r^2+0.0080))...
    -atand((0.0683*r-0.7744*r^3)/(r^4-0.2999*r^2+0.0080)) == -5;

r_sol = vpasolve(Equation_r, r, 0.01);

% Converting symbolic numeric to normal numeric
r_sol = double(r_sol)

% Solving for cut-off frequency w_c
w_c = w_g/r_sol 

% Bode plot of designed inverse Chebyshev filter
D_inverseChebyshev = tf([0.0010 0 0.0080*w_c^2 0 0.0080*w_c^4],...
    [1 0.7744*w_c 0.2999*w_c^2 0.0683*w_c^3 0.0080*w_c^4]);

bode(D_inverseChebyshev, 'r');

legend('D_butterworth', 'D_inverseChebyshev', 'Location','best')

grid on;
hold off;

%%
% Problem #4(a): Compute the CT compensator D_looping-shaping(s) =
% K*D_lead(s)*D_double-lag(s)*D_Inverse-Cheb(s)

clc;clear;close;

% All relevant information and compensator functions

w_c = 978.5149; %(rad/s)

delta = 0.001

s = tf('s');

D_lead = (s + 2.774)/(s + 36.056);

D_double_lag = ((s + 0.0411)/(s + 0.00411))^2;

D_inverse_Chebyshev = (0.0010*s^4+0.0080*w_c^2*s^2+0.0080*w_c^4)/...
    (s^4+0.7744*w_c*s^3+0.2999*w_c*s^2+0.0683*w_c^3*s+0.0080*w_c^4);

% Computing the CT compensator D_looping-shaping(s) = K*D_lead(s)*D_double-lag(s)*D_Inverse-Cheb(s)
K = 1; % Gain for the compensator
D_looping_shaping = K * D_lead * D_double_lag * D_inverse_Chebyshev;

% Problem #4(b): Convert D(s) to a DT difference equation in FIR form using
% Tustin's approximation with prewarping, taking the critical frequency as
% the crossover frequency w_g.

w_g = 10 

Tustins = c2dOptions('Method','tustin','PrewarpFrequency', w_g);

D_z = c2d(D_looping_shaping, delta, Tustins);

[num, den] = tfdata(D_z, 'v');

% Normalizing the numerator and denominator

b_bar = num/den(1);

a_bar = den/den(1);

% Round to 4 significant digits
a = round(a_bar, 4, 'significant');
b = round(b_bar, 4, 'significant');

% Putting everything in a table
n = (0:length(den)-1)';

T = table(n, a', b','VariableNames', {'n','a_n','b_n'});
disp(T)

%%
% Problem #5(a): Now consider a “cart-on-a-hill” unstable plant of the form G(s) = 100/(s^2-100).
% Design a lead compensator D_simple(s) using pole/zero cancellation and root locus techniques leveraging the
% approximate 2nd-order design guides, aiming for a rise time of t_r = 0.18 sec and overshoot of M_p = 15%

% Parameters

M_p = 0.15;

t_r = 0.18;

G = 100/((s-10)*(s+10));

% Solving for M_p

syms zeta 

Eqn = exp((-zeta*pi)/sqrt(1-zeta^2)) == 0.15;  

zeta_sol = vpasolve(Eqn, zeta, 0.5);

zeta_sol = double(zeta_sol)

% Solving for w_n

w_n = 1.8/t_r;


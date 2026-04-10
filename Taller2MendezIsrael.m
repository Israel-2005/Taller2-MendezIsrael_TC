%% TALLER 2
clear; clc; close all;

% SECCIÓN 1.5.1

num = 3;
den = [1 2 3];
Gs_base = tf(num, den);

figure('Name', 'Tarea 1: Respuestas directas G(s) base');
subplot(2,1,1);
impulse(Gs_base);
title('Respuesta al Impulso - Sistema sin retardo');
subplot(2,1,2);
step(Gs_base);
title('Respuesta al Escalón - Sistema sin retardo');

% Almacenar valores en vectores y graficar
[y_base, t_base] = step(Gs_base);
figure('Name', 'Tarea 2: Gráfica desde vectores');
plot(t_base, y_base, 'b', 'LineWidth', 1.5);
title('Respuesta al Escalón graficada desde vectores [y, t]');
xlabel('Tiempo (s)'); ylabel('Amplitud');
grid on;

delay = 2;
Gs_delay = tf(num, den, 'InputDelay', delay);


[y_imp_d, t_imp_d] = impulse(Gs_delay);
[y_step_d, t_step_d] = step(Gs_delay);

figure('Name', 'Tarea 4 y 5: Sistema con Retardo y Puntos Máximos');

subplot(2,1,1);
plot(t_imp_d, y_imp_d, 'LineWidth', 1.5); hold on; grid on;
% Marcar el valor máximo
[max_imp, idx_imp] = max(y_imp_d);
plot(t_imp_d(idx_imp), max_imp, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
text(t_imp_d(idx_imp)+0.5, max_imp, sprintf('Máx: %.2f', max_imp));
title('Respuesta al Impulso con Retardo (2s)');
xlabel('Tiempo (s)'); ylabel('Amplitud');

% Escalón
subplot(2,1,2);
plot(t_step_d, y_step_d, 'LineWidth', 1.5); hold on; grid on;
% 5. Encontrar y marcar el valor máximo
[max_step, idx_step] = max(y_step_d);
plot(t_step_d(idx_step), max_step, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
text(t_step_d(idx_step)+0.5, max_step, sprintf('Máx: %.2f', max_step));
title('Respuesta al Escalón con Retardo (2s)');
xlabel('Tiempo (s)'); ylabel('Amplitud');

% Verificar el tiempo 
% Buscamos el primer índice donde la salida es mayor a una tolerancia pequeña
tolerancia = 1e-3;
idx_inicio = find(y_step_d > tolerancia, 1);
tiempo_respuesta = t_step_d(idx_inicio);
fprintf('El sistema con retardo comienza a responder aproximadamente en t = %.2f segundos.\n', tiempo_respuesta);



% SECCIÓN 1.5.2: Respuesta a señales arbitrarias

t1 = 0:0.1:30;
u1 = zeros(size(t1));
u1(t1 >= 10 & t1 < 20) = 5;
u1(t1 >= 20) = 10;

figure('Name', 'Tarea 1 y 2: Señal Fig 1.2');
subplot(1,2,1);
plot(t1, u1, '--', 'LineWidth', 1.5); grid on;
title('(a) Señal arbitraria'); xlabel('Tiempo'); ylabel('Amplitud');
ylim([0 12]);

subplot(1,2,2);
lsim(Gs_delay, u1, t1);
title('(b) Respuesta del sistema'); grid on;

% Repetir para la señal arbitraria 
t2 = 0:0.1:40;
u2 = zeros(size(t2));
u2(t2 >= 10 & t2 < 20) = 5; % Escalón a 5

indices_rampa = (t2 >= 20 & t2 < 30);
u2(indices_rampa) = 15 + (t2(indices_rampa) - 20) * ((25 - 15) / (30 - 20)); 
u2(t2 >= 30) = 25; % Se mantiene en 25

figure('Name', 'Tarea 3: Señal Fig 1.3');
subplot(1,2,1);
plot(t2, u2, '--', 'LineWidth', 1.5); grid on;
title('Señal Fig 1.3'); xlabel('Tiempo'); ylabel('Amplitud');
ylim([0 30]);

subplot(1,2,2);
lsim(Gs_delay, u2, t2);
title('Respuesta a Señal Fig 1.3'); grid on;


%% =========================================================================
% SECCIÓN 1.6: Actividad Reto (Parte 1)
% =========================================================================

%Generar señal aleatoria con rampa asc, escalón subida, rampa desc y escalón bajada
t3 = 0:0.1:50;
u3 = zeros(size(t3));

idx_ramp_up = (t3 >= 5 & t3 < 10);
u3(idx_ramp_up) = (t3(idx_ramp_up) - 5); 

u3(t3 >= 10 & t3 < 20) = 5;
u3(t3 >= 20 & t3 < 30) = 10;

% Escalón de subida drástico en t=30 a 20, seguido de rampa descendente
u3(t3 == 30) = 20; 
idx_ramp_down = (t3 > 30);

% Rampa descendente de 20 a 15 (entre t=30 y t=50)
u3(idx_ramp_down) = 20 - (t3(idx_ramp_down) - 30) * ((20 - 15) / (50 - 30));


figure('Name', 'Actividad Reto');
subplot(1,2,1);
plot(t3, u3, 'b-', 'LineWidth', 1.5); grid on;
title('Señal aleatoria'); 
xlabel('Tiempo (s)'); ylabel('Amplitud');
legend('Señal variante en el tiempo');
ylim([0 22]);

% 3. Utilizar G(s) con retardo para obtener la respuesta con lsim
subplot(1,2,2);
lsim(Gs_delay, u3, t3);
title('Linear Simulation Results');
grid on;
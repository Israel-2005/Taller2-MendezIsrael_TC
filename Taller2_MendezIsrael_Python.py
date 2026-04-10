import numpy as np
import matplotlib.pyplot as plt
import control as ctrl

# 1. Crear el vector de tiempo discreto (0 a 50 segundos con pasos de 0.1)
t = np.arange(0, 50.1, 0.1)
u = np.zeros_like(t)

# 2. Generar la señal por tramos 
idx_ramp_up = (t >= 5) & (t < 10)
u[idx_ramp_up] = (t[idx_ramp_up] - 5)

# Escalones y mesetas
u[(t >= 10) & (t < 20)] = 5
u[(t >= 20) & (t < 30)] = 10

# Escalón de subida drástico en t=30 a 20, seguido de rampa descendente
u[t == 30] = 20
idx_ramp_down = (t > 30)
# Rampa descendente de 20 a 15 (entre t=30 y t=50)
u[idx_ramp_down] = 20 - (t[idx_ramp_down] - 30) * ((20 - 15) / (50 - 30))


num = [3]
den = [1, 2, 3]
G_base = ctrl.tf(num, den)


# Retraso de 2 segundos = 20 muestras (ya que el paso es 0.1)
delay = 2
delay_samples = int(delay / 0.1)

# Creamos un vector de entrada retrasado llenando de ceros el inicio
u_delayed = np.zeros_like(u)
u_delayed[delay_samples:] = u[:-delay_samples]

# Simular la respuesta del sistema
_, y_delayed = ctrl.forced_response(G_base, t, u_delayed)

# Graficación 
fig, axs = plt.subplots(1, 2, figsize=(12, 5))

# Subplot 1
axs[0].plot(t, u, 'b-', linewidth=1.5, label='Señal variante en el tiempo')
axs[0].set_title('Señal aleatoria')
axs[0].set_xlabel('Tiempo (s)')
axs[0].set_ylabel('Amplitud')
axs[0].grid(True)
axs[0].legend(loc='upper left')
axs[0].set_ylim([0, 22])

# Subplot 2
axs[1].plot(t, y_delayed, 'b-', linewidth=1.5)
axs[1].set_title('Linear Simulation Results')
axs[1].set_xlabel('Tiempo (s)')
axs[1].set_ylabel('Amplitud')
axs[1].grid(True)

plt.tight_layout()
plt.show()
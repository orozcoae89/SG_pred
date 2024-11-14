#from google.colab import drive
#drive.mount('/content/drive')
import pandas as pd
# Imports to plot and process data
import pandas as pd
import plotly.graph_objects as go
from plotly.subplots import make_subplots
import matplotlib.pyplot as plt
import warnings
import plotly.io as pio

#df1 = pd.read_csv('/content/drive/My Drive/datasets_articulo/dataset_cafetera.csv')
df1 = pd.read_csv('./datasets/dataset_cafetera_microondas.csv')
curr = df1.iloc[8300:9500, 0] / 100.0
vol = df1.iloc[:, 1]  / 100.0

# Crear una figura de Plotly
#fig = go.Figure()
lenght = len(vol.to_numpy())
time = [element/8000 for element in range(lenght)]
# Plotting the data
#fig1 = go.Figure()
#fig1 = make_subplots(specs=[[{"secondary_y": True}]])
##fig1.add_trace(go.Scatter(x=time, y=vol, name = "V"))
##fig1.add_trace(go.Scatter(x=time, y=curr,  name = "A"),secondary_y=True)
#fig1.add_trace(go.Scatter(x=time, y=curr, name="Corriente [A]", line=dict(color='black')), secondary_y=True)
#fig1.update_xaxes(title_text="Time [s]")
#fig1.update_yaxes(title_text="Voltaje [V]", secondary_y=False)
#fig1.update_yaxes(title_text="Corriente [A]", secondary_y=True)
#
#fig1.update_layout(
#    plot_bgcolor='white',  # Fondo blanco
#    width=600,            # Ancho en píxeles (7 pulgadas * 300 dpi)
#    height=600,           # Alto en píxeles (7 pulgadas * 300 dpi)
#    margin=dict(l=40, r=40, t=40, b=40)  # Márgenes ajustados
#)

#go.Scatter()
#fig1.show()
plt.figure(figsize=(7,7))

fig1 = plt.plot(time[8300:9500], curr, color='black')


plt.xlabel('Time [s]')
plt.ylabel('Current [A]')
plt.title('Coffee machine', fontweight='bold')
#plt.show()

#fig1.xlabel('Time [s]')
#fig1.ylabel('Current [A]')
plt.savefig('current.png', dpi=300)
#Intalacion de libreria
install.packages("reticulate")

#Activacion de libreria reticulate
library(reticulate)

#Creacion de entorno virtual para python
virtualenv_create("env_hibrido")

#Instalacion de paquetenes necesarios para el entorno virtual
virtualenv_install("env_hibrido", packages = c("numpy", "pandas", "matplotlib", "seaborn", "scipy"))

#Activare el ambiente virtual
use_virtualenv("env_hibrido", required = TRUE)

#Codigo en python que se ejecutara en R
py_run_string("
# Importacion de librerias
import pandas as pd
import numpy as np

#Carga de dataset
df = pd.read_csv('./DDoS_dataset.csv')

#Eliminando variable de alta correlacion previamente analizado (Packet Length)
df_cleaned = df.drop('Packet Length', axis=1)
")

# Visualizar el DataFrame limpio en R
py$df_cleaned

# Convertir el DataFrame limpio de Python a R
df_r <- as.data.frame(py$df_cleaned)
df_complete <- as.data.frame(py$df)


# Crear histograma de target
library(ggplot2)
ggplot(data=df_r, aes(x="target")) +
  geom_histogram(stat = "count", fill="blue", color='black') +
  labs(title='Histograma de valores target', x='target', y='Frecuencia')
themes_economist_white()

#Activacion de libraria dplyr
library(dplyr)

# Agrupamiento y estadísticas en R
resumen <- df_complete %>%
  group_by(`Transport Layer`) %>%
  summarise(
    promedio_paquetes = mean(`Packet Length`, na.rm = TRUE),
    promedio_tiempo_por_paquetes = mean(`Packets/Time`, na.rm = TRUE)
  )

print(resumen)

#Imprecion de resumen
#`Transport Layer` promedio_paquetes promedio_tiempo_por_paquetes
#<chr>                         <dbl>                        <dbl>
#1 TCP                           1010.                         150.
#2 UDP                            136.                         306.

#Podemos ver el promedio de los paquetes enviados asi como el tiempo que se tardo por paquete

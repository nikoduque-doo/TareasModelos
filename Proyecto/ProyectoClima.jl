### A Pluto.jl notebook ###
# v0.20.3

using Markdown
using InteractiveUtils

# ╔═╡ 8778b6d8-70e1-4698-9f96-497b4408e4cd
using Plots, Dates, LinearAlgebra, Optim, DifferentialEquations, NLsolve;

# ╔═╡ b6c26648-9b48-4f62-bba9-174171b7414c
md"""
# Análisis Climático de Bogotá mediante el Modelo de Lorenz
"""

# ╔═╡ 5d9909c7-e2d6-431a-90eb-16ad64c77254
md"""
Proyecto realizado por Alan Acero, Johan López y Nicolás Duque para la clase Modelos Matemáticos I ($2019082$) del Semestre $2024-2$ en la Universidad Nacional de Colombia.

Las siguientes librerías fueron utilizadas para el desarrollo del proyecto:
"""

# ╔═╡ 878817a2-18b1-456e-baf0-561c548aa796
md"""
## 1. Introducción

El clima es uno de los factores más relevantes a considerar en diversos ámbitos: desde la construcción de ciudades y la planificación de viajes, hasta la decisión sobre la viabilidad de un cultivo o la capacidad de una ciudad para abastecer de agua a su población. Además, el cambio climático, un fenómeno global de creciente preocupación, nos ha llevado a modificar ciertas rutinas; sin embargo, estos cambios aún no son suficientes para prevenir o revertir sus efectos.

Las ciudades en las que habitamos se han transformado en centros donde los impactos del cambio climático son cada vez más evidentes. Esto puede atribuirse a la concentración de personas que experimentan los mismos fenómenos, lo que facilita su identificación, o a eventos extremos que no podemos ignorar, como las inundaciones por lluvias en nuestra capital, períodos de sequía severa que afectan los ciclos de cultivo, incendios forestales como los registrados a nivel nacional en enero, o huracanes y temporales extremos como las inundaciones de la DANA en Valencia, España.

En este contexto, el análisis del clima se convierte en una herramienta clave para prevenir desastres y optimizar la infraestructura frente a estos eventos. En particular, Colombia, como país tropical, se encuentra entre las naciones más vulnerables al cambio climático. Por ello, es crucial disponer de herramientas que permitan anticipar las dinámicas climáticas. Esto facilitará la implementación de políticas sociales y ambientales orientadas a gestionar información y prevenir fenómenos como inundaciones, deslizamientos, sequías e incendios.


"""

# ╔═╡ 8e87310e-c44e-4092-87cb-73b113b4696d
md"""
## 2. Objetivos
El presente trabajo tuvo como fines los siguientes objetivos:

● Estudiar el comportamiento del clima de las ciudades seleccionadas desde la
perspectiva de los sistemas dinámicos caóticos.

● Evaluar la precisión, confiabilidad y adaptabilidad del modelo propuesto para
predecir el comportamiento climático.

● Explorar y aplicar técnicas de análisis para resolver ecuaciones diferenciales no
lineales.
"""

# ╔═╡ ac3ee554-5ba2-48e9-8fa3-b57f53087ccd
md"""
## 3. Metodología

Inicialmente, el proyecto se centró en analizar los datos históricos del clima de Bogotá y Medellín correspondientes al período $2009-2022$, con el objetivo de predecir el comportamiento climático de estas ciudades para el año $2025$. Sin embargo, durante el proceso de modelado, nos encontramos con que los datos presentaban un comportamiento inesperado y difícil de capturar con los modelos tradicionales. Esta complejidad nos llevó a explorar alternativas para refinar nuestro enfoque.

Para superar estos desafíos, decidimos generar datos sintéticos que nos permitieran ajustar y mejorar nuestro modelo antes de aplicarlo nuevamente a los datos reales. Utilizamos modelos matemáticos basados en ecuaciones diferenciales, en particular una derivación de la ecuación de Lorenz, conocida por su capacidad para describir sistemas dinámicos complejos y caóticos. Este enfoque nos permitió adquirir una comprensión tanto cualitativa como cuantitativa del clima en el contexto nacional, proporcionando una idea para futuras predicciones y análisis.

"""

# ╔═╡ d8aa9c53-721a-4651-abe2-535d7f3c2506
md"""
## 4. Marco Teórico

La modelación del clima ha sido uno de los trabajos más retadores dentro de la física entre los siglos $XX$ y $XXI$, sin embargo, se han obtenido algunos resultados muy interesantes. Dentro de la literatura, encontramos el sistema de ecuaciones diferenciales de Lorentz, una aproximación y representación del comportamiento de la atmósfera como un fluido no newtoniano en un sistema de referencia en rotación, donde se producen intercambios de energía en distintos puntos.
 
Su deducción nació como la simplificación de respuestas a otros problemas: 
  
En primer lugar, se tuve en cuenta el análisis del comportamiento de la convección térmica provocada por la transferencia vertical del calor absorbido sobre la superficie terrestre a lo largo de la troposfera. Este problema se resolvió con el modelo de Rayleigh-Bénard, donde si la densidad disminuye con la altura, el sistema se mantiene estable, pero si la densidad aumenta en capas superiores, ocurre una situación inestable, donde cualquier perturbación puede hacer que el fluido más denso se mueva hacia abajo.

En segundo lugar, está el fenómeno de convección, los efectos invernadero y el deshielo. En $1962$, Barry Salztamn dedujo un par de ecuaciones diferenciales que explican las proyecciones sobre concentración de gases, los cambios medios mundiales de la temperatura, el aumento del nivel del mar y la estabilización de los gases invernadero en dos dimensiones:

$\begin{equation}
\left\{ \begin{aligned} 
  \dot{\eta} &= \theta - \eta\\
  \dot{\theta}&= b\theta -a\eta
\end{aligned} \right.
\end{equation}$

donde $\theta$ representa la desviación de la temperatura a un cierto nivel de referencia y $\eta$ representa la desviación de la latitud, y $a$, $b$ son parámetros (que desconocemos).

Finalmente, el sistema de Lorentz se redujo a tres ecuaciones diferenciales ordinarias acopladas que representan la convección de fluidos atmosféricos en tres dimensiones:

$\begin{equation}
\left\{ \begin{aligned} 
  \dot{x}&= -\sigma x - \sigma y\\
  \dot{y}&= -xz + \rho x - y\\
  \dot{z}&= xy - \beta z\\
\end{aligned} \right.
\end{equation}$

con parámetros: $\sigma$ (número de Prandtl) como la relación entre la viscosidad y la conductividad térmica, $\rho$ (número de Rayleigh) como la intensidad de la convección térmica  (si es mayor que un valor crítico, se generan células convectivas) y $\beta$ la relación con la estructura del flujo y la disipación térmica. Al igual, la función $x(t)$ representa la velocidad y la dirección de circulación de fluido, $y(t)$ la variación de temperatura entre las capas de la atmósfera, y $z(t)$ la variación de energía térmica del sistema. 


"""

# ╔═╡ 52833a85-f26d-47c8-a6fe-c6a990f345a4
md"""
## 5. Desarrollo del Modelo

### 5.1 Análisis Dimensional
Obtener los datos específicos de una ciudad dado las variables anteriores es laborioso, ya que no es posible encontrarlas explícitamente. De esta manera, hicimos un cambio de variables y funciones a partir de la información que podíamos obtener, justificando su comportamiento en el modelo y reasignando un nuevo valor cualitativo y dimensional a cada parámetro. 

Tomaremos $x(t)$ como la presión atmosférica, $y(t)$ como la temperatura y $z(t)$ como la precipitación (por simplicidad **x**, **y** y **z**), teniendo el siguiente modelo: 

$\begin{equation}
\left\{ \begin{aligned} 
  \dot{x}&= -\sigma x - \sigma y\\
  \dot{y}&= \rho x - y -xz \\
  \dot{z}&= xy - \beta z\\
\end{aligned} \right.
\end{equation}$

En nuestra primera ecuación, se relaciona la presión atmosférica ($x$) con la temperatura ($y$), donde  será la rapidez con que cambia la presión ($x$) en respuesta a las variaciones en la temperatura ($y$).

En la segunda ecuación, la temperatura ($y$) se ve influenciada por la presión ($x$) y la precipitación, donde si hay precipitaciones intensas (dadas por la precipitaciones y presión), la temperatura ($y$) disminuye debido a la absorción de calor por evaporación o enfriamiento. Aquí,  determina el nivel crítico de temperatura a partir del cual se generan precipitaciones ($z$) (a un alto valor de p implica que se requiere una temperatura elevada para generar lluvias).

En nuestra tercer ecuación, la precipitación ($z$) aumenta cuando la presión ($x$) y la temperatura ($y$) interactúan, al igual  controla la disipación de las lluvias, es decir, es la velocidad con que desaparece la lluvia tras la formación de nubes. 

### 5.2 Modificaciones al Modelo de Lorenz

Pese a que la ecuación diferencial cuenta con un razonamiento cualitativo, no tiene sentido dimensional, por lo tanto, decidimos agregar más variables y analizar qué unidades deben tener. De esta manera, llegamos a que nuestra EDO quedaría de la siguiente forma:

$\begin{equation}
\left\{ \begin{aligned} 
  \dot{x}&= \sigma (\lambda x - y)\\
  \dot{y}&= \rho x -\sigma y - \mu xz \\
  \dot{z}&= \nu xy - \sigma z\\
\end{aligned} \right.
\end{equation}$

donde cada parámetro y función tiene la siguiente dimensión:

$\begin{equation}
\begin{aligned} 
  	\left[ x \right] &= ML^{-1}T^{-2}\\
  	\left[ y \right] &= \theta\\
	\left[ z \right] &= L\\
	\left[ t \right] &= T\\
	\left[ \sigma \right] &= T^{-1}\\
	\left[ \lambda \right] &= ML^{-1}T^{-2}\theta ^{-1}\\
	\left[ \rho \right] &= L \theta T M^{-1}\\
	\left[ \mu \right] &= \theta T M^{-1}\\
	\left[ \nu \right] &= L^2 T \theta ^ {-1} M^{-1}\\
\end{aligned}.
\end{equation}$

De esta forma, podemos analizar el valor cualitativo de cada variable:
- El parámetro $\sigma$ es una frecuencia o tasa de cambio temporal del sistema
- El parámetro $\lambda$ relaciona presión con temperatura. Por lo tanto, es un coeficiente que relaciona la conductividad térmica respecto a una porción de la atmósfera en función del tiempo.
- El parámetro $\rho$ relaciona precipitaciones, temperatura y tiempo, respecto a la masa. Podría llega a ser un coeficiente que vincula la conductancia térmica específica (por unidad de masa)
- El parámetro $\mu$ es la disipación térmica, ya que relaciona temperatura y tiempo, respecto a la masa
- El parámetro $\nu$ es el coeficiente de difusividad térmica, esto es, cómo se transporta el calor en función del tiempo y el área.

### 5.3 Adimencionalización del Modelo
Ya conociendo los valores dimensionales de cada uno, se puede adimensionalizar nuestro sistema de EDOs.

Para la primera ecuación se tiene que:

$\begin{equation}
\begin{aligned} 
  	T &= \left[ \sigma \right]^a \left[ \lambda \right]^b \left[ x_0 \right]^c\\
	\left[ t_c \right]&= \left[ \sigma \right]^a \left[ \lambda \right]^b \left[ x_0 \right]^c\\
	&= T^{-a} M^b L^{-b} T^{-2b} \theta ^{-b} M^c L^{-c} T^{-2c}\\
	&= T^{-a-2b-2c} M^{b + c} L^{-b-c} \theta ^{-b}\\
\end{aligned}.
\end{equation}$

Por lo tanto, se tiene que:

$\begin{equation}
\begin{aligned} 
	-a-2b-2c &= 1 \\
	b+c &= 0 \\
	-b-c &= 0 \\
	-b &= 0
\end{aligned}.
\end{equation}$

Así, $a=-1$ y $t_c = \sigma ^{-1}$.

Para la segunda ecuación se tiene que:

$\begin{equation}
\begin{aligned} 
  	T &= \left[ \rho \right]^a \left[ \sigma \right]^b \left[ \mu \right]^c \left[ 		y_0 \right]^d\\
	\left[ t_c \right]&= \left[ \rho \right]^a \left[ \sigma \right]^b \left[ \mu \right]^c \left[ y_0 \right]^d\\
	&= L^a \theta ^a T^a M^{-a} T^{-b} \theta ^ c T^c M^{-c} \theta ^d\\
	&= T^{a-b+c} M^{a-c} L^a \theta^{a+c+d} \\
\end{aligned}.
\end{equation}$

Por lo tanto:

$\begin{equation}
\begin{aligned} 
	a-b+c &= 1 \\
	-a-c &= 0 \\
	a &= 0 \\
	a+c+d &= 0
\end{aligned}.
\end{equation}$

Así, $b=-1$ y $t_c = \sigma ^{-1}$.

Para la tercera ecuación se tiene que:

$\begin{equation}
\begin{aligned} 
  	T &= \left[ \nu \right]^a \left[ \sigma \right]^b \left[ z_0 \right]^c\\
	\left[ t_c \right]&= \left[ \nu \right]^a \left[ \sigma \right]^b \left[ z_0 \right]^c\\
	&= L^{2a} T^a M^{-a} \theta ^{-a} T^{-b} L^c\\
	&= T^{a-b} M^{-a} L^{2a+c} \theta^{-a} \\
\end{aligned}.
\end{equation}$

Por lo tanto:

$\begin{equation}
\begin{aligned} 
	a-b &= 1 \\
	-a &= 0 \\
	2a+c &= 0 \\
	a &= 0
\end{aligned}.
\end{equation}$

Así, $b=-1$ y $t_c = \sigma ^{-1}$.

De esta manera, el tiempo característico de las tres ecuaciones es $t_c = \sigma ^{-1}$. Ahora, analicemos las escalas características de $x_c$, $y_c$ y $z_c$:

$\begin{equation}
\begin{aligned} 
  	\left[ x_c \right] &= \left[ \sigma \right]^a \left[ \lambda \right]^b \left[ x_0 \right]^c\\
	ML^{-1}T^{-2} &= \left[ \sigma \right]^a \left[ \lambda \right]^b \left[ x_0 \right]^c\\
	&= T^{-a}M^bL^{-b}T^{-2b}\theta ^{-b}M^cL^{-c}T^{-2c}\\
	&= T^{-a-2b-2c}M^{b+c}L^{-b-c}\theta ^{-b}\\
\end{aligned}.
\end{equation}$

Lo que implica que:

$\begin{equation}
\begin{aligned} 
	a-2b-2c &= -2 \\
	b+c &= 1 \\
	-b-c &= 1 \\
	-b &= 0
\end{aligned}.
\end{equation}$

Así, $c=1$ y $x_c = x_0$.

$\begin{equation}
\begin{aligned} 
  	\left[ y_c \right] &= \left[ \rho \right]^a \left[ \sigma \right]^b \left[ \mu \right]^c \left[ 		y_0 \right]^d\\
	\theta &= \left[ \rho \right]^a \left[ \sigma \right]^b \left[ \mu \right]^c \left[ y_0 \right]^d\\
	&= L^a \theta ^a T^a M^{-a} T^{-b} \theta ^ c T^c M^{-c} \theta ^d\\
	&= T^{a-b+c} M^{a-c} L^a \theta^{a+c+d} \\
\end{aligned}.
\end{equation}$

Lo que implica que:

$\begin{equation}
\begin{aligned} 
	a &= 0 \\
	b &= 0 \\
	c &= 0 \\
	d &= 1
\end{aligned}.
\end{equation}$

Así $y_c = y_0$.

$\begin{equation}
\begin{aligned} 
  	\left[ z_c \right] &= \left[ \nu \right]^a \left[ \sigma \right]^b \left[ z_0 \right]^c\\
	L &= \left[ \nu \right]^a \left[ \sigma \right]^b \left[ z_0 \right]^c\\
	&= L^{2a} T^a M^{-a} \theta ^{-a} T^{-b} L^c\\
	&= T^{a-b} M^{-a} L^{2a+c} \theta^{-a} \\
\end{aligned}.
\end{equation}$

Por lo tanto, se tiene que:

$\begin{equation}
\begin{aligned} 
	a-b &= 0 \\
	-a &= 0 \\
	2a+c &= 1 \\
	a &= 0
\end{aligned}.
\end{equation}$

Así, $c= 1$ y $z_c = z_0$.

Finalmente, con la información anterior podemos definir las variables adimensionales de la siguiente forma:

$\begin{equation}
\begin{aligned} 
	\overline{x}&=\frac{x}{x_c}=\frac{x}{x_0} \\
	\overline{x}&=\frac{y}{y_c}=\frac{y}{y_0} \\
	\overline{x}&=\frac{z}{z_c}=\frac{z}{z_0} \\
	\overline{t}&=\frac{t}{t_c}=\sigma t
\end{aligned}.
\end{equation}$

Derivando las anteriores expresiones:

$\begin{equation}
\begin{aligned} 
	\frac{d\overline{x}}{d\overline{t}}&=\frac{1}{x_0}\frac{dx}{dt}\frac{dt}{d\overline{t}}=\frac{1}{x_0 \sigma} \frac{dx}{dt}\\
	\frac{d\overline{y}}{d\overline{t}}&=\frac{1}{y_0}\frac{dy}{dt}\frac{dt}{d\overline{t}}=\frac{1}{y_0 \sigma} \frac{dy}{dt}\\
	\frac{d\overline{z}}{d\overline{t}}&=\frac{1}{z_0}\frac{dz}{dt}\frac{dt}{d\overline{t}}=\frac{1}{z_0 \sigma} \frac{dz}{dt}\\
\end{aligned}.
\end{equation}$

Luego, reemplazamos en estos resultados las ecuaciones originales para obtener el modelo adimensionalizado:

$\begin{equation}
\begin{aligned} 
	\frac{d\overline{x}}{d\overline{t}}&= \frac{1}{x_0 \sigma} \sigma (\lambda x - y) = \frac{\lambda y_0}{x_0} \overline{y} - \overline{x}\\

	\frac{d\overline{y}}{d\overline{t}}&= \frac{1}{y_0 \sigma} (\rho x -\sigma y - \mu xz) = \frac{\rho x_0}{y_0 \sigma} \overline{x} -\overline{y} - \frac{\mu z_0 x_0}{\sigma y_0} \overline{x}\overline{z}\\

	\frac{d\overline{z}}{d\overline{t}}&= \frac{1}{z_0 \sigma} (\nu \overline{x} x_0 \overline{y} y_0 - \beta \overline{z} z_0) = \frac{\nu x_0 y_0}{z_0 \sigma} \overline{x} \overline{y} - \frac{\beta}{\sigma} \overline{z}
\end{aligned}.
\end{equation}$

A partir de lo anterior, se obtiene el modelo adimensionalizado:

$\begin{equation}
\left\{ \begin{aligned} 
  \dot{x}&= \tilde{\lambda} x - y\\
  \dot{y}&= \tilde{\rho} x - y - \tilde{\mu} xz \\
  \dot{z}&= \tilde{\nu} xy - z\\
\end{aligned} \right.
\end{equation}$
"""

# ╔═╡ 648dc8fd-4ac1-42c7-83e2-caf5f6ac0710
md"""
## 6. Ajuste de Datos

### 6.1 Recolección de Datos

Se realizó una sintetización de los datos disponibles en la página de Datos Abiertos del Gobierno de Colombia con el fin de obtener los valores promedio de presión (en $Hpa$), temperatura ($°C$) y precipitación ($mm$) mensuales del año $2009$ al $2022$.
"""

# ╔═╡ 477613ea-5cd1-4ddd-b53b-4c600097ece7
# ╠═╡ show_logs = false
begin
datosClima =
	[
		"2009-01"	744.40	14.05	31.00
		"2009-02"	744.17	14.22	48.00
		"2009-03"	745.84	14.32	79.00
		"2009-04"	744.13	14.71	96.00
		"2009-05"	744.24	14.58	77.00
		"2009-06"	744.21	14.35	60.00
		"2009-07"	744.82	13.92	34.00
		"2009-08"	744.56	14.47	30.00
		"2009-09"	744.83	14.56	35.00
		"2009-10"	743.30	14.34	104.00
		"2009-11"	743.27	14.70	88.00
		"2009-12"	744.79	14.64	63.00
		"2010-01"	743.89	14.67	14.00
		"2010-02"	743.49	15.62	21.00
		"2010-03"	744.00	15.92	20.00
		"2010-04"	744.40	15.09	152.00
		"2010-05"	744.75	15.17	163.00
		"2010-06"	744.20	14.55	76.00
		"2010-07"	746.78	14.39	91.00
		"2010-08"	748.06	14.35	32.00
		"2010-09"	747.68	14.33	45.00
		"2010-10"	747.48	14.50	132.00
		"2010-11"	746.66	14.30	179.00
		"2010-12"	746.15	13.72	123.00
		"2011-01"	746.24	13.83	44.00
		"2011-02"	746.99	14.11	58.00
		"2011-03"	744.20	14.01	85.00
		"2011-04"	741.82	14.33	170.00
		"2011-05"	741.86	14.76	122.00
		"2011-06"	742.32	14.63	48.00
		"2011-07"	743.03	13.93	39.00
		"2011-08"	744.47	14.21	32.00
		"2011-09"	744.88	13.96	36.00
		"2011-10"	743.67	13.80	111.00
		"2011-11"	743.44	13.97	145.00
		"2011-12"	743.20	14.27	97.00
		"2012-01"	744.02	14.29	49.00
		"2012-02"	746.28	14.00	36.00
		"2012-03"	746.93	14.1	80.00
		"2012-04"	747.55	13.95	144.00
		"2012-05"	747.51	14.40	33.00
		"2012-06"	747.90	14.22	30.00
		"2012-07"	744.77	13.70	45.00
		"2012-08"	744.85	13.74	40.00
		"2012-09"	745.14	13.95	21.00
		"2012-10"	743.94	14.41	103.00
		"2012-11"	743.96	14.40	52.00
		"2012-12"	743.42	14.04	54.00
		"2013-01"	701.26	14.46	8.00
		"2013-02"	695.84	14.35	97.00
		"2013-03"	693.66	14.84	57.00
		"2013-04"	696.67	14.91	119.00
		"2013-05"	705.72	14.61	101.00
		"2013-06"	744.50	14.48	24.00
		"2013-07"	744.80	13.59	37.00
		"2013-08"	744.31	13.94	46.00
		"2013-09"	744.33	14.30	29.00
		"2013-10"	744.01	14.03	73.00
		"2013-11"	743.02	13.98	129.00
		"2013-12"	745.37	14.04	72.00
		"2014-01"	746.11	14.31	49.00
		"2014-02"	745.87	14.52	94.00
		"2014-03"	746.52	14.67	96.00
		"2014-04"	746.89	14.71	62.00
		"2014-05"	747.24	14.76	77.00
		"2014-06"	747.34	14.23	44.00
		"2014-07"	748.46	14.04	30.00
		"2014-08"	750.29	13.66	19.00
		"2014-09"	750.93	14.12	36.00
		"2014-10"	750.54	14.30	48.00
		"2014-11"	750.12	14.36	117.00
		"2014-12"	750.17	13.97	132.00
		"2015-01"	750.43	14.03	40.00
		"2015-02"	750.83	14.63	32.00
		"2015-03"	750.85	14.81	98.00
		"2015-04"	750.98	14.92	53.00
		"2015-05"	751.50	15.08	20.00
		"2015-06"	751.77	14.08	66.00
		"2015-07"	751.77	14.33	34.00
		"2015-08"	751.51	14.52	22.00
		"2015-09"	751.56	14.62	32.00
		"2015-10"	751.45	14.85	45.00
		"2015-11"	750.29	14.99	72.00
		"2015-12"	750.68	14.50	2.00
		"2016-01"	750.70	15.40	6.00
		"2016-02"	750.21	15.93	19.00
		"2016-03"	751.28	16.19	84.00
		"2016-04"	750.89	15.41	142.00
		"2016-05"	751.90	15.12	80.00
		"2016-06"	752.36	14.35	27.00
		"2016-07"	715.36	14.26	34.00
		"2016-08"	716.54	14.32	45.00
		"2016-09"	717.31	14.37	68.00
		"2016-10"	750.73	14.84	83.00
		"2016-11"	750.55	14.45	184.00
		"2016-12"	750.69	14.30	59.00
		"2017-01"	750.91	14.06	50.00
		"2017-02"	751.18	14.41	74.00
		"2017-03"	751.25	14.34	177.00
		"2017-04"	751.50	14.88	75.00
		"2017-05"	752.05	14.78	175.00
		"2017-06"	752.03	14.60	96.00
		"2017-07"	752.55	14.09	24.00
		"2017-08"	751.95	14.44	70.00
		"2017-09"	751.66	14.82	33.00
		"2017-10"	751.18	14.41	84.00
		"2017-11"	750.43	14.29	162.00
		"2017-12"	729.48	14.35	85.00
		"2018-01"	750.47	13.92	46.00
		"2018-02"	750.86	14.72	34.00
		"2018-03"	750.91	14.63	93.00
		"2018-04"	751.72	13.94	120.00
		"2018-05"	751.94	14.35	90.00
		"2018-06"	752.11	14.08	32.00
		"2018-07"	752.09	14.16	36.00
		"2018-08"	752.36	13.85	29.00
		"2018-09"	751.10	14.52	22.00
		"2018-10"	740.15	14.85	49.00
		"2018-11"	717.33	14.98	83.00
		"2018-12"	718.47	14.34	3.00
		"2019-01"	714.78	14.63	18.00
		"2019-02"	717.84	15.45	46.00
		"2019-03"	712.69	15.42	84.00
		"2019-04"	715.21	15.43	138.00
		"2019-05"	715.54	15.09	120.00
		"2019-06"	716.18	14.79	74.00
		"2019-07"	715.84	14.63	43.00
		"2019-08"	715.27	14.36	38.00
		"2019-09"	718.93	15.01	62.00
		"2019-10"	715.88	14.55	94.00
		"2019-11"	715.95	15.13	231.00
		"2019-12"	716.11	15.25	50.00
		"2020-01"	716.94	15.15	53.00
		"2020-02"	718.87	15.36	94.00
		"2020-03"	718.96	15.84	84.00
		"2020-04"	711.68	15.64	64.00
		"2020-05"	713.26	15.39	70.00
		"2020-06"	712.01	14.89	79.00
		"2020-07"	707.52	14.57	90.00
		"2020-08"	712.94	14.85	41.00
		"2020-09"	714.08	14.54	86.00
		"2020-10"	713.49	14.93	35.00
		"2020-11"	719.23	14.65	240.00
		"2020-12"	715.31	14.69	94.00
		"2021-01"	751.63	14.40	18.00
		"2021-02"	707.81	15.20	51.00
		"2021-03"	717.23	14.20	112.00
		"2021-04"	716.60	15.30	103.00
		"2021-05"	716.64	15.1	161.00
		"2021-06"	718.41	14.59	143.00
		"2021-07"	718.77	14.50	49.00
		"2021-08"	718.35	14.52	123.00
		"2021-09"	728.30	14.47	61.00
		"2021-10"	751.19	14.90	191.00
		"2021-11"	717.08	14.82	163.00
		"2021-12"	712.17	15.49	48.00
		"2022-01"	701.73	14.94	23.00
		"2022-02"	712.01	14.77	140.00
		"2022-03"	751.67	15.06	100.00
		"2022-04"	750.80	14.92	161.00
		"2022-05"	751.99	15.06	96.00
		"2022-06"	751.60	13.95	159.00
		"2022-07"	751.85	14.70	71.00
		"2022-08"	751.88	14.39	58.00
		"2022-09"	751.81	14.21	77.00
		"2022-10"	751.48	14.61	216.00
		"2022-11"	752.15	14.56	164.00
		"2022-12"	750.73	14.30	67.00
	];
end

# ╔═╡ 6b95fe60-b791-4c5e-950f-bca6b0f132ab
md"""
Tras ésto se definió la función que corresponde al modelo y a la minimización por mínimos cuadrados.
"""

# ╔═╡ 81953c25-7fdf-4ff4-865f-3c4993e319b1
function lorenz(du, u, params, tiempo)
	du[1] = params[1]*u[2] - u[1];
	du[2] = params[2]*u[1] - u[2] - params[3]*u[1]*u[3];
	du[3] = params[4]*u[1]*u[2] - u[3];
end

# ╔═╡ 90588eb2-451a-4551-a4c5-14024c879a52
function residuoLorenz(params, vDatos, tiempo)
    # Time domain for the ODE
    dominioTiempo = (0.0, 168.0)
    
    # Initial conditions for the Lorenz system
    V0 = [738.47, 14.55, 75.80]
    
    # Define and solve the ODE problem
    EDO = ODEProblem(lorenz, V0, dominioTiempo, params)
    Sol = solve(EDO, Tsit5(), saveat=tiempo)
    
    # Extract model data at specified time points
    vModelo = hcat(Sol.u...)'

	println("Dimensiones de vDatos: ", size(vDatos))
	println("Dimensiones de vModelo: ", size(vModelo))
    
    # Calculate residuals
    res = vDatos .- vModelo
    nRes = norm(res)
    
    return nRes
end

# ╔═╡ 8079c6a6-4f5e-4511-9a5b-4015d1c6c681
md"""
Además de ésto, se usará una notación particular para esta parte del código, con el fin de facilitar su entendimiento:

##### Datos:

- **datosClima**: Corresponde a nuestros datos base, donde cada una de sus columnas representa: $1.$ Mes y año en cuestion; $2.$ Presión promedio en ese mes; $3.$ temperatura promedio en ese mes; $4.$ y precipitación promedio en ese mes.

- **years**: es un vector con el tamaño de la primera columna de datosClima, y aumenta de a 1. En particular indexa los meses dentro de los cuales trataremos los datos

- **datosC**: Es una matriz cuyas columnas son las correspondientes a la presion, temperatura y precipitacion en datosClima, guardado como Float64.

- **P**, **T**, **R**: estos funcionaran como prefijo a funciones o datos correspondientes a presión (**P**), temperatura (**T**) y precipitación (**R** por *Rain*)

- **XPorAños**: corresponde a la columna con el tipo de datos **X**, donde **X** puede ser **P**, **T** o **R**

- **Con**, **Dis**: sufijos relacionados a si un tipo de datos sera continuo (**Con**) o discreto (**Dis**)

- **meses**: prefijo correspondiente a el eje x de muchas de nuestras funciónes, donde se toma el intervalo de $0$ a $12$ de manera continua o discreta (caso particular **mesesDis2** es la repeticion de tomar datos cada $1$ unidad, y repetirlo iteradamente para poder mapearlos repetidamente)

- **DatosPart**: **DatosC** pero particionado por años, así en cada coordenada del vector se guardara una matriz $12 \times 3$ con los datos de ese año.

- **Param**: se usa para representar en un vector los parametros de ciertas funciones particulares.

- **Prom**: referente al promedio

más adelante se definiran otros.
"""

# ╔═╡ 34cfce9b-c8a8-487e-a7a7-68c4c92dcace
# ╠═╡ skip_as_script = true
#=╠═╡
begin
	years = collect(1:size(datosClima[:,1], 1));
	datosC = Float64.(datosClima[:,[2,3,4]])

	PPorAños=datosClima[:,[2]] #presion
	TPorAños=Float64.(datosClima[:,[3]]) #temperatura
	RPorAños=Float64.(datosClima[:,[4]]) #precipitacion

	mesesDis2 = repeat(1:12, 14) # Eje X para las temperaturas por año
	mesesCon = 1:0.001:12
end;
  ╠═╡ =#

# ╔═╡ cdb69c71-3939-48f6-b24e-286a01bfdb83
# ╠═╡ skip_as_script = true
#=╠═╡
begin
	num_filas = size(datosC, 1)	 # Cantidad de filas   
	num_años = div(num_filas, 12) # Cantidad de años
	
	function dividir_por_año(datos)
	    DatosPart = [] # Particionar los datos de tal manera que queden por años
	    
	    # Dividir los datos en bloques de 12 meses (por año)
	    for i in 1:num_años
	        inicio = (i - 1) * 12 + 1
	        fin = i * 12
	        push!(DatosPart, datos[inicio:fin, :])
	    end
	    
	    return DatosPart
	end
	
	DatosPart = dividir_por_año(datosC)

	PProm=[0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.]
	TProm=PProm
	RProm=PProm

	for i in 1:14
		PDat=DatosPart[i][:,[1]] #presion
		TDat=DatosPart[i][:,[2]]
		RDat=DatosPart[i][:,[3]]
		global PProm+=PDat
		global TProm+=TDat
		global RProm+=RDat
	end

	PProm/=14
	TProm/=14
	RProm/=14

end;
  ╠═╡ =#

# ╔═╡ 6260c16a-7d99-42cc-b490-499ab9610871
md"""
### 6.2 Ajuste con Datos
"""

# ╔═╡ cdea1ba2-b6a2-4d9f-b2bf-28bbc2bd3f70
md"""
#### 6.2.1 Ajuste con Datos reales:

Este primer ajuste se hizo con los datos reales:
"""

# ╔═╡ 3c4d182c-7121-41e5-8573-9b183e1bcb7e
md"""
El primer ajuste realizado se hizo con los datos obtenidos, por un error de código (en el cual parecia que el ajuste no convergía de una manera apropiada), entonces se buscó avanzar con datos sintéticos, y con un ajuste intermedio de funciones. Para las funciones aquí vistas se utilizara el sufijo **Real**:
"""

# ╔═╡ 1f28b44f-d496-489d-8992-300d7f5f5cb7
#=╠═╡
rLorenz(parametros) = residuoLorenz(parametros, datosC , years)
  ╠═╡ =#

# ╔═╡ 094240e9-ce59-437d-b94c-594588e22d3a
# ╠═╡ show_logs = false
#=╠═╡
oLorenzReal = Optim.optimize(rLorenz, [10.0, 28.0, 8/3, 0.5], SimulatedAnnealing(), Optim.Options(iterations = 10000))
  ╠═╡ =#

# ╔═╡ 07a1610a-e58e-4ba0-9581-3d921dd920a7
md"""
Debido a la complejidad del modelo y a su carácter caótico, no se logra satisfactoriamente encontrar un único valor para sus parámetros. Ésto resulta en que en ejecuciones continuas, los valores pueden ser distintos (si bien son cercanos).
"""

# ╔═╡ 909cd9ad-e16e-4038-9b94-bd31624f9572
#=╠═╡
oLorenzTuplaReal = oLorenzReal.minimizer
  ╠═╡ =#

# ╔═╡ f88fa2eb-8565-4d9b-a1fc-4e79b1e58bf3
# ╠═╡ skip_as_script = true
#=╠═╡
begin
	a = oLorenzTuplaReal[1]
	b = oLorenzTuplaReal[2]
	c = oLorenzTuplaReal[3]
	d = oLorenzTuplaReal[4]
end;
  ╠═╡ =#

# ╔═╡ 9de2964f-47ae-4b55-9522-a0b5703006bc
#=╠═╡
md"""
La ecuación diferencial ordinaria es:

x' = $a y - x

y' = $b x - y - $c xz

z' = $d xy - z

Se puede ver representado gráficamente en la siguiente figura:
"""
  ╠═╡ =#

# ╔═╡ 0d1c2f64-7c49-4627-b607-dc76bdc15960
#=╠═╡
begin
	l0Real = [738.47, 14.55, 75.80]
	dominioTiempoLorenzReal = (1.0, 168.0)
	lorenzOptima1=ODEProblem(lorenz, l0Real, dominioTiempoLorenzReal, oLorenzTuplaReal)
	tablaLO1=solve(lorenzOptima1, Tsit5(), saveat=0:0.001:168)
	plot(title="Trayectoria del Sistema", xlabel="Presión", ylabel="Temperatura", zlabel="Precipitación")
	plot!(tablaLO1, idxs = (1, 2, 3), camera=(45, 30), label="Datos Reales")
end
  ╠═╡ =#

# ╔═╡ 01d1bde0-2cff-4d67-86bc-20f4ff91e57e
md"""
#### 6.2.2 Ajuste con Datos Sinteticos 1:

Debido a ciertos errores de código que llevaron a que el metodo anterior *pareciera* no funcionar, tuvimos otro acercamiento intermedio: con los datos sintéticos.

Cuando hablamos de datos sintéticos para presión, temperatura y precipitación es un acercamiento a través de ciertas funciones, que nuestra hipótesis será que modelan el comportamiento de los parámetros y compararemos con los datos promedio por mes. Estas funciones mantendrán cierto sentido físico a lo largo de un año, para ello le consultamos a algunos físicos y meteórologos para desarrollar una mejor intuición sobre el tipo adecuado de funciones. Para estas funciones sintéticas se usará el sufijo **Sint**:

"""

# ╔═╡ 2c19049c-6956-449a-8d21-e237ce4674a9
md"""
##### Presión: 

La función que modela la presión utiliza una **sinusoidal amortiguada** para representar la variabilidad de la presión en función del tiempo. Este tipo de función es útil cuando se busca modelar fenómenos periódicos cuya amplitud generalmente disminuye con el tiempo. Sin embargo, en este caso particular, debido a los comportamientos de **mayor presión característicos hacia el final del año**, la función ha sido ajustada para que la amplitud crezca en lugar de decaer. La **frecuencia angular**  ($\omega$) controla la periodicidad de la oscilación, asegurando que se repita cada seis meses, mientras que el término $e^{-k \cdot (12 - x)}$ refleja un comportamiento donde la presión aumenta a medida que se acerca el final del ciclo anual. El parámetro $k$ aún regula la rapidez con la que esta "expansión" de la presión ocurre. De esta manera, la función no solo refleja la periodicidad inherente al comportamiento de la presión, sino también su crecimiento hacia el final del año, lo cual es consistente con los aumentos de presión típicos en ciertas épocas del año, como es el caso en ciudades como Bogotá.

A continuación se presenta la función que modela esta relación:

$$P(x) = P_0 + A \cdot e^{-k \cdot (12 - x)} \cdot \sin\left(\omega \cdot (12 - x) + \phi\right)$$

donde:


$$\begin{aligned}
    P_0 &= 737 &\quad \text{(Presión base, aproximadamente en Bogotá)} \\
    A &= 5 \quad& \text{(Amplitud de las oscilaciones)} \\
    k &= 0.1 \quad& \text{(Coeficiente de amortiguación)} \\
    \omega &= \frac{\pi}{3} \quad &\text{(Frecuencia angular, asegura que la onda se repita cada 6 meses)} \\
    \phi &= 0 \quad &\text{(Fase inicial)}
\end{aligned}$$


"""

# ╔═╡ 42d5edd6-5108-4a79-8909-3df77c721bd4
PParamSint = [737., 5., .1 , π / 3 ,  0.] # P0, A, k, omega, phi

# ╔═╡ 37594ac5-547b-4b5b-a44a-81e35a51b319
function PDatos(x, parametros) # función de Presión
	P0, A, k, omega, phi = parametros
	
    return (P0 + A * exp(-k * (12-x)) * sin(omega * (12-x) + phi*x))
end	

# ╔═╡ 7ef0b150-22e2-406c-b818-399f9d8079ca
#=╠═╡
PSint = [PDatos(m, PParamSint) for m in mesesCon]
  ╠═╡ =#

# ╔═╡ e2e6b606-2de4-4793-b8cb-67bb0702953c
#=╠═╡
begin
	plot(mesesCon, PSint, label="Datos sitéticos", lw=4, xlabel="Datos X", yaxis="hPa", title="Datos sintéticos presión")
	
	plot!(1:12, PProm, label="Datos promedio por mes", lw=4)
end
  ╠═╡ =#

# ╔═╡ dd5e86c9-1914-4d55-8fcd-52913d963f55
md"""
##### Temperatura: 

La función que usaremos para modelar la temperatura será una suma entre una distribución normal y un componente lineal adicional. Se decidió la distribución normal puesto que la temperatura suele seguir un patrón estacional, incluso en zonas cercanas del la linea del Ecuador, en particular, las temperaturas suelen ser más altas durante los meses cercanos a la mitad del año. 

Nuestra distribución normal se utiliza para modelar estas fluctuaciones suaves en torno al valor central (en este caso, el mes de mayor temperatura), mientras que el componente lineal se agrega para el incremento gradual de temperatura a lo largo de los años por el cambio climatico (que se divide entre $12$ para asegurar que todos los meses vaya aumentando).

La ecuación que describe esta relación es la siguiente:

$$T(x) = A \cdot e^{-\frac{(x - \mu)^2}{2 \sigma^2}} + \frac{B}{12} \cdot (x - 1) + C$$

donde:

$$\begin{aligned}
    A &= 1 & \text{ (Amplitud de la distribución normal)} \\
    \mu &= 6 & \text{ (Mes de máxima temperatura, centrado en junio)} \\
    \sigma &= 2 &\text{ (Desviación estándar de la distribución normal)} \\
    B &= 1 \quad& \text{(aumento de temperatura por año)} \\
    C &= 14 &\text{ (temperatura base en diciembre)}
\end{aligned}$$

Donde la amplitud refleja las fluctuaciones de temperatura entre valor máximo y mínimo, y la desviación estándar refleja cuán amplias o estrechas son las fluctuaciones de temperatura respecto al mes central, o en otras palabras, qué tan drástico es el cambio de temperatura de un mes a otro.

"""

# ╔═╡ 3da8ddcd-70aa-4822-b2d8-524822fd10bf
TParamSint = [1., 6., 2., 1., 14.] # corresponde a A, μ, σ, B, C 

# ╔═╡ 90df1355-3972-4ab3-ad5e-b0c18f2b02dd
function TDatos(x, parametros)
	A, μ, σ, B, C = parametros
	
	# Componente normal (distribución gaussiana centrada en junio)
	normal_part = A * exp(-((x - μ)^2) / (2 * σ^2))
	
	# Componente lineal (tendencia de 1.0 grados por año)
	linear_part = (B / 12) * (x - 1) 
	
	# Temperatura total
	return normal_part + linear_part + C
end

# ╔═╡ 485e9595-afb0-439e-b778-29a540009fbb
#=╠═╡
TSint = [TDatos(m, TParamSint) for m in mesesCon]
  ╠═╡ =#

# ╔═╡ 068d4943-d64c-4057-997e-06034e406bd2
#=╠═╡
begin
	plot(mesesCon, TSint, label="Datos sitéticos", lw=4, xlabel="Meses", yaxis="Grados Celsius", title="Datos sintéticos temperatura")
	
	plot!(1:12, TProm, label="Datos promedio por mes", lw=4)
end
  ╠═╡ =#

# ╔═╡ 1e9d920d-599f-42da-a187-502960509916
md"""
##### Precipitación: 

La función que modela la precipitación utiliza una función coseno para representar la variabilidad de la precipitación a lo largo del año. Las épocas de lluvia se pueden situar alrededor de los meses de marzo/abril y hacia octubre, así que para representar un periodo de $6$ meses se tomó abril ($4$) y octubre ($10$).

La ecuación que describe esta relación es la siguiente:

$$P(x) = \frac{A}{2} \cdot \cos\left( \frac{3 \cdot (x - \mu)}{\pi} \right) + B$$

donde:

$$\begin{aligned}
    A &= 160 \quad &\text{(Rango base de la precipitación)} \\
    \mu &= 4 \quad &\text{(ubicación del pico de la funcion coseno)} \\
    B &= 80 \quad &\text{(Precipitación mínima)} 
\end{aligned}$$

La **amplitud** $A$ refleja las fluctuaciones entre la cantidad máxima y mínima de precipitación, $\mu$ representa el primer mes de mayor lluvia. Mientras tanto, el valor de $B$ representa la precipitación base en los meses secos, garantizando que haya un valor mínimo de precipitación razonable durante el año.

"""

# ╔═╡ f3e15a75-cef2-45f3-b251-9571d77cac77
RParamSint = [160, 4., 80.] # corresponde a A, μ, B 

# ╔═╡ f8aed4a9-3cbf-487d-8240-d3459a88978c
function RDatos(x, parametros)
		A, μ, B = parametros
	
	    # Componente coseno para modelar la estacionalidad
	    cos_part = (A / 2) * cos(3 * (x - μ) / π)
	
	    # Precipitación total
	    return cos_part + B 
	end

# ╔═╡ 03b83c1d-b131-479f-861a-8022bf74ffc7
#=╠═╡
RSint = [RDatos(m, RParamSint) for m in mesesCon]
  ╠═╡ =#

# ╔═╡ bc014ad3-0083-42d3-b5d1-ea09442e8bba
#=╠═╡
begin
	plot(mesesCon, RSint, label="Datos siteticos", lw=4, xlabel="Meses", yaxis="Precipitación (mm)", title="Datos sinteticos precipitación")
	
	plot!(1:12, RProm, label="Datos promedio por mes", lw=4)
end
  ╠═╡ =#

# ╔═╡ 9813a836-78db-4526-9538-fcd6febe1eff
#=╠═╡
datosSint = hcat(PSint, TSint, RSint) # Datos con nuestras funciones sinteticasa lo largo de mesesCont
  ╠═╡ =#

# ╔═╡ 38b7fc3f-3b77-48ab-ab00-f3385dc6186f
#=╠═╡
V0Sint = [PSint[1], TSint[1] ,RSint[1]] #Condiciones iniciales para el sistema de Lorenz
  ╠═╡ =#

# ╔═╡ 054c38cf-18b1-44b4-a8ce-a8f62a2f36b2
md"""
Para este (y el siguiente) ajuste, tenemos que adaptar la función de residuo, puesto que el dominio de tiempo paso de ser de los $14$ años que tenemos con los datos reales, a ser tan solo $1$. Esta función queda entonces de la siguiente manera:
"""

# ╔═╡ 7586cd85-3fb3-43ae-ab27-5a06cc2577fe
function residuoLorenz2(params, vDatos, tiempo, V0)
    # Time domain for the ODE
    dominioTiempo = (0.0, 12.0)
    
    # Define and solve the ODE problem
    EDO = ODEProblem(lorenz, V0, dominioTiempo, params)
    Sol = solve(EDO, Tsit5(), saveat=tiempo)
    
    # Extract model data at specified time points
    vModelo = hcat(Sol.u...)'

	println("Dimensiones de vDatos: ", size(vDatos))
	println("Dimensiones de vModelo: ", size(vModelo))
    
    # Calculate residuals
    res = vDatos .- vModelo
    nRes = norm(res)
    
    return nRes
end

# ╔═╡ ca0a6986-5baf-463a-b2c4-a0dd7f20feca
#=╠═╡
rLorenz2(params) = residuoLorenz2(params, datosSint , mesesCon, V0Sint)
  ╠═╡ =#

# ╔═╡ db7d9459-7cd2-463e-b1b4-63ae05a56244
# ╠═╡ show_logs = false
#=╠═╡
oLorenzSint = Optim.optimize(rLorenz2, [10.0, 28.0, 8/3, 0.5], SimulatedAnnealing(),Optim.Options(iterations = 1000)) 
  ╠═╡ =#

# ╔═╡ 641b1bd5-112d-4144-9639-7171a5e7b91f
#=╠═╡
oLorenzTuplaSint = oLorenzSint.minimizer
  ╠═╡ =#

# ╔═╡ 48fe1bbf-6972-4fb7-bdfe-e419dfa37fd7
#=╠═╡
begin
    l0Sint = [PSint[1], TSint[1], RSint[1]]
	dominioTiempoLorenzSint = (1.0, 12.0)
	lorenzOptima2=ODEProblem(lorenz, l0Sint, dominioTiempoLorenzSint, oLorenzTuplaSint)
	tablaLO2=solve(lorenzOptima2, Tsit5(), saveat=0:0.001:12)
	plot(title="Trayectoria del Sistema", xlabel="Presión", ylabel="Temperatura", zlabel="Precipitación")
	plot!(tablaLO2, idxs = (1, 2, 3), camera=(70, 30), label="Datos Sintéticos 1")
end
  ╠═╡ =#

# ╔═╡ f91a2d1f-196f-4fae-b04f-ec5be42e04b9
md"""
#### 6.2.3 Ajuste con Datos Sintéticos 2:

Dado que tenemos ya unas funciones que aproximan, con cierto sentido físico a nuestros datos reales, vamos a realizar un ajuste de datos con estas funciones, de tal manera que se acerquen más a nuestros datos originales, lo que realizaremos a continuación y compararemos con nuestros datos reales, antes y despues del promedio.

Además, como en nuestras funciones sintéticas cada una de las variables tenía un razonamiento físico, para nuestro ajuste lo interpretaremos acorde a esos mismos criterios.

Para estas funciones de ajuste se usara el sufijo **Ajus**, y su valor inicial para la función de optimización seran los valores que dentro de las hipótesis son óptimos:

"""

# ╔═╡ 6b1a1e1f-5ab3-4031-924a-b19d8903ca9c
md"""
##### Presión:
"""

# ╔═╡ 7bca8a7c-83a0-4746-8cf2-a0f866de5651
#=╠═╡
begin
	# Función objetivo para ajuste
	function residuoP(params, mesesDis2, datos) # residuo de la presion
	    errores = 0.0
	
	    for i in 1:length(mesesDis2)
	        # Evaluar la temperatura predicha para cada mes
	        prediccion = PDatos(mesesDis2[i], params)
	        # Calcular el error cuadrado entre la predicción y el dato real
	        errores += (prediccion - datos[i]).^2
	    end
	
	    return errores
	end

	function rP(parametros)
		return residuoP(parametros, mesesDis2, PPorAños)
	end 
	
	
	# Ajustamos la función a los datos
	POptim = optimize(rP, PParamSint, NelderMead())
	
	# Extraemos los parámetros ajustados
	PParamAjus = POptim.minimizer
	#println("Parámetros ajustados: ", params_ajustados)

	PP0, PA, Pk, Pomega, Pphi = PParamAjus
end
  ╠═╡ =#

# ╔═╡ df81ed4a-c4cf-43f7-af43-3a64d324b0b4
#=╠═╡
PDatosAjus = [PDatos(m, PParamAjus) for m in mesesCon]
  ╠═╡ =#

# ╔═╡ de1ec58a-11ae-4e7f-9638-4461776e3879
#=╠═╡
begin
	plot(mesesCon, PSint, label="Datos Sinteticos", xlabel="Meses", ylabel="Presión (hPa)", title="Modelo de Presión en Bogotá", linewidth=2,  xlims=(0, 17))
	
	for i in 1:14
		k=2008+i
		Dat=DatosPart[i][:,[1]] #presion
		scatter!(1:12, Dat, label="Datos año $k", lw=4)
	end

	plot!(mesesCon, PDatosAjus, label="Datos ajustados", linewidth=2)

	
end
  ╠═╡ =#

# ╔═╡ a7dc9a73-31fa-43da-99e2-3f2679e3c81a
#=╠═╡
begin
	plot(mesesCon, PSint, label="Datos siteticos", lw=4, ylims=(733.5, 745))
	
	plot!(1:12, PProm, label="Datos promedio por mes", lw=4)

	plot!(mesesCon, PDatosAjus, label="Datos Ajustados", xlabel="Meses", ylabel="Presión (hPa)", title="Datos presión", lw=4)
end
  ╠═╡ =#

# ╔═╡ 519130c6-1a51-4d9a-a1f1-594d8d88fb73
#=╠═╡
md"""

Dado entonces nuestro ajuste tenemos los siguientes valores:
- Presión base: P0 = $PP0.
- Amplitud de las oscilaciones: A = $PA
- coeficiente de amortiguación: k = $Pk
- frecuencia de repeticion: omega = $Pomega
- Fase inicial: phi = $Pphi

Dentro de este ajuste, podemos resaltar principalmente la amplitud de las oscilaciones, y la frecuencia de repetición, que cambiaron drásticamente, ya que la amplitud de las oscilaciones subió, mientras que la frecuencia de repetición, disminuyó bruscamente. Sin embargo, estos son factores que se multiplican, así un mejor acercamiento posible sería evitar la aparición de la función sinusoidal en este caso.

Además viendo los datos individuales, los ajustes que tenemos en esta variable en particular no deben ser tan fiables, puesto que hay una gran brecha entre $720$ y $740$ mPa donde no hay casi ningún dato original. 
"""
  ╠═╡ =#

# ╔═╡ 4a8149d0-b4d2-43d9-bbc0-455f0567a9c8
md"""
##### Temperatura:
"""

# ╔═╡ 60d99098-f972-446d-a279-3e771f9173ae
#=╠═╡
begin
	# Función objetivo para ajuste
	function residuoT(params, mesesDis2, datos)
	    error = 0.0
	
	    for i in 1:length(mesesDis2)
	        # Evaluar la temperatura predicha para cada mes
	        prediccion = TDatos(mesesDis2[i], params)
	        # Calcular el error cuadrado entre la predicción y el dato real
	        error += (prediccion - datos[i]).^2
	    end
	
	    return error
	end

	function rT(parametros)
		return residuoT(parametros, mesesDis2, TPorAños)
	end

	TOptim = optimize(rT, TParamSint, NelderMead())
		
	# Extraemos los parámetros ajustados
	TParamAjus = TOptim.minimizer
	#println("Parámetros ajustados: ", params_ajustados)
	TA, Tmu, Tsigma, TB, TC  = TParamAjus
end;
  ╠═╡ =#

# ╔═╡ 2e1ad853-84ab-4726-a49f-a5d30a9c8ef4
#=╠═╡
TDatosAjus = [TDatos(m, TParamAjus) for m in mesesCon]
  ╠═╡ =#

# ╔═╡ 7a2145df-ed6d-42e2-a9ea-18e39776beb3
#=╠═╡
begin
	plot(mesesCon, TSint, label="Datos Sinteticos", xlabel="Meses", ylabel="Temperatura (°C)", title="Modelo de Temperatura en Bogotá", linewidth=2,  xlims=(0, 17))
	
	for i in 1:14
		k=2008+i
		Dat=DatosPart[i][:,[2]] #temperatura
		scatter!(1:12, Dat, label="Datos año $k", lw=4)
	end

	plot!(mesesCon, TDatosAjus, label="Datos ajustados", linewidth=2)
	
end
  ╠═╡ =#

# ╔═╡ 59d78d63-28f5-429a-b3d7-292c39e74a90
#=╠═╡
begin
	plot(mesesCon, TSint, label="Datos siteticos", lw=4)#, ylims=(14, 15.8))
	
	plot!(1:12, TProm, label="Datos promedio por mes", lw=4)

	plot!(mesesCon, TDatosAjus, label="Datos Ajustados", xlabel="Meses", ylabel="Temperatura (°C)", title="Datos temperatura", linewidth=2)
end
  ╠═╡ =#

# ╔═╡ 36303e3b-b101-41fb-a24c-af2ebb58bb83
#=╠═╡
md"""

Con el ajuste en la temperatura tenemos los siguientes coeficientes:
- Fluctuaciones de temperatura: A = $TA
- Mes de máxima temperatura: mu = $Tmu
- Desviación estandar de la distribución: sigma = $Tsigma
- Aumento de temperatura por año: B = $TB
- Temperatura base en diciembre: C = $TC

Para la temperatura, las fluctuaciones, la desviación estándar y la temperatura base se mantuvieron igual. Lo que cambió respecto a nuestras hipótesis fue: qué tanto está aumentando la temperatura cada año (se estimo en $1.0$ y terminó siendo alrededor de $0.75$) y aún más importante, cuál es el mes mas cálido del año (El cual resultó siendo marzo)

Al mirar la grafica podemos ver que pese a haber una gran variación de datos la función parece estar encajada en medio de ellos. Pero aún mas importante, que es una buena aproximación a los datos promedio por mes, a diferencia de nuestra función sintética original.
"""
  ╠═╡ =#

# ╔═╡ c69e7e4d-521e-4208-9754-f80b746e3ba5
md"""
##### Precipitación:
"""

# ╔═╡ 92a32bb1-bcf0-41eb-9d3b-e1c92427c5ac
#=╠═╡
begin
	# Función objetivo para ajuste
	function residuoR(params, mesesDis2, datos)
	    error = 0.0
	
	    for i in 1:length(mesesDis2)
	        # Evaluar la temperatura predicha para cada mes
	        prediccion = RDatos(mesesDis2[i], params)
	        # Calcular el error cuadrado entre la predicción y el dato real
	        error += (prediccion - datos[i]).^2
	    end
	
	    return error
	end

	function rR(parametros)
		return residuoR(parametros, mesesDis2, RPorAños)
	end

	ROptim = optimize(rR, RParamSint, NelderMead())
		
	# Extraemos los parámetros ajustados
	RParamAjus = ROptim.minimizer
	#println("Parámetros ajustados: ", params_ajustados)
end
  ╠═╡ =#

# ╔═╡ 7dbdca71-1ed7-408b-a8ea-1faf3621dd16
#=╠═╡
RDatosAjus = [RDatos(m, RParamAjus) for m in mesesCon]
  ╠═╡ =#

# ╔═╡ 4d742757-996e-4c33-836d-6a0d0c285d61
#=╠═╡
begin
	plot(mesesCon, RSint, label="Datos Sinteticos", xlabel="Meses", ylabel="Precipitación (mm)", title="Modelo de Precipitación en Bogotá", linewidth=2,  xlims=(0, 17))
	
	for i in 1:14
		k=2008+i
		Dat=DatosPart[i][:,[3]] #temperatura
		scatter!(1:12, Dat, label="Datos año $k", lw=4)
	end

	plot!(mesesCon, RDatosAjus, label="Datos ajustados", linewidth=2)
	
end
  ╠═╡ =#

# ╔═╡ 0f0bcca1-8fd0-4dbc-8cd2-4d46f2c821c6
#=╠═╡
begin
	plot(mesesCon, RSint, label="Datos sintéticos", lw=4)#, ylims=(14, 15.8))
	
	plot!(1:12, RProm, label="Datos promedio por mes", lw=4)

	plot!(mesesCon, RDatosAjus, label="Datos Ajustados", xlabel="Meses", ylabel="Precipitación (mm)", title="Datos Precipitación en Bogotá", linewidth=2)
end
  ╠═╡ =#

# ╔═╡ 8c426a45-4ce1-4282-acb5-c5cd2b801414
#=╠═╡
RA, Rmu, RB  = RParamAjus
  ╠═╡ =#

# ╔═╡ a4f60993-188f-40e2-88ad-ebf40cb2d737
#=╠═╡
md"""

Dentro del ajuste de las precipitaciones tenemos los siguientes datos:
- Rango base de la precipitacion: A = $RA
- ubicación del primer pico de lluvias: mu = $Rmu
- Precipitación minima: B = $RB

Al ver las graficas (y nuestras hipótesis iniciales) podemos llegar a dos conclusiones principales. 

La primera es que nuestras hipótesis no estaban tan alejadas de nuestros valores más cercanos, donde teniamos una precipitación menos drástica por meses de lo que supusimos al comienzo, los meses de lluvia tienden hacia mitad de abril y octubre, y la precipitación mínima es algo menor de lo que supusimos.

La segunda conclusión es que la función sintética planteada ajusta los datos de una manera muy cercana, esto se puede apreciar sobre todo viendo como se comporta con el promedio de los datos.
"""
  ╠═╡ =#

# ╔═╡ 1f48cdd9-50d6-40fd-9789-e5aa25145cfd
md"""
##### Ajuste de la EDO:

Dadas nuestras funciones de aproximación, vamos a analizar el desarrollo de la ecuación diferencial
"""

# ╔═╡ 57c5184a-86d8-4425-a843-13a760dac9c8
#=╠═╡
datosAjus = hcat(PDatosAjus, TDatosAjus, RDatosAjus) # Datos con nuestras funciones Ajustadas lo largo de mesesCont
  ╠═╡ =#

# ╔═╡ f5904070-2512-4ae6-8150-c277efd3fb58
#=╠═╡
V0Ajus = [PDatosAjus[1], TDatosAjus[1] ,RDatosAjus[1]] #Condiciones iniciales para el sistema de Lorenz
  ╠═╡ =#

# ╔═╡ 5344754f-98ce-4726-aa1c-647fd17d2b90
#=╠═╡
rLorenz3(params) = residuoLorenz2(params, datosAjus , mesesCon, V0Ajus)
  ╠═╡ =#

# ╔═╡ 6ec4241d-a1cc-4330-9f23-6f34da9265b4
# ╠═╡ show_logs = false
#=╠═╡
oLorenzAjus = Optim.optimize(rLorenz3, [10.0, 28.0, 8/3, 0.5], SimulatedAnnealing(),Optim.Options(iterations = 1000))
  ╠═╡ =#

# ╔═╡ 7280fa09-0429-4807-8e5c-4b85044e4831
#=╠═╡
oLorenzTuplaAjus = oLorenzAjus.minimizer
  ╠═╡ =#

# ╔═╡ e7e80f4b-85d0-4110-92be-d492119a6e28
#=╠═╡
begin
    l0Ajus = [PDatosAjus[1], TDatosAjus[1], RDatosAjus[1]]
	dominioTiempoLorenzAjus = (1.0, 12.0)
	lorenzOptima3=ODEProblem(lorenz, l0Ajus, dominioTiempoLorenzAjus, oLorenzTuplaAjus)
	tablaLO3=solve(lorenzOptima3, Tsit5(), saveat=0:0.001:12)
	plot(title="Trayectoria del Sistema", xlabel="Presión", ylabel="Temperatura", zlabel="Precipitación")
	plot!(tablaLO3, idxs = (1, 2, 3), label="Datos Sintéticos 2")
	##scatter!(fechas,camas,ls=:dash,label="Camas UCI Covid-19",lw=4, xlabel = "Fecha",yaxis="Camas UCI Covid-19",legend=:bottomright, title="Modelo de Crecimiento Logístico óptimo")
end
  ╠═╡ =#

# ╔═╡ ae396be1-19d0-405a-b543-847f8cae537b
md"""
Finalmente, podemos observar todas las trayectorias resultantes en la siguiente figura:
"""

# ╔═╡ 59bdef18-be8f-46fa-99bd-a8080eb40f4c
#=╠═╡
begin
	plot(title="Trayectorias del Sistema", xlabel="Presión", ylabel="Temperatura", zlabel="Precipitación")
	plot!(tablaLO1, idxs = (1, 2, 3), label="Datos Reales")
	plot!(tablaLO2, idxs = (1, 2, 3), label="Datos Sintéticos 1")
	plot!(tablaLO3, idxs = (1, 2, 3), label="Datos Sintéticos 2")
	
end
  ╠═╡ =#

# ╔═╡ 4660944d-74bc-4c96-9a9f-83608882a60a
md"""
## 7. Análisis del Modelo
"""

# ╔═╡ c1e65ffc-aa17-4390-8b8c-ccd2c6a69ae4
md"""
Analizaremos a continuación el comportamiento general del modelo a partir de uno de los ajustes obtenidos previamente (es decir no necesariamente el de la presente ejecución). Sea nuestra Ecuación Diferencial Ordinaria

$\begin{aligned}
    x' &= 16.4875y - x \\
    y' &= 28.9506x - y - 1.22764xz \\
    z' &= 0.00148262xy - z
\end{aligned}$

Para visualizar los retratos de fase de la ecuación, primero hallemos la matriz asociada dada por el Jacobiano:

$\begin{equation}
 \begin{aligned} 
  D&=\begin{pmatrix}
	\frac{\partial(16.4875y-x)}{\partial x} & \frac{\partial(16.4875y-x)}{\partial y} & \frac{\partial(16.4875y-x)}{\partial z} \\
	\frac{\partial(28.9506x-y-1.22764xz)}{\partial x} & \frac{\partial(28.9506x-y-1.22764xz)}{\partial y} & \frac{\partial(28.9506x-y-1.22764xz)}{\partial z}\\
	\frac{\partial(0.00148262xy-z)}{\partial x} & \frac{\partial(0.00148262xy-z)}{\partial y} & \frac{\partial(0.00148262xy-z)}{\partial z}
	\end{pmatrix} \\
	&= \begin{pmatrix}
	-1 & 16.4875 & 0 \\
	28.9506-1.22764z & -1 & -1.22764x\\
	0.00148262y & 0.00148262x & -1
	\end{pmatrix}
\end{aligned} 
\end{equation}$

Ahora encontremos los puntos de equilibrio resolviendo el siguiente sistema de ecuaciones:

$\begin{aligned}
    16.4875y - x &= 0 \\  
    28.9506x - y - 1.22764xz &= 0 \\  
    0.00148262xy - z &= 0  
\end{aligned}$

Por lo tanto, se tienen tres puntos fijos:

$\begin{aligned}
    p_1 &= (-511.5644, -31.0274, 23.5329) \\  
    p_2 &= (0, 0, 0) \\  
    p_3 &= (511.5644, 31.0274, 23.5329)  
\end{aligned}$

Veamos que comportamiento tiene cada punto:
Para $p_1$ se tiene que:

$D=
\begin{pmatrix}
-1 & 16.4875 & 0 \\
0.0607 & -1 & 628.017\\
-0.046 & -0.7585 & -1
\end{pmatrix}$

Ahora calculamos los valores propios de esta matriz:

$\begin{aligned}
\det \begin{pmatrix}
-1 - \lambda & 16.4875 & 0 \\
0.0607 & -1 - \lambda & 628.017 \\
-0.046 & -0.7585 & -1 - \lambda
\end{pmatrix} &= 0
\end{aligned}$

Así, $\lambda _{1} = -2$ y $\lambda_2 \approx-0.5\pm21.8191i$. Al igual, los vectores propios son los siguientes respectivamente:

$\begin{aligned}
\vec{a} &= \begin{pmatrix}
-0.9888 + 0.1366i \\
0.06 - 0.0083i \\
4.81 \times 10^{-18} - 6.65 \times 10^{-19}i
\end{pmatrix}\\
\vec{b} &= \begin{pmatrix}
0.0861 + 0.7499i \\
0.9950 - 0.0912i \\
-0.0024 - 0.0347i
\end{pmatrix}\\
\vec{c} &= \begin{pmatrix}
-0.7328 - 0.1884i \\
0.2271 - 0.9755i \\
0.0341 + 0.0071i
\end{pmatrix}
\end{aligned}$

Ahora como para todos los valores propios, $Re(\lambda)<0$, se tendrá en el punto un atractor estable en espiral. Las trayectorias convergen hacia este punto con oscilaciones amortiguadas.

Para $p_2$ se tiene que:

$D=
\begin{pmatrix}
-1 & 16.4875 & 0 \\
28.9506 & -1 & 0\\
0 & 0 & -1
\end{pmatrix}$

Ahora calculamos los valores propios de esta matriz:

$\begin{aligned}
\det \begin{pmatrix}
-1 - \lambda & 16.4875 & 0 \\
28.9506 & -1 - \lambda & 0 \\
0 & 0 & -1 - \lambda
\end{pmatrix} &= 0
\end{aligned}$

Así, $\lambda _1 = -22.8477$, $\lambda _2 = 20.8477$ y $\lambda _3 = -1$- Al igual, los vectores propios son los siguientes respectivamente:

$\begin{aligned}
\vec{a} &=
\begin{pmatrix}
0.6024 \\
-0.7982 \\
0
\end{pmatrix}, \\[8pt]
\vec{b} &=
\begin{pmatrix}
0.6264 \\
0.83 \\
0
\end{pmatrix}, \\[8pt]
\vec{c} &=
\begin{pmatrix}
0 \\
0 \\
1
\end{pmatrix}
\end{aligned}$

Ahora como hay un valor propio positivo indica que hay una dirección en la que las soluciones divergen, mientras que los valores negativos indican que en otras direcciones las soluciones tienden a este punto. Esto sugiere que el punto es un silla inestable, con trayectorias que se alejan en algunas direcciones y se acercan en otras.

Para $p_3$ se tiene que:

$D=
\begin{pmatrix}
-1 & 16.4875 & 0 \\
0.0607 & -1 & -628.017\\
0.046 & 0.7585 & -1
\end{pmatrix}$

Ahora calculamos los valores propios de esta matriz:

$\det\begin{pmatrix}
-1-\lambda & 16.4875 & 0 \\
0.0607 & -1-\lambda & -628.017 \\
0.046 & 0.7585 & -1-\lambda
\end{pmatrix}$ 

Así, $\lambda_{1} = -2$ y $\lambda _2\approx-0.5\pm21.8191i$. Al igual, los vectores propios son los siguientes respectivamente:

$\begin{align}
\vec{a} &= 
\begin{pmatrix}
-0.9888+0.1366i\\
0.06-0.0083i\\
4.81\times 10^{-18}-6.65\times10^{-19}i
\end{pmatrix} \\[10pt]
\vec{b} &= 
\begin{pmatrix}
0.0861+0.7499i \\
0.9950-0.0912i \\
0.0024+0.0347i
\end{pmatrix} \\[10pt]
\vec{c} &= 
\begin{pmatrix}
0.7328+0.1884i \\
-0.2271+0.9755i \\
0.0341+0.0071i
\end{pmatrix}
\end{align}$

Ahora como para todos los valores propios, $Re(\lambda)<0$, se tendrá en el punto un atractor estable en espiral. Las trayectorias convergen hacia este punto.

En conclusión, se espera que el sistema tenga una dinámica bifurcada entre dos regiones de estabilidad y un punto inestable que separa estas regiones, lo que significa que el sistema dinámico presenta dos regiones donde las soluciones tienden a estabilizarse (atractores estables) y una región donde las soluciones son inestables (un punto silla).

"""

# ╔═╡ 597d3c9e-07c3-47db-8360-1f184d472545
# ╠═╡ show_logs = false
begin
	# Definir el sistema de ecuaciones diferenciales
    dx_dt(x, y, z) = 16.4875 * y - x
    dy_dt(x, y, z) = 28.9506 * x - y - 1.22764 * x * z
    dz_dt(x, y, z) = 0.00148262 * x * y - z

    # Definir el sistema en forma de vector
    f(x) = [dx_dt(x[1], x[2], x[3]), dy_dt(x[1], x[2], x[3]), dz_dt(x[1], x[2], x[3])]

    # Resolver el sistema no lineal para encontrar los puntos de equilibrio
    sol = nlsolve(x -> f(x), [1.0, 1.0, 1.0])
    eq_points = sol.zero
    println("Puntos de equilibrio: ", eq_points)

    # Definir la matriz Jacobiana
    function J(x, y, z)
        return [
            -1.0  16.4875   0.0;
            28.9506  -1.0  -1.22764*z;
            0.00148262*y  0.00148262*x  -1.0
        ]
    end

    # Evaluar la matriz Jacobiana en el punto de equilibrio
    jacobian_at_eq = J(eq_points...)  # Expande eq_points como argumentos
    println("Matriz Jacobiana en el equilibrio:\n", jacobian_at_eq)

    # Calcular autovalores (eigenvalues)
    eigenvalues = eigvals(jacobian_at_eq)
    println("Autovalores en el equilibrio: ", eigenvalues)

    # Definir la función del sistema para la simulación
    function dt!(du, u, p, t)
        du[1] = dx_dt(u...)
        du[2] = dy_dt(u...)
        du[3] = dz_dt(u...)
    end

    # Simulación con condiciones iniciales
    tspan = (0.0, 5.0)
    initial_conditions = [[-500, -30, 20], [500, 30, 20], [10, 10, 10], [-10, -10, -10], [0, 0.1, 0.1]]
    solutions = [solve(ODEProblem(dt!, u0, tspan), Tsit5(), saveat=0:0.001:12) for u0 in initial_conditions]   

	# Graficar las trayectorias en 3D
	plt = plot(title="Retrato de Fase del Sistema", xlabel="Presión", ylabel="Temperatura", zlabel="Precipitación")

	for sol in solutions
	    plot!(plt, sol[1, :], sol[2, :], sol[3, :], label="")
	end
	
	# Marcar el punto de equilibrio
	scatter!(plt, [eq_points[1]], [eq_points[2]], [eq_points[3]], markersize=5, color=:red, label="Equilibrio")

	
end

# ╔═╡ a74985d7-8795-4ec4-8a26-5f61cae4722e
md"""
### 7.1 Interpretación cualitativa de los parámetros en el sistema de ecuaciones dado por aproximación de datos reales

Valores de los parámetros en el sistema de ecuaciones:

λ = 16.4875:

Un valor alto indica que la presión tiene una gran influencia en la temperatura. En Bogotá, la presión atmosférica varía debido a la altitud y los cambios climáticos frecuentes, lo que sugiere que estos cambios afectan fuertemente la temperatura.

ρ = 28.9506:

Su valor elevado indica que la temperatura responde fuertemente a los cambios en la presión. Esto es coherente con Bogotá, donde la temperatura puede variar bruscamente según la presión atmosférica y la humedad presente.

μ = 1.22764:

Su valor mayor a 1 indica que la disipación de calor es significativa y ocurre a una tasa apreciable. Esto se alinea con el clima de Bogotá, donde las lluvias tienden a reducir rápidamente la temperatura. 

ν = 0.00148262:

Su valor muy pequeño sugiere que el transporte de calor en la atmósfera de Bogotá es lento. Esto es esperable en una ciudad con una atmósfera estable y sin grandes corrientes de convección masivas como en zonas costeras.
"""

# ╔═╡ 9206ac6a-a73e-45f8-a8b9-8219606aa502
md"""
## 8. Conclusiones.

Los datos pueden refinarse y ajustarse de manera más precisa para mejorar la calidad del análisis. Dado que el modelo es caótico, reiniciar el algoritmo genera resultados significativamente diferentes en cada ejecución. Los atractores de Lorenz presentan una estructura fascinante y visualmente impresionante. Aunque la selección de la función de ajuste pueda tener una justificación física inicial, no siempre se adapta correctamente a los datos, por lo que es necesario estar preparados para reconsiderarla.  

Partiendo de la premisa de que el modelo nunca será exacto, pero algunos enfoques pueden resultar más útiles que otros, este desarrollo ha logrado una función de ajuste para la precipitación con un desempeño excepcional, una función de ajuste para la temperatura que, aunque buena, aún tiene margen de mejora, y retratos de fase que revelan puntos de estabilidad hacia los cuales convergen las soluciones, lo que sugiere la existencia de estados climáticos estables. Sin embargo, aún faltan coeficientes adecuados para describirlos con precisión.  

Pequeños detalles en la implementación pueden generar grandes diferencias en los resultados. Por ejemplo, si los saltos de iteración son demasiado pequeños, el modelo podría no ser capaz de mostrar los característicos atractores de Lorenz. En este caso, el problema no sería nuestro enfoque, sino la acumulación de ceros numéricos que distorsionan el comportamiento del sistema.  
Como posibles mejoras y ampliaciones del proyecto, se podrían desarrollar funciones de ajuste más precisas, incorporar enfoques probabilísticos o estocásticos para el tratamiento de datos, optimizar la función iterativa para mejorar su estabilidad y precisión, comparar con otros modelos climáticos para identificar patrones comunes y mejorar la visualización de los datos para facilitar la interpretación de los resultados.

## Referencias

[1] P. E. Calderón Saavedra and V. H. Chaux M., ‘Descripción del Modelo de Lorenz con aplicaciones’, Nov. 2007, Accessed: Mar. 06, 2025. [Online]. Available: http://hdl.handle.net/10784/146

[2] S. Represa, ‘Ecuaciones de Lorenz’, 2016, doi: 10.13140/RG.2.2.18508.82563.

[3] R. H. Buitrago Puentes, ‘El sistema y el atractor geométrico de Lorenz’, 2010, Accessed: Mar. 06, 2025. [Online]. Available: https://repositorio.unal.edu.co/handle/unal/7557

[4] ‘Precipitaciones Totales Mensuales | Datos Abiertos Colombia’. Accessed: Mar. 06, 2025. [Online]. Available: https://www.datos.gov.co/Ambiente-y-Desarrollo-Sostenible/Precipitaciones-Totales-Mensuales/mb4n-6m2g/about_data

[5] ‘Presión Atmosférica | Datos Abiertos Colombia’. Accessed: Mar. 06, 2025. [Online]. Available: https://www.datos.gov.co/Ambiente-y-Desarrollo-Sostenible/Presi-n-Atmosf-rica/62tk-nxj5/data_preview

[6] ‘Temperatura en Bogotá D.C. y su relación con ENOS - Temperaturas registradas en Bogotá D.C - Datos Abiertos Bogotá’. Accessed: Mar. 06, 2025. [Online]. Available: https://datosabiertos.bogota.gov.co/dataset/temperaturas-en-bogota-d-c/resource/c3867459-1aa7-4e16-8ae8-ca41693f7261

"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
DifferentialEquations = "0c46a032-eb83-5123-abaf-570d42b7fbaa"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
NLsolve = "2774e3e8-f4cf-5e23-947b-6d7e65073b56"
Optim = "429524aa-4258-5aef-a3af-852621145aeb"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"

[compat]
DifferentialEquations = "~7.14.0"
NLsolve = "~4.5.1"
Optim = "~1.9.4"
Plots = "~1.40.8"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.3"
manifest_format = "2.0"
project_hash = "6011df769020a30e5df92ecde7f4ada7907638d2"

[[deps.ADTypes]]
git-tree-sha1 = "eea5d80188827b35333801ef97a40c2ed653b081"
uuid = "47edcb42-4c32-4615-8424-f2b9edc5f35b"
version = "1.9.0"
weakdeps = ["ChainRulesCore", "EnzymeCore"]

    [deps.ADTypes.extensions]
    ADTypesChainRulesCoreExt = "ChainRulesCore"
    ADTypesEnzymeCoreExt = "EnzymeCore"

[[deps.AbstractTrees]]
git-tree-sha1 = "2d9c9a55f9c93e8887ad391fbae72f8ef55e1177"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.5"

[[deps.Accessors]]
deps = ["CompositionsBase", "ConstructionBase", "InverseFunctions", "LinearAlgebra", "MacroTools", "Markdown"]
git-tree-sha1 = "b392ede862e506d451fc1616e79aa6f4c673dab8"
uuid = "7d9f7c33-5ae7-4f3b-8dc6-eff91059b697"
version = "0.1.38"

    [deps.Accessors.extensions]
    AccessorsAxisKeysExt = "AxisKeys"
    AccessorsDatesExt = "Dates"
    AccessorsIntervalSetsExt = "IntervalSets"
    AccessorsStaticArraysExt = "StaticArrays"
    AccessorsStructArraysExt = "StructArrays"
    AccessorsTestExt = "Test"
    AccessorsUnitfulExt = "Unitful"

    [deps.Accessors.weakdeps]
    AxisKeys = "94b1ba4f-4ee9-5380-92f1-94cde586c3c5"
    Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    Requires = "ae029012-a4dd-5104-9daa-d747884805df"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "50c3c56a52972d78e8be9fd135bfb91c9574c140"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.1.1"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.AliasTables]]
deps = ["PtrArrays", "Random"]
git-tree-sha1 = "9876e1e164b144ca45e9e3198d0b689cadfed9ff"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.1.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "d57bd3762d308bded22c3b82d033bff85f6195c6"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.4.0"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra"]
git-tree-sha1 = "3640d077b6dafd64ceb8fd5c1ec76f7ca53bcf76"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.16.0"

    [deps.ArrayInterface.extensions]
    ArrayInterfaceBandedMatricesExt = "BandedMatrices"
    ArrayInterfaceBlockBandedMatricesExt = "BlockBandedMatrices"
    ArrayInterfaceCUDAExt = "CUDA"
    ArrayInterfaceCUDSSExt = "CUDSS"
    ArrayInterfaceChainRulesExt = "ChainRules"
    ArrayInterfaceGPUArraysCoreExt = "GPUArraysCore"
    ArrayInterfaceReverseDiffExt = "ReverseDiff"
    ArrayInterfaceSparseArraysExt = "SparseArrays"
    ArrayInterfaceStaticArraysCoreExt = "StaticArraysCore"
    ArrayInterfaceTrackerExt = "Tracker"

    [deps.ArrayInterface.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    CUDSS = "45b445bb-4962-46a0-9369-b4df9d0f772e"
    ChainRules = "082447d4-558c-5d27-93f4-14fc19e9eca2"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.ArrayLayouts]]
deps = ["FillArrays", "LinearAlgebra"]
git-tree-sha1 = "492681bc44fac86804706ddb37da10880a2bd528"
uuid = "4c555306-a7a7-4459-81d9-ec55ddd5c99a"
version = "1.10.4"
weakdeps = ["SparseArrays"]

    [deps.ArrayLayouts.extensions]
    ArrayLayoutsSparseArraysExt = "SparseArrays"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.BandedMatrices]]
deps = ["ArrayLayouts", "FillArrays", "LinearAlgebra", "PrecompileTools"]
git-tree-sha1 = "a2c85f53ddcb15b4099da59867868bd40f005579"
uuid = "aae01518-5342-5314-be14-df237901396f"
version = "1.7.5"
weakdeps = ["SparseArrays"]

    [deps.BandedMatrices.extensions]
    BandedMatricesSparseArraysExt = "SparseArrays"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.Bijections]]
git-tree-sha1 = "d8b0439d2be438a5f2cd68ec158fe08a7b2595b7"
uuid = "e2ed5e7c-b2de-5872-ae92-c73ca462fb04"
version = "0.1.9"

[[deps.BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

[[deps.BitTwiddlingConvenienceFunctions]]
deps = ["Static"]
git-tree-sha1 = "f21cfd4950cb9f0587d5067e69405ad2acd27b87"
uuid = "62783981-4cbd-42fc-bca8-16325de8dc4b"
version = "0.1.6"

[[deps.BoundaryValueDiffEq]]
deps = ["ADTypes", "Adapt", "ArrayInterface", "BandedMatrices", "BoundaryValueDiffEqCore", "BoundaryValueDiffEqFIRK", "BoundaryValueDiffEqMIRK", "BoundaryValueDiffEqShooting", "ConcreteStructs", "DiffEqBase", "FastAlmostBandedMatrices", "FastClosures", "ForwardDiff", "LineSearch", "LineSearches", "LinearAlgebra", "LinearSolve", "Logging", "NonlinearSolve", "OrdinaryDiffEq", "PreallocationTools", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "Setfield", "SparseArrays", "SparseDiffTools"]
git-tree-sha1 = "98da8bd76b89a4ae1b8dde9fc6dcd75dcd6b5282"
uuid = "764a87c0-6b3e-53db-9096-fe964310641d"
version = "5.12.0"

    [deps.BoundaryValueDiffEq.extensions]
    BoundaryValueDiffEqODEInterfaceExt = "ODEInterface"

    [deps.BoundaryValueDiffEq.weakdeps]
    ODEInterface = "54ca160b-1b9f-5127-a996-1867f4bc2a2c"

[[deps.BoundaryValueDiffEqCore]]
deps = ["ADTypes", "Adapt", "ArrayInterface", "ConcreteStructs", "DiffEqBase", "ForwardDiff", "LineSearch", "LineSearches", "LinearAlgebra", "LinearSolve", "Logging", "NonlinearSolve", "PreallocationTools", "RecursiveArrayTools", "Reexport", "SciMLBase", "Setfield", "SparseArrays", "SparseDiffTools"]
git-tree-sha1 = "768423f5fa51adc47ea5bd2540497fc785c2f0cc"
uuid = "56b672f2-a5fe-4263-ab2d-da677488eb3a"
version = "1.0.1"

[[deps.BoundaryValueDiffEqFIRK]]
deps = ["ADTypes", "Adapt", "ArrayInterface", "BandedMatrices", "BoundaryValueDiffEqCore", "ConcreteStructs", "DiffEqBase", "FastAlmostBandedMatrices", "FastClosures", "ForwardDiff", "LineSearch", "LineSearches", "LinearAlgebra", "LinearSolve", "Logging", "NonlinearSolve", "PreallocationTools", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "Setfield", "SparseArrays", "SparseDiffTools"]
git-tree-sha1 = "35e1e7822d1c77d85ecf568606ca64d60fbd39de"
uuid = "85d9eb09-370e-4000-bb32-543851f73618"
version = "1.0.2"

[[deps.BoundaryValueDiffEqMIRK]]
deps = ["ADTypes", "Adapt", "ArrayInterface", "BandedMatrices", "BoundaryValueDiffEqCore", "ConcreteStructs", "DiffEqBase", "FastAlmostBandedMatrices", "FastClosures", "ForwardDiff", "LineSearch", "LineSearches", "LinearAlgebra", "LinearSolve", "Logging", "NonlinearSolve", "PreallocationTools", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "Setfield", "SparseArrays", "SparseDiffTools"]
git-tree-sha1 = "e1fa0dee3d8eca528ab96e765a52760fd7466ffa"
uuid = "1a22d4ce-7765-49ea-b6f2-13c8438986a6"
version = "1.0.1"

[[deps.BoundaryValueDiffEqShooting]]
deps = ["ADTypes", "Adapt", "ArrayInterface", "BandedMatrices", "BoundaryValueDiffEqCore", "ConcreteStructs", "DiffEqBase", "FastAlmostBandedMatrices", "FastClosures", "ForwardDiff", "LineSearch", "LineSearches", "LinearAlgebra", "LinearSolve", "Logging", "NonlinearSolve", "OrdinaryDiffEq", "PreallocationTools", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "Setfield", "SparseArrays", "SparseDiffTools"]
git-tree-sha1 = "fac04445ab0fdfa29b62d84e1af6b21334753a94"
uuid = "ed55bfe0-3725-4db6-871e-a1dc9f42a757"
version = "1.0.2"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "8873e196c2eb87962a2048b3b8e08946535864a1"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+2"

[[deps.CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[deps.CPUSummary]]
deps = ["CpuId", "IfElse", "PrecompileTools", "Static"]
git-tree-sha1 = "5a97e67919535d6841172016c9530fd69494e5ec"
uuid = "2a0fbf3d-bb9c-48f3-b0a9-814d99fd7ab9"
version = "0.2.6"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "009060c9a6168704143100f36ab08f06c2af4642"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.2+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "3e4b134270b372f2ed4d4d0e936aabaefc1802bc"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.25.0"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.CloseOpenIntervals]]
deps = ["Static", "StaticArrayInterface"]
git-tree-sha1 = "05ba0d07cd4fd8b7a39541e31a7b0254704ea581"
uuid = "fb6a15b2-703c-40df-9091-08a04967cfa9"
version = "0.1.13"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "bce6804e5e6044c6daab27bb533d1295e4a2e759"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.6"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "13951eb68769ad1cd460cdb2e64e5e95f1bf123d"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.27.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"
weakdeps = ["SpecialFunctions"]

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "64e15186f0aa277e174aa81798f7eb8598e0157e"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.13.0"

[[deps.Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[deps.CommonSolve]]
git-tree-sha1 = "0eee5eb66b1cf62cd6ad1b460238e60e4b09400c"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.4"

[[deps.CommonSubexpressions]]
deps = ["MacroTools"]
git-tree-sha1 = "cda2cfaebb4be89c9084adaca7dd7333369715c5"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.1"

[[deps.CommonWorldInvalidations]]
git-tree-sha1 = "ae52d1c52048455e85a387fbee9be553ec2b68d0"
uuid = "f70d9fcc-98c5-4d4a-abd7-e4cdeebd8ca8"
version = "1.0.0"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "8ae8d32e09f0dcf42a36b90d4e17f5dd2e4c4215"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.16.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.CompositeTypes]]
git-tree-sha1 = "bce26c3dab336582805503bed209faab1c279768"
uuid = "b152e2b5-7a66-4b01-a709-34e65c35f657"
version = "0.1.4"

[[deps.CompositionsBase]]
git-tree-sha1 = "802bb88cd69dfd1509f6670416bd4434015693ad"
uuid = "a33af91c-f02d-484b-be07-31d278c5ca2b"
version = "0.1.2"
weakdeps = ["InverseFunctions"]

    [deps.CompositionsBase.extensions]
    CompositionsBaseInverseFunctionsExt = "InverseFunctions"

[[deps.ConcreteStructs]]
git-tree-sha1 = "f749037478283d372048690eb3b5f92a79432b34"
uuid = "2569d6c7-a4a2-43d3-a901-331e8e4be471"
version = "0.2.3"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "ea32b83ca4fefa1768dc84e504cc0a94fb1ab8d1"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.4.2"

[[deps.ConstructionBase]]
git-tree-sha1 = "76219f1ed5771adbb096743bff43fb5fdd4c1157"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.8"
weakdeps = ["IntervalSets", "LinearAlgebra", "StaticArrays"]

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseLinearAlgebraExt = "LinearAlgebra"
    ConstructionBaseStaticArraysExt = "StaticArrays"

[[deps.Contour]]
git-tree-sha1 = "439e35b0b36e2e5881738abc8857bd92ad6ff9a8"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.3"

[[deps.CpuId]]
deps = ["Markdown"]
git-tree-sha1 = "fcbb72b032692610bfbdb15018ac16a36cf2e406"
uuid = "adafc99b-e345-5852-983c-f28acb93d879"
version = "0.3.1"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Dbus_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "fc173b380865f70627d7dd1190dc2fce6cc105af"
uuid = "ee1fde0b-3d02-5ea6-8484-8dfef6360eab"
version = "1.14.10+0"

[[deps.DelayDiffEq]]
deps = ["ArrayInterface", "DataStructures", "DiffEqBase", "LinearAlgebra", "Logging", "OrdinaryDiffEq", "Printf", "RecursiveArrayTools", "Reexport", "SciMLBase", "SimpleNonlinearSolve", "SimpleUnPack"]
git-tree-sha1 = "066f60231c1b0ae2905ffd2651e207accd91f627"
uuid = "bcd4f6db-9728-5f36-b5f7-82caef46ccdb"
version = "5.48.1"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DiffEqBase]]
deps = ["ArrayInterface", "ConcreteStructs", "DataStructures", "DocStringExtensions", "EnumX", "EnzymeCore", "FastBroadcast", "FastClosures", "ForwardDiff", "FunctionWrappers", "FunctionWrappersWrappers", "LinearAlgebra", "Logging", "Markdown", "MuladdMacro", "Parameters", "PreallocationTools", "PrecompileTools", "Printf", "RecursiveArrayTools", "Reexport", "SciMLBase", "SciMLOperators", "SciMLStructures", "Setfield", "Static", "StaticArraysCore", "Statistics", "TruncatedStacktraces"]
git-tree-sha1 = "f8eefbb7e910f59087c4bb09ce670f235758ee4a"
uuid = "2b5f629d-d688-5b77-993f-72d75c75574e"
version = "6.158.3"

    [deps.DiffEqBase.extensions]
    DiffEqBaseCUDAExt = "CUDA"
    DiffEqBaseChainRulesCoreExt = "ChainRulesCore"
    DiffEqBaseDistributionsExt = "Distributions"
    DiffEqBaseEnzymeExt = ["ChainRulesCore", "Enzyme"]
    DiffEqBaseGeneralizedGeneratedExt = "GeneralizedGenerated"
    DiffEqBaseMPIExt = "MPI"
    DiffEqBaseMeasurementsExt = "Measurements"
    DiffEqBaseMonteCarloMeasurementsExt = "MonteCarloMeasurements"
    DiffEqBaseReverseDiffExt = "ReverseDiff"
    DiffEqBaseSparseArraysExt = "SparseArrays"
    DiffEqBaseTrackerExt = "Tracker"
    DiffEqBaseUnitfulExt = "Unitful"

    [deps.DiffEqBase.weakdeps]
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"
    GeneralizedGenerated = "6b9d7cbe-bcb9-11e9-073f-15a7a543e2eb"
    MPI = "da04e1cc-30fd-572f-bb4f-1f8673147195"
    Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
    MonteCarloMeasurements = "0987c9cc-fe09-11e8-30f0-b96dd679fdca"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.DiffEqCallbacks]]
deps = ["DataStructures", "DiffEqBase", "ForwardDiff", "Functors", "LinearAlgebra", "Markdown", "NonlinearSolve", "Parameters", "RecipesBase", "RecursiveArrayTools", "SciMLBase", "StaticArraysCore"]
git-tree-sha1 = "19dbd44d18bbfdfcf5e56c99cea9b0ed23df350a"
uuid = "459566f4-90b8-5000-8ac3-15dfb0a30def"
version = "3.9.1"
weakdeps = ["OrdinaryDiffEq", "OrdinaryDiffEqCore", "Sundials"]

[[deps.DiffEqNoiseProcess]]
deps = ["DiffEqBase", "Distributions", "GPUArraysCore", "LinearAlgebra", "Markdown", "Optim", "PoissonRandom", "QuadGK", "Random", "Random123", "RandomNumbers", "RecipesBase", "RecursiveArrayTools", "ResettableStacks", "SciMLBase", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "ab1e6515ce15f01316a9825b02729fefa51726bd"
uuid = "77a26b50-5914-5dd7-bc55-306e6241c503"
version = "5.23.0"

    [deps.DiffEqNoiseProcess.extensions]
    DiffEqNoiseProcessReverseDiffExt = "ReverseDiff"

    [deps.DiffEqNoiseProcess.weakdeps]
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "23163d55f885173722d1e4cf0f6110cdbaf7e272"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.15.1"

[[deps.DifferentialEquations]]
deps = ["BoundaryValueDiffEq", "DelayDiffEq", "DiffEqBase", "DiffEqCallbacks", "DiffEqNoiseProcess", "JumpProcesses", "LinearAlgebra", "LinearSolve", "NonlinearSolve", "OrdinaryDiffEq", "Random", "RecursiveArrayTools", "Reexport", "SciMLBase", "SteadyStateDiffEq", "StochasticDiffEq", "Sundials"]
git-tree-sha1 = "d851f2ca05f3cec9988f081b047a778a58b48aaf"
uuid = "0c46a032-eb83-5123-abaf-570d42b7fbaa"
version = "7.14.0"

[[deps.DifferentiationInterface]]
deps = ["ADTypes", "LinearAlgebra"]
git-tree-sha1 = "95cf94719d2f71ad8b8c7ba3eb0accc978626856"
uuid = "a0c0ee7d-e4b9-4e03-894e-1c5f64a51d63"
version = "0.6.18"

    [deps.DifferentiationInterface.extensions]
    DifferentiationInterfaceChainRulesCoreExt = "ChainRulesCore"
    DifferentiationInterfaceDiffractorExt = "Diffractor"
    DifferentiationInterfaceEnzymeExt = "Enzyme"
    DifferentiationInterfaceFastDifferentiationExt = "FastDifferentiation"
    DifferentiationInterfaceFiniteDiffExt = "FiniteDiff"
    DifferentiationInterfaceFiniteDifferencesExt = "FiniteDifferences"
    DifferentiationInterfaceForwardDiffExt = "ForwardDiff"
    DifferentiationInterfaceMooncakeExt = "Mooncake"
    DifferentiationInterfacePolyesterForwardDiffExt = "PolyesterForwardDiff"
    DifferentiationInterfaceReverseDiffExt = "ReverseDiff"
    DifferentiationInterfaceSparseArraysExt = "SparseArrays"
    DifferentiationInterfaceSparseMatrixColoringsExt = "SparseMatrixColorings"
    DifferentiationInterfaceStaticArraysExt = "StaticArrays"
    DifferentiationInterfaceSymbolicsExt = "Symbolics"
    DifferentiationInterfaceTrackerExt = "Tracker"
    DifferentiationInterfaceZygoteExt = ["Zygote", "ForwardDiff"]

    [deps.DifferentiationInterface.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    Diffractor = "9f5e2b26-1114-432f-b630-d3fe2085c51c"
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"
    FastDifferentiation = "eb9bf01b-bf85-4b60-bf87-ee5de06c00be"
    FiniteDiff = "6a86dc24-6348-571c-b903-95158fe2bd41"
    FiniteDifferences = "26cc04aa-876d-5657-8c51-4c34ba976000"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    Mooncake = "da2b9cff-9c12-43a0-ae48-6db2b0edb7d6"
    PolyesterForwardDiff = "98d1487c-24ca-40b6-b7ab-df2af84e126b"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SparseMatrixColorings = "0a514795-09f3-496d-8182-132a7b665d35"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    Symbolics = "0c5d862f-8b57-4792-8d23-62f2024744c7"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.Distances]]
deps = ["LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "c7e3a542b999843086e2f29dac96a618c105be1d"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.12"
weakdeps = ["ChainRulesCore", "SparseArrays"]

    [deps.Distances.extensions]
    DistancesChainRulesCoreExt = "ChainRulesCore"
    DistancesSparseArraysExt = "SparseArrays"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"
version = "1.11.0"

[[deps.Distributions]]
deps = ["AliasTables", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SpecialFunctions", "Statistics", "StatsAPI", "StatsBase", "StatsFuns"]
git-tree-sha1 = "d7477ecdafb813ddee2ae727afa94e9dcb5f3fb0"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.112"

    [deps.Distributions.extensions]
    DistributionsChainRulesCoreExt = "ChainRulesCore"
    DistributionsDensityInterfaceExt = "DensityInterface"
    DistributionsTestExt = "Test"

    [deps.Distributions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DensityInterface = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.DomainSets]]
deps = ["CompositeTypes", "IntervalSets", "LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "490392af2c7d63183bfa2c8aaa6ab981c5ba7561"
uuid = "5b8099bc-c8ec-5219-889f-1d9e522a28bf"
version = "0.7.14"

    [deps.DomainSets.extensions]
    DomainSetsMakieExt = "Makie"

    [deps.DomainSets.weakdeps]
    Makie = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.DynamicPolynomials]]
deps = ["Future", "LinearAlgebra", "MultivariatePolynomials", "MutableArithmetics", "Reexport", "Test"]
git-tree-sha1 = "bbf1ace0781d9744cb697fb856bd2c3f6568dadb"
uuid = "7c1d4256-1411-5781-91ec-d7bc3513ac07"
version = "0.6.0"

[[deps.EnumX]]
git-tree-sha1 = "bdb1942cd4c45e3c678fd11569d5cccd80976237"
uuid = "4e289a0a-7415-4d19-859d-a7e5c4648b56"
version = "1.0.4"

[[deps.EnzymeCore]]
git-tree-sha1 = "04c777af6ef65530a96ab68f0a81a4608113aa1d"
uuid = "f151be2c-9106-41f4-ab19-57ee4f262869"
version = "0.8.5"
weakdeps = ["Adapt"]

    [deps.EnzymeCore.extensions]
    AdaptExt = "Adapt"

[[deps.EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8e9441ee83492030ace98f9789a654a6d0b1f643"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "dcb08a0d93ec0b1cdc4af184b26b591e9695423a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.10"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1c6317308b9dc757616f0b5cb379db10494443a7"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.6.2+0"

[[deps.ExponentialUtilities]]
deps = ["Adapt", "ArrayInterface", "GPUArraysCore", "GenericSchur", "LinearAlgebra", "PrecompileTools", "Printf", "SparseArrays", "libblastrampoline_jll"]
git-tree-sha1 = "8e18940a5ba7f4ddb41fe2b79b6acaac50880a86"
uuid = "d4d017d3-3776-5f7e-afef-a10c40355c18"
version = "1.26.1"

[[deps.ExprTools]]
git-tree-sha1 = "27415f162e6028e81c72b82ef756bf321213b6ec"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.10"

[[deps.Expronicon]]
deps = ["MLStyle", "Pkg", "TOML"]
git-tree-sha1 = "fc3951d4d398b5515f91d7fe5d45fc31dccb3c9b"
uuid = "6b7a57c9-7cc1-4fdf-b7f5-e857abae3636"
version = "0.8.5"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "53ebe7511fa11d33bec688a9178fac4e49eeee00"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.2"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "466d45dc38e15794ec7d5d63ec03d776a9aff36e"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.4+1"

[[deps.FastAlmostBandedMatrices]]
deps = ["ArrayInterface", "ArrayLayouts", "BandedMatrices", "ConcreteStructs", "LazyArrays", "LinearAlgebra", "MatrixFactorizations", "PrecompileTools", "Reexport"]
git-tree-sha1 = "3f03d94c71126b6cfe20d3cbcc41c5cd27e1c419"
uuid = "9d29842c-ecb8-4973-b1e9-a27b1157504e"
version = "0.1.4"

[[deps.FastBroadcast]]
deps = ["ArrayInterface", "LinearAlgebra", "Polyester", "Static", "StaticArrayInterface", "StrideArraysCore"]
git-tree-sha1 = "ab1b34570bcdf272899062e1a56285a53ecaae08"
uuid = "7034ab61-46d4-4ed7-9d0f-46aef9175898"
version = "0.3.5"

[[deps.FastClosures]]
git-tree-sha1 = "acebe244d53ee1b461970f8910c235b259e772ef"
uuid = "9aa1b823-49e4-5ca5-8b0f-3971ec8bab6a"
version = "0.3.2"

[[deps.FastLapackInterface]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "cbf5edddb61a43669710cbc2241bc08b36d9e660"
uuid = "29a986be-02c6-4525-aec4-84b980013641"
version = "2.0.4"

[[deps.FastPower]]
git-tree-sha1 = "58c3431137131577a7c379d00fea00be524338fb"
uuid = "a4df4552-cc26-4903-aec0-212e50a0e84b"
version = "1.1.1"

    [deps.FastPower.extensions]
    FastPowerEnzymeExt = "Enzyme"
    FastPowerForwardDiffExt = "ForwardDiff"
    FastPowerMeasurementsExt = "Measurements"
    FastPowerMonteCarloMeasurementsExt = "MonteCarloMeasurements"
    FastPowerReverseDiffExt = "ReverseDiff"
    FastPowerTrackerExt = "Tracker"

    [deps.FastPower.weakdeps]
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
    MonteCarloMeasurements = "0987c9cc-fe09-11e8-30f0-b96dd679fdca"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FillArrays]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "6a70198746448456524cb442b8af316927ff3e1a"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.13.0"
weakdeps = ["PDMats", "SparseArrays", "Statistics"]

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

[[deps.FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Setfield"]
git-tree-sha1 = "b10bdafd1647f57ace3885143936749d61638c3b"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.26.0"

    [deps.FiniteDiff.extensions]
    FiniteDiffBandedMatricesExt = "BandedMatrices"
    FiniteDiffBlockBandedMatricesExt = "BlockBandedMatrices"
    FiniteDiffSparseArraysExt = "SparseArrays"
    FiniteDiffStaticArraysExt = "StaticArrays"

    [deps.FiniteDiff.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Zlib_jll"]
git-tree-sha1 = "db16beca600632c95fc8aca29890d83788dd8b23"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.96+0"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions"]
git-tree-sha1 = "a9ce73d3c827adab2d70bf168aaece8cce196898"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.37"
weakdeps = ["StaticArrays"]

    [deps.ForwardDiff.extensions]
    ForwardDiffStaticArraysExt = "StaticArrays"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "5c1d8ae0efc6c2e7b1fc502cbe25def8f661b7bc"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.2+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1ed150b39aebcc805c26b93a8d0122c940f64ce2"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.14+0"

[[deps.FunctionWrappers]]
git-tree-sha1 = "d62485945ce5ae9c0c48f124a84998d755bae00e"
uuid = "069b7b12-0de2-55c6-9aab-29f3d0a68a2e"
version = "1.1.3"

[[deps.FunctionWrappersWrappers]]
deps = ["FunctionWrappers"]
git-tree-sha1 = "b104d487b34566608f8b4e1c39fb0b10aa279ff8"
uuid = "77dc65aa-8811-40c2-897b-53d922fa7daf"
version = "0.1.3"

[[deps.Functors]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "64d8e93700c7a3f28f717d265382d52fac9fa1c1"
uuid = "d9f16b24-f501-4c13-a1f2-28368ffc5196"
version = "0.4.12"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"
version = "1.11.0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll", "libdecor_jll", "xkbcommon_jll"]
git-tree-sha1 = "532f9126ad901533af1d4f5c198867227a7bb077"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.4.0+1"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "ec632f177c0d990e64d955ccc1b8c04c485a0950"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.1.6"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Preferences", "Printf", "Qt6Wayland_jll", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "p7zip_jll"]
git-tree-sha1 = "ee28ddcd5517d54e417182fec3886e7412d3926f"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.73.8"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "f31929b9e67066bee48eec8b03c0df47d31a74b3"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.73.8+0"

[[deps.GenericLinearAlgebra]]
deps = ["LinearAlgebra", "Printf", "Random", "libblastrampoline_jll"]
git-tree-sha1 = "c4f9c87b74aedf20920034bd4db81d0bffc527d2"
uuid = "14197337-ba66-59df-a3e3-ca00e7dcff7a"
version = "0.3.14"

[[deps.GenericSchur]]
deps = ["LinearAlgebra", "Printf"]
git-tree-sha1 = "af49a0851f8113fcfae2ef5027c6d49d0acec39b"
uuid = "c145ed77-6b09-5dd9-b285-bf645a82121e"
version = "0.5.4"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "674ff0db93fffcd11a3573986e550d66cd4fd71f"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.80.5+0"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "1dc470db8b1131cfc7fb4c115de89fe391b9e780"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.12.0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "bc3f416a965ae61968c20d0ad867556367f2817d"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.9"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll"]
git-tree-sha1 = "401e4f3f30f43af2c8478fc008da50096ea5240f"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "8.3.1+0"

[[deps.HostCPUFeatures]]
deps = ["BitTwiddlingConvenienceFunctions", "IfElse", "Libdl", "Static"]
git-tree-sha1 = "8e070b599339d622e9a081d17230d74a5c473293"
uuid = "3e5b6fbb-0976-4d2c-9146-d79de83f2fb0"
version = "0.1.17"

[[deps.HypergeometricFunctions]]
deps = ["LinearAlgebra", "OpenLibm_jll", "SpecialFunctions"]
git-tree-sha1 = "7c4195be1649ae622304031ed46a2f4df989f1eb"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.24"

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.Inflate]]
git-tree-sha1 = "d1b1b796e47d94588b3757fe84fbf65a5ec4a80d"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.5"

[[deps.IntegerMathUtils]]
git-tree-sha1 = "b8ffb903da9f7b8cf695a8bead8e01814aa24b30"
uuid = "18e54dd8-cb9d-406c-a71d-865a43cbb235"
version = "0.1.2"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl"]
git-tree-sha1 = "10bd689145d2c3b2a9844005d01087cc1194e79e"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2024.2.1+0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.IntervalSets]]
git-tree-sha1 = "dba9ddf07f77f60450fe5d2e2beb9854d9a49bd0"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.10"
weakdeps = ["Random", "RecipesBase", "Statistics"]

    [deps.IntervalSets.extensions]
    IntervalSetsRandomExt = "Random"
    IntervalSetsRecipesBaseExt = "RecipesBase"
    IntervalSetsStatisticsExt = "Statistics"

[[deps.InverseFunctions]]
git-tree-sha1 = "a779299d77cd080bf77b97535acecd73e1c5e5cb"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.17"
weakdeps = ["Dates", "Test"]

    [deps.InverseFunctions.extensions]
    InverseFunctionsDatesExt = "Dates"
    InverseFunctionsTestExt = "Test"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "39d64b09147620f5ffbf6b2d3255be3c901bec63"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.8"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "be3dc50a92e5a386872a493a10050136d4703f9b"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.6.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "25ee0be4d43d0269027024d75a24c24d6c6e590c"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.0.4+0"

[[deps.JumpProcesses]]
deps = ["ArrayInterface", "DataStructures", "DiffEqBase", "DocStringExtensions", "FunctionWrappers", "Graphs", "LinearAlgebra", "Markdown", "PoissonRandom", "Random", "RandomNumbers", "RecursiveArrayTools", "Reexport", "SciMLBase", "Setfield", "StaticArrays", "SymbolicIndexingInterface", "UnPack"]
git-tree-sha1 = "c3a2cb6f968404ed3b1d5382bbdd7b7d83966598"
uuid = "ccbc3e58-028d-4f4c-8cd5-9ae44345cda5"
version = "9.14.0"
weakdeps = ["FastBroadcast"]

[[deps.KLU]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse_jll"]
git-tree-sha1 = "07649c499349dad9f08dde4243a4c597064663e9"
uuid = "ef3ab10e-7fda-4108-b977-705223b18434"
version = "0.6.0"

[[deps.Krylov]]
deps = ["LinearAlgebra", "Printf", "SparseArrays"]
git-tree-sha1 = "4f20a2df85a9e5d55c9e84634bbf808ed038cabd"
uuid = "ba0b0d4f-ebba-5204-a429-3ac8c609bfb7"
version = "0.9.8"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "170b660facf5df5de098d866564877e119141cbd"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.2+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "36bdbc52f13a7d1dcb0f3cd694e01677a515655b"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "4.0.0+0"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "78211fb6cbc872f77cad3fc0b6cf647d923f4929"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "18.1.7+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "854a9c268c43b77b0a27f22d7fab8d33cdb3a731"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.2+1"

[[deps.LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

[[deps.Latexify]]
deps = ["Format", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "ce5f5621cac23a86011836badfedf664a612cee4"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.5"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SparseArraysExt = "SparseArrays"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LayoutPointers]]
deps = ["ArrayInterface", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "a9eaadb366f5493a5654e843864c13d8b107548c"
uuid = "10f19ff3-798f-405d-979b-55457f8fc047"
version = "0.1.17"

[[deps.LazyArrays]]
deps = ["ArrayLayouts", "FillArrays", "LinearAlgebra", "MacroTools", "SparseArrays"]
git-tree-sha1 = "360f6039babd6e4d6364eff0d4fc9120834a2d9a"
uuid = "5078a376-72f3-5289-bfd5-ec5146d43c02"
version = "2.2.1"

    [deps.LazyArrays.extensions]
    LazyArraysBandedMatricesExt = "BandedMatrices"
    LazyArraysBlockArraysExt = "BlockArrays"
    LazyArraysBlockBandedMatricesExt = "BlockBandedMatrices"
    LazyArraysStaticArraysExt = "StaticArrays"

    [deps.LazyArrays.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockArrays = "8e7c35d0-a365-5155-bbbb-fb81a777f24e"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"
version = "1.11.0"

[[deps.LevyArea]]
deps = ["LinearAlgebra", "Random", "SpecialFunctions"]
git-tree-sha1 = "56513a09b8e0ae6485f34401ea9e2f31357958ec"
uuid = "2d8b4e74-eb68-11e8-0fb9-d5eb67b50637"
version = "1.0.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll"]
git-tree-sha1 = "8be878062e0ffa2c3f67bb58a595375eda5de80b"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.11.0+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c6ce1e19f3aec9b59186bdf06cdf3c4fc5f5f3e6"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.50.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "61dfdba58e585066d8bce214c5a51eaa0539f269"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "0c4f9c4f1a50d8f35048fa0532dabbadf702f81e"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.40.1+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "b404131d06f7886402758c9ce2214b636eb4d54a"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.7.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "5ee6203157c120d79034c748a2acba45b82b8807"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.40.1+0"

[[deps.LineSearch]]
deps = ["ADTypes", "CommonSolve", "ConcreteStructs", "FastClosures", "LinearAlgebra", "MaybeInplace", "SciMLBase", "SciMLJacobianOperators", "StaticArraysCore"]
git-tree-sha1 = "97d502765cc5cf3a722120f50da03c2474efce04"
uuid = "87fe0de2-c867-4266-b59a-2f0a94fc965b"
version = "0.1.4"
weakdeps = ["LineSearches"]

    [deps.LineSearch.extensions]
    LineSearchLineSearchesExt = "LineSearches"

[[deps.LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "e4c3be53733db1051cc15ecf573b1042b3a712a1"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.3.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.LinearSolve]]
deps = ["ArrayInterface", "ChainRulesCore", "ConcreteStructs", "DocStringExtensions", "EnumX", "FastLapackInterface", "GPUArraysCore", "InteractiveUtils", "KLU", "Krylov", "LazyArrays", "Libdl", "LinearAlgebra", "MKL_jll", "Markdown", "PrecompileTools", "Preferences", "RecursiveFactorization", "Reexport", "SciMLBase", "SciMLOperators", "Setfield", "SparseArrays", "Sparspak", "StaticArraysCore", "UnPack"]
git-tree-sha1 = "591de175461afd8323aa24b7686062574527aa3a"
uuid = "7ed4a6bd-45f5-4d41-b270-4a48e9bafcae"
version = "2.36.2"

    [deps.LinearSolve.extensions]
    LinearSolveBandedMatricesExt = "BandedMatrices"
    LinearSolveBlockDiagonalsExt = "BlockDiagonals"
    LinearSolveCUDAExt = "CUDA"
    LinearSolveCUDSSExt = "CUDSS"
    LinearSolveEnzymeExt = "EnzymeCore"
    LinearSolveFastAlmostBandedMatricesExt = "FastAlmostBandedMatrices"
    LinearSolveHYPREExt = "HYPRE"
    LinearSolveIterativeSolversExt = "IterativeSolvers"
    LinearSolveKernelAbstractionsExt = "KernelAbstractions"
    LinearSolveKrylovKitExt = "KrylovKit"
    LinearSolveMetalExt = "Metal"
    LinearSolvePardisoExt = "Pardiso"
    LinearSolveRecursiveArrayToolsExt = "RecursiveArrayTools"

    [deps.LinearSolve.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockDiagonals = "0a1fb500-61f7-11e9-3c65-f5ef3456f9f0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    CUDSS = "45b445bb-4962-46a0-9369-b4df9d0f772e"
    EnzymeCore = "f151be2c-9106-41f4-ab19-57ee4f262869"
    FastAlmostBandedMatrices = "9d29842c-ecb8-4973-b1e9-a27b1157504e"
    HYPRE = "b5ffcf37-a2bd-41ab-a3da-4bd9bc8ad771"
    IterativeSolvers = "42fd0dbc-a981-5370-80f2-aaf504508153"
    KernelAbstractions = "63c18a36-062a-441e-b654-da1e3ab1ce7c"
    KrylovKit = "0b1a1467-8014-51b9-945f-bf0ae24f4b77"
    Metal = "dde4c033-4e86-420c-a63e-0dd931031962"
    Pardiso = "46dd5b70-b6fb-5a00-ae2d-e8fea33afaf2"
    RecursiveArrayTools = "731186ca-8d62-57ce-b412-fbd966d074cd"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "a2d09619db4e765091ee5c6ffe8872849de0feea"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.28"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "f02b56007b064fbfddb4c9cd60161b6dd0f40df3"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.1.0"

[[deps.LoopVectorization]]
deps = ["ArrayInterface", "CPUSummary", "CloseOpenIntervals", "DocStringExtensions", "HostCPUFeatures", "IfElse", "LayoutPointers", "LinearAlgebra", "OffsetArrays", "PolyesterWeave", "PrecompileTools", "SIMDTypes", "SLEEFPirates", "Static", "StaticArrayInterface", "ThreadingUtilities", "UnPack", "VectorizationBase"]
git-tree-sha1 = "8084c25a250e00ae427a379a5b607e7aed96a2dd"
uuid = "bdcacae8-1622-11e9-2a5c-532679323890"
version = "0.12.171"
weakdeps = ["ChainRulesCore", "ForwardDiff", "SpecialFunctions"]

    [deps.LoopVectorization.extensions]
    ForwardDiffExt = ["ChainRulesCore", "ForwardDiff"]
    SpecialFunctionsExt = "SpecialFunctions"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "oneTBB_jll"]
git-tree-sha1 = "f046ccd0c6db2832a9f639e2c669c6fe867e5f4f"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2024.2.0+0"

[[deps.MLStyle]]
git-tree-sha1 = "bc38dff0548128765760c79eb7388a4b37fae2c8"
uuid = "d8e11817-5142-5d16-987a-aa16d5891078"
version = "0.4.17"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.ManualMemory]]
git-tree-sha1 = "bcaef4fc7a0cfe2cba636d84cda54b5e4e4ca3cd"
uuid = "d125e4d3-2237-4719-b19c-fa641b8a4667"
version = "0.1.8"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MatrixFactorizations]]
deps = ["ArrayLayouts", "LinearAlgebra", "Printf", "Random"]
git-tree-sha1 = "16a726dba99685d9e94c8d0a8f655383121fc608"
uuid = "a3b82374-2e81-5b9e-98ce-41277c0e4c87"
version = "3.0.1"
weakdeps = ["BandedMatrices"]

    [deps.MatrixFactorizations.extensions]
    MatrixFactorizationsBandedMatricesExt = "BandedMatrices"

[[deps.MaybeInplace]]
deps = ["ArrayInterface", "LinearAlgebra", "MacroTools"]
git-tree-sha1 = "54e2fdc38130c05b42be423e90da3bade29b74bd"
uuid = "bb5d69b7-63fc-4a16-80bd-7e42200c7bdb"
version = "0.1.4"
weakdeps = ["SparseArrays"]

    [deps.MaybeInplace.extensions]
    MaybeInplaceSparseArraysExt = "SparseArrays"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.MuladdMacro]]
git-tree-sha1 = "cac9cc5499c25554cba55cd3c30543cff5ca4fab"
uuid = "46d2c3a1-f734-5fdb-9937-b9b9aeba4221"
version = "0.2.4"

[[deps.MultivariatePolynomials]]
deps = ["ChainRulesCore", "DataStructures", "LinearAlgebra", "MutableArithmetics"]
git-tree-sha1 = "8d39779e29f80aa6c071e7ac17101c6e31f075d7"
uuid = "102ac46a-7ee4-5c85-9060-abc95bfdeaa3"
version = "0.5.7"

[[deps.MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "90077f1e79de8c9c7c8a90644494411111f4e07b"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "1.5.2"

[[deps.NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "a0b464d183da839699f4c79e7606d9d186ec172c"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.3"

[[deps.NLsolve]]
deps = ["Distances", "LineSearches", "LinearAlgebra", "NLSolversBase", "Printf", "Reexport"]
git-tree-sha1 = "019f12e9a1a7880459d0173c182e6a99365d7ac1"
uuid = "2774e3e8-f4cf-5e23-947b-6d7e65073b56"
version = "4.5.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.NonlinearSolve]]
deps = ["ADTypes", "ArrayInterface", "ConcreteStructs", "DiffEqBase", "DifferentiationInterface", "FastBroadcast", "FastClosures", "FiniteDiff", "ForwardDiff", "LazyArrays", "LineSearch", "LineSearches", "LinearAlgebra", "LinearSolve", "MaybeInplace", "PrecompileTools", "Preferences", "Printf", "RecursiveArrayTools", "Reexport", "SciMLBase", "SciMLJacobianOperators", "SciMLOperators", "Setfield", "SimpleNonlinearSolve", "SparseArrays", "SparseConnectivityTracer", "SparseMatrixColorings", "StaticArraysCore", "SymbolicIndexingInterface", "TimerOutputs"]
git-tree-sha1 = "4d8944f32db2b07a2bdf8477e878bcb9c9ea2308"
uuid = "8913a72c-1f9b-4ce2-8d82-65094dcecaec"
version = "3.15.1"

    [deps.NonlinearSolve.extensions]
    NonlinearSolveBandedMatricesExt = "BandedMatrices"
    NonlinearSolveFastLevenbergMarquardtExt = "FastLevenbergMarquardt"
    NonlinearSolveFixedPointAccelerationExt = "FixedPointAcceleration"
    NonlinearSolveLeastSquaresOptimExt = "LeastSquaresOptim"
    NonlinearSolveMINPACKExt = "MINPACK"
    NonlinearSolveNLSolversExt = "NLSolvers"
    NonlinearSolveNLsolveExt = "NLsolve"
    NonlinearSolveSIAMFANLEquationsExt = "SIAMFANLEquations"
    NonlinearSolveSpeedMappingExt = "SpeedMapping"

    [deps.NonlinearSolve.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    FastLevenbergMarquardt = "7a0df574-e128-4d35-8cbd-3d84502bf7ce"
    FixedPointAcceleration = "817d07cb-a79a-5c30-9a31-890123675176"
    LeastSquaresOptim = "0fc2ff8b-aaa3-5acd-a817-1944a5e08891"
    MINPACK = "4854310b-de5a-5eb6-a2a5-c1dee2bd17f9"
    NLSolvers = "337daf1e-9722-11e9-073e-8b9effe078ba"
    NLsolve = "2774e3e8-f4cf-5e23-947b-6d7e65073b56"
    SIAMFANLEquations = "084e46ad-d928-497d-ad5e-07fa361a48c4"
    SpeedMapping = "f1835b91-879b-4a3f-a438-e4baacf14412"

[[deps.OffsetArrays]]
git-tree-sha1 = "1a27764e945a152f7ca7efa04de513d473e9542e"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.14.1"
weakdeps = ["Adapt"]

    [deps.OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+2"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "38cb508d080d21dc1128f7fb04f20387ed4c0af4"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7493f61f55a6cce7325f197443aa80d32554ba10"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.15+1"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Optim]]
deps = ["Compat", "FillArrays", "ForwardDiff", "LineSearches", "LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "PositiveFactorizations", "Printf", "SparseArrays", "StatsBase"]
git-tree-sha1 = "d9b79c4eed437421ac4285148fcadf42e0700e89"
uuid = "429524aa-4258-5aef-a3af-852621145aeb"
version = "1.9.4"

    [deps.Optim.extensions]
    OptimMOIExt = "MathOptInterface"

    [deps.Optim.weakdeps]
    MathOptInterface = "b8f27783-ece8-5eb3-8dc8-9495eed66fee"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6703a85cb3781bd5909d48730a67205f3f31a575"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.3+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.OrdinaryDiffEq]]
deps = ["ADTypes", "Adapt", "ArrayInterface", "DataStructures", "DiffEqBase", "DocStringExtensions", "EnumX", "ExponentialUtilities", "FastBroadcast", "FastClosures", "FillArrays", "FiniteDiff", "ForwardDiff", "FunctionWrappersWrappers", "InteractiveUtils", "LineSearches", "LinearAlgebra", "LinearSolve", "Logging", "MacroTools", "MuladdMacro", "NonlinearSolve", "OrdinaryDiffEqAdamsBashforthMoulton", "OrdinaryDiffEqBDF", "OrdinaryDiffEqCore", "OrdinaryDiffEqDefault", "OrdinaryDiffEqDifferentiation", "OrdinaryDiffEqExplicitRK", "OrdinaryDiffEqExponentialRK", "OrdinaryDiffEqExtrapolation", "OrdinaryDiffEqFIRK", "OrdinaryDiffEqFeagin", "OrdinaryDiffEqFunctionMap", "OrdinaryDiffEqHighOrderRK", "OrdinaryDiffEqIMEXMultistep", "OrdinaryDiffEqLinear", "OrdinaryDiffEqLowOrderRK", "OrdinaryDiffEqLowStorageRK", "OrdinaryDiffEqNonlinearSolve", "OrdinaryDiffEqNordsieck", "OrdinaryDiffEqPDIRK", "OrdinaryDiffEqPRK", "OrdinaryDiffEqQPRK", "OrdinaryDiffEqRKN", "OrdinaryDiffEqRosenbrock", "OrdinaryDiffEqSDIRK", "OrdinaryDiffEqSSPRK", "OrdinaryDiffEqStabilizedIRK", "OrdinaryDiffEqStabilizedRK", "OrdinaryDiffEqSymplecticRK", "OrdinaryDiffEqTsit5", "OrdinaryDiffEqVerner", "Polyester", "PreallocationTools", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "SciMLOperators", "SciMLStructures", "SimpleNonlinearSolve", "SimpleUnPack", "SparseArrays", "SparseDiffTools", "Static", "StaticArrayInterface", "StaticArrays", "TruncatedStacktraces"]
git-tree-sha1 = "cd892f12371c287dc50d6ad3af075b088b6f2d48"
uuid = "1dea7af3-3e70-54e6-95c3-0bf5283fa5ed"
version = "6.89.0"

[[deps.OrdinaryDiffEqAdamsBashforthMoulton]]
deps = ["ADTypes", "DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqLowOrderRK", "Polyester", "RecursiveArrayTools", "Reexport", "Static"]
git-tree-sha1 = "8e3c5978d0531a961f70d2f2730d1d16ed3bbd12"
uuid = "89bda076-bce5-4f1c-845f-551c83cdda9a"
version = "1.1.0"

[[deps.OrdinaryDiffEqBDF]]
deps = ["ArrayInterface", "DiffEqBase", "FastBroadcast", "LinearAlgebra", "MacroTools", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "OrdinaryDiffEqNonlinearSolve", "OrdinaryDiffEqSDIRK", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "StaticArrays", "TruncatedStacktraces"]
git-tree-sha1 = "b4498d40bf35da0b6d22652ff2e9d8820590b3c6"
uuid = "6ad6398a-0878-4a85-9266-38940aa047c8"
version = "1.1.2"

[[deps.OrdinaryDiffEqCore]]
deps = ["ADTypes", "Accessors", "Adapt", "ArrayInterface", "DataStructures", "DiffEqBase", "DocStringExtensions", "EnumX", "FastBroadcast", "FastClosures", "FastPower", "FillArrays", "FunctionWrappersWrappers", "InteractiveUtils", "LinearAlgebra", "Logging", "MacroTools", "MuladdMacro", "Polyester", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "SciMLOperators", "SciMLStructures", "SimpleUnPack", "Static", "StaticArrayInterface", "StaticArraysCore", "TruncatedStacktraces"]
git-tree-sha1 = "1175717a62ab21736a8f5d0d2531d2a6ad3b9e74"
uuid = "bbf590c4-e513-4bbe-9b18-05decba2e5d8"
version = "1.9.0"
weakdeps = ["EnzymeCore"]

    [deps.OrdinaryDiffEqCore.extensions]
    OrdinaryDiffEqCoreEnzymeCoreExt = "EnzymeCore"

[[deps.OrdinaryDiffEqDefault]]
deps = ["DiffEqBase", "EnumX", "LinearAlgebra", "LinearSolve", "OrdinaryDiffEqBDF", "OrdinaryDiffEqCore", "OrdinaryDiffEqRosenbrock", "OrdinaryDiffEqTsit5", "OrdinaryDiffEqVerner", "PrecompileTools", "Preferences", "Reexport"]
git-tree-sha1 = "c8223e487d58bef28a3535b33ddf8ffdb44f46fb"
uuid = "50262376-6c5a-4cf5-baba-aaf4f84d72d7"
version = "1.1.0"

[[deps.OrdinaryDiffEqDifferentiation]]
deps = ["ADTypes", "ArrayInterface", "DiffEqBase", "FastBroadcast", "FiniteDiff", "ForwardDiff", "FunctionWrappersWrappers", "LinearAlgebra", "LinearSolve", "OrdinaryDiffEqCore", "SciMLBase", "SparseArrays", "SparseDiffTools", "StaticArrayInterface", "StaticArrays"]
git-tree-sha1 = "e63ec633b1efa99e3caa2e26a01faaa88ba6cef9"
uuid = "4302a76b-040a-498a-8c04-15b101fed76b"
version = "1.1.0"

[[deps.OrdinaryDiffEqExplicitRK]]
deps = ["DiffEqBase", "FastBroadcast", "LinearAlgebra", "MuladdMacro", "OrdinaryDiffEqCore", "RecursiveArrayTools", "Reexport", "TruncatedStacktraces"]
git-tree-sha1 = "4dbce3f9e6974567082ce5176e21aab0224a69e9"
uuid = "9286f039-9fbf-40e8-bf65-aa933bdc4db0"
version = "1.1.0"

[[deps.OrdinaryDiffEqExponentialRK]]
deps = ["DiffEqBase", "ExponentialUtilities", "FastBroadcast", "LinearAlgebra", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "OrdinaryDiffEqSDIRK", "OrdinaryDiffEqVerner", "RecursiveArrayTools", "Reexport", "SciMLBase"]
git-tree-sha1 = "f63938b8e9e5d3a05815defb3ebdbdcf61ec0a74"
uuid = "e0540318-69ee-4070-8777-9e2de6de23de"
version = "1.1.0"

[[deps.OrdinaryDiffEqExtrapolation]]
deps = ["DiffEqBase", "FastBroadcast", "FastPower", "LinearSolve", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "Polyester", "RecursiveArrayTools", "Reexport"]
git-tree-sha1 = "048bcccc8f59c20d5b4ad268eef4d7d21c005a94"
uuid = "becaefa8-8ca2-5cf9-886d-c06f3d2bd2c4"
version = "1.2.1"

[[deps.OrdinaryDiffEqFIRK]]
deps = ["DiffEqBase", "FastBroadcast", "FastPower", "GenericLinearAlgebra", "GenericSchur", "LinearAlgebra", "LinearSolve", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "OrdinaryDiffEqNonlinearSolve", "Polynomials", "RecursiveArrayTools", "Reexport", "RootedTrees", "SciMLOperators", "Symbolics"]
git-tree-sha1 = "5735f4c094dff311f5064d1a351da9669e4647e3"
uuid = "5960d6e9-dd7a-4743-88e7-cf307b64f125"
version = "1.2.0"

[[deps.OrdinaryDiffEqFeagin]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "Polyester", "RecursiveArrayTools", "Reexport", "Static"]
git-tree-sha1 = "a7cc74d3433db98e59dc3d58bc28174c6c290adf"
uuid = "101fe9f7-ebb6-4678-b671-3a81e7194747"
version = "1.1.0"

[[deps.OrdinaryDiffEqFunctionMap]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "RecursiveArrayTools", "Reexport", "SciMLBase", "Static"]
git-tree-sha1 = "925a91583d1ab84f1f0fea121be1abf1179c5926"
uuid = "d3585ca7-f5d3-4ba6-8057-292ed1abd90f"
version = "1.1.1"

[[deps.OrdinaryDiffEqHighOrderRK]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "RecursiveArrayTools", "Reexport", "Static"]
git-tree-sha1 = "103e017ff186ac39d731904045781c9bacfca2b0"
uuid = "d28bc4f8-55e1-4f49-af69-84c1a99f0f58"
version = "1.1.0"

[[deps.OrdinaryDiffEqIMEXMultistep]]
deps = ["DiffEqBase", "FastBroadcast", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "OrdinaryDiffEqNonlinearSolve", "Reexport"]
git-tree-sha1 = "9f8f52aad2399d7714b400ff9d203254b0a89c4a"
uuid = "9f002381-b378-40b7-97a6-27a27c83f129"
version = "1.1.0"

[[deps.OrdinaryDiffEqLinear]]
deps = ["DiffEqBase", "ExponentialUtilities", "LinearAlgebra", "OrdinaryDiffEqCore", "OrdinaryDiffEqTsit5", "OrdinaryDiffEqVerner", "RecursiveArrayTools", "Reexport", "SciMLBase", "SciMLOperators"]
git-tree-sha1 = "0f81a77ede3da0dc714ea61e81c76b25db4ab87a"
uuid = "521117fe-8c41-49f8-b3b6-30780b3f0fb5"
version = "1.1.0"

[[deps.OrdinaryDiffEqLowOrderRK]]
deps = ["DiffEqBase", "FastBroadcast", "LinearAlgebra", "MuladdMacro", "OrdinaryDiffEqCore", "RecursiveArrayTools", "Reexport", "SciMLBase", "Static"]
git-tree-sha1 = "d4bb32e09d6b68ce2eb45fb81001eab46f60717a"
uuid = "1344f307-1e59-4825-a18e-ace9aa3fa4c6"
version = "1.2.0"

[[deps.OrdinaryDiffEqLowStorageRK]]
deps = ["Adapt", "DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "Polyester", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "Static", "StaticArrays"]
git-tree-sha1 = "590561f3af623d5485d070b4d7044f8854535f5a"
uuid = "b0944070-b475-4768-8dec-fb6eb410534d"
version = "1.2.1"

[[deps.OrdinaryDiffEqNonlinearSolve]]
deps = ["ADTypes", "ArrayInterface", "DiffEqBase", "FastBroadcast", "FastClosures", "ForwardDiff", "LinearAlgebra", "LinearSolve", "MuladdMacro", "NonlinearSolve", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "PreallocationTools", "RecursiveArrayTools", "SciMLBase", "SciMLOperators", "SciMLStructures", "SimpleNonlinearSolve", "StaticArrays"]
git-tree-sha1 = "a2a4119f3e35f7982f78e17beea7b12485d179e9"
uuid = "127b3ac7-2247-4354-8eb6-78cf4e7c58e8"
version = "1.2.1"

[[deps.OrdinaryDiffEqNordsieck]]
deps = ["DiffEqBase", "FastBroadcast", "LinearAlgebra", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqTsit5", "Polyester", "RecursiveArrayTools", "Reexport", "Static"]
git-tree-sha1 = "ef44754f10e0dfb9bb55ded382afed44cd94ab57"
uuid = "c9986a66-5c92-4813-8696-a7ec84c806c8"
version = "1.1.0"

[[deps.OrdinaryDiffEqPDIRK]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "OrdinaryDiffEqNonlinearSolve", "Polyester", "Reexport", "StaticArrays"]
git-tree-sha1 = "a8b7f8107c477e07c6a6c00d1d66cac68b801bbc"
uuid = "5dd0a6cf-3d4b-4314-aa06-06d4e299bc89"
version = "1.1.0"

[[deps.OrdinaryDiffEqPRK]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "Polyester", "Reexport"]
git-tree-sha1 = "da525d277962a1b76102c79f30cb0c31e13fe5b9"
uuid = "5b33eab2-c0f1-4480-b2c3-94bc1e80bda1"
version = "1.1.0"

[[deps.OrdinaryDiffEqQPRK]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "RecursiveArrayTools", "Reexport", "Static"]
git-tree-sha1 = "332f9d17d0229218f66a73492162267359ba85e9"
uuid = "04162be5-8125-4266-98ed-640baecc6514"
version = "1.1.0"

[[deps.OrdinaryDiffEqRKN]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "Polyester", "RecursiveArrayTools", "Reexport"]
git-tree-sha1 = "41c09d9c20877546490f907d8dffdd52690dd65f"
uuid = "af6ede74-add8-4cfd-b1df-9a4dbb109d7a"
version = "1.1.0"

[[deps.OrdinaryDiffEqRosenbrock]]
deps = ["ADTypes", "DiffEqBase", "FastBroadcast", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "LinearSolve", "MacroTools", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "Polyester", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "Static"]
git-tree-sha1 = "96b47cdd12cb4ce8f70d701b49f855271a462bd4"
uuid = "43230ef6-c299-4910-a778-202eb28ce4ce"
version = "1.2.0"

[[deps.OrdinaryDiffEqSDIRK]]
deps = ["DiffEqBase", "FastBroadcast", "LinearAlgebra", "MacroTools", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "OrdinaryDiffEqNonlinearSolve", "RecursiveArrayTools", "Reexport", "SciMLBase", "TruncatedStacktraces"]
git-tree-sha1 = "f6683803a58de600ab7a26d2f49411c9923e9721"
uuid = "2d112036-d095-4a1e-ab9a-08536f3ecdbf"
version = "1.1.0"

[[deps.OrdinaryDiffEqSSPRK]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "Polyester", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "Static", "StaticArrays"]
git-tree-sha1 = "7dbe4ac56f930df5e9abd003cedb54e25cbbea86"
uuid = "669c94d9-1f4b-4b64-b377-1aa079aa2388"
version = "1.2.0"

[[deps.OrdinaryDiffEqStabilizedIRK]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "OrdinaryDiffEqNonlinearSolve", "RecursiveArrayTools", "Reexport", "StaticArrays"]
git-tree-sha1 = "348fd6def9a88518715425025eadd58517017325"
uuid = "e3e12d00-db14-5390-b879-ac3dd2ef6296"
version = "1.1.0"

[[deps.OrdinaryDiffEqStabilizedRK]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "RecursiveArrayTools", "Reexport", "StaticArrays"]
git-tree-sha1 = "1b0d894c880e25f7d0b022d7257638cf8ce5b311"
uuid = "358294b1-0aab-51c3-aafe-ad5ab194a2ad"
version = "1.1.0"

[[deps.OrdinaryDiffEqSymplecticRK]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "Polyester", "RecursiveArrayTools", "Reexport"]
git-tree-sha1 = "4e8b8c8b81df3df17e2eb4603115db3b30a88235"
uuid = "fa646aed-7ef9-47eb-84c4-9443fc8cbfa8"
version = "1.1.0"

[[deps.OrdinaryDiffEqTsit5]]
deps = ["DiffEqBase", "FastBroadcast", "LinearAlgebra", "MuladdMacro", "OrdinaryDiffEqCore", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "Static", "TruncatedStacktraces"]
git-tree-sha1 = "96552f7d4619fabab4038a29ed37dd55e9eb513a"
uuid = "b1df2697-797e-41e3-8120-5422d3b24e4a"
version = "1.1.0"

[[deps.OrdinaryDiffEqVerner]]
deps = ["DiffEqBase", "FastBroadcast", "LinearAlgebra", "MuladdMacro", "OrdinaryDiffEqCore", "Polyester", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "Static", "TruncatedStacktraces"]
git-tree-sha1 = "81d7841e73e385b9925d5c8e4427f2adcdda55db"
uuid = "79d7bb75-1356-48c1-b8c0-6832512096c2"
version = "1.1.1"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+1"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "949347156c25054de2db3b166c52ac4728cbad65"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.31"

[[deps.PackageExtensionCompat]]
git-tree-sha1 = "fb28e33b8a95c4cee25ce296c817d89cc2e53518"
uuid = "65ce6f38-6b18-4e1d-a461-8949797d7930"
version = "1.0.2"
weakdeps = ["Requires", "TOML"]

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e127b609fb9ecba6f201ba7ab753d5a605d53801"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.54.1+0"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "35621f10a7531bc8fa58f74610b1bfb70a3cfc6b"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.43.4+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"
weakdeps = ["REPL"]

    [deps.Pkg.extensions]
    REPLExt = "REPL"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "41031ef3a1be6f5bbbf3e8073f210556daeae5ca"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.3.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "StableRNGs", "Statistics"]
git-tree-sha1 = "3ca9a356cd2e113c420f2c13bea19f8d3fb1cb18"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.3"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "TOML", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "45470145863035bb124ca51b320ed35d071cc6c2"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.40.8"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PoissonRandom]]
deps = ["Random"]
git-tree-sha1 = "a0f1159c33f846aa77c3f30ebbc69795e5327152"
uuid = "e409e4f3-bfea-5376-8464-e040bb5c01ab"
version = "0.4.4"

[[deps.Polyester]]
deps = ["ArrayInterface", "BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "ManualMemory", "PolyesterWeave", "Static", "StaticArrayInterface", "StrideArraysCore", "ThreadingUtilities"]
git-tree-sha1 = "6d38fea02d983051776a856b7df75b30cf9a3c1f"
uuid = "f517fe37-dbe3-4b94-8317-1923a5111588"
version = "0.7.16"

[[deps.PolyesterWeave]]
deps = ["BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "Static", "ThreadingUtilities"]
git-tree-sha1 = "645bed98cd47f72f67316fd42fc47dee771aefcd"
uuid = "1d0040c9-8b98-4ee7-8388-3f51789ca0ad"
version = "0.2.2"

[[deps.Polynomials]]
deps = ["LinearAlgebra", "RecipesBase", "Requires", "Setfield", "SparseArrays"]
git-tree-sha1 = "1a9cfb2dc2c2f1bd63f1906d72af39a79b49b736"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "4.0.11"

    [deps.Polynomials.extensions]
    PolynomialsChainRulesCoreExt = "ChainRulesCore"
    PolynomialsFFTWExt = "FFTW"
    PolynomialsMakieCoreExt = "MakieCore"
    PolynomialsMutableArithmeticsExt = "MutableArithmetics"

    [deps.Polynomials.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    FFTW = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
    MakieCore = "20f20a25-4f0e-4fdf-b5d1-57303727442b"
    MutableArithmetics = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"

[[deps.PositiveFactorizations]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "17275485f373e6673f7e7f97051f703ed5b15b20"
uuid = "85a6dd25-e78a-55b7-8502-1745935b8125"
version = "0.2.4"

[[deps.PreallocationTools]]
deps = ["Adapt", "ArrayInterface", "ForwardDiff"]
git-tree-sha1 = "6c62ce45f268f3f958821a1e5192cf91c75ae89c"
uuid = "d236fae5-4411-538c-8e31-a6e3d9e00b46"
version = "0.4.24"

    [deps.PreallocationTools.extensions]
    PreallocationToolsReverseDiffExt = "ReverseDiff"

    [deps.PreallocationTools.weakdeps]
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Primes]]
deps = ["IntegerMathUtils"]
git-tree-sha1 = "cb420f77dc474d23ee47ca8d14c90810cafe69e7"
uuid = "27ebfcd6-29c5-5fa9-bf4b-fb8fc14df3ae"
version = "0.5.6"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.PtrArrays]]
git-tree-sha1 = "77a42d78b6a92df47ab37e177b2deac405e1c88f"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.2.1"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "492601870742dcd38f233b23c3ec629628c1d724"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.7.1+1"

[[deps.Qt6Declarative_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll", "Qt6ShaderTools_jll"]
git-tree-sha1 = "e5dd466bf2569fe08c91a2cc29c1003f4797ac3b"
uuid = "629bc702-f1f5-5709-abd5-49b8460ea067"
version = "6.7.1+2"

[[deps.Qt6ShaderTools_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll"]
git-tree-sha1 = "1a180aeced866700d4bebc3120ea1451201f16bc"
uuid = "ce943373-25bb-56aa-8eca-768745ed7b5a"
version = "6.7.1+1"

[[deps.Qt6Wayland_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll", "Qt6Declarative_jll"]
git-tree-sha1 = "729927532d48cf79f49070341e1d918a65aba6b0"
uuid = "e99dba38-086e-5de3-a5b1-6e4c66e897c3"
version = "6.7.1+1"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "cda3b045cf9ef07a08ad46731f5a3165e56cf3da"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.11.1"

    [deps.QuadGK.extensions]
    QuadGKEnzymeExt = "Enzyme"

    [deps.QuadGK.weakdeps]
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Random123]]
deps = ["Random", "RandomNumbers"]
git-tree-sha1 = "4743b43e5a9c4a2ede372de7061eed81795b12e7"
uuid = "74087812-796a-5b5d-8853-05524746bad3"
version = "1.7.0"

[[deps.RandomNumbers]]
deps = ["Random"]
git-tree-sha1 = "c6ec94d2aaba1ab2ff983052cf6a606ca5985902"
uuid = "e6cf234a-135c-5ec9-84dd-332b85af5143"
version = "1.6.0"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.RecursiveArrayTools]]
deps = ["Adapt", "ArrayInterface", "DocStringExtensions", "GPUArraysCore", "IteratorInterfaceExtensions", "LinearAlgebra", "RecipesBase", "StaticArraysCore", "Statistics", "SymbolicIndexingInterface", "Tables"]
git-tree-sha1 = "ed2514425d030d7c9054fa0f2275ada45681788d"
uuid = "731186ca-8d62-57ce-b412-fbd966d074cd"
version = "3.27.2"

    [deps.RecursiveArrayTools.extensions]
    RecursiveArrayToolsFastBroadcastExt = "FastBroadcast"
    RecursiveArrayToolsForwardDiffExt = "ForwardDiff"
    RecursiveArrayToolsMeasurementsExt = "Measurements"
    RecursiveArrayToolsMonteCarloMeasurementsExt = "MonteCarloMeasurements"
    RecursiveArrayToolsReverseDiffExt = ["ReverseDiff", "Zygote"]
    RecursiveArrayToolsSparseArraysExt = ["SparseArrays"]
    RecursiveArrayToolsTrackerExt = "Tracker"
    RecursiveArrayToolsZygoteExt = "Zygote"

    [deps.RecursiveArrayTools.weakdeps]
    FastBroadcast = "7034ab61-46d4-4ed7-9d0f-46aef9175898"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
    MonteCarloMeasurements = "0987c9cc-fe09-11e8-30f0-b96dd679fdca"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.RecursiveFactorization]]
deps = ["LinearAlgebra", "LoopVectorization", "Polyester", "PrecompileTools", "StrideArraysCore", "TriangularSolve"]
git-tree-sha1 = "6db1a75507051bc18bfa131fbc7c3f169cc4b2f6"
uuid = "f2c3362d-daeb-58d1-803e-2bc74f2840b4"
version = "0.2.23"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.ResettableStacks]]
deps = ["StaticArrays"]
git-tree-sha1 = "256eeeec186fa7f26f2801732774ccf277f05db9"
uuid = "ae5879a3-cd67-5da8-be7f-38c6eb64a37b"
version = "1.1.1"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "852bd0f55565a9e973fcfee83a84413270224dc4"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.8.0"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "58cdd8fb2201a6267e1db87ff148dd6c1dbd8ad8"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.5.1+0"

[[deps.RootedTrees]]
deps = ["LaTeXStrings", "Latexify", "LinearAlgebra", "Preferences", "RecipesBase", "Requires"]
git-tree-sha1 = "c0c464d3063e46e4128d21fd677ca575ace44fdc"
uuid = "47965b36-3f3e-11e9-0dcf-4570dfd42a8c"
version = "2.23.1"
weakdeps = ["Plots"]

    [deps.RootedTrees.extensions]
    PlotsExt = "Plots"

[[deps.RuntimeGeneratedFunctions]]
deps = ["ExprTools", "SHA", "Serialization"]
git-tree-sha1 = "04c968137612c4a5629fa531334bb81ad5680f00"
uuid = "7e49a35a-f44a-4d26-94aa-eba1b4ca6b47"
version = "0.5.13"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SIMDTypes]]
git-tree-sha1 = "330289636fb8107c5f32088d2741e9fd7a061a5c"
uuid = "94e857df-77ce-4151-89e5-788b33177be4"
version = "0.1.0"

[[deps.SLEEFPirates]]
deps = ["IfElse", "Static", "VectorizationBase"]
git-tree-sha1 = "456f610ca2fbd1c14f5fcf31c6bfadc55e7d66e0"
uuid = "476501e8-09a2-5ece-8869-fb82de89a1fa"
version = "0.6.43"

[[deps.SciMLBase]]
deps = ["ADTypes", "Accessors", "ArrayInterface", "CommonSolve", "ConstructionBase", "Distributed", "DocStringExtensions", "EnumX", "Expronicon", "FunctionWrappersWrappers", "IteratorInterfaceExtensions", "LinearAlgebra", "Logging", "Markdown", "PrecompileTools", "Preferences", "Printf", "RecipesBase", "RecursiveArrayTools", "Reexport", "RuntimeGeneratedFunctions", "SciMLOperators", "SciMLStructures", "StaticArraysCore", "Statistics", "SymbolicIndexingInterface"]
git-tree-sha1 = "7a54136472ca0cb0f66ef22aa3f0ff198f379fa7"
uuid = "0bca4576-84f4-4d90-8ffe-ffa030f20462"
version = "2.58.0"

    [deps.SciMLBase.extensions]
    SciMLBaseChainRulesCoreExt = "ChainRulesCore"
    SciMLBaseMakieExt = "Makie"
    SciMLBasePartialFunctionsExt = "PartialFunctions"
    SciMLBasePyCallExt = "PyCall"
    SciMLBasePythonCallExt = "PythonCall"
    SciMLBaseRCallExt = "RCall"
    SciMLBaseZygoteExt = "Zygote"

    [deps.SciMLBase.weakdeps]
    ChainRules = "082447d4-558c-5d27-93f4-14fc19e9eca2"
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    Makie = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a"
    PartialFunctions = "570af359-4316-4cb7-8c74-252c00c2016b"
    PyCall = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
    PythonCall = "6099a3de-0909-46bc-b1f4-468b9a2dfc0d"
    RCall = "6f49c342-dc21-5d91-9882-a32aef131414"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.SciMLJacobianOperators]]
deps = ["ADTypes", "ArrayInterface", "ConcreteStructs", "ConstructionBase", "DifferentiationInterface", "FastClosures", "LinearAlgebra", "SciMLBase", "SciMLOperators"]
git-tree-sha1 = "f66048bb969e67bd7d1bdd03cd0b81219642bbd0"
uuid = "19f34311-ddf3-4b8b-af20-060888a46c0e"
version = "0.1.1"

[[deps.SciMLOperators]]
deps = ["Accessors", "ArrayInterface", "DocStringExtensions", "LinearAlgebra", "MacroTools"]
git-tree-sha1 = "6149620767866d4b0f0f7028639b6e661b6a1e44"
uuid = "c0aeaf25-5076-4817-a8d5-81caf7dfa961"
version = "0.3.12"
weakdeps = ["SparseArrays", "StaticArraysCore"]

    [deps.SciMLOperators.extensions]
    SciMLOperatorsSparseArraysExt = "SparseArrays"
    SciMLOperatorsStaticArraysCoreExt = "StaticArraysCore"

[[deps.SciMLStructures]]
deps = ["ArrayInterface"]
git-tree-sha1 = "25514a6f200219cd1073e4ff23a6324e4a7efe64"
uuid = "53ae85a6-f571-4167-b2af-e1d143709226"
version = "1.5.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"
version = "1.11.0"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "f305871d2f381d21527c770d4788c06c097c9bc1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.2.0"

[[deps.SimpleNonlinearSolve]]
deps = ["ADTypes", "ArrayInterface", "ConcreteStructs", "DiffEqBase", "DiffResults", "DifferentiationInterface", "FastClosures", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "MaybeInplace", "PrecompileTools", "Reexport", "SciMLBase", "Setfield", "StaticArraysCore"]
git-tree-sha1 = "44021f3efc023be3871195d8ad98b865001a2fa1"
uuid = "727e6d20-b764-4bd8-a329-72de5adea6c7"
version = "1.12.3"

    [deps.SimpleNonlinearSolve.extensions]
    SimpleNonlinearSolveChainRulesCoreExt = "ChainRulesCore"
    SimpleNonlinearSolveReverseDiffExt = "ReverseDiff"
    SimpleNonlinearSolveTrackerExt = "Tracker"
    SimpleNonlinearSolveZygoteExt = "Zygote"

    [deps.SimpleNonlinearSolve.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.SimpleUnPack]]
git-tree-sha1 = "58e6353e72cde29b90a69527e56df1b5c3d8c437"
uuid = "ce78b400-467f-4804-87d8-8f486da07d0a"
version = "1.1.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.11.0"

[[deps.SparseConnectivityTracer]]
deps = ["ADTypes", "DocStringExtensions", "FillArrays", "LinearAlgebra", "Random", "SparseArrays"]
git-tree-sha1 = "6914df6005bab9940e2a96879a97a43e1fb1ce78"
uuid = "9f842d2f-2579-4b1d-911e-f412cf18a3f5"
version = "0.6.8"

    [deps.SparseConnectivityTracer.extensions]
    SparseConnectivityTracerDataInterpolationsExt = "DataInterpolations"
    SparseConnectivityTracerLogExpFunctionsExt = "LogExpFunctions"
    SparseConnectivityTracerNNlibExt = "NNlib"
    SparseConnectivityTracerNaNMathExt = "NaNMath"
    SparseConnectivityTracerSpecialFunctionsExt = "SpecialFunctions"

    [deps.SparseConnectivityTracer.weakdeps]
    DataInterpolations = "82cc6244-b520-54b8-b5a6-8a565e85f1d0"
    LogExpFunctions = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
    NNlib = "872c559c-99b0-510c-b3b7-b6c96a88d5cd"
    NaNMath = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.SparseDiffTools]]
deps = ["ADTypes", "Adapt", "ArrayInterface", "Compat", "DataStructures", "FiniteDiff", "ForwardDiff", "Graphs", "LinearAlgebra", "PackageExtensionCompat", "Random", "Reexport", "SciMLOperators", "Setfield", "SparseArrays", "StaticArrayInterface", "StaticArrays", "UnPack", "VertexSafeGraphs"]
git-tree-sha1 = "b906758c107b049b6b71599b9f928d9b14e5554a"
uuid = "47a9eef4-7e08-11e9-0b38-333d64bd3804"
version = "2.23.0"

    [deps.SparseDiffTools.extensions]
    SparseDiffToolsEnzymeExt = "Enzyme"
    SparseDiffToolsPolyesterExt = "Polyester"
    SparseDiffToolsPolyesterForwardDiffExt = "PolyesterForwardDiff"
    SparseDiffToolsSymbolicsExt = "Symbolics"
    SparseDiffToolsZygoteExt = "Zygote"

    [deps.SparseDiffTools.weakdeps]
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"
    Polyester = "f517fe37-dbe3-4b94-8317-1923a5111588"
    PolyesterForwardDiff = "98d1487c-24ca-40b6-b7ab-df2af84e126b"
    Symbolics = "0c5d862f-8b57-4792-8d23-62f2024744c7"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.SparseMatrixColorings]]
deps = ["ADTypes", "DataStructures", "DocStringExtensions", "LinearAlgebra", "Random", "SparseArrays"]
git-tree-sha1 = "f37f046636f8dc353a39279abfefe296db212171"
uuid = "0a514795-09f3-496d-8182-132a7b665d35"
version = "0.4.8"
weakdeps = ["Colors"]

    [deps.SparseMatrixColorings.extensions]
    SparseMatrixColoringsColorsExt = "Colors"

[[deps.Sparspak]]
deps = ["Libdl", "LinearAlgebra", "Logging", "OffsetArrays", "Printf", "SparseArrays", "Test"]
git-tree-sha1 = "342cf4b449c299d8d1ceaf00b7a49f4fbc7940e7"
uuid = "e56a9233-b9d6-4f03-8d0f-1825330902ac"
version = "0.3.9"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "2f5d4697f21388cbe1ff299430dd169ef97d7e14"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.4.0"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.StableRNGs]]
deps = ["Random"]
git-tree-sha1 = "83e6cce8324d49dfaf9ef059227f91ed4441a8e5"
uuid = "860ef19b-820b-49d6-a774-d7a799459cd3"
version = "1.0.2"

[[deps.Static]]
deps = ["CommonWorldInvalidations", "IfElse", "PrecompileTools"]
git-tree-sha1 = "87d51a3ee9a4b0d2fe054bdd3fc2436258db2603"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "1.1.1"

[[deps.StaticArrayInterface]]
deps = ["ArrayInterface", "Compat", "IfElse", "LinearAlgebra", "PrecompileTools", "Static"]
git-tree-sha1 = "96381d50f1ce85f2663584c8e886a6ca97e60554"
uuid = "0d7ed370-da01-4f52-bd93-41d350b8b718"
version = "1.8.0"
weakdeps = ["OffsetArrays", "StaticArrays"]

    [deps.StaticArrayInterface.extensions]
    StaticArrayInterfaceOffsetArraysExt = "OffsetArrays"
    StaticArrayInterfaceStaticArraysExt = "StaticArrays"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "777657803913ffc7e8cc20f0fd04b634f871af8f"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.8"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "192954ef1208c7019899fbf8049e717f92959682"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.3"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"
weakdeps = ["SparseArrays"]

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "5cf7606d6cef84b543b483848d4ae08ad9832b21"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.3"

[[deps.StatsFuns]]
deps = ["HypergeometricFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "b423576adc27097764a90e163157bcfc9acf0f46"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.3.2"
weakdeps = ["ChainRulesCore", "InverseFunctions"]

    [deps.StatsFuns.extensions]
    StatsFunsChainRulesCoreExt = "ChainRulesCore"
    StatsFunsInverseFunctionsExt = "InverseFunctions"

[[deps.SteadyStateDiffEq]]
deps = ["ConcreteStructs", "DiffEqBase", "DiffEqCallbacks", "LinearAlgebra", "Reexport", "SciMLBase"]
git-tree-sha1 = "920acf6ae36c86f23969fea1d317e040dbfccf53"
uuid = "9672c7b4-1e72-59bd-8a11-6ac3964bc41f"
version = "2.4.1"

[[deps.StochasticDiffEq]]
deps = ["Adapt", "ArrayInterface", "DataStructures", "DiffEqBase", "DiffEqNoiseProcess", "DocStringExtensions", "FastPower", "FiniteDiff", "ForwardDiff", "JumpProcesses", "LevyArea", "LinearAlgebra", "Logging", "MuladdMacro", "NLsolve", "OrdinaryDiffEq", "Random", "RandomNumbers", "RecursiveArrayTools", "Reexport", "SciMLBase", "SciMLOperators", "SparseArrays", "SparseDiffTools", "StaticArrays", "UnPack"]
git-tree-sha1 = "bf4bad73c80e058b1d53788ff520e10c8bad7c9d"
uuid = "789caeaf-c7a9-5a7d-9973-96adeb23e2a0"
version = "6.70.0"

[[deps.StrideArraysCore]]
deps = ["ArrayInterface", "CloseOpenIntervals", "IfElse", "LayoutPointers", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static", "StaticArrayInterface", "ThreadingUtilities"]
git-tree-sha1 = "f35f6ab602df8413a50c4a25ca14de821e8605fb"
uuid = "7792a7ef-975c-4747-a70f-980b88e8d1da"
version = "0.5.7"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.7.0+0"

[[deps.Sundials]]
deps = ["CEnum", "DataStructures", "DiffEqBase", "Libdl", "LinearAlgebra", "Logging", "PrecompileTools", "Reexport", "SciMLBase", "SparseArrays", "Sundials_jll"]
git-tree-sha1 = "e87efb31e5360cb223a151c2398903dc2faeb32b"
uuid = "c3572dad-4567-51f8-b174-8c6c989267f4"
version = "4.26.0"

[[deps.Sundials_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "SuiteSparse_jll", "libblastrampoline_jll"]
git-tree-sha1 = "91db7ed92c66f81435fe880947171f1212936b14"
uuid = "fb77eaff-e24c-56d4-86b1-d163f2edb164"
version = "5.2.3+0"

[[deps.SymbolicIndexingInterface]]
deps = ["Accessors", "ArrayInterface", "RuntimeGeneratedFunctions", "StaticArraysCore"]
git-tree-sha1 = "20cf607cafb31f922bce84d60379203e7a126911"
uuid = "2efcf032-c050-4f8e-a9bb-153293bab1f5"
version = "0.3.34"

[[deps.SymbolicLimits]]
deps = ["SymbolicUtils"]
git-tree-sha1 = "fabf4650afe966a2ba646cabd924c3fd43577fc3"
uuid = "19f23fe9-fdab-4a78-91af-e7b7767979c3"
version = "0.2.2"

[[deps.SymbolicUtils]]
deps = ["AbstractTrees", "ArrayInterface", "Bijections", "ChainRulesCore", "Combinatorics", "ConstructionBase", "DataStructures", "DocStringExtensions", "DynamicPolynomials", "IfElse", "LinearAlgebra", "MultivariatePolynomials", "NaNMath", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArrays", "SymbolicIndexingInterface", "TermInterface", "TimerOutputs", "Unityper"]
git-tree-sha1 = "04e9157537ba51dad58336976f8d04b9ab7122f0"
uuid = "d1185830-fcd6-423d-90d6-eec64667417b"
version = "3.7.2"

    [deps.SymbolicUtils.extensions]
    SymbolicUtilsLabelledArraysExt = "LabelledArrays"
    SymbolicUtilsReverseDiffExt = "ReverseDiff"

    [deps.SymbolicUtils.weakdeps]
    LabelledArrays = "2ee39098-c373-598a-b85f-a56591580800"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"

[[deps.Symbolics]]
deps = ["ADTypes", "ArrayInterface", "Bijections", "CommonWorldInvalidations", "ConstructionBase", "DataStructures", "DiffRules", "Distributions", "DocStringExtensions", "DomainSets", "DynamicPolynomials", "IfElse", "LaTeXStrings", "Latexify", "Libdl", "LinearAlgebra", "LogExpFunctions", "MacroTools", "Markdown", "NaNMath", "PrecompileTools", "Primes", "RecipesBase", "Reexport", "RuntimeGeneratedFunctions", "SciMLBase", "Setfield", "SparseArrays", "SpecialFunctions", "StaticArraysCore", "SymbolicIndexingInterface", "SymbolicLimits", "SymbolicUtils", "TermInterface"]
git-tree-sha1 = "41852067b437d16a3ad4e01705ffc6e22925c42c"
uuid = "0c5d862f-8b57-4792-8d23-62f2024744c7"
version = "6.17.0"

    [deps.Symbolics.extensions]
    SymbolicsForwardDiffExt = "ForwardDiff"
    SymbolicsGroebnerExt = "Groebner"
    SymbolicsLuxExt = "Lux"
    SymbolicsNemoExt = "Nemo"
    SymbolicsPreallocationToolsExt = ["PreallocationTools", "ForwardDiff"]
    SymbolicsSymPyExt = "SymPy"

    [deps.Symbolics.weakdeps]
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    Groebner = "0b43b601-686d-58a3-8a1c-6623616c7cd4"
    Lux = "b2108857-7c20-44ae-9111-449ecde12c47"
    Nemo = "2edaba10-b0f1-5616-af89-8c11ac63239a"
    PreallocationTools = "d236fae5-4411-538c-8e31-a6e3d9e00b46"
    SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "598cd7c1f68d1e205689b1c2fe65a9f85846f297"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.12.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.TermInterface]]
git-tree-sha1 = "d673e0aca9e46a2f63720201f55cc7b3e7169b16"
uuid = "8ea1fca8-c5ef-4a55-8b96-4e9afe9c9a3c"
version = "2.0.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.ThreadingUtilities]]
deps = ["ManualMemory"]
git-tree-sha1 = "eda08f7e9818eb53661b3deb74e3159460dfbc27"
uuid = "8290d209-cae3-49c0-8002-c8c24d57dab5"
version = "0.5.2"

[[deps.TimerOutputs]]
deps = ["ExprTools", "Printf"]
git-tree-sha1 = "3a6f063d690135f5c1ba351412c82bae4d1402bf"
uuid = "a759f4b9-e2f1-59dc-863e-4aeb61b1ea8f"
version = "0.5.25"

[[deps.TranscodingStreams]]
git-tree-sha1 = "0c45878dcfdcfa8480052b6ab162cdd138781742"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.3"

[[deps.TriangularSolve]]
deps = ["CloseOpenIntervals", "IfElse", "LayoutPointers", "LinearAlgebra", "LoopVectorization", "Polyester", "Static", "VectorizationBase"]
git-tree-sha1 = "be986ad9dac14888ba338c2554dcfec6939e1393"
uuid = "d5829a12-d9aa-46ab-831f-fb7c9ab06edf"
version = "0.2.1"

[[deps.TruncatedStacktraces]]
deps = ["InteractiveUtils", "MacroTools", "Preferences"]
git-tree-sha1 = "ea3e54c2bdde39062abf5a9758a23735558705e1"
uuid = "781d530d-4396-4725-bb49-402e4bee1e77"
version = "1.4.0"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "d95fe458f26209c66a187b1114df96fd70839efd"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.21.0"
weakdeps = ["ConstructionBase", "InverseFunctions"]

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "975c354fcd5f7e1ddcc1f1a23e6e091d99e99bc8"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.4"

[[deps.Unityper]]
deps = ["ConstructionBase"]
git-tree-sha1 = "25008b734a03736c41e2a7dc314ecb95bd6bbdb0"
uuid = "a7c27f48-0311-42f6-a7f8-2c11e75eb415"
version = "0.1.6"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.VectorizationBase]]
deps = ["ArrayInterface", "CPUSummary", "HostCPUFeatures", "IfElse", "LayoutPointers", "Libdl", "LinearAlgebra", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "4ab62a49f1d8d9548a1c8d1a75e5f55cf196f64e"
uuid = "3d5dd08c-fd9d-11e8-17fa-ed2836048c2f"
version = "0.21.71"

[[deps.VertexSafeGraphs]]
deps = ["Graphs"]
git-tree-sha1 = "8351f8d73d7e880bfc042a8b6922684ebeafb35c"
uuid = "19fa3120-7c27-5ec5-8db8-b0b0aa330d6f"
version = "0.2.0"

[[deps.Vulkan_Loader_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Xorg_libX11_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "2f0486047a07670caad3a81a075d2e518acc5c59"
uuid = "a44049a8-05dd-5a78-86c9-5fde0876e88c"
version = "1.3.243+0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "7558e29847e99bc3f04d6569e82d0f5c54460703"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+1"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "93f43ab61b16ddfb2fd3bb13b3ce241cafb0e6c9"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.31.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "6a451c6f33a176150f315726eba8b92fbfdb9ae7"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.13.4+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "a54ee957f4c86b526460a720dbc882fa5edcbefc"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.41+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "15e637a697345f6743674f1322beefbc5dcd5cfc"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.6.3+0"

[[deps.Xorg_libICE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "326b4fea307b0b39892b3e85fa451692eda8d46c"
uuid = "f67eecfb-183a-506d-b269-f58e52b52d7c"
version = "1.1.1+0"

[[deps.Xorg_libSM_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libICE_jll"]
git-tree-sha1 = "3796722887072218eabafb494a13c963209754ce"
uuid = "c834827a-8449-5923-a945-d239c165b7dd"
version = "1.2.4+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "d2d1a5c49fae4ba39983f63de6afcbea47194e85"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.6+0"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "47e45cd78224c53109495b3e324df0c37bb61fbe"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.11+0"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "bcd466676fef0878338c61e655629fa7bbc69d8e"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.17.0+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "730eeca102434283c50ccf7d1ecdadf521a765a4"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+0"

[[deps.Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "04341cb870f29dcd5e39055f895c39d016e18ccd"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.4+0"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "330f955bc41bb8f5270a369c473fc4a5a4e4d3cb"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "555d1076590a6cc2fdee2ef1469451f872d8b41b"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.6+1"

[[deps.eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "gperf_jll"]
git-tree-sha1 = "431b678a28ebb559d224c0b6b6d01afce87c51ba"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.9+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "936081b536ae4aa65415d869287d43ef3cb576b2"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.53.0+0"

[[deps.gperf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3516a5630f741c9eecb3720b1ec9d8edc3ecc033"
uuid = "1a1c6b14-54f6-533d-8383-74cd7377aa70"
version = "3.1.1+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1827acba325fdcdf1d2647fc8d5301dd9ba43a9d"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.9.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "e17c115d55c5fbb7e52ebedb427a0dca79d4484e"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.2+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.libdecor_jll]]
deps = ["Artifacts", "Dbus_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pango_jll", "Wayland_jll", "xkbcommon_jll"]
git-tree-sha1 = "9bf7903af251d2050b467f76bdbe57ce541f7f4f"
uuid = "1183f4f0-6f2a-5f1a-908b-139f9cdfea6f"
version = "0.2.2+0"

[[deps.libevdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "141fe65dc3efabb0b1d5ba74e91f6ad26f84cc22"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.11.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a22cf860a7d27e4f3498a0fe0811a7957badb38"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.3+0"

[[deps.libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "ad50e5b90f222cfe78aa3d5183a20a12de1322ce"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.18.0+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "b70c870239dc3d7bc094eb2d6be9b73d27bef280"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.44+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "490376214c4721cdaca654041f635213c6165cb3"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+2"

[[deps.mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "814e154bdb7be91d78b6802843f76b6ece642f11"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.6+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[deps.oneTBB_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7d0ea0f4895ef2f5cb83645fa689e52cb55cf493"
uuid = "1317d2d5-d96f-522e-a858-c73665f53c3e"
version = "2021.12.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9c304562909ab2bab0262639bd4f444d7bc2be37"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+1"
"""

# ╔═╡ Cell order:
# ╟─b6c26648-9b48-4f62-bba9-174171b7414c
# ╟─5d9909c7-e2d6-431a-90eb-16ad64c77254
# ╠═8778b6d8-70e1-4698-9f96-497b4408e4cd
# ╟─878817a2-18b1-456e-baf0-561c548aa796
# ╟─8e87310e-c44e-4092-87cb-73b113b4696d
# ╟─ac3ee554-5ba2-48e9-8fa3-b57f53087ccd
# ╟─d8aa9c53-721a-4651-abe2-535d7f3c2506
# ╟─52833a85-f26d-47c8-a6fe-c6a990f345a4
# ╟─648dc8fd-4ac1-42c7-83e2-caf5f6ac0710
# ╟─477613ea-5cd1-4ddd-b53b-4c600097ece7
# ╟─6b95fe60-b791-4c5e-950f-bca6b0f132ab
# ╠═81953c25-7fdf-4ff4-865f-3c4993e319b1
# ╠═90588eb2-451a-4551-a4c5-14024c879a52
# ╟─8079c6a6-4f5e-4511-9a5b-4015d1c6c681
# ╟─34cfce9b-c8a8-487e-a7a7-68c4c92dcace
# ╟─cdb69c71-3939-48f6-b24e-286a01bfdb83
# ╟─6260c16a-7d99-42cc-b490-499ab9610871
# ╟─cdea1ba2-b6a2-4d9f-b2bf-28bbc2bd3f70
# ╟─3c4d182c-7121-41e5-8573-9b183e1bcb7e
# ╠═1f28b44f-d496-489d-8992-300d7f5f5cb7
# ╠═094240e9-ce59-437d-b94c-594588e22d3a
# ╟─07a1610a-e58e-4ba0-9581-3d921dd920a7
# ╠═909cd9ad-e16e-4038-9b94-bd31624f9572
# ╟─f88fa2eb-8565-4d9b-a1fc-4e79b1e58bf3
# ╟─9de2964f-47ae-4b55-9522-a0b5703006bc
# ╟─0d1c2f64-7c49-4627-b607-dc76bdc15960
# ╟─01d1bde0-2cff-4d67-86bc-20f4ff91e57e
# ╟─2c19049c-6956-449a-8d21-e237ce4674a9
# ╠═42d5edd6-5108-4a79-8909-3df77c721bd4
# ╠═37594ac5-547b-4b5b-a44a-81e35a51b319
# ╠═7ef0b150-22e2-406c-b818-399f9d8079ca
# ╟─e2e6b606-2de4-4793-b8cb-67bb0702953c
# ╟─dd5e86c9-1914-4d55-8fcd-52913d963f55
# ╠═3da8ddcd-70aa-4822-b2d8-524822fd10bf
# ╠═90df1355-3972-4ab3-ad5e-b0c18f2b02dd
# ╠═485e9595-afb0-439e-b778-29a540009fbb
# ╟─068d4943-d64c-4057-997e-06034e406bd2
# ╟─1e9d920d-599f-42da-a187-502960509916
# ╠═f3e15a75-cef2-45f3-b251-9571d77cac77
# ╠═f8aed4a9-3cbf-487d-8240-d3459a88978c
# ╠═03b83c1d-b131-479f-861a-8022bf74ffc7
# ╟─bc014ad3-0083-42d3-b5d1-ea09442e8bba
# ╠═9813a836-78db-4526-9538-fcd6febe1eff
# ╠═38b7fc3f-3b77-48ab-ab00-f3385dc6186f
# ╟─054c38cf-18b1-44b4-a8ce-a8f62a2f36b2
# ╠═7586cd85-3fb3-43ae-ab27-5a06cc2577fe
# ╠═ca0a6986-5baf-463a-b2c4-a0dd7f20feca
# ╠═db7d9459-7cd2-463e-b1b4-63ae05a56244
# ╠═641b1bd5-112d-4144-9639-7171a5e7b91f
# ╟─48fe1bbf-6972-4fb7-bdfe-e419dfa37fd7
# ╟─f91a2d1f-196f-4fae-b04f-ec5be42e04b9
# ╟─6b1a1e1f-5ab3-4031-924a-b19d8903ca9c
# ╠═7bca8a7c-83a0-4746-8cf2-a0f866de5651
# ╠═df81ed4a-c4cf-43f7-af43-3a64d324b0b4
# ╟─de1ec58a-11ae-4e7f-9638-4461776e3879
# ╟─a7dc9a73-31fa-43da-99e2-3f2679e3c81a
# ╟─519130c6-1a51-4d9a-a1f1-594d8d88fb73
# ╟─4a8149d0-b4d2-43d9-bbc0-455f0567a9c8
# ╠═60d99098-f972-446d-a279-3e771f9173ae
# ╠═2e1ad853-84ab-4726-a49f-a5d30a9c8ef4
# ╟─7a2145df-ed6d-42e2-a9ea-18e39776beb3
# ╟─59d78d63-28f5-429a-b3d7-292c39e74a90
# ╟─36303e3b-b101-41fb-a24c-af2ebb58bb83
# ╟─c69e7e4d-521e-4208-9754-f80b746e3ba5
# ╠═92a32bb1-bcf0-41eb-9d3b-e1c92427c5ac
# ╠═7dbdca71-1ed7-408b-a8ea-1faf3621dd16
# ╟─4d742757-996e-4c33-836d-6a0d0c285d61
# ╟─0f0bcca1-8fd0-4dbc-8cd2-4d46f2c821c6
# ╠═8c426a45-4ce1-4282-acb5-c5cd2b801414
# ╟─a4f60993-188f-40e2-88ad-ebf40cb2d737
# ╟─1f48cdd9-50d6-40fd-9789-e5aa25145cfd
# ╟─57c5184a-86d8-4425-a843-13a760dac9c8
# ╠═f5904070-2512-4ae6-8150-c277efd3fb58
# ╠═5344754f-98ce-4726-aa1c-647fd17d2b90
# ╠═6ec4241d-a1cc-4330-9f23-6f34da9265b4
# ╠═7280fa09-0429-4807-8e5c-4b85044e4831
# ╟─e7e80f4b-85d0-4110-92be-d492119a6e28
# ╟─ae396be1-19d0-405a-b543-847f8cae537b
# ╟─59bdef18-be8f-46fa-99bd-a8080eb40f4c
# ╟─4660944d-74bc-4c96-9a9f-83608882a60a
# ╟─c1e65ffc-aa17-4390-8b8c-ccd2c6a69ae4
# ╟─597d3c9e-07c3-47db-8360-1f184d472545
# ╟─a74985d7-8795-4ec4-8a26-5f61cae4722e
# ╟─9206ac6a-a73e-45f8-a8b9-8219606aa502
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002

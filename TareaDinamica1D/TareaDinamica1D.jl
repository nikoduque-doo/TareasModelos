### A Pluto.jl notebook ###
# v0.20.3

using Markdown
using InteractiveUtils

# ╔═╡ d3703fde-b1e9-11ef-3055-cf662349c47f
md"""
# Tarea Dinámica 1D
"""

# ╔═╡ 5ff70b9c-33a9-4673-816b-0bf4cc4fdcbc
md"""
## 1. Estudiar las siguientes EDOs:  
- Dibuje los retratos de fase en la recta real.  
- Encuentre los equilibrios o puntos fijos.  
- Clasifique la estabilidad de los puntos fijos.  
- Realice un bosquejo de la solución para algunas condiciones iniciales.  

"""

# ╔═╡ 3c0221c2-21f0-4fd9-999f-d078d37f5688
md"""
#### 1.1 $x' = 4x^2 - 16$  

"""

# ╔═╡ 26290e71-c19d-4c25-bc42-3e0c711984f1
md"""
Podemos factorizar de tal manera que $x' = 4x^2 - 16 = 4(x + 2)(x - 2)$. Luego, encontramos los puntos fijos o de equilibrio igualando a 0, así:

$$4(x + 2)(x - 2) = 0$$
$$x_1 = -2 \quad \text{o} \quad x_2 = 2$$

"""

# ╔═╡ 3c86def7-d55e-49e8-85e1-4bfab98624dc
md"""
Al observar cómo se comporta nuestra derivada alrededor de los puntos, sabemos que $x_1 = -2$ es un punto estable, mientras que $x_2 = 2$ es inestable.

"""

# ╔═╡ 3bdb3550-cf67-45c3-b0df-aac59d6681fa
md"""
#### 1.2 $x' = 1 + 0.5\cos(x)$  
"""

# ╔═╡ a94cdb28-f2dd-4c76-86e6-714acaece5ed
md"""
Nuevamente igualamos nuestra derivada a $0$, luego:

$\begin{align*}
1 + 0.5 \cos(x) &= 0 \\
\cos(x) &= -2
\end{align*}$

Dado que $-1 \leq \cos(x) \leq 1$, no existen puntos fijos o de equilibrio.

Asimismo, como $1 + 0.5 \cos(x) > 0$ para todo $x \in \mathbb{R}$, concluimos que los valores siempre tenderan hacia infinito:

"""

# ╔═╡ 501b338a-f45b-4f37-8a35-28a5e8db6d5f
md"""
#### 1.3 $x' = 1 - x^{14}$  

"""

# ╔═╡ 66260eb7-1b61-4e07-9606-ab69b7da7d49
md"""
Primero, factorizamos, así obtenemos que $x' = 1 - x^{14} = (1 - x^7)(1 + x^7)$. Ahora, para encontrar nuestros puntos de equilibrio:

$$(1 - x^7)(1 + x^7) = 0$$

De aquí, tenemos que:

$$x_1 = 1 \quad \text{y} \quad x_2 = -1$$

"""

# ╔═╡ ae5353eb-e1b1-489f-8e39-86de52f5ca8c
md"""
Estos son nuestros puntos de equilibrio. Como se puede ver en la gráfica, $x_1 = -1$ es inestable, mientras que $x_2 = 1$ es estable. Ahora vamos a analizar cómo se comporta con problemas de valor inicial:

"""

# ╔═╡ 1d685b37-4996-49e3-8449-295584c67481
md"""
#### 1.4 $x' = 1 - 2\cos(x)$  

"""

# ╔═╡ c4c09933-dc87-46a3-9fe6-fddd0757612b
md"""
En este caso, igualando a 0, tenemos que:

$\begin{align*}
1 - 2 \cos(x) &= 0 \\
\cos(x) &= \frac{1}{2}
\end{align*}$
$x_a = \frac{\pi}{3} + 2k\pi, \quad x_b = -\frac{\pi}{3} + 2k\pi, \quad k \in \mathbb{Z}$

Luego, se presentan infinitos puntos de equilibrio:

"""

# ╔═╡ 1e311318-ad71-4850-95de-e969e2fb8ac4
md"""
Para este caso, los puntos de equilibrio estables serán los de la forma $x_b = -\frac{\pi}{3} + 2k\pi$, y los puntos inestables serán los de la forma $x_a = \frac{\pi}{3} + 2k\pi$.

Para el valor inicial, quedaría de la siguiente manera:

"""

# ╔═╡ d5c6afc5-56af-4ecf-9ef8-feb1cabb09b3
md"""
## 2. Usar el análisis de estabilidad lineal para clasificar los equilibrios de las siguientes EDOs:  

"""

# ╔═╡ f823721d-4082-4043-b3df-b37cac5b031c
md"""
#### 2.1 $x' = x(1 - x)$  

"""

# ╔═╡ 74369ecc-1111-4263-8f3b-7b33cdbdd3f3
md"""
Encontremos los puntos fijos o de equilibrio. 

Usando el siguiente sistema:

$$x(1 - x) = 0$$
De donde obtenemos que:

$$x_1 = 0 \quad \text{o} \quad x_2 = 1$$

Ahora, sea $f(x) = x(1 - x)$. Tomemos su derivada y evaluemos en los puntos de equilibrio para clasificarlos. Con $f'(x) = 1 - 2x$, tenemos entonces:

$$\begin{align*}
f'(0) &= 1 > 0 \\
f'(1) &= 1 - 2 = -1 < 0
\end{align*}$$

De esta manera, concluimos que:

$$\begin{align*}
x = 0 &\quad \text{es inestable linealmente} \\
x = 1 &\quad \text{es estable linealmente}
\end{align*}$$

"""

# ╔═╡ 2b5ba01b-2797-4e83-a246-46045e03e8a0
md"""
#### 2.2 $x' = x^2(6 - x)$  

"""

# ╔═╡ 52ad07ab-3b12-4d53-808d-3016b249d2f6
md"""
Siguiendo los pasos del punto anterior:

$$x^2(6 - x) = 0$$

De donde obtenemos que los puntos de equilibrio son:

$$x_1 = 0 \quad \text{y} \quad x_2 = 6$$

Ahora, sea $f(x) = x^2(6 - x)$. Tomemos su derivada:

$$f'(x) = 2x(6 - x) - x^2$$

Encontremos la estabilidad o inestabilidad de cada punto. Evaluamos $f'(x)$ en los puntos de equilibrio:

$$\begin{align*}
f'(6) &= 12 \cdot 6 - 3 \cdot 36 = -36 < 0  &\text{estable linealmente} \\
f'(0) &= 0  &\text{semiestable linealmente}
\end{align*}$$

Por la derivada no podemos concluir nada, pero notemos que si $0 < x < 6$, entonces $f(x) > 0$, y si $x < 0$, entonces $f(x) > 0$. De esta manera, $x$ *"atrae"* los elementos de la izquierda y *"repela"* los de su derecha.


"""

# ╔═╡ 3ef79edd-cb7d-45a7-baa1-af1491ed4d9e
md"""
#### 2.3 $x' = \ln(x)$  

"""

# ╔═╡ cdf99963-bbf6-4059-b659-fa310a0a4d04
md"""
En este caso, el único punto de equilibrio donde $\ln(x) = 0$ es con $x = 1$.

Luego, si $f(x) = \ln(x)$, entonces $f'(x) = \frac{1}{x}$. De esta manera, $f'(1) = 1 > 0$. Por lo tanto, $x = 1$ es inestable linealmente.
"""

# ╔═╡ 017fb29f-5659-46fc-9e21-9cc0df17b4bf
md"""
## 3. Análisis del modelo de Gompertz:  
Use el análisis de estabilidad lineal para clasificar los equilibrios de la siguiente EDO:  

$N' = -aN*\ln(bN)$
"""

# ╔═╡ 19c694d7-6dcd-4192-a2e0-407f7bac2a6b
md"""
Tomamos para este ejercicio a,b != 0, puesto que si no la ecuacion daria constante 0 para el caso a=0 e indeterminado para b=0.

Encontremos entonces los puntos de equilibrio de la ecuacion diferencial,

-aNln(bN)=0
-aN=0 o ln(bN)=0

Luego como a y b son valores abitrarios, solo queda que
N=0 o N=1/b

Ahora, hagamos uso del analisis de estabilidad lineal y tomemos f(N)=-aN*\ln(bN), luego
b
f'N=.aln(bN)-a

De esta manera f'(1/b)=-adot0-a = -a
lim N->0 f'N => -aln(b\cdot0)-a \rightarrps infty (simbolo muy mayor) 0

Finalmente, obtenemos que N=0 es inestable linealmente y N=1/b es estable linealmente si a>0 e inestable linealmente si a<0
"""

# ╔═╡ 5f9e6ed9-2cc6-4b12-804c-5557112cbf92
md"""

Tomamos para este ejercicio que $a, b \neq 0$, puesto que si no, la ecuación daría constante 0 para el caso $a = 0$ e indeterminada para $b = 0$.

Encontremos entonces los puntos de equilibrio de la ecuación diferencial:

$$-aN \ln(bN) = 0$$

De donde obtenemos:

$$-aN = 0 \quad \text{o} \quad \ln(bN) = 0$$

Luego, como $a$ y $b$ son valores arbitrarios, solo queda que:

$$N = 0 \quad \text{o} \quad N = \frac{1}{b}$$

Ahora, hagamos uso del análisis de estabilidad lineal y tomemos $f(N) = -aN \ln(bN)$. Luego, la derivada de $f(N)$ es:

$$f'(N) = -a \ln(bN) - a$$

De esta manera, evaluamos en los puntos de equilibrio:

$$f'\left(\frac{1}{b}\right) = -a \cdot 0 - a = -a$$

Finalmente, evaluamos el límite cuando $N \to 0$:

$$\lim_{N \to 0} f'(N) = -a \ln(b \cdot 0) - a \quad \Rightarrow \quad \infty \quad \gg \quad 0$$

De esta manera, obtenemos que:

- $N = 0$ es **inestable linealmente**.
- $N = \frac{1}{b}$ es **estable linealmente** si $a > 0$ e **inestable linealmente** si $a < 0$.

"""

# ╔═╡ 33f6167c-04d4-4a39-8854-afc1915c3e17
md"""
## 4. El efecto Allee
Muestre que la siguiente equción es un ejemplo del efecto Allee si r,a,b, satisfacen algunas restricciones a detarminar.
Encuentre todos lospuntos fijos y clasifique su estabilidad. Bosqueje algunas soluciones. Como se compara con el modelo de crecimiento logistico? 

####  4.1 $N'= N* ( r-a(N-b)^2)$
"""

# ╔═╡ ee0e5870-b7c6-4b86-b2f2-2374be182b62
md"""
El **efecto Allee** describe que, en el contexto de poblaciones, existe un umbral poblacional debajo del cual la tasa de crecimiento de la población disminuye. Dicha tasa puede ser negativa, lo que se conoce como efecto Allee fuerte, o puede nunca llegar a ser negativa, lo que se denomina efecto Allee débil. Es también importante aclarar que, al acercarse a la capacidad de carga, la tasa de crecimiento de la población también aumentará [Wikipedia].
"""

# ╔═╡ 8829a967-c12c-4425-90b4-ed84a06519ff
md"""
Dada la EDO

$$N' = N \left( r - a(N - b)^2 \right)$$

con $N$ simbolizando la población, veamos cómo se pueden restringir los parámetros $r$, $a$, $b$ para que la ecuación describa el efecto Allee.
"""

# ╔═╡ 2b242f9d-8b5b-4162-bef5-8fe90ec05fd2
md"""
##### Primero, encontremos los puntos de equilibrio de la ecuación:

$$N(r - a(N - b)^2) = 0$$

Al ser una multiplicacion esto da lugar a los siguientes casos:

1. Si $N = 0$, entonces $N = 0$ es un punto de equilibrio.
2. Si $(r - a(N - b)^2) = 0$, se tiene que:

$$r = a(N - b)^2$$

$$\frac{r}{a} = (N - b)^2 \quad \text{por lo que} \quad \frac{r}{a} \geq 0, \quad a \neq 0$$

De aquí obtenemos:

$$\pm \sqrt{\frac{r}{a}} = N - b$$

lo que nos lleva a:

$$N = b - \sqrt{\frac{r}{a}} \quad \text{y} \quad N = b + \sqrt{\frac{r}{a}}$$

"""

# ╔═╡ 06c47559-ac8c-4b0d-bb72-3aaeb11f9f5b
md"""
##### Segundo, veamos las restricciones que surgen a partir de la formulación del problema:

Considere que, al tratarse de una población, $N \geq 0$. Por lo tanto, se tiene lo siguiente sobre los puntos de equilibrio:

$N = 0$
$N = b - \sqrt{\frac{r}{a}} \geq 0$
$N = b + \sqrt{\frac{r}{a}} \geq 0$

Por lo tanto, se debe cumplir que:

$$b \geq \sqrt{\frac{r}{a}} \geq 0 \quad \text{y} \quad b \geq 0$$
"""

# ╔═╡ cd7a3046-4d14-4ea7-b8af-8bc6d5824301
md"""
###### Cuando $r = 0$:

En este caso, la ecuación

$$N' = N \left( r - a(N - b)^2 \right) = 0$$

será siempre negativa en caso de $a > 0$ y siempre positiva si $a < 0$. Ninguno de estos casos describe el comportamiento de una población según el efecto Allee.

"""

# ╔═╡ 775e6207-b511-4f1a-9367-8927d83ed417
md"""
###### Cuando $r \neq 0$:

Si $r \neq 0$, $N' = N \left( r - a(N - b)^2 \right)$ será positivo cuando $r - a(N - b)^2 > 0$ y negativo cuando $r - a(N - b)^2 < 0$. Veamos cada uno de estos casos:
"""

# ╔═╡ 3d6df443-8fb1-4985-977a-2ac441c4ed55
md"""

 **$N' > 0$:**

Si $N > 0$ y $r - a(N - b)^2 > 0$, existen dos casos:

**Caso 1**. Si $a < 0$ y $r < 0$, se tiene que:

$$r > a(N - b)^2$$
$$\frac{r}{a} < (N - b)^2$$
$$\sqrt{\frac{r}{a}} < N - b \quad \text{o} \quad - \sqrt{\frac{r}{a}} > N - b$$
$$b + \sqrt{\frac{r}{a}} < N \quad \text{o} \quad b - \sqrt{\frac{r}{a}} > N$$

Luego, $b + \sqrt{\frac{r}{a}} < N < b - \sqrt{\frac{r}{a}}$.

**Caso 2**. Si $a > 0$ y $r > 0$:

$$r > a(N - b)^2$$
$$\frac{r}{a} > (N - b)^2$$
$$\sqrt{\frac{r}{a}} > N - b \quad \text{o} \quad - \sqrt{\frac{r}{a}} < N - b$$
$$b + \sqrt{\frac{r}{a}} > N \quad \text{o} \quad b - \sqrt{\frac{r}{a}} < N$$

Luego, $b - \sqrt{\frac{r}{a}} < N < b + \sqrt{\frac{r}{a}}$.

Note que cuando $a < 0$ y $r < 0$, $b + \sqrt{\frac{r}{a}} < b - \sqrt{\frac{r}{a}}$, lo que es una contradicción al ser $\sqrt{\frac{r}{a}} > 0$.

Por lo tanto, tenemos las siguientes condiciones: $r > 0$ , $a > 0$ , $b \geq \sqrt{\frac{r}{a}} > 0$.

Ahora, si $N > 0$ y $r - a(N - b)^2 < 0$, se tiene que:

$$r < a(N - b)^2$$
$$\sqrt{\frac{r}{a}} < N - b \quad \text{o} \quad - \sqrt{\frac{r}{a}} > N - b$$
$$b + \sqrt{\frac{r}{a}} < N \quad \text{o} \quad b - \sqrt{\frac{r}{a}} > N$$

De los cuales, solo $N < b - \sqrt{\frac{r}{a}}$ es posible bajo las condiciones propuestas.
"""


# ╔═╡ 325f5ecd-52ad-48ff-ab09-b918021b6358
md"""
- **$N' < 0$:**

    En este caso, se debe cumplir que $r - a(N - b)^2 < 0$, lo cual sucede cuando:

    $$N < b - \sqrt{\frac{r}{a}} \quad \text{o} \quad N > b + \sqrt{\frac{r}{a}}$$
"""

# ╔═╡ a3eb52da-d2bc-4a56-8c32-1c22d4e96b44
md"""
##### Conclusión:

Mediante el análisis anterior, podemos verificar que la ecuación $N' = N \left( r - a(N - b)^2 \right)$ describirá una población que presenta el efecto Allee siempre y cuando se cumplan las siguientes condiciones:

$r > 0 \quad a > 0 \quad b \geq \sqrt{\frac{r}{a}}$

Además, $N'$ será positiva entre los valores $b - \sqrt{\frac{r}{a}} < N < b + \sqrt{\frac{r}{a}}$ y negativa fuera de este intervalo.
"""

# ╔═╡ 435905d6-fa00-40ea-8686-43be1cbc456b
md"""
Mediante el análisis anterior, se puede verificar que $N' = N(r - a(N - b)^2)$ describirá una población que presente el efecto Allee siempre y cuando $r > 0$, $a > 0$, $b \geq \sqrt{\frac{r}{a}}$.
Además, $N'$ será positiva entre los valores $b - \sqrt{\frac{r}{a}} < N < b + \sqrt{\frac{r}{a}}$ y negativa en el resto de los valores de $N$.
"""


# ╔═╡ 862dae66-915b-4e44-be04-54fe6ac54e98
md"""
#### En ese sentido, existen dos tipos de diagramas de flujo:
"""

# ╔═╡ 5dbc885f-c5ff-45d0-827d-471f9df90729
md"""
##### Tipo 1: $b = \sqrt{\frac{r}{a}}$
"""

# ╔═╡ 09428df7-571a-4612-96db-4df927b0f189
md"""
En este caso, los puntos de equilibrio son:

- Con $N = 0$: inestable
- Con $N = b + \sqrt{\frac{r}{a}}$: estable
"""

# ╔═╡ 705e94de-5439-42f1-877a-348fec6d2503
md"""
##### Tipo 2: $b > \sqrt{\frac{r}{a}}$
"""

# ╔═╡ 6a78a9f0-6e27-4531-83bd-8293dca22f1d
md"""
En este caso, los puntos de equilibrio son:

- Con $N = 0$: semiestable
- Con $N = b - \sqrt{\frac{r}{a}}$: inestable
- Con $N = b + \sqrt{\frac{r}{a}}$: estable

"""

# ╔═╡ 06009e2a-b274-46f9-ab71-03ec1cce8657


# ╔═╡ Cell order:
# ╟─d3703fde-b1e9-11ef-3055-cf662349c47f
# ╟─5ff70b9c-33a9-4673-816b-0bf4cc4fdcbc
# ╟─3c0221c2-21f0-4fd9-999f-d078d37f5688
# ╟─26290e71-c19d-4c25-bc42-3e0c711984f1
# ╟─3c86def7-d55e-49e8-85e1-4bfab98624dc
# ╟─3bdb3550-cf67-45c3-b0df-aac59d6681fa
# ╟─a94cdb28-f2dd-4c76-86e6-714acaece5ed
# ╟─501b338a-f45b-4f37-8a35-28a5e8db6d5f
# ╟─66260eb7-1b61-4e07-9606-ab69b7da7d49
# ╟─ae5353eb-e1b1-489f-8e39-86de52f5ca8c
# ╟─1d685b37-4996-49e3-8449-295584c67481
# ╟─c4c09933-dc87-46a3-9fe6-fddd0757612b
# ╟─1e311318-ad71-4850-95de-e969e2fb8ac4
# ╟─d5c6afc5-56af-4ecf-9ef8-feb1cabb09b3
# ╟─f823721d-4082-4043-b3df-b37cac5b031c
# ╟─74369ecc-1111-4263-8f3b-7b33cdbdd3f3
# ╟─2b5ba01b-2797-4e83-a246-46045e03e8a0
# ╟─52ad07ab-3b12-4d53-808d-3016b249d2f6
# ╟─3ef79edd-cb7d-45a7-baa1-af1491ed4d9e
# ╟─cdf99963-bbf6-4059-b659-fa310a0a4d04
# ╟─017fb29f-5659-46fc-9e21-9cc0df17b4bf
# ╟─19c694d7-6dcd-4192-a2e0-407f7bac2a6b
# ╟─5f9e6ed9-2cc6-4b12-804c-5557112cbf92
# ╟─33f6167c-04d4-4a39-8854-afc1915c3e17
# ╟─ee0e5870-b7c6-4b86-b2f2-2374be182b62
# ╟─8829a967-c12c-4425-90b4-ed84a06519ff
# ╟─2b242f9d-8b5b-4162-bef5-8fe90ec05fd2
# ╟─06c47559-ac8c-4b0d-bb72-3aaeb11f9f5b
# ╟─cd7a3046-4d14-4ea7-b8af-8bc6d5824301
# ╟─775e6207-b511-4f1a-9367-8927d83ed417
# ╟─3d6df443-8fb1-4985-977a-2ac441c4ed55
# ╟─325f5ecd-52ad-48ff-ab09-b918021b6358
# ╟─a3eb52da-d2bc-4a56-8c32-1c22d4e96b44
# ╟─435905d6-fa00-40ea-8686-43be1cbc456b
# ╟─862dae66-915b-4e44-be04-54fe6ac54e98
# ╟─5dbc885f-c5ff-45d0-827d-471f9df90729
# ╟─09428df7-571a-4612-96db-4df927b0f189
# ╟─705e94de-5439-42f1-877a-348fec6d2503
# ╟─6a78a9f0-6e27-4531-83bd-8293dca22f1d
# ╟─06009e2a-b274-46f9-ab71-03ec1cce8657

### A Pluto.jl notebook ###
# v0.20.3

using Markdown
using InteractiveUtils

# ╔═╡ 8778b6d8-70e1-4698-9f96-497b4408e4cd
using Plots, Dates, LinearAlgebra, Optim, DifferentialEquations;

# ╔═╡ f03955a0-a5f3-11ef-1c1b-3ffc12415778
md"""
# Actividad Ajuste de Datos
En esta actividad de ajuste de datos, vamos a analizar la ocupación de las camas UCI en Bogotá durante el inicio de 2022, relacionándola también con el uso por el COVID-19. El objetivo de este trabajo es hacer uso de esa información para explorar y aprender acerca de distintos enfoques para el ajuste de datos. Tomaremos, entonces, diversas funciones con varias variables para el ajuste de los datos.

El ajuste de datos, también llamado ajuste de curvas, hace referencia a, dado un conjunto de datos, buscar alguna correlación entre ellos; es decir, intentar encontrar una relación que describa de manera cercana cómo se comportan los datos en relación entre sí.

Para este tipo de problemas, lo que se hace es usar un algoritmo de optimización y elegir las variables que nos den un mínimo residuo al usar este algoritmo. El algoritmo será implementado por la librería Optim, y nuestra función a minimizar será la de residuo, que en nuestro caso será mínimos cuadrados (con la norma euclidiana o la norma base 2).
"""

# ╔═╡ 1775cf34-9368-4b4a-9827-f430305b3ca6
begin
	df = DateFormat("d/m/y");
	
	Datos = [
		Date("1/01/2022", df) 	222
		Date("2/01/2022", df) 	209
		Date("3/01/2022", df) 	217
		Date("4/01/2022", df) 	245
		Date("5/01/2022", df) 	252
		Date("6/01/2022", df) 	278
		Date("7/01/2022", df) 	291
		Date("8/01/2022", df) 	299
		Date("9/01/2022", df) 	302
		Date("10/01/2022", df) 	292
		Date("11/01/2022", df) 	311
		Date("12/01/2022", df) 	306
		Date("13/01/2022", df) 	326
		Date("14/01/2022", df) 	332
		Date("15/01/2022", df) 	368
		Date("16/01/2022", df) 	356
		Date("17/01/2022", df) 	373
		Date("18/01/2022", df) 	397
		Date("19/01/2022", df) 	410
		Date("20/01/2022", df) 	431
	];

	 fechas = Datos[:,1];
	dias = collect(1:size(fechas, 1));
	camas = Datos[:,2];
	Datos
	# Dates.value(fechas[1])
end

# ╔═╡ f88abf94-d802-4760-9d94-135f3550af16
scatter(fechas,camas,ls=:dash,label="Camas UCI Covid-19",lw=4, xlabel = "Fecha",yaxis="Camas UCI Covid-19", title="Ocupación de Camas UCI")

# ╔═╡ 294d3337-5bc9-4e47-a168-c1f1cc988581
md"""
# Modelos no basados en Ecuaciones Diferenciales
"""

# ╔═╡ 89de066c-2866-4202-9b22-1075ea94066a
md"""
## Modelo Lineal

Empezaremos con el modelo lineal, que asumiremos tiene la siguiente forma: 

$V(t) \approx a + bt$

Y entonces buscamos encontrar los parámetros $a, b \in \mathbb{R}$ tal que minimicen nuestro residuo. Para calcular el residuo, creamos la siguiente función, donde nuestra entrada será *tuplaC*, una tupla que representa nuestro valor inicial para la optimización, *vDatos*, que será el vector de datos de las camas, y *tiempo*, que corresponderá a nuestros días.

"""

# ╔═╡ 4481dd92-82aa-40e8-89b7-762d5f0e1783
function residuoLineal(tuplaC, vDatos, tiempo)
	a,b = tuplaC;
	arrAux = fill(1, size(tiempo));
	vModelo = a * arrAux + b * tiempo;
	res=vDatos-vModelo
	nRes=norm(res)

	return nRes
end

# ╔═╡ 4947173b-fc52-40ad-8dd5-0ede7e2a5d6b
rL(tuplaC) = residuoLineal(tuplaC, camas, dias)

# ╔═╡ 038d95ef-5d51-44d8-a721-cd85d4e34234
oL =Optim.optimize(rL, [3.0, 5.0], LBFGS())

# ╔═╡ be1f5f32-bdfc-46fa-99b6-775206424c6d
oL.minimizer

# ╔═╡ c1b67505-7bf7-4be8-beae-12794fdc2a7e
oL.minimum

# ╔═╡ b3732f0b-26a1-4577-984f-1cd5411104fe
begin
	arrAux = fill(1, size(fechas));
	
	vModeloL = oL.minimizer[1] * arrAux + oL.minimizer[2] * dias;
	plot(fechas, vModeloL, lw=5, label="Modelo lineal óptimo");
	scatter!(fechas, camas, ls=:dash,label="Camas UCI Covid-19",lw=4, xlabel = "Fecha",yaxis="Camas UCI Covid-19", title="Ocupación de Camas UCI")
	
end

# ╔═╡ 2b4b2fe4-ffe2-4ece-acda-73f1e00873ee
md"""

## Modelo Cúbico

Para el modelo cúbico, buscaremos los parámetros $a$, $b$, $c$, $d \in \mathbb{R}$ que ajusten el siguiente modelo:

$V(t) \approx a + bt + ct^2 + dt^3$

A continuación, programamos la función de residuo utilizando la norma euclidiana.


"""

# ╔═╡ bc72517b-bf1c-419f-a303-2b993a0d0eed
function residuoCubico(tuplaC, vDatos, tiempo)
	a,b,c,d = tuplaC;
	arrAux = fill(1, size(tiempo));
	vModelo = a * arrAux + b * tiempo + c * tiempo .^ 2 + d * tiempo .^ 3;
	res=vDatos-vModelo
	nRes=norm(res)

	return nRes
end

# ╔═╡ 6d587ada-59e7-4eba-806a-9af4c4642378
rCub(tuplaC) = residuoCubico(tuplaC, camas, dias)

# ╔═╡ 97d224a5-09f0-4414-89c2-b5400bce79f4
oCub =Optim.optimize(rCub, [0.1, 0.1, 0.1, 0.1], LBFGS())

# ╔═╡ 1f4e3c04-7515-4203-9414-a8860243cf2f
oCub.minimizer

# ╔═╡ 537bfbd9-8fe4-41e7-9a69-9fd523ad6cf1
oCub.minimum

# ╔═╡ a3359ad2-b267-43c9-a685-50b20cce0621
begin
	# arrAux2 = fill(1, size(fechas));
	vModeloCub = oCub.minimizer[1] * arrAux + oCub.minimizer[2] * dias + oCub.minimizer[3] * dias .^ 2 + oCub.minimizer[4] * dias .^ 3;
	plot(fechas, vModeloCub, lw=5, label="Modelo lineal óptimo");
	scatter!(fechas, camas, ls=:dash,label="Camas UCI Covid-19",lw=4, xlabel = "Fecha",yaxis="Camas UCI Covid-19", title="Ocupación de Camas UCI")
	
end

# ╔═╡ 7dfb1224-530c-4c51-bc28-196c000e907a
md"""
## Modelo de redes neuronales artificiales

Empezaremos con el modelo lineal, que asumiremos tiene la siguiente forma: 

$V(t) \approx a + bt + ct^2 + dt^3$

Y entonces buscamos encontrar los parámetros $a, b \in \mathbb{R}$ tal que minimicen nuestro residuo. Para calcular el residuo, creamos la siguiente función, donde nuestra entrada será *tuplaC*, una tupla que representa nuestro valor inicial para la optimización, *vDatos*, que será el vector de datos de las camas, y *tiempo*, que corresponderá a nuestros días.

"""

# ╔═╡ d3001ce5-5d33-45b1-ab73-90c340d80fb3
function residuoRedesNeuronalesArtificiales(tuplaC, vDatos, tiempo)
	a,b = tuplaC;
	arrAux = fill(1, size(tiempo));
	vModelo = a * arrAux + b * tiempo;
	res=vDatos-vModelo
	nRes=norm(res)

	return nRes
end

# ╔═╡ 3d9ec925-1f43-4dbb-a471-e1fe86b3eb70
md"""
## Otros modelados

Con el fin de analizar modelos no polinómicos y ver la aproximación que tendrá, tomaremos los siguientes modelos no lineales: 

$V(t) \approx A\frac{1}{x}+B$

#

, que asumiremos tiene la siguiente forma: 

$V(t) \approx a + bt$

Y entonces buscamos encontrar los parámetros $a, b \in \mathbb{R}$ tal que minimicen nuestro residuo. Para calcular el residuo, creamos la siguiente función, donde nuestra entrada será *tuplaC*, una tupla que representa nuestro valor inicial para la optimización, *vDatos*, que será el vector de datos de las camas, y *tiempo*, que corresponderá a nuestros días.

"""

# ╔═╡ 2319d25e-e453-402e-87da-d31084cd274c


# ╔═╡ 44d043ce-c2e8-4ba2-8278-e4ab571ee244
md"""
# Modelos basados en Ecuaciones Diferenciales
"""

# ╔═╡ d4703198-4f45-49b7-ab5a-06ec61da41fc
md"""
$$V' = aV\left(1 - \frac{V}{b}\right),$$
"""

# ╔═╡ 5f86fda8-72f1-4f1b-877b-b9cd207cfd7b
modeloCL(vDatos, tupla, tiempo) = tupla[1] * vDatos * (1 - (vDatos / tupla[2]))

# ╔═╡ a4fa1201-9189-45b2-be4b-fa92a76c8930
function residuoCL(tupla,vDatos,tiempo)
   	dominioTiempo = (0,30);
  	V0 = 222;
 	EDO = ODEProblem(modeloCL, V0, dominioTiempo, tupla);
  	Sol = solve(EDO);
  	vModelo = [Sol(t) for t in tiempo];
  	res = vDatos - vModelo;
  	nRes = norm(res);
	return nRes;
end

# ╔═╡ b50cf6c5-07bb-4a9a-8c33-28b37d5ced42
residuoCL([1 1],camas,dias)

# ╔═╡ d802b272-cbf4-41e6-ab4e-ae786246c86c
rCL(tupla) = residuoCL(tupla, camas, dias)

# ╔═╡ 26432f87-c19e-4110-94a1-54d153b8bf7e
# ╠═╡ show_logs = false
oCL = Optim.optimize(rCL, [.01,.01], NelderMead())

# ╔═╡ ee04760f-e861-4f52-87ea-09b9155199fd
oCL.minimizer

# ╔═╡ 61f70619-ecef-4d5a-9135-45bcad412e01
begin
	dominioTiempo=(Dates.value(Date("31/12/2021", df)), Dates.value(Date("30/01/2022", df)))
	V0=222
	oCLtupla=oCL.minimizer
	EDOoptima=ODEProblem(modeloCL,V0,dominioTiempo,oCLtupla)
	VEDOoptima=solve(EDOoptima)
	plot(VEDOoptima,lw=5,label="EDO optima")
	scatter!(fechas,camas,ls=:dash,label="Camas UCI Covid-19",lw=4, xlabel = "Fecha",yaxis="Camas UCI Covid-19",legend=:bottomright, title="Ecuación diferencial ordinaria óptima")
end

# ╔═╡ Cell order:
# ╠═8778b6d8-70e1-4698-9f96-497b4408e4cd
# ╠═f03955a0-a5f3-11ef-1c1b-3ffc12415778
# ╠═1775cf34-9368-4b4a-9827-f430305b3ca6
# ╠═f88abf94-d802-4760-9d94-135f3550af16
# ╠═294d3337-5bc9-4e47-a168-c1f1cc988581
# ╠═89de066c-2866-4202-9b22-1075ea94066a
# ╠═4481dd92-82aa-40e8-89b7-762d5f0e1783
# ╠═4947173b-fc52-40ad-8dd5-0ede7e2a5d6b
# ╠═038d95ef-5d51-44d8-a721-cd85d4e34234
# ╠═be1f5f32-bdfc-46fa-99b6-775206424c6d
# ╠═c1b67505-7bf7-4be8-beae-12794fdc2a7e
# ╠═b3732f0b-26a1-4577-984f-1cd5411104fe
# ╟─2b4b2fe4-ffe2-4ece-acda-73f1e00873ee
# ╠═bc72517b-bf1c-419f-a303-2b993a0d0eed
# ╠═6d587ada-59e7-4eba-806a-9af4c4642378
# ╠═97d224a5-09f0-4414-89c2-b5400bce79f4
# ╠═1f4e3c04-7515-4203-9414-a8860243cf2f
# ╠═537bfbd9-8fe4-41e7-9a69-9fd523ad6cf1
# ╠═a3359ad2-b267-43c9-a685-50b20cce0621
# ╠═7dfb1224-530c-4c51-bc28-196c000e907a
# ╠═d3001ce5-5d33-45b1-ab73-90c340d80fb3
# ╠═3d9ec925-1f43-4dbb-a471-e1fe86b3eb70
# ╠═2319d25e-e453-402e-87da-d31084cd274c
# ╠═44d043ce-c2e8-4ba2-8278-e4ab571ee244
# ╠═d4703198-4f45-49b7-ab5a-06ec61da41fc
# ╠═5f86fda8-72f1-4f1b-877b-b9cd207cfd7b
# ╠═a4fa1201-9189-45b2-be4b-fa92a76c8930
# ╠═b50cf6c5-07bb-4a9a-8c33-28b37d5ced42
# ╠═d802b272-cbf4-41e6-ab4e-ae786246c86c
# ╠═26432f87-c19e-4110-94a1-54d153b8bf7e
# ╠═ee04760f-e861-4f52-87ea-09b9155199fd
# ╠═61f70619-ecef-4d5a-9135-45bcad412e01

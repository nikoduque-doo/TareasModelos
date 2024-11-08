### A Pluto.jl notebook ###
# v0.20.3

using Markdown
using InteractiveUtils

# ╔═╡ 77d8253e-1529-49d3-b6f8-cacc2553ddbc
using PlutoUI

# ╔═╡ ccfd2289-ca8d-4933-ada7-0130aa6cfbd5
md"""
# Modelo de Desperdicio de Grafito en Lápices

por Alan David Acero Cortes, Johan Andres Lopez Botero y Nicolas Duque Molina
"""

# ╔═╡ ba2b156b-5d84-4c17-a71b-00b8883f9671
md"""
## Problema
Para un lápiz de madera con núcleo de grafito, afilado con un sacapuntas tradicional, ¿cuál es el porcentaje de grafito que se desperdicia? Construya un modelo que permita estimar este porcentaje por cada lapíz.

![Punta de Lápiz](https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Pencil_01_kamranki.jpg/1920px-Pencil_01_kamranki.jpg)

"""

# ╔═╡ b26bf0b8-c556-4b7e-aff6-6ce01e9b1b4b
md"""
## Contexto del Problema
### Breve Historia del Lápiz
El lápiz de grafito apareció por primera vez alrededor de 1564, luego del descubrimiento de un yacimiento de grafito cerca de Borrowdale, Cumbria, en Inglaterra. Este yacimiento de gran tamaño, y pureza (que no se ha encontrado en otro yacimiento a nivel mundial) pronto adquirió gran valor, en un principio fue usado para marcar ovejas, pero al poder ser usado para revestir bolas de cañón, la corona británica tomó control de las minas. Por su utilidad para marcar, artistas del todo el mundo conocido fueron atraídos por sus propiedades, además por ser blando se usaba envuelto en cordeles o en cuero de oveja. En los depósitos de grafito que han sido encontrados en otras partes del mundo, no poseían la pureza del de Borrowdale, entonces tenía que ser purificado para limpiar impurezas. \

La idea de los lápices de madera fue dada por una pareja italiana, Simonio y Lyndiana Bernacotti, su principal idea (que de hecho es como yo pensaba que se hacían) es perforando la madera e insertando la mina, posteriormente pensaron en cortar 2 pedazos de madera en forma de semicírculo, dejando así el espacio para la mina, y después pegarlos con presión, este es el método vigente hoy en dia. \

Mientras las guerras napoleónicas, los lápices ingleses y alemanes no estaban al alcance de los franceses, así el interés por estos por parte de un oficial, Nicolas-Jacques Conté, lo llevó a inventar un método para endurecer las minas, mezclando el grafito con arcilla y agua, y cocinando, pese a que había sido descubierto 5 años antes por el austriaco Josef Hardtmuth fundador de Koh-I-Noor (empresa que lo patentó en alemania), por la necesidad en la guerra se le dio mucho más importancia a Nicolás Corté. \

Cuando llegaron a estados unidos, después de la guerra de independencia, se empezó a hacer en gran escala, y Ebenezer Wood, al notar que el proceso era tan lento se propuso a automatizar el proceso, dentro de eso fue el primero en construirlas con formas octogonales y hexagonales. \

A finales del siglo XIX, se utilizaban más de 240.000 lápices al día en Estados Unidos, cuya madera más usada era la del cedro rojo, la cual es aromática. Cuando empezaron a escasear los recursos, se empezó a usar cedro de incienso, el cual después de pintar y perfumar se parecía lo suficiente al cedro rojo. Esta es la madera que se usa más para hoy en día. \

El accesorio del borrador fue añadido el 30 de marzo de 1858, cuando Hymen Lipman recibió la primera patente para colocar una goma de borrar en el extremo de un lápiz. A su vez otro artículo muy usado son los extensores de lápiz, tanto entre ingenieros como artistas, para sacar el mayor provecho de estos artilugios. \

### Composición del Lápiz

La mina del lápiz actual comprende una mezcla entre grafito y arcilla, junto con agua. Fue descubierto que diversas proporciones entre estos materiales cambian si la mina será muy dura o muy suave, lo cual influye tanto en la oscuridad de las marcas, como en la facilidad de su uso. Un mayor contenido de arcilla da como resultado una mina de lápiz más dura, ideal para trazos precisos y limpios sin la preocupación de que se rompa con frecuencia. \

Los lápices, por tanto, tienen un espectro en su nivel de dureza. para eso hay una clasificación, la cual corresponde a las letras que aparecen por el borde del lápiz.
'H' representa las minas duras, 'B' representa las minas negras o suaves, El término medio es 'HB', equilibrando dureza y negrura. en lo que aumenta el número del 'H', corresponde a mayor suavidad de trazo, lease '2H' es más oscuro que '8H', por su parte con las 'B' es alrevez, el '2B' es más claro que '8B'. \

Ahora, un lapiz para ser lápiz necesita de la madera, la madera que se consigue para la fabricación es en forma de paneles precortados; posteriormente, cada panel se talla con una sierra eléctrica, formando canales delgados para la mina de grafito; a esto le sigue distribuir los paneles para hacer un “sandwich” con la madera, se dividen con tal que uno acunara la mina del lapiz, en lo que el otro panel lo tapara, completando la icónica forma de lápiz; entonces en camino a ser prensados, se añade un pegamento especializado, y a esto le sigue apilar la madera y la mina; al esto haberse hecho, se coloca todo junto, prensando los paneles con maquinaria de alta presión que puede ejercer fuerza de hasta 1 000 kg. Ya habiendo sido prensados, se cortan de manera individual y se añaden detalles, tal como la goma de borrar, logotipos, información del lápiz, entre otros. así los lápices están listos para ser enviados y distribuidos a lo largo del mundo. 


"""

# ╔═╡ 52ce0f6a-b558-45d7-b617-e8b007d8f335
md"""
## Desarrollo y ajuste del modelo
Para modelar correctamente la cantidad de grafito desperdiciado  es esencial primero establecer cuáles son estas partes relevantes para este caso específico. Mediante la observación del proceso de tajado, se puede apreciar que éste se compone de desprender finas capas de tanto el recubrimiento de madera como la mina para lograr una punta cuya forma se asemeja a un cilindro. Solo ocurre desperdicio de grafito cuando se retiran capas de la mina, indendientemente del volumen del recubrimiento. Por lo tanto, es adecuado sugerir que un modelo que aproxime el grafito perdido en este proceso debe centrarse en la aproximación de la mina únicamente. Para simplificar el uso del lenguaje se llamará mina al cilindro completo de grafito de un lápiz y la punta solo incluirá su sección compuesta de este mismo material\

### Primer acercamiento
Se puede notar que al asemejarse la mina y la punta de un lápiz a las figuras geométricas del cilindro y el cono respectivamente, se puede aproximar igualmente sus volúmenes a través de éstas. Por ende, se tiene que:

```math
V_{mina} = \pi r^{2} l
```

```math
V_{punta} = \frac{1}{3} \pi r^{2} h_{punta}
```

donde $l$ corresponde a la longitud de la mina y $h_{punta}$ es la altura de la punta. En un principio se podrían tomar $r$ como un valor variable y $h_{punta}$ como un valor constante en cada lápiz. \

Supongamos que el lápiz es tajado úncamente cuando la punta se reduce por completo, es decir cuando es completamente plana. Entonces es posible modelar el desperdicio de una sección de mina de longitud $h_{punta}$ por cada tajada como:

```math
d(r) = V_{seccionMina} - V_{punta} = (\pi r^{2} h_{punta}) - (\frac{1}{3} \pi r^{2} h_{punta})
```
```math
d(r) = \frac{2}{3} \pi r^{2} h_{punta}
```

Ahora únicamente basta con conocer cuántas veces es tajado un lápiz. Suponiendo que el lápiz no está tajado inicialmente y que el lápiz se tajará hasta consumir por completo la longitud de la mina, se tiene la siguiente expresión:

```math
l = n_{tajadas} \cdot h_{punta}
```
luego

```math
n_{tajadas} = \frac{l}{h_{punta}}
```
Por lo tanto la cantidad total de grafito perdido será por lápiz será:

```math
D(r) = d(r) \cdot n_{tajadas} = \frac{2}{3} \pi r^{2} h_{punta} \cdot \frac{l}{h_{punta}}
```

```math
D(r) = \frac{2}{3} \pi r^{2} l
```

Lo cual se puede expresar como un porcentaje del grafito total contenido en el lápiz:

```math
P_{desperdiciado} = \frac{D(r)}{V_{mina}} = \frac{\frac{2}{3} \pi r^{2} l}{\pi r^{2} l}
```

```math
P_{desperdiciado} = \frac{2}{3}
```

Según este modelo, $\frac{2}{3}$ del grafito contenido en un lápiz es desperdiciado al tajar el lápiz.
"""

# ╔═╡ ff6bc677-08b0-4562-a8ee-59ba8267a265
md"""
### Refinamiento Condición de Tajado
La observación del uso de un lápiz revela que asumir que el lápiz se tajará una vez la punta sea perfectamente plana no refleja la realidad. En efecto, la punta presenta cierta curvatura en el momento en que ya no se considera afilada. Es claro que este caso no se presenta en la primera tajada, es decir cuando el lápiz incia no teniendo ningún tipo de punta, y que esta situación puede utilizar el modelo anterior. \
El segundo caso, cuando se taja la punta partiendo desde una punta no afilada, se puede modelar añadiendo un casco esférico al cilindro de la mina. La punta sería entonces obtenida a partir de este nuevo sólido:

```math
d(r) = V_{solido} - V_{punta}
```

```math
d(r) = (V_{CE} + V_{seccionMina}) - V_{punta}
```

Note además que la altura de este nuevo sólido será igual a la altura de la punta:

```math
h_{punta} = h_{CE} + h_{seccionMina}
```



"""

# ╔═╡ 633f1898-7425-4e2e-a496-d2cd0974d777
Resource(
	"https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Spherical_Cap.svg/1024px-Spherical_Cap.svg.png",
	:alt => "Casco Esférico",
	:align => "center"
)

# ╔═╡ bb6db87e-b99c-4940-8a9b-cdf034d4c7d4
md"""
Para este modelo asumiremos que el radio de la esfera a la que pertenece este casco esférico es $2r$ y que el radio propio del casco $a = r$, con $r$ siendo el radio de la mina del lápiz. Mediante el teorema de Pitágoras, se puede encontrar una expresión para la altura de este sólido:

```math
h_{CE} = 2r - \sqrt{(2r)^2 - r^2} = 2r - r \sqrt{3}
```

```math
h_{CE} = r(2 -  \sqrt{3})
```

Ésto nos permite encontrar el área del casco en términos del radio de la esfera y su altura:

```math
V_{CE} = \frac{\pi h_{CE}^2}{3} \cdot (3r_{esfera} - h_{CE}) = \frac{\pi (r(2 -  \sqrt{3}))^2}{3} \cdot (3(2r) - r(2 -  \sqrt{3}))
```
```math
V_{CE} = \frac{\pi r^3}{3} \cdot (16-9\sqrt{3})
```

Teniendo el resultado de $h_{CE}$ en cuenta, también se tiene la siguiente expresión para la altura de la sección cilíndrica de la mina no afilada:

```math
h_{seccionMina} = h_{punta} - h_{CE} = h_{punta} - r(2 -  \sqrt{3})
```

"""

# ╔═╡ 65a5988d-655d-454a-ad83-ad7ca5d32fc7
md"""
### Refinamiento del Modelo de Punta
Mediante la observación de un tajalápiz se puede apreciar que no todos los modelos comparten el mismo ángulo de apertura. Este ángulo tiene influencia directa sobre las hipótesis planteadas en el primer modelo, ya que influencia la altura de la punta y a su vez, el volumen de la misma. Un corte vertical del modelo de punta puede interpretarse como un triángulo isóceles:
"""

# ╔═╡ 96e94224-88ce-49c0-a78f-89849b89dd8b
Resource(
	"https://www.inchcalculator.com/wp-content/uploads/2022/12/isosceles-triangle.png",
	:alt => "Triángulo Isóceles",
	:align => "center"
)

# ╔═╡ fbc618b5-ee02-4f3d-bb5f-0bf9f9e62f6c
md"""
donde $\beta$ corresponde al ángulo de apertura del tajalápiz, $b$ al diámetro de la mina $2r$ y $h$ a $h_{punta}$. Por lo tanto, se puede expresar $h_{punta}$ en términos de $r$ y $\beta$:

```math
cot(\frac{\beta}{2}) = \frac{h_{punta}}{r}
```

```math
h_{punta} = r \cdot cot(\frac{\beta}{2})
```

Por lo tanto, se puede expresar el volumen de la punta como:

```math
V_{punta} = \frac{\pi r^{2}}{3} (r \cdot cot(\frac{\beta}{2}))
```

```math
V_{punta} = \frac{\pi r^{3}}{3} cot(\frac{\beta}{2})
```

"""

# ╔═╡ 57c79804-331f-4a41-8e60-5c722f4305d1
md"""
### Volumen de la Sección Cilíndrica de la Punta sin Afilar
Los anteriores resultados nos permiten establecer una expresión para la altura de la sección cilíndrica:

```math
h_{seccionMina} = h_{punta} - r(2 -  \sqrt{3}) = r \cdot cot(\frac{\beta}{2}) - r(2 -  \sqrt{3})
```

```math
h_{seccionMina} = r( cot(\frac{\beta}{2}) - 2 + \sqrt{3})
```

Este resultado nos permite hallar el volumen de dicha sección:

```math
V_{seccionMina} = \pi r^{2} h_{seccionMina}
```

```math
V_{seccionMina} = \pi r^{3} ( cot(\frac{\beta}{2}) - 2 + \sqrt{3})
```

"""

# ╔═╡ 6a3ddd3e-f46c-4627-bfe8-7a760da0c43c
md"""
## Modelo Refinado Propuesto

Los resultados anteriores permiten expresar el desperdicio por tajada teniendo en cuenta la condición de tajado refinada:

```math
d(r, \beta) = (V_{CE} + V_{seccionMina}) - V_{punta}
```

```math
d(r, \beta) = ((\frac{\pi r^3}{3} \cdot (16-9\sqrt{3})) + (\pi r^{3} ( cot(\frac{\beta}{2}) - 2 + \sqrt{3}))) - (\frac{\pi r^{3}}{3} cot(\frac{\beta}{2}))
```

```math
d(r, \beta) = \pi r^3 (\frac{10}{3} - 2\sqrt{3} + \frac{2}{3} cot(\frac{\beta}{2}))
```

"""

# ╔═╡ ca691fa2-428c-41b9-98a3-912c68d2fab6
md"""
## Implementación del modelo
"""

# ╔═╡ 794ca260-eeed-4a53-9fed-7f004d99690b
md"""
## Estimaciones globales
"""

# ╔═╡ 27bab588-20c7-4bcc-bc90-f543230e9114
md"""
## Impacto del desperdicio de grafito
"""

# ╔═╡ ab8da165-e7da-4980-b7c9-38bf33e05bbb
md"""
## Propuestas de solución
"""

# ╔═╡ 4a60bb43-1e11-4a77-85be-bc57bb03744f
md"""
## Referencias y metodología de búsqueda
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.60"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.1"
manifest_format = "2.0"
project_hash = "8aa109ae420d50afa1101b40d1430cf3ec96e03e"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

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

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"

    [deps.Pkg.extensions]
    REPLExt = "REPL"

    [deps.Pkg.weakdeps]
    REPL = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eba4810d5e6a01f612b948c9fa94f905b49087b0"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.60"

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

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

    [deps.Statistics.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.Tricks]]
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╠═77d8253e-1529-49d3-b6f8-cacc2553ddbc
# ╟─ccfd2289-ca8d-4933-ada7-0130aa6cfbd5
# ╟─ba2b156b-5d84-4c17-a71b-00b8883f9671
# ╟─b26bf0b8-c556-4b7e-aff6-6ce01e9b1b4b
# ╟─52ce0f6a-b558-45d7-b617-e8b007d8f335
# ╟─ff6bc677-08b0-4562-a8ee-59ba8267a265
# ╠═633f1898-7425-4e2e-a496-d2cd0974d777
# ╠═bb6db87e-b99c-4940-8a9b-cdf034d4c7d4
# ╟─65a5988d-655d-454a-ad83-ad7ca5d32fc7
# ╟─96e94224-88ce-49c0-a78f-89849b89dd8b
# ╠═fbc618b5-ee02-4f3d-bb5f-0bf9f9e62f6c
# ╠═57c79804-331f-4a41-8e60-5c722f4305d1
# ╠═6a3ddd3e-f46c-4627-bfe8-7a760da0c43c
# ╠═ca691fa2-428c-41b9-98a3-912c68d2fab6
# ╠═794ca260-eeed-4a53-9fed-7f004d99690b
# ╠═27bab588-20c7-4bcc-bc90-f543230e9114
# ╠═ab8da165-e7da-4980-b7c9-38bf33e05bbb
# ╠═4a60bb43-1e11-4a77-85be-bc57bb03744f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002

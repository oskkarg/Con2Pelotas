

--========================================================================================================================================

--    ██████╗ ██████╗  ███╗   ██╗    ██████╗     ██████╗ ███████╗██╗      ██████╗ ████████╗ █████╗ ███████╗
--    ██╔════╝██╔═══██╗████╗  ██║    ╚════██╗    ██╔══██╗██╔════╝██║     ██╔═══██╗╚══██╔══╝██╔══██╗██╔════╝
--    ██║     ██║   ██║██╔██╗ ██║     █████╔╝    ██████╔╝█████╗  ██║     ██║   ██║   ██║   ███████║███████╗
--    ██║     ██║   ██║██║╚██╗██║    ██╔═══╝     ██╔═══╝ ██╔══╝  ██║     ██║   ██║   ██║   ██╔══██║╚════██║
--   ╚██████╗╚██████╔╝ ██║ ╚████║    ███████╗    ██║     ███████╗███████╗╚██████╔╝   ██║   ██║  ██║███████║
 --   ╚═════╝ ╚═════╝ ╚═╝   ╚═══╝    ╚══════╝    ╚═╝     ╚══════╝╚══════╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚══════╝
--                                 EJEMPLO 3 ---   PLANETAS        -----                     
--========================================================================================================================================
 require 'libreriasOscar/librerias'

local id_texto00
local id_texto01
local id_texto02
local id_texto03
local id_texto04
local NUMERO_PLANETAS = 0
-- Definir la tabla animacion01 manualmente
animacion01 = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 
	11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 
	21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 
	31, 32, 33, 34, 35, 36, 37, 38, 39, 40
} 



local PUNTUACION = 0
local text_size = 12
local accion_m_realizada = false

function love.load()
	local iconData = love.image.newImageData("images/icono.png")
	love.window.setIcon(iconData)
	set_titulo("😁😁  Con2pelotas : Planetas  😁😁")
	set_mode(320,200,4)


	fuente = carga_fuente("fuentes/regular.ttf",text_size )
	set_fps(60)
	fichero[1] = carga_fpg("graficos/pelotas00")
	texto_Juego()
	crea(Fondo,{z=1})
	crea(Planetas, {z =2})
	collectgarbage("setstepmul", 500)   -- Hace que limpie más agresivamente

end
texto_Juego = function()
	set_texto_size(24)
	set_color(1, 1, 0, 1)
	id_texto01 = escribe_texto("Pulsa barra espaciadora para crear planetas:", 10, 20)
	id_texto02 = escribe_texto("Planetas :"..NUMERO_PLANETAS, 10, 40)

end
--========================================================================================================================================
--========================================================================================================================================

function Planetas(p)
	-- Verifica si el gráfico aún no ha sido cargado
	if p.nombre == nil then   -------------- SIEMPRE LO iniciamos asi ,nunca con grafico,sino lo recargas continuamente !!!!!
		-- Asigna valores iniciales al objeto p
		p.nombre = "planetas"
		p.grafico = 1
		p.hoja = 1
		p.z = 3
		-- p.z = math.random(10, 100)
		p.velocidad_x = 0
		p.velocidad_y = 0
		p.velocidad_y_inicial = 0
		p.paso = 0

	end

	-- Factor de resolución para controlar la velocidad del movimiento
	local resolucion = 0.4 -- Puedes ajustar este valor para controlar la velocidad

	-- Si es el primer paso del proceso
	if p.paso == 0 then


		local id_proceso = GET_ID(p.id)
		if id_proceso then       -- ATENCION SIEMPRE QUE INTENTEMOS CAMBIAR MIRAMOS SI EXISTE SINO PUEDE PETARRRRR
		CAMBIA_Z(id_proceso, 4)
        end


		p.z = 2

		p.x = 0
		p.y = 180
		p.velocidad_x = rand(5, 10)  -- Reducido el rango para velocidades horizontales
		p.velocidad_y_inicial = rand(-20, -29)  -- Reducido el rango para velocidades verticales iniciales
		p.velocidad_y = p.velocidad_y_inicial
		p.paso = 1

	end
	-- p.z = 100

	if p.paso == 1 then
		-- p.z = 0
	end


	-- Mueve el proceso horizontalmente con una velocidad ajustada por la resolución
	p.x = p.x + p.velocidad_x * resolucion

	-- Revierte la dirección horizontal si se alcanzan los límites de la pantalla
	if (p.x < 0 or p.x > 320) then
		p.velocidad_x = -p.velocidad_x
	end

	-- Mueve el proceso verticalmente con una velocidad ajustada por la resolución
	p.y = p.y + p.velocidad_y * resolucion

	-- Controla el cambio de la longitud del proceso verticalmente
	if -p.velocidad_y <= p.velocidad_y_inicial then 
		-- Reinicia la longitud vertical a la inicial si se alcanza el límite negativo
		p.velocidad_y = -p.velocidad_y
	else
		-- Incrementa la longitud vertical con un valor constante
		p.velocidad_y = p.velocidad_y + 1
	end

	anima_Grafico(p, animacion01, 0.2)  -- Usa animacion02
end
--========================================================================================================================================
--========================================================================================================================================

function Fondo(p)
	if p.nombre == nil then
		p.nombre = "fondo"
		p.hoja = 1
		p.grafico = 41
		p.cosa = 22

		local id_proceso = GET_ID(p.id)
		CAMBIA_Z(id_proceso,1)

	end



	p.x =320 / 2
	p.y =200 /2

	if key("t") then   --efecto terminator MATO TODO +30000 procesos en un plis plas...XD
		local id_proceso = GET_ID(p.id)
		if id_proceso then    
        TERMINATOR(id_proceso)
		NUMERO_PLANETAS = 0
		end

	end


end
--========================================================================================================================================
--========================================================================================================================================
function bucle_Infinito()
	-- Cuando presionas la barra espaciadora, creas planetas
	if key("space") then
		for i = 0, 100 do 
			crea(Planetas,{z=2})
			NUMERO_PLANETAS = NUMERO_PLANETAS + 1
			actualiza_Texto(id_texto02, "Planetas :" .. NUMERO_PLANETAS, 10, 40)
		end
	end

	-- Cuando presionas la tecla 'm', matas a todos los planetas pero es lento...
	if key("m") then

		-- Verificar si existen procesos con el nombre "planetas"
		local proceso = buscar_proceso_por_nombre("planetas")

		-- Si existe algún proceso con el nombre "planetas", enviar la señal
		if proceso then
			NUMERO_PLANETAS = 0
			SEÑAL_NOMBRE("planetas", ESTADO_MUERTO)  -- ENVIO SEÑAL 
			actualiza_Texto(id_texto02, "Planetas :" .. NUMERO_PLANETAS, 10, 40)
			local activos, muertos = contar_procesos_activos()
		end
	end
end
--========================================================================================================================================
--========================================================================================================================================

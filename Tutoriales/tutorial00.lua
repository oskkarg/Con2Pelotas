require 'libreriasOscar/librerias'

--🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩

--    ██████╗ ██████╗  ███╗   ██╗    ██████╗     ██████╗ ███████╗██╗      ██████╗ ████████╗ █████╗ ███████╗
--    ██╔════╝██╔═══██╗████╗  ██║    ╚════██╗    ██╔══██╗██╔════╝██║     ██╔═══██╗╚══██╔══╝██╔══██╗██╔════╝
--    ██║     ██║   ██║██╔██╗ ██║     █████╔╝    ██████╔╝█████╗  ██║     ██║   ██║   ██║   ███████║███████╗
--    ██║     ██║   ██║██║╚██╗██║    ██╔═══╝     ██╔═══╝ ██╔══╝  ██║     ██║   ██║   ██║   ██╔══██║╚════██║
--   ╚██████╗╚██████╔╝ ██║ ╚████║    ███████╗    ██║     ███████╗███████╗╚██████╔╝   ██║   ██║  ██║███████║
--   ╚═════╝ ╚═════╝ ╚═╝   ╚═══╝    ╚══════╝    ╚═╝     ╚══════╝╚══════╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚══════╝
--                         TUTORIAL 00 --.. Simple Nave Con Meteoritos        -----                     
--💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀
--💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀
--🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩


local id_textos ={}




local PUNTUACION = 0
local text_size = 28


--========================================================================================================================================
--========================================================================================================================================

function love.load()

	fuente = carga_fuente("fuentes/regular.ttf",text_size )
	set_fps(30)
	set_titulo("😁😁  Con2pelotas  😁😁 por Oscar Adalid Gavilan 😁😁")
	set_mode(320,240,4)

	fichero[1] = carga_fpg("graficos/grafico0")
	fichero[2] = carga_fpg("graficos/grafico1")

	crea(Fondo)
	crea(Nave, {x=200, y=100})

end
--========================================================================================================================================
--========================================================================================================================================

function Nave(nave)
	if nave.nombre == nil then
		nave.hoja = 2
		nave.nombre = "nave"  -- Valor inicial de la velocidad
		nave.grafico = 1
		nave.z = 6
		nave.x = 160
		nave.y = 180

	end

	nave.x = mouse_x()
	if raton_pulsado(1) then
		crea(disparo, {x = nave.x , y = nave.y - 16, padre_id = nave.id})
	end


end
--========================================================================================================================================
--========================================================================================================================================

function disparo(disparo)
	if disparo.nombre == nil then
		disparo.nombre= "disparo" 
		disparo.grafico = 3
		disparo.accion = 0
		disparo.z = 10


	end

	if disparo.accion == 0 then
		disparo.y = disparo.y - 16
		local ha_colisionado_id = colision_Pixel(disparo, "enemigo")

		if ha_colisionado_id then  --devuelve el proceso enemigo = ha_colisionado.id == enemigo
			PUNTUACION = PUNTUACION + 5
			actualiza_Texto(id_textos[1],"Puntos:"..PUNTUACION, 120,10 )

			disparo.accion = 1
			disparo.estado = ESTADO_MUERTO
			ha_colisionado_id.paso = 1 --esto es lo mismo que esto : disparo.paso = 1

		end

		if disparo.y < -16 then
			disparo.estado = ESTADO_MUERTO
		end
	end



end
--========================================================================================================================================
--========================================================================================================================================

function Fondo(p)
	if p.nombre == nil then
		p.nombre = "fondo"
		p.hoja = 2
		p.grafico = 2
		set_texto_size(24)
		set_color(1, 1, 0, 1)
		id_textos[1]= escribe_texto("Puntos:"..PUNTUACION , 120, 10,100)

	end

	p.x = 320/2
	p.y = 200/2

end

--========================================================================================================================================
--========================================================================================================================================

function Enemigo(enemigo)
	if enemigo.nombre == nil then
		enemigo.nombre = "enemigo"
		enemigo.grafico = 4
		enemigo.y = -20
		enemigo.paso = 0
		enemigo.size_x = rand(25,100)
		enemigo.size_y = enemigo.size_x
		enemigo.z = 2
	end

	if enemigo.paso == 0 then
		enemigo.x = enemigo.x + enemigo.inc_x
		enemigo.y = enemigo.y + enemigo.inc_y

		if enemigo.y >= 220 then
			enemigo.paso = 1
		end
		return
	end	

	if enemigo.paso == 1 then
		enemigo.grafico = enemigo.grafico + 1
		if enemigo.grafico > 10 then
			enemigo.estado = ESTADO_MUERTO
			enemigo.paso = 2
		end
		return 
	end
end

--========================================================================================================================================
--========================================================================================================================================

function bucle_Infinito()


	if rand(0,100) <=30  then
		crea(Enemigo,{x= rand(0,320) , inc_x=rand(-4,4) , inc_y=rand(6,12)})

	end


end












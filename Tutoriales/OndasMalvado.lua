--🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩

--    ██████╗ ██████╗  ███╗   ██╗    ██████╗     ██████╗ ███████╗██╗      ██████╗ ████████╗ █████╗ ███████╗
--    ██╔════╝██╔═══██╗████╗  ██║    ╚════██╗    ██╔══██╗██╔════╝██║     ██╔═══██╗╚══██╔══╝██╔══██╗██╔════╝
--    ██║     ██║   ██║██╔██╗ ██║     █████╔╝    ██████╔╝█████╗  ██║     ██║   ██║   ██║   ███████║███████╗
--    ██║     ██║   ██║██║╚██╗██║    ██╔═══╝     ██╔═══╝ ██╔══╝  ██║     ██║   ██║   ██║   ██╔══██║╚════██║
--   ╚██████╗╚██████╔╝ ██║ ╚████║    ███████╗    ██║     ███████╗███████╗╚██████╔╝   ██║   ██║  ██║███████║
--   ╚═════╝ ╚═════╝ ╚═╝   ╚═══╝    ╚══════╝    ╚═╝     ╚══════╝╚══════╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚══════╝
--                         TUTORIAL 10 --.. Simple Ondas Malvado        -----                     
--💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀
--💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀
--🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩


require 'libreriasOscar/librerias'
local text_size = 12


------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

function love.load()
--	local iconData = love.image.newImageData("images/icono.png")
  --  love.window.setIcon(iconData)
	local iconData = love.image.newImageData("images/icono.png")
	love.window.setIcon(iconData)  
	
    set_titulo("😁😁  Con2pelotas : Ondas Malvado  😁😁")
    set_mode(320, 200, 3)
    set_fps(60)
    fuente = carga_fuente("fuentes/regular.ttf", text_size)

    fichero[1] = carga_fpg("images/grafico00")
    fichero[2] = TroceaSprite(fichero[1],1, 8, 200)
	
	
  local totalQuads = numeroQuads(fichero[2])
  for i = 1, totalQuads do
             crea(PintaTrozos, {z = 10, hoja = 2, grafico = i, x = (i - 1) * 8+4, y = 100})
    end   

end

------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------


function PintaTrozos(p)
    if  p.nombre == nil then
        p.nombre = "fondo"
        p.anima = 0
		p.size_y = 100 + (p.x / 8)
    end

    if p.anima == 0 then
        p.size_y = p.size_y + 1  -- Se incrementa correctamente
        if p.size_y > 140 then 
            p.anima = 1  
        end
    else
        p.size_y = p.size_y - 1  -- Se decrementa correctamente
        if p.size_y < 100 then 
            p.anima = 0  
        end
    end
end



function bucle_Infinito()  
-- Esto es una funcion por defecto donde se ejecuta continuamente..
-- es util para hacer llamadas a procesos etc,aunque puedes
-- crear un proceso  y desde ahi hacer las llamadas vamos
-- como div2.
end

--💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀




















--🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩

--    ██████╗ ██████╗  ███╗   ██╗    ██████╗     ██████╗ ███████╗██╗      ██████╗ ████████╗ █████╗ ███████╗
--    ██╔════╝██╔═══██╗████╗  ██║    ╚════██╗    ██╔══██╗██╔════╝██║     ██╔═══██╗╚══██╔══╝██╔══██╗██╔════╝
--    ██║     ██║   ██║██╔██╗ ██║     █████╔╝    ██████╔╝█████╗  ██║     ██║   ██║   ██║   ███████║███████╗
--    ██║     ██║   ██║██║╚██╗██║    ██╔═══╝     ██╔═══╝ ██╔══╝  ██║     ██║   ██║   ██║   ██╔══██║╚════██║
--   ╚██████╗╚██████╔╝ ██║ ╚████║    ███████╗    ██║     ███████╗███████╗╚██████╔╝   ██║   ██║  ██║███████║
--   ╚═════╝ ╚═════╝ ╚═╝   ╚═══╝    ╚══════╝    ╚═╝     ╚══════╝╚══════╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚══════╝
--                         TUTORIAL 01 --..  Rotacion + creacion de Semilla + Estados con Goto        -----                     
--💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀
--💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀💀
--🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩
require 'libreriasOscar/librerias'

local id_textos={}
local PUNTUACION = 0
local text_size = 28

-- Definir las animaciones en una tabla anidada
local animacion = {  
	[1] = {1, 2,   3,  4,  5,  6,   7,  8,  9,  10, 
		11, 12, 13, 14, 15, 16,  17, 18, 19,  20}, 

	[2] = {21, 22,   23,  24,  25,  26,   27,  28,  29,  30, 
		31, 32, 33, 34, 35, 36,  37, 38, 39,  40}, 


	[3] = {43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 
		53, 54, 55, 56, 57, 58, 59, 60, 61,62}

	
	
}

--██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
--██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████

-- Función love.load: Inicializa el juego y carga los recursos necesarios
function love.load()
    -- Siembra el generador de números aleatorios con el tiempo actual para asegurar aleatoriedad
    SEMILLA_RAND()

    -- Carga la fuente desde un archivo TTF y ajusta el tamaño del texto
    fuente = carga_fuente("fuentes/regular.ttf", text_size)

    -- Establece los cuadros por segundo (FPS) del juego
    set_fps(60)

    -- Establece el título de la ventana del juego
    set_titulo("😁😁  Con2pelotas : Planetas  😁😁")

    -- Configura la resolución de la ventana del juego a 640x480 con escalado x2
    set_mode(640, 480, 2)

    -- Carga el primer archivo de gráficos (solo contiene el fondo) y lo asigna al índice 1 del arreglo 'fichero'
    fichero[1] = carga_fpg("graficos/graficos01")  -- Solo contiene el fondo.

    -- Carga el segundo archivo de gráficos y lo asigna al índice 2 del arreglo 'fichero'
    fichero[2] = carga_fpg("graficos/graficos00")

    -- Crea un objeto de tipo 'Fondo' y lo posiciona con un valor de 'z' igual a 1
    crea(Fondo, { z = 1 })

    -- Crea el objeto de control de texto, que mostrará la puntuación u otros mensajes
    crea(controla_texto)

    -- Crea una nave en las coordenadas (320, 240) con el gráfico 41 y un valor 'z' de 8 (probablemente la profundidad de la nave en la pantalla)
    crea(Nave, { x = 320, y = 240, grafico = 41, z = 8 })

    -- Crea 4 asteroides grandes con el código 1
    for i = 1, 4 do
        crea(asteroide, { codigo = 1 })
    end

    -- Crea 4 asteroides grandes con el código 2
    for i = 1, 4 do
        crea(asteroide, { codigo = 2 })
    end
end

--██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████

function Fondo(p)
	if p.nombre == nil then
		p.nombre = "fondo"

		p.grafico = 1
		p.hoja = 1
		p.z = 0
		p.x = 640 / 2
		p.y = 480 / 2
	end
end

--██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████

-- Función para controlar el texto que muestra la puntuación en la pantalla
function controla_texto(proceso)
    -- Si el proceso no tiene un nombre asignado, inicializa las propiedades del texto
    if proceso.nombre == nil then
        proceso.hoja = 1                    -- Asigna el índice de la hoja del sprite (puede estar relacionado con el gráfico)
        proceso.nombre = "texto"             -- Asigna un nombre al proceso (en este caso, "texto")
        proceso.grafico = 1                  -- Asigna un gráfico o sprite (probablemente el texto se representa con un gráfico)
        proceso.size_x = 0.1                 -- Tamaño en el eje X (puede ser un factor de escala)
        proceso.size_y = 0.1                 -- Tamaño en el eje Y (puede ser un factor de escala)

        -- Se obtiene el valor de z (probablemente relacionado con la profundidad de renderizado)
        local x = proceso.z
        set_color(1, 1, 0, 1)                -- Establece el color amarillo (RGB: 1, 1, 0) y opacidad (1)
        
        -- Crea el texto que muestra la puntuación en las coordenadas (220, 10)
        id_textos[1] = escribe_texto("Puntos: " .. PUNTUACION, 220, 10)
        
        -- Cambia el tamaño del texto que se acaba de crear
        texto_size(id_textos[1], 24)
        
        -- Almacena la puntuación actual para poder verificar cambios después
        proceso.puntuacion_anterior = PUNTUACION
    end

    -- Detecta si ha habido un cambio en la puntuación
    if PUNTUACION ~= proceso.puntuacion_anterior then
        -- Si la puntuación ha cambiado, actualiza el texto en la pantalla con la nueva puntuación
		-- De momento lo dejamos asi,es un poco engorroso,tengo que mirar de cambiar esto 💀💀💀💀💀💀💀💀💀💀💀💀💀💀
        actualiza_Texto(id_textos[1], "Puntos: " .. PUNTUACION, 220, 10)
        
        -- Actualiza la puntuación anterior para la próxima comparación
        proceso.puntuacion_anterior = PUNTUACION
    end
end
--██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████


--😁😁😁😁  Con GOTO porque lo hago con2pelotas 😁😁😁😁
-- Función que gestiona el comportamiento de un asteroide en el juego
function asteroide(a)
    -- Inicialización única del asteroide (se ejecuta solo una vez)
    if not a.inicializado then
        a.nombre   = "asteroide"  -- Nombre del objeto
        a.z        = 2            -- Capa en la que se dibuja
        a.paso     = 0            -- Estado inicial
        a.x        = 0            -- Posición X inicial
        a.y        = 0            -- Posición Y inicial
        a.grafico  = a.codigo     -- Gráfico asociado
        a.hoja     = 2            -- Hoja de sprites usada
        a.inicializado = true     -- Marca que el asteroide ha sido inicializado
    end

    -- ESTADO 0: Inicialización del asteroide en el juego
    ::PASO_0::
    if a.paso == 0 then
        -- Se le asigna un ángulo de movimiento aleatorio
        a.angulo = rand(-grados_radianes(180), grados_radianes(180))
        a.hoja   = 2  -- Asigna la hoja de sprites
        a.paso   = 1  -- Avanza al siguiente estado
        a.x      = 0  -- Reinicia la posición X
        a.y      = 0  -- Reinicia la posición Y
        goto PASO_1   -- Salta al estado 1
    end

    -- ESTADO 1: Movimiento y detección de colisión
    ::PASO_1::
    if a.paso == 1 then
        anima_Grafico(a, animacion[a.codigo], 0.2) -- Anima el gráfico del asteroide
        avanza(a, 3, a.angulo) -- Mueve el asteroide en la dirección del ángulo
        corrige_coordenadas(a) -- Corrige la posición si sale de los límites del área de juego

        -- Verifica si el asteroide es impactado por un disparo
        if a.estado ~= ESTADO_MUERTO and colision_Pixel(a, "disparo") then
            a.paso = 2  -- Cambia al estado de impacto
            goto PASO_2
        end
        return  -- Si no hay colisión, finaliza la ejecución
    end

    -- ESTADO 2: El asteroide ha sido impactado por un disparo
    ::PASO_2::
    if a.paso == 2 then
        if a.estado == ESTADO_DESPIERTO then
            PUNTUACION = PUNTUACION + 1  -- Aumenta la puntuación del jugador
            a.paso = 3  -- Cambia al siguiente estado
            goto PASO_3
        end
        return  -- Si no está despierto, termina la función
    end

    -- ESTADO 3: Animación de destrucción y reinicio del asteroide
    ::PASO_3::
    if a.paso == 3 then
        local fin = anima_Grafico(a, animacion[3], 0.2) -- Anima la explosión,(id proceso,tabla animacion,velocidad)
        if fin then
            a.paso = 0  -- Reinicia el ciclo del asteroide
            goto PASO_0
        end
    end
end

--█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████


function corrige_coordenadas(proceso)

	-- restando para ello el ancho de pantalla
	if (proceso.x<-20) then proceso.x = proceso.x  + 680 end
	-- Si se sale por la derecha hace que aparezca por la izquierda
	if (proceso.x>660) then proceso.x = proceso.x  - 680 end
	-- Si se sale por la arriba hace que aparezca por la abajo
	if (proceso.y<-20) then proceso.y =  proceso.y  + 520 end
	-- Si se sale por la abajo hace que aparezca por la arriba
	if (proceso.y>500) then proceso.y = proceso.y-520; end



end
--██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
function Nave(nave)
    -- Verificamos si el objeto nave no tiene asignado un nombre
    if nave.nombre == nil then
        -- Si no tiene nombre, asignamos valores por defecto
        nave.nombre = "nave"  -- Asignamos un nombre por defecto a la nave
        nave.hoja = 2         -- Asignamos el número de la hoja de sprites (esto puede ser para la imagen de la nave)
        nave.contador = 0     -- Iniciamos el contador (posiblemente para animación o alguna función relacionada)
        nave.angulo = 0       -- Asignamos un ángulo de movimiento inicial de 0 (hacia la derecha)
        nave.desplaza = 0     -- Variable que podría usarse para controlar el desplazamiento (velocidad)
        nave.dispara = 0      -- Variable que indica si la nave está disparando o no
    end

    -- Definimos la variable 'frame' que probablemente se usa para cambiar de animación
    local frame = 0
    -- Definimos un valor para el tiempo (probablemente utilizado en el control de animaciones)
    local tiempo = 200
    -- Aumentamos el contador en 0.25, lo que puede estar relacionado con el control de la animación o tiempo de acción
    nave.contador = nave.contador + 0.25

    -- Obtenemos las dimensiones de la nave a partir de la hoja de sprites, para saber cómo dibujarla
    local ancho_x = spritesheet.getWidth(fichero[2], nave.grafico)
    local alto_y = spritesheet.getHeight(fichero[2], nave.grafico)

    -- Si la tecla "left" está presionada, reducimos el ángulo de la nave (gira a la izquierda)
    if key("left") then 
        nave.angulo = nave.angulo - 0.1  
    end

    -- Si la tecla "right" está presionada, aumentamos el ángulo de la nave (gira a la derecha)
    if key("right") then 
        nave.angulo = nave.angulo + 0.1  
    end

    -- Si la tecla "up" está presionada, se activa el desplazamiento de la nave
    if key("up") then 
        nave.desplaza = 2  
    end  

    -- Si la tecla "lctrl" (Control izquierdo) está presionada, la nave está disparando
    if key("lctrl") then 
        nave.dispara = 1  
    end

    -- Calculamos el desplazamiento en los ejes X y Y con base en el ángulo y la velocidad de desplazamiento
    local dx, dy = avanzaxy(nave.desplaza, nave.angulo)
    
    -- Movemos la nave de acuerdo a su ángulo y velocidad
    avanza(nave, nave.desplaza, nave.angulo)

    -- Si la nave está disparando (dispara = 1), se crea un disparo en la posición y ángulo de la nave
    if nave.dispara == 1 then
        -- Llamamos a la función 'crea' para crear un nuevo objeto disparo en la posición y ángulo de la nave
        crea(Disparo, { x = nave.x, y = nave.y, angulo = nave.angulo })
        -- Reiniciamos la variable 'dispara' para indicar que ya no está disparando
        nave.dispara = 0
    end

    -- Después de procesar la entrada y las acciones de la nave, restablecemos el desplazamiento a 0
    nave.desplaza = 0
end


--██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████

-- Función que maneja el comportamiento de un disparo
function Disparo(disparo)
    -- Si el disparo no tiene un nombre asignado, se inicializan las propiedades del disparo
    if disparo.nombre == nil then
        disparo.nombre = "disparo"      -- Asignamos un nombre por defecto al disparo
        disparo.hoja = 2                -- Se puede usar para identificar qué sprite utilizar
        disparo.grafico = 42            -- Asignamos el número de gráfico (sprite) para el disparo

        -- disparo.y = math.floor(disparo.y)  -- Línea comentada que podría usarse para redondear la posición Y (no se usa actualmente)
        disparo.accion = 0              -- Estado de la acción del disparo (0 indica que está activo)
        disparo.z = 6                   -- La capa o profundidad del disparo, puede influir en el renderizado

        -- Calculamos el desplazamiento en las direcciones X e Y según el ángulo del disparo
        local dx, dy = avanzaxy(32, disparo.angulo)
        disparo.x = disparo.x + dx      -- Actualizamos la posición X del disparo
        disparo.y = disparo.y + dy      -- Actualizamos la posición Y del disparo
    end

    -- Si la acción del disparo está en 0, significa que sigue en movimiento
    if disparo.accion == 0 then
        -- Calculamos el desplazamiento en las direcciones X e Y para el disparo según su ángulo
        local dx, dy = avanzaxy(16, disparo.angulo)
        disparo.x = disparo.x + dx      -- Actualizamos la posición X del disparo
        disparo.y = disparo.y + dy      -- Actualizamos la posición Y del disparo
        
        -- Verificamos si el disparo ha colisionado con un asteroide
        local ha_colisionado_id = colision_Pixel(disparo, "asteroide")

        -- Verificamos si el disparo ha salido de la pantalla
        if fuera_pantalla(disparo) then
            disparo.estado = ESTADO_MUERTO  -- Si el disparo está fuera de la pantalla, marcamos su estado como muerto
        end
    end
end


--██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████

function bucle_Infinito()
	if key("space") then
	end
end



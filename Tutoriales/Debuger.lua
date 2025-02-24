local debuger = {}

-- Tabla interna para almacenar las variables
local storedLines = {}

-- Función para almacenar variables
function debuger.debuger(...)
    local args = {...}
    local output = ""
    for i, v in ipairs(args) do
        output = output .. tostring(v) .. " "
    end
    table.insert(storedLines, output)
end

-- Función para imprimir todas las variables almacenadas
function debuger.printAll()
    -- Imprimir las variables en la consola de ZeroBrane
    for _, line in ipairs(storedLines) do
        print(line)  -- Aquí se imprime en la consola
    end
end

-- Función para limpiar la tabla (opcional, si quieres reutilizarla)
function debuger.clear()
    storedLines = {}
end

return debuger



--[[
 -- Almacenamos los valores de player.x, player.y, player.z y el frame
    imprime_variables.debuger("x:"..player.x,"y:"..player.y)
    imprime_variables.printAll()  -- Imprimir todas las variables almacenadas

--]]



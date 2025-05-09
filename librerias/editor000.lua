-- Configuración inicial
local gridWidth = 41
local gridHeight = 20
local baseTileSize = 16
local tileSize = baseTileSize
local zoom = 1
local minZoom = 0.5
local maxZoom = 10
local windowWidth = 1200
local windowHeight = 600
local grid = {}
local tiles = {
	{ id = 0, color = {1, 1, 1} }, -- Blanco
	{ id = 1, color = {0, 0, 1} }, -- Azul
	{ id = 2, color = {0, 1, 0} }, -- Verde
	{ id = 3, color = {1, 0, 0} }, -- Rojo
	{ id = 4, color = {0.6, 0.6, 0} }, -- Amarillo oscuro
	{ id = 5, color = {0.6, 0.2, 1} }, -- Morado
	{ id = 6, color = {0.5, 0, 0} } -- Rojo oscuro
}

local selectedTile = 2
local isMouseDown = false
local selectedControl = nil
local gridOffsetX = 10
local gridOffsetY = 10
local moveSpeed = 200 -- píxeles por segundo
local keyState = {
	left = false,
	right = false,
	up = false,
	down = false
}

-- Variables para el modo pintar/borrar
local paintMode = true
local paintButton = nil
if love.mouse.isDown(1) then
	paintButton = 1
elseif love.mouse.isDown(2) then
	paintButton = 2
end

-- Variables para controlar los tamaños de tile permitidos
local allowedTileSizes = {8, 16, 32, 64}
local currentTileSizeIndex = 2 -- Comienza en 16

-- Variables para el sistema de auto-resize
local resizeTimer = 0
local resizeHoldDelay = 0.5 -- Tiempo antes de empezar auto-resize
local resizeInterval = 0.1  -- Intervalo entre cambios durante auto-resize
local resizeDirection = nil -- "width_up", "width_down", "height_up", "height_down"
local isResizing = false

local gridArea = { x = 0, y = 0, width = windowWidth - 150, height = windowHeight - 50 }
local optionsArea = { x = windowWidth - 150, y = 0, width = 150, height = windowHeight }
local paletteArea = { x = 0, y = windowHeight - 50, width = windowWidth - 150, height = 50 }
local paletteTileSize = 16

function love.load()
	love.window.setMode(windowWidth, windowHeight)
	love.window.setTitle("Editor de Tiles")
	for y = 1, gridHeight do
		grid[y] = {}
		for x = 1, gridWidth do
			grid[y][x] = 0
		end
	end
end

function clearMap()
	for y = 1, gridHeight do
		for x = 1, gridWidth do
			grid[y][x] = 0
		end
	end
end

function resizeGrid(newWidth, newHeight)
	newWidth = math.max(1, newWidth) -- Evitar dimensiones negativas
	newHeight = math.max(1, newHeight)
	local newGrid = {}
	for y = 1, newHeight do
		newGrid[y] = {}
		for x = 1, newWidth do
			newGrid[y][x] = (grid[y] and grid[y][x]) or 0
		end
	end
	grid = newGrid
	gridWidth = newWidth
	gridHeight = newHeight
end

function love.update(dt)
	local moveAmount = moveSpeed * dt
	if keyState.left then
		gridOffsetX = gridOffsetX + moveAmount
	end
	if keyState.right then
		gridOffsetX = gridOffsetX - moveAmount
	end
	if keyState.up then
		gridOffsetY = gridOffsetY + moveAmount
	end
	if keyState.down then
		gridOffsetY = gridOffsetY - moveAmount
	end

	-- Actualizar temporizador de auto-resize
	if isResizing and resizeDirection then
		resizeTimer = resizeTimer + dt
		if resizeTimer >= resizeHoldDelay then
			-- Iniciar o continuar auto-resize
			if resizeDirection == "width_up" then
				resizeGrid(gridWidth + 1, gridHeight)
			elseif resizeDirection == "width_down" then
				resizeGrid(gridWidth - 1, gridHeight)
			elseif resizeDirection == "height_up" then
				resizeGrid(gridWidth, gridHeight + 1)
			elseif resizeDirection == "height_down" then
				resizeGrid(gridWidth, gridHeight - 1)
			end
			-- Reiniciar el temporizador al intervalo para el próximo cambio
			resizeTimer = resizeTimer - resizeInterval
		end
	end
end

function love.wheelmoved(x, y)
	local mouseX, mouseY = love.mouse.getPosition()
	if mouseX >= gridArea.x and mouseX < gridArea.x + gridArea.width and
	mouseY >= gridArea.y and mouseY < gridArea.y + gridArea.height then
		local oldZoom = zoom
		if y > 0 then
			zoom = math.min(zoom + 0.1, maxZoom)
		elseif y < 0 then
			zoom = math.max(zoom - 0.1, minZoom)
		end
		local zoomFactor = zoom / oldZoom
		tileSize = allowedTileSizes[currentTileSizeIndex] * zoom
		gridOffsetX = mouseX - (mouseX - gridOffsetX) * zoomFactor
		gridOffsetY = mouseY - (mouseY - gridOffsetY) * zoomFactor
	end
end

function love.draw()
	love.graphics.setColor(0.9, 0.9, 0.9)
	love.graphics.rectangle("fill", gridArea.x, gridArea.y, gridArea.width, gridArea.height)
	for y = 1, gridHeight do
		for x = 1, gridWidth do
			local tileId = grid[y][x]
			local tile = nil
			for _, t in ipairs(tiles) do
				if t.id == tileId then
					tile = t
					break
				end
			end
			if tile then
				love.graphics.setColor(tile.color)
				love.graphics.rectangle("fill", gridOffsetX + (x-1) * tileSize, gridOffsetY + (y-1) * tileSize, tileSize, tileSize)
			end
			love.graphics.setColor(0.5, 0.5, 0.5)
			love.graphics.rectangle("line", gridOffsetX + (x-1) * tileSize, gridOffsetY + (y-1) * tileSize, tileSize, tileSize)
		end
	end

	love.graphics.setColor(0.7, 0.7, 0.7)
	love.graphics.rectangle("fill", paletteArea.x, paletteArea.y, paletteArea.width, paletteArea.height)
	for i, tile in ipairs(tiles) do
		local paletteX = paletteArea.x + (i-1) * paletteTileSize + 10
		love.graphics.setColor(tile.color)
		love.graphics.rectangle("fill", paletteX, paletteArea.y + 10, paletteTileSize, paletteTileSize)
		if i == selectedTile then
			love.graphics.setColor(1, 0, 0)
			love.graphics.rectangle("line", paletteX, paletteArea.y + 10, paletteTileSize, paletteTileSize, 2)
		else
			love.graphics.setColor(0.5, 0.5, 0.5)
			love.graphics.rectangle("line", paletteX, paletteArea.y + 10, paletteTileSize, paletteTileSize)
		end
	end

	love.graphics.setColor(0.8, 0.8, 0.8)
	love.graphics.rectangle("fill", optionsArea.x, optionsArea.y, optionsArea.width, optionsArea.height)
	love.graphics.setColor(1, 1, 1)
	love.graphics.print("Ancho: " .. gridWidth, optionsArea.x + 10, optionsArea.y + 20)
	love.graphics.print("Alto: " .. gridHeight, optionsArea.x + 10, optionsArea.y + 40)

	-- Botones para ancho
	love.graphics.setColor(0.4, 0.4, 0.8)
	love.graphics.rectangle("fill", optionsArea.x + 100, optionsArea.y + 15, 20, 20)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print("-", optionsArea.x + 108, optionsArea.y + 18)
	love.graphics.setColor(0.4, 0.4, 0.8)
	love.graphics.rectangle("fill", optionsArea.x + 125, optionsArea.y + 15, 20, 20)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print("+", optionsArea.x + 133, optionsArea.y + 18)

	-- Botones para alto
	love.graphics.setColor(0.4, 0.4, 0.8)
	love.graphics.rectangle("fill", optionsArea.x + 100, optionsArea.y + 35, 20, 20)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print("-", optionsArea.x + 108, optionsArea.y + 38)
	love.graphics.setColor(0.4, 0.4, 0.8)
	love.graphics.rectangle("fill", optionsArea.x + 125, optionsArea.y + 35, 20, 20)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print("+", optionsArea.x + 133, optionsArea.y + 38)

	-- Botón de modo pintar/borrar
	love.graphics.setColor(paintMode and 0.5 or 0.2, paintMode and 1 or 0.5, paintMode and 0.5 or 0.2)
	love.graphics.rectangle("fill", optionsArea.x + 10, optionsArea.y + 70, 130, 30)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print(paintMode and "Modo: Pintar" or "Modo: Borrar", optionsArea.x + 20, optionsArea.y + 78)

	-- Botón para limpiar mapa
	love.graphics.setColor(0.8, 0.4, 0.4)
	love.graphics.rectangle("fill", optionsArea.x + 10, optionsArea.y + 110, 130, 30)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print("Limpiar Mapa", optionsArea.x + 20, optionsArea.y + 118)

	-- Controles para tamaño de tile
	love.graphics.setColor(1, 1, 1)
	love.graphics.print("Tamaño Tile: " .. allowedTileSizes[currentTileSizeIndex], optionsArea.x + 10, optionsArea.y + 150)

	-- Botón para disminuir tamaño
	love.graphics.setColor(0.4, 0.4, 0.8)
	love.graphics.rectangle("fill", optionsArea.x + 10, optionsArea.y + 170, 60, 30)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print("-", optionsArea.x + 35, optionsArea.y + 178)

	-- Botón para aumentar tamaño
	love.graphics.setColor(0.4, 0.4, 0.8)
	love.graphics.rectangle("fill", optionsArea.x + 80, optionsArea.y + 170, 60, 30)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print("+", optionsArea.x + 105, optionsArea.y + 178)

	if selectedControl == "width" then
		love.graphics.setColor(1, 0, 0)
		love.graphics.rectangle("line", optionsArea.x + 5, optionsArea.y + 15, 140, 20)
	elseif selectedControl == "height" then
		love.graphics.setColor(1, 0, 0)
		love.graphics.rectangle("line", optionsArea.x + 5, optionsArea.y + 35, 140, 20)
	end
end

function love.mousepressed(x, y, button)
	if button == 1 then
		isMouseDown = true
		paintButton = button

		-- Botón de modo pintar/borrar
		if x >= optionsArea.x + 10 and x <= optionsArea.x + 140 and
		y >= optionsArea.y + 70 and y <= optionsArea.y + 100 then
			paintMode = not paintMode
			return
		end

		-- Botón para limpiar mapa
		if x >= optionsArea.x + 10 and x <= optionsArea.x + 140 and
		y >= optionsArea.y + 110 and y <= optionsArea.y + 140 then
			clearMap()
			return
		end

		-- Botón para disminuir tamaño de tile
		if x >= optionsArea.x + 10 and x <= optionsArea.x + 70 and
		y >= optionsArea.y + 170 and y <= optionsArea.y + 200 then
			if currentTileSizeIndex > 1 then
				currentTileSizeIndex = currentTileSizeIndex - 1
				tileSize = allowedTileSizes[currentTileSizeIndex] * zoom
			end
			return
		end

		-- Botón para aumentar tamaño de tile
		if x >= optionsArea.x + 80 and x <= optionsArea.x + 140 and
		y >= optionsArea.y + 170 and y <= optionsArea.y + 200 then
			if currentTileSizeIndex < #allowedTileSizes then
				currentTileSizeIndex = currentTileSizeIndex + 1
				tileSize = allowedTileSizes[currentTileSizeIndex] * zoom
			end
			return
		end

		-- Botones de ancho
		if x >= optionsArea.x + 100 and x <= optionsArea.x + 120 and
		y >= optionsArea.y + 15 and y <= optionsArea.y + 35 then
			selectedControl = "width"
			resizeDirection = "width_down"
			isResizing = true
			resizeTimer = 0
			resizeGrid(gridWidth - 1, gridHeight)
			return
		elseif x >= optionsArea.x + 125 and x <= optionsArea.x + 145 and
		y >= optionsArea.y + 15 and y <= optionsArea.y + 35 then
			selectedControl = "width"
			resizeDirection = "width_up"
			isResizing = true
			resizeTimer = 0
			resizeGrid(gridWidth + 1, gridHeight)
			return
		end

		-- Botones de alto
		if x >= optionsArea.x + 100 and x <= optionsArea.x + 120 and
		y >= optionsArea.y + 35 and y <= optionsArea.y + 55 then
			selectedControl = "height"
			resizeDirection = "height_down"
			isResizing = true
			resizeTimer = 0
			resizeGrid(gridWidth, gridHeight - 1)
			return
		elseif x >= optionsArea.x + 125 and x <= optionsArea.x + 145 and
		y >= optionsArea.y + 35 and y <= optionsArea.y + 55 then
			selectedControl = "height"
			resizeDirection = "height_up"
			isResizing = true
			resizeTimer = 0
			resizeGrid(gridWidth, gridHeight + 1)
			return
		end

		if y >= paletteArea.y and y < paletteArea.y + paletteArea.height and
		x >= paletteArea.x + 10 and x < paletteArea.x + 10 + #tiles * paletteTileSize then
			local tileIndex = math.floor((x - paletteArea.x - 10) / paletteTileSize) + 1
			if tileIndex >= 1 and tileIndex <= #tiles then
				selectedTile = tileIndex
			end
		elseif x >= gridOffsetX and x < gridOffsetX + gridWidth * tileSize and
		y >= gridOffsetY and y < gridOffsetY + gridHeight * tileSize then
			local gridX = math.floor((x - gridOffsetX) / tileSize) + 1
			local gridY = math.floor((y - gridOffsetY) / tileSize) + 1
			if gridX >= 1 and gridX <= gridWidth and gridY >= 1 and gridY <= gridHeight then
				if paintMode then
					grid[gridY][gridX] = (button == 1) and tiles[selectedTile].id or 0
				else
					grid[gridY][gridX] = 0
				end
			end
		end
	end
end

function love.mousemoved(x, y, dx, dy)
	if isMouseDown and paintButton and x >= gridOffsetX and x < gridOffsetX + gridWidth * tileSize and
	y >= gridOffsetY and y < gridOffsetY + gridHeight * tileSize then
		local gridX = math.floor((x - gridOffsetX) / tileSize) + 1
		local gridY = math.floor((y - gridOffsetY) / tileSize) + 1
		if gridX >= 1 and gridX <= gridWidth and gridY >= 1 and gridY <= gridHeight then
			if paintMode then
				grid[gridY][gridX] = (paintButton == 1) and tiles[selectedTile].id or 0
			else
				grid[gridY][gridX] = 0
			end
		end
	end
end

function love.mousereleased(x, y, button)
	if button == paintButton then
		isMouseDown = false
		paintButton = nil
		isResizing = false
		resizeDirection = nil
		resizeTimer = 0
	end
end

function love.keypressed(key)
	if key == "p" then
		print("local ancho = " .. gridWidth)
		print("local alto = " .. gridHeight)
		print("local datos =")
		local output = "{"
		for y = 1, gridHeight do
			for x = 1, gridWidth do
				output = output .. grid[y][x]
				if x < gridWidth or y < gridHeight then
					output = output .. ", "
				end
				if (x + (y-1) * gridWidth) % 10 == 0 and x < gridWidth then
					output = output .. " "
				end
			end
			if y < gridHeight then
				output = output .. " "
			end
		end
		output = output .. "}"
		print(output)
	elseif key == "left" then
		keyState.left = true
	elseif key == "right" then
		keyState.right = true
	elseif key == "up" then
		keyState.up = true
	elseif key == "down" then
		keyState.down = true
	elseif key == "c" then
		centerGrid()
	elseif key == "m" then
		paintMode = not paintMode
	end
end

function love.keyreleased(key)
	if key == "left" then
		keyState.left = false
	elseif key == "right" then
		keyState.right = false
	elseif key == "up" then
		keyState.up = false
	elseif key == "down" then
		keyState.down = false
	end
end

function centerGrid()
	local gridPixelWidth = gridWidth * tileSize
	local gridPixelHeight = gridHeight * tileSize
	gridOffsetX = gridArea.x + (gridArea.width - gridPixelWidth) / 2
	gridOffsetY = gridArea.y + (gridArea.height - gridPixelHeight) / 2
end

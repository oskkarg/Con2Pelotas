-- con2pelotas/rejillaa000.lua
local Rejilla = {}

-- Variables internas como propiedades del módulo
Rejilla.spatialGridSegments = {}
Rejilla.spatialGridEnemies = {}
local enemyPreviousCells = {}
local CELL_SIZE, SEGMENT_INFLUENCE_RADIUS, ENEMY_INFLUENCE_RADIUS

-- Tabla de bordes predefinida para reutilización en colisionRectSegment
local edgesPool = {
    {{x = 0, y = 0}, {x = 0, y = 0}},
    {{x = 0, y = 0}, {x = 0, y = 0}},
    {{x = 0, y = 0}, {x = 0, y = 0}},
    {{x = 0, y = 0}, {x = 0, y = 0}}
}

-- Funciones internas de colisión y utilidades
local function intersectAABB(ax1, ay1, ax2, ay2, bx1, by1, bx2, by2)
    return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end

local function Interseccion(p1, q1, p2, q2)
    local function ccw(a, b, c)
        return (c.y - a.y) * (b.x - a.x) > (b.y - a.y) * (c.x - a.x)
    end
    return ccw(p1, p2, q2) ~= ccw(q1, p2, q2) and ccw(p1, q1, p2) ~= ccw(p1, q1, q2)
end

local function computeRectVertices(x, y, w, h)
    return {
        {x = x,     y = y},
        {x = x + w, y = y},
        {x = x + w, y = y + h},
        {x = x,     y = y + h}
    }
end

local function colisionRectSegment(vertices, rectX, rectY, rectWidth, rectHeight, segment)
    local segMinX, segMaxX = math.min(segment[1], segment[3]), math.max(segment[1], segment[3])
    local segMinY, segMaxY = math.min(segment[2], segment[4]), math.max(segment[2], segment[4])
    
    local playerLeft = rectX
    local playerRight = rectX + rectWidth
    if playerRight < segMinX or playerLeft > segMaxX then
        return false, nil
    end

    if not intersectAABB(rectX, rectY, rectX + rectWidth, rectY + rectHeight,
                         segMinX, segMinY, segMaxX, segMaxY) then
        return false, nil
    end

    edgesPool[1][1].x, edgesPool[1][1].y = vertices[1].x, vertices[1].y
    edgesPool[1][2].x, edgesPool[1][2].y = vertices[2].x, vertices[2].y
    edgesPool[2][1].x, edgesPool[2][1].y = vertices[2].x, vertices[2].y
    edgesPool[2][2].x, edgesPool[2][2].y = vertices[3].x, vertices[3].y
    edgesPool[3][1].x, edgesPool[3][1].y = vertices[3].x, vertices[3].y
    edgesPool[3][2].x, edgesPool[3][2].y = vertices[4].x, vertices[4].y
    edgesPool[4][1].x, edgesPool[4][1].y = vertices[4].x, vertices[4].y
    edgesPool[4][2].x, edgesPool[4][2].y = vertices[1].x, vertices[1].y

    for _, edge in ipairs(edgesPool) do
        if Interseccion(edge[1], edge[2], {x = segment[1], y = segment[2]}, {x = segment[3], y = segment[4]}) then
            return true, segment
        end
    end
    return false, nil
end

local function getCellCoords(x, y)
    return math.floor(x / CELL_SIZE), math.floor(y / CELL_SIZE)
end

local function distanceToSegment(px, py, x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    local lenSquared = dx * dx + dy * dy
    if lenSquared == 0 then
        return math.sqrt((px - x1)^2 + (py - y1)^2)
    end
    local t = math.max(0, math.min(1, ((px - x1) * dx + (py - y1) * dy) / lenSquared))
    local projX = x1 + t * dx
    local projY = y1 + t * dy
    return math.sqrt((px - projX)^2 + (py - projY)^2)
end

-- Funciones públicas
function Rejilla.init(segmentos, enemies, cellSize, segmentRadius, enemyRadius)
    Rejilla.segmentos = segmentos or {}
    Rejilla.enemies = enemies or {}
    CELL_SIZE = cellSize or 100
    SEGMENT_INFLUENCE_RADIUS = segmentRadius or 100
    ENEMY_INFLUENCE_RADIUS = enemyRadius or 100
    Rejilla.spatialGridSegments = {}
    Rejilla.spatialGridEnemies = {}
    Rejilla.populateSpatialGridSegments()
    Rejilla.populateSpatialGridEnemies()
    for _, enemy in ipairs(Rejilla.enemies) do
        enemyPreviousCells[enemy] = {x = enemy.x, y = enemy.y}
    end
end

function Rejilla.populateSpatialGridSegments()
    Rejilla.spatialGridSegments = {}
    for _, segment in ipairs(Rejilla.segmentos) do
        local minX, maxX = math.min(segment[1], segment[3]), math.max(segment[1], segment[3])
        local minY, maxY = math.min(segment[2], segment[4]), math.max(segment[2], segment[4])
        local minCellX, maxCellX = math.floor(minX / CELL_SIZE), math.floor(maxX / CELL_SIZE)
        local minCellY, maxCellY = math.floor(minY / CELL_SIZE), math.floor(maxY / CELL_SIZE)
        for cx = minCellX, maxCellX do
            for cy = minCellY, maxCellY do
                Rejilla.spatialGridSegments[cx] = Rejilla.spatialGridSegments[cx] or {}
                Rejilla.spatialGridSegments[cx][cy] = Rejilla.spatialGridSegments[cx][cy] or {}
                table.insert(Rejilla.spatialGridSegments[cx][cy], segment)
            end
        end
    end
end

function Rejilla.populateSpatialGridEnemies()
    Rejilla.spatialGridEnemies = {}
    for _, enemy in ipairs(Rejilla.enemies) do
        local cx, cy = getCellCoords(enemy.x, enemy.y)
        Rejilla.spatialGridEnemies[cx] = Rejilla.spatialGridEnemies[cx] or {}
        Rejilla.spatialGridEnemies[cx][cy] = Rejilla.spatialGridEnemies[cx][cy] or {}
        table.insert(Rejilla.spatialGridEnemies[cx][cy], enemy)
    end
end

function Rejilla.addEnemyToSpatialGrid(enemy)
    local cx, cy = getCellCoords(enemy.x, enemy.y)
    Rejilla.spatialGridEnemies[cx] = Rejilla.spatialGridEnemies[cx] or {}
    Rejilla.spatialGridEnemies[cx][cy] = Rejilla.spatialGridEnemies[cx][cy] or {}
    table.insert(Rejilla.spatialGridEnemies[cx][cy], enemy)
    enemyPreviousCells[enemy] = {x = enemy.x, y = enemy.y}
end

function Rejilla.removeEnemyFromSpatialGrid(enemy)
    local cx, cy = getCellCoords(enemyPreviousCells[enemy].x, enemyPreviousCells[enemy].y)
    if Rejilla.spatialGridEnemies[cx] and Rejilla.spatialGridEnemies[cx][cy] then
        for i, e in ipairs(Rejilla.spatialGridEnemies[cx][cy]) do
            if e == enemy then
                table.remove(Rejilla.spatialGridEnemies[cx][cy], i)
                break
            end
        end
        if #Rejilla.spatialGridEnemies[cx][cy] == 0 then
            Rejilla.spatialGridEnemies[cx][cy] = nil
        end
        if not next(Rejilla.spatialGridEnemies[cx]) then
            Rejilla.spatialGridEnemies[cx] = nil
        end
    end
    enemyPreviousCells[enemy] = nil
end

function Rejilla.updateEnemies(enemies)
    for _, enemy in ipairs(enemies) do
        if not enemyPreviousCells[enemy] then
            enemyPreviousCells[enemy] = {x = enemy.x, y = enemy.y}
        end
        local prevCX, prevCY = getCellCoords(enemyPreviousCells[enemy].x, enemyPreviousCells[enemy].y)
        local currCX, currCY = getCellCoords(enemy.x, enemy.y)
        if prevCX ~= currCX or prevCY ~= currCY then
            if Rejilla.spatialGridEnemies[prevCX] and Rejilla.spatialGridEnemies[prevCX][prevCY] then
                for i, e in ipairs(Rejilla.spatialGridEnemies[prevCX][prevCY]) do
                    if e == enemy then
                        table.remove(Rejilla.spatialGridEnemies[prevCX][prevCY], i)
                        break
                    end
                end
                if #Rejilla.spatialGridEnemies[prevCX][prevCY] == 0 then
                    Rejilla.spatialGridEnemies[prevCX][prevCY] = nil
                end
                if not next(Rejilla.spatialGridEnemies[prevCX]) then
                    Rejilla.spatialGridEnemies[prevCX] = nil
                end
            end
            Rejilla.spatialGridEnemies[currCX] = Rejilla.spatialGridEnemies[currCX] or {}
            Rejilla.spatialGridEnemies[currCX][currCY] = Rejilla.spatialGridEnemies[currCX][currCY] or {}
            table.insert(Rejilla.spatialGridEnemies[currCX][currCY], enemy)
            enemyPreviousCells[enemy].x = enemy.x
            enemyPreviousCells[enemy].y = enemy.y
        end
    end
end

function Rejilla.addSegmentToSpatialGrid(segment)
    local minX, maxX = math.min(segment[1], segment[3]), math.max(segment[1], segment[3])
    local minY, maxY = math.min(segment[2], segment[4]), math.max(segment[2], segment[4])
    local minCellX, maxCellX = math.floor(minX / CELL_SIZE), math.floor(maxX / CELL_SIZE)
    local minCellY, maxCellY = math.floor(minY / CELL_SIZE), math.floor(maxY / CELL_SIZE)
    for cx = minCellX, maxCellX do
        for cy = minCellY, maxCellY do
            Rejilla.spatialGridSegments[cx] = Rejilla.spatialGridSegments[cx] or {}
            Rejilla.spatialGridSegments[cx][cy] = Rejilla.spatialGridSegments[cx][cy] or {}
            table.insert(Rejilla.spatialGridSegments[cx][cy], segment)
        end
    end
end

function Rejilla.getSegmentsInInfluenceZone(playerX, playerY, rectWidth, rectHeight, segmentos)
    local nearby = {}
    local added = {}
    local centerX = playerX + rectWidth / 2
    local centerY = playerY + rectHeight / 2
    local minCellX = math.floor((centerX - SEGMENT_INFLUENCE_RADIUS) / CELL_SIZE)
    local maxCellX = math.floor((centerX + SEGMENT_INFLUENCE_RADIUS) / CELL_SIZE)
    local minCellY = math.floor((centerY - SEGMENT_INFLUENCE_RADIUS) / CELL_SIZE)
    local maxCellY = math.floor((centerY + SEGMENT_INFLUENCE_RADIUS) / CELL_SIZE)
    for cx = minCellX, maxCellX do
        for cy = minCellY, maxCellY do
            if Rejilla.spatialGridSegments[cx] and Rejilla.spatialGridSegments[cx][cy] then
                for _, segment in ipairs(Rejilla.spatialGridSegments[cx][cy]) do
                    if not added[segment] then
                        local dist = distanceToSegment(centerX, centerY, segment[1], segment[2], segment[3], segment[4])
                        if dist < SEGMENT_INFLUENCE_RADIUS then
                            table.insert(nearby, segment)
                            added[segment] = true
                        end
                    end
                end
            end
        end
    end
    return nearby
end

function Rejilla.getEnemiesInInfluenceZone(playerX, playerY, rectWidth, rectHeight, enemies)
    local nearby = {}
    local added = {}
    local centerX = playerX + rectWidth / 2
    local centerY = playerY + rectHeight / 2
    local minCellX = math.floor((centerX - ENEMY_INFLUENCE_RADIUS) / CELL_SIZE)
    local maxCellX = math.floor((centerX + ENEMY_INFLUENCE_RADIUS) / CELL_SIZE)
    local minCellY = math.floor((centerY - ENEMY_INFLUENCE_RADIUS) / CELL_SIZE)
    local maxCellY = math.floor((centerY + ENEMY_INFLUENCE_RADIUS) / CELL_SIZE)
    for cx = minCellX, maxCellX do
        for cy = minCellY, maxCellY do
            if Rejilla.spatialGridEnemies[cx] and Rejilla.spatialGridEnemies[cx][cy] then
                for _, enemy in ipairs(Rejilla.spatialGridEnemies[cx][cy]) do
                    if not added[enemy] then
                        local dx = (enemy.x + enemy.width / 2) - centerX
                        local dy = (enemy.y + enemy.height / 2) - centerY
                        local distance = math.sqrt(dx * dx + dy * dy)
                        if distance < ENEMY_INFLUENCE_RADIUS then
                            table.insert(nearby, enemy)
                            added[enemy] = true
                        end
                    end
                end
            end
        end
    end
    return nearby
end

function Rejilla.isCollidingAt(x, y, rectWidth, rectHeight, segmentos)
    local vertices = computeRectVertices(x, y, rectWidth, rectHeight)
    local nearbySegments = Rejilla.getSegmentsInInfluenceZone(x, y, rectWidth, rectHeight, segmentos)
    for _, segment in ipairs(nearbySegments) do
        local isColliding, collidedSegment = colisionRectSegment(vertices, x, y, rectWidth, rectHeight, segment)
        if isColliding then
            return true, collidedSegment
        end
    end
    return false, nil
end

function Rejilla.resolveVerticalCollision(prevY, currentX, currentY, rectWidth, rectHeight, segmentos)
    local isCollidingPrev, _ = Rejilla.isCollidingAt(currentX, prevY, rectWidth, rectHeight, segmentos)
    if not isCollidingPrev then
        local low, high = prevY, currentY
        local collidedSegment = nil
        for _ = 1, 10 do
            local mid = (low + high) / 2
            local isColliding, segment = Rejilla.isCollidingAt(currentX, mid, rectWidth, rectHeight, segmentos)
            if isColliding then
                high = mid
                collidedSegment = segment
            else
                low = mid
            end
            if high - low < 0.5 then break end
        end
        return low, collidedSegment
    else
        local collidedSegment = nil
        while true do
            local isColliding, segment = Rejilla.isCollidingAt(currentX, currentY, rectWidth, rectHeight, segmentos)
            if not isColliding then break end
            collidedSegment = segment
            currentY = currentY - 1
        end
        return currentY, collidedSegment
    end
end

function Rejilla.updateProjectiles2(projectiles, enemies, dt, windowHeight, useContinuous)
    local sweptAreas = {}
    local eliminatedEnemies = {}
    for i = #projectiles, 1, -1 do
        local proj = projectiles[i]
        local prevY = proj.y
        proj.y = proj.y + proj.vy * dt
        if proj.y + proj.height < 0 then
            table.remove(projectiles, i)
        else
            local projLeft = proj.x
            local projRight = proj.x + proj.width
            local projTop = math.min(proj.startY, proj.y)
            local projBottom = math.max(proj.startY + proj.height, proj.y + proj.height)
            table.insert(sweptAreas, {x = projLeft, y = projTop, width = projRight - projLeft, height = projBottom - projTop})
            if useContinuous then
                local projTopFrame = math.min(prevY, proj.y)
                local projBottomFrame = math.max(prevY + proj.height, proj.y + proj.height)
                for j = #enemies, 1, -1 do
                    local enemy = enemies[j]
                    if Rejilla.intersectAABB(projLeft, projTopFrame, projRight, projBottomFrame,
                                             enemy.x, enemy.y, enemy.x + enemy.width, enemy.y + enemy.height) then
                        table.insert(eliminatedEnemies, enemy)
                        Rejilla.removeEnemyFromSpatialGrid(enemy)
                        table.remove(enemies, j)
                        table.remove(projectiles, i)
                        goto continue_proj
                    end
                end
            end
            local minCellX = math.floor(proj.x / CELL_SIZE)
            local maxCellX = math.floor((proj.x + proj.width) / CELL_SIZE)
            local minCellY = math.floor(proj.y / CELL_SIZE)
            local maxCellY = math.floor((proj.y + proj.height) / CELL_SIZE)
            for cx = minCellX, maxCellX do
                for cy = minCellY, maxCellY do
                    if Rejilla.spatialGridEnemies[cx] and Rejilla.spatialGridEnemies[cx][cy] then
                        for j = #Rejilla.spatialGridEnemies[cx][cy], 1, -1 do
                            local enemy = Rejilla.spatialGridEnemies[cx][cy][j]
                            if Rejilla.intersectAABB(proj.x, proj.y, proj.x + proj.width, proj.y + proj.height,
                                                     enemy.x, enemy.y, enemy.x + enemy.width, enemy.y + enemy.height) then
                                table.insert(eliminatedEnemies, enemy)
                                for k = #enemies, 1, -1 do
                                    if enemies[k] == enemy then
                                        Rejilla.removeEnemyFromSpatialGrid(enemy)
                                        table.remove(enemies, k)
                                        break
                                    end
                                end
                                table.remove(projectiles, i)
                                goto continue_proj
                            end
                        end
                    end
                end
            end
        end
        ::continue_proj::
    end
    return eliminatedEnemies, sweptAreas
end

-- Exponer funciones necesarias
Rejilla.intersectAABB = intersectAABB

return Rejilla

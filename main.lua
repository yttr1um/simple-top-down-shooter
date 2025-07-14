_G.love = require("love")
_G.wf = require("Libraries/windfield")

_G.enemy = require("Enemy")
_G.player = require("Player")

math.randomseed(os.time())

bullets = {}

function love.load()
    love.mouse.setVisible(false)

    world = wf.newWorld(0, 0)

    player = player(world)

    enemies = {}

    for i = 1, 5 do
        table.insert(enemies, enemy(world))
    end

    player.collider:setFixedRotation(true)
end

function love.update(dt)
    player.gun.x, player.gun.y = love.mouse.getPosition()

    local vx = 0
    local vy = 0

    -- player movement
    if love.keyboard.isDown("a") then
        vx = player.speed * -1
    end

    if love.keyboard.isDown("d") then
        vx = player.speed
    end

    if love.keyboard.isDown("w") then
        vy = player.speed * -1
    end

    if love.keyboard.isDown("s") then
        vy = player.speed 
    end

    player.collider:setLinearVelocity(vx, vy)

    world:update(dt)
    player.x = player.collider:getX()
    player.y = player.collider:getY()

    -- find bullet new position

    for i, v in ipairs(bullets) do 
        v.x = v.x + (v.dx * dt)
        v.y = v.y + (v.dy * dt)
    end

    -- enemies
    
    for i = 1, #enemies do 

        enemies[i].x = enemies[i].collider:getX()
        enemies[i].y = enemies[i].collider:getY()

        enemies[i]:move(player.x, player.y)

        enemies[i].collider:setLinearVelocity(enemies[i].vx, enemies[i].vy)

        if enemies[i]:checkTouched(player.x, player.y, player.radius) then
            player.health = player.health - 1
        end
    end
end

function love.mousepressed(x, y, button) 
    if button == 1 then
        local startX = player.x 
        local startY = player.y

        local mouseX = x 
        local mouseY = y 

        local angle = math.atan2((mouseY - startY), (mouseX - startX))

        local bulletDx = player.gun.bulletSpeed * math.cos(angle)
        local bulletDy = player.gun.bulletSpeed * math.sin(angle)

        table.insert(bullets, {x = startX, y = startY, dx = bulletDx, dy = bulletDy})
    end
end

function love.draw()
    world:draw()

    -- FPS counter
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.printf(
        "FPS: " .. love.timer.getFPS(), 
        love.graphics.newFont(16),
        10, 
        love.graphics.getHeight()-25,
        love.graphics.getWidth()
    )
    love.graphics.setColor(1, 1, 1)

    love.graphics.printf(
        "Health: ".. player.health,
        love.graphics.newFont(16),
        love.graphics.getWidth() - 100,
        love.graphics.getHeight()-25,
        love.graphics.getWidth()
    )

    -- player
    love.graphics.circle("fill", player.x, player.y, player.radius)

    -- cursor
    if love.mouse.isDown("1") then
        love.graphics.setColor(1, 0, 0)
    else
        love.graphics.setColor(0.5, 0.5, 0.5)
    end
    love.graphics.circle("line", player.gun.x, player.gun.y, player.gun.radius)

    -- bullets
    love.graphics.setColor(1, 0, 0)
    for i, v in ipairs(bullets) do 
        love.graphics.circle("fill", v.x, v.y, 3)
    end

    -- enemies
    for i = 1, #enemies do
        enemies[i]:draw()
    end

    -- reset coloring
    love.graphics.setColor(1, 1, 1)
end
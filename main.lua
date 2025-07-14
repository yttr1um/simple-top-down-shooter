_G.love = require("love")
_G.enemy = require("Enemy")

local player = {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        radius = 30,
        speed = 5,
        health = 100,

        gun = {
            radius = 10,
            x = 100,
            y = 100,
            bulletSpeed = 250,
        }
    }

bullets = {}

enemies = {
    enemy()
}

function love.load()
    love.mouse.setVisible(false)


end

function love.update(dt)
    player.gun.x, player.gun.y = love.mouse.getPosition()

    -- player movement
    if love.keyboard.isDown("a") then
        player.x = player.x - player.speed
    end

    if love.keyboard.isDown("d") then
        player.x = player.x + player.speed
    end

    if love.keyboard.isDown("w") then
        player.y = player.y - player.speed
    end

    if love.keyboard.isDown("s") then
        player.y = player.y + player.speed
    end

    -- find bullet new position

    for i, v in ipairs(bullets) do 
        v.x = v.x + (v.dx * dt)
        v.y = v.y + (v.dy * dt)
    end

    -- enemies

    for i = 1, #enemies do 
        enemies[i]:move(player.x, player.y)
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
    -- FPS counter
    love.graphics.printf(
        "FPS: " .. love.timer.getFPS(), 
        love.graphics.newFont(16),
        10, 
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
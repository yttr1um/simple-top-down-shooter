_G.love = require("love")

local player = {
        x = 100,
        y = 100,
        radius = 30,
        speed = 5,

        gun = {
            radius = 10,
            x = 100,
            y = 100,
        }
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
end

function love.draw()
    love.graphics.circle("fill", player.x, player.y, player.radius)

    --love.graphics.setColor(0.5, 0.5, 0.5)

    if love.mouse.isDown("1") then
        love.graphics.setColor(1, 0, 0)
    else
        love.graphics.setColor(0.5, 0.5, 0.5)
    end

    love.graphics.circle("line", player.gun.x, player.gun.y, player.gun.radius)

    -- reset coloring
    love.graphics.setColor(1, 1, 1)
end
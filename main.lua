_G.love = require("love")

function love.load()
    player = {
        x = 100,
        y = 100,
        radius = 30,
        speed = 5,
    }
end

function love.update(dt)
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
end
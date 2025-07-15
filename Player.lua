function Player()

    return {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        vx = 0,
        vy = 0,
        radius = 30,
        speed = 300,
        health = 100,
        tag = "player",

        cursor = {
            radius = 10,
            x = 100,
            y = 100,
        }
    }

end

return Player
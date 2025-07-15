function Player()

    return {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        vx = 0,
        vy = 0,
        radius = 30,
        speed = 300,
        health = 100,

        cursor = {
            radius = 10,
            x = 100,
            y = 100,
            bulletSpeed = 250,
        }
    }

end

return Player
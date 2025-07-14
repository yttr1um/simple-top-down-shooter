function Player(world)

    return {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        vx = 0,
        vy = 0,
        radius = 30,
        speed = 300,
        health = 100,
        collider = world:newCircleCollider(
            love.graphics.getWidth() / 2, 
            love.graphics.getHeight() / 2, 
            35),

        gun = {
            radius = 10,
            x = 100,
            y = 100,
            bulletSpeed = 250,
        }
    }

end

return Player
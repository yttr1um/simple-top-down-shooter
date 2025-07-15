world = love.physics.newWorld(0, 0)

function Player()

    player = {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        vx = 0,
        vy = 0,
        radius = 30,
        speed = 300,
        health = 100,
        body = love.physics.newBody(world, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, "dynamic"),
        shape = love.physics.newCircleShape(30),

        cursor = {
            radius = 10,
            x = 100,
            y = 100,
            bulletSpeed = 250,
        }
    }

    player.fixture = love.physics.newFixture(player.body, player.shape)
    player.fixture:setUserData(player)
    player.body:setFixedRotation(true)

    return player

end

return Player
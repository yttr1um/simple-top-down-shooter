_G.love = require("love")

enemy = require("Enemy")
player = require("Player")

math.randomseed(os.time())

world = love.physics.newWorld(0, 0)

function removeBullet(bullet)
    if bullet and bullet.body and bullet.body:isDestroyed() == false then
        bullet.body:destroy()
    end
    bullets[bullet.id] = nil
end

function onCollisionEnter(a, b, contact)
    local obj1, obj2 = a:getUserData(), b:getUserData()

    if (obj1.tag == "bullet" or obj2.tag == "bullet") then
        local bullet = obj1.tag == "bullet" and obj1 or obj2
        if not(obj1.tag == "player" or obj2.tag=="player") then
            removeBullet(bullet)
        end

        if (obj1.tag == "enemy" or obj2.tag == "enemy") then
            local enemy = obj1.tag == "enemy" and obj1 or obj2
            enemy.shot = true

            if enemy.body and not enemy.body:isDestroyed() then
                enemy.body:destroy()
            end
        end
    end
end

function onCollisionExit(a, b, contact)

end

world:setCallbacks(onCollisionEnter, onCollisionExit)

player = player()

bullets = {}
bulletSpeed = 500
nextBulletId = 1 

function newBullet(id, x, y, dx, dy, r)
    local bullet = {
        x = x,
        y = y,
        dx = dx,
        dy = dy,
        id = id,
        radius = r,
        tag = "bullet",
        body = love.physics.newBody(world, x, y, "dynamic"),
        shape = love.physics.newCircleShape(r)
    }

    bullet.fixture = love.physics.newFixture(bullet.body, bullet.shape)
    bullet.fixture:setUserData(bullet)
    return bullet
end

function love.load()
    love.mouse.setVisible(false)

    player.body = love.physics.newBody(world, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, "dynamic")
    player.shape = love.physics.newCircleShape(30)
    player.fixture = love.physics.newFixture(player.body, player.shape)
    player.fixture:setUserData(player)
    player.body:setFixedRotation(true)

    enemies = {}

    while #enemies < 5 do
        enemy_obj = enemy()
        table.insert(enemies, enemy_obj)

        enemy_obj.body = love.physics.newBody(world, enemy_obj.x, enemy_obj.y, "dynamic")
        enemy_obj.shape = love.physics.newCircleShape(enemy_obj.radius)
        enemy_obj.fixture = love.physics.newFixture(enemy_obj.body, enemy_obj.shape)
        enemy_obj.fixture:setUserData(enemy_obj)
        enemy_obj.body:setFixedRotation(true)
    end

end

function love.update(dt)

    world:update(dt)

    player.cursor.x, player.cursor.y = love.mouse.getPosition()

     local dx, dy = 0, 0

    if love.keyboard.isDown("a") then
        dx = -player.speed
    end

    if love.keyboard.isDown("d") then
        dx = player.speed
    end

    if love.keyboard.isDown("w") then
        dy = -player.speed
    end

    if love.keyboard.isDown("s") then
        dy = player.speed
    end

    player.body:setLinearVelocity(dx, dy)
    player.x, player.y = player.body:getPosition()

    -- find bullet new position

    for id, v in pairs(bullets) do

        local dx, dy = 0, 0

        dx = v.dx
        dy = v.dy

        v.body:setLinearVelocity(dx, dy)
    end

    -- enemies
    
    for i = 1, #enemies do 
        if not enemies[i].shot then
            enemies[i].x, enemies[i].y = enemies[i].body:getPosition()

            enemies[i]:move(player.x, player.y)

            enemies[i].body:setLinearVelocity(enemies[i].vx, enemies[i].vy)

            if enemies[i]:checkTouched(player.x, player.y, player.radius) then
                player.health = player.health - 1
            end
        end
    end

    for i = #enemies, 1, -1 do
        if enemies[i].shot then
            table.remove(enemies, i)
        end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        local startX, startY = player.x, player.y 
        local mouseX, mouseY = x, y 

        local angle = math.atan2((mouseY - startY), (mouseX - startX))

        local bulletDx = bulletSpeed * math.cos(angle)
        local bulletDy = bulletSpeed * math.sin(angle)

        local bullet = newBullet(nextBulletId, startX, startY, bulletDx, bulletDy, 3)
        bullets[bullet.id] = bullet

        nextBulletId = nextBulletId + 1
    end
end

function love.draw()
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
    love.graphics.circle("line", player.cursor.x, player.cursor.y, player.cursor.radius)

    -- bullets
     love.graphics.setColor(1, 0, 0)
    for i, v in pairs(bullets) do
        local x, y = v.body:getPosition()
        love.graphics.circle("fill", x, y, 3)
    end
    love.graphics.setColor(1, 1, 1)

    -- enemies
    for i = 1, #enemies do
        if not enemies[i].shot then
            enemies[i]:draw()
        end
    end

    love.graphics.setColor(0, 0, 1)
    for _, body in pairs(world:getBodies()) do
        for _, fixture in pairs(body:getFixtures()) do
            local shape = fixture:getShape()

            if shape:typeOf("CircleShape") then
                local cx, cy = body:getWorldPoints(shape:getPoint())
                love.graphics.circle("line", cx, cy, shape:getRadius())
            elseif shape:typeOf("PolygonShape") then
                love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
            else
                love.graphics.line(body:getWorldPoints(shape:getPoints()))
            end
        end
    end

    -- reset coloring
    love.graphics.setColor(1, 1, 1)
end
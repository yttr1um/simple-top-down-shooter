_G.love = require "love"
_G.wf = require("Libraries/windfield")

function Enemy(world) 

    local dice = math.random(1,4) 
    local _x, _y
    local _radius = 20

    if dice == 1 then
        _x = math.random(0, love.graphics.getWidth())
        _y = -_radius * 4
    elseif dice == 2 then
        _x = -_radius * 4
        _y = math.random(0, love.graphics.getHeight())
    elseif dice == 3 then
        _x = math.random(0, love.graphics.getWidth())
        _y = love.graphics.getHeight() + _radius * 4
    else
        _x = love.graphics.getWidth() + (_radius * 4)
        _y = math.random(0, love.graphics.getHeight())
    end

    return {
        radius = _radius,
        x = _x,
        y = _y,
        speed = 75,
        collider = world:newCircleCollider(_x, _y, _radius + 5),

        vx = 0,
        vy = 0,

        move = function(self, player_x, player_y)
            if player_x - self.x > 0 then
                self.vx = self.speed 
            elseif player_x - self.x < 0 then 
                self.vx = self.speed * -1 
            end

            if player_y - self.y > 0 then
                self.vy = self.speed
            elseif player_y - self.y < 0 then 
                self.vy = self.speed * -1 
            end
        end,

        checkTouched = function (self, player_x, player_y, cursor_radius) 
            return math.sqrt((self.x - player_x) ^ 2 + (self.y - player_y) ^ 2) <= cursor_radius * 2
        end,

        draw = function(self)
            love.graphics.setColor(0.5, 0.6, 0.5)
            love.graphics.circle("fill", self.x, self.y, self.radius)
            love.graphics.setColor(1, 1, 1)
        end,

    }
end

return Enemy
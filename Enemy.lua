_G.love = require "love"

function Enemy() 
    return {
        radius = 20,
        x = -10,
        y = -50,
        level = 1,

        move = function(self, player_x, player_y)
            if player_x - self.x > 0 then
                self.x = self.x + self.level
            elseif player_x - self.x < 0 then 
                self.x = self.x - self.level  
            end

            if player_y - self.y > 0 then
                self.y = self.y + self.level
            elseif player_y - self.y < 0 then 
                self.y = self.y - self.level  
            end
        end,

        draw = function(self)
            love.graphics.setColor(0.5, 0.6, 0.5)
            love.graphics.circle("fill", self.x, self.y, self.radius)
            love.graphics.setColor(1, 1, 1)
        end,

    }
end

return Enemy
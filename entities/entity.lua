
Entity = class("Entity")
Entity.map = nil
Entity._type = nil

function Entity:initialize(options)
  self.name = self.class.name
  self.moving_position = { x = 0, y = 0} -- for the walking animation
  for k, v in pairs(options) do
    self[k] = v
  end
  if self._type == nil then
    self._type = self.class.name
  end

  if not self.position then
    self.position = {x = 1, y = 1, z = 1}
  end
  if not self.position.width then
    self.position.width = 1
  end
  if not self.position.height then
    self.position.height = 1
  end
end

function Entity:draw()
  love.graphics.push()
  love.graphics.setColor(255,255,255,255)
  game.renderer:translate(self.position.x, self.position.y)
  if self.moving_position then
    game.renderer:translate(-self.moving_position.x, -self.moving_position.y)
  end
  self:drawContent()
  love.graphics.pop()
end

function Entity:drawContent()
  if self:animation() then
    self:animation():draw(self:image(), 0, 0)
  end
end

function Entity:update(dt)
  if self:animation() then
    self:animation():update(dt)
  end
end

function Entity:animation()
  if not self.state then
    return self.animation_data.animation
  end

  if not self.animation_data or not self.animation_data[self.state] then
    return false
  end
  return self.animation_data[self.state].animation
end

function Entity:image()
  if not self.state then
    return self.animation_data.image
  end
  if not self.animation_data or not self.animation_data[self.state] then
    return false
  end
  return self.animation_data[self.state].image
end
function Entity:includesPoint(point)
  if self.position.x <= point.x and self.position.y <= point.y and
      self.position.x + self.position.width >= point.x and
      self.position.y + self.position.height >= point.y then
    return true
  end
  return false
end

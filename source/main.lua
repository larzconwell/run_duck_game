import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"

local gfx <const> = playdate.graphics

local inputPositionModifiers = {
    {playdate.kButtonUp, {0, -2}},
    {playdate.kButtonDown, {0, 2}},
    {playdate.kButtonLeft, {-2, 0}},
    {playdate.kButtonRight, {2, 0}}
}
local state = nil

function setState(newState)
    if state then
        state:destroy()
    end

    state = newState
end

function init()
    local backgroundImage = gfx.image.new("images/background")
    assert(backgroundImage)

    gfx.sprite.setBackgroundDrawingCallback(function(x, y, width, height)
        backgroundImage:draw(0, 0)
    end)

    setState(Main())
end

class("Main", {logoImage = nil, logoSprite = nil}).extends()

function Main:init()
    local logoImage = gfx.image.new("images/logo")
    assert(logoImage)

    local logoSprite = gfx.sprite.new(logoImage)
    logoSprite:setCenter(0, 0)
    logoSprite:moveTo(20, 20)
    logoSprite:add()

    self.logoImage = logoImage
    self.logoSprite = logoSprite
end

function Main:update()
    if playdate.buttonJustPressed(playdate.kButtonA) then
        setState(Game())
    end

    gfx.sprite.update()
end

function Main:destroy()
    self.logoSprite:remove()
end

class("Game", {playerImage = nil, playerSprite = nil}).extends()

function Game:init()
    local playerImage = gfx.image.new("images/sprite")
    assert(playerImage)

    local playerSprite = gfx.sprite.new(playerImage)
    playerSprite:moveTo(200, 120)
    playerSprite:add()

    self.playerImage = playerImage
    self.playerSprite = playerSprite
end

function Game:update()
    if playdate.buttonJustPressed(playdate.kButtonB) then
        setState(Main())
    end

    local playerSprite = self.playerSprite
    local minx = 0 + (playerSprite.width / 2)
    local maxx = 400 - (playerSprite.width / 2)
    local miny = 0 + (playerSprite.height / 2)
    local maxy = 240 - (playerSprite.height / 2)

    for _, modifier in ipairs(inputPositionModifiers) do
        if playdate.buttonIsPressed(modifier[1]) then
            local newx = playerSprite.x + modifier[2][1]
            local newy = playerSprite.y + modifier[2][2]

            if newx >= minx and newx <= maxx and newy >= miny and newy <= maxy then
                playerSprite:moveBy(table.unpack(modifier[2]))
            end
        end
    end

    gfx.sprite.update()
end

function Game:destroy()
    self.playerSprite:remove()
end

function playdate.update()
    state:update()
end

function playdate.gameWillTerminate()
    state:destroy()
end

init()

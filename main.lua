-- [[ parameters of the window / screen ]]
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

-- any variable that you are declaring without specifying the key word 'local' 
-- can be used from anywhere else
Class = require 'class'
push = require 'push'  -- import the file push.lua

require 'Paddle'
require 'Ball'
 
--[[
    Runs when the game first starts up, only once; used to initialize the game
-- ]]
function love.load()
    -- setting a start value for randomseed
    math.randomseed(os.time())

    -- use nearest-neighboor filtering on upscaling and downsclaing to prevent blurring of text
    -- try moving this function to see the difference ! 
    love.graphics.setDefaultFilter('nearest', 'nearest')


    -- intialize our vitual resolution, which will be rendered within our actual window no matter its dimensions; 
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false, 
        vsync = true,
        resizable = false
    })

    -- defining the font to use
    smallFont = love.graphics.newFont('font.TTF', 8)   -- an 8 pixel font
    scoreFont = love.graphics.newFont('font.TTF', 12)

    player1Score = 0
    player2Score = 0

    -- creating the paddles
    paddle1 = Paddle(5, 30, 5, 20 )
    paddle2 = Paddle(VIRTUAL_WIDTH-10, VIRTUAL_HEIGHT-30, 5, 20)

    -- the ball's position
    ballX = VIRTUAL_WIDTH/2 -2
    ballY = VIRTUAL_HEIGHT/2 -2

    -- if the chosen value is 1 it gets -100, otherwise it gets 100
    ballDX = math.random(2) == 1 and -100  or 100 
    ballDY = math.random(-50, 50)  -- somewhere in the range

    gameState = 'start'

end


-- [[consider using this function whenever you want to change the position of something, ...etc]]
function love.update(dt)
    -- dt allows you to move things regardless of the frame rate
    -- remember to always * by dt whenever you use time !

    paddle1:update(dt)
    paddle2:update(dt)

    -- player 1 movement
    if love.keyboard.isDown('s') then
        paddle1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('x') then
        paddle1.dy = PADDLE_SPEED
    else 
        paddle1.dy = 0
    end

    -- player 2 movement
    if love.keyboard.isDown('up') then 
        paddle2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        paddle2.dy = PADDLE_SPEED

    else 
        paddle2.dy = 0
    end

    

    -- intializing randomly the ball's position
    if gameState == 'play' then
        ballX = ballX + ballDX*dt
        ballY = ballY + ballDY*dt
    end

end

-- [[ Handling which key is pressed --]]
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()

    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        elseif gameState == 'play' then
            gameState = 'start'

            -- initialize the ball's coordinates  
            ballX = VIRTUAL_WIDTH/2 -2
            ballY = VIRTUAL_HEIGHT/2 -2

            -- initializing the ball's rate
            ballDX = math.random(2) == 1 and -100  or 100 
            ballDY = math.random(-50, 50)  -- somewhere in the range
        end
    end

end

-- [[ Called after update by lua, used to draw anything to the screen, updated or otherwise.]]
function love.draw()
    push:apply('start')

    -- this instruction changes the color of the background, it should be set before drawing anything else
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)  -- should be mapped to [0, 1]

    -- setting the font 
    love.graphics.setFont(smallFont)
    if gameState == 'start' then 
        -- text and its placement
        love.graphics.printf("Hello Start Pong!", 0, 5,  VIRTUAL_WIDTH , 'center')  
    elseif gameState == 'play' then 
        love.graphics.printf(" Playing Pong!", 0, 5,  VIRTUAL_WIDTH , 'center')
    end
        

    love.graphics.setFont(scoreFont)
    love.graphics.print(player1Score, VIRTUAL_WIDTH/2 - 50, VIRTUAL_HEIGHT/3 - 60)
    love.graphics.print(player2Score, VIRTUAL_WIDTH/2 +30, VIRTUAL_HEIGHT/3 - 60)


    -- VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/2   : the placement of the ball
    -- render ball (center)
    love.graphics.rectangle('fill', ballX, ballY, 5, 5)

    paddle1:render()
    paddle2:render()


    push:apply('end')
end



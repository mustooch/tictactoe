function love.load()
  
  love.window.setMode(600,600)
  WID, HEI = 600, 600
  
  love.window.setTitle("tic-tac-toe")
  love.window.setIcon( love.image.newImageData("icon.png") )
  
  love.graphics.setDefaultFilter("nearest")
  
  STATE = "intro"
  TURN = 1
  WIN = 0
  
  img = {
    X = love.graphics.newImage("img_x.png"),
    O = love.graphics.newImage("img_o.png")
  }
  
  GRID = {}
  
end

function new_game(players)
  
  GRID = {
    {0 , 0 , 0},
    {0 , 0 , 0},
    {0 , 0 , 0},
  }
  
  WIN = 0
  
end

function check_win(num)
  print("checking "..num)
  for i = 1, 3 do
    if (GRID[i][1] == num and GRID[i][2] == num and GRID[i][3] == num) -- horizontal
    or (GRID[1][i] == num and GRID[2][i] == num and GRID[3][i] == num) -- vertical
    or (GRID[1][1] == num and GRID[2][2] == num and GRID[3][3] == num) -- diagonal 1
    or (GRID[3][1] == num and GRID[2][2] == num and GRID[1][3] == num) -- diagonal 2
    then
      return true
    end
  end
  
end

function check_tie()
  
  for i = 1, 3 do
    for j = 1, 3 do
      if (GRID[i][j] == 0) then return false end
    end
  end
  return true
  
end

function get_input(x,y)
  
  return math.ceil(x/200), math.ceil(y/200)
  
end

function draw_grid()
  
  -- draw lines
  for i = 1, 2 do
    love.graphics.setColor(0,0,0)
    love.graphics.line( (i*200),0, (i*200),HEI ) 
    love.graphics.line( 0,(i*200), WID,(i*200) )
  end
  
  -- draw X's and O's
  for i = 1, 3 do
    for j = 1, 3 do
      if GRID[i][j] == 1 then
        love.graphics.draw( img.X, (j-1)*200, (i-1)*200 )
      elseif GRID[i][j] == 2 then
        love.graphics.draw( img.O, (j-1)*200, (i-1)*200 )
      end
    end
  end
  
end

function love.keypressed(key)
  
  if key=="escape" then love.event.push("quit") end
  
end

function love.mousepressed(mouse_x, mouse_y, button)
  
  if STATE == "intro" then
    
    new_game()
    STATE = "game"
    
  elseif STATE == "game" then
    
    grid_x, grid_y = get_input(mouse_x, mouse_y)
    if GRID[grid_y][grid_x] == 0 then -- if cell is empty
      GRID[grid_y][grid_x] = TURN -- set cell
      
      if check_win(1) then
        STATE = "end"
        WIN = 1
      elseif check_win(2) then
        STATE = "end"
        WIN = 2
      else
        if check_tie() then -- if tie (no more spaces left)
          STATE = "end" -- end the game
          WIN = 0
        end
        -- in all cases (tie or not)
        TURN = (TURN==1) and 2 or 1 -- switch between X and O
      end
    end
    
  elseif STATE == "end" then
    
    -- go back to game with a new game
    STATE = "game"
    new_game()
    
  end
  
end

function love.draw()
  
  love.graphics.setBackgroundColor(1,1,1)
  
  if STATE == "intro" then
    
    love.graphics.setColor(0,0,0)
    love.graphics.print("Press anywhere to start", 240,280)
    
  elseif STATE == "game" then
    
    draw_grid()
    
  elseif STATE == "end" then
    
    love.graphics.setColor(0,0,0)
    if WIN == 0 then love.graphics.print("IT'S A TIE! NO ONE WINS", 235,280)
    else love.graphics.print("PLAYER "..WIN.." WINS", 260,280) end
    love.graphics.print("Press anywhere to restart", 235,300)
    
  end
  
end

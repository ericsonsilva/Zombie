function love.load()
--cria tabelhas de spriotes.
  sprites = {}
--para caminha de arquivos usar aspas simples.
  sprites.player = love.graphics.newImage('sprites/player.png')
  sprites.bullet = love.graphics.newImage('sprites/bullet.png')
  sprites.zombie = love.graphics.newImage('sprites/zombie.png')
  sprites.background = love.graphics.newImage('sprites/background.png')
-- tabela para movimento do plaer.
  player = {}
  player.x = 200
  player.y = 200
  player.speed = 180
end

function love.update(dt)
-- funçao keyboard.
-- DT define a contagem de segundos. Mutiplicando por DT
-- garatimos que o jogo rodará sempre com a mesma velocidade,
-- mesmo que os frames dropem.
  if love.keyboard.isDown("s") then
    player.y = player.y + player.speed * dt
  end

  if love.keyboard.isDown("w") then
    player.y = player.y - player.speed * dt
  end

  if love.keyboard.isDown("a") then
    player.x = player.x - player.speed * dt
  end

  if love.keyboard.isDown("d") then
    player.x = player.x + player.speed * dt
  end
end

function love.draw()
--desenha objetos na tela.
    love.graphics.draw(sprites.background, 0, 0)
    love.graphics.draw(sprites.player, player.x, player.y)
end

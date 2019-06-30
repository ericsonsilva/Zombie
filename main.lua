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

  zombies = {}

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
--faz os zumbis andarem até o jogador, calculando o angulo onde o jogador está.
-- Usamos COS = cosseno e SIN = seno.
  for i,z in ipairs(zombies) do
    z.x = z.x + math.cos(zombie_player_angle(z)) * z.speed * dt
    z.y = z.y + math.sin(zombie_player_angle(z)) * z.speed * dt

    if distanceBetween(z.x, z.y, player.x, player.y) < 30 then
      for i,z in ipairs(zombies) do
        zombies[i] = nil
      end
    end
  end
end

function love.draw()
--desenha objetos na tela.
-- nil retorna valor nulo ou default para o parâmetro.
--getWidth e getHeight /2 mudam a referência do sprite pora o centro da imagem.
    love.graphics.draw(sprites.background, 0, 0)
    love.graphics.draw(sprites.player, player.x, player.y, player_mouse_angle(), nil, nil, sprites.player:getWidth()/2, sprites.player:getHeight()/2)
-- desenha zumbis na tela.
    for i, z in ipairs(zombies) do
      love.graphics.draw(sprites.zombie, z.x, z.y, zombie_player_angle(z), nil, nil, sprites.zombie:getWidth()/2, sprites.zombie:getHeight()/2)
    end
end
-- Função para girar o player em direção ao mouse. math.pi compensa a inverção de vamores em lovo.
function player_mouse_angle()
  return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX()) + math.pi
end
--faz zumbis olharem para jogador.
function zombie_player_angle(enemy)
  return math.atan2(player.y - enemy.y, player.x - enemy.x)
end

function spawnZombie()
  zombie = {}
  zombie.x = math.random(0, love.graphics.getWidth())
  zombie.y = math.random(0, love.graphics.getHeight())
  zombie.speed = 100
  table.insert(zombies, zombie)
end

function love.keypressed(key, scancode, isrepeat)
  if key == "space" then
    spawnZombie()
  end
end

-- Fórmula de cálculo de ditancia entre 2 objetos.
function distanceBetween(x1, y1, x2, y2)
  return math.sqrt((y2 - y1)^2 + (x2 - x1)^2)
end

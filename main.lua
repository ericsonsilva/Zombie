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
  bullets = {}
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
--usa função dsitancia para apagar zumbi quando colide.
    if distanceBetween(z.x, z.y, player.x, player.y) < 30 then
      for i,z in ipairs(zombies) do
        zombies[i] = nil
      end
    end
  end
-- bala sai do jogador
  for i,b in ipairs(bullets) do
    b.x = b.x + math.cos(b.direction) * b.speed * dt
    b.y = b.y + math.sin(b.direction) * b.speed * dt
  end
-- elimina as balas depois que elas saem da tela
  for i=#bullets,1,-1 do
    local b = bullets[i]
    if b.x < 0 or b.y< 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() then
      table.remove(bullets, i)
    end
  end
-- teste de colizão e remoção dos itens
  for i,z in ipairs(zombies) do
    for j,b in ipairs(bullets) do
      if distanceBetween(z.x, z.y, b.x, b.y) < 20 then
        z.dead = true
        b.dead = true
      end
    end
  end

  for i=#zombies, 1, -1 do
    local z = zombies[i]
    if z.dead == true then
      table.remove(zombies, i)
    end
  end

  for i=#bullets, 1, -1 do
    local b = bullets[i]
    if b.dead == true then
      table.remove(bullets, i)
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
    for i,z in ipairs(zombies) do
      love.graphics.draw(sprites.zombie, z.x, z.y, zombie_player_angle(z), nil, nil, sprites.zombie:getWidth()/2, sprites.zombie:getHeight()/2)
    end
--desenha bala na tela
    for i,b in ipairs(bullets) do
      love.graphics.draw(sprites.bullet, b.x, b.y, nil, 0.5, 0.5, sprites.bullet:getWidth()/2, sprites.bullet:getHeight()/2)
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
  zombie.x = 0
  zombie.y = 0
  zombie.speed = 100
  zombie.dead = false
-- zumbis spaunam fora da tela 
  local side = math.random(1, 4)

  if side == 1 then
    zombie.x = -30
    zombie.y = math.random(0, love.graphics.getHeight())
  elseif side == 2 then
    zombie.x = math.random(0, love.graphics.getWidth())
    zombie.y = -30
  elseif side == 3 then
    zombie.x = love.graphics.getWidth() + 30
    zombie.y = math.random(0, love.graphics.getHeight())
  else
    zombie.x = math.random(0, love.graphics.getWidth())
    zombie.y = love.graphics.getHeight() + 30
  end

  table.insert(zombies, zombie)
end

function spawnBullets()
  bullet = {}
  bullet.x = player.x
  bullet.y = player.y
  bullet.speed = 500
  bullet.direction = player_mouse_angle()
  bullet.dead = false
  table.insert(bullets, bullet)
end

function love.keypressed(key, scancode, isrepeat)
  if key == "space" then
    spawnZombie()
  end
end
--detecta que o botão esquedo do mouse foi apertado
function love.mousepressed(x, y, button, isTouch)
  if button == 1 then
    spawnBullets()
  end
end

-- Fórmula de cálculo de ditancia entre 2 objetos.
function distanceBetween(x1, y1, x2, y2)
  return math.sqrt((y2 - y1)^2 + (x2 - x1)^2)
end

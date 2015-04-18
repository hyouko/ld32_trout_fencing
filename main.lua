require "util"

-- Pseudo-object definitions

-- Scripting for levels, etc.

function love.load()	
	gamestate = "Title"
	
	width, height = love.graphics.getDimensions()
	
	load_images()
	load_sounds()
	
	-- Camera coords
	cam_x = 0.0
	cam_y = 0.0
	
	-- Camera velocity
	cam_vx = 0.0
	cam_vy = 0.0
	
	-- Control flags
	press_up =  false
	press_down = false
	press_left = false
	press_right = false
	
	zoom_in = false
	zoom_out = false
	
	scale_factor = 1.0
	
	-- Universal timer
	ticks = 0
	
	zoom_timer = 0
	
	fps = 60
end

function load_sounds()

end

function load_images()
	
	font_small = love.graphics.newFont('gfx/driftfont_3.ttf', 26)
	font_big = love.graphics.newFont('gfx/driftfont_3.ttf', 34)
	font_huge = love.graphics.newFont('gfx/driftfont_3.ttf', 200)
	
	love.graphics.setFont(font_small)
end

function render_sprites()
	sprite = sprites
	while sprite do
		
		if is_visible(sprite) then	
			love.graphics.setColor(255, 255, 255)
			love.graphics.draw(sprite.img,
				sx,
				sy,
				sprite.r, sprite.s * scale_factor, sprite.s * scale_factor, 64, 64)
		end
					
		sprite = sprite.next
	end
	
end

function love.draw()

	love.graphics.setColor(10, 100, 210)
	love.graphics.rectangle('fill', 0, 0, width, height)
	
	if gamestate == "Title" then
		
		love.graphics.setFont(font_huge)

		fake_bold_print("Ludum Dare 32 - An Unconventional Weapon", width / 3 + 12, height / 3 + 240,  1)
		fake_bold_print("(c) Chris Drouin, 2015", width / 3 + 12, height / 3 + 260,  1)
		
	elseif gamestate == "Boating" then
			
		render_sprites()
			
	elseif gamestate == "Fishing" then
		
		-- Render all sprites
		render_sprites()
				
		if debug_on then
			love.graphics.setColor(250, 250, 250)
			love.graphics.print("FPS: " .. fps, 20, 20)
			love.graphics.print("CamX: " .. math.ceil(cam_x  * 10) / 10, 20, 40)
			love.graphics.print("CamY: " .. math.ceil(cam_y  * 10) / 10, 160, 40)
		end
				
	end
	
end

function love.update(dt)
	ticks = ticks + dt
	
	mouse_x = love.mouse.getX()
	mouse_y = love.mouse.getY()
	
	if gamestate == "Title" then
		
	elseif gamestate == "Boating" then
		
	elseif gamestate == "Fishing" then
		
		for t = 0, math.min(4 / 60, dt), 1 / 60.0 do
			cam_x = cam_x + cam_vx / scale_factor
			cam_y = cam_y + cam_vy / scale_factor
			
			--Sort sprite objects
			sprites = mergeSort(sprites, sprite_compare)
			
			sprite = sprites
			i = 1
			while sprite do
				
				-- Check for collisions with other raft sprites
				if sprite.cleanup ~= true then
					other = sprites
					
					while other do
					
						-- Identify collision distance between sprites
						col_dist = dist(sprite.x, sprite.y, other.x, other.y)

					end
				
				-- Run sprite controller
				if sprite.controller ~= nil then
					sprite.controller(sprite, 1 / 60)
				end

				sprite.order = i
				i = i + 1
				sprite = sprite.next
			end
			
			sprites = cleanup_sprites(sprites)
			
		end
	end
	
	fps = math.ceil((1 / dt + fps * 29) / 3) / 10
end

function love.keypressed(key)

end

function love.keyreleased(key)
	
end

function love.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)

end
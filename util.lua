function dist(x1, y1, x2, y2)
	return math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
end

function sprite_dist(a, b)
	return dist(a.x, a.y, b.x, b.y)
end

function sprite_angle(a, b)
	return angle(a.x, a.y, b.x, b.y)
end

function angle(x1, y1, x2, y2)
	return math.atan2((y1 - y2), (x1 - x2))
end

function angle_avg(a1, a2, a1_weight)
	return math.atan2(math.sin(a1) * a1_weight + math.sin(a2) * (1 - a1_weight), math.cos(a1) * a1_weight + math.cos(a2) * (1 - a1_weight))
end

function to_screenspace(x, y)
	return (x - cam_x) * scale_factor, (y - cam_y) * scale_factor
end

function to_worldspace(x, y)
	return x / scale_factor + cam_x, y / scale_factor + cam_y
end

function val_clamp(val, min, max)
	return math.min(max, math.max(min, val))
end

function normalize(x, y)
	length = dist(0, 0, x, y)
	return x / length, y / length
end

function dot_prod(x1, y1, x2, y2)
	return x1 * x2 + y1 * y2
end

function fake_bold_print(text, x, y, rpt)
	
	for i = 0, rpt do
		for ii = 0, rpt do
			love.graphics.print(text, x + i, y + ii)
		end
	end
end

function outline_print(text, x, y)
	
	r, g, b, a = love.graphics.getColor()
	
	love.graphics.setColor(10, 20, 100)
	
	for i = 0, 2 do
		for ii = 0, 2 do
			love.graphics.print(text, x + i, y + ii)
		end
	end
	
	love.graphics.setColor(r, g, b)
	
	love.graphics.print(text, x + 1, y + 1)
end

function fake_bold_printf(text, x, y, limit, rpt)
	
	for i = 0, rpt do
		for ii = 0, rpt do
			love.graphics.printf(text, x + i, y + ii, limit)
		end
	end
end



-- merge sort, for z-ordering
function mergeSort(list, compare_func)
	insize = 1

	if list == nil then return nil end

	while 1 do
		p = list
		nmerges = 0
		tail = nil
		list = nil

		while p ~= nil do
			nmerges = nmerges + 1
			q = p
			psize = 0
			for i = 1, insize, 1 do
				psize = psize + 1
				q = q.next
				if not(q) then break end
			end 
			qsize = insize
			while (psize > 0 or (qsize > 0 and q)) do
				
				if psize == 0 then
					e = q
					q = q.next
					qsize  = qsize - 1
				elseif (qsize == 0 or not(q)) then
					e = p
					p = p.next
					psize = psize- 1
				elseif compare_func(p, q) then
					e = p
					p = p.next
					psize = psize - 1
				else
					e = q
					q = q.next
					qsize = qsize - 1
				end
				if (tail) then
					tail.next = e
				else
					list = e
				end
				tail = e
			end
			p = q
		end

		tail.next = nil

		if nmerges <= 1 then
			return list
		end
		
		insize = insize * 2
	end
end

function sprite_compare(p, q)
	return (p.y <= q.y and p.layer == q.layer) or (p.layer < q.layer)
end


function is_visible(sprite)
	sx, sy = to_screenspace(sprite.x, sprite.y)
	
	return (sx >= -128 * scale_factor and sx <= (width + 128 * scale_factor) and sy >= -128 * scale_factor and sy <= (height + 128 * scale_factor))
end

function within_box(x1, y1, x2, y2, w, h)
	return (x1 >= x2 and x1 <= x2 + w and y1 >= y2 and y1 <= y2 + h)
end

function cleanup_sprites(list)
	sprite = list
	last = nil
	
	while sprite do
		
		if sprite.cleanup then
			if last == nil then
				list = sprite.next
			else
				last.next = sprite.next
			end
		else
			last = sprite
		end
		
		sprite = sprite.next
	end
	
	return list
end
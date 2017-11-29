--[[

-- Colored beds - common functions

--]]
      


-------------------------------------------------
--
--  check_buildpos
--
--  helper to test if node can be placed at pos
-------------------------------------------------
colored_beds.check_buildpos = function ( pos, user, check_buildable )
   
      local node = minetest.get_node_or_nil(pos)
      
      if check_buildable ~= false  then
         local node_def = node and minetest.registered_nodes[node.name]
     
         if not node_def or not node_def.buildable_to then
            return false
         end
      end
      if minetest.is_protected(pos, user:get_player_name()) and
            not minetest.check_player_privs(user, "protection_bypass") then
         minetest.record_protection_violation(pos, user:get_player_name())
      return false
   end
   return true
end


--================================================================
--
--  !! HARDCODED COLOR NAMES
--
--  color names (hopefully never changed in unified dyes)
--   
--   
-------------------------------------------------
colored_beds.hues13 = {
   "red",
   "orange",
   "yellow",
   "lime",
   "green",
   "aqua",
   "cyan",
   "skyblue",
   "blue",
   "violet",
   "magenta",
   "redviolet",
   "grey"
}

-------------------------------------------------
--
--  palette_name
--
-- returns name of unifieddyes palette for 'colorfacedir' nodes
-------------------------------------------------
colored_beds.palette_name = function(color)
   return "unifieddyes_palette_"..color.."s.png"
end

        
-------------------------------------------------
--
--  base_color
--
-- returns base color name for 'colorfacedir' nodes
-------------------------------------------------
colored_beds.base_color = function(n)
   return n and colored_beds.hues13[n] or "grey"
end
   

-- Colord beds - beds for unified dyes
--
--
-- Library functions to define beds
--
--



-------------------------------------------------
--
--  on_place_small
--
--  places the normal bed (bottom part)
-------------------------------------------------
colored_beds.on_place_small = function(itemstack, placer, pointed_thing)

   local smalldef = minetest.registered_nodes[itemstack:get_name()]
   local count = itemstack:get_count()
   
   -- place bottom part of normal bed
   local i = ItemStack( itemstack )
   i:set_name( smalldef.bed_bottom )

   local j = colored_beds.on_place_bottom( i, placer, pointed_thing )
         
   -- if placed remove from original item stack also
   if  j:get_count() < count  then
      itemstack:take_item( count - j:get_count() ) 
   end
   
   return itemstack
end


-------------------------------------------------
--
--  on_place_bottom
--
-- places bottom part:
--   test if room for top part, call then orignal on_place 
-------------------------------------------------
colored_beds.on_place_bottom = function(itemstack, placer, pointed_thing)
   -- typical start of on_place(): get position and test for player sneak
   local under = pointed_thing.under
   local above = pointed_thing.above
   local unode = minetest.get_node(under)
   local udef = minetest.registered_nodes[unode.name]
         
   -- sneak test
   if udef and udef.on_rightclick and
          not (placer and placer:get_player_control().sneak) then
      return udef.on_rightclick(under, unode, placer, itemstack, pointed_thing) or itemstack
   end

   -- calculate pos of bottom part
   local bottom_pos
   if udef and udef.buildable_to then
      bottom_pos = under
   else
      bottom_pos = above
   end

   -- check  if placing of top part would be allowed
   local dir = minetest.dir_to_facedir(placer:get_look_dir())
   local top_pos = vector.add(bottom_pos, minetest.facedir_to_dir(dir))
   if not colored_beds.check_buildpos(top_pos, placer) then
      return itemstack
   end

   -- ok, allowed to place top part, so place bottom part first
   local bottom_name = itemstack:get_name()
   local bottom_def = minetest.registered_nodes[bottom_name]

   -- place bottom calls node 'on_place' default implementation
   -- will create top node later on in on_construct() callback
   if getmetatable(bottom_def) and getmetatable(bottom_def).__index and type(getmetatable(bottom_def).__index) == "table" then
         return getmetatable(bottom_def).__index.on_place(itemstack, placer, pointed_thing)
   end
   print("colored_beds:on_place_bottom(): Oops, this should not happen!")
   return core.item_place(itemstack, placer, pointed_thing) -- last resort...
end

-------------------------------------------------
--
--  on_construct_bottom
--
-- creates top node (position has been tested before)
-------------------------------------------------
colored_beds.on_construct_bottom = function(pos)
   local meta = minetest.get_meta(pos)
   local node = minetest.get_node(pos)
   
   local nodedef = minetest.registered_nodes[node.name]
   if not nodedef then return end
   
   local dir = minetest.facedir_to_dir(node.param2)
   local top_pos = vector.add(pos, dir)
   minetest.set_node( top_pos, { name = nodedef.bed_top, param2 = node.param2 } )
end


-------------------------------------------------
--
--  after-destruct
--  remove other node (top or buttom) of bed
-------------------------------------------------
colored_beds.after_destruct = function(pos, oldnode)
   local other
   local b
   local dir = minetest.facedir_to_dir(oldnode.param2)
   local n = minetest.get_node_group( oldnode.name, "bed" )
   if n == 2 then
      other = vector.subtract(pos, dir)
      b = 1
   elseif n == 1 then
      other = vector.add(pos, dir)
      b = 2
   end

   if other then
      local other_node = minetest.get_node(other)
      
      if other_node and minetest.get_node_group( other_node.name, "bed" ) == b and oldnode.param2 == other_node.param2 then
         minetest.remove_node(other)
         minetest.check_for_falling(other)
      end
   end
end

-------------------------------------------------
--
--  on_rotate
--  called with pos of bottom node
-------------------------------------------------
colored_beds.on_rotate_bottom = function(pos, node, user, mode, new_param2)
         local dir = minetest.facedir_to_dir(node.param2)
         local top_pos = vector.add(pos, dir)
         local top_node = minetest.get_node_or_nil(top_pos)
         
         -- check if node at top position is correct one
         if not top_node or not minetest.get_item_group(top_node.name, "bed") == 2 or
               not node.param2 == top_node.param2 then
            return false -- no rotation
         end
         
         -- are we allowed to change top node?
         if not colored_beds.check_buildpos( top_pos, user, false ) then
            return false -- no rotation
         end
         
         -- only rotate
         if mode ~= screwdriver.ROTATE_FACE then
            return false -- no rotation
         end
         
         -- new position of top node
         local new_top_pos = vector.add(pos, minetest.facedir_to_dir(new_param2))
         -- are we allowed to change new top position?
         if not colored_beds.check_buildpos( new_top_pos, user ) then
            return false -- no rotation
         end
         
         -- do the rotate for top node: create new top node and remove old top
         minetest.set_node(new_top_pos, {name = top_node.name, param2 = new_param2})
         minetest.remove_node(top_pos)
         
         return -- return nil: continue rotating bottom node
      end
      
-------------------------------------------------
--
--  on_punch
--  -- recolor top node (bottom node done by caller)
-------------------------------------------------
colored_beds.on_punch_bottom = function(pos, node, player, pointed_thing)
         -- punch top node
         local dir = minetest.facedir_to_dir(node.param2)
         local i = player:get_wielded_item()     
         local p = vector.add(pos,dir)
         local pt =
         {
            type  = pointed_thing.type,
            above = p, -- set above/under to pos of top
            under = p, 
            ref   = pointed_thing.ref,
         }
         unifieddyes.on_use(i, player, pt)    
         
         -- reset meta dye string of top - we use only one dye per bed
         local meta = minetest.get_meta(p)
         meta:set_string("dye",nil)   -- remove dye meta entry for top node
         -- reset meta dye string of bottom - no dye shall be returned on recoloring
         meta = minetest.get_meta(pos)
         meta:set_string("dye",nil)   -- remove dye meta entry for bottom node
         
         return false  -- continue punch bottom
      end

      

-------------------------------------------------
--
--  register_bed
--
-- parameter: name, definition-table    
--       
-- definition-table contains:     
--    description
--    tiles: list of tile images which will be colorized
--       bottom = { ... }
--       top = { ... }
--       small = { ... }
--    },
--    overlay_tiles: list of overlays not colorized
--       bottom = { ... }
--       top = { ... }
--       small = { ... }
--    },
--    nodebox: nodeboxes for bottom, top and small
--    selectionbox: selection bxes for bottom and small
--    recipe
--
-------------------------------------------------

colored_beds.register_bed = function(name, def)
   
for _, color in ipairs(colored_beds.hues13) do

   minetest.register_node(name .. "_bottom_"..color, {
      description = def.description.."_"..color,
      -- don't use inventory images as they are ugly using palettes and overlays
--       inventory_image = def.inventory_image,
--       wield_image = def.wield_image,
      drawtype = "nodebox",
      tiles = def.tiles.bottom,
      overlay_tiles = def.overlay_tiles.bottom,
      paramtype = "light",
      paramtype2 = "colorfacedir",
      palette = colored_beds.palette_name(color),
      is_ground_content = false,
      -- stack_max = 1,  -- not used in item stacks (uses small instead)
      groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, bed = 1, ud_param2_colorable = 1, not_in_creative_inventory = 1},
      bed_top = name .. "_top_"..color,
      bed_bottom = name .. "_bottom_"..color,
      sounds = def.sounds or default.node_sound_wood_defaults(),
      node_box = {
         type = "fixed",
         fixed = def.nodebox.bottom,
      },
      selection_box = {
         type = "fixed",
         fixed = def.selectionbox.bottom,
      },

      on_place = colored_beds.on_place_bottom,
      on_construct = colored_beds.on_construct_bottom,
      after_destruct = colored_beds.after_destruct,
      on_rotate = colored_beds.on_rotate_bottom,
      on_punch = colored_beds.on_punch_bottom,
      
      on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
         beds.on_rightclick(pos, clicker)
         return itemstack
      end,

      -- drop small bed to get a nicer inventory image
      drop = {
            items = {
                {items = {name.."_small_"..color}, inherit_color = true },
            }
      }
   })

   minetest.register_node(name .. "_top_"..color, {
      description = def.description.."_"..color.." (top)",
      drawtype = "nodebox",
      tiles = def.tiles.top,
      overlay_tiles = def.overlay_tiles.top,
      paramtype = "light",
      paramtype2 = "colorfacedir",
      palette = colored_beds.palette_name(color),
      is_ground_content = false,
      pointable = false,
      groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, bed = 2, ud_param2_colorable = 1, not_in_creative_inventory = 1},
      bed_top = name .. "_top_"..color,
      bed_bottom = name .. "_bottom_"..color,
      sounds = def.sounds or default.node_sound_wood_defaults(),
      node_box = {
         type = "fixed",
         fixed = def.nodebox.top,
      },
      after_destruct = colored_beds.after_destruct,
   })

   -- "small" version used as nice place holder for inventory/drops
   local s_groups
   if color == colored_beds.base_color() then -- show only base color in creative inventory
      s_groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, bed = 3, ud_param2_colorable = 1}
   else
      s_groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, bed = 3, ud_param2_colorable = 1, not_in_creative_inventory = 1 }
   end
   minetest.register_node(name .. "_small_"..color, {
      description = def.description,
      drawtype = "nodebox",
      tiles = def.tiles.small,
      overlay_tiles = def.overlay_tiles.small,
      paramtype = "light",
      paramtype2 = "colorfacedir",
      palette = colored_beds.palette_name(color),
      is_ground_content = false,
      -- stack_max = 1,  -- allow stacking 
      groups = s_groups,
      bed_top = name .. "_top_"..color,
      bed_bottom = name .. "_bottom_"..color,
      sounds = def.sounds or default.node_sound_wood_defaults(),
      node_box = {
         type = "fixed",
         fixed = def.nodebox.small,
      },
      selection_box = {
         type = "fixed",
         fixed = def.selectionbox.small,
      },
      on_place = colored_beds.on_place_small,
   })

  end -- for color

  -- alias "small" node for name
  minetest.register_alias(name, name .. "_small_"..colored_beds.base_color())
  -- register recipe for base colored node
  minetest.register_craft({
      output = name,
      recipe = def.recipe
   })
      
end -- register_bed
   

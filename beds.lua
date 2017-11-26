-- Colored beds - Bed definitions 
-- 
-- 


--------------------------------------------------------------------------------------------
-- Fancy shaped bed

colored_beds.register_bed("colored_beds:fancy_bed", {
   description = "Fancy Bed",
   tiles = {
      bottom = {
         "wool_white.png^[transformR90",
         "default_wood.png",
         "wool_white.png",
         "wool_white.png^[transformFX",
         "wool_white.png",
         "wool_white.png^[transformR90",
      },
      top = {
         "wool_white.png^[transformR90",
         "wool_white.png",
         "wool_white.png",
         "wool_white.png^[transformFX",
         "wool_white.png",
         "wool_white.png^[transformR90",
      },
      small = {
         "wool_white.png^[transformR90",
         "default_wood.png",
         "wool_white.png",
         "wool_white.png^[transformFX",
         "wool_white.png",
         "wool_white.png^[transformR90",
      },
   },
   overlay_tiles = {
      bottom = {
         { name = "colored_beds_fancybed_bottom_top.png",  color = "white" },
         { name = "default_wood.png", color = "white" },
         { name = "colored_beds_fancybed_bottom_side.png", color = "white" },
         { name = "colored_beds_fancybed_bottom_side.png^[transformFX", color = "white" },
         { name = "default_wood.png", color = "white" },
         { name = "colored_beds_fancybed_bottom_foot.png", color = "white" },
      },
      top = {
         { name = "colored_beds_fancybed_top_top.png", color = "white" },
         { name = "default_wood.png", color = "white" },
         { name = "colored_beds_fancybed_top_side.png", color = "white" },
         { name = "colored_beds_fancybed_top_side.png^[transformFX", color = "white" },
         { name = "colored_beds_fancybed_top_head.png", color = "white" },
         { name = "default_wood.png", color = "white" },
      },
      small = {
         { name = "colored_beds_fancysmall_top.png", color = "white" },
         { name = "default_wood.png", color = "white" },
         { name = "colored_beds_fancysmall_side.png", color = "white" },
         { name = "colored_beds_fancysmall_side.png^[transformFX", color = "white" },
         { name = "colored_beds_fancysmall_head.png", color = "white" },
         { name = "colored_beds_fancysmall_foot.png", color = "white" },
      },
   },
   nodebox = {
      bottom = {
         {-0.5, -0.5, -0.5, -0.375, -0.065, -0.4375},
         {0.375, -0.5, -0.5, 0.5, -0.065, -0.4375},
         {-0.5, -0.375, -0.5, 0.5, -0.125, -0.4375},
         {-0.5, -0.375, -0.5, -0.4375, -0.125, 0.5},
         {0.4375, -0.375, -0.5, 0.5, -0.125, 0.5},
         {-0.4375, -0.3125, -0.4375, 0.4375, -0.0625, 0.5},
      },
      top = {
         {-0.5, -0.5, 0.4375, -0.375, 0.1875, 0.5},
         {0.375, -0.5, 0.4375, 0.5, 0.1875, 0.5},
         {-0.5, 0, 0.4375, 0.5, 0.125, 0.5},
         {-0.5, -0.375, 0.4375, 0.5, -0.125, 0.5},
         {-0.5, -0.375, -0.5, -0.4375, -0.125, 0.5},
         {0.4375, -0.375, -0.5, 0.5, -0.125, 0.5},
         {-0.4375, -0.3125, -0.5, 0.4375, -0.0625, 0.4375},
      },
      
      small = {
         {-0.25, -0.5, 0.46875, -0.1875, -0.15625, 0.5},
         {0.1875, -0.5, 0.46875, 0.25, -0.15625, 0.5},
         {-0.25, -0.25, 0.46875, 0.25, -0.1875, 0.5},
         {-0.25, -0.4375, 0.46875, 0.25, -0.3125, 0.5},
         {-0.25, -0.4375, -0.5, -0.21875, -0.3125, 0.5},
         {0.21875, -0.4375, -0.5, 0.25, -0.3125, 0.5},
         {-0.21875, -0.40625, -0.46875, 0.21875, -0.28125, 0.46875},
         {-0.25, -0.5, -0.5, -0.1875, -0.28125, -0.46875},
         {0.1875, -0.5, -0.5, 0.25, -0.28125, -0.46875},
         {-0.25, -0.4375, -0.5, 0.25, -0.3125, -0.46875},
      },      
   },
   selectionbox = {
      bottom = { -0.5, -0.5, -0.5, 0.5, 0.06, 1.5},
      small = { -0.25, -0.5, -0.5, 0.25, -0.15625, 0.5},
   },
   recipe = {
      {"", "", "group:stick"},
      {"group:wool", "group:wool", "group:wool"},
      {"group:wood", "group:wood", "group:wood"},
   },
})
-- compatibility
minetest.register_alias_force( "beds:fancy_bed_bottom", "colored_beds:fancy_bed_bottom_grey" )
minetest.register_alias_force( "beds:fancy_bed_top", "colored_beds:fancy_bed_top_grey" )


minetest.register_craft({
    output = minetest.itemstring_with_palette("colored_beds:fancy_bed_small_red", 128),
    recipe = {
        {"", "", "group:stick"},
        {"wool:red", "wool:red", "wool:white"},
        {"group:wood", "group:wood", "group:wood"},
    },
})        

--------------------------------------------------------------------------------------------
-- Simple shaped bed

colored_beds.register_bed("colored_beds:bed", {
   description = "Colored Bed",
   tiles = {
      bottom = {
         "wool_white.png^[transformR90",
         "wool_white.png",
         "wool_white.png",
         "wool_white.png^[transformfx",
         "wool_white.png",
         "wool_white.png^[transformR90"
      },
      top = {
         "wool_white.png^[transformR90",
         "wool_white.png",
         "wool_white.png",
         "wool_white.png^[transformfx",
         "wool_white.png",
         "wool_white.png^[transformR90",
      },
      small = {
         "wool_white.png^[transformR90",
         "wool_white.png",
         "wool_white.png",
         "wool_white.png^[transformfx",
         "wool_white.png",
         "wool_white.png^[transformR90",
      },
   },
   overlay_tiles = {
      bottom = {
         "",
         { name = "default_wood.png", color = "white" },
         { name = "colored_beds_bed_bottom_side.png", color = "white" },
         { name = "colored_beds_bed_bottom_side.png^[transformfx", color = "white" },
         "",
         { name = "colored_beds_bed_bottom_foot.png", color = "white" },
      },
      top = {
         { name = "colored_beds_bed_top_top.png^[transformR90", color = "white" },
         { name = "default_wood.png", color = "white" },
         { name = "colored_beds_bed_top_side.png", color = "white" },
         { name = "colored_beds_bed_top_side.png^[transformfx", color = "white" },
         { name = "colored_beds_bed_top_head.png", color = "white" },
         "",
      },
      small = {
         { name = "colored_beds_smallbed_top.png^[transformR90", color = "white" },
         { name = "default_wood.png", color = "white" },
         { name = "colored_beds_smallbed_side.png", color = "white" },
         { name = "colored_beds_smallbed_side.png^[transformfx", color = "white" },
         { name = "colored_beds_smallbed_head.png", color = "white" },
         { name = "colored_beds_smallbed_foot.png", color = "white" },
      },
   },
   nodebox = {
      bottom = {-0.5, -0.5, -0.5, 0.5, 0.06, 0.5},
      top = {-0.5, -0.5, -0.5, 0.5, 0.06, 0.5},
      small = {-0.25, -0.5, -0.5, 0.25, -0.22, 0.5},
   },
   selectionbox = {
      bottom = { -0.5, -0.5, -0.5, 0.5, 0.06, 1.5},
      small = { -0.25, -0.5, -0.5, 0.25, -0.22, 0.5},
   },
      recipe = {
         {"group:wool", "group:wool", "group:wool"},
         {"group:wood", "group:wood", "group:wood"}
      },
})

-- compatibility
minetest.register_alias_force( "beds:bed_bottom", "colored_beds:bed_bottom_blue" )
minetest.register_alias_force( "beds:bed_top", "colored_beds:bed_top_blue" )

minetest.register_craft({
    output = minetest.itemstring_with_palette("colored_beds:bed_small_red", 128),
    recipe = {
        {"wool:red", "wool:red", "wool:white"},
        {"group:wood", "group:wood", "group:wood"},
    },
})        

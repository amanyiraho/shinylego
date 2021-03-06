source("0_Functions.R")
library(profvis)

#This will take a few minutes to run

img_import <- readJPEG("Images/shiny.jpg")
img_scale <- scale_image(img_import, c(48), warhol=c(3, 1, 2)) 
img_lego <- legoize(img_scale)
lego_mosaic <- collect_bricks(img_lego)

profvis({
  img_scale <- scale_image(img_import, c(48), warhol=c(3, 1, 2)) 
})

lego_mosaic <- readJPEG("Images/shiny.jpg") %>% 
  # scale_image(48) %>% #Single value for square,
  scale_image(c(48), warhol=c(3, 1, 2)) %>% # WIDE -  c(W, H) for rectangle
  legoize() %>% 
  collect_bricks() 

lego_mosaic %>% display_set()

#Instruction manual - calculate and graph
lego_mosaic %>% 
  generate_instructions(6) 
  
#Get summary of pieces
pieces <- lego_mosaic %>% table_pieces()

lego_mosaic %>% display_pieces()

#Save it
ggsave("LegoMosaic.png", device = "png", height = 5, width = 5)

#3D with rayshader ----
library(rayshader)

#mosaic_height is the elevation of the mosaic in LEGO plates... 3 plates =  1 LEGO brick
#Set highest_el = "dark" for dark bricks to be tallest... otherwise light bricks are tallest
lego_mosaic %>% 
  collect_3d(mosaic_height = 9) %>% 
  display_3d(fov=0,theta=-30,phi=30,windowsize=c(1000,800),zoom=0.75)


#display_3d() takes all inputs of rayshader::plot_3d() EXCEPT hillshade, heightmap, & zscale
# If you want to use plot_3d() instead, use the items 'threed_hillshade' and 'threed_elevation' in the collect_3d() output

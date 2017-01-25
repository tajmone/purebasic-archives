# ******************************************************************************
# *                                                                            *
# *                             PureBASIC Archives                             *
# *                                                                            *
# *                               /shared/sass/                                *
# *                                                                            *
# ******************************************************************************

# ==============================================================================
#                                custom settings                                
# ==============================================================================
cache_path = 'D:/Temp/sass'	# <== Move SASS cache out of repo's way
# sourcemap = true 			# <== 

# ==============================================================================
#                                General Settings                               
# ==============================================================================
require 'compass/import-once/activate'
# Require any additional compass plugins here.

# Set this to the root of your project when deployed:
http_path = "/"
css_dir = "../css"
sass_dir = ""
images_dir = "images"
javascripts_dir = "javascripts"

# To enable relative paths to assets via compass helper functions. Uncomment:
relative_assets = true

# ==============================================================================
#                              Conditional Settings                             
# ==============================================================================
# (can be overridden via the command line) one of:
# output_style = :expanded or :nested or :compact or :compressed
output_style = (environment == :production) ? :compressed : :nested

# Debugging comments showing original location of selectors:
line_comments = (environment == :production) ? false : true

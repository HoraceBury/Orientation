-- reads a source file and modifies it's placeholder values with a given string
-- source: the source filename (read from the resources directory)
-- dest: the target filename (can be the same) (written to the temporary directory)
-- params: table of tables of string pairs.. { { <placeholder>, <replacement value> }, ... }
function modifyTemplate( source, dest, params )
	local path = system.pathForFile( source, system.ResourcesDirectory )
	local file = io.open( path, "r" )
	local aline = file:read("*a")
	io.close( file )
	
	-- only do the string replacement if replacement parameters are supplied
	-- this function acts as a simple file copy if no replacement parameters are provided
	if (params) then
		for i=1, #params do
			local param = params[i]
			aline = aline:gsub( param[1], param[2] )
		end
	end
	
	path = system.pathForFile( dest, system.TemporaryDirectory )
	file = io.open( path, "w" )
	file:write( aline )
	io.close( file )
end

-- copy the web files to the directory the web overlay will read them from
modifyTemplate( 'generic.css', 'generic.css' ) -- colours and positions the html elements
modifyTemplate( 'jquery-1.6.4.min.js', 'jquery-1.6.4.min.js' ) -- jquery ajax library for easy javascript stuff
modifyTemplate( 'orient.js', 'orient.js' ) -- orients the body element of the page
modifyTemplate( 'main.html', 'main.html' ) -- the web page to be oriented properly
modifyTemplate( 'orientation.html', 'orientation.html' ) -- the page to retrieve using jquery ajax which indicates the correct orientation

-- updates the orientation file when the device is moved
function doOrient(event)
	-- copy the source orientation file to the temporary directory
	-- replace the string "{orientation}" in the file with the actual orientation from the system event
	-- the web page will using jquery ajax to read the value and alter the body element's rotation
	modifyTemplate( 'orientation.html', 'orientation.html', { { "{orientation}", event.type } } )
end

-- launch the orientation listening event
Runtime:addEventListener("orientation", doOrient)

-- open the browser overlay, using the temporary directory as the location to read web local files from
local options = { hasBackground=true, baseUrl=system.TemporaryDirectory }
native.showWebPopup( "main.html", options )

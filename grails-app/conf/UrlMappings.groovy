class UrlMappings {

	static mappings = {
		"/"(view:"/index")
		"/game/$playerName"(controller: "game", action: 'board')
		"/board/$action?"(controller: "board")
		"/a-long-journey"(controller: "write")
		"/long-write"(controller: "write", action: 'stuff')
		"/$userid"(view:"/index")
		"500"(view:'/error')
	}
}

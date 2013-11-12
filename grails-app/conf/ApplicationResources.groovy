modules = {
	application {
		resource url: 'js/application.js'
	}
	game {
		dependsOn 'jquery, grailsEvents'
		resource url: 'js/animation/easeljs-0.5.0.min.js'
	}
	faviconJs {
		resource url: 'js/favico-0.2.0.min.js'
	}
	board {
		dependsOn 'jquery, grailsEvents'
		resource url: 'js/easeljs-0.7.0.min.js'
		resource url: 'css/demoStyles.css'
	}
}
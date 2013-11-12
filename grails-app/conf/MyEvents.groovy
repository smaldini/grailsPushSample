import static reactor.event.selector.Selectors.*

includes = 'push'

doWithReactor = {
	reactor('browser') {


		ext 'browser', [
				R('sampleBro-.*'),
				'control',
				'move',
				'fire',
				'leave',
				'startDraw',
				'drawLine'
		]
	}

	reactor('grailsReactor'){
		ext 'browser', ['sleepBrowser']

		stream('sleepBrowser'){
			filter{
				println 'filtered'
				it.data == 'no'
			}
		}
	}
}

/**
 * @author Stephane Maldini
 */
class BoardController {

	def drawService

	def index(){}

	def replay(String id){
		log.info "replaying $id"
		drawService.replay(id)
		render 'ok'
	}

	def replayAll(){
		log.info 'replaying all'
		drawService.replayAll()
		render 'ok'
	}

	def clear(){
		log.info 'clear'
		drawService.clear()
		render 'ok'
	}
}

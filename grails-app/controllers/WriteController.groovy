/**
 * @author Stephane Maldini
 */
class WriteController {

	def index(){

	}


	def stuff(){
		event('sleep', 'no')
		redirect action: 'index'
	}
}

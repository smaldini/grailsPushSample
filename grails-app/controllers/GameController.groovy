/**
 * @author Stephane Maldini
 */
class GameController {

	def board(String playerName) {
		if (!playerName) {
			render 'Please use the following URL format: http://.../game/[Your user name]'
			return
		}
	}
}
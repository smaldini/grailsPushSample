package grailspushsample

import grails.transaction.Transactional
import reactor.spring.annotation.Selector

import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.CopyOnWriteArrayList

class DrawService {

	static transactional = false

	def captures = [:] as ConcurrentHashMap

	@Selector(reactor = "browser")
	void startDraw(Map data) {
		captures[data.id] = data
	}

	@Selector(reactor = "browser")
	void drawLine(Map data) {
		if (!captures[data.id]) return

		captures[data.id].traces = captures[data.id].traces ?: new CopyOnWriteArrayList<>()
		captures[data.id].traces << data
	}

	void replayAll() {
		for (entry in captures) {
			replay(entry.key)
		}
	}

	void clear() {
		captures.clear()
	}


	void replay(id) {
		def data = captures[id]
		if (!data) return

		event(key: 'startDraw', for: 'browser', data: data)
		for (trace in data.traces) {
			event(key: 'drawLine', for: 'browser', data: trace)
		}
	}
}

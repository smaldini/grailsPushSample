<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Drawing all together</title>

    <meta name="layout" content="simple"/>
    <r:require modules="board"/>

    <g:set var="generated_id" value="${UUID.randomUUID()}" />

    <r:script>
        window.grailsEvent = new grails.Events("${createLink(uri: "")}");

        var canvas, stage;
        var drawingCanvas;
        var title;
        var myId = "${generated_id}";

        var pens = {};
        var colors;
        var index;

        function init() {
            if (window.top != window) {
                document.getElementById("header").style.display = "none";
            }
            canvas = document.getElementById("myCanvas");
            index = 0;
            colors = ["#828b20", "#b0ac31", "#cbc53d", "#fad779", "#f9e4ad", "#faf2db", "#563512", "#9b4a0b", "#d36600", "#fe8a00", "#f9a71f"];

            //check to see if we are running in a browser with touch support
            stage = new createjs.Stage(canvas);
            stage.autoClear = false;
            stage.enableDOMEvents(true);

            createjs.Touch.enable(stage);
            createjs.Ticker.setFPS(24);

            drawingCanvas = new createjs.Shape();

            stage.addEventListener("stagemousedown", handleMouseDown);
            stage.addEventListener("stagemouseup", handleMouseUp);

            title = new createjs.Text("Touch and Move to draw", "36px Arial", "#777777");
            title.x = 300;
            title.y = 200;
            stage.addChild(title);

            stage.addChild(drawingCanvas);
            stage.update();
        }

        function stop() {
        }

        function startLine(id, color, stroke, x, y) {
            var oldPt = new createjs.Point(x, y);

            pens[id] = {
                color: color,
                stroke: stroke,
                oldPt: oldPt,
                oldMidPt: oldPt
            };
        }

        function handleMouseDown(event) {
            if (stage.contains(title)) {
                stage.clear();
                stage.removeChild(title);
            }
            var color = colors[(index++) % colors.length];
            var stroke = Math.random() * 30 + 10 | 0;

            startLine(myId, color, stroke, stage.mouseX, stage.mouseY );

            stage.addEventListener("stagemousemove", handleMouseMove);

            grailsEvent.send("startDraw", {id:myId, color: color, stroke: stroke, x:stage.mouseX, y:stage.mouseY});
        }

        function drawLine(id, x, y) {
            if (!pens[id]) return;

            var midPt = new createjs.Point(pens[id].oldPt.x + x >> 1, pens[id].oldPt.y + y >> 1);

            drawingCanvas.graphics.clear().
                    setStrokeStyle(pens[id].stroke, 'round', 'round').
                    beginStroke(pens[id].color).
                    moveTo(midPt.x, midPt.y).
                    curveTo(pens[id].oldPt.x, pens[id].oldPt.y, pens[id].oldMidPt.x, pens[id].oldMidPt.y);

            pens[id].oldPt.x = x;
            pens[id].oldPt.y = y;

            pens[id].oldMidPt.x = midPt.x;
            pens[id].oldMidPt.y = midPt.y;

            stage.update();
        }

        function handleMouseMove(event) {
            grailsEvent.send("drawLine", {id:myId, x:stage.mouseX, y:stage.mouseY});
            drawLine(myId, stage.mouseX, stage.mouseY);

        }

        function handleMouseUp(event) {
            stage.removeEventListener("stagemousemove", handleMouseMove);
        }

        init();

        grailsEvent.on('startDraw', function(data) {
            if(data.id && data.id != myId){
                startLine(data.id, data.color, data.stroke, data.x, data.y);
            }
        });

        grailsEvent.on('drawLine', function(data) {
            if(data.id && data.id != myId){
                drawLine(data.id, data.x, data.y);
            }
        });
    </r:script>
</head>

<body>
<header id="header" class="EaselJS">
    <h1><span class="text-product">Grails <strong>Events Push</strong></span> Whiteboard</h1>

    <p>This example demonstrates sharing canvas painting with others connected users</p>
</header>

<div style="margin:20px auto;text-align: center;">
    <canvas id="myCanvas" width="960" height="400"></canvas>
</div>

<g:remoteLink action="replayAll">replay all</g:remoteLink> |
<g:remoteLink action="clear" id="${generated_id}">clean</g:remoteLink> |

</body>
</html>
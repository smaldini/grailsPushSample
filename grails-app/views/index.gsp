<!doctype html>
<html>
<head>
<meta name="layout" content="main"/>
<title>Welcome to Grails</title>
<r:require modules="jquery, grailsEvents"/>
<style type="text/css" media="screen">
#status {
    background-color: #eee;
    border: .2em solid #fff;
    margin: 2em 2em 1em;
    padding: 1em;
    width: 12em;
    float: left;
    -moz-box-shadow: 0px 0px 1.25em #ccc;
    -webkit-box-shadow: 0px 0px 1.25em #ccc;
    box-shadow: 0px 0px 1.25em #ccc;
    -moz-border-radius: 0.6em;
    -webkit-border-radius: 0.6em;
    border-radius: 0.6em;
}

.ie6 #status {
    display: inline; /* float double margin fix http://www.positioniseverything.net/explorer/doubled-margin.html */
}

#status ul {
    font-size: 0.9em;
    list-style-type: none;
    margin-bottom: 0.6em;
    padding: 0;
}

#status li {
    line-height: 1.3;
}

#status h1 {
    text-transform: uppercase;
    font-size: 1.1em;
    margin: 0 0 0.3em;
}

#page-body {
    margin: 2em 1em 1.25em 18em;
}

h2 {
    margin-top: 1em;
    margin-bottom: 0.3em;
    font-size: 1em;
}

p {
    line-height: 1.5;
    margin: 0.25em 0;
}

#controller-list ul {
    list-style-position: inside;
}

#controller-list li {
    line-height: 1.3;
    list-style-position: inside;
    margin: 0.25em 0;
}

@media screen and (max-width: 480px) {
    #status {
        display: none;
    }

    #page-body {
        margin: 0 1em 1em;
    }

    #page-body h1 {
        margin-top: 0;
    }
}
</style>

<r:script>
    $(document).ready(function () {

      /*
       Register a grailsEvents handler for this window, constructor can take a root URL,
       a path to event-bus servlet and options. There are sensible defaults for each argument
       */
      window.grailsEvents = new grails.Events("${createLink(uri: '')}");

      function dataURItoBlob(dataURI) {
            // convert base64 to raw binary data held in a string
            // doesn't handle URLEncoded DataURIs
            var byteString = atob(dataURI.split(',')[1]);

            // separate out the mime component
            var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]

            // write the bytes of the string to an ArrayBuffer
            var ab = new ArrayBuffer(byteString.length);
            var ia = new Uint8Array(ab);
            for (var i = 0; i < byteString.length; i++) {
                ia[i] = byteString.charCodeAt(i);
            }

            // write the ArrayBuffer to a blob, and you're done
            return new Blob([ab], {type: mimeString});
        }


        //Another stupid sample

         window.URL = window.URL ||
            window.webkitURL        ||
            window.mozURL           ||
            window.msURL            ||
            window.oURL;
         navigator.getUserMedia  = navigator.getUserMedia ||
            navigator.webkitGetUserMedia ||
            navigator.mozGetUserMedia ||
            navigator.msGetUserMedia;

       var currentReceive;
       var currentReceiveTopic;
      $('#anotherReceive').change(function (event) {
        var channel = $('#to').val();
        if($(this).attr('checked')){
            var target = document.getElementById("target");
            var target2 = document.getElementById("target2");
            currentReceive = function (_stream) {
              var url= URL.createObjectURL(dataURItoBlob(_stream));
              target.onload = function() {
                 URL.revokeObjectURL(url);
              };
              target.src = url;
            };
            currentReceiveTopic = "sampleBro-"+channel;
            grailsEvents.on(currentReceiveTopic, currentReceive);
            grailsEvents.send("control", {user:window.userid, receive: channel});
        }else{
            if(!!currentReceive && !!currentReceiveTopic){
                grailsEvents.send("control", {user:window.userid, stopReceive: channel});
                grailsEvents.unregisterHandler(currentReceiveTopic, currentReceive);
            }
        }
      });

      $('#another').change(function (event) {

        var video = document.querySelector('video');
        var channel = $('#topic').val();

        if(!$(this).attr('checked')){
            clearTimeout(videoTimer);
            video.pause();
            if(!!window.localMediaStream){
                window.localMediaStream.stop();
            }
            URL.revokeObjectURL(video.src);
            grailsEvents.send("control", {user:window.userid, stopBroadcast: channel});
            return;
        }

         var onFailSoHard = function(e) {
           console.log('Reeeejected!', e);
         };

         var canvas = $("#canvas");
         var ctx = canvas.get()[0].getContext('2d');

       // Not showing vendor prefixes.


          if (navigator.getUserMedia) {
            navigator.getUserMedia({video: true}, function(stream) {
                window.localMediaStream = stream;
                video.src = URL.createObjectURL(stream);
            }, onFailSoHard);
          }

          grailsEvents.send("control", {user:window.userid, broadcast: channel});

           window.videoTimer = setInterval(
                function () {
                    ctx.drawImage(video, 0, 0, 320, 240);
                    var data = canvas.get()[0].toDataURL('image/jpeg', 1.0);

                    grailsEvents.send("sampleBro-"+channel, data);
            }, 100);

      });

      grailsEvents.on('control',function(data){
          if(data.broadcast) {
            $('#log').append("<li>User <i>"+data.user+"</i> <b>is broadcasting</b> to "+data.broadcast+"</li>")
          }else if(data.receive){
            $('#log').append("<li>User <i>"+data.user+"</i> <b>is receiving</b> from "+data.receive+"</li>")
          }else if(data.stopBroadcast){
            $('#log').append("<li>User <i>"+data.user+"</i> <b>has stopped broadcasting</b> to "+data.stopBroadcast+"</li>")
          }else if(data.stopReceive){
            $('#log').append("<li>User <i>"+data.user+"</i> <b>has stopped receiving</b> from "+data.stopReceive+"</li>")
          }

      });

      window.userid ="${params.userid ?: java.util.UUID.randomUUID().toString()}";
      $("#userid").html(userid);
    });
</r:script>

</head>

<body>
<a href="#page-body" class="skip"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>

<div id="status" role="complementary">
    <h1>Application Status</h1>
    <ul>
        <li>App version: <g:meta name="app.version"/></li>
        <li>Grails version: <g:meta name="app.grails.version"/></li>
        <li>JVM version: ${System.getProperty('java.version')}</li>
        <li>Reloading active: ${grails.util.Environment.reloadingAgentEnabled}</li>
        <li>Controllers: ${grailsApplication.controllerClasses.size()}</li>
        <li>Domains: ${grailsApplication.domainClasses.size()}</li>
        <li>Services: ${grailsApplication.serviceClasses.size()}</li>
        <li>Tag Libraries: ${grailsApplication.tagLibClasses.size()}</li>
    </ul>

    <h1>Installed Plugins</h1>
    <ul>
        <g:each var="plugin" in="${applicationContext.getBean('pluginManager').allPlugins}">
            <li>${plugin.name} - ${plugin.version}</li>
        </g:each>
    </ul>
</div>

<div id="page-body" role="main">
    <h1>Welcome to Grails <span id="userid" style='font-weight: bold;'></span></h1>

    <p>Congratulations, you are running the video broadcasting sample, you need to run an extreme recent browser to send images.
    but you still can receive ! just type a channel and check the box. Someone has to broadcast if you want to receive anything.</p>


    <p>BBC control :

    <p>Broadcast To : <input id='topic' type='text' value="1"/> <input id='another' class='button'
                                                                       type='checkbox'/> <br/>
        Receive From : <input id='to' type='text' value='1'/> <input id='anotherReceive' class='button'
                                                                     type='checkbox'/></p>

    <div>
        <video id="live" width="320" height="240" autoplay></video>
        <img id="target" style="display: inline;"/>

        <ul id="log"></ul>

        <div style='visibility:hidden;width:0; height:0;'><canvas width="320" id="canvas" height="240"
                                                                  style="display: inline;"></canvas>
        </div>
    </div>

</div>
</body>
</html>

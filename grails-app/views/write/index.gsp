<%--
  Created by IntelliJ IDEA.
  User: smaldini
  Date: 9/11/13
  Time: 9:51 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <title>Le test long</title>
    <meta name="layout" content="main"/>
    <r:require modules="jquery, grailsEvents" />
</head>
<body>
<r:script>
   window.grailsEvent = new grails.Events("${createLink(uri:"")}");
    grailsEvent.on('sleepBrowser', function(data) {
        $('#test').html(data);
    });
</r:script>
<div id="test"/>
<g:form controller="write" action="stuff">
    <g:submitButton name="long" />
</g:form>
</body>
</html>
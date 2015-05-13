<%-- 
    Document   : cors
    Created on : May 12, 2015, 5:43:38 PM
    Author     : focke
--%>

<%@tag description="CORS script" pageEncoding="UTF-8"%>

<script>
    function createCORSRequest(method, url) {
        var xhr = new XMLHttpRequest();
        if ("withCredentials" in xhr) {
            // XHR for Chrome/Firefox/Opera/Safari.
            xhr.open(method, url, true);
        } else if (typeof XDomainRequest != "undefined") {
            // XDomainRequest for IE.
            xhr = new XDomainRequest();
            xhr.open(method, url);
        } else {
            // CORS not supported.
            xhr = null;
        }
        return xhr;
    }

    // Make the actual CORS request.
    function makeCorsRequest(command) {
        var url = 'http://localhost:8888/?'+command;

        var xhr = createCORSRequest('GET', url);
        if (!xhr) {
            alert('CORS not supported');
            return;
        }

        // Response handlers.
        xhr.onload = function () {
            var text = xhr.responseText;
            alert('Command executed: ' + text);
        };

        xhr.onerror = function () {
            alert('Woops, there was an error making the request. Make sure your python script is running (rc=' + xhr.status + ')');
        };

        xhr.send();
    }
</script>

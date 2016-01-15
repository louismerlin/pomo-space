// Mabye later, for the moment let's focus on functionality !

post = function(url, data) {
  var postRequest = new XMLHttpRequest();
  postRequest.open('POST', url, true);
  postRequest.send(data);
}

// registering the fes out there

fetcher = function() {
  fes = document.getElementsByTagName("fe");

  for (fe of fes) {
    var getRequest = new XMLHttpRequest();
    getRequest.open('GET', fe.getAttribute("url"), true);

    getRequest.onload = function() {
      if (getRequest.status >= 200 && getRequest.status < 400) {
        // Success!
        //data = JSON.parse(request.responseText);
        fe.innerHTML = getRequest.responseText;
      } else {
        console.log("error from server");
        // We reached our target server, but it returned an error

      }
    };

    getRequest.onerror = function() {
      // There was a connection error of some sort
      console.log('connection error');
    };

    getRequest.send();
  }
}

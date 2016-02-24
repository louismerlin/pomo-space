post = function(url, data) {
  var postRequest = new XMLHttpRequest();
  postRequest.open('POST', url, true);
  postRequest.send(data);
}

// registering the fes out there

fetcher = function(url, func) {
  var getRequest = new XMLHttpRequest();
  getRequest.open('GET', url, true);
  getRequest.onerror = function() {
    // There was a connection error of some sort
    console.log('connection error');
  };
  getRequest.onload = function() {
    if (getRequest.status >= 200 && getRequest.status < 400) {
      func(JSON.parse(getRequest.responseText));
    } else {
      // We reached our target server, but it returned an error
      console.log("error from server");
    }
  };
  getRequest.send();
}

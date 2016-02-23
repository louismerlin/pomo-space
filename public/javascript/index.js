var ctx = document.getElementById("pomodoro_time").getContext("2d");

var data = {
    labels: "",
    datasets: [
        {
            label: "Pomodoros",
            fillColor: "rgba(220,220,220,0.0)",
            strokeColor: "rgba(220,220,220,2)",
            pointColor: "rgba(220,220,220,1)",
            pointStrokeColor: "#fff",
            pointHighlightFill: "#fff",
            pointHighlightStroke: "rgba(220,220,220,1)",
            data: [0,0,0,0,0,0,0]
        },
    ]
};

var options = {

  // Boolean - Whether to animate the chart
  animation: false,

  // Boolean - If we want to override with a hard coded scale
  scaleOverride: true,

  // Boolean - whether or not the chart should be responsive and resize when the browser does.
  responsive: true,

  // ** Required if scaleOverride is true **
  // Number - The number of steps in a hard coded scale
  scaleSteps: 1,
  // Number - The value jump in the hard coded scale
  scaleStepWidth: 1,
  // Number - The scale starting value
  scaleStartValue: 0,

};

var tagsDiv = document.getElementById("tags");
populateTags = function(tags){
  u = document.createElement('ul')
  tagsDiv.appendChild(u);
  for(i in tags){
   d = document.createElement('li');
   d.innerHTML = tags[i];
   u.appendChild(d);
  }
};

fetcher("/tags", populateTags);

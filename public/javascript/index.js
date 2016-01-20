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

};

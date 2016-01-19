var ctx = document.getElementById("pomodoro_time").getContext("2d");

var data = {
    labels: "",
    datasets: [
        {
            label: "Pomodoros",
            fillColor: "rgba(220,220,220,0.3)",
            strokeColor: "rgba(220,220,220,2)",
            pointColor: "rgba(220,220,220,1)",
            pointStrokeColor: "#fff",
            pointHighlightFill: "#fff",
            pointHighlightStroke: "rgba(220,220,220,1)",
            data: [6, 5, 8, 8, 5, 5, 4]
        },
    ]
};

var options = {

  // Boolean - Whether to animate the chart
  animation: false,

};

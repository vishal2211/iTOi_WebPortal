var ready;
ready = function() {
  if ($("body#home-index").length > 0) {

      var d1, d2, data, chartOptions

      $.get("/api/v1/recordings/stats", function (data) {

          data_sets = []

          _.each(data.stats, function (recording) {
              flot_data = []
              _.each(recording.data, function (d) {
                  flot_data.push([new Date(d.date), d.count])
              })
              data_sets.push({label: recording.recording.title, data: flot_data})
          })

          chartOptions = {
              xaxis: {
                  min: (new Date(data.start)).getTime(),
                  max: (new Date(data.end)).getTime(),
                  mode: "time",
                  tickSize: [4, "day"],
                  tickLength: 0
              },
              yaxis: {},
              series: {
                  lines: {
                      show: true,
                      fill: false,
                      lineWidth: 3
                  },
                  points: {
                      show: true,
                      radius: 3,
                      fill: true,
                      fillColor: "#ffffff",
                      lineWidth: 2
                  }
              },
              grid: {
                  hoverable: true,
                  clickable: false,
                  borderWidth: 0
              },
              legend: {
                  show: false
              },
              tooltip: true,
              tooltipOpts: {
                  content: '%s: %y'
              },
              colors: mvpready_core.layoutColors
          }

          var holder = $('#line-chart')

          if (holder.length) {
              $.plot(holder, data_sets, chartOptions)
          }


      })

  }

}

$(document).ready(ready);
$(document).on('page:load', ready);
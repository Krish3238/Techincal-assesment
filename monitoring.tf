resource "google_monitoring_dashboard" "dashboard" {
  dashboard_json = jsonencode({
    displayName = "Hello World App Dashboard"
    gridLayout = {
      columns = "2"
      widgets = [
        {
          title = "Request Latency"
          xyChart = {
            dataSets = [{
              timeSeriesQuery = {
                timeSeriesFilter = {
                  filter = "metric.type=\"appengine.googleapis.com/http/server/response_latencies\" resource.type=\"gae_app\""
                }
                unitOverride = "ms"
              }
            }]
          }
        },
        {
          title = "Error Rate"
          xyChart = {
            dataSets = [{
              timeSeriesQuery = {
                timeSeriesFilter = {
                  filter = "metric.type=\"appengine.googleapis.com/http/server/response_count\" resource.type=\"gae_app\" metric.label.response_code >= 400"
                }
              }
            }]
          }
        }
      ]
    }
  })
}
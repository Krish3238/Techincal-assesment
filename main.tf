terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_app_engine_application" "app" {
  project     = var.project_id
  location_id = var.region
}

resource "google_app_engine_standard_app_version" "myapp_v1" {
  version_id = "v1"
  service    = "default"
  runtime    = "python39"

  entrypoint {
    shell = "gunicorn -b :$PORT main:app"
  }

  deployment {
    files {
      name = "main.py"
      source = "app/main.py"
    }
    files {
      name = "requirements.txt"
      source = "app/requirements.txt"
    }
  }

  env_variables = {
    GOOGLE_CLOUD_PROJECT = var.project_id
  }

  depends_on = [google_app_engine_application.app]
}

resource "google_monitoring_dashboard" "dashboard" {
  dashboard_json = <<EOF
{
  "displayName": "Hello World App Dashboard",
  "gridLayout": {
    "columns": "2",
    "widgets": [
      {
        "title": "Request Latency",
        "xyChart": {
          "dataSets": [{
            "timeSeriesQuery": {
              "timeSeriesFilter": {
                "filter": "metric.type=\"appengine.googleapis.com/http/server/response_latencies\" resource.type=\"gae_app\"",
                "aggregation": {
                  "perSeriesAligner": "ALIGN_PERCENTILE_99",
                  "crossSeriesReducer": "REDUCE_MEAN",
                  "groupByFields": ["resource.label.\"version_id\""]
                }
              }
            },
            "plotType": "LINE"
          }]
        }
      },
      {
        "title": "Error Rate",
        "xyChart": {
          "dataSets": [{
            "timeSeriesQuery": {
              "timeSeriesFilter": {
                "filter": "metric.type=\"appengine.googleapis.com/http/server/response_count\" resource.type=\"gae_app\"",
                "aggregation": {
                  "perSeriesAligner": "ALIGN_RATE",
                  "crossSeriesReducer": "REDUCE_SUM",
                  "groupByFields": ["resource.label.\"version_id\""]
                }
              }
            },
            "plotType": "LINE"
          }]
        }
      }
    ]
  }
}
EOF
}

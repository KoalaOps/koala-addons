{{- define "defaultPresetGrafana"}}enabled: true
persistence:
  enabled: true
deploymentStrategy:
  type: Recreate
serviceMonitor:
  enabled: true
fullnameOverride: grafana
grafana.ini:
  wal: true
  server:
    domain: grafana.example.com
    root_url: "%(protocol)s://%(domain)s:%(http_port)s/"
    serve_from_sub_path: true
datasources:
  datasources.yaml:
    apiVersion: 1
    datasources:
      - name: Prometheus
        uid: webstore-metrics
        type: prometheus
        url: "http://tracing-mimir-ngnix.{{ .Values.destination.namespace }}/prometheus"
        editable: true
        isDefault: true
      - name: Tempo
        uid: webstore-traces
        type: tempo
        url: 'http://tracing-tempo-query-frontend.{{ .Values.destination.namespace }}:3100'
        editable: true
        isDefault: false
dashboardProviders:
  dashboardproviders.yaml:
    apiVersion: 1
    providers:
      - name: 'default'
        orgId: 1
        folder: ''
        type: file
        disableDeletion: false
        editable: true
        options:
          path: /var/lib/grafana/dashboards/default
dashboardsConfigMaps:
  default: 'koala-grafana-dashboards'
resources:
  limits:
    memory: 150Mi
{{- end}}
{{- define "grafana-demo-dashboard"}}  demo-dashboard.json: |-
    {
      "annotations": {
        "list": [
          {
            "builtIn": 1,
            "datasource": {
              "type": "grafana",
              "uid": "-- Grafana --"
            },
            "enable": true,
            "hide": true,
            "iconColor": "rgba(0, 211, 255, 1)",
            "name": "Annotations & Alerts",
            "target": {
              "limit": 100,
              "matchAny": false,
              "tags": [],
              "type": "dashboard"
            },
            "type": "dashboard"
          }
        ]
      },
      "editable": true,
      "fiscalYearStartMonth": 0,
      "graphTooltip": 0,
      "links": [],
      "liveNow": false,
      "panels": [
        {
          "collapsed": false,
          "gridPos": {
            "h": 1,
            "w": 24,
            "x": 0,
            "y": 0
          },
          "id": 14,
          "panels": [],
          "title": "Spanmetrics",
          "type": "row"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "palette-classic"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "line",
                "fillOpacity": 0,
                "gradientMode": "none",
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "insertNulls": false,
                "lineInterpolation": "linear",
                "lineWidth": 1,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "auto",
                "spanNulls": false,
                "stacking": {
                  "group": "A",
                  "mode": "none"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "dtdurationms"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 8,
            "w": 12,
            "x": 0,
            "y": 1
          },
          "id": 2,
          "options": {
            "legend": {
              "calcs": [],
              "displayMode": "list",
              "placement": "bottom",
              "showLegend": true
            },
            "tooltip": {
              "mode": "single",
              "sort": "none"
            }
          },
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "histogram_quantile(0.50, sum(rate(duration_milliseconds_bucket{service_name=\"${service}\"}[$__rate_interval])) by (le))",
              "legendFormat": "quantile50",
              "range": true,
              "refId": "A"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "histogram_quantile(0.95, sum(rate(duration_milliseconds_bucket{service_name=\"${service}\"}[$__rate_interval])) by (le))",
              "hide": false,
              "legendFormat": "quantile95",
              "range": true,
              "refId": "B"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "histogram_quantile(0.99, sum(rate(duration_milliseconds_bucket{service_name=\"${service}\"}[$__rate_interval])) by (le))",
              "hide": false,
              "legendFormat": "quantile99",
              "range": true,
              "refId": "C"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "histogram_quantile(0.999, sum(rate(duration_milliseconds_bucket{service_name=\"${service}\"}[$__rate_interval])) by (le))",
              "hide": false,
              "legendFormat": "quantile999",
              "range": true,
              "refId": "D"
            }
          ],
          "title": "Latency for ${service}",
          "type": "timeseries"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "palette-classic"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "line",
                "fillOpacity": 0,
                "gradientMode": "none",
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "insertNulls": false,
                "lineInterpolation": "linear",
                "lineWidth": 1,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "auto",
                "spanNulls": false,
                "stacking": {
                  "group": "A",
                  "mode": "none"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 8,
            "w": 12,
            "x": 12,
            "y": 1
          },
          "id": 10,
          "options": {
            "legend": {
              "calcs": [],
              "displayMode": "list",
              "placement": "bottom",
              "showLegend": true
            },
            "tooltip": {
              "mode": "single",
              "sort": "none"
            }
          },
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "expr": " sum by (span_name) (rate(calls_total{status_code=\"STATUS_CODE_ERROR\", service_name=\"${service}\"}[$__rate_interval]))",
              "interval": "",
              "legendFormat": "\{\{ span_name }}",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Error Rate for ${service} by span name",
          "type": "timeseries"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "palette-classic"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "line",
                "fillOpacity": 0,
                "gradientMode": "none",
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "insertNulls": false,
                "lineInterpolation": "linear",
                "lineWidth": 1,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "auto",
                "spanNulls": false,
                "stacking": {
                  "group": "A",
                  "mode": "none"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "reqps"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 8,
            "w": 12,
            "x": 0,
            "y": 9
          },
          "id": 12,
          "options": {
            "legend": {
              "calcs": [],
              "displayMode": "list",
              "placement": "bottom",
              "showLegend": true
            },
            "tooltip": {
              "mode": "single",
              "sort": "none"
            }
          },
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "expr": "sum by (span_name) (rate(duration_milliseconds_count{service_name=\"${service}\"}[$__rate_interval]))",
              "legendFormat": "\{\{ span_name }}",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Requests Rate for ${service} by span name",
          "type": "timeseries"
        },
        {
          "collapsed": false,
          "gridPos": {
            "h": 1,
            "w": 24,
            "x": 0,
            "y": 17
          },
          "id": 19,
          "panels": [],
          "title": "Application Logs",
          "type": "row"
        },
        {
          "datasource": {
            "type": "grafana-opensearch-datasource",
            "uid": "P9744FCCEAAFBD98F"
          },
          "description": "",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "thresholds"
              },
              "custom": {
                "align": "auto",
                "cellOptions": {
                  "type": "auto"
                },
                "inspect": false
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 8,
            "w": 4,
            "x": 0,
            "y": 18
          },
          "id": 20,
          "options": {
            "cellHeight": "sm",
            "footer": {
              "countRows": false,
              "fields": "",
              "reducer": [
                "sum"
              ],
              "show": false
            },
            "showHeader": true
          },
          "pluginVersion": "10.1.2",
          "targets": [
            {
              "alias": "",
              "bucketAggs": [
                {
                  "field": "time",
                  "id": "2",
                  "settings": {
                    "interval": "auto"
                  },
                  "type": "date_histogram"
                }
              ],
              "datasource": {
                "type": "grafana-opensearch-datasource",
                "uid": "P9744FCCEAAFBD98F"
              },
              "format": "table",
              "metrics": [
                {
                  "id": "1",
                  "type": "count"
                }
              ],
              "query": "search source=otel\n| where serviceName=\"${service}\"\n| stats count() by severityText",
              "queryType": "PPL",
              "refId": "A",
              "timeField": "time"
            }
          ],
          "title": "${service} Log entries by Severity",
          "type": "table"
        },
        {
          "datasource": {
            "type": "grafana-opensearch-datasource",
            "uid": "P9744FCCEAAFBD98F"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "thresholds"
              },
              "custom": {
                "align": "auto",
                "cellOptions": {
                  "type": "auto"
                },
                "inspect": false
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 8,
            "w": 20,
            "x": 4,
            "y": 18
          },
          "id": 17,
          "options": {
            "cellHeight": "sm",
            "footer": {
              "countRows": false,
              "fields": "",
              "reducer": [
                "sum"
              ],
              "show": false
            },
            "showHeader": true
          },
          "pluginVersion": "10.1.2",
          "targets": [
            {
              "alias": "",
              "bucketAggs": [
                {
                  "field": "time",
                  "id": "2",
                  "settings": {
                    "interval": "auto"
                  },
                  "type": "date_histogram"
                }
              ],
              "datasource": {
                "type": "grafana-opensearch-datasource",
                "uid": "P9744FCCEAAFBD98F"
              },
              "format": "logs",
              "hide": false,
              "metrics": [
                {
                  "id": "1",
                  "type": "count"
                }
              ],
              "query": "search source=otel\n| where serviceName=\"${service}\"",
              "queryType": "PPL",
              "refId": "A",
              "timeField": "time"
            }
          ],
          "title": "${service} Logs",
          "type": "table"
        },
        {
          "collapsed": false,
          "gridPos": {
            "h": 1,
            "w": 24,
            "x": 0,
            "y": 26
          },
          "id": 18,
          "panels": [],
          "title": "Application Metrics",
          "type": "row"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "palette-classic"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "line",
                "fillOpacity": 0,
                "gradientMode": "none",
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "insertNulls": false,
                "lineInterpolation": "linear",
                "lineWidth": 1,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "auto",
                "spanNulls": false,
                "stacking": {
                  "group": "A",
                  "mode": "none"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "percent"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 8,
            "w": 12,
            "x": 0,
            "y": 27
          },
          "id": 6,
          "options": {
            "legend": {
              "calcs": [],
              "displayMode": "list",
              "placement": "bottom",
              "showLegend": true
            },
            "tooltip": {
              "mode": "single",
              "sort": "none"
            }
          },
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "expr": "rate(process_runtime_cpython_cpu_time_seconds_total{type=~\"system\"}[$__rate_interval])*100",
              "hide": false,
              "interval": "2m",
              "legendFormat": "\{\{job}} (\{\{type}})",
              "range": true,
              "refId": "A"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "expr": "rate(process_runtime_cpython_cpu_time_seconds_total{type=~\"user\"}[$__rate_interval])*100",
              "hide": false,
              "interval": "2m",
              "legendFormat": "\{\{job}} (\{\{type}})",
              "range": true,
              "refId": "B"
            }
          ],
          "title": "Python services (CPU%)",
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "opentelemetry-demo/(.*)",
                "renamePattern": "$1"
              }
            }
          ],
          "type": "timeseries"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "palette-classic"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "line",
                "fillOpacity": 0,
                "gradientMode": "none",
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "insertNulls": false,
                "lineInterpolation": "linear",
                "lineWidth": 1,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "auto",
                "spanNulls": false,
                "stacking": {
                  "group": "A",
                  "mode": "none"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "bytes"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 8,
            "w": 12,
            "x": 12,
            "y": 27
          },
          "id": 8,
          "options": {
            "legend": {
              "calcs": [],
              "displayMode": "list",
              "placement": "bottom",
              "showLegend": true
            },
            "tooltip": {
              "mode": "single",
              "sort": "none"
            }
          },
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "expr": "process_runtime_cpython_memory_bytes{type=\"rss\"}",
              "legendFormat": "\{\{job}}",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Python services (Memory)",
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "opentelemetry-demo/(.*)",
                "renamePattern": "$1"
              }
            }
          ],
          "type": "timeseries"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "palette-classic"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "bars",
                "fillOpacity": 0,
                "gradientMode": "none",
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "insertNulls": false,
                "lineInterpolation": "linear",
                "lineWidth": 1,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "auto",
                "spanNulls": false,
                "stacking": {
                  "group": "A",
                  "mode": "none"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 8,
            "w": 12,
            "x": 0,
            "y": 35
          },
          "id": 4,
          "options": {
            "legend": {
              "calcs": [],
              "displayMode": "list",
              "placement": "bottom",
              "showLegend": false
            },
            "tooltip": {
              "mode": "single",
              "sort": "none"
            }
          },
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "expr": "rate(app_recommendations_counter_total{recommendation_type=\"catalog\"}[$__rate_interval])",
              "interval": "2m",
              "legendFormat": "recommendations",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Recommendations Rate",
          "type": "timeseries"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "palette-classic"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "line",
                "fillOpacity": 0,
                "gradientMode": "none",
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "insertNulls": false,
                "lineInterpolation": "linear",
                "lineWidth": 1,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "auto",
                "spanNulls": false,
                "stacking": {
                  "group": "A",
                  "mode": "none"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 8,
            "w": 12,
            "x": 12,
            "y": 35
          },
          "id": 16,
          "options": {
            "legend": {
              "calcs": [],
              "displayMode": "list",
              "placement": "bottom",
              "showLegend": true
            },
            "tooltip": {
              "mode": "single",
              "sort": "none"
            }
          },
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "expr": "rate(otel_trace_span_processor_spans{job=\"opentelemetry-demo/quoteservice\"}[2m])*120",
              "interval": "2m",
              "legendFormat": "\{\{state}}",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Quote Service batch span processor",
          "type": "timeseries"
        }
      ],
      "refresh": "",
      "revision": 1,
      "schemaVersion": 38,
      "style": "dark",
      "tags": [],
      "templating": {
        "list": [
          {
            "allValue": "",
            "current": {
              "selected": true,
              "text": "adservice",
              "value": "adservice"
            },
            "datasource": {
              "type": "prometheus",
              "uid": "webstore-metrics"
            },
            "definition": "duration_milliseconds_bucket",
            "hide": 0,
            "includeAll": false,
            "multi": false,
            "name": "service",
            "options": [],
            "query": {
              "query": "duration_milliseconds_bucket",
              "refId": "PrometheusVariableQueryEditor-VariableQuery"
            },
            "refresh": 1,
            "regex": "/.*service_name=\\\"([^\\\"]+)\\\".*/",
            "skipUrlSync": false,
            "sort": 1,
            "type": "query"
          }
        ]
      },
      "time": {
        "from": "now-3h",
        "to": "now"
      },
      "timepicker": {},
      "timezone": "",
      "title": "Demo Dashboard",
      "uid": "W2gX2zHVk",
      "version": 1,
      "weekStart": ""
    }
  opentelemetry-collector-data-flow.json: |
    {
      "annotations": {
        "list": [
          {
            "builtIn": 1,
            "datasource": {
              "type": "grafana",
              "uid": "-- Grafana --"
            },
            "enable": true,
            "hide": true,
            "iconColor": "rgba(0, 211, 255, 1)",
            "name": "Annotations & Alerts",
            "target": {
              "limit": 100,
              "matchAny": false,
              "tags": [],
              "type": "dashboard"
            },
            "type": "dashboard"
          }
        ]
      },
      "description": "otelcol metrics dashboard",
      "editable": true,
      "fiscalYearStartMonth": 0,
      "graphTooltip": 0,
      "id": 6,
      "links": [],
      "liveNow": false,
      "panels": [
        {
          "collapsed": false,
          "gridPos": {
            "h": 1,
            "w": 24,
            "x": 0,
            "y": 0
          },
          "id": 8,
          "panels": [],
          "title": "Process",
          "type": "row"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "Otel Collector Instance",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 4,
            "w": 3,
            "x": 0,
            "y": 1
          },
          "id": 6,
          "options": {
            "colorMode": "value",
            "graphMode": "area",
            "justifyMode": "center",
            "orientation": "auto",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": false
            },
            "textMode": "auto"
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "expr": "count(count(otelcol_process_cpu_seconds{service_instance_id=~\".*\"}) by (service_instance_id))",
              "legendFormat": "__auto",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Instance",
          "type": "stat"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "otelcol_process_cpu_seconds",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "s"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 4,
            "w": 3,
            "x": 3,
            "y": 1
          },
          "id": 24,
          "options": {
            "orientation": "auto",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": false
            },
            "showThresholdLabels": false,
            "showThresholdMarkers": true
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "expr": "avg(rate(otelcol_process_cpu_seconds{}[$__rate_interval])*100) by (instance)",
              "legendFormat": "__auto",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Cpu",
          "type": "gauge"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "Memory Rss\navg(otelcol_process_memory_rss{}) by (instance)",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "bytes"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 4,
            "w": 3,
            "x": 6,
            "y": 1
          },
          "id": 38,
          "options": {
            "orientation": "auto",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": false
            },
            "showThresholdLabels": false,
            "showThresholdMarkers": true
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "expr": "avg(otelcol_process_memory_rss{}) by (instance)",
              "legendFormat": "__auto",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Memory",
          "type": "gauge"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "",
          "gridPos": {
            "h": 4,
            "w": 15,
            "x": 9,
            "y": 1
          },
          "id": 32,
          "options": {
            "code": {
              "language": "plaintext",
              "showLineNumbers": false,
              "showMiniMap": false
            },
            "content": "## Opentelemetry Collector Data Ingress/Egress\n\n`service_version:` ${service_version}\n\n`opentelemetry collector:` contrib\n\n",
            "mode": "markdown"
          },
          "pluginVersion": "9.1.0",
          "type": "text"
        },
        {
          "collapsed": false,
          "gridPos": {
            "h": 1,
            "w": 24,
            "x": 0,
            "y": 5
          },
          "id": 10,
          "panels": [],
          "title": "Trace Pipeline",
          "type": "row"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "(avg(sum by(job) (rate(otelcol_exporter_sent_spans{}[$__range]))) / avg(sum by(job) (rate(otelcol_receiver_accepted_spans{}[$__range])))) ",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "thresholds"
              },
              "mappings": [],
              "min": 0,
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "light-blue",
                    "value": null
                  },
                  {
                    "color": "semi-dark-red",
                    "value": 0
                  },
                  {
                    "color": "super-light-orange",
                    "value": 0.4
                  },
                  {
                    "color": "dark-blue",
                    "value": 0.9
                  },
                  {
                    "color": "super-light-orange",
                    "value": 1.2
                  },
                  {
                    "color": "dark-red",
                    "value": 2.1
                  }
                ]
              },
              "unit": "percentunit"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 19,
            "w": 3,
            "x": 0,
            "y": 6
          },
          "id": 55,
          "options": {
            "orientation": "vertical",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": false
            },
            "showThresholdLabels": false,
            "showThresholdMarkers": false
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "avg(sum by(job) (rate(otelcol_exporter_sent_spans{}[$__range])))",
              "format": "time_series",
              "hide": true,
              "instant": false,
              "legendFormat": "__auto",
              "range": true,
              "refId": "export"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "expr": "avg(sum by(job) (rate(otelcol_receiver_accepted_spans{}[$__range])))",
              "format": "time_series",
              "hide": true,
              "legendFormat": "__auto",
              "range": true,
              "refId": "acc"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "expr": "(avg(sum by(job) (rate(otelcol_exporter_sent_spans{}[$__range]))) / avg(sum by(job) (rate(otelcol_receiver_accepted_spans{}[$__range])))) ",
              "hide": false,
              "legendFormat": "__auto",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Export Ratio",
          "transformations": [],
          "type": "gauge"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "gridPos": {
            "h": 11,
            "w": 21,
            "x": 3,
            "y": 6
          },
          "id": 4,
          "options": {
            "nodes": {
              "mainStatUnit": "flops"
            }
          },
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "label_join(label_join(\n(rate(otelcol_receiver_accepted_spans{}[$__interval]))\n, \"id\", \"\", \"transport\", \"receiver\")\n, \"title\", \"\", \"transport\", \"receiver\")\n\nor\n\nlabel_replace(label_replace(\nsum by(service_name) (rate(otelcol_receiver_accepted_spans{}[$__interval]))\n, \"id\", \"processor\", \"dummynode\", \"\")\n, \"title\", \"processor\", \"dummynode\", \"\")\n\nor\nlabel_replace(label_replace(\n(rate(otelcol_processor_batch_batch_send_size_count{}[$__interval]))\n, \"id\", \"$0\", \"processor\", \".*\")\n, \"title\", \"$0\", \"processor\", \".*\")\n\nor\nlabel_replace(label_replace(\nsum by(exporter) (rate(otelcol_exporter_sent_spans{}[$__interval]))\n, \"id\", \"exporter\", \"dummynode\", \"\")\n, \"title\", \"exporter\", \"dummynode\", \"\")\n        \nor\nlabel_replace(label_replace(\nsum by(exporter) (rate(otelcol_exporter_sent_spans{}[$__interval]))\n, \"id\", \"$0\", \"exporter\", \".*\")\n, \"title\", \"$0\", \"exporter\", \".*\")",
              "format": "table",
              "instant": true,
              "legendFormat": "__auto",
              "range": false,
              "refId": "nodes"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "label_join(\nlabel_replace(label_join(\n(rate(otelcol_receiver_accepted_spans{}[$__interval]))\n\n ,\"source\",\"\",\"transport\",\"receiver\")\n,\"target\",\"processor\",\"\",\"\")\n,\"id\",\"-\",\"source\",\"target\")\n\n  or\n\n  label_join(\nlabel_replace(label_replace(\n  (rate(otelcol_processor_batch_batch_send_size_count{}[$__interval]))\n ,\"source\",\"processor\",\"\",\"\")\n,\"target\",\"$0\",\"processor\",\".*\")\n,\"id\",\"-\",\"source\",\"target\")\n\nor\n  label_join(\nlabel_replace(label_replace(\n    (rate(otelcol_processor_batch_batch_send_size_count{}[$__interval]))\n ,\"source\",\"$0\",\"processor\",\".*\")\n,\"target\",\"exporter\",\"\",\"\")\n,\"id\",\"-\",\"source\",\"target\")\n\nor\n  label_join(\nlabel_replace(label_replace(\n   (rate(otelcol_exporter_sent_spans{}[$__interval]))\n ,\"source\",\"exporter\",\"\",\"\")\n,\"target\",\"$0\",\"exporter\",\".*\")\n,\"id\",\"-\",\"source\",\"target\")\n\n",
              "format": "table",
              "hide": false,
              "instant": true,
              "legendFormat": "__auto",
              "range": false,
              "refId": "edges"
            }
          ],
          "transformations": [],
          "type": "nodeGraph"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "Spans Accepted by Receiver and Transport",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "mappings": [],
              "noValue": "no data",
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "text",
                    "value": null
                  }
                ]
              },
              "unit": "none"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 5,
            "w": 5,
            "x": 3,
            "y": 17
          },
          "id": 12,
          "options": {
            "colorMode": "value",
            "graphMode": "area",
            "justifyMode": "auto",
            "orientation": "horizontal",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": false
            },
            "textMode": "auto"
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "expr": "sum(rate(otelcol_receiver_accepted_spans{}[$__rate_interval])) by (receiver,transport)",
              "legendFormat": "\{\{receiver}}-\{\{transport}}",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Accepted",
          "type": "stat"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "Total Spans Accepted ",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "text",
                    "value": null
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 5,
            "w": 3,
            "x": 8,
            "y": 17
          },
          "id": 13,
          "options": {
            "orientation": "horizontal",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": false
            },
            "showThresholdLabels": false,
            "showThresholdMarkers": true
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "expr": "sum(rate(otelcol_receiver_accepted_spans{}[$__rate_interval])) ",
              "legendFormat": "\{\{receiver}}-\{\{transport}}",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Total ",
          "type": "gauge"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "Total Batch Processed",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "#EAB839",
                    "value": 1
                  }
                ]
              },
              "unit": "none"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 5,
            "w": 5,
            "x": 11,
            "y": 17
          },
          "id": 15,
          "options": {
            "colorMode": "value",
            "graphMode": "area",
            "justifyMode": "auto",
            "orientation": "horizontal",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": false
            },
            "text": {},
            "textMode": "auto"
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "expr": "sum(rate(otelcol_processor_batch_batch_send_size_sum{}[$__rate_interval]))  by (processor)",
              "legendFormat": "\{\{processor}}",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Batch",
          "type": "stat"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "text",
                    "value": null
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 5,
            "w": 3,
            "x": 16,
            "y": 17
          },
          "id": 14,
          "options": {
            "orientation": "auto",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": false
            },
            "showThresholdLabels": false,
            "showThresholdMarkers": true
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "sum(rate(otelcol_exporter_sent_spans{}[$__interval])) ",
              "format": "time_series",
              "instant": false,
              "legendFormat": "\{\{processor}}",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Total ",
          "type": "gauge"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "Sent by Exporter",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "text",
                    "value": null
                  }
                ]
              },
              "unit": "none"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 5,
            "w": 5,
            "x": 19,
            "y": 17
          },
          "id": 30,
          "options": {
            "colorMode": "value",
            "graphMode": "area",
            "justifyMode": "auto",
            "orientation": "horizontal",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": false
            },
            "textMode": "auto"
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "sum(rate(otelcol_exporter_sent_spans{}[$__rate_interval])) by (exporter)",
              "format": "time_series",
              "instant": false,
              "legendFormat": "\{\{processor}}",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Sent",
          "type": "stat"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "mappings": [],
              "noValue": "no data",
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "text",
                    "value": null
                  }
                ]
              },
              "unit": "none"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 3,
            "w": 5,
            "x": 3,
            "y": 22
          },
          "id": 17,
          "options": {
            "colorMode": "value",
            "graphMode": "area",
            "justifyMode": "auto",
            "orientation": "horizontal",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": false
            },
            "textMode": "auto"
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "expr": "sum(rate(otelcol_receiver_refused_spans{}[$__rate_interval])) by (receiver,transport)",
              "legendFormat": "\{\{receiver}}-\{\{transport}}",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Refused",
          "type": "stat"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "Total Spans Accepted ",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "text",
                    "value": null
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 3,
            "w": 3,
            "x": 8,
            "y": 22
          },
          "id": 18,
          "options": {
            "orientation": "auto",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": false
            },
            "showThresholdLabels": false,
            "showThresholdMarkers": true
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "expr": "sum(rate(otelcol_receiver_refused_spans{}[$__rate_interval])) ",
              "legendFormat": "\{\{receiver}}-\{\{transport}}",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Total ",
          "type": "gauge"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "otelcol_exporter_send_failed_spans",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "text",
                    "value": null
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 3,
            "w": 3,
            "x": 16,
            "y": 22
          },
          "id": 19,
          "options": {
            "orientation": "auto",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": false
            },
            "showThresholdLabels": false,
            "showThresholdMarkers": true
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "sum(rate(otelcol_exporter_send_failed_spans{}[$__rate_interval])) ",
              "format": "time_series",
              "instant": false,
              "legendFormat": "\{\{processor}}",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Total ",
          "type": "gauge"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "Sent by Exporter\notelcol_exporter_send_failed_spans",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "text",
                    "value": null
                  }
                ]
              },
              "unit": "none"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 3,
            "w": 5,
            "x": 19,
            "y": 22
          },
          "id": 20,
          "options": {
            "colorMode": "value",
            "graphMode": "area",
            "justifyMode": "auto",
            "orientation": "horizontal",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": false
            },
            "textMode": "auto"
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "sum(rate(otelcol_exporter_send_failed_spans{}[$__rate_interval])) by (exporter)",
              "format": "time_series",
              "instant": false,
              "legendFormat": "\{\{processor}}",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Failed",
          "type": "stat"
        },
        {
          "collapsed": false,
          "gridPos": {
            "h": 1,
            "w": 24,
            "x": 0,
            "y": 25
          },
          "id": 22,
          "panels": [],
          "title": "Metrics Pipeline",
          "type": "row"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "avg(sum by(job) (rate(otelcol_exporter_sent_metric_points{}[$__range]))) versus avg(sum by(job) (rate(otelcol_receiver_accepted_metric_points{}[$__range])))",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "thresholds"
              },
              "mappings": [],
              "min": 0,
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "light-blue",
                    "value": null
                  },
                  {
                    "color": "semi-dark-red",
                    "value": 0
                  },
                  {
                    "color": "super-light-orange",
                    "value": 0.4
                  },
                  {
                    "color": "dark-blue",
                    "value": 0.9
                  },
                  {
                    "color": "super-light-orange",
                    "value": 1.2
                  },
                  {
                    "color": "dark-red",
                    "value": 2.1
                  }
                ]
              },
              "unit": "percentunit"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 19,
            "w": 3,
            "x": 0,
            "y": 26
          },
          "id": 54,
          "options": {
            "orientation": "vertical",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "/.*/",
              "values": false
            },
            "showThresholdLabels": false,
            "showThresholdMarkers": false
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "avg(sum by(job) (rate(otelcol_exporter_sent_metric_points{}[$__range])))",
              "format": "time_series",
              "hide": true,
              "instant": false,
              "legendFormat": "__auto",
              "range": true,
              "refId": "export"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "expr": "avg(sum by(job) (rate(otelcol_receiver_accepted_metric_points{}[$__range])))",
              "format": "time_series",
              "hide": true,
              "legendFormat": "__auto",
              "range": true,
              "refId": "acc"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "expr": "( avg(sum by(job) (rate(otelcol_exporter_sent_metric_points{}[$__range]))) /avg(sum by(job) (rate(otelcol_receiver_accepted_metric_points{}[$__range]))))",
              "hide": false,
              "legendFormat": "__auto",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Export Ratio",
          "transformations": [
            {
              "id": "calculateField",
              "options": {
                "alias": "percent",
                "binary": {
                  "left": "avg(sum by(job) (rate(otelcol_exporter_sent_metric_points{}[3600s])))",
                  "operator": "/",
                  "reducer": "sum",
                  "right": "avg(sum by(job) (rate(otelcol_receiver_accepted_metric_points{}[3600s])))"
                },
                "mode": "binary",
                "reduce": {
                  "reducer": "sum"
                }
              }
            },
            {
              "id": "organize",
              "options": {
                "excludeByName": {
                  "(sum(rate(otelcol_exporter_sent_metric_points{exporter=\"prometheus\"}[1m0s])) )": true,
                  "Time": true,
                  "avg(sum by(job) (rate(otelcol_exporter_sent_metric_points{}[3600s])))": true,
                  "avg(sum by(job) (rate(otelcol_receiver_accepted_metric_points{}[3600s])))": true,
                  "{instance=\"otelcol:9464\", job=\"otel\"}": true
                },
                "indexByName": {},
                "renameByName": {
                  "Time": "",
                  "percent": "Percent",
                  "{exporter=\"debug\", instance=\"otelcol:8888\", job=\"otel-collector\", service_instance_id=\"fbfa720a-ebf9-45c8-a79a-9d3b6021a663\", service_name=\"otelcol-contrib\", service_version=\"0.70.0\"}": ""
                }
              }
            }
          ],
          "type": "gauge"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "Metrics Signalling Pipelines",
          "gridPos": {
            "h": 11,
            "w": 21,
            "x": 3,
            "y": 26
          },
          "id": 25,
          "options": {
            "nodes": {
              "mainStatUnit": "flops"
            }
          },
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "\nlabel_join(label_join(\n(rate(otelcol_receiver_accepted_metric_points{}[$__interval]))\n, \"id\", \"\", \"transport\", \"receiver\")\n, \"title\", \"\", \"transport\", \"receiver\")\n\nor\n\nlabel_replace(label_replace(\nsum by(service_name) (rate(otelcol_receiver_accepted_spans{}[$__interval]))\n, \"id\", \"processor\", \"dummynode\", \"\")\n, \"title\", \"processor\", \"dummynode\", \"\")\n\n\n\nor\nlabel_replace(label_replace(\n(rate(otelcol_processor_batch_batch_send_size_count{}[$__interval]))\n, \"id\", \"$0\", \"processor\", \".*\")\n, \"title\", \"$0\", \"processor\", \".*\")\n\n\n\n\n\nor\nlabel_replace(label_replace(\nsum (rate(otelcol_exporter_sent_metric_points{}[$__interval]))\n, \"id\", \"exporter\", \"dummynode\", \"\")\n, \"title\", \"exporter\", \"dummynode\", \"\")\n\nor\nlabel_replace(label_replace(\nsum by(exporter) (rate(otelcol_exporter_sent_metric_points{}[$__interval]))\n, \"id\", \"$0\", \"exporter\", \".*\")\n, \"title\", \"$0\", \"exporter\", \".*\")",
              "format": "table",
              "instant": true,
              "legendFormat": "__auto",
              "range": false,
              "refId": "nodes"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "label_join(\nlabel_replace(label_join(\n(rate(otelcol_receiver_accepted_metric_points{}[$__interval]))\n\n,\"source\",\"\",\"transport\",\"receiver\")\n,\"target\",\"processor\",\"\",\"\")\n,\"id\",\"-\",\"source\",\"target\")\n\n\nor\n\nlabel_join(\nlabel_replace(label_replace(\n(rate(otelcol_processor_batch_batch_send_size_count{}[$__interval]))\n,\"source\",\"processor\",\"\",\"\")\n,\"target\",\"$0\",\"processor\",\".*\")\n,\"id\",\"-\",\"source\",\"target\")\n\n\n\n\n\nor\n\n\nlabel_join(\nlabel_replace(label_replace(\n(rate(otelcol_processor_batch_batch_send_size_count{}[$__interval]))\n,\"source\",\"$0\",\"processor\",\".*\")\n,\"target\",\"exporter\",\"\",\"\")\n,\"id\",\"-\",\"source\",\"target\")\n\nor\nlabel_join(\nlabel_replace(label_replace(\n(rate(otelcol_exporter_sent_metric_points{}[$__interval]))\n,\"source\",\"exporter\",\"\",\"\")\n,\"target\",\"$0\",\"exporter\",\".*\")\n,\"id\",\"-\",\"source\",\"target\")",
              "format": "table",
              "hide": false,
              "instant": true,
              "legendFormat": "__auto",
              "range": false,
              "refId": "edges"
            }
          ],
          "transformations": [],
          "type": "nodeGraph"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "otelcol_receiver_accepted_metric_points",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "mappings": [],
              "noValue": "no data",
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "text",
                    "value": null
                  }
                ]
              },
              "unit": "none"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 5,
            "w": 5,
            "x": 3,
            "y": 37
          },
          "id": 26,
          "options": {
            "colorMode": "value",
            "graphMode": "area",
            "justifyMode": "auto",
            "orientation": "horizontal",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": false
            },
            "textMode": "auto"
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "expr": "sum(rate(otelcol_receiver_accepted_metric_points{}[$__rate_interval])) by (receiver,transport)",
              "legendFormat": "\{\{receiver}}-\{\{transport}}",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Accepted",
          "type": "stat"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "otelcol_receiver_accepted_metric_points\nTotal Accepted ",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "text",
                    "value": null
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 5,
            "w": 3,
            "x": 8,
            "y": 37
          },
          "id": 27,
          "options": {
            "orientation": "auto",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": false
            },
            "showThresholdLabels": false,
            "showThresholdMarkers": true
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "expr": "sum(rate(otelcol_receiver_accepted_metric_points{}[$__rate_interval])) ",
              "legendFormat": "\{\{receiver}}-\{\{transport}}",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Total ",
          "type": "gauge"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "#EAB839",
                    "value": 1
                  }
                ]
              },
              "unit": "none"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 5,
            "w": 5,
            "x": 11,
            "y": 37
          },
          "id": 28,
          "options": {
            "colorMode": "value",
            "graphMode": "area",
            "justifyMode": "auto",
            "orientation": "horizontal",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": false
            },
            "text": {},
            "textMode": "auto"
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "expr": "sum(rate(otelcol_processor_batch_batch_send_size_sum{}[$__rate_interval]))  by (processor)",
              "legendFormat": "\{\{processor}}",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Batch",
          "type": "stat"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "Total Export ",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "text",
                    "value": null
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 5,
            "w": 3,
            "x": 16,
            "y": 37
          },
          "id": 29,
          "options": {
            "orientation": "auto",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": false
            },
            "showThresholdLabels": false,
            "showThresholdMarkers": true
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "sum(rate(otelcol_exporter_sent_metric_points{}[$__rate_interval])) ",
              "format": "time_series",
              "instant": false,
              "legendFormat": "\{\{processor}}",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Total ",
          "type": "gauge"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "Sent by Exporter",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "text",
                    "value": null
                  }
                ]
              },
              "unit": "none"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 5,
            "w": 5,
            "x": 19,
            "y": 37
          },
          "id": 16,
          "options": {
            "colorMode": "value",
            "graphMode": "area",
            "justifyMode": "auto",
            "orientation": "horizontal",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": false
            },
            "textMode": "auto"
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "sum(rate(otelcol_exporter_sent_metric_points{}[$__rate_interval])) by (exporter) ",
              "format": "time_series",
              "instant": false,
              "legendFormat": "\{\{processor}}",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Sent",
          "type": "stat"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "mappings": [],
              "noValue": "no data",
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "text",
                    "value": null
                  }
                ]
              },
              "unit": "none"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 3,
            "w": 5,
            "x": 3,
            "y": 42
          },
          "id": 47,
          "options": {
            "colorMode": "value",
            "graphMode": "area",
            "justifyMode": "auto",
            "orientation": "horizontal",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": false
            },
            "textMode": "auto"
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "expr": "sum(rate(otelcol_receiver_refused_metric_points{}[$__rate_interval])) by (receiver,transport)",
              "legendFormat": "\{\{receiver}}-\{\{transport}}",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Refused",
          "type": "stat"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "Total Refused \nsum(rate(otelcol_receiver_refused_metric_points{}[$__rate_interval])) ",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "text",
                    "value": null
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 3,
            "w": 3,
            "x": 8,
            "y": 42
          },
          "id": 48,
          "options": {
            "orientation": "auto",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": false
            },
            "showThresholdLabels": false,
            "showThresholdMarkers": true
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "expr": "sum(rate(otelcol_receiver_refused_metric_points{}[$__rate_interval])) ",
              "legendFormat": "\{\{receiver}}-\{\{transport}}",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Total ",
          "type": "gauge"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "Total Failed Export ",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "text",
                    "value": null
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 3,
            "w": 3,
            "x": 16,
            "y": 42
          },
          "id": 49,
          "options": {
            "orientation": "auto",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": false
            },
            "showThresholdLabels": false,
            "showThresholdMarkers": true
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "sum(rate(otelcol_exporter_send_failed_metric_points{}[$__rate_interval])) ",
              "format": "time_series",
              "instant": false,
              "legendFormat": "\{\{processor}}",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Total",
          "type": "gauge"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "Sent by Exporter\notelcol_exporter_send_failed_spans",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "text",
                    "value": null
                  }
                ]
              },
              "unit": "none"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 3,
            "w": 5,
            "x": 19,
            "y": 42
          },
          "id": 50,
          "options": {
            "colorMode": "value",
            "graphMode": "area",
            "justifyMode": "auto",
            "orientation": "horizontal",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": false
            },
            "textMode": "auto"
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "sum(rate(otelcol_exporter_send_failed_metric_points{}[$__rate_interval])) by (exporter)",
              "format": "time_series",
              "instant": false,
              "legendFormat": "\{\{processor}}",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Failed",
          "type": "stat"
        },
        {
          "collapsed": false,
          "gridPos": {
            "h": 1,
            "w": 24,
            "x": 0,
            "y": 45
          },
          "id": 35,
          "panels": [],
          "title": "Prometheus Scrape",
          "type": "row"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "otelcol prometheus exporter 8888 export rate versus prometheus scrape metrics",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "thresholds"
              },
              "mappings": [],
              "min": 0,
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "light-blue",
                    "value": null
                  },
                  {
                    "color": "semi-dark-red",
                    "value": 0
                  },
                  {
                    "color": "super-light-orange",
                    "value": 0.4
                  },
                  {
                    "color": "dark-blue",
                    "value": 0.9
                  },
                  {
                    "color": "super-light-orange",
                    "value": 1.2
                  },
                  {
                    "color": "dark-red",
                    "value": 2.1
                  }
                ]
              },
              "unit": "percentunit"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 9,
            "w": 3,
            "x": 0,
            "y": 46
          },
          "id": 53,
          "options": {
            "orientation": "vertical",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "/.*/",
              "values": false
            },
            "showThresholdLabels": false,
            "showThresholdMarkers": false
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "(sum_over_time(scrape_samples_scraped{job=\"otel-collector\"}[$__range])/ count_over_time(scrape_samples_scraped{job=\"otel-collector\"}[$__range])/(5*30)) ",
              "format": "time_series",
              "instant": false,
              "legendFormat": "__auto",
              "range": true,
              "refId": "accepted"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "expr": "(sum(rate(otelcol_exporter_sent_metric_points{exporter=\"prometheus\"}[$__rate_interval])) )",
              "format": "time_series",
              "hide": false,
              "legendFormat": "__auto",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Exported/Scraped",
          "transformations": [
            {
              "id": "calculateField",
              "options": {
                "alias": "percent",
                "binary": {
                  "left": "{instance=\"otelcol:9464\", job=\"otel-collector\"}",
                  "operator": "/",
                  "reducer": "sum",
                  "right": "(sum(rate(otelcol_exporter_sent_metric_points{exporter=\"prometheus\"}[1m0s])) )"
                },
                "mode": "binary",
                "reduce": {
                  "reducer": "sum"
                }
              }
            },
            {
              "id": "organize",
              "options": {
                "excludeByName": {
                  "(sum(rate(otelcol_exporter_sent_metric_points{exporter=\"prometheus\"}[1m0s])) )": true,
                  "Time": true,
                  "{instance=\"otelcol:9464\", job=\"otel\"}": true
                },
                "indexByName": {},
                "renameByName": {
                  "percent": "Percent"
                }
              }
            }
          ],
          "type": "gauge"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "sum_over_time(scrape_samples_scraped[$__range])/ count_over_time(scrape_samples_scraped[$__range])",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 9,
            "w": 5,
            "x": 3,
            "y": 46
          },
          "id": 37,
          "options": {
            "colorMode": "value",
            "graphMode": "area",
            "justifyMode": "auto",
            "orientation": "horizontal",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": false
            },
            "textMode": "value_and_name"
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "sum_over_time(scrape_samples_scraped[$__range])/ count_over_time(scrape_samples_scraped[$__range])/(5*30)",
              "format": "time_series",
              "instant": false,
              "legendFormat": "\{\{job}}/\{\{instance}}",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Samples Scraped",
          "type": "stat"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "scrape_samples_scraped{job!=\"\"}\nTotal Samples Scraped",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              }
            },
            "overrides": []
          },
          "gridPos": {
            "h": 9,
            "w": 3,
            "x": 8,
            "y": 46
          },
          "id": 42,
          "options": {
            "orientation": "horizontal",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": false
            },
            "showThresholdLabels": false,
            "showThresholdMarkers": true
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "sum_over_time(scrape_samples_scraped[$__range])/ count_over_time(scrape_samples_scraped[$__range])/(5*30)",
              "format": "time_series",
              "hide": false,
              "instant": false,
              "legendFormat": "__auto",
              "range": true,
              "refId": "B"
            }
          ],
          "title": "Total",
          "transformations": [
            {
              "id": "calculateField",
              "options": {
                "mode": "reduceRow",
                "reduce": {
                  "include": [
                    "{instance=\"otelcol:8888\", job=\"otel-collector\"}"
                  ],
                  "reducer": "sum"
                },
                "replaceFields": true
              }
            }
          ],
          "type": "gauge"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "gridPos": {
            "h": 9,
            "w": 8,
            "x": 11,
            "y": 46
          },
          "id": 41,
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "label_replace(label_replace(label_replace(\nsum (scrape_samples_scraped{job!=\"\"}) by (instance)\n, \"id\", \"$0\", \"instance\", \".*\")\n, \"title\", \"$0\", \"instance\", \".*\")\n,\"mainstat\",\"\",\"\",\"\")\n\nor \n\nlabel_replace(label_replace(label_replace(\nsum (scrape_samples_scraped{job!=\"\"})\n, \"id\", \"prometheus\", \"\", \"\")\n, \"title\", \"prometheus\", \"\", \"\")\n,\"mainstat\",\"\",\"\",\"\")\n",
              "format": "table",
              "hide": false,
              "instant": true,
              "legendFormat": "__auto",
              "range": false,
              "refId": "nodes"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "label_join(\nlabel_replace(label_replace(\nsum (scrape_samples_scraped{job!=\"\"}) by (instance)\n,\"source\",\"$0\",\"instance\",\".*\")\n,\"target\",\"prometheus\",\"\",\"\")\n,\"id\",\"-\",\"source\",\"target\")",
              "format": "table",
              "hide": false,
              "instant": true,
              "legendFormat": "__auto",
              "range": false,
              "refId": "edges"
            }
          ],
          "transformations": [
            {
              "id": "organize",
              "options": {
                "excludeByName": {
                  "Time": true
                },
                "indexByName": {},
                "renameByName": {}
              }
            }
          ],
          "type": "nodeGraph"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "Sent by Exporter",
          "gridPos": {
            "h": 9,
            "w": 5,
            "x": 19,
            "y": 46
          },
          "id": 52,
          "options": {
            "code": {
              "language": "plaintext",
              "showLineNumbers": false,
              "showMiniMap": false
            },
            "content": "\n \n## Prometheus Config\n\n`evaluation_interval:` 30s\n\n`scrape_interval:` 5s",
            "mode": "markdown"
          },
          "pluginVersion": "9.1.0",
          "type": "text"
        }
      ],
      "refresh": false,
      "schemaVersion": 37,
      "style": "dark",
      "tags": [],
      "templating": {
        "list": [
          {
            "allValue": ".*",
            "current": {
              "selected": false,
              "text": "0.70.0",
              "value": "0.70.0"
            },
            "datasource": {
              "type": "prometheus",
              "uid": "webstore-metrics"
            },
            "definition": "query_result(sum(otelcol_process_uptime{}) by (service_version))\n",
            "hide": 2,
            "includeAll": false,
            "label": "service_version",
            "multi": true,
            "name": "service_version",
            "options": [],
            "query": {
              "query": "query_result(sum(otelcol_process_uptime{}) by (service_version))\n",
              "refId": "StandardVariableQuery"
            },
            "refresh": 1,
            "regex": "/.*service_version=\"(.*)\".*/",
            "skipUrlSync": false,
            "sort": 0,
            "type": "query"
          }
        ]
      },
      "time": {
        "from": "now-15m",
        "to": "now"
      },
      "timepicker": {},
      "timezone": "",
      "title": "Opentelemetry Collector Data Flow",
      "uid": "rl5_tea4k",
      "version": 2,
      "weekStart": ""
    }
  opentelemetry-collector.json: |-
    {
      "__inputs": [],
      "__elements": {},
      "__requires": [
        {
          "type": "grafana",
          "id": "grafana",
          "name": "Grafana",
          "version": "10.0.3"
        },
        {
          "type": "panel",
          "id": "heatmap",
          "name": "Heatmap",
          "version": ""
        },
        {
          "type": "panel",
          "id": "nodeGraph",
          "name": "Node Graph",
          "version": ""
        },
        {
          "type": "datasource",
          "id": "prometheus",
          "name": "Prometheus",
          "version": "1.0.0"
        },
        {
          "type": "panel",
          "id": "table",
          "name": "Table",
          "version": ""
        },
        {
          "type": "panel",
          "id": "text",
          "name": "Text",
          "version": ""
        },
        {
          "type": "panel",
          "id": "timeseries",
          "name": "Time series",
          "version": ""
        }
      ],
      "annotations": {
        "list": [
          {
            "builtIn": 1,
            "datasource": {
              "type": "datasource",
              "uid": "grafana"
            },
            "enable": true,
            "hide": true,
            "iconColor": "rgba(0, 211, 255, 1)",
            "name": "Annotations & Alerts",
            "target": {
              "limit": 100,
              "matchAny": false,
              "tags": [],
              "type": "dashboard"
            },
            "type": "dashboard"
          }
        ]
      },
      "description": "Visualize OpenTelemetry (OTEL) collector metrics (tested with OTEL contrib v0.84.0)",
      "editable": true,
      "fiscalYearStartMonth": 0,
      "gnetId": 15983,
      "graphTooltip": 1,
      "id": null,
      "links": [],
      "liveNow": false,
      "panels": [
        {
          "collapsed": false,
          "datasource": {
            "type": "prometheus",
            "uid": "$datasource"
          },
          "gridPos": {
            "h": 1,
            "w": 24,
            "x": 0,
            "y": 0
          },
          "id": 23,
          "panels": [],
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "refId": "A"
            }
          ],
          "title": "Receivers",
          "type": "row"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "$datasource"
          },
          "description": "Accepted: count/rate of spans successfully pushed into the pipeline.\nRefused: count/rate of spans that could not be pushed into the pipeline.",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "palette-classic"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "line",
                "fillOpacity": 0,
                "gradientMode": "none",
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "lineInterpolation": "linear",
                "lineWidth": 1,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "never",
                "spanNulls": true,
                "stacking": {
                  "group": "A",
                  "mode": "none"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "links": [],
              "mappings": [],
              "min": 0,
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "short"
            },
            "overrides": [
              {
                "matcher": {
                  "id": "byRegexp",
                  "options": "/Refused.*/"
                },
                "properties": [
                  {
                    "id": "color",
                    "value": {
                      "fixedColor": "red",
                      "mode": "fixed"
                    }
                  }
                ]
              }
            ]
          },
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 0,
            "y": 1
          },
          "id": 28,
          "interval": "$minstep",
          "links": [],
          "options": {
            "legend": {
              "calcs": [
                "min",
                "max",
                "mean"
              ],
              "displayMode": "table",
              "placement": "bottom",
              "showLegend": true
            },
            "tooltip": {
              "mode": "multi",
              "sort": "none"
            }
          },
          "pluginVersion": "8.3.5",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "sum(${metric:value}(otelcol_receiver_accepted_spans{receiver=~\"$receiver\",job=\"$job\"}[$__rate_interval])) by (receiver $grouping)",
              "format": "time_series",
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Accepted: \{\{receiver}} \{\{transport}} \{\{service_instance_id}}",
              "range": true,
              "refId": "A"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "sum(${metric:value}(otelcol_receiver_refused_spans{receiver=~\"$receiver\",job=\"$job\"}[$__rate_interval])) by (receiver $grouping)",
              "format": "time_series",
              "hide": false,
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Refused: \{\{receiver}} \{\{transport}} \{\{service_instance_id}}",
              "range": true,
              "refId": "B"
            }
          ],
          "title": "Spans ${metric:text}",
          "type": "timeseries"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "$datasource"
          },
          "description": "Accepted: count/rate of metric points successfully pushed into the pipeline.\nRefused: count/rate of metric points that could not be pushed into the pipeline.",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "palette-classic"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "line",
                "fillOpacity": 0,
                "gradientMode": "none",
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "lineInterpolation": "linear",
                "lineWidth": 1,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "never",
                "spanNulls": true,
                "stacking": {
                  "group": "A",
                  "mode": "none"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "links": [],
              "mappings": [],
              "min": 0,
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "short"
            },
            "overrides": [
              {
                "matcher": {
                  "id": "byRegexp",
                  "options": "/Refused.*/"
                },
                "properties": [
                  {
                    "id": "color",
                    "value": {
                      "fixedColor": "red",
                      "mode": "fixed"
                    }
                  }
                ]
              }
            ]
          },
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 8,
            "y": 1
          },
          "id": 32,
          "interval": "$minstep",
          "links": [],
          "options": {
            "legend": {
              "calcs": [
                "min",
                "max",
                "mean"
              ],
              "displayMode": "table",
              "placement": "bottom",
              "showLegend": true
            },
            "tooltip": {
              "mode": "multi",
              "sort": "none"
            }
          },
          "pluginVersion": "8.3.5",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "sum(${metric:value}(otelcol_receiver_accepted_metric_points{receiver=~\"$receiver\",job=\"$job\"}[$__rate_interval])) by (receiver $grouping)",
              "format": "time_series",
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Accepted: \{\{receiver}} \{\{transport}} \{\{service_instance_id}}",
              "range": true,
              "refId": "A"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "sum(${metric:value}(otelcol_receiver_refused_metric_points{receiver=~\"$receiver\",job=\"$job\"}[$__rate_interval])) by (receiver $grouping)",
              "format": "time_series",
              "hide": false,
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Refused: \{\{receiver}} \{\{transport}} \{\{service_instance_id}}",
              "range": true,
              "refId": "B"
            }
          ],
          "title": "Metric Points ${metric:text}",
          "type": "timeseries"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "$datasource"
          },
          "description": "Accepted: count/rate of log records successfully pushed into the pipeline.\nRefused: count/rate of log records that could not be pushed into the pipeline.",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "palette-classic"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "line",
                "fillOpacity": 0,
                "gradientMode": "none",
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "lineInterpolation": "linear",
                "lineWidth": 1,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "never",
                "spanNulls": true,
                "stacking": {
                  "group": "A",
                  "mode": "none"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "links": [],
              "mappings": [],
              "min": 0,
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "short"
            },
            "overrides": [
              {
                "matcher": {
                  "id": "byRegexp",
                  "options": "/Refused.*/"
                },
                "properties": [
                  {
                    "id": "color",
                    "value": {
                      "fixedColor": "red",
                      "mode": "fixed"
                    }
                  }
                ]
              }
            ]
          },
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 16,
            "y": 1
          },
          "id": 47,
          "interval": "$minstep",
          "links": [],
          "options": {
            "legend": {
              "calcs": [
                "min",
                "max",
                "mean"
              ],
              "displayMode": "table",
              "placement": "bottom",
              "showLegend": true
            },
            "tooltip": {
              "mode": "multi",
              "sort": "none"
            }
          },
          "pluginVersion": "8.3.5",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "sum(${metric:value}(otelcol_receiver_accepted_log_records{receiver=~\"$receiver\",job=\"$job\"}[$__rate_interval])) by (receiver $grouping)",
              "format": "time_series",
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Accepted: \{\{receiver}} \{\{transport}} \{\{service_instance_id}}",
              "range": true,
              "refId": "A"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "sum(${metric:value}(otelcol_receiver_refused_log_records{receiver=~\"$receiver\",job=\"$job\"}[$__rate_interval])) by (receiver $grouping)",
              "format": "time_series",
              "hide": false,
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Refused: \{\{receiver}} \{\{transport}} \{\{service_instance_id}}",
              "range": true,
              "refId": "B"
            }
          ],
          "title": "Log Records ${metric:text}",
          "type": "timeseries"
        },
        {
          "collapsed": false,
          "datasource": {
            "type": "prometheus",
            "uid": "$datasource"
          },
          "gridPos": {
            "h": 1,
            "w": 24,
            "x": 0,
            "y": 9
          },
          "id": 34,
          "panels": [],
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "refId": "A"
            }
          ],
          "title": "Processors",
          "type": "row"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "$datasource"
          },
          "description": "",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "palette-classic"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "line",
                "fillOpacity": 0,
                "gradientMode": "none",
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "lineInterpolation": "linear",
                "lineWidth": 1,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "never",
                "spanNulls": true,
                "stacking": {
                  "group": "A",
                  "mode": "none"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "links": [],
              "mappings": [],
              "min": 0,
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "short"
            },
            "overrides": [
              {
                "matcher": {
                  "id": "byRegexp",
                  "options": "/.*Refused.*/"
                },
                "properties": [
                  {
                    "id": "color",
                    "value": {
                      "fixedColor": "red",
                      "mode": "fixed"
                    }
                  }
                ]
              },
              {
                "matcher": {
                  "id": "byRegexp",
                  "options": "/.*Dropped.*/"
                },
                "properties": [
                  {
                    "id": "color",
                    "value": {
                      "fixedColor": "purple",
                      "mode": "fixed"
                    }
                  }
                ]
              }
            ]
          },
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 0,
            "y": 18
          },
          "id": 36,
          "interval": "$minstep",
          "links": [],
          "options": {
            "legend": {
              "calcs": [
                "min",
                "max",
                "mean"
              ],
              "displayMode": "table",
              "placement": "bottom",
              "showLegend": true
            },
            "tooltip": {
              "mode": "multi",
              "sort": "none"
            }
          },
          "pluginVersion": "8.3.5",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "sum(${metric:value}(otelcol_processor_batch_batch_send_size_count{processor=~\"$processor\",job=\"$job\"}[$__rate_interval])) by (processor)",
              "format": "time_series",
              "hide": false,
              "instant": false,
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Batch send size count: \{\{processor}}",
              "refId": "B"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "sum(${metric:value}(otelcol_processor_batch_batch_send_size_sum{processor=~\"$processor\",job=\"$job\"}[$__rate_interval])) by (processor)",
              "format": "time_series",
              "hide": false,
              "instant": false,
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Batch send size sum: \{\{processor}}",
              "refId": "A"
            }
          ],
          "title": "Batch Metrics",
          "type": "timeseries"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "$datasource"
          },
          "description": "Number of units in the batch",
          "fieldConfig": {
            "defaults": {
              "custom": {
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "scaleDistribution": {
                  "type": "linear"
                }
              },
              "links": []
            },
            "overrides": []
          },
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 8,
            "y": 18
          },
          "id": 49,
          "interval": "$minstep",
          "links": [],
          "maxDataPoints": 50,
          "options": {
            "calculate": false,
            "cellGap": 1,
            "color": {
              "exponent": 0.5,
              "fill": "dark-orange",
              "mode": "scheme",
              "reverse": true,
              "scale": "exponential",
              "scheme": "Reds",
              "steps": 57
            },
            "exemplars": {
              "color": "rgba(255,0,255,0.7)"
            },
            "filterValues": {
              "le": 1e-9
            },
            "legend": {
              "show": true
            },
            "rowsFrame": {
              "layout": "auto"
            },
            "tooltip": {
              "show": true,
              "yHistogram": false
            },
            "yAxis": {
              "axisPlacement": "left",
              "reverse": false
            }
          },
          "pluginVersion": "10.0.3",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "sum(increase(otelcol_processor_batch_batch_send_size_bucket{processor=~\"$processor\",job=\"$job\"}[$__rate_interval])) by (le)",
              "format": "heatmap",
              "hide": false,
              "instant": false,
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "\{\{le}}",
              "refId": "B"
            }
          ],
          "title": "Batch Send Size Heatmap",
          "type": "heatmap"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "$datasource"
          },
          "description": "Number of times the batch was sent due to a size trigger. Number of times the batch was sent due to a timeout trigger.",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "palette-classic"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "line",
                "fillOpacity": 0,
                "gradientMode": "none",
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "lineInterpolation": "linear",
                "lineWidth": 1,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "never",
                "spanNulls": true,
                "stacking": {
                  "group": "A",
                  "mode": "none"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "links": [],
              "mappings": [],
              "min": 0,
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "short"
            },
            "overrides": [
              {
                "matcher": {
                  "id": "byRegexp",
                  "options": "/.*Refused.*/"
                },
                "properties": [
                  {
                    "id": "color",
                    "value": {
                      "fixedColor": "red",
                      "mode": "fixed"
                    }
                  }
                ]
              },
              {
                "matcher": {
                  "id": "byRegexp",
                  "options": "/.*Dropped.*/"
                },
                "properties": [
                  {
                    "id": "color",
                    "value": {
                      "fixedColor": "purple",
                      "mode": "fixed"
                    }
                  }
                ]
              }
            ]
          },
          "gridPos": {
            "h": 8,
            "w": 8,
            "x": 16,
            "y": 18
          },
          "id": 56,
          "interval": "$minstep",
          "links": [],
          "options": {
            "legend": {
              "calcs": [
                "min",
                "max",
                "mean"
              ],
              "displayMode": "table",
              "placement": "bottom",
              "showLegend": true
            },
            "tooltip": {
              "mode": "multi",
              "sort": "none"
            }
          },
          "pluginVersion": "8.3.5",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "sum(${metric:value}(otelcol_processor_batch_batch_size_trigger_send{processor=~\"$processor\",job=\"$job\"}[$__rate_interval])) by (processor)",
              "format": "time_series",
              "hide": false,
              "instant": false,
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Batch sent due to a size trigger: \{\{processor}}",
              "refId": "B"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "sum(${metric:value}(otelcol_processor_batch_timeout_trigger_send{processor=~\"$processor\"}[$__rate_interval])) by (processor)",
              "format": "time_series",
              "hide": false,
              "instant": false,
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Batch sent due to a timeout trigger: \{\{processor}}",
              "refId": "A"
            }
          ],
          "title": "Batch Metrics",
          "type": "timeseries"
        },
        {
          "collapsed": false,
          "datasource": {
            "type": "prometheus",
            "uid": "$datasource"
          },
          "gridPos": {
            "h": 1,
            "w": 24,
            "x": 0,
            "y": 26
          },
          "id": 25,
          "panels": [],
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "refId": "A"
            }
          ],
          "title": "Exporters",
          "type": "row"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "$datasource"
          },
          "description": "Sent: count/rate of spans successfully sent to destination.\nEngueue: count/rate of spans failed to be added to the sending queue.",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "palette-classic"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "line",
                "fillOpacity": 0,
                "gradientMode": "none",
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "lineInterpolation": "linear",
                "lineWidth": 1,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "never",
                "spanNulls": true,
                "stacking": {
                  "group": "A",
                  "mode": "none"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "links": [],
              "mappings": [],
              "min": 0,
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "short"
            },
            "overrides": [
              {
                "matcher": {
                  "id": "byRegexp",
                  "options": "/Failed:.*/"
                },
                "properties": [
                  {
                    "id": "color",
                    "value": {
                      "fixedColor": "red",
                      "mode": "fixed"
                    }
                  }
                ]
              }
            ]
          },
          "gridPos": {
            "h": 9,
            "w": 8,
            "x": 0,
            "y": 27
          },
          "id": 37,
          "interval": "$minstep",
          "links": [],
          "options": {
            "legend": {
              "calcs": [
                "min",
                "max",
                "mean"
              ],
              "displayMode": "table",
              "placement": "bottom",
              "showLegend": true
            },
            "tooltip": {
              "mode": "multi",
              "sort": "none"
            }
          },
          "pluginVersion": "8.3.5",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "sum(${metric:value}(otelcol_exporter_sent_spans{exporter=~\"$exporter\",job=\"$job\"}[$__rate_interval])) by (exporter $grouping)",
              "format": "time_series",
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Sent: \{\{exporter}} \{\{service_instance_id}}",
              "range": true,
              "refId": "A"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "sum(${metric:value}(otelcol_exporter_enqueue_failed_spans{exporter=~\"$exporter\",job=\"$job\"}[$__rate_interval])) by (exporter $grouping)",
              "format": "time_series",
              "hide": false,
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Enqueue: \{\{exporter}} \{\{service_instance_id}}",
              "range": true,
              "refId": "B"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "sum(${metric:value}(otelcol_exporter_send_failed_spans{exporter=~\"$exporter\",job=\"$job\"}[$__rate_interval])) by (exporter $grouping)",
              "format": "time_series",
              "hide": false,
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Failed: \{\{exporter}} \{\{service_instance_id}}",
              "range": true,
              "refId": "C"
            }
          ],
          "title": "Spans ${metric:text}",
          "type": "timeseries"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "$datasource"
          },
          "description": "Sent: count/rate of metric points successfully sent to destination.\nEngueue: count/rate of metric points failed to be added to the sending queue.",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "palette-classic"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "line",
                "fillOpacity": 0,
                "gradientMode": "none",
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "lineInterpolation": "linear",
                "lineWidth": 1,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "never",
                "spanNulls": true,
                "stacking": {
                  "group": "A",
                  "mode": "none"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "links": [],
              "mappings": [],
              "min": 0,
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "short"
            },
            "overrides": [
              {
                "matcher": {
                  "id": "byRegexp",
                  "options": "/Failed:.*/"
                },
                "properties": [
                  {
                    "id": "color",
                    "value": {
                      "fixedColor": "red",
                      "mode": "fixed"
                    }
                  }
                ]
              }
            ]
          },
          "gridPos": {
            "h": 9,
            "w": 8,
            "x": 8,
            "y": 27
          },
          "id": 38,
          "interval": "$minstep",
          "links": [],
          "options": {
            "legend": {
              "calcs": [
                "min",
                "max",
                "mean"
              ],
              "displayMode": "table",
              "placement": "bottom",
              "showLegend": true
            },
            "tooltip": {
              "mode": "multi",
              "sort": "none"
            }
          },
          "pluginVersion": "8.3.5",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "sum(${metric:value}(otelcol_exporter_sent_metric_points{exporter=~\"$exporter\",job=\"$job\"}[$__rate_interval])) by (exporter $grouping)",
              "format": "time_series",
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Sent: \{\{exporter}} \{\{service_instance_id}}",
              "range": true,
              "refId": "A"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "sum(${metric:value}(otelcol_exporter_enqueue_failed_metric_points{exporter=~\"$exporter\",job=\"$job\"}[$__rate_interval])) by (exporter $grouping)",
              "format": "time_series",
              "hide": false,
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Enqueue: \{\{exporter}} \{\{service_instance_id}}",
              "range": true,
              "refId": "B"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "sum(${metric:value}(otelcol_exporter_send_failed_metric_points{exporter=~\"$exporter\",job=\"$job\"}[$__rate_interval])) by (exporter $grouping)",
              "format": "time_series",
              "hide": false,
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Failed: \{\{exporter}} \{\{service_instance_id}}",
              "range": true,
              "refId": "C"
            }
          ],
          "title": "Metric Points ${metric:text}",
          "type": "timeseries"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "$datasource"
          },
          "description": "Sent: count/rate of log records successfully sent to destination.\nEngueue: count/rate of log records failed to be added to the sending queue.",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "palette-classic"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "line",
                "fillOpacity": 0,
                "gradientMode": "none",
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "lineInterpolation": "linear",
                "lineWidth": 1,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "never",
                "spanNulls": true,
                "stacking": {
                  "group": "A",
                  "mode": "none"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "links": [],
              "mappings": [],
              "min": 0,
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "short"
            },
            "overrides": [
              {
                "matcher": {
                  "id": "byRegexp",
                  "options": "/Failed:.*/"
                },
                "properties": [
                  {
                    "id": "color",
                    "value": {
                      "fixedColor": "red",
                      "mode": "fixed"
                    }
                  }
                ]
              }
            ]
          },
          "gridPos": {
            "h": 9,
            "w": 8,
            "x": 16,
            "y": 27
          },
          "id": 48,
          "interval": "$minstep",
          "links": [],
          "options": {
            "legend": {
              "calcs": [
                "min",
                "max",
                "mean"
              ],
              "displayMode": "table",
              "placement": "bottom",
              "showLegend": true
            },
            "tooltip": {
              "mode": "multi",
              "sort": "none"
            }
          },
          "pluginVersion": "8.3.5",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "sum(${metric:value}(otelcol_exporter_sent_log_records{exporter=~\"$exporter\",job=\"$job\"}[$__rate_interval])) by (exporter $grouping)",
              "format": "time_series",
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Sent: \{\{exporter}} \{\{service_instance_id}}",
              "range": true,
              "refId": "A"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "sum(${metric:value}(otelcol_exporter_enqueue_failed_log_records{exporter=~\"$exporter\",job=\"$job\"}[$__rate_interval])) by (exporter $grouping)",
              "format": "time_series",
              "hide": false,
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Enqueue: \{\{exporter}} \{\{service_instance_id}}",
              "range": true,
              "refId": "B"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "sum(${metric:value}(otelcol_exporter_send_failed_log_records{exporter=~\"$exporter\",job=\"$job\"}[$__rate_interval])) by (exporter $grouping)",
              "format": "time_series",
              "hide": false,
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Failed: \{\{exporter}} \{\{service_instance_id}}",
              "range": true,
              "refId": "C"
            }
          ],
          "title": "Log Records ${metric:text}",
          "type": "timeseries"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "$datasource"
          },
          "description": "Current size of the retry queue (in batches)",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "palette-classic"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "line",
                "fillOpacity": 0,
                "gradientMode": "none",
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "lineInterpolation": "linear",
                "lineWidth": 1,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "never",
                "spanNulls": true,
                "stacking": {
                  "group": "A",
                  "mode": "none"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "links": [],
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "short"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 9,
            "w": 12,
            "x": 0,
            "y": 36
          },
          "id": 10,
          "links": [],
          "options": {
            "legend": {
              "calcs": [
                "min",
                "max",
                "mean"
              ],
              "displayMode": "table",
              "placement": "bottom",
              "showLegend": true
            },
            "tooltip": {
              "mode": "multi",
              "sort": "none"
            }
          },
          "pluginVersion": "8.3.5",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "max(otelcol_exporter_queue_size{exporter=~\"$exporter\",job=\"$job\"}) by (exporter)",
              "format": "time_series",
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Max queue size: \{\{exporter}}",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Exporter Queue Size",
          "type": "timeseries"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "$datasource"
          },
          "description": "Fixed capacity of the retry queue (in batches)",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "palette-classic"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "line",
                "fillOpacity": 0,
                "gradientMode": "none",
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "lineInterpolation": "linear",
                "lineWidth": 1,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "never",
                "spanNulls": true,
                "stacking": {
                  "group": "A",
                  "mode": "none"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "links": [],
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "short"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 9,
            "w": 12,
            "x": 12,
            "y": 36
          },
          "id": 55,
          "links": [],
          "options": {
            "legend": {
              "calcs": [
                "min",
                "max",
                "mean"
              ],
              "displayMode": "table",
              "placement": "bottom",
              "showLegend": true
            },
            "tooltip": {
              "mode": "multi",
              "sort": "none"
            }
          },
          "pluginVersion": "8.3.5",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "min(otelcol_exporter_queue_capacity{exporter=~\"$exporter\",job=\"$job\"}) by (exporter)",
              "format": "time_series",
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Queue capacity: \{\{exporter}}",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Exporter Queue Capacity",
          "type": "timeseries"
        },
        {
          "collapsed": false,
          "datasource": {
            "type": "prometheus",
            "uid": "$datasource"
          },
          "gridPos": {
            "h": 1,
            "w": 24,
            "x": 0,
            "y": 45
          },
          "id": 21,
          "panels": [],
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "refId": "A"
            }
          ],
          "title": "Collector",
          "type": "row"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "$datasource"
          },
          "description": "Total physical memory (resident set size)",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "palette-classic"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "line",
                "fillOpacity": 0,
                "gradientMode": "none",
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "lineInterpolation": "linear",
                "lineWidth": 1,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "never",
                "spanNulls": true,
                "stacking": {
                  "group": "A",
                  "mode": "none"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "links": [],
              "mappings": [],
              "min": 0,
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "bytes"
            },
            "overrides": [
              {
                "matcher": {
                  "id": "byName",
                  "options": "Max Memory RSS "
                },
                "properties": [
                  {
                    "id": "color",
                    "value": {
                      "fixedColor": "red",
                      "mode": "fixed"
                    }
                  },
                  {
                    "id": "custom.fillBelowTo",
                    "value": "Avg Memory RSS "
                  },
                  {
                    "id": "custom.lineWidth",
                    "value": 0
                  },
                  {
                    "id": "custom.fillOpacity",
                    "value": 20
                  }
                ]
              },
              {
                "matcher": {
                  "id": "byName",
                  "options": "Min Memory RSS "
                },
                "properties": [
                  {
                    "id": "color",
                    "value": {
                      "fixedColor": "yellow",
                      "mode": "fixed"
                    }
                  },
                  {
                    "id": "custom.lineWidth",
                    "value": 0
                  }
                ]
              },
              {
                "matcher": {
                  "id": "byName",
                  "options": "Avg Memory RSS "
                },
                "properties": [
                  {
                    "id": "color",
                    "value": {
                      "fixedColor": "orange",
                      "mode": "fixed"
                    }
                  },
                  {
                    "id": "custom.fillBelowTo",
                    "value": "Min Memory RSS "
                  },
                  {
                    "id": "custom.fillOpacity",
                    "value": 20
                  }
                ]
              }
            ]
          },
          "gridPos": {
            "h": 9,
            "w": 8,
            "x": 0,
            "y": 46
          },
          "id": 40,
          "interval": "$minstep",
          "links": [],
          "options": {
            "legend": {
              "calcs": [
                "min",
                "max",
                "mean"
              ],
              "displayMode": "table",
              "placement": "bottom",
              "showLegend": true
            },
            "tooltip": {
              "mode": "multi",
              "sort": "none"
            }
          },
          "pluginVersion": "8.3.5",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "max(otelcol_process_memory_rss{job=\"$job\"}) by (job $grouping)",
              "format": "time_series",
              "hide": false,
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Max Memory RSS \{\{service_instance_id}}",
              "range": true,
              "refId": "C"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "avg(otelcol_process_memory_rss{job=\"$job\"}) by (job $grouping)",
              "format": "time_series",
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Avg Memory RSS \{\{service_instance_id}}",
              "range": true,
              "refId": "A"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "min(otelcol_process_memory_rss{job=\"$job\"}) by (job $grouping)",
              "format": "time_series",
              "hide": false,
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Min Memory RSS \{\{service_instance_id}}",
              "range": true,
              "refId": "B"
            }
          ],
          "title": "Total RSS Memory",
          "type": "timeseries"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "$datasource"
          },
          "description": "Total bytes of memory obtained from the OS (see 'go doc runtime.MemStats.Sys')",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "palette-classic"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "line",
                "fillOpacity": 0,
                "gradientMode": "none",
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "lineInterpolation": "linear",
                "lineWidth": 1,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "never",
                "spanNulls": true,
                "stacking": {
                  "group": "A",
                  "mode": "none"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "links": [],
              "mappings": [],
              "min": 0,
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "bytes"
            },
            "overrides": [
              {
                "matcher": {
                  "id": "byName",
                  "options": "Max Memory RSS "
                },
                "properties": [
                  {
                    "id": "color",
                    "value": {
                      "fixedColor": "red",
                      "mode": "fixed"
                    }
                  },
                  {
                    "id": "custom.fillBelowTo",
                    "value": "Avg Memory RSS "
                  },
                  {
                    "id": "custom.lineWidth",
                    "value": 0
                  },
                  {
                    "id": "custom.fillOpacity",
                    "value": 20
                  }
                ]
              },
              {
                "matcher": {
                  "id": "byName",
                  "options": "Min Memory RSS "
                },
                "properties": [
                  {
                    "id": "color",
                    "value": {
                      "fixedColor": "yellow",
                      "mode": "fixed"
                    }
                  },
                  {
                    "id": "custom.lineWidth",
                    "value": 0
                  }
                ]
              },
              {
                "matcher": {
                  "id": "byName",
                  "options": "Avg Memory RSS "
                },
                "properties": [
                  {
                    "id": "color",
                    "value": {
                      "fixedColor": "orange",
                      "mode": "fixed"
                    }
                  },
                  {
                    "id": "custom.fillBelowTo",
                    "value": "Min Memory RSS "
                  },
                  {
                    "id": "custom.fillOpacity",
                    "value": 20
                  }
                ]
              }
            ]
          },
          "gridPos": {
            "h": 9,
            "w": 8,
            "x": 8,
            "y": 46
          },
          "id": 52,
          "interval": "$minstep",
          "links": [],
          "options": {
            "legend": {
              "calcs": [
                "min",
                "max",
                "mean"
              ],
              "displayMode": "table",
              "placement": "bottom",
              "showLegend": true
            },
            "tooltip": {
              "mode": "multi",
              "sort": "none"
            }
          },
          "pluginVersion": "8.3.5",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "max(otelcol_process_runtime_total_sys_memory_bytes{job=\"$job\"}) by (job $grouping)",
              "format": "time_series",
              "hide": false,
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Max Memory RSS \{\{service_instance_id}}",
              "range": true,
              "refId": "C"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "avg(otelcol_process_runtime_total_sys_memory_bytes{job=\"$job\"}) by (job $grouping)",
              "format": "time_series",
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Avg Memory RSS \{\{service_instance_id}}",
              "range": true,
              "refId": "A"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "min(otelcol_process_runtime_total_sys_memory_bytes{job=\"$job\"}) by (job $grouping)",
              "format": "time_series",
              "hide": false,
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Min Memory RSS \{\{service_instance_id}}",
              "range": true,
              "refId": "B"
            }
          ],
          "title": "Total Runtime Sys Memory",
          "type": "timeseries"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "$datasource"
          },
          "description": "Bytes of allocated heap objects (see 'go doc runtime.MemStats.HeapAlloc')",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "palette-classic"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "line",
                "fillOpacity": 0,
                "gradientMode": "none",
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "lineInterpolation": "linear",
                "lineWidth": 1,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "never",
                "spanNulls": true,
                "stacking": {
                  "group": "A",
                  "mode": "none"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "links": [],
              "mappings": [],
              "min": 0,
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "bytes"
            },
            "overrides": [
              {
                "matcher": {
                  "id": "byName",
                  "options": "Max Memory RSS "
                },
                "properties": [
                  {
                    "id": "color",
                    "value": {
                      "fixedColor": "red",
                      "mode": "fixed"
                    }
                  },
                  {
                    "id": "custom.fillBelowTo",
                    "value": "Avg Memory RSS "
                  },
                  {
                    "id": "custom.lineWidth",
                    "value": 0
                  },
                  {
                    "id": "custom.fillOpacity",
                    "value": 20
                  }
                ]
              },
              {
                "matcher": {
                  "id": "byName",
                  "options": "Min Memory RSS "
                },
                "properties": [
                  {
                    "id": "color",
                    "value": {
                      "fixedColor": "yellow",
                      "mode": "fixed"
                    }
                  },
                  {
                    "id": "custom.lineWidth",
                    "value": 0
                  }
                ]
              },
              {
                "matcher": {
                  "id": "byName",
                  "options": "Avg Memory RSS "
                },
                "properties": [
                  {
                    "id": "color",
                    "value": {
                      "fixedColor": "orange",
                      "mode": "fixed"
                    }
                  },
                  {
                    "id": "custom.fillBelowTo",
                    "value": "Min Memory RSS "
                  },
                  {
                    "id": "custom.fillOpacity",
                    "value": 20
                  }
                ]
              }
            ]
          },
          "gridPos": {
            "h": 9,
            "w": 8,
            "x": 16,
            "y": 46
          },
          "id": 53,
          "interval": "$minstep",
          "links": [],
          "options": {
            "legend": {
              "calcs": [
                "min",
                "max",
                "mean"
              ],
              "displayMode": "table",
              "placement": "bottom",
              "showLegend": true
            },
            "tooltip": {
              "mode": "multi",
              "sort": "none"
            }
          },
          "pluginVersion": "8.3.5",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "max(otelcol_process_runtime_heap_alloc_bytes{job=\"$job\"}) by (job $grouping)",
              "format": "time_series",
              "hide": false,
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Max Memory RSS \{\{service_instance_id}}",
              "range": true,
              "refId": "C"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "avg(otelcol_process_runtime_heap_alloc_bytes{job=\"$job\"}) by (job $grouping)",
              "format": "time_series",
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Avg Memory RSS \{\{service_instance_id}}",
              "range": true,
              "refId": "A"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "min(otelcol_process_runtime_heap_alloc_bytes{job=\"$job\"}) by (job $grouping)",
              "format": "time_series",
              "hide": false,
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Min Memory RSS \{\{service_instance_id}}",
              "range": true,
              "refId": "B"
            }
          ],
          "title": "Total Runtime Heap Memory",
          "type": "timeseries"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "$datasource"
          },
          "description": "Total CPU user and system time in percentage",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "palette-classic"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "line",
                "fillOpacity": 0,
                "gradientMode": "none",
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "lineInterpolation": "linear",
                "lineWidth": 1,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "never",
                "spanNulls": true,
                "stacking": {
                  "group": "A",
                  "mode": "none"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "links": [],
              "mappings": [],
              "min": 0,
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "percent"
            },
            "overrides": [
              {
                "matcher": {
                  "id": "byName",
                  "options": "Max CPU usage "
                },
                "properties": [
                  {
                    "id": "color",
                    "value": {
                      "fixedColor": "red",
                      "mode": "fixed"
                    }
                  },
                  {
                    "id": "custom.fillBelowTo",
                    "value": "Avg CPU usage "
                  },
                  {
                    "id": "custom.lineWidth",
                    "value": 0
                  },
                  {
                    "id": "custom.fillOpacity",
                    "value": 20
                  }
                ]
              },
              {
                "matcher": {
                  "id": "byName",
                  "options": "Avg CPU usage "
                },
                "properties": [
                  {
                    "id": "color",
                    "value": {
                      "fixedColor": "orange",
                      "mode": "fixed"
                    }
                  },
                  {
                    "id": "custom.fillBelowTo",
                    "value": "Min CPU usage "
                  }
                ]
              },
              {
                "matcher": {
                  "id": "byName",
                  "options": "Min CPU usage "
                },
                "properties": [
                  {
                    "id": "color",
                    "value": {
                      "fixedColor": "yellow",
                      "mode": "fixed"
                    }
                  },
                  {
                    "id": "custom.lineWidth",
                    "value": 0
                  }
                ]
              }
            ]
          },
          "gridPos": {
            "h": 9,
            "w": 8,
            "x": 0,
            "y": 55
          },
          "id": 39,
          "interval": "$minstep",
          "links": [],
          "options": {
            "legend": {
              "calcs": [
                "min",
                "max",
                "mean"
              ],
              "displayMode": "table",
              "placement": "bottom",
              "showLegend": true
            },
            "tooltip": {
              "mode": "multi",
              "sort": "none"
            }
          },
          "pluginVersion": "8.3.5",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "max(rate(otelcol_process_cpu_seconds{job=\"$job\"}[$__rate_interval])*100) by (job $grouping)",
              "format": "time_series",
              "hide": false,
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Max CPU usage \{\{service_instance_id}}",
              "range": true,
              "refId": "B"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "avg(rate(otelcol_process_cpu_seconds{job=\"$job\"}[$__rate_interval])*100) by (job $grouping)",
              "format": "time_series",
              "hide": false,
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Avg CPU usage \{\{service_instance_id}}",
              "range": true,
              "refId": "A"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "min(rate(otelcol_process_cpu_seconds{job=\"$job\"}[$__rate_interval])*100) by (job $grouping)",
              "format": "time_series",
              "hide": false,
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Min CPU usage \{\{service_instance_id}}",
              "range": true,
              "refId": "C"
            }
          ],
          "title": "CPU Usage",
          "type": "timeseries"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "$datasource"
          },
          "description": "Number of service instances, which are reporting metrics",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "palette-classic"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "line",
                "fillOpacity": 0,
                "gradientMode": "none",
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "lineInterpolation": "linear",
                "lineWidth": 1,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "never",
                "spanNulls": true,
                "stacking": {
                  "group": "A",
                  "mode": "none"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "links": [],
              "mappings": [],
              "min": 0,
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "short"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 9,
            "w": 8,
            "x": 8,
            "y": 55
          },
          "id": 41,
          "interval": "$minstep",
          "links": [],
          "options": {
            "legend": {
              "calcs": [
                "min",
                "max",
                "mean"
              ],
              "displayMode": "table",
              "placement": "bottom",
              "showLegend": true
            },
            "tooltip": {
              "mode": "multi",
              "sort": "none"
            }
          },
          "pluginVersion": "8.3.5",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "count(count(otelcol_process_cpu_seconds{service_instance_id=~\".*\",job=\"$job\"}) by (service_instance_id))",
              "format": "time_series",
              "hide": false,
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Service instance count",
              "range": true,
              "refId": "B"
            }
          ],
          "title": "Service Instance Count",
          "type": "timeseries"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "$datasource"
          },
          "description": "",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "palette-classic"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "line",
                "fillOpacity": 0,
                "gradientMode": "none",
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "lineInterpolation": "linear",
                "lineWidth": 1,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "never",
                "spanNulls": true,
                "stacking": {
                  "group": "A",
                  "mode": "none"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "links": [],
              "mappings": [],
              "min": 0,
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "s"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 9,
            "w": 8,
            "x": 16,
            "y": 55
          },
          "id": 54,
          "interval": "$minstep",
          "links": [],
          "options": {
            "legend": {
              "calcs": [
                "min",
                "max",
                "mean"
              ],
              "displayMode": "table",
              "placement": "bottom",
              "showLegend": true
            },
            "tooltip": {
              "mode": "multi",
              "sort": "none"
            }
          },
          "pluginVersion": "8.3.5",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "max(otelcol_process_uptime{service_instance_id=~\".*\",job=\"$job\"}) by (service_instance_id)",
              "format": "time_series",
              "hide": false,
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "Service instance uptime: \{\{service_instance_id}}",
              "range": true,
              "refId": "B"
            }
          ],
          "title": "Uptime by Service Instance",
          "type": "timeseries"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "$datasource"
          },
          "description": "",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "thresholds"
              },
              "custom": {
                "align": "auto",
                "cellOptions": {
                  "type": "auto"
                },
                "inspect": false
              },
              "links": [],
              "mappings": [],
              "min": 0,
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "s"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 5,
            "w": 24,
            "x": 0,
            "y": 64
          },
          "id": 57,
          "interval": "$minstep",
          "links": [],
          "options": {
            "cellHeight": "sm",
            "footer": {
              "countRows": false,
              "fields": "",
              "reducer": [
                "sum"
              ],
              "show": false
            },
            "showHeader": true
          },
          "pluginVersion": "10.0.3",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "max(otelcol_process_uptime{service_instance_id=~\".*\",job=\"$job\"}) by (service_instance_id,service_name,service_version)",
              "format": "table",
              "hide": false,
              "instant": true,
              "interval": "$minstep",
              "intervalFactor": 1,
              "legendFormat": "__auto",
              "range": false,
              "refId": "B"
            }
          ],
          "title": "Service Instance Details",
          "transformations": [
            {
              "id": "organize",
              "options": {
                "excludeByName": {
                  "Time": true,
                  "Value": true
                },
                "indexByName": {},
                "renameByName": {}
              }
            }
          ],
          "type": "table"
        },
        {
          "collapsed": false,
          "gridPos": {
            "h": 1,
            "w": 24,
            "x": 0,
            "y": 69
          },
          "id": 59,
          "panels": [],
          "title": "Data Flows",
          "type": "row"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "$datasource"
          },
          "description": "Receivers -> Processor(s) -> Exporters (Node Graph panel is beta, so this panel may not show data correctly).",
          "gridPos": {
            "h": 9,
            "w": 8,
            "x": 0,
            "y": 70
          },
          "id": 58,
          "options": {
            "nodes": {
              "mainStatUnit": "flops"
            }
          },
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "# receivers\nlabel_replace(\n  label_join(\n    label_join(\n      sum(${metric:value}(\n        otelcol_receiver_accepted_spans{receiver=~\"$receiver\",job=\"$job\"}[$__rate_interval])\n      ) by (receiver)\n      , \"id\", \"-rcv-\", \"transport\", \"receiver\"\n    )\n    , \"title\", \"\", \"transport\", \"receiver\"\n  )\n  , \"icon\", \"arrow-to-right\", \"\", \"\"\n)\n\n# dummy processor\nor\nlabel_replace(\n  label_replace(\n    label_replace(\n      (sum(rate(otelcol_process_uptime{job=\"$job\"}[$__interval])))\n      , \"id\", \"processor\", \"\", \"\"\n    )\n    , \"title\", \"Processor(s)\", \"\", \"\"\n  )\n  , \"icon\", \"arrow-random\", \"\", \"\"\n)\n\n# exporters\nor\nlabel_replace(\n  label_join(\n    label_join(\n      sum(${metric:value}(\n        otelcol_exporter_sent_spans{exporter=~\"$exporter\",job=\"$job\"}[$__rate_interval])\n      ) by (exporter)\n      , \"id\", \"-exp-\", \"transport\", \"exporter\"\n    )\n    , \"title\", \"\", \"transport\", \"exporter\"\n  )\n  , \"icon\", \"arrow-from-right\", \"\", \"\"\n)",
              "format": "table",
              "hide": false,
              "instant": true,
              "legendFormat": "__auto",
              "range": false,
              "refId": "nodes"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "# receivers -> processor\r\nlabel_join(\r\n    label_replace(\r\n        label_join(\r\n            (sum(rate(otelcol_receiver_accepted_spans{job=\"$job\"}[$__interval])) by (receiver))\r\n            ,\"source\", \"-rcv-\", \"transport\", \"receiver\"\r\n        )\r\n        ,\"target\", \"processor\", \"\", \"\"\r\n    )\r\n    , \"id\", \"-\", \"source\", \"target\"\r\n)\r\n\r\n# processor -> exporters\r\nor\r\nlabel_join(\r\n    label_replace(\r\n        label_join(\r\n            (sum(rate(otelcol_exporter_sent_spans{job=\"$job\"}[$__interval])) by (exporter))\r\n            , \"target\", \"-exp-\", \"transport\", \"exporter\"\r\n        )\r\n        , \"source\", \"processor\", \"\", \"\"\r\n    )\r\n    , \"id\", \"-\", \"source\", \"target\"\r\n)",
              "format": "table",
              "hide": false,
              "instant": true,
              "legendFormat": "__auto",
              "range": false,
              "refId": "edges"
            }
          ],
          "title": "Spans Flow",
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "Value",
                "renamePattern": "mainstat"
              }
            },
            {
              "disabled": true,
              "id": "calculateField",
              "options": {
                "alias": "secondarystat",
                "mode": "reduceRow",
                "reduce": {
                  "include": [
                    "mainstat"
                  ],
                  "reducer": "sum"
                }
              }
            }
          ],
          "type": "nodeGraph"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "$datasource"
          },
          "description": "Receivers -> Processor(s) -> Exporters (Node Graph panel is beta, so this panel may not show data correctly).",
          "gridPos": {
            "h": 9,
            "w": 8,
            "x": 8,
            "y": 70
          },
          "id": 60,
          "options": {
            "nodes": {
              "mainStatUnit": "none"
            }
          },
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "# receivers\nlabel_replace(\n  label_join(\n    label_join(\n      (sum(\n        ${metric:value}(otelcol_receiver_accepted_metric_points{receiver=~\"$receiver\",job=\"$job\"}[$__rate_interval])\n      ) by (receiver))\n      , \"id\", \"-rcv-\", \"transport\", \"receiver\"\n    )\n    , \"title\", \"\", \"transport\", \"receiver\"\n  )\n  , \"icon\", \"arrow-to-right\", \"\", \"\"\n)\n\n# dummy processor\nor\nlabel_replace(\n  label_replace(\n    label_replace(\n      (sum(rate(otelcol_process_uptime{job=\"$job\"}[$__interval])))\n      , \"id\", \"processor\", \"\", \"\"\n    )\n    , \"title\", \"Processor(s)\", \"\", \"\"\n  )\n  , \"icon\", \"arrow-random\", \"\", \"\"\n)\n\n# exporters\nor\nlabel_replace(\n  label_join(\n    label_join(\n      (sum(\n        ${metric:value}(otelcol_exporter_sent_metric_points{exporter=~\"$exporter\",job=\"$job\"}[$__rate_interval])\n      ) by (exporter))\n      , \"id\", \"-exp-\", \"transport\", \"exporter\"\n    )\n    , \"title\", \"\", \"transport\", \"exporter\"\n  )\n  , \"icon\", \"arrow-from-right\", \"\", \"\"\n)",
              "format": "table",
              "hide": false,
              "instant": true,
              "legendFormat": "__auto",
              "range": false,
              "refId": "nodes"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "# receivers -> processor\r\nlabel_join(\r\n    label_replace(\r\n        label_join(\r\n            (sum(rate(otelcol_receiver_accepted_metric_points{job=\"$job\"}[$__interval])) by (receiver))\r\n            , \"source\", \"-rcv-\", \"transport\", \"receiver\"\r\n        )\r\n        , \"target\", \"processor\", \"\", \"\"\r\n    )\r\n    , \"id\", \"-\", \"source\", \"target\"\r\n)\r\n\r\n# processor -> exporters\r\nor \r\nlabel_join(\r\n    label_replace(\r\n        label_join(\r\n            (sum(rate(otelcol_exporter_sent_metric_points{job=\"$job\"}[$__interval])) by (exporter))\r\n            , \"target\", \"-exp-\", \"transport\", \"exporter\"\r\n        )\r\n        , \"source\", \"processor\", \"\", \"\"\r\n    )\r\n    , \"id\", \"-\", \"source\", \"target\"\r\n)",
              "format": "table",
              "hide": false,
              "instant": true,
              "legendFormat": "__auto",
              "range": false,
              "refId": "edges"
            }
          ],
          "title": "Metric Points Flow",
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "Value",
                "renamePattern": "mainstat"
              }
            },
            {
              "disabled": true,
              "id": "calculateField",
              "options": {
                "alias": "secondarystat",
                "mode": "reduceRow",
                "reduce": {
                  "include": [
                    "Value #nodes"
                  ],
                  "reducer": "sum"
                }
              }
            }
          ],
          "type": "nodeGraph"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "$datasource"
          },
          "description": "Receivers -> Processor(s) -> Exporters (Node Graph panel is beta, so this panel may not show data correctly).",
          "gridPos": {
            "h": 9,
            "w": 8,
            "x": 16,
            "y": 70
          },
          "id": 61,
          "options": {
            "nodes": {
              "mainStatUnit": "flops"
            }
          },
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "# receivers\nlabel_replace(\n  label_join(\n    label_join(\n      sum(${metric:value}(\n        otelcol_receiver_accepted_log_records{receiver=~\"$receiver\",job=\"$job\"}[$__rate_interval])\n      ) by (receiver)\n      , \"id\", \"-rcv-\", \"transport\", \"receiver\"\n    )\n    , \"title\", \"\", \"transport\", \"receiver\"\n  )\n  , \"icon\", \"arrow-to-right\", \"\", \"\"\n)\n\n# dummy processor\nor\nlabel_replace(\n  label_replace(\n    label_replace(\n      (sum(rate(otelcol_process_uptime{job=\"$job\"}[$__interval])))\n      , \"id\", \"processor\", \"\", \"\"\n    )\n    , \"title\", \"Processor(s)\", \"\", \"\"\n  )\n  , \"icon\", \"arrow-random\", \"\", \"\"\n)\n\n# exporters\nor\nlabel_replace(\n  label_join(\n    label_join(\n      sum(${metric:value}(\n        otelcol_exporter_sent_log_records{exporter=~\"$exporter\",job=\"$job\"}[$__rate_interval])\n      ) by (exporter)\n      , \"id\", \"-exp-\", \"transport\", \"exporter\"\n    )\n    , \"title\", \"\", \"transport\", \"exporter\"\n  )\n  , \"icon\", \"arrow-from-right\", \"\", \"\"\n)",
              "format": "table",
              "hide": false,
              "instant": true,
              "legendFormat": "__auto",
              "range": false,
              "refId": "nodes"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "# receivers -> processor\r\nlabel_join(\r\n    label_replace(\r\n        label_join(\r\n            (sum(rate(otelcol_receiver_accepted_log_records{job=\"$job\"}[$__interval])) by (receiver))\r\n            , \"source\", \"-rcv-\", \"transport\", \"receiver\"\r\n        )\r\n        , \"target\", \"processor\", \"\", \"\"\r\n    )\r\n    , \"id\", \"-edg-\", \"source\", \"target\"\r\n)\r\n\r\n# processor -> exporters\r\nor \r\nlabel_join(\r\n    label_replace(\r\n        label_join(\r\n            (sum(rate(otelcol_exporter_sent_log_records{job=\"$job\"}[$__interval])) by (exporter))\r\n            ,\"target\",\"-exp-\",\"transport\",\"exporter\"\r\n        )\r\n        ,\"source\",\"processor\",\"\",\"\"\r\n    )\r\n    ,\"id\",\"-edg-\",\"source\",\"target\"\r\n)",
              "format": "table",
              "hide": false,
              "instant": true,
              "legendFormat": "__auto",
              "range": false,
              "refId": "edges"
            }
          ],
          "title": "Log Records Flow",
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "Value",
                "renamePattern": "mainstat"
              }
            },
            {
              "disabled": true,
              "id": "calculateField",
              "options": {
                "alias": "secondarystat",
                "mode": "reduceRow",
                "reduce": {
                  "include": [
                    "mainstat"
                  ],
                  "reducer": "sum"
                }
              }
            }
          ],
          "type": "nodeGraph"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "$datasource"
          },
          "editable": true,
          "error": false,
          "gridPos": {
            "h": 3,
            "w": 24,
            "x": 0,
            "y": 79
          },
          "id": 45,
          "links": [],
          "options": {
            "code": {
              "language": "plaintext",
              "showLineNumbers": false,
              "showMiniMap": false
            },
            "content": "<a href=\"http://www.monitoringartist.com\" target=\"_blank\" title=\"Dashboard maintained by Monitoring Artist - DevOps / Docker / Kubernetes / AWS ECS / Google GCP / Zabbix / Zenoss / Terraform / Monitoring\"><img src=\"https://monitoringartist.github.io/monitoring-artist-logo-grafana.png\" height=\"30px\" /></a> | \n<a target=\"_blank\" href=\"https://github.com/open-telemetry/opentelemetry-collector/blob/main/docs/troubleshooting.md#metrics\">OTEL collector troubleshooting (how to enable telemetry metrics)</a> | \n<a target=\"_blank\" href=\"https://opentelemetry.io/docs/collector/scaling/\">Scaling the Collector (metrics to watch)</a> | \n<a target=\"_blank\" href=\"https://grafana.com/grafana/dashboards/15983-opentelemetry-collector/\">Installed from Grafana.com dashboards</a>",
            "mode": "html"
          },
          "pluginVersion": "10.0.3",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "$datasource"
              },
              "refId": "A"
            }
          ],
          "title": "Documentation",
          "type": "text"
        }
      ],
      "refresh": "10s",
      "schemaVersion": 38,
      "style": "dark",
      "tags": [
        "opentelemetry",
        "monitoring"
      ],
      "templating": {
        "list": [
          {
            "current": {},
            "hide": 0,
            "includeAll": false,
            "label": "Datasource",
            "multi": false,
            "name": "datasource",
            "options": [],
            "query": "prometheus",
            "queryValue": "",
            "refresh": 1,
            "regex": "",
            "skipUrlSync": false,
            "type": "datasource"
          },
          {
            "current": {},
            "datasource": {
              "type": "prometheus",
              "uid": "$datasource"
            },
            "definition": "label_values(otelcol_process_uptime, job)",
            "hide": 0,
            "includeAll": false,
            "label": "Job",
            "multi": false,
            "name": "job",
            "options": [],
            "query": {
              "query": "label_values(otelcol_process_uptime, job)",
              "refId": "StandardVariableQuery"
            },
            "refresh": 1,
            "regex": "",
            "skipUrlSync": false,
            "sort": 1,
            "type": "query"
          },
          {
            "auto": true,
            "auto_count": 300,
            "auto_min": "10s",
            "current": {
              "selected": false,
              "text": "auto",
              "value": "$__auto_interval_minstep"
            },
            "hide": 0,
            "label": "Min step",
            "name": "minstep",
            "options": [
              {
                "selected": true,
                "text": "auto",
                "value": "$__auto_interval_minstep"
              },
              {
                "selected": false,
                "text": "10s",
                "value": "10s"
              },
              {
                "selected": false,
                "text": "30s",
                "value": "30s"
              },
              {
                "selected": false,
                "text": "1m",
                "value": "1m"
              },
              {
                "selected": false,
                "text": "5m",
                "value": "5m"
              }
            ],
            "query": "10s,30s,1m,5m",
            "queryValue": "",
            "refresh": 2,
            "skipUrlSync": false,
            "type": "interval"
          },
          {
            "current": {
              "selected": true,
              "text": "Rate",
              "value": "rate"
            },
            "hide": 0,
            "includeAll": false,
            "label": "Base metric",
            "multi": false,
            "name": "metric",
            "options": [
              {
                "selected": true,
                "text": "Rate",
                "value": "rate"
              },
              {
                "selected": false,
                "text": "Count",
                "value": "increase"
              }
            ],
            "query": "Rate : rate, Count : increase",
            "queryValue": "",
            "skipUrlSync": false,
            "type": "custom"
          },
          {
            "allValue": ".*",
            "current": {},
            "datasource": {
              "type": "prometheus",
              "uid": "$datasource"
            },
            "definition": "label_values(receiver)",
            "hide": 0,
            "includeAll": true,
            "label": "Receiver",
            "multi": false,
            "name": "receiver",
            "options": [],
            "query": {
              "query": "label_values(receiver)",
              "refId": "StandardVariableQuery"
            },
            "refresh": 2,
            "regex": "",
            "skipUrlSync": false,
            "sort": 1,
            "tagValuesQuery": "",
            "tagsQuery": "",
            "type": "query",
            "useTags": false
          },
          {
            "current": {},
            "datasource": {
              "type": "prometheus",
              "uid": "$datasource"
            },
            "definition": "label_values(processor)",
            "hide": 0,
            "includeAll": true,
            "label": "Processor",
            "multi": false,
            "name": "processor",
            "options": [],
            "query": {
              "query": "label_values(processor)",
              "refId": "StandardVariableQuery"
            },
            "refresh": 2,
            "regex": "",
            "skipUrlSync": false,
            "sort": 1,
            "tagValuesQuery": "",
            "tagsQuery": "",
            "type": "query",
            "useTags": false
          },
          {
            "allValue": ".*",
            "current": {},
            "datasource": {
              "type": "prometheus",
              "uid": "$datasource"
            },
            "definition": "label_values(exporter)",
            "hide": 0,
            "includeAll": true,
            "label": "Exporter",
            "multi": false,
            "name": "exporter",
            "options": [],
            "query": {
              "query": "label_values(exporter)",
              "refId": "StandardVariableQuery"
            },
            "refresh": 2,
            "regex": "",
            "skipUrlSync": false,
            "sort": 1,
            "tagValuesQuery": "",
            "tagsQuery": "",
            "type": "query",
            "useTags": false
          },
          {
            "current": {
              "selected": true,
              "text": "None (basic metrics)",
              "value": ""
            },
            "description": "Detailed metrics must be configured in the collector configuration. They add grouping by transport protocol (http/grpc) for receivers. ",
            "hide": 0,
            "includeAll": false,
            "label": "Additional groupping",
            "multi": false,
            "name": "grouping",
            "options": [
              {
                "selected": true,
                "text": "None (basic metrics)",
                "value": ""
              },
              {
                "selected": false,
                "text": "By transport (detailed metrics)",
                "value": ",transport"
              },
              {
                "selected": false,
                "text": "By service instance id",
                "value": ",service_instance_id"
              }
            ],
            "query": "None (basic metrics) :  , By transport (detailed metrics) : \\,transport, By service instance id : \\,service_instance_id",
            "queryValue": "",
            "skipUrlSync": false,
            "type": "custom"
          }
        ]
      },
      "time": {
        "from": "now-6h",
        "to": "now"
      },
      "timepicker": {
        "refresh_intervals": [
          "5s",
          "10s",
          "30s",
          "1m",
          "5m",
          "15m",
          "30m",
          "1h",
          "2h",
          "1d"
        ],
        "time_options": [
          "5m",
          "15m",
          "1h",
          "6h",
          "12h",
          "24h",
          "2d",
          "7d",
          "30d"
        ]
      },
      "timezone": "utc",
      "title": "OpenTelemetry Collector",
      "uid": "BKf2sowmj",
      "version": 72,
      "weekStart": ""
    }
{{- end }}
{{- define "grafana-dashboard-spanmetrics"}}  spanmetrics-dashboard.json: |
    {
      "annotations": {
        "list": [
          {
            "builtIn": 1,
            "datasource": {
              "type": "grafana",
              "uid": "-- Grafana --"
            },
            "enable": true,
            "hide": true,
            "iconColor": "rgba(0, 211, 255, 1)",
            "name": "Annotations & Alerts",
            "target": {
              "limit": 100,
              "matchAny": false,
              "tags": [],
              "type": "dashboard"
            },
            "type": "dashboard"
          }
        ]
      },
      "description": "Spanmetrics way of demo application view.",
      "author": {
        "name": "devrimdemiroz"
        },
      "editable": true,
      "fiscalYearStartMonth": 0,
      "graphTooltip": 0,
      "links": [],
      "liveNow": false,
      "panels": [
        {
          "collapsed": false,
          "gridPos": {
            "h": 1,
            "w": 24,
            "x": 0,
            "y": 0
          },
          "id": 24,
          "panels": [],
          "title": "Service Level - Throughput and Latencies",
          "type": "row"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "blue",
                    "value": null
                  },
                  {
                    "color": "green",
                    "value": 2
                  },
                  {
                    "color": "#EAB839",
                    "value": 64
                  },
                  {
                    "color": "orange",
                    "value": 128
                  },
                  {
                    "color": "red",
                    "value": 256
                  }
                ]
              },
              "unit": "ms"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 20,
            "w": 12,
            "x": 0,
            "y": 1
          },
          "id": 2,
          "interval": "5m",
          "options": {
            "orientation": "auto",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": false
            },
            "showThresholdLabels": false,
            "showThresholdMarkers": true
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "topk(7,histogram_quantile(0.50, sum(rate(duration_milliseconds_bucket{service_name=~\"$service\", span_name=~\"$span_name\"}[$__rate_interval])) by (le,service_name)))",
              "format": "time_series",
              "hide": true,
              "instant": false,
              "interval": "",
              "legendFormat": "\{\{service_name}}-quantile_0.50",
              "range": true,
              "refId": "A"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "topk(7,histogram_quantile(0.95, sum(rate(duration_milliseconds_bucket{service_name=~\"$service\", span_name=~\"$span_name\"}[$__range])) by (le,service_name)))",
              "hide": false,
              "instant": true,
              "interval": "",
              "legendFormat": "\{\{le}} - \{\{service_name}}",
              "range": false,
              "refId": "B"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "histogram_quantile(0.99, sum(rate(duration_milliseconds_bucket{service_name=~\"$service\", span_name=~\"$span_name\"}[$__rate_interval])) by (le,service_name))",
              "hide": true,
              "interval": "",
              "legendFormat": "quantile99",
              "range": true,
              "refId": "C"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "histogram_quantile(0.999, sum(rate(duration_milliseconds_bucket{service_name=~\"$service\", span_name=~\"$span_name\"}[$__rate_interval])) by (le,service_name))",
              "hide": true,
              "interval": "",
              "legendFormat": "quantile999",
              "range": true,
              "refId": "D"
            }
          ],
          "title": "Top 3x3 - Service Latency - quantile95",
          "type": "gauge"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "decimals": 2,
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "super-light-blue",
                    "value": 1
                  },
                  {
                    "color": "#EAB839",
                    "value": 2
                  },
                  {
                    "color": "red",
                    "value": 10
                  }
                ]
              },
              "unit": "reqps"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 13,
            "w": 12,
            "x": 12,
            "y": 1
          },
          "id": 4,
          "interval": "5m",
          "options": {
            "displayMode": "lcd",
            "minVizHeight": 10,
            "minVizWidth": 0,
            "orientation": "horizontal",
            "reduceOptions": {
              "calcs": [
                "mean"
              ],
              "fields": "",
              "values": false
            },
            "showUnfilled": true,
            "text": {}
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "topk(7,sum by (service_name) (rate(calls_total{service_name=~\"$service\", span_name=~\"$span_name\"}[$__range])))",
              "format": "time_series",
              "instant": true,
              "interval": "",
              "legendFormat": "\{\{service_name}}",
              "range": false,
              "refId": "A"
            }
          ],
          "title": "Top 7 Services Mean Rate over Range",
          "transformations": [],
          "type": "bargauge"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-reds"
              },
              "decimals": 4,
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "#EAB839",
                    "value": 1
                  },
                  {
                    "color": "red",
                    "value": 15
                  }
                ]
              },
              "unit": "reqps"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 7,
            "w": 12,
            "x": 12,
            "y": 14
          },
          "id": 15,
          "interval": "5m",
          "options": {
            "displayMode": "lcd",
            "minVizHeight": 10,
            "minVizWidth": 0,
            "orientation": "vertical",
            "reduceOptions": {
              "calcs": [
                "mean"
              ],
              "fields": "",
              "values": false
            },
            "showUnfilled": true,
            "text": {}
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "topk(7,sum(rate(calls_total{status_code=\"STATUS_CODE_ERROR\",service_name=~\"$service\", span_name=~\"$span_name\"}[$__range])) by (service_name))",
              "instant": true,
              "interval": "",
              "legendFormat": "\{\{service_name}}",
              "range": false,
              "refId": "A"
            }
          ],
          "title": "Top 7 Services Mean ERROR Rate over Range",
          "transformations": [],
          "type": "bargauge"
        },
        {
          "collapsed": false,
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "gridPos": {
            "h": 1,
            "w": 24,
            "x": 0,
            "y": 21
          },
          "id": 14,
          "panels": [],
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "refId": "A"
            }
          ],
          "title": "span_names Level - Throughput",
          "type": "row"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "description": "",
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "thresholds"
              },
              "custom": {
                "align": "auto",
                "displayMode": "auto",
                "inspect": false
              },
              "decimals": 2,
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "reqps"
            },
            "overrides": [
              {
                "matcher": {
                  "id": "byName",
                  "options": "bRate"
                },
                "properties": [
                  {
                    "id": "custom.displayMode",
                    "value": "lcd-gauge"
                  },
                  {
                    "id": "color",
                    "value": {
                      "mode": "continuous-BlYlRd"
                    }
                  }
                ]
              },
              {
                "matcher": {
                  "id": "byName",
                  "options": "eRate"
                },
                "properties": [
                  {
                    "id": "custom.displayMode",
                    "value": "lcd-gauge"
                  },
                  {
                    "id": "color",
                    "value": {
                      "mode": "continuous-RdYlGr"
                    }
                  }
                ]
              },
              {
                "matcher": {
                  "id": "byName",
                  "options": "Error Rate"
                },
                "properties": [
                  {
                    "id": "custom.width",
                    "value": 663
                  }
                ]
              },
              {
                "matcher": {
                  "id": "byName",
                  "options": "Rate"
                },
                "properties": [
                  {
                    "id": "custom.width",
                    "value": 667
                  }
                ]
              },
              {
                "matcher": {
                  "id": "byName",
                  "options": "Service"
                },
                "properties": [
                  {
                    "id": "custom.width",
                    "value": null
                  }
                ]
              }
            ]
          },
          "gridPos": {
            "h": 11,
            "w": 24,
            "x": 0,
            "y": 22
          },
          "id": 22,
          "interval": "5m",
          "options": {
            "footer": {
              "fields": "",
              "reducer": [
                "sum"
              ],
              "show": false
            },
            "showHeader": true,
            "sortBy": []
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "exemplar": false,
              "expr": "topk(7, sum(rate(calls_total{service_name=~\"$service\", span_name=~\"$span_name\"}[$__range])) by (span_name,service_name)) ",
              "format": "table",
              "instant": true,
              "interval": "",
              "legendFormat": "",
              "refId": "Rate"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "exemplar": false,
              "expr": "topk(7, sum(rate(calls_total{status_code=\"STATUS_CODE_ERROR\",service_name=~\"$service\", span_name=~\"$span_name\"}[$__range])) by (span_name,service_name))",
              "format": "table",
              "hide": false,
              "instant": true,
              "interval": "",
              "legendFormat": "",
              "refId": "Error Rate"
            }
          ],
          "title": "Top 7 span_names and Errors  (APM Table)",
          "transformations": [
            {
              "id": "seriesToColumns",
              "options": {
                "byField": "span_name"
              }
            },
            {
              "id": "organize",
              "options": {
                "excludeByName": {
                  "Time 1": true,
                  "Time 2": true
                },
                "indexByName": {},
                "renameByName": {
                  "Value #Error Rate": "Error Rate",
                  "Value #Rate": "Rate",
                  "service_name 1": "Rate in Service",
                  "service_name 2": "Error Rate in Service"
                }
              }
            },
            {
              "id": "calculateField",
              "options": {
                "alias": "bRate",
                "mode": "reduceRow",
                "reduce": {
                  "include": [
                    "Rate"
                  ],
                  "reducer": "sum"
                }
              }
            },
            {
              "id": "calculateField",
              "options": {
                "alias": "eRate",
                "mode": "reduceRow",
                "reduce": {
                  "include": [
                    "Error Rate"
                  ],
                  "reducer": "sum"
                }
              }
            },
            {
              "id": "organize",
              "options": {
                "excludeByName": {
                  "Error Rate": true,
                  "Rate": true,
                  "bRate": false
                },
                "indexByName": {
                  "Error Rate": 4,
                  "Error Rate in Service": 6,
                  "Rate": 1,
                  "Rate in Service": 5,
                  "bRate": 2,
                  "eRate": 3,
                  "span_name": 0
                },
                "renameByName": {
                  "Rate in Service": "Service",
                  "bRate": "Rate",
                  "eRate": "Error Rate",
                  "span_name": "span_name Name"
                }
              }
            },
            {
              "id": "sortBy",
              "options": {
                "fields": {},
                "sort": [
                  {
                    "desc": true,
                    "field": "Rate"
                  }
                ]
              }
            }
          ],
          "type": "table"
        },
        {
          "collapsed": false,
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "gridPos": {
            "h": 1,
            "w": 24,
            "x": 0,
            "y": 33
          },
          "id": 20,
          "panels": [],
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "refId": "A"
            }
          ],
          "title": "span_name Level - Latencies",
          "type": "row"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "blue",
                    "value": null
                  },
                  {
                    "color": "green",
                    "value": 2
                  },
                  {
                    "color": "#EAB839",
                    "value": 64
                  },
                  {
                    "color": "orange",
                    "value": 128
                  },
                  {
                    "color": "red",
                    "value": 256
                  }
                ]
              },
              "unit": "ms"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 13,
            "w": 12,
            "x": 0,
            "y": 34
          },
          "id": 25,
          "interval": "5m",
          "options": {
            "orientation": "auto",
            "reduceOptions": {
              "calcs": [
                "lastNotNull"
              ],
              "fields": "",
              "values": false
            },
            "showThresholdLabels": false,
            "showThresholdMarkers": true
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "topk(7,histogram_quantile(0.50, sum(rate(duration_milliseconds_bucket{service_name=~\"$service\", span_name=~\"$span_name\"}[$__rate_interval])) by (le,service_name)))",
              "format": "time_series",
              "hide": true,
              "instant": false,
              "interval": "",
              "legendFormat": "\{\{service_name}}-quantile_0.50",
              "range": true,
              "refId": "A"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "topk(7,histogram_quantile(0.95, sum(rate(duration_milliseconds_bucket{service_name=~\"$service\", span_name=~\"$span_name\"}[$__range])) by (le,span_name)))",
              "hide": false,
              "instant": true,
              "interval": "",
              "legendFormat": "\{\{span_name}}",
              "range": false,
              "refId": "B"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "histogram_quantile(0.99, sum(rate(duration_milliseconds_bucket{service_name=~\"$service\", span_name=~\"$span_name\"}[$__rate_interval])) by (le,service_name))",
              "hide": true,
              "interval": "",
              "legendFormat": "quantile99",
              "range": true,
              "refId": "C"
            },
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "histogram_quantile(0.999, sum(rate(duration_milliseconds_bucket{service_name=~\"$service\", span_name=~\"$span_name\"}[$__rate_interval])) by (le,service_name))",
              "hide": true,
              "interval": "",
              "legendFormat": "quantile999",
              "range": true,
              "refId": "D"
            }
          ],
          "title": "Top 3x3 - span_name Latency - quantile95",
          "type": "gauge"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "continuous-BlYlRd"
              },
              "decimals": 2,
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "ms"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 13,
            "w": 12,
            "x": 12,
            "y": 34
          },
          "id": 10,
          "interval": "5m",
          "options": {
            "displayMode": "lcd",
            "minVizHeight": 10,
            "minVizWidth": 0,
            "orientation": "horizontal",
            "reduceOptions": {
              "calcs": [
                "mean"
              ],
              "fields": "",
              "values": false
            },
            "showUnfilled": true
          },
          "pluginVersion": "9.1.0",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": false,
              "expr": "topk(7, sum by (span_name,service_name)(increase(duration_milliseconds_sum{service_name=~\"${service}\", span_name=~\"$span_name\"}[5m]) / increase(duration_milliseconds_count{service_name=~\"${service}\",span_name=~\"$span_name\"}[5m\n])))",
              "instant": true,
              "interval": "",
              "legendFormat": "\{\{span_name}} [\{\{service_name}}]",
              "range": false,
              "refId": "A"
            }
          ],
          "title": "Top 7 Highest Endpoint Latencies  Mean Over Range ",
          "transformations": [],
          "type": "bargauge"
        },
        {
          "datasource": {
            "type": "prometheus",
            "uid": "webstore-metrics"
          },
          "fieldConfig": {
            "defaults": {
              "color": {
                "mode": "palette-classic"
              },
              "custom": {
                "axisCenteredZero": false,
                "axisColorMode": "text",
                "axisLabel": "",
                "axisPlacement": "auto",
                "barAlignment": 0,
                "drawStyle": "line",
                "fillOpacity": 15,
                "gradientMode": "none",
                "hideFrom": {
                  "legend": false,
                  "tooltip": false,
                  "viz": false
                },
                "lineInterpolation": "smooth",
                "lineWidth": 1,
                "pointSize": 5,
                "scaleDistribution": {
                  "type": "linear"
                },
                "showPoints": "auto",
                "spanNulls": false,
                "stacking": {
                  "group": "A",
                  "mode": "none"
                },
                "thresholdsStyle": {
                  "mode": "off"
                }
              },
              "mappings": [],
              "thresholds": {
                "mode": "absolute",
                "steps": [
                  {
                    "color": "green",
                    "value": null
                  },
                  {
                    "color": "red",
                    "value": 80
                  }
                ]
              },
              "unit": "ms"
            },
            "overrides": []
          },
          "gridPos": {
            "h": 12,
            "w": 24,
            "x": 0,
            "y": 47
          },
          "id": 16,
          "interval": "5m",
          "options": {
            "legend": {
              "calcs": [
                "mean",
                "logmin",
                "max",
                "delta"
              ],
              "displayMode": "table",
              "placement": "bottom",
              "showLegend": true
            },
            "tooltip": {
              "mode": "single",
              "sort": "none"
            }
          },
          "pluginVersion": "8.4.7",
          "targets": [
            {
              "datasource": {
                "type": "prometheus",
                "uid": "webstore-metrics"
              },
              "editorMode": "code",
              "exemplar": true,
              "expr": "topk(7,sum by (span_name,service_name)(increase(duration_milliseconds_sum{service_name=~\"$service\", span_name=~\"$span_name\"}[$__rate_interval]) / increase(duration_milliseconds_count{service_name=~\"$service\", span_name=~\"$span_name\"}[$__rate_interval])))",
              "instant": false,
              "interval": "",
              "legendFormat": "[\{\{service_name}}]  \{\{span_name}}",
              "range": true,
              "refId": "A"
            }
          ],
          "title": "Top 7 Latencies Over Range ",
          "type": "timeseries"
        }
      ],
      "refresh": "5m",
      "schemaVersion": 37,
      "style": "dark",
      "tags": [],
      "templating": {
        "list": [
          {
            "allValue": ".*",
            "current": {
              "selected": false,
              "text": "All",
              "value": "$__all"
            },
            "datasource": {
              "type": "prometheus",
              "uid": "webstore-metrics"
            },
            "definition": "query_result(count by (service_name)(count_over_time(calls_total[$__range])))",
            "hide": 0,
            "includeAll": true,
            "multi": true,
            "name": "service",
            "options": [],
            "query": {
              "query": "query_result(count by (service_name)(count_over_time(calls_total[$__range])))",
              "refId": "StandardVariableQuery"
            },
            "refresh": 2,
            "regex": "/.*service_name=\"(.*)\".*/",
            "skipUrlSync": false,
            "sort": 1,
            "type": "query"
          },
          {
            "allValue": ".*",
            "current": {
              "selected": false,
              "text": "All",
              "value": "$__all"
            },
            "datasource": {
              "type": "prometheus",
              "uid": "webstore-metrics"
            },
            "definition": "query_result(sum ({__name__=~\".*calls_total\",service_name=~\"$service\"})  by (span_name))",
            "hide": 0,
            "includeAll": true,
            "multi": true,
            "name": "span_name",
            "options": [],
            "query": {
              "query": "query_result(sum ({__name__=~\".*calls_total\",service_name=~\"$service\"})  by (span_name))",
              "refId": "StandardVariableQuery"
            },
            "refresh": 2,
            "regex": "/.*span_name=\"(.*)\".*/",
            "skipUrlSync": false,
            "sort": 0,
            "type": "query"
          }
        ]
      },
      "time": {
        "from": "now-1h",
        "to": "now"
      },
      "timepicker": {},
      "timezone": "",
      "title": "Spanmetrics Demo Dashboard",
      "uid": "W2gX2zHVk48",
      "version": 1,
      "weekStart": ""
    }
{{- end}}
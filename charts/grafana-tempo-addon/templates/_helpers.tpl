{{- define "authSecretName" -}}
{{- if .Values.addonValues.grafanaTempoAddon.valuesObject.secretName -}}
{{- .Values.addonValues.grafanaTempoAddon.valuesObject.secretName -}}
{{- else -}}
tempo-gw-auth
{{- end -}}
{{- end -}}


{{- define "sourceAuthSecretName" -}}
{{- $authSecretName := include "authSecretName" . -}}
{{- printf "%s-source" $authSecretName -}}
{{- end -}}

{{- define "tlsSecretName" -}}
{{- if .Values.addonValues.grafanaTempoAddon.valuesObject.ingress.tlsSecretName -}}
{{- .Values.addonValues.grafanaTempoAddon.valuesObject.ingress.tlsSecretName -}}
{{- else -}}
grafana-tempo-gw-tls-cert-{{ .Release.Name }}
{{- end -}}
{{- end -}}

{{/*
Looks if there's an existing secret and reuse its user. If not it generates
new user and use it.
*/}}
{{- define "tempo.username" -}}
{{- $secret := (lookup "v1" "Secret" "{{destination.namespace}}" (include "sourceAuthSecretName" .) ) }}
{{- if $secret }}
{{- $user := index $secret "data" "user" }}
{{$user}}
{{- else }}
{{- $user := (randAlphaNum 40) }}
{{- $user}}
{{- end }}
{{- end }}


{{- define "defaultPresetTempo"}}enabled: true
fullnameOverride: tracing-tempo
traces:
  otlp:
    grpc:
      enabled: true
{{- end}}
{{- define "authSecretName" -}}
{{- if .Values.addonValues.grafanaTempoAddon.valuesObject.secretName -}}
{{- .Values.addonValues.grafanaTempoAddon.valuesObject.secretName -}}
{{- else -}}
tempo-gw-auth
{{- end -}}
{{- end -}}
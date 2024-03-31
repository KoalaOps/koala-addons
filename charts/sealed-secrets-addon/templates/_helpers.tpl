{{- define "defaultPresetSealedSecrets"}}
    fullnameOverride: "sealed-secrets-controller"
{{- end}}

{{/*
Find secret by prefix
*/}}
{{- define "chart.findSecretByPrefix" -}}
{{- $desiredPrefix := .desiredPrefix -}}
{{- $namespace := .namespace -}}
{{- $allSecrets := lookup "v1" "Secret" $namespace "" -}}
{{- $matchedSecret := dict -}}
{{- range $allSecrets.items -}}
  {{- if and .metadata.name (hasPrefix $desiredPrefix .metadata.name) -}}
    {{- if eq (len $matchedSecret) 0 -}}
      {{- $matchedSecret = . -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- if gt (len $matchedSecret) 0 -}}
{{- $matchedSecret -}}
{{- else -}}
{{- printf "No secret found with prefix '%s' in namespace '%s'" $desiredPrefix $namespace -}}
{{- end -}}
{{- end -}}

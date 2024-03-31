{{- define "defaultPresetSealedSecrets"}}
    fullnameOverride: "sealed-secrets-controller"
{{- end}}


{{/*
Find secret by prefix and label
*/}}
{{- define "chart.findSecretByPrefixAndLabel" -}}
{{- $desiredPrefix := .desiredPrefix -}}
{{- $namespace := .namespace -}}
{{- $allSecrets := lookup "v1" "Secret" $namespace "" -}}
{{- $matchedSecret := dict -}}
{{- range $allSecrets.items -}}
  {{- if hasPrefix $desiredPrefix .metadata.name -}}
    {{- if eq (len $matchedSecret) 0 -}}
      {{- $matchedSecret = . -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- if gt (len $matchedSecret) 0 -}}
{{- $tlsCert := index $matchedSecret "data" "tls.crt" }}
{{- $tlsKey := index $matchedSecret "data" "tls.key" }}
tls.crt: {{ $tlsCert | b64enc | quote }}
tls.key: {{ $tlsKey  | b64enc | quote }}
{{- else -}}
error: {{ printf "No secret found with prefix '%s' and label 'sealedsecrets.bitnami.com/sealed-secrets-key: active' in namespace '%s'" $desiredPrefix $namespace  | quote }}
{{- end -}}
{{- end -}}

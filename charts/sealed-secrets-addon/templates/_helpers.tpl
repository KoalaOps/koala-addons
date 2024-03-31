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
  {{- if and (hasPrefix $desiredPrefix .metadata.name) (eq (index .metadata.labels "sealedsecrets.bitnami.com/sealed-secrets-key") "active") -}}
    {{- if eq (len $matchedSecret) 0 -}} # Check if $matchedSecret is still the placeholder
      {{- $matchedSecret = . -}} # Assign the first matching secret
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- if gt (len $matchedSecret) 0 -}}
{{- $tlsCert := index $matchedSecret "data" "tls.crt" }}
{{- $tlsKey := index $matchedSecret "data" "tls.key" }}
tls.crt: {{ $tlsCert | b64enc | quote }}
tls.key: {{ $tlsKey  | b64enc | quote }}
{{- else -}}
{{- printf "No secret found with prefix '%s' and label 'sealedsecrets.bitnami.com/sealed-secrets-key: active' in namespace '%s'" $desiredPrefix $namespace -}}
{{- end -}}
{{- end -}}

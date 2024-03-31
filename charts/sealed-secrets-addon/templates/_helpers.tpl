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
{{- $tlsCert := index . "data" "tls.crt" }}
{{- $tlsKey := index . "data" "tls.key" }}
tls.crt: {{ $tlsCert | b64enc | quote }}
tls.key: {{ $tlsKey  | b64enc | quote }}
{{- end -}}
{{- end -}}

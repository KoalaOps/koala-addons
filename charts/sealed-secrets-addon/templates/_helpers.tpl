{{- define "defaultPresetSealedSecrets"}}
    fullnameOverride: "sealed-secrets-controller"
{{- end}}


{{/*
Find secret by prefix and label
*/}}
{{- define "chart.findSecretByPrefixAndLabel" -}}
{{- $namespace := .namespace -}}
{{ range $index, $service := (lookup "v1" "Service" $namespace "").items }}
test{{$index}}: test
{{- end}}
{{ range $index, $service := (lookup "v1" "Secret" $namespace "").items }}
atest{{$index}}: test
{{- $tlsCert := index . "data" "tls.crt" }}
{{- $tlsKey := index . "data" "tls.key" }}
tls.crt: {{ $tlsCert | b64enc | quote }}
tls.key: {{ $tlsKey  | b64enc | quote }}
{{ end }}
{{- end -}}

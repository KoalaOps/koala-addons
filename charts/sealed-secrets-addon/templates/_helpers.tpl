{{- define "defaultPresetSealedSecrets"}}sealedsecrets:
    fullnameOverride: "sealed-secrets-controller"
    keyrenewperiod: "0"
{{- end}}
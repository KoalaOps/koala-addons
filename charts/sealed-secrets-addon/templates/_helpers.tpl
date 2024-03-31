{{- define "defaultPresetSealedSecrets"}}
    fullnameOverride: "sealed-secrets-controller"
{{- end}}


To modify the helper template to handle multiple matching secrets by prefix and choose the one with a specific label (sealedsecrets.bitnami.com/sealed-secrets-key: active), you can incorporate additional logic to filter based on this label. This approach ensures that among the secrets that match the given prefix, only the one with the specified label is selected.

Here's how you can adjust the _helpers.tpl helper definition to include this filtering logic:

yaml
Copy code
{{/*
Find secret by prefix and label
*/}}
{{- define "chart.findSecretByPrefixAndLabel" -}}
{{- $desiredPrefix := .desiredPrefix -}}
{{- $namespace := .namespace -}}
{{- $allSecrets := lookup "v1" "Secret" $namespace "" -}}
{{- $matchedSecrets := slice -}} # Initialize an empty slice to collect matching secrets
{{- range $allSecrets.items -}}
  {{- if and (hasPrefix $desiredPrefix .metadata.name) (eq (index .metadata.labels "sealedsecrets.bitnami.com/sealed-secrets-key") "active") -}}
    {{- $matchedSecrets = append $matchedSecrets . -}} # Add matching secret to slice
  {{- end -}}
{{- end -}}

{{- if gt (len $matchedSecrets) 0 -}}
  {{- index $matchedSecrets 0 -}} # Return the first matched secret
{{- else -}}
  {{- printf "No secret found with prefix '%s' and label 'sealedsecrets.bitnami.com/sealed-secrets-key: active' in namespace '%s'" $desiredPrefix $namespace -}}
{{- end -}}
{{- end -}}

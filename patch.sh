set -eu;

rm -rf /n8n

git clone --branch n8n@$RELEASE --filter=tree:0 --single-branch https://github.com/n8n-io/n8n.git /n8n

sed -i '/isLicensed(feature: BooleanLicenseFeature)/ {n; s/^[[:space:]]*return.*/\t\treturn true;/}' /n8n/packages/cli/src/license.ts
sed -i '/getPlanName(): string / {n; s/^[[:space:]]*return.*/\t\treturn "Enterprise";/}' /n8n/packages/cli/src/license.ts
sed -i '/isLicensed(_feature: BooleanLicenseFeature)/ {n; s/^[[:space:]]*\w*/\t\treturn true;/}' /n8n/packages/@n8n/backend-common/src/license-state.ts

sed -i $'/isLicensed(feature: BooleanLicenseFeature)[[:space:]]*{/a\\\n    return true;' /n8n/packages/@n8n/backend-common/src/license-state.ts
sed -i 's/this\.getValue.*/UNLIMITED_LICENSE_QUOTA;/' /n8n/packages/@n8n/backend-common/src/license-state.ts
sed -i 's/!options?.feature/true/' /n8n/packages/frontend/editor-ui/src/app/utils/rbac/checks/isEnterpriseFeatureEnabled.ts
sed -i 's/license.getUsersLimit() !== UNLIMITED_USERS_QUOTA/false/' /n8n/packages/cli/src/public-api/v1/shared/middlewares/global.middleware.ts
sed -i 's/Container.get(License).isLicensed(feature)/true/' /n8n/packages/cli/src/public-api/v1/shared/middlewares/global.middleware.ts

sed -i 's|"settings\.usageAndPlan\.description": "You’re on the {name} {type}"|"settings.usageAndPlan.description": "You’re on the {name} {type} (provided by {link})"|' /n8n/packages/frontend/@n8n/i18n/src/locales/en.json

sed -i  '/<template #name>{{ badgedPlanName.name ?? usageStore.planName }}<\/template>/a\
<template #link><a href="https://github.com/M-Ahadi/n8n-enterprise" target="_blank" rel="noopener noreferrer">Mojtaba Ahadi<\/a><\/template>' /n8n/packages/frontend/editor-ui/src/features/settings/usage/views/SettingsUsageAndPlan.vue



python3 - <<'PY'
import re
fname = "/n8n/packages/cli/src/license.ts"

with open(fname, "r", encoding="utf-8") as f:
    s = f.read()

pattern = re.compile(
    r'(^\s*getValue<T extends keyof FeatureReturnType>\(feature: T\): FeatureReturnType\[T\]\s*\{\n)'
    r'.*?'
    r'^\s*\}\s*',
    re.M | re.S
)

replacement = (
    r"\1\t\t// BYPASSED: Return unlimited quotas for enterprise features\n"
    r"\t\tif (feature === 'planName') {\n"
    r"\t\t\treturn 'Enterprise' as FeatureReturnType[T];\n"
    r"\t\t}\n\n"
    r"\t\t// For quota features, return unlimited (-1)\n"
    r"\t\tif (feature.toString().includes('quota:')) {\n"
    r"\t\t\treturn UNLIMITED_LICENSE_QUOTA as FeatureReturnType[T];\n"
    r"\t\t}\n\n"
    r"\t\t// For all other features, try to get the real value first, then fallback to unlimited\n"
    r"\t\tconst realValue = this.manager?.getFeatureValue(feature) as FeatureReturnType[T];\n"
    r"\t\tif (realValue !== undefined && realValue !== null) {\n"
    r"\t\t\treturn realValue;\n"
    r"\t\t}\n\n"
    r"\t\t// Default to unlimited for numeric values, true for boolean values\n"
    r"\t\treturn UNLIMITED_LICENSE_QUOTA as FeatureReturnType[T];\n"
    r"\t}\n"
)

new_s, n = pattern.subn(replacement, s)

if n == 0:
    print("Warning: no function matched. No changes made.")
else:
    with open(fname, "w", encoding="utf-8") as f:
        f.write(new_s)
PY
cd /n8n
yes "" | pnpm install
pnpm run build:docker

rm -rf /n8n
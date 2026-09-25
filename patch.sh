set -euo pipefail

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

sed -i 's|"settings\.usageAndPlan\.description": "You’re on the {name} {type}"|"settings.usageAndPlan.description": "You’re on the {name} {type} (provided by {link}). Join {telegram} for the latest release."|' /n8n/packages/frontend/@n8n/i18n/src/locales/en.json

sed -i  '/<template #name>{{ badgedPlanName.name ?? usageStore.planName }}<\/template>/a\
<template #link><a href="https://github.com/M-Ahadi/n8n-enterprise" target="_blank" rel="noopener noreferrer">Mojtaba Ahadi<\/a><\/template>\n<template #telegram><a href="https://t.me/n8n_release" target="_blank" rel="noopener noreferrer">n8n Telegram Channel<\/a><\/template>' /n8n/packages/frontend/editor-ui/src/features/settings/usage/views/SettingsUsageAndPlan.vue

sed -i 's/showNonProdBanner: .*/showNonProdBanner: false,\/\/Bypass/' /n8n/packages/cli/src/services/frontend.service.ts

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

# Add Telegram link to MainSidebar.vue
sidebar_file = "/n8n/packages/frontend/editor-ui/src/app/components/MainSidebar.vue"
with open(sidebar_file, "r", encoding="utf-8") as f:
    sidebar_content = f.read()

target = "const mainMenuItems = computed<IMenuItem[]>(() => ["
telegram_item = """const mainMenuItems = computed<IMenuItem[]>(() => [
	{
		id: 'telegram',
		icon: 'telegram',
		label: 'Telegram Channel',
		position: 'bottom',
		link: {
			href: 'https://t.me/n8n_release',
			target: '_blank',
		},
	},{
		id: 'github',
		icon: 'github',
		label: 'Github',
		position: 'bottom',
		link: {
			href: 'https://github.com/M-Ahadi/n8n-enterprise',
			target: '_blank',
		},
	},"""

if target in sidebar_content:
    with open(sidebar_file, "w", encoding="utf-8") as f:
        f.write(sidebar_content.replace(target, telegram_item, 1))
else:
    print("Warning: mainMenuItems not found in MainSidebar.vue")
PY
cd /n8n
pnpm install --frozen-lockfile

pnpm run build:docker

rm -rf /n8n

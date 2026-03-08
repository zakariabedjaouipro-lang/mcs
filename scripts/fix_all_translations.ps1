# Fix All Translations Script
# This script replaces all AppLocalizations.of(context).translate() calls with context.translateSafe()

Write-Host "🔧 Starting translation fixes..." -ForegroundColor Green
Write-Host ""

$files = Get-ChildItem -Path "lib" -Recurse -Filter "*.dart"
$fixedCount = 0
$totalFiles = $files.Count

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw

    # Skip if file doesn't contain AppLocalizations
    if ($content -notmatch 'AppLocalizations\.of\(context\)\.translate\(') {
        continue
    }

    # Replace AppLocalizations.of(context).translate('key') with context.translateSafe('key')
    $newContent = $content -replace 'AppLocalizations\.of\(context\)\.translate\(''([^'']+)''\)', 'context.translateSafe(''$1'')'

    # Replace AppLocalizations.of(context).translate("key") with context.translateSafe("key")
    $newContent = $newContent -replace 'AppLocalizations\.of\(context\)\.translate\("([^"]+)"\)', 'context.translateSafe("$1")'

    # Replace AppLocalizations.of(context).translate(variable) with context.translateSafe(variable)
    $newContent = $newContent -replace 'AppLocalizations\.of\(context\)\.translate\(([^)]+)\)', 'context.translateSafe($1)'

    if ($newContent -ne $content) {
        $newContent | Set-Content $file.FullName -NoNewline
        $fixedCount++
        Write-Host "✅ Fixed: $($file.Name)" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "📊 Summary:" -ForegroundColor Cyan
Write-Host "   Total files scanned: $totalFiles" -ForegroundColor White
Write-Host "   Files fixed: $fixedCount" -ForegroundColor Green
Write-Host ""
Write-Host "🎉 Translation fixes completed!" -ForegroundColor Green
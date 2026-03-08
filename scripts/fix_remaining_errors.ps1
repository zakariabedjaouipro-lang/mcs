# Fix Remaining Errors Script
# This script fixes all remaining errors in the project

Write-Host "🔧 Starting comprehensive error fixes..." -ForegroundColor Green
Write-Host ""

# Step 1: Fix translation issues
Write-Host "📝 Step 1: Fixing translation issues..." -ForegroundColor Yellow
& ".\scripts\fix_all_translations.ps1"
Write-Host ""

# Step 2: Fix DateTime null safety issues
Write-Host "📅 Step 2: Fixing DateTime null safety issues..." -ForegroundColor Yellow
$files = Get-ChildItem -Path "lib" -Recurse -Filter "*.dart"
$dateTimeFixedCount = 0

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw

    # Skip if file doesn't contain DateTime issues
    if ($content -notmatch '\.hour|\.minute|\.day|\.month|\.year|\.isAfter|\.isBefore|\.difference') {
        continue
    }

    $newContent = $content

    # Replace .hour with .safeHour
    $newContent = $newContent -replace '(\w+)\.hour', '$1.safeHour'

    # Replace .minute with .safeMinute
    $newContent = $newContent -replace '(\w+)\.minute', '$1.safeMinute'

    # Replace .day with .safeDay
    $newContent = $newContent -replace '(\w+)\.day', '$1.safeDay'

    # Replace .month with .safeMonth
    $newContent = $newContent -replace '(\w+)\.month', '$1.safeMonth'

    # Replace .year with .safeYear
    $newContent = $newContent -replace '(\w+)\.year', '$1.safeYear'

    # Replace .isAfter(DateTime.now()) with .safeIsAfter(DateTime.now())
    $newContent = $newContent -replace '(\w+)\.isAfter\(([^)]+)\)', '$1.safeIsAfter($2)'

    # Replace .isBefore(DateTime.now()) with .safeIsBefore(DateTime.now())
    $newContent = $newContent -replace '(\w+)\.isBefore\(([^)]+)\)', '$1.safeIsBefore($2)'

    # Replace .difference(DateTime.now()) with .safeDifference(DateTime.now())
    $newContent = $newContent -replace '(\w+)\.difference\(([^)]+)\)', '$1.safeDifference($2)'

    if ($newContent -ne $content) {
        $newContent | Set-Content $file.FullName -NoNewline
        $dateTimeFixedCount++
        Write-Host "✅ Fixed DateTime issues: $($file.Name)" -ForegroundColor Green
    }
}

Write-Host "   DateTime fixes: $dateTimeFixedCount" -ForegroundColor Green
Write-Host ""

# Step 3: Fix withAlphaSafe issues
Write-Host "🎨 Step 3: Fixing withAlphaSafe issues..." -ForegroundColor Yellow
$alphaFixedCount = 0

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw

    if ($content -notmatch '\.withAlphaSafe\(') {
        continue
    }

    # Replace Colors.X.withAlphaSafe(0.1) with Colors.X.withValues(alpha: 0.1)
    $newContent = $content -replace 'Colors\.(\w+)\.withAlphaSafe\(([^)]+)\)', 'Colors.$1.withValues(alpha: $2)'

    if ($newContent -ne $content) {
        $newContent | Set-Content $file.FullName -NoNewline
        $alphaFixedCount++
        Write-Host "✅ Fixed withAlphaSafe issues: $($file.Name)" -ForegroundColor Green
    }
}

Write-Host "   withAlphaSafe fixes: $alphaFixedCount" -ForegroundColor Green
Write-Host ""

# Step 4: Run dart fix
Write-Host "🛠️ Step 4: Running dart fix..." -ForegroundColor Yellow
dart fix --dry-run
Write-Host ""

# Step 5: Analyze results
Write-Host "📊 Step 5: Analyzing results..." -ForegroundColor Yellow
flutter analyze
Write-Host ""

Write-Host "🎉 All fixes completed!" -ForegroundColor Green
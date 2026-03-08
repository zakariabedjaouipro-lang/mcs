# Find All Dart Files Script
# This script finds all Dart files in the project

Write-Host "🔍 Finding all Dart files..." -ForegroundColor Green
Write-Host ""

# Find all screen files
Write-Host "📱 Screen files:" -ForegroundColor Cyan
$screenFiles = Get-ChildItem -Path "lib" -Recurse -Filter "*screen*.dart"
foreach ($file in $screenFiles) {
    Write-Host "   $($file.FullName)" -ForegroundColor White
}

Write-Host ""
Write-Host "📄 Total screen files: $($screenFiles.Count)" -ForegroundColor Green
Write-Host ""

# Find all page files
Write-Host "📄 Page files:" -ForegroundColor Cyan
$pageFiles = Get-ChildItem -Path "lib" -Recurse -Filter "*page*.dart"
foreach ($file in $pageFiles) {
    Write-Host "   $($file.FullName)" -ForegroundColor White
}

Write-Host ""
Write-Host "📄 Total page files: $($pageFiles.Count)" -ForegroundColor Green
Write-Host ""

# Find all dialog files
Write-Host "💬 Dialog files:" -ForegroundColor Cyan
$dialogFiles = Get-ChildItem -Path "lib" -Recurse -Filter "*dialog*.dart"
foreach ($file in $dialogFiles) {
    Write-Host "   $($file.FullName)" -ForegroundColor White
}

Write-Host ""
Write-Host "📄 Total dialog files: $($dialogFiles.Count)" -ForegroundColor Green
Write-Host ""

# Find all bottom_sheet files
Write-Host "📋 Bottom sheet files:" -ForegroundColor Cyan
$bottomSheetFiles = Get-ChildItem -Path "lib" -Recurse -Filter "*bottom_sheet*.dart"
foreach ($file in $bottomSheetFiles) {
    Write-Host "   $($file.FullName)" -ForegroundColor White
}

Write-Host ""
Write-Host "📄 Total bottom sheet files: $($bottomSheetFiles.Count)" -ForegroundColor Green
Write-Host ""

# Summary
$totalFiles = $screenFiles.Count + $pageFiles.Count + $dialogFiles.Count + $bottomSheetFiles.Count
Write-Host "📊 Summary:" -ForegroundColor Yellow
Write-Host "   Screen files: $($screenFiles.Count)" -ForegroundColor White
Write-Host "   Page files: $($pageFiles.Count)" -ForegroundColor White
Write-Host "   Dialog files: $($dialogFiles.Count)" -ForegroundColor White
Write-Host "   Bottom sheet files: $($bottomSheetFiles.Count)" -ForegroundColor White
Write-Host "   Total UI files: $totalFiles" -ForegroundColor Green
Write-Host ""

Write-Host "✅ Search completed!" -ForegroundColor Green
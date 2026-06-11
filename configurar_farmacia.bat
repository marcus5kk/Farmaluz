@echo off
chcp 65001 > nul
echo ========================================
echo   Configurador de Farmacia - APK Builder
echo ========================================
echo.

set /p FARMACIA_ID=ID da farmacia (numero do admin): 
set /p NOME_FARMACIA=Nome da farmacia (ex: Farmaluz): 
set /p PACKAGE_NAME=Package name (ex: com.farmaluz.app): 
set /p COR_PRINCIPAL=Cor principal em hex (ex: #E63946): 
set /p COR_FUNDO=Cor de fundo em hex (ex: #F5F5F5): 

echo.
echo --- Confirmacao ---
echo ID:        %FARMACIA_ID%
echo Nome:      %NOME_FARMACIA%
echo Package:   %PACKAGE_NAME%
echo Cor:       %COR_PRINCIPAL%
echo Fundo:     %COR_FUNDO%
echo.
set /p CONFIRMA=Confirmar? (s/n): 
if /i "%CONFIRMA%" neq "s" (
  echo Cancelado.
  exit /b 0
)

rem --- 1. Atualiza app_config.dart ---
echo ^>^> Atualizando app_config.dart...
(
echo class AppConfig {
echo   static const int farmaciaId = %FARMACIA_ID%;
echo   static const String nomeFarmacia = "%NOME_FARMACIA%";
echo   static const String apiBaseUrl = "https://api.appfarmacias.com.br";
echo   static const String corPrimaria = "%COR_PRINCIPAL%";
echo   static const String corSecundaria = "#FFFFFF";
echo   static const String corFundo = "%COR_FUNDO%";
echo }
) > lib\config\app_config.dart

rem --- 2. Atualiza build.gradle.kts ---
echo ^>^> Atualizando build.gradle.kts...
powershell -Command "(Get-Content android\app\build.gradle.kts) -replace 'namespace = \".*\"', 'namespace = \"%PACKAGE_NAME%\"' -replace 'applicationId = \".*\"', 'applicationId = \"%PACKAGE_NAME%\"' | Set-Content android\app\build.gradle.kts"

rem --- 3. Cria pasta e MainActivity.kt ---
echo ^>^> Criando MainActivity.kt no package correto...
set PACKAGE_PATH=%PACKAGE_NAME:.=\%
set FULL_PATH=android\app\src\main\kotlin\%PACKAGE_PATH%
if not exist "%FULL_PATH%" mkdir "%FULL_PATH%"
(
echo package %PACKAGE_NAME%
echo.
echo import io.flutter.embedding.android.FlutterActivity
echo.
echo class MainActivity : FlutterActivity^(^)
) > "%FULL_PATH%\MainActivity.kt"

rem --- 4. Atualiza AndroidManifest.xml ---
echo ^>^> Atualizando AndroidManifest.xml...
powershell -Command "(Get-Content android\app\src\main\AndroidManifest.xml) -replace 'android:label="".*""', 'android:label=""%NOME_FARMACIA%""' | Set-Content android\app\src\main\AndroidManifest.xml"

echo.
echo ========================================
echo   Pronto! Agora execute no terminal:
echo   flutter clean
echo   flutter build apk --release
echo ========================================
pause

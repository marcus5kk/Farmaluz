#!/bin/bash

# ============================================================
#  CONFIGURAR FARMÁCIA - Script de configuração automática
#  Uso: ./configurar_farmacia.sh
# ============================================================

echo "========================================"
echo "  Configurador de Farmácia - APK Builder"
echo "========================================"
echo ""

read -p "ID da farmácia (número do admin): " FARMACIA_ID
read -p "Nome da farmácia (ex: Farmaluz): " NOME_FARMACIA
read -p "Package name (ex: com.farmaluz.app): " PACKAGE_NAME
read -p "Cor principal em hex (ex: #E63946): " COR_PRINCIPAL
read -p "Cor de fundo em hex (ex: #F5F5F5): " COR_FUNDO

echo ""
echo "--- Confirmação ---"
echo "ID:        $FARMACIA_ID"
echo "Nome:      $NOME_FARMACIA"
echo "Package:   $PACKAGE_NAME"
echo "Cor:       $COR_PRINCIPAL"
echo "Fundo:     $COR_FUNDO"
echo ""
read -p "Confirmar? (s/n): " CONFIRMA

if [ "$CONFIRMA" != "s" ] && [ "$CONFIRMA" != "S" ]; then
  echo "Cancelado."
  exit 0
fi

# --- 1. Atualiza app_config.dart ---
echo ">> Atualizando app_config.dart..."
cat > lib/config/app_config.dart << EOF
class AppConfig {
  static const int farmaciaId = $FARMACIA_ID;
  static const String nomeFarmacia = "$NOME_FARMACIA";
  static const String apiBaseUrl = "https://api.appfarmacias.com.br";
  static const String corPrimaria = "$COR_PRINCIPAL";
  static const String corSecundaria = "#FFFFFF";
  static const String corFundo = "$COR_FUNDO";
}
EOF

# --- 2. Atualiza build.gradle.kts ---
echo ">> Atualizando build.gradle.kts..."
sed -i "s|namespace = \".*\"|namespace = \"$PACKAGE_NAME\"|g" android/app/build.gradle.kts
sed -i "s|applicationId = \".*\"|applicationId = \"$PACKAGE_NAME\"|g" android/app/build.gradle.kts

# --- 3. Cria a pasta e MainActivity.kt no package correto ---
echo ">> Criando MainActivity.kt no package correto..."
PACKAGE_PATH=$(echo $PACKAGE_NAME | tr '.' '/')
mkdir -p android/app/src/main/kotlin/$PACKAGE_PATH
cat > android/app/src/main/kotlin/$PACKAGE_PATH/MainActivity.kt << EOF
package $PACKAGE_NAME

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity()
EOF

# --- 4. Atualiza o nome do app no AndroidManifest.xml ---
echo ">> Atualizando AndroidManifest.xml..."
sed -i "s|android:label=\".*\"|android:label=\"$NOME_FARMACIA\"|g" android/app/src/main/AndroidManifest.xml

echo ""
echo "========================================"
echo "  Pronto! Agora execute no terminal:"
echo "  flutter clean && flutter build apk --release"
echo "========================================"

# Lyrics CarPlay

Prototype iOS 17 affichant la ligne courante de paroles dans une Live Activity susceptible d'apparaître dans CarPlay Dashboard.

## Pré-requis

- macOS, Xcode 15 ou ultérieur
- XcodeGen (`brew install xcodegen`)
- un iPhone réel pour ShazamKit et ActivityKit
- un compte Apple Developer pour signer l'application

## Lancement

1. Dans `project.yml`, remplacez `com.example` et les App Groups par vos identifiants.
2. Exécutez `xcodegen generate` dans ce dossier.
3. Ouvrez `LyricsCarPlay.xcodeproj`.
4. Sélectionnez votre équipe de signature pour les deux targets.
5. Lancez l'application et testez d'abord **Lancer la démonstration**.

## Compilation gratuite avec GitHub Actions

Le workflow `.github/workflows/ios-build.yml` génère le projet avec XcodeGen et le compile sans signature pour le simulateur iOS.

1. Créez un dépôt GitHub vide.
2. Poussez ce dossier sur la branche `main`.
3. Ouvrez l'onglet **Actions**, puis le workflow **iOS Build**.
4. Cliquez sur **Run workflow** si le workflow ne démarre pas automatiquement.
5. Téléchargez l'artefact `LyricsCarPlay-simulator` à la fin du job.

Cet artefact vérifie que le projet compile, mais ne peut pas être installé sur un iPhone. Un iPhone exige une archive signée avec un certificat et un profil Apple valides. Ne placez jamais votre mot de passe Apple directement dans les fichiers du dépôt.

## Fournisseur de paroles

`DemoLyricsProvider` ne contient que du texte fictif. Implémentez `LyricsProviding` avec un fournisseur licencié renvoyant des lignes horodatées, puis injectez-le dans `AppModel`. N'intégrez pas de clé secrète directement dans l'application : utilisez votre backend.

## Limites importantes

- Il n'existe pas d'API publique donnant la position de lecture de YouTube Music à une autre application.
- La synchronisation commence donc au moment de la reconnaissance et peut nécessiter un recalage manuel.
- CarPlay décide de l'emplacement et de la disponibilité de la Live Activity.
- L'acceptation App Store d'un affichage de paroles en conduite n'est pas garantie.
- Ce prototype ne demande pas l'entitlement d'application audio CarPlay puisqu'il ne lit pas lui-même la musique.

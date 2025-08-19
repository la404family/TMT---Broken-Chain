// Vérifie en boucle si hostageVIP est sorti du trigger zonehostage
waitUntil {
    sleep 1; // Pause d'une seconde entre chaque vérification pour éviter une surcharge
    !(hostageVIP inArea zonehostage) // Condition : l'otage n'est plus dans la zone du trigger zonehostage
};

// Joue la musique de fin "00outro"
playMusic "00outro"; // Lance la piste musicale définie dans description.ext

// Désactive les interactions des joueurs pour la cinématique
{
    _x disableAI "ALL"; // Désactive l'IA pour les unités contrôlées par l'IA
    _x enableSimulation false; // Désactive la simulation pour figer les joueurs
    _x allowDamage false; // Rend les joueurs invulnérables pendant la cinématique
} forEach [player_1, player_2, player_3, player_4, player_5];

// Crée une caméra pour suivre heliFIN
private _camera = "camera" camCreate (heliFIN modelToWorld [20, -20, 10]); // Positionne la caméra 20m à droite, 20m derrière, 10m au-dessus de heliFIN
_camera cameraEffect ["internal", "BACK"]; // Définit la caméra comme vue interne
_camera camSetTarget heliFIN; // Cible l'hélicoptère heliFIN
_camera camSetFov 0.7; // Définit un champ de vision standard pour la cinématique
_camera camCommit 0; // Applique immédiatement les paramètres de la caméra

// Fondu noir pour une transition fluide
titleCut ["", "BLACK IN", 4]; // Transition en fondu depuis le noir sur 4 secondes
sleep 5; // Attend la fin de la transition

// Vérifie la présence d'ennemis dans zoneCouvertureDrone
private _enemies = allUnits inAreaArray zoneCouvertureDrone select {side _x == east || side _x == independent}; // Liste des ennemis (OPFOR ou INDEP) dans la zone

if (count _enemies > 0) then {
    // Si des ennemis sont présents, heliFIN les attaque
    {
        private _wp = (group heliFIN) addWaypoint [getPos _x, 0]; // Crée un waypoint vers chaque ennemi
        _wp setWaypointType "SAD"; // Type "Search And Destroy" pour attaquer
        _wp setWaypointSpeed "FULL"; // Vitesse maximale
        _wp setWaypointCombatMode "RED"; // Mode de combat agressifs
    } forEach _enemies;
} else {
    // Si aucun ennemi, heliFIN fait le tour de zoneCouvertureDrone
    private _center = getPos zoneCouvertureDrone; // Centre de la zone
    private _radius = (triggerArea zoneCouvertureDrone select 0) max (triggerArea zoneCouvertureDrone select 1); // Rayon basé sur la taille du trigger
    for "_i" from 0 to 3 do { // Crée 4 waypoints pour faire un tour circulaire
        private _angle = _i * 90; // Angles pour un survol en carré
        private _wpPos = [_center select 0 + _radius * cos _angle, _center select 1 + _radius * sin _angle, 50]; // Position du waypoint à 50m d'altitude
        private _wp = (group heliFIN) addWaypoint [_wpPos, 0]; // Ajoute le waypoint
        _wp setWaypointType "MOVE"; // Type "Move" pour un déplacement simple
        _wp setWaypointSpeed "NORMAL"; // Vitesse normale pour le survol
    };
    // Ajoute un waypoint de cycle pour boucler le survol
    private _wpCycle = (group heliFIN) addWaypoint [getPos zoneCouvertureDrone, 0];
    _wpCycle setWaypointType "CYCLE";
};

// Suit l'hélicoptère avec la caméra pendant 200 secondes
private _timer = time + 200; // Définit un timer de 200 secondes
while {time < _timer} do {
    _camera camSetPos (heliFIN modelToWorld [20, -20, 10]); // Met à jour la position de la caméra pour suivre heliFIN
    _camera camCommit 0.1; // Applique les changements de position avec une transition fluide
    sleep 0.1; // Pause pour une mise à jour fluide
};

// Détruit la caméra
_camera cameraEffect ["terminate", "BACK"]; // Termine l'effet de la caméra
camDestroy _camera; // Détruit l'objet caméra

// Réactive les interactions des joueurs (par sécurité)
{
    _x enableAI "ALL"; // Réactive l'IA
    _x enableSimulation true; // Réactive la simulation
    _x allowDamage true; // Réactive les dégâts
} forEach [player_1, player_2, player_3, player_4, player_5];

// Termine la mission
["End1", true, true] call BIS_fnc_endMission; // Déclenche la fin de mission "End1" avec succès
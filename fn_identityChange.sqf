// Attribution automatique des identités 1 à 91
_identitesFrancaises = [
    "Soldier01", "Soldier02", "Soldier03", "Soldier04",
    "Soldier05", "Soldier06", "Soldier07", "Soldier08",
    "Soldier09", "Soldier10", "Soldier11", "Soldier12",
    "Soldier13", "Soldier14", "Soldier15", "Soldier16",
    "Soldier17", "Soldier18", "Soldier19", "Soldier20",
    "Soldier21", "Soldier22", "Soldier23", "Soldier24",
    "Soldier25", "Soldier26", "Soldier27", "Soldier28",
    "Soldier29", "Soldier30", "Soldier31", "Soldier32",
    "Soldier33", "Soldier34", "Soldier35", "Soldier36",
    "Soldier37", "Soldier38", "Soldier39", "Soldier40",
    "Soldier41", "Soldier42", "Soldier43", "Soldier44",
    "Soldier45", "Soldier46", "Soldier47", "Soldier48",
    "Soldier49", "Soldier50", "Soldier51", "Soldier52",
    "Soldier53", "Soldier54", "Soldier55", "Soldier56",
    "Soldier57", "Soldier58", "Soldier59", "Soldier60",
    "Soldier61", "Soldier62", "Soldier63", "Soldier64",
    "Soldier65", "Soldier66", "Soldier67", "Soldier68",
    "Soldier69", "Soldier70", "Soldier71", "Soldier72",
    "Soldier73", "Soldier74", "Soldier75", "Soldier76",
    "Soldier77", "Soldier78", "Soldier79", "Soldier80",
    "Soldier81", "Soldier82", "Soldier83", "Soldier84",
    "Soldier85", "Soldier86", "Soldier87", "Soldier88",
    "Soldier89", "Soldier90", "Soldier91"
];


// Vérification et attribution des identités
private _identitesUtilisees = []; // Tableau pour stocker les identités déjà attribuées

{
    if (!isPlayer _x && {side _x == west}) then {
        // Filtrer les identités non encore utilisées
        private _identitesDisponibles = _identitesFrancaises - _identitesUtilisees;
        
        // Si plus d'identités disponibles, réinitialiser la liste
        if (count _identitesDisponibles == 0) then {
            _identitesUtilisees = [];
            _identitesDisponibles = _identitesFrancaises;
        };
        
        // Sélectionner une identité aléatoire parmi celles disponibles
        private _identiteAleatoire = selectRandom _identitesDisponibles;
        
        // Ajouter l'identité à la liste des utilisées
        _identitesUtilisees pushBack _identiteAleatoire;
        
        // Sauvegarde de l'identité originale pour vérification
        private _originalFace = face _x;
        private _originalSpeaker = speaker _x;
        
        // Application de la nouvelle identité
        _x setIdentity _identiteAleatoire;
        
        
    };
} forEach allUnits;
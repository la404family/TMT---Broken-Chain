// Initialisation de la variable globale pour contrôler la boucle
missionNamespace setVariable ["RegroupLoopActive", false];

// Fonction pour vérifier si le joueur est le leader
fnc_isPlayerLeader = {
    player == leader group player
};

// Fonction pour ordonner aux IA de se regrouper en cercle
fnc_regroupAI = {
    if !(missionNamespace getVariable ["RegroupLoopActive", false]) exitWith {};
    
    private _playerPos = position player;
    private _aiUnits = [];
    
    // Collecter toutes les IA vivantes
    {
        if (!isPlayer _x && alive _x) then {
            _aiUnits pushBack _x;
        };
    } forEach (units group player);
    
    // Calculer les positions en cercle pour chaque IA
    private _numAI = count _aiUnits;
    private _radius = 3; // Rayon de 3 mètres
    
    if (_numAI > 0) then {
        private _angleStep = 360 / _numAI; // Angle entre chaque IA
        
        {
            private _index = _forEachIndex;
            private _angle = _angleStep * _index;
            
            // Calculer la position en cercle
            private _xOffset = _radius * cos(_angle);
            private _yOffset = _radius * sin(_angle);
            private _targetPos = [
                (_playerPos select 0) + _xOffset,
                (_playerPos select 1) + _yOffset,
                _playerPos select 2
            ];
            
            // Ordonner à l'IA de se déplacer vers sa position assignée
            _x doMove _targetPos;
            _x setUnitPos "UP"; // Assurer que l'IA est debout pour plus de réactivité
            _x groupChat format ["%1 se regroupe sur votre position, chef !", name _x];
            
            // Ajouter des compétences (optimisé)
            _x setSkill ["aimingAccuracy", 0.9];
            _x setSkill ["aimingShake", 0.7];
            _x setSkill ["aimingSpeed", 0.85];
            _x setSkill ["endurance", 0.9];
            _x setSkill ["spotDistance", 0.85];
            _x setSkill ["spotTime", 0.8];
            _x setSkill ["courage", 1.0];
            _x setSkill ["reloadSpeed", 0.8];
            _x setSkill ["commanding", 0.6];
            _x setSkill ["general", 0.8];
        } forEach _aiUnits;
    };
};

// Fonction pour démarrer la boucle de regroupement
fnc_startRegroupLoop = {
    if (missionNamespace getVariable ["RegroupLoopActive", false]) exitWith {
        hint "Le regroupement est déjà actif !";
    };
    
    if !(call fnc_isPlayerLeader) exitWith {
        hint "Vous devez être le leader pour utiliser cette commande !";
    };
    
    missionNamespace setVariable ["RegroupLoopActive", true];
    hint "Regroupement des troupes activé (2 cycles)";
    
    // Lancer la boucle dans un thread séparé
    [] spawn {
        for "_i" from 1 to 2 do {
            // Vérifier si la boucle doit continuer
            if !(missionNamespace getVariable ["RegroupLoopActive", false]) exitWith {};
            
            // Vérifier si le joueur est toujours leader
            if !(call fnc_isPlayerLeader) exitWith {
                missionNamespace setVariable ["RegroupLoopActive", false];
                hint "Regroupement arrêté : vous n'êtes plus le leader";
            };
            
            call fnc_regroupAI;
            
            // Afficher le compteur
            if (missionNamespace getVariable ["RegroupLoopActive", false]) then {
                hintSilent format ["Motivation des troupes : %1/2", _i];
            };
            
            sleep 15;
        };
        
        // Fin automatique après 2 cycles
        missionNamespace setVariable ["RegroupLoopActive", false];
        {
            if (!isPlayer _x && alive _x) then {
                _x doFollow player; // Les IA suivent le joueur après le regroupement
                _x groupChat "Regroupement terminé, on vous suit, chef !";
            };
        } forEach (units group player);
        hint "Regroupement terminé.";
    };
};

// Fonction pour arrêter la boucle
fnc_stopRegroupLoop = {
    if !(missionNamespace getVariable ["RegroupLoopActive", false]) exitWith {
        hint "Aucun regroupement en cours";
    };
    
    missionNamespace setVariable ["RegroupLoopActive", false];
    {
        if (!isPlayer _x && alive _x) then {
            _x groupChat "Ordre reçu, on arrête le regroupement.";
        };
    } forEach (units group player);
    hint "Regroupement des troupes arrêté";
};

// INITIALISATION DES ACTIONS
waitUntil {!isNull player && alive player};
sleep 1;

// Fonction pour gérer l'ajout/suppression de l'action
fnc_updateRegroupAction = {
    // Supprimer toute action existante
    player removeAction (player getVariable ["regroupActionID", -1]);
    
    // Ajouter l'action si le joueur est leader
    if (call fnc_isPlayerLeader) then {
        _actionID = player addAction [
            "<t color='#00FF00'>Motiver les troupes</t>",
            {[] call fnc_startRegroupLoop;},
            [],
            6,
            true,
            true,
            "",
            "call fnc_isPlayerLeader"
        ];
        player setVariable ["regroupActionID", _actionID];
    };
};

// Appeler la mise à jour de l'action initialement
call fnc_updateRegroupAction;

// EVENT HANDLERS
[] spawn {
    private _lastLeaderState = false;
    while {alive player} do {
        private _isLeader = call fnc_isPlayerLeader;
        
        // Mettre à jour l'action si le statut de leader change
        if (_isLeader != _lastLeaderState) then {
            call fnc_updateRegroupAction;
            _lastLeaderState = _isLeader;
            
            // Arrêter le regroupement si le joueur n'est plus leader
            if (!_isLeader && {missionNamespace getVariable ["RegroupLoopActive", false]}) then {
                missionNamespace setVariable ["RegroupLoopActive", false];
                hint "Regroupement arrêté : leadership perdu";
            };
        };
        
        sleep 5;
    };
};

// Gestion de la mort du joueur
player addEventHandler ["Killed", {
    missionNamespace setVariable ["RegroupLoopActive", false];
    // Supprimer l'action
    player removeAction (player getVariable ["regroupActionID", -1]);
}];
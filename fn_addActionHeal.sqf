// Fonction pour vérifier si le joueur est le leader
fnc_isPlayerLeader = {
    player == leader group player
};

// Fonction pour les soins de groupe
fnc_groupHeal = {
    
    private _healedCount = 0;
    {
        if (!isPlayer _x && alive _x && {damage _x > 0.1}) then {
            // Animation de soin (animation assise avec bandage)
            _x playMoveNow "AinvPknlMstpSlayWrflDnon_medic";
            
            // On attend le temps de l’animation (~4s)
            [_x] spawn {
                params ["_unit"];
                sleep 4;
                if (alive _unit) then {
                    _unit setDamage 0; // Restaure complètement la santé
                    _unit groupChat format ["%1 : Teşekkürler !", name _unit];
                };
            };
            _healedCount = _healedCount + 1;
        };
    } forEach (units group player);
    
    if (_healedCount > 0) then {
        hint format ["%1 treated themselves.", _healedCount];
    } else {
        hint "No injured units to heal.";
    };
};

// INITIALISATION DES ACTIONS
waitUntil {!isNull player && alive player};
sleep 1;

// Fonction pour gérer l'ajout/suppression de l'action
fnc_updateHealAction = {
    // Supprimer toute action existante
    player removeAction (player getVariable ["healActionID", -1]);
    
    // Ajouter l'action si le joueur est leader
    if (call fnc_isPlayerLeader) then {
        _actionID = player addAction [
            "<t color='#FF0080'>+ Healt !</t>",
            {[] call fnc_groupHeal;},
            [],
            5,
            true,
            true,
            "",
            "call fnc_isPlayerLeader"
        ];
        player setVariable ["healActionID", _actionID];
    };
};

// Appeler la mise à jour de l'action initialement
call fnc_updateHealAction;

// EVENT HANDLERS
[] spawn {
    private _lastLeaderState = false;
    while {alive player} do {
        private _isLeader = call fnc_isPlayerLeader;
        
        // Mettre à jour l'action si le statut de leader change
        if (_isLeader != _lastLeaderState) then {
            call fnc_updateHealAction;
            _lastLeaderState = _isLeader;
        };
        
        sleep 5;
    };
};

// Gestion de la mort du joueur
player addEventHandler ["Killed", {
    // Supprimer l'action
    player removeAction (player getVariable ["healActionID", -1]);
}];

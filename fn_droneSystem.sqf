
// Empêche les doublons si le script est relancé
if (missionNamespace getVariable ["droneSurveillance_Running", false]) exitWith {
    systemChat "Surveillance drone déjà active";
};
missionNamespace setVariable ["droneSurveillance_Running", true];

// Attendre 45 secondes avant de commencer la surveillance
sleep 45;

// Message de démarrage
systemChat "Bayraktar in position";
sleep 15;

// Variables pour les marqueurs de surveillance
if (isNil "droneMarkers_BLUFOR") then {
    droneMarkers_BLUFOR = [];
};
if (isNil "droneSurveillance_Active") then {
    droneSurveillance_Active = true;
};

// Fonction principale de surveillance
[] spawn {
    while {droneSurveillance_Active} do {

        droneBLUFOR flyInHeight 100;
        // Supprimer les anciens marqueurs d'ennemis
        {
            deleteMarker _x;
        } forEach droneMarkers_BLUFOR;
        droneMarkers_BLUFOR = [];
        
        // Obtenir les informations de la zone de couverture
        private _zonePos = getMarkerPos "zoneCouvertureDrone";
        private _zoneSize = getMarkerSize "zoneCouvertureDrone";
        private _zoneDir = markerDir "zoneCouvertureDrone";
        private _zoneShape = markerShape "zoneCouvertureDrone";
        
        // Chercher les ennemis dans la zone de couverture
        private _enemiesDetected = [];
        private _allUnits = allUnits select {
            alive _x && 
            side _x != west && 
            side _x != civilian &&
            side _x != sideUnknown
        };
        
        {
            private _unit = _x;
            private _unitPos = getPosATL _unit;
            
            // Vérifier si l'unité est dans la zone de couverture
            private _inZone = false;

            // si Zone rectangulaire
            if (_zoneShape == "RECTANGLE") then {
                _inZone = _unitPos inArea [_zonePos, _zoneSize select 0, _zoneSize select 1, _zoneDir, true];
            } else {
                // Zone circulaire/ellipse
                _inZone = _unitPos inArea [_zonePos, _zoneSize select 0, _zoneSize select 1, _zoneDir, false];
            };
            
            // Ajoute tous les ennemis de la zone
            if (_inZone) then {
                _enemiesDetected pushBack _unit;
            };
            
        } forEach _allUnits;
        
        // Créer les marqueurs pour les ennemis détectés
        private _enemyCount = count _enemiesDetected;
        
        if (_enemyCount > 0) then {
            systemChat format ["Bayraktar detection : %1 ", _enemyCount];
            
            {
                private _enemy = _x;
                private _markerName = format ["droneBLUFOR_contact_%1_%2", floor(time), _forEachIndex];
                // affichage d'un point rouge sur la carte pour chaque ennemi détecté
                private _marker = createMarker [_markerName, getPosATL _enemy];
                _marker setMarkerType "mil_dot";
                _marker setMarkerColor "ColorRed";
                _marker setMarkerSize [0.8, 0.8];
                _marker setMarkerAlpha 0.8;
                
                droneMarkers_BLUFOR pushBack _markerName;
                
            } forEach _enemiesDetected;
            
        } else {
            // S'il n'y a plus d'ennemis détectés, on affiche un message de fin de mission
            systemChat "The zone is clear";
            sleep 15;
            systemChat "Bayraktar returning to base";
			// supprimer le waypoint volEnAttente (ou tous les waypoints du groupe du drone)
			private _droneGroup = group droneBLUFOR;
			if (!isNil "volEnAttente") then {
				deleteWaypoint volEnAttente;
			} else {
				while {count (waypoints _droneGroup) > 0} do {
					deleteWaypoint ((waypoints _droneGroup) select ((count (waypoints _droneGroup)) - 1));
				};
			};
			// Faire conduire le drone à toute vitesse vers directionDroneFinDeMission
		droneBLUFOR doMove (getPos directionDroneFinDeMission);
		droneBLUFOR setSpeedMode "FULL";
		// Attendre que le drone soit arrivé proche de la destination
		waitUntil {droneBLUFOR distance directionDroneFinDeMission < 50};
		// Supprimer le drone
		deleteVehicle droneBLUFOR;
		// Désactiver la surveillance
		droneSurveillance_Active = false;
        };

        // Attendre 30 secondes avant la prochaine mise à jour
        sleep 30;
    };
    
    // Nettoyage final
    {
        deleteMarker _x;
    } forEach droneMarkers_BLUFOR;
    droneMarkers_BLUFOR = [];
    missionNamespace setVariable ["droneSurveillance_Running", false];
   
};

// Confirmer l'initialisation
systemChat "Bayraktar initialisation";
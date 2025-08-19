
    params [["_radius", 5, [0]]];
    
    // Liste des unités BLUFOR (joueurs et IA)
    private _bluforUnits = [player_1, player_2, player_3, player_4, player_5, vehiculeBLUFOR];
    
    // Liste des points de spawn disponibles
    private _spawnPoints = [spawn_01, spawn_02, spawn_03, spawn_04, spawn_05, spawn_06, spawn_07, spawn_08];
    
    // Filtrer les unités BLUFOR valides (existantes et vivantes)
    _bluforUnits = _bluforUnits select {
        !isNull _x && 
        alive _x && 
        side _x == BLUFOR
    };
    
    // Choisir un point de spawn aléatoire
    private _selectedSpawn = selectRandom _spawnPoints;
    
    
    private _spawnPos = getPos _selectedSpawn;
    private _unitCount = count _bluforUnits;
    
    // Calculer l'angle entre chaque unité pour former un cercle parfait
    private _angleStep = 360 / _unitCount;
    
    // Faire apparaître chaque unité en cercle
    {
        private _unit = _x;
        private _angle = _forEachIndex * _angleStep;
        
        // Calculer la position en cercle
        private _newX = (_spawnPos select 0) + (_radius * cos(_angle));
        private _newY = (_spawnPos select 1) + (_radius * sin(_angle));
        private _newZ = _spawnPos select 2;
        
        private _newPos = [_newX, _newY, _newZ];
        
        // Téléporter l'unité
        _unit setPos _newPos;
        
        // Orienter l'unité vers le centre du cercle
        private _directionToCenter = _spawnPos getDir _newPos;
        _unit setDir (_directionToCenter + 180);
        
    } forEach _bluforUnits;
    
    // Message de confirmation
    private _spawnName = vehicleVarName _selectedSpawn;
    if (_spawnName == "") then {_spawnName = "Point inconnu"};
    
    
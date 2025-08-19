[] spawn {
    // ===== CONFIGURATION =====
    private _missionTitle = "DANS LE BROUILLARD D'ALTIS";
    private _missionAuthor = "Par Kevin Du Chevreuil";
    private _missionType = "Opération d'extraction";
    private _heli = droneBLUFOR;
    private _marker = "marker_0";
    private _imagePNG = "GokturkçeTransp.png";

    // ===== INITIALISATION =====
    titleCut ["", "BLACK FADED", 999];
    showCinemaBorder true;


    // ===== EFFETS VISUELS INITIAUX =====
    private _blur = ppEffectCreate ["DynamicBlur", 500];
    _blur ppEffectEnable true;
    _blur ppEffectAdjust [3]; // Réduit l'intensité du flou pour un effet plus subtil
    _blur ppEffectCommit 0;

    // ===== AFFICHAGE DU TITRE =====
    [
        parseText format [
            "<t font='PuristaBold' size='1.8' color='#ffffff' shadow='2' shadowColor='#000000' align='center'>%1</t><br/>"
            + "<t font='PuristaLight' size='0.9' color='#a0a0a0' align='center'>%2</t><br/><br/>"
            + "<t font='PuristaMedium' size='0.7' color='#d0d0d0' align='center'>%3</t>",
            _missionTitle, _missionType, _missionAuthor
        ], 
        true, nil, 7, 0.7, 0
    ] spawn BIS_fnc_textTiles;

    // ===== TRANSITION MUSICALE =====
    sleep 5;
    playMusic "00intro";


    _blur ppEffectAdjust [0];
    _blur ppEffectCommit 5; // Allongé pour une transition plus fluide

    // ===== CINEMATIQUE HELICOPTERE =====
    private _heliPos = getPos _heli;
    private _camera = "camera" camCreate [_heliPos select 0, (_heliPos select 1) - 1, 150];
    _camera cameraEffect ["internal", "BACK"];

    // Plan 1: Vue aérienne éloignée avec effet brouillard
    private _markerPos = getMarkerPos _marker;
    _camera camSetPos [_markerPos select 0, (_markerPos select 1) - 50, 250];
    _camera camSetTarget _heli;
    _camera camSetFov 1.2; // Réduit le zoom pour un champ plus large
    _camera camCommit 0;

    titleCut ["", "BLACK IN", 4];
    sleep 5;

    // Plan 2: Mouvement orbital autour de l'hélicoptère
    _camera camSetPos [(_heliPos select 0) + 20, (_heliPos select 1) + 50, 50];
    _camera camSetTarget _heli;
    _camera camSetFov 0.7; // Ajusté pour un zoom plus dynamique
    _camera camCommit 5; // Allongé pour une transition plus fluide
    sleep 6;

    // ===== TRANSITION VERS LA ZONE OBJECTIVE =====
    // Plan 3: Vue satellite de la zone
    _camera camSetPos [_markerPos select 0, _markerPos select 1, 200];
    _camera camSetTarget _markerPos;
    _camera camSetFov 0.8;
    _camera camCommit 8;

    // Ajout de brouillard optimisé
    private _fog = ppEffectCreate ["ColorCorrections", 1501];
    _fog ppEffectEnable true;
    _fog ppEffectAdjust [1, 1.1, -0.01, [0.2, 0.2, 0.2, 0.15], [1, 1, 1, 0.9], [0.8, 0.8, 0.8, 0]]; // Ajusté pour un brouillard plus naturel
    _fog ppEffectCommit 4;
    sleep 4;

    // Plan 3.1: Vue rapprochée du marqueur
    _camera camSetPos [_markerPos select 0, (_markerPos select 1) - 50, 50];
    _camera camSetTarget _markerPos;
    _camera camSetFov 0.7;
    _camera camCommit 5;
    sleep 5;
    // Plan 3 : Vue du marqueur où se trouve l'otage (marker_0)
    private _markerPos = getMarkerPos "marker_0";
    _camera camSetPos [_markerPos select 0, (_markerPos select 1) - 50, 50];
    _camera camSetTarget _markerPos;
    _camera camSetFov 0.7;
    _camera camCommit 5;
    sleep 2;
    // Plan 4 : Vue dynamique autour du marqueur
    _camera camSetPos [(_markerPos select 0) + 20, (_markerPos select 1) + 50, 50];
    _camera camSetTarget _markerPos;
    _camera camSetFov 0.6;
    _camera camCommit 4;
    sleep 4;
    // faire un fondu vers le noir
    titleCut ["", "BLACK IN", 5];
    // Terminer la caméra
    _camera cameraEffect ["terminate", "BACK"];
    camDestroy _camera;
    sleep 10;
    // ===== FIN DE LA CINEMATIQUE =====
}
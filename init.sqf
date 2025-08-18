// Variables définies en jeu 

// hostageVIP est un civil otage dans le village
// ConducteurCamionExtractionOtage est le conducteur du camion qui va extraire l'otage
// camionExtractionOtage est le camion qui va extraire l'otage
// directionCamionExtraction est un objet vide dans le jeu qui permet de définir la direction du camion
// zoneCouvertureDrone est un marker qui permet de définir la zone de couverture du drone
// droneBLUFOR est le drone qui surveille la zone
// directionDroneFinDeMission est un objet vide dans le jeu qui permet de définir la direction du drone à la fin de la mission
// volEnAttente est un Waypoint qui permet de définir le vol en attente du drone
// heliport_01, heliport_02, heliport_03, heliport_04 sont les héliports de départ et d'arrivée de l'hélicoptère
// helimarker_01, helimarker_02, helimarker_03, helimarker_04 sont les marqueurs des héliports
// heliBLUFOR est l'hélicoptère BLUFOR
// heliBLUFORPILOT est le pilote de l'hélicoptère et le chef de groupe
// player_1, player_2, player_3, player_4, player_5, player_6, player_7, player_8, player_9, player_10 sont les joueurs
// equipeAPPUI est l'équipe du pilot heliBLUFORPILOT qui appuie les players 

// lancer les fonctions en début de mission
if (isServer) then {
    // Introduction de la mission
    //[] execVM "fn_introductionMission.sqf";
    // mettre tous les BLUFOR et le civil du jeu en voix Françaises :
    [] execVM "fn_BLUFORforcingENGLISH.sqf";
    // Mettre des noms et prénoms français aux unités BLUFOR
    [] execVM "fn_identityChange.sqf";
    // AJouter un boutton d'action pour se soigner
    [] execVM "fn_addActionHeal.sqf";
    // Ajouter un bouton d'action pour se regrouper
    [] execVM "fn_addActionRegroup.sqf";
};
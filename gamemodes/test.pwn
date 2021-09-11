//****************************Test Roleplay****************************
/*
||===============================================||
|| Nombre: Test Roleplay		                 ||
|| Programador: Lawliet                          ||
|| Mapper: 			                             ||
|| Version: 0.1                                  ||
||===============================================||
*/

#include <a_samp>
#include <streamer>
#include <sscanf2>
#include <zcmd>
#include <YSI\y_ini>

#pragma 				tabsize 					(0)

//Sistema de registro
#define 				RegisterDialog 				(1)
#define 				LoginDialog 				(2)
#define					RegisterSex					(3)
#define					RegisterAge					(4)
#define 				SuccessRegister 			(5)
#define 				SuccessLogin 				(6)

#define 				User_Path					"/Users/%s.ini"

//ID staff
#define					Usuario						(0)
#define					Ayudante					(1)
#define					Moderador					(2)
#define					Administrador				(3)
#define					Programador					(4)
#define					Dueno						(5)

//Colores
#define					COLOR_WHITE_T				"{FFFFFF}"
#define					COLOR_RED_T					"{F81414}"
#define					COLOR_GREEN_T				"{00FF22}"
#define					COLOR_BLACK					0x000000FF
#define					COLOR_WHITE					0xFFFFFFAA
#define					COLOR_YELLOW				0xE6E915FF
#define					COLOR_RED 					0xE60000FF
#define					COLOR_PURPLE				0xC2A2DAAA
#define					COLOR_GREEN					0x9EC73DAA
#define					COLOR_FADE1					0xE6E6E6E6
#define					COLOR_FADE2					0xC8C8C8C8
#define					COLOR_FADE3					0xAAAAAAAA
#define					COLOR_FADE4					0x8C8C8C8C
#define					COLOR_FADE5					0x6E6E6E6E

//Limites
#define					MAX_PING					(1500)

//Enum del sistema de registro
enum PlayerData
{
	Pass,
	Money,
	Float:Health,
	Float:Armour,
	Sex,
	Age,
	VIP,
	Admin,
	OnDuty,
	Float:PosX,
	Float:PosY,
	Float:PosZ,
	Float:PosA,
	Skin,
	VirtualW,
	Interior
};
new pInfo[MAX_PLAYERS][PlayerData];

//funcion para cargar los datos del usuario
forward LoadUser_data(playerid, name[], value[]);
public LoadUser_data(playerid, name[], value[])
{
	INI_Int("Password", pInfo[playerid][Pass]);
	INI_Int("Money", pInfo[playerid][Money]);
	INI_Float("Health", pInfo[playerid][Health]);
	INI_Float("Armour", pInfo[playerid][Armour]);
	INI_Int("Sex", pInfo[playerid][Sex]);
	INI_Int("Age", pInfo[playerid][Age]);
	INI_Int("VIP", pInfo[playerid][VIP]);
	INI_Int("Admin", pInfo[playerid][Admin]);
	INI_Int("OnDuty", pInfo[playerid][OnDuty]);
	INI_Float("PosX", pInfo[playerid][PosX]);
	INI_Float("PosY", pInfo[playerid][PosY]);
	INI_Float("PosZ", pInfo[playerid][PosZ]);
	INI_Float("PosA", pInfo[playerid][PosA]);
	INI_Int("Skin", pInfo[playerid][Skin]);
	INI_Int("VirtualW", pInfo[playerid][VirtualW]);
	INI_Int("Interior", pInfo[playerid][Interior]);

	return 1;
}

//Stock para obtener el path del usuario
stock UserPath(playerid)
{
	new string[128], playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playername, sizeof(playername));
	format(string, sizeof(string), User_Path, playername);
	return string;
}

//Stock para encriptar la contraseña
stock udb_hash(buf[])
{
	new length = strlen(buf);
    new s1 = 1;
    new s2 = 0;
    new n;
    for (n=0; n<length; n++)
    {
       s1 = (s1 + buf[n]) % 65521;
       s2 = (s2 + s1)     % 65521;
    }
    return (s2 << 16) + s1;
}

//Cuando iniciemos el server
main()
{
	print("\n----------------------------------");
	print(" Iniciando GM test de Roleplay.");
	print("----------------------------------\n");
}

//Cuando la GM es iniciada
public OnGameModeInit()
{
	SetGameModeText("Test Roleplay");
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
	ShowNameTags(0);
	SetNameTagDrawDistance(7.0);
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	SetWeather(2);
	SetWorldTime(11);
	UsePlayerPedAnims();
	
	return 1;
}

//Cuando la GM es cerrada
public OnGameModeExit()
{
	return 1;
}

//Cuando un usuario se conecta
public OnPlayerConnect(playerid)
{
	if(fexist(UserPath(playerid))) //Verificamos si el usuario existe
	{
		INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
		ShowPlayerDialog(playerid, LoginDialog, DIALOG_STYLE_INPUT, ""COLOR_WHITE_T"Iniciar sesion", ""COLOR_WHITE_T"Ingresa tu contraseNa para iniciar sesion:", "Ingresar", "Salir");
	}
	else
	{
		ShowPlayerDialog(playerid, RegisterDialog, DIALOG_STYLE_INPUT, ""COLOR_WHITE_T"Registrarse", ""COLOR_WHITE_T"Escribe una contrasena para crear tu cuenta:", "Siguiente", "Salir");
	}

	return 1;
}

//Cuando un usuario se desconecta
public OnPlayerDisconnect(playerid, reason)
{
	//Obtenemos todos los datos del usuario para posterior guardarlos en el archivo ini
	GetPlayerHealth(playerid, pInfo[playerid][Health]);
	GetPlayerArmour(playerid, pInfo[playerid][Armour]);
	pInfo[playerid][Money] = GetPlayerMoney(playerid);
	GetPlayerPos(playerid, pInfo[playerid][PosX], pInfo[playerid][PosY], pInfo[playerid][PosZ]);
	pInfo[playerid][VirtualW] = GetPlayerVirtualWorld(playerid);
	pInfo[playerid][Interior] = GetPlayerInterior(playerid);
	pInfo[playerid][Skin] = GetPlayerSkin(playerid);

	new INI:File = INI_Open(UserPath(playerid));
	INI_SetTag(File, "data");
	INI_WriteInt(File, "Money", pInfo[playerid][Money]);
	INI_WriteFloat(File, "Health", pInfo[playerid][Health]);
	INI_WriteFloat(File, "Armour", pInfo[playerid][Armour]);
	INI_WriteInt(File, "Sex", pInfo[playerid][Sex]);
	INI_WriteInt(File, "Age", pInfo[playerid][Age]);
	INI_WriteInt(File, "VIP", pInfo[playerid][VIP]);
	INI_WriteInt(File, "Admin", pInfo[playerid][Admin]);
	INI_WriteInt(File, "OnDuty", 0);
	INI_WriteFloat(File, "PosX", pInfo[playerid][PosX]);
	INI_WriteFloat(File, "PosY", pInfo[playerid][PosY]);
	INI_WriteFloat(File, "PosZ", pInfo[playerid][PosZ]);
	INI_WriteFloat(File, "PosA", pInfo[playerid][PosA]);
	INI_WriteInt(File, "Skin", pInfo[playerid][Skin]);
	INI_WriteInt(File, "VirtualW", pInfo[playerid][VirtualW]);
	INI_WriteInt(File, "Interior", pInfo[playerid][Interior]);
	INI_Close(File);

	return 1;
}

//Cada vez que se responde un Dialogo
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case RegisterDialog:
		{
			if(!response) return Kick(playerid);
			if(response)
			{
				if(!strlen(inputtext)) return ShowPlayerDialog(playerid, RegisterDialog, DIALOG_STYLE_INPUT, ""COLOR_WHITE_T"Registro",""COLOR_RED_T"Has ingresado una contrasena invalida.\n"COLOR_WHITE_T"Escribe una contrasena valida para registrarse:","Siguiente","Salir");
				new INI:File = INI_Open(UserPath(playerid));
				INI_SetTag(File, "data");
				INI_WriteInt(File, "Password", udb_hash(inputtext));
				INI_WriteInt(File, "Money", 15000);
				INI_WriteFloat(File, "Health", 100);
				INI_WriteFloat(File, "Armour", 0);
				INI_WriteInt(File, "Sex", 1);
				INI_WriteInt(File, "Age", 20);
				INI_WriteInt(File, "VIP", 0);
				INI_WriteInt(File, "Admin", 0);
				INI_WriteInt(File, "OnDuty", 0);
				INI_WriteFloat(File, "PosX", -2016.4399);
				INI_WriteFloat(File, "PosY", -79.77140);
				INI_WriteFloat(File, "PosZ", 35.3203);
				INI_WriteFloat(File, "PosA", 0);
				INI_WriteInt(File, "Skin", 60);
				INI_WriteInt(File, "VirtualW", 0);
				INI_WriteInt(File, "Interior", 0);
				INI_Close(File);

				ShowPlayerDialog(playerid, RegisterAge, DIALOG_STYLE_INPUT, ""COLOR_WHITE_T"Edad",""COLOR_WHITE_T"Ahora necesitamos que nos digas tu edad:", "Siguiente", "Cancelar");

				return 1;
			}
		}
		case LoginDialog:
		{
			if(!response) return Kick(playerid);
			if(response)
			{
				if(udb_hash(inputtext) == pInfo[playerid][Pass])
				{
					INI_ParseFile(UserPath(playerid), "LoadUser_%s", .bExtra = true, .extra = playerid);
					GivePlayerMoney(playerid, pInfo[playerid][Money]);
					SetPlayerHealth(playerid, pInfo[playerid][Health]);
					SetPlayerArmour(playerid, pInfo[playerid][Armour]);
					SetPlayerVirtualWorld(playerid, pInfo[playerid][VirtualW]);
					SetPlayerInterior(playerid, pInfo[playerid][Interior]);
					ShowPlayerDialog(playerid, SuccessLogin, DIALOG_STYLE_MSGBOX, ""COLOR_WHITE_T"Listo", ""COLOR_GREEN_T"Has iniciado sesion correctamente.", "Entendido", "");
					SetSpawnInfo(playerid, 0, pInfo[playerid][Skin], pInfo[playerid][PosX], pInfo[playerid][PosY], pInfo[playerid][PosZ], pInfo[playerid][PosA], 0, 0, 0, 0, 0, 0);
					SetPlayerSkin(playerid, pInfo[playerid][Skin]);
					SpawnPlayer(playerid);
				}
				else
				{
					ShowPlayerDialog(playerid, LoginDialog, DIALOG_STYLE_INPUT, ""COLOR_WHITE_T"Ingreso", ""COLOR_RED_T"Colocaste una contrasena incorrecta.\nEscribe tu contrasena para ingresar:", "Ingresar", "Salir");
				}

				return 1;
			}
		}
		case RegisterAge:
		{
			if(!response) return Kick(playerid);
			if(response)
			{
				if(strval(inputtext) < 15 || strval(inputtext) > 99) return ShowPlayerDialog(playerid, RegisterAge, DIALOG_STYLE_INPUT, ""COLOR_WHITE_T"Edad",""COLOR_RED_T"Ingresaste una edad no permitida, debe ser mayor que 15 y menor de 99:", "Siguiente", "Cancelar");

				pInfo[playerid][Age] = strval(inputtext);
				ShowPlayerDialog(playerid, RegisterSex, DIALOG_STYLE_MSGBOX, ""COLOR_WHITE_T"Sexo",""COLOR_WHITE_T"Ahora necesitamos que nos digas tu genero:", "Hombre", "Mujer");
				
				return 1;
			}
		}
		case RegisterSex:
		{
			if(response == 1)
			{
				pInfo[playerid][Sex] = 1;

				SetSpawnInfo(playerid, 0, 60, -2016.4399, -79.7714, 35.3203, 0, 0, 0, 0, 0, 0, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerInterior(playerid, 0);
				SetPlayerSkin(playerid, 60);
				GivePlayerMoney(playerid, 15000);
				SpawnPlayer(playerid);
			}
			else
			{
				pInfo[playerid][Sex] = 2;

				SetSpawnInfo(playerid, 0, 56, -2016.4399, -79.7714, 35.3203, 0, 0, 0, 0, 0, 0, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerInterior(playerid, 0);
				SetPlayerSkin(playerid, 56);
				GivePlayerMoney(playerid, 15000);
				SpawnPlayer(playerid);
			}

			return 1;
		}
	}

	return 1;
}

//Cada vez que el usuario escribe
public OnPlayerText(playerid, text[])
{
	new string[256];
	format(string, sizeof(string), "%s dice: %s", GetPlayerNameEx(playerid), text); //Formateamos para que aparezca en formato RP
	ProxDetector(15.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5); //Usamos el ProxDetector para mandar el mensaje en un rango especifico
}

//Cada vez que un usuario escribe un comando
public OnPlayerCommandReceived(playerid, cmdtext[])
{
  	printf("[CMD] [%s]: %s", GetPlayerNameEx(playerid), cmdtext);
  	if(strfind(cmdtext, "|", true) != -1)
	{
		SendClientMessage(playerid, COLOR_RED, "No puedes usar el caracter '|' en un comando.");
		return 0;
	}
  	return 1;
}

//Cada vez que un comando se ejecuta
public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
  	if(!success) SendClientMessage(playerid, COLOR_GREEN, "NoJodan Roleplay: {FF0000}[Error 404] {FFFFFF}El Comando que has introducido es incorrecto, use {BFFF00}/ayuda{FFFFFF}.");
	return 1;
}

//Comandos
CMD:me(playerid, params[])
{
	if(isnull(params)) return SendClientMessage(playerid, COLOR_WHITE, "Utiliza: /me (Accion)");
	new string[128];
	format(string, sizeof(string), "* %s %s.", GetPlayerNameEx(playerid), params);
	ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	return 1;
}

CMD:do(playerid, params[])
{
	if(isnull(params)) return SendClientMessage(playerid, COLOR_WHITE, "Utiliza: /do (Accion)");
	new string[128];
	format(string, sizeof(string), "* %s (( %s ))", params, GetPlayerNameEx(playerid));
	ProxDetector(30.0, playerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
	return 1;
}

CMD:e(playerid, params[])
{
	if(isnull(params)) return SendClientMessage(playerid, COLOR_WHITE, "Utiliza: /e (Entorno)");
	new string[128];
	format(string, sizeof(string), "[Entorno]: %s (( %s ))", params, GetPlayerNameEx(playerid));
	ProxDetector(30.0, playerid, string, COLOR_GREEN, COLOR_GREEN, COLOR_GREEN, COLOR_GREEN, COLOR_GREEN);
	return 1;
}

CMD:adminduty(playerid, params[])
{
	switch(pInfo[playerid][Admin])
	{
		case Usuario:
		{
			SendClientMessage(playerid, COLOR_GREEN, ""COLOR_RED_T"[ERROR] No eres miembro del staff para usar este comando.");
		}
		case Ayudante:
		{
			new string[128];
			format(string, sizeof(string), "[NoJodan] El ayudante "COLOR_WHITE_T"%s(%i) esta en servicio.", GetPlayerNameEx(playerid), playerid);
			SendClientMessageToAll(COLOR_GREEN, string);
			pInfo[playerid][OnDuty] = 1;
		}
		case Moderador:
		{
			new string[128];
			format(string, sizeof(string), "[NoJodan] El moderador "COLOR_WHITE_T"%s(%i) esta en servicio.", GetPlayerNameEx(playerid), playerid);
			SendClientMessageToAll(COLOR_GREEN, string);
			pInfo[playerid][OnDuty] = 1;
		}
		case Administrador:
		{
			new string[128];
			format(string, sizeof(string), "[NoJodan] El administrador "COLOR_WHITE_T"%s(%i) esta en servicio.", GetPlayerNameEx(playerid), playerid);
			SendClientMessageToAll(COLOR_GREEN, string);
			pInfo[playerid][OnDuty] = 1;
		}
		case Programador:
		{
			new string[128];
			format(string, sizeof(string), "[NoJodan] El programador "COLOR_WHITE_T"%s(%i) esta en servicio.", GetPlayerNameEx(playerid), playerid);
			SendClientMessageToAll(COLOR_GREEN, string);
			pInfo[playerid][OnDuty] = 1;
		}
		case Dueno:
		{
			new string[128];
			format(string, sizeof(string), "[NoJodan] El dueno "COLOR_WHITE_T"%s(%i) esta en servicio.", GetPlayerNameEx(playerid), playerid);
			SendClientMessageToAll(COLOR_GREEN, string);
			pInfo[playerid][OnDuty] = 1;
		}
	}
	return 1;
}

CMD:adminoffduty(playerid, params[])
{
	if(pInfo[playerid][OnDuty] == 1)
	{
		switch(pInfo[playerid][Admin])
		{
			case Usuario:
			{
				SendClientMessage(playerid, COLOR_GREEN, ""COLOR_RED_T"[ERROR] No eres miembro del staff para usar este comando.");
			}
			case Ayudante:
			{
				new string[128];
				format(string, sizeof(string), "[NoJodan] El ayudante "COLOR_WHITE_T"%s(%i) esta fuera de servicio.", GetPlayerNameEx(playerid), playerid);
				SendClientMessageToAll(COLOR_GREEN, string);
				pInfo[playerid][OnDuty] = 0;
			}
			case Moderador:
			{
				new string[128];
				format(string, sizeof(string), "[NoJodan] El moderador "COLOR_WHITE_T"%s(%i) esta fuera de servicio.", GetPlayerNameEx(playerid), playerid);
				SendClientMessageToAll(COLOR_GREEN, string);
				pInfo[playerid][OnDuty] = 0;
			}
			case Administrador:
			{
				new string[128];
				format(string, sizeof(string), "[NoJodan] El administrador "COLOR_WHITE_T"%s(%i) esta fuera de servicio.", GetPlayerNameEx(playerid), playerid);
				SendClientMessageToAll(COLOR_GREEN, string);
				pInfo[playerid][OnDuty] = 0;
			}
			case Programador:
			{
				new string[128];
				format(string, sizeof(string), "[NoJodan] El programador "COLOR_WHITE_T"%s(%i) esta fuera de servicio.", GetPlayerNameEx(playerid), playerid);
				SendClientMessageToAll(COLOR_GREEN, string);
				pInfo[playerid][OnDuty] = 0;
			}
			case Dueno:
			{
				new string[128];
				format(string, sizeof(string), "[NoJodan] El dueno "COLOR_WHITE_T"%s(%i) esta fuera de servicio.", GetPlayerNameEx(playerid), playerid);
				SendClientMessageToAll(COLOR_GREEN, string);
				pInfo[playerid][OnDuty] = 0;
			}
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_GREEN, ""COLOR_RED_T"No estas en modo administrativo o no puedes usar este comando.");
	}
	return 1;
}

//Funciones
forward ProxDetector(Float:radi, playerid, str[], col1, col2, col3, col4, col5);
public ProxDetector(Float:radi, playerid, str[], col1, col2, col3, col4, col5)
{
    if(IsPlayerConnected(playerid))
    {
        new Float:posx, Float:posy, Float:posz;
        new Float:oldposx, Float:oldposy, Float:oldposz;
        new Float:tempposx, Float:tempposy, Float:tempposz;
        GetPlayerPos(playerid, oldposx, oldposy, oldposz);
        for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i))
            {

                GetPlayerPos(i, posx, posy, posz);
                tempposx = (oldposx -posx);
                tempposy = (oldposy -posy);
                tempposz = (oldposz -posz);
				if(GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid))
				{
					if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
					{
						SendClientMessage(i, col1, str);
					}
					else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
					{
						SendClientMessage(i, col2, str);
					}
					else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
					{
						SendClientMessage(i, col3, str);
					}
					else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
					{
						SendClientMessage(i, col4, str);
					}
					else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
					{
						SendClientMessage(i, col5, str);
					}
				}
            }
        }
    }
    return 1;
}

GetPlayerNameEx(playerid)
{
	new sz_playerName[MAX_PLAYER_NAME], i_pos;
	GetPlayerName(playerid, sz_playerName, MAX_PLAYER_NAME);
	while ((i_pos = strfind(sz_playerName, "_", false, i_pos)) != -1) sz_playerName[i_pos] = ' ';
	return sz_playerName;
}

//****************************Test Roleplay****************************
/*
||===============================================||
|| Nombre: Test Roleplay		                 ||
|| Programador: Lawliet                          ||
|| Mapper: 			                             ||
|| Version: 0.1                                  ||
||===============================================||
*/

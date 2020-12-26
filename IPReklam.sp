#include <sourcemod>
#include <store>
#pragma tabsize 0

ConVar ip_kredi_miktar = null, ip_kredi_sure = null, ip_kredi_domain = null;

char NetIP[32], domain[32];

public Plugin myinfo = 
{
	name = "Ip Hediye",
	author = "Emur",
	description = "",
	version = "1.0",
};

public void OnPluginStart()
{
	CreateDirectory("cfg/PluginMerkezi", 3);
	ip_kredi_miktar = CreateConVar("ip_kredi_miktar", "10", "Verilecek kredi miktarı kaç olsun?");
	ip_kredi_sure = CreateConVar("ip_kredi_sure", "300", "Kaç saniyede bir kredi verilsin?");
	ip_kredi_domain = CreateConVar("ip_kredi_domain", "", "Varsa ekstra olarak domain adresinizi ekleyebilirsiniz.");
	AutoExecConfig(true, "ipkredi", "");
	
	CreateTimer(ip_kredi_sure.FloatValue, sayac, _, TIMER_REPEAT);
	
	int pieces[4];
	int longip = GetConVarInt(FindConVar("hostip"));
	
	pieces[0] = (longip >> 24) & 0x000000FF;
	pieces[1] = (longip >> 16) & 0x000000FF;
	pieces[2] = (longip >> 8) & 0x000000FF;
	pieces[3] = longip & 0x000000FF;

	Format(NetIP, sizeof(NetIP), "%d.%d.%d.%d", pieces[0], pieces[1], pieces[2], pieces[3]);
}

public void OnConfigsExecuted()
{
	GetConVarString(ip_kredi_domain, domain, sizeof(domain));
}

public Action sayac(Handle timer)
{
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) && !IsFakeClient(i))
		{
			char name[32];
			GetClientName(i, name, sizeof(name))
			if(StrContains(name, domain) != -1 || StrContains(name, NetIP) != -1)
			{
				Store_SetClientCredits(i, Store_GetClientCredits(i) + ip_kredi_miktar.IntValue);
				PrintToChat(i, "[SM] \x01Sunucu IP Adresini nickinize eklediğiniz için \x0B%d \x01kredi kazandınız.",ip_kredi_miktar.IntValue);
		    }
		    else
		    	PrintToChat(i, "[SM] \x01Sunucu IP Adresini nickinize ekleyerek \0Bx%d \x01dakikada \0Bx%d \x01kredi kazanabilirsiniz.", ip_kredi_sure.IntValue / 60, ip_kredi_miktar.IntValue);		    
	    }
    
   	}
    return Plugin_Continue;
}

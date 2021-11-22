[Setting category="Display Settings" name="Window position"]
vec2 anchor = vec2(0, 170);

const string HAMIRALL = "8A_HS-7nTtGmrdNpux3G3Q";
const string FLOW = "e-HCdWhhRiuwW60snv0AOw";
const string AYUIDO = "sL8raW_HRFGNqHowubnU7A";
const string WHITEWIX = "MCcmuCpARf2PbEJjWc5qdQ";
const string DANTAFASS = "K0CkvsQuRoKZgDHFTJxU1w";
const string MERY = "qiylvw99SJOeNmjnvnue9g";
const string XICUB = "wA4cueYFQ32ftBzGJfC1Kw";

array<string> listPlayersToDisplay = {
    FLOW,
    HAMIRALL,
    AYUIDO,
    WHITEWIX,
    DANTAFASS,
    MERY,
    XICUB,
};

void Main() {}

void Render()
{
    CTrackMania@ app = cast<CTrackMania>(GetApp());
    auto network =  app.Network;
    CGamePlayerInfo@ localPlayerInfo = cast<CTrackManiaNetwork>(app.Network).PlayerInfo;
    auto serverInfo =  network.ServerInfo;

    CTrackManiaPlayerInfo@[] playersToDisplay = sortTeamArray(network.PlayerInfos, localPlayerInfo);

    if (serverInfo.ServerHostName != "") {
        UI::SetNextWindowPos(int(anchor.x), int(anchor.y), UI::Cond::Always);
        int windowFlags = UI::WindowFlags::NoTitleBar | UI::WindowFlags::NoCollapse | UI::WindowFlags::AlwaysAutoResize | UI::WindowFlags::NoDocking;

        UI::Begin("Spec widgets", windowFlags);

        if (playersToDisplay.Length > 0) {
            for (uint i = 0; i < playersToDisplay.Length; i++) {
                CTrackManiaPlayerInfo@ playerInfo = playersToDisplay[i];

                string displayPlayer = "P" + playerInfo.LiveUpdate_Counter + " - [LDG] " + playerInfo.Name;

                if (UI::Button(displayPlayer)) {
                    network.PlaygroundClientScriptAPI.SetSpectateTarget(playerInfo.Login);            
                }

            }
        } else {
            UI::Text("No players found ", -1); 
        }

        UI::End();
    }
}

array<CTrackManiaPlayerInfo@> sortTeamArray(MwSArray<CGameNetPlayerInfo@> listPlayer, CGamePlayerInfo@ localPlayer) {
    CTrackManiaPlayerInfo@[] teamPlayers;

    for (uint i = 0; i < listPlayer.Length; i++) {
        auto playerInfo = cast<CTrackManiaPlayerInfo>(listPlayer[i]);

        if (playerInfo == null) {
            break;
        }

        if (listPlayersToDisplay.Find(playerInfo.Login) != -1 && localPlayer.Login != playerInfo.Login) {
            teamPlayers.InsertLast(playerInfo);
        }
    }

    return teamPlayers;
}

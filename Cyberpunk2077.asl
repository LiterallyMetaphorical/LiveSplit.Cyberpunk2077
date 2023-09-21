/*Cyberpunk 2077 Load Remover and Auto Splitter
Written by Meta and Radioactive03.
Shoutout to Kuno for bein a lad and helping out with splitting logic*/
//Thanks to Drek and Moowell for being my guinea pigs during the testing phase, and dealing with the janky splitting of early builds xD
//Thanks to nicnacnic for finding the 1.12 objective pointer, very epic

/*
Scanning Best Practices:

loading

search for 70 in game, changed value in loading. Look for address starting with 3 increasing over each update. Ie started at 3B now we're up to 3F.

objective

before scanning for this, make sure to load up in any save first to initialize the pointer

generic_sts_objective (at the end of load screen when starting new game)
01_meet_your_fixer (after you take the shot) || 1834955056
02_talk_to_kirk 1952395824
03_sit_down 1935618864
05_leave_coyote 1818178864
*/

state ("Cyberpunk","2,0")
{
	string50 objective : 0x046B6A20, 0xB8, 0x120;
}
state("Cyberpunk2077","1.63")
{
	string50 objective : 0x04C913B0, 0xB8, 0x118, 0x0;
}
state("Cyberpunk2077","1.61")
{
	string50 objective : 0x04C42170, 0xB8, 0x118, 0x0;
}

state("Cyberpunk2077","1.52")
{
	string50 objective : 0x04B6F878, 0xB8, 0x118, 0x0;
}

state("Cyberpunk2077","1.31")
{
	string50 objective : 0x04B73B30, 0x158, 0x118, 0x0;
}

state("Cyberpunk2077","1.23")
{
	string50 objective : 0x049F56F0, 0xB8, 0x118, 0x0;
}

state("Cyberpunk2077","1.2")
{
	string50 objective : 0x49E1170, 0xB8, 0x118, 0x0;
}

state("Cyberpunk2077","1.12")
{
	string50 objective : 0x048E30F8, 0x40, 0x18, 0xE30, 0x8, 0xB8, 0x118, 0x0;
}

state("Cyberpunk2077","1.11")
{
	string50 objective : 0x04320A50, 0x260, 0x28, 0x8, 0x38, 0xB8, 0x118, 0x0;
}

state("Cyberpunk2077", "1.1")
{
    string50 objective : 0x04320A50, 0x260, 0x28, 0x8, 0x38, 0xB8, 0x118, 0x0;
}


startup
  {
	    vars.TimerStart = (EventHandler) ((s, e) => timer.IsGameTimePaused = true);
        timer.OnStart += vars.TimerStart;
	  	refreshRate=30;
		if (timer.CurrentTimingMethod == TimingMethod.RealTime)
// Asks user to change to game time if LiveSplit is currently set to Real Time.
    {        
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | Cyberpunk 2077",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );
        
        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
// Creates a text component at the bottom of the users LiveSplit layout displaying the current objective/quest state
		vars.SetTextComponent = (Action<string, string>)((id, text) =>
    {
        var textSettings = timer.Layout.Components.Where(x => x.GetType().Name == "TextComponent").Select(x => x.GetType().GetProperty("Settings").GetValue(x, null));
        var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == id);
        if (textSetting == null)
        {
        var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
        var textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
        timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));

        textSetting = textComponent.GetType().GetProperty("Settings", BindingFlags.Instance | BindingFlags.Public).GetValue(textComponent, null);
        textSetting.GetType().GetProperty("Text1").SetValue(textSetting, id);
        }

        if (textSetting != null)
        textSetting.GetType().GetProperty("Text2").SetValue(textSetting, text);
    });
// Declares the name of the text component
    settings.Add("quest_state", true, "Current Objective");

// Dictionary containing all of the available objectives/quest states that can be split on	
	vars.objectivename = new Dictionary<string,string>
	{
		{"08_drive_downtown","Meet Padre // Entered Padre's Car"}, //moves from Meet Padre - Meet Jackie
		{"01_talk_to_jackie","Meet Jackie & Drones Killed (2 Splits) // Start of the 6 Months Later Cutscene, AND killed the drones during The Heist."}, // moves from Meet Jackie - The Rescue
		{"goto_elevator1","The Rescue // End of The Rescue just after Trauma Team."}, //moves from The Rescue - Prologue
		{"05_go_to_vroom","Prologue // End of Prologue when V is running to their apartment to sleep."}, //moves from Prologue - Dupe n Elevator Skip
		{"summon_car","Dupe & Elevator Skip (1 Split) // Summon the car after Elevator Skip and Duping."}, //moves from Dupe - The Ripperdoc
		{"ask_jackie","The Ripperdoc // Finished appointment with Vik during The Ripperdoc."}, //moves from The Ripperdoc - To Dex's Car
		{"ride_with_dex","To Dex's Car // Entered Dexs car"}, // moves from To Dex's Car - All Foods
		{"03_escape_allfoods","All Foods // After grabbing the flathead"}, // moves from All Foods - BD Tut 1
		{"talk_judy_and_evelyn","Brain Dance Tut 1 // End of Robbery Brain Dance"}, // moves from BD Tut 1 - BD Tut 2
		{"sum_up","Brain Dance Tut 2 // End of Konpeki Plaza Brain Dance"}, //moves from BD Tut 2 - The Information
		{"enter_meeting_capsule","The Information // Just before entering the meeting room with Dex and TBug in the Afterlife"}, // Moves from The Information - Excelsior Package
		{"wait_for_jackie_trunk","Excelsior Package // Get out of Delemain at Konpeki Plaza"},// moves from Excelsior Package - Flathead
		{"open_grate_sec_room","Flathead // Let the Flathead into the netrunner room"}, // Moves from Flathead - Saboru Ara-fucking-saka
		{"01c_jump","Saburo Ara-Fucking-Saka // Jump out of the penthouse"}, // moves from Saboru Ara-Fucking-Saka - Escape Arasaka
		{"07_get_to_delamain","Escape Arasaka // Enter Delemain"}, // moves from Escape Arasaka - Drones Killed
		// 01_talk_to_jackie is called at this point to move Drones Killed - BOMB HAS BEEN PLANTED
		{"shoot_cables","BOMB HAS BEEN PLANTED // Just shot the elevator cables in Love Like Fire"}, // moves BOMB HAS BEEN PLANTED - Love Like Fire
		{"dig","Love Like Fire // Dig through the rubble in the dump"}, // moves Love Like Fire - Here's Johnny
		{"prepare_before_leave","Here's Johnny // Get out of the shower after Johnny appears in your apt"}, // moves Here's Johnny - Takemura Diner
		{"holocall_judy","Takemura Diner // Exited Takemura's Diner"}, // moves Takemura Diner - Lizzie's Bar 2
		{"leave_lizzies","Lizzie's Bar 2 // Finish talking with Judy in Lizzie's Bar "}, // moves from Lizzies Bar 2 - Clouds
		{"take_weapons","Clouds // Take Weapons when you're done at Clouds"}, // Moves from Clouds - Fingers
		{"meet_fingers","Fingers // Enter Fingers building. Warning, if you enter and exit this multiple times it will split multiple times."}, // Moves from Fingers - Illegal BD's
		{"02_meet_judy_at_van","Illegal BD's // XBD bought.. or stolen"}, // Moves from Illegal BD's - Pizza Box Brain Dance
		{"talk_judy2","Pizza Box Brain Dance // After watching the Illegal BD in Judy's van"}, // Moves from Pizza Box Brain Dance - Rescue Evelyn
		{"17_leave","Rescue Evelyn // Just after picking up Evelyn in the compound"}, // Moves from Rescue Evelyn - Judy's Apartment
		{"01_call_fixer","Judy's Apartment // Left Judy's apartment and quest ended"}, // Moves from Judy's Apartment - Oda Meeting
		{"00c_03_talk_wakako","Oda Meeting // Started talking to Wakako after meeting with Oda & Takemura"}, // Moves from Oda Meeting - Afterlife
		{"go_to_panam","Afterlife // Finished talking to Rogue in the Afterlife"}, // Moves from Afterlife - Helping Panam
		{"ride_camp","Helping Panam // Entered Panams car, on the way to Nomad Camp"}, // Moves from Helping Panam - Car Ride
		{"talk_scorp_mitch","Car Ride // Started conversation w/ Scorpion and Mitch"}, // Moves from Car Ride - Grab n Go
		{"ride_to_ghost_town","Grab n Go // After grabbing Panams stuff from the Nomad camp"}, // Moves from Grab n Go - Ambush Setup
		{"wait_raffen","Ambush Setup // Time wait until the convoy comes through"}, // Moves from Ambush Setup - Panam's Truck
		{"rendezvous_gt_north1","Panam's Truck // Entered Panams truck"}, // Moves from Panam's Truck - Lightning Breaks Startup
		{"calibrate_turret","Lightning Breaks Startup // Enter the turret calibration sequence"}, // Moves from Lightning Breaks Startup - Turret Calibration
		{"plant_security","Turret Calibration // Started the drone shooting sequence during Lightning Breaks"}, // Moves from Turret Calibration - Crash Landing
		{"deal_av_turret","Crash Landing // Starting Mitch Skip"}, // Moves from Crash Landing - Mitch Skip
		{"reach_gas_station","Mitch Skip // You just reached the gas station after Mitch Skip"}, // Moves from Mitch Skip - Gas Station
		{"talk_with_courier","Gas Station // You finished at the gas station"}, // Moves from Gas Station - Start Map T'ann Pelen
		{"01b_wait_till_chapel_open","Start Map T'ann Pelen // Finished Takemura Meeting, starting Ma'p Tenn Pelen"}, // Moves from Start Map T'ann Pelen - Meet With Placide
		{"01_exit_the_hotel","Meet With Placide // Just finished the meeting with Placide"}, // Moves from Meet With Placide - GIM Skip
		{"05c_talk_to_netrunner","GIM Skip // Reach the Netwatch Agent"}, // Moves from GIM Skip - Meet Brigitte
		{"05b_talk_to_queen","Meet Brigitte // Enter Cyberspace with Brigitte"}, // Moves from Meet Brigitte - Meet Alt
		{"01_talk_with_ripper","Meet Alt // Finish at the Ripperdoc during Never Fade Away"}, // Moves from Meet Alt - Kill Arasaka
		{"05c_pick_parking","Kill Arasaka 1 // Killed all Arasaka enemies in Atlantis"}, // Moves from Kill Arasaka - Escape Atlantis
		{"02_escape_atlantis","Escape Atlantis // Enter Johnnys Porsche"}, // Moves from Escape Atlantis - Never Fade Away
		{"04_check_on_alt","Never Fade Away // Finish killing the Arasaka enemies in the room with Alt"}, // Moves from Never Fade Away - Transmission
		{"02b_leave_the_chapel","Transmission // Completed Transmission"}, // Moves Transmission - Arasaka Industrial Park
		{"04h_leave","Arasaka Industrial Park // Escaped Arasaka Industrial Park"}, // Moves from Arasaka Industrial Park - Takemura is Charging His Phone
		{"05a_go_parade","Takemura is charging his phone // Takemura finally fucking called you, time for the parade bitches"}, // Moves from Takemura is Charging His Phone - Let's Start the Parade
		{"05c_kill_snipers","Let's Start the Parade // Parade start"}, // Moves from Let's Start the Parade - To Oda
		{"05f_fight_cyberninja","To Oda // Started the Oda Fight"}, // Moves To Oda - Oda Fight
		{"05k_flee","Oda Fight // GTFO of the parade"}, // Moves Oda Fight - Takemura Hideout
		{"07a_guard_door","Takemura Hideout // Escaped, motel cutscene starts"}, // Moves Takemura Hideout - Meet Hanako at Embers
		{"05_leave_restaurant","Meet Hanako at Embers // Reach Hanako at the top of Embers"}, // Moves Meet Hanako at Embers - The Worst Ending
		// Manual split for The Worst Ending
	};
	
// split on specified objectives
	settings.Add("Quest States", true);
// Add objectives to setting list
	foreach (var script in vars.objectivename) {
		settings.Add(script.Key, true, script.Value, "Quest States");
	}
}

init
{
	version = modules.First().FileVersionInfo.ProductVersion;
	vars.loading = false;
	
	var module = modules.First();
	var scanner = new SignatureScanner(game, module.BaseAddress, module.ModuleMemorySize);
	vars.LoadingPtr = scanner.Scan(new SigScanTarget(2, "89??????????C6????????????E8????????4584??4889") { 
	OnFound = (process, scanners, addr) => addr + 0x4 + process.ReadValue<int>(addr)
	});
	if(version == "2.0")
	{
		vars.LoadingPtr = scanner.Scan(new SigScanTarget(2, "89??????????F0????????????????48FF??33??4889??????????E8????????4584") { 
		OnFound = (process, scanners, addr) => addr + 0x4 + process.ReadValue<int>(addr)
		});
	}

	
	if (vars.LoadingPtr == IntPtr.Zero)
	{
        	throw new Exception("Game engine not initialized - retrying");
	}
	
	vars.loadingWatcher = new MemoryWatcher<int>(vars.LoadingPtr);
}




update
{
	vars.loadingWatcher.Update(game);
	if (settings["quest_state"]) 
    {
      vars.SetTextComponent("Current Objective", (current.objective)); 
    }
	vars.loading = vars.loadingWatcher.Current == 10;
}

start
{
	//Start the timer when the first objective of the game is detected
    return (current.objective == "generic_sts_objective" && current.objective != old.objective);
}


split
{
	return current.objective != old.objective && old.objective != null && settings[current.objective];
}
	
/*checks for the following
that the current objective isn't the same as the old objective
that the current objective isn't after a null quest state, since this happens when you die. THIS DOESN'T WORK AND IDK WHY
^ In previous iterations, dying would re-call the quest state and cause an additional split
that the current objective is held within the dictionary (see Startup method)*/

exit
{
	timer.IsGameTimePaused = true;
}

isLoading
{	
	return vars.loading;
}

shutdown
{
    timer.OnStart -= vars.TimerStart;
}

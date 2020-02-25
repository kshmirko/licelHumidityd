import std.stdio;

import licelformat;


void main()
{
    //LicelFile f = new LicelFile("b2021019.223500");
	//LicelProfile lp = new LicelProfile(" 1 0 1 16380 1 0000 7.50 00355.o 0 0 00 000 12 000069 0.500 BT0");
	//EDatasetType dt=EDatasetType.dtAnalog;
	//f.m_Profiles["1"] = new LicelProfile();
	//writeln(lp.isActive, ' ', lp.dsType, ' ', lp.laserPolstate, ' ', lp.scatPolStatus, ' ', lp.wavelength, ' ', lp.deviceID);
	//writeln(dt);
	
	//dt=cast(EDatasetType)(2);
	LicelPack data = LoadPackage(["b2021019.223500", "b2021019.241690"]);
	writeln(data);
	//writeln(data["b2021019.223500"].Profiles[1].data);
	
}

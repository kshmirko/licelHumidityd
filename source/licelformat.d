module licelformat;
import std.datetime.date;
import std.array;
import std.uni : isWhite;
import std.conv;
import std.stdio;


enum EDatasetType {
	dtAnalog=0,
	dtPhoton,
	dtAnalogSquared,
	dtPhotonSquared 
}

enum EPolarizationStatus{
	psNone=0,
	psVertical,
	psHorizontal,
	psRightCircular,
	psLeftCircular		
}

enum EPolarizationScattStatus:char{
	psNone='o',
	psParallel='p',
	psCross='s',
	psRightCircular='r',
	psLeftCircular='l'		
}


class LicelProfile {
	
	@property bool isActive() {return m_isActive;}
	@property EDatasetType dsType(){return m_datsetType;}
	@property bool isPhoton() {return m_datsetType==EDatasetType.dtPhoton;}
	@property int nDataPoints(){return m_nDataPoints;}
	@property EPolarizationStatus laserPolstate(){return m_laserPolstate;}
	@property double wavelength(){return m_wavelength;}
	@property EPolarizationScattStatus scatPolStatus(){return m_scatPolStatus;}
	@property int nShots(){return m_nShots;}
	@property double discrLevel(){return m_discrLevel;}
	@property int deviceID(){return m_deviceID;}
	
	this(string dataline){
		parseLine(dataline);
	}
	
private:
	void parseLine(string dataline){
		auto items=dataline.split();
		writeln(items);
		m_isActive = cast(bool)(parse!int(items[0]));
		m_datsetType = cast(EDatasetType)(parse!int(items[1]));
		m_nlaser = parse!int(items[2]);
		m_nDataPoints = parse!int(items[3]);
		m_laserPolstate=cast(EPolarizationStatus)parse!int(items[4]);
		m_highVoltage=parse!double(items[5]);
		m_binWidth=parse!double(items[6]);
		auto tmp=items[7].split(".");
		m_wavelength=parse!double(tmp[0]);
		m_scatPolStatus=cast(EPolarizationScattStatus)(tmp[1][0]);
		m_binShift = parse!int(items[10]);
		m_decBinShift = parse!int(items[11]);
		m_adcBits = parse!int(items[12]);
		m_nShots=parse!int(items[13]);
		m_discrLevel = parse!double(items[14]);
		m_deviceID = cast(int)(items[15][2]-'0');
	}
	
private:
	bool m_isActive;
	EDatasetType m_datsetType;
	int m_nlaser;
	int m_nDataPoints;
	EPolarizationStatus m_laserPolstate;
	double m_highVoltage;
	double m_binWidth, m_wavelength;
	EPolarizationScattStatus m_scatPolStatus;
	int m_binShift, m_decBinShift;
	int m_adcBits;
	int m_nShots;
	double m_discrLevel;
	int m_deviceID;
	uint [] m_data;
	
}

class LicelFile{
	
	this(string fname){
		
	}
	
private:
	string m_fname;
	string m_measurementSite;
	DateTime m_measurementStartTime, m_measurementStopTime;
	double m_altitudeAboveSeaLevel, m_longitude, m_latitude, 
		m_zenith, m_azimuth;
	int m_nLaser1Shots, m_Laser1Freq, m_nLaser2Shots, m_Laser2Freq, m_nDatasets,
		m_nLaser3Shots, m_Laser3Freq;
		
	LicelProfile[string] m_Profiles;
}
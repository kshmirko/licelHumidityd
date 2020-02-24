module licelformat;
import std.datetime.date;

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


class LicelProfile {
	
	@property bool isActive() {return m_isActive;}
	@property EDatasetType dsType(){return m_datsetType;}
	@property bool isPhoton() {return m_datsetType==EDatasetType.dtPhoton;}
	
private:
	bool m_isActive;
	EDatasetType m_datsetType;
	int m_nlaser;
	int m_nDataPoints;
	EPolarizationStatus m_laserPolstate;
	double m_highVoltage;
	double m_binWidth, m_wavelengths;
	EPolarizationStatus m_polStatus;
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